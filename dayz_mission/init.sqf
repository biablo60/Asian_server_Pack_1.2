/*	
  READ!!!!!!!!!!!!!!!!!!!!                                           READ!!!!!!!!!!!!!!!!!!!!                                                         READ!!!!!!!!!!!!!!!!!!!!
	Asian Server Pack By B6 Media (Asian Kid)
	I hope you enjoy the pack ;)
	Any bugs or something not working contact me on the forums or email
	Email = biablo60@gmail.com
	
	Most of the scripts can be found in the custom folder
	
	Only modify in the 
	//////////////
	Stuff
	//////////////
	
	To turn off any script place // in front of it 
	Example
	//[] execVM "custom\effects.sqf";
	dayzPlayerLogin2
	To Change the loading screen and credits, place your new picture in custom (needs to be 2048x1024)
	
	To keep it lag free 
	-have the server restart on 3 hours
	-Don't change my Epoch setting
	spawnShoremode = 0; // Default = 1 (on shore)
    spawnArea= 1500; // Default = 1500
    MaxHeliCrashes= 5; // Default = 5
    MaxVehicleLimit = 250; // Default = 50
    MaxDynamicDebris = 100; // Default = 100
    dayz_MapArea = 13000; // Default = 10000
    dayz_maxLocalZombies = 30; // Default = 30 
    dayz_maxAnimals = 10;
	
*/
startLoadingScreen ["","RscDisplayLoadCustom"];
cutText ["","BLACK OUT"];
enableSaving [false, false];

///////////////////////////////////////////////////////////////////////////////////////////
//REALLY IMPORTANT VALUES
dayZ_instance =	000;					//The instance
///////////////////////////////////////////////////////////////////////////////////////////
//CHANGE ME TO MAKE IT WORK WITH YOUR DATA BASE!!!!!!
///////////////////////////////////////////////////////////////////////////////////////////
dayzHiveRequest = [];
initialized = false;
dayz_previousID = 0;
///////////////////////////////////////////////////////////////////////////////////////////
//disable greeting menu 
player setVariable ["BIS_noCoreConversations", true];
//disable radio messages to be heard and shown in the left lower corner of the screen
enableRadio true;
DZE_DeathMsgTitleText = true;
///////////////////////////////////////////////////////////////////////////////////////////
//Above is the death messages
//Change me to true if you want death messages (enableRadio true;)
//I don't know if this is working
///////////////////////////////////////////////////////////////////////////////////////////
// DayZ Epoch configure
spawnShoremode = 0; // Default = 1 (on shore)
spawnArea= 1500; // Default = 1500
MaxHeliCrashes= 5; // Default = 5
MaxVehicleLimit = 250; // Default = 50
MaxDynamicDebris = 100; // Default = 100
dayz_MapArea = 13000; // Default = 10000
dayz_maxLocalZombies = 30; // Default = 30 
dayz_maxAnimals = 10; //Default is 8
///////////////////////////////////////////////////////////////////////////////////////////
dayz_maxZeds = 300;
dayz_sellDistance = 30;
dayz_zedsAttackVehicles = false;        //Zeds can attack through cars (no/off)
DZE_TRADER_SPAWNMODE = false;          //parachute cars in when bought
dayz_tameDogs = true;                 //dogs
DynamicVehicleFuelHigh = 75;
DynamicVehicleDamageLow = 25;
OldHeliCrash = false;                
dayz_paraSpawn = false;             //parachute spawn
///////////////////////////////////////////////////////////////////////////////////////////
//Above is the Epoch settings
///////////////////////////////////////////////////////////////////////////////////////////
// Load out configure
DefaultMagazines = ["ItemBandage","ItemBandage","ItemMorphine","ItemPainkiller"];
DefaultWeapons = ["ItemMap","ItemFlashlight","ItemHatchet"];
DefaultBackpack = "US_Assault_Pack_EP1";
DefaultBackpackWeapon = "ItemGoldBar";
///////////////////////////////////////////////////////////////////////////////////////////
//Above is the custom spawn load out
//you may change it to what ever you want
///////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////
EpochEvents = [["any","any","any","any",0,"hello_word"],["any","any","any","any",30,"crash_spawner"],["any","any","any","any",0,"crash_spawner"]];
///////////////////////////////////////////////////////////////////////////////////////////
//This will fire the hello_word.sqf and crash_spawner.sqf found inside the servers modules folder at the top of the hour and crash_spawner.sqf again on 30.
///////////////////////////////////////////////////////////////////////////////////////////

//Load in compiled functions
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\variables.sqf";				//Initilize the Variables (IMPORTANT: Must happen very early)
progressLoadingScreen 0.1;
call compile preprocessFileLineNumbers "dayz_code\init\publicEH.sqf";				//Initilize the publicVariable event handlers
progressLoadingScreen 0.2;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\setup_functions_med.sqf";	//Functions used by CLIENT for medical
progressLoadingScreen 0.4;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf";				//Compile regular functions
progressLoadingScreen 0.5;
call compile preprocessFileLineNumbers "server_traders.sqf";				//Compile trader configs
call compile preprocessFileLineNumbers "dayz_code\init\variables.sqf"; //Initializes custom variables
call compile preprocessFileLineNumbers "dayz_code\init\compiles.sqf"; //Compile custom compiles
call compile preprocessFileLineNumbers "dayz_code\init\settings.sqf"; //Initialize custom clientside settings
progressLoadingScreen 1.0;

"filmic" setToneMappingParams [0.153, 0.357, 0.231, 0.1573, 0.011, 3.750, 6, 4]; setToneMapping "Filmic";

/* BIS_Effects_* fixes from Dwarden */
BIS_Effects_EH_Killed = compile preprocessFileLineNumbers "\z\addons\dayz_code\system\BIS_Effects\killed.sqf";
BIS_Effects_AirDestruction = compile preprocessFileLineNumbers "\z\addons\dayz_code\system\BIS_Effects\AirDestruction.sqf";
BIS_Effects_AirDestructionStage2 = compile preprocessFileLineNumbers "\z\addons\dayz_code\system\BIS_Effects\AirDestructionStage2.sqf";

BIS_Effects_globalEvent = {
	BIS_effects_gepv = _this;
	publicVariable "BIS_effects_gepv";
	_this call BIS_Effects_startEvent;
};

BIS_Effects_startEvent = {
	switch (_this select 0) do {
		case "AirDestruction": {
				[_this select 1] spawn BIS_Effects_AirDestruction;
		};
		case "AirDestructionStage2": {
				[_this select 1, _this select 2, _this select 3] spawn BIS_Effects_AirDestructionStage2;
		};
		case "Burn": {
				[_this select 1, _this select 2, _this select 3, false, true] spawn BIS_Effects_Burn;
		};
	};
};

"BIS_effects_gepv" addPublicVariableEventHandler {
	(_this select 1) call BIS_Effects_startEvent;
};

if ((!isServer) && (isNull player) ) then
{
waitUntil {!isNull player};
waitUntil {time > 3};
};

if ((!isServer) && (player != player)) then
{
  waitUntil {player == player}; 
  waitUntil {time > 3};
};

if (isServer) then {
	call compile preprocessFileLineNumbers "dynamic_vehicle.sqf";				//Compile vehicle configs
	// Add trader citys
	_nil = [] execVM "mission.sqf";
	_serverMonitor = 	[] execVM "\z\addons\dayz_code\system\server_monitor.sqf";
};

if (!isDedicated) then {
	//Conduct map operations
	0 fadeSound 0;
	waitUntil {!isNil "dayz_loadScreenMsg"};
	dayz_loadScreenMsg = (localize "STR_AUTHENTICATING");
	
	_id = player addEventHandler ["Respawn", {_id = [] spawn player_death; _nul = [] execVM "addin\plrInit.sqf";}];
    //_id = player addEventHandler ["Respawn", {_id = [] spawn player_death;}];
    _playerMonitor =[] execVM "\z\addons\dayz_code\system\player_monitor.sqf";
    _void = [] execVM "R3F_Realism\R3F_Realism_Init.sqf";
	_void = [] execVM "traders\init.sqf";
};
///////////////////////////////////////////////////////////////////////////////////////////
//Add-ons/Scripts Below
///////////////////////////////////////////////////////////////////////////////////////////
if (!isDedicated) then {
//Lights
[] execVM "custom\tower_lights.sqf";             //Tower lights
[] execVM "custom\change_streetlights.sqf";     //House lights
//colour corrections
[] execVM "custom\effects.sqf";                 //colour corrections
};
///////////////////////////////////////////////////////////////////////////////////////////
//Above is the lights and colour corrections
///////////////////////////////////////////////////////////////////////////////////////////
//scripts
[] execVM "custom\loginCamera.sqf";                        //login camera   go in the sqf and change the text to your liking
[] execVM "custom\custom_monitor.sqf";                    //debug
[] execVM "R3F_ARTY_AND_LOG\init.sqf";                   //Tow/lift
[] execVM "custom\kh_actions.sqf";                      //Auto refuel
[] execVM "BTK\Cargo Drop\Start.sqf";                  //cargo drop
[] execVM "custom\safezone.sqf";                      //safe zones
///////////////////////////////////////////////////////////////////////////////////////////
//Above is the Auto refuel, debug monitor, cargo drop, safe zones and tow/lift
///////////////////////////////////////////////////////////////////////////////////////////
//Fallen City
[] execVM "sectorfng\marker.sqf";
[] execVM "sectorfng\crates.sqf";
[] execVM "sectorfng\sectorfng.sqf";
///////////////////////////////////////////////////////////////////////////////////////////
//Above is the Fallen city made by paddy1223
///////////////////////////////////////////////////////////////////////////////////////////
//Sarge AI
call compile preprocessFileLineNumbers "addons\UPSMON\scripts\Init_UPSMON.sqf";
call compile preprocessfile "addons\SHK_pos\shk_pos_init.sqf";
[] execVM "addons\SARGE\SAR_AI_init.sqf";
///////////////////////////////////////////////////////////////////////////////////////////
//Above is Sarge AI must be on for the dayz mission system to work
//I nodded the default AI to work with Fallen city
//There is a default functions you can use or keep the one I have
//The nodded one doesn't spawn AI in towns
///////////////////////////////////////////////////////////////////////////////////////////
[] ExecVM "buildings\buildings.sqf";
[] ExecVM "buildings\villages.sqf";
///////////////////////////////////////////////////////////////////////////////////////////
//The map add-ons above were made by Bungle
///////////////////////////////////////////////////////////////////////////////////////////
//Map add-ons
[] execVM "buildings\excbridge.sqf";
[] ExecVM "buildings\fightyard.sqf";
[] ExecVM "buildings\devilscastle.sqf";
[] ExecVM "buildings\skal.sqf";
[] ExecVM "buildings\devfish_camptents.sqf";
///////////////////////////////////////////////////////////////////////////////////////////
//Above is the custom map you can remove any
///////////////////////////////////////////////////////////////////////////////////////////
