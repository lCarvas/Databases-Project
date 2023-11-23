Use MUNDIAL
Go 

/*A referee cannot referee a match where her/his own country is participating.
(INSERT/UPDATE) - Can't use an after update sadly */ 


CREATE OR ALTER TRIGGER referee_match
ON Match
INSTEAD OF INSERT
AS 
BEGIN

Insert into match (IDAWAYTEAM,IDTOURNAMENTPHASE,IDSTADIUM,IDHOMETEAM,IDREFEREE,STARTDATETIME,ADDEDTIME1STHALF,ADDEDTIME2NDHALF,EXTRATIMEADDEDTIME1STHALF,EXTRATIMEADDEDTIME2NDHALF,EXTRATIME,PENALTIES)
	select IDAWAYTEAM,IDTOURNAMENTPHASE,IDSTADIUM,IDHOMETEAM,IDREFEREE,STARTDATETIME,ADDEDTIME1STHALF,ADDEDTIME2NDHALF,EXTRATIMEADDEDTIME1STHALF,EXTRATIMEADDEDTIME2NDHALF,EXTRATIME,PENALTIES
	from inserted i join REFEREE r on i.IDREFEREE = r.IDPERSON
	WHERE r.IDCOUNTRY != i.IDAWAYTEAM and r.IDCOUNTRY != i.IDHOMETEAM 

end;
GO