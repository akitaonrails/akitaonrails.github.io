---
title: Choosing MatterMost over Rocket.chat and Slack
date: '2016-08-13T22:41:00-03:00'
slug: choosing-mattermost-over-rocket-chat-and-slack
tags:
- mattermost
- docker
- golang
- rocket.chat
- slack
draft: false
---

I am a technologist, basically a nerd. So when I obsess over technical stuff, no matter how small, I just can't sleep calmly until I find reasonable closure.

My team, my clients, we've been happily using Slack for more than 2 years, as I believe was true for many teams around the world. Although no one ever complained, I was always annoyed by the small things. First of all, as everything of value, it costs. Either I pay USD 6.67/month/user or I live with the restrictions of the free plan. And as most other teams, I lived with the restrictions for as long as I could.

For example, to get rid of the warnings to upgrade because we hit the upload limits, I created a small tool called [slack_cleanup](https://github.com/akitaonrails/slack_cleanup) (first in Elixir, and then in [Crystal](https://github.com/akitaonrails/cr_slack_cleanup) just for exercise). This helped for a while.

Our team kept growing, steadily, frequently, as well as clients. The more users we add, the more conversations, the faster we hit the restrictions. History gets lost more frequently, we need to clean up uploads more often. It gets old very fast.

One thing I value above everything is knowledge. As an small example, I myself keep multiple backups for all my emails, all my projects, all my assets that I produced in the last 20 years. Heck, I have a 6 TB, Raid-5, Drobo system right in my home desk and 3 extra 1TB external drives for backup. I've lost very little over the years.

It really annoys me when I lose information.

* Gmail Business, DropBox, AWS S3 buckets, being external services, don't worry me because I keep copies of everything offline. So if those accounts get busted all of a sudden, I have multiple copies.

* GitHub annoyed me a bit because although I have multiple copies of the repositories, I would lose all the Pull Request, Issues history. That's one reason I moved to my own GitLab and helped tweak the import process to grab those Pull Request history.

* Slack annoys me a lot for the aforementioned reasons, which is why last week we tried both MatterMost first, and then we deployed Rocket.chat.

![Mattermost](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/558/big_8_13_16__22_20.png)

### There, and Back Again

We moved from Slack to Rocket.chat and a couple of days latter we are moving again, now to Mattermost.

Yes, this was cumbersome. My team was not very happy for leaving Slack. Slack really is slick, full-featured, good-looking, well-rounded, a proper web product for this generation. Any alternative should be at least almost as good-looking, and at least have bug-free features, including webhooks.

Mattermost fits the bill almost perfectly but the open sourced Team Edition lacked one important feature for me: the ability to disallow normal members to rename and/or delete private groups. Yes, we expect grown-ups to behave, but when you have remote teams, remote clients, external users with no commitment to the company, it's a hassle.

Yes, I could and I probably should use the payed Enterprise Edition. But for just that small feature, it felt too expensive. So that triggered me to let it go and install Rocket.chat instead. I moved my entire team there (almost 50 people, because I didn't move the clients yet). That would be the end of the story.

But Rocket.chat has both a complex infrastructure to deal with (you must have at the very least 3 boxes or pay extra for a proper Mongodb SaaS). Actually, [in my previous post](http://www.akitaonrails.com/2016/08/09/moving-away-from-slack-into-rocket-chat-good-enough) I explained why you MEAN guys should not be careless dealing with Mongodb. In a nutshell: Mongodb was not meant to run in a single instance, you must have a replica set. If you have a single instance Mongodb, you're doing it wrong.

And the most problematic: the client-side is just too heavy. It frequently spikes out the CPU in not so powerful machines. It's noticeably and measurably slower to navigate in its UI, compared to Slack. MatterMost UI was much faster and way more responsive.

I was almost willing to overlook the lack of a proper test suite. I was willing to try to live with Meteor and CoffeeScript. I was willing to deal with the complex MongoDB maintenance.

But slow responsiviness across many of the members of my team is a no-go, a big show-stopper. We turned the beta videochat feature off (as it always triggers CPU spikes across all users), but many members still had a bad experience with a UI that was too slow and a resource hog.

The React-based, ES6-written, properly structured - with good enough client-side test suites - MatterMost was a more suitable candidate. So I decided to really think about the original problem and I came about with a simple solution: [add a simple PLPGSQL function](http://www.akitaonrails.com/2016/08/12/hacking-mattermost-team-edition) to be triggered whenever someone tried to delete a channel. Sure enough, it worked. And that prompted me to call my team again and propose this new change: I believe everybody was on-board as MatterMost was way faster on their machines.

I know I am sounding really harsh towards Rocket.chat, and it's really not my intention. If we didn't have any other options, we would still move to Rocket.chat. But as Mattermost proved to be the better choice, it was a no-brainer.

### MatterMost Install

As always, I will not bore you with instructions that are already available online. If you want to install everything manually, follow [this tutorial](https://docs.mattermost.com/install/prod-ubuntu.html), but a better option would be [the Docker-based deployment](https://docs.mattermost.com/install/prod-docker.html). You can even install/upgrade it [together with GitLab](http://docs.gitlab.com/omnibus/gitlab-mattermost/).

Make sure you have NGINX in front of the server and that you have both a properly registered domain or sub-domain, and that you have SSL - use Let's Encrypt.

Because I want to keep tweaking and experimenting with the codebase in a live installation, I installed everything manually and I have this directory structure:

```
-rw-r--r--  1 mattermost mattermost     6504 Aug 13 20:11 config.json
drwxrwxr-x  5 mattermost mattermost     4096 Aug 13 20:30 data
lrwxrwxrwx  1 mattermost mattermost       33 Aug 13 20:13 mattermost -> mattermost-team-3.3.0-linux-amd64
drwxr-xr-x  9 mattermost mattermost     4096 Aug 13 20:28 mattermost-team-3.2.0-linux-amd64
-rw-rw-r--  1 mattermost mattermost 19968308 Jul 14 16:37 mattermost-team-3.2.0-linux-amd64.tar.gz
drwxr-xr-x 11 mattermost mattermost     4096 Aug 13 20:28 mattermost-team-3.3.0-linux-amd64
-rw-rw-r--  1 mattermost mattermost 20241448 Aug 12 20:41 mattermost-team-3.3.0-linux-amd64.tar.gz
drwxrwxr-x  3 mattermost mattermost     4096 Aug 13 20:23 platform-dev-3.3.0
-rw-r--r--  1 mattermost mattermost 18060203 Aug 13 20:22 platform-dev.tar.gz
```

So I have a restricted, sudo user `mattermost` and I have a main `mattermost` directory pointing to the binary packages you will find in the [official download page](https://www.mattermost.org/download/).

Notice that I have a copy of `mattermost/config/config.json` in the home directory. I leave it there so every time I download a new version and redo the symlink to `mattermost`, I can just do:

```
rm -Rf ~/mattermost/config/config.json
cd ~/mattermost/config
ln -s ~/mattermost/config.json
```

Also make sure you change at least the following in the config:

```
...
"FileSettings": {
    "MaxFileSize": 83886080,
    "DriverName": "local",
    "Directory": "/home/mattermost/data",
...
```

If you want, you can set file uploads to go to some S3 bucket you have, and just fill in the AWS details. But if you choose to have them locally, change the directory to somewhere outside of the `mattermost` folder, as in every upgrade you will change the folder. With both AWS EC2 or Digital Ocean you can always choose to add a secondary volume that can outlive the virtual boxes, so even if you get to a point where you have hundreds of concurrent users and you want to scale horizontally, you can have all your boxes pointing to a shared volume (AWS EFS, for example).

Speaking of which, in this configuration, upgrading would be like this:

```
sudo service mattermost stop
wget https://releases.mattermost.com/x.y.z/mattermost-team-x.y.z-linux-amd64.tar.gz
tar xvfz mattermost-team-x.y.z-linux-amd64.tar.gz
mv mattermost mattermost-team-x.y.z-linux-amd64
ln -s mattermost-team-x.y.z-linux-amd64 mattermost
rm -Rf mattermost/config/config.json
rm -Rf mattermost/data
cd mattermost/config
ln -s ~/config.json
cd ..
ln -s ~/data
sudo service mattermost start
```

The reason I wanted to have it this way is because I can tweak the code and manually push the changes.

For your development machine you should follow [this instruction](https://docs.mattermost.com/developer/developer-setup.html). If you're in OS X and you choose to use Docker Toolbox, remember that you don't need VirtualBox anymore as it will use OS X's native hypervisor now. In my machine, I had to add `dockerhost` manually in my `/etc/hosts` because `boot2docker` was failing to get my ip address.

Then you can just clone the code from Github:

```
mkdir mattermost
cd mattermost
git clone https://github.com/mattermost/platform
git checkout -b v3.3.0 v3.3.0
```

Remember to always checkout the correct stable version (v3.3.0 as of the time when I originally posted this article) that you have installed in your server. Again, I will not bore you with what's already documented in the links above, but you must have Go 1.6(.3), Docker, Docker-Composer, Docker-Machine all installed already.

You can execute `make run` and after it finishes (and as usual, npm will make sure it takes a very long time) you can open `http://localhost:8065` to play with it locally.

Most importantly: you can tweak the React JSX components from `platform/webapp/components`, for example, the `channel_header.jsx` and add stuff like this:

```javascript
# line 493 from v3.3.0
if(isAdmin || isSystemAdmin) {
    dropdownContents.push(
        <li
            key='rename_channel'
            role='presentation'
        >
            <a
                role='menuitem'
                href='#'
                onClick={this.showRenameChannelModal}
            >
                <FormattedMessage
                    id='channel_header.rename'
                    defaultMessage='Rename {term}...'
                    values={{
                        term: (channelTerm)
                    }}
                />
            </a>
        </li>
    );

    if (!ChannelStore.isDefault(channel)) {
        dropdownContents.push(deleteOption);
    }
}
```

And you know what this will do? Remove the "Rename Group" and "Delete Group" options from the channel menu if the user is not a system admin. Now how do you put this in your server?

First of all, you have to edit the `Makefile` at this section:

```
@# Make osx package
@# Copy binary
cp $(GOPATH)/bin/darwin_amd64/platform $(DIST_PATH)/bin
@# Package
tar -C dist -czf $(DIST_PATH)-$(BUILD_TYPE_NAME)-osx-amd64.tar.gz mattermost
@# Cleanup
rm -f $(DIST_PATH)/bin/platform

@# Make windows package
@# Copy binary
cp $(GOPATH)/bin/windows_amd64/platform.exe $(DIST_PATH)/bin
@# Package
tar -C dist -czf $(DIST_PATH)-$(BUILD_TYPE_NAME)-windows-amd64.tar.gz mattermost
@# Cleanup
rm -f $(DIST_PATH)/bin/platform.exe

@# Make linux package
@# Copy binary
cp $(GOPATH)/bin/platform $(DIST_PATH)/bin
@# Package
tar -C dist -czf $(DIST_PATH)-$(BUILD_TYPE_NAME)-linux-amd64.tar.gz mattermost
@# Don't cleanup linux package so dev machines will have an unziped linux package avalilable
@#rm -f $(DIST_PATH)/bin/platform
```

Notice that the developer that made this file is probably using Linux. That's because this file build the Linux-ELF binary as `bin/platform`, while the OS X Mach-O binary will be at `bin/darwin_amd64/platform`. Now, if like me you're on OS X, you have to inverse this and make the Linux version point to `bin/linux_amd64/platform`, otherwise the packages will have the wrong binary.

Then you will notice that there is this section right at the bottom:

```
setup-mac:
    echo $$(boot2docker ip 2> /dev/null) dockerhost | sudo tee -a /etc/hosts
```

If you're on the newest versions of Docker-Toolbox, you don't need boot2docker anymore, it will use docker-machine instead. So this line doesn't work and the easiest way to make `make test` run is to change the `dockerhost` to `localhost` in the `config/config.json`'s PostgreSQL configuration.

If the tests are all passing, you can now run `make package` to make all packages, then you can send the `dist/mattermost-team-edition-linux-amd64.tar.gz` to your server and uncompress to the correct location.

As a sidenote for Go noobies like myself, I had my `GOPATH` pointed to `/Users/akitaonrails/.go` and my project was at `/Users/akitaonrails/codeminer42/mattermost/platform`. I was told that this is incorrect and the source of my many hours of frustration. The project MUST BE INSIDE THE GOPATH.

So I changed my `GOPATH` to `/Users/akitaonrails/Sites/go` and the project to `/Users/akitaonrails/Sites/go/src/github.com/mattermost/platform` and now it works. I would probably had symlinked the project path to be inside the GOPATH as well. But now everything compiles and runs just fine.

This is how I will keep experimenting for the time being, until I feel that I am comfortable enough to automate the whole process later. This should work just fine for my team for the time being.

Of course, the snippet above is nothing but a **dirty hack**, don't try to contribute like this. A proper implementation would require me to at least create a new setting into the `config.json`, for example `TeamSettings.MembersCanManageChannel` to `false`, and change the `api/context.go` around line 347 to be something like this:

```ruby
func (c *Context) HasPermissionsToTeam(teamId string, where string) bool {
    if c.IsSystemAdmin() {
        return true
    }

    if !utils.cfg.TeamSettings.MembersCanManageChannel {
        return false
    }
    ...
```

Then change the `webapp/channel_header.jsx` component in the React front-end (as well as a proper unit tests to `webapp/tests/client_channel.test.jsx`), make sure the `make test` passes, and then finally create a feature request to the core team.

But the idea here was just to show that it was not so difficult to solve the show-stopper for my particular scenario, both using the [SQL trigger](http://www.akitaonrails.com/2016/08/12/hacking-mattermost-team-edition) to safeguard the database and the hack to fix the Web UI.

### Conclusion

But what about the most important feature of all? RightGIF support? There is nothing as simple as a rightgif slack command just yet. Fortunately you can compensate most missing niceties like this by installing a [Hubot server](https://www.npmjs.com/package/hubot-mattermost), and linking it to a user so you can chat with the bot and make it do things for you (set an alarm, fetch a gif, translate text, etc). As a caveat, the hubot adapter requires the use of the [mattermost-client](https://github.com/loafoe/mattermost-client) which must be synced with the server platform version releases to work properly, so be careful when you're upgrading.

Overall, Mattermost is a great choice. It's not for amateurs as well, the development environment requires you to know your Docker stuff. It requires you to know proper Go-lang configuration. It requires you to follow [proper procedures to contribute](https://docs.mattermost.com/developer/contribution-guide.html), as they should. The project itself is a single codebase divided into roughly 2 applications, a Go-based HTTP API and a React-based front-end to consume the APIs. Everything about the project is automated through the proper usage of Docker images (for mysql, postgresql, openldap instances) and Makefiles to run the test suite, create packages, etc.

And it has some conveniences from Slack that Rocket.chat doesn't have yet such as a simple shortcut to switch channels (Cmd-K), the ability to reply messages and organize them as threads, proper and more complete Markdown support. Overall, the features are well-rounded, and not half-baked. What is there is solid and works, it's always bad to have half-finished features.

With these hacks in mind I can strongly recommend that you use Mattermost. And as I said in previous posts, it's not just a matter of cost. If you're a small team, without internal developers or someone that can maintain your own installation, you should definitely pay Mattermost for the Enterprise support, it's affordable and way cheaper than Slack.

For now, it's the better choice, both in terms of overall fit-and-finish, well-rounded features, simple and responsive UI, good code quality and overall care on the engineering.
