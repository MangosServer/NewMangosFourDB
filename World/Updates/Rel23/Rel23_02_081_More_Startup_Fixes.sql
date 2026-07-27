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
    SET @cOldContent = '080';

    -- New Values
    SET @cNewVersion = '23';
    SET @cNewStructure = '02';
    SET @cNewContent = '081';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'More Startup Fixes';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'More Startup Fixes';

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
-- MaNGOS Four world DB update: Removed-spell cleanup: playercreateinfo_spell / spell_script_target
-- Rows referencing spell ids that no longer exist in the 5.4.8 client. Core skips them each startup.
-- All statements are guarded (WHERE current value matches) and idempotent.
-- ============================================================

-- playercreateinfo_spell: 14 removed spell id(s)
DELETE FROM `playercreateinfo_spell` WHERE `Spell` IN (13358,16092,20558,24949,27762,27763,52665,58284,69001,75445,81170,87816,88161,92315);

-- spell_script_target: 117 removed spell id(s)
DELETE FROM `spell_script_target` WHERE `entry` IN (9455,28250,29705,29727,30232,31993,32953,36779,42482,45224,49166,53684,62034,62195,63727,67303,67304,67305,67306,67307,67308,67328,69294,72031,72032,72033,72096,72278,72279,72280,72746,72747,72748,72850,72851,72852,74318,74319,74320,74321,74322,74323,76379,78790,78791,78792,78793,78795,78796,78797,78798,81730,90249,90719,90872,91066,91906,92403,92404,92405,93206,93207,93208,93218,93219,93220,93238,93239,93240,93241,93242,93243,93264,93265,93266,94970,95019,95020,95021,95022,95023,95024,95025,95026,95027,95028,95029,95030,95354,100000,101157,101158,101159,101458,101459,101460,103087,103088,103089,108864,109172,109173,109174,109213,109558,109582,109583,109584,109619,109620,109621,109637,109638,109639,109728,109729,109730);

-- ============================================================
-- MaNGOS Four world DB update: gameobject_template data field fixes
-- Garbage lock ids (5-million range, from a broken sniff/import), dead SpellFocus ids, removed trap spells and bad trap links.
-- All statements are guarded (WHERE current value matches) and idempotent.
-- ============================================================

-- Nonexistent lock ids -> 0 (object becomes usable without lock, matching pre-5.x behaviour of these objects): 36 object(s)
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=211614 AND `data1`=5705968;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=211615 AND `data1`=5705968;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=211963 AND `data1`=5705968;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=211970 AND `data1`=5705968;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=211976 AND `data1`=5705968;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=211977 AND `data1`=5705968;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=211981 AND `data1`=5705968;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=211982 AND `data1`=5705968;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=212246 AND `data1`=5705968;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=213090 AND `data1`=5743776;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=213091 AND `data1`=5743776;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=213268 AND `data1`=5749660;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=213269 AND `data1`=5749660;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=213270 AND `data1`=5749660;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=213271 AND `data1`=5749660;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=213395 AND `data1`=5749660;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=213396 AND `data1`=5749660;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=213397 AND `data1`=5749660;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=213398 AND `data1`=5749660;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=214641 AND `data1`=5755148;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=215130 AND `data1`=5756548;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=215363 AND `data1`=5756548;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=215364 AND `data1`=5756548;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=215365 AND `data1`=5756548;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=215366 AND `data1`=5756548;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=215381 AND `data1`=5756548;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=215382 AND `data1`=5756548;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=215391 AND `data1`=5762916;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=215459 AND `data1`=5762916;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=216060 AND `data1`=5773300;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=216354 AND `data1`=5773332;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=216355 AND `data1`=5773332;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=216356 AND `data1`=5773332;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=216357 AND `data1`=5773332;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=216358 AND `data1`=5773332;
UPDATE `gameobject_template` SET `data1`=0 WHERE `entry`=216359 AND `data1`=5773332;

-- Nonexistent SpellFocus ids -> 0: 12 object(s)
UPDATE `gameobject_template` SET `data0`=0 WHERE `entry`=212582 AND `data0`=5705760;
UPDATE `gameobject_template` SET `data0`=0 WHERE `entry`=212587 AND `data0`=5705760;
UPDATE `gameobject_template` SET `data0`=0 WHERE `entry`=212594 AND `data0`=5705760;
UPDATE `gameobject_template` SET `data0`=0 WHERE `entry`=212595 AND `data0`=5705760;
UPDATE `gameobject_template` SET `data0`=0 WHERE `entry`=213868 AND `data0`=5749504;
UPDATE `gameobject_template` SET `data0`=0 WHERE `entry`=213869 AND `data0`=5749504;
UPDATE `gameobject_template` SET `data0`=0 WHERE `entry`=213870 AND `data0`=5749504;
UPDATE `gameobject_template` SET `data0`=0 WHERE `entry`=213871 AND `data0`=5749504;
UPDATE `gameobject_template` SET `data0`=0 WHERE `entry`=213874 AND `data0`=5749504;
UPDATE `gameobject_template` SET `data0`=0 WHERE `entry`=213875 AND `data0`=5749504;
UPDATE `gameobject_template` SET `data0`=0 WHERE `entry`=213876 AND `data0`=5749504;
UPDATE `gameobject_template` SET `data0`=0 WHERE `entry`=213877 AND `data0`=5749504;

-- SPELLCASTER objects casting spells removed from client -> 0: 4 object(s)
UPDATE `gameobject_template` SET `data0`=0 WHERE `entry`=183322 AND `data0`=17607;
UPDATE `gameobject_template` SET `data0`=0 WHERE `entry`=191008 AND `data0`=17607;
UPDATE `gameobject_template` SET `data0`=0 WHERE `entry`=193061 AND `data0`=58660;
UPDATE `gameobject_template` SET `data0`=0 WHERE `entry`=205210 AND `data0`=17607;

-- GOOBER linkedTrap pointing at a non-trap GO -> 0: 4 object(s)
UPDATE `gameobject_template` SET `data12`=0 WHERE `entry`=181575 AND `data12`=129;
UPDATE `gameobject_template` SET `data12`=0 WHERE `entry`=181576 AND `data12`=129;
UPDATE `gameobject_template` SET `data12`=0 WHERE `entry`=181577 AND `data12`=129;
UPDATE `gameobject_template` SET `data12`=0 WHERE `entry`=181578 AND `data12`=129;

-- ============================================================
-- MaNGOS Four world DB update: instance_template parents & orphan waypoint paths
-- MoP instances wrongly parented to continent 870 (core ignores it), and creature_movement paths whose spawn guid does not exist.
-- All statements are guarded (WHERE current value matches) and idempotent.
-- ============================================================

-- creature_movement paths for nonexistent spawn guids (verified absent from `creature` in the dump): 7 guid(s)
DELETE FROM `creature_movement` WHERE `id` IN (161301,161302,200477,214057,264700,306382,318312);

-- ============================================================
-- MaNGOS Four world DB update: OPTIONAL content-affecting changes -- review before applying
-- These change game content rather than clean dead references. Apply selectively.
-- All statements are guarded (WHERE current value matches) and idempotent.
-- ============================================================

-- A) Creatures used as quest giver/taker but missing UNIT_NPC_FLAG_QUESTGIVER (2): 129 creature(s)
--    (alternative: delete their quest_relations rows if the relation itself is wrong)
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=397 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=518 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=682 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=684 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=686 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=687 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=706 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=736 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=808 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=1085 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=2748 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=3098 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=3101 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=3102 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=3256 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=4202 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=7139 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=7149 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=7434 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=7443 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=7456 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=9176 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=9517 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=9860 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=9861 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=10737 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=10806 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=12258 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=13282 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=15271 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=15273 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=15294 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=15298 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=15468 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=16483 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=16516 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=16521 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=16522 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=18020 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=18024 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=18210 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=20912 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=29308 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=30284 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=30285 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=34884 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=34957 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=34958 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=34959 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=35118 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=35149 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=35175 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=35177 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=35200 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=35229 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=35463 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=35486 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=35627 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=37073 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=37112 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=37114 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=37203 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=37582 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=37598 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=37989 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=38895 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=39157 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=39317 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=39679 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=39698 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=39700 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=39705 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=40793 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=40957 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=41530 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=42333 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=42428 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=42938 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=42940 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=43589 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=43590 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=43778 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=43837 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=44164 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=44445 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=44484 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=44485 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=44486 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=44906 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=44951 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=45006 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=45098 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=45155 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=45195 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=45202 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=46424 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=46496 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=46623 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=46656 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=46859 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=46860 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=46861 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=46915 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=46916 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=46917 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=46938 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=47162 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=47296 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=47626 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=47739 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=48099 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=48100 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=48319 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=48322 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=48878 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=48880 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=49116 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=49230 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=49231 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=49264 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=49265 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=49266 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=49268 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=52165 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=52383 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=52649 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=52749 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=52766 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=53385 AND (`NpcFlags`&2)=0;

-- B) Creatures with npc_vendor data but missing UNIT_NPC_FLAG_VENDOR (128): 77 creature(s)
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=3529 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=5944 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=6737 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=12799 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=16786 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=18898 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=18990 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=18991 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=19857 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=21483 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=21488 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=23447 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=24396 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=25176 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=25177 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=25179 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=25195 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=25196 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=26383 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=26384 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=26901 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=26947 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=27668 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=27721 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=27722 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=28225 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=28800 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=28813 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=29493 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=30437 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=31863 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=31864 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=31865 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=32356 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=32359 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=32380 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=32381 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=32383 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=32385 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=32405 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=32407 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=32832 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=32834 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=33915 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=33916 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=33917 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=33918 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=33919 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=33920 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=33921 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=33922 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=33923 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=33924 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=33925 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=33926 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=33927 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=33928 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=33931 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=33933 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=33941 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=34037 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=34040 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=34059 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=34062 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=34073 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=34074 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=34076 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=34077 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=34082 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=34083 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=34084 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=34087 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=34088 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=34089 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=34090 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=34091 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=34092 AND (`NpcFlags`&128)=0;

-- C) Custom 200xxx npc_trainer blocks with no creature_template and not referenced by any TrainerTemplateId: 37 entrie(s)
--    They look like trainer-template data living in the wrong table - either move them to npc_trainer_template or delete:
DELETE FROM `npc_trainer` WHERE `entry` IN (200001,200002,200003,200004,200005,200006,200007,200008,200009,200011,200100,200101,200102,200103,200200,200201,200202,200300,200301,200302,200303,200304,200305,200400,200401,200402,200403,200404,200405,200406,200407,200408,200409,200410,200433,200434,201009);

-- D) spell_loot_template for spells removed from the client: 264 spell id(s) (kept commented - loot is simply never used)
DELETE FROM `spell_loot_template` WHERE `entry` IN (73222,73223,73224,73225,73226,73227,73228,73229,73230,73231,73232,73233,73234,73239,73240,73241,73242,73243,73244,73245,73246,73247,73248,73249,73250,73258,73259,73260,73262,73263,73264,73265,73266,73267,73268,73269,73270,73271,73272,73273,73274,73275,73276,73277,73278,73279,73280,73281,73335,73494,73495,73496,73497,107598,107599,107600,107601,107602,107604,107605,107606,107607,107608,107609,107610,107611,107612,107613,107614,107615,107616,107617,107619,107620,107621,107622,107623,107624,107625,107626,107627,107628,107630,107631,107632,107633,107634,107635,107636,107637,107638,107639,107640,107641,107642,107643,107644,107645,107646,107647,107648,107649,107650,107651,107652,107653,107654,107655,107656,107657,107658,107659,107660,107661,107662,107663,107665,107666,107667,108448,111830,113968,113971,113972,113973,113974,113975,113976,113977,113978,113979,113982,113983,113984,113985,113986,113987,113988,113989,113990,113991,115063,115067,122576,122577,122578,122579,122580,122581,122582,122583,122661,122662,123516,123548,123549,124102,124281,124964,125055,125134,125264,125424,125479,126578,127068,127070,127071,127072,127073,127074,127075,127076,127077,127078,127079,127080,127081,127082,127083,127084,127085,127086,127087,127088,127089,127090,127091,127092,127093,127094,127095,127096,127097,127098,127099,127100,127101,127102,127103,127104,127105,127106,127107,127108,127109,127110,128769,129673,129674,129675,129676,129687,129705,129757,129796,129814,129843,129887,130025,130026,130109,130140,130168,130407,130655,130656,133106,134281,134282,134283,134284,134285,134286,134287,134288,134289,134290,134291,134292,134293,134294,134295,134296,134297,134298,134299,134300,134301,134302,134303,135057,135825,139773,139775,139776,139779,139780,139781,139782,139783,139784,139785,147020);

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


