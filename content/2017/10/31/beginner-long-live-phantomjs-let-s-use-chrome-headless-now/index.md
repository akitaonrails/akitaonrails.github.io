---
title: "[Beginner] Long live PhantomJS, let's use Chrome Headless now"
date: '2017-10-31T19:48:00-02:00'
slug: beginner-long-live-phantomjs-let-s-use-chrome-headless-now
tags:
- beginner
- rubyonrails
- rails51
- nodejs
- selenium
- phantomjs
- chromium
- chromedriver
draft: false
---

If you do Feature Specs, the act of loading up a real app server and then a real headless browser to do real user feature testing, then you know [Capybara](https://github.com/teamcapybara/capybara/issues/1860) and one of its most well-known drivers, [Poltergeist](https://github.com/teampoltergeist/poltergeist/issues/882). Poltergeist wraps up PhantomJS, which is a well known WebKit-based headless browser.

But WebKit is known for being **very** complicated to deal with. So I can only imagine the nightmare to maintain PhantomJS, which is akin to main a full-blown web browser like Chrome or Safari.

So it's no wonder that when the Chrome team announced the availability of the [Chrome Driver](https://developers.google.com/web/updates/2017/04/headless-chrome), then the maintainer of PhantomJS [decided to step down](https://github.com/teampoltergeist/poltergeist/issues/882).

If you know the contributors of PhantomJS, say thank you, as it helped as build more solid user features.

That being said, fear not. You can easily replace Poltergeist/PhantomJS for Selenium WebDriver/Chrome Driver in your RSpec/Capybara setup.

My friend [Lucas Caton](https://www.lucascaton.com.br/2017/06/22/how-to-run-your-feature-specs-using-capybara-and-headless-chrome/) wrote about it in June this year. Follow his blog as well.

If you're using Linux with the Chromium browser, you don't need to install anything, as the Chrome Driver comes with Chromium. Otherwise, you need to install the proper packages for your operating system. For example, `brew install chromedriver` for OS X or `pacaur -S chromedriver` on Arch if you don't like to have Chromium around. You may need to [tweak your PATH on Ubuntu](https://askubuntu.com/questions/539498/where-does-chromedriver-install-to) though.

Rule of thumb: install Chromium.

In my case, this is what had to change:

--- diff
# Gemfile
- gem "poltergeist"
+ gem "selenium-webdriver"
+ gem "rspec-retry"
---

Then in the Capybara setup:

--- diff
Capybara.server = :puma # Until your setup is working
Capybara.server = :puma, { Silent: true } # To clean up your test output

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

Capybara.default_max_wait_time = 5 # you may want to increase this timeout if your app is heavy to load
---

In feature specs, sometimes either Rails itself takes a long while to load up, compile assets, etc and the first features spec may timeout. To avoid a failure in the test run, it's recommended to add the `rspec-retry` gem, as I did above, and add the following to your `spec/rails_helper.rb`:

--- ruby
require 'rspec/retry'

RSpec.configure do |config|
  ...
  # show retry status in spec process
  config.verbose_retry = true
  # Try twice (retry once)
  config.default_retry_count = 2
  # Only retry when Selenium raises Net::ReadTimeout
  config.exceptions_to_retry = [Net::ReadTimeout]
  ...
end
---

And that should be it. I didn't have to touch any of my feature specs and they all ran beautifully. So kudos to the respective teams that maintain Capybara, Selenium-WebDriver for supporting this.

If you're a Node.js developer as well, you probably used something like Casper, which is said to support Chrome Headless as well. But while we're at it, you should check out [Puppeteer](https://github.com/GoogleChrome/puppeteer) as well, from the Google team itself. It is a promise based library where you can code like this:

--- javascript
const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('https://example.com');
  await page.screenshot({path: 'example.png'});

  await browser.close();
})();
---

So yeah, Chrome Headless seems like a very good option as most users actually use the Chrome browser, so it means we should have more reliable feature specs and also web crawling tools.
