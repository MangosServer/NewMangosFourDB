-- Quest-conditioned replacement of the Wandering Isle temple gate after
-- rewarding quest 29406 (The Lesson of the Sandy Fist).
--
-- phase_definitions is MyISAM in Rel23 while the other owned tables are
-- InnoDB. This update therefore uses exact preconditions and compensating
-- cleanup for its phase rows; it does not claim mixed-engine atomicity.

DROP PROCEDURE IF EXISTS `update_mangos`;

DELIMITER $$

CREATE PROCEDURE `update_mangos`()
main: BEGIN
    DECLARE v_cur_version INT DEFAULT NULL;
    DECLARE v_cur_structure INT DEFAULT NULL;
    DECLARE v_cur_content INT DEFAULT NULL;
    DECLARE v_cur_description VARCHAR(30) DEFAULT NULL;
    DECLARE v_gate_failure VARCHAR(255) DEFAULT NULL;
    DECLARE v_sql_message TEXT DEFAULT NULL;

    DECLARE v_condition_max BIGINT DEFAULT 0;
    DECLARE v_condition_reserved_count INT DEFAULT 0;
    DECLARE v_condition_tuple_count INT DEFAULT 0;
    DECLARE v_zone_phase_count INT DEFAULT 0;
    DECLARE v_creature_non_normal_count INT DEFAULT 0;
    DECLARE v_gameobject_non_normal_count INT DEFAULT 0;
    DECLARE v_gate_count INT DEFAULT 0;
    DECLARE v_near_transform_count INT DEFAULT 0;
    DECLARE v_closed_template_count INT DEFAULT 0;
    DECLARE v_open_template_count INT DEFAULT 0;
    DECLARE v_closed_spawn_count INT DEFAULT 0;
    DECLARE v_max_guid BIGINT DEFAULT 0;
    DECLARE v_candidate_guid_count INT DEFAULT 0;
    DECLARE v_engine_count INT DEFAULT 0;
    DECLARE v_new_version_count INT DEFAULT 0;
    DECLARE v_affected_rows INT DEFAULT 0;
    DECLARE v_post_count INT DEFAULT 0;
    DECLARE v_post_exact_count INT DEFAULT 0;

    SELECT `version`, `structure`, `content`, `description`
      INTO v_cur_version, v_cur_structure, v_cur_content, v_cur_description
      FROM `db_version`
     ORDER BY `version` DESC, `structure` DESC, `content` DESC
     LIMIT 1;

    IF v_cur_version = 23 AND v_cur_structure = 3 AND v_cur_content = 6 THEN
        SELECT '* UPDATE SKIPPED *' AS `Status`,
               '23.03.006 is already the current database version' AS `Detail`;
        LEAVE main;
    END IF;

    IF v_cur_version IS NULL
       OR v_cur_version <> 23
       OR v_cur_structure <> 3
       OR v_cur_content <> 5 THEN
        SELECT '* UPDATE FAILED *' AS `Status`,
               'database version must be exactly 23.03.005' AS `Failed gate`,
               CONCAT_WS('.', v_cur_version, v_cur_structure, v_cur_content) AS `Current version`;
        LEAVE main;
    END IF;

    SELECT COALESCE(MAX(`condition_entry`), 0)
      INTO v_condition_max
      FROM `conditions`;

    SELECT COUNT(*)
      INTO v_condition_reserved_count
      FROM `conditions`
     WHERE `condition_entry` IN (57816, 57817);

    SELECT COUNT(*)
      INTO v_condition_tuple_count
      FROM `conditions`
     WHERE (`type` = 8 AND `value1` = 29406 AND `value2` = 0)
        OR (`type` = -3 AND `value1` = 57816 AND `value2` = 0);

    SELECT COUNT(*)
      INTO v_zone_phase_count
      FROM `phase_definitions`
     WHERE `zoneId` = 5736;

    SELECT COUNT(*)
      INTO v_creature_non_normal_count
      FROM `creature`
     WHERE `map` = 860 AND `phaseMask` <> 1;

    SELECT COUNT(*)
      INTO v_gameobject_non_normal_count
      FROM `gameobject`
     WHERE `map` = 860 AND `phaseMask` <> 1;

    SELECT COUNT(*)
      INTO v_gate_count
      FROM `gameobject`
     WHERE `guid` = 600079
       AND `id` = 209972
       AND `map` = 860
       AND `spawnMask` = 1
       AND `phaseMask` = 1
       AND ABS(CAST(`position_x` AS DOUBLE) - 1446.98) <= 0.0005
       AND ABS(CAST(`position_y` AS DOUBLE) - 3389.89) <= 0.0005
       AND ABS(CAST(`position_z` AS DOUBLE) - 173.35) <= 0.0005
       AND ABS(CAST(`orientation` AS DOUBLE) - 1.23918) <= 0.000001
       AND `rotation0` = 0
       AND `rotation1` = 0
       AND ABS(CAST(`rotation2` AS DOUBLE) - 0.580701) <= 0.000001
       AND ABS(CAST(`rotation3` AS DOUBLE) - 0.814117) <= 0.000001
       AND `spawntimesecs` = 120
       AND `animprogress` = 255
       AND `state` = 0;

    SELECT COUNT(*)
      INTO v_near_transform_count
      FROM `gameobject`
     WHERE `map` = 860
       AND (POW(`position_x` - 1446.98, 2)
          + POW(`position_y` - 3389.89, 2)
          + POW(`position_z` - 173.35, 2)) <= POW(0.25, 2);

    SELECT COUNT(*)
      INTO v_closed_template_count
      FROM `gameobject_template`
     WHERE `entry` = 209970
       AND `type` = 0
       AND `displayId` = 11014
       AND `faction` = 114
       AND `flags` = 0
       AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001
       AND `data0` = 0
       AND `data1` = 0
       AND `data2` = 3000;

    SELECT COUNT(*)
      INTO v_open_template_count
      FROM `gameobject_template`
     WHERE `entry` = 209972
       AND `type` = 0
       AND `displayId` = 11014
       AND `faction` = 114
       AND `flags` = 0
       AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001
       AND `data0` = 0
       AND `data1` = 0
       AND `data2` = 0;

    SELECT COUNT(*)
      INTO v_closed_spawn_count
      FROM `gameobject`
     WHERE `id` = 209970;

    SELECT COALESCE(MAX(`guid`), 0)
      INTO v_max_guid
      FROM `gameobject`;

    SELECT COUNT(*)
      INTO v_candidate_guid_count
      FROM `gameobject`
     WHERE `guid` = 609470;

    SELECT COUNT(*)
      INTO v_engine_count
      FROM `information_schema`.`tables`
     WHERE `table_schema` = DATABASE()
       AND ((`table_name` = 'conditions' AND `engine` = 'InnoDB')
         OR (`table_name` = 'gameobject' AND `engine` = 'InnoDB')
         OR (`table_name` = 'gameobject_template' AND `engine` = 'InnoDB')
         OR (`table_name` = 'phase_definitions' AND `engine` = 'MyISAM'));

    SELECT COUNT(*)
      INTO v_new_version_count
      FROM `db_version`
     WHERE `version` = 23 AND `structure` = 3 AND `content` = 6;

    IF v_condition_max <> 57815 THEN
        SET v_gate_failure = CONCAT('condition high-water must be 57815; found ', v_condition_max);
    ELSEIF v_condition_reserved_count <> 0 THEN
        SET v_gate_failure = 'condition IDs 57816 and 57817 must both be free';
    ELSEIF v_condition_tuple_count <> 0 THEN
        SET v_gate_failure = 'owned condition tuples must not already exist';
    ELSEIF 57816 >= 57817 THEN
        SET v_gate_failure = 'CONDITION_NOT must reference a numerically lower condition ID';
    ELSEIF v_zone_phase_count <> 0 THEN
        SET v_gate_failure = 'zone 5736 phase definitions must be empty';
    ELSEIF v_creature_non_normal_count <> 0 THEN
        SET v_gate_failure = 'map 860 creature phase masks must all be 1';
    ELSEIF v_gameobject_non_normal_count <> 0 THEN
        SET v_gate_failure = 'map 860 gameobject phase masks must all be 1';
    ELSEIF v_gate_count <> 1 THEN
        SET v_gate_failure = 'GUID 600079 does not exactly match the expected open gate row';
    ELSEIF v_near_transform_count <> 1 THEN
        SET v_gate_failure = 'the gate transform must have exactly one nearby gameobject';
    ELSEIF v_closed_template_count <> 1 THEN
        SET v_gate_failure = 'template 209970 does not exactly match the expected unused closed door';
    ELSEIF v_open_template_count <> 1 THEN
        SET v_gate_failure = 'template 209972 does not exactly match the expected open door';
    ELSEIF v_closed_spawn_count <> 0 THEN
        SET v_gate_failure = 'template 209970 already has a spawn';
    ELSEIF v_max_guid <> 609469 THEN
        SET v_gate_failure = CONCAT('gameobject GUID high-water must be 609469; found ', v_max_guid);
    ELSEIF v_candidate_guid_count <> 0 THEN
        SET v_gate_failure = 'candidate gameobject GUID 609470 is not free';
    ELSEIF v_engine_count <> 4 THEN
        SET v_gate_failure = 'owned table engines do not match the expected InnoDB/MyISAM split';
    ELSEIF v_new_version_count <> 0 THEN
        SET v_gate_failure = 'db_version row 23.03.006 already exists below the current version';
    END IF;

    IF v_gate_failure IS NOT NULL THEN
        SELECT '* UPDATE FAILED *' AS `Status`,
               v_gate_failure AS `Failed gate`,
               CONCAT(v_cur_version, '.', v_cur_structure, '.', v_cur_content) AS `Current version`;
        LEAVE main;
    END IF;

    write_block: BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 v_sql_message = MESSAGE_TEXT;
            ROLLBACK;

            DELETE FROM `phase_definitions`
             WHERE `zoneId` = 5736
               AND ((`entry` = 1 AND `phasemask` = 1 AND `phaseId` = 0
                     AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 0)
                 OR (`entry` = 2 AND `phasemask` = 16384 AND `phaseId` = 0
                     AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57817)
                 OR (`entry` = 3 AND `phasemask` = 32768 AND `phaseId` = 0
                     AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57816));

            SELECT '* UPDATE FAILED *' AS `Status`,
                   v_sql_message AS `SQL error`,
                   'InnoDB work rolled back; exact owned MyISAM phase rows removed' AS `Compensation`;
        END;

        START TRANSACTION;

        INSERT INTO `conditions`
            (`condition_entry`, `type`, `value1`, `value2`, `comments`) VALUES
            (57816, 8, 29406, 0, 'Quest 29406 rewarded: Sandy Fist temple gate is open'),
            (57817, -3, 57816, 0, 'Quest 29406 not rewarded: Sandy Fist temple gate is closed');

        UPDATE `gameobject_template`
           SET `flags` = 16
         WHERE `entry` = 209970
           AND `type` = 0
           AND `displayId` = 11014
           AND `faction` = 114
           AND `flags` = 0
           AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001
           AND `data0` = 0
           AND `data1` = 0
           AND `data2` = 3000
           AND NOT EXISTS (SELECT 1 FROM `gameobject` WHERE `id` = 209970);

        SET v_affected_rows = ROW_COUNT();
        IF v_affected_rows <> 1 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'template 209970 guarded update did not affect exactly one row';
        END IF;

        UPDATE `gameobject`
           SET `id` = 209970,
               `phaseMask` = 16384,
               `state` = 1
         WHERE `guid` = 600079
           AND `id` = 209972
           AND `map` = 860
           AND `spawnMask` = 1
           AND `phaseMask` = 1
           AND ABS(CAST(`position_x` AS DOUBLE) - 1446.98) <= 0.0005
           AND ABS(CAST(`position_y` AS DOUBLE) - 3389.89) <= 0.0005
           AND ABS(CAST(`position_z` AS DOUBLE) - 173.35) <= 0.0005
           AND ABS(CAST(`orientation` AS DOUBLE) - 1.23918) <= 0.000001
           AND `rotation0` = 0
           AND `rotation1` = 0
           AND ABS(CAST(`rotation2` AS DOUBLE) - 0.580701) <= 0.000001
           AND ABS(CAST(`rotation3` AS DOUBLE) - 0.814117) <= 0.000001
           AND `spawntimesecs` = 120
           AND `animprogress` = 255
           AND `state` = 0;

        SET v_affected_rows = ROW_COUNT();
        IF v_affected_rows <> 1 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'GUID 600079 guarded conversion did not affect exactly one row';
        END IF;

        INSERT INTO `gameobject`
            (`guid`, `id`, `map`, `spawnMask`, `phaseMask`,
             `position_x`, `position_y`, `position_z`, `orientation`,
             `rotation0`, `rotation1`, `rotation2`, `rotation3`,
             `spawntimesecs`, `animprogress`, `state`) VALUES
            (609470, 209972, 860, 1, 32768,
             1446.98, 3389.89, 173.35, 1.23918,
             0, 0, 0.580701, 0.814117,
             120, 255, 0);

        INSERT INTO `phase_definitions`
            (`zoneId`, `entry`, `phasemask`, `phaseId`, `terrainswapmap`, `flags`, `condition_id`, `comment`) VALUES
            (5736, 1, 1, 0, 0, 0, 0, 'Base Wandering Isle visibility retained for every player'),
            (5736, 2, 16384, 0, 0, 0, 57817, 'Closed Sandy Fist temple gate before quest 29406 reward'),
            (5736, 3, 32768, 0, 0, 0, 57816, 'Open Sandy Fist temple gate after quest 29406 reward');

        SELECT COUNT(*)
          INTO v_post_count
          FROM `conditions`
         WHERE `condition_entry` IN (57816, 57817);

        SELECT COUNT(*)
          INTO v_post_exact_count
          FROM `conditions`
         WHERE (`condition_entry` = 57816 AND `type` = 8 AND `value1` = 29406 AND `value2` = 0)
            OR (`condition_entry` = 57817 AND `type` = -3 AND `value1` = 57816 AND `value2` = 0);

        IF v_post_count <> 2 OR v_post_exact_count <> 2 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'condition postcondition failed';
        END IF;

        SELECT COUNT(*)
          INTO v_post_count
          FROM `phase_definitions`
         WHERE `zoneId` = 5736;

        SELECT COUNT(*)
          INTO v_post_exact_count
          FROM `phase_definitions`
         WHERE `zoneId` = 5736
           AND ((`entry` = 1 AND `phasemask` = 1 AND `phaseId` = 0
                 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 0)
             OR (`entry` = 2 AND `phasemask` = 16384 AND `phaseId` = 0
                 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57817)
             OR (`entry` = 3 AND `phasemask` = 32768 AND `phaseId` = 0
                 AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57816));

        IF v_post_count <> 3 OR v_post_exact_count <> 3 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'phase-definition postcondition failed';
        END IF;

        SELECT COUNT(*)
          INTO v_post_exact_count
          FROM `gameobject`
         WHERE (`guid` = 600079 AND `id` = 209970 AND `map` = 860
                AND `spawnMask` = 1 AND `phaseMask` = 16384
                AND ABS(CAST(`position_x` AS DOUBLE) - 1446.98) <= 0.0005
                AND ABS(CAST(`position_y` AS DOUBLE) - 3389.89) <= 0.0005
                AND ABS(CAST(`position_z` AS DOUBLE) - 173.35) <= 0.0005
                AND ABS(CAST(`orientation` AS DOUBLE) - 1.23918) <= 0.000001
                AND `rotation0` = 0 AND `rotation1` = 0
                AND ABS(CAST(`rotation2` AS DOUBLE) - 0.580701) <= 0.000001
                AND ABS(CAST(`rotation3` AS DOUBLE) - 0.814117) <= 0.000001
                AND `spawntimesecs` = 120 AND `animprogress` = 255 AND `state` = 1)
            OR (`guid` = 609470 AND `id` = 209972 AND `map` = 860
                AND `spawnMask` = 1 AND `phaseMask` = 32768
                AND ABS(CAST(`position_x` AS DOUBLE) - 1446.98) <= 0.0005
                AND ABS(CAST(`position_y` AS DOUBLE) - 3389.89) <= 0.0005
                AND ABS(CAST(`position_z` AS DOUBLE) - 173.35) <= 0.0005
                AND ABS(CAST(`orientation` AS DOUBLE) - 1.23918) <= 0.000001
                AND `rotation0` = 0 AND `rotation1` = 0
                AND ABS(CAST(`rotation2` AS DOUBLE) - 0.580701) <= 0.000001
                AND ABS(CAST(`rotation3` AS DOUBLE) - 0.814117) <= 0.000001
                AND `spawntimesecs` = 120 AND `animprogress` = 255 AND `state` = 0);

        SELECT COUNT(*)
          INTO v_post_count
          FROM `gameobject`
         WHERE `map` = 860
           AND (POW(`position_x` - 1446.98, 2)
              + POW(`position_y` - 3389.89, 2)
              + POW(`position_z` - 173.35, 2)) <= POW(0.25, 2);

        IF v_post_exact_count <> 2 OR v_post_count <> 2 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'gate-spawn postcondition failed';
        END IF;

        SELECT COUNT(*)
          INTO v_post_exact_count
          FROM `gameobject_template`
         WHERE `entry` = 209970
           AND `type` = 0
           AND `displayId` = 11014
           AND `faction` = 114
           AND `flags` = 16
           AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001
           AND `data0` = 0
           AND `data1` = 0
           AND `data2` = 3000;

        IF v_post_exact_count <> 1 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'closed-door template postcondition failed';
        END IF;

        INSERT INTO `db_version`
            (`version`, `structure`, `content`, `description`, `comment`) VALUES
            (23, 3, 6, 'Quest Conditioned Temple Door',
             'Replace the Sandy Fist temple gate per player after quest 29406 is rewarded');

        COMMIT;

        SELECT '* UPDATE COMPLETE *' AS `Status`,
               '23.03.006' AS `Database version`,
               'MyISAM phase rows published with guarded compensation' AS `Detail`;
    END write_block;
END main$$

DELIMITER ;

CALL `update_mangos`();
DROP PROCEDURE IF EXISTS `update_mangos`;

-- Operator verification: these selects are intentionally read-only and run
-- after both a successful update and a guarded skip/failure.
SELECT `condition_entry`, `type`, `value1`, `value2`, `comments`
  FROM `conditions`
 WHERE `condition_entry` IN (57816, 57817)
 ORDER BY `condition_entry`;

SELECT `zoneId`, `entry`, `phasemask`, `phaseId`, `terrainswapmap`, `flags`, `condition_id`, `comment`
  FROM `phase_definitions`
 WHERE `zoneId` = 5736
 ORDER BY `entry`;

SELECT `guid`, `id`, `map`, `spawnMask`, `phaseMask`,
       `position_x`, `position_y`, `position_z`, `orientation`,
       `rotation0`, `rotation1`, `rotation2`, `rotation3`,
       `spawntimesecs`, `animprogress`, `state`
  FROM `gameobject`
 WHERE `guid` IN (600079, 609470)
 ORDER BY `guid`;

SELECT `entry`, `type`, `displayId`, `faction`, `flags`, `size`, `data0`, `data1`, `data2`
  FROM `gameobject_template`
 WHERE `entry` IN (209970, 209972)
 ORDER BY `entry`;

SELECT `version`, `structure`, `content`, `description`, `comment`
  FROM `db_version`
 ORDER BY `version` DESC, `structure` DESC, `content` DESC
 LIMIT 1;

-- -------------------------------------------------------------------------
-- MANUAL COMPENSATING ROLLBACK (copy and execute separately when required)
--
-- This deliberately does not remove or decrement db_version 23.03.006.
-- Version-history handling remains an operator deployment-policy decision.
-- Every mutation below is guarded by the exact values owned by this update.
-- -------------------------------------------------------------------------
/*
DROP PROCEDURE IF EXISTS `rollback_quest_conditioned_temple_door`;

DELIMITER $$

CREATE PROCEDURE `rollback_quest_conditioned_temple_door`()
BEGIN
    DECLARE v_phase_rows INT DEFAULT 0;
    DECLARE v_open_rows INT DEFAULT 0;
    DECLARE v_closed_rows INT DEFAULT 0;
    DECLARE v_template_rows INT DEFAULT 0;
    DECLARE v_not_condition_rows INT DEFAULT 0;
    DECLARE v_reward_condition_rows INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT '* ROLLBACK FAILED *' AS `Status`;
    END;

    START TRANSACTION;

    DELETE FROM `phase_definitions`
     WHERE `zoneId` = 5736
       AND ((`entry` = 1 AND `phasemask` = 1 AND `phaseId` = 0
             AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 0)
         OR (`entry` = 2 AND `phasemask` = 16384 AND `phaseId` = 0
             AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57817)
         OR (`entry` = 3 AND `phasemask` = 32768 AND `phaseId` = 0
             AND `terrainswapmap` = 0 AND `flags` = 0 AND `condition_id` = 57816));
    SET v_phase_rows = ROW_COUNT();

    DELETE FROM `gameobject`
     WHERE `guid` = 609470
       AND `id` = 209972
       AND `map` = 860
       AND `spawnMask` = 1
       AND `phaseMask` = 32768
       AND ABS(CAST(`position_x` AS DOUBLE) - 1446.98) <= 0.0005
       AND ABS(CAST(`position_y` AS DOUBLE) - 3389.89) <= 0.0005
       AND ABS(CAST(`position_z` AS DOUBLE) - 173.35) <= 0.0005
       AND ABS(CAST(`orientation` AS DOUBLE) - 1.23918) <= 0.000001
       AND `rotation0` = 0
       AND `rotation1` = 0
       AND ABS(CAST(`rotation2` AS DOUBLE) - 0.580701) <= 0.000001
       AND ABS(CAST(`rotation3` AS DOUBLE) - 0.814117) <= 0.000001
       AND `spawntimesecs` = 120
       AND `animprogress` = 255
       AND `state` = 0;
    SET v_open_rows = ROW_COUNT();

    UPDATE `gameobject`
       SET `id` = 209972,
           `phaseMask` = 1,
           `state` = 0
     WHERE `guid` = 600079
       AND `id` = 209970
       AND `map` = 860
       AND `spawnMask` = 1
       AND `phaseMask` = 16384
       AND ABS(CAST(`position_x` AS DOUBLE) - 1446.98) <= 0.0005
       AND ABS(CAST(`position_y` AS DOUBLE) - 3389.89) <= 0.0005
       AND ABS(CAST(`position_z` AS DOUBLE) - 173.35) <= 0.0005
       AND ABS(CAST(`orientation` AS DOUBLE) - 1.23918) <= 0.000001
       AND `rotation0` = 0
       AND `rotation1` = 0
       AND ABS(CAST(`rotation2` AS DOUBLE) - 0.580701) <= 0.000001
       AND ABS(CAST(`rotation3` AS DOUBLE) - 0.814117) <= 0.000001
       AND `spawntimesecs` = 120
       AND `animprogress` = 255
       AND `state` = 1;
    SET v_closed_rows = ROW_COUNT();

    UPDATE `gameobject_template`
       SET `flags` = 0
     WHERE `entry` = 209970
       AND `type` = 0
       AND `displayId` = 11014
       AND `faction` = 114
       AND `flags` = 16
       AND ABS(CAST(`size` AS DOUBLE) - 0.9) <= 0.000001
       AND `data0` = 0
       AND `data1` = 0
       AND `data2` = 3000
       AND NOT EXISTS (SELECT 1 FROM `gameobject` WHERE `id` = 209970);
    SET v_template_rows = ROW_COUNT();

    DELETE owned
      FROM `conditions` owned
      LEFT JOIN `phase_definitions` phase_ref
        ON phase_ref.`condition_id` = owned.`condition_entry`
      LEFT JOIN `conditions` condition_ref
        ON condition_ref.`type` = -3
       AND condition_ref.`value1` = owned.`condition_entry`
       AND condition_ref.`condition_entry` <> owned.`condition_entry`
     WHERE owned.`condition_entry` = 57817
       AND owned.`type` = -3
       AND owned.`value1` = 57816
       AND owned.`value2` = 0
       AND phase_ref.`zoneId` IS NULL
       AND condition_ref.`condition_entry` IS NULL;
    SET v_not_condition_rows = ROW_COUNT();

    DELETE owned
      FROM `conditions` owned
      LEFT JOIN `phase_definitions` phase_ref
        ON phase_ref.`condition_id` = owned.`condition_entry`
      LEFT JOIN `conditions` condition_ref
        ON condition_ref.`type` = -3
       AND condition_ref.`value1` = owned.`condition_entry`
       AND condition_ref.`condition_entry` <> owned.`condition_entry`
     WHERE owned.`condition_entry` = 57816
       AND owned.`type` = 8
       AND owned.`value1` = 29406
       AND owned.`value2` = 0
       AND phase_ref.`zoneId` IS NULL
       AND condition_ref.`condition_entry` IS NULL;
    SET v_reward_condition_rows = ROW_COUNT();

    COMMIT;

    SELECT '* COMPENSATING ROLLBACK COMPLETE *' AS `Status`,
           v_phase_rows AS `phase rows removed`,
           v_open_rows AS `open spawns removed`,
           v_closed_rows AS `closed spawns restored`,
           v_template_rows AS `template flags restored`,
           v_not_condition_rows AS `NOT conditions removed`,
           v_reward_condition_rows AS `reward conditions removed`;
END$$

DELIMITER ;

CALL `rollback_quest_conditioned_temple_door`();
DROP PROCEDURE IF EXISTS `rollback_quest_conditioned_temple_door`;
*/
