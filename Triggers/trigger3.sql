use mundial
go

-- When a yellow card event is inserted, it must be verified if the player already received a 
-- yellow card in the same match. If that is the case, then a new red card event must be 
-- inserted with the same data. (INSERT) 

create or alter trigger card_event
ON events
instead of INSERT
AS 
BEGIN

    if exists (SELECT * from inserted i where i.EVENTTYPE = 'Card' and i.CARDTYPE = 'Yellow')

    -- How do I check if the player has a yellow card already?
    -- Maybe?? How do I make this fit in the code??

    -- select COUNT(CARDTYPE) as 'yellow card'
    -- from EVENTS
    -- where CARDTYPE = 'Yellow' and events.IDSUMMONEDMAINPLAYER = 9
    -- group by IDSUMMONEDMAINPLAYER
    

    BEGIN
            insert into EVENTS (IDSUMMONEDMAINPLAYER,IDSUMMONEDPLAYEROUT,MINUTE,MATCHPART,EVENTTYPE,CARDTYPE)
            SELECT i.IDSUMMONEDMAINPLAYER, i.IDSUMMONEDPLAYEROUT, i.MINUTE, i.MATCHPART, 'Card', 'Red'
            from inserted i join events e on i.IDSUMMONEDMAINPLAYER = e.IDSUMMONEDMAINPLAYER
            WHERE exists (select COUNT(e.CARDTYPE)
                            from EVENTS e 
                            where e.CARDTYPE = 'Yellow'
                            group by e.IDSUMMONEDMAINPLAYER)

    end;

end;
GO

