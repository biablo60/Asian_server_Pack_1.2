private ["_vehicle", "_vehicle_refuel_id"];
//Awesomely Edited by Seven, Then modified by Muddr
_vehicle = objNull;
diag_log "Running ""kh_actions"".";

_distance = 15; // Distance from object to display Refuel Message
_amount= 0.01; // Amount of fuel to add per loop. Default was 0.005

while {true} do
{
    if (!isNull player) then {
        private ["_currentVehicle", "_isNearFeed", "_countFuel"];
_currentVehicle = vehicle player;
// Refuel Trucks
_countFuel = (count ((position _currentVehicle) nearObjects ["UralRefuel_TK_EP1_DZ", _distance]));
_countFuel = _countFuel + (count ((position _currentVehicle) nearObjects ["V3S_Refuel_TK_GUE_EP1_DZ", _distance]));
_countFuel = _countFuel + (count ((position _currentVehicle) nearObjects ["KamazRefuel_DZ", _distance]));
_countFuel = _countFuel + (count ((position _currentVehicle) nearObjects ["MtvrRefuel_DES_EP1_DZ", _distance]));
// Fuel Tanks/Stations
_countFuel = (count ((position _currentVehicle) nearObjects ["Land_Fuel_tank_big", _distance]));
_countFuel = _countFuel + (count ((position _currentVehicle) nearObjects ["Land_A_FuelStation_Feed", _distance]));
_countFuel = _countFuel + (count ((position _currentVehicle) nearObjects ["Land_Ind_TankSmall", _distance]));
_countFuel = _countFuel + (count ((position _currentVehicle) nearObjects ["Land_Ind_TankSmall2", _distance]));
_countFuel = _countFuel + (count ((position _currentVehicle) nearObjects ["Land_Ind_TankSmall2_EP1", _distance]));
_countFuel = _countFuel + (count ((position _currentVehicle) nearObjects ["Land_fuel_tank_stairs", _distance]));
_isNearFeed = _countFuel > 0;
        if (_vehicle != _currentVehicle) then {
            if (!isNull _vehicle) then {
                _vehicle removeAction _vehicle_refuel_id;
                _vehicle = objNull;
            };
 
            if (_currentVehicle != player && _isNearFeed && !(_currentVehicle isKindof "Bicycle")) then {
                _vehicle = _currentVehicle;
 
                _vehicle_refuel_id = _vehicle addAction ["Refuel", "custom\kh_vehicle_refuel.sqf", [_amount], -1, false, true, "", "vehicle _this == _target && local _target"];
            };
        };
   
        if (!_isNearFeed) then {
            _vehicle removeAction _vehicle_refuel_id;
            _vehicle = objNull;
        };
    };
    sleep 2;
}