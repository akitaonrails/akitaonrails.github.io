---
title: Hacking Mattermost Team Edition
date: '2016-08-12T14:43:00-03:00'
slug: hacking-mattermost-team-edition
tags:
- mattermost
- postgresql
- rocket.chat
- slack
draft: false
---

In [my previous post](http://www.akitaonrails.com/2016/08/09/moving-away-from-slack-into-rocket-chat-good-enough) I was reporting on my move from Slack to Rocket.chat. But I also mentioned that before Rocket.chat I would rather use Mattermost. First and foremost because it's written in Go (lightweight, highly concurrent, super stable), and because the code base shows much more quality than Rocket.chat (which feels super fragile, with almost no automated tests at all).

But my major complaint with MatterMost is because the free, open source, Team Edition, lacks a super important feature: not allowing users to delete private groups.

[@iantien commented](http://www.akitaonrails.com/2016/08/09/moving-away-from-slack-into-rocket-chat-good-enough#comment-2832915684) that the private groups are never actually "deleted", they are just marked as deleted, audited, but all data is still in the database. Just the UI has no way to hide the "delete" option from users and there is no Administration UI to unarchive the delete groups.

In fact, you can open a `psql` session in your PostgreSQL database and just do:

---
update channels set deleteat = 0;
---

This will unarchive and restore all delete channels. But you can see how this is a hassle.

I strongly disagree when he says that only "10,000 users enterprises" would need such a feature. Even in a small team, any grumpy user can just archive a channel out of the blue and disrupt the entire team communication in private groups. Sure, the "Town Square" and other public channels will still function, but if you have just one external user participating in projects, for example, you want to use private groups to isolate your internal communication from external users.

So, not having the option for very basic permissions (such as disallowing members to delete channels or private groups) is a very big show stopper even for small teams. And sure, the USD 20/user/year fee is not expensive, but as Mattermost still has less features than Rocket.chat, it becomes a very hard to sell proposition.

Also, hacking the code itself and adding a flag to disallow this option, in Go, is actually quite easy, but you would have to maintain your own fork (as I think Mattermost would not accept a pull request from a feature that already is in their payed, Enterprise offering)

But after @iantien commented that nothing is deleted and it's all audited, I quickly realized that I could use the audit metadata and devise a way to automatically restore the channels (unless it's the system admin doing it). All without altering the source code.

One can use the many tools available in PostgreSQL itself, namely: **TRIGGERS**. So, without further ado, just run this in your Mattermost database:

--- sql
CREATE OR REPLACE FUNCTION undelete_channel() RETURNS trigger AS $$
    DECLARE
        user_counter integer;
        channel_id character varying(26);
    BEGIN
        -- Only for channel delete operations
        IF NEW.action NOT LIKE '%/channels/%/delete' THEN
            RETURN NEW;
        END IF;

        -- Check if it is the system_admin
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
---

That's it, it will listen to audits new inserts, check if it is a "channel delete" action, check if it is not a 'system_admin', and if so it will automatically grab the channel id from the action REST URL and do the proper UPDATE to get it back.

I tested it already and in my UI users don't even realize something happened. Not even the offending user sees the channel go away, it instantly comes back.

So, if this was the only thing stopping you to use the free-of-charge, on-premise Team Edition, there you go. And with this you can derive functions to also avoid renaming channels, but I will leave it as an exercise for you (please share in the comments section below if you do it).

Happy Hacking!
