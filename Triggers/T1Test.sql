use mundial
go

begin TRANSACTION

select * from SUMMONEDS

insert into SUMMONEDS (IDPLAYER,IDMATCH,STARTING11)
values(1,1,1),(6,1,1) -- player na equipa 1 que está no jogo -- player 3 que nao esta em nenhuma equipa

select * from SUMMONEDS

ROLLBACK TRANSACTION