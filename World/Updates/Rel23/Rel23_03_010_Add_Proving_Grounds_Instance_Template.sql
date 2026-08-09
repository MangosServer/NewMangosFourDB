-- Add the missing instance metadata required to validate the Proving Grounds
-- Dungeon Finder entrance introduced by 23.03.009. Map 1148 is a scenario,
-- therefore MapManager treats it as an instanceable dungeon and requires an
-- instance_template row before the entrance can be loaded.

DROP PROCEDURE IF EXISTS `update_mangos`;

DELIMITER $$

CREATE PROCEDURE `update_mangos`()
main: BEGIN
    DECLARE v_version INT DEFAULT NULL;
    DECLARE v_structure INT DEFAULT NULL;
    DECLARE v_content INT DEFAULT NULL;
    DECLARE v_count INT DEFAULT 0;
    DECLARE v_instance_exact INT DEFAULT 0;
    DECLARE v_entrance_exact INT DEFAULT 0;
    DECLARE v_is_current BOOL DEFAULT FALSE;
    DECLARE v_sql_message TEXT DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sql_message = MESSAGE_TEXT;
        ROLLBACK;
        SELECT '* UPDATE FAILED *' AS `Status`, v_sql_message AS `SQL error`;
    END;

    SELECT `version`, `structure`, `content`
      INTO v_version, v_structure, v_content
      FROM `db_version`
     ORDER BY `version` DESC, `structure` DESC, `content` DESC
     LIMIT 1;

    SET v_is_current = COALESCE(
        v_version = 23 AND v_structure = 3 AND v_content = 10, FALSE);

    IF NOT v_is_current AND
       (v_version IS NULL OR v_version <> 23 OR v_structure <> 3 OR v_content <> 9) THEN
        SELECT '* UPDATE FAILED *' AS `Status`,
               'database version must be exactly 23.03.009' AS `Failed gate`;
        LEAVE main;
    END IF;

    SELECT COUNT(*) INTO v_count
      FROM `information_schema`.`tables`
     WHERE `table_schema` = DATABASE()
       AND ((`table_name` = 'db_version' AND `engine` = 'InnoDB')
         OR (`table_name` = 'dungeonfinder_entrance' AND `engine` = 'InnoDB')
         OR (`table_name` = 'instance_template' AND `engine` = 'MyISAM'));
    IF v_count <> 3 THEN
        SELECT '* UPDATE FAILED *' AS `Status`,
               'db_version and dungeonfinder_entrance must be InnoDB and instance_template must be MyISAM' AS `Failed gate`;
        LEAVE main;
    END IF;

    IF NOT v_is_current THEN
        SELECT COUNT(*) INTO v_count
          FROM `db_version`
         WHERE `version` = 23 AND `structure` = 3 AND `content` = 10;
        IF v_count <> 0 THEN
            SELECT '* UPDATE FAILED *' AS `Status`,
                   'db_version row 23.03.010 already exists below current' AS `Failed gate`;
            LEAVE main;
        END IF;

        -- instance_template is MyISAM. This exact upsert is retry-safe if a
        -- later InnoDB db_version write fails after the row has been changed.
        INSERT INTO `instance_template` (`map`, `parent`, `levelMin`, `levelMax`)
        VALUES (1148, 0, 0, 0)
        ON DUPLICATE KEY UPDATE
            `parent` = VALUES(`parent`),
            `levelMin` = VALUES(`levelMin`),
            `levelMax` = VALUES(`levelMax`);
    END IF;

    SELECT COUNT(*) INTO v_instance_exact
      FROM `instance_template`
     WHERE `map` = 1148
       AND `parent` = 0
       AND `levelMin` = 0
       AND `levelMax` = 0;

    SELECT COUNT(*) INTO v_entrance_exact
      FROM `dungeonfinder_entrance`
     WHERE `dungeon_id` = 640
       AND `target_map` = 1148
       AND ABS(`target_position_x` - 3756.820068359375) <= 0.001
       AND ABS(`target_position_y` - 521.7769775390625) <= 0.001
       AND ABS(`target_position_z` - 639.6920166015625) <= 0.001
       AND ABS(`target_orientation` - 2.509591579437256) <= 0.00001;

    IF v_instance_exact <> 1 OR v_entrance_exact <> 1 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Proving Grounds LFG entrance postcondition failed';
    END IF;

    IF v_is_current THEN
        SELECT '* UPDATE SKIPPED *' AS `Status`,
               '23.03.010 is already current and validated' AS `Detail`,
               v_instance_exact AS `Instance template rows`,
               v_entrance_exact AS `LFG entrance rows`;
        LEAVE main;
    END IF;

    START TRANSACTION;

    INSERT INTO `db_version`
        (`version`, `structure`, `content`, `description`, `comment`) VALUES
        (23, 3, 10, 'Add Proving Grounds Template',
         'Add map 1148 metadata required by the dungeon 640 LFG entrance');

    COMMIT;

    SELECT '* UPDATE COMPLETE *' AS `Status`,
           '23.03.010' AS `Database version`,
           v_instance_exact AS `Instance template rows`,
           v_entrance_exact AS `LFG entrance rows`;
END main$$

DELIMITER ;

CALL `update_mangos`();
DROP PROCEDURE IF EXISTS `update_mangos`;
