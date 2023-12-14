Use MUNDIAL
Go 

/*A referee cannot referee a match where her/his own country is participating.
(INSERT/UPDATE) - Can't use an after update sadly */ 


CREATE OR ALTER TRIGGER referee_match_insert
ON Match
INSTEAD OF INSERT
AS 
BEGIN

	Insert into match (IDAWAYTEAM,IDTOURNAMENTPHASE,IDSTADIUM,IDHOMETEAM,IDREFEREE,STARTDATETIME,ADDEDTIME1STHALF,ADDEDTIME2NDHALF,EXTRATIMEADDEDTIME1STHALF,EXTRATIMEADDEDTIME2NDHALF,EXTRATIME,PENALTIES)
	select IDAWAYTEAM,IDTOURNAMENTPHASE,IDSTADIUM,IDHOMETEAM,IDREFEREE,STARTDATETIME,ADDEDTIME1STHALF,ADDEDTIME2NDHALF,EXTRATIMEADDEDTIME1STHALF,EXTRATIMEADDEDTIME2NDHALF,EXTRATIME,PENALTIES
	from inserted i join REFEREE r on i.IDREFEREE = r.IDPERSON
	WHERE r.IDCOUNTRY != i.IDAWAYTEAM and r.IDCOUNTRY != i.IDHOMETEAM 

	if @@ROWCOUNT < (select count(*) from inserted)
        print('There were records not being inserted because the referee belongs to one of the countries playing on the match.')

end;
GO

---

create or alter trigger referee_match_update
on MATCH
instead of UPDATE
as
BEGIN

	update MATCH 
	set IDREFEREE = i.IDREFEREE
	from inserted i join MATCH m on i.IDMATCH = m.IDMATCH join REFEREE r on i.IDREFEREE = r.IDPERSON
	where r.IDCOUNTRY != m.IDAWAYTEAM and r.IDCOUNTRY != m.IDHOMETEAM

	if @@ROWCOUNT < (select count(*) from inserted)
        print('There were records not being updated because the referee belongs to one of the countries playing on the match.')

end;
go