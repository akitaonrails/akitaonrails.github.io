---
title: Gerando Videos de até 2 min a partir de uma Foto com I.A.
date: '2025-04-19T20:00:00-03:00'
slug: gerando-videos-de-ate-2-min-a-partir-de-uma-foto-com-i-a
tags:
- framepack
- hunyuan
- flux
- docker
- figures
- 3d print
draft: false
---

Fácil o melhor canal de tutoriais de ferramentas open source pra I.A. é o [Aitrepreneur](https://www.youtube.com/watch?v=GywyMij88rY). E nesse link ele apresenta uma nova ferramenta chamada [FramePack](https://github.com/lllyasviel/FramePack), que usa o famoso modelo [HunyuanVideo](https://github.com/Tencent/HunyuanVideo) da Tencent pra pegar uma única imagem, uma foto, e conseguir gerar videos de excelente qualidade de até 2 minutos de duração. É realmente impressionante! Assistam o video, mas eis aqui embaixo um video gerado de 10 segundos de uma foto que eu tirei de uma das action figures da minha coleção.

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/link-animado.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/link-animado.mp4)
    </video>
</div>



Já que estava no embalo de empacotar esse tipo de ferramenta em Docker, resolvi fazer mais um projetinho com um Dockerfile pra rodar no meu Manjaro Linux com RTX 4090. O bom do Aitrepreneur é que ele tem um Patreon que você pode assinar pra contribuir (é barato) e ele sempre sobe scripts pra rodar no [RunPod](https://www.runpod.io/) caso você não tenha uma máquina parruda ou GPU, ou script .BAT pra rodar no seu Windows.

Meu projetinho está [neste GitHub](https://github.com/akitaonrails/FramePack-Docker-CUDA) e pra usar é muito simples:

```

git clone https://github.com/akitaonrails/FramePack-Docker-CUDA.git
cd FramePack-Docker-CUDA
mkdir outputs
mkdir hf_download

# Build the image
docker build -t framepack-torch26-cu124:latest .

# Run mapping the directories outside:
docker run -it --rm --gpus all -p 7860:7860 \
  -v ./outputs:/app/outputs \
  -v ./hf_download:/app/hf_download \
  framepack-torch26-cu124:latest
```

Isso vai construir a imagem de Docker e rodar. E na primeira vez dá pra ver que ele vai baixar uma TONELADA de models, o HunyuanVideo, Flux e mais. Se prepara pra mais de 30GB. Mas é só na primeira vez porque eu mapeio o diretório de download pra fora, então se reiniciar o container ele já vai ter na próxima vez.

Quando terminar, é só acessar **http://localhost:7860** e vai ver esta interface super simples:

![FramePack Web UI](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/x5nwxu25vlb9ox5kda5xiz6b4fwf?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-19%2018-06-34.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-19%252018-06-34.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001022Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=830ef72db7ab9c3d1edd183b440306dc8a66ff0d1e2e092ef9d51cdcf06a9d66)


Os controles são muito simples:

- Desabilite a opção "Use TeaCache" que deixa mais rápido mas aí você arrisca a ter aqueles defeitos de I.A. como mão com mais dedos e coisas assim.
- Total do Video pode ser até 2 minutos, mas só faça isso se realmente tiver paciência porque demora BASTANTE! Acho melhor começar mesmo testando com videos curtos de 5 a 10 segundos primeiro.
- Se sua GPU tiver pouca VRAM vai ser obrigado a mexer em "GPU Inference Preserved Memory (GB) (larger means slower)". No meu caso que tenho 24GB de VRAM deixei como está, mas olha só rodando como ele consome:

![btop](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/5purckhhytuqd7bwp2wjqhyxq66p?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-19%2017-52-44.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-19%252017-52-44.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001026Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=dd7769d6fb7d2342c079225d9e64f4eedf0c174533aa5d5ffc42ba02dcc0afcb)

Sim! 100% da GPU e quase 100% da VRAM, puxando mais de 350W da parede! (foda-se meio ambiente! kkkkk) A CPU até fica de boa, porque esse processo é feito pra realmente MASSACRAR a GPU. Se não tiver GPU boa, alugue uma máquina na RunPod como falei antes.

O video de 10 segundos no começo do post é uma foto da uma das action figures que eu mais gosto na minha coleção, o Link de Breath of the Wild. E isso é uma coisa que me deixou empolgado. Esta é a foto original que serviu de base pro FramePack fazer o video:

![Link Foto](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/g3dm9u1ij8r6gl0dk90qool0htyw?response-content-disposition=inline%3B%20filename%3D%2220250419_184724.jpg%22%3B%20filename%2A%3DUTF-8%27%2720250419_184724.jpg&response-content-type=image%2Fjpeg&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001027Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=0fcdc1b699b3e6a3adfb05e846339aa1bf3f0e036e31176df2ee9916a7c06619)

Fazer video de fotos de pessoas é sem graça e tedioso, mas agora que estou aprendendo a modelar 3D pra imprimir na minha Bambulab, imagina depois ainda conseguir fazer ele ficar animado?

Pra animar no Blender e renderizar, também é bastante processamento e demora. Mas com isso eu consigo rapidamente prototipar uma animação e ver como fica, pra ver se vale a pena fazer uma versão melhor no Blender depois. Abre muitas possibildades de experimentação!

Por mais impressionante que isso pareça, ele não faz **QUALQUER COISA**, tive várias experimentações que deram errado e a movimentação que ele faz é bem limitada, afinal ele só tem uma foto pra usar de referência e não tem dá pra fazer movimentos bruscos demais, tem limites. Mesmo assim é bem divertido de brincar. O fato dele conseguir identificar mais que seres humanos é um grande "plus" na minha opinião, porque é onde eu me interessei mais.

**AH SIM!** Lembram o [outro blog post](https://www.akitaonrails.com/2025/04/19/aumentando-resolucao-de-anime-velho-pra-4k-com-i-a) que publiquei hoje sobre fazer **UPSCALE PRA 4K**?? Dá pra usar aqui também, pegue um video que o FramePack gerou e você gostou muito e faça upscale pra 4K pra ter mais definição ainda! Aí fica em qualidade pra até usar em edição de videos.

Videos de 2 minutos deve levar horas pra fazer. 30 segundos levou quase 1 hora. Melhor coisa é ficar em videos de 5 segundos pra brincar e experimentar, só isso já leva aí quase meia hora. Aqui vão mais alguns exemplos tirados de fotos de itens da minha coleção (aqueles que vocês viam no fundo dos meus videos). Divirtam-se!

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/ultraseven-animado.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/ultraseven-animado.mp4)
    </video>
</div>

Este é um Ultraseven de mais de 30cm de altura que eu encontrei e trouxe direto de um sebo de Tóquio ano passado, um dos que eu mais gosto especialmente porque assisti muito no começo dos anos 80 quando eu era criança.

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/jiraya-animado.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/jiraya-animado.mp4)
    </video>
</div>

Falando em nostalgia, esse é outro item da hora da minha coleção, um Jiraya super detalhado feito pela Iron Studios. E animado até que ficou bem da hora. O que acharam?

Mas agora o meu **FAVORITO**, quem me acompanha no [Instagram](https://www.instagram.com/p/DIAe3pNOFgffFZ5J32fWlc-8Kmy3Lhap5Vm58U0/?img_index=1) viu que faz algumas semanas que venho me dedicando a melhorar minhas técnicas de 3D e também de desenho e eu fiz um conceito de Mandaloriam + Judge Dredd:

![Boba Dredd](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/01qz4daelmm671m5ytgua036373h?response-content-disposition=inline%3B%20filename%3D%22Illustration23%20%25282%2529.png%22%3B%20filename%2A%3DUTF-8%27%27Illustration23%2520%25282%2529.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001029Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=078984bf5edc78e683b6cf4403bb41394b0fb29eb1882533c3a54ea119d6f9f3).png?disposition=attachment&locale=en)

Depois vejam os outros desenhos no meu Instagram, mas enfim, eu precisava saber se o FramePack era capaz de animar também desenhos e SIM, ELE CONSEGUE!! OLHA QUE PH0DA!!! Esse me deixou impressionado, dá uma nova dimensão nas minhas coisas!

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/boba-dredd-animado_upscaled.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/boba-dredd-animado_upscaled.mp4)
    </video>
</div>

Sim, tudo isso é bem pesado, mas a vantagem é que eu posso experimentar INFINITAMENTE, porque tudo roda local. Num produto comercial de alguém no "cloud", eu precisaria pagar alguma assinatura e ele ia me limitar, seria impossível ficar experimentando quando eu quisesse. Agora eu posso fazer tudo que eu quiser, quando eu quiser, como eu quiser, sem que ninguém nem nada possa encher meu s@co.

Aliás, se puderem assistam esse clip do "Boba Dredd" em tela cheia num monitor grande. Notaram que tá bem nítido? É porque eu passei no Video2K e fiz upscale pra 4x a resolução que o FramePack me deu. Juntando essas ferramentas dá pra fazer coisas BEM interessantes, depois me falem se conseguiram usar e o que fizeram de legal!
