---
title: "AI Agents: Blender MCP com Rodin e Hunyuan"
slug: "ai-agents-blender-mcp-com-rodin-e-hunyuan"
draft: true
date: 2026-01-14T11:22:38-0300
draft: false
tags:
- crush
- Blender
- Hunyuan
- Rodin
---

MCP ou Model Context Protocol é uma integração entre Agentes de IA e serviços locais ou online. É a forma de fazer seu Agente, seja Crush, OpenCode, Claude Code, etc conseguir interagir com o ambiente externo. No caso, fazia algum tempo que eu queria testar o [Blender-MCP](https://github.com/ahujasid/blender-mcp), pra conseguir usar IA pra manipular o editor de modelos 3D, Blender.

Como sempre, já vi muito hype de _"uau, já era pra quem vivia de modelar 3d, agora a IA faz tudo!"_

E como todo hype, só 1% disso é real mesmo. O **TL;DR** é simples: sim, ele gera modelos 3d. Mas sempre de baixa qualidade. Não dá pra usar como modelo principal. Dá sim pra usar como "props", objetos que jogamos no fundo, que vai aparecer pequeno e por pouco tempo. Era o que eu esperava mesmo, e agora vou demonstrar.

Como nos últimos artigos, vou usar o Crush, mas você pode usar Claude Code ou o que quiser que suporte MCP. No meu caso, começo editando o `/.config/crush/crush.json` pra ter o seguinte trecho:

```json
...
  "mcp": {
    "blender": {
      "type": "stdio",
      "command": "uvx",
      "args": [
        "blender-mcp"
      ]
    }
  }
...
```

Vou abrir o Crush dentro do diretório do próprio projeto do Blender-MCP. Mais pra caso ele fique com alguma dúvida, tem o código-fonte pra vasculhar a resposta direto:

```bash
git clone https://github.com/ahujasid/blender-mcp.git
cd blender-mcp
crush
```

E escolhi continuar usando o Claude Opus 4.5 via OpenRouter - mas vai funcionar bem com GPT 5.2 também, e outros se quiserem testar.

> Aliás, eu não sei se este é o único MCP pra Blender ou se tem outros melhores. Mas como este funcionou como eu esperava, estou usando este. Se conhecerem outros melhores, mandem nos comentários.

Nesse diretório do blender-mcp vai ter um `addon.py`. Precisa instalar ele dentro do Blender, igual se instala qualquer outro addon:

![blender install addon](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114113009_screenshot-2026-01-14_11-29-52.png)

Feito isso, o Blender vai ganhar um novo painel, que configurei desta forma:

![blender-mcp panel config](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114113120_screenshot-2026-01-14_11-31-12.png)

Tem duas coisas importantes nesse painel. O primeiro é escolher se quer usar o serviço online [Hyper3D Rodin Business](https://hyper3d.ai/) ou rodar localmente o modelo [Hunyuan3D-2 da Tencent](https://github.com/Tencent-Hunyuan/Hunyuan3D-2). Eu vou testar os dois, mas recomendo usar o Hunyuan3D se tiver uma GPU com no mínimo uns 16GB de VRAM. O Rodin é caro se você não for um profissional que vai usar todos os dias.

### Hyper3D Rodin - com API Gen-2

![Rodin Subscription](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114113633_screenshot-2026-01-14_11-36-24.png)

Ele custa nada menos que **USD 96/mês** (USD 60 o primeiro mês). Eu vou cancelar assim que terminar de brincar este mês. E tem que ser o plano Business porque precisa conseguir gerar API pro MCP conseguir usar. A qualidade final não é muito diferente do Hunyuan3D-2, então é bem mais barato se conseguir usar offline.

Um adendo sobre o Blender-MCP. O `addon.json` que falei acima foi feito pra API versão 1 do Rodin, mas hoje tem o que ele chama de "Gen-2". Tive problemas com isso e o Claude Opus conseguiu atualizar. Eis o diff:

```diff
diff --git a/addon.py b/addon.py
index d19cf1c..a6d298a 100644
--- a/addon.py
+++ b/addon.py
@@ -1187,17 +1187,19 @@ class BlenderMCPServer:
             if images is None:
                 images = []
             """Call Rodin API, get the job uuid and subscription key"""
+            # Decode base64 images back to binary for multipart upload
+            import base64
             files = [
-                *[("images", (f"{i:04d}{img_suffix}", img)) for i, (img_suffix, img) in enumerate(images)],
-                ("tier", (None, "Sketch")),
-                ("mesh_mode", (None, "Raw")),
+                *[("images", (f"{i:04d}{img_suffix}", base64.b64decode(img), f"image/{img_suffix.lstrip('.').replace('jpg', 'jpeg')}")) for i, (img_suffix, img) in enumerate(images)],
+                ("tier", (None, "Regular")),
+                ("quality", (None, "high")),
             ]
             if text_prompt:
                 files.append(("prompt", (None, text_prompt)))
             if bbox_condition:
                 files.append(("bbox_condition", (None, json.dumps(bbox_condition))))
             response = requests.post(
-                "https://hyperhuman.deemos.com/api/v2/rodin",
+                "https://api.hyper3d.com/api/v2/rodin",
                 headers={
                     "Authorization": f"Bearer {bpy.context.scene.blendermcp_hyper3d_api_key}",
                 },
@@ -1249,7 +1251,7 @@ class BlenderMCPServer:
     def poll_rodin_job_status_main_site(self, subscription_key: str):
         """Call the job status API to get the job status"""
         response = requests.post(
-            "https://hyperhuman.deemos.com/api/v2/status",
+            "https://api.hyper3d.com/api/v2/status",
             headers={
                 "Authorization": f"Bearer {bpy.context.scene.blendermcp_hyper3d_api_key}",
             },
@@ -1352,7 +1354,7 @@ class BlenderMCPServer:
     def import_generated_asset_main_site(self, task_uuid: str, name: str):
         """Fetch the generated asset, import into blender"""
         response = requests.post(
-            "https://hyperhuman.deemos.com/api/v2/download",
+            "https://api.hyper3d.com/api/v2/download",
             headers={
                 "Authorization": f"Bearer {bpy.context.scene.blendermcp_hyper3d_api_key}",
             },
```

Lembre de instalar esta versão atualizada no Blender.

Além disso note que o addon, por default, manda o Rodin gerar em modo "Sketch" (rascunho), que é bem baixa qualidade. Meu patch acima aumenta pro modo "Regular-High", que parece que gasta 5x mais créditos, mas tem mais qualidade.

### Hunyuan3D-2 offline

Os modelos da Tencent tem sido bem recomendados pra geração de imagens e videos, vale fuçar depois. Em particular, tem também pra gerar meshes pra modelos 3D. Pra isso precisamos rodar um servidor local que vai ficar escutando em **localhost:8081**.

```bash
git clone https://github.com/Tencent-Hunyuan/Hunyuan3D-2.git
cd Hunyuan3D-2
```

Na data de publicação deste artigo, esse projeto precisava de Python 3.12 e CUDA 12.8. Meu Arch Linux/Omarchy é mais atualizado - bleeding edge - e roda Python 3.13 com CUDA 13.1 e isso vai dar um monte de problemas pra compilar os módulos que vamos precisar. A forma correta é usar Mise e Docker:

```bash
mise install python@3.12
mise local python@3.12
python -m venv venv
source venv/bin/activate
pip install --index-url https://download.pytorch.org/whl/cu128 torch torchvision
torchaudio
pip install -r requirements.txt
```

Isso deve ser suficiente pra rodar o `api_server.py` mas caso queira suporte a geração de texturas (tem essa opção no painel do MCP, tem que habilitar lá também), precisa compilar um módulo que vai precisar de GCC-13 (e meu Arch tem GCC-14). O jeito mais fácil é usar Docker:

```bash
docker run --gpus all \
--user "$(id -u):$(id -g)" \
-v /etc/passwd:/etc/passwd:ro \
-v /etc/group:/etc/group:ro \
-v $HOME/Projects/Hunyuan3D-2:/workspace \
-v $HOME/Projects/Hunyuan3D-2/venv/lib/python3.13/site-packages:/output \
nvidia/cuda:12.8.0-devel-ubuntu22.04 \
bash -c "
  apt-get update && apt-get install -y python3 python3-pip python3-dev ninja-build &&
  cd /workspace/hy3dgen/texgen/custom_rasterizer &&
  pip3 install torch --index-url https://download.pytorch.org/whl/cu128 &&
  pip3 install . --no-build-isolation &&
  cp -r /usr/local/lib/python3.10/dist-packages/custom_rasterizer* /output/
  cp build/lib*/custom_rasterizer_kernel*.so /output/
"
```

Se nada der errado agora é só subir o servidor local:

```bash
python api_server.py --model_path tencent/Hunyuan3D-2 --high_quality --enable_tex
```

Pra não gerar baixa qualidade, no painel do MCP tem que colocar:

* Octree Resolution de 256 pra 512
* Number of Inference Steps, de 20 pra 50
* Guidance Scale em 5.5 pode manter, quanto maior, mais "ao pé da letra" ele vai ser com o prompt.

E não esquecer e habilitar "Generate Textures". E, finalmente "Connect to MCP Server".

### Teste 1: Dominator

Pros testes eu baixei algumas imagens do Google Images, dei upscale no Nano Banana, e joguei no diretório do projeto mesmo pro Crush conseguir pegar (ele também suporta anexos, de qualquer forma).

O prompt não foi nada de especial, basicamente "use a imagem pra gerar modelo 3D com Rodin/Hunyuan" e só.

O primeiro teste foi esta arma Dominator do anime Psycho-Pass:

![original: Dominator](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114120531_dominator.jpg)

Eis a versão de Rodin, com texturas:

![rodin, textured, dominator](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114120627_screenshot-2026-01-13_13-22-58.png)

E eis o mesh:

![rodin, mesh, dominator](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114120715_screenshot-2026-01-14_12-07-07.png)

Olhando assim parece "perfeito", mas comparado com a imagem original dá pra ver que ele tomou várias "liberdades artísticas" com a textura. Ficou até bonito, mas ficou bem diferente do original.

Tem algumas coisas que ele não tem como adivinhar só pela foto original. Por exemplo, a Dominator é uma arma comprida mas olhando o modelo, ela ficou BEM curta. 😂

![rodin, dominator, short](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114120858_screenshot-2026-01-14_12-08-49.png)

Isso acontece com o Hunyuan3D também. Eis a versão com textura:

![hunyuan, textured, dominator](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114121011_screenshot-2026-01-14_12-09-59.png)

Eu diria que a textura ficou mais parecida com a original. A versão do Rodin pode parecer mais "impressionante" porque por coincidência ele exagerou as luzes e, sem querer, acabou ficando "atraente". Mas como disse, ele divergiu muito do original. O do Hunyuan dá pra ver que os detalhes ficaram menos "sharp", mas talvez fazendo mais upscale na foto original ou achando uma imagem de mais resolução, vá ficar melhor.

Eis o mesh gerado pelo Hunyuan:

![hunyuan, mesh, dominator](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114121202_screenshot-2026-01-14_12-11-53.png)
Comparado ao Rodin, é um mesh com bem menos polígonos e mais irregular. Mas não é ruim. Dá pra trabalhar em cima.

No geral estes vão ser os temas em todos os exemplos:

* Os modelos dos dois são OK.
* Modelos do Rodin tem mais polígonos. Mas isso não quer dizer "melhor".
* Texturas do Rodin tendem a parecer mais "atraentes". Mas do Hunyuan tende a ficar mais próximo do original.

### Teste 2: Genshin

Vamos ao próximo exemplo. Pra isso usei esta imagem de um personagem de Genshin que baixei do Google Images e também fiz upscale no Nano Banana:

![original: Genshin](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114121506_genshin.jpg)

Eu duvidei que as IAs iam conseguir chegar perto, e acertei. Ainda tá longe deles conseguirem fazer engenharia reversa de um modelo tão complicado assim. Personagens de Gatcha-games asiáticos são o estado da arte da modelagem 3D, IMHO (e tem vários pra baixar gratuitamente!).

Vamos ver o que o Rodin conseguiu fazer:

![rodin, textured, genshin](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114121657_screenshot-2026-01-14_12-16-49.png)
Absolutamente tenebroso, é o tipo de coisa que aparece em pesadelos. Completamente inusável.

E como ficou do Hunyuan?

![hunyuan, textured, genshin](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114121752_screenshot-2026-01-14_12-17-44.png)

Igualmente tenebroso e inusável. Um tema comum dessas IAs é que elas são incapazes de pegar detalhes pequenos e manter eles coerentes. Coisas como olhos, nariz, cílios, sombrancelha, sutilezas da boca. Rostos, em particular, vai ser difícil eles conseguirem modelar com precisão.

### Teste 3: Trueno

Vamos a outro objeto que não é um personagem. Peguei uma foto do Toyota AE-86 Trueno, claro. Eis a foto original:

![original: trueno](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114123035_toyota.jpg)

Mesma coisa, upscaled etc.

Vamos ver o que o Rodin fez:

![rodin, textured, trueno](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114122100_screenshot-2026-01-14_12-20-52.png)

Parece um tema frequente: objetos são melhor modelados. O formato do carro em si ficou bem OK. A textura ficou com "cara de IA". Mas se olhar de longe, não é tão ruim. Se for um carro que eu quero que apareça de relance numa rua no fundo de uma cena, funciona.

Vamos ver a versão do Hunyuan:

![hunyuan, textured, trueno](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114122245_screenshot-2026-01-14_12-22-38.png)

Mesma coisa: se olhar de longe, até que dá pra enganar. As texturas do Rodin são pouca coisa melhores, mas não é que era bons, pra começar.

Vale a pena comparar as versões sem textura. Primeiro, do Rodin:

![rodin, no-texture, trueno](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114130313_screenshot-2026-01-14_12-24-14.png)

E agora do Hunyuan:

![hunyuan, no-texture, trueno](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114130327_screenshot-2026-01-14_12-25-00.png)

Viram o que eu falei antes: do Rodin tem mais polígonos e eles são mais "regulares". Parece que passou um filtro de "smooth" pra "alisar". Já do Hunyuan tem menos polígonos e eles são irregulares, mais "orgânicos", "rough", "rascunho".

Nenhum dos dois é "bom". Como falei, não prestam pra ser modelo principal.

Uma curiosidade totalmente inútil foi quando olhei o lado de baixo do modelo. Lembrem-se: o modelo mão tem como "adivinhar" o que tinha embaixo do carro na foto. Então eles "inventam" o que preencher:

![comparison, trueno, underneath](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114130349_screenshot-2026-01-14_12-26-47.png)

Sei lá porque, o do Rodin (na direita) parece um brinquedo. Ele fez a forma mais simplificada e isso tá bem ok. Já o Hunyuan (na esquerda) tentou inventar a transmissão, eixos e tudo mais. Mas ficou bem torto. Na prática não serve pra nada e vai ser só geometria extra. Isso não é ponto positivo, só curiosidade mesmo.

### Teste 4: PS Vita

O último teste com foto foi tentar um objeto com mais detalhes, como um PS Vita. Eis a foto original:

![original: PS Vita](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114123115_PlayStation-Vita-1101-FL.png)

Primeiro com o Rodin:

![rodin, textured, ps vita](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114125430_screenshot-2026-01-14_12-31-43.png)

Não ficou ruim. Novamente, a textura ficou com "cara de IA". Também parece que esse PS Vita foi colocado num forno. As coisas parecem meio "derretendo". Mas no geral toda a geometria principal está nos lugares certos. Os botoes nas posições corretas e tudo mais. No geral, não é um modelo ruim. Eu poderia usar de prop pra colocar de enfeite me cima de uma mesa num modelo de decoração e arquitetura de um quarto, por exemplo.

Agora do Hunyuan:

![hunyuan, textured, ps vita](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114125457_screenshot-2026-01-14_12-33-40.png)

É, este é completamente inusável. O Hunyuan não conseguiu colocar nem os botões nos lugares certos e completamente alucionou a textura e fez parecer mesmo um piratão xing-ling da Shopee (faz até sentido ...).

![hunyuan, no-texture, ps vita](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114123512_screenshot-2026-01-14_12-34-57.png)

Mesmo se desconsiderar a textura, a geometria está toda errada. Tudo torto e fora do lugar. Tem que diminuir muito pra, muito de longe mesmo, enganar que é um PS Vita.

![rodin, no-texture, ps vita](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114123619_screenshot-2026-01-14_12-36-01.png)

Só o modelo 3D do Rodin também não é nenhuma maravilha, mas pelo menos os botões, posições e proporções parecem mais ou menos nos lugares certos. Continua não prestando se eu quisesse fazer um case, ou imprimir 3D. Mas como prop, dá pra usar.

### Teste 5: modelagem procedural

Todos os testes anteriores são baseados em "fotogrametria", onde passsamos a foto pra um modelo de difusão pra gerar o modelo. Mas existe uma outra forma: modelagem procedural.

Blender é todo scriptado com Python. Então é possível automatizar tudo dentro dele usando Python (todos os addons são feitos assim). Então eu posso pedir pro Crush (usando Opus ou GPT 5.2) usar a imagem como referência mas modelar usando as primitivas do sistema: cilindros, cubos, etc e ver se ele consegue modelar como um ser humano de verdade faria.

Se ele for inteligente de verdade, o correto é carregar a imagem dentro do Blender e ir ajustando os meshes pra ficarem mais ou menos alinhados com a foto.

![gpt 5.2, procedural, trueno](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114125543_screenshot-2026-01-14_12-45-45.png)

E esta é a obra de arte e o real estado do GPT 5.2 pra modelagem 3D. Pior que o pior amador na primeira semana aprendendo Blender. Completamente inusável.

E o Claude Opus não foi muito melhor não, veja esta tentativa de Dominator:

![opus, procedural, dominator](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114124711_screenshot-2026-01-13_12-18-15.png)

É uma piada de mau gosto. Não vejo nenhuma dessas LLMs conseguindo fazer modelagem procedural nem perto de um estado que dá pra enganar olhando de longe ainda.

Eu certamente consigo modelar muito melhor que isso sozinho.

### Conclusão

Como eu esperava, não imagine um bom profissional 3D sendo substituído tão cedo. Isso que eu mostrei aqui é só o pico do iceberg. Modelagem 3D de verdade envolve coisas como adiconar Rigs/esqueletos de animação e coisas muito mais sutis e delicadas. No estado atual de todas essas IAs, male male ainda conseguem fazer uns modelos tortos, animação ainda tá bem longe.

Pra gerar props pra jogar em background, funciona. Quero fazer um cenário urbano, mas não quero perder tempo fazendo um poste, ou um carrinho de pipoca, coisas pra colocar lá longe na rua só pra não parecer um cenário vazio. Sim, talvez sirva. Apesar que pra isso já existem várias bibliotecas online com props de alta qualidade muito melhores e mais baratos ou até gratuitos.

Rodin é caro. USD 96 por mês, pra esse tipo de qualidade. Eu não consigo justificar em que casos daria pra usar.

Pra brincar, use Hunyuan3D-2 como ensinei no começo. Mas não espere grandes coisas.

Pelo menos o povo de 3D, por algum tempo, ainda não tem com o que se preocupar.

Faltou eu mostrar como fiquei brincando: Crush de um lado e Blender do outro. É divertido, pelo menos:

![crush + blender](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260114130002_screenshot-2026-01-14_12-59-53.png)
