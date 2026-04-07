---
title: "Iniciante: Longa Vida ao PhantomJS - Vamos Usar Chrome Headless Agora"
date: '2017-10-31T19:48:00-02:00'
slug: iniciante-longa-vida-ao-phantomjs-vamos-usar-chrome-headless-agora
translationKey: beginner-chrome-headless
aliases:
- /2017/10/31/beginner-long-live-phantomjs-let-s-use-chrome-headless-now/
tags:
- beginner
- rubyonrails
- rails51
- nodejs
- selenium
- phantomjs
- chromium
- chromedriver
- traduzido
draft: false
---

Se você faz Feature Specs — o processo de subir um servidor real da aplicação e um browser headless real para testar funcionalidades do ponto de vista do usuário — então você conhece o [Capybara](https://github.com/teamcapybara/capybara/issues/1860) e um dos seus drivers mais famosos, o [Poltergeist](https://github.com/teampoltergeist/poltergeist/issues/882). O Poltergeist encapsula o PhantomJS, que é um browser headless baseado em WebKit bastante conhecido.

Só que o WebKit é famoso por ser **muito** complicado de lidar. Então dá pra imaginar o pesadelo que é manter o PhantomJS, que é basicamente manter um browser completo como Chrome ou Safari.

Não é de espantar que, quando o time do Chrome anunciou a disponibilidade do [Chrome Driver](https://developers.google.com/web/updates/2017/04/headless-chrome), o mantenedor do PhantomJS [decidiu se afastar do projeto](https://github.com/teampoltergeist/poltergeist/issues/882).

Se você conhece os contribuidores do PhantomJS, agradeça a eles — o projeto nos ajudou a construir funcionalidades de usuário mais sólidas por anos.

Dito isso, não precisa se preocupar. É perfeitamente possível substituir Poltergeist/PhantomJS por Selenium WebDriver/Chrome Driver no seu setup de RSpec/Capybara.

Meu amigo [Lucas Caton](https://www.lucascaton.com.br/2017/06/22/how-to-run-your-feature-specs-using-capybara-and-headless-chrome/) escreveu sobre isso em junho deste ano. Vale acompanhar o blog dele também.

Se você usa Linux com o browser Chromium, não precisa instalar nada — o Chrome Driver já vem com o Chromium. Caso contrário, instale os pacotes adequados para o seu sistema operacional. Por exemplo: `brew install chromedriver` no OS X, ou `pacaur -S chromedriver` no Arch Linux se preferir não ter o Chromium instalado. No Ubuntu, talvez seja necessário [ajustar seu PATH](https://askubuntu.com/questions/539498/where-does-chromedriver-install-to).

Regra geral: instale o Chromium.

No meu caso, as mudanças foram as seguintes:

```diff
# Gemfile
- gem "poltergeist"
+ gem "selenium-webdriver"
+ gem "rspec-retry"
```

Depois, na configuração do Capybara:

```diff
Capybara.server = :puma # Até o setup funcionar
Capybara.server = :puma, { Silent: true } # Para limpar o output dos testes

- Capybara.register_driver :poltergeist do |app|
-   options = {
-     timeout: 3.minutes,
-     phantomjs_options: [
-       '--proxy-type=none',
-       '--load-images=no',
-       '--ignore-ssl-errors=yes',
-       '--ssl-protocol=any',
-       '--web-security=false'
-     ]
-   }
-   Capybara::Poltergeist::Driver.new(app, options)
- end
- Capybara.javascript_driver = :poltergeist

+ Capybara.register_driver :chrome do |app|
+   capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
+     chromeOptions: {
+       args: %w[ no-sandbox headless disable-popup-blocking disable-gpu window-size=1280,1024]
+     }
+   )
+ 
+   Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
+ end
+ 
+ Capybara::Screenshot.register_driver :chrome do |driver, path|
+   driver.save_screenshot(path)
+ end
+ 
+ Capybara.javascript_driver = :chrome

Capybara.default_max_wait_time = 5 # aumente esse timeout se sua aplicação for pesada para carregar
```

Em feature specs, às vezes o próprio Rails demora um pouco para subir, compilar assets e tal, e o primeiro spec pode dar timeout. Para evitar falha na execução dos testes, recomendo adicionar a gem `rspec-retry` como fiz acima, e incluir o seguinte no seu `spec/rails_helper.rb`:

```ruby
require 'rspec/retry'

RSpec.configure do |config|
  ...
  # mostra o status de retry no processo do spec
  config.verbose_retry = true
  # Tenta duas vezes (repete uma vez)
  config.default_retry_count = 2
  # Faz retry apenas quando o Selenium lança Net::ReadTimeout
  config.exceptions_to_retry = [Net::ReadTimeout]
  ...
end
```

E é isso. Não precisei alterar nenhum dos meus feature specs e todos rodaram perfeitamente. Parabéns às equipes que mantêm o Capybara e o Selenium-WebDriver por suportarem essa mudança.

Se você também desenvolve em Node.js, provavelmente já usou algo como o Casper, que dizem suportar Chrome Headless também. Mas já que estamos no assunto, vale muito conferir o [Puppeteer](https://github.com/GoogleChrome/puppeteer), da própria equipe do Google. É uma biblioteca baseada em Promises onde você escreve código assim:

```javascript
const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('https://example.com');
  await page.screenshot({path: 'example.png'});

  await browser.close();
})();
```

Então sim, o Chrome Headless parece uma ótima opção — afinal, a maioria dos usuários já usa o Chrome, o que significa que teremos feature specs mais confiáveis e ferramentas de web crawling mais robustas.
