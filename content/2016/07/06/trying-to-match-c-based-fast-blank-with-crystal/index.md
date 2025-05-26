---
title: Trying to match C-based Fast Blank with Crystal
date: '2016-07-06T17:10:00-03:00'
slug: trying-to-match-c-based-fast-blank-with-crystal
tags:
- crystal
draft: false
---

In my eyes, Crystal may become the ideal solution to make our beloved Ruby gems faster. Up until now we have been using C-based extensions to accelerate CPU-bound code in Ruby. Nokogiri, for example, is a wrapper to provide a nice API on top of libxml, which is a huge library in C.

But there are many opportunities to accelerate Rails applications as well. For example, we just saw the release of the [gem "faster_path"](https://github.com/danielpclark/faster_path), this time written in Rust and bridged through FFI (Foreign Function Interface). The author's claim is that Sprockets has to compute lots of paths and making this library, natively compiled and optimized with Rust, added a huge improvement in the asset pipeline task.

Sam Saffrom, from Discourse, also built a very small gem called ["fast_blank"](https://github.com/SamSaffron/fast_blank) which is a tiny library written in C that reimplements ActiveSupport's `String#blank?` method to be up to 9x faster. Because Rails digests volumes of strings, checking if they are blank everytime, this adds some performance (depends on your app, of course).

The Holy Grail to native-level performance is to be able to write close-to-Ruby code instead of having to hack low-level C or having the high learning curve of a language such as Rust. More than  that, I'd like to avoid having to use FFI. I am not an expert in FFI but I remember understanding that it adds overhead to make the bindings.

By the way, it's important to disclose right now: I am not a C expert by any means of the imagination, far from that. So I have very little experience dealing with hard core C development. Which is again, why this possibility of writing in Crystal is even more appealing to me. So if you are a C expert and you spot something silly I am saying about it, please let me know in the comments section below.

My exercise is to rewrite the C-based Fast Blank gem in Crystal, add it to the same Gem to compile under Crystal if it's available or fallback to C, and make the specs pass so it's a seamless transition for the user.

To achieve that I had to:

* Extend the Gem's extconf.rb to generate different Makefiles (for C and Crystal) that are able to compile under OS X or Linux (Ubuntu at least) - OK
* Make the specs pass in the Crystal version - Almost (it's ok for all intents and purposes but an edge case)
* Make the performance be faster than Ruby and close to C - Not so much yet (under OS X the performance is quite good, but under Ubuntu it doesn't scale so well for large string)

You can check out the results so far on [my fork over Github](https://github.com/akitaonrails/fast_blank/tree/crystal_version) and follow the [Pull Request discussion as well](https://github.com/SamSaffron/fast_blank/pull/20).

### Comparing C and Crystal

Just to have us started, let's check out a snippet of Sam's original C version:

--- C
static VALUE
rb_str_blank(VALUE str)
{
  rb_encoding *enc;
  char *s, *e;

  enc = STR_ENC_GET(str);
  s = RSTRING_PTR(str);
  if (!s || RSTRING_LEN(str) == 0) return Qtrue;

  e = RSTRING_END(str);
  while (s < e) {
    int n;
    unsigned int cc = rb_enc_codepoint_len(s, e, &n, enc);

    if (!rb_isspace(cc) && cc != 0) return Qfalse;
    s += n;
  }
  return Qtrue;
}
---

Yeah, quite scary, I know. Now let's see the Crystal version:

--- ruby
struct Char
  ...
  # same way C Ruby implements it
  def is_blank
    self == ' ' || ('\t' <= self <= '\r')
  end
end

class String
  ...
  def blank?
    return true if self.nil? || self.size == 0
    each_char { |char| return false if !char.is_blank }
    return true
  end
end
---

Hell yeah! If you're a rubyist I bet you can understand a 100% of the snippet above. It's not "exactly" the same thing (as the specs are not fully passing yet), but it's damn close.

### The Quest for a Makefile to Crystal

I've researched many [experimental Github repos](https://github.com/akitaonrails/ruby_ext_in_crystal_math) and Gists out there. But I didn't find one that has it all so I decided to tweak what I found until I got to this version:

Obs: again, I am not a C expert. If you have experience with Makefiles I know this one can be refactored to something nicer than this. Let me know in the comments below.

--- C
ifeq "$(PLATFORM)" ""
PLATFORM := $(shell uname)
endif

ifeq "$(PLATFORM)" "Linux"
UNAME = "$(shell llvm-config --host-target)"
CRYSTAL_BIN = $(shell readlink -f `which crystal`)
LIBRARY_PATH = $(shell dirname $(CRYSTAL_BIN))/../embedded/lib
LIBCRYSTAL = $(shell dirname $(CRYSTAL_BIN) )/../src/ext/libcrystal.a
LIBRUBY = $(shell ruby -e "puts RbConfig::CONFIG['libdir']")
LIBS = -lpcre -lgc -lpthread -levent -lrt -ldl
LDFLAGS = -rdynamic

install: all

all: fast_blank.so

fast_blank.so: fast_blank.o
  $(CC) -shared $^ -o $@ $(LIBCRYSTAL) $(LDFLAGS) $(LIBS) -L$(LIBRARY_PATH) -L$(LIBRUBY)

fast_blank.o: ../../../../ext/src/fast_blank.cr
  crystal build --cross-compile --release --target $(UNAME) $<

.PHONY: clean
clean:
  rm -f bc_flags
  rm -f *.o
  rm -f *.so
endif

ifeq "$(PLATFORM)" "Darwin"
CRYSTAL_FLAGS = -dynamic -bundle -Wl,-undefined,dynamic_lookup

install: all

all: fast_blank.bundle

fast_blank.bundle: ../../../../ext/src/fast_blank.cr
  crystal $^ --release --link-flags "$(CRYSTAL_FLAGS)" -o $@

clean:
  rm -f *.log
  rm -f *.o
  rm -f *.bundle
endif
---

Most people using Crystal are on OS X, including the creators of Crystal. LLVM is under Apple's umbrella and their entire ecosystem relies heavily on LLVM. They spent many years migrating the C front-end first, then the C back-end away from GNU's standard GCC to Clang. And they were able to make their both Objective-C and Swift compile down to LLVM's IR and that's how both can interact back and forth natively.

Then, they improved the ARM backend support and that's how they can have an entire iOS "Simulator" (not a dog slow emulator like Android) where the iOS apps are natively compiled to run over Intel's x86_64 processor while in development and then quickly recompile to ARM when ready to package to the App Store.

This way you can run natively, test quickly, without the slowness of an emulated environment. By the way, I will say this once: Google's biggest mistake is not supporting LLVM as they should and reinventing the wheel. If they had, Go could already be used to implement for Android and Chromebooks as well as x86 based servers and they could put away all the Java/Oracle debacle.

But I digress.

In OS X you can pass a "`-bundle`" link-flag to crystal and it will probably use clang underneath to generate the binary bundle.

On Ubuntu crystal just compiles down to an object file (.o) and you have to manually invoke GCC with the "`-shared`" option to create a shared-object. To do that we have to use the ["--cross-compile"](https://crystal-lang.org/docs/syntax_and_semantics/cross-compilation.html) and pass an LLVM target triplet so it generates the .o (this requires the `llvm-config` tool).

Shared Libraries (.so) and Loadable Modules (.bundle) are different beasts, check [this documentation](http://docstore.mik.ua/orelly/unix3/mac/ch05_03.htm) out for more details.

Keep in mind that benchmarking binaries built with different compilers can make a difference. I am not an expert but out of pure anecdote I believe Ruby under RVM on OS X is compiled using OS X's default Clang. On Ubuntu it's compiled under GCC. This seems to make Ruby on OS X "so slightly" inneficient in synthetic benchmarks.

On the other hand, Crystal binaries linked with GCC feels "so slightly" inneficient on Ubuntu, while Ruby on Ubuntu feels a bit faster, having been compiled and linked with GCC.

So when we compare Fast Blank/OS X/bit faster with Ruby/OS X/slower against Fast Blank/Ubuntu/bit slower with Ruby/Ubuntu/bit faster, it seems to give a wider advantage to the OS X benchmark comparison against the Ubuntu benchmark, even though individual computation times are not so far from each other.

I will come back to this point in the benchmarks section.

Finally, everytime you have a rubygem with a native extension, you will find this bit in their gemspec files:

--- ruby
Gem::Specification.new do |s|
  s.name = 'fast_blank'
  ...
  s.extensions = ['ext/fast_blank/extconf.rb']
  ...
---

When the gem is installed through `gem install` or `bundle install` it will run this script to generate a proper `Makefile`. In a pure C extension it will use the built-in "mkmf" library to generate it.

In our case, if we have Crystal installed, we want to use the Crystal version, so I tweaked the `extconf.rb` to be like this:

--- ruby
require 'mkmf'

if ENV['VERSION'] != "C" && find_executable('crystal') && find_executable('llvm-config')
  # Very dirty patching
  def create_makefile(target, srcprefix = nil)
    mfile = open("Makefile", "wb")
    cr_makefile = File.join(File.dirname(__FILE__), "../src/Makefile")
    mfile.print File.read(cr_makefile)
  ensure
    mfile.close if mfile
    puts "Crystal version of the Makefile copied"
  end
end

create_makefile 'fast_blank'
---

So, if it finds `crystal` and `llvm-config` (which in OS X you have to add the proper path like this: `export PATH=$(brew --prefix llvm)/bin:$PATH`).

The `Rakefile` in this project declares the standard `:compile` task as the first one to run, and it will execute the `extconf.rb`, which will generate the proper `Makefile` and run the `make` command to compile and link the proper library in the proper `lib/` path.

So we will end up with `lib/fast_blank.bundle` on OS X and `lib/fast_blank.so` on Ubuntu. From there we can just have `require "fast_blank"` from any Ruby file in the gem and it will have access to the publicly exported C function mappings from the Crystal library.

### Mapping C-Ruby to Crystal

Now, any direct C extension - without FFI, fiddle or other "bridges" - will ALWAYS have a much better advantage.

The reason is that you literally have to "copy" data from C-Ruby to Crystal/Rust/Go or whatever other language you're binding. While with a C-based extension you can operate directly in the memory space with the data without having to move it or copy it away.

For example. First, you have to bind the C functions from C-Ruby to Crystal. And we accomplish that with [Paul Hoffer's Crystalized Ruby](https://github.com/phoffer/crystalized_ruby/blob/master/src/lib_ruby.cr) mappings. It's an experimental repository that I helped a bit to clean up in order for him to later extract this mapping library into its own Shard (shards are the same as gems for Crystal). For now I had to simply copy the file over to my Fast Blank.

Some of the relevant bits are like this:

--- ruby
lib LibRuby
  type VALUE = Void*
  type METHOD_FUNC = VALUE -> VALUE
  type ID = Void*
  ...

  # strings
  fun rb_str_to_str(value : VALUE) : VALUE
  fun rb_string_value_cstr(value_ptr : VALUE*) : UInt8*
  fun rb_str_new_cstr(str : UInt8*) : VALUE
  fun rb_utf8_encoding() : VALUE
  fun rb_enc_str_new_cstr(str : UInt8*, enc : VALUE) : VALUE
  ...
  # exception handling
  fun rb_rescue(func : VALUE -> UInt8*, args : VALUE, callback: VALUE -> UInt8*, value: VALUE) : UInt8*
end
...
class String
  RUBY_UTF = LibRuby.rb_utf8_encoding
  def to_ruby
    LibRuby.rb_enc_str_new_cstr(self, RUBY_UTF)
  end

  def self.from_ruby(str : LibRuby::VALUE)
    c_str = LibRuby.rb_rescue(->String.cr_str_from_rb_cstr, str, ->String.return_empty_string, 0.to_ruby)
    # FIXME there is still an unhandled problem: then we receive \u0000 from Ruby it raises "string contains null bytes"
    # so we catch it with rb_rescue, but then we can't generate a Pointer(UInt8) that represents the unicode 0, instead we return a plain blank string
    # but then the specs fail
    new(c_str)
  ensure
    ""
  end

  def self.cr_str_from_rb_cstr(str : LibRuby::VALUE)
    rb_str = LibRuby.rb_str_to_str(str)
    c_str  = LibRuby.rb_string_value_cstr(pointerof(rb_str))
  end

  def self.return_empty_string(arg : LibRuby::VALUE)
    a = 0_u8
    pointerof(a)
  end
end
---

Then I can use these mappings and helpers to build a "Wrapper" class in Crystal:

--- ruby
require "./lib_ruby"
require "./string_extension"

module StringExtensionWrapper
  def self.blank?(self : LibRuby::VALUE)
    return true.to_ruby if LibRuby.rb_str_length(self) == 0
    str = String.from_ruby(self)
    str.blank?.to_ruby
  rescue
    true.to_ruby
  end

  def self.blank_as?(self : LibRuby::VALUE)
    return true.to_ruby if LibRuby.rb_str_length(self) == 0
    str = String.from_ruby(self)
    str.blank_as?.to_ruby
  rescue
    true.to_ruby
  end

  def self.crystal_value(self : LibRuby::VALUE)
    str = String.from_ruby(self)
    str.to_ruby
  end
end
---

And this "Wrapper" depends on the "pure" Crystal library itself like with the snippets for the Char struct and String class extensions I showed in the first section of the article above.

Finally, I have a main "fast_blank.cr" file that externs those Wrapper functions so C-Ruby can see them as plain String methods:

--- ruby
require "./string_extension_wrapper.cr"

fun init = Init_fast_blank
  GC.init
  LibCrystalMain.__crystal_main(0, Pointer(Pointer(UInt8)).null)

  string = LibRuby.rb_define_class("String", LibRuby.rb_cObject)
  LibRuby.rb_define_method(string, "blank?", ->StringExtensionWrapper.blank?, 0)
  LibRuby.rb_define_method(string, "blank_as?", ->StringExtensionWrapper.blank_as?, 0)
  ...
end
---

This is mostly boilerplate. But now check out what I am having to do in the wrapper, in this particular snippet:

--- ruby
def self.blank?(self : LibRuby::VALUE)
  return true.to_ruby if LibRuby.rb_str_length(self) == 0
  str = String.from_ruby(self)
  str.blank?.to_ruby
rescue
  true.to_ruby
end
---

I am receiving a C-Ruby String casted as a pointer (VALUE) then I go through the lib_ruby.cr mappings to get the C-Ruby string data and copy it over into a new instance of Crystal's internal String representation. So at any given time I have 2 copies of the same string, one in the C-Ruby memory space and another in the Crystal memory space.

This happens with all FFI-like extensions but it doesn't happen to the pure C implementation. In Sam Saffrom's C implementation it directly works with the same address in C-Ruby's memory space:

--- C
static VALUE
rb_str_blank(VALUE str)
{
  rb_encoding *enc;
  char *s, *e;

  enc = STR_ENC_GET(str);
  s = RSTRING_PTR(str);
  ...
---

It receives a pointer (direct memory address) and goes. And this is huge advantage for the C version. When you have a big volume of medium to large sized strings being copied over from C-Ruby to Crystal, it adds a noticeable overhead that can't be removed.

### String mapping Caveat

I still have a problem though. There is one edge case I was not able to overcome yet (help is most welcome). When C-Ruby passes a unicode `"\u0000"` I am unable to create the same character in Crystal and I end up passing just an empty string ("") which is not the same thing.

The way to deal with it is to receive a Ruby String (VALUE) and get the C-String from it this way:

--- ruby
rb_str = LibRuby.rb_str_to_str(str)
c_str  = LibRuby.rb_string_value_cstr(pointerof(rb_str))
---

If the "str" is the "\u0000" (under Ruby 2.2.5 at least) C-Ruby raises a "string contains null bytes" exception. Which is why I rescue from this exception like this:

--- ruby
c_str = LibRuby.rb_rescue(->String.cr_str_from_rb_cstr, str, ->String.return_empty_string, 0.to_ruby)
---

When an exception is triggered I have to pass the pointer to another function to rescue from it:

--- ruby
def self.return_empty_string(arg : LibRuby::VALUE)
  a = 0_u8
  pointerof(a)
end
---

But this is not correct, I am just passing the pointer to a "0" character, which is "empty". Therefore, specs are not passing correctly:

---
Failures:

  1) String provides a parity with active support function
     Failure/Error: expect("#{i.to_s(16)} #{c.blank_as?}").to eq("#{i.to_s(16)} #{c.blank2?}")

       expected: "0 false"
            got: "0 true"

       (compared using ==)
     # ./spec/fast_blank_spec.rb:22:in `block (3 levels) in <top (required)>'
     # ./spec/fast_blank_spec.rb:19:in `times'
     # ./spec/fast_blank_spec.rb:19:in `block (2 levels) in <top (required)>'

  2) String treats  correctly
     Failure/Error: expect("\u0000".blank_as?).to be_falsey
       expected: falsey value
            got: true
     # ./spec/fast_blank_spec.rb:47:in `block (2 levels) in <top (required)>'
---

Ary gave a simple tip later, I will add it to the conclusion below.

### The Synthetic Benchmarks (careful on how you interpret them!)

The [original Rails ActiveSupport implementation of String#blank?](https://github.com/rails/rails/blob/2a371368c91789a4d689d6a84eb20b238c37678a/activesupport/lib/active_support/core_ext/object/blank.rb#L101) looks like this:

--- ruby
class String
  # 0x3000: fullwidth whitespace
  NON_WHITESPACE_REGEXP = %r![^\s#{[0x3000].pack("U")}]!

  # A string is blank if it's empty or contains whitespaces only:
  #
  #   "".blank?                 # => true
  #   "   ".blank?              # => true
  #   "　".blank?               # => true
  #   " something here ".blank? # => false
  #
  def blank?
    # 1.8 does not takes [:space:] properly
    if encoding_aware?
      self !~ /[^[:space:]]/
    else
      self !~ NON_WHITESPACE_REGEXP
    end
  end
end
---

It's mainly a regular expression comparison, which can be a bit slow. Sam's version is a more straight forward loop through the string to compare each character with what's considered "blank". There are many unicode codepoints that are considered blank, some are not, which is why the C and Crystal versions are similar, but they are different from Rails' version.

In the Fast Blank gem there is a `benchmark` Ruby script to compare the C-extension against Rails' Regex based implementation.

The Regex implementation is called **"Slow Blank"**. It's particularly slow if you pass a real empty String, so in the benchmark Sam added a **"New Slow Blank"** that checks through `String#empty?` first, and this version is faster in this edge case.

The fast C version is called **"Fast Blank"** but although you can consider ir "correct" it's not compatible with all the edge cases from Rails. So he implemented a `String#blank_as?` which is compatible with Rails. Sam calls it **"Fast Activesupport"**.

In my Crystal version I did the same, having both `String#blank?` and `String#blank_as?`.

So, without further ado, here is the **C Version over OS X** benchmark for empty strings, and we exercise each function many times within a few seconds to have more accurate results (check out Evan Phoenix's ["benchmark/ips"](https://github.com/evanphx/benchmark-ips) to understand the "iteration per second" methodology).

---
================== Test String Length: 0 ==================
Warming up _______________________________________
          Fast Blank   191.708k i/100ms
  Fast ActiveSupport   209.628k i/100ms
          Slow Blank    61.487k i/100ms
      New Slow Blank   203.165k i/100ms
Calculating _______________________________________
          Fast Blank     20.479M (± 9.3%) i/s -    101.414M in   5.001177s
  Fast ActiveSupport     21.883M (± 9.4%) i/s -    108.378M in   5.004350s
          Slow Blank      1.060M (± 4.7%) i/s -      5.288M in   5.001365s
      New Slow Blank     18.883M (± 6.9%) i/s -     94.065M in   5.008899s

Comparison:
  Fast ActiveSupport: 21882711.5 i/s
          Fast Blank: 20478961.5 i/s - same-ish: difference falls within error
      New Slow Blank: 18883442.2 i/s - same-ish: difference falls within error
          Slow Blank:  1059692.6 i/s - 20.65x slower
---

It's super fast. Rails' version is 20x slower on my machine.

Now, **Crystal version over OS X**

---
================== Test String Length: 0 ==================
Warming up _______________________________________
          Fast Blank   174.349k i/100ms
  Fast ActiveSupport   174.035k i/100ms
          Slow Blank    64.684k i/100ms
      New Slow Blank   215.164k i/100ms
Calculating _______________________________________
          Fast Blank      8.647M (± 1.6%) i/s -     43.239M in   5.001530s
  Fast ActiveSupport      8.580M (± 1.3%) i/s -     42.987M in   5.010759s
          Slow Blank      1.047M (± 3.7%) i/s -      5.239M in   5.008907s
      New Slow Blank     19.090M (± 9.3%) i/s -     94.672M in   5.009057s

Comparison:
      New Slow Blank: 19090034.8 i/s
          Fast Blank:  8647459.7 i/s - 2.21x slower
  Fast ActiveSupport:  8580487.9 i/s - 2.22x slower
          Slow Blank:  1047465.3 i/s - 18.22x slower
---

As I explained before, even checking empty strings, the Crystal version is slower than the Ruby check for `String#empty?` (New Slow Blank) because I have the string copying routine of the Wrapper mappings. This adds overhead that is perceptible over many iterations. It's still 18x faster than Rails, but it loses to C-Ruby.

Finally, ** Crystal version over Ubuntu**

---
================== Test String Length: 0 ==================
Warming up _______________________________________
          Fast Blank   255.883k i/100ms
  Fast ActiveSupport   260.915k i/100ms
          Slow Blank   105.424k i/100ms
      New Slow Blank   284.670k i/100ms
Calculating _______________________________________
          Fast Blank      8.895M (± 9.8%) i/s -     44.268M in   5.037761s
  Fast ActiveSupport      8.647M (± 8.2%) i/s -     43.051M in   5.020125s
          Slow Blank      1.736M (± 3.9%) i/s -      8.750M in   5.048253s
      New Slow Blank     22.170M (± 6.2%) i/s -    110.452M in   5.004909s

Comparison:
      New Slow Blank: 22170031.0 i/s
          Fast Blank:  8895113.3 i/s - 2.49x slower
  Fast ActiveSupport:  8646940.8 i/s - 2.56x slower
          Slow Blank:  1736071.0 i/s - 12.77x slower
---

Notice that it's around the same ballpark, but the Rails version on Ubuntu runs almost twice as fast compared to its counterpart in OS X, which makes the comparison against the Crystal library go down from 18x to 12x.

The benchmark keeps comparing agains strings of larger and larger sizes, from 6, to 14, to 24, up to 136 characters in length.

Let's get just the last test case of 136 characters. First with **C version on OS X**:

---
================== Test String Length: 136 ==================
Warming up _______________________________________
          Fast Blank   177.521k i/100ms
  Fast ActiveSupport   193.559k i/100ms
          Slow Blank    89.378k i/100ms
      New Slow Blank    60.639k i/100ms
Calculating _______________________________________
          Fast Blank     10.727M (± 8.7%) i/s -     53.256M in   5.006538s
  Fast ActiveSupport     11.600M (± 8.3%) i/s -     57.681M in   5.009692s
          Slow Blank      1.872M (± 5.7%) i/s -      9.385M in   5.029243s
      New Slow Blank      1.017M (± 5.3%) i/s -      5.094M in   5.022994s

Comparison:
  Fast ActiveSupport: 11600112.2 i/s
          Fast Blank: 10726792.8 i/s - same-ish: difference falls within error
          Slow Blank:  1872262.5 i/s - 6.20x slower
      New Slow Blank:  1016926.7 i/s - 11.41x slower
---

The C-version is consistently much faster in all test cases and in the 136 characters it's still 11x faster than Rails in pure Ruby.

Now the **Crystal version over OS X**:

---
================== Test String Length: 136 ==================
Warming up _______________________________________
          Fast Blank   127.749k i/100ms
  Fast ActiveSupport   126.538k i/100ms
          Slow Blank    94.390k i/100ms
      New Slow Blank    60.594k i/100ms
Calculating _______________________________________
          Fast Blank      3.283M (± 1.8%) i/s -     16.480M in   5.021364s
  Fast ActiveSupport      3.235M (± 1.3%) i/s -     16.197M in   5.008315s
          Slow Blank      1.888M (± 4.4%) i/s -      9.439M in   5.009458s
      New Slow Blank    967.950k (± 4.7%) i/s -      4.848M in   5.018946s

Comparison:
          Fast Blank:  3283025.1 i/s
  Fast ActiveSupport:  3234586.5 i/s - same-ish: difference falls within error
          Slow Blank:  1887800.5 i/s - 1.74x slower
      New Slow Blank:   967950.2 i/s - 3.39x slower
---

It's also faster, but just by 2 to 3 times compared to pure Ruby, a far cry from 11x. But my hypothesis is that the mapping and copying of so many string over adds a large overhead that the C version does not have.

And the **Crystal version over OS X**:

---
================== Test String Length: 136 ==================
Warming up _______________________________________
          Fast Blank   186.810k i/100ms
  Fast ActiveSupport   187.306k i/100ms
          Slow Blank   143.439k i/100ms
      New Slow Blank    98.308k i/100ms
Calculating _______________________________________
          Fast Blank      3.517M (± 3.9%) i/s -     17.560M in   5.000791s
  Fast ActiveSupport      3.485M (± 3.8%) i/s -     17.419M in   5.006427s
          Slow Blank      2.755M (± 4.2%) i/s -     13.770M in   5.008490s
      New Slow Blank      1.551M (± 4.3%) i/s -      7.766M in   5.017853s

Comparison:
          Fast Blank:  3516960.7 i/s
  Fast ActiveSupport:  3484575.5 i/s - same-ish: difference falls within error
          Slow Blank:  2754669.0 i/s - 1.28x slower
      New Slow Blank:  1550815.2 i/s - 2.27x slower
---

Again, the Ubuntu versions of both Crystal library but also the Ruby binary runs faster and the comparison shows no more than twice as much faster. And the pure Ruby's `String#empty?` is in the same ballpark as Crystal's version.

### Conclusion

The most obvious conclusion is that I probably did a mistake in choosing Fast Blank as my first proof of concept. The algorithm is too trivial and a simple check for `String#empty?` in pure Ruby is orders of magnitude faster than the added overhead of mapping and string copying to Crystal.

Also, any use case where you have a huge amount of small bits of data being transferred from C-Ruby to Crystal or any FFI-based extension will have the overhead of data copying, which a pure C-version will not have. Which is why Fast Blank is better done in C.

Any other use case where you have less amounts of data, or data that can be transferred in bulk (less calls from C-Ruby to the extension, with arguments with a larger size, and with more costly processing) are better candidates to benefit from extensions.

Again, not everything gets automatically faster, we always have to figure out the use case scenarios first. But because it's so much easier to write in Crystal and benchmark, we can make faster proofs of concepts and scrap the idea if the measurements prove that we won't benefit as much.

The Crystal documentation recently received a ["Performance Guide"](https://crystal-lang.org/docs/guides/performance.html). It's very useful for you to avoid common pitfalls that harms overall performance. Even though LLVM is quite competent in heavy optimization, it can't do everything. So read it through to improve your general Crystal skills.

That being said, I still believe that this exercise was well worth it. I will probabaly do some more. I'd really want to thank Ary (Crystal creator) and Paul Hoffer for the patience in helping me out through many of quircks I found along the way.

While I was finishing this post, [Ary pointed out](https://github.com/SamSaffron/fast_blank/pull/20#issuecomment-230875300) that I could probably ditch Strings altogether and work directly with an array of bytes, which is a good idea and I will probably try that. I think I made it clear by now that the whole String copying adds a very perceptible overhead as we saw in the benchmarks above. Let me know if someone is interested in contributing as well. With a few more tweaks I believe we can have a Crystal version that can at least compete against the C version while also being more readable and maintainable for most Rubyists, which is my goal.

I hope the codes I published here will serve as boilerplate examples for more Crystal-based Ruby extensions in the future!
