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
    SET @cOldContent = '003';

    -- New Values
    SET @cNewVersion = '23';
    SET @cNewStructure = '03';
    SET @cNewContent = '004';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'Fix The Disciples Challenge';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Fix The Disciples Challenge';

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
-- Fix: Jaomin Ro (54611) should be attackable during
--      "The Disciple's Challenge" (quest 29409)
-- ============================================================================
-- Jaomin Ro currently has faction 2104 (friendly to all players) and no
-- gossip or AI scripts, so there is no way to engage him in combat.
--
-- This patch adds:
--   1. A gossip menu with a "challenge" option, visible only when
--      quest 29409 is active (CONDITION_QUESTTAKEN).
--   2. A DB script triggered by the gossip option that sets Jaomin Ro
--      to a hostile faction and starts combat with the player.
--   3. An EventAI script to restore his default faction when he
--      returns home (evade) or dies, so he is friendly again for the
--      next player.
--   4. NpcFlags updated to show the gossip icon.
-- ============================================================================

-- --------------------------------------------------------
-- Step 1: Condition — quest 29409 must be active
-- --------------------------------------------------------
-- (reuse condition 57808-57814 range; 57815 is next free)
DELETE FROM `conditions` WHERE `condition_entry`=57815 AND `type`=9;
INSERT INTO `conditions` (`condition_entry`, `type`, `value1`, `value2`, `comments`) VALUES
(57815, 9, 29409, 0, 'Disciple\'s Challenge quest taken');

-- --------------------------------------------------------
-- Step 2: NPC text for Jaomin Ro's gossip window
-- --------------------------------------------------------
DELETE FROM `npc_text` WHERE `ID`=100000;
INSERT INTO `npc_text` (`ID`, `text0_0`, `text0_1`) VALUES
(100000, 'You wish to challenge me? Very well, show me what you have learned!', 'You wish to challenge me? Very well, show me what you have learned!');

-- --------------------------------------------------------
-- Step 3: Gossip menu and option
-- --------------------------------------------------------
DELETE FROM `gossip_menu` WHERE `entry`=57802 AND `text_id`=100000 AND `condition_id`=0;
INSERT INTO `gossip_menu` (`entry`, `text_id`, `condition_id`) VALUES
(57802, 100000, 0);

DELETE FROM `gossip_menu_option` WHERE `menu_id`=57802 AND `id`=0;
INSERT INTO `gossip_menu_option` (`menu_id`, `id`, `option_icon`, `option_text`, `option_id`, `npc_option_npcflag`, `action_menu_id`, `action_poi_id`, `action_script_id`, `box_coded`, `box_money`, `box_text`, `condition_id`) VALUES
(57802, 0, 0, 'I am ready to challenge you, Jaomin!', 1, 1, -1, 0, 54611, 0, 0, '', 57815);

-- --------------------------------------------------------
-- Step 4: DB script (on gossip) — set hostile faction and
--         attack the player
-- --------------------------------------------------------
-- script_type 2 = DBS_ON_GOSSIP, id = 54611 (matches action_script_id)
-- Command 22 = SCRIPT_COMMAND_SET_FACTION, datalong = 14 (hostile to all)
-- Command 26 = SCRIPT_COMMAND_ATTACK_START

DELETE FROM `db_scripts` WHERE `script_guid` IN (55932,55933);
INSERT INTO `db_scripts` (`script_guid`, `script_type`, `id`, `delay`, `command`, `datalong`, `datalong2`, `buddy_entry`, `search_radius`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES
(55932, 2, 54611, 0, 22, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Jaomin Ro - Set faction hostile'),
(55933, 2, 54611, 0, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Jaomin Ro - Attack player');

-- --------------------------------------------------------
-- Step 5: EventAI — restore faction on evade (reach home)
--         and on death
-- --------------------------------------------------------
-- Event 11 (EVENT_T_REACH_HOME): action 22 = set faction back to 0 (default)
-- Event 6 (EVENT_T_DEATH): action 22 = set faction back to 0 (default)
-- EventAI IDs: creatureId*100 + seq
DELETE FROM `creature_ai_scripts` WHERE `id` IN (5461101,5461102) AND `creature_id`=54611;
INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES
(5461101, 54611, 11, 0, 100, 0, 0, 0, 0, 0, 22, 2104, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Jaomin Ro - Restore faction on evade'),
(5461102, 54611, 6, 0, 100, 0, 0, 0, 0, 0, 22, 2104, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Jaomin Ro - Restore faction on death');

-- --------------------------------------------------------
-- Step 6: Update creature_template — add gossip flag and
--         set AIName to EventAI
-- --------------------------------------------------------
-- NpcFlags: add UNIT_NPC_FLAG_GOSSIP (1)
-- GossipMenuId: 57802
-- AIName: 'EventAI'
UPDATE `creature_template`
   SET `NpcFlags` = `NpcFlags` | 1,
       `GossipMenuId` = 57802,
       `AIName` = 'EventAI'
 WHERE `Entry` = 54611;

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


