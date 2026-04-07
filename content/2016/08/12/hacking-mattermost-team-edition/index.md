---
title: "Hackeando o Mattermost Team Edition"
date: '2016-08-12T14:43:00-03:00'
slug: hackeando-o-mattermost-team-edition
translationKey: hacking-mattermost-team-edition
aliases:
- /2016/08/12/hacking-mattermost-team-edition/
tags:
- mattermost
- postgresql
- rocket.chat
- slack
- traduzido
draft: false
---

No [meu post anterior](http://www.akitaonrails.com/2016/08/09/moving-away-from-slack-into-rocket-chat-good-enough) contei sobre minha migração do Slack para o Rocket.chat. Mas também mencionei que, antes do Rocket.chat, eu preferiria usar o Mattermost. Primeiro, porque é escrito em Go (leve, altamente concorrente, super estável), e segundo, porque a base de código mostra muito mais qualidade do que a do Rocket.chat (que parece super frágil, com praticamente nenhum teste automatizado).

Mas minha maior reclamação com o Mattermost é que a Team Edition, gratuita e open source, não tem um recurso super importante: impedir que usuários apaguem grupos privados.

O [@iantien comentou](http://www.akitaonrails.com/2016/08/09/moving-away-from-slack-into-rocket-chat-good-enough#comment-2832915684) que na verdade os grupos privados nunca são realmente "apagados", eles só ficam marcados como deletados, auditados, mas todos os dados continuam no banco. Só que a UI não tem como esconder a opção de "delete" dos usuários e não existe uma tela de Administração para desarquivar os grupos apagados.

De fato, dá para abrir uma sessão `psql` no seu banco PostgreSQL e simplesmente rodar:

```
update channels set deleteat = 0;
```

Isso vai desarquivar e restaurar todos os canais apagados. Mas dá para ver como isso é um saco.

Discordo fortemente quando ele diz que só "empresas com 10.000 usuários" precisariam de um recurso desses. Mesmo em um time pequeno, qualquer usuário mal-humorado pode simplesmente arquivar um canal do nada e atrapalhar toda a comunicação do time nos grupos privados. Claro, a "Town Square" e outros canais públicos continuam funcionando, mas se você tem até mesmo um único usuário externo participando de projetos, por exemplo, você quer usar grupos privados para isolar a comunicação interna dos usuários externos.

Então, não ter a opção de permissões bem básicas (como impedir que membros apaguem canais ou grupos privados) é um baita empecilho mesmo para times pequenos. E sim, a taxa de USD 20/usuário/ano não é cara, mas como o Mattermost ainda tem menos recursos que o Rocket.chat, fica uma proposta difícil de vender.

Hackear o código diretamente e adicionar uma flag para desabilitar essa opção, em Go, até que é bem fácil, só que você teria que manter seu próprio fork (porque acho que o Mattermost não aceitaria um pull request de uma feature que já está na oferta paga, Enterprise, deles).

Mas depois que o @iantien comentou que nada é apagado e tudo fica auditado, rapidamente percebi que eu poderia usar os metadados de auditoria e bolar um jeito de restaurar automaticamente os canais (exceto quando for o system admin fazendo). Tudo isso sem mexer no código-fonte.

Dá para usar as várias ferramentas disponíveis no próprio PostgreSQL, a saber: **TRIGGERS**. Então, sem mais delongas, basta rodar isto no seu banco do Mattermost:

```sql
CREATE OR REPLACE FUNCTION undelete_channel() RETURNS trigger AS $$
    DECLARE
        user_counter integer;
        channel_id character varying(26);
    BEGIN
        -- Apenas para operações de delete de canal
        IF NEW.action NOT LIKE '%/channels/%/delete' THEN
            RETURN NEW;
        END IF;

        -- Verifica se é o system_admin
        SELECT count(*) INTO user_counter
        FROM users
        WHERE id = NEW.userid
        AND roles = 'system_admin';

        IF user_counter > 0 THEN
            RETURN NEW;
        END IF;

        channel_id = split_part(NEW.action, '/', 7);

        UPDATE channels
        SET deleteat = 0
        WHERE id = channel_id;

        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS undelete_channel ON audits;
CREATE TRIGGER undelete_channel AFTER INSERT ON audits
    FOR EACH ROW EXECUTE PROCEDURE undelete_channel();
```

É isso, ela vai escutar novos inserts na tabela de audits, checar se é uma ação de "channel delete", checar se não é um 'system_admin', e, sendo o caso, pega automaticamente o id do canal da URL REST da action e faz o UPDATE para trazê-lo de volta.

Já testei e na minha UI os usuários nem percebem que algo aconteceu. Nem o próprio usuário que tentou deletar vê o canal sumir, ele volta instantaneamente.

Então, se isso era a única coisa impedindo você de usar a Team Edition on-premise, gratuita, aí está. E com isso você pode derivar funções para também impedir que canais sejam renomeados, mas vou deixar isso como exercício para você (por favor, compartilhe nos comentários abaixo se fizer).

Happy Hacking!
