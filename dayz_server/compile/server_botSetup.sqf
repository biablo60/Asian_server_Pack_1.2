private["_updates","_playerUID","_charID","_humanity","_worldspace","_model","_bot","_object","_class","_position","_dir","_group","_oldUnit","_currentWpn","_muzzles","_currentAnim","_wounds","_lastTime"];
_playerUID 	= _this select 0;
_charID 	= _this select 1;
_model 		= _this select 2;
_object = _this select 3;
//_pname = name player;

_old = _object;
//_object allowDamage false;

_object removeEventHandler ["FiredNear",0];
_object removeEventHandler ["HandleDamage",0];
_object removeEventHandler ["Killed",0];
_object removeEventHandler ["Fired",0];

_updates = 		_object getVariable["updatePlayer",[false,false,false,false,false]];
_updates set [0,true];
_object setVariable["updatePlayer",_updates,true];
//dayz_unsaved = true;
//Logout
if (_object getVariable["USEC_injured",false]) then {
	{
		if (_object getVariable[_x,false]) then {
			_wounds set [count _wounds,_x];
		};
	} forEach USEC_typeOfWounds;
};

_humanity = _object getVariable["humanity",0];
_legs = _object getVariable ["hit_legs",0];
_arms = _object getVariable ["hit_arms",0];
_medical = [
	_object getVariable["USEC_isDead",false],
	_object getVariable["NORRN_unconscious", false],
	_object getVariable["USEC_infected",false],
	_object getVariable["USEC_injured",false],
	_object getVariable["USEC_inPain",false],
	_object getVariable["USEC_isCardiac",false],
	_object getVariable["USEC_lowBlood",false],
	_object getVariable["USEC_BloodQty",12000],
	_wounds,
	[_legs,_arms],
	_object getVariable["unconsciousTime",0],
	_object getVariable["messing",[0,0]]
];
_worldspace 	= [round(direction _object),getPosATL _object];
_zombieKills 	= _object getVariable ["zombieKills",0];
_headShots 		= _object getVariable ["headShots",0];
_humanKills 	= _object getVariable ["humanKills",0];
_banditKills 	= _object getVariable ["banditKills",0];
_lastTime       = _object getVariable ["lastTime",0];

//Switch

_class 			= _model;

_position 		= getPosATL _object;
_dir 			= getDir _object;
_currentAnim 	= animationState _object;

//Secure Player for Transformation
_object setPosATL [0,0,0];


//BackUp Weapons and Mags
private ["_weapons","_magazines","_primweapon","_secweapon"];
_weapons 	= weapons _object;
_magazines	= magazines _object;
_primweapon	= primaryWeapon _object;
_secweapon	= secondaryWeapon _object;

//Checks
if(!(_primweapon in _weapons) && _primweapon != "") then {
	_weapons = _weapons + [_primweapon];
};

if(!(_secweapon in _weapons) && _secweapon != "") then {
	_weapons = _weapons + [_secweapon];
};

if(count _magazines == 0) then {
	_magazines = magazines _object;
};

//BackUp Backpack
private ["_newBackpackType","_backpackWpn","_backpackMag"];
	_newBackpackType = (typeOf (unitBackpack _object));
	if(_newBackpackType != "") then {
		_backpackWpn = getWeaponCargo unitBackpack _object;
		_backpackMag = getMagazineCargo unitBackpack _object;
	};

//Get Muzzle
	_currentWpn = "";
	_muzzles = getArray(configFile >> "cfgWeapons" >> _currentWpn >> "muzzles");
	if (count _muzzles > 1) then {
		_currentWpn = currentMuzzle _object;
	};
	

//BackUp Player Object
	_oldUnit = _object;
	_oldUnitname = _oldUnit getVariable["bodyName", "nil"];
	
/***********************************/
//DONT USE player AFTER THIS POINT
/***********************************/

//Create New Character

	//[player] joinSilent grpNull;
	_group 		= createGroup west;
	_bot 	= _group createUnit [_class,getpos _object,[],0,"NONE"];
	_bot setVariable["bodyName", _oldUnitname, true];
	_bot setVariable["altf4", "yes", true];
	_bot disableai "anim";

//Clear New Character
	{_bot removeMagazine _x;} forEach  magazines _bot;
	removeAllWeapons _bot;	

//Equip New Charactar
	{
		_bot addMagazine _x;
		//sleep 0.05;
	} forEach _magazines;
	
	{
		_bot addWeapon _x;
		//sleep 0.05;
	} forEach _weapons;

//Check and Compare it
	if(str(_magazines) != str(magazines _bot)) then {
		//Get Differecnce
		{
			_magazines = _magazines - [_x];
		} forEach (magazines _bot);
		
		//Add the Missing
		{
			_bot addMagazine _x;
			//sleep 0.2;
		} forEach _magazines;
	};
	
	if(str(_weapons) != str(weapons _bot)) then {
		//Get Differecnce
		{
			_weapons = _weapons - [_x];
		} forEach (weapons _bot);
	
		//Add the Missing
		{
			_bot addWeapon _x;
			//sleep 0.2;
		} forEach _weapons;
	};
	
	if(_primweapon !=  (primaryWeapon _bot)) then {
		_bot addWeapon _primweapon;		
	};

	if(_secweapon != (secondaryWeapon _bot) && _secweapon != "") then {
		_bot addWeapon _secweapon;		
	};

//Add and Fill BackPack
	if (!isNil "_newBackpackType") then {
		if (_newBackpackType != "") then {
			_bot addBackpack _newBackpackType;
			_oldBackpack = dayz_myBackpack;
			dayz_myBackpack = unitBackpack _bot;


			//Fill backpack contents
			//Weapons
			_backpackWpnTypes = [];
			_backpackWpnQtys = [];
			if (count _backpackWpn > 0) then {
				_backpackWpnTypes = _backpackWpn select 0;
				_backpackWpnQtys = 	_backpackWpn select 1;
			};
			_countr = 0;
			{
				dayz_myBackpack addWeaponCargoGlobal [_x,(_backpackWpnQtys select _countr)];
				_countr = _countr + 1;
			} forEach _backpackWpnTypes;
			//magazines
			_backpackmagTypes = [];
			_backpackmagQtys = [];
			if (count _backpackmag > 0) then {
				_backpackmagTypes = _backpackMag select 0;
				_backpackmagQtys = 	_backpackMag select 1;
			};
			_countr = 0;
			{
				dayz_myBackpack addmagazineCargoGlobal [_x,(_backpackmagQtys select _countr)];
				_countr = _countr + 1;
			} forEach _backpackmagTypes;
		};
	};
	
	
//Make New Unit Playable
	_bot setPosATL _position;
	_bot setDir _dir;
	addSwitchableUnit _bot;
	setPlayable _bot;


	
	if(_currentWpn != "") then {_bot selectWeapon _currentWpn;};	
	

//Login

//set medical values
if (count _medical > 0) then {
	_bot setVariable["USEC_isDead",(_medical select 0),true];
	_bot setVariable["NORRN_unconscious", (_medical select 1), true];
	_bot setVariable["USEC_infected",(_medical select 2),true];
	_bot setVariable["USEC_injured",(_medical select 3),true];
	_bot setVariable["USEC_inPain",(_medical select 4),true];
	_bot setVariable["USEC_isCardiac",(_medical select 5),true];
	_bot setVariable["USEC_lowBlood",(_medical select 6),true];
	_bot setVariable["USEC_BloodQty",(_medical select 7),true];
	_bot setVariable["unconsciousTime",(_medical select 10),true];
	
	//Add Wounds
	{
		_bot setVariable[_x,true,true];
		[_bot,_x,_hit] spawn fnc_usec_damageBleed;
		usecBleed = [_bot,_x,0];
		publicVariable "usecBleed";
	} forEach (_medical select 8);
	
	//Add fractures
	_fractures = (_medical select 9);
	_bot setVariable ["hit_legs",(_fractures select 0),true];
	_bot setVariable ["hit_hands",(_fractures select 1),true];
} else {
	//Reset Fractures
	_bot setVariable ["hit_legs",0,true];
	_bot setVariable ["hit_hands",0,true];
	_bot setVariable ["USEC_injured",false,true];
	_bot setVariable ["USEC_inPain",false,true];	
};

//General Stats
_bot setVariable["characterID",str(_charID),true];
_bot setVariable["worldspace",_worldspace,true];
_bot setVariable["lastTime",_lastTime];
_bot setVariable ["zombieKills",_zombieKills];
_bot setVariable ["headShots",_headShots];
_bot setVariable ["humanKills",_humanKills];
_bot setVariable ["banditKills",_banditKills];
dayzPlayerMorph = [_charID,_bot,_playerUID,[_zombieKills,_headShots,_humanKills,_banditKills],_humanity];
publicVariable "dayzPlayerMorph";
if (isServer) then {
	dayzPlayerMorph call server_playerMorph;
};
call dayz_resetSelfActions;
//eh_player_killed = _bot addeventhandler ["FiredNear",{_this call player_weaponFiredNear;} ];
_a = call compile format["player%1", getPlayerUID player];
_a = "Test";
//t_name = _pname;
_damageHandle = _bot addeventhandler ["HandleDamage",{[_this] call server_botDamage;}];
_bot removeAllEventHandlers "MPHit";
//_bot addeventhandler ["MPHit",{[_this] call server_botDamage;}];
//_bot addEventHandler ["Killed", {[_this] call server_botDied;}];

_bot allowDamage true;

_bot addWeapon "Loot";
_bot addWeapon "Flare";

sleep 0.1;
deleteVehicle _old;
botPlayers = botPlayers + [_playerUID];

diag_log("Wait 40 seconds");
_waitTimer = 40;
while {(_playerUID in botPlayers) and (_waitTimer >= 0)} do {
	_waitTimer = _waitTimer - 1;
	sleep 1;
};
diag_log("Wait over");
diag_log ("DISCONNECT START (i): " + _playerName + " (" + str(_playerUID) + ") Object: " + str(_object) );

// TODO: Bot Sync

if (alive _bot) then {
	_bot removeAllEventHandlers "handleDamage";
	[_bot, _charID, _worldspace, _model, _currentWpn, _currentAnim] call server_botSync;
	};

// Update Bot List
if (_playerUID in botPlayers) then {
	botPlayers = botPlayers - [_playerUID];
	diag_log("Bot List Updated");
};
