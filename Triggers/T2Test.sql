use MUNDIAL
go

begin TRANSACTION

select * from MATCH

insert into match(IDAWAYTEAM,IDTOURNAMENTPHASE,IDSTADIUM,IDHOMETEAM,IDREFEREE,STARTDATETIME,ADDEDTIME1STHALF,ADDEDTIME2NDHALF,EXTRATIMEADDEDTIME1STHALF,EXTRATIMEADDEDTIME2NDHALF,EXTRATIME,PENALTIES)
values(1,1,1,2,34,'1997/06/25',NULL,NULL,NULL,NULL,NULL,NULL), (1,1,1,2,37,'1997/06/25',NULL,NULL,NULL,NULL,NULL,NULL)

select * from MATCH
rollback TRANSACTION

---

begin TRANSACTION

select * from MATCH

update [MATCH]
set IDREFEREE = 34
where IDMATCH = 1

select * from MATCH

ROLLBACK TRANSACTION
