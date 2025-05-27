---
title: IIS 8 finalmente ganha um módulo de Proxy-Reverso! E como executar Rails sobre
  JRuby no Windows!
date: '2015-02-16T12:29:00-02:00'
slug: iis-8-finalmente-ganha-um-modulo-de-proxy-reverso-e-como-executar-rails-sobre-jruby-no-windows
tags:
- learning
- rails
- windows
draft: false
---

__TL;DR__: se está familiarizado com os problemas de executar Rails no Windows e já sabe o que é o HttpPlatformHandler, porque devemos usar JRuby no Windows, pule direto pra seção [Configurando Rails da forma Correta para Windows](#configuracao) mais pra abaixo.

No dia 4/2 a Microsoft [anunciou o módulo HttpPlatformHandler](http://azure.microsoft.com/blog/2015/02/04/announcing-the-release-of-the-httpplatformhandler-module-for-iis-8/). Então, em 9/2, o conhecido blogueiro [Scott Hanselman fez um blog post](http://www.hanselman.com/blog/AnnouncingRunningRubyOnRailsOnIIS8OrAnythingElseReallyWithTheNewHttpPlatformHandler.aspx) explicando como poderíamos usar esse módulo para servir uma aplicação Rails atrás do IIS 8. Depois de um comentário que fiz ele atualizou para demonstrar como servir uma aplicação Rails em cima do JRuby.

O HttpPlatformHandler é um módulo que há anos estava faltando no IIS, e não entendo a razão  de porque tanta demora. Todo servidor HTTP tinha um módulo desses por padrão (Apache, NGINX, etc), menos o IIS. E esse módulo é importante para poder repassar uma requisição HTTP do IIS para uma aplicação web que responde HTTP atrás dele (basicamente qualquer coisa que não é PHP, de Python/WSGI a Java). Antes disso era necessário usar um módulo desenvolvido por terceiros ou uma combinação de [ARR (Application Request Routing, que é um balanceador de carga) e URL Rewrite](http://www.gitshah.com/2013/06/how-to-use-iis7-as-front-end-to-java.html), que é tudo menos algo "plug-and-play".

Minha "teoria da conspiração" é que a Microsoft obviamente gostaria que o IIS fosse o único servidor de aplicação e qualquer coisa dinâmica deveria rodar dentro do controle de seus Application Pools, o que era verdade para ASP antigo e .NET. O resto ficaria relegado ao antigo (obsoleto) esquema de sub-processo por requisição de CGI/FastCGI (que é extremamente ineficiente).

Na verdade não precisamos do IIS se quisermos rodar uma aplicação Rails, Java ou qualquer outro no Windows: basta desabilitar o IIS (para não ocupar a porta 80) e fazer o JRuby on Rails/Puma ou Java/JBoss/Tomcat/etc subir na porta 80 e pronto. Por outro lado poderíamos querer executar uma aplicação ASP.NET MVC e outra em Java/JSF na mesma máquina, e aí começa a ficar mais complicado.

Um módulo de proxy-reverso é a solução nesses cenários: agora é possível executar aplicações em quaisquer linguagens na mesma máquina, todas coordenadas com o IIS 8, repassando a requisição quando ele mesmo não tiver como responder. Com a proposta do Azure de querer ser uma plataforma para muitas linguagens e projetos open source, esse componente era muito necessário para colocá-lo em pé de igualdade com NGINX e outros servidores web.

## Por que Rails (ou qualquer coisa diferente de .NET) no Windows?

Na realidade é a mesma resposta de "por que Java/Python/PHP/etc" no Windows. Na prática, eu diria que se você precisar muito se manter na plataforma Windows - e existem dezenas de razões legítimas pra isso - mantenha-se na stack do .NET, use ASP.NET MVC (ou o vNext que é o próximo). Faça web services com WCF, faça aplicações desktop com WPF. Muitas soluções corporativas precisam integrar diversos componentes como BizTalk, Exchange, Sharepoint, conectar exclusivamente com endpoints SOAP ou COM+ e nesses casos o melhor é ficar no nativo.

Usar algo diferente de .NET significa não somente mudar de linguagem, mas mudar de sistema operacional e toda uma forma de trabalhar e desenvolver que são completamente diferentes. Linguagens de script como PHP, Ruby, Python, Perl dependem bastante do sistema operacional por baixo. Algumas se esforçaram para oferecer mais suporte no Windows, mas eles nunca vão se comportar 100% da mesma forma em dois sistemas operacionais diferentes.

O [próprio Technet da Microsoft](https://technet.microsoft.com/en-us/library/bb496993.aspx) tem vários artigos detalhando as diferenças (tanto técnicas quanto filosóficas) e se procurar no Google vai achar centenas de artigos (muitos meramente pedantes e trolls, evite-os) detalhando mais sobre essas diferenças, principalmente nos aspectos de [segurança](http://www.kernelthread.com/publications/security/uw.html).

Extensões nativas precisam ser escritas levando em consideração APIs, chamadas de baixo nível de sistema muito diferentes. Windows e Linux/Unix são animais diferentes, gerenciam memória de formas diferentes, lidam com I/O (sistema de arquivos, rede) de formas diferentes. Daí é necessário programar uma "camada intermediária" que tenta abstrair as duas coisas. PHP é de longe o que tem mais "wrappers" prontos para ambos os sistemas, Python vem na sequência. Ruby não tem histórico de uso no Windows por isso tem menos wrappers.

Existem várias ferramentas do mundo Linux que um desenvolvedor no Windows não está acostumado a usar. Coisas que vão desde coisas simples como um simples wget ou curl até coisas mais complexas como GDB ou DTrace. Por isso mesmo não é simples para um programador Windows migrar para qualquer outra plataforma diferente de .NET. 

Mesmo assim, pode ser muito útil saber o básico de algumas linguagens pois daí é possível tirar vantagens de instalar um Wordpress (PHP), ou um Plone (Python) e até mesmo no caso de Rails usar aplicações excelentes como Redmine, Discourse, Spree, FatFreeCRM, e várias outras aplicações de código aberto, sem precisa duplicar esforços e refazê-los em .NET. Ou então usar as excelentes ferramentas que temos para criar CRUDs rápidos usando Rails + Devise + ActiveAdmin por exemplo. Existem várias razões para tirar proveito das excelentes ferramentas do ecossistema Rails que não existem no mundo ASP.NET MVC.

Por essas razões, o Ruby no Windows nunca será tão bom quanto o Ruby no Linux/OS X, nem mesmo PHP ou Perl será tão bom no Windows quanto é no Linux, no mesmo hardware. Um exemplo prático mais notável: [Windows não tem o conceito e nem a implementação de fork()](http://stackoverflow.com/questions/21732566/linux-fork-function-compared-to-windows-createprocess-what-gets-copied), algo essencial para nossos servidores de aplicação Ruby como Unicorn, Puma, Thin, etc. Por isso mesmo, rodar Rails usando o servidor padrão, Webrick, não é aceitável em produção. Ele vai ter um único processo e responder a apenas uma requisição de cada vez, sem possibilidade de responder conexões simultâneas.

Isso dito, no caso específico de Ruby, existe uma ótima solução e é [JRuby](http://jruby.org), que permite executar código Ruby dentro da máquina virtual Java. Em resumo, uma aplicação inteira feita em Ruby on Rails, com pequenas modificações (por exemplo, instalando o driver JDBC pra acessar banco de dados), pode ser executado no ambiente Java, com todas as vantagens que ele oferece como melhor performance e capacidade para multithreading real.

O motivo disso é que Java roda sobre a Java Virtual Machine (JVM) que, como o próprio nome diz, é literalmente uma máquina virtual (de um jeito tosco, pense nele como um VirtualBox, com outro sistema operacional rodando virtualmente). A JVM abstrai completamente o sistema operacional por baixo e é como se fosse um micro-sistema operacional próprio. De fato, já houve a tentativa de se fazer um [Java OS](http://en.wikipedia.org/wiki/JavaOS) inteiro que não necessitaria de um outro sistema como Linux ou Windows pra executar.

Feito isso, podemos colocar uma aplicação Rails, com boa performance, com boa concorrência, integrado com banco de dados como SQL Server ou Oracle, atrás do IIS, rodando lado a lado com aplicações feitas em .NET.

<a name="configuracao"></a>

## Configurando Rails da forma Correta para Windows

A partir daqui vou assumir que você é um desenvolvedor familiarizado com o ambiente Windows e sabe como usar [Web Platform Installer](http://www.microsoft.com/web/downloads/platform.aspx), onde procurar instaladores, não estranha em usar o Command Prompt e sabe como instalar os seguinte componentes básicos:

* IIS 8
* SQL Server 2008 R2
* Java 1.8

E antes de realmente começar precisamos configurar algumas coisas.

No caso de Java, também precisamos antes instalar o [Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy](http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html) que é um tosco arquivo zip cujos arquivos precisam ser manualmente copiados no diretório de policies do JRE:

![JCE](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/481/Screen_Shot_2015-02-13_at_14.13.41.png)

Depois disso precisamos fazer o SQL Server se ligar à porta TCP 1433. Para isso instale e abra o SQL Server Configuration Manager, habilite o TCP/IP e na tela de propriedades apague o que estiver em "TCP Dynamic Ports" e coloque "1433" em TCP Port. Precisa fazer isso em todos os campos.

![SQL Server Configuration Manager](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/482/Screen_Shot_2015-02-13_at_14.18.37.png)

Agora, baixe [meu código do Github](https://github.com/akitaonrails/jruby_windows_demo) em alguma pasta. Se não for diretamente dentro do C:\inetpub\wwwroot precisa adicionar o usuário IIS_IUSRS para ter acesso a todos os subdiretórios:

![Permissões](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/483/Screen_Shot_2015-02-13_at_14.16.34.png)

A partir de um Command Prompt, entre no diretório do projeto e execute:

```
jruby -S bundle install
```

Isso deve instalar todas as dependências que estão listadas no arquivo <tt>Gemfile</tt> cujas partes mais importantes são:

--- ruby
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.9'
# Use jdbcsqlite3 as the database for Active Record
gem 'jdbc-mssql-azure'
gem 'activerecord-jdbc-adapter'
gem 'activerecord-jdbcmssql-adapter'
# ...
gem 'puma'
gem 'jruby-openssl', require: false
# ...
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
```

As partes importantes:

* Use Rails 4.1 e não 4.2 pois muitas gems ainda não estão totalmente compatíveis até o momento deste post.
* Use [drivers JDBC](https://github.com/MikeEmery/jdbc-mssql-azure) pois estaremos rodando dentro da JVM, e para isso funcionar é necessário um [adapter de activerecord](https://github.com/jruby/activerecord-jdbc-adapter/tree/master/activerecord-jdbcmssql-adapter).
* Vamos usar [Puma](https://github.com/puma/puma) como servidor Web em vez do padrão Webrick, que é muito melhor por suportar multi-thread na JVM.
* Precisamos adicionar o pacote [jruby-openssl](https://github.com/jruby/jruby-openssl) pois o Windows não tem suporte nativo a OpenSSL e também o [tzinfo-data](https://github.com/tzinfo/tzinfo-data) pois o Windows também não tem dados de time zones facilmente acessíveis (lembram quando falei das várias coisas diferentes entre sistemas operacionais, estes são exemplos de pacotes pra cobrir buracos desse tipo).

Finalmente, configure uma nova aplicação no IIS dentro do Default Web Site, numa sub-pasta chamada "rails":

![IIS](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/484/Screen_Shot_2015-02-13_at_14.16.13.png)

Uma aplicação Rails, por padrão, não é feito para funcionar numa sub-pasta, mas este trecho no arquivo <tt>config.ru</tt> garante que isso vai funcionar:

--- ruby
Rails.application.config.relative_url_root = '/rails'

map Rails.application.config.relative_url_root || "/" do
  run Rails.application
end
```

Você vai precisar criar um banco de dados chamado "jruby_demo" ou outro nome que você pode configurar no arquivo <tt>config/database.yml</tt>. Note que você precisa modificar também o usuário e senha nesse arquivo para conseguir se conectar ao seu banco. Nesse caso significa que precisa usar [SQL Server Authentication](https://msdn.microsoft.com/en-us/library/ms144284.aspx) e não o padrão Windows Authentication.

--- yaml
default: &default
  adapter: jdbcmssql
  driver: com.microsoft.sqlserver.jdbc.SQLServerDriver
  url: 'jdbc:sqlserver://localhost;databaseName=jruby_demo'
  username: sa
  password: abcd1234
```

Se estiver configurado corretamente, agora podemos usar o processo de migrations do ActiveRecord para criar tabelas e subir dados de exemplo, executando o seguinte na linha de comando:

```
jruby -S rake db:migrate db:seed
```

Para o IIS 8 conseguir carregar corretamente o JRuby, você precisa configurar o arquivo <tt>Web.config</tt>:

--- XML
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <system.webServer>
        <handlers>
            <add name="httpplatformhandler" path="*" verb="*" modules="httpPlatformHandler" resourceType="Unspecified" requireAccess="Script" />
        </handlers>
        <httpPlatform stdoutLogEnabled="true" stdoutLogFile="rails.log" startupTimeLimit="60" startupRetryCount="5" processPath="c:\jruby-1.7.19\bin\jruby.exe"
                  arguments="-S puma --env production --dir C:\Users\Fabio\Projects\jruby_demo2 -p %HTTP_PLATFORM_PORT%">
            <environmentVariables>
                <environmentVariable name="JAVA_HOME" value="C:\Program Files\Java\jre1.8.0_31"/>
                <environmentVariable name="SECRET_KEY_BASE" value="4a8f4bb5de3637e9fab1f3c8fb6e3a787f60a811d6b36ff8d77a3371a31d19f7a93cfb48597d8263f46748c729b291a0277e6e819a869c4f8edf9445595e5548"/>
            </environmentVariables>
        </httpPlatform>
    </system.webServer>
</configuration>
```

Preste atenção aos diretórios no arquivo para refletirem onde estão essas coisas na sua máquina, sem isso estar correto, nada vai carregar.

Feito isso, você já deve conseguir carregar a URL "http://localhost/rails" num navegador. Como é JRuby a primeira requisição vai demorar alguns segundos pra carregar (até a JVM terminar de carregar). Mas depois disso vai ficar tudo rápido.

Uma coisa diferente entre o HttpPlatformHandler e um módulo normal de proxy-reverso é que além de fazer o papel de proxy reverso ele também controla o ciclo de vida da aplicação por trás, no caso o JRuby + Puma. E também controla em que porta a aplicação vai ficar escutando (pela variável de ambiente "HTTP_PLATFORM_PORT").

Sobre aplicações Rails, não se esqueça que todos tem um "SECRET_KEY_BASE" diferente. Sempre gere um novo através da linha de comando <tt>jruby -S rake secret</tt>.

Se tudo foi feito corretamente, você deveria conseguir ver o seguinte no navegador:

![JRuby Demo](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/485/Screen_Shot_2015-02-13_at_14.12.18.png)

A partir daqui você pode evoluir a aplicação, criar mais models, mais controller, adicionar frameworks CSS como Bourbon (pois o Asset Pipeline vai funcionar corretamente usando o [Rhino](https://github.com/mozilla/rhino) como runtime Javascript no lugar do V8).
