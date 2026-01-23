---
title: "AI 3D: Já dá pra modelar 3D com prompts?"
slug: "ai-3d-ja-da-pra-modelar-3d-com-prompts"
date: 2026-01-23T12:13:58-0300
tags:
- hunyuan
- hitem3d
- blender
- bambulab
---

Alguns dias atrás eu tinha feito um post sobre como usar Blender com IAs locais usando Blender MCP. E a conclusão era que a qualidade era ruim.

Mas fui prematuro na conclusão. Opções open source ainda variam bastante em qualidade, maioria não é muito boa, mas as opções comerciais são muito boas e bem estáveis. Não vou listar tudo que existe então fica minha recomendação de dois canais no YouTube pra se manter atualizado:

* [**PixelArtistry_**](https://www.youtube.com/@PixelArtistry_)
* [**Stefan 3D AI Lab**](https://www.youtube.com/channel/UCRW08KcTVjXEmBzBsVl7XjA)

Na prática, existem vários workflows de ComfyUI pra brincar, como neste tutorial ensinando a usar o [recém-lançado modelo Trellis2](https://www.youtube.com/watch?v=H7gqMnK7wUc), da Microsoft. Não funciona perfeito como no video todas as vezes. Depende muito da imagem que se passar. Nos meus testes só consegui uns "blobs" deformados.

Mas no mundo comercial, existem 3 ferramentas que vale criar conta:

* [Hunyuan Global](https://3d.hunyuanglobal.com/), da Tencent. Existe a plataforma em chinês - que é mais completa - e a versão global em inglês que é mais limitada. Mas com ele é possível criar modelos 3D a partir de imagens com qualidade excepcional.
* [Hitem3D](https://www.hitem3d.ai/home) - é concorrente da Hunyuan, também é excelente pra gerar modelos 3D a partir de imagens. Vale testar nas duas porque dependendendo das imagens que se passar, uma pode resultar melhor que a outra.
* [Yvo3D](https://yvo3d.com/) - é uma das mais caras, mas especificamente pra gerar texturas em alta qualidade, parece que é o melhor disparado.

Tem várias outras plataformas e pra se manter atualizado existe o site [**Top3D.ai**](https://www.top3d.ai/) com o ranking das melhores ferramentas. A maioria costuma ter planos gratuitos, trial, ou coisas assim, então é bom testar quantas puder. O preço não é "caro" se você é um profissional que vai usar em trabalho pra cliente. Só é caro pra caras com eu, que usam como hobby.

Algumas que vale a pena testar são Hyper3D Rodin, Tripo AI, Prism e SAM 3D. Nos canais de YouTube que recomendei, tem videos sobre eles, então pelo menos assista.

### A carta na manga: Nano Banana

O grande truque pra qualquer plataforma, seja open source ou comercial, é começar com imagens de boa qualidade. Imagens de Google Images, ou suas fotos mal tiradas, sempre vai resultar em modelos 3D ruins.

Pra limpar imagens, o jeito mais fácil é ir no [**Google Nano Banana**](https://gemini.google/br/overview/image-generation/?hl=pt-BR). É de longe a melhor plataforma de IA pra editar e gerar imagens.

Como exemplo, resolvi partir de uma imagem que minha namorada encomendou pra um artista no **Fiverr** e que mandamos fazer adesivos pra colar no nosso arcade. Esta imagem:

![arcade original left](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260123123341_TOMIKO_NAGAI%20left.png)

A primeira coisa que pedi ao Nano Banana foi pra remover o background e separar só a personagem. É o tipo de coisa que antigamente precisaria de Photoshop pra fazer. Olha como fica agora:

![arcade no background](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260123123457_no-background.png)

(não liguem que tá espelhado, fiquei com preguiça de pegar a imagem certa.)

Enfim, ainda não é o suficiente pra gerar 3D. No caso específico de gerar modelos de personagens, o ideal é ter imagens em **"T-Pose"**, "pose em T", que é a pessoa ereta de pé com os braços abertos como Jesus. E ter fotos exatamente de frente, de trás, pela esquerda e pela direita.

E dá pra pedir pro Nano Banana fazer exatamente isso: _"generate a front photo of this character in T-Pose, for 3D modeling"_ e ele vai gerar isso:

![t-pose front](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260123124015_front.png)

Metade do trabalho acabou neste passo. Sem isso não dá pra gerar modelos bons. Agora é só mandar gerar os outros ângulos, como de costas:

![t-pose back](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260123124004_back.png)

Mesma coisa, imagens do ângulo na esquerda, na direita e pronto. Pelo menos 4 imagens **consistentes, coerentes, limpas**.

## Hunyuan Global

Agora é a parte simples. Basta escolher Hunyuan ou Hitem3D. No caso, escolhi Hunyuan:

[![Hunyuan Generate](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260123124227_screenshot-2026-01-23_12-42-16.png)](https://3d.hunyuanglobal.com/)

Só escolher o novo modelo versão 3.0 e mandar gerar com 1.5 milhões de polígonos (sim, é bem pesado, mas depois é só fazer remesh) e opcionalmente mandar gerar texturas (já sabendo que Hunyuan não é bom com texturas).

![Hunyuan model](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260123124359_screenshot-2026-01-18_13-35-13.png)

E olha o resultado. Perfeito! Do jeito que tá já dá pra usar. Como falei, ele não é muito bom com texturas, mas como meu objetivo pra esse teste foi imprimir na minha impressora 3D, não me preocupei com texturas.

Abrindo no Blender, posso colocar um modifier de remesh pra diminuir a resolução de polígonos e converter tudo em quads e fica assim:

![Blender model](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260123124605_screenshot-2026-01-18_13-46-35.png)

E de cara já tentei imprimir e saiu assim:

![Bambulab 3d Print](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260123124749_20260123_124442.png)

Fiquei particularmente impressionado com os detalhes: nada torto, nada fora do lugar, mãos com 5 dedos, proporções corretas, detalhes no rosto perfeitos, cabelo perfeito.

> Pense nisso: fui do nada, ao IA, a uma impressão 3D física!

E agora que eu tenho esse modelo, posso mandar pro [**Adobe Mixamo**](https://www.mixamo.com/#/), que é uma ferramenta online pra re-usar poses pré-prontas.

[![mixamo pose](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260123124934_screenshot-2026-01-18_14-12-07.png)](https://www.mixamo.com/#/)

Consigo subir meu modelo, calibrar a armatura/esqueleto e colocar na pose que eu quiser. Eis um exemplo:

![model sitting](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260123125208_screenshot-2026-01-23_12-51-46.png)

No Blender consigo calibrar peso de partes do mesh e outros detalhes pra melhorar a pose, mas os 80% do trabalho já foi feito automaticamente. Com isso consigo fazer animações e muito mais.

Portanto, sim, modelagem 3D já é uma realidade com IA. Existem dezenas de ferramentas pra diferentes casos de uso e especialidades, como geração de texturas, esqueletos, animação.

O principal: comece com uma boa fundação usando Nano Banana como falei, esse é o principal truque pro resto funciona direito. E fiquem sempre de olho na Tencent: o Hunyuan é o modelo mais interessante.

No mundo open source tem o Hunyuan pequeno pra rodar local e agora o Trellis2. Também fiquem de olho em novos workflow que usem esses dois juntos no ComfyUI.

Do meu lado, pra fazer coisas simples que eu quero imprimir em 3D na minha Bambulab X1C, isso já tá mais que excelente!
