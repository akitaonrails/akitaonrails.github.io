---
title: Mudando roupas usando I.A. (ComfyUI)
date: '2025-04-23T17:45:00-03:00'
slug: mudando-roupas-usando-i-a-comfyui
tags:
- comfyui
- idm-vton
- docker
draft: false
---

No [post anterior](https://www.akitaonrails.com/2025/04/23/usando-i-a-comfyui-pra-gerar-npcs-em-desenvolvimento-de-games) mostrei como gerar character sheets pra desenvolvimento de games. Mas alguns me perguntaram "e se eu quiser roupas específicas?".

**Hold my Beer**



Tem como, é um workflow separado que depois dá pra adicionar ao workflow anterior se quiser (fica de lição de casa). Basta pegar o personagem gerado no primeiro grupo de nodes e passar por este outro workflow que troca roupas. (ou fazer o trabalhinho extra de gerar loras e ativar com palavras-chave no prompt também, não existe só um jeito).

Diferente do workflow do Mick - que é pago - este outro é aberto, peguei em algum Reddit e coloquei na pasta de workflows do meu projeto de Docker como "garmente-replacement-idm-vton.json", só carregar no ComfyUI e brincar. Vamos ver o resultado. Eis duas imagens, o resultado não é perfeito, mas veja se descobre qual dos dois é o original e qual é o gerado pela I.A.:

![Hemsworth 1](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/6b56mdoiwf82xdh7cdhdc7tg0ic2)

![Hemsworth 2](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/w0s9nthw6jt86en8wl09m67ryzpc)

Resposta ao final do post kkkk

Mas vamos lá, o workflow completo se parece com isto:

![workflow](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/xbgu7dzrjzflhfsld6jtrl5jc3ia)

No estágio atual da minha setup tem um glitch que não consegui resolver. Eu acho que é a extension JNodes que está abrindo um popup infernal no top esquerdo da interface, que não fecha de jeito nenhum. Por enquanto estou abrindo o Inspector e deletando o Node do HTML direto mesmo kkkk gambiarra mas funciona:

![JNode bug](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/p8q4hmwjmi4opsu8u045jxrpma2v)

Se alguém souber como consertar, agradeceria muito. Tem um alert de uma extension que parece que tá defasada, esse front-end alguma coisa, mas é só ignorar. Tinha que ser front-end-alguma-coisa ...

Enfim. neste primeiro grupo, é simples, basta carregar uma imagem o mais limpa e clara possível da roupa nova que quer usar. E depois a foto original onde quer que essa roupa seja aplicada. Ele não faz milagre, se a foto for de alguém com paletó e você quiser mudar pra regata, às vezes ele consegue, mas não espere que os braços e torso sejam bons, ele vai redesenhar tudo como achar que precisa, ou vai acabar colocando a regata em cima do paletó, enfim, é I.A., quanto mais claro for o objetivo, melhor o resultado. Se a nova roupa é um paletó, idealmente o original era outro paletó, vai encaixar melhor.

![Load Images](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2owpldebsc91y6vfsayscdkuqtui)


Já avisando que os modelos do IDM-VTON pesam realmente uma **TONELADA**. Ele sozinho baixa nada menos que **30GB** de modelos (já incluso no meu setup) e vai exigir mais de 20GB de VRAM, então abaixo de uma RTX 3090 de 24GB, não vai rodar. Tem como rodar online, no site do Hugging Face. Assista este tutorial que mostra como:

<iframe width="560" height="315" src="https://www.youtube.com/embed/WL59FqL0L-s?si=go8Qv-0hMiPOVwH_" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

Esse é o canal do **Aiconomist**. Ele mostra como rodar online e como fazer o setup na sua máquina [neste outro video](https://youtu.be/pFYqPf1Z7x8?si=Ryu5vxPmKGr4zhWx) que usei de referência pra fazer meu workflow. Assinem o canal dele, vale a pena, os tutoriais são bem explicadinhos e tem mais detalhes que não vou explicar neste post.

Isso dito, tem um bug que ainda não resolvi. Depois que roda o workflow, o modelo fica pendurado na VRAM da GPU e se tento rodar de novo, ele EMPERRA. Aí tenho que desligar o container de Docker e reiniciar pra recuperar a memória. Tentei um node de Clear VRAM GPU mas não funcionou. Se alguém souber como consertar, agradeço também.

O próximo passo é recorrente em vários workflow: extrair camadas de informações da foto original. Conseguir uma máscara da roupa que queremos substituir e informações da pose original:

![máscara e pose](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/kgs8jj5m7cgt2nx4kv8yazfpbfg5)

É por isso que workflows de ComfyUI são poderosos quando você começa a entender como processo é dividido. Essas partes são reusáveis e diferentes modelos dão diferentes resultados dependendo dessas controlnets que se adiciona.

Aí chegamos na parte principal: ligar todas essas informações no node de IDM-VTON, que vai reposicionar a nova roupa em cima da foto original:

![IDM-VTON](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/7xnxbrcy22trdctbf5a1dhh0rqjw)

Note que o resultado não é muito bom, fica bem "fake" mesmo. E tem como ajustar parâmetros pra melhorar. Mas o caso de uso não é usar pra trocar por roupa **específica** mas sim por roupa **similar**. Já vou explicar, mas antes, uma tangente.

O repositório da extension original desse Node é [este](https://github.com/TemryL/ComfyUI-IDM-VTON) Mas se tentar instalar, ele quebra. Parece que ele está um pouco defasado com o ComfyUI e precisa rodar numa versão mais velha. Mas isso é um saco. Então, eu resolvi fazer um [**FORK**](https://github.com/akitaonrails/ComfyUI-IDM-VTON) com as correções necessárias pra rodar na versão mais nova (as versões mais novas dos pacotes de Python diffusers, transformers, huggingface_hub, quebram o IDM-VTON).

Aliás, o gerenciamento de dependências de Python é bem RUIM. Mas do ComfyUI é ainda pior, porque diferentes extensions (que instalam dependências de Python globalmente) podem estar em diferentes estágios de desenvolvimentos. Toda vez que o ComfyUI em si muda, todo mundo precisa atualizar rápido. Por isso o ideal é não instalar a versão da branch master do ComfyUI, sempre uma versão estável (marcada numa tag) ou duas versões pra trás, pra garantir. Mas aí tem extensions novas que exigem você estar na versão mais nova. Como falei, é um pesadelo pra gerenciar. Sendo programador, eu consigo "gambiarrar" quando dá erro, mas usuários normais vão sofrer um pouco.

Feito o rant. No passo anterior a primeira parte do fluxo acaba. Quando bate nesse node Image Sender, o processo pára - não sei porque. E precisa clicar no botão "RUN" uma segunda vez. Daí o outro node, Image Receiver, vai receber a nova imagem. Acho que vou só apagar esses dois nós e ligar direto o output "image" do node Run IDM-VTON Inference e ligar direto no próximo node que são o Image Composite Masked e o VAE Encode.

Vamos voltar um passo:

![Nova foto, nova roupa](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/jj950u7842rkc9lxniz3uoztbszv)

Nesse próximo passo, no segundo "RUN", ele pega a imagem com a nova roupa, mas baixa qualidade e carrega um novo checkpoint (no caso o juggernaultXL mas poderia ser qualquer outro como o próprio SDXL, FLUX ou dreamsharper). O modelo vai determinar a nova foto, que é o que se gera no final, na direita.

Note que a nova foto tem qualidade de roupa muito melhor, mas a cara é completamente diferente. Ele usou as informações da foto original, manteve a pose, a proporção do corpo, até o fundo, mas o rosto ele não consegue manter. Não tem problema, porque podemos ajudar.

![mix photos](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/bw9sram1maspiob2ubo4r904oriy)

Lembra que no passo anterior conseguimos a máscara (preto e branco) da posição exata da roupa? Podemos aumentar a máscara e aplicar um Gaussian Blur (pra depois ele mesclar bonitinho na foto original) e usar isso pra recortar da foto gerada com o rosto diferente, usando o modelo [**IPAdapter**](https://github.com/tencent-ailab/IP-Adapter/) (que sozinho são outros 30GB de modelos - falei que é pesado).

Se não entendi errado, IP Adapter é o responsável por conseguir gerar novas imagens COERENTES entre si, com o mesmo rosto, ou mesmas roupas, mas em outras posições, por exemplo, um tipo de geração condicionada. Com ele é possível controlar BASTANTE a coerência de novas imagens, gerar uma personagem em diferentes posições, em diferentes fundos e sempre mantendo as características da personagem original.

O IP Adapter vai usar a foto original, manter o rosto, usar as máscaras e misturar com a foto com o rosto diferente, tirando só a roupa e depois juntar tudo no Image Composite Masked que é o Node final do processo.

No final, podemos comparar a primeira tentativa de colocar a roupa nova (que ficou ok mas feita, e a roupa nova, que ficou diferente mas mais bonita) e tudo integrado na foto original, mantendo o mesmo rosto. 

![image compare](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/uawsqhhr6d8kii8getzkq6ebxgh9)

Como falei, as qualidades são afetadas pela escolha do modelo, as configurações do KSampler, número de passos, cfg e tudo mais. Tem que experimentar e gerar várias até chegar no resultado que te agrada mais. É assim que se aprende mais também. Não é só clicar uma vez e magicamente já ter o resultado. Um bom artista experimenta dezenas de vezes.

A imagem final talvez não seja adequada pra ser capa da Vogue (embora eu já tenha visto muita capa oficial BEM duvidosa). Vai depender da necessidade. Em particular é bom pra prototipação. "Como será que fica essa roupa vestida na minha modelo?" Em vez de chamar a modelo, mandar vestir, ou gastar uma hora Photoshopando, em minutos dá pra experimentar várias roupas diferentes e ver se a modelo combina com a roupa, sem precisar gastar tempo. Pra um fotógrafo só mostrar pro cliente, antes de gastarem dinheiro com estúdio, ajudantes, equipamento, etc. Dá pra visualizar rapidamente e discutir detalhes muito mais rápido.

É nesse tipo de coisa que ferramentas como essa podem ajudar muito e diferenciar um artista do outro, não substituindo o artista, mas criando mais opções. E o principal: todos esses workflows são modificáveis, você reprograma e combina com outros como quiser. O limite é a criatividade.
