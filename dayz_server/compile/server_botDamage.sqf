
_unit = (_this select 0) select 0;
_hit = (_this select 0) select 1;
_damage = (_this select 0) select 2;
_source = (_this select 0) select 3;

_ammo = (_this select 0) select 4;
_type = [_damage,_ammo] call fnc_usec_damageType;

_isMinor = (_hit in USEC_MinorWounds);
_isHeadHit = (_hit == "head_hit");
_inVehicle = (vehicle _unit != _unit);

_unconscious = _unit getVariable ["NORRN_unconscious", false];


diag_log ("DAMAGE: " + str(_this));



// Humanity
//diag_log("Humanity changes");
//if (_hit == "") then {
//	if ((_source != _unit) and _sourceIsPlayer) then {
//		_canHitFree = 	player getVariable ["freeTarget",false];
//		_isBandit = 	(typeOf player) == "Bandit1_DZ";
//		if (!_canHitFree and !_isBandit) then {
//			_myKills = 		200 - (((_unit getVariable ["humanKills",0]) / 30) * 100);
			//Process Morality Hit
//			_humanityHit = -(_myKills * _damage);
//			//TODO: _humanity hit
//		};
//	};
//};



//PVP Damage
//diag_log("PVP Damage");
_bloodLoss = 0;
_scale = 200;
if (_damage > 0.4) then {
	if (_ammo != "zombie") then {
		_scale = _scale + 50;
	};
	if (_isHeadHit) then {
		_scale = _scale + 500;
	};
	if ((isPlayer _source) and !(_source != _unit)) then {
		_scale = _scale + 800;
		if (_isHeadHit) then {
			_scale = _scale + 500;
		};
	};
	switch (_type) do {
		case 1: {_scale = _scale + 200};
		case 2: {_scale = _scale + 200};
	};
	_bloodLoss = round((_damage * _scale));
	//r_player_blood = r_player_blood - (_damage * _scale);
};

//PVP Damage Values to be done


if (_damage > 0.4) then {	//0.25
	/*
		BLEEDING
	*/		
	_wound = _hit call fnc_usec_damageGetWound;
	_isHit = _unit getVariable[_wound,false];
	_rndPain = 		(random 10);
	_rndInfection = (random 1000);
	_hitPain = 		(_rndPain < _damage);
	if ((_isHeadHit) or (_damage > 1.2 and _hitPain)) then {
		_hitPain = true;
		};
	_hitInfection = (_rndInfection < 1);
	//player sidechat format["HitPain: %1, HitInfection %2 (Damage: %3)",_rndPain,_rndInfection,_damage]; //r_player_infected
	if (_isHit) then {
		//Make hit worse
		_bloodLoss = _bloodLoss - 50;
		};
	if (_hitInfection) then {
		//Set Infection if not already
		_unit setVariable["USEC_infected",true,true];
		};
	if (_hitPain) then {
		//Set Pain if not already
		_unit setVariable["USEC_inPain",true,true];
		};

	if ((_damage > 1.5) and _isHeadHit) then {
		_id = [_unit,_source,"shothead"] spawn server_botDied;
		// TODO: Bot Death
		};

	if(!_isHit) then {
		//Create Wound
		_unit setVariable[_wound,true,true];
		[_unit,_wound,_hit] spawn fnc_usec_damageBleed;
		usecBleed = [_unit,_wound,_hit];
		publicVariable "usecBleed";

		//Set Injured if not already
		_isInjured = _unit getVariable["USEC_injured",false];
		if (!_isInjured) then {
			_unit setVariable["USEC_injured",true,true];
		};
	};
};

if (_type == 1) then {
	/*
		BALISTIC DAMAGE		
	*/		

	if (_damage > 4) then {
		//serious ballistic damage
		_id = [_unit,_source,"explosion"] spawn server_botDied;
	} else {
		if (_damage > 2) then {
			_isCardiac = _unit getVariable["USEC_isCardiac",false];
			if (!_isCardiac) then {
				_unit setVariable["USEC_isCardiac",true,true];
			};
		};
	};
};
if (_type == 2) then {
	/*
		HIGH CALIBRE
	*/
	if (_damage > 4) then {
		//serious ballistic damage
		_id = [_unit,_source,"shotheavy"] spawn server_botDied;
	} else {
		if (_damage > 2) then {
			_isCardiac = _unit getVariable["USEC_isCardiac",false];
			if (!_isCardiac) then {
				_unit setVariable["USEC_isCardiac",true,true];
			};
		};
	};
};

if (!_unconscious and !_isMinor and ((_damage > 2) or ((_damage > 0.5) and _isHeadHit))) then {
	//set unconsious
	[_unit,_damage] call fnc_usec_damageUnconscious;
};



//Reduce Bots Health
_oldBlood = _unit getVariable "USEC_BloodQty";
_unitBlood = _oldBlood - _bloodLoss;
//diag_log("Bot Damage");
//diag_log("Blood Lost " + str(_bloodLoss));
//diag_log("Current Blood " + str(_unitBlood));

if (_unitBlood <= 0 ) then {
	_unit setVariable["USEC_BloodQty",0,true];
	_unit setVariable["USEC_lowBlood",false,true];
	_id = [_unit,_source,"blood"] spawn server_botDied;
	} else {
		_unit setVariable["USEC_BloodQty",_unitBlood,true];
		_unit setVariable["USEC_lowBlood",true,true];
		};