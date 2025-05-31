---
title: "[Off-Topic] iOS Development and Open Source Libraries"
date: '2011-03-26T15:59:00-03:00'
slug: off-topic-ios-development-and-open-source-libraries
tags:
- learning
- beginner
- apple
- objective-c
- english
draft: false
---

I’ve been following the evolution of iOS development and I have to say that is becoming increasingly easier to assemble a quality application these days. Apple just released iOS 4.3.1 and Xcode 4.0.1. Great releases, and the new Xcode is a great step forward. I think this is the first big IDE to fully support Git as a first class citizen in the development workflow. Every serious IDE should do it and any serious developer should be comfortable with Git by now.

The new LLVM Compiler 2.0 is very impressive, it helps a lot in making memory leak free applications. By the way, I don’t buy the _“it is too difficult doing memory management”_, this is just saying _“I’m too lazy and cheap”_. Come on, there are thousands of quality apps both for OS X and iOS. Memory management is a little bit more difficult than having a full features generational garbage collector, but it’s nowhere near as difficult as some people claim it to be. Any reasonable developer should be able to accomplish this with minimum effort.

And to help even more, the community has been releasing more and more great libraries that further increase productivity. Let me list a few of my favorites:


- [Flurry](http://www.flurry.com/) – it is the equivalent of Google Analytics for iOS. Everything is trackable nowadays and information such as who’s using your app, how they are using it, what are the most used and least used features, in what regions, are all important. You can use this data to further refine your app and make it even greater. It gives you SDK’s for Java ME, Blackberry, Android, Windows Phone and iOS. You have to sign up to have access to the libraries. You will register your application, and that will give it a unique application key that you have to hard code into your app and that’s it. It is literally as easy as doing:

* * *
objective-c

#import “FlurryAPI.h”  
…  
- (void) applicationDidFinishLaunching:(NSNotification*) notice {  
 [FlurryAPI startSession:@"your_unique_app_key"];  
 …  
}  
-

And there are several other methods for you to count certain events in your app, to log page views, to log exceptions and errors, and even location. Definitely mandatory for every app.

- [ASIHTTPRequest](http://allseeing-i.com/ASIHTTPRequest/) – most apps these days integrate with some web based back-end. Twitter, Facebook, LinkedIn, everything logs in into some cloud service out there to grab information and collaborate. Cocoa Touch as a rich set of networking capabilities but they are lower level than most would like it to be. It is boring to make connections in the background, track it’s success or error, trigger events and loading cues for the user and so on. Enter ASIHTTPRequest, it makes it strikingly easy to make reliable connections to any web endpoint. The documentation is good enough and the code is even easier:

* * *
objective-c

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
-

This library creates network queues and you can trigger as many connection requests as you want and it will manage the queue for you in the background. There are use case example in the [documentation](http://allseeing-i.com/ASIHTTPRequest/How-to-use). With this library there is no need to use the low level base classes and you should delegate all HTTP requests to this library. Highly recommended.

- [TouchJSON](https://github.com/TouchCode/TouchJSON) – if you are consuming online HTTP data, you will probably receive a JSON formatted payload (another trend these days). Now you have to parse it into meaningful Objective-C objects. It helps a lot that Objective-C is very dynamic and flexible in its type system so you are able to easily convert anything. It is a very boring process, though, so this library will help a lot. You will want to use ASIHTTPRequest to handle connecting to the server and once it returns, you can parse the response blob like this:

* * *
objective-c

- (void)requestDone:(ASIHTTPRequest *)request  
{  
 NSString *response = [request responseString];  
 NSError *theError = NULL;  
 NSDictionary *theDictionary = [NSDictionary dictionaryWithJSONString:response error:&theError];  
}  
-

Super easy. It supports deserializing a JSON string into a graph of Objective-C objects and it also supports the way back to convert objects into a JSON representation so you can POST it somewhere or just record it into a local file.

- [ShareKit](http://www.getsharekit.com/) – it is a trend that every application content should shared. Whenever your user share something with his friends, it makes your app more well known, and is great marketing. You definitely want to make your app able to share content through email, Twitter, Facebook and other social networks. The [documentation](http://www.getsharekit.com/docs/) is good, the views are all customizable, and it takes responsability for all the boring details of logging in each online service and making connections and everything. And it is extensible, making it easy to add any new online service that comes up in the future. To add it into your app, follow the [installation instructions](http://www.getsharekit.com/install/), but in the end it comes down to you adding a UIBarButtonItem like this:

* * *
objective-c

[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction  
 target:self  
 action:@selector(share)]  
-

And adding the event handler code:

* * *
objective-c

- (void)myButtonHandlerAction  
{  
 // Create the item to share (in this example, a url)  
NSURL *url = [NSURL URLWithString:`"http://getsharekit.com"];
	SHKItem *item = [SHKItem URL:url title:`“ShareKit is Awesome!”];

// Get the ShareKit action sheet  
 SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];

// Display the action sheet  
 [actionSheet showFromToolbar:navigationController.toolbar];  
}  
-

Can’t get easier than that.

- [simple-iphone-image-processing](http://code.google.com/p/simple-iphone-image-processing/) – another very important feature is to deal with images. Every new smartphone has a camera these days and it is important to leverage this capability. But just taking pictures and recording its image file is not enough. You will want to further process the image to take out meaningful information. Want to be inspired? Take a look at this [Sudoku application demo](http://www.youtube.com/watch?v=oImMJ6p6mKE) that uses this image processing library and you will understand what I mean. You can take a picture from any sudoku game printed in the newspaper, for example, and the application will parse the image, detect the information, and create a fully functional digital representation that can now be solved through well known algorithms. How cool is that? Now, problem is that this library is very old (last commit from 2009), so I am not sure how well it behaves in current iOS releases, and the documentation is close to none, so you will have to dig through its source code. I didn’t try it myself, I’m just adding it here as a note for myself to make further experiments.

- [cocos2d](http://cocos2d.org/) – now, making simple list based applications is boring. You should consider adding a little bit of animation and interactivity into your app. You can use Apple’s standard Core Graphics and Core Animation APIs or you can go craze with cocos2d. It is an OpenGL accelerated 2D API so you can easily create great effects. You will have cross platform wrappers so you can leverage this knowledge in many platforms. There are several tutorials in the internet such as [this](http://maniacdev.com/2011/02/tool-easily-gather-data-for-box2d-and-generate-cocos2d-code/), and [this](http://maniacdev.com/2011/02/cross-platform-cocos2d-game-engine-using-cpp/) and [more](http://bit.ly/eKHOqw). Definitely worth studying.

- [iPhone AR Kit](http://www.iphonear.org/) – this is still now entirely mature yet – I guess – but many applications are using it and this should evolve fast in the future. The idea is to turn on the camera, process the image frames and add 2d or 3d animation on top of it, making the digital objects sort of “interact” with the real time captured background. If you use the device’s movement sensors (compass, gyroscope, accelerometer, etc) you can make really impressive applications. Definitely study this.

- [Kiwi](https://github.com/allending/Kiwi) and [Gh-Unit](http://gabriel.github.com/gh-unit/_installing.html) – unfortunatelly testing is not something well understood and practiced in the Objective-C community. Many rubyists that are also developing in Objective-C are trying to adopt the same practices we take for granted in the Ruby community so I hope this helps. Cocoa and Xcode do come with basic unit testing tools such as SentestingKit. There is close to zero documentation about this subject, you can look at Apple’s official [logic testing](https://developer.apple.com/library/ios/#documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html%23//apple_ref/doc/uid/TP40007959-CH20-SW9) article and this other [blog post](http://www.grokkingcocoa.com/how_to_debug_iphone_unit_te.html) about it. The default tools are a bit basic though, so you will want to check out other testing frameworks such as Gh-Unit and Kiwi. In particular, Kiwi looks very impressive trying to follow a RSpec-like syntax:

* * *
objective-c

describe(`"Team", ^{
    context(`“when newly created”, ^{  
 it(`"should have a name", ^{
            id team = [Team team];
            [[team.name should] equal:`“Black Hawks”];  
 });

it(@"should have 11 players", ^{ id team = [Team team]; [[[team should] have:11] players]; }); });

});  
-

Both are definitely worth checking out. And we should strive to add more technology and techniques for testing in Objective-C development. We did in the Ruby-land, there’s no reason we can’t do the same in Objective-C.

And this is it for now. There are many more great libraries and tools available and iOS is evolving fast, so this is all very exciting to follow and practice. I hope to be able to contribute back as soon as possible.

