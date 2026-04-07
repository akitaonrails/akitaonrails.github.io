---
title: "3 Meses de GitLab. A Era do SaaS Híbrido"
date: '2016-11-16T16:44:00-02:00'
slug: 3-meses-de-gitlab-a-era-do-saas-hibrido
translationKey: 3-months-gitlab-hybrid-saas
aliases:
- /2016/11/16/3-months-of-gitlab-the-hybrid-saas-era/
tags:
- gitlab
- saas
- business
- traduzido
draft: false
---

Se você ainda não leu, talvez seja uma boa ideia dar uma olhada no meu post anterior [Moving to GitLab! Yes, it's worth it!](https://about.gitlab.com/2016/08/04/moving-to-gitlab-yes-its-worth-it/).

Minhas impressões vêm de circunstâncias bem específicas, então isso aqui não deve ser lido como recomendação geral para qualquer situação. Por exemplo, eu não avaliei as opções hospedadas do GitLab, que podem ser mais compatíveis com cenários diferentes do meu.

No meu caso, a mudança para o GitLab fez parte de uma estratégia interna da empresa para ter mais controle sobre nossos próprios dados. Nessa mesma estratégia também migramos do Slack para o Mattermost, e do Pivotal Tracker para uma alternativa open source que eu mesmo mantenho, chamada [Central](https://github.com/Codeminer42/cm42-central), entre outras coisas.

Antes da migração, eu tinha dezenas de projetos ativos no GitHub e uma porção de projetos arquivados no Bitbucket. Sou do tipo que odeia perder dado, então mantenho backups redundantes e tento nunca apagar nada.

Movi praticamente tudo para meu próprio servidor GitLab e isso dá quase **200 repositórios**, espalhados em 4 grupos, com cerca de 80 usuários ativos. Isso representa mais de 13.500 notas, mais de 5.200 Merge Requests, mais de 2.500 builds no CI, e o Sidekiq interno que controla tudo isso já processou mais de 51.000 jobs.

Nos últimos 3 meses desde a migração, venho pagando uma conta de Digital Ocean em torno de $140 por mês pela infraestrutura exata que descrevi no artigo anterior, com máquinas separadas para o GitLab Core, o CI Runner, o CI Docker Registry Mirror, o servidor de cache do CI e máquinas descartáveis para builds paralelos, controladas pelo Runner.

A redução de custo é bem-vinda, claro, mas não foi por causa dela que fui atrás dessa empreitada toda. Eu pagaria tranquilamente o dobro ou o triplo só pela conveniência, só que a estratégia por trás é o que mais importa nesse caso.

Minha empresa tem mais de 60 desenvolvedores, trabalhando a partir dos nossos próprios escritórios em 6 cidades diferentes no Brasil (sem freelancers e sem home-office), se comunicando diariamente pelo Mattermost, fazendo Code Review via Merge Requests do GitLab, recebendo feedback automatizado imediato dos testes pelo GitLab CI, e gerenciando projetos através da nossa própria aplicação Central.

A única peça que ainda está faltando é uma boa ferramenta de análise estática de código. A gente depende bastante do Code Climate, que na nossa experiência é uma das melhores opções que existem hoje.

Eu estava prestes a começar uma empreitada para construir uma versão OSS simplificada para integrar com o GitLab CI, mas o [Bryan Helmkamp anunciou recentemente](http://blog.codeclimate.com/blog/2016/10/06/series-a-and-community-edition/) que eles vão lançar a própria "Community Edition" do Code Climate nos próximos meses.

Essa é exatamente a peça que faltava no meu stack, e vai acelerar minha estratégia para o ano que vem.

### A Era do SaaS Híbrido

Nos últimos 5 a 10 anos houve um movimento rápido em direção a uma estrutura de "micro-serviços" de terceiros. E isso é realmente ótimo, porque permitiu que muitas empresas pequenas ou até desenvolvedores independentes tivessem acesso a tecnologias que os fizeram andar mais rápido e com cada vez mais qualidade na entrega.

Hoje é super fácil ter um serviço de upload e storage de primeira linha com ferramentas como Cloudinary.

Também é muito fácil ter um banco relacional de ponta, com replicação e escalabilidade, como Heroku Postgres ou AWS RDS.

Gerenciamento de projetos como serviço com Pivotal Tracker, Trello.

Comunicação como serviço com Slack, Hangout, etc.

Gestão de conhecimento como serviço com GitHub, Bitbucket, etc.

Então hoje muitas empresas de tecnologia são um mashup de vários serviços de terceiros diferentes.

Minha pequena implicância é que todo o nosso conhecimento, experiência, portfólio, fica espalhado por uma dúzia ou mais de serviços opacos, completamente fora do nosso controle e dependendo do capricho de cada empresa (ou dos investidores delas).

Não me entenda mal, sou a favor de usar esses serviços, pelo contrário. Uso vários e vou continuar usando muitos deles no futuro previsível. Algumas empreitadas nem seriam possíveis sem a eficiência desse pedaço de um mercado livre baseado em tecnologia.

Só que de vez em quando você chega num ponto de virada onde passa a ser importante ter mais controle sobre seus próprios dados, sua própria identidade. Tanto pela posse em si quanto pela possibilidade de usar esses dados com mais intenção.

E acredito que, chegado esse ponto, a gente deveria ter uma opção que não custasse um rim e um pulmão pra replicar.

Antes de uma opção como o GitLab, estávamos limitados a escolher entre jardins murados como GitHub ou Bitbucket, ou então investir uma tonelada de recursos tentando juntar pequenos componentes open source para construir o seu próprio. Com o GitLab agora temos a opção de fazer uma transição suave para a versão hospedada, sem precisar encarar manutenção de infraestrutura, ou podemos optar por ter controle total. E os usuários não sofrem no processo.

Por isso acredito que o melhor SaaS para sobreviver à próxima década vai começar a entrar no **modo Híbrido**: ter uma opção comercial, hospedada, geralmente "mais barata", e uma versão OSS DIY (do-it-yourself).

GitLab é assim. Mattermost é assim. Agora o Code Climate está ficando assim.

Nessa opção, empresas como o GitLab ficam numa situação ganha-ganha. Muito mais gente e empresas podem contribuir para fazer uma plataforma madura e robusta que todo mundo gosta de usar, e ao mesmo tempo cada participante pode estender a ferramenta para seus próprios planos particulares. O GitLab consegue ter um modelo de negócio sustentável atendendo a cauda longa de empresas e desenvolvedores que querem um serviço hospedado razoavelmente acessível, enquanto os 20% do topo podem perseguir empreitadas mais específicas usando a mesma tecnologia.

Dessa forma tiramos a discussão de confidencialidade, do jeito como as empresas tratam nossos dados, e avançamos para ações mais produtivas como construir uma ferramenta que beneficia tanto o público externo quanto os planos internos de cada um.

Jardins murados vieram para ficar. Liberar integração - ainda que opaca - via APIs públicas não é suficiente. É muito animador ver essas novas opções surgindo para preencher essa lacuna. O ambiente OSS junto de um modelo de negócio sustentável faz sentido. E espero continuar vendo cada vez mais concorrentes de serviços fechados seguindo o modelo Híbrido num futuro próximo.

Por que dar o trabalho de instalar, manter e ajustar alternativas open source para serviços hospedados (ainda que opacos) bem estabelecidos? Acredito que seja uma discussão maior do que conveniência, manutenção e corte de custos. A gente deveria começar pequeno, com menos risco, mas à medida que cresce deveria conseguir retomar o controle. Só que normalmente não dá para sair de um jardim murado sem um investimento significativo - e às vezes impossível - em reinventar a roda. Sempre tivemos os pequenos componentes open source sobre os quais esses serviços são construídos, mas ir desses pequenos componentes até um sistema completo é um caminho irrealista.

Com essa tendência possível de pós-SaaS, ou SaaS Híbrido como eu chamo, talvez a gente tenha acabado de ganhar o elo que faltava para ir da mera conveniência ao controle total sem o abismo inerente de custos e riscos.
