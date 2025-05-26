---
title: "[Objective-C] It's a Unix System! I know this!"
date: '2011-04-23T22:47:00-03:00'
slug: objective-c-it's-a-unix-system-i-know-this
tags:
- learning
- beginner
- apple
- objective-c
- english
draft: false
---

While experimenting with ways of using Objective-C a little bit closer to how I code Ruby, there were two things that annoyed me a bit. First, Date Formatting and, second, Regular Expressions.

The Cocoa framework has both implemented as [NSDateFormatter](http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html%23//apple_ref/doc/uid/TP40002369-SW1) and [NSRegularExpression](http://developer.apple.com/library/iOS/#documentation/Foundation/Reference/NSRegularExpression_Class/Reference/Reference.html) that also happen to be available for iOS development.

You can format dates like this:

* * *
C

NSDateFormatter \*dateFormatter = [[NSDateFormatter alloc] init];  
[dateFormatter setDateStyle:NSDateFormatterMediumStyle];  
[dateFormatter setTimeStyle:NSDateFormatterNoStyle];

NSDate \*date = [NSDate dateWithTimeIntervalSinceReferenceDate:162000];

NSString \*formattedDateString = [dateFormatter stringFromDate:date];  
NSLog(`"formattedDateString: %`", formattedDateString);  
// Output for locale en\_US: “formattedDateString: Jan 2, 2001”  
-

And you can use Regular Expressions like this:

* * *
C

NSError \*error = NULL;  
NSRegularExpression \*regex = [NSRegularExpression regularExpressionWithPattern:@"\\b(a|b)(c|d)\\b"   
 options:NSRegularExpressionCaseInsensitive  
 error:&error];

NSUInteger numberOfMatches = [regex numberOfMatchesInString:string  
 options:0  
 range:NSMakeRange(0, [string length])];  
-

But I have issues with both of these. The Ruby equivalent for the date formatting example would be:

* * *
ruby

require ‘activesupport’  
date = Time.parse(“2001-01-01”) + 162000.seconds  
date.strftime(“%b %d, %Y”)  
-

And the regular expression example would be like this:

* * *
ruby

number\_of\_matches = /\W\*[a|b][c|d]\W\*/.match(string).size  
-

There are 2 specific things that annoys me:

- that the Obj-C versions feels unnecessarily verbose. Now, I do understand that they are lower level and they will probably allow for more flexibility, but I think they should have higher “porcelain” versions, that are more straightforward.
- that in Obj-C, the Date Formatting uses the [Unicode TR-35](http://unicode.org/reports/tr35/tr35-10.html#Date_Format_Patterns) formatting standard and that Regular Expressions uses the [ICU](http://userguide.icu-project.org/strings/regexp) standard that is inspired by Perl Regular Expression with support for Unicode and loosely based on JDK 1.4 java.util.regex.

So, the ideal solution for me would be:

- to have higher level versions of those features;
- to have C-compatible strftime date formatting and Ruby 1.9’s Oniguruma level regular expressions.


## It’s a Unix System!

That’s when the obvious thing came to me: Objective-C is nothing more than a superset of C, so anything that is compatible with C is automatically compatible with Objective-C. More than that, the **iOS is a Unix System**! Meaning that it has all the goodies of Posix support.

http://www.youtube.com/embed/dFUlAQZB9Ng

So, how do I get [C-compatible](http://www.cplusplus.com/reference/clibrary/ctime/strftime/) strftime? Easy:

* * *
C

#import “time.h”  
…  
- (NSString\*) toFormattedString:(NSString\*)format {  
 time\_t unixTime = (time\_t) [self timeIntervalSince1970];  
 struct tm timeStruct;  
 localtime\_r(&unixTime, &timeStruct);

char buffer<sup class="footnote" id="fnr30"><a href="#fn30">30</a></sup>; strftime(buffer, 30, [[NSDate formatter:format] cStringUsingEncoding:[NSString defaultCStringEncoding]], &timeStruct); NSString\* output = [NSString stringWithCString:buffer encoding:[NSString defaultCStringEncoding]]; return output;

}  
-

Reference: [NSDate+helpers.m](https://github.com/akitaonrails/ObjC_Rubyfication/blob/master/Rubyfication/NSDate+helpers.m#L71-80)

Now follow each line to understand it:

- At line 4 it is returning the current time represented as the number of seconds since 1970. That method actually returns a <tt>NSTimeInterval</tt> which is a number that is essentially the same as the C-equivalent <tt>time_t</tt>
- At line 6 the C function <tt>localtime_r</tt> converts the <tt>unitTime</tt> number into the C-structure <tt>timeStruct</tt>
- At line 9 we call a custom method I created called <tt>formatter</tt> that just returns a <tt>strftime</tt> compatible string format. The Obj-C string (when we create using the “@” symbol) is an object that we must convert to an array of chars using the <tt>cStringUsingEncoding:</tt>. C functions don’t understand Obj-C string, hence the conversion. Then we finally call the <tt>strftime</tt> itself that will store the result in the <tt>buffer</tt> array of char that we declared before.
- At line 10 we now do the reverse and convert the resulting C-string (array of chars) back into an Obj-C String.

Now this is too nice. I have added a few other helper methods that now allows me to use it like this:

* * *
C

it(`"should convert the date to the rfc822 format", ^{
    [[[ref toFormattedString:`“rfc822”] should] equal:@"Fri, 01 Jan 2010 10:15:30"];  
});  
-

Reference: [DateSpec.m](https://github.com/akitaonrails/ObjC_Rubyfication/blob/master/RubyficationTests/DateSpec.m#L69)

And the <tt>“rfc822”</tt> string will just be internally converted to <tt>@"%a, %d %b %Y %H:%M:%S"</tt> by the [<tt>formatter:</tt>](https://github.com/akitaonrails/ObjC_Rubyfication/blob/master/Rubyfication/NSDate+helpers.m#L82-100) selector in the <tt>NSDate</tt> class.

Now, to add Ruby 1.9-level regular expression you can go straight to the source and use the original C-based [Oniguruma](http://www.geocities.jp/kosako3/oniguruma/) itself, exactly what Ruby does. There several ways to integrate a C library into your Cocoa project, but someone already did all the hard work. Satoshi Nakagawa wrote an Obj-C wrapper called [CocoaOniguruma](http://limechat.net/cocoaoniguruma/) that makes it dead easy to integrate into your project.

There are several ways to integrate an external library into your project, the easier way (albeit, not exactly the best) that I am showing here is by creating a new Static Library Target within my project, called _CocoaOniguruma_:

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/23/Screen%20shot%202011-04-23%20at%2010.33.47%20PM_original.png?1303608817)

It will create a new Group called _CocoaOniguruma_ in your project. Than you just add all the files from [CocoaOniguruma’s core folder](https://github.com/psychs/cocoaoniguruma/tree/master/framework/core) to that group, select the new target and all the source files and headers will be properly added to the project, like this:

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/23/Screen%20shot%202011-04-23%20at%2010.37.19%20PM_original.png?1303608987)

Finally, you need to go to the original main target of your application and add both the new target to the target dependencies and the binary <tt>.a</tt> file to the binary linking section, like this:

![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/23/Screen%20shot%202011-04-23%20at%2010.39.07%20PM_original.png?1303609098)

With all this set, I recommend you to explore the <tt>OnigRegexp.m</tt> and <tt>OnigRegexpUtility.m</tt>, that are Obj-C wrappers to the Oniguruma library. The author already did some very Ruby-like syntax for you to use.

I have wrapped those helpers in my own classes like this:

* * *
C

- (NSString\*) gsub:(NSString\*)pattern with:(id)replacement {  
 if ([replacement isKindOfClass:[NSString class]]) {  
 return [self replaceAllByRegexp:pattern with:replacement];   
 } else if ([replacement isKindOfClass:[NSArray class]]) {  
 \_\_block int i = -1;  
 return [self replaceAllByRegexp:pattern withBlock:^(OnigResult\* obj) {  
 return (NSString\*)[replacement objectAtIndex:(++i)];  
 }];   
 }  
 return nil;  
}

- (NSString\*) gsub:(NSString\*)pattern withBlock:(NSString\* (^)(OnigResult\*))replacement {  
 return [self replaceAllByRegexp:pattern withBlock:replacement];  
}  
-

Reference: [NSString+helpers.m](https://github.com/akitaonrails/ObjC_Rubyfication/blob/master/Rubyfication/NSString+helpers.m#L176-190)

Which now allows me to use this nicer syntax:

* * *
C

context(`"Regular Expressions", ^{
    it(`“should replace all substrings that match the pattern”, ^{  
 [[[`"hello world, heyho!" gsub:`“h\\w+” with:`"hi"] should] equal:`“hi world, hi!”];  
 });

it(@"should replace each substrings with one corresponding replacement in the array", ^{ NSArray\* replacements = [NSArray arrayWithObjects:@"hi", @"everybody", nil]; [[[`"hello world, heyho!" gsub:`“h\\w+” with:replacements] should] equal:@"hi world, everybody!"]; }); it(@"should replace each substring with the return of the block", ^{ [[[`"hello world, heyho!" gsub:`“h\\w+” withBlock:^(OnigResult\* obj) { return @"foo"; }] should] equal:@"foo world, foo!"]; });

});  
-

Reference: [StringSpec.m](https://github.com/akitaonrails/ObjC_Rubyfication/blob/master/RubyficationTests/StringSpec.m#L86-102)

If you’re thinking that it is strange for a snippet of Objective-C code to have keyword such as <tt>context</tt> or <tt>it</tt>, they come from [Kiwi](http://www.kiwi-lib.info/), which builds an RSpec-like BDD testing framework on top of SenTesting Kit for Objective-C development that you should definitely check out. But the code above should be easy enough to understand without even knowing about Kiwi. If you’re a Ruby developer, you will probably notice that the syntax bears some resemblance to what you’re used to already.

So, linking to existing standard C libraries or even third-party open source C libraries is a piece of cake for those simple cases, without having to resort to any “Native Interface” tunneling between virtual machines or any other plumbing. If you want C, they’re there for you to easily integrate and use.

