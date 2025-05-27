---
title: "[Akitando] #135 - ChatGPT Consegue te Substituir? | Entendendo Jobs Assíncronos"
date: '2023-01-05T11:00:00-03:00'
slug: akitando-135-chatgpt-consegue-te-substituir-entendendo-jobs-assincronos
tags:
- chatgpt
- node.js
- bull
- kafka
- spring boot
- promises
- async
- aws
- akitando
draft: false
---

{{< youtube id="Yl-hlwhj2B0" >}}

Vamos entender mais sobre Jobs Assíncronos, a diferença de usar Promises ou Bull. E um pouco mais sobre o comportamento do famigerado ChatGPT. Vamos ver se ele realmente substitui programadores durante os códigos deste video.

## Capítulos

* 00:00 - Intro
* 01:42 - Cap 1 - Form de Upload com ChatGPT | Coisas que você não pensa
* 04:55 - Cap 2 - Upload Direto pra Cloud | Porque não gravar local
* 09:23 - Cap 3 - Ajustando o Front | ChatGPT é júnior?
* 11:46 - Cap 4 - Jogando o Back todo dentro do Controller | Como avaliar Back pesado
* 18:26 - Cap 5 - Promises, não: Jobs Async | Controlando seu back
* 23:52 - Cap 6 - Exemplos Reais de Jobs Async | Google, Anchor
* 26:00 - Cap 7 - Precisa de Jobs Async se Java tem Threads? | Apache Kafka
* 29:51 - Cap 8 - Qual o nível do ChatGPT | Errando com Convicção
* 33:27 - Cap 9 - Quanto custa um ChatGPT? | IA é inacessível
* 36:40 - Cap 10 - ChatGPT vai te substituir? | Talvez?
* 38:50 - Bloopers


## Links

* https://docs.bullmq.io/guide/connections
* https://www.npmjs.com/package/bull-ui
* https://github.com/ShaneK/Matador
* https://www.baeldung.com/spring-kafka
* https://youtu.be/yE-XLLa2AME?t=642
* https://youtu.be/0uQqMxXoNVs?t=551
* https://jdhao.github.io/2022/08/10/http_benchmark_wrk/

## SCRIPT

Olá pessoal, Fabio Akita


Todo mundo parece que gostou do episódio de técnicas de otimização web, onde explico porque o aplicativo que você acabou de conseguir terminar seguindo um tutorial ou curso online não se parece nada com um projeto profissional de verdade. Não foi surpreendente como realmente, a maioria dos iniciantes nem imaginava que aquelas técnicas existiam. E quem já tem experiência também confirmou que tudo que falei é o arroz com feijão.







Na mesma semana, em dezembro de 2022, tava todo mundo super hypado com o ChatGPT. Acho que todos assistindo pelo menos ouviram falar dessa inteligência artificial, da OpenAI do Elon Musk, que consegue fazer sua lição de casa, até escrever uma matéria jornalística ou script pra videos de YouTube sem nenhum esforço e, pra nós programadores, o relevante é ele conseguir escrever código direitinho. Muitos YouTubers até prevêem o fim dos programadores. Será? Se você pensou assim também, hoje vou explicar porque está errado! 




(... )






Recapitulando, no episódio de otimização expliquei rapidamente o conceito básico de balanceador de carga, tanto no nível de requisições HTTP com um NGINX ou entre sua aplicação e o banco de dados com pool de conexões. No final falei sobre como deferimos a execução de operações demoradas pra jobs assíncronos. Alguns iniciantes corretamente se questionaram: por que usar um sistema como o Bull, no caso de Node.js, se existem Promises, Async/Await, Child Processes e Worker Threads? Por que não simplesmente colocar a operação mais demorada numa Promise? Vai rodar em paralelo e devolver o HTML pro usuário rápido. Não é a mesma coisa?








Pra responder isso, eu queria mostrar um outro exemplo. E como escrevi este script tarde da noite, realmente tava morrendo de preguiça de escrever código Javascript então resolvi pedir pro meu copiloto, o ChatGPT, pra escrever pra mim.  Eu peço as coisas pra ele sempre tudo em inglês, porque o modelo em inglês é o mais completo e mais bem treinado e é quem dá as melhores respostas. E minha primeira requisição foi: "escreve um form multipart pra upload de uma imagem" ("write a multipart form to upload an image").








Como era de se esperar, a resposta está correta, eis o código. E ele até dá uma explicação sobre o atributo `enctype` e tudo mais. Isso é bacana mas não exatamente impressionante. Pra uma lição de casa de curso ou faculdade é suficiente. Mas numa aplicação de verdade não fazemos mais assim.


```html
<form action="/upload" method="post" enctype="multipart/form-data">
  <div>
    <label for="image">Select an image to upload:</label>
    <input type="file" id="image" name="image">
  </div>
  <div>
    <button type="submit">Upload Image</button>
  </div>
</form>
```




É o seguinte: esse HTML vai gerar um formulário onde o usuário pode escolher uma imagem no seu computador ou smartphone. Quando clicar em "enviar" o navegador vai fazer aquele caminho que já expliquei nos episódios de rede: criar o pacote de HTTP request, conectar no servidor que responde com o endpoint "/upload". E no servidor o processo que recebe essa requisição fica bloqueado esperando receber esse arquivo.







Qual o objetivo de um endpoint de uma aplicação web? É responder de volta pro usuário o mais rápido possível, de preferência na faixa abaixo de 100 milissegundos. Lembram? Quanto mais tempo sua aplicação leva pra responder deixando o usuário pendurado, menos requisições por segundo seu servidor consegue responder, daí somos obrigados a gastar mais, colocando mais servidores pra suportar todo mundo  acessando  simultaneamente. Portanto, sempre precisamos pensar se o que estamos fazendo contribui pra aumentar ou diminuir esse tempo.








O problema do form desse exemplo é que ele se conecta e vai deixar sua aplicação e o usuário parados esperando o upload da imagem completar. Num pior caso, digamos que o usuário é um fotógrafo e resolveu dar upload numa foto em 8K RAW, ou seja, descomprimido, que pode ocupar entre 60 a 100 megabytes! Digamos que seja 60 megabytes, e ele está fazendo upload do celular, numa conexão 4G ruinzinha que dá upload só a 10 megabits por segundo.






Isso vai custar 480 segundos, ou aproximadamente 8 minutos. Isso é terrível. Esse 1 upload fez um processo do seu servidor ficar simplesmente parado, esperando, e sem poder fazer mais nada por 8 minutos inteiros! 





O Node tem capacidade de jogar essa espera pra uma thread separada que não bloqueia a habilidade de conseguir responder outras requisições enquanto isso. Porém, imagine que sua aplicação é feita pra fotógrafos que vão ficar o dia todo subindo imagens gigantes desse tipo, o tempo todo. Tudo tem um limite, e em breve seu servidor vai ficar bem pesado, porque não dá pra ficar criando threads infinitamente. E threads não são de graça.







Muitos não entendem isso. Cada nova thread ocupa espaço em RAM e tempo de processamento pra mudar o estado de uma thread pra outra. Um paliativo é justamente usar o NGINX na frente da aplicação Node, ou Spring Boot, ou Laravel ou seja lá qual framework esteja usando, porque o NGINX foi feito pra lidar com coisas como uploads demorados de forma mais eficiente do que o Node. O usuário primeiro se pendura no NGINX, faz o upload, e só quando termina o NGINX passa o arquivo direto pra sua aplicação. 







Só que NGINX, apesar de ordens de grandeza mais rápido que seu Node, também não é infinito, e uma hora vai ficar pesado. Tem diversas formas de lidar com esse problema, mas hoje em dia o melhor custo-benefício é simplesmente não lidar com ele. Especialmente porque tem outro problema ruim que não tem a ver com a espera e sim com onde fica o arquivo: o storage, ou HD local do processo que recebeu o arquivo.








Lembra que numa infraestrutura de verdade subimos vários pequenos servidores embaixo de um balanceador de carga? Significa que se a aplicação receber um arquivo e gravar localmente, só os processos no mesmo servidor vão conseguir ler, os outros não vão ter acesso. Mas aí o usuário navega na sua aplicação e vai querer ver a imagem que acabou de subir, e não vai achar, porque o NGINX elegeu outro servidor pra receber sua requisição e nesse servidor não tem a imagem. Como faz?









Podemos usar um volume compartilhado na rede via NFS, que nem quando você se conecta num servidor de arquivos da sua empresa. É uma solução válida. Mas ao mesmo tempo gostaríamos de ter um backup, caso o servidor de arquivos dê algum pau, não queremos perder arquivos dos usuários. E no fim, vamos acabar mandando esses arquivos pra algum lugar como o serviço AWS S3. Por isso falei que o menos trabalhoso é simplesmente não lidar com arquivos localmente e sim já mandar direto pro AWS S3.







Eu já sabia disso então fiz outra requisição pro ChatGPT. Pedi pra ele: "agora escreva outra versão desse formulário mas com suporte a upload direto pra um bucket com url pré-assinada do S3". E como esperado, devolveu um exemplo correto. ("now write another version of this form but with support for amazon aws s3's pre-signed direct upload to a bucket")


```html
<form action="{{ presignedUrl }}" method="post" enctype="multipart/form-data">
  <input type="hidden" name="key" value="{{ objectKey }}">
  <input type="hidden" name="acl" value="private">
  <input type="hidden" name="X-Amz-Credential" value="{{ xAmzCredential }}">
  <input type="hidden" name="X-Amz-Algorithm" value="AWS4-HMAC-SHA256">
  <input type="hidden" name="X-Amz-Date" value="{{ xAmzDate }}">
  <input type="hidden" name="Policy" value="{{ policy }}">
  <input type="hidden" name="X-Amz-Signature" value="{{ xAmzSignature }}">
  <div>
    <label for="image">Select an image to upload:</label>
    <input type="file" id="image" name="file">
  </div>
  <div>
    <button type="submit">Upload Image</button>
  </div>
</form>
```



Se você é iniciante e pelo menos já tentou programar um upload via web, provavelmente fez igual o ChatGPT na primeira vez: um form multipart dando POST pra um endpoint na sua aplicação. Só que nunca parou pra pensar em coisas como a demora do upload num cenário de verdade e nunca pensou que daria pra dar upload direto pro S3 sem passar pela sua aplicação. O grande truque é o atributo "action". No exemplo anterior era um POST pra "/upload" na sua aplicação. Mas agora é pra URL que estiver nessa variável "presignedUrl".







Em seguida tem vários campos escondidos que não chequei na documentação mais atualizada da AWS se é assim mesmo, mas se não for, é parecido. São coisas como o nome da chave onde vai ser gravado esse arquivo no bucket do S3, credenciais e outras configurações. E o resto do formulário é igual. Como falei antes, o  lance é que quando o usuário clicar em "submeter", o arquivo não passa por nenhum dos servidores da sua aplicação. Vai dar upload direto pro bucket que você configurou na sua conta antes. 







Mas como que gera essa tal de URL pré-assinada? Essa foi minha próxima requisição pro ChatGPT: "agora escreva um examplo em Node.js Express de como conseguir a url pré-assinada antes de renderizar o HTML anterior". E ele fez o código de back-end que executa antes de mandar renderizar o HTML que acabei de mostrar. ("now write a node.js express example of how to acquire the presignedUrl before rendering the previous HTML")



```js
const AWS = require('aws-sdk');
const express = require('express');
const app = express();
const s3 = new AWS.S3();

app.get('/upload', (req, res) => {
  const objectKey = `uploads/${Date.now()}/${req.query.fileName}`;
  const params = {
    Bucket: 'my-bucket',
    Key: objectKey,
    Expires: 60, // URL expires in 60 seconds
  };

  s3.getSignedUrl('putObject', params, (err, presignedUrl) => {
    if (err) {
      console.error(err);
      return res.sendStatus(500);
    }

    // Render form template with presigned URL and other required parameters
    res.render('upload_form', { presignedUrl, objectKey });
  });
});
```



Nada mau. Ele importa bibliotecas como "aws-sdk", o "express" e tudo mais. Note que só pedi esse trecho, mas pra funcionar, ou precisa saber fazer ou pedir pro ChatGPT configurar seu `package.json` o arquivo `app.js` e outras configurações. Só esse código sozinho não funciona. Se nunca usou Express, quando abrir o navegador apontando pra "localhost:3000/upload", vai cair nesse `app.get('/upload')`.






Gerar a chave do objeto pode ser feito de diversas formas. Se for antes do usuário escolher qual arquivo vai mandar, vamos precisar criar um nome aleatório usando coisas como uma função de hash, tipo um SHA512 de um número aleatório. Se for via Javascript a partir do formulário, depois que o usuário escolher o arquivo, podemos usar o próprio nome do arquivo. O principal é escolher uma fórmula que gere um string que vai ser único dentro do bucket, pra não sobrescrever o arquivo de outra pessoa.








Então construímos um JSON simples indicando o bucket, a chave que geramos e por quanto tempo a URL de upload vai ficar disponível. Coisa como 60 segundos ou menos, porque se essa URL não tiver expiração, e vazar, qualquer um poderia ficar fazendo uploads arbitrários no seu bucket até acabar o espaço ou te fazer pagar uma fortuna à toa. 





Finalmente, usamos o objeto de s3 que carregamos e chamamos essa função `getSignedUrl` passando os parâmetros que configuramos. A biblioteca do s3 vai chamar a API da AWS e se não der erro, vai devolver uma URL especial, a tal URL pré-assinada. Que passamos pra esse template "upload_form" que é o HTML que mostrei antes.





Aliás, faltou uma coisa né? Não tem nada mais ruim pro usuário do que dar upload de um arquivo gigante e não saber se tá fazendo upload devagar ou se travou tudo. Então pedi pro ChatGPT refazer o formulário anterior adicionando uma barra de progresso. "  
rewrite the html form with pre-signed url for aws s3 but with a visual progress bar as well"




```html
<form id="upload-form" method="post" action="{{presignedUrl}}" enctype="multipart/form-data">
  <input type="hidden" name="key" value="{{objectKey}}">
  <input type="hidden" name="x-amz-algorithm" value="AWS4-HMAC-SHA256">
  <input type="hidden" name="x-amz-credential" value="{{credential}}">
  <input type="hidden" name="x-amz-date" value="{{date}}">
  <input type="hidden" name="x-amz-signature" value="{{signature}}">

  <label for="file">Choose file</label>
  <input type="file" name="file" id="file" required>

  <div id="progress-bar-container">
    <div id="progress-bar"></div>
  </div>

  <button type="submit">Upload</button>
</form>

<style>
#progress-bar-container {
  height: 20px;
  width: 200px;
  border: 1px solid #ccc;
  position: relative;
}

#progress-bar {
  height: 100%;
  width: 0%;
  background-color: #4caf50;
  position: absolute;
  top: 0;
  left: 0;
}
</style>

<script>
const form = document.getElementById('upload-form');
const progressBar = document.getElementById('progress-bar');

form.addEventListener('submit', (event) => {
  event.preventDefault();

  const formData = new FormData(form);
  const xhr = new XMLHttpRequest();

  xhr.upload.addEventListener('progress', (event) => {
    if (event.lengthComputable) {
      const percentComplete = event.loaded / event.total;
      progressBar.style.width = `${percentComplete * 100}%`;
    }
  });

  xhr.open('POST', form.action);
  xhr.send(formData);
});
</script>

```



E ele fez de novo uma solução simples, mas correta. Primeiro adicionou um `div` chamado "progress-bar-container" com outro `div` dentro chamado "progress-bar".  Em seguida criou um CSS simples pra cada um desses elementos. E no fim fez um Javascript que captura o evento de "submit" do form pra mandar o upload usando a classe XMLHttpRequest, que tem evento pra indicar o progresso do upload. Ele usa isso pra conseguir o percentual que já foi e atualizar o comprimento do `div`  da barra via CSS.






Honestamente não testei pra ver se funciona. Só de bater o olho parece que sim, mas de novo, é um código super simplificado. Como  não especifiquei que era pra usar Vue.js ou React ou outro framework, ele fez javascript puro. Se seu projeto usa React, não dê copy e paste desse código. Faça um componente seguindo o padrão da sua equipe. É o tipo de código que se encontraria numa resposta de stackoverflow e que não se deve copiar e colar sem ajustar. Note que pesquisei rapidamente no stackoverflow e achei uma resposta com código similar ao que o ChatGPT me deu. No geral não tá errado.







Estão entendendo? Digamos que você é um programador júnior iniciante num projeto e o gerente pedisse, "fulano, faz um formulário de upload de imagens no nosso site?". Você faria a mesma coisa que o ChatGPT: aquele primeiro formulário HTML multipart mandando o arquivo direto pra aplicação e gravando no disco local do servidor e pronto. Se a mesma requisição viesse pra mim ou outro programador mais experiente, faríamos perguntas: "é pra coisas pesadas? quem vai usar, só pessoal interno ou é pra todo usuário? onde quer gravar essas imagens? podemos mandar direto pro s3? quer mostrar uma barra de progresso pro usuário?"








O ChatGPT sabe como fazer tudo isso, mas ele não questiona, faz o mais simples primeiro, e não tá errado. Precisamos saber de antemão que queremos mandar pro S3 via URL pré-assinada, daí ele faz exatamente o que foi pedido. Deixa eu dar outro exemplo pra ficar mais claro e aproveitar pra explicar mais conceitos que iniciantes não conhecem. Agora que temos a imagem no bucket do S3, digamos que nossa aplicação web é tipo um clone de Instagram. Eu gostaria que a imagem fosse cropada em formato quadrado e sempre fosse gravado em formato PNG pra padronizar tudo. 








Então pedi exatamente isso pro ChatGPT: "agora escreva um exemplo de ação de controller de Node.js Express pra puxar a imagem que deu upload na url pré-assinada do S3, daí use ImageMagick pra cropar num quadrado perfeito, salvar como um PNG e dar upload pra outro bucket do S3". ("now write an example of a node.js express controller action to fetch the image that was uploaded to the presigned url in aws s3, then use imagemagick to crop it in a perfect square, save as a PNG and upload to another s3 bucket")



```js
const AWS = require('aws-sdk');
const express = require('express');
const app = express();
const s3 = new AWS.S3();
const im = require('imagemagick');

app.post('/process-image', async (req, res) => {
  try {
    // Download image from S3 bucket
    const objectKey = req.body.objectKey;
    const params = { Bucket: 'my-bucket', Key: objectKey };
    const imageData = await s3.getObject(params).promise();
    const imageBuffer = imageData.Body;

    // Use ImageMagick to crop the image into a square
    const croppedImageBuffer = await new Promise((resolve, reject) => {
      im.crop({
        srcData: imageBuffer,
        width: 200,
        height: 200,
        gravity: "Center",
      }, (err, stdout, stderr) => {
        if (err) {
          return reject(err);
        }
        resolve(stdout);
      });
    });

    // Save the cropped image as a PNG
    const pngImageBuffer = await new Promise((resolve, reject) => {
      im.convert(
        ['-strip', '-interlace', 'Plane', '-quality', '100', '-colorspace', 'sRGB', '-define', 'png:compression-level=9', 'png:-'],
        croppedImageBuffer,
        (err, stdout, stderr) => {
          if (err) {
            return reject(err);
          }
          resolve(stdout);
        }
      );
    });

    // Upload the cropped image to another S3 bucket
    const targetBucket = 'cropped-images';
    const targetObjectKey = objectKey.replace('uploads/', 'cropped/');
    await s3.putObject({
      Bucket: targetBucket,
      Key: targetObjectKey,
      Body: pngImageBuffer,
      ContentType: 'image/png',
    }).promise();

    res.sendStatus(200);
  } catch (error) {
    console.error(error);
    res.sendStatus(500);
  }
});

```



De novo, tá certinho. No começo ele carrega bibliotecas que precisa saber carregar no `package.json`. E cria um endpoint de POST chamado "/process-image" que poderia ser chamado pelo Javascript do formulário, pelo objeto de XMLHTTPRequest quando detectar que o upload terminou, por exemplo. Esse código faz o seguinte, primeiro tem que saber a URL completa do arquivo que acabou de subir no bucket do S3, e configurar os parâmetros pra esse bucket.






Ele começa chamando o método `getObject` do objeto do s3. Não estou familiarizado com a biblioteca `aws-sdk` pra Javascript, mas parece que  devolve uma Promise e corretamente dá `await`. Pra quem é de outras linguagens que não tem Promises, não é a mesma coisa, mas é como se estivesse colocando esse `s3.getObject` dentro de uma nova Thread e esse `await` é como se fosse `join`, ou seja, pra esperar a thread terminar antes de continuar. 








Finalmente, puxamos o conteúdo binário do arquivo nessa variável `imageBuffer`. Relembrando, se a imagem tinha 60 megabytes, agora tem 60 megabytes na memória do interpretador V8 desse processo. Na sequência, ele faz o código pra fazer crop, ou seja, pra recortar a imagem num quadrado usando a biblioteca ImageMagick nesse "im" chamando o método "crop" direitinho. 






Ele assumiu que eu queria uma imagem de 200 por 200 pixels. Tá ok, não tinha dito nenhum outro número, mas de novo, por isso que não pode copiar e colar às cegas. Se o amador só copiasse sem ver e deixasse isso passar, agora aquela imagem de altíssima qualidade em 8K RAW do fotógrafo, se transformou numa imagem porcaria minúscula. Se for pra ser fixo eu não cortaria nada menor que uns 1000 por 1000 pixels. 







Esse pattern que ele faz de englobar tudo numa nova Promise e imeditamente chamar await, do ponto de vista só desse código, seria a mesma coisa que não ter isso. Desse jeito (muda imagem). Esse código vai esperar, await, até o crop terminar. Pela forma como o event loop do Node.js funciona, suponho que a vantagem é que fazendo assim, a única thread do event loop ficaria bloqueada e o Node não iria conseguir fazer mais nada até o crop do ImageMagick terminar. 






Mas colocando numa Promise e dando await, ele delega pro sistema operacional a operação de esperar o I/O (ler arquivo, gravar arquivo), e libera o event loop pra fazer outra coisa, como responder outras requisições de outros usuário. Quando a operação cara de I/O retorna, a thread continua depois do await como se nada tivesse acontecido. Essa é a grande vantagem de se usar Node em primeiro lugar, o event loop e o suporte a Promises. 






Vou voltar nisso mais pra frente. Em seguida temos um bloco de código que chama direto o programa "convert". Mesma coisa, Promise com await. E no final, o último bloco é chamando a biblioteca do S3 pra fazer o upload do binário cropado e reformatado como PNG pro bucket do S3. 






Agora vamos entender o problema. Quer dizer, não é nenhum problema se só você for usar essa aplicação, ou mesmo se for uma parte administrativa de um site onde só meia dúzia de pessoas for usar. Mas se for pra todo usuário do site e tiver centenas ou milhares de usuários, isso vai pesar rapidamente e exigir que se faça deploy de muitos servidores, tornando a infraestrutura super cara. 







Primeiro de tudo. Quando fazemos download da imagem do S3 e guardamos nessa variável `imageData` e a imagem tem 60MB, de cara estamos consumindo 60MB de RAM do servidor. Digamos que 100 usuários estão fazendo upload de imagens mais ou menos ao mesmo tempo. Seria 6 GB de RAM sendo ocupado no servidor web. Pra processar imagens, realmente vai usar muita RAM, o problema é compartilhar isso no mesmo servidor que precisa responder requisições web o mais rápido possível.







Além disso temos duas operações de rede pra s3, de download e upload, baixando uns 60MB e subindo uma imagem menor, mas é um tráfego que não podemos ignorar. De novo, se tiver 100 usuários simultaneamente subindo imagens de alta qualidade, naquele minuto seu servidor tá precisando gastar uns 6 gigabytes de tráfego só pra baixar do S3. "Ah, mas é porque você mandou fazer direct upload pro s3, se estivesse num storage local estaria ocupando menos banda"







Sim, é verdade e eis um exemplo de que não tem resposta certa. Se você é um serviço grande onde uma das partes principais do que oferece aos usuários é armazenamento de arquivos grandes, talvez  queira ter essa infraestrutura sob seu controle. Vai ter gente dedicada, com servidores no data center dedicados só pra gerenciar armazenamento, daí não precisa usar tanto S3. 







Por outro lado, pode ser uma empresa no começo, que ainda não tem  tantos servidores, rede e gente de infra dedicada só pra armazenamento. Talvez o S3 seja um custo-benefício melhor. Nenhuma das duas respostas é errada, depende de quem você é, qual seu nível de serviço, seu orçamento, quanto cobra e qual sua receita.








Digamos que somos uma empresa menor, e pra gente S3 faz sentido, então o código seria mais ou menos como nesse exemplo. Mas além do armazenamento temos esses dois blocos pesados de processamento, que é calcular o cropping e converter a image pra outro formato. Lembra que falei que na variável `imageData` tem 60 megabytes do binário da imagem original? Nessa parte aqui a variável `croppedImageBuffer` vai ter o binário da imagem recortada, digamos que seja uns 50 Megabytes. 







E nessa outra parte aqui onde convertemos pra PNG faz de conta que o PNG ficou com uns 5 Megabytes de tamanho, porque é comprimido. Então, antes dessa função acabar, essas 3 variáveis estão ocupando 60 + 50 + 5, ou seja, 115 megabytes de memória. Se tiver 10 usuários pendurados fazendo upload de imagens semelhantes, estamos ocupando uns 11 giga e meio de RAM dos servidores só nesse processo. 









Estão entendendo? O problema não é só conseguir rodar essas tarefas em paralelo pra liberar processamento pro Node conseguir atender mais requisições. O problema é que quanto mais gente usar o sistema, mais rápido vai acabar os recursos das máquinas web e em breve não vai ter RAM pra atender mais gente chegando. O objetivo é responder rápido, mas fazendo tudo isso, é impossível devolver a resposta HTML pro usuário na faixa de menos de 100 milissegundos. 







Por isso que pra casos assim, o correto é jogar esse processamento pra fora da aplicação web. Isso não vai diminuir nem a carga de processamento e nem o uso de RAM, mas vamos conseguir segmentar, separar os recursos dedicados só pra web e os recursos dedicados pra processar as imagens. No caso do Node.js podemos usar a biblioteca Bull, como mencionei no último episódio. 






Pedi pro ChatGPT: "escreva o mesmo código mas sem usar Promises e na realidade deferir as tarefas de download da imagem, cropping, salvar em PNG e fazer upload de volta pra outro bucket como um job assíncrono implementado como um worker de Bull. ("write the same code but without using Promises and actually deferring the tasks for downloading the image, cropping the image, saving as PNG and uploading back to a bucket to an asynchronous job implemented as a Bull worker")








Sabendo perguntar em detalhes exatamente o que queremos, o ChatGPT responde direitinho. Ele não tem como adivinhar qual é a melhor solução pra você, por isso sempre vai dar a resposta mais simples. Se eu não soubesse que Bull existe, o ChatGPT não ia me dizer. Mas agora o código começa com ele carregando a biblioteca do Bull e instanciando uma nova fila chamada "image-processing". Em seguida já adiciona uma nova tarefa na fila com a chave do objeto no bucket, que é a imagem original que o usuário fez upload. Esse é o trecho que iria no controller do Express e vamos tirar fora.








Eu não pedi pro ChatGPT reescrever aquele trecho `app.post("/upload")` do Express, mas seria arrancar fora todo aquele código do processamento de imagens e simplesmente colocar essa linha de registrar uma nova tarefa na Fila e rapidamente devolver OK pro usuário parar de esperar na fila. Caso a página web que iria devolver tivesse um preview da imagem que subiu, não teríamos como mostrar porque ainda não processamos, mas aí é só colocar uma imagem genérica com uma mensagem de "aguarde, estamos processando", e colocar um WebSocket ou algo assim pra puxar a imagem processada quando ficar disponível depois.








Voltando pro Worker de Bull, é a mesma coisa de antes, o código que acabamos de apagar do endpoint de `app.post`. Esse worker eu instalaria num servidor separado só pra workers. A vantagem é que  posso controlar quantos tarefas quero processar simultaneamente. Digamos que meu servidor não tenha 11 gigabytes de RAM que seria necessário pra rodar 100 tarefas simultâneas de imagens grandes. Só tenho 4 gigabytes, então só dá pra rodar umas 30 tarefas ou menos. Mas tudo bem. Vai demorar mais, mas como o usuário não tá pendurado esperando e nem estou congestionando os servidores web, não tem problema se demorar o triplo de tempo. 










Além disso tem outra razão pra jogar essas coisas pesadas num job assíncrono em vez de tentar rodar com Promises ou Threads. Digamos que tenha um bug na biblioteca do ImageMagick ou do S3 e dê um crash na hora de processar por alguma razão. Como faço pra rodar de novo essa tarefa? Existem bibliotecas como o "async-await-retry", mas imagina que seja um erro sistêmico, e tinha 100 usuários subindo imagens e por um erro qualquer, as 100 tarefas comecem a dar pau, e 100 vezes o sistema tente dar retry e fique retentando? Meu servidor vai morrer retentando à toa assim. Eu preciso ter controle sobre regras de retry.








Numa fila como Bull, se os workers começam a dar pau, posso configurar pra não dar retry e só marcar erro. Se descobrimos que foi algo sistêmico, podemos corrigir o bug e depois que estiver tudo corrigido, mandar as tarefas pendentes na fila rodar, tudo sob controle. Na documentação do Bull ele explica como podemos configurar retries automáticos, por exemplo, aqui ele diz pra tentar 3 vezes caso dê problema e com um tempo de backoff exponencial que começa em 1 segundo na primeira tentativa, 2 segundos pra segunda, 4 segundos pra terceira. Nunca é bom retentar imediatamente porque muito provavelmente vai dar problema igual.








E o Bull tem um monte de funcionalidades importantes como Gracefull shutdown. Digamos que modificamos o código dos workers e agora precisamos atualizar nos servidores. Não pode simplesmente desligar tudo e atualizar. Não queremos crashear jobs que estão rodando. Normalmente queremos que o worker saiba que tem uma atualização e reinicie só depois que terminar de processar o job que estava em andamento. 






Se temos vários servidores de Bull, cada um com vários processos, ele vai desligando, atualizando e reiniciando um a um só depois que terminar os jobs. Assim nenhum job vai corromper. É que nem dar shutdown normal num Windows em vez de apertar o botão de força e desligar forçado, que nunca é bom.





E sendo um sistema com fila e workers separados, existem projetos como o Matador, que é uma interface web pra monitorar os trabalhos na fila do Bull. Assim um administrador ou devops pode checar visualmente se os workers estão se comportando como deveriam e facilitar conseguir identificar se tudo está correndo bem.






Entendam, colocar um Bull e jogar aquele processamento pesado de imagens em outros servidores não diminui a quantidade de recursos sendo gastos. Ele serve pra tornar esse processamento mais gerenciável e previsível. Tudo que roda no lado dos servidores web é pra ser leve e rápido. Tudo que é pesado, como nesse exemplo de imagens, jogamos em jobs em outros servidores que só rodam jobs. 







E a comunicação entre os dois é feita via uma Fila. No caso do Bull ele usa um módulo chamado `ioredis` que usa Redis como servidor de fila. O correto na hora de instanciar a fila é indicar o servidor do Redis na conexão e quando subimos os workers, apontamos pro mesmo Redis pra escutarem quando chegar novos jobs, como estou mostrando neste exemplo que tem na própria documentação.







Se não ficou claro vou repetir: quando precisamos executar alguma tarefa mais pesada, faz de conta, mandar uma linha nova de log pra um servidor de log, enviar uma notificação, coisas que não duram muitos segundos ou até minutos, é possível que Promises no caso de Javascript, ou async/await num DotNet ou mesmo Threads como num Java, façam sentido. O problema é quando a duração desse processamento é longo e, pior, varia bastante. Nesse caso o tempo vai variar dependendo do tamanho das imagens. Fica imprevisível demais pra controlar misturado com a requisição web.







O certo é mandar pra jobs assíncronos. Isso me lembrou um caso. Esses dias eu estava configurando minha conta de Google Workspace, que são os planos pagos do Google pra serviços como Gmail. Eu queria habilitar a opção de conseguir mudar o tema do meu Gmail, isso tava desligado sei lá porque. Fui no admin, nessa tela e liguei. Mas mesmo recarregando meu Gmail, essa opção não aparecia. Olha só, em outra conta de Google Workspace que é da minha empresa, já tá ligado e em configurações aparece essa opção aqui tão vendo? Por que na outra conta não apareceu? 







Porque quando habilitei no admin ele mandou isso pra uma fila que tem um tempo super longo pros workers pegarem. Pode ser porque tem tanta operação em fila dos milhões de usuários que usam a plataforma, que precisa de horas pra executar meu pedido. Você imaginaria que deveria ser imediato, mas eles escolheram separar assim porque deve ser pesado por N motivos que não temos acesso de saber.








Veja o YouTube. Toda vez que termino um episódio, faço upload do arquivo de video. É um arquivo de dezenas de gigabytes, leva vários minutos pra subir. E depois que sobe precisa fazer checagens de copyright, gerar versões com resoluções menores, sincronizar cópias em CDN e assim por diante. Enquanto isso não acontece, eu fico vendo essa mensagem indicando que ainda tá processando. Só depois que termina que consigo fazer coisas como adicionar cards. 








Veja no anchor.fm, que é onde eu subo o arquivo mp3 pra publicar no Spotify ou Deezer. Eu faço upload e depois ele manda pra alguma fila, enquanto isso no meu front-end só indica que tá "processando". Meu navegador não tá pendurado no servidor deles. Provavelmente tem um javascript que de tempos em tempos checa se já terminou, ou tem um web socket aberto. 







Qual "a" melhor forma de fazer tudo isso? Não tem. Depende de quantos servidores, de quais tamanhos você pode pagar. O software tem que ser feito pra organizar os recursos disponíveis de forma que fique tudo menos difícil de gerenciar. Não quer dizer necessariamente mais performance ou rodar tudo em paralelo. Controle significa que quando alguma coisa dá erro eu tenha a oportunidade de pausar, checar, consertar e mandar rodar de novo, e pra isso soluções usando fila e workers como o Bull de Node.js faz sentido.








Muitos pensam que porque Node.js tem eventloop não precisa de jobs assíncronos, só Promises. Espero que tenham entendido que são funcionalidades diferentes pra casos diferentes. Mesma coisa pessoal de Java, que tem threads nativas e poderiam achar que não precisam de jobs assíncronos. Mas um dos sistemas de fila mais reconhecidos é justamente o Apache Kafka, que é feito em Java. Aproveitei pra pedir pro ChatGPT reescrever o worker de Bull em Spring Boot ("To process an image that was uploaded to an Amazon S3 bucket using a pre-signed URL in a Spring Boot app, using a Kafka queue to defer the tasks to a worker, you can use the following code")









Tecnicamente, o boilerplate, a parte burocrática de configuração de Kafka exige adicionar o pacote org.springframework.kafka no arquivo `pom.xml` do projeto que é mais ou menos o equivalente ao `package.json` de Node. Daí teria que usar o script `kafka-topics.sh` pra criar os tópicos da fila. Finalmente, pra aplicação Spring Boot conseguir criar mensagens pra mandar pra fila, precisa configurar um `ProducerFactory` que é o responsável pela estratégia de como criar instâncias de Producers de Kafka.






O código de exemplo que o ChatGPT gerou instancia um KafkaTemplate mas ele deveria injetar um ProducerFactory dentro, que foi omitido. Como o video não é pra ser um tutorial de Spring Boot, depois leiam a documentação, mas só pra explicar que, de novo, o ChatGPT não me deu tudo mastigado. Eu sei que falta coisa porque já li a documentação. Se você nunca usou Kafka na vida e achou que o ChatGPT ia te dar tudo mastigado, pensou errado.



 


Em seguida ele cria um endpoint web chamado "/process-image" como tínhamos feito com o Express. No Spring Boot isso é configurado com uma annotation que é essa linha que começa com arroba pra decorar a função logo abaixo. E essa função responde super rápido porque a única coisa que faz é pegar a instância de KafkaTemplate e enviar a mensagem do job pra fila.






A classe de Worker abaixo também é configurado com outra annotation pra dizer que é o responsável por mensagens enviadas pro tópico "image-processing". Nessa classe tem a função `processImage` que vai fazer a mesma coisa que o worker de Bull, só que em Java. Instanciar bibliotecas de S3 e ImageMagick nas versões de Java, download da imagem num ByteArray em memória, cropar e converter em PNG e fazer upload. Em termos de tempo de processamente, como o grosso depende da conexão remota com o S3 e de chamar o mesmo ImageMagick, tanto faz ser em Javascript ou em Java, vai levar mais ou menos o mesmo tempo pra rodar.







Pra quem gosta de perder tempo discutindo benchmarks de linguagens em subreddit, entenda esse cenário. Veja esses dois códigos lado a lado. A linguagem meio que não importa, porque o grosso do trabalho não é feito nem em Javascript e nem em Java. O grosso é o ImageMagick e o S3. Nas dus versões, vão fazer fork e subir um processo separado da ferramenta `convert` que vem no pacote do ImageMagick, que é feito em C.







Ele é quem vai fazer o trabalho sujo. E sim, eu não precisava ter usado ImageMagick, poderia ter escolhido uma biblioteca feita em puro Javascript e outra feita em puro Java. Mas não vejo porque, ImageMagick é a ferramenta mais madura e mais reconhecida pra trabalhar imagens. É literalmente um Photoshop em linha de comando que faz praticamente tudo. Pra que vou reinventar a roda? E mesmo se eu reinventasse a roda, não seria uma diferença muito grande de qualquer jeito.







Novamente, o objetivo de hoje foi demonstrar como um código feito como exercício simples, que só você vai usar sozinho na sua própria máquina é de um jeito. Mas como as mesmas funcionalidades num projeto de verdade ficam completamente diferentes. Na sua própria máquina, não precisa de Bull nem de Kafka. Basta subir uma Promise, ou child process que é fork de processos, ou worker thread que sobe uma thread no mesmo processo pra rodar em paralelo. Mesmo se a imagem for pesada, só você tá usando, mesmo se demorar alguns minutos e usar muita RAM e cair pro swap que é mais lento, não tem problema. O problema só aparece se estiver exposto na internet, aí fodeu.








E agora sobre coisas como o ChatGPT ou GitHub Copilot que não mostrei nesse video mas já usei. Acho excelentes. Eu sei exatamente o que quero, eu sei que não quero uma solução simples com upload direto na aplicação web. Eu sei que existe a técnica de URL pré-assinada, então o ChatGPT me obedece. Eu sei que o processamento de imagens, download e upload pro S3 é demorado, por isso eu soube pedir pro ChatGPT fazer o código levando isso em consideração e usar Bull e Kafka.








Além disso eu sei que nos exemplos de código que o ChatGPT me devolveu não tem a configuração de Redis do Bull nem do ProducerFactory de Kafka. Eu sei onde configurar e os detalhes que não lembro. Eu sei achar a documentação e completar. Também poderia pedir. "Ow, ChatGPT, faltou a configuração de ProducerFactory no KafkaTemplate, pode completar pra mim?". Entenderam? Vocês assistindo que são iniciantes e ainda não trabalharam em projetos de verdade: já tinham ouvido falar dessas coisas? 







Não estou dizendo que ninguém ensina, mas entenda: os cursos mais básicos querem que vocês tenham a falsa ilusão que programar é simples e qualquer um pode fazer. E te dão um passo a passo pra conseguir fazer um front-end de instagram, com upload de imagem, e quando conseguir ver a imagem postada na sua aplicação local, fica feliz. E realmente, a primeira vez que consegue é bacana mesmo. Mas acho que falta dizer que em cima disso tem esse tanto de coisas que mostrei nesse video e no anterior. 







Uma inteligência artificial consegue facilmente substituir um programador júnior inexperiente como puderam ver aqui. Porém, ele ainda não consegue substituir um programador experiente. Eu vou ficar impressionado quando pedir pra ele fazer alguma coisa e em vez de me dar um código simples, começar a me devolver perguntas pertinentes, como quantos usuários eu espero que o sistema tenha que aguentar, ou o volume dos uploads. Um programador experiente não sai codando à toa de qualquer jeito.







O ChatGPT é um serviçal bem burrinho que dá respostas erradas ou incompletas com muita convicção. Por exemplo, num video que eu tava assistindo, do Joseph Carlson, ele pediu pro irmão dele, que é médico de verdade, fazer uma pergunta pro ChatGPT, no caso foi "qual a condição mais comum que provavelmente se origina na coróida e que afeta homens jovens?" E o ChatGPT faz um textão explicando que é neovascularização coroidal e segue explicando o que é isso. E o médico responde: "nada mau, mas está incorreto. Seria correto se estivéssemos falando de pessoas idosas. A resposta correta seria retinopatia serosa, e é por isso que fazer auto diagnóstico via Google  não funciona".








Claro, esse caso em particular, com um pouco mais de treino o ChatGPT deve conseguir responder correto da próxima vez, mas o ponto é que as respostas deles não são garantidamente corretas o tempo todo e quando são erradas, ele não tem noção que tá errado. A resposta é sempre verbalizada de uma forma bem assertiva. Se você não for também especialista no assunto, vai acreditar e nesse caso poderia se auto-diagnosticar errado e acabar tendo problemas graves. Mas isso já acontece hoje com Google também.









Pra amadores, o ChatGPT pode ser usado como uma ferramenta de estudos, e nada do que ele soltar deve ser usado no mundo real sem consultar um especialista, porque você não tem o conhecimento e nem a experiência pra saber se veio errado ou incompleto. Pra especialistas de verdade, o ChatGPT é excelente pra fazer as tarefas mundanas que nós sabemos fazer, mas não vale nossa taxa hora, como os códigos que mostrei aqui. Eu sei avaliar se o código serve ou não, por isso pra mim o ChatGPT funciona bem. Quando ele não sabe responder, ou me responde errado, eu sei como consertar.








O banco de dados, o modelo dele, é realmente impressionante. O que mais me impressiona não é funcionar. Eu sei que funciona. As teorias pra isso existem e vem sendo evoluídas e desenvolvidas faz décadas. Mas pra fazer modelos desse tipo custa extremamente caro. Eu estava assistindo o canal Coldfusion que gosto muito e recomendo, e no video ele menciona o que o Sam Altman, presidente da OpenAI  falou. 








Hoje temos milhões de pessoas usando o ChatGPT pela novidade. Mas ele não escala pra ordem de bilhões de pessoas, que seria a escala de redes sociais como Facebook ou a escala que Google, Apple ou Microsoft conseguem atingir com seus produtos. O custo seria inviável. Segundo o Altman, uma resposta do ChatGPT custa de 10 a 100 vezes o custo de pesquisa no Google. Ainda precisa otimizar 100 vezes essa tecnologia pra chegar num ponto onde vai ser economicamente viável todo mundo usar no dia-a-dia, como smartphones ou um Google.








E claro, em alguns anos isso vai acontecer. Hoje ainda não é esse dia. Pode levar 10 anos, 20 anos. E isso pra otimizar custos. Pra chegar num ponto onde posso confiar quase 100% a ponto de não precisar de especialistas humanos, isso realmente não vejo acontecendo tão cedo. Eu vejo sim, sendo um excelente auxiliar pra nós especialistas, e num espectro menor, ajudando não especialistas com perguntas simples do dia a dia, algo um pouco melhor que as porcarias de Alexa, Siri ou Cortana. 








Pra nós programadores tem outro aspecto. Muitos iniciantes acham que deveriam estudar tópicos de inteligência artificial porque num futuro próximo todo mundo vai estar programando inteligências artificiais, mas sinto te informar que isso não vai acontecer como você pensa. Sim, se você tem nível e talento pra ser contratado pra times de pesquisa da OpenAI, da Microsoft, da Apple, do Google, aí você teria chances de trabalhar na construção dessas inteligências. Mas fora dessas empresas gigantes, não vai rolar.









O maior problema não são os algoritmos. O problema é o treinamento. Pra conseguir fazer um Dall-e 2, Midjourney ou Stable Diffusion gerar fotos e desenhos artísticos realistas, precisou treinar cada um desses modelos com milhões de imagens diferentes por muito e muito tempo. Estamos falando em escala de petabytes de dados, milhares ou milhões de horas em dezenas ou centenas de servidores super caros. Data centers dedicados com o supra sumo das placas de video NVIDIA. Ou seja, você, no seu PCzinho ou notebook, jamais vai conseguir produzir um modelo de verdade que vá além de um  brinquedo. 







Modelos sérios do tamanho de um ChatGPT custam milhões de dólares pra produzir. Você não vai ter acesso a esse tipo de investimento e infraestrutura. Se alguém de uma tech startup desconhecida vier te convidar pra construir um modelo desses, já sabemos que ele mora em Nárnia, enxerga unicórnios e tem amigos imaginários. Não vai acontecer.






Na prática, quase todos nós, programadores, no máximo vamos poder usar modelos prontos dos outros, como da OpenAI. Se já tentou usar o ChatGPT todo dia, já deve ter visto como do nada uma resposta engasga e dá erro de conexão, ou como o site todo às vezes fica fora do ar por alguns segundos ou minutos. Exatamente porque nesta versão de agora, ainda não escala. Precisa sair uma versão 2.0 com mais garantias pra gente poder investir em produtos que tirem proveito desse modelo.








Mas a pergunta que todo mundo tem na cabeça é "o ChatGPT vai substituir programadores?" E a resposta é simples: sim, vai substituir os ruins, os preguiçosos, os falsos sêniors e infelizmente alguns dos iniciantes. Porque muitas tarefas mundanas de código que um júnior pegaria, eu como sênior posso usar o ChatGPT pra fazer mais rápido e, mais importante, com zero reclamação, mais rápido e com menos erros. Agora, substituir um bom sênior de verdade? Eu diria que precisa pelo menos de uns bons 50 anos antes de cogitar algo assim. Tá longe, bem longe.







Eu estou satisfeito o suficiente com ferramentas como o ChatGPT ou Copilot do GitHub. Eles são mais eficientes e mais rápidos do que dar alt-tab e procurar o que preciso no Google ou Stackoverflow. Eu sei quando ele me devolve bobagem e consigo ignorar. E sei quando tá incompleto. Ao mesmo tempo, é bom pra fazer coisas mudanas e repetitivas, como testes unitários por exemplo. Ou me devolver exemplos de códigos que estou com preguiça de procurar no Github. Realmente, é como se eu tivesse um serviçal que procura no Google pra mim.








Muitos YouTubers tem feito video dizendo "olha só como o ChatGPT escreveu o script desse video". Eu tentei, mas tava dando tanto trabalho que foi mais r;apido eu mesmo escrever. Sinto muito, na atual versão, o ChatGPT é incapaz de escrever um script pra este canal sem muita intervenção. Eu concluo que os canais dos outros são bem superficiais e simplórios se um script gerado pelo ChatGPT é capaz de enganar a audiência. No meu caso não rolou. O ChatGPT é excelente pra encher linguiça de forma convincente, mas falar direto ao ponto, ele tem muita dificuldade. 







No final a conclusão é simples: seu grau de empolgação com o ChatGPT é inversamente proporcional ao seu nível de conhecimento. Se for baixo, vai ficar exageradamente empolgado, se for alto, vai achar útil, com ressalvas. É a diferença de quem vê um truque de mágica pela primeira vez, e de quem já sabe como o truque funciona. Pra quem não quer ser substituído por uma IA mande dúvidas nos comentários abaixo. Se curtiram o video deixem um joinha, assinem o canal e não deixem de compartilhar o video com seus amigos. A gente se vê, até mais!
