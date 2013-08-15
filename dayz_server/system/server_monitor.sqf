private ["_result","_pos","_wsDone","_dir","_block","_isOK","_countr","_objWpnTypes","_objWpnQty","_dam","_selection","_totalvehicles","_object","_idKey","_type","_ownerID","_worldspace","_intentory","_hitPoints","_fuel","_damage","_date","_script","_key","_outcome","_vehLimit","_hiveResponse","_objectCount","_codeCount","_objectArray"];
[]execVM "\z\addons\dayz_server\system\s_fps.sqf"; //server monitor FPS (writes each ~181s diag_fps+181s diag_fpsmin*)

dayz_versionNo = 		getText(configFile >> "CfgMods" >> "DayZ" >> "version");
dayz_hiveVersionNo = 	getNumber(configFile >> "CfgMods" >> "DayZ" >> "hiveVersion");
_script = getText(missionConfigFile >> "onPauseScript");

if ((count playableUnits == 0) and !isDedicated) then {
	isSinglePlayer = true;
};

waitUntil{initialized}; //means all the functions are now defined
// ####Copy START
// ### BASE BUILDING 1.2 ### SERVER SIDE BUILD ARRAYS - START
call build_baseBuilding_arrays;
// ### BASE BUILDING 1.2 ### SERVER SIDE BUILD ARRAYS - END
// ####Copy END
diag_log "HIVE: Starting";


waituntil{isNil "sm_done"}; // prevent server_monitor be called twice (bug during login of the first player)

//Set the Time
//Send request
_key = "CHILD:307:";
_result = _key call server_hiveReadWrite;
_outcome = _result select 0;
if(_outcome == "PASS") then {
	_date = _result select 1; 
		
	if(dayz_fullMoonNights) then {
		//date setup
		_year = _date select 0;
		_month = _date select 1;
		_day = _date select 2;
		_hour = _date select 3;
		_minute = _date select 4;
		
		//Force full moon nights
		_date = [2012,6,6,_hour,_minute];
	};
		
	if(isDedicated) then {
		//["dayzSetDate",_date] call broadcastRpcCallAll;
		setDate _date;
		dayzSetDate = _date;
		publicVariable "dayzSetDate";
	};

	diag_log ("HIVE: Local Time set to " + str(_date));
};

	
// Custom Configs
if(isnil "MaxVehicleLimit") then {
	MaxVehicleLimit = 50;
};
if(isnil "MaxHeliCrashes") then {
	MaxHeliCrashes = 5;
};
if(isnil "MaxDynamicDebris") then {
	MaxDynamicDebris = 100;
};
// Custon Configs End

if (isServer and isNil "sm_done") then {

	serverVehicleCounter = [];
	_hiveResponse = [];

	for "_i" from 1 to 5 do {
		diag_log "HIVE: trying to get objects";
		_key = format["CHILD:302:%1:", dayZ_instance];
		_hiveResponse = _key call server_hiveReadWrite;  
		if ((((isnil "_hiveResponse") || {(typeName _hiveResponse != "ARRAY")}) || {((typeName (_hiveResponse select 1)) != "SCALAR")}) || {(_hiveResponse select 1 > 2000)}) then {
			diag_log ("HIVE: connection problem... HiveExt response:"+str(_hiveResponse));
			_hiveResponse = ["",0];
		} 
		else {
			diag_log ("HIVE: found "+str(_hiveResponse select 1)+" objects" );
			_i = 99; // break
		};
	};

	_objectArray = [];
	if ((_hiveResponse select 0) == "ObjectStreamStart") then {
		_objectCount = _hiveResponse select 1;
		diag_log ("HIVE: Commence Object Streaming...");
		for "_i" from 1 to _objectCount do { 
			_hiveResponse = _key call server_hiveReadWrite;
			_objectArray set [_i - 1, _hiveResponse];
			//diag_log (format["HIVE dbg %1 %2", typeName _hiveResponse, _hiveResponse]);
		};
		diag_log ("HIVE: got " + str(count _objectArray) + " objects");
	};

	// # START OF STREAMING #
	_countr = 0;	
	_totalvehicles = 0;
	{
		//Parse Array
		_countr = _countr + 1;

		_idKey = 	_x select 1;
		_type =		_x select 2;
		_ownerID = 	_x select 3;

		_worldspace = _x select 4;
		_intentory=	_x select 5;
		_hitPoints=	_x select 6;
		_fuel =		_x select 7;
		_damage = 	_x select 8;

		_dir = 0;
		_pos = [0,0,0];
		_wsDone = false;
		if (count _worldspace >= 2) then
		{
			_dir = _worldspace select 0;
			if (count (_worldspace select 1) == 3) then {
				_pos = _worldspace select 1;
				_wsDone = true;
			}
		};			
		if (!_wsDone) then {
			if (count _worldspace >= 1) then { _dir = _worldspace select 0; };
			_pos = [getMarkerPos "center",0,4000,10,0,2000,0] call BIS_fnc_findSafePos;
			if (count _pos < 3) then { _pos = [_pos select 0,_pos select 1,0]; };
			diag_log ("MOVED OBJ: " + str(_idKey) + " of class " + _type + " to pos: " + str(_pos));
		};

		if (_damage < 1) then {
			diag_log format["OBJ: %1 - %2", _idKey,_type];
			
			//Create it
			_object = createVehicle [_type, _pos, [], 0, "CAN_COLLIDE"];
			_object setVariable ["lastUpdate",time];
			_object setVariable ["ObjectID", _idKey, true];

			// fix for leading zero issues on safe codes after restart
			if (_object isKindOf "VaultStorageLocked") then {
				_codeCount = (count (toArray _ownerID));
				if(_codeCount == 3) then {
					_ownerID = format["0%1", _ownerID];
				};
				if(_codeCount == 2) then {
					_ownerID = format["00%1", _ownerID];
				};
				if(_codeCount == 1) then {
					_ownerID = format["000%1", _ownerID];
				};
			};

			_object setVariable ["CharacterID", _ownerID, true];
			
			clearWeaponCargoGlobal  _object;
			clearMagazineCargoGlobal  _object;
			
			if ((typeOf _object) in dayz_allowedObjects) then {
				_object addMPEventHandler ["MPKilled",{_this call object_handleServerKilled;}];
				// Test disabling simulation server side on buildables only.
				_object enableSimulation false;
			};
			
			_object setdir _dir;
			_object setpos _pos;
			_object setDamage _damage;
// ####Copy START
// ##### BASE BUILDING 1.2 Server Side ##### - START
// This sets objects to appear properly once server restarts
		//_object setVariable ["ObjectUID", _worldspace call dayz_objectUID2, true]; // Optional (REMOVE // lines before _object) May fix DayZ.ST issues, or issues related to Panel codes not working thanks nullpo
		//the following is happening on every server restart
		_code = _fuel * 1000; //it is necessary cause we get only the converted fuel variable from the database, so we got to calculate back to code format
		_object setVariable ["Code", _code,true]; //set Code to the Object
		_object setVariable ["Classname", _type,true]; //set Classname to the Object
		_object setVariable ["ObjectID", _idKey,true]; //set ObjectID to the Object
		_object setVariable ["ObjectUID", _worldspace call dayz_objectUID2, true]; //set ObjectUID to the Object
		if ((_object isKindOf "Static") && !(_object isKindOf "TentStorage")) then {
			_object setpos [(getposATL _object select 0),(getposATL _object select 1), 0];
		};
		//Set Variable
		if (_object isKindOf "Infostand_2_EP1" && !(_object isKindOf "Infostand_1_EP1")) then {
			_object setVariable ["Code", _code, true]; //changed to _code instead of _worldspace call dayz_objectUID2
		};


				// Set whether or not buildable is destructable
		if (typeOf(_object) in allbuildables_class) then {
			diag_log ("SERVER: in allbuildables_class:" + typeOf(_object) + " !");
			for "_i" from 0 to ((count allbuildables) - 1) do
			{
				_classname = (allbuildables select _i) select _i - _i + 1;
				_result = [_classname,typeOf(_object)] call BIS_fnc_areEqual;
				if (_result) then {
					_requirements = (allbuildables select _i) select _i - _i + 2;

					_isDestructable = _requirements select 13;
					diag_log ("SERVER: " + typeOf(_object) + " _isDestructable = " + str(_isDestructable));
					if (!_isDestructable) then {
						diag_log("Spawned: " + typeOf(_object) + " Handle Damage False");
						_object addEventHandler ["HandleDamage", {false}];
					};
				};
			};
			//gateKeypad = _object addaction ["Defuse", "\z\addons\dayz_server\compile\enterCode.sqf"];
		};
// ##### BASE BUILDING 1.2 Server Side ##### - END
// This sets objects to appear properly once server restarts
// ###COPY END
			if (count _intentory > 0) then {
				if (_object isKindOf "VaultStorageLocked") then {
					// Fill variables with loot
					_object setVariable ["WeaponCargo", (_intentory select 0), true];
					_object setVariable ["MagazineCargo", (_intentory select 1), true];
					_object setVariable ["BackpackCargo", (_intentory select 2), true];
					_object setVariable ["OEMPos", _pos, true];
				} else {

					//Add weapons
					_objWpnTypes = (_intentory select 0) select 0;
					_objWpnQty = (_intentory select 0) select 1;
					_countr = 0;					
					{
						if (_x == "Crossbow") then { _x = "Crossbow_DZ" }; // Convert Crossbow to Crossbow_DZ
						_isOK = 	isClass(configFile >> "CfgWeapons" >> _x);
						if (_isOK) then {
							_block = 	getNumber(configFile >> "CfgWeapons" >> _x >> "stopThis") == 1;
							if (!_block) then {
								_object addWeaponCargoGlobal [_x,(_objWpnQty select _countr)];
							};
						};
						_countr = _countr + 1;
					} forEach _objWpnTypes; 
				
					//Add Magazines
					_objWpnTypes = (_intentory select 1) select 0;
					_objWpnQty = (_intentory select 1) select 1;
					_countr = 0;
					{
						if (_x == "BoltSteel") then { _x = "WoodenArrow" }; // Convert BoltSteel to WoodenArrow
						_isOK = 	isClass(configFile >> "CfgMagazines" >> _x);
						if (_isOK) then {
							_block = 	getNumber(configFile >> "CfgMagazines" >> _x >> "stopThis") == 1;
							if (!_block) then {
								_object addMagazineCargoGlobal [_x,(_objWpnQty select _countr)];
							};
						};
						_countr = _countr + 1;
					} forEach _objWpnTypes;

					//Add Backpacks
					_objWpnTypes = (_intentory select 2) select 0;
					_objWpnQty = (_intentory select 2) select 1;
					_countr = 0;
					{
						_isOK = 	isClass(configFile >> "CfgVehicles" >> _x);
						if (_isOK) then {
							_block = 	getNumber(configFile >> "CfgVehicles" >> _x >> "stopThis") == 1;
							if (!_block) then {
								_object addBackpackCargoGlobal [_x,(_objWpnQty select _countr)];
							};
						};
						_countr = _countr + 1;
					} forEach _objWpnTypes;
				};
			};	
			
			if (_object isKindOf "AllVehicles") then {
				{
					_selection = _x select 0;
					_dam = _x select 1;
					if (_selection in dayZ_explosiveParts and _dam > 0.8) then {_dam = 0.8};
					[_object,_selection,_dam] call object_setFixServer;
				} forEach _hitpoints;

				_object setFuel _fuel;

				if (!((typeOf _object) in dayz_allowedObjects)) then {
					
					_object setvelocity [0,0,1];
					_object call fnc_vehicleEventHandler;			
					
					if(_ownerID != "0") then {
						_object setvehiclelock "locked";
					};
					
					_totalvehicles = _totalvehicles + 1;

					// total each vehicle
					serverVehicleCounter set [count serverVehicleCounter,_type];
				};
			};

			//Monitor the object
			dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_object];
		};
	} forEach _objectArray;
	// # END OF STREAMING #

	//  spawn_vehicles
	_vehLimit = MaxVehicleLimit - _totalvehicles;
	diag_log ("HIVE: Spawning # of Vehicles: " + str(_vehLimit));
	if(_vehLimit > 0) then {
		for "_x" from 1 to _vehLimit do {
			[] spawn spawn_vehicles;
		};
	};
	//  spawn_roadblocks
	diag_log ("HIVE: Spawning # of Debris: " + str(MaxDynamicDebris));
	for "_x" from 1 to MaxDynamicDebris do {
		[] spawn spawn_roadblocks;
	};

	if(isnil "dayz_MapArea") then {
		dayz_MapArea = 10000;
	};
	if(isnil "HeliCrashArea") then {
		HeliCrashArea = dayz_MapArea / 2;
	};
	if(isnil "OldHeliCrash") then {
		OldHeliCrash = false;
	};

// [_guaranteedLoot, _randomizedLoot, _frequency, _variance, _spawnChance, _spawnMarker, _spawnRadius, _spawnFire, _fadeFire, _useStatic, _preWaypoint, _crashDamage]
nul =    [
                3,        //Number of the guaranteed Loot-Piles at the Crashside
                4,        //Number of the random Loot-Piles at the Crashside 3+(1,2,3 or 4)
                3000,     //Fixed-Time (in seconds) between each start of a new Chopper
                500,      //Random time (in seconds) added between each start of a new Chopper
                1,        //Spawnchance of the Heli (1 will spawn all possible Choppers, 0.5 only 50% of them)
                'center', //Center-Marker for the Random-Crashpoints, for Chernarus this is a point near Stary
                4000,     //Radius in Meters from the Center-Marker in which the Choppers can crash and get waypoints
                true,     //Should the spawned crashsite burn (at night) & have smoke?
                false,    //Should the flames & smoke fade after a while?
                false,    //Use the Static-Crashpoint-Function? If true, you have to add Coordinates into server_spawnCrashSite.sqf
                1,        //Amount of Random-Waypoints the Heli gets before he flys to his Point-Of-Crash (using Static-Crashpoint-Coordinates if its enabled)
                1         //Amount of Damage the Heli has to get while in-air to explode before the POC. (0.0001 = Insta-Explode when any damage//bullethit, 1 = Only Explode when completly damaged)
            ] spawn server_spawnCrashSite;
/*	
	// [_guaranteedLoot, _randomizedLoot, _frequency, _variance, _spawnChance, _spawnMarker, _spawnRadius, _spawnFire, _fadeFire]
	nul = [3, 4, 900, 300, 0.99, 'center', HeliCrashArea, true, false] spawn server_spawnCrashSite;
*/	
// [_guaranteedLoot, _randomizedLoot, _frequency, _variance(DONOTUSE), _spawnChance, _spawnMarker, _spawnRadius, _spawnFire, _fadeFire, waypoints, damage]
nul = [7, 5, 700, 0, 0.99, 'center', 4000, true, false, true, 5, 1] spawn server_spawnC130CrashSite;
nul =    [
                6,        //Number of the guaranteed Loot-Piles at the Crashside
                3,        //Number of the random Loot-Piles at the Crashside 3+(1,2,3 or 4)
                (50*60),    //Fixed-Time (in seconds) between each start of a new Chopper
                (15*60),      //Random time (in seconds) added between each start of a new Chopper
                0.75,        //Spawnchance of the Heli (1 will spawn all possible Choppers, 0.5 only 50% of them)
                'center', //'center' Center-Marker for the Random-Crashpoints, for Chernarus this is a point near Stary
                8000,    // [106,[960.577,3480.34,0.002]]Radius in Meters from the Center-Marker in which the Choppers can crash and get waypoints
                true,    //Should the spawned crashsite burn (at night) & have smoke?
                false,    //Should the flames & smoke fade after a while?
                2,    //RANDOM WP
                3,        //GUARANTEED WP
                1        //Amount of Damage the Heli has to get while in-air to explode before the POC. (0.0001 = Insta-Explode when any damage//bullethit, 1 = Only Explode when completly damaged)
            ] spawn server_spawnAN2;
	// Epoch Events
	nul = [] spawn server_spawnEvents;

	allowConnection = true;
	sm_done = true;
};
