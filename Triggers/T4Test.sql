use mundial
go

begin TRANSACTION

select * from EVENTS

insert into EVENTS (IDSUMMONEDMAINPLAYER,MINUTE,MATCHPART,EVENTTYPE,ISPENALTY,ISOWNGOAL)
values (1,52,'Second half','Goal',0,0)
,(4,52,'Second half','Goal',0,0)
,(14,52,'Second half','Goal',0,0)
,(2,52,'Second half','Goal',0,0)
,(5,52,'Second half','Goal',0,0)



select * from EVENTS

rollback TRANSACTION
