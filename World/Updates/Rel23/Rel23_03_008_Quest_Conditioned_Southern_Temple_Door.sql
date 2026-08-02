-- Replace the globally open southern Wandering Isle temple gate with two
-- player-specific representations after rewarding quest 29408 (The Burning
-- Scroll). The northern quest-29406 gate remains independently conditioned.
--
-- phase_definitions is MyISAM in Rel23 while the other owned tables are
-- InnoDB. Exact preconditions and compensating cleanup protect this split.

DROP PROCEDURE IF EXISTS `update_mangos`;

DELIMITER $$

CREATE PROCEDURE `update_mangos`()
main: BEGIN
    DECLARE v_version INT DEFAULT NULL;
    DECLARE v_structure INT DEFAULT NULL;
    DECLARE v_content INT DEFAULT NULL;
    DECLARE v_gate_failure VARCHAR(255) DEFAULT NULL;
    DECLARE v_sql_message TEXT DEFAULT NULL;
    DECLARE v_count INT DEFAULT 0;
    DECLARE v_exact INT DEFAULT 0;
    DECLARE v_phase_published INT DEFAULT 0;
    DECLARE v_max_condition BIGINT DEFAULT 0;
    DECLARE v_max_guid BIGINT DEFAULT 0;

    SELECT `version`, `structure`, `content`
      INTO v_version, v_structure, v_content
      FROM `db_version`
     ORDER BY `version` DESC, `structure` DESC, `content` DESC
     LIMIT 1;

    IF v_version = 23 AND v_structure = 3 AND v_content = 8 THEN
        SELECT '* UPDATE SKIPPED *' AS `Status`, '23.03.008 is already current' AS `Detail`;
        LEAVE main;
    END IF;

    IF v_version IS NULL OR v_version <> 23 OR v_structure <> 3 OR v_content <> 7 THEN
        SELECT '* UPDATE FAILED *' AS `Status`,
               'database version must be exactly 23.03.007' AS `Failed gate`;
        LEAVE main;
    END IF;

    SELECT COALESCE(MAX(`condition_entry`), 0) INTO v_max_condition FROM `conditions`;
    SELECT COALESCE(MAX(`guid`), 0) INTO v_max_guid FROM `gameobject`;
    IF v_max_condition <> 57817 OR v_max_guid <> 609470 THEN
        SET v_gate_failure = CONCAT('unexpected condition or gameobject high-water: ', v_max_condition, '/', v_max_guid);
    END IF;

    SELECT COUNT(*) INTO v_count
      FROM `conditions`
     WHERE `condition_entry` IN (57816, 57817, 57818, 57819)
        OR (`type` = 8 AND `value1` IN (29406, 29408) AND `value2` = 0)
        OR (`type` = -3 AND `value1` IN (57816, 57818) AND `value2` = 0);
    SELECT COUNT(*) INTO v_exact
      FROM `conditions`
     WHERE (`condition_entry` = 57816 AND `type` = 8 AND `value1` = 29406 AND `value2` = 0)
        OR (`condition_entry` = 57817 AND `type` = -3 AND `value1` = 57816 AND `value2` = 0);
    IF v_gate_failure IS NULL AND (v_count <> 2 OR v_exact <> 2) THEN
        SET v_gate_failure = 'northern conditions must be exact and southern condition IDs and tuples must be free';
    END IF;

    SELECT COUNT(*) INTO v_count FROM `phase_definitions` WHERE `zoneId` = 5736;
    SELECT COUNT(*) INTO v_exact
      FROM `phase_definitions`
     WHERE `zoneId` = 5736
       AND ((`entry` = 1 AND `phasemask` = 1 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 0)
         OR (`entry` = 2 AND `phasemask` = 16384 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57817)
         OR (`entry` = 3 AND `phasemask` = 32768 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57816));
    IF v_gate_failure IS NULL AND (v_count <> 3 OR v_exact <> 3) THEN
        SET v_gate_failure = 'zone 5736 must contain only exact northern definitions 1 through 3';
    END IF;

    SELECT COUNT(*) INTO v_count FROM `creature` WHERE `map` = 860 AND `phaseMask` <> 1;
    IF v_gate_failure IS NULL AND v_count <> 0 THEN
        SET v_gate_failure = 'map 860 creature phase masks must all be 1';
    END IF;

    SELECT COUNT(*) INTO v_count FROM `gameobject` WHERE `map` = 860 AND `phaseMask` <> 1;
    IF v_gate_failure IS NULL AND v_count <> 2 THEN
        SET v_gate_failure = 'only the exact northern pair may have non-base map 860 phase masks';
    END IF;

    SELECT COUNT(*) INTO v_exact
      FROM `gameobject`
     WHERE (`guid` = 600079 AND `id` = 209970 AND `map` = 860 AND `spawnMask` = 1 AND `phaseMask` = 16384
            AND ABS(CAST(`position_x` AS DOUBLE) - 1446.98) <= 0.0005
            AND ABS(CAST(`position_y` AS DOUBLE) - 3389.89) <= 0.0005
            AND ABS(CAST(`position_z` AS DOUBLE) - 173.35) <= 0.0005
            AND ABS(CAST(`orientation` AS DOUBLE) - 1.23918) <= 0.000001
            AND `rotation0` = 0 AND `rotation1` = 0
            AND ABS(CAST(`rotation2` AS DOUBLE) - 0.580701) <= 0.000001
            AND ABS(CAST(`rotation3` AS DOUBLE) - 0.814117) <= 0.000001
            AND `spawntimesecs` = 120 AND `animprogress` = 255 AND `state` = 1)
        OR (`guid` = 609470 AND `id` = 209972 AND `map` = 860 AND `spawnMask` = 1 AND `phaseMask` = 32768
            AND ABS(CAST(`position_x` AS DOUBLE) - 1446.98) <= 0.0005
            AND ABS(CAST(`position_y` AS DOUBLE) - 3389.89) <= 0.0005
            AND ABS(CAST(`position_z` AS DOUBLE) - 173.35) <= 0.0005
            AND ABS(CAST(`orientation` AS DOUBLE) - 1.23918) <= 0.000001
            AND `rotation0` = 0 AND `rotation1` = 0
            AND ABS(CAST(`rotation2` AS DOUBLE) - 0.580701) <= 0.000001
            AND ABS(CAST(`rotation3` AS DOUBLE) - 0.814117) <= 0.000001
            AND `spawntimesecs` = 120 AND `animprogress` = 255 AND `state` = 0);
    IF v_gate_failure IS NULL AND v_exact <> 2 THEN
        SET v_gate_failure = 'northern gate pair is not exact';
    END IF;

    SELECT COUNT(*) INTO v_count
      FROM `gameobject`
     WHERE `map` = 860
       AND (POW(`position_x` - 1446.98, 2) + POW(`position_y` - 3389.89, 2) + POW(`position_z` - 173.35, 2)) <= POW(0.25, 2);
    IF v_gate_failure IS NULL AND v_count <> 2 THEN
        SET v_gate_failure = 'the northern transform must have exactly two gameobjects';
    END IF;

    SELECT COUNT(*) INTO v_exact
      FROM `gameobject`
     WHERE (`guid` = 600074 AND `id` = 209971 AND `map` = 860 AND `spawnMask` = 1 AND `phaseMask` = 1
            AND ABS(CAST(`position_x` AS DOUBLE) - 1435.17) <= 0.0005
            AND ABS(CAST(`position_y` AS DOUBLE) - 3353.44) <= 0.0005
            AND ABS(CAST(`position_z` AS DOUBLE) - 173.35) <= 0.0005
            AND ABS(CAST(`orientation` AS DOUBLE) - 4.39823) <= 0.000001
            AND `rotation0` = 0 AND `rotation1` = 0
            AND ABS(CAST(`rotation2` AS DOUBLE) - 0.809017) <= 0.000001
            AND ABS(CAST(`rotation3` AS DOUBLE) - (-0.587785)) <= 0.000001
            AND `spawntimesecs` = 120 AND `animprogress` = 255 AND `state` = 0)
        OR (`guid` = 600080 AND `id` = 209973 AND `map` = 860 AND `spawnMask` = 1 AND `phaseMask` = 1
            AND ABS(CAST(`position_x` AS DOUBLE) - 1435.17) <= 0.0005
            AND ABS(CAST(`position_y` AS DOUBLE) - 3353.44) <= 0.0005
            AND ABS(CAST(`position_z` AS DOUBLE) - 173.35) <= 0.0005
            AND ABS(CAST(`orientation` AS DOUBLE) - 4.39823) <= 0.000001
            AND `rotation0` = 0 AND `rotation1` = 0
            AND ABS(CAST(`rotation2` AS DOUBLE) - 0.809017) <= 0.000001
            AND ABS(CAST(`rotation3` AS DOUBLE) - (-0.587785)) <= 0.000001
            AND `spawntimesecs` = 120 AND `animprogress` = 255 AND `state` = 0);
    IF v_gate_failure IS NULL AND v_exact <> 2 THEN
        SET v_gate_failure = 'southern gate pair is not the exact phase-1 workaround';
    END IF;

    SELECT COUNT(*) INTO v_count
      FROM `gameobject`
     WHERE `map` = 860
       AND (POW(`position_x` - 1435.17, 2) + POW(`position_y` - 3353.44, 2) + POW(`position_z` - 173.35, 2)) <= POW(0.25, 2);
    IF v_gate_failure IS NULL AND v_count <> 2 THEN
        SET v_gate_failure = 'the southern transform must have exactly two gameobjects';
    END IF;

    SELECT COUNT(*) INTO v_exact
      FROM `gameobject_template`
     WHERE `entry` = 209970 AND `type` = 0 AND `displayId` = 11014 AND `faction` = 114 AND `flags` = 16
       AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001 AND `data0` = 0 AND `data1` = 0 AND `data2` = 3000;
    IF v_gate_failure IS NULL AND v_exact <> 1 THEN
        SET v_gate_failure = 'northern closed-door template 209970 is not exact';
    END IF;

    SELECT COUNT(*) INTO v_exact
      FROM `gameobject_template`
     WHERE `entry` = 209971 AND `type` = 0 AND `displayId` = 11014 AND `faction` = 114 AND `flags` = 0
       AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001 AND `data0` = 0 AND `data1` = 0 AND `data2` = 3000;
    IF v_gate_failure IS NULL AND v_exact <> 1 THEN
        SET v_gate_failure = 'southern closed-door template 209971 is not exact';
    END IF;
    SELECT COUNT(*) INTO v_count FROM `gameobject` WHERE `id` = 209971;
    IF v_gate_failure IS NULL AND v_count <> 1 THEN
        SET v_gate_failure = 'template 209971 must have exactly one spawn';
    END IF;

    SELECT COUNT(*) INTO v_exact
      FROM `gameobject_template`
     WHERE `entry` = 209973 AND `type` = 0 AND `displayId` = 11014 AND `faction` = 0 AND `flags` = 4
       AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001 AND `data0` = 1 AND `data1` = 0 AND `data2` = 0;
    IF v_gate_failure IS NULL AND v_exact <> 1 THEN
        SET v_gate_failure = 'southern open-door template 209973 is not exact';
    END IF;
    SELECT COUNT(*) INTO v_count FROM `gameobject` WHERE `id` = 209973;
    IF v_gate_failure IS NULL AND v_count <> 1 THEN
        SET v_gate_failure = 'template 209973 must have exactly one spawn';
    END IF;

    SELECT COUNT(*) INTO v_count
      FROM `information_schema`.`tables`
     WHERE `table_schema` = DATABASE()
       AND ((`table_name` = 'conditions' AND `engine` = 'InnoDB')
         OR (`table_name` = 'db_version' AND `engine` = 'InnoDB')
         OR (`table_name` = 'gameobject' AND `engine` = 'InnoDB')
         OR (`table_name` = 'gameobject_template' AND `engine` = 'InnoDB')
         OR (`table_name` = 'phase_definitions' AND `engine` = 'MyISAM'));
    IF v_gate_failure IS NULL AND v_count <> 5 THEN
        SET v_gate_failure = 'owned table engines do not match the required split';
    END IF;

    SELECT COUNT(*) INTO v_count
      FROM `db_version`
     WHERE `version` = 23 AND `structure` = 3 AND `content` = 8;
    IF v_gate_failure IS NULL AND v_count <> 0 THEN
        SET v_gate_failure = 'db_version row 23.03.008 already exists below current';
    END IF;

    IF v_gate_failure IS NOT NULL THEN
        SELECT '* UPDATE FAILED *' AS `Status`, v_gate_failure AS `Failed gate`;
        LEAVE main;
    END IF;

    write_block: BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 v_sql_message = MESSAGE_TEXT;
            ROLLBACK;
            DELETE FROM `phase_definitions`
             WHERE `zoneId` = 5736
               AND ((`entry` = 4 AND `phasemask` = 4096 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57819)
                 OR (`entry` = 5 AND `phasemask` = 8192 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57818));
            SET v_count = ROW_COUNT();
            SELECT '* UPDATE FAILED *' AS `Status`, v_sql_message AS `SQL error`,
                   v_count AS `MyISAM rows removed`,
                   IF((v_phase_published = 0 AND v_count = 0) OR (v_phase_published = 1 AND v_count = 2),
                      'exact cleanup complete', 'CLEANUP COUNT MISMATCH; inspect manually') AS `Compensation`;
        END;

        START TRANSACTION;

        INSERT INTO `conditions`
            (`condition_entry`, `type`, `value1`, `value2`, `comments`) VALUES
            (57818, 8, 29408, 0, 'Quest 29408 rewarded: southern temple gate is open'),
            (57819, -3, 57818, 0, 'Quest 29408 not rewarded: southern temple gate is closed');

        UPDATE `gameobject_template`
           SET `flags` = 16
         WHERE `entry` = 209971 AND `type` = 0 AND `displayId` = 11014
           AND `faction` = 114 AND `flags` = 0
           AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001
           AND `data0` = 0 AND `data1` = 0 AND `data2` = 3000
           AND (SELECT COUNT(*) FROM `gameobject` WHERE `id` = 209971) = 1;
        IF ROW_COUNT() <> 1 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'template 209971 update count was not one';
        END IF;

        UPDATE `gameobject`
           SET `phaseMask` = 4096, `state` = 1
         WHERE `guid` = 600074 AND `id` = 209971 AND `map` = 860 AND `spawnMask` = 1 AND `phaseMask` = 1
           AND ABS(CAST(`position_x` AS DOUBLE) - 1435.17) <= 0.0005
           AND ABS(CAST(`position_y` AS DOUBLE) - 3353.44) <= 0.0005
           AND ABS(CAST(`position_z` AS DOUBLE) - 173.35) <= 0.0005
           AND ABS(CAST(`orientation` AS DOUBLE) - 4.39823) <= 0.000001
           AND `rotation0` = 0 AND `rotation1` = 0
           AND ABS(CAST(`rotation2` AS DOUBLE) - 0.809017) <= 0.000001
           AND ABS(CAST(`rotation3` AS DOUBLE) - (-0.587785)) <= 0.000001
           AND `spawntimesecs` = 120 AND `animprogress` = 255 AND `state` = 0;
        IF ROW_COUNT() <> 1 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'GUID 600074 update count was not one';
        END IF;

        UPDATE `gameobject`
           SET `phaseMask` = 8192, `state` = 0
         WHERE `guid` = 600080 AND `id` = 209973 AND `map` = 860 AND `spawnMask` = 1 AND `phaseMask` = 1
           AND ABS(CAST(`position_x` AS DOUBLE) - 1435.17) <= 0.0005
           AND ABS(CAST(`position_y` AS DOUBLE) - 3353.44) <= 0.0005
           AND ABS(CAST(`position_z` AS DOUBLE) - 173.35) <= 0.0005
           AND ABS(CAST(`orientation` AS DOUBLE) - 4.39823) <= 0.000001
           AND `rotation0` = 0 AND `rotation1` = 0
           AND ABS(CAST(`rotation2` AS DOUBLE) - 0.809017) <= 0.000001
           AND ABS(CAST(`rotation3` AS DOUBLE) - (-0.587785)) <= 0.000001
           AND `spawntimesecs` = 120 AND `animprogress` = 255 AND `state` = 0;
        IF ROW_COUNT() <> 1 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'GUID 600080 update count was not one';
        END IF;

        INSERT INTO `phase_definitions`
            (`zoneId`, `entry`, `phasemask`, `phaseId`, `terrainswapmap`, `flags`, `condition_id`, `comment`) VALUES
            (5736, 4, 4096, 0, 0, 0, 57819, 'Closed southern temple gate before quest 29408 reward'),
            (5736, 5, 8192, 0, 0, 0, 57818, 'Open southern temple gate after quest 29408 reward');
        SET v_phase_published = 1;

        SELECT COALESCE(MAX(`condition_entry`), 0) INTO v_max_condition FROM `conditions`;
        IF v_max_condition <> 57819 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'condition high-water postcondition failed';
        END IF;

        SELECT COUNT(*) INTO v_count
          FROM `conditions`
         WHERE `condition_entry` BETWEEN 57816 AND 57819
            OR (`type` = 8 AND `value1` IN (29406, 29408) AND `value2` = 0)
            OR (`type` = -3 AND `value1` IN (57816, 57818) AND `value2` = 0);
        SELECT COUNT(*) INTO v_exact
          FROM `conditions`
         WHERE (`condition_entry` = 57816 AND `type` = 8 AND `value1` = 29406 AND `value2` = 0)
            OR (`condition_entry` = 57817 AND `type` = -3 AND `value1` = 57816 AND `value2` = 0)
            OR (`condition_entry` = 57818 AND `type` = 8 AND `value1` = 29408 AND `value2` = 0)
            OR (`condition_entry` = 57819 AND `type` = -3 AND `value1` = 57818 AND `value2` = 0);
        IF v_count <> 4 OR v_exact <> 4 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'condition postcondition failed';
        END IF;

        SELECT COUNT(*) INTO v_count FROM `phase_definitions` WHERE `zoneId` = 5736;
        SELECT COUNT(*) INTO v_exact
          FROM `phase_definitions`
         WHERE `zoneId` = 5736
           AND ((`entry` = 1 AND `phasemask` = 1 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 0)
             OR (`entry` = 2 AND `phasemask` = 16384 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57817)
             OR (`entry` = 3 AND `phasemask` = 32768 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57816)
             OR (`entry` = 4 AND `phasemask` = 4096 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57819)
             OR (`entry` = 5 AND `phasemask` = 8192 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57818));
        IF v_count <> 5 OR v_exact <> 5 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'phase-definition postcondition failed';
        END IF;

        SELECT COUNT(*) INTO v_count FROM `creature` WHERE `map` = 860 AND `phaseMask` <> 1;
        IF v_count <> 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'creature phase-mask postcondition failed';
        END IF;
        SELECT COUNT(*) INTO v_count FROM `gameobject` WHERE `map` = 860 AND `phaseMask` <> 1;
        SELECT COUNT(*) INTO v_exact
          FROM `gameobject`
         WHERE (`guid` = 600079 AND `id` = 209970 AND `phaseMask` = 16384 AND `state` = 1)
            OR (`guid` = 609470 AND `id` = 209972 AND `phaseMask` = 32768 AND `state` = 0)
            OR (`guid` = 600074 AND `id` = 209971 AND `phaseMask` = 4096 AND `state` = 1)
            OR (`guid` = 600080 AND `id` = 209973 AND `phaseMask` = 8192 AND `state` = 0);
        IF v_count <> 4 OR v_exact <> 4 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'four-gate phase postcondition failed';
        END IF;

        SELECT COUNT(*) INTO v_exact
          FROM `gameobject_template`
         WHERE (`entry` = 209970 AND `type` = 0 AND `displayId` = 11014 AND `faction` = 114 AND `flags` = 16
                AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001 AND `data0` = 0 AND `data1` = 0 AND `data2` = 3000)
            OR (`entry` = 209971 AND `type` = 0 AND `displayId` = 11014 AND `faction` = 114 AND `flags` = 16
                AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001 AND `data0` = 0 AND `data1` = 0 AND `data2` = 3000)
            OR (`entry` = 209973 AND `type` = 0 AND `displayId` = 11014 AND `faction` = 0 AND `flags` = 4
                AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001 AND `data0` = 1 AND `data1` = 0 AND `data2` = 0);
        IF v_exact <> 3 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'gate-template postcondition failed';
        END IF;

        SELECT COUNT(*) INTO v_count
          FROM `information_schema`.`tables`
         WHERE `table_schema` = DATABASE()
           AND ((`table_name` = 'conditions' AND `engine` = 'InnoDB')
             OR (`table_name` = 'db_version' AND `engine` = 'InnoDB')
             OR (`table_name` = 'gameobject' AND `engine` = 'InnoDB')
             OR (`table_name` = 'gameobject_template' AND `engine` = 'InnoDB')
             OR (`table_name` = 'phase_definitions' AND `engine` = 'MyISAM'));
        IF v_count <> 5 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'owned table-engine postcondition failed';
        END IF;

        INSERT INTO `db_version`
            (`version`, `structure`, `content`, `description`, `comment`) VALUES
            (23, 3, 8, 'Condition Southern Temple Door',
             'Replace the southern gate per player after quest 29408 is rewarded');

        COMMIT;
        SELECT '* UPDATE COMPLETE *' AS `Status`, '23.03.008' AS `Database version`;
    END write_block;
END main$$

DELIMITER ;

CALL `update_mangos`();
DROP PROCEDURE IF EXISTS `update_mangos`;

SELECT `condition_entry`, `type`, `value1`, `value2`
  FROM `conditions` WHERE `condition_entry` BETWEEN 57816 AND 57819 ORDER BY `condition_entry`;
SELECT `zoneId`, `entry`, `phasemask`, `condition_id`
  FROM `phase_definitions` WHERE `zoneId` = 5736 ORDER BY `entry`;
SELECT `guid`, `id`, `phaseMask`, `state`
  FROM `gameobject` WHERE `guid` IN (600074, 600079, 600080, 609470) ORDER BY `guid`;
SELECT `entry`, `flags`
  FROM `gameobject_template` WHERE `entry` IN (209970, 209971, 209973) ORDER BY `entry`;
SELECT `version`, `structure`, `content`, `description`
  FROM `db_version` ORDER BY `version` DESC, `structure` DESC, `content` DESC LIMIT 1;

-- -------------------------------------------------------------------------
-- MANUAL COMPENSATING ROLLBACK (copy and execute separately when required)
--
-- This deliberately leaves db_version at 23.03.008. Every mutation is
-- guarded by the exact values owned by this update.
-- -------------------------------------------------------------------------
/*
DROP PROCEDURE IF EXISTS `rollback_quest_conditioned_southern_temple_door`;

DELIMITER $$

CREATE PROCEDURE `rollback_quest_conditioned_southern_temple_door`()
rollback_main: BEGIN
    DECLARE v_version INT DEFAULT NULL;
    DECLARE v_structure INT DEFAULT NULL;
    DECLARE v_content INT DEFAULT NULL;
    DECLARE v_gate_failure VARCHAR(255) DEFAULT NULL;
    DECLARE v_phase_rows INT DEFAULT 0;
    DECLARE v_closed_rows INT DEFAULT 0;
    DECLARE v_open_rows INT DEFAULT 0;
    DECLARE v_template_rows INT DEFAULT 0;
    DECLARE v_not_condition_rows INT DEFAULT 0;
    DECLARE v_reward_condition_rows INT DEFAULT 0;

    SELECT `version`, `structure`, `content`
      INTO v_version, v_structure, v_content
      FROM `db_version`
     ORDER BY `version` DESC, `structure` DESC, `content` DESC
     LIMIT 1;
    IF v_version IS NULL OR v_version <> 23 OR v_structure <> 3 OR v_content <> 8 THEN
        SET v_gate_failure = 'database version must be exactly 23.03.008';
    END IF;

    SELECT COUNT(*) INTO v_phase_rows
      FROM `phase_definitions`
     WHERE `zoneId` = 5736
       AND ((`entry` = 4 AND `phasemask` = 4096 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57819)
         OR (`entry` = 5 AND `phasemask` = 8192 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57818));
    IF v_gate_failure IS NULL AND v_phase_rows <> 2 THEN SET v_gate_failure = 'exact southern phase definitions are not present'; END IF;

    SELECT COUNT(*) INTO v_closed_rows
      FROM `gameobject`
     WHERE `guid` = 600074 AND `id` = 209971 AND `map` = 860 AND `spawnMask` = 1 AND `phaseMask` = 4096
       AND ABS(CAST(`position_x` AS DOUBLE) - 1435.17) <= 0.0005
       AND ABS(CAST(`position_y` AS DOUBLE) - 3353.44) <= 0.0005
       AND ABS(CAST(`position_z` AS DOUBLE) - 173.35) <= 0.0005
       AND ABS(CAST(`orientation` AS DOUBLE) - 4.39823) <= 0.000001
       AND `rotation0` = 0 AND `rotation1` = 0
       AND ABS(CAST(`rotation2` AS DOUBLE) - 0.809017) <= 0.000001
       AND ABS(CAST(`rotation3` AS DOUBLE) - (-0.587785)) <= 0.000001
       AND `spawntimesecs` = 120 AND `animprogress` = 255 AND `state` = 1;
    IF v_gate_failure IS NULL AND v_closed_rows <> 1 THEN SET v_gate_failure = 'closed southern spawn is not exact'; END IF;

    SELECT COUNT(*) INTO v_open_rows
      FROM `gameobject`
     WHERE `guid` = 600080 AND `id` = 209973 AND `map` = 860 AND `spawnMask` = 1 AND `phaseMask` = 8192
       AND ABS(CAST(`position_x` AS DOUBLE) - 1435.17) <= 0.0005
       AND ABS(CAST(`position_y` AS DOUBLE) - 3353.44) <= 0.0005
       AND ABS(CAST(`position_z` AS DOUBLE) - 173.35) <= 0.0005
       AND ABS(CAST(`orientation` AS DOUBLE) - 4.39823) <= 0.000001
       AND `rotation0` = 0 AND `rotation1` = 0
       AND ABS(CAST(`rotation2` AS DOUBLE) - 0.809017) <= 0.000001
       AND ABS(CAST(`rotation3` AS DOUBLE) - (-0.587785)) <= 0.000001
       AND `spawntimesecs` = 120 AND `animprogress` = 255 AND `state` = 0;
    IF v_gate_failure IS NULL AND v_open_rows <> 1 THEN SET v_gate_failure = 'open southern spawn is not exact'; END IF;

    SELECT COUNT(*) INTO v_template_rows
      FROM `gameobject_template`
     WHERE `entry` = 209971 AND `type` = 0 AND `displayId` = 11014 AND `faction` = 114 AND `flags` = 16
       AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001 AND `data0` = 0 AND `data1` = 0 AND `data2` = 3000;
    IF v_gate_failure IS NULL AND v_template_rows <> 1 THEN SET v_gate_failure = 'southern closed-door template is not exact'; END IF;

    SELECT COUNT(*) INTO v_not_condition_rows
      FROM `conditions` WHERE `condition_entry` = 57819 AND `type` = -3 AND `value1` = 57818 AND `value2` = 0;
    SELECT COUNT(*) INTO v_reward_condition_rows
      FROM `conditions` WHERE `condition_entry` = 57818 AND `type` = 8 AND `value1` = 29408 AND `value2` = 0;
    IF v_gate_failure IS NULL AND (v_not_condition_rows <> 1 OR v_reward_condition_rows <> 1) THEN
        SET v_gate_failure = 'southern conditions are not exact';
    END IF;

    IF v_gate_failure IS NOT NULL THEN
        SELECT '* ROLLBACK FAILED *' AS `Status`, v_gate_failure AS `Failed gate`;
        LEAVE rollback_main;
    END IF;

    rollback_write: BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            INSERT IGNORE INTO `phase_definitions`
                (`zoneId`, `entry`, `phasemask`, `phaseId`, `terrainswapmap`, `flags`, `condition_id`, `comment`) VALUES
                (5736, 4, 4096, 0, 0, 0, 57819, 'Closed southern temple gate before quest 29408 reward'),
                (5736, 5, 8192, 0, 0, 0, 57818, 'Open southern temple gate after quest 29408 reward');
            SELECT '* ROLLBACK FAILED *' AS `Status`,
                   'InnoDB rolled back; exact MyISAM definitions restored' AS `Compensation`;
        END;

        START TRANSACTION;

        DELETE FROM `phase_definitions`
         WHERE `zoneId` = 5736
           AND ((`entry` = 4 AND `phasemask` = 4096 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57819)
             OR (`entry` = 5 AND `phasemask` = 8192 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57818));
        SET v_phase_rows = ROW_COUNT();
        IF v_phase_rows <> 2 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'phase rollback count was not two'; END IF;

        UPDATE `gameobject`
           SET `phaseMask` = 1, `state` = 0
         WHERE `guid` = 600074 AND `id` = 209971 AND `map` = 860 AND `spawnMask` = 1 AND `phaseMask` = 4096
           AND ABS(CAST(`position_x` AS DOUBLE) - 1435.17) <= 0.0005
           AND ABS(CAST(`position_y` AS DOUBLE) - 3353.44) <= 0.0005
           AND ABS(CAST(`position_z` AS DOUBLE) - 173.35) <= 0.0005
           AND ABS(CAST(`orientation` AS DOUBLE) - 4.39823) <= 0.000001
           AND `rotation0` = 0 AND `rotation1` = 0
           AND ABS(CAST(`rotation2` AS DOUBLE) - 0.809017) <= 0.000001
           AND ABS(CAST(`rotation3` AS DOUBLE) - (-0.587785)) <= 0.000001
           AND `spawntimesecs` = 120 AND `animprogress` = 255 AND `state` = 1;
        SET v_closed_rows = ROW_COUNT();
        IF v_closed_rows <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'closed spawn rollback count was not one'; END IF;

        UPDATE `gameobject`
           SET `phaseMask` = 1, `state` = 0
         WHERE `guid` = 600080 AND `id` = 209973 AND `map` = 860 AND `spawnMask` = 1 AND `phaseMask` = 8192
           AND ABS(CAST(`position_x` AS DOUBLE) - 1435.17) <= 0.0005
           AND ABS(CAST(`position_y` AS DOUBLE) - 3353.44) <= 0.0005
           AND ABS(CAST(`position_z` AS DOUBLE) - 173.35) <= 0.0005
           AND ABS(CAST(`orientation` AS DOUBLE) - 4.39823) <= 0.000001
           AND `rotation0` = 0 AND `rotation1` = 0
           AND ABS(CAST(`rotation2` AS DOUBLE) - 0.809017) <= 0.000001
           AND ABS(CAST(`rotation3` AS DOUBLE) - (-0.587785)) <= 0.000001
           AND `spawntimesecs` = 120 AND `animprogress` = 255 AND `state` = 0;
        SET v_open_rows = ROW_COUNT();
        IF v_open_rows <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'open spawn rollback count was not one'; END IF;

        SELECT COUNT(*) INTO v_template_rows
          FROM `gameobject` WHERE `id` = 209971 AND `phaseMask` = 4096;
        IF v_template_rows <> 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'phase-4096 template 209971 spawns remain'; END IF;

        UPDATE `gameobject_template`
           SET `flags` = 0
         WHERE `entry` = 209971 AND `type` = 0 AND `displayId` = 11014 AND `faction` = 114 AND `flags` = 16
           AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001 AND `data0` = 0 AND `data1` = 0 AND `data2` = 3000
           AND (SELECT COUNT(*) FROM `gameobject` WHERE `id` = 209971) = 1;
        SET v_template_rows = ROW_COUNT();
        IF v_template_rows <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'template rollback count was not one'; END IF;

        DELETE owned
          FROM `conditions` owned
          LEFT JOIN `phase_definitions` phase_ref ON phase_ref.`condition_id` = owned.`condition_entry`
          LEFT JOIN `conditions` condition_ref
            ON condition_ref.`type` = -3 AND condition_ref.`value1` = owned.`condition_entry`
           AND condition_ref.`condition_entry` <> owned.`condition_entry`
         WHERE owned.`condition_entry` = 57819 AND owned.`type` = -3 AND owned.`value1` = 57818 AND owned.`value2` = 0
           AND phase_ref.`zoneId` IS NULL AND condition_ref.`condition_entry` IS NULL;
        SET v_not_condition_rows = ROW_COUNT();
        IF v_not_condition_rows <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NOT-condition rollback count was not one'; END IF;

        DELETE owned
          FROM `conditions` owned
          LEFT JOIN `phase_definitions` phase_ref ON phase_ref.`condition_id` = owned.`condition_entry`
          LEFT JOIN `conditions` condition_ref
            ON condition_ref.`type` = -3 AND condition_ref.`value1` = owned.`condition_entry`
           AND condition_ref.`condition_entry` <> owned.`condition_entry`
         WHERE owned.`condition_entry` = 57818 AND owned.`type` = 8 AND owned.`value1` = 29408 AND owned.`value2` = 0
           AND phase_ref.`zoneId` IS NULL AND condition_ref.`condition_entry` IS NULL;
        SET v_reward_condition_rows = ROW_COUNT();
        IF v_reward_condition_rows <> 1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'reward-condition rollback count was not one'; END IF;

        COMMIT;
        SELECT '* COMPENSATING ROLLBACK COMPLETE *' AS `Status`,
               v_phase_rows AS `phase rows removed`,
               v_closed_rows AS `closed spawns restored`,
               v_open_rows AS `open spawns restored`,
               v_template_rows AS `template flags restored`,
               v_not_condition_rows AS `NOT conditions removed`,
               v_reward_condition_rows AS `reward conditions removed`;
    END rollback_write;
END rollback_main$$

DELIMITER ;

CALL `rollback_quest_conditioned_southern_temple_door`();
DROP PROCEDURE IF EXISTS `rollback_quest_conditioned_southern_temple_door`;
*/
