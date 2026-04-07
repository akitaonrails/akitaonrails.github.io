---
title: Conversando com Luke Kanies
date: '2009-11-18T11:45:00-02:00'
slug: conversando-com-luke-kanies
translationKey: chatting-luke-kanies
tags:
- interview
- traduzido
aliases:
- /2009/11/18/chatting-with-luke-kaines/
draft: false
---

Gerenciamento de Configuração é um assunto complicado. Para quem não está familiarizado: quando você é um desenvolvedor com poucos servidores para cuidar, geralmente dá para se virar gerenciando-os manualmente. As pessoas provavelmente estão acostumadas a colocar um CD, dar duplo clique no programa "instalar" e clicar "avançar", "avançar" até o fim, depois entrar manualmente para fazer backup (quando se lembra), e às vezes até aplicar atualizações de segurança quando se lembra delas.

Mas quando você tem mais de uma dúzia de máquinas, as coisas começam a ficar feias. Você acaba cometendo mais erros, esquecendo etapas importantes, e de repente gerenciar máquinas vira um pesadelo. Você acaba sendo acordado no meio da noite porque esqueceu de instalar algum componente crucial, e por aí vai.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/pic2_original.jpg)

Da mesma forma que você precisa de testes e ferramentas de integração contínua como desenvolvedor, você também precisa de ferramentas automatizadas, confiáveis e flexíveis para o papel de administrador de sistemas. É aí que ferramentas como o **Puppet** entram para ajudar.

Desta vez entrevistei [Luke Kanies](http://twitter.com/puppetmasterd), do [Reductive Labs](http://reductivelabs.com/), ex-contribuidor da famosa ferramenta CFEngine e criador do [Puppet](http://github.com/reductivelabs/puppet), uma das ferramentas de gerenciamento de configuração mais aclamadas para datacenters do século XXI.


**AkitaOnRails:** Para começar esta entrevista, seria ótimo ter mais informações de background sobre você. Como você chegou ao campo de gerenciamento de configuração? Entendo que você tem uma longa história com o desenvolvimento do CFEngine, certo?

![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/luke_kanies_portrait_original.jpg)

**Luke:** Fui administrador Unix desde 1997, sempre escrevendo scripts e ferramentas para economizar tempo, e por volta de 2001 percebi que não deveria precisar escrever tudo sozinho — que alguém em algum lugar deveria ser capaz de me poupar tempo. Após muita pesquisa e experimentação, me fixei no Cfengine e tive sucesso suficiente com ele para começar a fazer consultoria, publicar e contribuir para o projeto.

**AkitaOnRails:** Qual é a história por trás do Reductive Labs, qual é sua missão e qual é a história da criação do Puppet?

**Luke:** Depois de alguns anos com o Cfengine, tinha muito mais insight, mas estava frustrado porque ainda parecia difícil demais — ninguém estava compartilhando código Cfengine e havia alguns problemas que exigiam muito trabalho para resolver. O maior problema, porém, era que seu desenvolvimento era muito fechado — era difícil contribuir com muito mais do que apenas correções de bugs.

Fiquei frustrado o suficiente para parar de fazer consultoria e procurar outras opções. Trabalhei brevemente no BladeLogic, uma empresa de software comercial nesse espaço, mas no final decidi que o insight que tinha e a falta de uma ótima solução eram um bom começo para um negócio — então decidi transformar minha empresa de consultoria em uma empresa de software e escrever uma nova ferramenta.

**AkitaOnRails:** Gostaria de dizer que apenas sysadmins amadores fazem tudo manualmente, mas acho que a maioria das corporações pequenas e médias ainda faz tudo manualmente ou com scripts aleatórios espalhados por todo lugar. A noção de "gerenciamento de configuração" ainda é nova para muita gente. Você poderia explicar brevemente o que é e por que é importante?

**Luke:** É surpreendentemente difícil descrever de forma concisa, mas para mim há duas regras principais: você não deveria precisar se conectar diretamente a uma máquina para alterar sua configuração, e deveria ser capaz de reimplantar qualquer máquina na sua rede muito rapidamente.

Essas duas regras combinadas exigem automação e/ou centralização abrangente de tudo que é necessário para fazer uma máquina funcionar. Irritantemente, elas também introduzem imediatamente ciclos de dependência, porque o seu servidor de automação precisa ser capaz de se construir, o que sempre é um pequeno desafio.

**AkitaOnRails:** Acho que um dos sistemas mais amplamente utilizados é o CFEngine2. Como o Puppet se compara a ele? Ou seja, qual o valor agregado ao migrar para o Puppet e quais são as ressalvas conhecidas?

**Luke:** Há várias diferenças funcionais importantes. A maior é a **Resource Abstraction Layer** do Puppet, que permite que os usuários do Puppet evitem muitos detalhes com os quais não se preocupam realmente, como como rpm, adduser ou init scripts funcionam — eles falam sobre usuários, grupos e pacotes, e o Puppet descobre os detalhes.

Também temos suporte explícito a dependências, o que faz uma enorme diferença — é fácil ordenar recursos relacionados e reiniciar serviços quando seus arquivos de configuração mudam, por exemplo.

A linguagem também é um pouco mais poderosa. Como o Cfengine, temos uma linguagem customizada simples, mas a linguagem do Puppet fornece melhor suporte para heterogeneidade, além de uma construção de recurso composto que permite criar facilmente tipos de recursos em linguagem como virtual hosts Apache que modelam recursos mais complexos compostos por múltiplos recursos simples.

**AkitaOnRails:** O Puppet tem muitos componentes. Você pode descrever brevemente alguns dos principais que trabalham juntos? O lado do cliente, o lado do servidor, as recipes?

**Luke:** A maioria das pessoas usa o Puppet no modo cliente/servidor, onde o servidor central é a única máquina que tem acesso a todo o código, e ele executa um processo capaz de compilar esse código em configurações específicas para cada host. Então cada máquina executa um cliente (incluindo o servidor), que recupera e aplica essa configuração específica do host. Isso tem boas implicações de segurança porque você não enviou seu código para cada máquina na rede.

Se esse modelo não funcionar para você, também é fácil executar o Puppet de forma standalone, onde cada máquina tem todo o código e o compila separadamente. Vários usuários do Puppet fazem isso por várias razões. Esse executável 'puppet' standalone é um interpretador padrão — pode ser usado para executar scripts de 1 linha ou milhares de linhas em uma configuração completa.

Além disso, temos alguns outros executáveis interessantes, como para acessar nossa funcionalidade de autoridade de certificação, e um executável interessante chamado 'ralsh' que fornece uma forma simples de gerenciar recursos diretamente do shell Unix, sem precisar escrever um script separado.

**AkitaOnRails:** O que você diria sobre a maturidade do Puppet? O CFEngine tem mais de uma década de uso, o que é difícil de superar. Você diria que é "maduro o suficiente"? Ou seja, já está em produção em empresas de muitos tamanhos, suas APIs não mudam muito e minhas recipes provavelmente funcionarão se eu atualizar para uma versão mais nova do Puppet? Acho que a versão 0.x deixa algumas pessoas nervosas :-)

**Luke:** Na verdade deveríamos ter chamado uma versão de 2007 de 1.0, mas é difícil saber o quão estável um lançamento será até que ele esteja disponível há algum tempo. :)

É obviamente difícil competir com a longa vida do Cfengine, embora eles estejam de certa forma migrando forçosamente para o Cfengine 3, que é uma reescrita completa, então essa maturidade não vale tanto assim agora.

No entanto, o Puppet está em uso em produção ao redor do mundo desde 2006 e atualmente é usado por mais grandes empresas do que eu poderia razoavelmente nomear — Twitter, Digg, Google, Sun, Red Hat e muitas outras — e nossa comunidade e base de clientes o consideram maduro. A virada aconteceu em algum momento no início do ano passado, quando descobri que a grande maioria dos problemas das pessoas eram problemas do lado deles, em vez de alguma falha ou limitação no Puppet.

Em geral as APIs são bastante estáveis e acho que nos saímos muito bem em manter a compatibilidade retroativa quando as APIs precisaram mudar. O ponto sobre estabilidade de API em um lançamento 1.0 não é tanto diferenciá-lo de esforços anteriores quanto fazer uma promessa para o futuro. Isso importa especialmente para empresas como a Canonical, que querem um lançamento que possam suportar no Ubuntu por cinco anos.

**AkitaOnRails:** O Puppet tem sua própria linguagem e você pode usar Ruby para os casos avançados. Provavelmente é perfeito para Rubistas, mas sinto que a maioria dos sysadmins está acostumada com Bash, Python e não é muito flexível a mudanças. Por que você escolheu usar Ruby em vez de uma linguagem mais difundida? O que os sysadmins precisam perceber para mudar de paradigmas?

**Luke:** Parte disso é que a maioria das pessoas não precisa realmente saber nada de Ruby para ser eficaz com o Puppet. Claro, você pode ter mais poder se souber, mas se você não é uma pessoa de linguagens, funciona perfeitamente com apenas Puppet.

Outra coisa boa é que temos uma escala bastante suave em termos de conhecimento de Ruby — você pode começar escrevendo templates ERB ou extensões de cinco linhas para o [Facter](http://github.com/reductivelabs/facter), que é nosso sistema de consulta do lado do cliente, e crescer suavemente até escrever tipos de recursos customizados.

No fim das contas, escolhi Ruby porque era mais produtivo nele. Provavelmente deveria ter escolhido Python, dado seu benefício de velocidade e popularidade no Red Hat e outros lugares, mas descobri que simplesmente não conseguia escrever código nele. Comecei a pensar em Ruby depois de apenas algumas horas de uso, então era impossível para mim me afastar dele.

**AkitaOnRails:** Sysadmins acostumados ao CFEngine reclamam das dependências do Ruby e do peso geral. Porque para o Puppet rodar você precisa do Ruby instalado. Nem todas as distros têm Ruby na mesma versão (embora a maioria já tenha migrado para 1.8.7). Depois há o problema do peso. O Puppet pode chegar a centenas de megabytes. O que não querem é ter clusters de máquinas Puppet (que, por si só, também precisam de manutenção, adicionando à complexidade geral). Como você lida com datacenters com milhares de servidores? Sei que é difícil medir com precisão, mas qual seria uma proporção razoável entre servidores Puppet x servidores gerenciados?

**Luke:** É tão impossível te dizer quantos clientes um servidor Puppet pode atender quanto é te dizer quantos clientes um servidor Rails pode atender — tudo depende da complexidade das tarefas. O Google escalou para 4500 máquinas clientes em um único servidor, mas a maioria das pessoas tende a adicionar outro servidor em torno de 500-1000 clientes.

É verdade que é difícil manter o uso de memória baixo em um processo Ruby, mas fizemos grandes avanços nos nossos lançamentos recentes fazendo coisas como deduplicar strings em memória e ser mais eficiente em nossos code paths. Mas na verdade gastamos muito mais tempo em features e correções de bugs e menos tempo em otimização — até recentemente éramos uma equipe de desenvolvimento pequena e simplesmente não tínhamos largura de banda para isso.

Agora que minha empresa, Reductive Labs, tem algum investimento, conseguimos adicionar três desenvolvedores em tempo integral, o que vai ajudar muito nessa área.

Quanto a dependências, essa é uma área onde nos afastamos fortemente da comunidade Ruby — não exigimos uma única gem, a não ser nossa própria ferramenta Facter (e normalmente não é enviada como gem). Os Rubistas tendem a não se preocupar muito com dependências de pacotes — eles simplesmente colocam no vendor, como gosto de dizer — mas isso não funciona quando você tem que implantar milhares de cópias. Então sim, você pode ter que instalar Ruby, mas não haverá outras dependências com as quais você tenha que lidar, o que simplifica muito.

Geralmente é tão difícil saber como você precisará dimensionar seu puppetmaster quanto seria dimensionar um servidor web — depende de quão complicada é a carga de trabalho. Em geral, em algum ponto entre 500 e 5000 clientes, você precisará de um segundo servidor, mas a maioria das pessoas provavelmente encontra isso mais perto de 500. Mas, se você tem 3000 clientes acessando um serviço, provavelmente quer torná-lo horizontalmente escalável para estabilidade além de performance.

**AkitaOnRails:** Segurança é uma grande preocupação hoje em dia. O Puppet se preocupou desde o início com o procedimento de handshake entre clientes e servidor. Você pode descrevê-lo um pouco? Também existe alguma recipe embutida para hardening de máquinas, por exemplo? Ou pelo menos algum desejo de adicionar tais ferramentas no futuro?

**Luke:** O Puppet usa certificados SSL padrão para autenticação e criptografia, incluindo uma fase de assinatura de certificados. Por padrão, o cliente gera uma chave e uma requisição de certificado (CSR) e depois envia o CSR para seu servidor. Esse envio, junto com o download posterior do certificado, são as únicas conexões não autenticadas permitidas por padrão.

A partir daí, um humano normalmente precisa acionar a assinatura do certificado do cliente, mas muitas organizações, incluindo o Google, assinam automaticamente os certificados dos clientes porque confiam em sua rede interna.

Quanto ao hardening automático, não há recipes que eu saiba agora, mas é algo que definitivamente me interessa. Anos atrás era grande fã do TITAN, que é um pacote de hardening para várias plataformas *NIX, e foi parte da inspiração para escrever o Puppet — sempre quis uma política de segurança portável e executável.

**AkitaOnRails:** O puppetmaster usa Webrick por padrão, mas a documentação também descreve o uso do Mongrel ou Passenger. Há ganhos reais em usá-los? É mais para conveniência ou temos melhorias de performance/robustez?

**Luke:** Nossa, o Webrick é lento. É realmente fantástico para provas de conceito — sobe e roda em minutos. Uma vez que você passa dessa prova de conceito, porém, você realmente precisa mudar para Mongrel ou Passenger. Se você tiver mais de uma conexão concorrente no Webrick, seus clientes começam a sofrer, mas você pode escalar para muito mais com as outras soluções disponíveis.

**AkitaOnRails:** Há algum caso de clientes sobre o qual você pode falar? Ou seja, mais detalhes sobre o tipo de infraestrutura, dificuldades, ressalvas, boas práticas?

**Luke:** As possibilidades aqui são bastante abertas. O Google usa o Puppet para manter seu TI corporativo, o que significa que o estão executando em milhares de laptops e desktops — o que é bem diferente. A MessageOne, uma divisão da Dell, é realmente interessante porque seus desenvolvedores têm que enviar código Puppet para gerenciar as aplicações que enviam, então se um app não está aparando seus logs ou fazendo backup de si mesmo, é um bug que o desenvolvedor do app tem que corrigir em vez do sysadmin. Isso realmente ajuda a fazer a ponte entre dev e ops, o que funcionou muito bem para eles.

Fora isso, há muitas histórias e boas práticas, mas temo que isso seria um segundo artigo completo. :)

**AkitaOnRails:** Já vi Andrew Shafer falar sobre [Agile Infrastructure](http://www.slideshare.net/littleidea/agile-infra-agileroots-2009) por alguns anos, mas ainda acho que a maioria das organizações de TI desconhece esse conceito. Você pode elaborar o que significa ser Ágil fora do campo de desenvolvimento?

<embed src="http://agileroots2009.confreaks.com/player.swf" height="380" width="640" allowscriptaccess="always" allowfullscreen="true" flashvars="image=images%2F15-jun-2009-14-30-agile-infrastructure-andrew-shafer-preview.png&file=http%3A%2F%2Fagileroots2009.confreaks.com%2Fvideos%2F15-jun-2009-14-30-agile-infrastructure-andrew-shafer-small.mp4&plugins=viral-1"></embed>

**Luke:** Acho que a Infraestrutura Ágil tem ainda menos adoção do que o Desenvolvimento Ágil. A grande maioria dos departamentos de TI não mudou as práticas significativamente em anos e está amplamente despreparada para o crescimento no número de servidores que estão experimentando. Eles tentam principalmente escalar adicionando mais pessoas, que chamamos de _meatcloud_, em vez de escalar suas ferramentas e práticas.

**AkitaOnRails:** Provavelmente relacionado à pergunta anterior: parece que especialmente após a Sarbanes-Oxley houve um interesse crescente em coisas como ITIL e CoBit. Você já viu implementações bem-sucedidas dessas em infraestrutura no estilo Web? Quero dizer, posso vê-las funcionando em Bancos, Aeroespacial e Defesa, etc., mas não consigo ver funcionando conforme anunciado em um ambiente muito dinâmico como hospedagem de serviços Web. Quais são suas experiências com essa questão?

**Luke:** Em geral, acho que esses tipos de políticas de alto nível são ótimas para fins regulatórios, mas não são tão boas para realmente resolver problemas. Quanto maior a empresa e mais pública ela for, mais provável é que se importem com ITIL e similares, mas na minha experiência isso não as ajuda realmente a resolver problemas além do aspecto de relações públicas. Você pode ser compatível com ITIL e disfuncional, ou completamente fora de conformidade, mas em ótima forma. Considerando que os melhores padrões são derivados de implementação e boas práticas — o que poucos desses são —, não tenho muita esperança de que eles sejam adotados pelas melhores equipes por aí.

Minha experiência pessoal é que muito poucas empresas perguntam ou se importam com esses padrões, e as que se importam geralmente o fazem de uma forma de checklist — querem garantir que podem marcar coisas como CMDB, mas não estão realmente preocupadas com os detalhes.

**AkitaOnRails:** Acho que é isso! Muito obrigado por esta conversa!
