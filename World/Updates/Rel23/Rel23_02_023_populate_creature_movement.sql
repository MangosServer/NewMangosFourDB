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
    SET @cOldContent = '022';

    -- New Values
    SET @cNewVersion = '23';
    SET @cNewStructure = '02';
    SET @cNewContent = '023';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'populate_creature_movement';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'populate_creature_movement';

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
-- Mangos4 conversion to MOP, phase 1: CREATURES
-- ============================================================================
SET NAMES utf8;
SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE='';

DELETE FROM `creature_movement` WHERE `id` BETWEEN 8500000 AND 8599999;
INSERT INTO `creature_movement` (`id`,`point`,`position_x`,`position_y`,`position_z`,`waittime`,`script_id`,`textid1`,`textid2`,`textid3`,`textid4`,`textid5`,`emote`,`spell`,`orientation`,`model1`,`model2`) VALUES
(8500433,1,1249.13,3454.83,103.564,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,2,1256.86,3455.24,104.493,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,3,1264.51,3458.41,105.212,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,4,1272.02,3462.19,105.429,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,5,1278.93,3467.93,104.811,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,6,1281.52,3473.01,104.007,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,7,1281.64,3478.48,103.147,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,8,1279.99,3489.91,101.098,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,9,1277.78,3500.26,98.5475,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,10,1273.72,3503.59,97.8382,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,11,1276.96,3516.68,95.2494,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,12,1276.56,3522.36,94.4618,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,13,1277.52,3529.94,93.6695,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,14,1280.08,3538.13,93.5984,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,15,1281.16,3542.92,93.7748,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,16,1283.16,3546.6,93.6833,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,17,1280.93,3554.82,92.8959,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,18,1283.96,3561.63,92.6974,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,19,1288.58,3567.83,91.9825,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,20,1303.82,3596.18,89.3944,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,21,1300.56,3586.43,89.9046,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,22,1295.78,3580.47,90.5702,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,23,1287.36,3569.26,92.0012,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,24,1283.53,3561.12,92.7272,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,25,1279.93,3553.41,93.0656,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,26,1278.7,3544.61,93.5958,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,27,1277.16,3533.58,93.6457,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,28,1275.06,3523.38,94.2346,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,29,1276.44,3510.94,95.9647,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,30,1278.51,3498.19,99.1174,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,31,1280.55,3488.46,101.418,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,32,1281.07,3477.09,103.346,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,33,1281.36,3467.77,105.138,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,34,1284.56,3461.19,107.257,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,35,1291.94,3453.17,110.7,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,36,1299.06,3447.67,113.27,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,37,1306.16,3444.22,115.04,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,38,1313.5,3435.57,117.749,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,39,1320.31,3426.35,120.396,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,40,1325.85,3419.41,121.761,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,41,1334.44,3413.73,123.295,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,42,1340.35,3403.41,124.419,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,43,1343.7,3387.74,125.126,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,44,1349.91,3377.52,125.492,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,45,1352.25,3365.31,126.179,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,46,1356.81,3355.38,126.952,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,47,1360.3,3342.95,127.785,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,48,1360.44,3327.92,129.235,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,49,1357.8,3315.53,129.774,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,50,1354.33,3306.15,130.233,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,51,1353.3,3295.28,130.811,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,52,1354.69,3287.23,131.226,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,53,1361.36,3277.02,131.369,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,54,1368.48,3274.2,131.63,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,55,1375.96,3271.82,132.197,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,56,1370.85,3273.61,131.785,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,57,1366.51,3276.06,131.385,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,58,1360.34,3280.27,131.344,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,59,1356.11,3285.41,131.363,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,60,1355.47,3292.22,131.131,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,61,1357.09,3297.61,130.745,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,62,1353.78,3304.52,130.293,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,63,1355.34,3310.56,130.098,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,64,1357.98,3317.83,129.686,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,65,1360.3,3324.48,129.505,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,66,1361.19,3331.42,129.042,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,67,1360.58,3339.86,128.111,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,68,1357.24,3342.74,127.887,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,69,1360.53,3351.98,127.245,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,70,1357.11,3358.5,126.766,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,71,1353.69,3365.59,126.254,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,72,1351.66,3371.24,125.842,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,73,1350.67,3378.94,125.377,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,74,1349.86,3385.3,125.165,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,75,1342.2,3395.27,124.755,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,76,1339.63,3403.9,124.394,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,77,1335.15,3413.65,123.366,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,78,1329.75,3418.93,122.194,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,79,1323.12,3423.36,120.952,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,80,1318.51,3425.09,120.444,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,81,1313.94,3426.07,120.446,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,82,1310.61,3438.9,116.719,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,83,1304.12,3446.72,114.253,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,84,1298.81,3449.3,112.813,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,85,1293.24,3453.55,110.769,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,86,1289.14,3459.11,108.671,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,87,1287.54,3464.89,106.939,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,88,1271.95,3460.98,105.688,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,89,1264.58,3456.45,105.357,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,90,1254.86,3454.89,104.289,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,91,1248.15,3456.35,103.448,0,0,0,0,0,0,0,0,0,0,0,0),
(8500433,92,1240.31,3458.16,102.724,0,0,0,0,0,0,0,0,0,0,0,0);

SET FOREIGN_KEY_CHECKS=1;


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


