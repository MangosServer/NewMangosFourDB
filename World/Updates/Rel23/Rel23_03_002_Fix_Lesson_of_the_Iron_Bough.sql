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
    SET @cOldStructure = '03'; 
    SET @cOldContent = '001';

    -- New Values
    SET @cNewVersion = '23';
    SET @cNewStructure = '03';
    SET @cNewContent = '002';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'Fix_Lesson_of_the_Iron_Bough';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Fix_Lesson_of_the_Iron_Bough';

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
-- Fix: Pandaren "The Lesson of the Iron Bough" - Weapon Rack Loot
-- ============================================================================
-- All Weapon Rack gameobjects in the Wandering Isle starting area should
-- provide class-appropriate weapons when the player has accepted their
-- class-specific version of "The Lesson of the Iron Bough" quest.
--
-- Currently each rack only contains items for a single class. This patch
-- adds every class's weapon items to every rack, gated by a condition
-- that checks whether the player has the matching quest active.
--
-- Quest -> Class -> Items:
--   30027  Monk      73209 (Trainee's Staff)
--   30033  Mage      76390 (Trainee's Spellblade), 76392 (Trainee's Hand Fan)
--   30034  Hunter    73211 (Trainee's Crossbow)
--   30035  Priest    73207 (Trainee's Mace), 76393 (Trainee's Book of Prayers)
--   30036  Rogue     73208 (Trainee's Dagger), 73212 (Trainee's Dagger)
--   30037  Shaman    76391 (Trainee's Axe), 73213 (Trainee's Shield)
--   30038  Warrior   73210 (Trainee's Sword)
--
-- Weapon Rack GO entries (type 3, displayId 10721) and their loot templates:
--   210005 -> loot 40856    210015 -> loot 40859    210016 -> loot 40860
--   210017 -> loot 40861    210018 -> loot 40862    210019 -> loot 40863
--   210020 -> loot 40864
-- ============================================================================

-- --------------------------------------------------------
-- Step 1: Create CONDITION_QUESTTAKEN (type 9) entries
--         for each class quest
-- --------------------------------------------------------
INSERT INTO `conditions` (`condition_entry`, `type`, `value1`, `value2`, `comments`) VALUES
(57808, 9, 30027, 0, 'Iron Bough - Monk quest taken'),
(57809, 9, 30033, 0, 'Iron Bough - Mage quest taken'),
(57810, 9, 30034, 0, 'Iron Bough - Hunter quest taken'),
(57811, 9, 30035, 0, 'Iron Bough - Priest quest taken'),
(57812, 9, 30036, 0, 'Iron Bough - Rogue quest taken'),
(57813, 9, 30037, 0, 'Iron Bough - Shaman quest taken'),
(57814, 9, 30038, 0, 'Iron Bough - Warrior quest taken');

-- --------------------------------------------------------
-- Step 2: Remove existing weapon items from all 7 loot
--         templates (keep any non-weapon items intact)
-- --------------------------------------------------------
DELETE FROM `gameobject_loot_template` WHERE `entry` = 40856 AND `item` = 73209;
DELETE FROM `gameobject_loot_template` WHERE `entry` = 40859 AND `item` IN (76390, 76392);
DELETE FROM `gameobject_loot_template` WHERE `entry` = 40860 AND `item` = 73211;
DELETE FROM `gameobject_loot_template` WHERE `entry` = 40861 AND `item` IN (73207, 76393);
DELETE FROM `gameobject_loot_template` WHERE `entry` = 40862 AND `item` IN (73208, 73212);
DELETE FROM `gameobject_loot_template` WHERE `entry` = 40863 AND `item` IN (73213, 76391);
DELETE FROM `gameobject_loot_template` WHERE `entry` = 40864 AND `item` = 73210;

-- --------------------------------------------------------
-- Step 3: Insert all class weapon items into every loot
--         template, each gated by its quest condition.
--         ChanceOrQuestChance = 100 (guaranteed when
--         condition is met), groupid = 0, min/max = 1.
-- --------------------------------------------------------

-- Helper: one INSERT per loot template, all 12 items
-- Loot 40856 (GO 210005)
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
(40856, 73209, 100, 0, 1, 1, 57808),  -- Monk: Staff
(40856, 76390, 100, 0, 1, 1, 57809),  -- Mage: Spellblade
(40856, 76392, 100, 0, 1, 1, 57809),  -- Mage: Hand Fan
(40856, 73211, 100, 0, 1, 1, 57810),  -- Hunter: Crossbow
(40856, 73207, 100, 0, 1, 1, 57811),  -- Priest: Mace
(40856, 76393, 100, 0, 1, 1, 57811),  -- Priest: Book of Prayers
(40856, 73208, 100, 0, 1, 1, 57812),  -- Rogue: Dagger
(40856, 73212, 100, 0, 1, 1, 57812),  -- Rogue: Dagger (offhand)
(40856, 76391, 100, 0, 1, 1, 57813),  -- Shaman: Axe
(40856, 73213, 100, 0, 1, 1, 57813),  -- Shaman: Shield
(40856, 73210, 100, 0, 1, 1, 57814);  -- Warrior: Sword

-- Loot 40859 (GO 210015)
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
(40859, 73209, 100, 0, 1, 1, 57808),
(40859, 76390, 100, 0, 1, 1, 57809),
(40859, 76392, 100, 0, 1, 1, 57809),
(40859, 73211, 100, 0, 1, 1, 57810),
(40859, 73207, 100, 0, 1, 1, 57811),
(40859, 76393, 100, 0, 1, 1, 57811),
(40859, 73208, 100, 0, 1, 1, 57812),
(40859, 73212, 100, 0, 1, 1, 57812),
(40859, 76391, 100, 0, 1, 1, 57813),
(40859, 73213, 100, 0, 1, 1, 57813),
(40859, 73210, 100, 0, 1, 1, 57814);

-- Loot 40860 (GO 210016)
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
(40860, 73209, 100, 0, 1, 1, 57808),
(40860, 76390, 100, 0, 1, 1, 57809),
(40860, 76392, 100, 0, 1, 1, 57809),
(40860, 73211, 100, 0, 1, 1, 57810),
(40860, 73207, 100, 0, 1, 1, 57811),
(40860, 76393, 100, 0, 1, 1, 57811),
(40860, 73208, 100, 0, 1, 1, 57812),
(40860, 73212, 100, 0, 1, 1, 57812),
(40860, 76391, 100, 0, 1, 1, 57813),
(40860, 73213, 100, 0, 1, 1, 57813),
(40860, 73210, 100, 0, 1, 1, 57814);

-- Loot 40861 (GO 210017)
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
(40861, 73209, 100, 0, 1, 1, 57808),
(40861, 76390, 100, 0, 1, 1, 57809),
(40861, 76392, 100, 0, 1, 1, 57809),
(40861, 73211, 100, 0, 1, 1, 57810),
(40861, 73207, 100, 0, 1, 1, 57811),
(40861, 76393, 100, 0, 1, 1, 57811),
(40861, 73208, 100, 0, 1, 1, 57812),
(40861, 73212, 100, 0, 1, 1, 57812),
(40861, 76391, 100, 0, 1, 1, 57813),
(40861, 73213, 100, 0, 1, 1, 57813),
(40861, 73210, 100, 0, 1, 1, 57814);

-- Loot 40862 (GO 210018)
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
(40862, 73209, 100, 0, 1, 1, 57808),
(40862, 76390, 100, 0, 1, 1, 57809),
(40862, 76392, 100, 0, 1, 1, 57809),
(40862, 73211, 100, 0, 1, 1, 57810),
(40862, 73207, 100, 0, 1, 1, 57811),
(40862, 76393, 100, 0, 1, 1, 57811),
(40862, 73208, 100, 0, 1, 1, 57812),
(40862, 73212, 100, 0, 1, 1, 57812),
(40862, 76391, 100, 0, 1, 1, 57813),
(40862, 73213, 100, 0, 1, 1, 57813),
(40862, 73210, 100, 0, 1, 1, 57814);

-- Loot 40863 (GO 210019)
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
(40863, 73209, 100, 0, 1, 1, 57808),
(40863, 76390, 100, 0, 1, 1, 57809),
(40863, 76392, 100, 0, 1, 1, 57809),
(40863, 73211, 100, 0, 1, 1, 57810),
(40863, 73207, 100, 0, 1, 1, 57811),
(40863, 76393, 100, 0, 1, 1, 57811),
(40863, 73208, 100, 0, 1, 1, 57812),
(40863, 73212, 100, 0, 1, 1, 57812),
(40863, 76391, 100, 0, 1, 1, 57813),
(40863, 73213, 100, 0, 1, 1, 57813),
(40863, 73210, 100, 0, 1, 1, 57814);

-- Loot 40864 (GO 210020)
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
(40864, 73209, 100, 0, 1, 1, 57808),
(40864, 76390, 100, 0, 1, 1, 57809),
(40864, 76392, 100, 0, 1, 1, 57809),
(40864, 73211, 100, 0, 1, 1, 57810),
(40864, 73207, 100, 0, 1, 1, 57811),
(40864, 76393, 100, 0, 1, 1, 57811),
(40864, 73208, 100, 0, 1, 1, 57812),
(40864, 73212, 100, 0, 1, 1, 57812),
(40864, 76391, 100, 0, 1, 1, 57813),
(40864, 73213, 100, 0, 1, 1, 57813),
(40864, 73210, 100, 0, 1, 1, 57814);


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


