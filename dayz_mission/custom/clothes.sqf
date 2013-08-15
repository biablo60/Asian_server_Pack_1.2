// Created by [GEEK SQUAD]Churchie
// Contributors to getting it working are:| cyrq | Manatee Hunter | Deasil | OnlyblackSurvivor | Thank you!
player removeAction s_clothes;
s_clothes = -1;
private["_body","_result"];
    _body = _this select 3;
    _model = typeOf _body;
if( _model in ["Sniper1_DZ", "Camo1_DZ", "Functionary1_EP1_DZ", "Haris_Press_EP1_DZ", "Ins_Soldier_GL_DZ", "Priest_DZ", "Rocker2_DZ", "Soldier_Bodyguard_AA12_PMC_DZ", "TK_INS_Soldier_EP1_DZ", "TK_INS_Warlord_EP1_DZ", "Rocker1_DZ", "Rocker3_DZ", "Rocker4_DZ", "Bandit1_DZ", "Bandit2_DZ", "BanditW1_DZ", "BanditW2_DZ", "SurvivorW2_DZ", "SurvivorW3_DZ", "SurvivorWpink_DZ", "SurvivorWcombat_DZ", "SurvivorWdesert_DZ", "SurvivorWurban_DZ", "CZ_Special_Forces_GL_DES_EP1_DZ", "Drake_Light_DZ", "Pilot_EP1_DZ", "RU_Policeman_DZ", "Rocket_DZ", "Soldier1_DZ", "Soldier_Sniper_PMC_DZ", "Soldier_TL_PMC_DZ", "FR_OHara_DZ", "FR_Rodriguez_DZ", "CZ_Soldier_Sniper_EP1_DZ", "Graves_Light_DZ", "GUE_Commander_DZ", "GUE_Soldier_2_DZ", "GUE_Soldier_CO_DZ", "GUE_Soldier_Crew_DZ", "GUE_Soldier_Sniper_DZ"] ) then { _model = "Skin_" + _model;
    _result = [player,_model] call BIS_fnc_invAdd;
if (_result) then { player playActionNow "PutDown";
private["_name","_method","_methodStr"];
    _name = _body getVariable["bodyName","unknown"];
    _method = _body getVariable["deathType","unknown"];
    _methodStr = localize format ["str_death_%1",_method];
    _class = "Survivor2_DZ";
    _position = getPosATL _body;
    _dir = getDir _body;
    _currentAnim = animationState
    _body; private ["_weapons","_magazines","_primweapon","_secweapon"];
    _weapons = weapons _body;
    _primweapon = primaryWeapon
    _body; _secweapon = secondaryWeapon _body;
if(!(_primweapon in _weapons) && _primweapon != "") then { _weapons = _weapons + [_primweapon]; };
if(!(_secweapon in _weapons) && _secweapon != "") then { _weapons = _weapons + [_secweapon]; };
    _magazines = magazines _body;
private ["_newBackpackType","_backpackWpn","_backpackMag"]; dayz_myBackpack = unitBackpack _body;
    _newBackpackType = (typeOf dayz_myBackpack);
if(_newBackpackType != "") then { _backpackWpn = getWeaponCargo unitBackpack _body;
    _backpackMag = getMagazineCargo unitBackpack _body; };
    _currentWpn = currentWeapon _body;
    _muzzles = getArray(configFile >> "cfgWeapons" >> _currentWpn >> "muzzles");
if (count _muzzles > 1) then { _currentWpn = currentMuzzle _body; };
        diag_log "Attempting to switch model";
        diag_log str(_weapons);
        diag_log str(_magazines);
        diag_log (str(_backpackWpn));
        diag_log (str(_backpackMag));
    _body setPosATL dayz_spawnPos;
    _oldUnit = _body;
    _group = createGroup west;
    _newUnit = _group createUnit [_class,dayz_spawnPos,[],0,"NONE"];
    _newUnit setPosATL _position;
    _newUnit setDir _dir; {_newUnit removeMagazine _x;} forEach magazines _newUnit;
    removeAllWeapons _newUnit; {
if (typeName _x == "ARRAY") then {_newUnit addMagazine [_x select 0,_x select 1]
    } else { _newUnit addMagazine _x };
    } forEach _magazines; { _newUnit addWeapon _x; } forEach _weapons;
if(str(_weapons) != str(weapons _newUnit)) then { { _weapons = _weapons - [_x];
    } forEach (weapons _newUnit); {
    _newUnit addWeapon _x;
    } forEach _weapons; };
if(_primweapon != (primaryWeapon _newUnit)) then { _newUnit addWeapon _primweapon; };
if(_secweapon != (secondaryWeapon _newUnit) && _secweapon != "") then { _newUnit addWeapon _secweapon; };
if (!isNil "_newBackpackType") then {
if (_newBackpackType != "") then { _newUnit addBackpack _newBackpackType;
    _oldBackpack = dayz_myBackpack; dayz_myBackpack = unitBackpack _newUnit; _backpackWpnTypes = [];
    _backpackWpnQtys = [];
if (count _backpackWpn > 0) then { _backpackWpnTypes = _backpackWpn select 0;
    _backpackWpnQtys = _backpackWpn select 1; };
    _countr = 0; { dayz_myBackpack addWeaponCargoGlobal [_x,(_backpackWpnQtys select _countr)];
    _countr = _countr + 1;
    } forEach _backpackWpnTypes;
    _backpackmagTypes = [];
    _backpackmagQtys = [];
if (count _backpackmag > 0) then { _backpackmagTypes =
    _backpackMag select 0;
    _backpackmagQtys = _backpackMag select 1; };
    _countr = 0; { dayz_myBackpack addmagazineCargoGlobal [_x,(_backpackmagQtys select _countr)];
    _countr = _countr + 1;
    } forEach _backpackmagTypes; }; };
        diag_log "Taking Clothes. Equipment:";
        diag_log str(weapons _newUnit); diag_log str(magazines _newUnit);
        diag_log str(getWeaponCargo unitBackpack _newUnit);
        diag_log str(getMagazineCargo unitBackpack _newUnit);
    removeAllWeapons _oldUnit; {_oldUnit removeMagazine _x;
    } forEach magazines _oldUnit; deleteVehicle _oldUnit;
    _newUnit setDamage 1;
    _newUnit setVariable["bodyName",_name,true];
    _newUnit setVariable["deathType",_method,true];
    } else {
        cutText ["You need a free inventory slot to take clothing.", "PLAIN DOWN"];
    };
};