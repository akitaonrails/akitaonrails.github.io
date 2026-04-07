---
title: Escolhendo MatterMost no lugar de Rocket.chat e Slack
date: '2016-08-13T22:41:00-03:00'
slug: escolhendo-mattermost-no-lugar-de-rocket-chat-e-slack
translationKey: choosing-mattermost
aliases:
- /2016/08/13/choosing-mattermost-over-rocket-chat-and-slack/
tags:
- mattermost
- docker
- golang
- rocket.chat
- slack
- traduzido
draft: false
---

Eu sou um tecnólogo, basicamente um nerd. Então, quando fico obcecado com alguma questão técnica, por menor que seja, simplesmente não consigo dormir tranquilo até encontrar uma solução razoável.

Meu time, meus clientes, todos nós usamos Slack felizes por mais de 2 anos, como acredito que muitos times pelo mundo também usaram. Apesar de ninguém nunca ter reclamado, eu sempre me incomodava com pequenos detalhes. Em primeiro lugar, como tudo que tem valor, custa. Ou pago USD 6.67/mês/usuário, ou aceito as restrições do plano gratuito. E, como a maioria dos outros times, fui levando com as restrições enquanto deu.

Por exemplo, para me livrar dos avisos para fazer upgrade porque batemos no limite de uploads, criei uma pequena ferramenta chamada [slack_cleanup](https://github.com/akitaonrails/slack_cleanup) (primeiro em Elixir e depois em [Crystal](https://github.com/akitaonrails/cr_slack_cleanup), só por exercício). Isso ajudou por um tempo.

Nosso time foi crescendo, de forma constante e frequente, assim como os clientes. Quanto mais usuários adicionamos, mais conversas, mais rápido batemos nas restrições. Histórico se perde com mais frequência, precisamos limpar uploads com mais frequência. Isso cansa muito rápido.

Uma coisa que valorizo acima de tudo é conhecimento. Como pequeno exemplo, eu mesmo mantenho múltiplos backups de todos os meus emails, todos os meus projetos, todos os assets que produzi nos últimos 20 anos. Caramba, tenho um sistema Drobo de 6 TB em Raid-5 bem na minha mesa de casa e mais 3 HDs externos de 1TB para backup. Perdi muito pouco ao longo dos anos.

Realmente me incomoda quando perco informação.

* Gmail Business, DropBox, buckets do AWS S3, por serem serviços externos, não me preocupam, pois mantenho cópias de tudo offline. Então, se essas contas forem comprometidas de uma hora para outra, tenho múltiplas cópias.

* GitHub me incomodava um pouco porque, embora eu tenha múltiplas cópias dos repositórios, perderia todo o histórico de Pull Requests e Issues. Esse é um dos motivos pelos quais migrei para o meu próprio GitLab e ajudei a ajustar o processo de import para puxar esse histórico de Pull Requests.

* O Slack me incomoda muito pelos motivos já mencionados, e por isso na semana passada testamos primeiro o MatterMost e depois subimos o Rocket.chat.

![Mattermost](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/558/big_8_13_16__22_20.png)

### There, and Back Again

Saímos do Slack para o Rocket.chat e, alguns dias depois, estamos migrando de novo, agora para o Mattermost.

Sim, isso foi trabalhoso. Meu time não ficou muito feliz em deixar o Slack. O Slack é realmente elegante, completo, bonito, redondinho, um produto web de verdade para esta geração. Qualquer alternativa precisa ser pelo menos quase tão bonita e ter funcionalidades sem bugs, incluindo webhooks.

O Mattermost atende quase perfeitamente, mas a Team Edition open source carecia de uma funcionalidade importante para mim: a possibilidade de impedir que membros comuns renomeiem e/ou apaguem grupos privados. Sim, esperamos que adultos se comportem, mas quando você tem times remotos, clientes remotos, usuários externos sem nenhum compromisso com a empresa, isso vira uma dor de cabeça.

Sim, eu poderia, e provavelmente deveria, usar a Enterprise Edition paga. Mas só por essa pequena funcionalidade, achei caro demais. Isso me motivou a deixar pra lá e instalar o Rocket.chat. Movi todo o meu time pra lá (quase 50 pessoas, porque ainda não migrei os clientes). Esse seria o fim da história.

Mas o Rocket.chat tem uma infraestrutura complexa para lidar (você precisa ter no mínimo 3 máquinas, ou pagar a mais por um SaaS de Mongodb decente). Aliás, [no meu post anterior](http://www.akitaonrails.com/2016/08/09/moving-away-from-slack-into-rocket-chat-good-enough) expliquei por que vocês, pessoal de MEAN, não devem ser desleixados ao lidar com Mongodb. Resumindo: Mongodb não foi pensado para rodar em uma única instância, você precisa ter um replica set. Se você tem um Mongodb em instância única, está fazendo errado.

E o mais problemático: o client-side é simplesmente pesado demais. Frequentemente faz a CPU disparar em máquinas não tão potentes. É notavelmente, e mensuravelmente, mais lento de navegar na UI, comparado ao Slack. A UI do MatterMost era muito mais rápida e muito mais responsiva.

Eu estava quase disposto a relevar a falta de uma suíte de testes decente. Estava disposto a tentar conviver com Meteor e CoffeeScript. Estava disposto a lidar com a manutenção complexa do MongoDB.

Mas a lentidão na resposta atingindo vários membros do meu time é um show-stopper, um problema gigante. Desligamos a feature beta de videochat (já que ela sempre dispara picos de CPU em todos os usuários), mas vários membros ainda tinham uma experiência ruim com uma UI lenta demais e devoradora de recursos.

O MatterMost, baseado em React, escrito em ES6, devidamente estruturado, com suítes de teste client-side suficientemente boas, era um candidato mais adequado. Então decidi pensar de verdade no problema original e cheguei a uma solução simples: [adicionar uma função PLPGSQL simples](http://www.akitaonrails.com/2016/08/12/hackeando-o-mattermost-team-edition) para ser disparada sempre que alguém tentasse apagar um canal. Funcionou direitinho. E isso me motivou a chamar meu time de novo e propor essa nova mudança: acredito que todo mundo embarcou, já que o MatterMost estava muito mais rápido nas máquinas deles.

Sei que estou soando muito duro com o Rocket.chat, e essa não é minha intenção. Se não tivéssemos outras opções, ainda iríamos para o Rocket.chat. Mas como o Mattermost provou ser a melhor escolha, foi decisão fácil.

### Instalação do MatterMost

Como sempre, não vou cansar você com instruções já disponíveis online. Se quiser instalar tudo manualmente, siga [este tutorial](https://docs.mattermost.com/install/prod-ubuntu.html), mas uma opção melhor seria [o deployment via Docker](https://docs.mattermost.com/install/prod-docker.html). Você pode até instalar/atualizar [junto com o GitLab](http://docs.gitlab.com/omnibus/gitlab-mattermost/).

Garanta que você tenha NGINX na frente do servidor e que tenha tanto um domínio ou subdomínio devidamente registrado, quanto SSL - use Let's Encrypt.

Como quero continuar mexendo e experimentando com o codebase em uma instalação ativa, instalei tudo manualmente e tenho esta estrutura de diretórios:

```
-rw-r--r--  1 mattermost mattermost     6504 Aug 13 20:11 config.json
drwxrwxr-x  5 mattermost mattermost     4096 Aug 13 20:30 data
lrwxrwxrwx  1 mattermost mattermost       33 Aug 13 20:13 mattermost -> mattermost-team-3.3.0-linux-amd64
drwxr-xr-x  9 mattermost mattermost     4096 Aug 13 20:28 mattermost-team-3.2.0-linux-amd64
-rw-rw-r--  1 mattermost mattermost 19968308 Jul 14 16:37 mattermost-team-3.2.0-linux-amd64.tar.gz
drwxr-xr-x 11 mattermost mattermost     4096 Aug 13 20:28 mattermost-team-3.3.0-linux-amd64
-rw-rw-r--  1 mattermost mattermost 20241448 Aug 12 20:41 mattermost-team-3.3.0-linux-amd64.tar.gz
drwxrwxr-x  3 mattermost mattermost     4096 Aug 13 20:23 platform-dev-3.3.0
-rw-r--r--  1 mattermost mattermost 18060203 Aug 13 20:22 platform-dev.tar.gz
```

Tenho um usuário sudo restrito chamado `mattermost` e tenho um diretório principal `mattermost` apontando para os pacotes binários que você encontra na [página oficial de download](https://www.mattermost.org/download/).

Note que tenho uma cópia de `mattermost/config/config.json` no diretório home. Deixo lá para que, toda vez que eu baixe uma nova versão e refaça o symlink para `mattermost`, eu possa simplesmente fazer:

```
rm -Rf ~/mattermost/config/config.json
cd ~/mattermost/config
ln -s ~/mattermost/config.json
```

Garanta também que você ajuste pelo menos o seguinte na config:

```
...
"FileSettings": {
    "MaxFileSize": 83886080,
    "DriverName": "local",
    "Directory": "/home/mattermost/data",
...
```

Se quiser, você pode mandar os uploads de arquivos para algum bucket S3 que você tenha, e só preencher os detalhes da AWS. Mas se escolher tê-los localmente, mude o diretório para algum lugar fora da pasta `mattermost`, já que a cada upgrade você vai trocar a pasta. Tanto com AWS EC2 quanto com Digital Ocean você sempre pode escolher adicionar um volume secundário que sobreviva às VMs, então mesmo se chegar a um ponto de ter centenas de usuários simultâneos e quiser escalar horizontalmente, pode ter todas as máquinas apontando para um volume compartilhado (AWS EFS, por exemplo).

Por falar nisso, nessa configuração, atualizar seria assim:

```
sudo service mattermost stop
wget https://releases.mattermost.com/x.y.z/mattermost-team-x.y.z-linux-amd64.tar.gz
tar xvfz mattermost-team-x.y.z-linux-amd64.tar.gz
mv mattermost mattermost-team-x.y.z-linux-amd64
ln -s mattermost-team-x.y.z-linux-amd64 mattermost
rm -Rf mattermost/config/config.json
rm -Rf mattermost/data
cd mattermost/config
ln -s ~/config.json
cd ..
ln -s ~/data
sudo service mattermost start
```

A razão de eu querer dessa forma é poder ajustar o código e empurrar as alterações manualmente.

Para sua máquina de desenvolvimento, você deve seguir [estas instruções](https://docs.mattermost.com/developer/developer-setup.html). Se você está em OS X e escolhe usar o Docker Toolbox, lembre que você não precisa mais do VirtualBox, pois ele vai usar o hypervisor nativo do OS X agora. Na minha máquina, tive que adicionar `dockerhost` manualmente no meu `/etc/hosts` porque o `boot2docker` estava falhando em obter meu IP.

Aí você pode simplesmente clonar o código do Github:

```
mkdir mattermost
cd mattermost
git clone https://github.com/mattermost/platform
git checkout -b v3.3.0 v3.3.0
```

Lembre-se de sempre fazer checkout da versão estável correta (v3.3.0 na época em que postei este artigo originalmente) que você tem instalada no seu servidor. De novo, não vou cansar você com o que já está documentado nos links acima, mas você precisa ter Go 1.6(.3), Docker, Docker-Composer, Docker-Machine, tudo já instalado.

Você pode executar `make run` e, depois que terminar (e, como sempre, o npm vai garantir que isso demore muito), pode abrir `http://localhost:8065` para brincar localmente.

Mais importante: você pode mexer nos componentes JSX do React em `platform/webapp/components`, por exemplo, no `channel_header.jsx`, e adicionar coisas assim:

```javascript
// linha 493 da v3.3.0
if(isAdmin || isSystemAdmin) {
    dropdownContents.push(
        <li
            key='rename_channel'
            role='presentation'
        >
            <a
                role='menuitem'
                href='#'
                onClick={this.showRenameChannelModal}
            >
                <FormattedMessage
                    id='channel_header.rename'
                    defaultMessage='Rename {term}...'
                    values={{
                        term: (channelTerm)
                    }}
                />
            </a>
        </li>
    );

    if (!ChannelStore.isDefault(channel)) {
        dropdownContents.push(deleteOption);
    }
}
```

E sabe o que isso faz? Remove as opções "Rename Group" e "Delete Group" do menu do canal se o usuário não for um system admin. Agora, como colocar isso no seu servidor?

Antes de mais nada, você tem que editar o `Makefile` nesta seção:

```
@# Make osx package
@# Copy binary
cp $(GOPATH)/bin/darwin_amd64/platform $(DIST_PATH)/bin
@# Package
tar -C dist -czf $(DIST_PATH)-$(BUILD_TYPE_NAME)-osx-amd64.tar.gz mattermost
@# Cleanup
rm -f $(DIST_PATH)/bin/platform

@# Make windows package
@# Copy binary
cp $(GOPATH)/bin/windows_amd64/platform.exe $(DIST_PATH)/bin
@# Package
tar -C dist -czf $(DIST_PATH)-$(BUILD_TYPE_NAME)-windows-amd64.tar.gz mattermost
@# Cleanup
rm -f $(DIST_PATH)/bin/platform.exe

@# Make linux package
@# Copy binary
cp $(GOPATH)/bin/platform $(DIST_PATH)/bin
@# Package
tar -C dist -czf $(DIST_PATH)-$(BUILD_TYPE_NAME)-linux-amd64.tar.gz mattermost
@# Don't cleanup linux package so dev machines will have an unziped linux package avalilable
@#rm -f $(DIST_PATH)/bin/platform
```

Note que o desenvolvedor que fez esse arquivo provavelmente usa Linux. Isso porque esse arquivo gera o binário Linux-ELF como `bin/platform`, enquanto o binário OS X Mach-O fica em `bin/darwin_amd64/platform`. Agora, se como eu você está em OS X, tem que inverter isso e fazer a versão Linux apontar para `bin/linux_amd64/platform`, senão os pacotes vão ter o binário errado.

Aí você vai notar que existe esta seção bem no fim:

```
setup-mac:
    echo $$(boot2docker ip 2> /dev/null) dockerhost | sudo tee -a /etc/hosts
```

Se você está nas versões mais recentes do Docker-Toolbox, não precisa mais do boot2docker, ele vai usar o docker-machine. Então essa linha não funciona, e a forma mais fácil de fazer o `make test` rodar é trocar o `dockerhost` por `localhost` na configuração de PostgreSQL do `config/config.json`.

Se os testes estão todos passando, você pode rodar `make package` para gerar todos os pacotes, e então enviar o `dist/mattermost-team-edition-linux-amd64.tar.gz` para o seu servidor e descompactar no local correto.

Como nota pra noobs em Go como eu, eu tinha meu `GOPATH` apontando para `/Users/akitaonrails/.go` e meu projeto estava em `/Users/akitaonrails/codeminer42/mattermost/platform`. Me disseram que isso está incorreto e foi a fonte de muitas horas de frustração minha. O projeto PRECISA ESTAR DENTRO DO GOPATH.

Então mudei meu `GOPATH` para `/Users/akitaonrails/Sites/go` e o projeto para `/Users/akitaonrails/Sites/go/src/github.com/mattermost/platform` e agora funciona. Provavelmente eu também teria feito symlink do caminho do projeto para dentro do GOPATH. Mas agora tudo compila e roda direitinho.

É assim que vou continuar experimentando por enquanto, até me sentir confortável o suficiente para automatizar todo o processo depois. Isso deve funcionar bem para meu time por ora.

É claro, o snippet acima é apenas um **dirty hack**, não tente contribuir assim. Uma implementação adequada exigiria que eu pelo menos criasse uma nova configuração no `config.json`, por exemplo `TeamSettings.MembersCanManageChannel` como `false`, e mudasse o `api/context.go` por volta da linha 347 para algo como:

```ruby
func (c *Context) HasPermissionsToTeam(teamId string, where string) bool {
    if c.IsSystemAdmin() {
        return true
    }

    if !utils.cfg.TeamSettings.MembersCanManageChannel {
        return false
    }
    ...
```

Depois mudar o componente `webapp/channel_header.jsx` no front-end React (junto com testes unitários decentes em `webapp/tests/client_channel.test.jsx`), garantir que o `make test` passa, e finalmente abrir um feature request para o core team.

Mas a ideia aqui era só mostrar que não foi tão difícil resolver o show-stopper para o meu cenário particular, tanto usando o [trigger SQL](http://www.akitaonrails.com/2016/08/12/hackeando-o-mattermost-team-edition) para proteger o banco quanto o hack para arrumar a Web UI.

### Conclusão

Mas e a feature mais importante de todas? Suporte a RightGIF? Ainda não existe nada tão simples quanto um comando rightgif do Slack. Felizmente, dá pra compensar a maior parte dessas pequenas faltas instalando um [servidor Hubot](https://www.npmjs.com/package/hubot-mattermost), e ligando a um usuário para que você possa conversar com o bot e fazer ele fazer coisas pra você (programar um alarme, buscar um gif, traduzir texto, etc). Como ressalva, o adaptador do hubot exige o uso do [mattermost-client](https://github.com/loafoe/mattermost-client), que precisa ser sincronizado com as releases da plataforma do servidor para funcionar direito, então tome cuidado ao atualizar.

No geral, o Mattermost é uma ótima escolha. Também não é para amadores; o ambiente de desenvolvimento exige que você domine seu Docker. Exige que você saiba configurar Go-lang direito. Exige que você siga os [procedimentos adequados para contribuir](https://docs.mattermost.com/developer/contribution-guide.html), como deveria ser. O projeto em si é um único codebase dividido em aproximadamente 2 aplicações, uma API HTTP em Go e um front-end em React para consumir as APIs. Tudo no projeto é automatizado através do uso adequado de imagens Docker (para mysql, postgresql, instâncias openldap) e Makefiles para rodar a suíte de testes, criar pacotes, etc.

E ele tem algumas conveniências do Slack que o Rocket.chat ainda não tem, como um atalho simples para trocar de canal (Cmd-K), a capacidade de responder mensagens e organizá-las como threads, suporte a Markdown adequado e mais completo. No geral, as funcionalidades são redondas e bem acabadas. O que está lá é sólido e funciona; é sempre ruim ter funcionalidades pela metade.

Com esses hacks em mente, posso recomendar fortemente que você use Mattermost. E como já disse em posts anteriores, isso vai além de uma questão de custo. Se você é um time pequeno, sem desenvolvedores internos ou alguém que possa manter sua própria instalação, definitivamente deveria pagar pelo suporte Enterprise do Mattermost; é acessível e bem mais barato que o Slack.

Por enquanto, é a melhor escolha, tanto em termos de acabamento geral, funcionalidades completas, UI simples e responsiva, qualidade de código e o cuidado geral com a engenharia.
