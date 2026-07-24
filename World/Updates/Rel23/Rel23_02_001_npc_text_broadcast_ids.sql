-- --------------------------------------------------------------------------------
-- Preserve the client BroadcastText identifiers required by the 5.4.8
-- SMSG_NPC_TEXT_UPDATE wire format.
-- --------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `update_mangos`;

DELIMITER $$

CREATE PROCEDURE `update_mangos`()
BEGIN
    DECLARE bRollback BOOL DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `bRollback` = TRUE;

    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `structure` DESC, `content` DESC LIMIT 1);
    SET @cCurStructure := (SELECT `structure` FROM `db_version` ORDER BY `version` DESC, `structure` DESC, `content` DESC LIMIT 1);
    SET @cCurContent := (SELECT `content` FROM `db_version` ORDER BY `version` DESC, `structure` DESC, `content` DESC LIMIT 1);

    SET @cOldVersion = '23';
    SET @cOldStructure = '01';
    SET @cOldContent = '001';

    SET @cNewVersion = '23';
    SET @cNewStructure = '02';
    SET @cNewContent = '001';
    SET @cNewDescription = 'npc_text_broadcast_ids';
    SET @cNewComment = 'Retain BroadcastText.db2 IDs required by the 5.4.8 NPC text cache';

    SET @cCurResult := (SELECT `description` FROM `db_version` ORDER BY `version` DESC, `structure` DESC, `content` DESC LIMIT 1);
    SET @cOldResult := (SELECT `description` FROM `db_version` WHERE `version` = @cOldVersion AND `structure` = @cOldStructure AND `content` = @cOldContent);
    SET @cNewResult := (SELECT `description` FROM `db_version` WHERE `version` = @cNewVersion AND `structure` = @cNewStructure AND `content` = @cNewContent);

    IF (@cCurResult = @cOldResult) THEN
        START TRANSACTION;

        ALTER TABLE `npc_text`
            ADD COLUMN `BroadcastTextID0` mediumint(8) unsigned NOT NULL DEFAULT 0 AFTER `text0_1`,
            ADD COLUMN `BroadcastTextID1` mediumint(8) unsigned NOT NULL DEFAULT 0 AFTER `text1_1`,
            ADD COLUMN `BroadcastTextID2` mediumint(8) unsigned NOT NULL DEFAULT 0 AFTER `text2_1`,
            ADD COLUMN `BroadcastTextID3` mediumint(8) unsigned NOT NULL DEFAULT 0 AFTER `text3_1`,
            ADD COLUMN `BroadcastTextID4` mediumint(8) unsigned NOT NULL DEFAULT 0 AFTER `text4_1`,
            ADD COLUMN `BroadcastTextID5` mediumint(8) unsigned NOT NULL DEFAULT 0 AFTER `text5_1`,
            ADD COLUMN `BroadcastTextID6` mediumint(8) unsigned NOT NULL DEFAULT 0 AFTER `text6_1`,
            ADD COLUMN `BroadcastTextID7` mediumint(8) unsigned NOT NULL DEFAULT 0 AFTER `text7_1`;

        -- Direct build-18414 BroadcastText.db2 exact and unique match.
        -- All other rows deliberately remain zero until similarly proven.
        UPDATE `npc_text`
        SET `BroadcastTextID0` = 62792
        WHERE `ID` = 17235
          AND `text0_0` = 'Who are you?'
          AND `text0_1` = 'Who are you?';

        IF bRollback = TRUE THEN
            ROLLBACK;
            SHOW ERRORS;
            SELECT '* UPDATE FAILED *' AS `===== Status =====`, @cCurResult AS `===== DB is on Version: =====`;
        ELSE
            INSERT INTO `db_version`
            VALUES (@cNewVersion, @cNewStructure, @cNewContent, @cNewDescription, @cNewComment);
            COMMIT;
            SET @cNewResult := (SELECT `description` FROM `db_version` WHERE `version` = @cNewVersion AND `structure` = @cNewStructure AND `content` = @cNewContent);
            SELECT '* UPDATE COMPLETE *' AS `===== Status =====`, @cNewResult AS `===== DB is now on Version =====`;
        END IF;
    ELSE
        IF (@cCurResult = @cNewResult) THEN
            SELECT '* UPDATE SKIPPED *' AS `===== Status =====`, @cCurResult AS `===== DB is already on Version =====`;
        ELSE
            SELECT '* UPDATE FAILED *' AS `===== Status =====`,
                CONCAT(@cOldVersion, '_', @cOldStructure, '_', @cOldContent) AS `===== Expected Version =====`,
                CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent) AS `===== Found Version =====`;
        END IF;
    END IF;
END $$

DELIMITER ;

CALL update_mangos();
DROP PROCEDURE IF EXISTS `update_mangos`;
