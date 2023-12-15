use mundial
go

create or alter trigger goals_player_check
on events
instead of insert
AS
BEGIN

    if EXISTS (select * from inserted where EVENTTYPE = 'Goal')
    BEGIN


    insert into EVENTS (IDSUMMONEDMAINPLAYER,MINUTE,MATCHPART,EVENTTYPE,ISPENALTY,ISOWNGOAL)
    SELECT i.IDSUMMONEDMAINPLAYER,i.MINUTE,i.MATCHPART,i.EVENTTYPE,i.ISPENALTY,i.ISOWNGOAL
    from inserted i join EVENTS e on i.IDSUMMONEDMAINPLAYER = e.IDSUMMONEDMAINPLAYER join SUMMONEDS s on i.IDSUMMONEDMAINPLAYER = s.IDSUMMONED
    where s.STARTING11 = 'True'
    and i.IDSUMMONEDMAINPLAYER not in (select IDSUMMONEDPLAYEROUT from EVENTS) 
    -- and not exists (select e.CARDTYPE where e.CARDTYPE = 'Red' 
    -- and e.IDSUMMONEDMAINPLAYER = i.IDSUMMONEDMAINPLAYER)

    end;

    else
    BEGIN
    insert into events (IDSUMMONEDMAINPLAYER,IDSUMMONEDPLAYEROUT,[MINUTE],MATCHPART,EVENTTYPE,ISPENALTY,ISOWNGOAL,CARDTYPE)
    select IDSUMMONEDMAINPLAYER,IDSUMMONEDPLAYEROUT,[MINUTE],MATCHPART,EVENTTYPE,ISPENALTY,ISOWNGOAL,CARDTYPE
    from inserted
    end;


    if @@ROWCOUNT < (select count(*) from inserted)
        print('There were records not being inserted because the player is not on field.')


end;
go