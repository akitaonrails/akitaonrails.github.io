---
title: "Omarchy 3 - One of the Best Coding Agents Out There: Crush"
slug: "omarchy-3-one-of-the-best-coding-agents-crush"
date: 2026-01-09T20:01:04-0300
draft: false
translationKey: omarchy-3-crush
tags:
- omarchy
- AI
---

Last year I was recommending [Aider](https://aider.chat/) as the go-to coding agent. But it kind of stopped in time. Compared to the Cursors and Windsurfs of the world, it fell pretty far behind.

Lucky for us, the open source side is cooking up new options. DHH decided to bring [OpenCode](https://opencode.ai/) into Omarchy 3.x.

[![dhh opencode](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109200839_screenshot-2026-01-09_20-08-17.png)](https://x.com/dhh/status/2007589042485883374)
After I ran the upgrade (just `omarchy-update`) I noticed I also got the option to install the one I'm starting to play with now, [**CRUSH**](https://github.com/charmbracelet/crush).

Crush is from the same crew that's been cranking out a bunch of libraries to make TUI (Terminal User Interface) development easier, like [BubbleTea](https://github.com/charmbracelet/bubbletea) and [Gum](https://github.com/charmbracelet/gum). I'd recommend digging into those repos too. Building terminal apps is way more interesting these days, especially dev tools or anything Linux-flavored.

It's a really well-built TUI. Here's what it looks like:

![Crush UI](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109202710_screenshot-2026-01-09_20-26-58.png)

For a first pass I ran it on this little blog project, which is a static site generated with [Hugo](https://akitaonrails.com/2025/09/10/meu-novo-blog-como-eu-fiz/).

Since I already have the env vars set up for [OpenRouter](https://openrouter.ai/docs/quickstart), I didn't even need to configure anything. Just `crush` inside the project directory.

The first thing it did was analyze my project. It's small, so it was quick. I have no idea how it handles giant projects. But it goes scanning through the source code and at the end writes everything down in an [AGENTS.md](https://github.com/akitaonrails/akitaonrails.github.io/blob/master/AGENTS.md) file. And I was impressed by how good of a job it did summarizing the project. Take a look at this snippet:

![agents.md](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109201559_screenshot-2026-01-09_20-15-47.png)
I didn't even know I had the option of running `scripts/dev.sh new-post` to automatically create the timestamped subdirectory for a new post. I'd been doing that by hand every single time 😅.

I knew my [`scripts/generate_index.rb`](https://github.com/akitaonrails/akitaonrails.github.io/blob/master/scripts/generate_index.rb) script was kind of a mess, so I asked Crush if it could refactor it:

![refactor generate_index](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109201839_screenshot-2026-01-09_20-18-30.png)
And in the end it refactored the thing nicely, no new bugs introduced, no rewriting stuff that didn't need rewriting. It really nailed refactoring only what needed to be touched. It changed things like using `Dir.glob` instead of `Find.find`, switched to symbols instead of strings (more idiomatic), that kind of thing.

I liked that it ran the modified version and checked that it still worked the way it was supposed to.

Then I asked it to do the same thing with [`scripts/dev.sh`](https://github.com/akitaonrails/akitaonrails.github.io/blob/master/scripts/dev.sh):

![refactor dev.sh](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109202153_screenshot-2026-01-09_20-21-44.png)
And in this case it actually found a bug I hadn't noticed. Again, it edited the shell script to make it safer, separated constants out, improved error checking, and so on.

Here's the [commit with the changes](https://github.com/akitaonrails/akitaonrails.github.io/commit/440470b09e822af0dc23a7c6aec73b4ead89caf7). Take a look. It really didn't add any unnecessary code. Everything still works the way it did before, but now it's more organized. And on top of that it caught a bug I had missed.

For this little example I picked the **Claude Opus 4.5** model. All the code came out of it. Crush is just the agent that talks to the model and feeds it the right context.

So far I've only done easy, dumb stuff. The docs say it integrates with LSPs and MCPs to get even more context about the code, but I haven't tested that yet.

Either way, I figured I'd write a quick post just to say that these new options like Crush and OpenCode are already plenty good for daily use. Worth trying on your own project.

### Second Test

Since Crush did fine with that basic web test, I figured I'd throw it last year's challenge. I'd built a tiny command-line project that's a basic chat, written from scratch, talking directly to the llama.cpp library, with CUDA, in Zig — which is a low-level language, still experimental and unfinished. The whole point of the challenge is that almost nobody uses it, so there's barely any documentation or examples. The LLM has to actually sweat to make it work.

Unlike a web page with React and Tailwind — which has thousands of forum posts, tutorials, blog posts and everything else — Zig has almost nothing. The only popular app I know of that uses Zig is Ghostty.

To make it worse, a new version came out recently, 0.15, which changed a whole bunch of the IO API (in preparation for better Async IO support). New versions of Llama, Cuda, etc. also dropped. So the idea was to use Crush with Claude Opus to see if it could refactor, fix bugs, update the APIs, and get to the point of compiling a working binary.

In short: **it pulled it off!**

![crush - qwen-cli-zig](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109211613_screenshot-2026-01-09_21-15-57.png)
On the first refactoring pass, it burned only USD 5.64 of credit on my Anthropic account. It managed to take the spaghetti monolith (which I'd written that way on purpose as a challenge) and split it into smaller files like `chat.zig` and `llama.zig`.

It managed to map the C functions from Llama as Zig functions. It managed to figure out that things like ArrayList changed in the new Zig. It managed to figure out that all the IO APIs changed in 0.15. And it managed to modify the right places.

It ran `zig build`, checked the errors and made fixes that actually made sense, until it produced the final binary.

You can check the [Pull Request](https://github.com/akitaonrails/qwen-cli-zig/pull/1/files) with everything it did. It was a pretty reasonable amount of change and didn't leave the project broken.

![llama.cpp externs](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109212115_screenshot-2026-01-09_21-21-03.png)
The fact that it managed to consult the Zig 0.15 documentation, and also correctly infer which new Llama.cpp functions it should make extern, was pretty impressive.

Anyway, on the first pass it got to the point where it compiles. But that doesn't mean it works. And sure enough, when I tried to run it, it ended in a segmentation fault:

![qwen-cli-zig segmentation fault](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109213331_screenshot-2026-01-09_21-33-22.png)

So I asked Crush to run it and look at the error. It found the bug and made the necessary changes. It found a wrong struct and even caught a memory leak. It fixed both and now the program runs the way it should:

![qwen-cli-zig](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109213702_screenshot-2026-01-09_21-36-23.png)
Like I said, it's a goofy little chat program that uses Llama.cpp directly to load the Qwen3 model and open a chat for me to talk to. It's just an exercise — a chat like this already exists, all you have to do is use Ollama. But I wanted to build one from scratch, low level, as an exercise for LLMs. Up to last year, no LLM I tested could finish this program properly. But now one finally did.

![crush explanation of the crash](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109213930_screenshot-2026-01-09_21-39-22.png)

And as you can see, in the end I spent almost 8 bucks to refactor it, fix the bugs, and get this program working properly. Not cheap, but at least it wasn't credits thrown out the window like it was a year ago. I haven't tested it with local LLMs yet, to see if Crush can land on similar results.

But the fact that it can deal with a language as obscure as Zig has me genuinely excited to play with this more. The tooling and LLMs have finally hit a point where they're actually practical to use. I'm not saying it solves everything, but compared to a year ago, it's a real leap.

I'd recommend giving Crush a spin with other models too. I only played with Opus a little, but other models can give you different results depending on the kind of problem you're trying to crack.
