Use MUNDIAL
Go 

/*A referee cannot referee a match where her/his own country is participating.
(INSERT/UPDATE) - Can't use an after update sadly */ 


CREATE OR ALTER TRIGGER referee_match
ON Match
INSTEAD OF INSERT
AS 
BEGIN

 Insert into (IDREFEREE)
	Select m.IDREFEREE
	From countries c join Referee r on c.IDCOUNTRY = r.IDCOUNTRY
		LEFT JOIN MATCH m on r.IDCOUNTRY = m.IDHOMETEAM 
		LEFT JOIN MATCH m on r.IDCOUNTRY = ma.IDAWAYTEAM
	Where r.IDCOUNTRY != m.IDAWAYTEAM and r.IDCOUNTRY != ma.IDHOMETEAM
end;
GO

INSERT INTO MATCH 




-- run the following line to disable all constraints before
--loading data to avoid FK restrictions
EXEC sp_MSForEachTable "ALTER TABLE ? NOCHECK CONSTRAINT all";

-- delete data in all tables
EXEC sp_MSForEachTable "DELETE FROM ?";

-- <Do the import/insert in all tables>
-- run the following line to enable all constraints back. DO NOT
--FORGET TO RUN THIS LINE AFTER IMPORTING/INSERTING DATA!!
EXEC sp_MSForEachTable "ALTER TABLE ? WITH CHECK CHECK
CONSTRAINT all";

























