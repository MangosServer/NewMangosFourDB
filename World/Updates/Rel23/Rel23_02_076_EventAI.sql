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
    SET @cOldContent = '075';

    -- New Values
    SET @cNewVersion = '23';
    SET @cNewStructure = '02';
    SET @cNewContent = '076';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'pop_EventAI';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'pop_EventAI';

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
-- Mangos4 conversion to MOP, phase 8: SMARTAI -> EVENTAI
--
--   Conversion notes:
--   - Timed/aggro/death/kill/range/HP events and cast/text/emote/phase/despawn/
--     kill-credit actions are mapped 1:1 where the engines agree; SmartAI link
--     chains are folded into EventAI's three action slots (overflow duplicates
--     the event row).
--   - Unconvertible pieces are skipped, counts: {'event 38': 20, 'orphan link row': 11, 'cast target 11': 2, 'action 115': 4, 'action 44': 14, 'cast target 19': 1, 'action 87': 4, 'action 27': 4, 'event 62': 2, 'action 49': 2}
--     (world-phasing, gossip-driven, actionlist and data-set logic have no
--     EventAI equivalent; those creatures keep default AI where nothing mapped).
-- ============================================================================
SET NAMES utf8;
SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE='';

DELETE FROM `creature_ai_scripts` WHERE `creature_id` IN (53565,54131,54586,54587,54734,56201,56239,56309,56357,57649,57752,57753,58068,58216,58273,58880,58893,59021,59148,59166,59705,59715,59722,59742,59746,59753,59768,59769,59787,59788,59797,60201,60202,63673,64202,65469,65470,65471,65626,66315,66707,72762,72764,72765,72777,72844);
DELETE FROM `creature_ai_texts` WHERE `entry` BETWEEN -400012 AND -400001;

-- ---------------------------------------------------------------- 2. TEXTS
INSERT INTO `creature_ai_texts` (`entry`,`content_default`,`sound`,`type`,`language`,`emote`,`comment`) VALUES
(-400001,'That was a good match. Thank you.',0,0,0,511,'SmartAI convert: 54586 group 0'),
(-400002,'My skills are no match for yours. I admit defeat.',0,0,0,507,'SmartAI convert: 54586 group 0'),
(-400003,'Your skills are too great. I yield.',0,0,0,511,'SmartAI convert: 54586 group 0'),
(-400004,'That was a good match. Thank you.',0,0,0,1,'SmartAI convert: 54587 group 0'),
(-400005,'You fought well. I must learn more from you in the future.',0,0,0,1,'SmartAI convert: 54587 group 0'),
(-400006,'Thank you for reminding me that I must train more diligently.',0,0,0,1,'SmartAI convert: 54587 group 0'),
(-400007,'That was a good match. Thank you.',0,0,0,1,'SmartAI convert: 65470 group 0'),
(-400008,'My skills are no match for yours. I admit defeat.',0,0,0,507,'SmartAI convert: 65470 group 0'),
(-400009,'Your skills are too great. I yield.',0,0,0,511,'SmartAI convert: 65470 group 0'),
(-400010,'That was a good match. Thank you.',0,0,0,1,'SmartAI convert: 65471 group 0'),
(-400011,'You fought well. I must learn more from you in the future.',0,0,0,1,'SmartAI convert: 65471 group 0'),
(-400012,'Thank you for reminding me that I must train more diligently.',0,0,0,1,'SmartAI convert: 65471 group 0');

-- ---------------------------------------------------------------- 3. SCRIPTS
INSERT INTO `creature_ai_scripts` (`id`,`creature_id`,`event_type`,`event_inverse_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action1_type`,`action1_param1`,`action1_param2`,`action1_param3`,`action2_type`,`action2_param1`,`action2_param2`,`action2_param3`,`action3_type`,`action3_param1`,`action3_param2`,`action3_param3`,`comment`) VALUES
(5356500,53565,0,65533,100,1,1000,1000,5000,5000,10,507,509,511,0,0,0,0,0,0,0,0,'Aspiring Trainee - On Update - Cast Spell ''Jab'''),
(5413100,54131,0,0,100,0,500,500,500,500,11,46598,0,0,0,0,0,0,0,0,0,0,'Fe Feng Hozen - IC once - Cast Ride Vehicle Hardcoded on self'),
(5458600,54586,11,0,100,1,0,0,0,0,42,1,0,0,20,1,0,0,22,0,0,0,'Huojin Trainee - On Respawn - Set Invincibility Hp 1'),
(5458601,54586,4,0,100,1,0,0,0,0,22,1,0,0,0,0,0,0,0,0,0,0,'Huojin Trainee - On Aggro - Set Phase 1'),
(5458602,54586,2,65533,100,0,1,0,0,0,2,35,0,0,5,0,0,0,1,-400001,-400002,-400003,'Huojin Trainee - Between 0-1% Health - Combat Stop'),
(5458603,54586,2,65533,100,0,1,0,0,0,33,54586,6,0,41,3000,0,0,0,0,0,0,'Huojin Trainee - Between 0-1% Health - Combat Stop'),
(5458700,54587,11,0,100,1,0,0,0,0,42,1,0,0,20,1,0,0,22,0,0,0,'Tushui Trainee - On Respawn - Set Invincibility Hp 1'),
(5458701,54587,4,0,100,1,0,0,0,0,22,1,0,0,0,0,0,0,0,0,0,0,'Tushui Trainee - On Aggro - Set Phase 1'),
(5458702,54587,2,65533,100,0,1,0,0,0,2,35,0,0,5,0,0,0,1,-400004,-400005,-400006,'Tushui Trainee - Between 0-1% Health - Combat Stop'),
(5458703,54587,2,65533,100,0,1,0,0,0,33,54586,6,0,41,3000,0,0,0,0,0,0,'Tushui Trainee - Between 0-1% Health - Combat Stop'),
(5473400,54734,0,0,100,1,4000,4500,10000,10500,11,108958,1,0,0,0,0,0,0,0,0,0,'Master Li Fei - IC - Feet of Fury'),
(5473401,54734,0,0,100,1,5000,6000,11000,12000,11,108944,1,0,0,0,0,0,0,0,0,0,'Master Li Fei - IC - Flying Shadow Kick'),
(5473402,54734,2,0,100,1,20,1,0,0,33,54734,1,0,0,0,0,0,0,0,0,0,'Master Li Fei - at 20% health - give credit'),
(5620100,56201,0,0,100,1,3000,4000,13000,14000,11,106918,1,1,0,0,0,0,0,0,0,0,'Orchard Wasp - In Combat - Cast Noxious Venom'),
(5623900,56239,0,0,100,1,8000,9000,22000,23000,11,125384,1,1,0,0,0,0,0,0,0,0,'Adolescent Mushan - In Combat - Cast Belly Flop'),
(5630900,56309,1,0,100,1,0,0,0,0,21,0,0,0,22,0,0,0,0,0,0,0,'Grookin Wildtail - Out Of Combat - Allow Combat Movement'),
(5630901,56309,4,0,100,1,0,0,0,0,11,105762,1,0,23,1,0,0,0,0,0,0,'Grookin Wildtail - On Aggro - Cast Sling Derk'),
(5630902,56309,9,0,100,1,0,40,3000,3500,11,105762,1,0,0,0,0,0,0,0,0,0,'Grookin Wildtail - At 0 - 40 Range - Cast Sling Derk'),
(5630903,56309,3,0,100,1,15,0,0,0,21,1,0,0,23,1,0,0,0,0,0,0,'Grookin Wildtail - At 15% Mana - Allow Combat Movement'),
(5630904,56309,9,0,100,0,35,80,0,0,21,1,0,0,0,0,0,0,0,0,0,0,'Grookin Wildtail - At 35 - 80 Range - Allow Combat Movement'),
(5630905,56309,9,0,100,0,5,15,0,0,21,0,0,0,0,0,0,0,0,0,0,0,'Grookin Wildtail - At 5 - 15 Range - Allow Combat Movement'),
(5630906,56309,9,0,100,0,0,5,0,0,21,1,0,0,0,0,0,0,0,0,0,0,'Grookin Wildtail - At 0 - 5 Range - Allow Combat Movement'),
(5630907,56309,3,0,100,1,100,25,100,100,23,1,0,0,0,0,0,0,0,0,0,0,'Grookin Wildtail - At 100% Mana - Increment Phase'),
(5635700,56357,9,0,100,1,5,40,1700,3800,11,129496,1,0,0,0,0,0,0,0,0,0,'Lupello - Within 5-40 Range - Cast ''Prey Pounce'''),
(5635701,56357,0,0,100,1,10000,10500,10500,15500,11,129502,1,0,0,0,0,0,0,0,0,0,'Lupello - In Combat - Cast ''Fearsome Howl'''),
(5635702,56357,0,0,100,1,5000,10000,10000,15000,11,129497,1,0,0,0,0,0,0,0,0,0,'Lupello - In Combat - Cast ''Pounced'''),
(5764900,57649,0,0,100,1,3000,4000,6000,7000,11,119556,1,1,0,0,0,0,0,0,0,0,'Weeping Horror - In Combat - Cast Overwhelming Sadness'),
(5775200,57752,1,0,100,1,0,0,5000,5000,10,507,509,511,0,0,0,0,0,0,0,0,'Quiet Lam - OOC - Play Random Emote (507, 509, 511, 543)'),
(5775300,57753,1,0,100,1,0,0,5000,5000,10,507,509,511,0,0,0,0,0,0,0,0,'Ironfist Zhou - OOC - Play Random Emote (507, 509, 511, 543)'),
(5806800,58068,0,0,100,1,21800,25400,24300,26700,11,11971,1,0,0,0,0,0,0,0,0,0,'Dojani Surveyor - In Combat - Sunder Armor'),
(5821600,58216,0,0,100,1,0,0,3300,5100,11,119577,1,0,0,0,0,0,0,0,0,0,'Wildscale Herbalist - In Combat - Cast Wrath'),
(5821601,58216,14,0,80,0,0,40,0,0,11,119575,6,1,0,0,0,0,0,0,0,0,'Wildscale Herbalist - On Friendly Unit At 0 - 40% Health - Cast Healing Wave'),
(5827300,58273,0,0,100,1,1000,2000,9000,10000,11,119561,1,1,0,0,0,0,0,0,0,0,'Riverblade Slayer - In Combat - Cast Bloodletting'),
(5827301,58273,0,0,100,1,2000,3000,10000,11000,11,119569,1,1,0,0,0,0,0,0,0,0,'Riverblade Slayer - In Combat - Cast Savage Strikes'),
(5888000,58880,0,0,100,1,3500,4000,12500,13000,11,117372,1,1,0,0,0,0,0,0,0,0,'Viseclaw Fisher - In Combat - Cast Vise Claw'),
(5889300,58893,0,0,100,1,7200,7300,7250,7350,11,117586,1,0,0,0,0,0,0,0,0,0,'Sungraze Mushan - In Combat - Bludgeon'),
(5902100,59021,0,0,100,1,7000,10000,10000,15000,11,11970,1,0,0,0,0,0,0,0,0,0,'Bataari Flamecaller - In Combat - Cast Fire Nova'),
(5902101,59021,0,0,100,1,9000,12000,8000,12000,11,15536,1,0,0,0,0,0,0,0,0,0,'Bataari Flamecaller - In Combat - Cast Fire Ball'),
(5914800,59148,0,0,100,1,7000,10000,10000,15000,11,11970,1,0,0,0,0,0,0,0,0,0,'Bataari Flamecaller - In Combat - Cast Fire Nova'),
(5914801,59148,0,0,100,1,9000,12000,8000,12000,11,15536,1,0,0,0,0,0,0,0,0,0,'Bataari Flamecaller - In Combat - Cast Fire Ball'),
(5916600,59166,0,0,100,1,4200,7700,7100,16200,11,11639,1,0,0,0,0,0,0,0,0,0,'Enraged Priest - In Combat - Cast Shadow Word: Pain'),
(5970500,59705,0,0,100,1,7000,7000,20000,20000,11,115506,0,0,0,0,0,0,0,0,0,0,'Scarlet Flamethrower - On IC Timer - Cast Flamethrower.'),
(5971500,59715,0,0,70,1,25000,25000,25000,25000,11,18266,4,0,0,0,0,0,0,0,0,0,'Riverblade Chieftain - In Combat - Cast Curse of Agony'),
(5971501,59715,0,0,75,1,15000,15000,30000,30000,11,9613,1,0,0,0,0,0,0,0,0,0,'Riverblade Chieftain - In Combat - Cast Shadow Bolt'),
(5971502,59715,2,0,100,1,30,0,0,0,11,84533,0,1,0,0,0,0,0,0,0,0,'Riverblade Chieftain - At 30% HP - Cast Drain Life'),
(5972200,59722,7,0,100,1,0,0,0,0,11,114951,0,0,0,0,0,0,0,0,0,0,'Pile of Corpses - Cast Pile of Corpses On Reset'),
(5972201,59722,0,0,100,1,0,0,0,0,20,0,0,0,0,0,0,0,0,0,0,0,'Pile of Corpses -  Set React Passive on Reset.'),
(5974200,59742,0,0,100,1,4000,5000,8000,9000,11,116013,1,1,0,0,0,0,0,0,0,0,'Thunderfist Gorilla - In Combat - Cast Thunderfist Rage'),
(5974201,59742,0,0,100,1,8000,9000,12000,13000,11,116007,1,1,0,0,0,0,0,0,0,0,'Thunderfist Gorilla - In Combat - Cast Thunderfist'),
(5974600,59746,0,0,100,1,15000,15000,35000,35000,11,115511,0,2,0,0,0,0,0,0,0,0,'Scarlet Centurion - On IC Timer - Cast Retaliation.'),
(5974601,59746,0,0,100,1,7000,7000,16000,16000,11,115519,1,0,0,0,0,0,0,0,0,0,'Scarlet Centurion - On IC Timer - Cast Cleave.'),
(5975300,59753,0,0,100,1,4500,5000,7500,8000,11,115083,1,1,0,0,0,0,0,0,0,0,'Golden Tiger - In Combat - Cast Ferocious Claw'),
(5976800,59768,0,0,100,1,3000,3500,13000,13500,11,116010,1,1,0,0,0,0,0,0,0,0,'Jadeglow Wasp - In Combat - Cast Jadeglow Poison'),
(5976900,59769,0,0,100,1,4000,4500,10000,10500,11,116026,1,1,0,0,0,0,0,0,0,0,'Bamboo Python - In Combat - Cast Swamp Fever'),
(5978700,59787,4,0,100,0,0,0,0,0,11,115385,0,0,0,0,0,0,0,0,0,0,'Sunrise Crane - On Aggro - Cast Rush'),
(5978800,59788,1,0,100,1,0,0,0,0,21,0,0,0,22,0,0,0,0,0,0,0,'Spirit Darter - Out Of Combat - Allow Combat Movement'),
(5978801,59788,4,0,100,1,0,0,0,0,11,115394,1,0,23,1,0,0,0,0,0,0,'Spirit Darter - On Aggro - Cast Mana Flare'),
(5978802,59788,9,0,100,1,0,40,2500,3000,11,115394,1,0,0,0,0,0,0,0,0,0,'Spirit Darter - At 0 - 40 Range - Cast Mana Flare'),
(5978803,59788,3,0,100,1,15,0,0,0,21,1,0,0,23,1,0,0,0,0,0,0,'Spirit Darter - At 15% Mana - Allow Combat Movement'),
(5978804,59788,9,0,100,0,35,80,0,0,21,1,0,0,0,0,0,0,0,0,0,0,'Spirit Darter - At 35 - 80 Range - Allow Combat Movement'),
(5978805,59788,9,0,100,0,5,15,0,0,21,0,0,0,0,0,0,0,0,0,0,0,'Spirit Darter - At 5 - 15 Range - Allow Combat Movement'),
(5978806,59788,9,0,100,0,0,5,0,0,21,1,0,0,0,0,0,0,0,0,0,0,'Spirit Darter - At 0 - 5 Range - Allow Combat Movement'),
(5978807,59788,3,0,100,1,100,25,100,100,23,1,0,0,0,0,0,0,0,0,0,0,'Spirit Darter - At 100% Mana - Increment Phase'),
(5979700,59797,0,0,70,1,25000,25000,25000,25000,11,129132,4,0,0,0,0,0,0,0,0,0,'Mogujia Soul-Caller - In Combat - Cast Shadow Crash - on random target'),
(5979701,59797,0,0,75,1,15000,15000,30000,30000,11,9613,1,0,0,0,0,0,0,0,0,0,'Mogujia Soul-Caller - In Combat - Cast Shadow Bolt'),
(5979702,59797,2,0,100,1,30,0,0,0,11,84533,0,1,0,0,0,0,0,0,0,0,'Mogujia Soul-Caller - At 30% HP - Cast Drain Life'),
(6020100,60201,9,0,100,1,5,40,1000,1500,11,87930,1,0,0,0,0,0,0,0,0,0,'Mortbreath Snapper - Within 5-40 Range - Charge'),
(6020101,60201,0,0,100,1,12000,12900,12500,13400,11,118990,1,0,0,0,0,0,0,0,0,0,'Mortbreath Snapper - In Combat - Jaw Snap'),
(6020200,60202,9,0,100,1,5,40,1000,1500,11,87930,1,0,0,0,0,0,0,0,0,0,'Mortbreath Skulker - Within 5-40 Range - Charge'),
(6020201,60202,0,0,100,1,12000,12900,12500,13400,11,118990,1,0,0,0,0,0,0,0,0,0,'Mortbreath Skulker - In Combat - Jaw Snap'),
(6367300,63673,4,0,100,0,0,0,0,0,11,131524,0,0,0,0,0,0,0,0,0,0,'Farraki Sand-Stormer - On Aggro - Cast Burning Winds'),
(6367301,63673,0,0,100,1,15000,15000,25000,40000,11,131553,1,0,0,0,0,0,0,0,0,0,'Farraki Sand-Stormer - In Combat - Cast Heat Lightning'),
(6420200,64202,0,0,100,1,1000,1000,12000,15000,11,129095,1,0,0,0,0,0,0,0,0,0,'Gurubashi Hexxer - In Combat - Cast Spirit Assault'),
(6420201,64202,0,0,100,1,7000,9000,15000,17000,11,126241,1,1,0,0,0,0,0,0,0,0,'Gurubashi Hexxer - In Combat - Cast Hex'),
(6420202,64202,0,0,100,1,7000,10000,15000,22000,11,126242,4,0,0,0,0,0,0,0,0,0,'Gurubashi Hexxer - In Combat - Cast Shrink'),
(6546900,65469,0,65533,100,1,1000,1000,5000,5000,10,507,509,511,0,0,0,0,0,0,0,0,'Aspiring Trainee - On Update - Cast Spell ''Jab'''),
(6547000,65470,11,0,100,1,0,0,0,0,42,1,0,0,20,1,0,0,22,0,0,0,'Huojin Trainee - On Respawn - Set Invincibility Hp 1'),
(6547001,65470,4,0,100,1,0,0,0,0,22,1,0,0,0,0,0,0,0,0,0,0,'Huojin Trainee - On Aggro - Set Phase 1'),
(6547002,65470,2,65533,100,0,1,0,0,0,2,35,0,0,5,0,0,0,1,-400007,-400008,-400009,'Huojin Trainee - Between 0-1% Health - Combat Stop'),
(6547003,65470,2,65533,100,0,1,0,0,0,33,54586,6,0,41,3000,0,0,0,0,0,0,'Huojin Trainee - Between 0-1% Health - Combat Stop'),
(6547100,65471,11,0,100,1,0,0,0,0,42,1,0,0,20,1,0,0,22,0,0,0,'Tushui Trainee - On Respawn - Set Invincibility Hp 1'),
(6547101,65471,4,0,100,1,0,0,0,0,22,1,0,0,0,0,0,0,0,0,0,0,'Tushui Trainee - On Aggro - Set Phase 1'),
(6547102,65471,2,65533,100,0,1,0,0,0,2,35,0,0,5,0,0,0,1,-400010,-400011,-400012,'Tushui Trainee - Between 0-1% Health - Combat Stop'),
(6547103,65471,2,65533,100,0,1,0,0,0,33,54586,6,0,41,3000,0,0,0,0,0,0,'Tushui Trainee - Between 0-1% Health - Combat Stop'),
(6562600,65626,0,0,100,1,21800,21900,21700,23100,11,129018,1,0,0,0,0,0,0,0,0,0,'Dojani Enforcer - In Combat - Shockwave'),
(6562601,65626,0,0,100,1,13300,14600,14500,15800,11,129017,1,0,0,0,0,0,0,0,0,0,'Dojani Enforcer - In Combat - Leap of Victory'),
(6562602,65626,0,0,100,1,12400,16700,16500,21800,11,129016,1,0,0,0,0,0,0,0,0,0,'Dojani Enforcer - In Combat - Enrage'),
(6631500,66315,0,0,75,1,15000,15000,30000,30000,11,12739,1,0,0,0,0,0,0,0,0,0,'Shan''ze Stonebender - In Combat - Cast Shadow Bolt'),
(6670700,66707,4,0,100,1,0,0,0,0,11,131559,1,0,0,0,0,0,0,0,0,0,'Drakkari Frostweaver - On Aggro - Cast Ice Column'),
(6670701,66707,9,0,100,1,0,40,3300,6600,11,9672,1,0,0,0,0,0,0,0,0,0,'Drakkari Frostweaver - At 0 - 40 Range - Cast Frostbolt'),
(6670702,66707,9,0,100,1,0,8,11000,16000,11,11831,0,1,0,0,0,0,0,0,0,0,'Drakkari Frostweaver - At 0 - 8 Range - Cast Frost Nova'),
(7276200,72762,0,0,100,1,2000,10000,35000,45000,11,147306,1,0,0,0,0,0,0,0,0,0,'@Windfeather'),
(7276201,72762,0,0,100,1,4000,20000,70000,90000,11,147310,1,0,0,0,0,0,0,0,0,0,'@Gust of Wind'),
(7276400,72764,0,0,100,1,2000,10000,35000,45000,11,147568,1,0,0,0,0,0,0,0,0,0,'@Snapping Bite'),
(7276401,72764,0,0,100,1,4000,20000,70000,90000,11,147571,1,0,0,0,0,0,0,0,0,0,'@Shell Spin'),
(7276500,72765,0,0,100,1,2000,10000,35000,45000,11,147573,1,0,0,0,0,0,0,0,0,0,'@Geyser'),
(7276501,72765,0,0,100,1,4000,20000,70000,90000,11,147589,1,0,0,0,0,0,0,0,0,0,'@Snapping Bite'),
(7276502,72765,0,0,100,1,6000,30000,105000,135000,11,147590,1,0,0,0,0,0,0,0,0,0,'@Shell Spin'),
(7277700,72777,0,0,100,1,2000,10000,35000,45000,11,147654,1,0,0,0,0,0,0,0,0,0,'@Toxic Skin'),
(7277701,72777,0,0,100,1,4000,20000,70000,90000,11,147655,1,0,0,0,0,0,0,0,0,0,'@Gulp Frog Toxin');
INSERT INTO `creature_ai_scripts` (`id`,`creature_id`,`event_type`,`event_inverse_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action1_type`,`action1_param1`,`action1_param2`,`action1_param3`,`action2_type`,`action2_param1`,`action2_param2`,`action2_param3`,`action3_type`,`action3_param1`,`action3_param2`,`action3_param3`,`comment`) VALUES
(7284400,72844,0,0,100,1,2000,10000,35000,45000,11,147368,1,0,0,0,0,0,0,0,0,0,'@Iron Fur'),
(7284401,72844,0,0,100,1,4000,20000,70000,90000,11,147385,1,0,0,0,0,0,0,0,0,0,'@Ox Charge'),
(7284402,72844,0,0,100,1,6000,30000,105000,135000,11,147386,1,0,0,0,0,0,0,0,0,0,'@Ox Charge');

-- ---------------------------------------------------------------- 4. ENABLE EVENTAI
UPDATE `creature_template` SET `AIName`='EventAI' WHERE `Entry` IN (53565,54131,54586,54587,54734,56201,56239,56309,56357,57649,57752,57753,58068,58216,58273,58880,58893,59021,59148,59166,59705,59715,59722,59742,59746,59753,59768,59769,59787,59788,59797,60201,60202,63673,64202,65469,65470,65471,65626,66315,66707,72762,72764,72765,72777,72844);

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


