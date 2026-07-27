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
    SET @cOldContent = '065';

    -- New Values
    SET @cNewVersion = '23';
    SET @cNewStructure = '02';
    SET @cNewContent = '066';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'pop_NPC_Gossip_pt1';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'pop_NPC_Gossip_Events_pt1';

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
-- Mangos4 conversion to MOP, phase 5: GOSSIP, NPC TEXT, VENDORS, TRAINERS,
-- PAGE TEXT, GAME EVENT SPAWN LINKS (full-dump edition)
-- ============================================================================
SET NAMES utf8;
SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE='';

DELETE FROM `npc_text` WHERE `ID` IN (19513,19526,20201,20551,20564,20618,20620,20621,20622,20624,21024,22932,22990,30000,30001,31023,42230,50616,53245,54024,62445,65082,65901,65910,66068,74212,724001,724002,724003,724004,724005,921061,16777215);
DELETE FROM `gossip_menu` WHERE `entry` IN (589,590,591,592,1668,2186,3643,4464,4477,4478,6492,6500,6510,6627,7872,8151,8358,8359,8360,8361,8363,8364,8365,8408,8409,8411,8412,8413,8414,8415,8416,8417,8418,8550,8988,9711,9898,10513,10600,10687,10688,13060,13140,13608,13609,14224,14379,14422,14580,14581,14583,14584,14616,14617,14672,14988,15719,21002,21003,21004,21005,21006,21008,21009,21011,21012,21013,21014,21016,21017,21018,21020,21021,21022,21023,21025,21026,21029,21030,21031,21032,21033,21034,21036,21037,21040,21042,21043,21044,21045,21046,21047,21050,21051,21052,21053,21055,21056,21057,21058,21059,21060,21061,21062,21063,21066,21068,21070,21071,21072,21073,21075,21076,21077,21078,21079,21080,21081,21082,21083,21084,21085,21086,21087,21088,21089,21090,21091,21092,21093,21094,21095,21096,21097,21098,21099,21100,21101,21102,21103,21104,21105,21106,21107,21108,21109,21110,21111,21112,21113,21114,21115,21116,21117,21118,21119,21120,21121,21122,21123,21124,21125,21126,21127,21128,21129,21130,21131,21132,21133,21134,21135,21136,21137,21138,21139,21140,21141,21142,21143,21144,21145,21146,21147,21148,21149,21150,21151,21152,21153,21154,21155,21156,21157,21158,21159,21160,21161,21162,21163,21164,21165,21166,21167,21168,21169,21170,21171,21172,21173,21174,21175,21176,21177,21178,21179,21180,21181,21182,21183,21184,21185,21186,21187,21188,21189,21190,21191,21192,21193,21194,21195,21196,21197,21198,21200,21201,21202,21203,21204,21205,21206,21207,21208,21209,21210,21211,21212,21213,21214,21215,21216,21217,21218,21219,21220,21221,21222,21223,21224,21225,21226,21227,21228,21229,21231,21232,21234,21235,21236,21237,21239,21240,21241,21242,21246,21247,21248,21251,21252,21253,21254,21255,21256,21257,21258,21259,21260,21261,21262,21272,21273,21274,21275,21276,21277,21278,21279,21280,21281,21282,21283,21284,21285,21286,21287,21288,21289,21290,21291,21292,21293,21294,21310,21311,21313,21314,21315,21316,21317,21318,21319,21320,21321,21322,21323,21324,21325,21326,21330,21331,21332,21333,21334,21335,21340,21400,40060,54000,55000);
DELETE FROM `gossip_menu_option` WHERE `menu_id` IN (589,590,591,592,1668,2186,3643,4464,4477,4478,6492,6500,6510,6627,7872,8151,8358,8359,8360,8361,8363,8364,8365,8408,8409,8411,8412,8413,8414,8415,8416,8417,8418,8550,8988,9711,9898,10513,10600,10687,10688,13060,13140,13608,13609,14224,14379,14422,14580,14581,14583,14584,14616,14617,14672,14988,15719,21002,21003,21004,21005,21006,21008,21009,21011,21012,21013,21014,21016,21017,21018,21020,21021,21022,21023,21025,21026,21029,21030,21031,21032,21033,21034,21036,21037,21040,21042,21043,21044,21045,21046,21047,21050,21051,21052,21053,21055,21056,21057,21058,21059,21060,21061,21062,21063,21066,21068,21070,21071,21072,21073,21075,21076,21077,21078,21079,21080,21081,21082,21083,21084,21085,21086,21087,21088,21089,21090,21091,21092,21093,21094,21095,21096,21097,21098,21099,21100,21101,21102,21103,21104,21105,21106,21107,21108,21109,21110,21111,21112,21113,21114,21115,21116,21117,21118,21119,21120,21121,21122,21123,21124,21125,21126,21127,21128,21129,21130,21131,21132,21133,21134,21135,21136,21137,21138,21139,21140,21141,21142,21143,21144,21145,21146,21147,21148,21149,21150,21151,21152,21153,21154,21155,21156,21157,21158,21159,21160,21161,21162,21163,21164,21165,21166,21167,21168,21169,21170,21171,21172,21173,21174,21175,21176,21177,21178,21179,21180,21181,21182,21183,21184,21185,21186,21187,21188,21189,21190,21191,21192,21193,21194,21195,21196,21197,21198,21200,21201,21202,21203,21204,21205,21206,21207,21208,21209,21210,21211,21212,21213,21214,21215,21216,21217,21218,21219,21220,21221,21222,21223,21224,21225,21226,21227,21228,21229,21231,21232,21234,21235,21236,21237,21239,21240,21241,21242,21246,21247,21248,21251,21252,21253,21254,21255,21256,21257,21258,21259,21260,21261,21262,21272,21273,21274,21275,21276,21277,21278,21279,21280,21281,21282,21283,21284,21285,21286,21287,21288,21289,21290,21291,21292,21293,21294,21310,21311,21313,21314,21315,21316,21317,21318,21319,21320,21321,21322,21323,21324,21325,21326,21330,21331,21332,21333,21334,21335,21340,21400,40060,54000,55000);
DELETE FROM `npc_vendor` WHERE `entry` IN (3529,5944,6737,12799,16786,18898,18990,18991,19857,21483,21488,23447,24396,25176,25177,25179,25195,25196,26383,26384,26901,26947,27668,27721,27722,28225,28800,28813,29493,30437,31863,31864,31865,32356,32359,32380,32381,32383,32385,32405,32407,32832,32834,33915,33916,33917,33918,33919,33920,33921,33922,33923,33924,33925,33926,33927,33928,33931,33933,33941,34037,34040,34059,34062,34073,34074,34076,34077,34080,34082,34083,34084,34087,34088,34089,34090,34091,34092,35790,54943,54981,54982,55143,55180,55233,55809,56406,56687,56689,56693,56705,56707,56777,56778,58162,58414,58789,59042,59044,59045,59059,59079,59173,59320,59341,59403,59405,59413,59569,59597,59688,59691,59695,59827,59894,60420,60423,60425,60605,60762,61215,61493,61596,61598,61640,61749,61756,62322,62656,62657,62660,62661,62662,62663,62737,62867,62871,62872,62874,62875,62878,62879,62882,62883,62917,62935,62967,63008,63016,63367,63721,64047,64062,64078,64100,64126,64231,64331,64333,64342,64343,64365,64366,64522,64585,64595,64599,64605,64606,64607,64829,64836,64922,64940,65068,65171,65172,65220,65289,65528,66022,66035,66219,66223,66230,66236,66238,66241,66242,66243,66246,66247,66248,66249,66250,66353,66354,66356,66359,66678,66685,66973,66998,67052,67054,67170,67171,67173,67175,67176,67178,67179,67180,67181,67182,67183,67184,67447,67565,67751,67775,67776,68989,69060,70030,70034,70155,70346,70436,72007,72993,72997,73003,73004,73005,73006,73007,73009,73010,73047,73082,73142,73143,73144,73147,73305,73306,73307,73399,73401,73435,73618,73622,73647,73649,73651,73656,73657,73812,73813,73814,73815,73816,73817,73819);
DELETE FROM `npc_trainer` WHERE `entry` IN (996,1384,1546,2133,2222,3071,3703,3964,3965,4888,4941,4998,4999,5032,5033,5037,5038,5040,5041,6242,6288,6387,7174,7525,7526,7528,8777,12020,12035,12939,15465,16000,16190,16265,16487,16527,25263,28400,48685,53437,58712,58713,58714,58715,58716,58717,63596,63626,64231,66222,66980,66981,70301,200001,200002,200003,200004,200005,200006,200007,200008,200009,200011,200100,200101,200102,200103,200200,200201,200202,200300,200301,200302,200303,200304,200305,200400,200401,200402,200403,200404,200405,200406,200407,200408,200409,200410,200433,200434,201009);
DELETE FROM `page_text` WHERE `entry` IN (4546,4605,4610);
DELETE FROM `game_event` WHERE `entry` IN (74);
DELETE FROM `game_event_creature` WHERE `guid` BETWEEN 8500000 AND 8599999;
DELETE FROM `game_event_gameobject` WHERE `guid` BETWEEN 600000 AND 699999;

-- ---------------------------------------------------------------- 2. NPC TEXT
INSERT INTO `npc_text` (`ID`,`text0_0`,`text0_1`,`BroadcastTextID0`,`lang0`,`prob0`,`em0_0_delay`,`em0_0`,`em0_1_delay`,`em0_1`,`em0_2_delay`,`em0_2`,`text1_0`,`text1_1`,`BroadcastTextID1`,`lang1`,`prob1`,`em1_0_delay`,`em1_0`,`em1_1_delay`,`em1_1`,`em1_2_delay`,`em1_2`,`text2_0`,`text2_1`,`BroadcastTextID2`,`lang2`,`prob2`,`em2_0_delay`,`em2_0`,`em2_1_delay`,`em2_1`,`em2_2_delay`,`em2_2`,`text3_0`,`text3_1`,`BroadcastTextID3`,`lang3`,`prob3`,`em3_0_delay`,`em3_0`,`em3_1_delay`,`em3_1`,`em3_2_delay`,`em3_2`,`text4_0`,`text4_1`,`BroadcastTextID4`,`lang4`,`prob4`,`em4_0_delay`,`em4_0`,`em4_1_delay`,`em4_1`,`em4_2_delay`,`em4_2`,`text5_0`,`text5_1`,`BroadcastTextID5`,`lang5`,`prob5`,`em5_0_delay`,`em5_0`,`em5_1_delay`,`em5_1`,`em5_2_delay`,`em5_2`,`text6_0`,`text6_1`,`BroadcastTextID6`,`lang6`,`prob6`,`em6_0_delay`,`em6_0`,`em6_1_delay`,`em6_1`,`em6_2_delay`,`em6_2`,`text7_0`,`text7_1`,`BroadcastTextID7`,`lang7`,`prob7`,`em7_0_delay`,`em7_0`,`em7_1_delay`,`em7_1`,`em7_2_delay`,`em7_2`) VALUES
(22932,'Rokkaram, is that you?$B$BForgive me for questioning you, my son. My sight isn''t what it once was, but the raven has blessed me with a long life. Soon it will be time for you to take my place. I have taught you all I know. $B$BMy only regret is that I didn''t prove worthy enough to recover our sacred Book of the Raven.The true believers have lived in shame since the day our treacherous cousins in Skettis stole the book from us, shattered its tablet, and buried the fragments in their wretched city!$B$BPray that the raven will choose you to restore it, my son. Be faithful and remember always the prophecy, "From the dreams of his enemies shall the raven spring forth into the world."','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(921061,'Hey citizen ! I need your help.. .','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(16777215,'Greetings $N','Greetings $N',0,0,0,0,0,0,0,0,0,'Greetings $N','Greetings $N',0,0,0,0,0,0,0,0,0,'Greetings $N','Greetings $N',0,0,0,0,0,0,0,0,0,'Greetings $N','Greetings $N',0,0,0,0,0,0,0,0,0,'Greetings $N','Greetings $N',0,0,0,0,0,0,0,0,0,'Greetings $N','Greetings $N',0,0,0,0,0,0,0,0,0,'Greetings $N','Greetings $N',0,0,0,0,0,0,0,0,0,'Greetings $N','Greetings $N',0,0,0,0,0,0,0,0,0),
(20201,'Stop! Do not go any further, mortal. You are ill-prepared to face the forces of the Infinite Dragonflight.Come, let me help you.','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(20551,'I hope this damned thing works. "Araxes pounds on the portable trasnponder."','Iam Here, Commander',0,0,0,0,0,0,0,0,0,'Weve located the mark, commander. Ya-six and i have been seperated. Requesting backup.','Arxes! Send help! Im pinned down in the mines, I...Im not sure where iam exactly but i had the presence of mind to drop tracers on the gro8und behind me',0,0,0,0,0,0,0,0,0,'I cant follow the tracers back out, too many flesh beasts in the way.Send someone in... Follow the tracers... Ya-Six out.','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(20564,'Araxes, come in....Are you there Araxes? Visibility is nil, Warp storms blocking us.','Copy, Status report, Soldier.',0,0,0,0,0,0,0,0,0,'Copy that, Araxes. Backup is on the way. Hold your position. I repeat, Hold your Position','Ameer, Over and out.',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(21024,'It is here that Gul`dan severed the tie between orcs and elemental spirits. His unquenchable thirst for power could not be satiated with the complete annihilation of the draenei. He had to also destroy Draenor, razing the land and siphoning all of its energies for use in his war.  Npw all that is left are remnants of his madness.   Look to the altar, night elf - the land is forever haunted......','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(22990,'Be wary, friends. The Betrayer meditates in the court just beyond.','Be wary, friends. The Betrayer meditates in the court just beyond.',0,0,1,0,0,0,0,0,0,' ',' ',0,0,0,0,0,0,0,0,0,' ',' ',0,0,0,0,0,0,0,0,0,' ',' ',0,0,0,0,0,0,0,0,0,' ',' ',0,0,0,0,0,0,0,0,0,' ',' ',0,0,0,0,0,0,0,0,0,' ',' ',0,0,0,0,0,0,0,0,0,' ',' ',0,0,0,0,0,0,0,0,0),
(30000,'Here you will find the Inscription Trainer.','Here you will find the Inscription Trainer.',0,0,1,0,0,0,0,0,0,'So you want to be a Inscriber? Well here you will find the trainer.','So you want to be a Inscriber? Well here you will find the trainer.',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(30001,'So you are looking for a Inscription Trainer? Well you can''t find the trainer out here, better head to the nearest city.
','So you are looking for a Inscription Trainer? Well you can''t find the trainer out here, better head to the nearest city.
',0,0,0,0,0,0,0,0,0,'So you want to be a Inscriber? Well you can''t find the trainer out here, better head to the nearest city.','So you want to be a Inscriber? Well you can''t find the trainer out here, better head to the nearest city.',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(31023,'Hello, $N. What can I do for you?','Hello, $N. What can I do for you?',0,0,1,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(724001,'Greetings $N! Are you ready to be tested in Crusaders Coliseum?','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(724002,'Are you ready for the next stage?','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(724003,'Are you ready to fight the champions of the Silver vanguard?','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(724004,'Are you ready for the next stage?','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(724005,'Are you ready to continue battle with Anub-Arak?','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(54024,'<Shu looks at you expectantly.>','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(53245,'I came to ask the famous Aysa Cloudsinger for help, but I just can''t bring myself to intrude on her exercises. She''s so poised, so practiced... so beautiful.','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(65910,'It is said, "Turn your face towards the sun, and the shadows will fall behind you."$b$bI hope you find many bright days ahead of you, $n!','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(50616,'Have you seen my latest invention? It''s going to be a hit... if it doesn''t explode.','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(42230,'Operation: Gnomeregan was a success. Sure, that dastardly Thermaplugg had an unforeseen trick up his sleeve, but we have him on the run! It''s only a matter of time before Gnomeregan is cleaned up and in our hands again!','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(66068,'','<Aysa appears to be deeply lost in her excercises.>',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(65901,'Whoever said they''d rather light a candle than curse the darkness...$b$bWell, they probably haven''t lit as many candles as me.','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(62445,'','Should try the special.',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(65082,'Why was the tank nervous before the fight?$B$B...$B$BBecause he was a worrier!','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(74212,'Hello friend.','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(20624,'Your skill in cooking is only as great as your most advanced Way.','Your skill in cooking is only as great as your most advanced Way.',0,0,100,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(19513,'Brew here!','',0,0,100,0,0,0,2,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(19526,'Looking for meat? I''ve got plenty right here.$b$bOn my grill, I mean.','',0,0,100,0,0,0,2,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(20618,'Hello, friend, Hungry?','',0,0,100,0,0,0,2,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(20622,'Did you need something?','',0,0,100,0,0,0,2,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(20621,'It smells delicious, doesn''t it?','',0,0,100,0,0,0,2,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0),
(20620,'Yes?','',0,0,100,0,0,0,2,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0,'','',0,0,0,0,0,0,0,0,0);

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


