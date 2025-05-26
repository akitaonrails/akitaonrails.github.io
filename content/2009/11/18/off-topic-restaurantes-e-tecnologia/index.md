---
title: "[Off-Topic] Restaurantes e Tecnologia"
date: '2009-11-18T16:51:00-02:00'
slug: off-topic-restaurantes-e-tecnologia
tags:
- off-topic
- management
draft: false
---

Existem desenvolvedores e desenvolvedores. Existem empresas e empresas. Apenas para efeitos ilustrativos deste post eu vou separar pelo menos dois tipos de empresa: onde tecnologia faz parte ou é o _core business_, onde o gasto relacionado a tecnologia é considerado de fato “investimento”; ou empresas onde tecnologia é apenas acessória, considerada meramente parte do “custo operacional”, onde apenas somente para suportar o negócio, que é muito do que chamamos de “backoffice”. Na falta de termos melhores, chamarei empresas onde tecnologia é _core business_ de **“empresas de tecnologia”** e os outros de **“enterpriseys”** para facilitar.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/A_Busy_Restaurant_Kitchen.JPG_original.jpeg)

Por que estou dizendo isso? Porque muitas decisões são tomadas fora desse contexto. Decisões que normalmente se encaixam bem em _enterpriseys_ são tomadas em empresas de tecnologia e vice-versa. É um dos motivos de muitas discussões inúteis. Eu consigo entender porque um banco se sentiria incomodado de implementar hoje uma nova tecnologia, vamos chutar, trocar alguns de seus DB2 por um CouchDB por exemplo. Também consigo entender porque uma empresa médica ficaria relutante em trocar seus atuais programas embarcados de C, por exemplo, por .NET micro framework. Não quer dizer que nenhuma delas tenta, mas sim que não é o caso da maioria e nem que as tecnologias não funcionariam.


 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/cheftony_original.jpg)

O mesmo não pode ser dito de “empresas de tecnologia”. Nesse contexto, tentar usar o que há de mais novo e mais avançado deveria ser o normal. Mais do que isso: criar as próprias tecnologias deveria ser o normal. Agora, a preocupação é que isso fique aleatório, desordenado e leve ao caos. Não se trata disso. É justamente por isso que empresas de tecnologia como Google, Microsoft, Novell, RedHat e diversos outros menores tem algo que se assemelha a um departamento de “Research & Development” (pesquisa e desenvolvimento), ou no mínimo a noção de “pesquisar e experimentar”. É por isso que eles se esforçam em contratar os profissionais do mercado que estão na ponta das novas tecnologias, coisa que não faz sentido por exemplo em um banco, ou uma seguradora, ou uma empresa de transportes.

Esse pensamento parece óbvio e realmente é, mas por alguma razão eu vejo pessoas decidindo e discutindo coisas fora desses contextos, coisa que é particularmente irritante. Tecnologias mais recentes de código aberto, por exemplo, fazem total sentido em empresas de tecnologias. Mais do que isso: ter funcionários contribuindo para projetos de código aberto faz mais sentido ainda.

Para facilitar a analogia, eu disse que em “empresas de tecnologia” o _core business_ é tecnologia (duh). Agora pense num restaurante. Nesse caso trata-se de uma empresa onde o _core business_ é cozinhar bons pratos culinários. Se nessa empresa eu decidir, fora do contexto, e pensar como se a comida fosse apenas acessória, poderia dizer: _“porque não terceirizamos nossa cozinha e passamos a comprar hamburgers do McDonald’s? Vai diminuir nosso custo operacional, teremos entrega garantida nas quantidades que precisamos. Mais do que isso, o mercado todo já conhece e gosta.”_

![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/chaplin-charlie-modern-times_01_original.jpg)

Pior ainda, se os cozinheiros desse restaurante tivessem a mentalidade: _“ah, não quero testar esse novo ingrediente porque vai dar mais trabalho. Prefiro pegar o tempero já pronto no mercado.”_ É o que eu chamo de “cozinheiros de ovos mexidos”. Isso porque qualquer um consegue fazer ovos mexidos.

Em enterpriseys, normalmente a maior parte do trabalho é literalmente “desenvolvimento de formulários e relatórios”, o que justifica a existência de Fábricas de Software e a contratação de “codificadores”, o típico funcionário de restaurante que apenas esquenta a comida congelada de terceiros no micro-ondas.

E eu também sempre diferencio um “codificador” de um “desenvolvedor”. Um desenvolvedor precisa ter a cabeça de um “chéf”, um verdadeiro cozinheiro, tentando coisas novas, testando novos ingredientes, arriscando novos pratos. É o que diferencia um chéf premiado de um funcionário que apenas esquenta uma grelha. Sem querer denegrir a profissão, estou apenas tentando ilustrar um conceito. E o problema é quando um esquentador de micro-ondas acha que é cozinheiro e o que ele está fazendo é gastronomia. Não é.

Vale uma ressalva: não estou dizendo que não existem “cozinheiros” em consultorias ou enterpriseys. O que estou apontando é como a empresa encara esse tipo de serviço ou gasto. Como ex-consultor estou mais do que ciente que existem grandes mentes tentando influenciar e mudando o mindset de muitas indústrias. Exemplo claro disso é a Thoughtworks, por exemplo.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/kitchen_original.jpg)

Portanto, antes de mais nada, veja em qual contexto você está. Se estiver num restaurante de verdade, espera-se que você seja um cozinheiro. Não ache que agir como um esquentador de micro-ondas está correto, a menos que você queira levar o restaurante à falência.

Outro exemplo do nosso mundo: acho que todos que lêem o meu blog conhecem o [Github](http://github.com), um dos repositórios de código-aberto mais inovadores da atualidade. Tentem colocar isso nas suas cabeças: foi o trabalho de literalmente 4 programadores, alguns deles que mal acabaram de sair da faculdade. Eles poderiam usar tudo que é considerado “aceitável” pelo “mercado”. Leiam este blog post deles: [Como fizemos o Github ficar rápido](http://github.com/blog/530-how-we-made-github-fast). Se você aspira ser um “chéf” nenhuma das tecnologias citadas deveria ser novidade: ldirectord, nginx, unicorn, rails, drdb, proxymachine, haproxy, redis, ernie, memcached. Querem mais? Ao mesmo tempo, só recentemente, eles lançaram duas novas tecnologias: [Resque](http://github.com/blog/542-introducing-resque) e [BERT-RPC](http://github.com/blog/531-introducing-bert-and-bert-rpc). Vou repetir: não muito mais que 4 pessoas.

Querem mais? Lembram do [Phusion Passenger](http://www.modrails.com/) e do [Ruby Enterprise Edition](http://www.rubyenterpriseedition.com/)? São dois garotos que nem saíram da universidade. Eles são “chéfs”.

Em uma empresa de tecnologia, essa é a meta. Em enterpriseys não. Onde você está?

