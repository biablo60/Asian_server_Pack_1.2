scriptName "Functions\misc\fn_selfActions.sqf";
/***********************************************************
	ADD ACTIONS FOR SELF
	- Function
	- [] call fnc_usec_selfActions;
************************************************************/
private ["_temp_keys","_magazinesPlayer","_isPZombie","_vehicle","_inVehicle","_hasFuelE","_hasRawMeat","_hasKnife","_hasToolbox","_onLadder","_nearLight","_canPickLight","_canDo","_text","_isHarvested","_isVehicle","_isVehicletype","_isMan","_traderType","_ownerID","_isAnimal","_isDog","_isZombie","_isDestructable","_isTent","_isFuel","_isAlive","_canmove","_Unlock","_lock","_buy","_dogHandle","_lieDown","_warn","_hastinitem","_allowedDistance","_menu","_menu1","_humanity_logic","_low_high","_cancel","_metals_trader","_traderMenu","_isWreck","_isRemovable","_isDisallowRepair","_rawmeat","_humanity","_speed","_dog","_hasbottleitem","_isAir","_isShip","_playersNear","_findNearestGens","_findNearestGen","_IsNearRunningGen","_cursorTarget","_isnewstorage","_itemsPlayer","_ownerKeyId","_typeOfCursorTarget","_hasKey","_oldOwner","_combi","_key_colors"];

if (TradeInprogress) exitWith {}; // Do not allow if any script is running.

_vehicle = vehicle player;
_isPZombie = player isKindOf "PZombie_VB";
_inVehicle = (_vehicle != player);

_onLadder =		(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
_canDo = (!r_drag_sqf and !r_player_unconscious and !_onLadder);
// ---------------------------------------Krixes Self Bloodbag Start------------------------------------
    _mags = magazines player;
 
    // Krixes Self Bloodbag
    if ("ItemBloodbag" in _mags) then {
        hasBagItem = true;
    } else { hasBagItem = false;};
    if((speed player <= 1) && hasBagItem && _canDo) then {
        if (s_player_selfBloodbag < 0) then {
            s_player_selfBloodbag = player addaction[("<t color=""#c70000"">" + ("Self Bloodbag") +"</t>"),"custom\player_selfbloodbag.sqf","",5,false,true,"", ""];
        };
    } else {
        player removeAction s_player_selfBloodbag;
        s_player_selfBloodbag = -1;
    };
// ---------------------------------------Krixes Self Bloodbag End------------------------------------
_nearLight = 	nearestObject [player,"LitObject"];
_canPickLight = false;
if (!isNull _nearLight) then {
	if (_nearLight distance player < 4) then {
		_canPickLight = isNull (_nearLight getVariable ["owner",objNull]);
	};
};
//##### BASE BUILDING 1.2 Custom Actions (CROSSHAIR IS TARGETING NOTHING) #####
// #### START1 ####
_currentSkin = typeOf(player);
			// Get closest camonet since we cannot target with crosshair Base Building Script, got lazy here, didnt fix with array
			camoNetB_East = nearestObject [player, "Land_CamoNetB_EAST"];
			camoNetVar_East = nearestObject [player, "Land_CamoNetVar_EAST"];
			camoNet_East = nearestObject [player, "Land_CamoNet_EAST"];
			camoNetB_Nato = nearestObject [player, "Land_CamoNetB_NATO"];
			camoNetVar_Nato = nearestObject [player, "Land_CamoNetVar_NATO"];
			camoNet_Nato = nearestObject [player, "Land_CamoNet_NATO"];
			radar = nearestObject [player, "Land_radar"];
			Ind_IlluminantTower = nearestObject [player, "Land_Ind_IlluminantTower"];
	// Check mags in player inventory to show build recipe menu	
	_mags = magazines player;
	if ("ItemTankTrap" in _mags || "ItemSandbag" in _mags || "ItemWire" in _mags || "PartWoodPile" in _mags || "PartGeneric" in _mags) then {
		hasBuildItem = true;
	} else { hasBuildItem = false;};
	//Build Recipe Menu Action
	if((speed player <= 1) && hasBuildItem && _canDo) then {
		if (s_player_recipeMenu < 0) then {
			s_player_recipeMenu = player addaction [("<t color=""#0074E8"">" + ("Build Recipes") +"</t>"),"buildRecipeBook\build_recipe_dialog.sqf","",5,false,true,"",""];
		};
	} else {
		player removeAction s_player_recipeMenu;
		s_player_recipeMenu = -1;
	};

	//Add in custom eventhandlers or whatever on skin change
	if (_currentSkin != globalSkin) then {
		globalSkin = _currentSkin;
		player removeMPEventHandler ["MPHit", 0]; 
		player removeEventHandler ["AnimChanged", 0];
		ehWall = player addEventHandler ["AnimChanged", { player call antiWall; } ];
	};
	// Remove CamoNets, (Not effecient but works)
	if((isNull cursorTarget) && _hasToolbox && 
		(camoNetB_East distance player < 10 or 
		camoNetVar_East distance player < 10 or 
		camoNet_East distance player < 10 or 
		camoNetB_Nato distance player < 10 or 
		camoNetVar_Nato distance player < 10 or 
		radar distance player < 30 or 
		Ind_IlluminantTower distance player < 30 or 
		camoNet_Nato distance player < 10) && (_ownerID == dayz_playerUID)) then {
		if (s_player_deleteCamoNet < 0) then {
			s_player_deleteCamoNet = player addaction [("<t color=""#8E11F5"">" + ("Remove Camo Net or Tower next to you.") +"</t>"), "dayz_code\actions\player_remove.sqf",cursorTarget, 1, true, true, "", ""];
		};
	} else {
		player removeAction s_player_deleteCamoNet;
		s_player_deleteCamoNet = -1;
	};
/*	// Remove CamoNets Owner removal, (Not effecient but works)
		if(_canDo && removeObject && 
		(camoNetB_East distance player < 10 or 
		camoNetVar_East distance player < 10 or 
		camoNet_East distance player < 10 or 
		camoNetB_Nato distance player < 10 or 
		camoNetVar_Nato distance player < 10 or 
		radar distance player < 30 or 
		Ind_IlluminantTower distance player < 30 or 
		camoNet_Nato distance player < 10)) then {
		if (s_player_codeRemoveNet < 0) then {
			s_player_codeRemoveNet = player addaction [("<t color=""#8E11F5"">" + ("Base Owners Remove Camo Net or Tower next to you.") +"</t>"),"dayz_code\actions\player_remove.sqf","",5,false,true,"",""];
		};
	} else {
			player removeAction s_player_codeRemoveNet;
			s_player_codeRemoveNet = -1;
	};
*/

//##### BASE BUILDING 1.2 Custom Actions (CROSSHAIR IS TARGETING NOTHING) #####
// #### END1 ####
//Grab Flare
if (_canPickLight and !dayz_hasLight and !_isPZombie) then {
	if (s_player_grabflare < 0) then {
		_text = getText (configFile >> "CfgAmmo" >> (typeOf _nearLight) >> "displayName");
		s_player_grabflare = player addAction [format[localize "str_actions_medical_15",_text], "\z\addons\dayz_code\actions\flare_pickup.sqf",_nearLight, 1, false, true, "", ""];
		s_player_removeflare = player addAction [format[localize "str_actions_medical_17",_text], "\z\addons\dayz_code\actions\flare_remove.sqf",_nearLight, 1, false, true, "", ""];
	};
} else {
	player removeAction s_player_grabflare;
	player removeAction s_player_removeflare;
	s_player_grabflare = -1;
	s_player_removeflare = -1;
};

if(DZEdebug) then {
	hint str(typeOf cursorTarget);
	if (s_player_debuglootpos < 0) then {
		s_player_debuglootpos = player addAction ["Save to arma2.rpt", "\z\addons\dayz_code\actions\debug\Make_lootPos.sqf", ["start"], 99, false, true, "",""];
		s_player_debuglootpos1 = player addAction ["Raise Z", "\z\addons\dayz_code\actions\debug\Make_lootPos.sqf", ["up"], 99, false, true, "",""];
		s_player_debuglootpos2 = player addAction ["Lower Z", "\z\addons\dayz_code\actions\debug\Make_lootPos.sqf", ["down"], 99, false, true, "",""];
		s_player_debuglootpos3 = player addAction ["Raise Z", "\z\addons\dayz_code\actions\debug\Make_lootPos.sqf", ["up_small"], 99, false, true, "",""];
		s_player_debuglootpos4 = player addAction ["Lower Z", "\z\addons\dayz_code\actions\debug\Make_lootPos.sqf", ["down_small"], 99, false, true, "",""];
		Base_Z_height = 0.5;
	};
};

if(_isPZombie) then {
	if (s_player_callzombies < 0) then {
		s_player_callzombies = player addAction ["Raise Horde", "\z\addons\dayz_code\actions\call_zombies.sqf",player, 5, true, false, "",""];
	};
	if (s_player_pzombiesattack < 0) then {
		s_player_pzombiesattack = player addAction ["Attack", "\z\addons\dayz_code\actions\pzombie\pz_attack.sqf",cursorTarget, 6, true, false, "",""];
	};
	if (s_player_pzombiesvision < 0) then {
		s_player_pzombiesvision = player addAction ["Night Vision", "\z\addons\dayz_code\actions\pzombie\pz_vision.sqf", [], 4, false, true, "nightVision", "_this == _target"];
	};
	if (!isNull cursorTarget and (player distance cursorTarget < 3)) then {	//Has some kind of target
		_isAnimal = cursorTarget isKindOf "Animal";
		_isZombie = cursorTarget isKindOf "zZombie_base";
		_isHarvested = cursorTarget getVariable["meatHarvested",false];
		_isMan = cursorTarget isKindOf "Man";
		// Pzombie Gut human corpse or animal
		if (!alive cursorTarget and (_isAnimal or _isMan) and !_isZombie and !_isHarvested) then {
			if (s_player_pzombiesfeed < 0) then {
				s_player_pzombiesfeed = player addAction ["Feed", "\z\addons\dayz_code\actions\pzombie\pz_feed.sqf",cursorTarget, 3, true, false, "",""];
			};
		} else {
			player removeAction s_player_pzombiesfeed;
			s_player_pzombiesfeed = -1;
		};
	} else {
		player removeAction s_player_pzombiesfeed;
		s_player_pzombiesfeed = -1;
	};
};

// Increase distance only if AIR OR SHIP
_allowedDistance = 4;
_isAir = cursorTarget isKindOf "Air";
_isShip = cursorTarget isKindOf "Ship";
if(_isAir or _isShip) then {
	_allowedDistance = 6;
};

if (!isNull cursorTarget and !_inVehicle and !_isPZombie and (player distance cursorTarget < _allowedDistance) and _canDo) then {	//Has some kind of target
	
	// set cursortarget to variable
	_cursorTarget = cursorTarget;
	
	// get typeof cursortarget once
	_typeOfCursorTarget = typeOf _cursorTarget;

	_isVehicle = _cursorTarget isKindOf "AllVehicles";
	_isVehicletype = _typeOfCursorTarget in ["ATV_US_EP1","ATV_CZ_EP1"];
	_isnewstorage = _typeOfCursorTarget in DZE_isNewStorage;
	
	// get items and magazines only once
	_magazinesPlayer = magazines player;

	//boiled Water
	_hasbottleitem = "ItemWaterbottle" in _magazinesPlayer;
	_hastinitem = false;
	{
		if (_x in _magazinesPlayer) then {
			_hastinitem = true;
		};
	} forEach boil_tin_cans;
	_hasFuelE = 	"ItemJerrycanEmpty" in _magazinesPlayer;

	_itemsPlayer = items player;
	
	_temp_keys = [];
	// find available keys
	_key_colors = ["ItemKeyYellow","ItemKeyBlue","ItemKeyRed","ItemKeyGreen","ItemKeyBlack"];
	{
		if (configName(inheritsFrom(configFile >> "CfgWeapons" >> _x)) in _key_colors) then {
			_ownerKeyId = getNumber(configFile >> "CfgWeapons" >> _x >> "keyid");
			_temp_keys set [count _temp_keys,str(_ownerKeyId)];
		};
	} forEach _itemsPlayer;

	_hasKnife = 	"ItemKnife" in _itemsPlayer;
	_hasToolbox = 	"ItemToolbox" in _itemsPlayer;

	_isMan = _cursorTarget isKindOf "Man";
	_traderType = _typeOfCursorTarget;
	_ownerID = _cursorTarget getVariable ["characterID","0"];
	_isAnimal = _cursorTarget isKindOf "Animal";
	_isDog =  (_cursorTarget isKindOf "DZ_Pastor" || _cursorTarget isKindOf "DZ_Fin");
	_isZombie = _cursorTarget isKindOf "zZombie_base";
	_isDestructable = _cursorTarget isKindOf "BuiltItems";
	_isWreck = _typeOfCursorTarget in DZE_isWreck;
	_isRemovable = _typeOfCursorTarget in DZE_isRemovable;
	_isDisallowRepair = _typeOfCursorTarget in ["M240Nest_DZ"];

	_isTent = _cursorTarget isKindOf "TentStorage";
	
	_isAlive = alive _cursorTarget;
	_canmove = canmove _cursorTarget;
	_text = getText (configFile >> "CfgVehicles" >> _typeOfCursorTarget >> "displayName");
	
	_rawmeat = meatraw;
	_hasRawMeat = false;
	{
		if (_x in _magazinesPlayer) then {
			_hasRawMeat = true;
		};
	} forEach _rawmeat; 
	
	_isFuel = false;
	if (_hasFuelE) then {
		{
			if(_cursorTarget isKindOf _x) exitWith {_isFuel = true;};
		} forEach dayz_fuelsources;
	};

	// diag_log ("OWNERID = " + _ownerID + " CHARID = " + dayz_characterID + " " + str(_ownerID == dayz_characterID));
	//##### BASE BUILDING 1.2 Custom Actions (CROSSHAIR HAS A TARGET) #####
// ##### START #####
	// Operate Gates
	if ((dayz_myCursorTarget != cursorTarget) && (cursorTarget isKindOf "Infostand_2_EP1") && keyValid) then {
		_lever = cursorTarget;
		{dayz_myCursorTarget removeAction _x} forEach s_player_gateActions;s_player_gateActions = [];
		dayz_myCursorTarget = _lever;
		_gates = nearestObjects [_lever, ["Hhedgehog_concrete","Concrete_Wall_EP1"], 15];
		if (count _gates > 0) then {
			_handle = dayz_myCursorTarget addAction ["Operate Gate", "dayz_code\external\keypad\fnc_keyPad\operate_gates.sqf", _lever, 1, false, true, "", ""];
			s_player_gateActions set [count s_player_gateActions,_handle];
		};
	};


/*	// Remove Object Custom removal test
	if((speed player <= 1) && (typeOf(cursortarget) in allbuildables_class) && _hasToolbox && _canDo && !remProc && !procBuild && !removeObject && (_ownerID == dayz_playerUID)) then {
		if (s_player_deleteBuild < 0) then {
			s_player_deleteBuild = player addAction [("<t color=""#FF0000"">" + (format[localize "str_actions_delete",_text]) +"</t>"), "dayz_code\actions\player_remove.sqf",cursorTarget, 1, true, true, "", ""];
		};
	} else {
		player removeAction s_player_deleteBuild;
		s_player_deleteBuild = -1;
	};
*/

	// Enter Code to Operate Gates Action
	if((speed player <= 1) && !keyValid && (typeOf(cursortarget) == "Infostand_2_EP1") && cursorTarget distance player < 5 && _canDo) then {
		if (s_player_enterCode < 0) then {
			s_player_enterCode = player addaction [("<t color=""#4DFF0D"">" + ("Enter Key Code to Operate Gate") +"</t>"),"dayz_code\external\keypad\fnc_keyPad\enterCode.sqf","",5,false,true,"",""];
		};
	} else {
		player removeAction s_player_enterCode;
		s_player_enterCode = -1;
	};

	// remove object
	if((speed player <= 1) && (typeOf(cursortarget) in allbuildables_class) && (_ownerID == dayz_playerUID)) then {
				if (s_player_codeObject < 0) then {
//				s_player_codeObject = player addaction [("<t color=""#8E11F5"">" + ("Enter Code of Object to remove") +"</t>"),"dayz_code\external\keypad\fnc_keyPad\enterCode.sqf","",5,false,true,"",""];
				s_player_codeObject = player addAction [("<t color=""#FF0000"">" + (format[localize "str_actions_delete",_text]) +"</t>"), "dayz_code\actions\player_remove.sqf",cursorTarget, 1, true, true, "", ""];
			};
	} else {
		player removeAction s_player_codeObject;
		s_player_codeObject = -1;
	};
/*	
	// Remove Object from code
	if((typeOf(cursortarget) in allbuildables_class) && _canDo && removeObject && !procBuild && !remProc) then {
		_validObject = cursortarget getVariable ["validObject",false];
		if (_validObject) then {
			if (s_player_codeRemove < 0) then {
				s_player_codeRemove = player addAction [format[localize "str_actions_delete",_text], "dayz_code\actions\player_remove.sqf",cursorTarget, 1, true, true, "", ""];
			};
		} else {
			player removeAction s_player_codeRemove;
			s_player_codeRemove = -1;
		};
	} else {
		player removeAction s_player_codeRemove;
		s_player_codeRemove = -1;
	};
*/
	// Disarm Booby Trap Action
	if(_hasToolbox && _canDo && !remProc && !procBuild && (cursortarget iskindof "Grave" && cursortarget distance player < 2.5 && !(cursortarget iskindof "Body" || cursortarget iskindof "GraveCross1" || cursortarget iskindof "GraveCross2" || cursortarget iskindof "GraveCrossHelmet" || cursortarget iskindof "Land_Church_tomb_1" || cursortarget iskindof "Land_Church_tomb_2" || cursortarget iskindof "Land_Church_tomb_3" || cursortarget iskindof "Mass_grave"))) then {
		if (s_player_disarmBomb < 0) then {
			s_player_disarmBomb = player addaction [("<t color=""#F01313"">" + ("Disarm Bomb") +"</t>"),"dayz_code\actions\player_disarmBomb.sqf","",1,true,true,"", ""];
		};
	} else {
		player removeAction s_player_disarmBomb;
		s_player_disarmBomb = -1;
	};
	
// ------------------------------------------------------------------------kikyou2 Edit Button Start---------------------------------------------------------------------
	if((typeOf(cursortarget) == "Infostand_2_EP1") && _canDo && !procBuild && !remProc && (_ownerID == dayz_playerUID)) then {
		if (true) then {
			if (s_player_codeEdit < 0) then {
				s_player_codeEdit = player addaction [("<t color=""#00ffff"">" + ("Edit Code") +"</t>"),"dayz_code\external\keypad\fnc_keyPad\editCode.sqf"];
			};
		} else {
			player removeAction s_player_codeEdit;
			s_player_codeEdit = -1;
		};
	} else {
		player removeAction s_player_codeEdit;
		s_player_codeEdit = -1;
	};
// ------------------------------------------------------------------------kikyou2 Edit Button End-----------------------------------------------------------------------
//##### BASE BUILDING 1.2 Custom Actions (CROSSHAIR HAS A TARGET) #####
// ##### END #####

	//Allow player to delete objects
	_player_deleteBuild = false;
	if((_isWreck or (_isRemovable and ("ItemCrowbar" in _itemsPlayer))) and _hasToolbox and _isAlive) then {
	_player_deleteBuild = true;
};			
		
	
	if(_player_deleteBuild) then {
		if (s_player_deleteBuild < 0) then {
			s_player_deleteBuild = player addAction [format[localize "str_actions_delete",_text], "dayz_code\actions\remove.sqf",_cursorTarget, 1, true, true, "", ""];
		};
	} else {
		player removeAction s_player_deleteBuild;
		s_player_deleteBuild = -1;
	};
	
	// Allow Owner to lock and unlock vehicle  
	if(_isVehicle and _isAlive and !_isMan and _ownerID != "0") then {
		if (s_player_lockUnlock_crtl < 0) then {
			_hasKey = _ownerID in _temp_keys;
			_oldOwner = (_ownerID == dayz_playerUID);
			if(locked _cursorTarget) then {
				if(_hasKey or _oldOwner) then {
					_Unlock = player addAction [format["Unlock %1",_text], "\z\addons\dayz_code\actions\unlock_veh.sqf",_cursorTarget, 2, true, true, "", ""];
					s_player_lockunlock set [count s_player_lockunlock,_Unlock];
					s_player_lockUnlock_crtl = 1;
				} else {
					_Unlock = player addAction ["<t color='#ff0000'>Vehicle Locked</t>", "",_cursorTarget, 2, true, true, "", ""];
					s_player_lockunlock set [count s_player_lockunlock,_Unlock];
					s_player_lockUnlock_crtl = 1;
				};
			} else {
				if(_hasKey or _oldOwner) then {
					_lock = player addAction [format["Lock %1",_text], "\z\addons\dayz_code\actions\lock_veh.sqf",_cursorTarget, 1, true, true, "", ""];
					s_player_lockunlock set [count s_player_lockunlock,_lock];
					s_player_lockUnlock_crtl = 1;
				};
			};
		};
		 
	} else {
		{player removeAction _x} forEach s_player_lockunlock;s_player_lockunlock = [];
		s_player_lockUnlock_crtl = -1;
	};

	if(DZE_AllowForceSave) then {
		//Allow player to force save
		if((_isVehicle or _isTent) and !_isMan) then {
			if (s_player_forceSave < 0) then {
				s_player_forceSave = player addAction [format[localize "str_actions_save",_text], "\z\addons\dayz_code\actions\forcesave.sqf",_cursorTarget, 1, true, true, "", ""];
			};
		} else {
			player removeAction s_player_forceSave;
			s_player_forceSave = -1;
		};
	};
	
	If(DZE_AllowCargoCheck) then {
		if((_isVehicle or _isTent or _isnewstorage) and _isAlive and !_isMan) then {
			if (s_player_checkGear < 0) then {
				s_player_checkGear = player addAction ["Cargo Check", "\z\addons\dayz_code\actions\cargocheck.sqf",_cursorTarget, 1, true, true, "", ""];
			};
		} else {
			player removeAction s_player_checkGear;
			s_player_checkGear = -1;
		};
	};
	

	//flip vehicle small vehicles by your self and all other vehicles with help nearby
	if (_isVehicle and !_canmove and _isAlive and (player distance _cursorTarget >= 2) and (count (crew _cursorTarget))== 0 and ((vectorUp _cursorTarget) select 2) < 0.5) then {
		_playersNear = {isPlayer _x} count (player nearEntities ["CAManBase", 6]);
		if(_isVehicletype or (_playersNear >= 2)) then {
			if (s_player_flipveh  < 0) then {
				s_player_flipveh = player addAction [format[localize "str_actions_flipveh",_text], "\z\addons\dayz_code\actions\player_flipvehicle.sqf",_cursorTarget, 1, true, true, "", ""];		
			};	
		};
	} else {
		player removeAction s_player_flipveh;
		s_player_flipveh = -1;
	};
	
	//Allow player to fill jerrycan
	if(_hasFuelE and _isFuel) then {
		if (s_player_fillfuel < 0) then {
			s_player_fillfuel = player addAction [localize "str_actions_self_10", "\z\addons\dayz_code\actions\jerry_fill.sqf",[], 1, false, true, "", ""];
		};
	} else {
		player removeAction s_player_fillfuel;
		s_player_fillfuel = -1;
	};
	
	// Human Gut animal or zombie
	if (!alive _cursorTarget and (_isAnimal or _isZombie) and _hasKnife) then {
		_isHarvested = _cursorTarget getVariable["meatHarvested",false];
		if (s_player_butcher < 0 and !_isHarvested) then {
			if(_isZombie) then {
				s_player_butcher = player addAction ["Gut Zombie", "\z\addons\dayz_code\actions\gather_zparts.sqf",_cursorTarget, 3, true, true, "", ""];
			} else {
				s_player_butcher = player addAction [localize "str_actions_self_04", "\z\addons\dayz_code\actions\gather_meat.sqf",_cursorTarget, 3, true, true, "", ""];
			};
		};
		
	} else {
		player removeAction s_player_butcher;
		s_player_butcher = -1;
	};
	
	//Fireplace Actions check
	if (inflamed _cursorTarget and _hasRawMeat) then {
		if (s_player_cook < 0) then {
			s_player_cook = player addAction [localize "str_actions_self_05", "\z\addons\dayz_code\actions\cook.sqf",_cursorTarget, 3, true, true, "", ""];
		};
	} else {
		player removeAction s_player_cook;
		s_player_cook = -1;
	};
	if (inflamed _cursorTarget and (_hasbottleitem and _hastinitem)) then {
		if (s_player_boil < 0) then {
			s_player_boil = player addAction [localize "str_actions_boilwater", "\z\addons\dayz_code\actions\boil.sqf",_cursorTarget, 3, true, true, "", ""];
		};
	} else {
		player removeAction s_player_boil;
		s_player_boil = -1;
	};
	
	if(_cursorTarget == dayz_hasFire) then {
		if ((s_player_fireout < 0) and !(inflamed _cursorTarget) and (player distance _cursorTarget < 3)) then {
			s_player_fireout = player addAction [localize "str_actions_self_06", "\z\addons\dayz_code\actions\fire_pack.sqf",_cursorTarget, 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_fireout;
		s_player_fireout = -1;
	};
	
	//Packing my tent
	if(_cursorTarget isKindOf "TentStorage" and _ownerID == dayz_playerUID) then {
		if ((s_player_packtent < 0) and (player distance _cursorTarget < 3)) then {
			s_player_packtent = player addAction [localize "str_actions_self_07", "\z\addons\dayz_code\actions\tent_pack.sqf",_cursorTarget, 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_packtent;
		s_player_packtent = -1;
	};

	//Allow owner to unlock vault
	if((_typeOfCursorTarget == "VaultStorageLocked" or _typeOfCursorTarget == "VaultStorage") and _ownerID != "0" and (player distance _cursorTarget < 3)) then {
		if (s_player_unlockvault < 0) then {
			if(_typeOfCursorTarget == "VaultStorageLocked") then {
				if(_ownerID == dayz_combination or _ownerID == dayz_playerUID) then {
					_combi = player addAction ["Open Safe", "\z\addons\dayz_code\actions\vault_unlock.sqf",_cursorTarget, 0, false, true, "",""];
				} else {
					_combi = player addAction ["Unlock Safe", "\z\addons\dayz_code\actions\vault_combination_1.sqf",_cursorTarget, 0, false, true, "",""];
				};
				s_player_combi set [count s_player_combi,_combi];
				s_player_unlockvault = 1;
			} else {
				if(_ownerID != dayz_combination and _ownerID != dayz_playerUID) then {
					_combi = player addAction ["Enter Combo", "\z\addons\dayz_code\actions\vault_combination_1.sqf",_cursorTarget, 0, false, true, "",""];
					s_player_combi set [count s_player_combi,_combi];
					s_player_unlockvault = 1;
				};
			};
		};
	} else {
		{player removeAction _x} forEach s_player_combi;s_player_combi = [];
		s_player_unlockvault = -1;
	};

	//Allow owner to pack vault
	if(_typeOfCursorTarget == "VaultStorage" and _ownerID != "0" and (player distance _cursorTarget < 3)) then {

		if (s_player_lockvault < 0) then {
			if(_ownerID == dayz_combination or _ownerID == dayz_playerUID) then {
				s_player_lockvault = player addAction ["Lock Safe", "\z\addons\dayz_code\actions\vault_lock.sqf",_cursorTarget, 0, false, true, "",""];
			};
		};
		if (s_player_packvault < 0 and (_ownerID == dayz_combination or _ownerID == dayz_playerUID)) then {
			s_player_packvault = player addAction ["<t color='#ff0000'>Pack Safe</t>", "\z\addons\dayz_code\actions\vault_pack.sqf",_cursorTarget, 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_packvault;
		s_player_packvault = -1;
		player removeAction s_player_lockvault;
		s_player_lockvault = -1;
	};

	

    //Player Deaths
	if(_typeOfCursorTarget == "Info_Board_EP1") then {
		if ((s_player_information < 0) and (player distance _cursorTarget < 3)) then {
			s_player_information = player addAction ["Recent Deaths", "\z\addons\dayz_code\actions\list_playerDeaths.sqf",[], 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_information;
		s_player_information = -1;
	};
	
	//Fuel Pump
	if(_typeOfCursorTarget in dayz_fuelpumparray) then {	
		if ((s_player_fuelauto < 0) and (player distance _cursorTarget < 3)) then {
			
			// check if Generator_DZ is running within 30 meters
			_findNearestGens = nearestObjects [player, ["Generator_DZ"], 30];
			_findNearestGen = [];
			{
				if (alive _x and (_x getVariable ["GeneratorRunning", false])) then {
					_findNearestGen set [(count _findNearestGen),_x];
				};
			} foreach _findNearestGens;
			_IsNearRunningGen = count (_findNearestGen);
			
			// show that pump needs power if no generator nearby.
			if(_IsNearRunningGen > 0) then {
				s_player_fuelauto = player addAction ["Fill Vehicle", "\z\addons\dayz_code\actions\fill_nearestVehicle.sqf",[], 0, false, true, "",""];
			} else {
				s_player_fuelauto = player addAction ["<t color='#ff0000'>Needs Power</t>", "",[], 0, false, true, "",""];
			};
		};
	} else {
		player removeAction s_player_fuelauto;
		s_player_fuelauto = -1;
	};

	//Start Generator
	if(_cursorTarget isKindOf "Generator_DZ") then {
		if ((s_player_fillgen < 0) and (player distance _cursorTarget < 3)) then {
			
			// check if not running 
			if((_cursorTarget getVariable ["GeneratorRunning", false])) then {
				s_player_fillgen = player addAction ["Stop Generator", "\z\addons\dayz_code\actions\stopGenerator.sqf",_cursorTarget, 0, false, true, "",""];				
			} else {
			// check if not filled and player has jerry.
				if((_cursorTarget getVariable ["GeneratorFilled", false])) then {
					s_player_fillgen = player addAction ["Start Generator", "\z\addons\dayz_code\actions\fill_startGenerator.sqf",_cursorTarget, 0, false, true, "",""];
				} else {
					if("ItemJerrycan" in _magazinesPlayer) then {
						s_player_fillgen = player addAction ["Fill and Start Generator", "\z\addons\dayz_code\actions\fill_startGenerator.sqf",_cursorTarget, 0, false, true, "",""];
					};
				};
			};
		};
	} else {
		player removeAction s_player_fillgen;
		s_player_fillgen = -1;
	};
    //Sleep
	if(_cursorTarget isKindOf "TentStorage" and _ownerID == dayz_playerUID) then {
		if ((s_player_sleep < 0) and (player distance _cursorTarget < 3)) then {
			s_player_sleep = player addAction [localize "str_actions_self_sleep", "custom\player_sleep.sqf",cursorTarget, 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_sleep;
		s_player_sleep = -1;
	};
	//Dance At fire Place (A Little Fun P) Comment Out To Disable
    if (inflamed cursorTarget and _canDo) then {
            if (s_player_dance < 0) then {
            s_player_dance = player addAction ["Dance!","custom\dance.sqf",cursorTarget, 0, false, true, "",""];
        };
    } else {
        player removeAction s_player_dance;
        s_player_dance = -1;
    };
	//Repairing Vehicles
	if ((dayz_myCursorTarget != _cursorTarget) and _isVehicle and !_isMan and _hasToolbox and (damage _cursorTarget < 1) and !_isDisallowRepair) then {
		if (s_player_repair_crtl < 0) then {
			dayz_myCursorTarget = _cursorTarget;
			_menu = dayz_myCursorTarget addAction ["Repair Vehicle", "\z\addons\dayz_code\actions\repair_vehicle.sqf",_cursorTarget, 0, true, false, "",""];
			_menu1 = dayz_myCursorTarget addAction ["Salvage Vehicle", "\z\addons\dayz_code\actions\salvage_vehicle.sqf",_cursorTarget, 0, true, false, "",""];
			s_player_repairActions set [count s_player_repairActions,_menu];
			s_player_repairActions set [count s_player_repairActions,_menu1];
			s_player_repair_crtl = 1;
		} else {
			{dayz_myCursorTarget removeAction _x} forEach s_player_repairActions;s_player_repairActions = [];
			s_player_repair_crtl = -1;
		};
	};

	// All Traders
	if (_isMan and !_isPZombie and _traderType in serverTraders) then {
		
		if (s_player_parts_crtl < 0) then {

			// get humanity
			_humanity = player getVariable ["humanity",0];
			_traderMenu = call compile format["menu_%1;",_traderType];

			// diag_log ("TRADER = " + str(_traderMenu));
			
			_low_high = "low";
			_humanity_logic = false;
			if((_traderMenu select 2) == "friendly") then {
				_humanity_logic = (_humanity < -5000);
			};
			if((_traderMenu select 2) == "hostile") then {
				_low_high = "high";
				_humanity_logic = (_humanity > -5000);
			};
			if((_traderMenu select 2) == "hero") then {
				_humanity_logic = (_humanity < 5000);
			};
			if(_humanity_logic) then {
				_cancel = player addAction [format["Your humanity is too %1 this trader refuses to talk to you.",_low_high], "\z\addons\dayz_code\actions\trade_cancel.sqf",["na"], 0, true, false, "",""];
				s_player_parts set [count s_player_parts,_cancel];
			} else {
				
				// Static Menu
				{
					diag_log format["DEBUG TRADER: %1", _x];
					_buy = player addAction [format["Trade %1 %2 for %3 %4",(_x select 3),(_x select 5),(_x select 2),(_x select 6)], "\z\addons\dayz_code\actions\trade_items_wo_db.sqf",[(_x select 0),(_x select 1),(_x select 2),(_x select 3),(_x select 4),(_x select 5),(_x select 6)], (_x select 7), true, true, "",""];
					s_player_parts set [count s_player_parts,_buy];
				
				} forEach (_traderMenu select 1);
				// Database menu 
			    _buy = player addAction ["Trader Menu", "traders\show_dialog.sqf",(_traderMenu select 0), 99, true, false, "",""];
                s_player_parts set [count s_player_parts,_buy];
				// Add static metals trader options under sub menu
				_metals_trader = player addAction ["Trade Metals", "\z\addons\dayz_code\actions\trade_metals.sqf",["na"], 0, true, false, "",""];
				s_player_parts set [count s_player_parts,_metals_trader];

			};
			s_player_parts_crtl = 1;
			
		};
	} else {
		{player removeAction _x} forEach s_player_parts;s_player_parts = [];
		s_player_parts_crtl = -1;
	};

	if (_isMan and !_isAlive and !_isZombie) then {
		if (s_player_studybody < 0) then {
			s_player_studybody = player addAction [localize "str_action_studybody", "custom\study_body.sqf",_cursorTarget, 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_studybody;
		s_player_studybody = -1;
	};
    if (_isMan and !_isAlive and !_isZombie and !_isAnimal) then {
    if (s_clothes < 0) then {
            s_clothes = player addAction [("<t color=""#FF0000"">" + ("Take Skin") + "</t>"), "custom\clothes.sqf",cursorTarget, 1, false, true, "",""];
        };
    } else {
        player removeAction s_clothes;
        s_clothes = -1;
    };
	// KNOCKOUT Script by Player2
    _unconscious =    cursorTarget getVariable ["NORRN_unconscious", false];
 
    if (_isMan and _isAlive and !_isZombie and _canDo and !_unconscious) then {
        if (s_player_knockout < 0) then {
            s_player_knockout = player addAction [("<t color=""#FF9800"">" + ("Knockout!") + "</t>"), "custom\knockout.sqf",cursorTarget, 0, false, true, "",""];
        };
    } else {
        player removeAction s_player_knockout;
        s_player_knockout = -1;
    };
	if(dayz_tameDogs) then {
		
		//Dog
		if (_isDog and _isAlive and (_hasRawMeat) and _ownerID == "0" and player getVariable ["dogID", 0] == 0) then {
			if (s_player_tamedog < 0) then {
				s_player_tamedog = player addAction [localize "str_actions_tamedog", ""dayz_code\actions\tame_dog.sqf"", _cursorTarget, 1, false, true, "", ""];
			};
		} else {
			player removeAction s_player_tamedog;
			s_player_tamedog = -1;
		};
		if (_isDog and _ownerID == dayz_characterID and _isAlive) then {
			_dogHandle = player getVariable ["dogID", 0];
			if (s_player_feeddog < 0 and _hasRawMeat) then {
				s_player_feeddog = player addAction [localize "str_actions_feeddog","\z\addons\dayz_code\actions\dog\feed.sqf",[_dogHandle,0], 0, false, true,"",""];
			};
			if (s_player_waterdog < 0 and "ItemWaterbottle" in _magazinesPlayer) then {
				s_player_waterdog = player addAction [localize "str_actions_waterdog","\z\addons\dayz_code\actions\dog\feed.sqf",[_dogHandle,1], 0, false, true,"",""];
			};
			if (s_player_staydog < 0) then {
				_lieDown = _dogHandle getFSMVariable "_actionLieDown";
				if (_lieDown) then { _text = "str_actions_liedog"; } else { _text = "str_actions_sitdog"; };
				s_player_staydog = player addAction [localize _text,"\z\addons\dayz_code\actions\dog\stay.sqf", _dogHandle, 5, false, true,"",""];
			};
			if (s_player_trackdog < 0) then {
				s_player_trackdog = player addAction [localize "str_actions_trackdog","\z\addons\dayz_code\actions\dog\track.sqf", _dogHandle, 4, false, true,"",""];
			};
			if (s_player_barkdog < 0) then {
				s_player_barkdog = player addAction [localize "str_actions_barkdog","\z\addons\dayz_code\actions\dog\speak.sqf", _cursorTarget, 3, false, true,"",""];
			};
			if (s_player_warndog < 0) then {
				_warn = _dogHandle getFSMVariable "_watchDog";
				if (_warn) then { _text = "Quiet"; _warn = false; } else { _text = "Alert"; _warn = true; };
				s_player_warndog = player addAction [format[localize "str_actions_warndog",_text],"\z\addons\dayz_code\actions\dog\warn.sqf",[_dogHandle, _warn], 2, false, true,"",""];		
			};
			if (s_player_followdog < 0) then {
				s_player_followdog = player addAction [localize "str_actions_followdog","\z\addons\dayz_code\actions\dog\follow.sqf",[_dogHandle,true], 6, false, true,"",""];
			};
		} else {
			player removeAction s_player_feeddog;
			s_player_feeddog = -1;
			player removeAction s_player_waterdog;
			s_player_waterdog = -1;
			player removeAction s_player_staydog;
			s_player_staydog = -1;
			player removeAction s_player_trackdog;
			s_player_trackdog = -1;
			player removeAction s_player_barkdog;
			s_player_barkdog = -1;
			player removeAction s_player_warndog;
			s_player_warndog = -1;
			player removeAction s_player_followdog;
			s_player_followdog = -1;
		};
	};

} else {
	//Engineering
	{dayz_myCursorTarget removeAction _x} forEach s_player_repairActions;s_player_repairActions = [];
	s_player_repair_crtl = -1;

	{player removeAction _x} forEach s_player_combi;s_player_combi = [];
		
	dayz_myCursorTarget = objNull;

	{player removeAction _x} forEach s_player_parts;s_player_parts = [];
	s_player_parts_crtl = -1;

	{player removeAction _x} forEach s_player_lockunlock;s_player_lockunlock = [];
	s_player_lockUnlock_crtl = -1;

	player removeAction s_player_checkGear;
	s_player_checkGear = -1;
	// ### BASE BUILDING 1.2 ### For gates: 
// ### START ###
	{dayz_myCursorTarget removeAction _x} forEach s_player_gateActions;s_player_gateActions = [];
	dayz_myCursorTarget = objNull;	
// ### BASE BUILDING 1.2 ### For gates: 
// ### END ###
	//Others
	player removeAction s_player_forceSave;
	s_player_forceSave = -1;
	player removeAction s_player_flipveh;
	s_player_flipveh = -1;
	player removeAction s_player_deleteBuild;
	s_player_deleteBuild = -1;
	// ### BASE BUILDING 1.2 ### Add in these: 
// ### START ###
	player removeAction s_player_codeRemove;
	s_player_codeRemove = -1;
	player removeAction s_player_forceSave;
	s_player_forceSave = -1;
	player removeAction s_player_disarmBomb;
	s_player_disarmBomb = -1;
	player removeAction s_player_codeObject;
	s_player_codeObject = -1;
	player removeAction s_player_enterCode;
	s_player_enterCode = -1;
	player removeAction s_player_smeltRecipes;
	s_player_smeltRecipes = -1;
	player removeAction s_player_smeltItems;
	s_player_smeltItems = -1;
// ------------------------------------------------------------------------kikyou2 Edit Button Start---------------------------------------------------------------------
	player removeAction s_player_codeEdit;
	s_player_codeEdit = -1;
// ------------------------------------------------------------------------kikyou2 Edit Button End-----------------------------------------------------------------------
// ### BASE BUILDING 1.2 ### Add in these:
// ### END ###
	player removeAction s_player_butcher;
	s_player_butcher = -1;
	player removeAction s_player_cook;
	s_player_cook = -1;
	player removeAction s_player_boil;
	s_player_boil = -1;
	player removeAction s_player_fireout;
	s_player_fireout = -1;
	player removeAction s_player_packtent;
	s_player_packtent = -1;
	player removeAction s_player_fillfuel;
	s_player_fillfuel = -1;
	player removeAction s_player_studybody;
	s_player_studybody = -1;
	//Custom Addons
	player removeAction s_clothes;
    s_clothes = -1;
	player removeAction s_player_knockout;
	s_player_knockout = -1;
	//Dog
	player removeAction s_player_tamedog;
	s_player_tamedog = -1;
	player removeAction s_player_feeddog;
	s_player_feeddog = -1;
	player removeAction s_player_waterdog;
	s_player_waterdog = -1;
	player removeAction s_player_staydog;
	s_player_staydog = -1;
	player removeAction s_player_trackdog;
	s_player_trackdog = -1;
	player removeAction s_player_barkdog;
	s_player_barkdog = -1;
	player removeAction s_player_warndog;
	s_player_warndog = -1;
	player removeAction s_player_followdog;
	s_player_followdog = -1;
    
    // vault
	player removeAction s_player_unlockvault;
	s_player_unlockvault = -1;
	player removeAction s_player_packvault;
	s_player_packvault = -1;
	player removeAction s_player_lockvault;
	s_player_lockvault = -1;

	player removeAction s_player_information;
	s_player_information = -1;
	player removeAction s_player_fillgen;
	s_player_fillgen = -1;
	player removeAction s_player_fuelauto;
	s_player_fuelauto = -1;
};



//Dog actions on player self
_dogHandle = player getVariable ["dogID", 0];
if (_dogHandle > 0) then {
	_dog = _dogHandle getFSMVariable "_dog";
	_ownerID = "0";
	if (!isNull cursorTarget) then { _ownerID = cursorTarget getVariable ["characterID","0"]; };
	if (_canDo and !_inVehicle and alive _dog and _ownerID != dayz_characterID) then {
		if (s_player_movedog < 0) then {
			s_player_movedog = player addAction [localize "str_actions_movedog", "\z\addons\dayz_code\actions\dog\move.sqf", player getVariable ["dogID", 0], 1, false, true, "", ""];
		};
		if (s_player_speeddog < 0) then {
			_text = "Walk";
			_speed = 0;
			if (_dog getVariable ["currentSpeed",1] == 0) then { _speed = 1; _text = "Run"; };
			s_player_speeddog = player addAction [format[localize "str_actions_speeddog", _text], "\z\addons\dayz_code\actions\dog\speed.sqf",[player getVariable ["dogID", 0],_speed], 0, false, true, "", ""];
		};
		if (s_player_calldog < 0) then {
			s_player_calldog = player addAction [localize "str_actions_calldog", "\z\addons\dayz_code\actions\dog\follow.sqf", [player getVariable ["dogID", 0], true], 2, false, true, "", ""];
		};
	};
} else {
	player removeAction s_player_movedog;		
	s_player_movedog =		-1;
	player removeAction s_player_speeddog;
	s_player_speeddog =		-1;
	player removeAction s_player_calldog;
	s_player_calldog = 		-1;
};
// ---------------------------------------SUICIDE START------------------------------------
 
private ["_handGun"];
_handGun = currentWeapon player;
if ((_handGun in ["glock17_EP1","M9","M9SD","Makarov","MakarovSD","revolver_EP1","UZI_EP1","Sa61_EP1","Colt1911"]) && (player ammo _handGun > 0)) then {
    hasSecondary = true;
} else {
    hasSecondary = false;
};
if((speed player <= 1) && hasSecondary && _canDo) then {
    if (s_player_suicide < 0) then {
        s_player_suicide = player addaction[("<t color=""#ff0000"">" + ("Commit Suicide like a boss") +"</t>"),"custom\suicide.sqf",_handGun,0,false,true,"", ""];
    };
} else {
    player removeAction s_player_suicide;
    s_player_suicide = -1;
};
 
// ---------------------------------------SUICIDE END------------------------------------
 