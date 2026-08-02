-- Advance the quest-conditioned Wandering Isle gate from Rel23_03_006.
-- Two exact deployment histories are valid: 006 may still be active, or its
-- documented data compensation may have been applied while retaining the
-- 23.03.006 version row. Both converge on the same active 23.03.007 state.

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
    DECLARE v_active_match INT DEFAULT 1;
    DECLARE v_compensated_match INT DEFAULT 1;
    DECLARE v_max_condition BIGINT DEFAULT 0;
    DECLARE v_max_guid BIGINT DEFAULT 0;

    SELECT `version`, `structure`, `content`
      INTO v_version, v_structure, v_content
      FROM `db_version`
     ORDER BY `version` DESC, `structure` DESC, `content` DESC
     LIMIT 1;

    IF v_version = 23 AND v_structure = 3 AND v_content = 7 THEN
        SELECT '* UPDATE SKIPPED *' AS `Status`,
               '23.03.007 is already current' AS `Detail`;
        LEAVE main;
    END IF;

    IF v_version IS NULL OR v_version <> 23 OR v_structure <> 3 OR v_content <> 6 THEN
        SELECT '* UPDATE FAILED *' AS `Status`,
               'database version must be exactly 23.03.006' AS `Failed gate`;
        LEAVE main;
    END IF;

    SELECT COALESCE(MAX(`condition_entry`), 0)
      INTO v_max_condition
      FROM `conditions`;
    SELECT COALESCE(MAX(`guid`), 0) INTO v_max_guid FROM `gameobject`;

    SELECT COUNT(*) INTO v_count
      FROM `information_schema`.`tables`
     WHERE `table_schema` = DATABASE()
       AND ((`table_name` = 'conditions' AND `engine` = 'InnoDB')
         OR (`table_name` = 'db_version' AND `engine` = 'InnoDB')
         OR (`table_name` = 'gameobject' AND `engine` = 'InnoDB')
         OR (`table_name` = 'gameobject_template' AND `engine` = 'InnoDB')
         OR (`table_name` = 'phase_definitions' AND `engine` = 'MyISAM'));
    IF v_count <> 5 THEN
        SET v_gate_failure = 'owned table engines do not match the required split';
    END IF;

    SELECT COUNT(*) INTO v_count
      FROM `db_version`
     WHERE `version` = 23 AND `structure` = 3 AND `content` = 7;
    IF v_gate_failure IS NULL AND v_count <> 0 THEN
        SET v_gate_failure = 'db_version row 23.03.007 already exists below current';
    END IF;

    -- Classify the exact successful-006 state.
    IF v_max_condition <> 57817 OR v_max_guid <> 609470 THEN
        SET v_active_match = 0;
    END IF;

    SELECT COUNT(*) INTO v_count
      FROM `conditions`
     WHERE `condition_entry` IN (57816, 57817)
        OR (`type` = 8 AND `value1` = 29406 AND `value2` = 0)
        OR (`type` = -3 AND `value1` = 57816 AND `value2` = 0);
    SELECT COUNT(*) INTO v_exact
      FROM `conditions`
     WHERE (`condition_entry` = 57816 AND `type` = 8 AND `value1` = 29406 AND `value2` = 0)
        OR (`condition_entry` = 57817 AND `type` = -3 AND `value1` = 57816 AND `value2` = 0);
    IF v_count <> 2 OR v_exact <> 2 THEN SET v_active_match = 0; END IF;

    SELECT COUNT(*) INTO v_count FROM `phase_definitions` WHERE `zoneId` = 5736;
    SELECT COUNT(*) INTO v_exact
      FROM `phase_definitions`
     WHERE `zoneId` = 5736
       AND ((`entry` = 1 AND `phasemask` = 1 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 0)
         OR (`entry` = 2 AND `phasemask` = 16384 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57817)
         OR (`entry` = 3 AND `phasemask` = 32768 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57816));
    IF v_count <> 3 OR v_exact <> 3 THEN SET v_active_match = 0; END IF;

    SELECT COUNT(*) INTO v_count FROM `creature` WHERE `map` = 860 AND `phaseMask` <> 1;
    IF v_count <> 0 THEN SET v_active_match = 0; END IF;
    SELECT COUNT(*) INTO v_count FROM `gameobject` WHERE `map` = 860 AND `phaseMask` <> 1;
    IF v_count <> 2 THEN SET v_active_match = 0; END IF;

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
    IF v_exact <> 2 THEN SET v_active_match = 0; END IF;

    SELECT COUNT(*) INTO v_count
      FROM `gameobject`
     WHERE `map` = 860
       AND (POW(`position_x` - 1446.98, 2) + POW(`position_y` - 3389.89, 2) + POW(`position_z` - 173.35, 2)) <= POW(0.25, 2);
    IF v_count <> 2 THEN SET v_active_match = 0; END IF;

    SELECT COUNT(*) INTO v_exact
      FROM `gameobject_template`
     WHERE `entry` = 209970 AND `type` = 0 AND `displayId` = 11014 AND `faction` = 114 AND `flags` = 16
       AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001 AND `data0` = 0 AND `data1` = 0 AND `data2` = 3000;
    IF v_exact <> 1 THEN SET v_active_match = 0; END IF;
    SELECT COUNT(*) INTO v_exact
      FROM `gameobject_template`
     WHERE `entry` = 209972 AND `type` = 0 AND `displayId` = 11014 AND `faction` = 114 AND `flags` = 0
       AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001 AND `data0` = 0 AND `data1` = 0 AND `data2` = 0;
    IF v_exact <> 1 THEN SET v_active_match = 0; END IF;
    SELECT COUNT(*) INTO v_count FROM `gameobject` WHERE `id` = 209970;
    IF v_count <> 1 THEN SET v_active_match = 0; END IF;

    -- Classify the exact documented compensation of 006.
    IF v_max_condition <> 57815 OR v_max_guid <> 609469 THEN
        SET v_compensated_match = 0;
    END IF;

    SELECT COUNT(*) INTO v_count
      FROM `conditions`
     WHERE `condition_entry` IN (57816, 57817)
        OR (`type` = 8 AND `value1` = 29406 AND `value2` = 0)
        OR (`type` = -3 AND `value1` = 57816 AND `value2` = 0);
    IF v_count <> 0 THEN SET v_compensated_match = 0; END IF;
    SELECT COUNT(*) INTO v_count FROM `phase_definitions` WHERE `zoneId` = 5736;
    IF v_count <> 0 THEN SET v_compensated_match = 0; END IF;
    SELECT COUNT(*) INTO v_count FROM `creature` WHERE `map` = 860 AND `phaseMask` <> 1;
    IF v_count <> 0 THEN SET v_compensated_match = 0; END IF;
    SELECT COUNT(*) INTO v_count FROM `gameobject` WHERE `map` = 860 AND `phaseMask` <> 1;
    IF v_count <> 0 THEN SET v_compensated_match = 0; END IF;

    SELECT COUNT(*) INTO v_exact
      FROM `gameobject`
     WHERE `guid` = 600079 AND `id` = 209972 AND `map` = 860 AND `spawnMask` = 1 AND `phaseMask` = 1
       AND ABS(CAST(`position_x` AS DOUBLE) - 1446.98) <= 0.0005
       AND ABS(CAST(`position_y` AS DOUBLE) - 3389.89) <= 0.0005
       AND ABS(CAST(`position_z` AS DOUBLE) - 173.35) <= 0.0005
       AND ABS(CAST(`orientation` AS DOUBLE) - 1.23918) <= 0.000001
       AND `rotation0` = 0 AND `rotation1` = 0
       AND ABS(CAST(`rotation2` AS DOUBLE) - 0.580701) <= 0.000001
       AND ABS(CAST(`rotation3` AS DOUBLE) - 0.814117) <= 0.000001
       AND `spawntimesecs` = 120 AND `animprogress` = 255 AND `state` = 0;
    IF v_exact <> 1 THEN SET v_compensated_match = 0; END IF;
    SELECT COUNT(*) INTO v_count
      FROM `gameobject`
     WHERE `map` = 860
       AND (POW(`position_x` - 1446.98, 2) + POW(`position_y` - 3389.89, 2) + POW(`position_z` - 173.35, 2)) <= POW(0.25, 2);
    IF v_count <> 1 THEN SET v_compensated_match = 0; END IF;

    SELECT COUNT(*) INTO v_exact
      FROM `gameobject_template`
     WHERE `entry` = 209970 AND `type` = 0 AND `displayId` = 11014 AND `faction` = 114 AND `flags` = 0
       AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001 AND `data0` = 0 AND `data1` = 0 AND `data2` = 3000;
    IF v_exact <> 1 THEN SET v_compensated_match = 0; END IF;
    SELECT COUNT(*) INTO v_exact
      FROM `gameobject_template`
     WHERE `entry` = 209972 AND `type` = 0 AND `displayId` = 11014 AND `faction` = 114 AND `flags` = 0
       AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001 AND `data0` = 0 AND `data1` = 0 AND `data2` = 0;
    IF v_exact <> 1 THEN SET v_compensated_match = 0; END IF;
    SELECT COUNT(*) INTO v_count FROM `gameobject` WHERE `id` = 209970;
    IF v_count <> 0 THEN SET v_compensated_match = 0; END IF;
    SELECT COUNT(*) INTO v_count FROM `gameobject` WHERE `guid` = 609470;
    IF v_count <> 0 THEN SET v_compensated_match = 0; END IF;

    IF v_gate_failure IS NOT NULL THEN
        SELECT '* UPDATE FAILED *' AS `Status`, v_gate_failure AS `Failed gate`;
        LEAVE main;
    END IF;

    IF v_active_match + v_compensated_match <> 1 THEN
        SELECT '* UPDATE FAILED *' AS `Status`,
               '23.03.006 state is neither exact active nor exact compensated' AS `Failed gate`;
        LEAVE main;
    END IF;

    write_block: BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 v_sql_message = MESSAGE_TEXT;
            ROLLBACK;
            IF v_compensated_match = 1 THEN
                DELETE FROM `phase_definitions`
                 WHERE `zoneId` = 5736
                   AND ((`entry` = 1 AND `phasemask` = 1 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 0)
                     OR (`entry` = 2 AND `phasemask` = 16384 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57817)
                     OR (`entry` = 3 AND `phasemask` = 32768 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57816));
            END IF;
            SELECT '* UPDATE FAILED *' AS `Status`, v_sql_message AS `SQL error`,
                   IF(v_compensated_match = 1,
                      'InnoDB rolled back; exact newly-owned MyISAM rows removed',
                      'InnoDB rolled back; pre-existing active phase rows retained') AS `Compensation`;
        END;

        START TRANSACTION;

        IF v_compensated_match = 1 THEN
            INSERT INTO `conditions`
            (`condition_entry`, `type`, `value1`, `value2`, `comments`) VALUES
            (57816, 8, 29406, 0, 'Quest 29406 rewarded: Sandy Fist temple gate is open'),
            (57817, -3, 57816, 0, 'Quest 29406 not rewarded: Sandy Fist temple gate is closed');

        UPDATE `gameobject_template`
           SET `flags` = 16
         WHERE `entry` = 209970 AND `type` = 0 AND `displayId` = 11014
           AND `faction` = 114 AND `flags` = 0
           AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001
           AND `data0` = 0 AND `data1` = 0 AND `data2` = 3000
           AND NOT EXISTS (SELECT 1 FROM `gameobject` WHERE `id` = 209970);
        IF ROW_COUNT() <> 1 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'template 209970 update count was not one';
        END IF;

        UPDATE `gameobject`
           SET `id` = 209970, `phaseMask` = 16384, `state` = 1
         WHERE `guid` = 600079 AND `id` = 209972 AND `map` = 860
           AND `spawnMask` = 1 AND `phaseMask` = 1
           AND ABS(CAST(`position_x` AS DOUBLE) - 1446.98) <= 0.0005
           AND ABS(CAST(`position_y` AS DOUBLE) - 3389.89) <= 0.0005
           AND ABS(CAST(`position_z` AS DOUBLE) - 173.35) <= 0.0005
           AND ABS(CAST(`orientation` AS DOUBLE) - 1.23918) <= 0.000001
           AND `rotation0` = 0 AND `rotation1` = 0
           AND ABS(CAST(`rotation2` AS DOUBLE) - 0.580701) <= 0.000001
           AND ABS(CAST(`rotation3` AS DOUBLE) - 0.814117) <= 0.000001
           AND `spawntimesecs` = 120 AND `animprogress` = 255 AND `state` = 0;
        IF ROW_COUNT() <> 1 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'GUID 600079 update count was not one';
        END IF;

        INSERT INTO `gameobject`
            (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`,
             `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`) VALUES
            (609470, 209972, 860, 1, 32768, 1446.98, 3389.89, 173.35, 1.23918,
             0, 0, 0.580701, 0.814117, 120, 255, 0);

            INSERT INTO `phase_definitions`
            (`zoneId`, `entry`, `phasemask`, `phaseId`, `terrainswapmap`, `flags`, `condition_id`, `comment`) VALUES
            (5736, 1, 1, 0, 0, 0, 0, 'Base Wandering Isle visibility retained for every player'),
            (5736, 2, 16384, 0, 0, 0, 57817, 'Closed Sandy Fist temple gate before quest 29406 reward'),
            (5736, 3, 32768, 0, 0, 0, 57816, 'Open Sandy Fist temple gate after quest 29406 reward');
        END IF;

        -- Repeat the complete active identity before publishing 23.03.007.
        SELECT COALESCE(MAX(`condition_entry`), 0) INTO v_max_condition FROM `conditions`;
        SELECT COALESCE(MAX(`guid`), 0) INTO v_max_guid FROM `gameobject`;
        IF v_max_condition <> 57817 OR v_max_guid <> 609470 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'active high-water postcondition failed';
        END IF;

        SELECT COUNT(*) INTO v_count
          FROM `conditions`
         WHERE `condition_entry` IN (57816, 57817)
            OR (`type` = 8 AND `value1` = 29406 AND `value2` = 0)
            OR (`type` = -3 AND `value1` = 57816 AND `value2` = 0);
        SELECT COUNT(*) INTO v_exact
          FROM `conditions`
         WHERE (`condition_entry` = 57816 AND `type` = 8 AND `value1` = 29406 AND `value2` = 0)
            OR (`condition_entry` = 57817 AND `type` = -3 AND `value1` = 57816 AND `value2` = 0);
        IF v_count <> 2 OR v_exact <> 2 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'condition postcondition failed';
        END IF;

        SELECT COUNT(*) INTO v_count FROM `phase_definitions` WHERE `zoneId` = 5736;
        SELECT COUNT(*) INTO v_exact
          FROM `phase_definitions`
         WHERE `zoneId` = 5736
           AND ((`entry` = 1 AND `phasemask` = 1 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 0)
             OR (`entry` = 2 AND `phasemask` = 16384 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57817)
             OR (`entry` = 3 AND `phasemask` = 32768 AND `phaseId` = 0 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57816));
        IF v_count <> 3 OR v_exact <> 3 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'phase-definition postcondition failed';
        END IF;

        SELECT COUNT(*) INTO v_count FROM `creature` WHERE `map` = 860 AND `phaseMask` <> 1;
        IF v_count <> 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'creature phase-mask postcondition failed';
        END IF;
        SELECT COUNT(*) INTO v_count FROM `gameobject` WHERE `map` = 860 AND `phaseMask` <> 1;
        IF v_count <> 2 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'gameobject phase-mask postcondition failed';
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
        SELECT COUNT(*) INTO v_count
          FROM `gameobject`
         WHERE `map` = 860
           AND (POW(`position_x` - 1446.98, 2) + POW(`position_y` - 3389.89, 2) + POW(`position_z` - 173.35, 2)) <= POW(0.25, 2);
        IF v_exact <> 2 OR v_count <> 2 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'gate-spawn postcondition failed';
        END IF;

        SELECT COUNT(*) INTO v_exact
          FROM `gameobject_template`
         WHERE `entry` = 209970 AND `type` = 0 AND `displayId` = 11014 AND `faction` = 114 AND `flags` = 16
           AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001 AND `data0` = 0 AND `data1` = 0 AND `data2` = 3000;
        IF v_exact <> 1 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'closed-door template postcondition failed';
        END IF;
        SELECT COUNT(*) INTO v_exact
          FROM `gameobject_template`
         WHERE `entry` = 209972 AND `type` = 0 AND `displayId` = 11014 AND `faction` = 114 AND `flags` = 0
           AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001 AND `data0` = 0 AND `data1` = 0 AND `data2` = 0;
        IF v_exact <> 1 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'open-door template postcondition failed';
        END IF;
        SELECT COUNT(*) INTO v_count FROM `gameobject` WHERE `id` = 209970;
        IF v_count <> 1 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'closed-door spawn-count postcondition failed';
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
            (23, 3, 7, 'Reactivate Conditioned Door',
             'Accept exact active or compensated 006 state');

        COMMIT;
        SELECT '* UPDATE COMPLETE *' AS `Status`,
               IF(v_active_match = 1,
                  '23.03.007; active 006 data retained',
                  '23.03.007; compensated 006 data restored') AS `Database version`;
    END write_block;
END main$$

DELIMITER ;

CALL `update_mangos`();
DROP PROCEDURE IF EXISTS `update_mangos`;

SELECT `condition_entry`, `type`, `value1`, `value2`
  FROM `conditions` WHERE `condition_entry` IN (57816, 57817) ORDER BY `condition_entry`;
SELECT `zoneId`, `entry`, `phasemask`, `condition_id`
  FROM `phase_definitions` WHERE `zoneId` = 5736 ORDER BY `entry`;
SELECT `guid`, `id`, `phaseMask`, `state`
  FROM `gameobject` WHERE `guid` IN (600079, 609470) ORDER BY `guid`;
SELECT `entry`, `flags` FROM `gameobject_template` WHERE `entry` IN (209970, 209972) ORDER BY `entry`;
SELECT `version`, `structure`, `content`, `description`
  FROM `db_version` ORDER BY `version` DESC, `structure` DESC, `content` DESC LIMIT 1;

-- Emergency data compensation uses the exact-value manual rollback block in
-- Rel23_03_006_Quest_Conditioned_Temple_Door.sql. As with 006, do not remove
-- or decrement db_version automatically; follow deployment version policy.
