use mundial
go

begin TRANSACTION

select * from EVENTS

insert into EVENTS (IDSUMMONEDMAINPLAYER,IDSUMMONEDPLAYEROUT,MINUTE,MATCHPART,EVENTTYPE,CARDTYPE)
values (9,Null,51,'First half','Card','Yellow')


select * from EVENTS

rollback TRANSACTION
