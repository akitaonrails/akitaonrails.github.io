---
title: Segurança em Rails
date: '2014-05-22T11:39:00-03:00'
slug: seguranca-em-rails
tags:
- learning
- beginner
- rails
- security
draft: false
---

O assunto segurança é bem complicado, este post não tem a intenção de ser a fonte completa de tudo relacionado a segurança no mundo Ruby on Rails mas apenas listar algumas informações e ferramentas úteis. Antes de começar alguns links importantes que, se você ainda não conhecia, precisa ter nos seus favoritos:

* [Ruby on Rails Security Guide](http://guides.rubyonrails.org/security.html) - este é o guia oficial básico sobre as diversas brechas de segurança que o Rails, por padrão, já previne mas que você pode desativar acidentalmente. É o "Hello World" da segurança, como Session Hijacking, CSRF, SQL Injection, XSS, etc.

* [Ruby on Rails Security Group](https://groups.google.com/forum/#!forum/rubyonrails-security) - este é o grupo oficial de segurança. Toda vez que uma nova vulnerabilidade é corrigida é aqui que primeiro aparece seu anúncio e você pode avaliar os detalhes para saber se precisa atualizar sua aplicação imediatamente ou não.

* [Brakeman](http://brakemanscanner.org/) - como disse antes, você pode se descuidar e deixar passar um string com interpolação que pode causar um SQL Injection, por exemplo. Para evitar isso execute este scanner de tempos em tempos. O Code Climate implementa o Brakeman para dar as mesmas métricas de brechas de segurança.

* [RubySec](http://www.rubysec.com/) - mantém um banco de dados de vulnerabilidades não só do framework Ruby on Rails mas de diversas Rubygems que usamos todos os dias. E daqui vem uma das ferramentas que vou sugerir neste artigo.

Aliás, um comentário sobre o termo. Nunca se pode dizer _"minha aplicação está segura"_, o máximo que podemos dizer é _"minha aplicação parece não ter nenhuma vulnerabilidade conhecida."_ Só porque você não conhece, não significa que as vulnerabilidades não existam, e as chances são que existam e você simplesmente a ignora. O único tipo de aplicação "segura" é aquela que está completamente off-line numa localização geográfica desconhecida em um bunker anti-nuclear. Tirando isso, qualquer outra coisa é "quebrável".

## Bundler Audit

Como disse antes, não é fácil manter um projeto. Depois de algum tempo as gems são atualizadas e você não fica sabendo disso. Quando são apenas adições de algumas novas funcionalidades, não há com o que se preocupar, mas como você fica sabendo se uma das dezenas de gems que sua aplicação utiliza recebeu atualizações de segurança.

Para isso o pessoal do RubySec mantém um banco de dados, o [Ruby Advisory DB](https://github.com/rubysec/ruby-advisory-db/) que concentra e organiza os diversos security advisories. Você pode contribuir se tiver gems de código aberto que receberam contribuições para fechar vulnerabilidades.

E para quem quer automatizar o processo de encontrar esses advisories, o RubySec também tem o [Bundler Audit](https://github.com/rubysec/bundler-audit). Ele funciona usando o Advisory DB e cruzando com as versões específicas de gems que estão listadas no <tt>Gemfile.lock</tt> do seu projeto.

Apenas instale a gem com 

```
gem install bundler-install
```

E execute a partir da raíz do seu projeto:

```
bundle-audit
```

Ele vai lhe dar uma saída parecida com esta:

```
Insecure Source URI found: git://github.com/Codeminer42/axlsx.git
Name: actionpack
Version: 3.2.16
Advisory: OSVDB-103440
Criticality: Unknown
URL: http://osvdb.org/show/osvdb/103440
Title: Denial of Service Vulnerability in Action View when using render :text
Solution: upgrade to >= 3.2.17

Name: actionpack
Version: 3.2.16
Advisory: OSVDB-103439
Criticality: Unknown
URL: http://osvdb.org/show/osvdb/103439
Title: XSS Vulnerability in number_to_currency, number_to_percentage and number_to_human
Solution: upgrade to ~> 3.2.17, ~> 4.0.3, >= 4.1.0.beta2

Name: mini_magick
Version: 3.5.0
Advisory: OSVDB-91231
Criticality: High
URL: http://osvdb.org/show/osvdb/91231
Title: MiniMagick Gem for Ruby URI Handling Arbitrary Command Injection
Solution: upgrade to >= 3.6.0

Name: nokogiri
Version: 1.5.10
Advisory: OSVDB-101458
Criticality: Unknown
URL: http://www.osvdb.org/show/osvdb/101458
Title: Nokogiri Gem for Ruby External Entity (XXE) Expansion Remote DoS
Solution: upgrade to ~> 1.5.11, >= 1.6.1

Name: nokogiri
Version: 1.5.10
Advisory: OSVDB-101179
Criticality: Unknown
URL: http://www.osvdb.org/show/osvdb/101179
Title: Nokogiri Gem for JRuby Crafted XML Document Handling Infinite Loop Remote DoS
Solution: upgrade to ~> 1.5.11, >= 1.6.1

Unpatched versions found!
```

Seguindo o exemplo acima, precisaríamos fazer o seguinte:

```
bundle update nokogiri mini_magick rails
```

Você pode precisar alterar o arquivo <tt>Gemfile</tt> se a versão específica estiver declarada antes de realizar o <tt>update</tt>. E depois rode o <tt>bundle-audit</tt> novamente para ter certeza que está tudo bem. Apenas cuidado com os casos onde você aponta diretamente para um repositório do Github em vez do Rubygems.org, pois ele não tem como checar se o que você está puxando do Github tem vulnerabilidades conhecidas ou não.

Para atualizar seu bundler-audit antes de realizar um novo scan, faça:

```
bundle-audit update
```

## Bônus: Rack-Attack

Além da análise estática de código para avaliar segurança, uma adição que pode ser interessante dependendo do tipo de site que você usa é o [Rack-Attack](https://github.com/kickstarter/rack-attack).

Digamos que avaliando seus logs você perceba que seu site está sendo muito consumido por web scrappers, robôs do tipo que ficam capturando seu conteúdo. Se for robôs de motores de busca como Google, Bing, tudo bem, mas você vai encontrar mais do que isso. 

Imagine que além de scrappers consumindo demais, você tenha tentativa de ataques de força-bruta, como scripts automatizados tentando diversas combinações de usuários e senhas até conseguir acertar um.

Ou imagine simplesmente que você quer ou criar uma lista de IPs que você quer permitir (se seu site estiver em beta fechado, por exemplo) ou uma lista negra que você já sabe que quer bloquear.

Tudo isso pode ser feito diretamente no web server ou balanceador de carga. Mas se você estiver fazendo deployment em ambientes fechados como Heroku, não vai ter acesso à essa configuração.

Para isso existe o Rack::Attack, que é um middleware Rack que você instala de modo simples diretamente na sua aplicação Rails e pode customizá-lo de diferentes formas. A instalação básica é simples. Apenas acrescente à sua <tt>Gemfile</tt>:

```ruby
gem 'rack-attack'
```

E adicione ao arquivo <tt>config.ru</tt>, antes da linha do comando <tt>run</tt>:

```ruby
use Rack::Attack
```

E se quiser customizar, comece adicionando o arquivo <tt>config/initializers/rack-attack.rb</tt> com o seguinte:

```ruby
class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new # defaults to Rails.cache
end
```

A [documentação](https://github.com/kickstarter/rack-attack) no Github tem muito mais detalhes. Nos aspectos de detectar padrões de invasão por força bruta ele se inspira no famoso [fail2ban](http://www.fail2ban.org/wiki/index.php/MANUAL_0_8#Jail_Options) (que você pode usar para proteger, por exemplo, o [SSH](https://www.digitalocean.com/community/articles/how-to-protect-ssh-with-fail2ban-on-ubuntu-12-04) de seu servidor).

Vale a pensa aprender mais sobre esse assunto.
