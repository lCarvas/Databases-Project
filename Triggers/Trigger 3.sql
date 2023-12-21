use mundial
go

-- When a yellow card event is inserted, it must be verified if the player already received a 
-- yellow card in the same match. If that is the case, then a new red card event must be 
-- inserted with the same data. (INSERT) 

create or alter trigger card_event
ON events
after INSERT
AS 
BEGIN

            insert into EVENTS (IDSUMMONEDMAINPLAYER,IDSUMMONEDPLAYEROUT,MINUTE,MATCHPART,EVENTTYPE,CARDTYPE)
            SELECT distinct i.IDSUMMONEDMAINPLAYER, i.IDSUMMONEDPLAYEROUT, i.MINUTE, i.MATCHPART, 'Card', 'Red'
            from inserted i join events e on i.IDSUMMONEDMAINPLAYER = e.IDSUMMONEDMAINPLAYER
            WHERE 1 < (select COUNT(e.CARDTYPE)
                            from EVENTS e 
                            where e.CARDTYPE = 'Yellow' and i.IDSUMMONEDMAINPLAYER = e.IDSUMMONEDMAINPLAYER
                            group by e.IDSUMMONEDMAINPLAYER)

end;
GO

