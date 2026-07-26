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
    SET @cOldContent = '029';

    -- New Values
    SET @cNewVersion = '23';
    SET @cNewStructure = '02';
    SET @cNewContent = '030';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'pop_creature_classLevel';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'pop_creature_classLevel';

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

UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=83, `BaseDamageExp4`=0.2114 WHERE `Level`=1 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=83, `BaseDamageExp4`=0.2114 WHERE `Level`=1 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=83, `BaseDamageExp4`=0.2114 WHERE `Level`=1 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=83, `BaseDamageExp4`=0.2114 WHERE `Level`=1 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=114, `BaseDamageExp4`=0.2904 WHERE `Level`=2 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=114, `BaseDamageExp4`=0.2904 WHERE `Level`=2 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=114, `BaseDamageExp4`=0.2904 WHERE `Level`=2 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=114, `BaseDamageExp4`=0.2904 WHERE `Level`=2 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=141, `BaseDamageExp4`=0.3591 WHERE `Level`=3 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=141, `BaseDamageExp4`=0.3591 WHERE `Level`=3 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=141, `BaseDamageExp4`=0.3591 WHERE `Level`=3 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=141, `BaseDamageExp4`=0.3591 WHERE `Level`=3 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=163, `BaseDamageExp4`=0.4152 WHERE `Level`=4 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=163, `BaseDamageExp4`=0.4152 WHERE `Level`=4 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=163, `BaseDamageExp4`=0.4152 WHERE `Level`=4 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=163, `BaseDamageExp4`=0.4152 WHERE `Level`=4 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=200, `BaseDamageExp4`=0.5094 WHERE `Level`=5 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=200, `BaseDamageExp4`=0.5094 WHERE `Level`=5 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=200, `BaseDamageExp4`=0.5094 WHERE `Level`=5 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=200, `BaseDamageExp4`=0.5094 WHERE `Level`=5 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=236, `BaseDamageExp4`=0.6011 WHERE `Level`=6 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=236, `BaseDamageExp4`=0.6011 WHERE `Level`=6 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=236, `BaseDamageExp4`=0.6011 WHERE `Level`=6 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=236, `BaseDamageExp4`=0.6011 WHERE `Level`=6 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=248, `BaseDamageExp4`=0.6317 WHERE `Level`=7 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=248, `BaseDamageExp4`=0.6317 WHERE `Level`=7 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=248, `BaseDamageExp4`=0.6317 WHERE `Level`=7 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=248, `BaseDamageExp4`=0.6317 WHERE `Level`=7 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=285, `BaseDamageExp4`=0.7259 WHERE `Level`=8 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=285, `BaseDamageExp4`=0.7259 WHERE `Level`=8 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=285, `BaseDamageExp4`=0.7259 WHERE `Level`=8 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=285, `BaseDamageExp4`=0.7259 WHERE `Level`=8 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=321, `BaseDamageExp4`=0.8176 WHERE `Level`=9 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=321, `BaseDamageExp4`=0.8176 WHERE `Level`=9 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=321, `BaseDamageExp4`=0.8176 WHERE `Level`=9 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=321, `BaseDamageExp4`=0.8176 WHERE `Level`=9 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=334, `BaseDamageExp4`=0.8507 WHERE `Level`=10 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=334, `BaseDamageExp4`=0.8507 WHERE `Level`=10 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=334, `BaseDamageExp4`=0.8507 WHERE `Level`=10 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=334, `BaseDamageExp4`=0.8507 WHERE `Level`=10 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=370, `BaseDamageExp4`=0.9424 WHERE `Level`=11 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=370, `BaseDamageExp4`=0.9424 WHERE `Level`=11 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=370, `BaseDamageExp4`=0.9424 WHERE `Level`=11 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=370, `BaseDamageExp4`=0.9424 WHERE `Level`=11 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=407, `BaseDamageExp4`=1.0367 WHERE `Level`=12 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=407, `BaseDamageExp4`=1.0367 WHERE `Level`=12 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=407, `BaseDamageExp4`=1.0367 WHERE `Level`=12 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=407, `BaseDamageExp4`=1.0367 WHERE `Level`=12 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=419, `BaseDamageExp4`=1.0672 WHERE `Level`=13 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=419, `BaseDamageExp4`=1.0672 WHERE `Level`=13 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=419, `BaseDamageExp4`=1.0672 WHERE `Level`=13 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=419, `BaseDamageExp4`=1.0672 WHERE `Level`=13 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=455, `BaseDamageExp4`=1.1589 WHERE `Level`=14 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=455, `BaseDamageExp4`=1.1589 WHERE `Level`=14 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=455, `BaseDamageExp4`=1.1589 WHERE `Level`=14 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=455, `BaseDamageExp4`=1.1589 WHERE `Level`=14 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=492, `BaseDamageExp4`=1.2532 WHERE `Level`=15 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=492, `BaseDamageExp4`=1.2532 WHERE `Level`=15 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=492, `BaseDamageExp4`=1.2532 WHERE `Level`=15 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=492, `BaseDamageExp4`=1.2532 WHERE `Level`=15 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=504, `BaseDamageExp4`=1.2838 WHERE `Level`=16 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=504, `BaseDamageExp4`=1.2838 WHERE `Level`=16 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=504, `BaseDamageExp4`=1.2838 WHERE `Level`=16 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=504, `BaseDamageExp4`=1.2838 WHERE `Level`=16 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=541, `BaseDamageExp4`=1.378 WHERE `Level`=17 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=541, `BaseDamageExp4`=1.378 WHERE `Level`=17 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=541, `BaseDamageExp4`=1.378 WHERE `Level`=17 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=541, `BaseDamageExp4`=1.378 WHERE `Level`=17 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=577, `BaseDamageExp4`=1.4697 WHERE `Level`=18 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=577, `BaseDamageExp4`=1.4697 WHERE `Level`=18 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=577, `BaseDamageExp4`=1.4697 WHERE `Level`=18 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=577, `BaseDamageExp4`=1.4697 WHERE `Level`=18 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=589, `BaseDamageExp4`=1.5003 WHERE `Level`=19 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=589, `BaseDamageExp4`=1.5003 WHERE `Level`=19 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=589, `BaseDamageExp4`=1.5003 WHERE `Level`=19 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=589, `BaseDamageExp4`=1.5003 WHERE `Level`=19 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=626, `BaseDamageExp4`=1.5945 WHERE `Level`=20 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=626, `BaseDamageExp4`=1.5945 WHERE `Level`=20 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=626, `BaseDamageExp4`=1.5945 WHERE `Level`=20 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=626, `BaseDamageExp4`=1.5945 WHERE `Level`=20 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=662, `BaseDamageExp4`=1.6862 WHERE `Level`=21 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=662, `BaseDamageExp4`=1.6862 WHERE `Level`=21 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=662, `BaseDamageExp4`=1.6862 WHERE `Level`=21 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=662, `BaseDamageExp4`=1.6862 WHERE `Level`=21 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=674, `BaseDamageExp4`=1.7168 WHERE `Level`=22 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=674, `BaseDamageExp4`=1.7168 WHERE `Level`=22 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=674, `BaseDamageExp4`=1.7168 WHERE `Level`=22 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=674, `BaseDamageExp4`=1.7168 WHERE `Level`=22 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=711, `BaseDamageExp4`=1.811 WHERE `Level`=23 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=711, `BaseDamageExp4`=1.811 WHERE `Level`=23 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=711, `BaseDamageExp4`=1.811 WHERE `Level`=23 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=711, `BaseDamageExp4`=1.811 WHERE `Level`=23 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=738, `BaseDamageExp4`=1.8798 WHERE `Level`=24 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=738, `BaseDamageExp4`=1.8798 WHERE `Level`=24 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=738, `BaseDamageExp4`=1.8798 WHERE `Level`=24 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=738, `BaseDamageExp4`=1.8798 WHERE `Level`=24 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=774, `BaseDamageExp4`=1.9715 WHERE `Level`=25 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=774, `BaseDamageExp4`=1.9715 WHERE `Level`=25 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=774, `BaseDamageExp4`=1.9715 WHERE `Level`=25 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=774, `BaseDamageExp4`=1.9715 WHERE `Level`=25 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=818, `BaseDamageExp4`=2.0836 WHERE `Level`=26 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=818, `BaseDamageExp4`=2.0836 WHERE `Level`=26 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=818, `BaseDamageExp4`=2.0836 WHERE `Level`=26 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=818, `BaseDamageExp4`=2.0836 WHERE `Level`=26 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=879, `BaseDamageExp4`=2.2389 WHERE `Level`=27 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=879, `BaseDamageExp4`=2.2389 WHERE `Level`=27 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=879, `BaseDamageExp4`=2.2389 WHERE `Level`=27 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=879, `BaseDamageExp4`=2.2389 WHERE `Level`=27 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=923, `BaseDamageExp4`=2.351 WHERE `Level`=28 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=923, `BaseDamageExp4`=2.351 WHERE `Level`=28 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=923, `BaseDamageExp4`=2.351 WHERE `Level`=28 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=923, `BaseDamageExp4`=2.351 WHERE `Level`=28 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=969, `BaseDamageExp4`=2.4682 WHERE `Level`=29 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=969, `BaseDamageExp4`=2.4682 WHERE `Level`=29 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=969, `BaseDamageExp4`=2.4682 WHERE `Level`=29 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=969, `BaseDamageExp4`=2.4682 WHERE `Level`=29 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1042, `BaseDamageExp4`=2.6541 WHERE `Level`=30 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1042, `BaseDamageExp4`=2.6541 WHERE `Level`=30 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1042, `BaseDamageExp4`=2.6541 WHERE `Level`=30 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1042, `BaseDamageExp4`=2.6541 WHERE `Level`=30 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1098, `BaseDamageExp4`=2.7967 WHERE `Level`=31 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1098, `BaseDamageExp4`=2.7967 WHERE `Level`=31 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1098, `BaseDamageExp4`=2.7967 WHERE `Level`=31 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1098, `BaseDamageExp4`=2.7967 WHERE `Level`=31 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1157, `BaseDamageExp4`=2.947 WHERE `Level`=32 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1157, `BaseDamageExp4`=2.947 WHERE `Level`=32 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1157, `BaseDamageExp4`=2.947 WHERE `Level`=32 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1157, `BaseDamageExp4`=2.947 WHERE `Level`=32 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1218, `BaseDamageExp4`=3.1024 WHERE `Level`=33 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1218, `BaseDamageExp4`=3.1024 WHERE `Level`=33 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1218, `BaseDamageExp4`=3.1024 WHERE `Level`=33 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1218, `BaseDamageExp4`=3.1024 WHERE `Level`=33 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1281, `BaseDamageExp4`=3.2629 WHERE `Level`=34 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1281, `BaseDamageExp4`=3.2629 WHERE `Level`=34 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1281, `BaseDamageExp4`=3.2629 WHERE `Level`=34 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1281, `BaseDamageExp4`=3.2629 WHERE `Level`=34 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1347, `BaseDamageExp4`=3.431 WHERE `Level`=35 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1347, `BaseDamageExp4`=3.431 WHERE `Level`=35 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1347, `BaseDamageExp4`=3.431 WHERE `Level`=35 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1347, `BaseDamageExp4`=3.431 WHERE `Level`=35 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1415, `BaseDamageExp4`=3.6042 WHERE `Level`=36 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1415, `BaseDamageExp4`=3.6042 WHERE `Level`=36 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1415, `BaseDamageExp4`=3.6042 WHERE `Level`=36 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1415, `BaseDamageExp4`=3.6042 WHERE `Level`=36 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1485, `BaseDamageExp4`=3.7825 WHERE `Level`=37 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1485, `BaseDamageExp4`=3.7825 WHERE `Level`=37 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1485, `BaseDamageExp4`=3.7825 WHERE `Level`=37 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1485, `BaseDamageExp4`=3.7825 WHERE `Level`=37 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1558, `BaseDamageExp4`=3.9684 WHERE `Level`=38 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1558, `BaseDamageExp4`=3.9684 WHERE `Level`=38 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1558, `BaseDamageExp4`=3.9684 WHERE `Level`=38 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1558, `BaseDamageExp4`=3.9684 WHERE `Level`=38 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1634, `BaseDamageExp4`=4.162 WHERE `Level`=39 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1634, `BaseDamageExp4`=4.162 WHERE `Level`=39 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1634, `BaseDamageExp4`=4.162 WHERE `Level`=39 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1634, `BaseDamageExp4`=4.162 WHERE `Level`=39 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1712, `BaseDamageExp4`=4.3607 WHERE `Level`=40 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1712, `BaseDamageExp4`=4.3607 WHERE `Level`=40 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1712, `BaseDamageExp4`=4.3607 WHERE `Level`=40 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1712, `BaseDamageExp4`=4.3607 WHERE `Level`=40 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1792, `BaseDamageExp4`=4.5645 WHERE `Level`=41 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1792, `BaseDamageExp4`=4.5645 WHERE `Level`=41 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1792, `BaseDamageExp4`=4.5645 WHERE `Level`=41 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1792, `BaseDamageExp4`=4.5645 WHERE `Level`=41 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1875, `BaseDamageExp4`=4.7759 WHERE `Level`=42 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1875, `BaseDamageExp4`=4.7759 WHERE `Level`=42 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1875, `BaseDamageExp4`=4.7759 WHERE `Level`=42 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1875, `BaseDamageExp4`=4.7759 WHERE `Level`=42 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1960, `BaseDamageExp4`=4.9924 WHERE `Level`=43 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1960, `BaseDamageExp4`=4.9924 WHERE `Level`=43 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1960, `BaseDamageExp4`=4.9924 WHERE `Level`=43 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=1960, `BaseDamageExp4`=4.9924 WHERE `Level`=43 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2048, `BaseDamageExp4`=5.2165 WHERE `Level`=44 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2048, `BaseDamageExp4`=5.2165 WHERE `Level`=44 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2048, `BaseDamageExp4`=5.2165 WHERE `Level`=44 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2048, `BaseDamageExp4`=5.2165 WHERE `Level`=44 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2138, `BaseDamageExp4`=5.4458 WHERE `Level`=45 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2138, `BaseDamageExp4`=5.4458 WHERE `Level`=45 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2138, `BaseDamageExp4`=5.4458 WHERE `Level`=45 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2138, `BaseDamageExp4`=5.4458 WHERE `Level`=45 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2230, `BaseDamageExp4`=5.6801 WHERE `Level`=46 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2230, `BaseDamageExp4`=5.6801 WHERE `Level`=46 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2230, `BaseDamageExp4`=5.6801 WHERE `Level`=46 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2230, `BaseDamageExp4`=5.6801 WHERE `Level`=46 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2325, `BaseDamageExp4`=5.9221 WHERE `Level`=47 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2325, `BaseDamageExp4`=5.9221 WHERE `Level`=47 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2325, `BaseDamageExp4`=5.9221 WHERE `Level`=47 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2325, `BaseDamageExp4`=5.9221 WHERE `Level`=47 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2423, `BaseDamageExp4`=6.1717 WHERE `Level`=48 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2423, `BaseDamageExp4`=6.1717 WHERE `Level`=48 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2423, `BaseDamageExp4`=6.1717 WHERE `Level`=48 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2423, `BaseDamageExp4`=6.1717 WHERE `Level`=48 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2506, `BaseDamageExp4`=6.3831 WHERE `Level`=49 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2506, `BaseDamageExp4`=6.3831 WHERE `Level`=49 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2506, `BaseDamageExp4`=6.3831 WHERE `Level`=49 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2506, `BaseDamageExp4`=6.3831 WHERE `Level`=49 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2627, `BaseDamageExp4`=6.6913 WHERE `Level`=50 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2627, `BaseDamageExp4`=6.6913 WHERE `Level`=50 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2627, `BaseDamageExp4`=6.6913 WHERE `Level`=50 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2627, `BaseDamageExp4`=6.6913 WHERE `Level`=50 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2754, `BaseDamageExp4`=7.0148 WHERE `Level`=51 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2754, `BaseDamageExp4`=7.0148 WHERE `Level`=51 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2754, `BaseDamageExp4`=7.0148 WHERE `Level`=51 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2754, `BaseDamageExp4`=7.0148 WHERE `Level`=51 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2885, `BaseDamageExp4`=7.3485 WHERE `Level`=52 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2885, `BaseDamageExp4`=7.3485 WHERE `Level`=52 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2885, `BaseDamageExp4`=7.3485 WHERE `Level`=52 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=2885, `BaseDamageExp4`=7.3485 WHERE `Level`=52 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3022, `BaseDamageExp4`=7.6974 WHERE `Level`=53 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3022, `BaseDamageExp4`=7.6974 WHERE `Level`=53 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3022, `BaseDamageExp4`=7.6974 WHERE `Level`=53 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3022, `BaseDamageExp4`=7.6974 WHERE `Level`=53 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3163, `BaseDamageExp4`=8.0566 WHERE `Level`=54 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3163, `BaseDamageExp4`=8.0566 WHERE `Level`=54 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3163, `BaseDamageExp4`=8.0566 WHERE `Level`=54 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3163, `BaseDamageExp4`=8.0566 WHERE `Level`=54 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3309, `BaseDamageExp4`=8.4284 WHERE `Level`=55 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3309, `BaseDamageExp4`=8.4284 WHERE `Level`=55 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3309, `BaseDamageExp4`=8.4284 WHERE `Level`=55 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3309, `BaseDamageExp4`=8.4284 WHERE `Level`=55 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3460, `BaseDamageExp4`=8.8131 WHERE `Level`=56 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3460, `BaseDamageExp4`=8.8131 WHERE `Level`=56 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3460, `BaseDamageExp4`=8.8131 WHERE `Level`=56 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3460, `BaseDamageExp4`=8.8131 WHERE `Level`=56 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3616, `BaseDamageExp4`=9.2104 WHERE `Level`=57 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3616, `BaseDamageExp4`=9.2104 WHERE `Level`=57 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3616, `BaseDamageExp4`=9.2104 WHERE `Level`=57 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3616, `BaseDamageExp4`=9.2104 WHERE `Level`=57 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3680, `BaseDamageExp4`=9.3734 WHERE `Level`=58 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3680, `BaseDamageExp4`=9.3734 WHERE `Level`=58 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3680, `BaseDamageExp4`=9.3734 WHERE `Level`=58 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3680, `BaseDamageExp4`=9.3734 WHERE `Level`=58 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3743, `BaseDamageExp4`=9.5339 WHERE `Level`=59 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3743, `BaseDamageExp4`=9.5339 WHERE `Level`=59 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3743, `BaseDamageExp4`=9.5339 WHERE `Level`=59 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3743, `BaseDamageExp4`=9.5339 WHERE `Level`=59 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3807, `BaseDamageExp4`=9.6969 WHERE `Level`=60 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3807, `BaseDamageExp4`=9.6969 WHERE `Level`=60 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3807, `BaseDamageExp4`=9.6969 WHERE `Level`=60 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3807, `BaseDamageExp4`=9.6969 WHERE `Level`=60 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3871, `BaseDamageExp4`=9.8599 WHERE `Level`=61 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3871, `BaseDamageExp4`=9.8599 WHERE `Level`=61 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3871, `BaseDamageExp4`=9.8599 WHERE `Level`=61 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3871, `BaseDamageExp4`=9.8599 WHERE `Level`=61 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3934, `BaseDamageExp4`=10.0204 WHERE `Level`=62 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3934, `BaseDamageExp4`=10.0204 WHERE `Level`=62 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3934, `BaseDamageExp4`=10.0204 WHERE `Level`=62 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3934, `BaseDamageExp4`=10.0204 WHERE `Level`=62 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3998, `BaseDamageExp4`=10.1834 WHERE `Level`=63 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3998, `BaseDamageExp4`=10.1834 WHERE `Level`=63 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3998, `BaseDamageExp4`=10.1834 WHERE `Level`=63 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=3998, `BaseDamageExp4`=10.1834 WHERE `Level`=63 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4062, `BaseDamageExp4`=10.3464 WHERE `Level`=64 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4062, `BaseDamageExp4`=10.3464 WHERE `Level`=64 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4062, `BaseDamageExp4`=10.3464 WHERE `Level`=64 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4062, `BaseDamageExp4`=10.3464 WHERE `Level`=64 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4126, `BaseDamageExp4`=10.5095 WHERE `Level`=65 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4126, `BaseDamageExp4`=10.5095 WHERE `Level`=65 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4126, `BaseDamageExp4`=10.5095 WHERE `Level`=65 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4126, `BaseDamageExp4`=10.5095 WHERE `Level`=65 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4189, `BaseDamageExp4`=10.6699 WHERE `Level`=66 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4189, `BaseDamageExp4`=10.6699 WHERE `Level`=66 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4189, `BaseDamageExp4`=10.6699 WHERE `Level`=66 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4189, `BaseDamageExp4`=10.6699 WHERE `Level`=66 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4253, `BaseDamageExp4`=10.8329 WHERE `Level`=67 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4253, `BaseDamageExp4`=10.8329 WHERE `Level`=67 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4253, `BaseDamageExp4`=10.8329 WHERE `Level`=67 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4253, `BaseDamageExp4`=10.8329 WHERE `Level`=67 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4317, `BaseDamageExp4`=10.996 WHERE `Level`=68 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4317, `BaseDamageExp4`=10.996 WHERE `Level`=68 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4317, `BaseDamageExp4`=10.996 WHERE `Level`=68 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4317, `BaseDamageExp4`=10.996 WHERE `Level`=68 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4380, `BaseDamageExp4`=11.1564 WHERE `Level`=69 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4380, `BaseDamageExp4`=11.1564 WHERE `Level`=69 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4380, `BaseDamageExp4`=11.1564 WHERE `Level`=69 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4380, `BaseDamageExp4`=11.1564 WHERE `Level`=69 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4444, `BaseDamageExp4`=11.3194 WHERE `Level`=70 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4444, `BaseDamageExp4`=11.3194 WHERE `Level`=70 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4444, `BaseDamageExp4`=11.3194 WHERE `Level`=70 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4444, `BaseDamageExp4`=11.3194 WHERE `Level`=70 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4720, `BaseDamageExp4`=12.0224 WHERE `Level`=71 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4720, `BaseDamageExp4`=12.0224 WHERE `Level`=71 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4720, `BaseDamageExp4`=12.0224 WHERE `Level`=71 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=4720, `BaseDamageExp4`=12.0224 WHERE `Level`=71 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=5013, `BaseDamageExp4`=12.7688 WHERE `Level`=72 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=5013, `BaseDamageExp4`=12.7688 WHERE `Level`=72 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=5013, `BaseDamageExp4`=12.7688 WHERE `Level`=72 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=5013, `BaseDamageExp4`=12.7688 WHERE `Level`=72 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=5325, `BaseDamageExp4`=13.5635 WHERE `Level`=73 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=5325, `BaseDamageExp4`=13.5635 WHERE `Level`=73 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=5325, `BaseDamageExp4`=13.5635 WHERE `Level`=73 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=5325, `BaseDamageExp4`=13.5635 WHERE `Level`=73 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=5656, `BaseDamageExp4`=14.4066 WHERE `Level`=74 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=5656, `BaseDamageExp4`=14.4066 WHERE `Level`=74 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=5656, `BaseDamageExp4`=14.4066 WHERE `Level`=74 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=5656, `BaseDamageExp4`=14.4066 WHERE `Level`=74 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=6008, `BaseDamageExp4`=15.3031 WHERE `Level`=75 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=6008, `BaseDamageExp4`=15.3031 WHERE `Level`=75 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=6008, `BaseDamageExp4`=15.3031 WHERE `Level`=75 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=6008, `BaseDamageExp4`=15.3031 WHERE `Level`=75 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=6381, `BaseDamageExp4`=16.2532 WHERE `Level`=76 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=6381, `BaseDamageExp4`=16.2532 WHERE `Level`=76 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=6381, `BaseDamageExp4`=16.2532 WHERE `Level`=76 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=6381, `BaseDamageExp4`=16.2532 WHERE `Level`=76 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=6778, `BaseDamageExp4`=17.2644 WHERE `Level`=77 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=6778, `BaseDamageExp4`=17.2644 WHERE `Level`=77 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=6778, `BaseDamageExp4`=17.2644 WHERE `Level`=77 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=6778, `BaseDamageExp4`=17.2644 WHERE `Level`=77 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=7199, `BaseDamageExp4`=18.3368 WHERE `Level`=78 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=7199, `BaseDamageExp4`=18.3368 WHERE `Level`=78 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=7199, `BaseDamageExp4`=18.3368 WHERE `Level`=78 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=7199, `BaseDamageExp4`=18.3368 WHERE `Level`=78 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=7646, `BaseDamageExp4`=19.4753 WHERE `Level`=79 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=7646, `BaseDamageExp4`=19.4753 WHERE `Level`=79 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=7646, `BaseDamageExp4`=19.4753 WHERE `Level`=79 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=7646, `BaseDamageExp4`=19.4753 WHERE `Level`=79 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=8121, `BaseDamageExp4`=20.6852 WHERE `Level`=80 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=8121, `BaseDamageExp4`=20.6852 WHERE `Level`=80 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=8121, `BaseDamageExp4`=20.6852 WHERE `Level`=80 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=8121, `BaseDamageExp4`=20.6852 WHERE `Level`=80 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=11349, `BaseDamageExp4`=28.9074 WHERE `Level`=81 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=11349, `BaseDamageExp4`=28.9074 WHERE `Level`=81 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=11349, `BaseDamageExp4`=28.9074 WHERE `Level`=81 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=11349, `BaseDamageExp4`=28.9074 WHERE `Level`=81 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=15860, `BaseDamageExp4`=40.3975 WHERE `Level`=82 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=15860, `BaseDamageExp4`=40.3975 WHERE `Level`=82 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=15860, `BaseDamageExp4`=40.3975 WHERE `Level`=82 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=15860, `BaseDamageExp4`=40.3975 WHERE `Level`=82 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=22164, `BaseDamageExp4`=56.4546 WHERE `Level`=83 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=22164, `BaseDamageExp4`=56.4546 WHERE `Level`=83 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=22164, `BaseDamageExp4`=56.4546 WHERE `Level`=83 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=22164, `BaseDamageExp4`=56.4546 WHERE `Level`=83 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=30974, `BaseDamageExp4`=78.8948 WHERE `Level`=84 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=30974, `BaseDamageExp4`=78.8948 WHERE `Level`=84 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=30974, `BaseDamageExp4`=78.8948 WHERE `Level`=84 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=30974, `BaseDamageExp4`=78.8948 WHERE `Level`=84 AND `Class`=8;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=43285, `BaseDamageExp4`=110.2525 WHERE `Level`=85 AND `Class`=1;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=43285, `BaseDamageExp4`=110.2525 WHERE `Level`=85 AND `Class`=2;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=43285, `BaseDamageExp4`=110.2525 WHERE `Level`=85 AND `Class`=4;
UPDATE `creature_template_classlevelstats` SET `BaseHealthExp4`=43285, `BaseDamageExp4`=110.2525 WHERE `Level`=85 AND `Class`=8;
DELETE FROM `creature_template_classlevelstats` WHERE `Level` BETWEEN 86 AND 100;
INSERT INTO `creature_template_classlevelstats` (`Level`,`Class`,`BaseHealthExp0`,`BaseHealthExp1`,`BaseHealthExp2`,`BaseHealthExp3`,`BaseHealthExp4`,`BaseMana`,`BaseDamageExp0`,`BaseDamageExp1`,`BaseDamageExp2`,`BaseDamageExp3`,`BaseDamageExp4`,`BaseMeleeAttackPower`,`BaseRangedAttackPower`,`BaseArmor`) VALUES
(86,1,8840,8840,8840,8840,55250,0,140.7289,140.7289,140.7289,140.7289,140.7289,618.2,494.6,11679),
(86,2,8840,8840,8840,8840,55250,9094,140.7289,140.7289,140.7289,140.7289,140.7289,618.2,494.6,11590),
(86,4,8840,8840,8840,8840,55250,0,140.7289,140.7289,140.7289,140.7289,140.7289,618.2,494.6,10348),
(86,8,7072,7072,7072,7072,55250,9850,140.7289,140.7289,140.7289,140.7289,140.7289,618.2,494.6,9018),
(87,1,9585,9585,9585,9585,70523,0,179.6312,179.6312,179.6312,179.6312,179.6312,789,631.2,12034),
(87,2,9585,9585,9585,9585,70523,9310,179.6312,179.6312,179.6312,179.6312,179.6312,789,631.2,11949),
(87,4,9585,9585,9585,9585,70523,0,179.6312,179.6312,179.6312,179.6312,179.6312,789,631.2,10613),
(87,8,7668,7668,7668,7668,70523,10030,179.6312,179.6312,179.6312,179.6312,179.6312,789,631.2,9195),
(88,1,10174,10174,10174,10174,90017,0,229.2849,229.2849,229.2849,229.2849,229.2849,1007.2,805.8,12399),
(88,2,10174,10174,10174,10174,90017,9470,229.2849,229.2849,229.2849,229.2849,229.2849,1007.2,805.8,12319),
(88,4,10174,10174,10174,10174,90017,0,229.2849,229.2849,229.2849,229.2849,229.2849,1007.2,805.8,10884),
(88,8,8139,8139,8139,8139,90017,10213,229.2849,229.2849,229.2849,229.2849,229.2849,1007.2,805.8,9375),
(89,1,10883,10883,10883,10883,114901,0,292.6676,292.6676,292.6676,292.6676,292.6676,1285.6,1028.5,12775),
(89,2,10883,10883,10883,10883,114901,9692,292.6676,292.6676,292.6676,292.6676,292.6676,1285.6,1028.5,12700),
(89,4,10883,10883,10883,10883,114901,0,292.6676,292.6676,292.6676,292.6676,292.6676,1285.6,1028.5,11161),
(89,8,8706,8706,8706,8706,114901,10399,292.6676,292.6676,292.6676,292.6676,292.6676,1285.6,1028.5,9558),
(90,1,11494,11494,11494,11494,146663,0,373.5695,373.5695,373.5695,373.5695,373.5695,1640.9,1312.7,13162),
(90,2,11494,11494,11494,11494,146663,9916,373.5695,373.5695,373.5695,373.5695,373.5695,1640.9,1312.7,13092),
(90,4,11494,11494,11494,11494,146663,0,373.5695,373.5695,373.5695,373.5695,373.5695,1640.9,1312.7,11445),
(90,8,9195,9195,9195,9195,146663,10588,373.5695,373.5695,373.5695,373.5695,373.5695,1640.9,1312.7,9744),
(91,1,11891,11891,11891,11891,187204,0,476.8327,476.8327,476.8327,476.8327,476.8327,2094.5,1675.6,13560),
(91,2,11891,11891,11891,11891,187204,10145,476.8327,476.8327,476.8327,476.8327,476.8327,2094.5,1675.6,13496),
(91,4,11891,11891,11891,11891,187204,0,476.8327,476.8327,476.8327,476.8327,476.8327,2094.5,1675.6,11736),
(91,8,9513,9513,9513,9513,187204,10780,476.8327,476.8327,476.8327,476.8327,476.8327,2094.5,1675.6,9933),
(92,1,12301,12301,12301,12301,238953,0,608.644,608.644,608.644,608.644,608.644,2673.5,2138.8,13970),
(92,2,12301,12301,12301,12301,238953,10379,608.644,608.644,608.644,608.644,608.644,2673.5,2138.8,13912),
(92,4,12301,12301,12301,12301,238953,0,608.644,608.644,608.644,608.644,608.644,2673.5,2138.8,12034),
(92,8,9841,9841,9841,9841,238953,10975,608.644,608.644,608.644,608.644,608.644,2673.5,2138.8,10125),
(93,1,12725,12725,12725,12725,305006,0,776.8895,776.8895,776.8895,776.8895,776.8895,3412.6,2730.1,14392),
(93,2,12725,12725,12725,12725,305006,10618,776.8895,776.8895,776.8895,776.8895,776.8895,3412.6,2730.1,14340),
(93,4,12725,12725,12725,12725,305006,0,776.8895,776.8895,776.8895,776.8895,776.8895,3412.6,2730.1,12339),
(93,8,10180,10180,10180,10180,305006,11173,776.8895,776.8895,776.8895,776.8895,776.8895,3412.6,2730.1,10320),
(94,1,20481,20481,20481,20481,389318,0,991.643,991.643,991.643,991.643,991.643,4355.9,3484.7,14826),
(94,2,20481,20481,20481,20481,389318,10862,991.643,991.643,991.643,991.643,991.643,4355.9,3484.7,14781),
(94,4,20481,20481,20481,20481,389318,0,991.643,991.643,991.643,991.643,991.643,4355.9,3484.7,12651),
(94,8,16385,16385,16385,16385,389318,11374,991.643,991.643,991.643,991.643,991.643,4355.9,3484.7,10518),
(95,1,1,1,1,1,496937,0,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(95,2,1,1,1,1,496937,1,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(95,4,1,1,1,1,496937,0,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(95,8,1,1,1,1,496937,1,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(96,1,1,1,1,1,496937,0,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(96,2,1,1,1,1,496937,1,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(96,4,1,1,1,1,496937,0,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(96,8,1,1,1,1,496937,1,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(97,1,1,1,1,1,496937,0,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(97,2,1,1,1,1,496937,1,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(97,4,1,1,1,1,496937,0,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(97,8,1,1,1,1,496937,1,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(98,1,1,1,1,1,496937,0,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(98,2,1,1,1,1,496937,1,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(98,4,1,1,1,1,496937,0,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(98,8,1,1,1,1,496937,1,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(99,1,1,1,1,1,496937,0,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(99,2,1,1,1,1,496937,1,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(99,4,1,1,1,1,496937,0,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(99,8,1,1,1,1,496937,1,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(100,1,1,1,1,1,496937,0,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(100,2,1,1,1,1,496937,1,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(100,4,1,1,1,1,496937,0,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1),
(100,8,1,1,1,1,496937,1,1265.7625,1265.7625,1265.7625,1265.7625,1265.7625,5560,4448,1);

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


