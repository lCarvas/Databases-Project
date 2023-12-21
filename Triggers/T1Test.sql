use mundial
go

begin TRANSACTION

delete from SUMMONEDS
where IDSUMMONED = 2

select * from SUMMONEDS

insert into SUMMONEDS (IDPLAYER,IDMATCH,STARTING11)
values(2,1,1) -- player na equipa 1 que está no jogo -- player 3 que nao esta em nenhuma equipa

select * from SUMMONEDS

ROLLBACK TRANSACTION