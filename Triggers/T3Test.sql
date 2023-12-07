use mundial
go

begin TRANSACTION

select * from EVENTS

insert into EVENTS (IDSUMMONEDMAINPLAYER,IDSUMMONEDPLAYEROUT,MINUTE,MATCHPART,EVENTTYPE,CARDTYPE)
values (1,Null,52,'Second half','Card','Yellow')


select * from EVENTS

rollback TRANSACTION
