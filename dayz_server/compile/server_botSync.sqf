
_bot = _this select 0;
_charID = _this select 1;
_worldspace = _this select 2;
_model = _this select 3;
_currentWpn = _this select 4;
_currentAnim = _this select 5;

_backpack = unitBackpack _bot;
_playerBackp = [typeOf _backpack,getWeaponCargo _backpack,getMagazineCargo _backpack];

if (_bot getVariable["USEC_injured",false]) then {
			{
				if (_bot getVariable[_x,false]) then {
					_wounds set [count _wounds,_x];
				};
			} forEach USEC_typeOfWounds;
		};
		_legs = _bot getVariable ["hit_legs",0];
		_arms = _bot getVariable ["hit_arms",0];
		_medical = [
			_bot getVariable["USEC_isDead",false],
			_bot getVariable["NORRN_unconscious", false],
			_bot getVariable["USEC_infected",false],
			_bot getVariable["USEC_injured",false],
			_bot getVariable["USEC_inPain",false],
			_bot getVariable["USEC_isCardiac",false],
			_bot getVariable["USEC_lowBlood",false],
			_bot getVariable["USEC_BloodQty",12000],
			_wounds,
			[_legs,_arms],
			_bot getVariable["unconsciousTime",0],
			_bot getVariable["messing",[0,0]]
		];

if ( typeName(_currentWpn) == "STRING" ) then {
	_muzzles = getArray(configFile >> "cfgWeapons" >> _currentWpn >> "muzzles");
	if (count _muzzles > 1) then {
		_currentWpn = currentMuzzle _bot;
	};	
} else {
	diag_log ("DW_DEBUG: _currentWpn: " + str(_currentWpn));
	_currentWpn = "";
};
_temp = round(_bot getVariable ["temperature",100]);
_currentState = [_currentWpn,_currentAnim,_temp];			
				



_myGroup = group _bot;
deleteVehicle _bot;
deleteGroup group _bot;
//Wait for HIVE to be free
//Send request

private["_debug","_distance"];
_debug = getMarkerpos "respawn_west";
_charPos = getPosATL _bot;
_distance = _debug distance _charPos;
if (_distance < 750) exitWith { 
	diag_log format["ERROR: server_playerSync: Cannot Sync Bot %1 [%2]. Position in debug! %3",name _bot,_charID,_charPos];
};

if (str(_worldspace) != "[0,[0,0,0]]") then { // Костыль от кривых сохранений в базе
	_key = format["CHILD:201:%1:%2:%3:%4:%5:%6:%7:%8:%9:%10:%11:%12:%13:%14:%15:%16:",_charID,_worldspace,[weapons _bot,magazines _bot],_playerBackp,_medical,false,false,0,0,0,0,_currentState,0,0,_model,0];
	diag_log ("HIVE: ontimer WRITE: "+ str(_key) + " / " + _charID);
	_key call server_hiveWrite;
} else {
	diag_log ("DiscoMorph: WORLDSPACE 0,0,0 FOUND in CID: " + _charID);
};

