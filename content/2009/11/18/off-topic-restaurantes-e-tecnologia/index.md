---
title: "[Off-Topic] Restaurantes e Tecnologia"
date: '2009-11-18T16:51:00-02:00'
slug: off-topic-restaurantes-e-tecnologia
translationKey: off-topic-restaurantes-e-tecnologia
description: "A analogia com restaurantes separa empresas cujo negócio central é tecnologia das que apenas a usam como suporte. Nas primeiras, programadores devem experimentar e criar ferramentas, como no GitHub."
tags:
- gestao
- engenharia-de-software
- negocios
- off-topic
draft: false
---

Existem desenvolvedores e desenvolvedores. Existem empresas e empresas. Só para efeito de ilustração, vou separar dois tipos de empresa. No primeiro, tecnologia é o _core business_, e o gasto com ela conta de fato como “investimento”.

No segundo, tecnologia é acessória, tratada como “custo operacional”. Ela existe só para dar suporte ao negócio, muito do que chamamos de “backoffice”. Na falta de termos melhores, vou chamar as primeiras de **“empresas de tecnologia”** e as outras de **“enterpriseys”**.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/A_Busy_Restaurant_Kitchen.JPG_original.jpeg)

Por que estou dizendo isso? Porque muitas decisões são tomadas fora desse contexto. Decisões que combinam com uma _enterprisey_ acabam aplicadas numa empresa de tecnologia, e vice-versa. É a origem de muita discussão inútil.

Eu entendo por que um banco hesitaria em trocar hoje alguns dos seus DB2 por um CouchDB, por exemplo. Também entendo por que uma empresa médica ficaria relutante em trocar seus programas embarcados em C por algo como o .NET micro framework. Poucas tentam, e isso não quer dizer que as tecnologias não funcionariam.


 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/cheftony_original.jpg)

O mesmo não pode ser dito de “empresas de tecnologia”. Nesse contexto, usar o que há de mais novo e mais avançado deveria ser o normal. E mais: criar as próprias tecnologias deveria ser o normal.

A preocupação óbvia é que isso vire algo aleatório, desordenado, caótico. Não é o caso. É justamente por isso que empresas como Google, Microsoft, Novell, RedHat e várias menores mantêm algo parecido com um departamento de “Research & Development”, ou pelo menos a noção de pesquisar e experimentar. É por isso que elas se esforçam para contratar os profissionais na ponta das novas tecnologias, coisa que não faz sentido num banco, numa seguradora ou numa transportadora.

Esse raciocínio parece óbvio, e é mesmo, mas por algum motivo eu vejo gente decidindo e discutindo as coisas fora desses contextos. Isso é particularmente irritante. Tecnologias recentes de código aberto fazem todo sentido numa empresa de tecnologia. E ter funcionários contribuindo para projetos de código aberto faz sentido ainda maior.

Para facilitar a analogia, eu disse que numa “empresa de tecnologia” o _core business_ é tecnologia (duh). Agora pense num restaurante, uma empresa cujo _core business_ é cozinhar bons pratos. Se eu decidir fora de contexto, como se a comida fosse acessória, poderia dizer: _“por que não terceirizamos a cozinha e passamos a comprar hambúrgueres do McDonald’s? Reduz o custo operacional e garante entrega na quantidade que precisamos. E o mercado todo já conhece e gosta.”_

![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/chaplin-charlie-modern-times_01_original.jpg)

Pior ainda seria se os cozinheiros tivessem a mentalidade: _“ah, não quero testar esse ingrediente novo porque dá mais trabalho. Prefiro pegar o tempero pronto no mercado.”_ É o que eu chamo de “cozinheiros de ovos mexidos”, porque qualquer um consegue fazer ovos mexidos.

Numa enterprisey, a maior parte do trabalho costuma ser literalmente “desenvolvimento de formulários e relatórios”. É o que justifica a existência de Fábricas de Software e a contratação de “codificadores”, o típico funcionário de restaurante que só esquenta no micro-ondas a comida congelada de terceiros.

E eu sempre diferencio um “codificador” de um “desenvolvedor”. Um desenvolvedor precisa ter cabeça de “chéf”, um cozinheiro de verdade, testando coisas novas, arriscando novos ingredientes e novos pratos. É o que separa um chéf premiado do funcionário que só esquenta uma grelha.

Não quero denegrir a profissão, só ilustrar o conceito. O problema aparece quando o esquentador de micro-ondas acha que é cozinheiro e que o que ele faz é gastronomia. Não é.

Vale a ressalva: não estou dizendo que faltam “cozinheiros” em consultorias ou enterpriseys. O que aponto é como a empresa encara esse tipo de serviço ou gasto. Como ex-consultor, sei bem que existem grandes mentes tentando mudar o mindset de muitas indústrias. A Thoughtworks é um exemplo claro disso.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/kitchen_original.jpg)

Portanto, antes de mais nada, veja em que contexto você está. Se estiver num restaurante de verdade, espera-se que você seja cozinheiro. Não ache que agir como esquentador de micro-ondas está certo, a menos que você queira levar o restaurante à falência.

Outro exemplo do nosso mundo: acho que todo mundo que lê o meu blog conhece o [Github](https://github.com), um dos repositórios de código aberto mais inovadores da atualidade. Coloquem isso na cabeça: foi o trabalho de literalmente 4 programadores, alguns recém-saídos da faculdade. Eles poderiam usar só o que o “mercado” considera “aceitável”.

Leiam este post deles: [Como fizemos o Github ficar rápido](https://github.blog/news-insights/the-library/how-we-made-github-fast/). Se você aspira a ser um “chéf”, nenhuma das tecnologias citadas deveria ser novidade: ldirectord, nginx, unicorn, rails, drbd, proxymachine, haproxy, redis, ernie, memcached. Quer mais? Na mesma época, eles lançaram duas tecnologias próprias, o [Resque](https://github.blog/news-insights/the-library/introducing-resque/) e o [BERT-RPC](https://github.blog/news-insights/the-library/introducing-bert-and-bert-rpc/). Repito: não muito mais que 4 pessoas.

Quer mais? Lembram do [Phusion Passenger](https://www.phusionpassenger.com/) e do [Ruby Enterprise Edition](http://www.rubyenterpriseedition.com/)? São dois garotos que nem tinham saído da universidade. São “chéfs”.

Numa empresa de tecnologia, essa é a meta. Numa enterprisey, não. Onde você está?

