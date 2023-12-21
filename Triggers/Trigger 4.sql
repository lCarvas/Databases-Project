use mundial
go

CREATE OR ALTER FUNCTION onfieldcheck(@IDSummoned numeric)
RETURNS bit
BEGIN

    IF NOT EXISTS (SELECT 1 FROM Summoneds LEFT OUTER JOIN Events ON IDSUMMONED = IDSummonedMainPlayer
                   WHERE IDSummoned = @IDSummoned
                   AND (Starting11 != 0 OR (IDEvent IS NOT NULL AND EventType = 'Replacement')))
    RETURN 0

    IF EXISTS (SELECT 1 FROM Summoneds LEFT OUTER JOIN Events ON IDSUMMONED = IDSummonedMainPlayer
               WHERE IDSummoned = @IDSummoned
               AND (IDEventPlayerOut IS NOT NULL
               OR (IDEvent IS NOT NULL AND EventType = 'Card' AND CardType = 'Red')))
    RETURN 0

    RETURN 1

END;
GO

CREATE OR ALTER TRIGGER goals_replacements
ON Events
INSTEAD OF INSERT
AS
BEGIN

    DROP TABLE IF EXISTS #temp_replace, #temp_goals
    SELECT * INTO #temp_goals FROM inserted WHERE eventType = 'Goal'
    SELECT * INTO #temp_replace FROM inserted WHERE eventType = 'Replacement'

    INSERT INTO Events (IDSummonedMainPlayer, Minute, Matchpart, EventType, CardType)
    SELECT IDSummonedMainPlayer, Minute, Matchpart, 'Card', CardType
    FROM inserted
    WHERE eventType = 'Card' AND CardType IS NOT NULL

    DECLARE
        @skipped_rows INT,
        @total_skipped INT,
        @goal_count INT = (SELECT COUNT(1) FROM #temp_goals),
        @replace_count INT = (SELECT COUNT(1) FROM #temp_replace)


    IF (@goal_count != 0)
    BEGIN

        INSERT INTO Events (IDSummonedMainPlayer, Minute, MatchPart, EventType, IsPenalty, IsOwnGoal)
        SELECT IDSummonedMainPlayer, Minute, MatchPart, 'Goal', IsPenalty, IsOwnGoal
        FROM #temp_goals
        WHERE dbo.onfieldcheck(IDSummonedMainPlayer) != 0

        SET @skipped_rows = @goal_count - @@rowcount;
        SET @total_skipped = @skipped_rows;
        IF (@skipped_rows > 0) PRINT 'Goals not inserted: ' + CAST(@skipped_rows AS nvarchar) + '.';

    END;
    DROP TABLE #temp_goals;
    
    IF (@replace_count != 0) BEGIN;
        INSERT INTO Events (IDSummonedMainPlayer, IDSummonedPlayerOut, Minute, MatchPart, EventType) 
        SELECT IDSummonedMainPlayer, IDSummonedPlayerOut, Minute, MatchPart, 'Replacement'
        FROM #temp_replace
        WHERE IDSummonedPlayerOut IS NOT NULL -- consistency; someone has to leave when someone else joins
        AND IDSummonedPlayerOut != IDSummonedMainPlayer -- yeah I won't be explaining this one
        AND dbo.onfieldcheck(IDSummonedPlayerOut) != 0 -- playerOut must be on the field before the substitution
        AND EXISTS (SELECT 1 FROM Summoneds sOut INNER JOIN Player pOut ON sOut.IDPlayer = pOut.IDPerson 
                    INNER JOIN Summoneds sIn ON sIn.IDSummoned = IDSummonedMainPlayer INNER JOIN Player pIn ON sIn.IDPlayer = pIn.IDPerson
                    WHERE sOut.IDSummoned = IDSummonedPlayerOut -- same as the join condition for sIn
                    AND sOut.IDMatch = sIn.IDMatch -- players must be in the same game
                    AND pOut.IDCountry = pIn.IDCountry -- players must be on the same team
                    AND sIn.Starting11 != 1 -- playerIn can't be in the starting players since that would mean they'd have already been on the field
                    AND NOT EXISTS (SELECT 1 FROM Events WHERE Events.IDSummonedMainPlayer = sIn.IDSummoned
                                    AND ((Events.EventType = 'Card' AND Events.CardType = 'Red') -- playerIn can't have a red card
                                    OR Events.EventType = 'Replacement'))) -- playerIn can't have entered the game earlier

        SET @skipped_rows = @replace_count - @@rowcount;
        SET @total_skipped = @total_skipped + @skipped_rows;
        IF (@skipped_rows > 0) PRINT 'Substitutions not inserted: ' + CAST(@skipped_rows AS nvarchar) + '.';

    END;
    DROP TABLE #temp_replace;

    IF (@total_skipped > 0) PRINT 'Total number of records not inserted: ' + CAST(@total_skipped AS nvarchar) + '.';

END;
GO


CREATE OR ALTER TRIGGER card_event_sumupdate
ON Events
AFTER INSERT
AS
BEGIN

    UPDATE Summoneds
    SET IDEventPlayerOut = IDEvent
    FROM inserted
    WHERE IDSummonedPlayerOut = IDSummoned
    AND EventType = 'Replacement'


    INSERT INTO Events (IDSummonedMainPlayer, Minute, Matchpart, EventType, CardType) 
    SELECT IDSummonedMainPlayer, Minute, MatchPart, 'Card', 'Red'
    FROM inserted
    WHERE EventType = 'Card' AND CardType = 'Yellow'
    AND EXISTS (SELECT 1 FROM Events WHERE Events.IDSummonedMainPlayer = inserted.IDSummonedMainPlayer
                AND (inserted.IDEVENT IS NULL OR EVENTS.IDEVENT != inserted.IDEVENT)
                AND Events.EventType = 'Card'
                AND Events.CardType = 'Yellow')

END;
GO