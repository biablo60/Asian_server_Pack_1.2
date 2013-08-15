
//[unit, weapon, muzzle, mode, ammo, magazine, projectile]

_bot    = _this select 0;
_killer = _this select 1;

_bot removeAllEventHandlers "HandleDamage";

//_botName = _bot getVariable["bodyName", "nil"];

//_killer = _bot getVariable["AttackedBy", "nil"];
//_killerName = _bot getVariable["AttackedByName", "nil"];



_characterID = _bot getVariable ["CharacterID",0];
_minutes = 	_bot getVariable["lastTime",0];

diag_log ("Bot DEATH: Player Died " + str(_characterID));
_key = format["CHILD:202:%1:%2:",_characterID,_minutes];
_key call server_hiveWrite;
diag_log ("HIVE: death WRITE: "+ str(_key));
_bot setDamage 1

//_myGroup = group _bot;
//deleteVehicle _bot;
//deleteGroup group _bot;


