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
    SET @cOldContent = '081';

    -- New Values
    SET @cNewVersion = '23';
    SET @cNewStructure = '02';
    SET @cNewContent = '082';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'More Startup Fixes Pt2';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'More Startup Fixes Pt2';

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

DELETE FROM Gameobject_Template WHERE Entry=21653;
DELETE FROM Gameobject_Template WHERE Entry=21654;
DELETE FROM Gameobject_Template WHERE Entry=21655;
DELETE FROM Gameobject_Template WHERE Entry=21656;
DELETE FROM Gameobject_Template WHERE Entry=32056;
DELETE FROM Gameobject_Template WHERE Entry=32057;
DELETE FROM Gameobject_Template WHERE Entry=80024;
DELETE FROM Gameobject_Template WHERE Entry=176080;
DELETE FROM Gameobject_Template WHERE Entry=176081;
DELETE FROM Gameobject_Template WHERE Entry=176082;
DELETE FROM Gameobject_Template WHERE Entry=176083;
DELETE FROM Gameobject_Template WHERE Entry=176084;
DELETE FROM Gameobject_Template WHERE Entry=176085;
DELETE FROM Gameobject_Template WHERE Entry=176086;
DELETE FROM Gameobject_Template WHERE Entry=192517;
DELETE FROM Gameobject_Template WHERE Entry=192550;
DELETE FROM Gameobject_Template WHERE Entry=192551;
DELETE FROM Gameobject_Template WHERE Entry=193458;
DELETE FROM Gameobject_Template WHERE Entry=193459;
DELETE FROM Gameobject_Template WHERE Entry=193460;
DELETE FROM Gameobject_Template WHERE Entry=193461;
DELETE FROM Gameobject_Template WHERE Entry=194030;
DELETE FROM Gameobject_Template WHERE Entry=194031;
DELETE FROM Gameobject_Template WHERE Entry=194582;
DELETE FROM Gameobject_Template WHERE Entry=194583;
DELETE FROM Gameobject_Template WHERE Entry=194584;
DELETE FROM Gameobject_Template WHERE Entry=194585;
DELETE FROM Gameobject_Template WHERE Entry=194586;
DELETE FROM Gameobject_Template WHERE Entry=194587;
DELETE FROM Gameobject_Template WHERE Entry=203251;
DELETE FROM Gameobject_Template WHERE Entry=203303;
DELETE FROM Gameobject_Template WHERE Entry=203304;
DELETE FROM Gameobject_Template WHERE Entry=204242;
DELETE FROM Gameobject_Template WHERE Entry=216666;

-- ============================================================
-- MaNGOS Four world DB update (round 2): instance_template parents
-- Same 8 MoP instances as round 1 (M4_07 was not applied to this DB). Core ignores continent parents each load.
-- All statements guarded on current values and idempotent.
-- ============================================================

UPDATE `instance_template` SET `parent`=0 WHERE `map`=959 AND `parent`=870;
UPDATE `instance_template` SET `parent`=0 WHERE `map`=960 AND `parent`=870;
UPDATE `instance_template` SET `parent`=0 WHERE `map`=961 AND `parent`=870;
UPDATE `instance_template` SET `parent`=0 WHERE `map`=962 AND `parent`=870;
UPDATE `instance_template` SET `parent`=0 WHERE `map`=994 AND `parent`=870;
UPDATE `instance_template` SET `parent`=0 WHERE `map`=1008 AND `parent`=870;
UPDATE `instance_template` SET `parent`=0 WHERE `map`=1011 AND `parent`=870;
UPDATE `instance_template` SET `parent`=0 WHERE `map`=1136 AND `parent`=870;

-- ============================================================
-- MaNGOS Four world DB update (round 2): creature_template FactionHorde=0 fixes
-- 21 MoP creatures have FactionHorde=0 (invalid). Copy the valid FactionAlliance value (factions are identical A/H for these NPC types).
-- All statements guarded on current values and idempotent.
-- ============================================================

UPDATE `creature_template` SET `FactionHorde`=16 WHERE `entry`=69154 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=14 WHERE `entry`=71864 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=16 WHERE `entry`=71908 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=14 WHERE `entry`=71919 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=974 WHERE `entry`=72033 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=16 WHERE `entry`=72045 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=974 WHERE `entry`=72048 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=2030 WHERE `entry`=72049 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=14 WHERE `entry`=72193 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=14 WHERE `entry`=72245 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=14 WHERE `entry`=72970 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=16 WHERE `entry`=73160 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=2136 WHERE `entry`=73161 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=16 WHERE `entry`=73163 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=16 WHERE `entry`=73166 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=16 WHERE `entry`=73173 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=14 WHERE `entry`=73279 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=14 WHERE `entry`=73281 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=16 WHERE `entry`=73282 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=230 WHERE `entry`=73703 AND `FactionHorde`=0;
UPDATE `creature_template` SET `FactionHorde`=230 WHERE `entry`=73704 AND `FactionHorde`=0;

-- ============================================================
-- MaNGOS Four world DB update (round 2): creature addon aura cleanup
-- Removes spells that no longer exist in the 5.4.8 client (or apply no aura) from the space-separated `auras` lists. Core skips them each load.
-- All statements guarded on current values and idempotent.
-- ============================================================

-- creature_template_addon: 22 entrie(s)
UPDATE `creature_template_addon` SET `auras`='' WHERE `entry`=926 AND `auras`='465 63510 63514 63531';
UPDATE `creature_template_addon` SET `auras`='' WHERE `entry`=25958 AND `auras`='34947 34956 34957 34958 61013 89953';
UPDATE `creature_template_addon` SET `auras`='' WHERE `entry`=34825 AND `auras`='67104';
UPDATE `creature_template_addon` SET `auras`='' WHERE `entry`=35278 AND `auras`='67104';
UPDATE `creature_template_addon` SET `auras`='' WHERE `entry`=35279 AND `auras`='67104';
UPDATE `creature_template_addon` SET `auras`='' WHERE `entry`=35280 AND `auras`='67104';
UPDATE `creature_template_addon` SET `auras`='' WHERE `entry`=39388 AND `auras`='91044';
UPDATE `creature_template_addon` SET `auras`='79963' WHERE `entry`=43001 AND `auras`='79963 63510 63514 63531';
UPDATE `creature_template_addon` SET `auras`='' WHERE `entry`=48505 AND `auras`='90955';
UPDATE `creature_template_addon` SET `auras`='' WHERE `entry`=48791 AND `auras`='90955';
UPDATE `creature_template_addon` SET `auras`='' WHERE `entry`=48832 AND `auras`='91044';
UPDATE `creature_template_addon` SET `auras`='79963' WHERE `entry`=49954 AND `auras`='79963 63510 63514 63531';
UPDATE `creature_template_addon` SET `auras`='79963' WHERE `entry`=50150 AND `auras`='79963 63510 63514 63531';
UPDATE `creature_template_addon` SET `auras`='79963' WHERE `entry`=50160 AND `auras`='79963 63510 63514 63531';
UPDATE `creature_template_addon` SET `auras`='81206' WHERE `entry`=54263 AND `auras`='81206 81207';
UPDATE `creature_template_addon` SET `auras`='32223 101090' WHERE `entry`=54265 AND `auras`='32223 63510 63514 63531 101090';
UPDATE `creature_template_addon` SET `auras`='109247' WHERE `entry`=56188 AND `auras`='109247 109588';
UPDATE `creature_template_addon` SET `auras`='' WHERE `entry`=56311 AND `auras`='108643';
UPDATE `creature_template_addon` SET `auras`='109247' WHERE `entry`=57978 AND `auras`='109247 109588';
UPDATE `creature_template_addon` SET `auras`='109247' WHERE `entry`=58142 AND `auras`='109247 109588';
UPDATE `creature_template_addon` SET `auras`='109247' WHERE `entry`=58143 AND `auras`='109247 109588';
UPDATE `creature_template_addon` SET `auras`='' WHERE `entry`=62143 AND `auras`='120889';

-- creature_addon (per-spawn): 6 guid(s)
UPDATE `creature_addon` SET `auras`='' WHERE `guid`=330962 AND `auras`='95184';
UPDATE `creature_addon` SET `auras`='' WHERE `guid`=331012 AND `auras`='95184';
UPDATE `creature_addon` SET `auras`='109247' WHERE `guid`=345053 AND `auras`='109247 109588';
UPDATE `creature_addon` SET `auras`='109247' WHERE `guid`=345092 AND `auras`='109247 109588';
UPDATE `creature_addon` SET `auras`='81206' WHERE `guid`=375486 AND `auras`='81206 81207';
UPDATE `creature_addon` SET `auras`='32223 101090' WHERE `guid`=375494 AND `auras`='32223 63510 63514 63531 101090';

-- ============================================================
-- MaNGOS Four world DB update (round 2): npc_trainer bogus spell ids
-- 43 rows store negative custom spell ids (logged as 429476xxxx = 2^32 + value). No such spells exist; the core ignores the rows.
-- All statements guarded on current values and idempotent.
-- ============================================================

DELETE FROM `npc_trainer` WHERE `entry`=996 AND `spell`=-200410;
DELETE FROM `npc_trainer` WHERE `entry`=1384 AND `spell`=-200408;
DELETE FROM `npc_trainer` WHERE `entry`=1546 AND `spell`=-200404;
DELETE FROM `npc_trainer` WHERE `entry`=2133 AND `spell`=-200404;
DELETE FROM `npc_trainer` WHERE `entry`=2222 AND `spell`=-200408;
DELETE FROM `npc_trainer` WHERE `entry`=3071 AND `spell`=-200404;
DELETE FROM `npc_trainer` WHERE `entry`=3703 AND `spell`=-200407;
DELETE FROM `npc_trainer` WHERE `entry`=3964 AND `spell`=-200400;
DELETE FROM `npc_trainer` WHERE `entry`=3965 AND `spell`=-200404;
DELETE FROM `npc_trainer` WHERE `entry`=4888 AND `spell`=-200401;
DELETE FROM `npc_trainer` WHERE `entry`=4941 AND `spell`=-200403;
DELETE FROM `npc_trainer` WHERE `entry`=4998 AND `spell`=-200404;
DELETE FROM `npc_trainer` WHERE `entry`=4999 AND `spell`=-200408;
DELETE FROM `npc_trainer` WHERE `entry`=5032 AND `spell`=-200400;
DELETE FROM `npc_trainer` WHERE `entry`=5033 AND `spell`=-200401;
DELETE FROM `npc_trainer` WHERE `entry`=5037 AND `spell`=-200403;
DELETE FROM `npc_trainer` WHERE `entry`=5038 AND `spell`=-200402;
DELETE FROM `npc_trainer` WHERE `entry`=5040 AND `spell`=-200407;
DELETE FROM `npc_trainer` WHERE `entry`=5041 AND `spell`=-200410;
DELETE FROM `npc_trainer` WHERE `entry`=6242 AND `spell`=-200409;
DELETE FROM `npc_trainer` WHERE `entry`=6288 AND `spell`=-200409;
DELETE FROM `npc_trainer` WHERE `entry`=6387 AND `spell`=-200409;
DELETE FROM `npc_trainer` WHERE `entry`=7174 AND `spell`=-200401;
DELETE FROM `npc_trainer` WHERE `entry`=7525 AND `spell`=-200407;
DELETE FROM `npc_trainer` WHERE `entry`=7526 AND `spell`=-200407;
DELETE FROM `npc_trainer` WHERE `entry`=7528 AND `spell`=-200407;
DELETE FROM `npc_trainer` WHERE `entry`=8777 AND `spell`=-200409;
DELETE FROM `npc_trainer` WHERE `entry`=12020 AND `spell`=-200400;
DELETE FROM `npc_trainer` WHERE `entry`=12035 AND `spell`=-200408;
DELETE FROM `npc_trainer` WHERE `entry`=12939 AND `spell`=-200303;
DELETE FROM `npc_trainer` WHERE `entry`=15465 AND `spell`=-200406;
DELETE FROM `npc_trainer` WHERE `entry`=16000 AND `spell`=-200410;
DELETE FROM `npc_trainer` WHERE `entry`=16190 AND `spell`=-200402;
DELETE FROM `npc_trainer` WHERE `entry`=16265 AND `spell`=-200401;
DELETE FROM `npc_trainer` WHERE `entry`=16487 AND `spell`=-200400;
DELETE FROM `npc_trainer` WHERE `entry`=16527 AND `spell`=-200404;
DELETE FROM `npc_trainer` WHERE `entry`=25263 AND `spell`=-200405;
DELETE FROM `npc_trainer` WHERE `entry`=28400 AND `spell`=-200407;
DELETE FROM `npc_trainer` WHERE `entry`=48685 AND `spell`=-200402;
DELETE FROM `npc_trainer` WHERE `entry`=53437 AND `spell`=-200409;
DELETE FROM `npc_trainer` WHERE `entry`=66222 AND `spell`=-200303;
DELETE FROM `npc_trainer` WHERE `entry`=66980 AND `spell`=-200404;
DELETE FROM `npc_trainer` WHERE `entry`=66981 AND `spell`=-200409;

-- ============================================================
-- MaNGOS Four world DB update (round 2): item_template removed spells in spellid_N
-- 114 references to spells removed from the 5.4.8 client; core zeroes them each startup.
-- All statements guarded on current values and idempotent.
-- ============================================================

UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=72987 AND `spellid_1`=102696;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=77497 AND `spellid_1`=108949;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=77501 AND `spellid_1`=108956;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=78960 AND `spellid_1`=110234;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=78961 AND `spellid_1`=110235;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=78962 AND `spellid_1`=110233;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=79715 AND `spellid_1`=112871;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=80239 AND `spellid_1`=114726;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=80428 AND `spellid_1`=81040;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=80429 AND `spellid_1`=81040;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=80430 AND `spellid_1`=81040;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=80535 AND `spellid_1`=81040;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=80807 AND `spellid_1`=81040;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=85682 AND `spellid_1`=78142;
UPDATE `item_template` SET `spellid_2`=0 WHERE `entry`=85686 AND `spellid_2`=122138;
UPDATE `item_template` SET `spellid_2`=0 WHERE `entry`=85711 AND `spellid_2`=124420;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=85783 AND `spellid_1`=81040;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=87252 AND `spellid_1`=126509;
UPDATE `item_template` SET `spellid_2`=0 WHERE `entry`=87756 AND `spellid_2`=127133;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=89053 AND `spellid_1`=129201;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=89124 AND `spellid_1`=81040;
UPDATE `item_template` SET `spellid_2`=0 WHERE `entry`=90500 AND `spellid_2`=131908;
UPDATE `item_template` SET `spellid_2`=0 WHERE `entry`=90501 AND `spellid_2`=131915;
UPDATE `item_template` SET `spellid_2`=0 WHERE `entry`=90502 AND `spellid_2`=131916;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92549 AND `spellid_1`=79342;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92580 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92582 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92584 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92586 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92588 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92590 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92592 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92594 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92596 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92598 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92600 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92602 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92604 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92606 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92608 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92610 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92612 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92614 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92616 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92618 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92620 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92622 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=92624 AND `spellid_1`=134279;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=93823 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=93824 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94160 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94161 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94162 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94163 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94164 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94165 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94166 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94167 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94168 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94169 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94170 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94171 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94172 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94173 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94174 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94175 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94176 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94177 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94178 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94179 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94180 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94181 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94182 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94183 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94184 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94185 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94186 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94187 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94188 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=94189 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97278 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97279 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97280 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97281 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97282 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97283 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97284 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97285 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97286 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97287 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97288 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97289 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97321 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97445 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97450 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97559 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97560 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97561 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97563 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97566 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=97972 AND `spellid_1`=137059;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=103649 AND `spellid_1`=147057;
UPDATE `item_template` SET `spellid_2`=0 WHERE `entry`=103649 AND `spellid_2`=147084;
UPDATE `item_template` SET `spellid_2`=0 WHERE `entry`=104115 AND `spellid_2`=132655;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=104648 AND `spellid_1`=147057;
UPDATE `item_template` SET `spellid_2`=0 WHERE `entry`=104648 AND `spellid_2`=147084;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=104897 AND `spellid_1`=147057;
UPDATE `item_template` SET `spellid_2`=0 WHERE `entry`=104897 AND `spellid_2`=147084;
UPDATE `item_template` SET `spellid_2`=0 WHERE `entry`=105146 AND `spellid_2`=147084;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=105146 AND `spellid_1`=147057;
UPDATE `item_template` SET `spellid_2`=0 WHERE `entry`=105395 AND `spellid_2`=147084;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=105395 AND `spellid_1`=147057;
UPDATE `item_template` SET `spellid_2`=0 WHERE `entry`=105644 AND `spellid_2`=147084;
UPDATE `item_template` SET `spellid_1`=0 WHERE `entry`=105644 AND `spellid_1`=147057;

-- ============================================================
-- MaNGOS Four world DB update (round 2): misc creature/equip fixes
-- KillCredit links to a nonexistent creature (core zeroes), unequippable ranged-slot items (core forces 0).
-- All statements guarded on current values and idempotent.
-- ============================================================

UPDATE `creature_template` SET `KillCredit2`=0 WHERE `entry`=71292 AND `KillCredit2`=71066;
UPDATE `creature_template` SET `KillCredit2`=0 WHERE `entry`=71293 AND `KillCredit2`=71066;

UPDATE `creature_equip_template` SET `equipentry3`=0 WHERE `entry`=30624 AND `equipentry3`=35019;
UPDATE `creature_equip_template` SET `equipentry3`=0 WHERE `entry`=102311 AND `equipentry3`=47661;
UPDATE `creature_equip_template` SET `equipentry3`=0 WHERE `entry`=102310 AND `equipentry3`=47673;

-- ============================================================
-- MaNGOS Four world DB update (round 2): OPTIONAL content-affecting changes -- review before applying
-- Each block independent; apply what you agree with.
-- All statements guarded on current values and idempotent.
-- ============================================================

-- A) 37 creatures reference gossip menus that don't exist in `gossip_menu`.
--    Proper fix: import/author the menus. Quick fix (NPC falls back to default gossip):
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=55054 AND `GossipMenuId`=14988;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=61348 AND `GossipMenuId`=55015;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=62321 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=62393 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=62419 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=62425 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=62445 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=62450 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=62462 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=62463 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=62464 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=63238 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=63258 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=63272 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=63285 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=63296 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=63310 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=63327 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=63331 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=63332 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=63335 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=64679 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=64975 AND `GossipMenuId`=55001;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=66292 AND `GossipMenuId`=14971;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=70279 AND `GossipMenuId`=16032;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=71965 AND `GossipMenuId`=15762;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=73591 AND `GossipMenuId`=16037;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=73592 AND `GossipMenuId`=16026;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=73597 AND `GossipMenuId`=16036;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=73598 AND `GossipMenuId`=16029;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=73603 AND `GossipMenuId`=16039;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=73604 AND `GossipMenuId`=16041;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=73605 AND `GossipMenuId`=16038;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=73606 AND `GossipMenuId`=16040;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=73607 AND `GossipMenuId`=16030;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=74216 AND `GossipMenuId`=16033;
UPDATE `creature_template` SET `GossipMenuId`=0 WHERE `entry`=74217 AND `GossipMenuId`=16031;

-- B) Add QUESTGIVER flag (2): 5 creature(s)
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=68392 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=69433 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=70297 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=70371 AND (`NpcFlags`&2)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|2 WHERE `entry`=73335 AND (`NpcFlags`&2)=0;

-- C) Add VENDOR flag (128): 4 creature(s)
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=63367 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=72993 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=73004 AND (`NpcFlags`&128)=0;
UPDATE `creature_template` SET `NpcFlags`=`NpcFlags`|128 WHERE `entry`=73819 AND (`NpcFlags`&128)=0;

-- D) quest_relations row whose creature template genuinely doesn't exist:
DELETE FROM `quest_relations` WHERE `entry`=69533 AND `quest`=32499;

-- E) 4 creatures at level 100 vs core cap 95 (core clamps at load). Either raise
--    DEFAULT_MAX_CREATURE_LEVEL in the core or align the data:
-- UPDATE `creature_template` SET `MinLevel`=LEAST(`MinLevel`,95), `MaxLevel`=LEAST(`MaxLevel`,95) WHERE `entry`=59899;
-- UPDATE `creature_template` SET `MinLevel`=LEAST(`MinLevel`,95), `MaxLevel`=LEAST(`MaxLevel`,95) WHERE `entry`=68981;
-- UPDATE `creature_template` SET `MinLevel`=LEAST(`MinLevel`,95), `MaxLevel`=LEAST(`MaxLevel`,95) WHERE `entry`=73811;
-- UPDATE `creature_template` SET `MinLevel`=LEAST(`MinLevel`,95), `MaxLevel`=LEAST(`MaxLevel`,95) WHERE `entry`=73818;

-- F) creature_template_classlevelstats rows for levels 96-100 are skipped by the core (cap 95).
--    Harmless; delete only if you want a quiet log:
-- DELETE FROM `creature_template_classlevelstats` WHERE `Level` BETWEEN 96 AND 100;

-- G) spell_loot_template for 264 spells removed from the client (loot never used):
DELETE FROM `spell_loot_template` WHERE `entry` IN (73222,73223,73224,73225,73226,73227,73228,73229,73230,73231,73232,73233,73234,73239,73240,73241,73242,73243,73244,73245,73246,73247,73248,73249,73250,73258,73259,73260,73262,73263,73264,73265,73266,73267,73268,73269,73270,73271,73272,73273,73274,73275,73276,73277,73278,73279,73280,73281,73335,73494,73495,73496,73497,107598,107599,107600,107601,107602,107604,107605,107606,107607,107608,107609,107610,107611,107612,107613,107614,107615,107616,107617,107619,107620,107621,107622,107623,107624,107625,107626,107627,107628,107630,107631,107632,107633,107634,107635,107636,107637,107638,107639,107640,107641,107642,107643,107644,107645,107646,107647,107648,107649,107650,107651,107652,107653,107654,107655,107656,107657,107658,107659,107660,107661,107662,107663,107665,107666,107667,108448,111830,113968,113971,113972,113973,113974,113975,113976,113977,113978,113979,113982,113983,113984,113985,113986,113987,113988,113989,113990,113991,115063,115067,122576,122577,122578,122579,122580,122581,122582,122583,122661,122662,123516,123548,123549,124102,124281,124964,125055,125134,125264,125424,125479,126578,127068,127070,127071,127072,127073,127074,127075,127076,127077,127078,127079,127080,127081,127082,127083,127084,127085,127086,127087,127088,127089,127090,127091,127092,127093,127094,127095,127096,127097,127098,127099,127100,127101,127102,127103,127104,127105,127106,127107,127108,127109,127110,128769,129673,129674,129675,129676,129687,129705,129757,129796,129814,129843,129887,130025,130026,130109,130140,130168,130407,130655,130656,133106,134281,134282,134283,134284,134285,134286,134287,134288,134289,134290,134291,134292,134293,134294,134295,134296,134297,134298,134299,134300,134301,134302,134303,135057,135825,139773,139775,139776,139779,139780,139781,139782,139783,139784,139785,147020);

-- ============================================================
-- MaNGOS Four world DB update (round 2): M4v2_08_item_random_suffix_groups.sql
-- Adds the 69 missing random-suffix groups to `item_enchantment_template`
-- (negative `entry` = suffix group, `ench` = ItemRandomSuffix.dbc id).
-- Fixes 1,460 startup log lines and restores random suffixes on 730 MoP items
-- (Windwool, Ghost-Forged, Barrens sets, Immaculate weapons, Timeless Isle gear...).
--
-- DERIVATION NOTE: Blizzard's group->suffix mapping is not shipped with the
-- client; these pools were derived from the 5.4.8 ItemRandomSuffix.dbc you
-- provided, matched to each group's member items by armour class and content
-- tier (5.0 generic / 5.3 / 5.4 blocks, identified by the DBC internal names).
-- Equal chances per suffix, summing to 100. Stat values scale automatically
-- from the DBC AllocationPct, so one group serves items of different ilvls.
-- Review sheet: suffix_groups_review.csv
-- ============================================================

-- group 415: 16 item(s), e.g. Windwool Hood
--   suffixes: of the Feverflare, of the Fireflash, of the Undertow, of the Wavecrest, of the Wildfire
DELETE FROM `item_enchantment_template` WHERE `entry`=-415;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-415,129,20.0),(-415,130,20.0),(-415,131,20.0),(-415,132,20.0),(-415,138,20.0);

-- group 528: 57 item(s), e.g. Stormbrew Vest
--   suffixes: of the Feverflare, of the Fireflash, of the Galeburst, of the Stormblast, of the Undertow, of the Wavecrest, of the Wildfire, of the Windflurry, of the Windstorm, of the Zephyr
DELETE FROM `item_enchantment_template` WHERE `entry`=-528;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-528,133,10.0),(-528,134,10.0),(-528,135,10.0),(-528,136,10.0),(-528,137,10.0),(-528,129,10.0),(-528,130,10.0),(-528,131,10.0),(-528,132,10.0),(-528,138,10.0);

-- group 529: 34 item(s), e.g. Greenstone Vambraces
--   suffixes: of the Bedrock, of the Bouldercrag, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Landslide, of the Mountainbed, of the Rockslab, of the Substratum
DELETE FROM `item_enchantment_template` WHERE `entry`=-529;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-529,120,11.11),(-529,121,11.11),(-529,122,11.11),(-529,123,11.11),(-529,124,11.11),(-529,125,11.11),(-529,126,11.11),(-529,127,11.11),(-529,128,11.12);

-- group 530: 33 item(s), e.g. Firewool Wristwraps
--   suffixes: of the Feverflare, of the Fireflash, of the Undertow, of the Wavecrest, of the Wildfire
DELETE FROM `item_enchantment_template` WHERE `entry`=-530;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-530,129,20.0),(-530,130,20.0),(-530,131,20.0),(-530,132,20.0),(-530,138,20.0);

-- group 531: 105 item(s), e.g. Mogu-Wrought Breastplate
--   suffixes: of the Bedrock, of the Bouldercrag, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Feverflare, of the Fireflash, of the Galeburst, of the Landslide, of the Mountainbed, of the Rocks
DELETE FROM `item_enchantment_template` WHERE `entry`=-531;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-531,129,5.26),(-531,130,5.26),(-531,131,5.26),(-531,132,5.26),(-531,138,5.26),(-531,133,5.26),(-531,134,5.26),(-531,135,5.26),(-531,136,5.26),(-531,137,5.26),(-531,120,5.26),(-531,121,5.26),(-531,122,5.26),(-531,123,5.26),(-531,124,5.26),(-531,125,5.26),(-531,126,5.26),(-531,127,5.26),(-531,128,5.32);

-- group 532: 16 item(s), e.g. Ghost-Forged Helm
--   suffixes: of the Bedrock, of the Bouldercrag, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Landslide, of the Mountainbed, of the Rockslab, of the Substratum
DELETE FROM `item_enchantment_template` WHERE `entry`=-532;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-532,120,11.11),(-532,121,11.11),(-532,122,11.11),(-532,123,11.11),(-532,124,11.11),(-532,125,11.11),(-532,126,11.11),(-532,127,11.11),(-532,128,11.12);

-- group 533: 1 item(s), e.g. Scavenged Pandaren Spear
--   suffixes: of the Bedrock, of the Bouldercrag, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Galeburst, of the Landslide, of the Mountainbed, of the Rockslab, of the Stormblast, of the Substr
DELETE FROM `item_enchantment_template` WHERE `entry`=-533;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-533,133,7.14),(-533,134,7.14),(-533,135,7.14),(-533,136,7.14),(-533,137,7.14),(-533,120,7.14),(-533,121,7.14),(-533,122,7.14),(-533,123,7.14),(-533,124,7.14),(-533,125,7.14),(-533,126,7.14),(-533,127,7.14),(-533,128,7.18);

-- group 534: 1 item(s), e.g. Scavenged Pandaren Spear
--   suffixes: of the Bedrock, of the Bouldercrag, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Galeburst, of the Landslide, of the Mountainbed, of the Rockslab, of the Stormblast, of the Substr
DELETE FROM `item_enchantment_template` WHERE `entry`=-534;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-534,133,7.14),(-534,134,7.14),(-534,135,7.14),(-534,136,7.14),(-534,137,7.14),(-534,120,7.14),(-534,121,7.14),(-534,122,7.14),(-534,123,7.14),(-534,124,7.14),(-534,125,7.14),(-534,126,7.14),(-534,127,7.14),(-534,128,7.18);

-- group 539: 1 item(s), e.g. Loa-Binder Disc
--   suffixes: of the Bedrock, of the Bouldercrag, of the Feverflare, of the Fireflash, of the Rockslab, of the Undertow, of the Wavecrest, of the Wildfire
DELETE FROM `item_enchantment_template` WHERE `entry`=-539;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-539,125,12.5),(-539,127,12.5),(-539,128,12.5),(-539,129,12.5),(-539,130,12.5),(-539,131,12.5),(-539,132,12.5),(-539,138,12.5);

-- group 541: 20 item(s), e.g. Beady-Eye Bracers
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Impatient, of the Pious, of the Savant, of the Unerring, of the Untouchable
DELETE FROM `item_enchantment_template` WHERE `entry`=-541;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-541,344,12.5),(-541,345,12.5),(-541,346,12.5),(-541,347,12.5),(-541,348,12.5),(-541,349,12.5),(-541,350,12.5),(-541,351,12.5);

-- group 542: 10 item(s), e.g. Armplates of the Vanquished Abomination
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Impatient, of the Pious, of the Savant, of the Unerring, of the Untouchable
DELETE FROM `item_enchantment_template` WHERE `entry`=-542;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-542,344,12.5),(-542,345,12.5),(-542,346,12.5),(-542,347,12.5),(-542,348,12.5),(-542,349,12.5),(-542,350,12.5),(-542,351,12.5);

-- group 543: 5 item(s), e.g. Bracers of Constant Implosion
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Impatient, of the Pious, of the Savant, of the Unerring, of the Untouchable
DELETE FROM `item_enchantment_template` WHERE `entry`=-543;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-543,344,12.5),(-543,345,12.5),(-543,346,12.5),(-543,347,12.5),(-543,348,12.5),(-543,349,12.5),(-543,350,12.5),(-543,351,12.5);

-- group 547: 7 item(s), e.g. Insubordination Gauntlets
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-547;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-547,344,5.88),(-547,345,5.88),(-547,346,5.88),(-547,347,5.88),(-547,348,5.88),(-547,349,5.88),(-547,350,5.88),(-547,351,5.88),(-547,352,5.88),(-547,364,5.88),(-547,365,5.88),(-547,366,5.88),(-547,367,5.88),(-547,368,5.88),(-547,369,5.88),(-547,370,5.88),(-547,371,5.92);

-- group 548: 7 item(s), e.g. Insubordination Breastplate
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-548;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-548,344,5.88),(-548,345,5.88),(-548,346,5.88),(-548,347,5.88),(-548,348,5.88),(-548,349,5.88),(-548,350,5.88),(-548,351,5.88),(-548,352,5.88),(-548,364,5.88),(-548,365,5.88),(-548,366,5.88),(-548,367,5.88),(-548,368,5.88),(-548,369,5.88),(-548,370,5.88),(-548,371,5.92);

-- group 549: 7 item(s), e.g. Malcontent's Belt
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-549;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-549,344,5.26),(-549,345,5.26),(-549,346,5.26),(-549,347,5.26),(-549,348,5.26),(-549,349,5.26),(-549,350,5.26),(-549,351,5.26),(-549,353,5.26),(-549,354,5.26),(-549,355,5.26),(-549,356,5.26),(-549,357,5.26),(-549,358,5.26),(-549,359,5.26),(-549,360,5.26),(-549,361,5.26),(-549,362,5.26),(-549,363,5.32);

-- group 550: 7 item(s), e.g. Malcontent's Vest
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-550;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-550,344,5.26),(-550,345,5.26),(-550,346,5.26),(-550,347,5.26),(-550,348,5.26),(-550,349,5.26),(-550,350,5.26),(-550,351,5.26),(-550,353,5.26),(-550,354,5.26),(-550,355,5.26),(-550,356,5.26),(-550,357,5.26),(-550,358,5.26),(-550,359,5.26),(-550,360,5.26),(-550,361,5.26),(-550,362,5.26),(-550,363,5.32);

-- group 551: 7 item(s), e.g. Tallgrass Guerilla's Tunic
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-551;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-551,344,5.26),(-551,345,5.26),(-551,346,5.26),(-551,347,5.26),(-551,348,5.26),(-551,349,5.26),(-551,350,5.26),(-551,351,5.26),(-551,353,5.26),(-551,354,5.26),(-551,355,5.26),(-551,356,5.26),(-551,357,5.26),(-551,358,5.26),(-551,359,5.26),(-551,360,5.26),(-551,361,5.26),(-551,362,5.26),(-551,363,5.32);

-- group 552: 7 item(s), e.g. Dissident's Boots
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-552;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-552,344,7.14),(-552,345,7.14),(-552,346,7.14),(-552,347,7.14),(-552,348,7.14),(-552,349,7.14),(-552,350,7.14),(-552,351,7.14),(-552,358,7.14),(-552,359,7.14),(-552,360,7.14),(-552,361,7.14),(-552,362,7.14),(-552,363,7.18);

-- group 553: 7 item(s), e.g. Crimson Schism Chestpiece
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-553;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-553,344,5.26),(-553,345,5.26),(-553,346,5.26),(-553,347,5.26),(-553,348,5.26),(-553,349,5.26),(-553,350,5.26),(-553,351,5.26),(-553,353,5.26),(-553,354,5.26),(-553,355,5.26),(-553,356,5.26),(-553,357,5.26),(-553,358,5.26),(-553,359,5.26),(-553,360,5.26),(-553,361,5.26),(-553,362,5.26),(-553,363,5.32);

-- group 554: 14 item(s), e.g. Crimson Schism Chestpiece
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-554;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-554,344,5.26),(-554,345,5.26),(-554,346,5.26),(-554,347,5.26),(-554,348,5.26),(-554,349,5.26),(-554,350,5.26),(-554,351,5.26),(-554,353,5.26),(-554,354,5.26),(-554,355,5.26),(-554,356,5.26),(-554,357,5.26),(-554,358,5.26),(-554,359,5.26),(-554,360,5.26),(-554,361,5.26),(-554,362,5.26),(-554,363,5.32);

-- group 555: 7 item(s), e.g. Secessionist's Gauntlets
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-555;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-555,344,5.88),(-555,345,5.88),(-555,346,5.88),(-555,347,5.88),(-555,348,5.88),(-555,349,5.88),(-555,350,5.88),(-555,351,5.88),(-555,352,5.88),(-555,364,5.88),(-555,365,5.88),(-555,366,5.88),(-555,367,5.88),(-555,368,5.88),(-555,369,5.88),(-555,370,5.88),(-555,371,5.92);

-- group 556: 7 item(s), e.g. Secessionist's Breastplate
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-556;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-556,344,5.88),(-556,345,5.88),(-556,346,5.88),(-556,347,5.88),(-556,348,5.88),(-556,349,5.88),(-556,350,5.88),(-556,351,5.88),(-556,352,5.88),(-556,364,5.88),(-556,365,5.88),(-556,366,5.88),(-556,367,5.88),(-556,368,5.88),(-556,369,5.88),(-556,370,5.88),(-556,371,5.92);

-- group 557: 7 item(s), e.g. Reformationist's Sandals
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-557;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-557,344,7.14),(-557,345,7.14),(-557,346,7.14),(-557,347,7.14),(-557,348,7.14),(-557,349,7.14),(-557,350,7.14),(-557,351,7.14),(-557,358,7.14),(-557,359,7.14),(-557,360,7.14),(-557,361,7.14),(-557,362,7.14),(-557,363,7.18);

-- group 558: 7 item(s), e.g. Disowner's Tunic
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-558;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-558,344,5.26),(-558,345,5.26),(-558,346,5.26),(-558,347,5.26),(-558,348,5.26),(-558,349,5.26),(-558,350,5.26),(-558,351,5.26),(-558,353,5.26),(-558,354,5.26),(-558,355,5.26),(-558,356,5.26),(-558,357,5.26),(-558,358,5.26),(-558,359,5.26),(-558,360,5.26),(-558,361,5.26),(-558,362,5.26),(-558,363,5.32);

-- group 559: 7 item(s), e.g. Unbending Spirit Coif
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-559;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-559,344,5.26),(-559,345,5.26),(-559,346,5.26),(-559,347,5.26),(-559,348,5.26),(-559,349,5.26),(-559,350,5.26),(-559,351,5.26),(-559,353,5.26),(-559,354,5.26),(-559,355,5.26),(-559,356,5.26),(-559,357,5.26),(-559,358,5.26),(-559,359,5.26),(-559,360,5.26),(-559,361,5.26),(-559,362,5.26),(-559,363,5.32);

-- group 560: 7 item(s), e.g. Unbending Spirit Kilt
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-560;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-560,344,5.26),(-560,345,5.26),(-560,346,5.26),(-560,347,5.26),(-560,348,5.26),(-560,349,5.26),(-560,350,5.26),(-560,351,5.26),(-560,353,5.26),(-560,354,5.26),(-560,355,5.26),(-560,356,5.26),(-560,357,5.26),(-560,358,5.26),(-560,359,5.26),(-560,360,5.26),(-560,361,5.26),(-560,362,5.26),(-560,363,5.32);

-- group 561: 7 item(s), e.g. Perjurious Sandals
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-561;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-561,344,7.14),(-561,345,7.14),(-561,346,7.14),(-561,347,7.14),(-561,348,7.14),(-561,349,7.14),(-561,350,7.14),(-561,351,7.14),(-561,358,7.14),(-561,359,7.14),(-561,360,7.14),(-561,361,7.14),(-561,362,7.14),(-561,363,7.18);

-- group 562: 7 item(s), e.g. Insurrection Breastplate
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-562;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-562,344,5.88),(-562,345,5.88),(-562,346,5.88),(-562,347,5.88),(-562,348,5.88),(-562,349,5.88),(-562,350,5.88),(-562,351,5.88),(-562,352,5.88),(-562,364,5.88),(-562,365,5.88),(-562,366,5.88),(-562,367,5.88),(-562,368,5.88),(-562,369,5.88),(-562,370,5.88),(-562,371,5.92);

-- group 563: 7 item(s), e.g. Insurrection Spaulders
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-563;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-563,344,5.88),(-563,345,5.88),(-563,346,5.88),(-563,347,5.88),(-563,348,5.88),(-563,349,5.88),(-563,350,5.88),(-563,351,5.88),(-563,352,5.88),(-563,364,5.88),(-563,365,5.88),(-563,366,5.88),(-563,367,5.88),(-563,368,5.88),(-563,369,5.88),(-563,370,5.88),(-563,371,5.92);

-- group 564: 7 item(s), e.g. Secessionist's Breastplate
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-564;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-564,344,5.88),(-564,345,5.88),(-564,346,5.88),(-564,347,5.88),(-564,348,5.88),(-564,349,5.88),(-564,350,5.88),(-564,351,5.88),(-564,352,5.88),(-564,364,5.88),(-564,365,5.88),(-564,366,5.88),(-564,367,5.88),(-564,368,5.88),(-564,369,5.88),(-564,370,5.88),(-564,371,5.92);

-- group 565: 11 item(s), e.g. Thunder Bastion Drape
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-565;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-565,344,5.88),(-565,345,5.88),(-565,346,5.88),(-565,347,5.88),(-565,348,5.88),(-565,349,5.88),(-565,350,5.88),(-565,351,5.88),(-565,352,5.88),(-565,364,5.88),(-565,365,5.88),(-565,366,5.88),(-565,367,5.88),(-565,368,5.88),(-565,369,5.88),(-565,370,5.88),(-565,371,5.92);

-- group 566: 11 item(s), e.g. Doubtcrusher Drape
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-566;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-566,344,5.88),(-566,345,5.88),(-566,346,5.88),(-566,347,5.88),(-566,348,5.88),(-566,349,5.88),(-566,350,5.88),(-566,351,5.88),(-566,352,5.88),(-566,364,5.88),(-566,365,5.88),(-566,366,5.88),(-566,367,5.88),(-566,368,5.88),(-566,369,5.88),(-566,370,5.88),(-566,371,5.92);

-- group 567: 8 item(s), e.g. Ale-Boiled Jerkin
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-567;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-567,344,5.26),(-567,345,5.26),(-567,346,5.26),(-567,347,5.26),(-567,348,5.26),(-567,349,5.26),(-567,350,5.26),(-567,351,5.26),(-567,353,5.26),(-567,354,5.26),(-567,355,5.26),(-567,356,5.26),(-567,357,5.26),(-567,358,5.26),(-567,359,5.26),(-567,360,5.26),(-567,361,5.26),(-567,362,5.26),(-567,363,5.32);

-- group 569: 2 item(s), e.g. Scavenged Pandaren Gun
--   suffixes: of the Galeburst, of the Stormblast, of the Windflurry, of the Windstorm, of the Zephyr
DELETE FROM `item_enchantment_template` WHERE `entry`=-569;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-569,133,20.0),(-569,134,20.0),(-569,135,20.0),(-569,136,20.0),(-569,137,20.0);

-- group 570: 11 item(s), e.g. Sha-Seeker Cloak
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-570;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-570,344,7.14),(-570,345,7.14),(-570,346,7.14),(-570,347,7.14),(-570,348,7.14),(-570,349,7.14),(-570,350,7.14),(-570,351,7.14),(-570,358,7.14),(-570,359,7.14),(-570,360,7.14),(-570,361,7.14),(-570,362,7.14),(-570,363,7.18);

-- group 573: 8 item(s), e.g. Lightning Pillar Breastplate
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-573;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-573,344,5.88),(-573,345,5.88),(-573,346,5.88),(-573,347,5.88),(-573,348,5.88),(-573,349,5.88),(-573,350,5.88),(-573,351,5.88),(-573,352,5.88),(-573,364,5.88),(-573,365,5.88),(-573,366,5.88),(-573,367,5.88),(-573,368,5.88),(-573,369,5.88),(-573,370,5.88),(-573,371,5.92);

-- group 576: 11 item(s), e.g. Heartlander's Cloak
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-576;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-576,344,7.14),(-576,345,7.14),(-576,346,7.14),(-576,347,7.14),(-576,348,7.14),(-576,349,7.14),(-576,350,7.14),(-576,351,7.14),(-576,358,7.14),(-576,359,7.14),(-576,360,7.14),(-576,361,7.14),(-576,362,7.14),(-576,363,7.18);

-- group 577: 19 item(s), e.g. Mist Splitter's Cloak
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-577;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-577,344,5.26),(-577,345,5.26),(-577,346,5.26),(-577,347,5.26),(-577,348,5.26),(-577,349,5.26),(-577,350,5.26),(-577,351,5.26),(-577,353,5.26),(-577,354,5.26),(-577,355,5.26),(-577,356,5.26),(-577,357,5.26),(-577,358,5.26),(-577,359,5.26),(-577,360,5.26),(-577,361,5.26),(-577,362,5.26),(-577,363,5.32);

-- group 578: 8 item(s), e.g. Mountaineer's Vest
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-578;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-578,344,5.26),(-578,345,5.26),(-578,346,5.26),(-578,347,5.26),(-578,348,5.26),(-578,349,5.26),(-578,350,5.26),(-578,351,5.26),(-578,353,5.26),(-578,354,5.26),(-578,355,5.26),(-578,356,5.26),(-578,357,5.26),(-578,358,5.26),(-578,359,5.26),(-578,360,5.26),(-578,361,5.26),(-578,362,5.26),(-578,363,5.32);

-- group 583: 8 item(s), e.g. Immaculate Pandaren Greatsword
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Galeburst, of the Impatient, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-583;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-583,344,4.55),(-583,345,4.55),(-583,346,4.55),(-583,347,4.55),(-583,348,4.55),(-583,349,4.55),(-583,350,4.55),(-583,351,4.55),(-583,352,4.55),(-583,364,4.55),(-583,365,4.55),(-583,366,4.55),(-583,367,4.55),(-583,368,4.55),(-583,369,4.55),(-583,370,4.55),(-583,371,4.55),(-583,353,4.55),(-583,354,4.55),(-583,355,4.55),(-583,356,4.55),(-583,357,4.45);

-- group 584: 8 item(s), e.g. Immaculate Pandaren Greatsword
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Galeburst, of the Impatient, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-584;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-584,344,4.55),(-584,345,4.55),(-584,346,4.55),(-584,347,4.55),(-584,348,4.55),(-584,349,4.55),(-584,350,4.55),(-584,351,4.55),(-584,352,4.55),(-584,364,4.55),(-584,365,4.55),(-584,366,4.55),(-584,367,4.55),(-584,368,4.55),(-584,369,4.55),(-584,370,4.55),(-584,371,4.55),(-584,353,4.55),(-584,354,4.55),(-584,355,4.55),(-584,356,4.55),(-584,357,4.45);

-- group 585: 9 item(s), e.g. Immaculate Pandaren Spear
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Galeburst, of the Impatient, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-585;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-585,344,4.55),(-585,345,4.55),(-585,346,4.55),(-585,347,4.55),(-585,348,4.55),(-585,349,4.55),(-585,350,4.55),(-585,351,4.55),(-585,352,4.55),(-585,364,4.55),(-585,365,4.55),(-585,366,4.55),(-585,367,4.55),(-585,368,4.55),(-585,369,4.55),(-585,370,4.55),(-585,371,4.55),(-585,353,4.55),(-585,354,4.55),(-585,355,4.55),(-585,356,4.55),(-585,357,4.45);

-- group 586: 6 item(s), e.g. Immaculate Pandaren Scepter
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-586;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-586,344,7.14),(-586,345,7.14),(-586,346,7.14),(-586,347,7.14),(-586,348,7.14),(-586,349,7.14),(-586,350,7.14),(-586,351,7.14),(-586,358,7.14),(-586,359,7.14),(-586,360,7.14),(-586,361,7.14),(-586,362,7.14),(-586,363,7.18);

-- group 587: 4 item(s), e.g. Immaculate Pandaren Staff
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-587;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-587,344,7.14),(-587,345,7.14),(-587,346,7.14),(-587,347,7.14),(-587,348,7.14),(-587,349,7.14),(-587,350,7.14),(-587,351,7.14),(-587,358,7.14),(-587,359,7.14),(-587,360,7.14),(-587,361,7.14),(-587,362,7.14),(-587,363,7.18);

-- group 629: 1 item(s), e.g. Cliffbreaker Helm
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-629;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-629,461,5.88),(-629,462,5.88),(-629,463,5.88),(-629,464,5.88),(-629,465,5.88),(-629,466,5.88),(-629,467,5.88),(-629,468,5.88),(-629,469,5.88),(-629,481,5.88),(-629,482,5.88),(-629,483,5.88),(-629,484,5.88),(-629,485,5.88),(-629,486,5.88),(-629,487,5.88),(-629,488,5.92);

-- group 630: 1 item(s), e.g. Elder Tortoiseshell Helm
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-630;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-630,461,5.88),(-630,462,5.88),(-630,463,5.88),(-630,464,5.88),(-630,465,5.88),(-630,466,5.88),(-630,467,5.88),(-630,468,5.88),(-630,469,5.88),(-630,481,5.88),(-630,482,5.88),(-630,483,5.88),(-630,484,5.88),(-630,485,5.88),(-630,486,5.88),(-630,487,5.88),(-630,488,5.92);

-- group 631: 2 item(s), e.g. Crimsonscale Helm
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-631;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-631,461,5.26),(-631,462,5.26),(-631,463,5.26),(-631,464,5.26),(-631,465,5.26),(-631,466,5.26),(-631,467,5.26),(-631,468,5.26),(-631,470,5.26),(-631,471,5.26),(-631,472,5.26),(-631,473,5.26),(-631,474,5.26),(-631,475,5.26),(-631,476,5.26),(-631,477,5.26),(-631,478,5.26),(-631,479,5.26),(-631,480,5.32);

-- group 632: 4 item(s), e.g. Fire-Chanter Hood
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Feverflare, of the Fireflash,
DELETE FROM `item_enchantment_template` WHERE `entry`=-632;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-632,461,3.57),(-632,462,3.57),(-632,463,3.57),(-632,464,3.57),(-632,465,3.57),(-632,466,3.57),(-632,467,3.57),(-632,468,3.57),(-632,469,3.57),(-632,481,3.57),(-632,482,3.57),(-632,483,3.57),(-632,484,3.57),(-632,485,3.57),(-632,486,3.57),(-632,487,3.57),(-632,488,3.57),(-632,470,3.57),(-632,471,3.57),(-632,472,3.57),(-632,473,3.57),(-632,474,3.57),(-632,475,3.57),(-632,476,3.57),(-632,477,3.57),(-632,478,3.57),(-632,479,3.57),(-632,480,3.61);

-- group 633: 1 item(s), e.g. Cloudscorcher Cowl
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-633;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-633,461,7.14),(-633,462,7.14),(-633,463,7.14),(-633,464,7.14),(-633,465,7.14),(-633,466,7.14),(-633,467,7.14),(-633,468,7.14),(-633,475,7.14),(-633,476,7.14),(-633,477,7.14),(-633,478,7.14),(-633,479,7.14),(-633,480,7.18);

-- group 634: 2 item(s), e.g. Cliffbreaker Breastplate
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-634;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-634,461,5.88),(-634,462,5.88),(-634,463,5.88),(-634,464,5.88),(-634,465,5.88),(-634,466,5.88),(-634,467,5.88),(-634,468,5.88),(-634,469,5.88),(-634,481,5.88),(-634,482,5.88),(-634,483,5.88),(-634,484,5.88),(-634,485,5.88),(-634,486,5.88),(-634,487,5.88),(-634,488,5.92);

-- group 635: 2 item(s), e.g. Elder Tortoiseshell Breastplate
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-635;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-635,461,5.88),(-635,462,5.88),(-635,463,5.88),(-635,464,5.88),(-635,465,5.88),(-635,466,5.88),(-635,467,5.88),(-635,468,5.88),(-635,469,5.88),(-635,481,5.88),(-635,482,5.88),(-635,483,5.88),(-635,484,5.88),(-635,485,5.88),(-635,486,5.88),(-635,487,5.88),(-635,488,5.92);

-- group 636: 4 item(s), e.g. Crimsonscale Legguards
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-636;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-636,461,5.26),(-636,462,5.26),(-636,463,5.26),(-636,464,5.26),(-636,465,5.26),(-636,466,5.26),(-636,467,5.26),(-636,468,5.26),(-636,470,5.26),(-636,471,5.26),(-636,472,5.26),(-636,473,5.26),(-636,474,5.26),(-636,475,5.26),(-636,476,5.26),(-636,477,5.26),(-636,478,5.26),(-636,479,5.26),(-636,480,5.32);

-- group 637: 8 item(s), e.g. Fire-Chanter Britches
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Feverflare, of the Fireflash,
DELETE FROM `item_enchantment_template` WHERE `entry`=-637;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-637,461,3.57),(-637,462,3.57),(-637,463,3.57),(-637,464,3.57),(-637,465,3.57),(-637,466,3.57),(-637,467,3.57),(-637,468,3.57),(-637,469,3.57),(-637,481,3.57),(-637,482,3.57),(-637,483,3.57),(-637,484,3.57),(-637,485,3.57),(-637,486,3.57),(-637,487,3.57),(-637,488,3.57),(-637,470,3.57),(-637,471,3.57),(-637,472,3.57),(-637,473,3.57),(-637,474,3.57),(-637,475,3.57),(-637,476,3.57),(-637,477,3.57),(-637,478,3.57),(-637,479,3.57),(-637,480,3.61);

-- group 638: 2 item(s), e.g. Cloudscorcher Leggings
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-638;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-638,461,7.14),(-638,462,7.14),(-638,463,7.14),(-638,464,7.14),(-638,465,7.14),(-638,466,7.14),(-638,467,7.14),(-638,468,7.14),(-638,475,7.14),(-638,476,7.14),(-638,477,7.14),(-638,478,7.14),(-638,479,7.14),(-638,480,7.18);

-- group 639: 2 item(s), e.g. Cliffbreaker Breastplate
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-639;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-639,461,5.88),(-639,462,5.88),(-639,463,5.88),(-639,464,5.88),(-639,465,5.88),(-639,466,5.88),(-639,467,5.88),(-639,468,5.88),(-639,469,5.88),(-639,481,5.88),(-639,482,5.88),(-639,483,5.88),(-639,484,5.88),(-639,485,5.88),(-639,486,5.88),(-639,487,5.88),(-639,488,5.92);

-- group 640: 2 item(s), e.g. Elder Tortoiseshell Breastplate
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-640;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-640,461,5.88),(-640,462,5.88),(-640,463,5.88),(-640,464,5.88),(-640,465,5.88),(-640,466,5.88),(-640,467,5.88),(-640,468,5.88),(-640,469,5.88),(-640,481,5.88),(-640,482,5.88),(-640,483,5.88),(-640,484,5.88),(-640,485,5.88),(-640,486,5.88),(-640,487,5.88),(-640,488,5.92);

-- group 641: 4 item(s), e.g. Crimsonscale Legguards
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-641;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-641,461,5.26),(-641,462,5.26),(-641,463,5.26),(-641,464,5.26),(-641,465,5.26),(-641,466,5.26),(-641,467,5.26),(-641,468,5.26),(-641,470,5.26),(-641,471,5.26),(-641,472,5.26),(-641,473,5.26),(-641,474,5.26),(-641,475,5.26),(-641,476,5.26),(-641,477,5.26),(-641,478,5.26),(-641,479,5.26),(-641,480,5.32);

-- group 642: 8 item(s), e.g. Fire-Chanter Britches
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Feverflare, of the Fireflash,
DELETE FROM `item_enchantment_template` WHERE `entry`=-642;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-642,461,3.57),(-642,462,3.57),(-642,463,3.57),(-642,464,3.57),(-642,465,3.57),(-642,466,3.57),(-642,467,3.57),(-642,468,3.57),(-642,469,3.57),(-642,481,3.57),(-642,482,3.57),(-642,483,3.57),(-642,484,3.57),(-642,485,3.57),(-642,486,3.57),(-642,487,3.57),(-642,488,3.57),(-642,470,3.57),(-642,471,3.57),(-642,472,3.57),(-642,473,3.57),(-642,474,3.57),(-642,475,3.57),(-642,476,3.57),(-642,477,3.57),(-642,478,3.57),(-642,479,3.57),(-642,480,3.61);

-- group 643: 2 item(s), e.g. Cloudscorcher Leggings
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-643;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-643,461,7.14),(-643,462,7.14),(-643,463,7.14),(-643,464,7.14),(-643,465,7.14),(-643,466,7.14),(-643,467,7.14),(-643,468,7.14),(-643,475,7.14),(-643,476,7.14),(-643,477,7.14),(-643,478,7.14),(-643,479,7.14),(-643,480,7.18);

-- group 644: 1 item(s), e.g. Cliffbreaker Helm
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-644;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-644,461,5.88),(-644,462,5.88),(-644,463,5.88),(-644,464,5.88),(-644,465,5.88),(-644,466,5.88),(-644,467,5.88),(-644,468,5.88),(-644,469,5.88),(-644,481,5.88),(-644,482,5.88),(-644,483,5.88),(-644,484,5.88),(-644,485,5.88),(-644,486,5.88),(-644,487,5.88),(-644,488,5.92);

-- group 645: 1 item(s), e.g. Elder Tortoiseshell Helm
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-645;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-645,461,5.88),(-645,462,5.88),(-645,463,5.88),(-645,464,5.88),(-645,465,5.88),(-645,466,5.88),(-645,467,5.88),(-645,468,5.88),(-645,469,5.88),(-645,481,5.88),(-645,482,5.88),(-645,483,5.88),(-645,484,5.88),(-645,485,5.88),(-645,486,5.88),(-645,487,5.88),(-645,488,5.92);

-- group 646: 2 item(s), e.g. Crimsonscale Helm
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-646;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-646,461,5.26),(-646,462,5.26),(-646,463,5.26),(-646,464,5.26),(-646,465,5.26),(-646,466,5.26),(-646,467,5.26),(-646,468,5.26),(-646,470,5.26),(-646,471,5.26),(-646,472,5.26),(-646,473,5.26),(-646,474,5.26),(-646,475,5.26),(-646,476,5.26),(-646,477,5.26),(-646,478,5.26),(-646,479,5.26),(-646,480,5.32);

-- group 647: 4 item(s), e.g. Fire-Chanter Hood
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Feverflare, of the Fireflash,
DELETE FROM `item_enchantment_template` WHERE `entry`=-647;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-647,461,3.57),(-647,462,3.57),(-647,463,3.57),(-647,464,3.57),(-647,465,3.57),(-647,466,3.57),(-647,467,3.57),(-647,468,3.57),(-647,469,3.57),(-647,481,3.57),(-647,482,3.57),(-647,483,3.57),(-647,484,3.57),(-647,485,3.57),(-647,486,3.57),(-647,487,3.57),(-647,488,3.57),(-647,470,3.57),(-647,471,3.57),(-647,472,3.57),(-647,473,3.57),(-647,474,3.57),(-647,475,3.57),(-647,476,3.57),(-647,477,3.57),(-647,478,3.57),(-647,479,3.57),(-647,480,3.61);

-- group 648: 1 item(s), e.g. Cloudscorcher Cowl
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-648;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-648,461,7.14),(-648,462,7.14),(-648,463,7.14),(-648,464,7.14),(-648,465,7.14),(-648,466,7.14),(-648,467,7.14),(-648,468,7.14),(-648,475,7.14),(-648,476,7.14),(-648,477,7.14),(-648,478,7.14),(-648,479,7.14),(-648,480,7.18);

-- group 651: 16 item(s), e.g. Elder Tortoiseshell Drape
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-651;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-651,461,5.88),(-651,462,5.88),(-651,463,5.88),(-651,464,5.88),(-651,465,5.88),(-651,466,5.88),(-651,467,5.88),(-651,468,5.88),(-651,469,5.88),(-651,481,5.88),(-651,482,5.88),(-651,483,5.88),(-651,484,5.88),(-651,485,5.88),(-651,486,5.88),(-651,487,5.88),(-651,488,5.92);

-- group 652: 16 item(s), e.g. Cliffbreaker Drape
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-652;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-652,461,5.88),(-652,462,5.88),(-652,463,5.88),(-652,464,5.88),(-652,465,5.88),(-652,466,5.88),(-652,467,5.88),(-652,468,5.88),(-652,469,5.88),(-652,481,5.88),(-652,482,5.88),(-652,483,5.88),(-652,484,5.88),(-652,485,5.88),(-652,486,5.88),(-652,487,5.88),(-652,488,5.92);

-- group 653: 26 item(s), e.g. Warmsun Choker
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-653;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-653,461,5.26),(-653,462,5.26),(-653,463,5.26),(-653,464,5.26),(-653,465,5.26),(-653,466,5.26),(-653,467,5.26),(-653,468,5.26),(-653,470,5.26),(-653,471,5.26),(-653,472,5.26),(-653,473,5.26),(-653,474,5.26),(-653,475,5.26),(-653,476,5.26),(-653,477,5.26),(-653,478,5.26),(-653,479,5.26),(-653,480,5.32);

-- group 654: 16 item(s), e.g. Cloudscorcher Belt
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-654;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-654,461,7.14),(-654,462,7.14),(-654,463,7.14),(-654,464,7.14),(-654,465,7.14),(-654,466,7.14),(-654,467,7.14),(-654,468,7.14),(-654,475,7.14),(-654,476,7.14),(-654,477,7.14),(-654,478,7.14),(-654,479,7.14),(-654,480,7.18);

-- group 655: 46 item(s), e.g. Fire-Chanter Bindings
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Feverflare, of the Fireflash,
DELETE FROM `item_enchantment_template` WHERE `entry`=-655;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-655,461,3.57),(-655,462,3.57),(-655,463,3.57),(-655,464,3.57),(-655,465,3.57),(-655,466,3.57),(-655,467,3.57),(-655,468,3.57),(-655,469,3.57),(-655,481,3.57),(-655,482,3.57),(-655,483,3.57),(-655,484,3.57),(-655,485,3.57),(-655,486,3.57),(-655,487,3.57),(-655,488,3.57),(-655,470,3.57),(-655,471,3.57),(-655,472,3.57),(-655,473,3.57),(-655,474,3.57),(-655,475,3.57),(-655,476,3.57),(-655,477,3.57),(-655,478,3.57),(-655,479,3.57),(-655,480,3.61);

-- ============================================================
-- MaNGOS Four world DB update (round 2): M4v2_08_item_random_suffix_groups.sql
-- Adds the 69 missing random-suffix groups to `item_enchantment_template`
-- (negative `entry` = suffix group, `ench` = ItemRandomSuffix.dbc id).
-- Fixes 1,460 startup log lines and restores random suffixes on 730 MoP items
-- (Windwool, Ghost-Forged, Barrens sets, Immaculate weapons, Timeless Isle gear...).
--
-- DERIVATION NOTE: Blizzard's group->suffix mapping is not shipped with the
-- client; these pools were derived from the 5.4.8 ItemRandomSuffix.dbc you
-- provided, matched to each group's member items by armour class and content
-- tier (5.0 generic / 5.3 / 5.4 blocks, identified by the DBC internal names).
-- Equal chances per suffix, summing to 100. Stat values scale automatically
-- from the DBC AllocationPct, so one group serves items of different ilvls.
-- ============================================================

-- group 415: 16 item(s), e.g. Windwool Hood
--   suffixes: of the Feverflare, of the Fireflash, of the Undertow, of the Wavecrest, of the Wildfire
DELETE FROM `item_enchantment_template` WHERE `entry`=-415;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-415,129,20.0),(-415,130,20.0),(-415,131,20.0),(-415,132,20.0),(-415,138,20.0);

-- group 528: 57 item(s), e.g. Stormbrew Vest
--   suffixes: of the Feverflare, of the Fireflash, of the Galeburst, of the Stormblast, of the Undertow, of the Wavecrest, of the Wildfire, of the Windflurry, of the Windstorm, of the Zephyr
DELETE FROM `item_enchantment_template` WHERE `entry`=-528;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-528,133,10.0),(-528,134,10.0),(-528,135,10.0),(-528,136,10.0),(-528,137,10.0),(-528,129,10.0),(-528,130,10.0),(-528,131,10.0),(-528,132,10.0),(-528,138,10.0);

-- group 529: 34 item(s), e.g. Greenstone Vambraces
--   suffixes: of the Bedrock, of the Bouldercrag, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Landslide, of the Mountainbed, of the Rockslab, of the Substratum
DELETE FROM `item_enchantment_template` WHERE `entry`=-529;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-529,120,11.11),(-529,121,11.11),(-529,122,11.11),(-529,123,11.11),(-529,124,11.11),(-529,125,11.11),(-529,126,11.11),(-529,127,11.11),(-529,128,11.12);

-- group 530: 33 item(s), e.g. Firewool Wristwraps
--   suffixes: of the Feverflare, of the Fireflash, of the Undertow, of the Wavecrest, of the Wildfire
DELETE FROM `item_enchantment_template` WHERE `entry`=-530;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-530,129,20.0),(-530,130,20.0),(-530,131,20.0),(-530,132,20.0),(-530,138,20.0);

-- group 531: 105 item(s), e.g. Mogu-Wrought Breastplate
--   suffixes: of the Bedrock, of the Bouldercrag, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Feverflare, of the Fireflash, of the Galeburst, of the Landslide, of the Mountainbed, of the Rocks
DELETE FROM `item_enchantment_template` WHERE `entry`=-531;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-531,129,5.26),(-531,130,5.26),(-531,131,5.26),(-531,132,5.26),(-531,138,5.26),(-531,133,5.26),(-531,134,5.26),(-531,135,5.26),(-531,136,5.26),(-531,137,5.26),(-531,120,5.26),(-531,121,5.26),(-531,122,5.26),(-531,123,5.26),(-531,124,5.26),(-531,125,5.26),(-531,126,5.26),(-531,127,5.26),(-531,128,5.32);

-- group 532: 16 item(s), e.g. Ghost-Forged Helm
--   suffixes: of the Bedrock, of the Bouldercrag, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Landslide, of the Mountainbed, of the Rockslab, of the Substratum
DELETE FROM `item_enchantment_template` WHERE `entry`=-532;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-532,120,11.11),(-532,121,11.11),(-532,122,11.11),(-532,123,11.11),(-532,124,11.11),(-532,125,11.11),(-532,126,11.11),(-532,127,11.11),(-532,128,11.12);

-- group 533: 1 item(s), e.g. Scavenged Pandaren Spear
--   suffixes: of the Bedrock, of the Bouldercrag, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Galeburst, of the Landslide, of the Mountainbed, of the Rockslab, of the Stormblast, of the Substr
DELETE FROM `item_enchantment_template` WHERE `entry`=-533;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-533,133,7.14),(-533,134,7.14),(-533,135,7.14),(-533,136,7.14),(-533,137,7.14),(-533,120,7.14),(-533,121,7.14),(-533,122,7.14),(-533,123,7.14),(-533,124,7.14),(-533,125,7.14),(-533,126,7.14),(-533,127,7.14),(-533,128,7.18);

-- group 534: 1 item(s), e.g. Scavenged Pandaren Spear
--   suffixes: of the Bedrock, of the Bouldercrag, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Galeburst, of the Landslide, of the Mountainbed, of the Rockslab, of the Stormblast, of the Substr
DELETE FROM `item_enchantment_template` WHERE `entry`=-534;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-534,133,7.14),(-534,134,7.14),(-534,135,7.14),(-534,136,7.14),(-534,137,7.14),(-534,120,7.14),(-534,121,7.14),(-534,122,7.14),(-534,123,7.14),(-534,124,7.14),(-534,125,7.14),(-534,126,7.14),(-534,127,7.14),(-534,128,7.18);

-- group 539: 1 item(s), e.g. Loa-Binder Disc
--   suffixes: of the Bedrock, of the Bouldercrag, of the Feverflare, of the Fireflash, of the Rockslab, of the Undertow, of the Wavecrest, of the Wildfire
DELETE FROM `item_enchantment_template` WHERE `entry`=-539;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-539,125,12.5),(-539,127,12.5),(-539,128,12.5),(-539,129,12.5),(-539,130,12.5),(-539,131,12.5),(-539,132,12.5),(-539,138,12.5);

-- group 541: 20 item(s), e.g. Beady-Eye Bracers
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Impatient, of the Pious, of the Savant, of the Unerring, of the Untouchable
DELETE FROM `item_enchantment_template` WHERE `entry`=-541;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-541,344,12.5),(-541,345,12.5),(-541,346,12.5),(-541,347,12.5),(-541,348,12.5),(-541,349,12.5),(-541,350,12.5),(-541,351,12.5);

-- group 542: 10 item(s), e.g. Armplates of the Vanquished Abomination
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Impatient, of the Pious, of the Savant, of the Unerring, of the Untouchable
DELETE FROM `item_enchantment_template` WHERE `entry`=-542;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-542,344,12.5),(-542,345,12.5),(-542,346,12.5),(-542,347,12.5),(-542,348,12.5),(-542,349,12.5),(-542,350,12.5),(-542,351,12.5);

-- group 543: 5 item(s), e.g. Bracers of Constant Implosion
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Impatient, of the Pious, of the Savant, of the Unerring, of the Untouchable
DELETE FROM `item_enchantment_template` WHERE `entry`=-543;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-543,344,12.5),(-543,345,12.5),(-543,346,12.5),(-543,347,12.5),(-543,348,12.5),(-543,349,12.5),(-543,350,12.5),(-543,351,12.5);

-- group 547: 7 item(s), e.g. Insubordination Gauntlets
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-547;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-547,344,5.88),(-547,345,5.88),(-547,346,5.88),(-547,347,5.88),(-547,348,5.88),(-547,349,5.88),(-547,350,5.88),(-547,351,5.88),(-547,352,5.88),(-547,364,5.88),(-547,365,5.88),(-547,366,5.88),(-547,367,5.88),(-547,368,5.88),(-547,369,5.88),(-547,370,5.88),(-547,371,5.92);

-- group 548: 7 item(s), e.g. Insubordination Breastplate
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-548;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-548,344,5.88),(-548,345,5.88),(-548,346,5.88),(-548,347,5.88),(-548,348,5.88),(-548,349,5.88),(-548,350,5.88),(-548,351,5.88),(-548,352,5.88),(-548,364,5.88),(-548,365,5.88),(-548,366,5.88),(-548,367,5.88),(-548,368,5.88),(-548,369,5.88),(-548,370,5.88),(-548,371,5.92);

-- group 549: 7 item(s), e.g. Malcontent's Belt
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-549;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-549,344,5.26),(-549,345,5.26),(-549,346,5.26),(-549,347,5.26),(-549,348,5.26),(-549,349,5.26),(-549,350,5.26),(-549,351,5.26),(-549,353,5.26),(-549,354,5.26),(-549,355,5.26),(-549,356,5.26),(-549,357,5.26),(-549,358,5.26),(-549,359,5.26),(-549,360,5.26),(-549,361,5.26),(-549,362,5.26),(-549,363,5.32);

-- group 550: 7 item(s), e.g. Malcontent's Vest
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-550;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-550,344,5.26),(-550,345,5.26),(-550,346,5.26),(-550,347,5.26),(-550,348,5.26),(-550,349,5.26),(-550,350,5.26),(-550,351,5.26),(-550,353,5.26),(-550,354,5.26),(-550,355,5.26),(-550,356,5.26),(-550,357,5.26),(-550,358,5.26),(-550,359,5.26),(-550,360,5.26),(-550,361,5.26),(-550,362,5.26),(-550,363,5.32);

-- group 551: 7 item(s), e.g. Tallgrass Guerilla's Tunic
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-551;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-551,344,5.26),(-551,345,5.26),(-551,346,5.26),(-551,347,5.26),(-551,348,5.26),(-551,349,5.26),(-551,350,5.26),(-551,351,5.26),(-551,353,5.26),(-551,354,5.26),(-551,355,5.26),(-551,356,5.26),(-551,357,5.26),(-551,358,5.26),(-551,359,5.26),(-551,360,5.26),(-551,361,5.26),(-551,362,5.26),(-551,363,5.32);

-- group 552: 7 item(s), e.g. Dissident's Boots
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-552;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-552,344,7.14),(-552,345,7.14),(-552,346,7.14),(-552,347,7.14),(-552,348,7.14),(-552,349,7.14),(-552,350,7.14),(-552,351,7.14),(-552,358,7.14),(-552,359,7.14),(-552,360,7.14),(-552,361,7.14),(-552,362,7.14),(-552,363,7.18);

-- group 553: 7 item(s), e.g. Crimson Schism Chestpiece
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-553;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-553,344,5.26),(-553,345,5.26),(-553,346,5.26),(-553,347,5.26),(-553,348,5.26),(-553,349,5.26),(-553,350,5.26),(-553,351,5.26),(-553,353,5.26),(-553,354,5.26),(-553,355,5.26),(-553,356,5.26),(-553,357,5.26),(-553,358,5.26),(-553,359,5.26),(-553,360,5.26),(-553,361,5.26),(-553,362,5.26),(-553,363,5.32);

-- group 554: 14 item(s), e.g. Crimson Schism Chestpiece
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-554;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-554,344,5.26),(-554,345,5.26),(-554,346,5.26),(-554,347,5.26),(-554,348,5.26),(-554,349,5.26),(-554,350,5.26),(-554,351,5.26),(-554,353,5.26),(-554,354,5.26),(-554,355,5.26),(-554,356,5.26),(-554,357,5.26),(-554,358,5.26),(-554,359,5.26),(-554,360,5.26),(-554,361,5.26),(-554,362,5.26),(-554,363,5.32);

-- group 555: 7 item(s), e.g. Secessionist's Gauntlets
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-555;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-555,344,5.88),(-555,345,5.88),(-555,346,5.88),(-555,347,5.88),(-555,348,5.88),(-555,349,5.88),(-555,350,5.88),(-555,351,5.88),(-555,352,5.88),(-555,364,5.88),(-555,365,5.88),(-555,366,5.88),(-555,367,5.88),(-555,368,5.88),(-555,369,5.88),(-555,370,5.88),(-555,371,5.92);

-- group 556: 7 item(s), e.g. Secessionist's Breastplate
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-556;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-556,344,5.88),(-556,345,5.88),(-556,346,5.88),(-556,347,5.88),(-556,348,5.88),(-556,349,5.88),(-556,350,5.88),(-556,351,5.88),(-556,352,5.88),(-556,364,5.88),(-556,365,5.88),(-556,366,5.88),(-556,367,5.88),(-556,368,5.88),(-556,369,5.88),(-556,370,5.88),(-556,371,5.92);

-- group 557: 7 item(s), e.g. Reformationist's Sandals
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-557;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-557,344,7.14),(-557,345,7.14),(-557,346,7.14),(-557,347,7.14),(-557,348,7.14),(-557,349,7.14),(-557,350,7.14),(-557,351,7.14),(-557,358,7.14),(-557,359,7.14),(-557,360,7.14),(-557,361,7.14),(-557,362,7.14),(-557,363,7.18);

-- group 558: 7 item(s), e.g. Disowner's Tunic
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-558;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-558,344,5.26),(-558,345,5.26),(-558,346,5.26),(-558,347,5.26),(-558,348,5.26),(-558,349,5.26),(-558,350,5.26),(-558,351,5.26),(-558,353,5.26),(-558,354,5.26),(-558,355,5.26),(-558,356,5.26),(-558,357,5.26),(-558,358,5.26),(-558,359,5.26),(-558,360,5.26),(-558,361,5.26),(-558,362,5.26),(-558,363,5.32);

-- group 559: 7 item(s), e.g. Unbending Spirit Coif
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-559;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-559,344,5.26),(-559,345,5.26),(-559,346,5.26),(-559,347,5.26),(-559,348,5.26),(-559,349,5.26),(-559,350,5.26),(-559,351,5.26),(-559,353,5.26),(-559,354,5.26),(-559,355,5.26),(-559,356,5.26),(-559,357,5.26),(-559,358,5.26),(-559,359,5.26),(-559,360,5.26),(-559,361,5.26),(-559,362,5.26),(-559,363,5.32);

-- group 560: 7 item(s), e.g. Unbending Spirit Kilt
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-560;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-560,344,5.26),(-560,345,5.26),(-560,346,5.26),(-560,347,5.26),(-560,348,5.26),(-560,349,5.26),(-560,350,5.26),(-560,351,5.26),(-560,353,5.26),(-560,354,5.26),(-560,355,5.26),(-560,356,5.26),(-560,357,5.26),(-560,358,5.26),(-560,359,5.26),(-560,360,5.26),(-560,361,5.26),(-560,362,5.26),(-560,363,5.32);

-- group 561: 7 item(s), e.g. Perjurious Sandals
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-561;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-561,344,7.14),(-561,345,7.14),(-561,346,7.14),(-561,347,7.14),(-561,348,7.14),(-561,349,7.14),(-561,350,7.14),(-561,351,7.14),(-561,358,7.14),(-561,359,7.14),(-561,360,7.14),(-561,361,7.14),(-561,362,7.14),(-561,363,7.18);

-- group 562: 7 item(s), e.g. Insurrection Breastplate
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-562;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-562,344,5.88),(-562,345,5.88),(-562,346,5.88),(-562,347,5.88),(-562,348,5.88),(-562,349,5.88),(-562,350,5.88),(-562,351,5.88),(-562,352,5.88),(-562,364,5.88),(-562,365,5.88),(-562,366,5.88),(-562,367,5.88),(-562,368,5.88),(-562,369,5.88),(-562,370,5.88),(-562,371,5.92);

-- group 563: 7 item(s), e.g. Insurrection Spaulders
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-563;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-563,344,5.88),(-563,345,5.88),(-563,346,5.88),(-563,347,5.88),(-563,348,5.88),(-563,349,5.88),(-563,350,5.88),(-563,351,5.88),(-563,352,5.88),(-563,364,5.88),(-563,365,5.88),(-563,366,5.88),(-563,367,5.88),(-563,368,5.88),(-563,369,5.88),(-563,370,5.88),(-563,371,5.92);

-- group 564: 7 item(s), e.g. Secessionist's Breastplate
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-564;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-564,344,5.88),(-564,345,5.88),(-564,346,5.88),(-564,347,5.88),(-564,348,5.88),(-564,349,5.88),(-564,350,5.88),(-564,351,5.88),(-564,352,5.88),(-564,364,5.88),(-564,365,5.88),(-564,366,5.88),(-564,367,5.88),(-564,368,5.88),(-564,369,5.88),(-564,370,5.88),(-564,371,5.92);

-- group 565: 11 item(s), e.g. Thunder Bastion Drape
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-565;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-565,344,5.88),(-565,345,5.88),(-565,346,5.88),(-565,347,5.88),(-565,348,5.88),(-565,349,5.88),(-565,350,5.88),(-565,351,5.88),(-565,352,5.88),(-565,364,5.88),(-565,365,5.88),(-565,366,5.88),(-565,367,5.88),(-565,368,5.88),(-565,369,5.88),(-565,370,5.88),(-565,371,5.92);

-- group 566: 11 item(s), e.g. Doubtcrusher Drape
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-566;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-566,344,5.88),(-566,345,5.88),(-566,346,5.88),(-566,347,5.88),(-566,348,5.88),(-566,349,5.88),(-566,350,5.88),(-566,351,5.88),(-566,352,5.88),(-566,364,5.88),(-566,365,5.88),(-566,366,5.88),(-566,367,5.88),(-566,368,5.88),(-566,369,5.88),(-566,370,5.88),(-566,371,5.92);

-- group 567: 8 item(s), e.g. Ale-Boiled Jerkin
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-567;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-567,344,5.26),(-567,345,5.26),(-567,346,5.26),(-567,347,5.26),(-567,348,5.26),(-567,349,5.26),(-567,350,5.26),(-567,351,5.26),(-567,353,5.26),(-567,354,5.26),(-567,355,5.26),(-567,356,5.26),(-567,357,5.26),(-567,358,5.26),(-567,359,5.26),(-567,360,5.26),(-567,361,5.26),(-567,362,5.26),(-567,363,5.32);

-- group 569: 2 item(s), e.g. Scavenged Pandaren Gun
--   suffixes: of the Galeburst, of the Stormblast, of the Windflurry, of the Windstorm, of the Zephyr
DELETE FROM `item_enchantment_template` WHERE `entry`=-569;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-569,133,20.0),(-569,134,20.0),(-569,135,20.0),(-569,136,20.0),(-569,137,20.0);

-- group 570: 11 item(s), e.g. Sha-Seeker Cloak
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-570;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-570,344,7.14),(-570,345,7.14),(-570,346,7.14),(-570,347,7.14),(-570,348,7.14),(-570,349,7.14),(-570,350,7.14),(-570,351,7.14),(-570,358,7.14),(-570,359,7.14),(-570,360,7.14),(-570,361,7.14),(-570,362,7.14),(-570,363,7.18);

-- group 573: 8 item(s), e.g. Lightning Pillar Breastplate
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-573;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-573,344,5.88),(-573,345,5.88),(-573,346,5.88),(-573,347,5.88),(-573,348,5.88),(-573,349,5.88),(-573,350,5.88),(-573,351,5.88),(-573,352,5.88),(-573,364,5.88),(-573,365,5.88),(-573,366,5.88),(-573,367,5.88),(-573,368,5.88),(-573,369,5.88),(-573,370,5.88),(-573,371,5.92);

-- group 576: 11 item(s), e.g. Heartlander's Cloak
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-576;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-576,344,7.14),(-576,345,7.14),(-576,346,7.14),(-576,347,7.14),(-576,348,7.14),(-576,349,7.14),(-576,350,7.14),(-576,351,7.14),(-576,358,7.14),(-576,359,7.14),(-576,360,7.14),(-576,361,7.14),(-576,362,7.14),(-576,363,7.18);

-- group 577: 19 item(s), e.g. Mist Splitter's Cloak
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-577;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-577,344,5.26),(-577,345,5.26),(-577,346,5.26),(-577,347,5.26),(-577,348,5.26),(-577,349,5.26),(-577,350,5.26),(-577,351,5.26),(-577,353,5.26),(-577,354,5.26),(-577,355,5.26),(-577,356,5.26),(-577,357,5.26),(-577,358,5.26),(-577,359,5.26),(-577,360,5.26),(-577,361,5.26),(-577,362,5.26),(-577,363,5.32);

-- group 578: 8 item(s), e.g. Mountaineer's Vest
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-578;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-578,344,5.26),(-578,345,5.26),(-578,346,5.26),(-578,347,5.26),(-578,348,5.26),(-578,349,5.26),(-578,350,5.26),(-578,351,5.26),(-578,353,5.26),(-578,354,5.26),(-578,355,5.26),(-578,356,5.26),(-578,357,5.26),(-578,358,5.26),(-578,359,5.26),(-578,360,5.26),(-578,361,5.26),(-578,362,5.26),(-578,363,5.32);

-- group 583: 8 item(s), e.g. Immaculate Pandaren Greatsword
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Galeburst, of the Impatient, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-583;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-583,344,4.55),(-583,345,4.55),(-583,346,4.55),(-583,347,4.55),(-583,348,4.55),(-583,349,4.55),(-583,350,4.55),(-583,351,4.55),(-583,352,4.55),(-583,364,4.55),(-583,365,4.55),(-583,366,4.55),(-583,367,4.55),(-583,368,4.55),(-583,369,4.55),(-583,370,4.55),(-583,371,4.55),(-583,353,4.55),(-583,354,4.55),(-583,355,4.55),(-583,356,4.55),(-583,357,4.45);

-- group 584: 8 item(s), e.g. Immaculate Pandaren Greatsword
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Galeburst, of the Impatient, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-584;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-584,344,4.55),(-584,345,4.55),(-584,346,4.55),(-584,347,4.55),(-584,348,4.55),(-584,349,4.55),(-584,350,4.55),(-584,351,4.55),(-584,352,4.55),(-584,364,4.55),(-584,365,4.55),(-584,366,4.55),(-584,367,4.55),(-584,368,4.55),(-584,369,4.55),(-584,370,4.55),(-584,371,4.55),(-584,353,4.55),(-584,354,4.55),(-584,355,4.55),(-584,356,4.55),(-584,357,4.45);

-- group 585: 9 item(s), e.g. Immaculate Pandaren Spear
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Galeburst, of the Impatient, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-585;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-585,344,4.55),(-585,345,4.55),(-585,346,4.55),(-585,347,4.55),(-585,348,4.55),(-585,349,4.55),(-585,350,4.55),(-585,351,4.55),(-585,352,4.55),(-585,364,4.55),(-585,365,4.55),(-585,366,4.55),(-585,367,4.55),(-585,368,4.55),(-585,369,4.55),(-585,370,4.55),(-585,371,4.55),(-585,353,4.55),(-585,354,4.55),(-585,355,4.55),(-585,356,4.55),(-585,357,4.45);

-- group 586: 6 item(s), e.g. Immaculate Pandaren Scepter
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-586;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-586,344,7.14),(-586,345,7.14),(-586,346,7.14),(-586,347,7.14),(-586,348,7.14),(-586,349,7.14),(-586,350,7.14),(-586,351,7.14),(-586,358,7.14),(-586,359,7.14),(-586,360,7.14),(-586,361,7.14),(-586,362,7.14),(-586,363,7.18);

-- group 587: 4 item(s), e.g. Immaculate Pandaren Staff
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-587;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-587,344,7.14),(-587,345,7.14),(-587,346,7.14),(-587,347,7.14),(-587,348,7.14),(-587,349,7.14),(-587,350,7.14),(-587,351,7.14),(-587,358,7.14),(-587,359,7.14),(-587,360,7.14),(-587,361,7.14),(-587,362,7.14),(-587,363,7.18);

-- group 629: 1 item(s), e.g. Cliffbreaker Helm
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-629;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-629,461,5.88),(-629,462,5.88),(-629,463,5.88),(-629,464,5.88),(-629,465,5.88),(-629,466,5.88),(-629,467,5.88),(-629,468,5.88),(-629,469,5.88),(-629,481,5.88),(-629,482,5.88),(-629,483,5.88),(-629,484,5.88),(-629,485,5.88),(-629,486,5.88),(-629,487,5.88),(-629,488,5.92);

-- group 630: 1 item(s), e.g. Elder Tortoiseshell Helm
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-630;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-630,461,5.88),(-630,462,5.88),(-630,463,5.88),(-630,464,5.88),(-630,465,5.88),(-630,466,5.88),(-630,467,5.88),(-630,468,5.88),(-630,469,5.88),(-630,481,5.88),(-630,482,5.88),(-630,483,5.88),(-630,484,5.88),(-630,485,5.88),(-630,486,5.88),(-630,487,5.88),(-630,488,5.92);

-- group 631: 2 item(s), e.g. Crimsonscale Helm
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-631;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-631,461,5.26),(-631,462,5.26),(-631,463,5.26),(-631,464,5.26),(-631,465,5.26),(-631,466,5.26),(-631,467,5.26),(-631,468,5.26),(-631,470,5.26),(-631,471,5.26),(-631,472,5.26),(-631,473,5.26),(-631,474,5.26),(-631,475,5.26),(-631,476,5.26),(-631,477,5.26),(-631,478,5.26),(-631,479,5.26),(-631,480,5.32);

-- group 632: 4 item(s), e.g. Fire-Chanter Hood
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Feverflare, of the Fireflash,
DELETE FROM `item_enchantment_template` WHERE `entry`=-632;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-632,461,3.57),(-632,462,3.57),(-632,463,3.57),(-632,464,3.57),(-632,465,3.57),(-632,466,3.57),(-632,467,3.57),(-632,468,3.57),(-632,469,3.57),(-632,481,3.57),(-632,482,3.57),(-632,483,3.57),(-632,484,3.57),(-632,485,3.57),(-632,486,3.57),(-632,487,3.57),(-632,488,3.57),(-632,470,3.57),(-632,471,3.57),(-632,472,3.57),(-632,473,3.57),(-632,474,3.57),(-632,475,3.57),(-632,476,3.57),(-632,477,3.57),(-632,478,3.57),(-632,479,3.57),(-632,480,3.61);

-- group 633: 1 item(s), e.g. Cloudscorcher Cowl
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-633;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-633,461,7.14),(-633,462,7.14),(-633,463,7.14),(-633,464,7.14),(-633,465,7.14),(-633,466,7.14),(-633,467,7.14),(-633,468,7.14),(-633,475,7.14),(-633,476,7.14),(-633,477,7.14),(-633,478,7.14),(-633,479,7.14),(-633,480,7.18);

-- group 634: 2 item(s), e.g. Cliffbreaker Breastplate
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-634;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-634,461,5.88),(-634,462,5.88),(-634,463,5.88),(-634,464,5.88),(-634,465,5.88),(-634,466,5.88),(-634,467,5.88),(-634,468,5.88),(-634,469,5.88),(-634,481,5.88),(-634,482,5.88),(-634,483,5.88),(-634,484,5.88),(-634,485,5.88),(-634,486,5.88),(-634,487,5.88),(-634,488,5.92);

-- group 635: 2 item(s), e.g. Elder Tortoiseshell Breastplate
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-635;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-635,461,5.88),(-635,462,5.88),(-635,463,5.88),(-635,464,5.88),(-635,465,5.88),(-635,466,5.88),(-635,467,5.88),(-635,468,5.88),(-635,469,5.88),(-635,481,5.88),(-635,482,5.88),(-635,483,5.88),(-635,484,5.88),(-635,485,5.88),(-635,486,5.88),(-635,487,5.88),(-635,488,5.92);

-- group 636: 4 item(s), e.g. Crimsonscale Legguards
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-636;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-636,461,5.26),(-636,462,5.26),(-636,463,5.26),(-636,464,5.26),(-636,465,5.26),(-636,466,5.26),(-636,467,5.26),(-636,468,5.26),(-636,470,5.26),(-636,471,5.26),(-636,472,5.26),(-636,473,5.26),(-636,474,5.26),(-636,475,5.26),(-636,476,5.26),(-636,477,5.26),(-636,478,5.26),(-636,479,5.26),(-636,480,5.32);

-- group 637: 8 item(s), e.g. Fire-Chanter Britches
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Feverflare, of the Fireflash,
DELETE FROM `item_enchantment_template` WHERE `entry`=-637;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-637,461,3.57),(-637,462,3.57),(-637,463,3.57),(-637,464,3.57),(-637,465,3.57),(-637,466,3.57),(-637,467,3.57),(-637,468,3.57),(-637,469,3.57),(-637,481,3.57),(-637,482,3.57),(-637,483,3.57),(-637,484,3.57),(-637,485,3.57),(-637,486,3.57),(-637,487,3.57),(-637,488,3.57),(-637,470,3.57),(-637,471,3.57),(-637,472,3.57),(-637,473,3.57),(-637,474,3.57),(-637,475,3.57),(-637,476,3.57),(-637,477,3.57),(-637,478,3.57),(-637,479,3.57),(-637,480,3.61);

-- group 638: 2 item(s), e.g. Cloudscorcher Leggings
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-638;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-638,461,7.14),(-638,462,7.14),(-638,463,7.14),(-638,464,7.14),(-638,465,7.14),(-638,466,7.14),(-638,467,7.14),(-638,468,7.14),(-638,475,7.14),(-638,476,7.14),(-638,477,7.14),(-638,478,7.14),(-638,479,7.14),(-638,480,7.18);

-- group 639: 2 item(s), e.g. Cliffbreaker Breastplate
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-639;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-639,461,5.88),(-639,462,5.88),(-639,463,5.88),(-639,464,5.88),(-639,465,5.88),(-639,466,5.88),(-639,467,5.88),(-639,468,5.88),(-639,469,5.88),(-639,481,5.88),(-639,482,5.88),(-639,483,5.88),(-639,484,5.88),(-639,485,5.88),(-639,486,5.88),(-639,487,5.88),(-639,488,5.92);

-- group 640: 2 item(s), e.g. Elder Tortoiseshell Breastplate
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-640;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-640,461,5.88),(-640,462,5.88),(-640,463,5.88),(-640,464,5.88),(-640,465,5.88),(-640,466,5.88),(-640,467,5.88),(-640,468,5.88),(-640,469,5.88),(-640,481,5.88),(-640,482,5.88),(-640,483,5.88),(-640,484,5.88),(-640,485,5.88),(-640,486,5.88),(-640,487,5.88),(-640,488,5.92);

-- group 641: 4 item(s), e.g. Crimsonscale Legguards
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-641;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-641,461,5.26),(-641,462,5.26),(-641,463,5.26),(-641,464,5.26),(-641,465,5.26),(-641,466,5.26),(-641,467,5.26),(-641,468,5.26),(-641,470,5.26),(-641,471,5.26),(-641,472,5.26),(-641,473,5.26),(-641,474,5.26),(-641,475,5.26),(-641,476,5.26),(-641,477,5.26),(-641,478,5.26),(-641,479,5.26),(-641,480,5.32);

-- group 642: 8 item(s), e.g. Fire-Chanter Britches
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Feverflare, of the Fireflash,
DELETE FROM `item_enchantment_template` WHERE `entry`=-642;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-642,461,3.57),(-642,462,3.57),(-642,463,3.57),(-642,464,3.57),(-642,465,3.57),(-642,466,3.57),(-642,467,3.57),(-642,468,3.57),(-642,469,3.57),(-642,481,3.57),(-642,482,3.57),(-642,483,3.57),(-642,484,3.57),(-642,485,3.57),(-642,486,3.57),(-642,487,3.57),(-642,488,3.57),(-642,470,3.57),(-642,471,3.57),(-642,472,3.57),(-642,473,3.57),(-642,474,3.57),(-642,475,3.57),(-642,476,3.57),(-642,477,3.57),(-642,478,3.57),(-642,479,3.57),(-642,480,3.61);

-- group 643: 2 item(s), e.g. Cloudscorcher Leggings
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-643;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-643,461,7.14),(-643,462,7.14),(-643,463,7.14),(-643,464,7.14),(-643,465,7.14),(-643,466,7.14),(-643,467,7.14),(-643,468,7.14),(-643,475,7.14),(-643,476,7.14),(-643,477,7.14),(-643,478,7.14),(-643,479,7.14),(-643,480,7.18);

-- group 644: 1 item(s), e.g. Cliffbreaker Helm
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-644;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-644,461,5.88),(-644,462,5.88),(-644,463,5.88),(-644,464,5.88),(-644,465,5.88),(-644,466,5.88),(-644,467,5.88),(-644,468,5.88),(-644,469,5.88),(-644,481,5.88),(-644,482,5.88),(-644,483,5.88),(-644,484,5.88),(-644,485,5.88),(-644,486,5.88),(-644,487,5.88),(-644,488,5.92);

-- group 645: 1 item(s), e.g. Elder Tortoiseshell Helm
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-645;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-645,461,5.88),(-645,462,5.88),(-645,463,5.88),(-645,464,5.88),(-645,465,5.88),(-645,466,5.88),(-645,467,5.88),(-645,468,5.88),(-645,469,5.88),(-645,481,5.88),(-645,482,5.88),(-645,483,5.88),(-645,484,5.88),(-645,485,5.88),(-645,486,5.88),(-645,487,5.88),(-645,488,5.92);

-- group 646: 2 item(s), e.g. Crimsonscale Helm
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-646;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-646,461,5.26),(-646,462,5.26),(-646,463,5.26),(-646,464,5.26),(-646,465,5.26),(-646,466,5.26),(-646,467,5.26),(-646,468,5.26),(-646,470,5.26),(-646,471,5.26),(-646,472,5.26),(-646,473,5.26),(-646,474,5.26),(-646,475,5.26),(-646,476,5.26),(-646,477,5.26),(-646,478,5.26),(-646,479,5.26),(-646,480,5.32);

-- group 647: 4 item(s), e.g. Fire-Chanter Hood
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Feverflare, of the Fireflash,
DELETE FROM `item_enchantment_template` WHERE `entry`=-647;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-647,461,3.57),(-647,462,3.57),(-647,463,3.57),(-647,464,3.57),(-647,465,3.57),(-647,466,3.57),(-647,467,3.57),(-647,468,3.57),(-647,469,3.57),(-647,481,3.57),(-647,482,3.57),(-647,483,3.57),(-647,484,3.57),(-647,485,3.57),(-647,486,3.57),(-647,487,3.57),(-647,488,3.57),(-647,470,3.57),(-647,471,3.57),(-647,472,3.57),(-647,473,3.57),(-647,474,3.57),(-647,475,3.57),(-647,476,3.57),(-647,477,3.57),(-647,478,3.57),(-647,479,3.57),(-647,480,3.61);

-- group 648: 1 item(s), e.g. Cloudscorcher Cowl
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-648;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-648,461,7.14),(-648,462,7.14),(-648,463,7.14),(-648,464,7.14),(-648,465,7.14),(-648,466,7.14),(-648,467,7.14),(-648,468,7.14),(-648,475,7.14),(-648,476,7.14),(-648,477,7.14),(-648,478,7.14),(-648,479,7.14),(-648,480,7.18);

-- group 651: 16 item(s), e.g. Elder Tortoiseshell Drape
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-651;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-651,461,5.88),(-651,462,5.88),(-651,463,5.88),(-651,464,5.88),(-651,465,5.88),(-651,466,5.88),(-651,467,5.88),(-651,468,5.88),(-651,469,5.88),(-651,481,5.88),(-651,482,5.88),(-651,483,5.88),(-651,484,5.88),(-651,485,5.88),(-651,486,5.88),(-651,487,5.88),(-651,488,5.92);

-- group 652: 16 item(s), e.g. Cliffbreaker Drape
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Impatient, of the Landslide, 
DELETE FROM `item_enchantment_template` WHERE `entry`=-652;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-652,461,5.88),(-652,462,5.88),(-652,463,5.88),(-652,464,5.88),(-652,465,5.88),(-652,466,5.88),(-652,467,5.88),(-652,468,5.88),(-652,469,5.88),(-652,481,5.88),(-652,482,5.88),(-652,483,5.88),(-652,484,5.88),(-652,485,5.88),(-652,486,5.88),(-652,487,5.88),(-652,488,5.92);

-- group 653: 26 item(s), e.g. Warmsun Choker
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Galeburst, of the Impatient, of the Pious, of the Savant, of the Stormblast, of the Un
DELETE FROM `item_enchantment_template` WHERE `entry`=-653;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-653,461,5.26),(-653,462,5.26),(-653,463,5.26),(-653,464,5.26),(-653,465,5.26),(-653,466,5.26),(-653,467,5.26),(-653,468,5.26),(-653,470,5.26),(-653,471,5.26),(-653,472,5.26),(-653,473,5.26),(-653,474,5.26),(-653,475,5.26),(-653,476,5.26),(-653,477,5.26),(-653,478,5.26),(-653,479,5.26),(-653,480,5.32);

-- group 654: 16 item(s), e.g. Cloudscorcher Belt
--   suffixes: of the Adroit, of the Bladewall, of the Decimator, of the Feverflare, of the Fireflash, of the Flameblaze, of the Impatient, of the Pious, of the Savant, of the Undertow, of the Unerring, of the Untou
DELETE FROM `item_enchantment_template` WHERE `entry`=-654;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-654,461,7.14),(-654,462,7.14),(-654,463,7.14),(-654,464,7.14),(-654,465,7.14),(-654,466,7.14),(-654,467,7.14),(-654,468,7.14),(-654,475,7.14),(-654,476,7.14),(-654,477,7.14),(-654,478,7.14),(-654,479,7.14),(-654,480,7.18);

-- group 655: 46 item(s), e.g. Fire-Chanter Bindings
--   suffixes: of the Adroit, of the Bedrock, of the Bladewall, of the Bouldercrag, of the Decimator, of the Earthbreaker, of the Earthfall, of the Earthshaker, of the Faultline, of the Feverflare, of the Fireflash,
DELETE FROM `item_enchantment_template` WHERE `entry`=-655;
INSERT INTO `item_enchantment_template` (`entry`,`ench`,`chance`) VALUES (-655,461,3.57),(-655,462,3.57),(-655,463,3.57),(-655,464,3.57),(-655,465,3.57),(-655,466,3.57),(-655,467,3.57),(-655,468,3.57),(-655,469,3.57),(-655,481,3.57),(-655,482,3.57),(-655,483,3.57),(-655,484,3.57),(-655,485,3.57),(-655,486,3.57),(-655,487,3.57),(-655,488,3.57),(-655,470,3.57),(-655,471,3.57),(-655,472,3.57),(-655,473,3.57),(-655,474,3.57),(-655,475,3.57),(-655,476,3.57),(-655,477,3.57),(-655,478,3.57),(-655,479,3.57),(-655,480,3.61);


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


