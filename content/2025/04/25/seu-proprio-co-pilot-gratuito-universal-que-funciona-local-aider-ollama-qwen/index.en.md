---
title: 'Your Own Free Universal Co-Pilot Running Local: AIDER-OLLAMA-QWEN'
date: '2025-04-25T13:40:00-03:00'
slug: your-own-free-universal-copilot-running-local-aider-ollama-qwen
tags:
- aider
- ollama
- qwen
- python
- docker
- llm
- sdpa
  - AI
draft: false
translationKey: local-copilot-aider-ollama-qwen
description: "How to run Aider with Ollama and Qwen 2.5 Coder locally to build a free, universal Co-Pilot alternative that works with any editor."
---

In my [previous post](https://www.akitaonrails.com/en/2025/04/25/hello-world-de-llm-criando-seu-proprio-chat-de-i-a-que-roda-local) I show how to build an LLM chat from scratch, capable of loading code files for refactoring. I demonstrate the principles behind tools like Co-Pilot, Cursor or Windsurf. The summary is simple:

- A GOOD RULES PROMPT
- SCRIPTS that run locally and add more context to the chat session.



That's basically "all" there is to it (of course, even though the principle is simple, it still takes a lot of work to actually implement). And I don't need to build everything from scratch. There is already an open source alternative that does exactly all of this, the tool that became the most popular over the past months for software development, [**AIDER**](https://aider.chat/docs/install.html)

What I like about AIDER:

+ it works with practically any LLM, closed or open, thanks to using [**LiteLLM**](https://www.litellm.ai/) underneath, which abstracts and organizes every configuration like context window size, temperature and other parameters known to work best for each LLM.
+ it's OPEN SOURCE, so besides being free you can also learn more by reading the source code, like I did.
+ no need for special - and proprietary - plugins to install in each IDE: it has a "watch files" feature. So I can leave it open in one terminal pane and my favorite editor in the other pane: NeoVIM. You can integrate with plugins, but it's optional. It will work for everything, even Notepad, if you're masochistic.

I tried a bit of that "vibe coding" crap only through the web interface of ChatGPT, Gemini, Claude, and I'll say that all of them are crap. To build a small project that was simple, with no more than 4 short files, it gave me A LOT of trouble. Some of them:

- it doesn't take long before it starts mixing the content of one file into another.
- mistakes it made, I explained it was wrong, it corrected, but right after it repeats the same thing.
- it doesn't run anything, so it guesses a lot, like file paths, library versions
- it doesn't matter that the context is big and you can upload many files to context, it's a sliding window: it won't pay attention to everything at the same time. The more code files you upload, the more quality degrades
- you have to write a lot to explain what you want and, especially, why it got it wrong and how to fix it.
- credits are expensive, they run out really fast, because you waste half the tokens just explaining mistakes and reuploading the same files more than once because you realize it already "forgot". I hit the Claude limit, and the Gemini limit, super fast (I pay the first paid plan, I'm not going to pay the most expensive one). Then you have to wait a few hours to come back (awful).

All of this, someone will comment _"Oh, but for me it worked."_ I don't give a damn, I didn't ask. I said that FOR ME it went this way, just accept it. What matters is saying that the whole "virtual employee" or "fully replacing a programmer" or "building a whole project without knowing how to code at all" story is **BALONEY**, **FAIRY TALE**, **CON ARTIST TALE**, **AMATEUR ILLUSION**, etc.

All LLMs are **JUST ANOTHER TOOL** that someone who truly understands, like us programmers, will know how to use much better than any "amateur entrepreneur" ever will. And I'm going to prove it.

### Basic Aider

Installing Aider is easy, you just need to have Python >= 3.12 on your machine, which every modern Linux has. Their documentation is very good, [I recommend reading it](https://aider.chat/docs/install.html) to know what they recommend post-install. It has many tips.

```
python -m pip install aider-install
aider-install
```

What they don't say in the documentation is that the first thing to do is download [this sample file](https://github.com/Aider-AI/aider/blob/main/aider/website/assets/sample.aider.conf.yml) and place it at `$HOME/.aider.conf.yml`. In it there is one important thing we have to change:

```yaml
...
## Enable/disable auto commit of LLM changes (default: True)
auto-commits: false
...
```

I recommend reading this file, it is fully commented and may have options you want to turn off, but this one is annoying, because - by default - this damn thing does "AUTO COMMIT" on your Git, every time it changes something in your code. It doesn't even give me a chance to review. It runs on "TRUST US". No way, turned off.

This is the kind of thing an amateur wouldn't do, and I even understand. Amateurs don't know how to organize git commits anyway, so probably the automatic Aider messages will be the lesser evil. Look how it ends up:

![Aider Git commit](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/22ji8rp2bbw5lsxwbmpneh5clhcr)

Heads up to juniors: this is the kind of thing that if I were evaluating, would earn you negative points if I saw it done this way. Do it right: re-check the changes and organize into real commits. Aider "says" it did a refactor, but it doesn't always get it right, yet it still commits, and then it gets pushed wrong. If the plan is to push everything automatically, even with errors, really, I don't need you.

But I'm getting ahead of myself, after installing Aider, you need to configure the API KEYS for each service you use, whether OpenAI, Claude or others. Whoever uses ChatGPT on Linux already has a variable like `export OPENAI_API_KEY=sk-proj-........` set up in `.bashrc` or `.zshrc`.

Once that's done, you can pick which model to use:

```
# Change directory into your codebase
cd /to/your/project

# o3-mini
aider --model o3-mini

# o1-mini
aider --model o1-mini

# GPT-4o
aider --model gpt-4o

# List models available from OpenAI
aider --list-models openai/
```

And that will already open an interactive chat. You can also, before opening the chat, tell it to load local files like this:

```
aider README.md init.py utils.py ...
```

Or, from inside the chat, it accepts [several commands](https://aider.chat/docs/usage/commands.html) starting with slash "/", similar to an IRC chat. For example:

```
/add helper.py
/copy # copies the last code suggestion to the clipboard
/git # runs a local git command from the chat
/run # runs a shell command and adds the output to the chat
/web # goes to a web page and pulls the content into the chat
```

Read the documentation. But the most interesting mode is "watch-files". Just be inside your project directory and start it like this:

```
aider --watch-files
```

It uses the Python [watchfiles](https://pypi.org/project/watchfiles/) library to intercept IO calls in that directory and trigger the loading of your files on its own, as soon as you save in your favorite editor (that's why I said no extra plugin is needed if you don't want one). Heads up that this lib doesn't support watching SMB or NFS mounts (yes, I tested it).

In your editor, just create a comment near the code you want it to work on, like this:

```
// can you refactor this return so it has more error checking? AI!
export const getCapitalizedLabel = (name: string): string => {
  return name
    .replace(/_/g, " ")
    .split(" ")
    .map((word: string) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(" ")
}
```

Put in the comment what you want it to do, and end with the "AI!" trigger. Then on the other terminal where Aider is loaded, it will notice that the file was saved:

```
>

Added src/utils/getCapitalizedLabel.ts to the chat
Processing your request...
...
```

And it will do its "magic" (whose secret I'll tell you in a moment). This is the example of what it did (same results with both o4-mini and Qwen2.5, but it's a pretty trivial example):

```js
export const getCapitalizedLabel = (name: string): string => {
  if (typeof name !== 'string') {
    throw new TypeError('Expected a string');
  }

  return name
    .replace(/_/g, " ")
    .split(" ")
    .map((word: string) => {
      if (word.length === 0) return word;
      return word.charAt(0).toUpperCase() + word.slice(1);
    })
    .join(" ");
}
```

A graphical editor like Visual Studio Code, as soon as Aider changes the file, reloads it in the editor and you already see the changes. On NeoVim, autoread usually reloads automatically too, but sometimes I need to issue the ":e" command to force a reload, but nothing major. And just with that we already have an efficient work workflow.

My favorite editor works exactly the same way, without a plugin slowing it down or conflicting with anything. If I need to do pair programming, I call Aider in another terminal and done, just write ideas as comments, and it sends suggestions. Since I turned off the damn auto-commit, if I don't like it, I just UNDO or `git checkout` the file and it's back like it was.

More than that. If I notice that the `o4-mini` model isn't giving good results, I can switch to `--model gemini` - which tends to be better for code than o4. Or `--model claude-3-opus-20240229`. Speaking of Claude, as I said before [read the fucking documentation](https://aider.chat/docs/llms/anthropic.html)

The documentation says that Aider supports "thinking tokens" from Sonnet 3.7. There is a config file where we can do "fine-tuning" for each model, the `$HOME/.aider.model.settings.yml` where we can add:

```yaml
- name: anthropic/claude-3-7-sonnet-20250219
  edit_format: diff
  weak_model_name: anthropic/claude-3-5-haiku-20241022
  use_repo_map: true
  examples_as_sys_msg: true
  use_temperature: false
  extra_params:
    extra_headers:
      anthropic-beta: prompt-caching-2024-07-31,pdfs-2024-09-25,output-128k-2025-02-19
    max_tokens: 64000
    thinking:
      type: enabled
      budget_tokens: 32000 # Adjust this number
  cache_control: true
  editor_model_name: anthropic/claude-3-7-sonnet-20250219
  editor_edit_format: editor-diff
```

### Reasoning

Thinking or Reasoning as it is called in the marketing of most commercial LLMs is the "chain-of-thought" pattern, which is a prompting technique where you ask the LLM not to give an answer, but to describe "step by step" how it would reach the answer, and then repeat the question telling it to follow those steps and then give an answer.

In practice there are several ways to implement something similar. And one of them is to be Multi-Model. Especially with open source models, like DeepSeek-Coder or Qwen2.5-Coder or Llama3. Some models are better at reasoning - at verbally explaining what has to be done, but they are bad at actually writing the code. And some models are not good at explaining things in detail, but were trained to write good code.

We can use this in our favor and Aider has a feature I think is really badass - for cases where you really need it, because it's heavy - which is running in **architect mode**, generating the reasoning and then switching to **code mode** on another model, and using that reasoning to assemble better code.

There is a [whole article](https://aider.chat/2024/09/26/architect.html) in the Aider documentation explaining this, but the motivation came from the OpenAI o1 model, which is precisely strong at reasoning an explanation of what to do, but bad at actually writing the code. So it's worth listening to o1 and letting it analyze the problem and describe it in text form, and then switching to Gemini Pro or Exp and telling it to write the code.

In practice, just start Aider first in "Architect" mode:

```
pip install -U aider-chat

# Change directory into a git repo
cd /to/your/git/repo

# Work with Claude 3.5 Sonnet as the Architect and Editor
export ANTHROPIC_API_KEY=your-key-goes-here
aider --sonnet --architect
```

And this works with other models:

```
# Work with OpenAI models, using gpt-4o as the Editor
export OPENAI_API_KEY=your-key-goes-here
aider --4o --architect
aider --o1-mini --architect
aider --o1-preview --architect
```

As an example, setting `OPENAI_API_KEY` and `GEMINI_API_KEY` I can launch o4 as architect and Gemini as the coder:

```
❯ aider --watch-files --architect --editor-model gemini
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Using gpt-4o model with API key from environment.
Aider v0.82.3.dev55+g25a30393
Main model: gpt-4o with architect edit format
Editor model: gemini/gemini-2.5-pro-preview-03-25 with editor-diff edit format
Weak model: gpt-4o-mini
Git repo: .git with 184 files
Repo-map: using 4096 tokens, auto refresh
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
architect>
```

See in the startup status that it accepted both. Now just code the same way as before, but using both. Obviously, this way you'll burn a lot more credits! Watch out for that! There are **chances** of better results but you **certainly** will spend more credits, so use this more for more complex code, where a single model is struggling to solve it.

Note there are configurations and token limits, and also note that at the end of every response, Aider gives an estimate of how much it's costing you. Here first is the bill from the OpenAI o4 architect:

```
...
This should make the function more concise and efficient.


Tokens: 4.4k sent, 246 received. Cost: $0.01 message, $0.01 session.
```

And here is the SECOND bill from the Coder Gemini 2.0 Flash:

```
...
Tokens: 1.9k sent, 136 received. Cost: $0.0037 message, $0.02 session.
Applied edit to src/utils/getCapitalizedLabel.ts
```

Free Gemini has a "rate limit" (number of requests allowed per minute, super low, only 15 RPM, for an API it's ridiculous, Aider hits it on the first try).

Not rarely, you'll hit the plan limit, and that's a pain:

```
The API provider has rate limited you. Try again later or check your quotas.
Retrying in 4.0 seconds...
```

Then there's no way around it, you have to go to the [Google AI Studio]() site, set up your billing account, add your card and move up to a slightly better paid plan like 2.0 Flash, which supports 2,000 RPM and 4M TPM and the price isn't expensive:

![Gemini 2.0 Flash](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ozbz5tvmpyla0huinqa6da2iwb1m)

Some say that today Gemini 2.0 has delivered code results similar or superior to Claude Sonnet 3.7. It varies case by case, it's never an absolute measure, but in my small experience, both are very good and I see both being superior even to ChatGPT 4 or o4. But OpenAI, for me, has really been better at "verbal" responses, so the strategy of separating the "architect" role for OpenAI and the "coder" role for Gemini or Claude makes A LOT of sense.

In the end, that initial code I asked to refactor, in this architect/editor combination came out like this:

```js
export const getCapitalizedLabel = (name: string): string => {
  return name
    .replace(/_/g, ' ')
    .replace(/\b\w/g, char => char.toUpperCase());
}
```

Ok, I wouldn't have thought of it this way.

### Not using "Token Credits": OLLAMA

Now comes the most interesting part for us, more hard-core nerds, with beefier machines (at minimum an RTX 3090, I use an RTX 4090 - what matters is having **24GB of VRAM**). You can use smaller models that fit in less VRAM, but then the code result will be much worse, so you're better off sticking with Gemini or Claude.

If you have the machine for it, with CUDA Toolkit already installed, it's time for the grown-up solution: installing Ollama. On my Manjaro/Arch it goes like this:

```
yay -S ollama ollama_cuda
```

Be sure to check your CUDA configuration because by default Ollama will silently run on your CPU and everything will be ABSURDLY SLOW.

Ollama works both as a local HTTP server for APIs, and as an interactive chat client, like my qwen_cli from the previous post. It works with logic more or less similar to Docker. It can be configured to start automatically as a service on your system. See the [ArchWiki documentation](https://wiki.archlinux.org/title/Ollama).

I prefer to start it manually in a terminal, where I can see the log of what's happening:

```
OLLAMA_FLASH_ATTENTION=1 OLLAMA_CONTEXT_LENGTH=8192 ollama serve
```

There are several configurations via environment variables. You can just set them in your `/etc/profile` or `~/.zshrc` but since I'm testing, I prefer to launch directly on the command line. With this we'll have a web server. To work with Aider, again, just declare where to find it in your `/.zshrc`:

```
export OLLAMA_API_BASE=http://127.0.0.1:11434
```

Now, we need to download some model, like my favorite Qwen 2.5 Coder, which I already used in the previous post:

```
ollama pull qwen2.5-coder:32b
```

Note I'm explicitly asking for the 32B version, but you can try a lighter one like the 7b. Each model supported by Ollama has [a page](https://ollama.com/library/qwen2.5-coder) describing details of this sort:

![qwen 2.5 coder page](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/q76sz7qyqupk8jv3gm1igpk4q0i3)

Depending on which synthetic benchmark you "believe in" you'll see comparisons like this one:

![comparison](https://ollama.com/assets/library/qwen2.5-coder/bbf378d8-c80e-4ae3-98ab-90111dfbf3e7)

In practice, Claude, ChatGPT, Gemini, really are already very good for code. In the open source world the options are Qwen 2.5 Coder, Deepseek-Coder-V2 (which still doesn't work very well in Aider, we have to wait for updates). So, if you want everything for free, the best for now is Qwen 2.5 Coder. And in my experience, it has worked very well. But it is VERY heavy in the 32B version and responses are considerably slower than a paid option like Gemini. So it depends a lot on your case.

Once the model is downloaded, you need to configure the context window (by default it's quite small, only 2K tokens), [the documentation warns](https://aider.chat/docs/llms/ollama.html) about this and you have to edit the file `$HOME/.aider.model.settings.yml` like this:

```yaml
- name: ollama/qwen2.5-coder:32b
  extra_params:
    num_ctx: 65536
```

What the documentation does **NOT** explain and, because of that, I spent a long time digging through the source code and Issues on GitHub, is that to launch open source models, you need to use the `ollama_chat/` option and not `ollama` as it tells you. That is, the documentation says:

```
aider --model ollama/qwen2.5-coder:32b
```

But the CORRECT way is to do:

```
aider --model ollama_chat/qwen2.5-coder:32b
```

Otherwise, the responses will be completely random, out of context. Pay attention to this. But knowing this, we can even do what I mentioned before: mix models! How about launching GPT o4 as architect and letting it command the editor being Qwen 2.5?

```
aider --watch-files --architect --editor-model ollama_chat/qwen2.5-coder:32
```

Yes, this is possible. Now you can use a commercial model you're more used to, like Gemini or Claude, in both architect and editor roles, and an open source model like Qwen 2.5 as support, and pay less. Or just use Qwen 2.5 all the way and pay **zero credits** (only electricity, of course, it will draw **+200W** from the wall every time, but just for a few seconds each time).

In my (little) experience. Gemini still produces better code than Qwen, but that doesn't mean Qwen is bad, as I said, it will depend A LOT on your prompt instructions (the more detailed the better). And speaking of instructions, let's move on to the final part:

### The Secret of the Magic: Prompts

I make fun when someone talks about "prompt engineering", but in reality, the best way to get the most out of an LLM is to make the best possible prompt. This doesn't mean the "longest prompt". It's quality and not quantity.

That's why both [Microsoft](https://github.com/microsoft/generative-ai-for-beginners) and [Google](https://www.kaggle.com/whitepaper-prompt-engineering) made detailed guides focused on prompting. Theirs are worth reading and studying. What isn't worth it is paying for courses from random people talking about "prompt engineering" as if they understood anything.

Aider supports a "--verbose" option, where it shows exactly what it is sending to the LLMs. Let's test. Right away it already prints this to the console:

```
❯ aider --watch-files --verbose
Config files search order, if no --config:
  - /tmp/smells/.aider.conf.yml
  - /home/akitaonrails/.aider.conf.yml (exists)
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Too soon to check version: 11.6 hours
Command Line Args:   --watch-files --verbose
Config File (/home/akitaonrails/.aider.conf.yml):
  max-chat-history-tokens:8192
  map-tokens:        4096
  auto-commits:      False
Defaults:
  --set-env:         []
  --api-key:         []
  --model-settings-file:.aider.model.settings.yml
  --model-metadata-file:.aider.model.metadata.json
  ...
  --encoding:        utf-8
  --line-endings:    platform
  --env-file:        /tmp/smells/.env

Option settings:
  - 35turbo: False
  - 4: False
  - 4_turbo: False
  ...
  - upgrade: False
  - user_input_color: #00cc00
  - verbose: True
  - verify_ssl: True
  - vim: False
  - voice_format: wav
  - voice_input_device: None
  - voice_language: en
  - watch_files: True
  - weak_model: None
  - yes_always: None
  ...
```

What tools like Aider, Cursor, Co-Pilot and others do is have optimized parameters for every LLM already hard-coded in the tool, like in this case where it detects to use o4 and already configures with better parameters (that you can still tune by putting them in `$HOME/.aider.model.settings.yml`).

But when you send the first question that gets interesting, look at this:

![Aiden Verbose 1](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/rb4hxk4cn181fkkf841snl7ygfja)

_"Act as an expert software developer. Always use best practices when coding. Respect and use existing conventions, libraries, etc that are already present in the code base. Take requests for changes to the supplied code. Be diligent and not lazy! You will NEVER leave comments describing code without implementing it! You will always COMPLETELY IMPLEMENT the needed code! ..."_

Remember what I said at the beginning of the post: RULES PROMPTS. This SYSTEM at the beginning is a "role". You as user are the "USER" and the model is the "ASSISTANT", and in fact this SYSTEM prompt is gigantic, it scans my project and already explains the project structure to the model and even summarizes some files (showing only the interface of methods, for example, to give context without uploading the whole code).

It has snippets like:

```
...
SYSTEM # *SEARCH/REPLACE block* Rules:
SYSTEM
SYSTEM Every *SEARCH/REPLACE block* must use this format:
SYSTEM 1. The *FULL* file path alone on a line, verbatim. No bold asterisks, no quotes around it, no escaping of characters, etc.
SYSTEM 2. The opening fence and code language, eg: ```python
SYSTEM 3. The start of search block: <<<<<<< SEARCH
SYSTEM 4. A contiguous chunk of lines to search for in the existing source code
SYSTEM 5. The dividing line: =======
SYSTEM 6. The lines to replace into the source code
SYSTEM 7. The end of the replace block: >>>>>>> REPLACE
SYSTEM 8. The closing fence: ```
SYSTEM
SYSTEM Use the *FULL* file path, as shown to you by the user.
...
```

In fact, if you've used Co-Pilot, you know you can put the conventions of your project in `CONVENTIONS.MD`. Aider will also load that file into the prompt. So things like "use 4 spaces instead of tabs, place the opening { at the end of the line and not starting a new line, etc", all of that goes in that file and both Co-Pilot and Aider add these rules to the PROMPT. There's no other mechanism, it's PROMPT.

Then, as USER, it starts uploading summaries of my files in the prompt:

```
...
USER Here are summaries of some files present in my git repository.
USER Do not propose changes to these files, treat them as *read-only*.
USER If you need to edit any of these files, ask me to *add them to the chat* first.
USER
USER data_scraper/main.py:
USER ⋮
USER │def main(args: Arguments):
USER ⋮
USER
USER data_scraper/src/arguments.py:
USER ⋮
USER │@dataclass(frozen=True)
USER │class Arguments:
USER │    content_path: Path
USER ⋮
USER │    @staticmethod
USER │    def get() -> 'Arguments':
USER ⋮
...
```

When this part ends, Aider asks for confirmation from the Model:

```
...
ASSISTANT Ok, I won't try and edit those files without asking first.
...
```

And that's how a "software A.I." works, with a ton of instruction prompts and a client program that keeps parsing the responses and triggers actual commands that run on your system (agents), like git or lint commands. The result of those commands, the text, gets concatenated into the chat to add to the context and then it asks the model/assistant to keep analyzing from that point on.

A model alone does nothing. The one doing the work is the tool that loads the model, in this case Aider, or Co-Pilot, or Cursor. The program comes pre-loaded with several pre-written profiles/personas/roles to add prompts to the model. In the Aider source code, we have this example of [architect_prompts.py](https://github.com/Aider-AI/aider/blob/main/aider/coders/architect_prompts.py)

![architect role](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/nlzkq16pcfjwwow5tbibocr1oa1n)

Look, in the first variable `main_system` is that first prompt we saw at the beginning of this section. There are several other pre-programmed profiles whose differences are good to understand. Each model works better with certain types of instructions, with different limitations.

In this other code [commands.py](https://github.com/Aider-AI/aider/blob/main/aider/commands.py) is where we have declared how Aider is able to do things like `git commit` directly in your project or run the linter of your language:

![commands](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/bdt1a5dqj28bvzhqximdi8j2gx2g)

None of this is "magic", it is all pre-programmed and it - for safety - should only be able to do limited and well-checked commands. We don't want commands that do too much outside the project directory (in fact, NEVER, outside the project directory). Nor should it be able to run many executables. You never know what security bugs might happen when running commands blindly.

If you're in cyber-security, this is where you should audit. But that's the advantage, Aider being open source is auditable. Proprietary and closed tools, no. They run on "TRUST THE DADDY".

Test [Aider](https://aider.chat/docs/install.html) today and read that whole documentation site. It is short and has important tips that may help special cases.

![Aider](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/0zeis5fjnkuf2qkmwy7pm6vc62gi)

### OpenRouter

As you must have realized, the ideal is to test the several commercial LLMs because they evolve and each has strong and weak points. But keeping credits paid in each is a pain.

For this there's [OpenRouter](https://openrouter.ai/) where you have a single account, a single `OPEN_ROUTER_API_KEY` and pay in one place and it distributes the credits to each provider like OpenAI or Claude as you use them. It simplifies the management of your API costs, it's very worth it and, of course, Aider also knows how to use it:

```
aider --model openrouter/openai/gpt-4o
```

Again, read [the documentation](https://aider.chat/docs/llms/openrouter.html).


Now, an **ANTI-PATTERN**. I asked Aider, using the `openrouter/google/gemini-2.5-pro-preview-03-25` model, which theoretically is the best of the best at the moment, to generate a unit test file for qwen_cli.py, from the little project I dropped on GitHub in yesterday's post.

It failed miserably. It created a test file, almost 800 lines long, stuffed with mocks for everything, testing things that don't need it, overcomplicating. Fine. I try to run it and it throws errors.

A cool feature of Aider is being able to run from inside the chat with `/run python -m unittest ...` and it offers to throw the errors right into the chat. I ask Gemini to fix it. Then off it goes modifying the test file and my code file. I send `/run` again, more errors. And I did this about 4 times. It keeps "fixing" code that didn't need fixing, and simple unit tests (which was just a small typo, just adjust 1 number), it leaves behind. I describe in the prompt _"you are messing with what you shouldn't and not fixing the trivial thing, like that little number"_ I send `/run`, and it insists on ignoring and goes off messing around in other places.

Summary:

![OpenRouter Credits](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/q4fiux9vj0d5l6e8p4nmku4rcjma)

It spent almost 3 bucks and didn't solve the problem. The advantage of OpenRouter is that it all stays centralized in one place. It paid Google for the use of Gemini and deducts from my credits. I had pre-loaded with 100 credits (roughly 100 dollars). And in 30 minutes 3 credits were already gone. Do the math.

**Best practice:** the best thing is to open the qwen_cli.py code, for example, in my NeoVIM or any editor and put a comment just on top of a single method:

```python
...
# this method is used to just load a config.json file, create a single unit test and add to test_qwen_cli.py, AI!
def load_config
  ...
```

Then it makes only **ONE** unit test at a time, we run it with `/run` and if it passes and the code looks clean, we move on to the next. Doing one method at a time is much more reliable than saying _"make tests for EVERYTHING at once."_ That way it's guaranteed we'll waste credits for nothing.

On top of that, one method at a time, open source models like Qwen 2.5 will do well and you run it locally without spending credits.


### Conclusion

For now, I'm going to adopt Aider. Now I understand why it became so popular this year. It is a well-made little project, open, that I can explore, try to improve and learn more from. At the same time it makes using commercial LLMs easier and opens options for me to use open source models on my own machine, putting my RTX 4090 to better use.

A bad programmer is someone who says they had trouble with ChatGPT and then spits out a canned response like "have you tried Claude, have you tried Manus" or "ah, if you had used Cursor it would be better". Stop being that NPC, it's exhausting and demonstrates absolute LAZINESS.

A GOOD programmer is the one who goes through a journey like the one I just described in this post: learns the strong points, the weak points, how to CONTROL, how to SUBVERT, how to create CONTINGENCIES and, in the end, walks out with a BETTER solution than everyone else's.

That's what I became a programmer for, not to be a free billboard repeating Sam Altman's propaganda.
