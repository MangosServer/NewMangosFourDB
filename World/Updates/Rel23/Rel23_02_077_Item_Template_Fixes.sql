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
    SET @cOldContent = '076';

    -- New Values
    SET @cNewVersion = '23';
    SET @cNewStructure = '02';
    SET @cNewContent = '077';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'item_template_Fixes';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'item_template_Fixes';

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

-- ============================================================
-- MaNGOS Four world DB update: item_template ⇄ Item.dbc/Item-sparse alignment
-- Fields where the 5.4.8 client DBC disagrees with DB. Values below are the client values reported by the core.
-- All statements are guarded (WHERE current value matches) and idempotent.
-- ============================================================

-- displayid: 136 item(s)
UPDATE `item_template` SET `displayid`=34561 WHERE `entry`=79246 AND `displayid`=99803;
UPDATE `item_template` SET `displayid`=119545 WHERE `entry`=79868 AND `displayid`=74730;
UPDATE `item_template` SET `displayid`=118081 WHERE `entry`=79869 AND `displayid`=74730;
UPDATE `item_template` SET `displayid`=113716 WHERE `entry`=81579 AND `displayid`=117475;
UPDATE `item_template` SET `displayid`=113716 WHERE `entry`=81583 AND `displayid`=117475;
UPDATE `item_template` SET `displayid`=118855 WHERE `entry`=81634 AND `displayid`=113796;
UPDATE `item_template` SET `displayid`=118855 WHERE `entry`=81638 AND `displayid`=113796;
UPDATE `item_template` SET `displayid`=114620 WHERE `entry`=81674 AND `displayid`=116936;
UPDATE `item_template` SET `displayid`=113716 WHERE `entry`=81969 AND `displayid`=117475;
UPDATE `item_template` SET `displayid`=118855 WHERE `entry`=81978 AND `displayid`=113796;
UPDATE `item_template` SET `displayid`=114604 WHERE `entry`=82008 AND `displayid`=116784;
UPDATE `item_template` SET `displayid`=113716 WHERE `entry`=82030 AND `displayid`=117475;
UPDATE `item_template` SET `displayid`=118855 WHERE `entry`=82040 AND `displayid`=113796;
UPDATE `item_template` SET `displayid`=114604 WHERE `entry`=82052 AND `displayid`=116784;
UPDATE `item_template` SET `displayid`=113716 WHERE `entry`=82085 AND `displayid`=117475;
UPDATE `item_template` SET `displayid`=118855 WHERE `entry`=82095 AND `displayid`=113796;
UPDATE `item_template` SET `displayid`=114604 WHERE `entry`=82107 AND `displayid`=116784;
UPDATE `item_template` SET `displayid`=114620 WHERE `entry`=82162 AND `displayid`=116936;
UPDATE `item_template` SET `displayid`=119807 WHERE `entry`=82180 AND `displayid`=107999;
UPDATE `item_template` SET `displayid`=114620 WHERE `entry`=82217 AND `displayid`=116936;
UPDATE `item_template` SET `displayid`=119807 WHERE `entry`=82235 AND `displayid`=107999;
UPDATE `item_template` SET `displayid`=115166 WHERE `entry`=82272 AND `displayid`=115253;
UPDATE `item_template` SET `displayid`=119807 WHERE `entry`=82290 AND `displayid`=107999;
UPDATE `item_template` SET `displayid`=119810 WHERE `entry`=82490 AND `displayid`=113867;
UPDATE `item_template` SET `displayid`=119810 WHERE `entry`=82494 AND `displayid`=113867;
UPDATE `item_template` SET `displayid`=119810 WHERE `entry`=82495 AND `displayid`=113867;
UPDATE `item_template` SET `displayid`=113533 WHERE `entry`=82600 AND `displayid`=116875;
UPDATE `item_template` SET `displayid`=119807 WHERE `entry`=82617 AND `displayid`=107999;
UPDATE `item_template` SET `displayid`=119807 WHERE `entry`=82621 AND `displayid`=107999;
UPDATE `item_template` SET `displayid`=119807 WHERE `entry`=82622 AND `displayid`=107999;
UPDATE `item_template` SET `displayid`=124325 WHERE `entry`=82709 AND `displayid`=115253;
UPDATE `item_template` SET `displayid`=119610 WHERE `entry`=83088 AND `displayid`=117143;
UPDATE `item_template` SET `displayid`=119809 WHERE `entry`=83161 AND `displayid`=108001;
UPDATE `item_template` SET `displayid`=119809 WHERE `entry`=83165 AND `displayid`=108001;
UPDATE `item_template` SET `displayid`=119809 WHERE `entry`=83166 AND `displayid`=108001;
UPDATE `item_template` SET `displayid`=115166 WHERE `entry`=83263 AND `displayid`=115253;
UPDATE `item_template` SET `displayid`=119806 WHERE `entry`=83647 AND `displayid`=113858;
UPDATE `item_template` SET `displayid`=119806 WHERE `entry`=83651 AND `displayid`=113858;
UPDATE `item_template` SET `displayid`=119806 WHERE `entry`=83652 AND `displayid`=113858;
UPDATE `item_template` SET `displayid`=114604 WHERE `entry`=83749 AND `displayid`=116784;
UPDATE `item_template` SET `displayid`=114620 WHERE `entry`=83756 AND `displayid`=116936;
UPDATE `item_template` SET `displayid`=119806 WHERE `entry`=83986 AND `displayid`=113858;
UPDATE `item_template` SET `displayid`=119806 WHERE `entry`=83990 AND `displayid`=113858;
UPDATE `item_template` SET `displayid`=119806 WHERE `entry`=83991 AND `displayid`=113858;
UPDATE `item_template` SET `displayid`=115166 WHERE `entry`=84088 AND `displayid`=115253;
UPDATE `item_template` SET `displayid`=126165 WHERE `entry`=84353 AND `displayid`=114981;
UPDATE `item_template` SET `displayid`=119806 WHERE `entry`=84590 AND `displayid`=113858;
UPDATE `item_template` SET `displayid`=119806 WHERE `entry`=84594 AND `displayid`=113858;
UPDATE `item_template` SET `displayid`=119806 WHERE `entry`=84595 AND `displayid`=113858;
UPDATE `item_template` SET `displayid`=119806 WHERE `entry`=84620 AND `displayid`=113858;
UPDATE `item_template` SET `displayid`=119806 WHERE `entry`=84624 AND `displayid`=113858;
UPDATE `item_template` SET `displayid`=119806 WHERE `entry`=84625 AND `displayid`=113858;
UPDATE `item_template` SET `displayid`=110788 WHERE `entry`=84697 AND `displayid`=100387;
UPDATE `item_template` SET `displayid`=110788 WHERE `entry`=84698 AND `displayid`=100387;
UPDATE `item_template` SET `displayid`=126825 WHERE `entry`=84721 AND `displayid`=111026;
UPDATE `item_template` SET `displayid`=126717 WHERE `entry`=84785 AND `displayid`=111028;
UPDATE `item_template` SET `displayid`=110788 WHERE `entry`=84893 AND `displayid`=100387;
UPDATE `item_template` SET `displayid`=110788 WHERE `entry`=84894 AND `displayid`=100387;
UPDATE `item_template` SET `displayid`=126697 WHERE `entry`=85107 AND `displayid`=111029;
UPDATE `item_template` SET `displayid`=110788 WHERE `entry`=85116 AND `displayid`=100387;
UPDATE `item_template` SET `displayid`=110788 WHERE `entry`=85117 AND `displayid`=100387;
UPDATE `item_template` SET `displayid`=113277 WHERE `entry`=85308 AND `displayid`=111917;
UPDATE `item_template` SET `displayid`=109508 WHERE `entry`=85320 AND `displayid`=116467;
UPDATE `item_template` SET `displayid`=109506 WHERE `entry`=85322 AND `displayid`=116466;
UPDATE `item_template` SET `displayid`=109505 WHERE `entry`=85323 AND `displayid`=116465;
UPDATE `item_template` SET `displayid`=109508 WHERE `entry`=85340 AND `displayid`=116467;
UPDATE `item_template` SET `displayid`=109506 WHERE `entry`=85342 AND `displayid`=116466;
UPDATE `item_template` SET `displayid`=109505 WHERE `entry`=85343 AND `displayid`=116465;
UPDATE `item_template` SET `displayid`=109508 WHERE `entry`=85345 AND `displayid`=116467;
UPDATE `item_template` SET `displayid`=109506 WHERE `entry`=85347 AND `displayid`=116466;
UPDATE `item_template` SET `displayid`=109505 WHERE `entry`=85348 AND `displayid`=116465;
UPDATE `item_template` SET `displayid`=129112 WHERE `entry`=85500 AND `displayid`=110678;
UPDATE `item_template` SET `displayid`=53879 WHERE `entry`=85504 AND `displayid`=32650;
UPDATE `item_template` SET `displayid`=121168 WHERE `entry`=85510 AND `displayid`=113814;
UPDATE `item_template` SET `displayid`=118855 WHERE `entry`=85836 AND `displayid`=113796;
UPDATE `item_template` SET `displayid`=114167 WHERE `entry`=85978 AND `displayid`=108303;
UPDATE `item_template` SET `displayid`=118040 WHERE `entry`=85997 AND `displayid`=108304;
UPDATE `item_template` SET `displayid`=119366 WHERE `entry`=86086 AND `displayid`=111179;
UPDATE `item_template` SET `displayid`=118149 WHERE `entry`=86129 AND `displayid`=117735;
UPDATE `item_template` SET `displayid`=119367 WHERE `entry`=86134 AND `displayid`=111187;
UPDATE `item_template` SET `displayid`=114175 WHERE `entry`=86151 AND `displayid`=114144;
UPDATE `item_template` SET `displayid`=119829 WHERE `entry`=86335 AND `displayid`=111404;
UPDATE `item_template` SET `displayid`=119826 WHERE `entry`=86391 AND `displayid`=114531;
UPDATE `item_template` SET `displayid`=127135 WHERE `entry`=86524 AND `displayid`=112674;
UPDATE `item_template` SET `displayid`=119366 WHERE `entry`=86785 AND `displayid`=111179;
UPDATE `item_template` SET `displayid`=119367 WHERE `entry`=86793 AND `displayid`=111187;
UPDATE `item_template` SET `displayid`=109562 WHERE `entry`=86839 AND `displayid`=116743;
UPDATE `item_template` SET `displayid`=119828 WHERE `entry`=86893 AND `displayid`=111403;
UPDATE `item_template` SET `displayid`=119825 WHERE `entry`=86910 AND `displayid`=114530;
UPDATE `item_template` SET `displayid`=111909 WHERE `entry`=86923 AND `displayid`=116629;
UPDATE `item_template` SET `displayid`=111909 WHERE `entry`=86931 AND `displayid`=116629;
UPDATE `item_template` SET `displayid`=111909 WHERE `entry`=86936 AND `displayid`=116629;
UPDATE `item_template` SET `displayid`=111909 WHERE `entry`=86938 AND `displayid`=116629;
UPDATE `item_template` SET `displayid`=108312 WHERE `entry`=87017 AND `displayid`=102062;
UPDATE `item_template` SET `displayid`=117529 WHERE `entry`=87042 AND `displayid`=112207;
UPDATE `item_template` SET `displayid`=109474 WHERE `entry`=87051 AND `displayid`=102055;
UPDATE `item_template` SET `displayid`=118145 WHERE `entry`=87115 AND `displayid`=116172;
UPDATE `item_template` SET `displayid`=118144 WHERE `entry`=87120 AND `displayid`=116172;
UPDATE `item_template` SET `displayid`=119827 WHERE `entry`=87166 AND `displayid`=114532;
UPDATE `item_template` SET `displayid`=119830 WHERE `entry`=87170 AND `displayid`=116937;
UPDATE `item_template` SET `displayid`=114021 WHERE `entry`=87317 AND `displayid`=114664;
UPDATE `item_template` SET `displayid`=114020 WHERE `entry`=87321 AND `displayid`=114641;
UPDATE `item_template` SET `displayid`=119808 WHERE `entry`=87322 AND `displayid`=108002;
UPDATE `item_template` SET `displayid`=119808 WHERE `entry`=87323 AND `displayid`=108002;
UPDATE `item_template` SET `displayid`=114931 WHERE `entry`=87458 AND `displayid`=82716;
UPDATE `item_template` SET `displayid`=110762 WHERE `entry`=87642 AND `displayid`=117305;
UPDATE `item_template` SET `displayid`=126658 WHERE `entry`=87774 AND `displayid`=73489;
UPDATE `item_template` SET `displayid`=119808 WHERE `entry`=88071 AND `displayid`=108002;
UPDATE `item_template` SET `displayid`=119808 WHERE `entry`=88072 AND `displayid`=108002;
UPDATE `item_template` SET `displayid`=119808 WHERE `entry`=88076 AND `displayid`=108002;
UPDATE `item_template` SET `displayid`=120336 WHERE `entry`=88174 AND `displayid`=115638;
UPDATE `item_template` SET `displayid`=119076 WHERE `entry`=88805 AND `displayid`=113046;
UPDATE `item_template` SET `displayid`=119368 WHERE `entry`=89055 AND `displayid`=111195;
UPDATE `item_template` SET `displayid`=119367 WHERE `entry`=89056 AND `displayid`=111187;
UPDATE `item_template` SET `displayid`=119366 WHERE `entry`=89057 AND `displayid`=111179;
UPDATE `item_template` SET `displayid`=121176 WHERE `entry`=89194 AND `displayid`=113809;
UPDATE `item_template` SET `displayid`=121177 WHERE `entry`=89195 AND `displayid`=113817;
UPDATE `item_template` SET `displayid`=127136 WHERE `entry`=89395 AND `displayid`=114132;
UPDATE `item_template` SET `displayid`=119638 WHERE `entry`=89401 AND `displayid`=114156;
UPDATE `item_template` SET `displayid`=112227 WHERE `entry`=89679 AND `displayid`=112252;
UPDATE `item_template` SET `displayid`=118991 WHERE `entry`=89739 AND `displayid`=108838;
UPDATE `item_template` SET `displayid`=119842 WHERE `entry`=89822 AND `displayid`=116189;
UPDATE `item_template` SET `displayid`=122594 WHERE `entry`=90118 AND `displayid`=41428;
UPDATE `item_template` SET `displayid`=25466 WHERE `entry`=90135 AND `displayid`=112115;
UPDATE `item_template` SET `displayid`=118911 WHERE `entry`=90286 AND `displayid`=116232;
UPDATE `item_template` SET `displayid`=118910 WHERE `entry`=90290 AND `displayid`=116233;
UPDATE `item_template` SET `displayid`=119575 WHERE `entry`=90376 AND `displayid`=116866;
UPDATE `item_template` SET `displayid`=119574 WHERE `entry`=90383 AND `displayid`=61679;
UPDATE `item_template` SET `displayid`=116196 WHERE `entry`=90408 AND `displayid`=116916;
UPDATE `item_template` SET `displayid`=118855 WHERE `entry`=90493 AND `displayid`=113796;
UPDATE `item_template` SET `displayid`=127675 WHERE `entry`=90625 AND `displayid`=117144;
UPDATE `item_template` SET `displayid`=107613 WHERE `entry`=90906 AND `displayid`=116734;
UPDATE `item_template` SET `displayid`=119839 WHERE `entry`=93403 AND `displayid`=0;
UPDATE `item_template` SET `displayid`=125027 WHERE `entry`=101776 AND `displayid`=0;
UPDATE `item_template` SET `displayid`=126760 WHERE `entry`=104289 AND `displayid`=0;
UPDATE `item_template` SET `displayid`=126792 WHERE `entry`=104312 AND `displayid`=0;

-- class: 8 item(s)
UPDATE `item_template` SET `class`=7 WHERE `entry`=79246 AND `class`=12;
UPDATE `item_template` SET `class`=7 WHERE `entry`=79250 AND `class`=12;
UPDATE `item_template` SET `class`=15 WHERE `entry`=87210 AND `class`=12;
UPDATE `item_template` SET `class`=12 WHERE `entry`=89169 AND `class`=15;
UPDATE `item_template` SET `class`=7 WHERE `entry`=89639 AND `class`=15;
UPDATE `item_template` SET `class`=0 WHERE `entry`=90815 AND `class`=12;
UPDATE `item_template` SET `class`=0 WHERE `entry`=90816 AND `class`=12;
UPDATE `item_template` SET `class`=0 WHERE `entry`=93403 AND `class`=8;

-- InventoryType: 55 item(s)
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=80932 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=81094 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=81253 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=26 WHERE `entry`=81543 AND `InventoryType`=13;
UPDATE `item_template` SET `InventoryType`=26 WHERE `entry`=81845 AND `InventoryType`=13;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=82003 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=82011 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=82064 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=82065 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=82119 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=82120 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=82174 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=82175 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=82229 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=82230 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=82284 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=82285 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=26 WHERE `entry`=82590 AND `InventoryType`=13;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=82816 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=82963 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=82970 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=84695 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=84697 AND `InventoryType`=22;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=84698 AND `InventoryType`=22;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=84720 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=84893 AND `InventoryType`=22;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=84894 AND `InventoryType`=22;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=84961 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=85116 AND `InventoryType`=22;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=85117 AND `InventoryType`=22;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=85127 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=85137 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=85190 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=86148 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=86217 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=86227 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=86390 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=86527 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=86806 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=86862 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=86865 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=86909 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=86983 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=86990 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=87074 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=87152 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=87465 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=87466 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=87467 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=87544 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=88280 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=90461 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=90513 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=90527 AND `InventoryType`=21;
UPDATE `item_template` SET `InventoryType`=13 WHERE `entry`=90819 AND `InventoryType`=22;

-- Material: 17 item(s)
UPDATE `item_template` SET `Material`=0 WHERE `entry`=79250 AND `Material`=4;
UPDATE `item_template` SET `Material`=2 WHERE `entry`=80874 AND `Material`=8;
UPDATE `item_template` SET `Material`=2 WHERE `entry`=81079 AND `Material`=8;
UPDATE `item_template` SET `Material`=2 WHERE `entry`=81288 AND `Material`=8;
UPDATE `item_template` SET `Material`=1 WHERE `entry`=82008 AND `Material`=2;
UPDATE `item_template` SET `Material`=1 WHERE `entry`=82052 AND `Material`=2;
UPDATE `item_template` SET `Material`=1 WHERE `entry`=82107 AND `Material`=2;
UPDATE `item_template` SET `Material`=1 WHERE `entry`=82162 AND `Material`=2;
UPDATE `item_template` SET `Material`=1 WHERE `entry`=82217 AND `Material`=2;
UPDATE `item_template` SET `Material`=1 WHERE `entry`=82272 AND `Material`=2;
UPDATE `item_template` SET `Material`=4 WHERE `entry`=82800 AND `Material`=0;
UPDATE `item_template` SET `Material`=8 WHERE `entry`=83078 AND `Material`=4;
UPDATE `item_template` SET `Material`=5 WHERE `entry`=85794 AND `Material`=8;
UPDATE `item_template` SET `Material`=1 WHERE `entry`=86524 AND `Material`=2;
UPDATE `item_template` SET `Material`=2 WHERE `entry`=87642 AND `Material`=8;
UPDATE `item_template` SET `Material`=1 WHERE `entry`=89395 AND `Material`=8;
UPDATE `item_template` SET `Material`=8 WHERE `entry`=90135 AND `Material`=4;

-- sheath: 11 item(s)
UPDATE `item_template` SET `sheath`=4 WHERE `entry`=82961 AND `sheath`=0;
UPDATE `item_template` SET `sheath`=4 WHERE `entry`=82962 AND `sheath`=0;
UPDATE `item_template` SET `sheath`=3 WHERE `entry`=82963 AND `sheath`=0;
UPDATE `item_template` SET `sheath`=3 WHERE `entry`=82964 AND `sheath`=0;
UPDATE `item_template` SET `sheath`=1 WHERE `entry`=82966 AND `sheath`=0;
UPDATE `item_template` SET `sheath`=3 WHERE `entry`=82967 AND `sheath`=0;
UPDATE `item_template` SET `sheath`=4 WHERE `entry`=82968 AND `sheath`=0;
UPDATE `item_template` SET `sheath`=4 WHERE `entry`=82969 AND `sheath`=0;
UPDATE `item_template` SET `sheath`=3 WHERE `entry`=82970 AND `sheath`=0;
UPDATE `item_template` SET `sheath`=3 WHERE `entry`=82971 AND `sheath`=0;
UPDATE `item_template` SET `sheath`=1 WHERE `entry`=82973 AND `sheath`=0;

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


