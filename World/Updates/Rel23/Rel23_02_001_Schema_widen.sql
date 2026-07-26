-- ----------------------------------------------------------------
-- This is an attempt to create a full transactional MaNGOS update
-- Now compatible with newer MySql Databases (v1.5)
-- ----------------------------------------------------------------
DROP PROCEDURE IF EXISTS `update_mangos`; 

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_mangos`()
BEGIN
    DECLARE bRollback BOOL  DEFAULT FALSE ;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `bRollback` = TRUE;

    -- Current Values (TODO - must be a better way to do this)
    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @cCurStructure := (SELECT `structure` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @cCurContent := (SELECT `content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);

    -- Expected Values
    SET @cOldVersion = '23'; 
    SET @cOldStructure = '01'; 
    SET @cOldContent = '002';

    -- New Values
    SET @cNewVersion = '23';
    SET @cNewStructure = '02';
    SET @cNewContent = '001';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'Schema_widen';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Schema_widen';

    -- Evaluate all settings
    SET @cCurResult := (SELECT `description` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @cOldResult := (SELECT `description` FROM `db_version` WHERE `version`=@cOldVersion AND `structure`=@cOldStructure AND `content`=@cOldContent);
    SET @cNewResult := (SELECT `description` FROM `db_version` WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

    IF (@cCurResult = @cOldResult) THEN    -- Does the current version match the expected version
        -- APPLY UPDATE
        START TRANSACTION;
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
        -- -- PLACE UPDATE SQL BELOW -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

    -- ============================================================================
-- Mangos4 conversion for MOP, phase 0: SCHEMA WIDENING for MoP values
--
-- The mangos4 core is MoP-aware, but several MangosFour columns are too narrow
-- for MoP data ranges. This widens exactly the columns where values exceed the
-- old limits, so the conversion files can carry the original values unclamped:
--   creature_template.Family     tinyint      -> smallint      (MoP pet families 128+)
--   item_template.AllowableRace  mediumint    -> int           (Pandaren race bits, keeps -1 = all)
--   quest_template.QuestFlags    mediumint u. -> int unsigned  (MoP quest flags > 2^24)
--   quest_poi.floorId            tinyint u.   -> int unsigned  (MoP floor ids)
--   gameobject_template.data1/6  int unsigned -> int signed    (-1 sentinels in MoP GO data)
--   npc_trainer.spell            mediumint u. -> int signed    (negative = trainer-cast spell)
-- ============================================================================
SET NAMES utf8;

ALTER TABLE `creature_template`
  MODIFY `Family` SMALLINT(6) NOT NULL DEFAULT 0 COMMENT 'This Defines The Family That This Creature Belongs To.';

ALTER TABLE `item_template`
  MODIFY `AllowableRace` INT(11) NOT NULL DEFAULT -1 COMMENT 'Mask of allowed races.';

ALTER TABLE `quest_template`
  MODIFY `QuestFlags` INT(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'The quest flags give additional details on the quest type.';

ALTER TABLE `quest_poi`
  MODIFY `floorId` INT(10) UNSIGNED NOT NULL DEFAULT 0;

ALTER TABLE `gameobject_template`
  MODIFY `data1` INT(11) NOT NULL DEFAULT 0 COMMENT 'The content of the data fields depends on the gameobject type',
  MODIFY `data6` INT(11) NOT NULL DEFAULT 0 COMMENT 'The content of the data fields depends on the gameobject type';

ALTER TABLE `npc_trainer`
  MODIFY `spell` INT(11) NOT NULL DEFAULT 0 COMMENT 'Learning spell ID (See Spell.dbc). Negative: spell the trainer casts to teach.';

ALTER TABLE `player_levelstats`
  MODIFY `str` SMALLINT(5) UNSIGNED NOT NULL DEFAULT 0,
  MODIFY `agi` SMALLINT(5) UNSIGNED NOT NULL DEFAULT 0,
  MODIFY `sta` SMALLINT(5) UNSIGNED NOT NULL DEFAULT 0,
  MODIFY `inte` SMALLINT(5) UNSIGNED NOT NULL DEFAULT 0,
  MODIFY `spi` SMALLINT(5) UNSIGNED NOT NULL DEFAULT 0;

ALTER TABLE `spell_area`
  MODIFY `racemask` INT(10) UNSIGNED NOT NULL DEFAULT 0;



        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
        -- -- PLACE UPDATE SQL ABOVE -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

        -- If we get here ok, commit the changes
        IF bRollback = TRUE THEN
            ROLLBACK;
            SHOW ERRORS;
            SELECT '* UPDATE FAILED *' AS `===== Status =====`,@cCurResult AS `===== DB is on Version: =====`;
        ELSE
            COMMIT;
            -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
            -- UPDATE THE DB VERSION
            -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
            INSERT INTO `db_version` VALUES (@cNewVersion, @cNewStructure, @cNewContent, @cNewDescription, @cNewComment);
            SET @cNewResult := (SELECT `description` FROM `db_version` WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

            SELECT '* UPDATE COMPLETE *' AS `===== Status =====`,@cNewResult AS `===== DB is now on Version =====`;
        END IF;
    ELSE    -- Current version is not the expected version
        IF (@cCurResult = @cNewResult) THEN    -- Does the current version match the new version
            SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cCurResult AS `===== DB is already on Version =====`;
        ELSE    -- Current version is not one related to this update
            IF(@cCurResult IS NULL) THEN    -- Something has gone wrong
                SELECT '* UPDATE FAILED *' AS `===== Status =====`,'Unable to locate DB Version Information' AS `============= Error Message =============`;
            ELSE
                IF(@cOldResult IS NULL) THEN    -- Something has gone wrong
                    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurStructure := (SELECT `STRUCTURE` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurContent := (SELECT `Content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent, ' - ',@cCurResult);
                    SET @cOldResult = CONCAT('Rel',@cOldVersion, '_', @cOldStructure, '_', @cOldContent, ' - ','IS NOT APPLIED');
                    SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cOldResult AS `=== Expected ===`,@cCurOutput AS `===== Found Version =====`;
                ELSE
                    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurStructure := (SELECT `STRUCTURE` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurContent := (SELECT `Content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent, ' - ',@cCurResult);
                    SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cOldResult AS `=== Expected ===`,@cCurOutput AS `===== Found Version =====`;
                END IF;
            END IF;
        END IF;
    END IF;
END $$

DELIMITER ;

-- Execute the procedure
CALL update_mangos();

-- Drop the procedure
DROP PROCEDURE IF EXISTS `update_mangos`;


