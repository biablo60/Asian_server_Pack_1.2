waituntil {!isnil "bis_fnc_init"};

BIS_MPF_remoteExecutionServer = {
	if ((_this select 1) select 2 == "JIPrequest") then {
		[nil,(_this select 1) select 0,"loc",rJIPEXEC,[any,any,"per","execVM","ca\Modules\Functions\init.sqf"]] call RE;
	};
};

BIS_Effects_Burn =			{};
server_playerLogin =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerLogin.sqf";
server_playerSetup =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerSetup.sqf";
server_onPlayerDisconnect = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_onPlayerDisconnect.sqf";
server_updateObject =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_updateObject.sqf";
server_playerDied =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerDied.sqf";
server_publishObj = 		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_publishObject.sqf";	//Creates the object in DB
server_publishObj2 = 		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_publishObject2.sqf";	//Creates the Base Building object in DB
server_deleteObj =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_deleteObj.sqf"; 	//Removes the object from the DB
server_deleteObj2 =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_deleteObj2.sqf"; 	//Removes the object from the DB
server_publishVeh = 		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_publishVehicle.sqf"; // Custom to add vehicles
server_publishVeh2 = 		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_publishVehicle2.sqf"; // Custom to add vehicles
server_tradeObj = 			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_tradeObject.sqf";
server_traders = 			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_traders.sqf";
server_playerSync =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerSync.sqf";
zombie_findOwner =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\zombie_findOwner.sqf";
server_updateNearbyObjects =	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_updateNearbyObjects.sqf";
server_spawnCrashSite  =    compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_spawnCrashSite.sqf";
server_spawnC130CrashSite = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_spawnC130CrashSite.sqf";
server_spawnAN2 = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_spawnAN2.sqf"; 
server_carepackagedrop = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_carepackagedrop.sqf";
server_handleZedSpawn =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_handleZedSpawn.sqf";
server_spawnEvents =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_spawnEvent.sqf";
server_botSetup =        compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_botSetup.sqf";
server_botSync =        compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_botSync.sqf";
server_botDamage =            compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_botDamage.sqf";
server_botDied =        compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_botDied.sqf";
//Get instance name (e.g. dayz_1.chernarus)
fnc_instanceName = {
    "dayz_" + str(dayz_instance) + "." + worldName
};
 
if(isNil "botPlayers") then {
    botPlayers = []
};
fnc_plyrHit   = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\fnc_plyrHit.sqf";
fnc_hTime = compile preprocessFile "\z\addons\dayz_server\Missions\misc\fnc_hTime.sqf"; //Random integer selector for mission wait time
server_deaths = 			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerDeaths.sqf";


vehicle_handleInteract = {
	private["_object"];
	_object = _this select 0;
	needUpdate_objects = needUpdate_objects - [_object];
	[_object, "all"] call server_updateObject;
};

vehicle_handleServerKilled = {
	private["_unit","_killer"];
	_unit = _this select 0;
	_killer = _this select 1;
		
	[_unit, "killed"] call server_updateObject;
	
	_unit removeAllMPEventHandlers "MPKilled";
	_unit removeAllEventHandlers "Killed";
	_unit removeAllEventHandlers "HandleDamage";
	_unit removeAllEventHandlers "GetIn";
	_unit removeAllEventHandlers "GetOut";
};

object_handleServerKilled = {
	private["_unit","_objectID","_objectUID"];
	_unit = _this select 0;
	
	_objectID =	 _unit getVariable ["ObjectID","0"];
	_objectUID = _unit getVariable ["ObjectUID","0"];
		
	[_objectID,_objectUID] call server_deleteObj;
	
	_unit removeAllMPEventHandlers "MPKilled";
	_unit removeAllEventHandlers "Killed";
	_unit removeAllEventHandlers "HandleDamage";
	_unit removeAllEventHandlers "GetIn";
	_unit removeAllEventHandlers "GetOut";
};

check_publishobject = {
	private["_allowed","_object","_playername"];

	_object = _this select 0;
	_playername = _this select 1;
	
	_allowed = false;
       
	diag_log format ["DEBUG: Checking if Object: %1 is allowed published by %2", _object, _playername];

    if ((typeOf _object) in dayz_allowedObjects || (typeOf _object) in allbuildables_class) then {
			diag_log format ["DEBUG: Object: %1 published by %2 is Safe",_object, _playername];
			_allowed = true;
	};
    _allowed
};

//event Handlers
eh_localCleanup =			{
	private ["_object"];
	_object = _this select 0;
	_object addEventHandler ["local", {
		if(_this select 1) then {
			private["_type","_unit"];
			_unit = _this select 0;
			_type = typeOf _unit;
			 _myGroupUnit = group _unit;
 			_unit removeAllMPEventHandlers "mpkilled";
 			_unit removeAllMPEventHandlers "mphit";
 			_unit removeAllMPEventHandlers "mprespawn";
 			_unit removeAllEventHandlers "FiredNear";
			_unit removeAllEventHandlers "HandleDamage";
			_unit removeAllEventHandlers "Killed";
			_unit removeAllEventHandlers "Fired";
			_unit removeAllEventHandlers "GetOut";
			_unit removeAllEventHandlers "GetIn";
			_unit removeAllEventHandlers "Local";
			clearVehicleInit _unit;
			deleteVehicle _unit;
			deleteGroup _myGroupUnit;
			_unit = nil;
			diag_log ("CLEANUP: DELETED A " + str(_type) );
		};
	}];
};

server_hiveWrite = {
	private["_data"];
	//diag_log ("ATTEMPT WRITE: " + _this);
	_data = "HiveExt" callExtension _this;
	//diag_log ("WRITE: " +str(_data));
};

server_hiveReadWrite = {
	private["_key","_resultArray","_data"];
	_key = _this;
	//diag_log ("ATTEMPT READ/WRITE: " + _key);
	_data = "HiveExt" callExtension _key;
	//diag_log ("READ/WRITE: " +str(_data));
	_resultArray = call compile format ["%1",_data];
	_resultArray
};

server_characterSync = {
	private ["_characterID","_playerPos","_playerGear","_playerBackp","_medical","_currentState","_currentModel","_key"];
	_characterID = 	_this select 0;	
	_playerPos =	_this select 1;
	_playerGear =	_this select 2;
	_playerBackp =	_this select 3;
	_medical = 		_this select 4;
	_currentState =	_this select 5;
	_currentModel = _this select 6;
	
	_key = format["CHILD:201:%1:%2:%3:%4:%5:%6:%7:%8:%9:%10:%11:%12:%13:%14:%15:%16:",_characterID,_playerPos,_playerGear,_playerBackp,_medical,false,false,0,0,0,0,_currentState,0,0,_currentModel,0];
	//diag_log ("HIVE: WRITE: "+ str(_key) + " / " + _characterID);
	_key call server_hiveWrite;
};

//onPlayerConnected 		"[_uid,_name] spawn server_onPlayerConnect;";
onPlayerDisconnected 		"[_uid,_name] call server_onPlayerDisconnect;";

// Setup globals allow overwrite from init.sqf
if(isnil "dayz_MapArea") then {
	dayz_MapArea = 10000;
};
if(isnil "DynamicVehicleArea") then {
	DynamicVehicleArea = dayz_MapArea / 2;
};

// Get all buildings and roads only once TODO: set variables to nil after done if nessicary 
MarkerPosition = getMarkerPos "center";
RoadList = MarkerPosition nearRoads DynamicVehicleArea;
BuildingList = MarkerPosition nearObjects ["House",DynamicVehicleArea];

spawn_vehicles = {
	private ["_weights","_isOverLimit","_isAbort","_counter","_index","_vehicle","_velimit","_qty","_isAir","_isShip","_position","_dir","_istoomany","_veh","_objPosition","_marker","_iClass","_itemTypes","_cntWeights","_itemType","_num","_allCfgLoots"];
	
	if (isDedicated) then {
		waituntil {!isnil "fnc_buildWeightedArray"};
		
		_isOverLimit = true;
		_isAbort = false;
		_counter = 0;
		while {_isOverLimit} do {

			waitUntil{!isNil "BIS_fnc_selectRandom"};
			_index = AllowedVehiclesList call BIS_fnc_selectRandom;

			_vehicle = _index select 0;
			_velimit = _index select 1;

			_qty = {_x == _vehicle} count serverVehicleCounter;

			// If under limit allow to proceed
			if(_qty <= _velimit) then {
				_isOverLimit = false;
			};

			// counter to stop after 5 attempts
			_counter = _counter + 1;

			if(_counter >= 5) then {
				_isOverLimit = false;
				_isAbort = true;
			};
		};

		if (_isAbort) then {
			diag_log("DEBUG: unable to find sutable vehicle to spawn");
		} else {

			// add vehicle to counter for next pass
			serverVehicleCounter set [count serverVehicleCounter,_vehicle];
		
			// Find Vehicle Type to better control spawns
			_isAir = _vehicle isKindOf "Air";
			_isShip = _vehicle isKindOf "Ship";
		
			if(_isShip || _isAir) then {
				if(_isShip) then {
					// Spawn anywhere on coast on water
					waitUntil{!isNil "BIS_fnc_selectRandom"};
					_position = [MarkerPosition,0,DynamicVehicleArea,10,1,2000,1] call BIS_fnc_findSafePos;
					//diag_log("DEBUG: spawning boat near coast " + str(_position));
				} else {
					// Spawn air anywhere that is flat
					waitUntil{!isNil "BIS_fnc_selectRandom"};
					_position = [MarkerPosition,0,DynamicVehicleArea,10,0,2000,0] call BIS_fnc_findSafePos;
					//diag_log("DEBUG: spawning air anywhere flat " + str(_position));
				};
			
			
			} else {
				// Spawn around buildings and 50% near roads
				if((random 1) > 0.5) then {
				
					waitUntil{!isNil "BIS_fnc_selectRandom"};
					_position = RoadList call BIS_fnc_selectRandom;
				
					_position = _position modelToWorld [0,0,0];
				
					waitUntil{!isNil "BIS_fnc_findSafePos"};
					_position = [_position,0,10,10,0,2000,0] call BIS_fnc_findSafePos;
				
					//diag_log("DEBUG: spawning near road " + str(_position));
				
				} else {
				
					waitUntil{!isNil "BIS_fnc_selectRandom"};
					_position = BuildingList call BIS_fnc_selectRandom;
				
					_position = _position modelToWorld [0,0,0];
				
					waitUntil{!isNil "BIS_fnc_findSafePos"};
					_position = [_position,0,40,5,0,2000,0] call BIS_fnc_findSafePos;
				
					//diag_log("DEBUG: spawning around buildings " + str(_position));
			
				};
			};
			// only proceed if two params otherwise BIS_fnc_findSafePos failed and may spawn in air
			if ((count _position) == 2) then { 
		
				_dir = round(random 180);
			
				_istoomany = _position nearObjects ["AllVehicles",50];
				if((count _istoomany) > 0) exitWith { diag_log("DEBUG: Too many vehicles at " + str(_position)); };
			
				//place vehicle 
				_veh = createVehicle [_vehicle, _position, [], 0, "CAN_COLLIDE"];
				_veh setdir _dir;
				_veh setpos _position;		
				
				if(DZEdebug) then {
					_marker = createMarker [str(_position) , _position];
					_marker setMarkerShape "ICON";
					_marker setMarkerType "DOT";
					_marker setMarkerText _vehicle;
				};	
			
				// Get position with ground
				_objPosition = getPosATL _veh;
			
				clearWeaponCargoGlobal  _veh;
				clearMagazineCargoGlobal  _veh;

				// Add 0-3 loots to vehicle using random cfgloots 
				_num = floor(random 4);
				_allCfgLoots = ["trash","civilian","food","generic","medical","military","policeman","hunter","worker","clothes","militaryclothes","specialclothes","trash"];
				
				for "_x" from 1 to _num do {
					_iClass = _allCfgLoots call BIS_fnc_selectRandom;

					_itemTypes = [] + ((getArray (configFile >> "cfgLoot" >> _iClass)) select 0);
					_index = dayz_CLBase find _iClass;
					_weights = dayz_CLChances select _index;
					_cntWeights = count _weights;
					
					_index = floor(random _cntWeights);
					_index = _weights select _index;
					_itemType = _itemTypes select _index;
					_veh addMagazineCargoGlobal [_itemType,1];
					diag_log("DEBUG: spawed loot inside vehicle " + str(_itemType));
				};

				[_veh,[_dir,_objPosition],_vehicle,true,"0"] call server_publishVeh;
			};
		};
	};
};

spawn_roadblocks = {
	private ["_position","_veh","_num","_config","_itemType","_itemChance","_weights","_index","_iArray","_istoomany","_marker","_spawnloot","_nearby","_spawnveh","_WreckList"];
	_WreckList = ["SKODAWreck","HMMWVWreck","UralWreck","datsun01Wreck","hiluxWreck","datsun02Wreck","UAZWreck","Land_Misc_Garb_Heap_EP1","Fort_Barricade_EP1","Rubbish2"];
	
	waitUntil{!isNil "BIS_fnc_selectRandom"};
	if (isDedicated) then {
	
		_position = RoadList call BIS_fnc_selectRandom;
		
		_position = _position modelToWorld [0,0,0];
		
		waitUntil{!isNil "BIS_fnc_findSafePos"};
		_position = [_position,0,10,5,0,2000,0] call BIS_fnc_findSafePos;
		
		if ((count _position) == 2) then {
			// Get position with ground
			
			_istoomany = _position nearObjects ["All",5];
		
			if((count _istoomany) > 0) exitWith { diag_log("DEBUG: Too many at " + str(_position)); };
			
			if(DZEdebug) then {
				_marker = createMarker [str(_position) , _position];
				_marker setMarkerShape "ICON";
				_marker setMarkerType "DOT";
			};
			
			waitUntil{!isNil "BIS_fnc_selectRandom"};
			_spawnveh = _WreckList call BIS_fnc_selectRandom;
			_spawnloot =  "DynamicDebris";

			if((_spawnveh == "HMMWVWreck") or (_spawnveh == "UralWreck") or (_spawnveh == "UAZWreck")) then {
				_spawnloot = "DynamicDebrisMilitary";
			};
		
			diag_log("DEBUG: Spawning a crashed " + _spawnveh + " with " + _spawnloot + " at " + str(_position));
			_veh = createVehicle [_spawnveh,_position, [], 0, "CAN_COLLIDE"];
			_veh enableSimulation false;

			// Randomize placement a bit
			_veh setDir round(random 360);
			_veh setpos _position;

			dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_veh];
			_veh setVariable ["ObjectID","1",true];

			_num = round(random 3);
			_config = 		configFile >> "CfgBuildingLoot" >> _spawnloot;
			_itemType =		[] + getArray (_config >> "itemType");
			_itemChance =	[] + getArray (_config >> "itemChance");

			waituntil {!isnil "fnc_buildWeightedArray"};
		
			_weights = [];
			_weights = 		[_itemType,_itemChance] call fnc_buildWeightedArray;
			for "_x" from 1 to _num do {
				//create loot
				_index = _weights call BIS_fnc_selectRandom;
				sleep 1;
				if (count _itemType > _index) then {
					_iArray = _itemType select _index;
					_iArray set [2,_position];
					_iArray set [3,5];
					_iArray call spawn_loot;
					_nearby = _position nearObjects ["WeaponHolder",20];
					{
						_x setVariable ["permaLoot",true];
					} forEach _nearBy;
				};
			};
		};
	
	};
	
};

if(isnil "DynamicVehicleDamageLow") then {
	DynamicVehicleDamageLow = 0;
};
if(isnil "DynamicVehicleDamageHigh") then {
	DynamicVehicleDamageHigh = 100;
};

if(isnil "DynamicVehicleFuelLow") then {
	DynamicVehicleFuelLow = 0;
};
if(isnil "DynamicVehicleFuelHigh") then {
	DynamicVehicleFuelHigh = 100;
};

// Damage generator function
generate_new_damage = {
	private ["_damage"];
    _damage = ((random(DynamicVehicleDamageHigh-DynamicVehicleDamageLow))+DynamicVehicleDamageLow) / 100;
	_damage;
};

// Damage generator fuction
generate_exp_damage = {
	private ["_damage"];
    _damage = ((random(DynamicVehicleDamageHigh-DynamicVehicleDamageLow))+DynamicVehicleDamageLow) / 100;
	
	// limit this to 85% since vehicle would blow up otherwise.
	//if(_damage >= 0.85) then {
	//	_damage = 0.85;
	//};
	_damage;
};

server_getDiff =	{
	private["_variable","_object","_vNew","_vOld","_result"];
	_variable = _this select 0;
	_object = 	_this select 1;
	_vNew = 	_object getVariable[_variable,0];
	_vOld = 	_object getVariable[(_variable + "_CHK"),_vNew];
	_result = 	0;
	if (_vNew < _vOld) then {
		//JIP issues
		_vNew = _vNew + _vOld;
		_object getVariable[(_variable + "_CHK"),_vNew];
	} else {
		_result = _vNew - _vOld;
		_object setVariable[(_variable + "_CHK"),_vNew];
	};
	_result
};

server_getDiff2 =	{
	private["_variable","_object","_vNew","_vOld","_result"];
	_variable = _this select 0;
	_object = 	_this select 1;
	_vNew = 	_object getVariable[_variable,0];
	_vOld = 	_object getVariable[(_variable + "_CHK"),_vNew];
	_result = _vNew - _vOld;
	_object setVariable[(_variable + "_CHK"),_vNew];
	_result
};

dayz_objectUID = {
	private["_position","_dir","_key","_object"];
	_object = _this;
	_position = getPosATL _object;
	_dir = direction _object;
	_key = [_dir,_position] call dayz_objectUID2;
    _key
};

dayz_objectUID2 = {
	private["_position","_dir","_key"];
	_dir = _this select 0;
	_key = "";
	_position = _this select 1;
	{
		_x = _x * 10;
		if ( _x < 0 ) then { _x = _x * -10 };
		_key = _key + str(round(_x));
	} forEach _position;
	_key = _key + str(round(_dir));
	_key
};

dayz_objectUID3 = {
	private["_position","_dir","_key"];
	_dir = _this select 0;
	_key = "";
	_position = _this select 1;
	{
		_x = _x * 10;
		if ( _x < 0 ) then { _x = _x * -10 };
		_key = _key + str(round(_x));
	} forEach _position;
	_key = _key + str(round(_dir + time));
	_key
};

dayz_recordLogin = {
	private["_key"];
	_key = format["CHILD:103:%1:%2:%3:",_this select 0,_this select 1,_this select 2];
	_key call server_hiveWrite;
};
// ### COPY START
// BASE BUILDING 1.2 Build Array
build_baseBuilding_arrays = {

// ################################### BUILD LIST ARRAY SERVER SIDE ######################################## START
/*
Build list by Daimyo for SERVER side
Add and remove recipes, Objects(classnames), requirments to build, and town restrictions + extras
This method is used because we are referencing magazines from player inventory as buildables.
Main array (_buildlist) consist of 34 arrays within. These arrays contains parameters for player_build.sqf
From left to right, each array contains 3 elements, 1st: Recipe Array, 2nd: "Classname", 3rd: Requirements array. 
Check comments below for more info on parameters
*/
private["_isDestructable","_classname","_isSimulated","_disableSims","_objectSims","_objectSim","_requirements","_isStructure","_structure","_wallType","_removable","_buildlist","_build_townsrestrict"];
// Count is 56
// Info on Parameters (Copy and Paste to add more recipes and their requirments!):
//[TankTrap, SandBags, Wires, Logs, Scrap Metal, Grenades], "Classname", [_attachCoords, _startPos, _modDir, _toolBox, _eTool, _medWait, _longWait, _inBuilding, _roadAllowed, _inTown, _removable, _isStructure, _isSimulated, _isDestructable];
_buildlist = [
[[0, 1, 0, 0, 1, 1], "Grave", 						[[0,2.5,.1],[0,2,0], 	0, 	true, true, false, false, false, false, true, true, false, true, false]],//Booby Traps --1
[[2, 0, 0, 3, 1, 0], "Concrete_Wall_EP1", 			[[0,5,1.75],[0,2,0], 	0, 	true, false, false, false, false, true, false, true, true, true, false]],//Gate Concrete Wall --2
[[1, 0, 1, 0, 1, 0], "Infostand_2_EP1",				[[0,2.5,.6],[0,2,0], 	0, 	true, false, false, false, false, false, false, true, true, false, false]],//Gate Panel w/ KeyPad --3
[[3, 3, 2, 2, 0, 0], "WarfareBDepot",				[[0,18,2], 	[0,15,0], 	90, true, true, false, false, false, false, false, true, true, true, false]],//WarfareBDepot --4
[[4, 1, 2, 2, 0, 0], "Base_WarfareBBarrier10xTall",	[[0,10,1], 	[0,10,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//Base_WarfareBBarrier10xTall --5 
[[2, 1, 2, 1, 0, 0], "WarfareBCamp",				[[0,12,1], 	[0,10,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//WarfareBCamp --6
[[2, 1, 1, 1, 0, 0], "Base_WarfareBBarrier10x", 	[[0,10,.6], [0,10,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//Base_WarfareBBarrier10x --7
[[2, 2, 0, 2, 0, 0], "Land_fortified_nest_big", 	[[0,12,1], 	[2,8,0], 	180,true, true, false, false, false, false, false, true, true, true, false]],//Land_fortified_nest_big --8
[[2, 1, 2, 2, 0, 0], "Land_Fort_Watchtower",		[[0,10,2.2],[0,8,0], 	90, true, true, false, false, false, false, false, true, true, true, false]],//Land_Fort_Watchtower --9
[[4, 1, 1, 3, 0, 0], "Land_fort_rampart_EP1", 		[[0,7,.2], 	[0,8,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//Land_fort_rampart_EP1 --10
[[2, 1, 1, 0, 0, 0], "Land_HBarrier_large", 		[[0,7,1], 	[0,4,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//Land_HBarrier_large --11
[[2, 1, 0, 1, 0, 0], "Land_fortified_nest_small",	[[0,7,1], 	[0,3,0], 	90, true, true, false, false, false, false, false, true, true, true, false]],//Land_fortified_nest_small --12
[[0, 1, 1, 0, 0, 0], "Land_BagFenceRound",			[[0,4,.5], 	[0,2,0], 	180,true, true, false, false, false, false, false, true, true, true, false]],//Land_BagFenceRound --13
[[0, 1, 0, 0, 0, 0], "Land_fort_bagfence_long", 	[[0,4,.3], 	[0,2,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//Land_fort_bagfence_long --14
[[6, 0, 0, 0, 2, 0], "Land_Misc_Cargo2E",			[[0,7,2.6], [0,5,0], 	90, true, false, false, false, false, false, false, true, true, true, false]],//Land_Misc_Cargo2E --15
[[5, 0, 0, 0, 1, 0], "Misc_Cargo1Bo_military",		[[0,7,1.3], [0,5,0], 	90, true, false, false, false, false, false, false, true, true, true, false]],//Misc_Cargo1Bo_military --16
[[3, 0, 0, 0, 1, 0], "Land_Misc_Cargo1D",			[[0,7,1.3], [0,5,0], 	90, true, false, false, false, false, false, false, true, true, true, false]],//Land_Misc_Cargo1D --17
[[1, 1, 0, 2, 1, 0], "Land_pumpa",					[[0,3,.4], 	[0,3,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//Land_pumpa --18
[[1, 0, 0, 0, 0, 0], "Land_CncBlock",				[[0,3,.4], 	[0,2,0], 	0, 	true, false, false, false, false, false, false, true, true, true, false]],//Land_CncBlock --19
[[1, 0, 1, 0, 0, 0], "Land_CncBlock_Stripes",		[[0,3,.4], 	[0,2,0], 	0, 	true, false, false, false, false, false, false, true, true, true, false]],//Land_CncBlock_Stripes --46
[[4, 0, 0, 0, 0, 0], "Hhedgehog_concrete",			[[0,5,.6], 	[0,4,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//Hhedgehog_concrete --20
[[1, 0, 0, 0, 1, 0], "Misc_cargo_cont_small_EP1",	[[0,5,1.3], [0,4,0], 	90, true, false, false, false, false, false, false, true, true, true, false]],//Misc_cargo_cont_small_EP1 --21
[[1, 0, 0, 2, 0, 0], "Land_prebehlavka",			[[0,6,.7], 	[0,3,0], 	90, true, false, false, false, false, false, false, true, true, true, false]],//Land_prebehlavka(Ramp) --22
[[2, 0, 0, 0, 0, 0], "Fence_corrugated_plate",		[[0,4,.6], 	[0,3,0], 	0,	true, false, false, false, false, false, false, true, true, true, false]],//Fence_corrugated_plate --23
[[2, 0, 1, 0, 0, 0], "ZavoraAnim", 					[[0,5,4.0], [0,5,0], 	0, 	true, false, false, false, false, true, false, true, true, true, true]],//ZavoraAnim --24
[[0, 0, 7, 0, 1, 0], "Land_tent_east", 				[[0,8,1.7], [0,6,0], 	0, 	true, false, false, false, false, false, false, true, true, true, true]],//Land_tent_east --25
[[0, 0, 6, 0, 1, 0], "Land_CamoNetB_EAST",			[[0,10,2], 	[0,10,0], 	0, 	true, false, false, false, false, false, false, true, true, true, true]],//Land_CamoNetB_EAST --26
[[0, 0, 5, 0, 1, 0], "Land_CamoNetB_NATO", 			[[0,10,2], 	[0,10,0], 	0, 	true, false, false, false, false, false, false, true, true, true, true]],//Land_CamoNetB_NATO --27
[[0, 0, 4, 0, 1, 0], "Land_CamoNetVar_EAST",		[[0,10,1.2],[0,7,0], 	0, 	true, false, false, false, false, false, false, true, true, true, true]],//Land_CamoNetVar_EAST --28
[[0, 0, 3, 0, 1, 0], "Land_CamoNetVar_NATO", 		[[0,10,1.2],[0,7,0], 	0, 	true, false, false, false, false, false, false, true, true, true, true]],//Land_CamoNetVar_NATO --29
[[0, 0, 2, 0, 1, 0], "Land_CamoNet_EAST",			[[0,8,1.2], [0,7,0], 	0, 	true, false, false, false, false, false, false, true, true, true, true]],//Land_CamoNet_EAST --30
[[0, 0, 1, 0, 1, 0], "Land_CamoNet_NATO",			[[0,8,1.2], [0,7,0], 	0, 	true, false, false, false, false, false, false, true, true, true, true]],//Land_CamoNet_NATO --31
[[0, 0, 2, 2, 0, 0], "Fence_Ind_long",				[[0,5,.6], 	[-4,1.5,0], 0, 	true, false, false, false, false, false, false, true, true, true, true]], //Fence_Ind_long --32
[[0, 0, 2, 0, 0, 0], "Fort_RazorWire",				[[0,5,.8], 	[0,4,0], 	0, 	true, false, false, false, false, false, false, true, true, true, true]],//Fort_RazorWire --33
[[0, 0, 0, 4, 2, 0], "Land_Fire_barrel",			[[0,5,1.8], [0,4,0], 	0, 	true, true, false, false, true, false, true, true, true, true, false]],//Land_Fire_barrel --34
[[2, 2, 2, 0, 6, 0], "Land_Ind_TankSmall2_EP1",		[[0,8,.8], 	[0,6,0], 	0, 	true, true, false, false, true, false, false, true, true, true, false]],//Land_Ind_TankSmall2_EP1 --35
[[0, 0, 3, 3, 6, 0], "Land_Ind_SawMillPen",			[[0,18,.2], [0,15,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//Land_Ind_SawMillPen --36
[[3, 6, 0, 0, 3, 0], "Land_Ind_Garage01",			[[0,10,.1],	[0,10,0], 	0, 	true, true, false, false, false, false, false, true, true, false, false]],//MAP_Ind_Garage01 --37
[[0, 4, 4, 0, 0, 0], "Land_A_FuelStation_Build",	[[0,10,2.1],[0,10,0], 	0, 	true, true, false, false, false, false, false, true, true, false, false]],//Land_A_FuelStation_Build --38
[[4, 6, 2, 0, 0, 0], "Land_A_FuelStation_Shed",		[[0,10,2.1],[0,10,0], 	0, 	true, true, false, false, false, false, false, true, true, false, false]],//Land_A_FuelStation_Shed --39
[[8, 0, 4, 0, 0, 0], "Land_radar",					[[0,10,2.1],[0,10,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//Land_radar --40
[[0, 0, 2, 0, 2, 0], "Land_coneLight",				[[0,5,0.3], [0,4,0], 	0, 	true, true, false, false, false, false, true, true, true, true, false]],//Land_coneLight --41
[[0, 0, 0, 0, 5, 0], "Land_RedWhiteBarrier",		[[0,8,1.8], [0,8,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//Land_RedWhiteBarrier --42
[[3, 0, 0, 2, 0, 0], "Land_arrows_desk_R",			[[0,5,1.8], [0,4,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//Land_arrows_desk_R --43
[[2, 0, 0, 3, 0, 0], "Land_arrows_desk_L",			[[0,5,1.8], [0,4,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//Land_arrows_desk_L --44
[[0, 2, 0, 0, 0, 0], "HeliHCivil",					[[0,5,1.8], [0,4,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//HeliHCivil --47
[[0, 0, 5, 0, 0, 0], "Land_Ind_IlluminantTower",	[[0,5,2], 	[0,4,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//Land_Ind_IlluminantTower --48
[[1, 2, 1, 0, 0, 0], "Land_vez",					[[0,5,1.8], [0,4,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//Land_vez --49
[[1, 1, 0, 0, 0, 0], "SearchLight",					[[0,2,1], 	[0,2,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//SearchLight --50
[[0, 0, 1, 1, 0, 0], "Sign_Danger",					[[0,5,2], 	[0,4,1], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//Sign_Danger --51
[[0, 0, 1, 2, 0, 0], "SignM_UN_Base_EP1",			[[0,5,1.8], [0,4,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//SignM_UN_Base_EP1 --52
[[0, 0, 1, 2, 1, 0], "ASC_runway_YellowlightB",		[[0,5,.8],	[0,4,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//ASC_runway_YellowlightB --52
[[0, 0, 1, 2, 2, 0], "ASC_runway_BluelightB",		[[0,5,.8],	[0,4,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//ASC_runway_BluelightB --52
[[0, 0, 0, 0, 8, 0], "Land_Wall_Gate_Kolchoz",		[[0,10,1.8], [0,5,0], 	0, 	true, true, false, false, false, false, false, true, true, true, false]],//Land_Wall_Gate_Kolchoz --55
[[1, 0, 0, 0, 2, 0], "Fence_Ind",  					[[0,4,.7], 	[0,2,0], 	0, 	true, false, false, false, false, false, false, true, true, true, true]] //Fence_Ind 	--45 *** Remember that the last element in array does not get comma ***
];

// Build allremovables array for remove action
for "_i" from 0 to ((count _buildlist) - 1) do
{
	_removable = (_buildlist select _i) select _i - _i + 1;
	if (_removable != "Grave") then { // Booby traps have disarm bomb
	allremovables set [count allremovables, _removable];
	};
};
// Build classnames array for use later
for "_i" from 0 to ((count _buildlist) - 1) do
{
	_classname = (_buildlist select _i) select _i - _i + 1;
	allbuildables_class set [count allbuildables_class, _classname];
};


/*
*** Remember that the last element in ANY array does not get comma ***
Notice lines 47 and 62
*/
// Towns to restrict from building in. (Type exact name as shown on map, NOT Case-Sensitive but spaces important)
// ["Classname", range restriction];
// NOT REQUIRED SERVER SIDE, JUST ADDED IN IF YOU NEED TO USE IT
_build_townsrestrict = [
["Lyepestok", 1000],
["Sabina", 900],
["Branibor", 600],
["Bilfrad na moru", 400],
["Mitrovice", 350],
["Seven", 300],
["Blato", 300]
];
// Here we are filling the global arrays with this local list
allbuildables = _buildlist;
allbuild_notowns = _build_townsrestrict;

// ################################### BUILD LIST ARRAY SERVER SIDE ######################################## END

};
//##### COPY END
//----------InitMissions--------//
  MissionGo = 0;
  MissionGoMinor = 0;
    if (isServer) then {
  SMarray = ["SM1","SM2","SM3","SM4","SM5","SM6"];
    [] execVM "\z\addons\dayz_server\missions\major\SMfinder.sqf"; //Starts major mission system
    SMarray2 = ["SM1","SM2","SM3","SM4","SM5","SM6"];
    [] execVM "\z\addons\dayz_server\missions\minor\SMfinder.sqf"; //Starts minor mission system
    };
//---------EndInitMissions------//
