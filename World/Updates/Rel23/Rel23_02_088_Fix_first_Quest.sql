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
    SET @cOldStructure = '02'; 
    SET @cOldContent = '087';

    -- New Values
    SET @cNewVersion = '23';
    SET @cNewStructure = '02';
    SET @cNewContent = '088';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'Fix Lesson of the Shady Fist';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Fix Lesson of the Shady Fist';

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
-- Fix: "The Lesson of the Sandy Fist" (Quest 29406)
-- Problem: Training Targets (creature 53714) use NullAI, so they never grant
--          quest credit for "Training Targets Destroyed" when their HP drops.
-- Solution:
--   1. Change creature 53714 AIName from 'NullAI' to 'EventAI'
--   2. Add EventAI scripts:
--      a. On entering combat: disable combat movement (stay rooted in place)
--      b. On HP dropping to 1-5%: give kill credit, then evade (reset + leave combat)
-- ============================================================================

-- Step 1: Change AIName to EventAI so the creature processes AI events
UPDATE `creature_template`
   SET `AIName` = 'EventAI'
 WHERE `Entry` = 53714;

-- Step 2: Remove any previous versions of these scripts
DELETE FROM `creature_ai_scripts` WHERE `id` IN (5371401, 5371402);

-- Step 3: On aggro (event_type 4), disable combat movement so it stays in place
-- action1_type 21 = ACTION_T_COMBAT_MOVEMENT, param1=0 = disable
INSERT INTO `creature_ai_scripts`
  (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`,
   `event_param1`, `event_param2`, `event_param3`, `event_param4`,
   `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`,
   `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`,
   `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`,
   `comment`)
VALUES
  (5371401, 53714, 4, 0, 100, 0,
   0, 0, 0, 0,
   21, 0, 0, 0,
   0, 0, 0, 0,
   0, 0, 0, 0,
   'Training Target - Disable combat movement on aggro (stay rooted)');

-- Step 4: On HP 1-5% (event_type 2), give kill credit then evade to reset
-- action1_type 33 = ACTION_T_KILLED_MONSTER, param1=53714, param2=6 (attacker)
-- action2_type 24 = ACTION_T_EVADE (drop combat, reset to full HP)
INSERT INTO `creature_ai_scripts`
  (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`,
   `event_param1`, `event_param2`, `event_param3`, `event_param4`,
   `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`,
   `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`,
   `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`,
   `comment`)
VALUES
  (5371402, 53714, 2, 0, 100, 1,
   5, 1, 3000, 3000,
   33, 53714, 6, 0,
   24, 0, 0, 0,
   0, 0, 0, 0,
   'Training Target - Give Quest Kill Credit at low HP then Evade (Quest: The Lesson of the Sandy Fist 29406)');

DELETE FROM spell_template WHERE id IN (96365, 96366, 91000, 91001);
DELETE FROM spell_area WHERE spell IN (96365, 96366, 91000, 91001);

INSERT INTO `spell_template`
  (`id`, `attr`, `attr_ex`, `attr_ex2`, `attr_ex3`, `proc_flags`, `proc_chance`,
   `duration_index`, `effect0`, `effect0_implicit_target_a`, `effect0_implicit_target_b`,
   `effect0_radius_idx`, `effect0_apply_aura_name`, `effect0_misc_value`,
   `effect0_misc_value_b`, `effect0_trigger_spell`, `comments`)
VALUES
  (91000, 536870912, 0, 0, 0, 0, 101,
   21, 6, 1, 0,
   0, 261, 2,
   0, 0, 'Shang Xi Training Grounds - Post-Sandy-Fist Phase (quest 29406)');

INSERT INTO `spell_template`
  (`id`, `attr`, `attr_ex`, `attr_ex2`, `attr_ex3`, `proc_flags`, `proc_chance`,
   `duration_index`, `effect0`, `effect0_implicit_target_a`, `effect0_implicit_target_b`,
   `effect0_radius_idx`, `effect0_apply_aura_name`, `effect0_misc_value`,
   `effect0_misc_value_b`, `effect0_trigger_spell`, `comments`)
VALUES
  (91001, 536870912, 0, 0, 0, 0, 101,
   21, 6, 1, 0,
   0, 261, 4,
   0, 0, 'Shang Xi Training Grounds - Post-Stifled-Pride Phase (quest 29524)');

INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_start_active`, `quest_end`, `condition_id`, `aura_spell`, `racemask`, `gender`, `autocast`)
VALUES (91000, 5736, 29406, 0, 29524, 0, 0, 0, 2, 1);

INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_start_active`, `quest_end`, `condition_id`, `aura_spell`, `racemask`, `gender`, `autocast`)
VALUES (91001, 5736, 29524, 0, 0, 0, 0, 0, 2, 1);

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


