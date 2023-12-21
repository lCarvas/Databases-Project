use mundial
go

create or alter trigger no_country_entry
on SUMMONEDS
instead OF INSERT
AS
BEGIN

    INSERT INTO SUMMONEDS (IDPLAYER,IDMATCH,STARTING11)
    SELECT i.IDPLAYER, i.IDMATCH, i.STARTING11
    FROM inserted i INNER JOIN PLAYER p on i.IDPLAYER = p.IDPERSON
                    INNER JOIN MATCH m on m.IDMATCH = i.IDMATCH                    
    WHERE p.IDCOUNTRY IN (m.IDHOMETEAM,m.IDAWAYTEAM) and m.IDMATCH = i.IDMATCH

    if @@ROWCOUNT < (select count(*) from inserted)
        print('There were records not being inserted because the player does not belong to any of the countries playing on the match.')

end;
go
