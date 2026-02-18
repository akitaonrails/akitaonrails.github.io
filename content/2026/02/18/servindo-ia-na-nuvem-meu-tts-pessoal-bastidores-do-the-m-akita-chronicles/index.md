---
title: "Servindo IA na Nuvem: Meu TTS pessoal | Bastidores do The M.Akita Chronicles"
slug: "servindo-ia-na-nuvem-meu-tts-pessoal-bastidores-do-the-m-akita-chronicles"
date: 2026-02-18T15:28:46+00:00
draft: false
tags:
- themakitachronicles
- runpod
- vibecode
- qwen3-tts
---

Este post vai fazer parte de uma série; acompanhe pela tag [/themakitachronicles](/tags/themakitachronicles). Esta é a parte 3.

E não deixe de assinar minha nova newsletter [The M.Akita Chronicles](https://themakitachronicles.com/)!

Já vou falar do podcast hoje; lembrem-se de que o [episódio piloto já está no ar](https://blog.themakitachronicles.com/podcast-transcripts/) (transcripts e RSS pra assinar) e no canal no Spotify.

--

Todo tutorial de IA começa com *"instale o modelo, rode inference, pronto!"*. Nenhum te conta o que acontece quando você precisa rodar isso em produção com uptime real, custo controlado, e qualidade consistente.

Vou contar a história real de colocar um modelo de TTS (Text-to-Speech) em produção numa GPU na nuvem. Sem romantizar, sem simplificar. Porque se você está considerando servir modelos de IA, precisa saber no que está se metendo.

## O Cenário

> O objetivo: gerar um podcast de ~30 minutos a partir de texto, com duas vozes distintas, qualidade de broadcast, pronto pra Spotify. Toda semana, automaticamente, sem intervenção humana.

O modelo escolhido: [**Qwen3-TTS**](https://qwen.ai/blog?id=qwen3tts-0115), um modelo de text-to-speech que suporta voice cloning e fine-tuning. Roda em GPU — precisa de pelo menos 6GB de VRAM pra inference.

A plataforma: [**RunPod**](https://runpod.io/), que oferece GPUs serverless com cobrança por segundo de uso.

![runpod](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-18_12-33-45.jpg)

Parece simples, né? Pois aguarde.

## Problema 1: Cold Start — O Assassino Silencioso

GPU serverless funciona assim: quando não tem requisição, o worker desliga. Quando chega uma requisição, ele liga, carrega o modelo na VRAM, e processa.

O tempo de "carregar o modelo na VRAM" é o *cold start*. Pra um modelo de ~4GB, estamos falando de **30 a 90 segundos**. Sua requisição HTTP fica pendurada, esperando. Se seu timeout é de 30 segundos, você nem chega a ver o modelo funcionar — só vê timeout.

A solução ingênua: *"aumenta o timeout!"*. A solução real: **health check com polling**.

```python
@app.get("/health")
async def health():
    if not model_loaded:
        return JSONResponse(
            status_code=503,
            content={"status": "loading", "detail": "Model loading..."}
        )
    return {"status": "ready"}
```

O cliente (no caso, um job Rails) faz polling no `/health` antes de mandar a requisição real:

```ruby
def wait_for_server(max_wait: 180)
  deadline = Time.current + max_wait
  loop do
    response = http_get("/health")
    return if response.code == 200
    raise "Server não iniciou a tempo" if Time.current > deadline
    sleep 5
  end
end
```

Parece primitivo? É. Mas funciona melhor do que qualquer solução sofisticada de "warm pool" que custa 10x mais.

## Problema 2: Onde Ficam os Pesos do Modelo?

Um modelo de 4GB precisa estar disponível quando o worker inicia. Três opções:

1. **Bake no Docker**: Imagem de 4GB+. Build lento. Push lento. Pull lento.
2. **Download do HuggingFace no boot**: Depende de rede. Pode falhar. Adiciona minutos ao cold start.
3. **Network Volume**: Disco persistente montado no worker.

A opção 3 é a correta. O RunPod oferece Network Volumes que persistem entre execuções. O modelo fica lá, sempre pronto. O cold start é só o tempo de carregar da disk pra VRAM, sem download.

![network storage](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-18_12-35-43.jpg)

Mas tem uma pegadinha: o volume pode estar montado ou não, dependendo de como o worker é configurado. Então o código de setup precisa ser resiliente:

```python
NETWORK_VOLUME = "/runpod-volume"
LOCAL_FALLBACK = "/workspace/models"

def resolve_model_path():
    if os.path.isdir(NETWORK_VOLUME):
        base = os.path.join(NETWORK_VOLUME, "huggingface")
        os.environ["HF_HOME"] = base
        return os.path.join(base, "hub", "models--Qwen--Qwen3-TTS")
    # Fallback: download local
    return LOCAL_FALLBACK
```

Auto-detecção. Se o volume existe, usa. Se não, funciona do mesmo jeito (mais lento no primeiro boot). **Nunca assuma que a infraestrutura está perfeita.**

## Problema 3: Dois Modos de Voz, Dois Conjuntos de Parâmetros

Aqui está algo que nenhuma documentação vai te dizer: modelos de TTS com voice cloning e fine-tuning precisam de **parâmetros de sampling completamente diferentes** dependendo do modo.

Com uma voz fine-tuned (treinada especificamente no modelo), você quer parâmetros conservadores:

```
temperature: 0.5
top_p: 0.8
repetition_penalty: 1.1
```

Com voice cloning (voz base + áudio de referência), os mesmos parâmetros produzem **ruído branco**. Literalmente. White noise. Porque o modelo de clone precisa de mais "criatividade" pra reconstruir as características vocais:

```
temperature: 0.9
top_p: 0.95
repetition_penalty: 1.05
```

Descobri isso depois de horas gerando áudio inutilizável. A documentação do modelo não menciona. Os papers acadêmicos não mencionam. É o tipo de conhecimento que só vem de **experimentação em produção**.

## Problema 4: O Áudio de Referência Importa Mais que o Modelo

Voice cloning usa um trecho de áudio como referência pra replicar a voz. Parece simples: grava 10 segundos, passa pro modelo e pronto.

Exceto que se o áudio de referência começa com a fala imediatamente — sem nem 200 milissegundos de silêncio no início — o modelo aprende que "o áudio começa sem onset". E **toda geração subsequente** vai cortar a primeira sílaba.

Isso não é um bug do modelo. É o modelo fazendo exatamente o que você pediu: *"gere áudio que começa igual a essa referência"*. Se a referência começa cortada, a geração começa cortada.

A correção não é pós-processamento (o áudio já foi gerado sem a sílaba). É **corrigir a referência**: garantir pelo menos 300ms de silêncio antes da fala.

Pra quem vem do mundo de software, isso é contra-intuitivo. Estamos acostumados a tratar dados de entrada como imutáveis e consertar na saída. Com modelos generativos, a qualidade da entrada é **tudo**.

## Problema 5: Timeout e Limites de Geração

Um modelo de TTS gera áudio token por token. Se você não limitar, ele pode gerar indefinidamente — e no RunPod, você paga por segundo de GPU. Um turno de diálogo de 30 palavras não deveria gerar 3 minutos de áudio, mas sem limite, pode.

```python
MAX_NEW_TOKENS = 720  # ~60 segundos de áudio a 12Hz
GENERATION_TIMEOUT = 180  # 3 minutos absolutos

with ThreadPoolExecutor(max_workers=1) as executor:
    future = executor.submit(model.generate, **params)
    result = future.result(timeout=GENERATION_TIMEOUT)
```

Dupla proteção: limite de tokens na geração e timeout absoluto no processo. Se qualquer um disparar, o turno falha e pode ser re-tentado com parâmetros ajustados.

## Problema 6: Pós-Processamento é Metade do Trabalho

O modelo gera WAV cru. Pra chegar em áudio de podcast quality, o caminho é longo:

1. **Normalização de loudness**: Spotify exige -14 LUFS. Sem normalização, cada turno tem volume diferente.
2. **Re-encoding**: Os WAVs do modelo podem ter formatos sutilmente diferentes (sample rate, bit depth). Concatenar com `-c copy` causa **segmentos silenciosos**. Precisa re-encodar tudo pro mesmo formato.
3. **Conversão pra MP3**: CBR 192kbps, 44.1kHz, com metadata ID3.

E a normalização de loudness precisa ser **two-pass**: primeiro mede, depois aplica. Single-pass é chute — e chute em produção gera áudio com volume inconsistente entre episódios.

```bash
# Pass 1: análise
ffmpeg -i input.wav -af loudnorm=I=-14:print_format=json -f null -

# Pass 2: aplicação dos valores medidos
ffmpeg -i input.wav -af loudnorm=I=-14:measured_I=-18.5:measured_TP=-2.1:... output.wav
```

Tudo isso roda no servidor, depois da geração do TTS. E precisa de `ffmpeg` instalado no container — mais uma dependência pra gerenciar.

## Problema 7: O Script Importa Mais que o Modelo de Voz

Depois de resolver GPU, cold start, voice cloning, sampling, normalização — o podcast sai. E soa... robótico. Não por causa do TTS. O TTS é excelente. Soa robótico porque o **texto** é robótico.

Esse é o problema que ninguém menciona em pipelines de TTS: a qualidade do áudio começa no script, não no modelo de voz. Um TTS perfeito lendo um texto seco e formal produz áudio seco e formal. Garbage in, garbage out — mas num nível que você não espera.

### Duas Passadas: Draft e Refine

A solução é gerar o script em duas passadas de LLM:

**Passada 1 (Draft)**: Transforma a newsletter em diálogo. Aqui o LLM recebe o conteúdo completo e cria a estrutura — quem fala o quê, em que ordem, com quais transições. **Sem mudar o conteúdo, só a forma!**

**Passada 2 (Refine)**: Pega o draft e torna natural. Adiciona hesitações, reações, interrupções, auto-correções. Transforma "script lido" em "conversa real".

Por que não fazer tudo numa passada? Porque são tarefas cognitivamente diferentes. Estruturar conteúdo e adicionar naturalidade ao mesmo tempo resulta num texto que não faz nem um nem outro direito. Duas passadas especializadas produzem resultado consistentemente melhor.

### Personalidade Precisa de Instruções Brutalmente Específicas

"Faça o Akita soar confiante" não funciona. O LLM vai produzir confiança genérica — frases motivacionais, tom positivo. Não é isso. Akita é confiante porque é **assertivo e impaciente**. A diferença está nos detalhes do prompt:

```markdown
## Akita Delivery Style

- **Declarative, not tentative**: "Isso é óbvio" not "Eu acho que talvez isso seja..."
- **Dismissive of nonsense**: "Isso é bobagem", "Não tem nenhum mistério aqui"
- **Owns his track record**: "Eu avisei", "Quem assistiu meu canal já sabe"
- **Never hedges**: No "talvez", "quem sabe", "pode ser que"
- **Impatient with the obvious**: "Vocês já sabem como funciona"
```

E pro Marvin (o co-host robô):

```markdown
- **Filler words** (Marvin only): "bom...", "olha...", "enfim", "pois é"
- **Self-corrections** (Marvin only): "quer dizer...", "ou melhor..."
- Akita doesn't second-guess himself — if he corrects, it's
  "Não, peraí" and he restates with even MORE conviction
```

Sem esse nível de especificidade, os dois personagens soam iguais. O LLM precisa de exemplos concretos de **como** cada um fala, não de descrições abstratas de personalidade.

### Normalização Pra Fala: O Que Parece Certo no Texto Soa Errado no Áudio

Siglas. O inimigo invisível do TTS. "EUA" no texto é perfeitamente legível. Falado pelo TTS, sai "éu-á" — incompreensível. O prompt precisa de regras explícitas de normalização:

```markdown
## Spoken Text Normalization (MANDATORY)

- `EUA` → `Estados Unidos`
- `UE` → `União Europeia`
- `IA` → `inteligência artificial`
- `LLM` → `modelo de linguagem`
- `API` → `interface de programação`
```

Isso precisa estar no prompt de **ambas** as passadas (draft e refine), porque o LLM tem tendência a reintroduzir siglas que removeu na passada anterior.

### O LLM Vai Reescrever Suas Opiniões (Se Você Deixar)

Essa foi a lição mais sutil. A newsletter tem comentários opinativos do Akita e do Marvin em cada seção. Quando o LLM transforma em diálogo, ele **substitui** as opiniões por versões mais "balanceadas" e "nuançadas". Akita que dizia "isso é bobagem" vira Akita dizendo "isso tem seus méritos, mas...". Marvin pessimista vira Marvin "levemente cético".

O LLM faz isso porque foi treinado pra ser helpful e balanced. Opiniões fortes parecem "unhelpful" pro modelo, então ele suaviza. A instrução original — "use os comentários da newsletter como sementes pra conversa" — era vaga demais. Dava liberdade pro modelo reinterpretar.

A correção é ser explícito e inflexível:

```markdown
**PRESERVE THE ORIGINAL OPINIONS**: The newsletter contains Akita and
Marvin commentary on each topic. These opinions are the author's real
voice — you MUST preserve their substance, stance, and conclusions.
Make the delivery conversational, but do NOT change what they actually
think. If Akita's comment says "isso é bobagem", the podcast version
must convey the same dismissal. Rephrase for spoken delivery, but
never substitute a different opinion.
```

É a diferença entre "adapte pra conversa" (LLM entende: "reescreva como quiser") e "mude o COMO, nunca o QUÊ" (LLM entende: "mantenha a opinião, troque a embalagem").

Essa é talvez a lição mais importante de prompt engineering pra conteúdo autoral: **o LLM vai homogeneizar sua voz se você não for explícito sobre preservá-la**. E num podcast onde a personalidade dos hosts É o produto, perder a voz é perder tudo.

## O Custo Real de IA em Produção

Vamos ser práticos sobre custos no RunPod:

| Recurso | Custo |
|---------|-------|
| GPU L40 (serverless) | ~$0.39/hora |
| Network Volume 20GB | $1.40/mês |
| Geração de 1 episódio (~30 min áudio) | ~$0.50–1.50 |

O custo por episódio é baixo. O custo de **descobrir como fazer funcionar** é alto. Foram dezenas de horas de experimentação, logs incompreensíveis de CUDA, gerações falhadas, e áudio com qualidade inutilizável antes de chegar numa pipeline estável.

E o custo cognitivo: manter dois ecossistemas (Python pra ML, Ruby pra aplicação) sincronizados, com interfaces HTTP entre eles, e debugging que cruza fronteiras de linguagem.

De qualquer forma, pra quem pensou *"Por que não Elevenlabs?"*, bom, eu consegui qualidade similar, numa fração do custo, e aprendi muito no processo (e vocês também, lendo aqui).

## Lições

1. **Cold start é um requisito, não um bug.** Design seu sistema esperando que o modelo demore pra carregar.

2. **Network volumes são obrigatórios** pra modelos grandes. Não bake pesos no Docker, não faça download no boot.

3. **Parâmetros de sampling não são universais.** Cada modo de operação do mesmo modelo pode precisar de configuração completamente diferente.

4. **A qualidade da entrada domina a qualidade da saída.** Tanto pro áudio de referência do TTS quanto pro script. Se a referência corta a primeira sílaba, toda geração corta. Se o script é genérico, o áudio é genérico.

5. **Timeouts em todas as camadas.** Token limit, process timeout, HTTP timeout. Se não limitar, o custo escala e a geração trava.

6. **Pós-processamento é metade do pipeline.** O modelo gera matéria-prima. Normalização, encoding, metadata — tudo isso é trabalho real.

7. **Separe o servidor de ML da aplicação.** Python pra inference, Ruby pra orquestração. Tentar fazer tudo numa linguagem é receita pra frustração.

8. **Prompts precisam de duas passadas pra conteúdo complexo.** Estruturar e naturalizar são tarefas diferentes. Forçar as duas numa passada produz resultado medíocre em ambas.

9. **O LLM vai homogeneizar sua voz.** Opiniões fortes viram "nuanced takes" se você não for explícito sobre preservá-las. Instrua o modelo a mudar a embalagem, nunca o conteúdo.

## Conclusão

IA em produção não é um tutorial de HuggingFace com 10 linhas. É infraestrutura, é experimentação, é debugging de problemas que não existem em software tradicional. Mas quando funciona — quando seu sistema gera um podcast inteiro automaticamente toda semana, com qualidade broadcast, sem intervenção humana — a sensação é que valeu cada hora de dor de cabeça.

O truque é não subestimar a complexidade. E ter um sistema robusto (como os jobs do Rails que discutimos no primeiro post) orquestrando tudo. A IA é o cérebro, mas o Rails é o sistema nervoso que mantém tudo funcionando.

No próximo post, vou falar sobre frontend — como Tailwind CSS e Hugo transformam o design de um projeto solo.

