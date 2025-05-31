---
title: "[Objective-C] Categories, Static Libraries and Gotchas"
date: '2011-04-23T23:44:00-03:00'
slug: objective-c-categories-static-libraries-and-gotchas
tags:
- learning
- beginner
- apple
- objective-c
- english
draft: false
---

As some of you may know, I have this small pet project called [ObjC Rubyfication](https://github.com/akitaonrails/ObjC_Rubyfication), a personal exercise in writing some Ruby-like syntax within Objective-C. Most of this project uses the fact that we can reopen Objective-C standard classes – very much like Ruby, unlike Java – and insert our own code – through [Categories](http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocCategories.html%23//apple_ref/doc/uid/TP30001163-CH20), similar to Ruby’s modules.

The idea of this pet project is to be a Static Library that I can easily add to any other project and have all of its features. In this article I’d like to present how I am organizing its many subprojects within one project (and I am accepting any suggestions and tips to make it better as I am just learning how to organize things within Obj-C projects) and talk about a gotcha that took me hours to figure out and might help someone else.

To make this exercise even more fun, I also added a separated target for my unit testing suite (and see how XCode supports tests), then another target for the [Kiwi](http://kiwi-lib.info/) BDD testing framework for Obj-C, and another one for [CocoaOniguruma](http://limechat.net/cocoaoniguruma/) as I have just explained in my [previous article](http://www.akitaonrails.com/2011/04/23/objective-c-it's-a-unix-system-i-know-this).

I’ve been playing with ways of reorganizing my project and I realized that I was doing it wrong. I was adding all the source files from my “Rubyfication” target into my Specs target. So everything was compiling fine, the specs were all passing, but the way I defined dependencies was wrong. It is kind of complicated to understand at first, but it should be something like this:

- CocoaOniguruma Target: should be a static library, with no target dependencies and no binary libraries to link against, just a dependency to the standard Foundation framework. It exposes the OnigRegexp.h, OnigRegexpUtility.h and oniguruma.h as public headers.
- Kiwi Target: should be another static library, with no target dependencies and no binary libraries to link against, just having the Foundation and UIKit framework dependencies.
- Rubyfication: should be another static library, with CocoaOniguruma as a target dependency, linking against the libCocoaOniguruma.a binary and depending on the Foundation framework as well. It exposes all of its <tt>.h</tt> files as public headers.
- RubyficationTests: should be a Bundle which were created together with the Rubyfication target (you can specify whether you want a unit test target when you create new targets), with both Kiwi and Rubyfication targets as dependencies, linking against the libKiwi.a and libRubyfication.a binaries, and the Foundation and UIKit frameworks as well.

If you keep creating new targets manually, XCode 4 will also create a bunch of Schemes that you don’t really need. I keep mine clean with just the Rubyfication scheme. You can access the “Product” menu and the “Edit Scheme” option. Then my Scheme looks like this:

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/23/Screen%20shot%202011-04-23%20at%2011.26.25%20PM_original.png?1303611943)

I usually configure all my build settings to use “LLVM Compiler 2.0” for the Debug settings and “LLVM GCC 4.2” for the Release settings (actually, I do that for precaution as I am not aware if people are actually deploying binaries in production compiled from LLVM).

I also set the <tt>“Targeted Device Family”</tt> to “iPhone/iPad” and I try to make the <tt>“iOS Deployment Target”</tt> to “iOS 3.0” whenever possible. People usually leave the default one which will be the latest release – now at 4.3. Be aware that your project may not run on older devices that way.

Finally I also make sure that the <tt>“Framework Search Paths”</tt> are pointing to these options:

* * *

```
“$(SDKROOT)/Developer/Library/Frameworks”  
“${DEVELOPER_LIBRARY_DIR}/Frameworks”  
```

Everything compiles just fine that way. Then I can press “Command-U” (or go to the “Product” menu, “Test” option) to build the “RubyficationTests” target. It builds all the target dependencies, links everything together and runs the final script to execute the tests (you must make sure that you are selecting the “Rubyfication – iPhone 4.3 Simulator” in the Scheme Menu). It will fire up the Simulator so it can run the specs.

But then I was receiving:

* * *

```

Test Suite ‘/Users/akitaonrails/Library/Developer/Xcode/DerivedData/Rubyfication-gfqxbgyxicfpxugauehktilpmwzv/Build/Products/Debug-iphonesimulator/RubyficationTests.octest(Tests)’ started at 2011-04-24 02:16:27 +0000  
Test Suite ‘CollectionSpec’ started at 2011-04-24 02:16:27 +0000  
Test Case ‘-[CollectionSpec runSpec]’ started.  
2011-04-23 23:16:27.506 otest[40298:903] [__NSArrayI each:]: unrecognized selector sent to instance 0xe51a30  
2011-04-23 23:16:27.508 otest[40298:903] ***** Terminating app due to uncaught exception ‘NSInvalidArgumentException’, reason: ’[__NSArrayI each:]: unrecognized selector sent to instance 0xe51a30’  
```

It says that an instance of <tt>NSArray</tt> is not recognizing the selector <tt>each:</tt> sent to it in the <tt>CollectionSpec</tt> file. It is probably this snippet:

* * *

```objc
# import “Kiwi.h”  

# import “NSArray+functional.h”  

# import “NSArray+helpers.h”  

# import “NSArray+activesupport.h”

SPEC_BEGIN(CollectionSpec)

describe(@"NSArray", ^{  
 __block NSArray* list = nil;

context(@"Functional", ^{ beforeEach(^{ list = [NSArray arrayWithObjects:@"a", @"b", @"c", nil]; }); 

it(@"should iterate sequentially through the entire collection of items", ^{ NSMutableArray* output = [[NSMutableArray alloc] init]; 

[list each:^(id item) { [output addObject:item]; }];

[[theValue([output count]) should] equal:theValue([list count])]; });
…
```

Reference: [CollectionSpec.m](https://github.com/akitaonrails/ObjC_Rubyfication/blob/master/RubyficationTests/CollectionSpec.m#L1-22)

Notice that at Line 3 there is the correct import statement where the <tt>NSArray(Helpers)</tt> category is defined with the correct <tt>each:</tt> method declared. The error is happening at the spec in line 18 in the above snippet.

Now, this was not a compile time error, it was a runtime error. So the import statement is finding the correct file and compiling but something in the linking phase is not going correctly and at runtime the <tt>NSArray(Helpers)</tt> category, and probably other categories, are not available.

It took me a few hours of research but I finally figured out one simple flag that changed everything, the [-all_load](http://developer.apple.com/library/mac/#qa/qa1490/_index.html) linker flag. As the documentation states:

> **Important:** For 64-bit and iPhone OS applications, there is a linker bug that prevents <tt>-ObjC</tt> from loading objects files from static libraries that contain only categories and no classes. The workaround is to use the <tt>-all_load</tt> or <tt>-force_load</tt> flags.
>
> <tt>-all_load</tt> forces the linker to load all object files from every archive it sees, even those without Objective-C code. <tt>-force_load</tt> is available in Xcode 3.2 and later. It allows finer grain control of archive loading. Each <tt>-force_load</tt> option must be followed by a path to an archive, and every object file in that archive will be loaded.

So every target that depends on external static libraries that loads Categories has to add this <tt>-all_load</tt> flag in the “Other Linker Flags”, under the “Linking” category on the “Build Settings” of the target, like this:

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/23/Screen%20shot%202011-04-23%20at%2011.41.27%20PM_original.png?1303613619)

So both my <tt>RubyficationTests</tt> and <tt>Rubyfication</tt> targets had to receive this new flag. And not the Tests all pass flawlessly!
