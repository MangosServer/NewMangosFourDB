-- -------------------------------------------------------------------------
-- Remove obsolete per-check Warden punishment overrides.
-- IMPORTANT: export any custom `warden_action` rows before applying this
-- intentionally destructive update. No automatic conversion is safe.
-- Structural update: 23.02.001 -> 23.03.001.
-- -------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `update_mangos`;

DELIMITER $$

CREATE PROCEDURE `update_mangos`()
main: BEGIN
    DECLARE v_version INT DEFAULT NULL;
    DECLARE v_structure INT DEFAULT NULL;
    DECLARE v_content INT DEFAULT NULL;
    DECLARE v_is_current BOOL DEFAULT FALSE;
    DECLARE v_is_superseded BOOL DEFAULT FALSE;
    DECLARE v_table_count INT DEFAULT 0;
    DECLARE v_sql_message TEXT DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sql_message = MESSAGE_TEXT;
        ROLLBACK;
        SELECT '* UPDATE FAILED *' AS `Status`, v_sql_message AS `SQL error`;
        RESIGNAL;
    END;

    SELECT `version`, `structure`, `content`
      INTO v_version, v_structure, v_content
      FROM `db_version`
     ORDER BY `version` DESC, `structure` DESC, `content` DESC
     LIMIT 1;

    SET v_is_current = COALESCE(
        v_version = 23 AND v_structure = 3 AND v_content = 1, FALSE);
    SET v_is_superseded = COALESCE(
        v_version > 23 OR
        (v_version = 23 AND
         (v_structure > 3 OR
          (v_structure = 3 AND v_content > 1))), FALSE);

    IF NOT v_is_current AND NOT v_is_superseded AND
       (v_version IS NULL OR v_version <> 23 OR
        v_structure <> 2 OR v_content <> 1) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'database version must be exactly 23.02.001';
    END IF;

    IF NOT v_is_current AND NOT v_is_superseded THEN
        DROP TABLE IF EXISTS `warden_action`;
    END IF;

    SELECT COUNT(*) INTO v_table_count
      FROM `information_schema`.`tables`
     WHERE `table_schema` = DATABASE()
       AND `table_name` = 'warden_action';
    IF v_table_count <> 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'legacy warden_action removal postcondition failed';
    END IF;

    IF v_is_current OR v_is_superseded THEN
        SELECT '* UPDATE SKIPPED *' AS `Status`,
               '23.03.001 postcondition is already satisfied' AS `Detail`;
        LEAVE main;
    END IF;

    START TRANSACTION;
    INSERT INTO `db_version`
        (`version`, `structure`, `content`, `description`, `comment`) VALUES
        (23, 3, 1, 'Remove_Warden_Action',
         'Remove obsolete per-check Warden punishments');
    COMMIT;

    SELECT '* UPDATE COMPLETE *' AS `Status`,
           '23.03.001' AS `Database version`;
END main$$

DELIMITER ;

CALL `update_mangos`();
DROP PROCEDURE IF EXISTS `update_mangos`;
