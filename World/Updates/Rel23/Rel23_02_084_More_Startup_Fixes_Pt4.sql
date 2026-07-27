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
    SET @cOldContent = '083';

    -- New Values
    SET @cNewVersion = '23';
    SET @cNewStructure = '02';
    SET @cNewContent = '084';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'More Startup Fixes Pt4';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'More Startup Fixes Pt4';

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
-- MaNGOS Four world DB update (round 2): M4v2_16_loot_cleanup.sql
-- Loot-table cleanup for the safely fixable classes:
--  A) 4 junk French-named Spirit Kings duplicate templates (never
--     spawned) reference loot that does not exist: clear their LootId.
--  B) Orphan loot templates not referenced by anything (custom 70xxx/
--     80xxx/100xxx skinning blocks, old pickpocket/disenchant rows).
--  C) 9 unreferenced spell_loot_template entries.
--
-- NOT touched here - these warnings report MISSING CONTENT, and the
-- fix is importing/authoring the loot data, not deleting references:
--  * 38 Siege of Orgrimmar creatures (Garrosh, Malkorok, Galakras,
--    Immerseus, all SoO bosses + trash) with LootId set but NO loot
--    rows -> SoO drop tables were never imported. Do NOT zero LootIds.
--  * 192 gameobject templates - ALL MoP gathering nodes (Ghost Iron /
--    Kyparite / Trillium veins, Green Tea Leaf, Silkweed, Snow Lily,
--    Rain Poppy, Golden Lotus, Fool's Cap...), fishing pools, 5.x and
--    SoO chests - with no gameobject_loot_template data. MoP mining
--    and herbalism currently yield nothing.
--  * 264 "not exist but used as loot id" spell_loot entries: these are
--    EXISTING container/salvage spells whose loot tables are missing
--    (the table has no rows for them - nothing to delete).
--  * Millable herb 87821 with no milling_loot_template rows.
--  * The 14 condition_id 216-230 lines are already fixed by
--    M4v2_13_item_ghosts_and_pages.sql (those rows reference deleted
--    ghost items and are removed by it).
-- ============================================================

-- A) junk duplicate boss templates (no spawns) - clear dangling LootId
UPDATE `creature_template` SET `LootId`=0 WHERE `entry`=61421 AND `LootId`<>0;
UPDATE `creature_template` SET `LootId`=0 WHERE `entry`=61423 AND `LootId`<>0;
UPDATE `creature_template` SET `LootId`=0 WHERE `entry`=61427 AND `LootId`<>0;
UPDATE `creature_template` SET `LootId`=0 WHERE `entry`=61429 AND `LootId`<>0;

-- B) orphan loot templates (verified unreferenced in Mangos4DB.sql)
-- B1: pickpocketing orphans (134 row(s))
DELETE FROM `pickpocketing_loot_template` WHERE `entry` IN (842,1283,1434,1755,2405,2621,3296,3501,4624,4979,5089,5953,6086,6670,7067,7787,8151,8877,9460,10475,10696,10812,10991,11190,11837,11946,12903,17256,17416,18585,18586,19500,19797,20051,20116,20512,20555,21065,21387,22201,22325,23865,25618,28803,32467);

-- B2: skinning orphans incl. custom 70xxx/80xxx/100xxx blocks (333 row(s))
DELETE FROM `skinning_loot_template` WHERE `entry` IN (534,721,883,890,1933,2098,2275,2442,2565,2620,2831,4166,4279,5951,5982,9198,10105,10116,10131,10136,10147,10150,10156,10237,10257,10780,12296,12297,12298,12299,12715,12723,12741,13602,14750,15412,15414,15415,15416,15554,16095,17467,27641,29724,29725,29726,29727,29728,29729,29730,70060,70061,70062,70063,70064,70065,70066,70067,70160,70161,70162,70163,70164,70165,70166,70167,70168,70169,70170,70171,70172,70200,70201,70202,70203,70204,70205,70206,70207,70208,70209,70210,70211,70212,70213,70214,80000,80001,80002,80007,80100,80101,80102,80103,80104,80200,80201,80202,80203,80204,80205,80206,100001,100002,100003,100004,100006,100007);

-- B3: disenchant orphans (120 row(s))
DELETE FROM `disenchant_loot_template` WHERE `entry` IN (35039,35040,35106,40727,51417,51423,51429,51437,51472,51478,51501,51507,51513,55248,55783,55800,55821,55852,56279,56316,56337,56350,56372,57297,59626,59637,59640,60223,61388,61389,61390,61391,61399,61437,61440,62240,62241,62242,62243,62244,62245,63460,63480,63487,63769,63772,63776,63888,63891,64671,64672,64673,64674,64676,64819,64820,64821,64822,65812,66048,66049,66050,66051,66912,66961,66988,67059,67110,68609,68612,70077,70078,70079,70405,70406,70407,70408,70629,70630,70939,71146,71147,71148,71149,72310,72328,72358,72456,75066,75069,75079,77080,77081,77082,77083);

-- C: unreferenced spell_loot entries (10 row(s))
DELETE FROM `spell_loot_template` WHERE `entry` IN (51771,60445,61500,86656,86883,86884,86885,95399,95406);

-- ============================================================
-- MaNGOS Four world DB update (round 2): M4v2_17_gameobject_loot_fill.sql
-- Fills the missing `gameobject_loot_template` data for the MoP
-- gathering nodes, fishing pools and quest containers reported as
-- "not exist but used as loot id".
--
-- Sources, in order of authority:
--  * quest containers: items taken from the objects' own questItemN
--    fields in gameobject_template (quest-drop chance -100);
--  * gathering nodes / fishing pools: BLIZZLIKE-APPROXIMATE yields
--    (ore 2-4 / rich 3-6, herbs 2-4 + 5%% Golden Lotus bonus, Trillium
--    veins split black/white, pools 2-3 fish) - item ids verified
--    against item_template by name;
--  * remaining objects: exact-name item match in item_template.
-- Idempotent: each block deletes its loot id before inserting.
-- Tune counts/chances to taste - they are sane defaults, not sniffs.
-- ============================================================

-- loot 40258: Ghost Iron Deposit
DELETE FROM `gameobject_loot_template` WHERE `entry`=40258;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40258,72092,100,0,2,4,0);

-- loot 40259: Kyparite Deposit
DELETE FROM `gameobject_loot_template` WHERE `entry`=40259;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40259,72093,100,0,2,4,0);

-- loot 40260: Trillium Vein
DELETE FROM `gameobject_loot_template` WHERE `entry`=40260;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40260,72094,50,1,1,3,0),
 (40260,72103,50,1,1,3,0);

-- loot 40268: Rich Ghost Iron Deposit
DELETE FROM `gameobject_loot_template` WHERE `entry`=40268;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40268,72092,100,0,3,6,0);

-- loot 40270: Rich Kyparite Deposit
DELETE FROM `gameobject_loot_template` WHERE `entry`=40270;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40270,72093,100,0,3,6,0);

-- loot 40321: Green Tea Leaf
DELETE FROM `gameobject_loot_template` WHERE `entry`=40321;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40321,72234,100,0,2,4,0),
 (40321,72238,5,0,1,1,0);

-- loot 40325: Silkweed
DELETE FROM `gameobject_loot_template` WHERE `entry`=40325;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40325,72235,100,0,2,4,0),
 (40325,72238,5,0,1,1,0);

-- loot 40326: Snow Lily
DELETE FROM `gameobject_loot_template` WHERE `entry`=40326;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40326,79010,100,0,2,4,0),
 (40326,72238,5,0,1,1,0);

-- loot 40327: Rain Poppy
DELETE FROM `gameobject_loot_template` WHERE `entry`=40327;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40327,72237,100,0,2,4,0),
 (40327,72238,5,0,1,1,0);

-- loot 40328: Golden Lotus
DELETE FROM `gameobject_loot_template` WHERE `entry`=40328;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40328,72238,100,0,1,2,0);

-- loot 40329: Fool's Cap
DELETE FROM `gameobject_loot_template` WHERE `entry`=40329;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40329,79011,100,0,2,4,0),
 (40329,72238,5,0,1,1,0);

-- loot 40338: Ripe Orange
DELETE FROM `gameobject_loot_template` WHERE `entry`=40338;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40338,72589,-100,0,1,1,0);

-- loot 40415: Hozen Skull
DELETE FROM `gameobject_loot_template` WHERE `entry`=40415;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40415,74033,-100,0,1,1,0);

-- loot 40463: Chipped Ritual Bowl
DELETE FROM `gameobject_loot_template` WHERE `entry`=40463;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40463,74760,-100,0,1,1,0);

-- loot 40464: Pungent Ritual Candle
DELETE FROM `gameobject_loot_template` WHERE `entry`=40464;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40464,74761,-100,0,1,1,0);

-- loot 40465: Jade Cong
DELETE FROM `gameobject_loot_template` WHERE `entry`=40465;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40465,74762,-100,0,1,1,0);

-- loot 40481: Tidemist Cap
DELETE FROM `gameobject_loot_template` WHERE `entry`=40481;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40481,75214,-100,0,1,1,0);

-- loot 40483: Zen Lotus
DELETE FROM `gameobject_loot_template` WHERE `entry`=40483;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40483,75217,-100,0,1,1,0);

-- loot 40485: Freshly Fallen Petals
DELETE FROM `gameobject_loot_template` WHERE `entry`=40485;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40485,75219,-100,0,1,1,0);

-- loot 40517: Stolen Turnip
DELETE FROM `gameobject_loot_template` WHERE `entry`=40517;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40517,76297,-100,0,1,1,0);

-- loot 40521: Meadow Marigold
DELETE FROM `gameobject_loot_template` WHERE `entry`=40521;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40521,76334,-100,0,1,1,0);

-- loot 40527: Stolen Sack of Hops
DELETE FROM `gameobject_loot_template` WHERE `entry`=40527;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40527,76337,-100,0,1,1,0);

-- loot 40535: Jademoon
DELETE FROM `gameobject_loot_template` WHERE `entry`=40535;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40535,76499,-100,0,1,1,0);

-- loot 40536: Emperor Tern Egg
DELETE FROM `gameobject_loot_template` WHERE `entry`=40536;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40536,76501,-100,0,1,1,0);

-- loot 40537: Crane Egg, Whitefisher Crane Egg
DELETE FROM `gameobject_loot_template` WHERE `entry`=40537;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40537,76503,-100,0,1,1,0);

-- loot 40538: Hornbill Strider Egg
DELETE FROM `gameobject_loot_template` WHERE `entry`=40538;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40538,76516,-100,0,1,1,0);

-- loot 40747: Dreamleaf Bush
DELETE FROM `gameobject_loot_template` WHERE `entry`=40747;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40747,76973,-100,0,1,1,0);

-- loot 40870: Stolen Barley Sack, Stolen Malt Sack
DELETE FROM `gameobject_loot_template` WHERE `entry`=40870;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40870,77033,-100,0,1,1,0);

-- loot 40882: Defender's Arrow
DELETE FROM `gameobject_loot_template` WHERE `entry`=40882;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40882,77452,-100,0,1,1,0);

-- loot 40884: Mulberry Barrel
DELETE FROM `gameobject_loot_template` WHERE `entry`=40884;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (40884,77455,-100,0,1,1,0);

-- loot 41153: Imperial Lotus
DELETE FROM `gameobject_loot_template` WHERE `entry`=41153;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41153,78918,-100,0,1,1,0);

-- loot 41232: Jar of Pigment
DELETE FROM `gameobject_loot_template` WHERE `entry`=41232;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41232,78942,-100,0,1,1,0);

-- loot 41305: Serpent Egg
DELETE FROM `gameobject_loot_template` WHERE `entry`=41305;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41305,78959,-100,0,1,1,0),
 (41305,79067,-100,0,1,1,0);

-- loot 41322: Slitherscale Weapons
DELETE FROM `gameobject_loot_template` WHERE `entry`=41322;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41322,79025,-100,0,1,1,0);

-- loot 41354: Mogu Artifact
DELETE FROM `gameobject_loot_template` WHERE `entry`=41354;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41354,79120,-100,0,1,1,0);

-- loot 41367: Dark Soil
DELETE FROM `gameobject_loot_template` WHERE `entry`=41367;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41367,79264,20,1,1,1,0),
 (41367,79265,20,1,1,1,0),
 (41367,79266,20,1,1,1,0),
 (41367,79267,20,1,1,1,0),
 (41367,79268,20,1,1,1,0);

-- loot 41405: Stolen Vegetable
DELETE FROM `gameobject_loot_template` WHERE `entry`=41405;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41405,79824,-100,0,1,1,0);

-- loot 41409: Authentic Valley Stir Fry
DELETE FROM `gameobject_loot_template` WHERE `entry`=41409;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41409,79827,-100,0,1,1,0);

-- loot 41410: Shadelight Truffle
DELETE FROM `gameobject_loot_template` WHERE `entry`=41410;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41410,79833,-100,0,1,1,0);

-- loot 41422: Yu-Ping Soup Cauldron
DELETE FROM `gameobject_loot_template` WHERE `entry`=41422;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41422,79870,-100,0,1,1,0);

-- loot 41436: Celestial Jade
DELETE FROM `gameobject_loot_template` WHERE `entry`=41436;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41436,80074,-100,0,1,1,0);

-- loot 41440: Partially Chewed Carrot
DELETE FROM `gameobject_loot_template` WHERE `entry`=41440;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41440,80116,-100,0,1,1,0);

-- loot 41443: Spideroot
DELETE FROM `gameobject_loot_template` WHERE `entry`=41443;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41443,80122,-100,0,1,1,0);

-- loot 41448: Boat Planks
DELETE FROM `gameobject_loot_template` WHERE `entry`=41448;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41448,80136,-100,0,1,1,0);

-- loot 41454: Violet Lichen
DELETE FROM `gameobject_loot_template` WHERE `entry`=41454;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41454,80143,-100,0,1,1,0);

-- loot 41459: Root Vegetable
DELETE FROM `gameobject_loot_template` WHERE `entry`=41459;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41459,80227,-100,0,1,1,0);

-- loot 41464: Cast Iron Pot
DELETE FROM `gameobject_loot_template` WHERE `entry`=41464;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41464,80230,-100,0,1,1,0);

-- loot 41480: Jagged Abalone
DELETE FROM `gameobject_loot_template` WHERE `entry`=41480;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41480,80277,-100,0,1,1,0);

-- loot 41481: Mogu Relic
DELETE FROM `gameobject_loot_template` WHERE `entry`=41481;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41481,80294,-100,0,1,1,0);

-- loot 41485: Pristine Crane Egg
DELETE FROM `gameobject_loot_template` WHERE `entry`=41485;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41485,80303,-100,0,1,1,0);

-- loot 41507: Stolen Supplies
DELETE FROM `gameobject_loot_template` WHERE `entry`=41507;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41507,80315,-100,0,1,1,0);

-- loot 41548: Lump of Sand
DELETE FROM `gameobject_loot_template` WHERE `entry`=41548;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41548,80817,-100,0,1,1,0);

-- loot 41556: Shipwreck Debris
DELETE FROM `gameobject_loot_template` WHERE `entry`=41556;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41556,78930,100,0,1,1,0);

-- loot 41596: Suncrawler
DELETE FROM `gameobject_loot_template` WHERE `entry`=41596;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41596,81116,-100,0,1,1,0);

-- loot 41603: Pitch Pot
DELETE FROM `gameobject_loot_template` WHERE `entry`=41603;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41603,81174,-100,0,1,1,0);

-- loot 41640: Snarlvine
DELETE FROM `gameobject_loot_template` WHERE `entry`=41640;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41640,81250,-100,0,1,1,0);

-- loot 41681: Stolen Bag of Luckydos
DELETE FROM `gameobject_loot_template` WHERE `entry`=41681;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41681,81293,-100,0,1,1,0);

-- loot 41744: Blackmane Booty Barrel
DELETE FROM `gameobject_loot_template` WHERE `entry`=41744;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41744,81261,-100,0,1,1,0);

-- loot 41835: Palewind Totem
DELETE FROM `gameobject_loot_template` WHERE `entry`=41835;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (41835,81355,-100,0,1,1,0);

-- loot 42013: Volatile Blooms
DELETE FROM `gameobject_loot_template` WHERE `entry`=42013;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42013,82298,-100,0,1,1,0);

-- loot 42068: Violet Citron
DELETE FROM `gameobject_loot_template` WHERE `entry`=42068;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42068,82342,-100,0,1,1,0);

-- loot 42246: Sra'thik Weapon
DELETE FROM `gameobject_loot_template` WHERE `entry`=42246;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42246,82353,-100,0,1,1,0);

-- loot 42311: Mao-Willow
DELETE FROM `gameobject_loot_template` WHERE `entry`=42311;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42311,82389,-100,0,1,1,0);

-- loot 42315: Qiang Dynasty Tablet
DELETE FROM `gameobject_loot_template` WHERE `entry`=42315;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42315,82394,-100,0,1,1,0);

-- loot 42434: King's Coffer
DELETE FROM `gameobject_loot_template` WHERE `entry`=42434;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42434,82764,-100,0,1,1,0);

-- loot 42446: Amber Fragment
DELETE FROM `gameobject_loot_template` WHERE `entry`=42446;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42446,82864,-100,0,1,1,0);

-- loot 42448: Mantid Relic
DELETE FROM `gameobject_loot_template` WHERE `entry`=42448;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42448,82867,-100,0,1,1,0);

-- loot 42449: Starshade
DELETE FROM `gameobject_loot_template` WHERE `entry`=42449;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42449,82868,-100,0,1,1,0);

-- loot 42510: Shado-Pan Crossbow Bolt Bundle
DELETE FROM `gameobject_loot_template` WHERE `entry`=42510;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42510,83023,-100,0,1,1,0);

-- loot 42512: Shado-Pan Fire Arrows
DELETE FROM `gameobject_loot_template` WHERE `entry`=42512;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42512,83024,-100,0,1,1,0);

-- loot 42513: Shado-Pan Fire Arrows
DELETE FROM `gameobject_loot_template` WHERE `entry`=42513;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42513,83024,-100,0,1,1,0);

-- loot 42519: Emperor Salmon School
DELETE FROM `gameobject_loot_template` WHERE `entry`=42519;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42519,74859,100,0,2,3,0);

-- loot 42520: Giant Mantis Shrimp Swarm
DELETE FROM `gameobject_loot_template` WHERE `entry`=42520;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42520,74857,100,0,2,3,0);

-- loot 42522: Jade Lungfish School
DELETE FROM `gameobject_loot_template` WHERE `entry`=42522;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42522,74856,100,0,2,3,0);

-- loot 42523: Krasarang Paddlefish School
DELETE FROM `gameobject_loot_template` WHERE `entry`=42523;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42523,74865,100,0,2,3,0);

-- loot 42524: Redbelly Mandarin School
DELETE FROM `gameobject_loot_template` WHERE `entry`=42524;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42524,74860,100,0,2,3,0);

-- loot 42525: Reef Octopus Swarm
DELETE FROM `gameobject_loot_template` WHERE `entry`=42525;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42525,74864,100,0,2,3,0);

-- loot 42526: Tiger Gourami School
DELETE FROM `gameobject_loot_template` WHERE `entry`=42526;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42526,74861,100,0,2,3,0);

-- loot 42528: Spinefish School
DELETE FROM `gameobject_loot_template` WHERE `entry`=42528;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42528,83064,100,0,2,3,0);

-- loot 42694: Ruby Eye
DELETE FROM `gameobject_loot_template` WHERE `entry`=42694;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42694,84646,-100,0,1,1,0);

-- loot 42695: Mogu Artifact
DELETE FROM `gameobject_loot_template` WHERE `entry`=42695;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42695,84655,-100,0,1,1,0);

-- loot 42706: Highly Explosive Yaungol Oil Barrel
DELETE FROM `gameobject_loot_template` WHERE `entry`=42706;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42706,84762,-100,0,1,1,0);

-- loot 42707: Solidified Amber
DELETE FROM `gameobject_loot_template` WHERE `entry`=42707;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42707,84779,-100,0,1,1,0);

-- loot 42721: Amber Collector
DELETE FROM `gameobject_loot_template` WHERE `entry`=42721;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42721,85159,-100,0,1,1,0);

-- loot 42829: Lushroom
DELETE FROM `gameobject_loot_template` WHERE `entry`=42829;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42829,85681,-100,0,1,1,0);

-- loot 42838: Mistfall Water Bucket
DELETE FROM `gameobject_loot_template` WHERE `entry`=42838;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42838,85782,-100,0,1,1,0);

-- loot 42854: Cursed Hozen Totem, Evil Monkey Idol, Priceless Mogu Artifact, Smuggled Brewfather Statue,
DELETE FROM `gameobject_loot_template` WHERE `entry`=42854;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42854,85981,-100,0,1,1,0);

-- loot 42897: Wukao Scouting Report
DELETE FROM `gameobject_loot_template` WHERE `entry`=42897;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42897,86099,-100,0,1,1,0);

-- loot 42902: Pandaren Fishing Spear
DELETE FROM `gameobject_loot_template` WHERE `entry`=42902;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42902,86124,100,0,1,1,0);

-- loot 42904: Ancient Jinyu Staff
DELETE FROM `gameobject_loot_template` WHERE `entry`=42904;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42904,86196,100,0,1,1,0);

-- loot 42918: Terracotta Head
DELETE FROM `gameobject_loot_template` WHERE `entry`=42918;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42918,86427,100,0,1,1,0);

-- loot 42928: Ancient Mogu Tablet
DELETE FROM `gameobject_loot_template` WHERE `entry`=42928;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42928,86471,100,0,1,1,0);

-- loot 42936: Fragment of Dread
DELETE FROM `gameobject_loot_template` WHERE `entry`=42936;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42936,86516,100,0,1,1,0);

-- loot 42948: Blade of the Poisoned Mind
DELETE FROM `gameobject_loot_template` WHERE `entry`=42948;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42948,86527,100,0,1,1,0);

-- loot 42949: Wind-Reaver's Dagger of Quick Strikes
DELETE FROM `gameobject_loot_template` WHERE `entry`=42949;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (42949,86519,100,0,1,1,0);

-- loot 43115: Vor'thik Egg
DELETE FROM `gameobject_loot_template` WHERE `entry`=43115;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (43115,86598,-100,0,1,1,0);

-- loot 43132: Stack of Papers
DELETE FROM `gameobject_loot_template` WHERE `entry`=43132;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (43132,87798,100,0,1,1,0);

-- loot 43363: Oona Brew Mug
DELETE FROM `gameobject_loot_template` WHERE `entry`=43363;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (43363,88855,-100,0,1,1,0);

-- loot 43366: Serpent's Scale
DELETE FROM `gameobject_loot_template` WHERE `entry`=43366;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (43366,88895,-100,0,1,1,0);

-- loot 43367: Serpent's Scale
DELETE FROM `gameobject_loot_template` WHERE `entry`=43367;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (43367,88895,-100,0,1,1,0);

-- loot 43372: Stolen Boots
DELETE FROM `gameobject_loot_template` WHERE `entry`=43372;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (43372,89054,-100,0,1,1,0);

-- loot 43460: Onyx Egg
DELETE FROM `gameobject_loot_template` WHERE `entry`=43460;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (43460,89155,100,0,1,1,0);

-- loot 43478: Stolen Sri-La Keg
DELETE FROM `gameobject_loot_template` WHERE `entry`=43478;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (43478,88855,-100,0,1,1,0);

-- loot 43905: Rancher's Lariat
DELETE FROM `gameobject_loot_template` WHERE `entry`=43905;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (43905,75208,-100,0,1,1,0);

-- loot 44457: Sha-Touched Herb
DELETE FROM `gameobject_loot_template` WHERE `entry`=44457;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (44457,72238,100,0,2,3,0);

-- loot 44459: Sha-Touched Herb
DELETE FROM `gameobject_loot_template` WHERE `entry`=44459;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (44459,72238,100,0,2,3,0);

-- loot 45540: "Distilled" Fuel
DELETE FROM `gameobject_loot_template` WHERE `entry`=45540;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (45540,91846,-100,0,1,1,0);

-- loot 45553: Hastily Abandoned Lumber
DELETE FROM `gameobject_loot_template` WHERE `entry`=45553;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (45553,91907,-100,0,1,1,0);

-- loot 46976: Glimmering Jewel Danio Pool, Large Pool of Glimmering Jewel Danio
DELETE FROM `gameobject_loot_template` WHERE `entry`=46976;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (46976,74863,100,0,2,3,0);

-- loot 49418: Ghost Iron Deposit
DELETE FROM `gameobject_loot_template` WHERE `entry`=49418;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (49418,72092,100,0,2,4,0);

-- loot 49421: Rich Ghost Iron Deposit
DELETE FROM `gameobject_loot_template` WHERE `entry`=49421;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (49421,72092,100,0,3,6,0);

-- loot 49426: Fool's Cap
DELETE FROM `gameobject_loot_template` WHERE `entry`=49426;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (49426,79011,100,0,2,4,0),
 (49426,72238,5,0,1,1,0);

-- loot 49429: Silkweed
DELETE FROM `gameobject_loot_template` WHERE `entry`=49429;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (49429,72235,100,0,2,4,0),
 (49429,72238,5,0,1,1,0);

-- loot 49430: Rain Poppy
DELETE FROM `gameobject_loot_template` WHERE `entry`=49430;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (49430,72237,100,0,2,4,0),
 (49430,72238,5,0,1,1,0);

-- loot 49431: Green Tea Leaf
DELETE FROM `gameobject_loot_template` WHERE `entry`=49431;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (49431,72234,100,0,2,4,0),
 (49431,72238,5,0,1,1,0);

-- loot 49457: Jewel Danio School
DELETE FROM `gameobject_loot_template` WHERE `entry`=49457;
INSERT INTO `gameobject_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`groupid`,`mincountOrRef`,`maxcount`,`condition_id`) VALUES
 (49457,74863,100,0,2,3,0);

-- Still missing (no quest item, no matching item - needs authored loot):
--   2882: Defias Gunpowder
--   41331: Dry Fire Wood
--   41358: Eternal Blossom
--   41595: Kafa'kota Berries, Kafa'kota Bush
--   42555: Shiny Egg
--   42900: Virmen Treasure Cache
--   42901: Equipment Locker
--   42914: Stolen Sprite Treasure
--   42927: Stash of Yaungol Weapons
--   42939: Abandoned Crate of Goods
--   49252: Shao-Tien Rice
--   49253: Silkfeather Hawk Egg
--   49498: Giant Clam
--   54233: 
--   54236: Vault of Forbidden Treasures
--   54244: Unlocked Stockpile of Pandaren Spoils
--   223521: Kor'kron Supplies
--   232092: 
--   232164: 
--   232166: Unlocked Stockpile of Pandaren Spoils

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


