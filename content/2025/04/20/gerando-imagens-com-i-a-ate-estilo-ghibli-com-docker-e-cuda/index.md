---
title: "Gerando Imagens com I.A - até estilo Ghibli \U0001F602 - com Docker e CUDA"
date: '2025-04-20T17:30:00-03:00'
slug: gerando-imagens-com-i-a-ate-estilo-ghibli-com-docker-e-cuda
tags:
- comfyui
- stable diffusion
- flux
- chatgpt
- dalle
- docker
- cuda
draft: false
---

Este tema vai ser dividido em dois posts. Neste é só técnico de como fazer rodar, no outro vou explicar o que diabos é um ComfyUI e mais ou menos como usar.

Mais de ano atrás, quando fiz meus últimos videos sobre I.A. e nos podcasts eu sempre falava que rodava tudo na minha máquina. Mas nunca detahei como. Então hoje consertei isso com vários posts de blog e projetinhos no GitHub com Dockerfiles pra você mesmo rodar na sua própria máquina, sem configurar nada difícil.

Finalmente fiz um [Dockerfile](https://github.com/akitaonrails/ComfyUI-Docker-CUDA-preloaded) pra ComfyUI, que é a melhor interface gráfica pra edição de workflows de geração de imagens. Se você já trabalhou com Davinci Resolve Fusion ou Blender Geometry Nodes da vida, workflows são basicamente configurações de nós pra processar suas imagens, áudio, video e ir passando por processamentos não só de I.A.. É como programar visualmente. Por isso é uma ferramenta muito mais complicada do que o FramePack que mostrei no post anterior. Não é só clicar.

Recentemente todo mundo ficou histérico com as atualizações do ChatGPT e como ele _"OH MY GOD"_ consegue gerar imagens em estilo de anime da Ghibli e ficaram spammando o mundo com memes idiotas em estilo anime. Histeria online é um saco mesmo. Mas como eu falei, por mais impressionante que seja, é isso: um gerador de memes. Não dá pra usar profissionalmente. 

Cansei de tentar subir fotos minhas ou até fotos genéricas, de personagens fictícios, alguns até desenhos meus, e vira e mexe, aleatoriamente, o ChatGPT se recusa a gerar a imagem. Alegando privacidade, segurança, copyright e tudo mais que ele conseguir inventar de desculpa. Não dá pra confiar nisso pra trabalhar. Quem é profissional deveria ter controle completo sobre o processo e é isso que vou ensinar hoje.

Pra começar, clone meu [repositório no GitHub](https://github.com/akitaonrails/ComfyUI-Docker-CUDA-preloaded) e siga as instruções do README ou faça isto:

```
git clone https://github.com/akitaonrails/ComfyUI-Docker-CUDA-preloaded.git
cd ComfyUI-Docker-CUDA-preloaded
docker compose build
```

Sendo mais complexo, precisei colocar um Docker Compose desta vez. Então pra subir, depois do build finalizar, só fazer isso:

```
docker compose up
```

Agora vai demorar, porque por padrão ele vai baixar quase **500GB** de modelos pré-treinados pra conseguir fazer quase tudo de imagens. Sim, pra brincar com I.A. localmente precisa ter infra. Ou se não, alugar máquina parruda com muito armazenamento numa RunPod da vida e rodar remoto. Tem como baixar menos modelos, vou explicar a seguir.

No Docker Compose. Recomendo evitar a opção "-d" de subir como daemon, porque é bom reservar um terminal pra ficar vendo os outputs (você pode dar `docker compose logs --follow`, se quiser também, mas é mais fácil direto).

O ComfyUI é um programa mais complexo que a média, muito mais que um FramePack da vida. Ele tem suporte a instalar "extensions" (plugins, addons, chame como quiser). E na verdade ele sozinho não faz muita coisa, precisa instalar várias extensions pra começar a ficar realmente útil. Vira e mexe alguma dessas extensions não trata erros direito e estoura no console, algo como isso:

![Console Error](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBakVCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--d73bdac23b4af02f8f14242942f257181181fa08/Screenshot%20From%202025-04-20%2017-04-48.png?disposition=attachment&locale=en)

É útil sempre ficar de olho no console pra descobrir se ele tentou carregar um arquivo que não existe. Daí dá pra pegar o nome do arquivo e buscar no Google, baixar e colocar no lugar certo. Ou se é uma extension muito bugada que é melhor tirar do diretório "custom_nodes", e assim por diante. Sem ver o console, não aparece na interface web e você vai ficar a ver navios.

Muito dos modelos e extensions eu me baseei na configuraçãol **Ultimate ComfyUI versão 3** recomendada pelo **Aitrepreneur**, de novo. Assista [este video dele](https://youtu.be/q5kpr84uyzc) pra ter todos os detalhes e tudo que é possível fazer. Ele tem os scripts pra Linux, Windows, e os workflow na versão paga do Patreon dele e, claro, não vou compartilhar os workflows porque não são meus. Em teoria, minha config deve ser capaz de fazer o que ele ensina.

O workflow V3 do Aitrepreneur é muito ph0da. Mas eu não posso compartilhar porque é material fechado no Patreon dele, mas eis uma foto de tela do meu ComfyUI com tudo dele carregado:

[![Ultimate V3](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBaklCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--2c231ae898e583c757b2bf9478d78483d3363c32/Screenshot%20From%202025-04-20%2017-09-33.png?disposition=attachment&locale=en)](https://www.patreon.com/posts/ultimate-all-in-121355089)

Mas a config em si, eu refiz inteira pra funcionar neste Docker. Dá pra carregar qualquer outro workflow aberto que achar num Reddit da vida. 

O que eu fiz foi o seguinte:

## Models

No projeto tem que ter um diretório "models", se não tiver crie, porque o docker compose vai mapear pra dentro do container. Quando iniciar, ele vai rodar o arquivo [init_models.sh](https://github.com/akitaonrails/ComfyUI-Docker-CUDA-preloaded/blob/master/init_models.sh). Esse script vai carregar um arquivo de configuração que você pode editar depois: [models.conf](https://github.com/akitaonrails/ComfyUI-Docker-CUDA-preloaded/blob/master/models.conf). Ele é enorme e um pedaço dele é assim:

```
...
[CONTROLNET]
https://huggingface.co/XLabs-AI/flux-controlnet-collections/resolve/main/flux-canny-controlnet-v3.safetensors
https://huggingface.co/XLabs-AI/flux-controlnet-collections/resolve/main/flux-depth-controlnet-v3.safetensors
https://huggingface.co/brad-twinkl/controlnet-union-sdxl-1.0-promax/resolve/main/diffusion_pytorch_model.safetensors|controlnet-union-sdxl-1.0-promax.safetensors
https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.pth
https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.pth
https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.pth
https://huggingface.co/Aitrepreneur/FLX/resolve/main/Shakker-LabsFLUX1-dev-ControlNet-Union-Pro.safetensors

[STYLE_MODELS]
https://huggingface.co/Aitrepreneur/FLX/resolve/main/flux1-redux-dev.safetensors

[SAMS]
https://huggingface.co/Aitrepreneur/FLX/resolve/main/sam_vit_b_01ec64.pth
```

Cada seção mapeia pra um sub-diretório, então "[SAMS]" vai mapear pra "models/sams" e baixar os binários nos lugares certos. Tem alguns especiais nas seções "[GIT_REPOS]", para os que podem ser clonados via git ou "[CUSTOM]" pra arquivos que precisa baixar depois dentro desses projetos clonados, por exemplo. Não sei ainda se dá pra simplificar, mas isso eu peguei na config do Aitrepreneur.

O ideal é sempre manter essa lista organizada com modelos que acharem depois. Se quiserem contribuir também seria bacana. O motivo é que fica tudo espalhado em tudo que é site por aí, você baixa manualmente, daí move pro diretório dentro de "models". Amanhã, se reinstalar sua máquina, e pra lembrar todos os sites? São dezenas de modelos disponíveis.

No outro post vou tentar resumir o que diabos são "checkpoints", "diffusion models", "loras", "controlnet" e tudo mais. Mas por enquanto, a extensão dos arquivos não diz muita coisa. Dizer ".pt" por exemplo só quer dizer que é um arquivo que o PyTorch consegue abrir, mas não diz se é um clip ou um text encoder, por exemplo. Extensão ".safetensors" mesma coisa, pode ser qualquer coisa, e o ComfyUI precisa que cada arquivo esteja no sub-diretório correto pra conseguir usar depois, não pode sair movendo arquivo aleatoriamente.

O script "init_models.sh" roda toda vez que o Docker é reiniciado e é inteligente pra só baixar URLs que já não estão baixadas no diretório "models". Por isso sempre roda quando o container sobe, no entrypoint. Essa é uma das vantagens da minha config: ela é tem manutenção automática.

### Extensions e Dependências

Eu fiz um segundo script chamado [init_extensions.sh](https://github.com/akitaonrails/ComfyUI-Docker-CUDA-preloaded/blob/master/init_extensions.sh), que também roda no entrypoint do container e você não deve mexer, mas ele carrega um outro arquivo de configuração chamado [extensions.conf](https://github.com/akitaonrails/ComfyUI-Docker-CUDA-preloaded/blob/master/extensions.conf) e, esse sim, você pode mexer e adicionar novas extensions depois. Um pedaço dele é assim:

```
[EXTENSIONS]
https://github.com/ltdrdata/ComfyUI-Manager.git
https://codeberg.org/Gourieff/comfyui-reactor-node.git
https://github.com/ssitu/ComfyUI_UltimateSDUpscale.git
https://github.com/kijai/ComfyUI-LivePortraitKJ.git
https://github.com/PowerHouseMan/ComfyUI-AdvancedLivePortrait.git
...
```

Aqui eu declaro todas as extensions que adicionam novas funcionalidades em cima do ComfyUI, em particular novos **NODES**, por isso ficam no diretório "custom_nodes", que é um volume externo ao Docker e por isso é persistente, ou seja, toda nova extension sobrevive restarts do container.

Mas tem ainda um porém GRANDE: **Dependências de Python**. Um pesadelo.

A build da Imagem Docker faz um monte de `pip install` e como estou usando Virtual ENV, vai tudo instalado em `/venv` dentro do container, como deveria.

Porém, as extensions que são instaladas fora da build - toda vez que o container reinicia - costumam ser código Python e também tem mais dependências. Extensions são projetos no GitHub e podem estar mudando neste exato momento. Se mudar e fizer um `git pull` pra atualizar, precisa rodar o `pip install -r requirements.txt`. Mas se tiver dezenas de extensions, rodar `pip install`, de cada um, em cada restart do Docker é uma demora grande pra não fazer quase nada. Como eu disse, pesadelo.

Minha solução - pra me gabar um pouco - conserta boa parte dessa manutenção. Quando o script `init_extensions.sh` executa, se uma extension da lista já estiver instalada, ele vai pular. Daí vai gravar no diretório `./custom_nodes/.last_commit/*.commit` o último commit de cada extension. Quando o Docker reiniciar, ele vai dar um `git fetch` e checar se o hash do último commit mudou.

Só se mudou, ele vai rodar `pip install` pra essa extension que ganhou atualização e pular todas as outras que não mudaram desde o último restart, economizando MUITO tempo e evitando que você precisa manualmente atualizar as coisas. Como estou usando VENV, vai ficar tudo persistido no volume "/venv". Sim, é um VOLUME, porque ela muda depois do build a cada atualização de extension.

Dessa forma, tudo que tem na imagem vai ser copiada nesse volume, e tudo que as extensions instalarem por fora, também vai pra dentro desse volume. Toda vez que reiniciar, volta tudo como estava antes. Foi a solução que encontrei e até agora parece funcionar direitinho.

Mas é só questão de tempo pra alguma extension mal feita instalar dependências que quebrem outras dependências, ou um caso real que eu passei: tinha uma extension que crasheia sem mensagem de erro se estiver usando Python 3.11, o Zoe Depth Map da extension `comfyui_controlnet_aux`, um dos pacotes que parece que são populares.

Eu não tinha me dado conta que comecei usando uma image base de Docker de ubuntu22 em vez de ubuntu24, eu estava com medo de usar algo novo demais e quebrar, mas acabei usando velha demais e quebrou do mesmo jeito. Gerenciar versionamento é um saco. Enfim, mudei o Dockerfile pra ubuntu24. 

Mas no volume externo do VENV agora sobrou um monte de dependências que se limitavam ao Python 3.11. Não tem problema, basta apagar o volume:

```
docker compose down # garantir que está parado
docker volume rm comfyui-venv
rm ./custom_nodes/.last_commits/*.commit
```

E pronto, o VENV vai reiniciar vazio, preencher com as dependências corretas de Python 3.12 da imagem e ao iniciar o container meu script `init_extensions.sh` não vai achar o ".last_commits" e vai forçar um `pip install -r requirements.txt` de todas as extensions, agora com Python 3.12. Super limpo e confiável.

Se mesmo assim tiver erro, aí pode ser bug numa extension em especial, só vá até o diretório dele em "./custom_nodes" e apague manualmente antes de reiniciar o container.

Acho que isso é o menos complicado que dá pra fazer nesse caso. Esse docker não foi feito pra rodar sozinho num servidor, é pra rodar na sua própria máquina local, onde você está monitorando o output do terminal mesmo. 

Ah sim, se sair versão nova do ComfyUI aí tem que re-buildar a imagem e apagar o volume de VENV. A imagem é estática, não esqueçam. Dentro o Dockerfile faz um novo git clone e pega o commit mais novo. Daí vai instalar pacotes python mais novos, então precisa zerar o volume da VENV e fazer as extensions re-instalarem suas dependências depois também. É um enorme saco, mas é assim mesmo que funciona.

### Conclusão

Feito tudo isso, com um simples `docker compose up` consigo ter um ambiente de ComfyUI estável e isolado do resto do meu sistema, sem sujar nada com milhares de dependências duvidosas. Quando terminar só fazer `docker compose down` ou "ctrl-c" no console dele e pronto, meu sistema continua limpo.

Além disso, diretórios como "models" e seus 500GB de modelos ficam separados, dá pra fazer backup pra outro lugar se precisar. E se quiser subir em outra máquina, basta levar somente esses diretórios e subir Docker Compose lá e tem que subir igualzinho, zero-setup. Esse foi meu objetivo ao Dockerzar ComfyUI, FramePack, Video2K, ter tudo portátil, isolado e limpo pra subir em qualquer máquina depois sem precisar ficar rodando scripts duvidosos de instalação direto na minha máquina.

[No meu X](https://x.com/AkitaOnRails/status/1914030815962411367) eu já mostrei meu ComfyUI funcionando. Carreguei um workflow qualquer que achei na Web e olha só:

![ComfyUI](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBamNCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--60ceae3b972db1c3a1d4fcc6a79d24996913eee9/Go__77_WcAASeBr.jpg?disposition=attachment&locale=en)

Nesse workflow eu subo uma imagem de referência e posso escrever um prompt de como quero transformar ela:

![Prompt](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBallCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--4d51b8ec90a5db09555ebff721da04c37aad1112/GpAAMX-X0AATd1j.png?disposition=attachment&locale=en)

Com ComfyUI eu tenho controle sobre todas as etapas do processo, por exemplo, esse workflow consegue separar coisas como Mapa de Profundidade e Contorno de Bordas da imagem original, pra usar de contexto antes de fazer a imagem final, garantindo um resultado muito mais preciso:

![Depth Map](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBalVCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--8a42084f0f05a715da7dab2770ec36a11df6e354/GpAAfhNWwAAr_eb.jpg?disposition=attachment&locale=en)

E eis um resultado que já consegui usando o modelo "waiNSFIllustrious" que esse workflow sugere, que é um modelo treinado pra gerar imagens estilo anime (tem dezenas, pra vários estilos diferentes).

![anime](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBalFCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--34e09db5b606c6414707e8c58c93ff15039cd744/GpAA4ByWoAAkcav.jpg?disposition=attachment&locale=en)

Mudando o modelo pra `Mistoon`, baseado em Stable Diffusion (SDXL), eis outro resultado, com o mesmo prompt, no mesmo workflow:

![anime 2](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBak1CIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--367e105788479b952fb131e4618d7de6c87111a9/GpAJr-jXQAAQhE0.jpg?disposition=attachment&locale=en)

E posso ficar tunando dezenas de parâmetros dentro desse workflow, trocar vaes, text encodes, controlnets e muito mais até conseguir exatamente o resultado que eu quiser. Esse é o poder do ComfyUI e seus Custom Nodes e Workflows. É o que vou tentar explicar o básico no próximo post.
