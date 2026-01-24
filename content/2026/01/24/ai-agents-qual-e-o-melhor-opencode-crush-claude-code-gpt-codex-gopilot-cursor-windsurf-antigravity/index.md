---
title: "AI Agents: Qual é o melhor? OpenCode, Crush, Claude Code, GPT Codex, GoPilot, Cursor, WindSurf, AntiGravity?"
slug: "ai-agents-qual-e-o-melhor-opencode-crush-claude-code-gpt-codex-gopilot-cursor-windsurf-antigravity"
date: 2026-01-24T09:00:31-0300
tags:
- agents
- claude
- gpt
- codex
- opencode
- crush
---

Este post foi inspirado por causa deste tweet:

[![tweet](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260124090157_screenshot-2026-01-24_09-01-43.png)](https://x.com/lordmagus/status/2014853337058050077)

Quem acompanha meu blog ou meu X, sabe que eu venho incentivando a usar agentes open source de IA como [**Crush**](/2026/01/09/omarchy-3-um-dos-melhores-agentes-pra-programacao-crush/) ou [**OpenCode**](https://opencode.ai/), que o DHH gosta mais no Omarchy.

Mas como o tweet disse acima, sim, eles não são capazes de fazer tudo que as opções proprietárias e fechadas conseguem.

Apesar do título, a idéia não é fazer um review de cada um, mas sim dizer em "linahs gerais", onde os principais agentes se encontram.

> TL;DR por preferência pessoal, eu vou continuar usando Crush. Pontualmente vou usar Claude Code.

Vamos explicar por que.

### Agent Skills

Esta é a parte fácil. A Anthropic inventou um padrão de ferramentas chamadas [**Agents Skills**](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview). Praticamente todos os agentes comerciais e open source suportam skills.

No meu setup pessoal, pra Crush, configurei da seguinte forma:

```bash
cd ~/.config/crush/
git clone https://github.com/anthropics/skills.git anthropic_skills
ln -s anthropic_skills/skills skills
```

Daí no meu `~/.config/crush/crush.json` configuro assim:

```json
{
  "$schema": "https://charm.land/crush.json",
  "options": {
    "skills_paths": [
      "~/.config/crush/skills"
    ]
  },
  ...
}
```

As skills da Anthropic são open source (pelo menos eles contribuem alguma coisa pra open source, de vez em quando, entre uma controvérsia e outra ... 🤷‍♂). E na prática não tem nenhuma skill muito interessante. Vejam:

![anthropic skills](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260124091029_screenshot-2026-01-24_09-10-19.png)

São ferramentas pra gerar documentos Word ou PDF e coisas assim. A idéia no Claude Code é que existe um Marketplace de plugins, e você pode instalar vários outros plugins de terceiros. Eis um exemplo da Supabase:

[![supabase skills](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260124091331_screenshot-2026-01-24_09-13-21.png)](https://github.com/supabase/agent-skills)

No meu exemplo simples, estou usando só skills da anthropic, mas eu posso só sair juntando mais e mais skills e jogar dentro de `~/.config/crush/skills/` e pronto. Veja como eu ativo dentro do meu Crush:

![crush skill call](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260124091515_screenshot-2026-01-24_08-55-20.png)

Viram? Igual no Claude Code, a skill é chamada automaticamente.

> Skills automáticas são facas de dois gumes: não instale tudo que ver pela frente.

TUDO em agentes é baseado em **SYSTEM PROMPT**. São as instruções que os agentes repetem a cada nova sessão. A diferença de usar agentes e usar direto no chat do site deles são os prompts.

Ano passado eu [expliquei neste post](https://akitaonrails.com/2025/04/25/hello-world-de-llm-criando-seu-proprio-chat-de-i-a-que-roda-local/) como um agente funciona do zero. Leia pra entender.

Pra usar skills, a LLM tem que saber que elas existem. E pra isso precisa ser informado no SYSTEM PROMPT. Isso **não é de graça**.

Pro SYSTEM PROMPT ter as skills, o agente precisa concatenar metadados da skill: nome, descrição, path pros scripts, tudo num formato XML.

* nome: 5 a 10 tokens (máximo de 64 tokens)
* descrição: 50 a 200 tokens (máximo de 1024 tokens)
* path: 10 a 20 tokens
* overhead de XML: uns 15 tokens

Estimativa grosseira: 80 a 250 tokens por skill.

Estimativa se tiver 50 skills instaladas: 4 mil a 12.500 tokens pra cada nova sessão!

Agentes são muito úteis, mas isso é uma das coisas que vai tornando as coisas caras: elas ficam melhores, quanto mais SYSTEM PROMPT de instruções receberem. Mas isso não tem memória: precisa instruir TODA vez que você abre o Claude Code ou Codex ou qualquer outro. Sempre vai consumir tokens! Mesmo se você só abrir a ferramenta e não fizer nada, vai gastar tokens. Esse é o modelo de negócio de todos eles.

"MAS", isso dito, sim, de fato skills são úteis. Assim como LSPs, MCPs, ACPs. Só tenha consciência que nada disso é de graça. E também nada disso é mágica específica de alguma ferramenta. É tudo aberto, e tem que ser, são prompts em texto.

### GPT Codex "HARNESS"

Este é um ponto de controvérsia, mais uma chatice da OpenAI. Dependendo do ponto de vista é bom, mas também é ruim.

"Harness", como o próprio nome diz, é um "arreio", uma "correia de segurança", como se o GPT fosse um cavalo selvagem e estamos tentando domar ele.

É tudo que segura a LLM bruta pra torná-la mais efetiva especificamente pra código:

* SYSTEM PROMPT - a parte mais importante, as intruções que definem o comportamento, personalidade, limitações
* Definição de Tools/ferramentas - ferramentas específicas que o modelo pode chamar (apply_patch, rg, git, etc)
* Formato de Patch - um formato diff específico que o modelo foi treinado (um dos pontos que eu não gosto: treinar em formato não padrão)
* Loop/Orquestração - chamar o modelo repetidament, como lidar com resultado das ferramentas, gerenciamento de contexto

Os modelos GPT Codex foram tunados especificament pra esse harness **proprietário** - só ele se comporta assim. Por isso que usar esses LLMs em ferramentas diferentes do Codex CLI pode não trazer o mesmo resultado.

> Mas dá pra usar esses harness foram do Codex? Parcialmente, sim.

**1. O SYSTEM PROMPT é público**

Está [neste link](https://github.com/openai/codex/blob/main/codex-rs/core/prompt.md). Principais elementos:

* seja conciso, direto, amigável
* use apply_patch para editar arquivos (e não sed/echo)
* use rg em vez de grep pra pesquisas
* obedeça arquivos AGENTS.md
* use update_plan para tarefas de múltiplos passos
* nunca use git commit a menos que seja explicitamente ordenado

**2. O Formato apply_patch**

Os modelos da OpenAI são treinados neste formato específico de patch:

```diff
*** Begin Patch
*** Update File: src/main.py
@@ def calculate():
     result = 0
-    return result
+    return result + 1
*** End Patch
```

Princípios:

* sem número nas linhas - em vez disso, use linhas de contexto
* delimitadores claros pra código velho vs novo
* suporta operações de criar, atualizar, deletar

**3. Configuração de Ferramenta**

Ferramentas padrão do Codex:

* apply_patch - edição de arquivos (o modelo foi treinado nisso)
* rg - ripgrep pra pesquisar código
* read_file - lê conteúdo de arquivos
* list_dir - lista arquivos do diretório
* glob_file_search - pattern matching
* git - controle de versão
* todo_write/update_plan - gerenciamento de tarefas

Ou seja, no caso específico do Crush, ainda não tem suporte ao harness proprietário da OpenAI. Os modelos da OpenAI tiveram fine-tuning em cima desse harness em específico. Pra tirar melhor proveito, precisa mandar chamar "apply_patch" e não usar "sed", por exemplo. Pra achar código direito, ele sabe usar "rg", mas não vai saber usar "grep" da mesma forma.

> Por isso, pra usar o harness do Codex, obrigatoriamente precisa usar o Codex CLI.

Dá pra fazer engenharia reversa e implementar em Crush ou OpenCode. Eu acho que ainda não tem esse suporte. O saco é que vai ser como com Microsoft e Windows. Sempre que no mundo open source conseguirmos replicar o mesmo comportamento, eles vão lançar uma nova versão que quebra o comportamento antigo e vai virar a mesma história cansativa de gato e rato.

### Agents Wars

Lembram do "Browser Wars" dos anos 90 e anos 2000? É a mesma coisa:

* Claude Code é o Internet Explorer 11
* GPT Codex é o Netscape
* Cursor, Windsurf, Copilot são os Operas
* OpenCode/Crush são Chromium em 2006

Os princípios são os mesmos:

* cada modelo LLM de código foi treinado num "harness" diferente
* teoricamente, somente a OpenAI e parceiros licenciados da OpenAI tem acesso à especificação exata desse harness. Por isso Codex ou Cursor ou CoPilot vão se comportar diferente de OpenCode quando usam modelos da OpenAI.
* tudo são prompts: se soubermos os prompts de instrução exatos, podemos replicar isso no mundo open source - já deve ter gente fazendo
* mas é perseguição de gato e rato. toda vez vai sair versão nova. É o mesmo problema de LibreOffice vs Microsoft Office, que depois de décadas, continua não sendo 100% compatível

Por isso não tem jeito:

* quer tirar o máximo proveito de Claude? Use Claude Code
* quer tirar o máximo proveito de GPT? Use Codex CLI

LLMs são caros de treinar. Na casa dos bilhões de caro. Óbvio que eles vão fechar o máximo possível pra conseguir o maior retorno de investimento. É até justo.

Por isso modelos "abertos" são importantes: pra ajudar a forçar um padrão aberto de tooling e harness. Não existe, na prática, nenhum modelo verdadeiramente aberto. Todos são "grátis" (como em "cerveja grátis") e não "livres" (como em "liberdade de expressão"). Todo mundo quer tirar fatia de mercado do concorrente, esse é o incentivo.

### Conclusão

Na prática, pra variar, **DEPENDE** do seu uso. Se GPT dá melhores resultados pro seu tipo de projeto, use Codex CLI ou parceiros da OpenAI como CoPilot ou Cursor que - provavelmente - usam o mesmo harness.

Se Claude dá melhores resultados pra você, use Claude Code.

Se você não se vê usando skills específicas ou coisas assim, existem alternativas que dão resultados tão bons quanto Claude, como GLM 4.7 ou MiniMax v2.1. O atrativo pras alternativas é não ficar fechado em ferramentas proprietárias de novo e poder usar OpenCode ou Crush. Essas são as mais "open source"-friendly - se você se importa com isso.

Estamos numa bolha de IAs, isso é óbvio. E em particular no mundo de dev, estamos no meio de uma "Guerra de Agentes". Codex quer ser o próximo Office. Claude Code quer ser o próximo Internet Explorer.

Eu pessoalmente não tenho nada específico que preciso de Claude ou GPT. A performance de Claude via Crush está muito boa pra mim, por isso vou continuar no Crush. Você deve escolher baseado nas suas próprias necessidades e testes.

Você deveria ser um dev de verdade e testar tecnicamente, e não seguir opiniões.
