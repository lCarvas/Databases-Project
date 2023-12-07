use mundial
go

create or alter trigger no_country_entry
on SUMMONEDS
instead OF INSERT
AS
BEGIN

    insert into SUMMONEDS (IDPLAYER,IDMATCH,STARTING11)
    SELECT i.IDPLAYER, i.IDMATCH, i.STARTING11
    from inserted i join PLAYER p on i.IDPLAYER = p.IDPERSON
                    join [MATCH] m on m.IDMATCH = i.IDMATCH
                    
                   

    WHERE (p.IDCOUNTRY = m.IDHOMETEAM or p.IDCOUNTRY = m.IDAWAYTEAM) and m.IDMATCH = i.IDMATCH

    if @@ROWCOUNT < (select count(*) from inserted)
        print('There were records not being inserted because the player does not belong to any of the countries playing on the match.')

end;
go
