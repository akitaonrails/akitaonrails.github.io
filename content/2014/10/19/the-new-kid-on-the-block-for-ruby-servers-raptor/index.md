---
title: 'O Novo Garoto da Pesada para Servidores Ruby: Raptor!'
date: '2014-10-19T15:00:00-02:00'
slug: o-novo-garoto-da-pesada-para-servidores-ruby-raptor
translationKey: raptor-new-ruby-server
aliases:
- /2014/10/19/the-new-kid-on-the-block-for-ruby-servers-raptor/
tags:
- learning
- passenger
- traduzido
draft: false
---

*Atualização (25/11/2014):* Finalmente podemos confirmar que sim, o tão aguardado projeto Raptor é o codinome para o próximo release do Phusion Passenger! Leia o [anúncio](http://blog.phusion.nl/2014/11/25/introducing-phusion-passenger-5-beta-1-codename-raptor/)

Se você é um desenvolvedor web Ruby experiente, provavelmente já está acostumado e confortável usando os suspeitos de sempre para fazer deploy das suas aplicações. Ou você está fazendo deploy de algo simples através do bom e velho Thin, ou está orquestrando vários processos Ruby com workers do Unicorn, ou está experimentando JRuby para ter melhor concorrência e gerenciamento de threads, e por isso usa Puma ou Torquebox.

E mesmo parecendo que já chegamos ao topo do que é possível fazer com Ruby, queremos sempre mais. O Ruby 2.1.3 acabou de ser lançado, o 3.0 está em desenvolvimento. Mas até lá, ainda dá para espremer mais performance das suas máquinas.

Na verdade, um novo competidor, com algumas abordagens novas, acabou de aparecer. Tenho poucos detalhes até agora, mas é um produto totalmente novo - não é derivado dos outros - de um time desconhecido. Esse produto se chama ["Raptor"](http://www.rubyraptor.org) e eles afirmam que conseguem espremer ainda mais suco das nossas máquinas.

E é essa a alegação deles:

![Raptor Chart](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/475/chart-1.png)

Felizmente, tive a chance de experimentar o release beta num ambiente Vagrant controlado e checar essas alegações! Tenha em mente que esses são benchmarks sintéticos e o throughput do mundo real, com aplicações reais, deve nos dar comportamentos diferentes. Dito isso, vamos ver como os principais servidores Ruby se saem rodando uma aplicação Rack bem simples que devolve um HTTP 200 com "Hello World":

```
 ==> Benchmark parameters:
     Application         : hello_app
     Operating system    : Ubuntu 14.04 LTS (x86_64)
     Virtual CPU cores   : 4
     MRI Ruby            : ruby 2.1.3p242 (2014-09-19 revision 45877) [x86_64-linux-gnu]
     JRuby               : jruby 1.7.13 (1.9.3p392) 2014-06-24 43f133c on OpenJDK 64-Bit Server VM 1.7.0_65-b32 [linux-amd64]

     Unicorn workers     : 8
     Puma workers (MRI)  : 8 (16 threads each)
     Puma workers (JRuby): 1 (32 threads each)
     Torquebox threads   : 32
     Raptor workers      : 8

     Concurrent clients  : 16

 ==> Benchmark summary:
     Unicorn (MRI Ruby)         : 23015.36 req/sec
     Puma (MRI Ruby)            : 32538.62 req/sec
     Puma (JRuby)               : 399.14 req/sec
     Torquebox (JRuby)          : 29773.21 req/sec
     Raptor (MRI Ruby)          : 95309.35 req/sec
     Raptor (JRuby)             : 87523.65 req/sec
```

Bom, isso soa bem impressionante! E quanto a um exemplo mais complexo: uma aplicação Rails 4.1.6 simples renderizando uma página index de scaffold padrão com um model buscando 20 linhas do MySQL:

```
==> Benchmark summary:
    Unicorn (MRI Ruby)         : 326.49 req/sec
    Puma (MRI Ruby)            : 327.36 req/sec
    Puma (JRuby)               : 221.78 req/sec
    Torquebox (JRuby)          : 226.57 req/sec
    Raptor (MRI Ruby)          : 79617.78 req/sec
    Raptor (JRuby)             : 73948.59 req/sec
```

De novo, **super** impressionante. Minha primeira impressão ao ler esses números é que o Raptor deve ter cache de resposta embutido (o que é ótimo!). Então mexi no exemplo para deixá-lo bem mais pesado do que é considerado "normal" para um cache pequeno, renderizando uma tabela de 100 linhas vinda do banco na página index, e os resultados continuam competitivos:

```
==> Benchmark summary:
    Unicorn (MRI Ruby)         : 85.98 req/sec
    Puma (MRI Ruby)            : 89.93 req/sec
    Puma (JRuby)               : 79.42 req/sec
    Torquebox (JRuby)          : 77.98 req/sec
    Raptor (MRI Ruby)          : 82.63 req/sec
    Raptor (JRuby)             : 88.92 req/sec
```

Isso pode significar que, no melhor cenário, você consegue quase **4 vezes** o throughput da sua aplicação, e no pior cenário, ainda obtém throughputs similares. Quer dizer que o Raptor é adaptável e razoavelmente "esperto". No geral, é uma situação ganha-ganha!

A forma como eles conseguem esses números superiores pode ser explicada pelo jeito como abordaram a implementação. Esse é o resumo que eles divulgaram até agora:

* **Proteção contra clientes lentos**: Clientes lentos na Internet podem travar sua aplicação, como pessoas paradas na frente da sua porta. O Unicorn tem uma única porta pequena, então [exige](http://unicorn.bogomips.org/PHILOSOPHY.html) que você coloque um proxy reverso com buffer na frente, como o Nginx. O Puma tem tantas portinhas quantas threads você configurar, então você ainda precisa colocar o Nginx na frente para ficar seguro. Mas o Raptor tem uma porta praticamente infinita em largura, e protege totalmente sua aplicação contra clientes lentos sem precisar de software adicional.
* **Integração opcional com Nginx**. O Nginx é um ótimo servidor web e oferece recursos úteis como compressão, segurança, etc. Mas usar Puma e Unicorn com Nginx exige que você configure Puma/Unicorn separadamente, configure o Nginx separadamente, configure o monitoramento separadamente e gerencie cada componente separadamente. Não faz mais sentido consolidar todas essas peças em um único pacote? Aí entra o modo de integração opcional do Raptor com Nginx: configuração, gerenciamento e monitoramento de daemons direto do Nginx.
* **Multitenancy**. Se você roda múltiplas aplicações no mesmo servidor, gerenciar todas essas instâncias de Puma e Unicorn rapidamente vira uma chatice. O modo de integração com Nginx do Raptor permite gerenciar todas as suas aplicações a partir de uma única instância do Nginx.
* **Segurança**. Melhore a segurança do seu servidor rodando facilmente várias aplicações sob contas de usuário diferentes. Assim, uma vulnerabilidade em uma aplicação não afeta todas as outras.
* **Suporte a JRuby**. Como o Puma (e diferente do Unicorn), o Raptor tem ótimo suporte a JRuby.

Então é uma implementação diferente e também traz recursos para o futuro, suportando o tratamento transparente de clientes lentos sem causar gargalos na sua aplicação e evitando ter camadas extras de proteção. E tudo num pacote fácil de usar (segundo o release deles: você vai poder substituir seu servidor atual no Gemfile e rodar bundle install!)

O Raptor está prestes a ser lançado, então fique ligado para mais notícias e para quando estiver disponível para todo mundo testar suas aplicações. Pelo que vimos até agora, esse aqui parece um vencedor!

Vá ao [site deles](http://www.rubyraptor.org) para saber mais e, se você é como eu e acha que isso é a coisa real, [dê um Thunderclap!](https://www.thunderclap.it/projects/17748-raptor-fast-ruby-web-server)

![Raptor](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/473/raptor_square.png)
