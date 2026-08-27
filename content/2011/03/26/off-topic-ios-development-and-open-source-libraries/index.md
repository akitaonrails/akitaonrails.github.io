---
title: "[Off-Topic] iOS Development and Open Source Libraries"
date: '2011-03-26T15:59:00-03:00'
slug: off-topic-ios-development-and-open-source-libraries
description: "O autor apresenta bibliotecas para acelerar o desenvolvimento de apps iOS, cobrindo analytics, HTTP, JSON, compartilhamento, jogos, realidade aumentada e testes, mas ressalva que o processamento de imagens está desatualizado."
tags:
- mobile
- apple
- programacao
- off-topic
draft: false
---

I've been following the evolution of iOS development, and it keeps getting easier to assemble a quality application. Apple just released iOS 4.3.1 and Xcode 4.0.1, and the new Xcode is a big step forward. I think this is the first major IDE to support Git as a first class citizen in the development workflow. Every serious IDE should do that, and any serious developer should be comfortable with Git by now.

The new LLVM Compiler 2.0 is impressive and helps a lot in writing memory leak free applications. I don't buy the _"it is too difficult doing memory management"_ complaint, which usually just means _"I'm too lazy and cheap"_. Come on, there are thousands of quality apps for both OS X and iOS.

Memory management is a bit harder than leaning on a full featured generational garbage collector, but it's nowhere near as hard as some people claim. Any reasonable developer can handle it with minimal effort.

The community keeps releasing great libraries that push productivity even further. Let me list a few of my favorites:

- [Flurry](http://web.archive.org/web/20110326193919/http://www.flurry.com/) is the iOS equivalent of Google Analytics. Everything is trackable now: who is using your app, how they use it, which features get the most and least use, and in which regions. You feed that data back into the product to refine it. It ships SDKs for Java ME, Blackberry, Android, Windows Phone and iOS. You sign up, register your application, and get a unique application key that you hard code into the app. It is literally as easy as this:

```objc
#import "FlurryAPI.h"
...
- (void) applicationDidFinishLaunching:(NSNotification*) notice {
    [FlurryAPI startSession:@"your_unique_app_key"];
    ...
}
```

There are several other methods to count events, log page views, log exceptions and errors, and even location. Mandatory for every app.

- [ASIHTTPRequest](https://allseeing-i.com/ASIHTTPRequest/) handles the fact that most apps integrate with some web based back-end. Twitter, Facebook, LinkedIn, everything logs into some cloud service to grab information and collaborate. Cocoa Touch has a rich set of networking capabilities, but they sit at a lower level than most people want. Making background connections, tracking success or failure, triggering events and loading cues for the user, it all gets tedious. ASIHTTPRequest makes reliable connections to any web endpoint strikingly easy. The documentation is good enough and the code is even simpler:

```objc
- (IBAction)grabURLInTheBackground:(id)sender
{
    if (![self queue]) {
        [self setQueue:[[[NSOperationQueue alloc] init] autorelease]];
    }

    NSURL *url = [NSURL URLWithString:@"http://allseeing-i.com"]; ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url]; [request setDelegate:self]; [request setDidFinishSelector:@selector(requestDone:)]; [request setDidFailSelector:@selector(requestWentWrong:)]; [[self queue] addOperation:request]; //queue is an NSOperationQueue
}

- (void)requestDone:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
}
```

The library creates network queues, so you can fire as many requests as you want and it manages the queue in the background. There are use case examples in the [documentation](https://allseeing-i.com/ASIHTTPRequest/How-to-use/). You can skip the low level base classes and delegate all HTTP requests to it. Highly recommended.

- [TouchJSON](http://web.archive.org/web/20110423000036/https://github.com/TouchCode/TouchJSON): if you consume online HTTP data, you will probably get a JSON payload (another trend of the moment) that you need to parse into meaningful Objective-C objects. Objective-C is dynamic and flexible in its type system, so converting anything is easy. The parsing itself is tedious, and this library takes care of it. Use ASIHTTPRequest to connect to the server, and once it returns, parse the response blob like this:

```objc
- (void)requestDone:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSError *theError = NULL;
    NSDictionary *theDictionary = [NSDictionary dictionaryWithJSONString:response error:&theError];
}
```

Super easy. It deserializes a JSON string into a graph of Objective-C objects, and it goes the other way too, turning objects back into JSON so you can POST it somewhere or save it to a local file.

- ShareKit rides the trend that every piece of app content should be shareable. Whenever your users share something with their friends, your app gets more visibility, which is great marketing. You want the app to share content through email, Twitter, Facebook and other social networks. The [documentation](http://web.archive.org/web/20110319200447/http://www.getsharekit.com/docs) is good, the views are all customizable, and it takes care of the boring details of logging into each service and making the connections. It is also extensible, so adding a new online service later is easy. Follow the [installation instructions](http://web.archive.org/web/20110321130554/http://getsharekit.com/install); in the end it comes down to adding a UIBarButtonItem like this:

```objc
[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
    target:self
    action:@selector(share)]
```

And adding the event handler code:

```objc
- (void)myButtonHandlerAction
{
    // Create the item to share (in this example, a url)
    NSURL *url = [NSURL URLWithString:@"http://getsharekit.com"];
    SHKItem *item = [SHKItem URL:url title:@"ShareKit is Awesome!"];

    // Get the ShareKit action sheet
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];

    // Display the action sheet
    [actionSheet showFromToolbar:navigationController.toolbar];
}
```

Can't get easier than that.

- [simple-iphone-image-processing](https://code.google.com/archive/p/simple-iphone-image-processing) covers another important area: dealing with images. Every new smartphone has a camera, and it pays to leverage it. Snapping a picture and saving the file is just the start; you will often want to process the image to extract meaningful information.

Want to be inspired? Look at this [Sudoku application demo](https://www.youtube.com/watch?v=oImMJ6p6mKE) built on this image processing library. You point the camera at any Sudoku printed in a newspaper, and the app parses the image, detects the grid, and builds a fully functional digital representation you can then solve with well known algorithms. How cool is that?

One caveat: the library is old, with its last commit from 2009, so I am not sure how it behaves on current iOS releases. The documentation is close to none, so you will have to dig through the source. I haven't tried it myself; I'm adding it here as a note to run further experiments later.

- [cocos2d](http://cocos2d.org/) steps in when simple list based apps get boring and you want animation and interactivity. You can use Apple's standard Core Graphics and Core Animation APIs, or go crazy with cocos2d. It is an OpenGL accelerated 2D API, so great effects are easy to build, and the cross platform wrappers let you carry the knowledge to other platforms. There are plenty of tutorials online, such as this Box2D data tool writeup, [this cross platform engine](http://web.archive.org/web/20110325002808/http://maniacdev.com/2011/02/cross-platform-cocos2d-game-engine-using-cpp/), and [more](http://bit.ly/eKHOqw). Worth studying.

- [iPhone AR Kit](http://web.archive.org/web/20110317060458/http://www.iphonear.org/) is not entirely mature yet, I think, but plenty of apps already use it and it should evolve fast. The idea is to turn on the camera, process the image frames, and lay 2D or 3D animation on top, so the digital objects seem to interact with the real time background. Pair that with the device's motion sensors (compass, gyroscope, accelerometer) and you can build genuinely impressive apps. Worth studying.

- [Kiwi](https://github.com/allending/Kiwi) and Gh-Unit: unfortunately, testing is not well understood or practiced in the Objective-C community. Many Rubyists who also write Objective-C are trying to bring over the practices we take for granted in Ruby, so I hope this helps. Cocoa and Xcode ship basic unit testing tools like SenTestingKit. Documentation is close to zero; you can read Apple's official [logic testing](http://web.archive.org/web/20110411203656/http://developer.apple.com/library/ios/DOCUMENTATION/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html) article and this [blog post](http://www.grokkingcocoa.com/how_to_debug_iphone_unit_te.html). The default tools are basic, so it is worth checking out other frameworks like Gh-Unit and Kiwi. Kiwi in particular looks impressive, following an RSpec-like syntax:

```objc
describe(@"Team", ^{
    context(@"when newly created", ^{
        it(@"should have a name", ^{
            id team = [Team team];
            [[team.name should] equal:@"Black Hawks"];
        });

        it(@"should have 11 players", ^{ id team = [Team team]; [[[team should] have:11] players]; });
    });
});
```

Both are worth checking out. We should push more testing technique and tooling into Objective-C development. We did it in Ruby land, and there is no reason we can't do the same here.

That's it for now. There are many more great libraries and tools out there, and iOS is evolving fast, so all of this is exciting to follow and practice. I hope to contribute back soon.
