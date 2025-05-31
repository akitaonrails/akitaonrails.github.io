---
title: Asset Pipeline para Iniciantes - Parte 2
date: '2012-07-01T23:35:00-03:00'
slug: asset-pipeline-para-iniciantes-parte-2
tags:
- learning
- rails
- tutorial
- front-end
draft: false
---

Não perca o início deste artigo, na [Parte 1](http://akitaonrails.com/2012/07/01/asset-pipeline-para-iniciantes)

## Ambientes de Desenvolvimento e Produção

Agora entenda uma regra básica:

- toda URL que você passar ao Rails é analisada pelo sistema de roteamento, que você configura em <tt>config/routes.rb</tt>
- a exceção é tudo que estiver no diretório <tt>public</tt>, graças ao middleware Rack::Static.

Ou seja, se você pedir por <tt>http://localhost:3000/uploads/application.js</tt> isso nem vai passar pelo Rails porque, como vimos na listagem do diretório <tt>public/uploads</tt> acima, esse arquivo existe lá e, portanto, será servido diretamente.

Por isso a recomendação, depois do último exercício com pré-compilação é apagar tudo:

* * *

```
rm -Rf public/uploads
```

--

Desta forma, quando você subir o servidor Rails no ambiente padrão de desenvolvimento, a mesma URL irá passar pelo Rails, pelo Asset Pipeline, e processará o arquivo <tt>app/uploads/javascripts/application.js</tt>. Assim, toda vez que fizer modificações e recarregar a página no navegador, você verá as mudanças imediatamente. Se estivesse précompilado, veria a versão antiga, sem as modificações novas.

A compilação em tempo real só acontece em desenvolvimento pois, obviamente, é um processo lento. Em produção, ninguém em sã consciência vai alterar nenhum arquivo direto em servidor de produção, portanto é importante ter tudo précompilado em <tt>public/uploads</tt> para economizar o aplicativo Rails do trabalho.

Outra coisa importante, os arquivos de assets que se chamam “application”, são automaticamente compilados. Mas digamos que você tem um stylesheet que não vai carregar no layout principal, mas só em algumas outra seções, digamos que se chame <tt>special.css</tt>, ou seja, precisamos encontrá-lo em <tt>http://localhost:3000/uploads/special.css</tt>, criamos nesta estrutura:

* * *

```
app  
 assets  
 stylesheets  
 special.css
```

Porém, se reexecutarmos o rake task <tt>assets:precompile</tt> novamente, verá que esse arquivo não aparece em <tt>public/uploads</tt>. Recapitulando, arquivos “application” são automaticamente usados na précompilação. Todo asset declarado nesses manifestos, será usado dentro dos arquivos minificados “application”. Agora, para adicionar arquivos extras, precisamos declará-los manualmente em <tt>config/application.rb</tt>, adicionado uma linha assim:

* * *

```ruby
config.assets.precompile += %w(special.css)  
```

Colocar tudo no “application” e carregar esse arquivo no layout principal para que toda página tenha tudo? Ou separar CSS e JSS que é necessário seção a seção do site? Não tenho uma regra rígida. Se a aplicação não for tão grande assim, provavelmente centralizar tudo em “application” é a saída mais simples de gerenciar. Porém se a aplicação for ou muito grande, ou se determinada seção é relativamente mais pesada em JS que as demais, por exemplo, talvez valha a pena gerenciar assets em separado, usando a configuração acima.

Agora sim, se executar a task de precompile novamente, teremos algo como:

* * *

```
special-f7bf76f875ce5c9edd0075eaea3f6140.css  
special-f7bf76f875ce5c9edd0075eaea3f6140.css.gz  
special.css  
special.css.gz  
```

## Compass e SASS

Agora, por que adicionamos o Compass? Não vou fazer desta seção um tutorial de Compass, mas para que entendem o básico, podemos adicionar o seguinte CSS de exemplo em <tt>app/uploads/stylesheets/application.css.scss</tt>:

* * *

```css
@import “compass”;

.box {  
 font {  
 family: Lucida Grande;  
 size: 12px;  
 }  
 width: 400px;  
 padding: 15px;  
 border: 1px solid black;  
 @include text-shadow(1px 0 1px opacify(#5c5c5c, .37));  
 @include box-orient(horizontal);  
 @include border-radius(20px, 20px);  
}  
```

Na maior parte parece um CSS normal, mas a diferença maior está nos comandos <tt>@include</tt> do Sass, que serve para carregar “Mixins”. Pense em Mixin no Sass como “funções” que retornam CSS parametrizável e reusável. O Compass é uma biblioteca de Mixins que encapsulam alguns dos aspectos mais comuns de CSS. No exemplo, estamos chamando os mixins <tt>text-shadow</tt> e <tt>border-radius</tt>, cuja função deve ser bastante óbvia. Vamos ver o CSS que isso gera:

* * *

```css
** line 3, ../../app/uploads/stylesheets/application.css.scss **/  
.box {  
 width: 400px;  
 padding: 15px;  
 border: 1px solid black;  
 text-shadow: 1px 0 1px #5c5c5c;  
 -webkit-box-orient: horizontal;  
 -moz-box-orient: horizontal;  
 -ms-box-orient: horizontal;  
 box-orient: horizontal;  
 -webkit-border-radius: 20px 20px;  
 -moz-border-radius: 20px / 20px;  
 -ms-border-radius: 20px / 20px;  
 -o-border-radius: 20px / 20px;  
 border-radius: 20px / 20px;  
}  
/** line 4, ../../app/uploads/stylesheets/application.css.scss */  
.box font {  
 family: Lucida Grande;  
 size: 12px;  
}  
```

Fica claro a função de “nesting”, para herdar estilos de um elemento pai, que usamos no elemento “font” para não repetir em blocos separados, como no CSS final. O “text-shadow” foi simples, mas o “box-orient” e border-radius" automaticamente adicionaram todas as diretivas específicas de cada browser, coisas como “-webkit”, “-moz”, etc.

Veja a documentação de [referência do Compass](http://compass-style.org/reference/compass/) para encontrar todos os mixins e exemplos detalhados de como usá-los.

Isso é interessante, mas a principal função, para fechar todas as situações que descrevi na introdução do artigo, é a que se segue.

Primeiro, vamos adicionar duas novas imagens na pasta <tt>app/images/social-icons</tt>:

* * *

```
app  
 images  
 social-icons  
 facebook.png  
 linkedin.png  
 twitter.png  
```

Agora, vamos adicionar o seguinte HTML em <tt>app/views/home/index.html.erb</tt>:

* * *

```html

…

1. [Twitter](http://www.twitter.com)
  
2. [Facebook](http://www.facebook.com)
  
3. [LinkedIn](http://www.linkedin.com)
```

* * *

Nada demais, apenas o objetivo de adicionar ícones de redes sociais com links a eles. Para estilizá-los, vamos completar nosso SCSS assim:

* * *

```css

@import “compass”;  
@import “social-icons/*.png”;

…

ol.social {  
 @include horizontal-list;  
 @each $network in twitter, facebook, linkedin {  
 li.#{$network} a {  
 @include social-icons_sprite(#{$network})  
 }  
 }  
 a {  
 height: 32px;  
 width: 32px;  
 display: block;  
 text-indent: 9000px;  
 color: #FFF;  
 }  
}  
```

--

Novamente, estude SASS para entender essa sintaxe e também note que novamente usamos um mixin do Compass chamado <tt>horizontal-list</tt>. Lembre que colocamos 3 novas imagens, listados acima. Agora neste SCSS, na segunda linha, fazemos um <tt>@import</tt> de todos esses ícones.

Agora localize esta linha: <tt>@include social-icons_sprite(#{$network})</tt>. O nome da pasta, com o sufixo “_sprite” se torna um mixin, que recebe como parâmetro o nome da imagem/sprite. O que significa isso no CSS gerado ao final? Vejamos:

* * *

```css

/* line 58, social-icons/**.png */  
.social-icons-sprite, ol.social li.twitter a, ol.social li.facebook a, ol.social li.linkedin a {  
 background: url(/uploads/social-icons-s25bc94da3e.png) no-repeat;  
}  
…  
/ **line 20, ../../app/uploads/stylesheets/application.css.scss** /  
ol.social li.twitter a {  
 background-position: 0 -32px;  
}  
/ **line 20, ../../app/uploads/stylesheets/application.css.scss** /  
ol.social li.facebook a {  
 background-position: 0 -64px;  
}  
/** line 20, ../../app/uploads/stylesheets/application.css.scss */  
ol.social li.linkedin a {  
 background-position: 0 0;  
}  
…  
```

Aqui vemos o que aconteceu: as 3 imagens separadas foram concatenadas numa única, declarada no topo do CSS, chamada neste exemplo de <tt>/uploads/social-icons-s25bc94da3e.png</tt>. Agora, cada uma das classes de rede social que criamos tem um reposicionamento da mesma imagem, como: <tt>background-position: 0 -64px;</tt>.

Isto resolve o ponto 2 da introdução do artigo, que estava pendente: gerenciamento de sprites. Dependendo da quantidade de pequenas imagens que uma única página do seu site tem, somente este truque pode causar um impacto positivo que seus usuários irão notar rapidamente por causa do aumento na velocidade de renderização.

Para complementar, sempre que usarmos chamadas como <tt>background: url(/uploads/social-icons-s25bc94da3e.png)</tt> no CSS, nunca devemos digitar a URL absoluta manualmente. Devemos deixar o Asset Pipeline cuidar disso, como ele fez aqui no caso dos sprites.

Vejamos um exemplo mais concreto. Vamos adicionar o seguinte ao nosso <tt>application.css.scss</tt>:

* * *

```css
h1 {  
 padding-left: 60px;  
 height: 70px;  
 background: url(“/uploads/rails.png”) no-repeat;  
}  
```

O que confunde é que isso de fato funciona. Porém, caímos nos problema mencionados no início do artigo: sem o número timestamp, se atualizarmos a imagem, os usuários ficarão travados na versão antiga em cache local. Se quisermos migrar para CDN vamos ter problemas de mudar todas essas URLs manualmente, etc. Portanto, no caso de SASS o correto é usar a função <tt>image-url</tt> e fazer desta forma:

* * *

```css
background: image-url(“rails.png”) no-repeat;
```

* * *

Isto irá gerar a URL correta. Temos as seguinte variações:

* * *

```ruby
image-url(“rails.png”) # url(/uploads/rails.png)  
image-path(“rails.png”) # “/uploads/rails.png”.  
asset-url(“rails.png”, image) # url(/uploads/rails.png)  
asset-path(“rails.png”, image) # “/uploads/rails.png”  
```

Agora, se for necessário URLs de assets dentro do Javascript, não há equivalente no <tt>application.js</tt> puro, por isso precisaríamos renomeá-lo para <tt>application.js.erb</tt> e então a mesma regra que usaríamos em views HTML ERB normais valem:

* * *

```ruby
var imagem = “<%= image_path(”rails.png") \>";  
var tag_imagem = "<= image_tag(“rails.png”) \>";  
var audio = "<= audio_path(“rails.mp3”) \>";  
var tag_audio = "<= image_tag(“rails.mp3”) \>";  
var video = "<= video_path(“rails.m4v”) \>";  
var tag_video = "<= image_tag(“rails.m4v”) %\>";  
```

Vejam a documentação do [ActionView::Helpers::AssetTagHelper](http://api.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html) para entender melhor sobre estes helpers, mas o importante é: se estiver escrevendo a URL de um asset manualmente, como um string, você está fazendo errado.

## NGINX

Não vou entrar em detalhes sobre como configurar um NGINX completo, mas fica um lembrete para não esquecer de adicionar à configuração do servidor o seguinte trecho:

* * *

```conf
location ~ ^/uploads/ {  
 expires 1y;  
 add_header Cache-Control public;  
 add_header Last-Modified "";  
 add_header ETag "";  
 break;  
}
```

Isso garantirá que o browser do usuário guarde todos os assets no seu cache local para não pedir novamente. Com o Asset Pipeline, como explicamos exaustivamente acima, assets atualizados são imunes ao cache local.

E para diminuir ainda mais a quantidade de bits transportado entre o servidor e o browser dos usuários, lembre de checar se o suporte a gzip está ativado:

* * *

```conf

# 1. Gzip Settings  

gzip on;  
gzip_disable “msie6”;

gzip_vary on;
gzip_proxied any;
gzip_comp_level 6;
gzip_buffers 16 8k;
gzip_http_version 1.1;
gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;  
```

## Conclusão

Como podem ver, o Asset Pipeline é bastante simples para a grande maioria dos casos de uso. As regras são diferentes mas simples:

- Assets devem ir todas em <tt>app/uploads</tt>
- Em desenvolvimento <tt>public/uploads</tt> deve ficar vazio. Em produção, sempre execute <tt>rake assets:precompile</tt>
- Não digite URL de assets manualmente, use os helpers de URL

Isso lhe dará, “de graça”:

- concatenação de arquivos de assets, minificação de javascript e stylesheets
- compatibilidade com caches, CDNs e suporte a gzip
- gerenciamento de sprites numa única imagem com posicionamento via CSS
- suporte a diferentes geradores de templates, como SASS

Expanda seus conhecimentos, aprenda mais sobre:

- [Bourbon](http://thoughtbot.com/bourbon/)
- [Compass](http://compass-style.org/reference/compass/)
- [Rails Guides](http://guides.rubyonrails.org/asset_pipeline.html)
- [Asset Pipeline for Dummies](http://coderberry.me/blog/2012/04/24/asset-pipeline-for-dummies/)

Esqueçam rumores, opiniões contrárias, rants e trolls. O Asset Pipeline certamente não é simples. Porém está longe do bicho de sete cabeças que costumam descrever. No início haviam muitos bugs, que já foram corrigidos e, toda vez que alguém falar em “Asset Poopline”, normalmente é problema de de [BIOS](http://bios.6te.net/) mais do que de ferramenta. Google e Stackoverflow, for the help.
