TraderDialogCatList = 12000;
TraderDialogItemList = 12001;
TraderDialogBuyPrice = 12002;
TraderDialogSellPrice = 12003;

TraderCurrentCatIndex = -1;
TraderCatList = -1;
TraderItemList = -1;

TraderDialogLoadItemList = {
	private ["_index", "_trader_id", "_activatingPlayer"];
	TraderItemList = -1;
	_index = _this select 0;

	if (_index < 0 or TraderCurrentCatIndex == _index) exitWith {};
	TraderCurrentCatIndex = _index;

	_trader_id = TraderCatList select _index;
	_activatingPlayer = player;

	lbClear TraderDialogItemList;
	ctrlSetText [TraderDialogBuyPrice, ""];
	ctrlSetText [TraderDialogSellPrice, ""];

	lbAdd [TraderDialogItemList, "Loading items..."];

	dayzTraderMenuResult = call compile format["tcacheBuy_%1;",_trader_id];

	if(isNil "dayzTraderMenuResult") then {
		dayzTraderMenu = [_activatingPlayer,_trader_id];
		publicVariableServer  "dayzTraderMenu";
		waitUntil {!isNil "dayzTraderMenuResult"};
	};

	lbClear TraderDialogItemList;
	_item_list = [];
	{
		private ["_header", "_item", "_name", "_type", "_textPart", "_qty", "_buy", "_bqty", "_bname", "_btype", "_btextCurrency", "_sell", "_sqty", "_sname", "_stype", "_stextCurrency", "_order", "_order", "_afile", "_File", "_count", "_bag", "_bagclass", "_index", "_image"];
		_header = _x select 0; // "TRD"
		_item = _x select 1;
		_name = _item select 0;
		_type = _item select 1;
		switch (true) do { 
			case (_type == 1): { 
				_type = "CfgMagazines";
			}; 
			case (_type == 2): { 
				_type = "CfgVehicles";
			}; 
			case (_type == 3): { 
				_type = "CfgWeapons";
			}; 
		}; 
		// Display Name of item
		_textPart =	getText(configFile >> _type >> _name >> "displayName");

		// Total in stock
		_qty = _x select 2;

		// Buy Data from array
		_buy = _x select 3;	
		_bqty = _buy select 0;
		_bname = _buy select 1;
		_btype = _buy select 2;
		switch(true)do{ 
			case (_btype == 1): { 
				_btype = "CfgMagazines";
			}; 
			case (_btype == 2): { 
				_btype = "CfgVehicles";
			}; 
			case (_btype == 3): { 
				_btype = "CfgWeapons";
			}; 
		}; 

		// Display Name of buy item
		_btextCurrency = getText(configFile >> _btype >> _bname >> "displayName");

		_sell = _x select 4;
		_sqty = _sell select 0;
		_sname = _sell select 1;
		_stype = _sell select 2;
		switch(true)do{ 
			case (_stype == 1): { 
				_stype = "CfgMagazines";
			}; 
			case (_stype == 2): { 
				_stype = "CfgVehicles";
			}; 
			case (_stype == 3): { 
				_stype = "CfgWeapons";
			}; 
		}; 
		// Display Name of sell item
		_stextCurrency =	getText(configFile >> _stype >> _sname >> "displayName");

		// Menu sort order
		_order = _x select 5;

		// Action file to use for trade
		_afile = _x select 7;
		_File = "\z\addons\dayz_code\actions\" + _afile + ".sqf";
		
		_count = 0;
		if(_type == "CfgVehicles") then {
			if (_afile == "trade_backpacks") then {
				_bag = unitBackpack player;
				_bagclass = typeOf _bag;
				if(_name == _bagclass) then {
					_count = 1;
				};
			} else {
				_count = {(typeOf _x) == _name} count (nearestObjects [player, [_name], 20]);
			}
		};

		if(_type == "CfgMagazines") then {
			_count = {_x == _name} count magazines player;
		};

		if(_type == "CfgWeapons") then {
			_count = {_x == _name} count weapons player;
		};

		_index = lbAdd [TraderDialogItemList, format["%1 (%2)", _textPart, _name]];

		if (_count > 0) then {
			lbSetColor [TraderDialogItemList, _index, [0, 1, 0, 1]];
		};

		_image = getText(configFile >> _type >> _name >> "picture");
		lbSetPicture [TraderDialogItemList, _index, _image];

		_item_list set [count _item_list, [
			_name,
			_textPart,
			_bqty,
			_bname,
			_btextCurrency,
			_sqty,
			_sname,
			_stextCurrency,
			_header,
			_File
		]];
	} forEach dayzTraderMenuResult;
	TraderItemList = _item_list;
};

TraderDialogShowPrices = {
	private ["_index", "_item"];
	_index = _this select 0;
	if (_index < 0) exitWith {};
	while {count TraderItemList < 1} do { sleep 1; };
	_item = TraderItemList select _index;
	ctrlSetText [TraderDialogBuyPrice, format["%1 %2", _item select 2, _item select 4]];
	ctrlSetText [TraderDialogSellPrice, format["%1 %2", _item select 5, _item select 7]];
};

TraderDialogBuy = {
	private ["_index", "_item", "_data"];
	_index = _this select 0;
	if (_index < 0) exitWith {
		cutText ["Trading canceled." , "PLAIN DOWN"];
	};
	_item = TraderItemList select _index;
	_data = [_item select 0, _item select 3, 1, _item select 2, "buy", _item select 4, _item select 1, _item select 8];
	[0, player, '', _data] execVM (_item select 9);
	TraderItemList = -1;
};

TraderDialogSell = {
	private ["_index", "_item", "_data"];
	_index = _this select 0;
	if (_index < 0) exitWith {
		cutText ["Trading canceled." , "PLAIN DOWN"];
	};
	_item = TraderItemList select _index;
	_data = [_item select 6, _item select 0, _item select 5, 1, "sell", _item select 1, _item select 7, _item select 8];
	[0, player, '', _data] execVM (_item select 9);
	TraderItemList = -1;
};