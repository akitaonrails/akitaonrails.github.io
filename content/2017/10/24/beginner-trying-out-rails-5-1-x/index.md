---
title: "[Beginner] Trying out Rails 5.1.x"
date: '2017-10-24T16:29:00-02:00'
slug: beginner-trying-out-rails-5-1-x
tags:
- beginner
- rubyonrails
- rails51
- nodejs
- webpack
- reactjs
draft: false
---

One thing that is not so great about having to deal with client projects is that most of them take their time before doing a full framework upgrade. And you can't blame them, as many of the dependencies in the ecosystem take their sweet, sweet time to upgrade either.

[Rails 5.2 Beta](http://weblog.rubyonrails.org/2017/9/29/this-week-in-rails-getting-closer-to-rails-5-2-beta/) is almost upon us, and I would bet that most of the Rails projects out there are in the 4.2 version, still thinking about doing the jump to 5.0 (which is not so bad an upgrade).

By the way, in case you didn't know, the official Rails Guides website has a section dedicated to upgrades. It's called [A Guide for Upgrading Ruby on Rails](http://guides.rubyonrails.org/upgrading_ruby_on_rails.html). The process of upgrading is not actually so difficult **if, and only if**:

- You have a fairly good test coverage. You should have, at the very least, feature specs for the most important parts of your system.

- You should upgrade to just one subsequent version at a time, never going straight to the most recent one. For example, If you're in Rails 4.1, you must first upgrade to 4.2, make sure everything works. Then go to 5.0. And only then go to 5.1. Each version has **many** deprecations, changes in behavior, changes in default boilerplate configuration, added new features. You must attend to each very carefully.

So, what are you missing if you're still in Rails 4.2?

Again, in case you didn't know, the official Rails Guides website also compiles detailed and easy to read Release Notes for each new version. The most recent are the [Ruby on Rails 5.1 Release Notes](http://guides.rubyonrails.org/5_1_release_notes.html).

## Starting a new project

The `rails new` command has a lot of new flags. And I think these are the ones most people will use:

```
rails new --skip-action-mailer --skip-coffee --webpack=react my_fancy_new_project
```

You can disable features you don't need such as ActionMailer or actionable. You can disable CoffeeScript. It was cool for a while but now that ES6 exists we should just use it.

Rails 5.1 comes with the support for webpack. But until Rails 5.2 comes up, we need to use the `webpack-dev-server` manually in development mode so we can hot reload assets. For that end, I recommend installing good old [Foreman](https://github.com/ddollar/foreman). Install it like this:

```
gem install foreman
```

And add a `Procfile.dev` file to your project with the following content:

```
web: ./bin/rails s -b 0.0.0.0 -p 3000
webpack: ./bin/webpack-dev-server
```

And now you can start up your development server like this:

```
foreman start -f Procfile.dev
```

In production, you don't need the `webpack-dev-server` as the `bin/rails assets:precompile` task should be able to compile all the assets you need as static, timestamped files in `public/assets`.

## Front-end Specific Changes

Now, you can rejoice with Yarn, Webpack, and no more jQuery pre-installed. Samuel Muller has a [nice article](http://samuelmullen.com/articles/embracing-change-rails51-adopts-yarn-webpack-and-the-js-ecosystem/) that summarizes most of these changes in more detail.

Now Ruby on Rails officially supports every bells and whistle from the Javascript ecosystem. There is nothing left behind that you might miss.

No more manually vendoring JS assets in `vendor/assets/javascripts` directory. No more need to use [Rails Assets](https://rails-assets.org/), which was a secondary RubyGems source specific to package JS libraries into RubyGems.

Let's say that, for some reason, you want jQuery back. You can now just do:

```
yarn add jquery
```

And, as usual, you can simply add it to your `app/assets/javascripts/application.js` manifest file:

```
// app/assets/javascripts/application.js
...
//= require jquery
...
//= require_tree .
```

The so-called ["support for Yarn in Rails 5.1"](https://github.com/rails/rails/pull/26836) boils down to a few wrappers and boilerplate. So you can run `rails yarn:install` and have the dependencies installed, but you can just as easily type `yarn` and it will install everything you need that is declared in the `package.json` file, as with any other Javascript-only project.

Now, the whole magic of the integration comes from the inclusion of the [Webpacker](https://github.com/rails/webpacker) gem. It adds a bunch of boilerplate configuration for webpack. And, **bonus fact** you can include it today in your current Rails 4.2+ projects as well. Just start by adding the webpacker gem to your `Gemfile`:

```
# Gemfile
gem 'webpacker', '~> 3.0'
```

Then `bundle install` as usual and run:

```
bundle exec rake webpacker:install
```

If you didn't use the `--webpack=react` flag to the `rails new` command, you can add it later. Or you can add Angular as well:

```
bundle exec rake webpacker:install:angular
bundle exec rake webpacker:install:react 
```

You should replace `bundle exec rake` for `bin/rails` if you're in Rails 5.1.

Adding proper React components is a bit more than the command above though. And the details are more than I want to cover in this post.

Andy Barnov has a [good post](https://x-team.com/blog/get-in-full-stack-shape-with-rails-5-1-webpacker-and-reactjs/) on how to follow the Rails 5.1 packs convention to add your React components in the pipeline. As he recommends, don't fight the conventions and you should be golden.

Oddly enough, even though I used the `--webpack-react` flag to the `rails new` I still had to run the following command to bootstrap the webpack and react supports:

```
./bin/rails webpacker:install:react
```

But once you do, you will get a new place to add React components, and that's in a proper `app/javascripts/packs`. And in the views, instead of the usual `javascript_include_tag` you will use the brand new `javascript_pack_tag`. I believe you can figure out the rest from the example component `hello_react.jsx` that it generates for you.

## Final Thoughts

You now have a whole lot more options for Javascript, as Rails 5.1 fully embraces the current standards.

Once upon a time, no one properly knew how to streamline an [Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html). It was very messy to compile all your assets in a single file with proper cache busting timestamps, but the **Sprockets** gem did it.

Once upon a time, Javascript 5 was a damn mess. Libraries such as JQuery actually "fixed" most of the browsers DOM situation, and CoffeeScript normalized the language in a way that made it enjoyable. ES6 came to take over the reigns but it's very unfair to criticize JQuery and Coffee as neither ES6 nor HTML5 were there to solve the situation almost 10 years ago. JQuery and Coffee were there, and they solved it.

When Angular, Ember, React was starting, we already had a good enough solution javascript heavy website with [Turbolinks](https://github.com/turbolinks/turbolinks). This is still a very good solution that you should consider using instead of adding a full-blown (and sometimes unnecessary) React/Redux solution at once.

CSS is another matter entirely. The Rails community also created Sass (which then Twitter envied and copied to Less for the Bootstrap framework).

It's easy to see the current landscape and just repeat that Coffee is bad or Sprockets is bad. But for the past 10 years, those tools were the best of breed in a time where people didn't have Yarn, Webpack, React and all the tools that popped up in the past 3 years or so.

Rails 5.1 is a very good release to marry the best of Rails with the best that kinda stabilized today in the Javascript mad arena. And I highly recommend that any new, greenfield project, start with Rails 5.1 in mind.

One thing that led me to write this post is to highlight that many people ask questions that are mostly answered in the official [Rails Guides](http://guides.rubyonrails.org/). Not only on how to install and use the many components of the framework but also how to upgrade and what the new features of each release are. So you should definitely take a better look there.
