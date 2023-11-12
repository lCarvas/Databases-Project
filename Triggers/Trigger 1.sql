use mundial
go

create or alter trigger no_country_entry
on SUMMONEDS
instead OF INSERT
AS
BEGIN

    insert into SUMMONEDS
    SELECT *
    from inserted i join PLAYER p on i.IDPLAYER = p.IDPERSON
                    left join [MATCH] m on p.IDCOUNTRY = m.IDHOMETEAM
                    left join [MATCH] ma on p.IDCOUNTRY = ma.IDAWAYTEAM
                   

    WHERE p.IDCOUNTRY = m.IDHOMETEAM or p.IDCOUNTRY = ma.IDAWAYTEAM

end;
go
