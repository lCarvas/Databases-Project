use mundial
go

begin TRANSACTION

select * from EVENTS

insert into EVENTS (IDSUMMONEDMAINPLAYER,IDSUMMONEDPLAYEROUT,MINUTE,MATCHPART,EVENTTYPE,CARDTYPE)
values (2,Null,52,'Second half','Goal',Null)
,(1,Null,52,'Second half','Card','Yellow')
,(3,Null,52,'Second half','Card','Yellow')


select * from EVENTS

rollback TRANSACTION
