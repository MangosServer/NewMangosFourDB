@ECHO OFF
rem -- set the main parameters
set createcharDB=YES
set createworldDB=YES
set createrealmDB=YES

set loadcharDB=YES
set loadworldDB=YES
set loadrealmDB=YES
set DBType=POPULATED
set activity=@

set viacommandline=NO

rem -- Change the values below to match your server --
set mysql=
set svr=localhost
set user=root
set pass=mangos
set port=3306
set wdb=mangos4
set wdborig=mangos4
set cdb=character4
set cdborig=character4
set rdb=realmd
set rdborig=realmd


SET servername=%1
if %servername%. NEQ . goto parameters:
goto main

:parameters
if %servername% == HELP goto parametersbanners:
goto processparams

:parametersbanners
CLS
echo %colWhiteBold%_______________________________________________________________________________
echo %colWhiteDarkBlue%^|    __  __      _  _  ___  ___  ___                                          ^|
echo ^|   ^|  \/  ^|__ _^| \^| ^|/ __^|/ _ \/ __^|                                         ^|
echo ^|   ^| ^|\/^| / _` ^| .` ^| (_ ^| (_) \__ \                                         ^|
echo ^|   ^|_^|  ^|_\__,_^|_^|\_^|\___^|\___/^|___/ %colYellowBold%Database Backup v2.0                %colWhiteBold%    ^|
echo ^|_____________________________________________________________________________^|
echo %colWhiteLightBlue%^|                                                                             ^|
echo ^|   Website / Forum / Wiki / Support: https://getmangos.eu                    ^|
echo ^|_____________________________________________________________________________^|%colReset%
echo %colWhiteBold%^|                                                                             ^|
echo %colWhiteBold%^|  
echo.
ECHO.
echo  Parameters:
echo.
echo  backupDB {servername} {username} {password} {port} {worlddbname}
echo           {wdbStruct} {chardbname} {cdbStruct} {realmdbname} {rdbStruct}
echo.
echo  Where    {servername}  - The name or ip address of the server
echo           {username}    - Username to use
echo           {password}    - Password to use
echo           {port}        - Port to access the server
echo           {worlddbname} - Name of the World Database
echo           {wdbStruct}   - Backup the Structure as part of the backup (YES/NO)
echo           {chardbname}  - Name of the Character Database
echo           {cdbStruct}   - Backup the Structure as part of the backup (YES/NO)
echo           {realmdbname} - Name of the Realm Database
echo           {rdbStruct}   - Backup the Structure as part of the backup (YES/NO)

echo  e.g.
echo.
echo  backupDB mangosserver root mangos 3306 mangos0 YES character0 YES realmd YES
echo.
goto finish

:processparams
set svr=%1
set user=%2
set pass=%3
set port=%4
set wdb=%5
set cdb=%7
set rdb=%9
set loadworldDB=%6
set loadcharDB=%8
shift /1
set loadrealmDB=%9
set viacommandline=YES

echo.
echo  backupDB %svr% %user% %pass% %port% %wdb% %loadworldDB% %cdb% %loadcharDB% %rdb% %loadrealmDB%
echo.
rem pause
rem goto finish


rem -- Don't change past this point --
rem setlocal

goto main:

:BackupTable
rem Subroutine to backup a single table
rem Parameters: %1=tablename, %2=database, %3=outputdir, %4=loadDBflag
SET TABLENAME=%1
SET CURRENTDB=%2
SET OUTPUTDIR=%3
SET LOADFLAG=%4
echo Dumping.... %TABLENAME%
if %LOADFLAG% == NO echo -- ---------------------------------------- >  %OUTPUTDIR%\%TABLENAME%.sql
if %LOADFLAG% == NO echo -- --        CLEAR DOWN THE TABLE        -- >>  %OUTPUTDIR%\%TABLENAME%.sql
if %LOADFLAG% == NO echo -- ---------------------------------------- >>  %OUTPUTDIR%\%TABLENAME%.sql
if %LOADFLAG% == NO echo TRUNCATE TABLE `%TABLENAME%`; >>  %OUTPUTDIR%\%TABLENAME%.sql
if %LOADFLAG% == NO echo -- ---------------------------------------- >>  %OUTPUTDIR%\%TABLENAME%.sql
mysqldump -Q -c -e -q %extraparams% -u%user% -p%pass% --port=%port% -h %svr% %CURRENTDB% %TABLENAME% >>  %OUTPUTDIR%\%TABLENAME%.sql
goto :EOF

:main
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "6.3" echo Windows 8.1
if "%version%" == "6.2" echo Windows 8.
if "%version%" == "6.1" echo Windows 7.
if "%version%" == "6.0" echo Windows Vista.
if "%version%" == "10.0" echo Windows 10.

if "%version%" == "10.0" goto setColours:
goto setOptions:

:setColours
set colReset=[0m
set colYellow=[33m
set colYellowBold=[93m
set colWhiteBold=[97m
set colWhiteDarkBlue=[97;44m
set colWhiteLightBlue=[97;104m
set colWhiteLightGreen=[97;42m
set colCyanBold=[96m
set colCyan=[36m
set colWhite=[37m
set colMagentaBold=[95m
set colMagenta=[35m
set colRedBold=[91m
set colRed=[31m
set colGreenBold=[92m
set colGreen=[32m
set colWhiteDarkRed=[97;101m
set colBold=[101m
set colWhiteDarkYellow=[97;43m


:setOptions
rem If running from the commandline, skip the asking for params
if %viacommandline% == YES goto Step1:
CLS

echo %colWhiteBold%_______________________________________________________________________________
echo %colWhiteDarkBlue%^|    __  __      _  _  ___  ___  ___                                          ^|
echo ^|   ^|  \/  ^|__ _^| \^| ^|/ __^|/ _ \/ __^|                                         ^|
echo ^|   ^| ^|\/^| / _` ^| .` ^| (_ ^| (_) \__ \                                         ^|
echo ^|   ^|_^|  ^|_\__,_^|_^|\_^|\___^|\___/^|___/ %colYellowBold%Database Backup v2.0                %colWhiteBold%    ^|
echo ^|_____________________________________________________________________________^|
echo %colWhiteLightBlue%^|                                                                             ^|
echo ^|   Website / Forum / Wiki / Support: https://getmangos.eu                    ^|
echo ^|_____________________________________________________________________________^|%colReset%
echo %colWhiteBold%^|                                                                             ^|
echo %colWhiteBold%^|                                                                             ^|

if %createcharDB% == NO set PAD= 
if %createcharDB% == YES set PAD=
echo %colWhiteBold%^|    Character Database : V -%colWhite% Backup DB (%colYellowBold%%createcharDB%%colWhite%)%PAD%                                 %colWhiteBold%^|

if %loadcharDB% == NO set PAD= 
if %loadcharDB% == YES set PAD=
echo %colWhiteBold%^|                         C -%colWhite% Include DB Structure (%colYellowBold%%loadcharDB%%colWhite%)%PAD%                      %colWhiteBold%^|
echo %colWhiteBold%^|                                                                             ^|

if %createworldDB% == NO set PAD= 
if %createworldDB% == YES set PAD=
echo %colWhiteBold%^|        %colYellowBold%World Database : E -%colYellow% Backup DB (%colWhiteBold%%createworldDB%%colYellow%)%PAD%                                 %colWhiteBold%^|

if %loadworldDB% == NO set PAD= 
if %loadworldDB% == YES set PAD=
echo %colWhiteBold%^|                         %colYellowBold%W -%colYellow% Include DB Structure (%colWhiteBold%%loadworldDB%%colYellow%)%PAD%                      %colWhiteBold%^|
echo %colWhiteBold%^|                                                                             ^|

if %createrealmDB% == NO set PAD= 
if %createrealmDB% == YES set PAD=
echo %colWhiteBold%^|        %colCyanBold%Realm Database : T -%colCyan% Backup DB (%colWhiteBold%%createrealmDB%%colCyan%)%PAD%                                 %colWhiteBold%^|

if %loadrealmDB% == NO set PAD= 
if %loadrealmDB% == YES set PAD=
echo %colWhiteBold%^|                         %colCyanBold%R -%colCyan% Include DB Structure (%colWhiteBold%%loadrealmDB%%colCyan%)%PAD%                      %colWhiteBold%^|
echo %colWhiteBold%^|                                                                             ^|
echo %colWhiteBold%^|                         %colGreenBold%N -%colGreen% Next Step%colWhiteBold%                                       ^|
echo %colWhiteBold%^|                         X - %colWhite%Exit%colWhiteBold%                                            ^|
echo %colWhiteBold%^|                                                                             ^|
echo %colWhiteBold%^|    %colRedBold%Type backupDB HELP to display commandline options%colWhiteBold%                        ^|
echo %colWhiteBold%^|                                                                             ^|
echo %colWhiteBold%^|_____________________________________________________________________________^|%colReset%
echo.


set /p activity=. Please select an activity ? : 
if %activity% == V goto ToggleCharDB:
if %activity% == v goto ToggleCharDB:
if %activity% == E goto ToggleWorldDB:
if %activity% == e goto ToggleWorldDB:
if %activity% == T goto ToggleRealmDB:
if %activity% == t goto ToggleRealmDB:
if %activity% == C goto LoadCharDB:
if %activity% == c goto LoadCharDB:
if %activity% == W goto LoadWorldDB:
if %activity% == w goto LoadWorldDB:
if %activity% == R goto LoadRealmDB:
if %activity% == r goto LoadRealmDB:

if %activity% == N goto Step1:
if %activity% == n goto Step1:

if %activity% == X goto done:
if %activity% == x goto done:
if %activity%. == . goto main:
if %activity% == . goto main:
goto main:


:ToggleCharDB
if %createcharDB% == NO goto ToggleCharDBNo:
if %createcharDB% == YES goto ToggleCharDBYes:
goto main:

:ToggleCharDBNo
set createcharDB=YES
goto main:

:ToggleCharDBYes
set createcharDB=NO
goto main:

:ToggleWorldDB
if %createworldDB% == NO goto ToggleWorldDBNo:
if %createworldDB% == YES goto ToggleWorldDBYes:
goto main:

:ToggleWorldDBNo
set createworldDB=YES
goto main:

:ToggleWorldDBYes
set createworldDB=NO
goto main:

:ToggleRealmDB
if %createrealmDB% == NO goto ToggleRealmDBNo:
if %createrealmDB% == YES goto ToggleRealmDBYes:
goto main:

:ToggleRealmDBNo
set createrealmDB=YES
goto main:

:ToggleRealmDBYes
set createrealmDB=NO
goto main:

:LoadCharDB
if %loadcharDB% == NO goto LoadCharDBNo:
if %loadcharDB% == YES goto LoadCharDBYes:
goto main:

:LoadCharDBNo
set loadcharDB=YES
goto main:

:LoadCharDBYes
set loadcharDB=NO
goto main:

:LoadWorldDB
if %loadworldDB% == NO goto LoadWorldDBNo:
if %loadworldDB% == YES goto LoadWorldDBYes:
goto main:

:LoadWorldDBNo
set loadworldDB=YES
goto main:

:LoadWorldDBYes
set loadworldDB=NO
goto main:

:LoadRealmDB
if %loadrealmDB% == NO goto LoadRealmDBNo:
if %loadrealmDB% == YES goto LoadRealmDBYes:
goto main:

:LoadRealmDBNo
set loadrealmDB=YES
goto main:

:LoadRealmDBYes
set loadrealmDB=NO
goto main:

:Step1
if not exist %mysql%mysql.exe goto patherror:
rem If running from the commandline, skip the asking for params
if %viacommandline% == YES goto WorldDB:

CLS
echo %colWhiteBold%_______________________________________________________________________________
echo %colWhiteDarkBlue%^|    __  __      _  _  ___  ___  ___                                          ^|
echo ^|   ^|  \/  ^|__ _^| \^| ^|/ __^|/ _ \/ __^|                                         ^|
echo ^|   ^| ^|\/^| / _` ^| .` ^| (_ ^| (_) \__ \                                         ^|
echo ^|   ^|_^|  ^|_\__,_^|_^|\_^|\___^|\___/^|___/ %colYellowBold%Database Backup v2.0                %colWhiteBold%    ^|
echo ^|_____________________________________________________________________________^|
echo %colWhiteLightBlue%^|                                                                             ^|
echo ^|   Website / Forum / Wiki / Support: https://getmangos.eu                    ^|
echo ^|_____________________________________________________________________________^|%colReset%
echo.
echo.
set /p svr=. What is your MySQL host name?           [%svr%] : 
if %svr%. == . set svr=localhost
set /p user=. What is your MySQL user name?                [%user%] : 
if %user%. == . set user=root
set /p pass=. What is your MySQL password?               [%pass%] : 
if %pass%. == . set pass=mangos
set /p port=. What is your MySQL port?                     [%port%] : 
if %port%. == . set port=3306

set showChar=0
if %createcharDB% == YES set showChar=1
REM if %loadcharDB% == YES set showChar=1

if %showChar% == 1 set /p cdb=. What is your Character database name?  [%cdb%] : 
if %cdb%. == . set cdb=%cdborig%

set showWorld=0
if %createworldDB% == YES set showWorld=1
REM if %loadworldDB% == YES set showWorld=1
if %showWorld% == 1 set /p wdb=. What is your World database name?         [%wdb%] : 
if %wdb%. == . set wdb=%wdborig%

set showRealm=0
if %createrealmDB% == YES set showRealm=1
REM if %loadrealmDB% == YES set showRealm=1

if %showRealm% == 1 set /p rdb=. What is your Realm database name?          [%rdb%] : 
if %rdb%. == . set rdb=%rdborig%

color 02

:WorldDB
REM ##### IF createworlddb = YES then create the DB
if %loadworldDB% == NO set extraparams=--add-drop-table=false --no-create-info 
if %createworldDB% == YES goto WorldDB1:
if %loadworldDB% == YES goto WorldDB1:

:CharDB
REM ##### IF createchardb = YES then create the DB
set extraparams=
if %loadcharDB% == NO set extraparams=--add-drop-table=false --no-create-info 
if %loadcharDB% == YES goto CharDB1:
if %createcharDB% == YES goto CharDB1:

:RealmDB
REM ##### IF createrealmdb = YES then create the DB
set extraparams=
if %loadrealmDB% == NO set extraparams=--add-drop-table=false --no-create-info 
if %createrealmDB% == YES goto RealmDB1:
if %loadrealmDB% == YES goto RealmDB1:

goto done:

:WorldDB1
if exist _full_worlddb goto WorldDBSkip1:
md _full_worlddb
:WorldDBSkip1
echo %colWhiteBold%_______________________________________________________________________________
echo %colWhiteDarkYellow%^|                                                                             ^|
echo ^|                                                                             ^|
echo ^| Dumping World Database                                                      ^|
echo ^|                                                                             ^|
echo ^|_____________________________________________________________________________^|%colReset%
echo.

call :BackupTable achievement_criteria_requirement %wdb% _full_worlddb %loadworldDB%
call :BackupTable achievement_reward %wdb% _full_worlddb %loadworldDB%
call :BackupTable areatrigger_tavern %wdb% _full_worlddb %loadworldDB%
call :BackupTable areatrigger_teleport %wdb% _full_worlddb %loadworldDB%
call :BackupTable autobroadcast %wdb% _full_worlddb %loadworldDB%
call :BackupTable battleground_events %wdb% _full_worlddb %loadworldDB%
call :BackupTable battleground_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable battlemaster_entry %wdb% _full_worlddb %loadworldDB%
call :BackupTable command %wdb% _full_worlddb %loadworldDB%
call :BackupTable conditions %wdb% _full_worlddb %loadworldDB%
call :BackupTable creature %wdb% _full_worlddb %loadworldDB%
call :BackupTable creature_addon %wdb% _full_worlddb %loadworldDB%
call :BackupTable creature_ai_scripts %wdb% _full_worlddb %loadworldDB%
call :BackupTable creature_ai_summons %wdb% _full_worlddb %loadworldDB%
call :BackupTable creature_ai_texts %wdb% _full_worlddb %loadworldDB%
call :BackupTable creature_battleground %wdb% _full_worlddb %loadworldDB%
call :BackupTable creature_equip_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable creature_linking %wdb% _full_worlddb %loadworldDB%
call :BackupTable creature_linking_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable creature_loot_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable creature_model_info %wdb% _full_worlddb %loadworldDB%
call :BackupTable creature_model_race %wdb% _full_worlddb %loadworldDB%
call :BackupTable creature_movement %wdb% _full_worlddb %loadworldDB%
call :BackupTable creature_movement_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable creature_onkill_reputation %wdb% _full_worlddb %loadworldDB%
call :BackupTable creature_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable creature_template_addon %wdb% _full_worlddb %loadworldDB%
call :BackupTable creature_template_classlevelstats %wdb% _full_worlddb %loadworldDB%
call :BackupTable creature_template_spells %wdb% _full_worlddb %loadworldDB%
call :BackupTable custom_texts %wdb% _full_worlddb %loadworldDB%
call :BackupTable db_script_string %wdb% _full_worlddb %loadworldDB%
call :BackupTable db_scripts %wdb% _full_worlddb %loadworldDB%
call :BackupTable db_version %wdb% _full_worlddb %loadworldDB%
call :BackupTable disables %wdb% _full_worlddb %loadworldDB%
call :BackupTable disenchant_loot_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable dungeonfinder_item_rewards %wdb% _full_worlddb %loadworldDB%
call :BackupTable dungeonfinder_requirements %wdb% _full_worlddb %loadworldDB%
call :BackupTable dungeonfinder_rewards %wdb% _full_worlddb %loadworldDB%
call :BackupTable exploration_basexp %wdb% _full_worlddb %loadworldDB%
call :BackupTable fishing_loot_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable game_event %wdb% _full_worlddb %loadworldDB%
call :BackupTable game_event_creature %wdb% _full_worlddb %loadworldDB%
call :BackupTable game_event_creature_data %wdb% _full_worlddb %loadworldDB%
call :BackupTable game_event_gameobject %wdb% _full_worlddb %loadworldDB%
call :BackupTable game_event_mail %wdb% _full_worlddb %loadworldDB%
call :BackupTable game_event_quest %wdb% _full_worlddb %loadworldDB%
call :BackupTable game_graveyard_zone %wdb% _full_worlddb %loadworldDB%
call :BackupTable game_tele %wdb% _full_worlddb %loadworldDB%
call :BackupTable game_weather %wdb% _full_worlddb %loadworldDB%
call :BackupTable gameobject %wdb% _full_worlddb %loadworldDB%
call :BackupTable gameobject_addon %wdb% _full_worlddb %loadworldDB%
call :BackupTable gameobject_battleground %wdb% _full_worlddb %loadworldDB%
call :BackupTable gameobject_loot_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable gameobject_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable gossip_menu %wdb% _full_worlddb %loadworldDB%
call :BackupTable gossip_menu_option %wdb% _full_worlddb %loadworldDB%
call :BackupTable gossip_texts %wdb% _full_worlddb %loadworldDB%
call :BackupTable hotfix_data %wdb% _full_worlddb %loadworldDB%
call :BackupTable instance_encounters %wdb% _full_worlddb %loadworldDB%
call :BackupTable instance_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable item_convert %wdb% _full_worlddb %loadworldDB%
call :BackupTable item_enchantment_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable item_expire_convert %wdb% _full_worlddb %loadworldDB%
call :BackupTable item_loot_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable item_required_target %wdb% _full_worlddb %loadworldDB%
call :BackupTable item_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable locales_achievement_reward %wdb% _full_worlddb %loadworldDB%
call :BackupTable locales_command %wdb% _full_worlddb %loadworldDB%
call :BackupTable locales_creature %wdb% _full_worlddb %loadworldDB%
call :BackupTable locales_gameobject %wdb% _full_worlddb %loadworldDB%
call :BackupTable locales_gossip_menu_option %wdb% _full_worlddb %loadworldDB%
call :BackupTable locales_item %wdb% _full_worlddb %loadworldDB%
call :BackupTable locales_npc_text %wdb% _full_worlddb %loadworldDB%
call :BackupTable locales_page_text %wdb% _full_worlddb %loadworldDB%
call :BackupTable locales_points_of_interest %wdb% _full_worlddb %loadworldDB%
call :BackupTable locales_quest %wdb% _full_worlddb %loadworldDB%
call :BackupTable mail_level_reward %wdb% _full_worlddb %loadworldDB%
call :BackupTable mail_loot_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable mangos_string %wdb% _full_worlddb %loadworldDB%
call :BackupTable milling_loot_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable npc_gossip %wdb% _full_worlddb %loadworldDB%
call :BackupTable npc_spellclick_spells %wdb% _full_worlddb %loadworldDB%
call :BackupTable npc_text %wdb% _full_worlddb %loadworldDB%
call :BackupTable npc_trainer %wdb% _full_worlddb %loadworldDB%
call :BackupTable npc_trainer_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable npc_vendor %wdb% _full_worlddb %loadworldDB%
call :BackupTable npc_vendor_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable page_text %wdb% _full_worlddb %loadworldDB%
call :BackupTable pet_levelstats %wdb% _full_worlddb %loadworldDB%
call :BackupTable pet_name_generation %wdb% _full_worlddb %loadworldDB%
call :BackupTable phase_definitions %wdb% _full_worlddb %loadworldDB%
call :BackupTable pickpocketing_loot_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable player_levelstats %wdb% _full_worlddb %loadworldDB%
call :BackupTable player_xp_for_level %wdb% _full_worlddb %loadworldDB%
call :BackupTable playercreateinfo %wdb% _full_worlddb %loadworldDB%
call :BackupTable playercreateinfo_action %wdb% _full_worlddb %loadworldDB%
call :BackupTable playercreateinfo_item %wdb% _full_worlddb %loadworldDB%
call :BackupTable playercreateinfo_spell %wdb% _full_worlddb %loadworldDB%
call :BackupTable points_of_interest %wdb% _full_worlddb %loadworldDB%
call :BackupTable pool_creature %wdb% _full_worlddb %loadworldDB%
call :BackupTable pool_creature_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable pool_gameobject %wdb% _full_worlddb %loadworldDB%
call :BackupTable pool_gameobject_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable pool_pool %wdb% _full_worlddb %loadworldDB%
call :BackupTable pool_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable prospecting_loot_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable quest_phase_maps %wdb% _full_worlddb %loadworldDB%
call :BackupTable quest_poi %wdb% _full_worlddb %loadworldDB%
call :BackupTable quest_poi_points %wdb% _full_worlddb %loadworldDB%
call :BackupTable quest_relations %wdb% _full_worlddb %loadworldDB%
call :BackupTable quest_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable reference_loot_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable reputation_reward_rate %wdb% _full_worlddb %loadworldDB%
call :BackupTable reputation_spillover_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable reserved_name %wdb% _full_worlddb %loadworldDB%
call :BackupTable script_binding %wdb% _full_worlddb %loadworldDB%
call :BackupTable script_texts %wdb% _full_worlddb %loadworldDB%
call :BackupTable script_waypoint %wdb% _full_worlddb %loadworldDB%
call :BackupTable skill_discovery_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable skill_extra_item_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable skill_fishing_base_level %wdb% _full_worlddb %loadworldDB%
call :BackupTable skinning_loot_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable spell_area %wdb% _full_worlddb %loadworldDB%
call :BackupTable spell_bonus_data %wdb% _full_worlddb %loadworldDB%
call :BackupTable spell_chain %wdb% _full_worlddb %loadworldDB%
call :BackupTable spell_elixir %wdb% _full_worlddb %loadworldDB%
call :BackupTable spell_learn_spell %wdb% _full_worlddb %loadworldDB%
call :BackupTable spell_loot_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable spell_pet_auras %wdb% _full_worlddb %loadworldDB%
call :BackupTable spell_phase %wdb% _full_worlddb %loadworldDB%
call :BackupTable spell_proc_event %wdb% _full_worlddb %loadworldDB%
call :BackupTable spell_proc_item_enchant %wdb% _full_worlddb %loadworldDB%
call :BackupTable spell_script_target %wdb% _full_worlddb %loadworldDB%
call :BackupTable spell_target_position %wdb% _full_worlddb %loadworldDB%
call :BackupTable spell_template %wdb% _full_worlddb %loadworldDB%
call :BackupTable spell_threat %wdb% _full_worlddb %loadworldDB%
call :BackupTable transports %wdb% _full_worlddb %loadworldDB%
call :BackupTable vehicle_accessory %wdb% _full_worlddb %loadworldDB%
call :BackupTable warden %wdb% _full_worlddb %loadworldDB%

goto CharDB:

:CharDB1
REM ############ CHAR DB DUMP STUFF HERE ###########
if exist _full_chardb goto CharDBSkip1:
md _full_chardb
:CharDBSkip1
echo %colWhiteBold%_______________________________________________________________________________
echo %colWhiteDarkYellow%^|                                                                             ^|
echo ^|                                                                             ^|
echo ^| Dumping Character Database                                                  ^|
echo ^|                                                                             ^|
echo ^|_____________________________________________________________________________^|%colReset%
echo.

echo Dumping.... account_data
call :BackupTable account_data %cdb% _full_chardb %loadcharDB%

call :BackupTable ahbot_category %cdb% _full_chardb %loadcharDB%
call :BackupTable ahbot_history %cdb% _full_chardb %loadcharDB%
call :BackupTable ahbot_price %cdb% _full_chardb %loadcharDB%
call :BackupTable ai_playerbot_names %cdb% _full_chardb %loadcharDB%
call :BackupTable ai_playerbot_random_bots %cdb% _full_chardb %loadcharDB%
call :BackupTable arena_team %cdb% _full_chardb %loadcharDB%
call :BackupTable arena_team_member %cdb% _full_chardb %loadcharDB%
call :BackupTable arena_team_stats %cdb% _full_chardb %loadcharDB%
call :BackupTable auction %cdb% _full_chardb %loadcharDB%
call :BackupTable bugreport %cdb% _full_chardb %loadcharDB%
call :BackupTable calendar_events %cdb% _full_chardb %loadcharDB%
call :BackupTable calendar_invites %cdb% _full_chardb %loadcharDB%

call :BackupTable character_account_data %cdb% _full_chardb %loadcharDB%
call :BackupTable character_achievement %cdb% _full_chardb %loadcharDB%
call :BackupTable character_achievement_progress %cdb% _full_chardb %loadcharDB%
call :BackupTable character_action %cdb% _full_chardb %loadcharDB%
call :BackupTable character_aura %cdb% _full_chardb %loadcharDB%
call :BackupTable character_battleground_data %cdb% _full_chardb %loadcharDB%
call :BackupTable character_currencies %cdb% _full_chardb %loadcharDB%
call :BackupTable character_declinedname %cdb% _full_chardb %loadcharDB%
call :BackupTable character_equipmentsets %cdb% _full_chardb %loadcharDB%
call :BackupTable character_gifts %cdb% _full_chardb %loadcharDB%
call :BackupTable character_glyphs %cdb% _full_chardb %loadcharDB%
call :BackupTable character_homebind %cdb% _full_chardb %loadcharDB%
call :BackupTable character_instance %cdb% _full_chardb %loadcharDB%
call :BackupTable character_inventory %cdb% _full_chardb %loadcharDB%
call :BackupTable character_pet %cdb% _full_chardb %loadcharDB%
call :BackupTable character_pet_declinedname %cdb% _full_chardb %loadcharDB%
call :BackupTable character_queststatus %cdb% _full_chardb %loadcharDB%
call :BackupTable character_queststatus_daily %cdb% _full_chardb %loadcharDB%
call :BackupTable character_queststatus_monthly %cdb% _full_chardb %loadcharDB%
call :BackupTable character_queststatus_weekly %cdb% _full_chardb %loadcharDB%
call :BackupTable character_reputation %cdb% _full_chardb %loadcharDB%
call :BackupTable character_skills %cdb% _full_chardb %loadcharDB%
call :BackupTable character_social %cdb% _full_chardb %loadcharDB%

call :BackupTable character_spell %cdb% _full_chardb %loadcharDB%
call :BackupTable character_spell_cooldown %cdb% _full_chardb %loadcharDB%
call :BackupTable character_stats %cdb% _full_chardb %loadcharDB%
call :BackupTable character_talent %cdb% _full_chardb %loadcharDB%
call :BackupTable character_ticket %cdb% _full_chardb %loadcharDB%
call :BackupTable character_tutorial %cdb% _full_chardb %loadcharDB%
call :BackupTable character_whispers %cdb% _full_chardb %loadcharDB%
call :BackupTable characters %cdb% _full_chardb %loadcharDB%
call :BackupTable corpse %cdb% _full_chardb %loadcharDB%
call :BackupTable creature_respawn %cdb% _full_chardb %loadcharDB%
call :BackupTable db_version %cdb% _full_chardb %loadcharDB%
call :BackupTable game_event_status %cdb% _full_chardb %loadcharDB%
call :BackupTable gameobject_respawn %cdb% _full_chardb %loadcharDB%
call :BackupTable group_instance %cdb% _full_chardb %loadcharDB%
call :BackupTable group_member %cdb% _full_chardb %loadcharDB%
call :BackupTable groups %cdb% _full_chardb %loadcharDB%
call :BackupTable guild %cdb% _full_chardb %loadcharDB%
call :BackupTable guild_bank_eventlog %cdb% _full_chardb %loadcharDB%
call :BackupTable guild_bank_item %cdb% _full_chardb %loadcharDB%
call :BackupTable guild_bank_right %cdb% _full_chardb %loadcharDB%
call :BackupTable guild_bank_tab %cdb% _full_chardb %loadcharDB%
call :BackupTable guild_eventlog %cdb% _full_chardb %loadcharDB%

call :BackupTable guild_member %cdb% _full_chardb %loadcharDB%
call :BackupTable guild_rank %cdb% _full_chardb %loadcharDB%
call :BackupTable instance %cdb% _full_chardb %loadcharDB%
call :BackupTable instance_reset %cdb% _full_chardb %loadcharDB%
call :BackupTable item_instance %cdb% _full_chardb %loadcharDB%
call :BackupTable item_loot %cdb% _full_chardb %loadcharDB%
call :BackupTable mail %cdb% _full_chardb %loadcharDB%
call :BackupTable mail_items %cdb% _full_chardb %loadcharDB%
call :BackupTable pet_aura %cdb% _full_chardb %loadcharDB%
call :BackupTable pet_spell %cdb% _full_chardb %loadcharDB%
call :BackupTable pet_spell_cooldown %cdb% _full_chardb %loadcharDB%
call :BackupTable petition %cdb% _full_chardb %loadcharDB%
call :BackupTable petition_sign %cdb% _full_chardb %loadcharDB%
call :BackupTable pvpstats_players %cdb% _full_chardb %loadcharDB%
call :BackupTable quest_tracker %cdb% _full_chardb %loadcharDB%
call :BackupTable saved_variables %cdb% _full_chardb %loadcharDB%
call :BackupTable warden_action %cdb% _full_chardb %loadcharDB%
call :BackupTable world %cdb% _full_chardb %loadcharDB%
goto RealmDB:

:RealmDB1
REM ############ REALM DB DUMP STUFF HERE ###########
if exist _full_realmdb goto RealmDBSkip1:
md _full_realmdb
:RealmDBSkip1
echo %colWhiteBold%_______________________________________________________________________________
echo %colWhiteDarkYellow%^|                                                                             ^|
echo ^|                                                                             ^|
echo ^| Dumping Realm Database                                                      ^|
echo ^|                                                                             ^|
echo ^|_____________________________________________________________________________^|%colReset%
echo.

echo Dumping.... account
call :BackupTable account %rdb% _full_realmdb %loadrealmDB%

call :BackupTable account_banned %rdb% _full_realmdb %loadrealmDB%
call :BackupTable db_version %rdb% _full_realmdb %loadrealmDB%
call :BackupTable ip_banned %rdb% _full_realmdb %loadrealmDB%
call :BackupTable realmcharacters %rdb% _full_realmdb %loadrealmDB%
call :BackupTable realmlist %rdb% _full_realmdb %loadrealmDB%
call :BackupTable uptime %rdb% _full_realmdb %loadrealmDB%
call :BackupTable warden_log %rdb% _full_realmdb %loadrealmDB%

goto done:



:patherror
echo.
echo _______________________________________________________________________________
echo %colWhiteDarkRed%^|                                                                             ^|
echo ^|                                                                             ^|
echo ^|                           Cannot find required files.                       ^|
echo ^|                                                                             ^|
echo %colWhiteBold%^|_____________________________________________________________________________^|
echo.
goto finish:

:error
echo.
echo _______________________________________________________________________________
echo %colWhiteDarkRed%^|                                                                             ^|
echo ^|                                                                             ^|
echo ^|                          Database Backup Process Failed                     ^|
echo ^|                                                                             ^|
echo %colWhiteBold%^|_____________________________________________________________________________^|
echo.
goto finish:

:done
color 08
echo %colWhiteBold%_______________________________________________________________________________%colReset%
echo %colWhiteDarkBlue%^|    __  __      _  _  ___  ___  ___                                          ^|%colReset%
echo %colWhiteDarkBlue%^|   ^|  \/  ^|__ _^| \^| ^|/ __^|/ _ \/ __^|                                         ^|%colReset%
echo %colWhiteDarkBlue%^|   ^| ^|\/^| / _` ^| .` ^| (_ ^| (_) \__ \                                         ^|%colReset%
echo %colWhiteDarkBlue%^|   ^|_^|  ^|_\__,_^|_^|\_^|\___^|\___/^|___/ %colYellowBold%Database Backup v2.0                %colWhiteBold%    ^|%colReset%
echo %colWhiteDarkBlue%^|_____________________________________________________________________________^|%colReset%
echo %colWhiteLightGreen%^|                                                                             ^|%colReset%
echo %colWhiteLightGreen%^|                                                                             ^|%colReset%
echo %colWhiteLightGreen%^|                               Database Backup Complete                      ^|%colReset%
echo %colWhiteLightGreen%^|                                                                             ^|%colReset%
echo %colWhiteLightGreen%^|_____________________________________________________________________________^|%colReset%
echo.
echo Done :)
echo.
:finish
pause