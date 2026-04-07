---
title: "A Solução de Upload Nativa do Rails 5.2: ActiveStorage"
date: '2017-07-07T14:40:00-03:00'
slug: a-solucao-de-upload-nativa-do-rails-5-2-activestorage
translationKey: upcoming-activestorage
aliases:
- /2017/07/07/upcoming-built-in-upload-solution-for-rails-5-2-activestorage/
tags:
- heroku
- uploads
- carrierwave
- cloudfront
- cloudinary
- cdn
- activestorage
- traduzido
draft: false
---

**Atualização 07/11/2017**: Logo depois do nosso brainstorm no Twitter, DHH e @gauravtiwari se mobilizaram e iniciaram um [novo branch](https://github.com/rails/activestorage/pull/35) para adicionar suporte a Direct Upload para a nuvem imediatamente. Claro, ainda é trabalho em andamento, mas vai ser ótimo ter esse suporte nativo.

**Atualização 07/20/2017:** Preciso esclarecer alguns pontos. Primeiro, estou recomendando a solução proprietária do Cloudinary, mas há ressalvas. Você está trocando facilidade de uso por vendor lock-in. E só recomendo para fotos e imagens. Se precisar fazer upload de arquivos gigantes (vídeos, ou binários arbitrários como tarballs pesados), você precisa pesquisar mais e talvez construir uma solução customizada com Shrine ou similar. Outro ponto que faço é que se você usa Heroku, sua única opção é Direct Upload para serviços de nuvem como o AWS S3. Já entreguei vários apps que bateram no [H12 Routing Timeout](https://devcenter.heroku.com/articles/request-timeout#uploading-large-files) — está na documentação oficial. Mas há pouco deployei um Rails 5.1 simples com Carrierwave padrão e um formulário HTML multipart. Consegui fazer upload de um vídeo de mais de 2GB e ele passou pela camada de roteamento do Heroku. Parece que o roteador absorve o arquivo, deixa o upload terminar e só então passa para a aplicação Rails. Agora, se você bloqueia a requisição (por exemplo, fazendo upload do Rails para o S3 ou qualquer operação demorada), a camada de roteamento vai dar H12/timeout após 30 segundos. Então, se você permitir uploads de arquivos grandes, vai acabar tendo desconexões aleatórias. Mesmo que você consiga receber o arquivo, não pode mantê-lo no sistema de arquivos (que é volátil num Dyno do Heroku), então ainda precisa enviá-lo para algum lugar — e essa é a parte que pode dar timeout. Portanto, o Direct Upload continua sendo a abordagem correta no Heroku.

O DHH acabou de anunciar uma funcionalidade nova para o Rails 5.2 que está por vir. É o [ActiveStorage](https://github.com/rails/activestorage).

Ele deve se tornar a solução padrão para suporte a uploads de arquivos, basicamente substituindo o Paperclip, o Carrierwave, e algumas funcionalidades do Dragonfly e do Shrine (que fazem bem mais do que isso).

Escrevo este post não para apresentar a solução, mas para esclarecer algumas críticas que fiz no Twitter. Acontece que o Twitter é uma plataforma péssima para discussões mais aprofundadas, daí este texto.

A thread original no Twitter pode ser encontrada [aqui](https://twitter.com/AkitaOnRails/status/882998977754537984).

O processo tem pelo menos 3 pontos importantes a considerar:

1. O upload do arquivo, do usuário final até o seu controller Rails.
2. Uma etapa opcional de transformação (que você deveria fazer, para redimensionar imagens e servi-las para diferentes dispositivos e resoluções de tela).
3. Servir o blob do arquivo de volta ao usuário final como uma URL de imagem, por exemplo.

### A Etapa de Upload

A maioria das soluções simples de upload — como o ActiveStorage e as antigas como o Paperclip original e o Carrierwave numa instalação padrão — basicamente configuram o formulário HTML como multipart e adicionam um campo de arquivo HTML simples. Isso vai enviar o formulário diretamente para uma action do controller Rails, que receberá o arquivo no hash `params` e você pode lidar com o blob binário a partir daí.

Numa implantação ingênua, isso vai **bloquear** o MRI durante todo o upload. Se o arquivo for muito grande, pode bloquear qualquer outra requisição entrante pela duração desse upload. (Tecnicamente, como o Rails suporta threads MRI e threads MRI são teoricamente não-bloqueantes para operações de IO, não deveria ser tão grave quanto parece.)

Felizmente, acredito que ninguém em sã consciência expõe um processo MRI diretamente para a internet. Normalmente ficamos atrás de um [proxy reverso](https://www.digitalocean.com/community/tutorials/how-to-deploy-a-rails-app-with-puma-and-nginx-on-ubuntu-14-04), como Haproxy, NGINX, Apache HTTPD ou algo similar.

E geralmente esses proxies reversos são os que recebem o upload e só fazem proxy da requisição quando o upload está concluído. Assim, a aplicação MRI/Rails pode continuar respondendo às outras requisições enquanto isso.

Então, se você tem uma infraestrutura customizada, está bem.

Se você usa algo como Heroku, está basicamente ferrado. A camada de roteamento do Heroku tem um timeout fixo de 30 segundos. Acho isso uma coisa boa, porque você não deveria ter requisições que demoram tanto para processar. Ora, você não deveria ter uma requisição respondendo em 1 segundo, quanto mais 30 segundos.

Mas upload de arquivos é a exceção. Um arquivo grande demora para transferir pela internet. E aí o timeout do Heroku entra em ação e interrompe a transmissão. O usuário tenta de novo, e se você tiver gente suficiente acessando, começa a encher a fila HTTP até ter timeouts em cascata.

É por isso que a única solução disponível para Heroku é fazer "Direct Upload" para um serviço de nuvem como o AWS S3. Você pode adicionar o add-on [Carrierwave Direct](https://github.com/dwilkie/carrierwave_direct), ou usar uma solução completa de terceiros como o [Cloudinary](http://www.akitaonrails.com/2016/07/28/atualizando-meus-posts-antigos-sobre-uploads), com sua biblioteca cliente Attachinary para facilitar as coisas. E pronto!

O Active Storage, como está agora, vai funcionar bem para qualquer deploy customizado razoável (NGINX + Rails/Puma) ~~mas não vai funcionar de jeito nenhum no Heroku~~ e quando o [novo branch](https://github.com/rails/activestorage/pull/35) estiver pronto, será uma boa opção para usar no Heroku também.

### A Etapa de Transformação

Isso pode ser feito logo após o upload ou logo antes de servir o arquivo de volta ao usuário.

A primeira opção pode ser feita de forma síncrona ou assíncrona.

Síncrona é "ruim" (quer dizer, na própria action do controller, porque essa etapa é CPU-intensiva e leva tempo). É basicamente transformar a imagem (usando algo como Rmagick ou MiniMagick) em outras versões de tamanhos diferentes (thumbnail, versão mobile, versão high-dpi, etc.) e armazenar os caminhos para as diferentes versões no storage.

Assíncrona é delegar essa transformação custosa para o ActiveJob, para que um worker do Sidekiq pegue a tarefa mais tarde e faça o processamento. Enquanto isso, você pode servir um placeholder se a versão específica ainda não estiver pronta.

Uma ressalva é que se você tem cloud storage e transformação assíncrona em jobs, vai ter muito tráfego, porque você vai gastar tempo fazendo upload para o cloud storage, depois o job vai ter que baixar de lá, fazer a transformação e fazer novos uploads.

A outra solução é não fazer nenhum processamento e delegar o processamento para ser feito sob demanda. É isso que o [Cloudinary/Attachinary](http://cloudinary.com/documentation/image_transformations) de terceiros faz — você pode fazer transformações customizadas usando parâmetros URI. Ele faz a transformação uma vez e faz cache dos resultados para uso futuro. Um exemplo de URL de transformação de imagem do Cloudinary:

```
http://res.cloudinary.com/demo/image/upload/w_400,h_400,c_crop,g_face,r_max/w_200/lady.jpg
```

Isso também é o que você obtém se implementar o [Refile](https://github.com/refile/refile) ou o [Shrine](https://github.com/janko-m/shrine). Eles adicionam um endpoint Rack à sua aplicação Rails que vai buscar o binário da imagem, executar a transformação de acordo com os parâmetros recebidos na URI, fazer cache da transformação e então enviar o binário.

### A Etapa de Servir os Arquivos

Aqui é fazer sua aplicação Rails servir o blob armazenado. O arquivo pode ser armazenado localmente (ou em um mount NFS remoto) ou na internet a partir de qualquer cloud storage como o AWS S3 (caso em que você simplesmente linka diretamente para o endpoint HTTP deles).

Quando sua aplicação Rails serve um arquivo local, pode apenas enviar um Header especial para o proxy reverso (NGINX ou Apache — `X-SendFile` ou `X-Accel-Redirect`, que é a diferença entre `send_file` e `send_data` no `ActionController::DataStreaming`, por sinal) e eles vão servir o arquivo diretamente, evitando bloquear o MRI durante a transferência.

Se está em cloud storage, é ainda mais fácil porque você simplesmente imprime a URL do arquivo diretamente no template HTML e não há processamento nenhum.

Haverá algum processamento se você fizer o Rails ler o blob e fazer streaming diretamente (às vezes isso é necessário porque você tem acesso restrito aos arquivos e não quer arriscar usar uma URL aleatória para o arquivo).

### Conclusão

O DHH está certo: o Basecamp serve muitos arquivos e o ActiveStorage (assim como o Paperclip e o Carrierwave) funciona bem, desde que você tenha um proxy reverso NGINX adequado na frente e tenha adicionado um CDN para fazer cache dos arquivos.

Se você não quer ter que gerenciar seu próprio storage, use um Cloud Storage (AWS S3, Google Cloud, Azure, etc.). O ActiveStorage ou outras soluções vão receber o arquivo no nível do controller Rails e você DEVE usar o ActiveJob para fazer POST do blob para o serviço de nuvem em background — sem bloquear sua aplicação no processo. Mas o trade-off é que se você adicionar transformação assíncrona em jobs, vai acabar tendo que buscar a imagem original do cloud storage para fazer as transformações.

Você deveria fazer transformações nas suas imagens para enviar a imagem no tamanho ideal de volta aos seus usuários. Novamente, se fizer isso na sua aplicação, considere um worker do ActiveJob ou as soluções Rack de transformação em tempo real com cache disponíveis no Refile ou Shrine. Pelo menos como está agora, o ActiveStorage não fornece uma solução para as transformações de imagem.

[Minha recomendação](http://www.akitaonrails.com/2016/07/28/atualizando-meus-posts-antigos-sobre-uploads) dos posts anteriores sobre o assunto continua valendo: se é sua primeira vez ou seu negócio está começando, não se estresse. Use uma solução completa como Cloudinary/Attachinary. Ela vai cuidar de tudo da forma mais otimizada possível.

Mas isso NÃO é uma recomendação definitiva. Se você tem deploys customizados e conhece seus requisitos e restrições, uma solução como ActiveStorage, Carrierwave vanilla, etc. funciona bem. Sempre há trade-offs, e ter muitas partes móveis sempre soma complexidade. A recomendação do Cloudinary é apenas para que você possa começar com o mínimo de partes móveis possível e depois migrar para cenários mais complexos se precisar.

Lidar com todas as combinações possíveis de gerenciamento de upload de arquivos não é tarefa simples. E você provavelmente tem preocupações mais urgentes na sua lógica de negócios do que lidar com arquivos.

Ah, e repetindo o mesmo de sempre: use um CDN, pelo amor de Deus! Independentemente da solução, você sempre deveria [adicionar um CDN](https://devcenter.heroku.com/articles/using-amazon-cloudfront-cdn) para servir seus assets (javascripts, stylesheets, imagens, etc.).
