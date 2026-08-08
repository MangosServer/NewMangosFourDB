-- Add the missing 5.4.8 dungeon entrance targets used by Dungeon Finder.
--
-- Destination evidence: decoded build-18414 SMSG_NEW_WORLD bodies under
-- MoPSniff catalogue generation
-- 2BE10C899585BAECD237705AC13BBF9262D81B6BDC085B462808C6869CE88752.
-- Each destination below is the dominant repeated arrival for its map; the
-- AreaTrigger IDs are present in the shipped build-18414 AreaTrigger.dbc.

DROP PROCEDURE IF EXISTS `update_mangos`;

DELIMITER $$

CREATE PROCEDURE `update_mangos`()
main: BEGIN
    DECLARE v_version INT DEFAULT NULL;
    DECLARE v_structure INT DEFAULT NULL;
    DECLARE v_content INT DEFAULT NULL;
    DECLARE v_count INT DEFAULT 0;
    DECLARE v_exact INT DEFAULT 0;
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

    IF v_version = 23 AND v_structure = 3 AND v_content = 9 THEN
        SELECT '* UPDATE SKIPPED *' AS `Status`,
               '23.03.009 is already current' AS `Detail`;
        LEAVE main;
    END IF;

    IF v_version IS NULL OR v_version <> 23 OR v_structure <> 3 OR v_content <> 8 THEN
        SELECT '* UPDATE FAILED *' AS `Status`,
               'database version must be exactly 23.03.008' AS `Failed gate`;
        LEAVE main;
    END IF;

    SELECT COUNT(*) INTO v_count
      FROM `information_schema`.`tables`
     WHERE `table_schema` = DATABASE()
       AND ((`table_name` = 'db_version' AND `engine` = 'InnoDB')
         OR (`table_name` = 'areatrigger_teleport' AND `engine` = 'InnoDB'));
    IF v_count <> 2 THEN
        SELECT '* UPDATE FAILED *' AS `Status`,
               'db_version and areatrigger_teleport must both be InnoDB' AS `Failed gate`;
        LEAVE main;
    END IF;

    SELECT COUNT(*) INTO v_count
      FROM `db_version`
     WHERE `version` = 23 AND `structure` = 3 AND `content` = 9;
    IF v_count <> 0 THEN
        SELECT '* UPDATE FAILED *' AS `Status`,
               'db_version row 23.03.009 already exists below current' AS `Failed gate`;
        LEAVE main;
    END IF;

    START TRANSACTION;

    DELETE FROM `areatrigger_teleport`
     WHERE `id` IN (45, 614, 2567, 7694, 7705, 7726, 7854, 8134, 8315);

    INSERT INTO `areatrigger_teleport`
        (`id`, `name`, `required_level`, `required_item`, `required_item2`,
         `heroic_key`, `heroic_key2`, `required_quest_done`,
         `required_quest_done_heroic`, `target_map`, `target_position_x`,
         `target_position_y`, `target_position_z`, `target_orientation`) VALUES
        -- capture-000059:66903; 15 of 16 map-959 arrivals
        (7694, 'Shado-Pan Monastery - Entrance Target', 0, 0, 0, 0, 0, 0, 0,
         959, 3657.2900390625, 2551.919921875, 766.9660034179688, 0.4363323152065277),
        -- capture-000059:548319; 17 of 17 map-960 arrivals
        (7854, 'Temple of the Jade Serpent - Entrance Target', 0, 0, 0, 0, 0, 0, 0,
         960, 953.3698120117188, -2487.5, 180.4305877685547, 4.369081020355225),
        -- capture-000059:440550; 13 of 14 map-961 arrivals
        (7705, 'Stormstout Brewery - Entrance Target', 0, 0, 0, 0, 0, 0, 0,
         961, -732.1145629882812, 1266.126708984375, 116.1080093383789, 1.8120787143707275),
        -- capture-000020:14050; 32 of 34 map-962 arrivals
        (7726, 'Gate of the Setting Sun - Entrance Target', 0, 0, 0, 0, 0, 0, 0,
         962, 722.0972290039062, 2108.085205078125, 402.9779968261719, 1.5926363468170166),
        -- capture-000059:1109779; 17 of 17 map-994 arrivals
        (8134, 'Mogu''shan Palace - Entrance Target', 0, 0, 0, 0, 0, 0, 0,
         994, -3969.670166015625, -2542.7119140625, 26.753700256347656, 4.71238899230957),
        -- capture-000059:6137; 11 of 11 map-1001 arrivals
        (614, 'Scarlet Halls - Entrance Target', 0, 0, 0, 0, 0, 0, 0,
         1001, 820.7430419921875, 607.8125, 13.638883590698242, 0),
        -- capture-000059:273582; 15 of 15 map-1004 arrivals
        (45, 'Scarlet Monastery - Entrance Target', 0, 0, 0, 0, 0, 0, 0,
         1004, 1124.6441650390625, 512.467041015625, 0.9895489811897278, 1.5707963705062866),
        -- capture-000059:193434; 11 of 11 map-1007 arrivals
        (2567, 'Scholomance - Entrance Target', 0, 0, 0, 0, 0, 0, 0,
         1007, 199.87600708007812, 125.34600067138672, 138.42999267578125, 4.6774821281433105),
        -- capture-000059:348818; 19 of 21 map-1011 arrivals
        (8315, 'Siege of Niuzao Temple - Entrance Target', 0, 0, 0, 0, 0, 0, 0,
         1011, 1463.904541015625, 5110.861328125, 156.8542022705078, 0);

    SELECT COUNT(*) INTO v_count
      FROM `areatrigger_teleport`
     WHERE `id` IN (45, 614, 2567, 7694, 7705, 7726, 7854, 8134, 8315);

    SELECT COUNT(*) INTO v_exact
      FROM `areatrigger_teleport`
     WHERE `required_level` = 0
       AND `required_item` = 0 AND `required_item2` = 0
       AND `heroic_key` = 0 AND `heroic_key2` = 0
       AND `required_quest_done` = 0 AND `required_quest_done_heroic` = 0
       AND (
            (`id` = 7694 AND `target_map` = 959
             AND ABS(`target_position_x` - 3657.2900390625) <= 0.001
             AND ABS(`target_position_y` - 2551.919921875) <= 0.001
             AND ABS(`target_position_z` - 766.9660034179688) <= 0.001
             AND ABS(`target_orientation` - 0.4363323152065277) <= 0.00001)
         OR (`id` = 7854 AND `target_map` = 960
             AND ABS(`target_position_x` - 953.3698120117188) <= 0.001
             AND ABS(`target_position_y` - (-2487.5)) <= 0.001
             AND ABS(`target_position_z` - 180.4305877685547) <= 0.001
             AND ABS(`target_orientation` - 4.369081020355225) <= 0.00001)
         OR (`id` = 7705 AND `target_map` = 961
             AND ABS(`target_position_x` - (-732.1145629882812)) <= 0.001
             AND ABS(`target_position_y` - 1266.126708984375) <= 0.001
             AND ABS(`target_position_z` - 116.1080093383789) <= 0.001
             AND ABS(`target_orientation` - 1.8120787143707275) <= 0.00001)
         OR (`id` = 7726 AND `target_map` = 962
             AND ABS(`target_position_x` - 722.0972290039062) <= 0.001
             AND ABS(`target_position_y` - 2108.085205078125) <= 0.001
             AND ABS(`target_position_z` - 402.9779968261719) <= 0.001
             AND ABS(`target_orientation` - 1.5926363468170166) <= 0.00001)
         OR (`id` = 8134 AND `target_map` = 994
             AND ABS(`target_position_x` - (-3969.670166015625)) <= 0.001
             AND ABS(`target_position_y` - (-2542.7119140625)) <= 0.001
             AND ABS(`target_position_z` - 26.753700256347656) <= 0.001
             AND ABS(`target_orientation` - 4.71238899230957) <= 0.00001)
         OR (`id` = 614 AND `target_map` = 1001
             AND ABS(`target_position_x` - 820.7430419921875) <= 0.001
             AND ABS(`target_position_y` - 607.8125) <= 0.001
             AND ABS(`target_position_z` - 13.638883590698242) <= 0.001
             AND ABS(`target_orientation`) <= 0.00001)
         OR (`id` = 45 AND `target_map` = 1004
             AND ABS(`target_position_x` - 1124.6441650390625) <= 0.001
             AND ABS(`target_position_y` - 512.467041015625) <= 0.001
             AND ABS(`target_position_z` - 0.9895489811897278) <= 0.001
             AND ABS(`target_orientation` - 1.5707963705062866) <= 0.00001)
         OR (`id` = 2567 AND `target_map` = 1007
             AND ABS(`target_position_x` - 199.87600708007812) <= 0.001
             AND ABS(`target_position_y` - 125.34600067138672) <= 0.001
             AND ABS(`target_position_z` - 138.42999267578125) <= 0.001
             AND ABS(`target_orientation` - 4.6774821281433105) <= 0.00001)
         OR (`id` = 8315 AND `target_map` = 1011
             AND ABS(`target_position_x` - 1463.904541015625) <= 0.001
             AND ABS(`target_position_y` - 5110.861328125) <= 0.001
             AND ABS(`target_position_z` - 156.8542022705078) <= 0.001
             AND ABS(`target_orientation`) <= 0.00001)
       );

    IF v_count <> 9 OR v_exact <> 9 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'MoP LFG entrance postcondition failed';
    END IF;

    INSERT INTO `db_version`
        (`version`, `structure`, `content`, `description`, `comment`) VALUES
        (23, 3, 9, 'Add MoP LFG Entrances',
         'Add nine build-18414 dungeon entrance targets for Dungeon Finder');

    COMMIT;
    SELECT '* UPDATE COMPLETE *' AS `Status`,
           '23.03.009' AS `Database version`,
           v_exact AS `Entrance rows`;
END main$$

DELIMITER ;

CALL `update_mangos`();
DROP PROCEDURE IF EXISTS `update_mangos`;

SELECT `id`, `target_map`, `target_position_x`, `target_position_y`,
       `target_position_z`, `target_orientation`
  FROM `areatrigger_teleport`
 WHERE `id` IN (45, 614, 2567, 7694, 7705, 7726, 7854, 8134, 8315)
 ORDER BY `target_map`;

SELECT `version`, `structure`, `content`, `description`
  FROM `db_version`
 ORDER BY `version` DESC, `structure` DESC, `content` DESC
 LIMIT 1;
