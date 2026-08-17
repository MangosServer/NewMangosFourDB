-- -------------------------------------------------------------------------
-- Replace the legacy opaque Warden table with an empty typed catalogue.
-- IMPORTANT: export any custom `warden` rows before applying this
-- intentionally destructive update. No automatic conversion is safe, and
-- this Four transition deliberately carries no checks or client addresses.
-- Structural update: 23.03.010 -> 23.04.001.
-- -------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `update_mangos`;

DELIMITER $$

CREATE PROCEDURE `update_mangos`()
main: BEGIN
    DECLARE v_version INT DEFAULT NULL;
    DECLARE v_structure INT DEFAULT NULL;
    DECLARE v_content INT DEFAULT NULL;
    DECLARE v_is_current BOOL DEFAULT FALSE;
    DECLARE v_table_count INT DEFAULT 0;
    DECLARE v_column_count INT DEFAULT 0;
    DECLARE v_row_count BIGINT DEFAULT 0;
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
        v_version = 23 AND v_structure = 4 AND v_content = 1, FALSE);

    IF NOT v_is_current AND
       (v_version IS NULL OR v_version <> 23 OR
        v_structure <> 3 OR v_content <> 10) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'database version must be exactly 23.03.010';
    END IF;

    IF NOT v_is_current THEN
        -- At 23.03.010 this name is unowned. Removing it makes a retry after
        -- non-transactional DDL failure deterministic.
        DROP TABLE IF EXISTS `warden_checks`;
        CREATE TABLE `warden_checks` (
          `build` SMALLINT UNSIGNED NOT NULL,
          `platform` VARBINARY(4) NOT NULL,
          `locale` BINARY(4) NOT NULL,
          `check_id` INT UNSIGNED NOT NULL,
          `type` TINYINT UNSIGNED NOT NULL,
          `enabled` TINYINT UNSIGNED NOT NULL,
          `sort_order` SMALLINT UNSIGNED NOT NULL,
          `evidence_class` TINYINT UNSIGNED NOT NULL,
          `module` VARBINARY(255) NOT NULL DEFAULT '',
          `address` INT UNSIGNED NOT NULL DEFAULT 0,
          `length` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
          `request` VARBINARY(255) NOT NULL DEFAULT '',
          `expected` VARBINARY(255) NOT NULL DEFAULT '',
          `comment` VARCHAR(255) NOT NULL DEFAULT '',
          PRIMARY KEY (`build`,`platform`,`locale`,`check_id`),
          UNIQUE KEY `uq_warden_checks_profile_order`
            (`build`,`platform`,`locale`,`sort_order`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC
          COMMENT='Exact typed Warden check catalogue';
    END IF;

    SELECT COUNT(*) INTO v_table_count
      FROM `information_schema`.`tables`
     WHERE `table_schema` = DATABASE()
       AND `table_name` = 'warden_checks'
       AND UPPER(`engine`) = 'INNODB'
       AND UPPER(`row_format`) = 'DYNAMIC';
    SELECT COUNT(*) INTO v_column_count
      FROM `information_schema`.`columns`
     WHERE `table_schema` = DATABASE()
       AND `table_name` = 'warden_checks';

    IF v_table_count <> 1 OR v_column_count <> 14 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'typed warden_checks structure postcondition failed';
    END IF;

    SELECT COUNT(*) INTO v_row_count FROM `warden_checks`;
    IF v_row_count <> 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'warden_checks must remain empty during Four preparation';
    END IF;

    IF NOT v_is_current THEN
        -- Remove recoverable legacy data only after the empty typed replacement
        -- has passed its postconditions.
        DROP TABLE IF EXISTS `warden`;
    END IF;

    SELECT COUNT(*) INTO v_table_count
      FROM `information_schema`.`tables`
     WHERE `table_schema` = DATABASE()
       AND `table_name` = 'warden';
    IF v_table_count <> 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'legacy warden table removal postcondition failed';
    END IF;

    IF v_is_current THEN
        SELECT '* UPDATE SKIPPED *' AS `Status`,
               '23.04.001 is already current and validated' AS `Detail`;
        LEAVE main;
    END IF;

    START TRANSACTION;
    INSERT INTO `db_version`
        (`version`, `structure`, `content`, `description`, `comment`) VALUES
        (23, 4, 1, 'Warden_Checks',
         'Replace legacy Warden rows with an empty typed catalogue');
    COMMIT;

    SELECT '* UPDATE COMPLETE *' AS `Status`,
           '23.04.001' AS `Database version`,
           v_row_count AS `Warden check rows`;
END main$$

DELIMITER ;

CALL `update_mangos`();
DROP PROCEDURE IF EXISTS `update_mangos`;
