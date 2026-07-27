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
    SET @cOldContent = '082';

    -- New Values
    SET @cNewVersion = '23';
    SET @cNewStructure = '02';
    SET @cNewContent = '083';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'More Startup Fixes Pt3';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'More Startup Fixes Pt3';

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
-- MaNGOS Four world DB update (round 2): M4v2_09_spell_chain_cleanup.sql
-- Removes 18 pre-Cataclysm leftover rows from `spell_chain`.
--
-- 13 rows model profession SPECIALIZATIONS as "rank 5" of the pre-4.0
-- profession chains (first 2018/2259/3908/2108/4036). The 5.4.8 client data
-- generates the real MoP chains (first 110396/105206/110426/110423/110403,
-- the Zen Master tiers), so the core rejects these rows at every startup.
-- Specializations are standalone spells, not ranks - the rows serve no
-- purpose on a 5.4.8 core. Also removed: the 3 Weaponsmith sub-specs
-- (would start erroring once 9787 is gone) and the 2 rows the core flags
-- as redundant single-rank data (759, 26573).
-- Verified against Mangos4DB.sql: every guarded DELETE matches exactly
-- one existing row. 8 valid rows remain untouched.
-- ============================================================

-- Weaponsmith (removed in 4.0)
DELETE FROM `spell_chain` WHERE `spell_id`=9787 AND `prev_spell`=9785 AND `first_spell`=2018 AND `rank`=5 AND `req_spell`=0;
-- Armorsmith (removed in 4.0)
DELETE FROM `spell_chain` WHERE `spell_id`=9788 AND `prev_spell`=9785 AND `first_spell`=2018 AND `rank`=5 AND `req_spell`=0;
-- Master Swordsmith (removed in 4.0)
DELETE FROM `spell_chain` WHERE `spell_id`=17039 AND `prev_spell`=9787 AND `first_spell`=2018 AND `rank`=6 AND `req_spell`=0;
-- Master Hammersmith (removed in 4.0)
DELETE FROM `spell_chain` WHERE `spell_id`=17040 AND `prev_spell`=9787 AND `first_spell`=2018 AND `rank`=6 AND `req_spell`=0;
-- Master Axesmith (removed in 4.0)
DELETE FROM `spell_chain` WHERE `spell_id`=17041 AND `prev_spell`=9787 AND `first_spell`=2018 AND `rank`=6 AND `req_spell`=0;
-- Transmutation Master (spec, not a rank)
DELETE FROM `spell_chain` WHERE `spell_id`=28672 AND `prev_spell`=11611 AND `first_spell`=2259 AND `rank`=5 AND `req_spell`=0;
-- Potion Master (spec, not a rank)
DELETE FROM `spell_chain` WHERE `spell_id`=28675 AND `prev_spell`=11611 AND `first_spell`=2259 AND `rank`=5 AND `req_spell`=0;
-- Elixir Master (spec, not a rank)
DELETE FROM `spell_chain` WHERE `spell_id`=28677 AND `prev_spell`=11611 AND `first_spell`=2259 AND `rank`=5 AND `req_spell`=0;
-- Spellfire Tailoring (removed in 4.0)
DELETE FROM `spell_chain` WHERE `spell_id`=26797 AND `prev_spell`=12180 AND `first_spell`=3908 AND `rank`=5 AND `req_spell`=0;
-- Mooncloth Tailoring (removed in 4.0)
DELETE FROM `spell_chain` WHERE `spell_id`=26798 AND `prev_spell`=12180 AND `first_spell`=3908 AND `rank`=5 AND `req_spell`=0;
-- Shadoweave Tailoring (removed in 4.0)
DELETE FROM `spell_chain` WHERE `spell_id`=26801 AND `prev_spell`=12180 AND `first_spell`=3908 AND `rank`=5 AND `req_spell`=0;
-- Dragonscale LW (removed in 4.0)
DELETE FROM `spell_chain` WHERE `spell_id`=10656 AND `prev_spell`=10662 AND `first_spell`=2108 AND `rank`=5 AND `req_spell`=0;
-- Elemental LW (removed in 4.0)
DELETE FROM `spell_chain` WHERE `spell_id`=10658 AND `prev_spell`=10662 AND `first_spell`=2108 AND `rank`=5 AND `req_spell`=0;
-- Tribal LW (removed in 4.0)
DELETE FROM `spell_chain` WHERE `spell_id`=10660 AND `prev_spell`=10662 AND `first_spell`=2108 AND `rank`=5 AND `req_spell`=0;
-- Gnomish Engineering (spec, not a rank)
DELETE FROM `spell_chain` WHERE `spell_id`=20219 AND `prev_spell`=12656 AND `first_spell`=4036 AND `rank`=5 AND `req_spell`=0;
-- Goblin Engineering (spec, not a rank)
DELETE FROM `spell_chain` WHERE `spell_id`=20222 AND `prev_spell`=12656 AND `first_spell`=4036 AND `rank`=5 AND `req_spell`=0;
-- Conjure Mana Gem - single rank in 5.4.8, row redundant
DELETE FROM `spell_chain` WHERE `spell_id`=759 AND `prev_spell`=0 AND `first_spell`=759 AND `rank`=1 AND `req_spell`=0;
-- Consecration - single rank in 5.4.8, row redundant
DELETE FROM `spell_chain` WHERE `spell_id`=26573 AND `prev_spell`=0 AND `first_spell`=26573 AND `rank`=1 AND `req_spell`=0;

-- ============================================================
-- MaNGOS Four world DB update (round 2): M4v2_10_spell_learn_spell_cleanup.sql
-- Removes 20 rows from `spell_learn_spell` whose trigger spell no longer
-- exists in the 5.4.8 client: two removed druid talents (Feral Swiftness,
-- Nurturing Instinct) and the Cataclysm guild-perk learn-triggers
-- (80388, 86467, 86530, 87491-87509). In MoP, guild perks are granted via
-- the guild-level system / client data, not spell_learn_spell.
-- The core skips these rows at every startup; this makes it permanent.
-- Guarded per-row; verified against Mangos4DB.sql (20 rows, all present).
-- ============================================================

-- 17002: Feral Swiftness r1 (druid talent, removed in 5.0)
DELETE FROM `spell_learn_spell` WHERE `entry`=17002 AND `SpellID`=24867;
-- 24866: Feral Swiftness r2 (removed in 5.0)
DELETE FROM `spell_learn_spell` WHERE `entry`=24866 AND `SpellID`=24864;
-- 33872: Nurturing Instinct (removed in 5.0)
DELETE FROM `spell_learn_spell` WHERE `entry`=33872 AND `SpellID`=47179;
-- 80388: Cata guild-perk trigger (removed in 5.0)
DELETE FROM `spell_learn_spell` WHERE `entry`=80388 AND `SpellID`=93375;
-- 86467: Cata guild-perk trigger (removed in 5.0)
DELETE FROM `spell_learn_spell` WHERE `entry`=86467 AND `SpellID`=86473;
-- 86530: Cata guild-perk trigger (removed in 5.0)
DELETE FROM `spell_learn_spell` WHERE `entry`=86530 AND `SpellID`=86093;
DELETE FROM `spell_learn_spell` WHERE `entry`=86530 AND `SpellID`=86096;
DELETE FROM `spell_learn_spell` WHERE `entry`=86530 AND `SpellID`=86097;
DELETE FROM `spell_learn_spell` WHERE `entry`=86530 AND `SpellID`=86104;
-- 87491: Cata guild-perk trigger (removed in 5.0)
DELETE FROM `spell_learn_spell` WHERE `entry`=87491 AND `SpellID`=86470;
-- 87492: Cata guild-perk trigger (removed in 5.0)
DELETE FROM `spell_learn_spell` WHERE `entry`=87492 AND `SpellID`=86471;
-- 87493: Cata guild-perk trigger (removed in 5.0)
DELETE FROM `spell_learn_spell` WHERE `entry`=87493 AND `SpellID`=86472;
-- 87494: Cata guild-perk trigger (removed in 5.0)
DELETE FROM `spell_learn_spell` WHERE `entry`=87494 AND `SpellID`=86474;
-- 87495: Cata guild-perk trigger (removed in 5.0)
DELETE FROM `spell_learn_spell` WHERE `entry`=87495 AND `SpellID`=86475;
-- 87496: Cata guild-perk trigger (removed in 5.0)
DELETE FROM `spell_learn_spell` WHERE `entry`=87496 AND `SpellID`=86476;
-- 87497: Cata guild-perk trigger (removed in 5.0)
DELETE FROM `spell_learn_spell` WHERE `entry`=87497 AND `SpellID`=86477;
-- 87498: Cata guild-perk trigger (removed in 5.0)
DELETE FROM `spell_learn_spell` WHERE `entry`=87498 AND `SpellID`=86478;
-- 87500: Cata guild-perk trigger (removed in 5.0)
DELETE FROM `spell_learn_spell` WHERE `entry`=87500 AND `SpellID`=86479;
-- 87506: Cata guild-perk trigger (removed in 5.0)
DELETE FROM `spell_learn_spell` WHERE `entry`=87506 AND `SpellID`=86528;
-- 87509: Cata guild-perk trigger (removed in 5.0)
DELETE FROM `spell_learn_spell` WHERE `entry`=87509 AND `SpellID`=86526;

-- ============================================================
-- MaNGOS Four world DB update (round 2): M4v2_11_spell_bonus_data_cleanup.sql
-- Cleans `spell_bonus_data` (spell-power/AP coefficient overrides):
--  A) deletes rows for 16 spells removed from the 5.4.8 client;
--  B) deletes 2 rows made fully redundant (direct_bonus matches the
--     auto-calculated coefficient, nothing else used: 5176 Wrath,
--     33110 Prayer of Mending heal);
--  C) zeroes `dot_bonus`/`ap_dot_bonus` on rows whose spell has no
--     periodic effect in 5.4.8 (mostly old Wrath-era data for spells whose
--     DoT component was removed) -- the core ignores those fields anyway;
--     rows where nothing useful remains after zeroing are deleted instead.
-- Guarded per-row; verified against Mangos4DB.sql.
-- ============================================================

-- A) removed spells: 16 row(s)
DELETE FROM `spell_bonus_data` WHERE `entry`=543;
DELETE FROM `spell_bonus_data` WHERE `entry`=13218;
DELETE FROM `spell_bonus_data` WHERE `entry`=15237;
DELETE FROM `spell_bonus_data` WHERE `entry`=19306;
DELETE FROM `spell_bonus_data` WHERE `entry`=20424;
DELETE FROM `spell_bonus_data` WHERE `entry`=25742;
DELETE FROM `spell_bonus_data` WHERE `entry`=27813;
DELETE FROM `spell_bonus_data` WHERE `entry`=28176;
DELETE FROM `spell_bonus_data` WHERE `entry`=30294;
DELETE FROM `spell_bonus_data` WHERE `entry`=34913;
DELETE FROM `spell_bonus_data` WHERE `entry`=50536;
DELETE FROM `spell_bonus_data` WHERE `entry`=53733;
DELETE FROM `spell_bonus_data` WHERE `entry`=54158;
DELETE FROM `spell_bonus_data` WHERE `entry`=60089;
DELETE FROM `spell_bonus_data` WHERE `entry`=63675;
DELETE FROM `spell_bonus_data` WHERE `entry`=64085;

-- B) fully redundant rows: 2
DELETE FROM `spell_bonus_data` WHERE `entry`=5176;
DELETE FROM `spell_bonus_data` WHERE `entry`=33110;

-- C) unused periodic coefficients: 69 spell(s)
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=17;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=120;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=122;
DELETE FROM `spell_bonus_data` WHERE `entry`=172; -- nothing useful left
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=331;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=339;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=403;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=421;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=596;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=686;
UPDATE `spell_bonus_data` SET `ap_dot_bonus`=0 WHERE `entry`=779;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=1064;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=1449;
DELETE FROM `spell_bonus_data` WHERE `entry`=1978; -- nothing useful left
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=2060;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=2061;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=2136;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=2912;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=2948;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=5185;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=6343;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=6353;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=6572;
UPDATE `spell_bonus_data` SET `ap_dot_bonus`=0 WHERE `entry`=7712;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=8004;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=8092;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=11113;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=11426;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=13376;
UPDATE `spell_bonus_data` SET `ap_dot_bonus`=0 WHERE `entry`=13897;
UPDATE `spell_bonus_data` SET `ap_dot_bonus`=0 WHERE `entry`=16614;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=17877;
UPDATE `spell_bonus_data` SET `ap_dot_bonus`=0 WHERE `entry`=18798;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=19236;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=20167;
UPDATE `spell_bonus_data` SET `ap_dot_bonus`=0 WHERE `entry`=22568;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=24275;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=25912;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=25914;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=26573;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=27285;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=29722;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=30283;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=30451;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=31661;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=31935;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=32379;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=32546;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=34861;
UPDATE `spell_bonus_data` SET `ap_dot_bonus`=0 WHERE `entry`=44525;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=45055;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=45284;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=45297;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=45429;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=50256;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=51460;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=51505;
UPDATE `spell_bonus_data` SET `ap_dot_bonus`=0 WHERE `entry`=53353;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=57755;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=57984;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=59638;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=60203;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=60488;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=61391;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=61491;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=64382;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=64844;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=69733;
UPDATE `spell_bonus_data` SET `dot_bonus`=0, `ap_dot_bonus`=0 WHERE `entry`=69734;

-- ============================================================
-- MaNGOS Four world DB update (round 2): M4v2_13_item_ghosts_and_pages.sql
-- OPTIONAL - review before applying.
--
-- A) 94 "ghost" items exist in item_template but NOT in the 5.4.8
--    client's item data (test items, removed WotLK glyphs/scrolls/patterns,
--    seasonal leftovers). A 5.4.8 client cannot display them; if looted
--    they show as invalid. Deleting them plus their loot/vendor references
--    keeps the DB consistent (no quest references exist - verified).
-- B) 32 placeholder pages for readable items whose page_text is missing,
--    so books open in-game instead of failing; text is clearly marked
--    as placeholder. Replace with real text at leisure.
-- ============================================================

-- A) ghost items and their references
DELETE FROM `creature_loot_template` WHERE `item` IN (905,1041,3384,3393,9036,9293,11098,11224,13513,13522,16216,16243,20732,20733,22053,22541,22548,25848,25849,28276,28277,29483,29485,29486,29487,29488,29669,29672,29673,29674,29675,31357,33176,33182,33183,33184,33189,33208,33209,35433,35434,35435,35450,37161,37330,37331,37332,37333,37334,38770,38784,38795,38815,38826,38843,38858,38891,38892,38907,38915,38941,38942,38950,38956,38957,38958,38969,38970,38977,38982,38983,38994,38996,43230,43232,43234,44559,44560,44561,44562,44563,44939,45908,47499,47507,58149,65359,67155,72047,72102,72106,90458,90501,90502); -- 565 row(s)
DELETE FROM `gameobject_loot_template` WHERE `item` IN (905,1041,3384,3393,9036,9293,11098,11224,13513,13522,16216,16243,20732,20733,22053,22541,22548,25848,25849,28276,28277,29483,29485,29486,29487,29488,29669,29672,29673,29674,29675,31357,33176,33182,33183,33184,33189,33208,33209,35433,35434,35435,35450,37161,37330,37331,37332,37333,37334,38770,38784,38795,38815,38826,38843,38858,38891,38892,38907,38915,38941,38942,38950,38956,38957,38958,38969,38970,38977,38982,38983,38994,38996,43230,43232,43234,44559,44560,44561,44562,44563,44939,45908,47499,47507,58149,65359,67155,72047,72102,72106,90458,90501,90502); -- 35 row(s)
DELETE FROM `item_loot_template` WHERE `item` IN (905,1041,3384,3393,9036,9293,11098,11224,13513,13522,16216,16243,20732,20733,22053,22541,22548,25848,25849,28276,28277,29483,29485,29486,29487,29488,29669,29672,29673,29674,29675,31357,33176,33182,33183,33184,33189,33208,33209,35433,35434,35435,35450,37161,37330,37331,37332,37333,37334,38770,38784,38795,38815,38826,38843,38858,38891,38892,38907,38915,38941,38942,38950,38956,38957,38958,38969,38970,38977,38982,38983,38994,38996,43230,43232,43234,44559,44560,44561,44562,44563,44939,45908,47499,47507,58149,65359,67155,72047,72102,72106,90458,90501,90502); -- 10 row(s)
DELETE FROM `reference_loot_template` WHERE `item` IN (905,1041,3384,3393,9036,9293,11098,11224,13513,13522,16216,16243,20732,20733,22053,22541,22548,25848,25849,28276,28277,29483,29485,29486,29487,29488,29669,29672,29673,29674,29675,31357,33176,33182,33183,33184,33189,33208,33209,35433,35434,35435,35450,37161,37330,37331,37332,37333,37334,38770,38784,38795,38815,38826,38843,38858,38891,38892,38907,38915,38941,38942,38950,38956,38957,38958,38969,38970,38977,38982,38983,38994,38996,43230,43232,43234,44559,44560,44561,44562,44563,44939,45908,47499,47507,58149,65359,67155,72047,72102,72106,90458,90501,90502); -- 5 row(s)
DELETE FROM `npc_vendor` WHERE `item` IN (905,1041,3384,3393,9036,9293,11098,11224,13513,13522,16216,16243,20732,20733,22053,22541,22548,25848,25849,28276,28277,29483,29485,29486,29487,29488,29669,29672,29673,29674,29675,31357,33176,33182,33183,33184,33189,33208,33209,35433,35434,35435,35450,37161,37330,37331,37332,37333,37334,38770,38784,38795,38815,38826,38843,38858,38891,38892,38907,38915,38941,38942,38950,38956,38957,38958,38969,38970,38977,38982,38983,38994,38996,43230,43232,43234,44559,44560,44561,44562,44563,44939,45908,47499,47507,58149,65359,67155,72047,72102,72106,90458,90501,90502); -- 26 row(s)
DELETE FROM `item_template` WHERE `entry` IN (905,1041,3384,3393,9036,9293,11098,11224,13513,13522,16216,16243,20732,20733,22053,22541,22548,25848,25849,28276,28277,29483,29485,29486,29487,29488,29669,29672,29673,29674,29675,31357,33176,33182,33183,33184,33189,33208,33209,35433,35434,35435,35450,37161,37330,37331,37332,37333,37334,38770,38784,38795,38815,38826,38843,38858,38891,38892,38907,38915,38941,38942,38950,38956,38957,38958,38969,38970,38977,38982,38983,38994,38996,43230,43232,43234,44559,44560,44561,44562,44563,44939,45908,47499,47507,58149,65359,67155,72047,72102,72106,90458,90501,90502); -- the 94 ghost items

-- B) placeholder pages
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4315, '[Partially Soaked Pages]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4315);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4338, '[Pandaren Scroll]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4338);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4379, '[Sentinel Scout''s Report]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4379);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4383, '[Dojani Orders]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4383);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4394, '[Sunwalker Scout''s Report]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4394);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4418, '[Song of the Vale]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4418);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4452, '[Crumpled Bill of Sale]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4452);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4459, '[Legacy of the Masters (Part 1)]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4459);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4479, '[Scroll of Auspice]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4479);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4481, '[Calligraphed Letter]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4481);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4482, '[Elegant Scroll]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4482);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4483, '[Elegant Rune]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4483);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4484, '[Calligraphed Parchment]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4484);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4485, '[Calligraphed Note]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4485);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4486, '[Calligraphed Sigil]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4486);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4487, '[Alliance Orders]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4487);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4511, '[A Missive from Lorewalker Cho]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4511);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4566, '[Horde Missive]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4566);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4567, '[Alliance Missive]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4567);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4593, '[Mysterious Note]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4593);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4595, '[Mysterious Note]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4595);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4596, '[A Steamy Romance Novel: Hot and Misty]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4596);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4660, '[Troubles From Without]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4660);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4690, '[Reliquary Facsimile]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4690);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4695, '[Jubeka''s Journal]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4695);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4725, '[Sealed Note]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4725);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4788, '[Waterlogged Zandalari Journal]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4788);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4790, '[Iron-Bound Zandalari Journal]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4790);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4791, '[Blood-Spattered Zandalari Journal]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4791);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4793, '[Torn Zandalari Journal]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4793);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4795, '[Frayed Zandalari Journal]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4795);
INSERT INTO `page_text` (`entry`,`text`,`next_page`) SELECT 4820, '[Time-Worn Journal]$B$BThis text is not yet available in the database.', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `page_text` WHERE `entry`=4820);

-- ============================================================
-- MaNGOS Four world DB update (round 2): M4v2_14_spawnmask_fixes.sql
-- Residual spawnMask normalization - apply together with the
-- spawn-mask validation core patch (see core_patch_spawnmasks.md).
--
-- A) Maps 938/939/940 (End Time, Well of Eternity, Hour of Twilight -
--    the heroic-only 4.3 dungeons): spawns carry WotLK-style mask 3
--    (normal+heroic) or 1 (normal only); the only mode these maps run
--    in is heroic (internal mode 1 -> mask 2), matching how Zul'Gurub /
--    Zul'Aman data is already stored.
-- B) Maps 959-962 (Shado-Pan Monastery, Temple of the Jade Serpent,
--    Stormstout Brewery, Gate of the Setting Sun): part of the spawns
--    were imported with raw 5.4.8 difficulty-id bits (mask 6 = ids 1+2)
--    instead of internal spawn-mode bits (mask 3 = modes 0+1).
-- ============================================================

-- A) heroic-only 4.3 dungeons -> mask 2
UPDATE `creature`   SET `spawnMask`=2 WHERE `map` IN (938,939,940) AND `spawnMask` IN (1,3);
UPDATE `gameobject` SET `spawnMask`=2 WHERE `map` IN (938,939,940) AND `spawnMask` IN (1,3);

-- B) MoP dungeons: difficulty-id bits -> spawn-mode bits
UPDATE `creature`   SET `spawnMask`=3 WHERE `map` IN (959,960,961,962) AND `spawnMask`=6;
UPDATE `gameobject` SET `spawnMask`=3 WHERE `map` IN (959,960,961,962) AND `spawnMask`=6;

-- ============================================================
-- MaNGOS Four world DB update (round 2): M4v2_15_gameobject_state_fix.sql
-- Six elevator spawns (Serpent's Spine great-wall elevators on Pandaria,
-- and four Siege of Orgrimmar elevators) were imported from a
-- TrinityCore-format source with `state` = 24 (TC's
-- GO_STATE_TRANSPORT_ACTIVE). MaNGOS only knows states 0-2, so the loader
-- SKIPS these rows and the elevators never spawn at all.
-- Every other transport spawn in this DB (125 of 132) uses state 1
-- (GO_STATE_READY); align these six with that convention.
-- ============================================================

UPDATE `gameobject` SET `state`=1 WHERE `guid`=600954 AND `id`=212976 AND `state`=24; -- Doodad_VEB_greatwall_elevator_002
UPDATE `gameobject` SET `state`=1 WHERE `guid`=601179 AND `id`=212975 AND `state`=24; -- Doodad_VEB_greatwall_elevator_003
UPDATE `gameobject` SET `state`=1 WHERE `guid`=609211 AND `id`=220364 AND `state`=24; -- Doodad_Orgrimmar_Elevator_004 (SoO)
UPDATE `gameobject` SET `state`=1 WHERE `guid`=609236 AND `id`=219177 AND `state`=24; -- Doodad_Orgrimmar_Elevator_03 (SoO)
UPDATE `gameobject` SET `state`=1 WHERE `guid`=609241 AND `id`=219176 AND `state`=24; -- Doodad_Orgrimmar_Elevator_02 (SoO)
UPDATE `gameobject` SET `state`=1 WHERE `guid`=609252 AND `id`=219175 AND `state`=24; -- Doodad_Orgrimmar_Elevator_01 (SoO)


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


