---
title: "[SmallTips] Running GitLab CI Runner Locally"
date: '2018-04-28T18:35:00-03:00'
slug: smalltips-running-gitlab-ci-runner-locally
tags:
- smalltips
- gitlab
draft: false
---

If there is one thing you should always do is to maintain your test suite. Every bug you fix, every new feature, you should add new tests.

I have been working very hard in past few weeks, quite literally coding non-stop, 7 days a week. Remember that "stop complaining you don't have time, what do you do from midnight to 6 AM?" thing? Yeah, won't apply to me.

And it's exactly when you're sleep deprived, exhausted when you start to add mistakes. Even though your code runs, locally, you will shoot yourself in the foot in one of those 3 AM coding spree sessions.

The test suite was really my sidekick, co-pilot, bringing me back to my senses whenever the night got too dark.

I maintain my own GitLab custom server for all my company's client and internal projects. Just a bit of paranoia, to make sure my code is owned by me alone. And GitLab is a fantastic tool. Even more so because it has [its own Continuous Integration companion](https://about.gitlab.com/features/gitlab-ci-cd/).

Just add your `.gitlab-ci.yml` file to your project, create a new branch, push it and create a Merge Request and the CI kicks in, with multiple [parallel jobs](https://docs.gitlab.com/ee/ci/yaml/#jobs)  if you want. Even when I was forgetting to run my tests, the CI would not let me fail.

Keeping a CI up and running does require you to stop and maintain your specs though. Sometimes you will wonder, why does a test run on your local machine but keeps failing in the CI server?

That's when its super useful to run the CI docker image locally, to iron out remaining environment dependent quircks.

And you can do just that by running the GitLab CI Runner itself. It will pick up your project's `.gitlab-ci.yml` and run it locally through docker. So whatever  problem you're seeing on the server will quite definitely happen locally as well. With the added benefit that you don't need to wait in line in case, there is a queue of jobs waiting to run (many developers working, not as many machines to chew the CI work immediately). And you won't be the one adding useless jobs to the same queue.

And, if you've followed my recommendations and installed the awesome Arch Linux distro (or my personal favorite derivative, Manjaro Gnome) you can easily install the runner through AUR like this:

```
pacaur -S gitlab-runner
```

Otherwise you will have to check your particular distro repos or download the binary from [here](https://gitlab.com/gitlab-org/gitlab-runner/blob/master/docs/install/bleeding-edge.md#download-the-standalone-binaries). For example:

```
wget https://gitlab-runner-downloads.s3.amazonaws.com/master/binaries/gitlab-runner-linux-amd64
sudo mv gitlab-runner-linux-amd64 /usr/local/bin
sudo chmod +x /usr/local/bin/gitlab-runner
```

Once you have it installed, let's say you have a snippet like this in your `.gitlab-ci.yml` configuration:

```yaml
backend:
  stage: test
  script:
    - ./bin/cc-test-reporter before-build
    - bundle exec rspec --exclude-pattern "**/features/**/*_spec.rb"
  after_script:
    - ./bin/cc-test-reporter after-build --exit-code $? || true
```

You can configure many test jobs to run in parallel. I recommend that you separate front-end related JS tests, Rspec/minitest back-end unit tests, Capybara-based feature tests, Brakeman related security checks, for instance. Each will run in parallel and you won't have to wait for everything to run if you're only interested in the JS tests, for example. So you have faster feedback and can start fixing immediately.

Locally, from your project root directory, just run:

```
gitlab-runner exec docker backend
```

Of course, this is assuming that you already have Docker installed and properly configured. If you don't make sure you read [Arch Wiki's excellent entry on Docker](https://wiki.archlinux.org/index.php/Docker#Installation) but it's basically installing the Docker package and adding yourself to the docker group.

This is it! Super easy, barely an inconvenience, and runner will do everything your GitLab CI server is doing.

One caveat is that unfortunately, it seems like you [don't have the ability to save cache or artifacts](https://gitlab.com/gitlab-org/gitlab-runner/issues/2409) between job runs (gems, npm packages, etc) so every time this local runner runs, it will start from scratch. This makes it less useful to run all the time, but it's still faster than pushing to the server and wait in line for your turn in a busy server.

Saved me a couple times already.
