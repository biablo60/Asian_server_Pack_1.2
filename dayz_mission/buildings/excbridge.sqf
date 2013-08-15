// Excelsior Bridge
// The land_nav_pier_m_2 is the double fenced bridge floor.  These can be changed to land_nav_pier_m_1 and spun 180 if you wanted only 1 fence.
 
// Installation
// Make sure to make a folder inside the mission file called "buildings" and save this file in there as "excbridge.sqf"
// Then add the following line as the VERY LAST line in in the "init.sqf" file.
// [] execVM "buildings\excbridge.sqf";
 
// Props to Rossymond for pointing out the new install method.
 
// Excelsior
// Server: Death DealerZ - DayzChernarus
 
if (isServer) then {
 
_vehicle_0 = objNull;
if (true) then
{
  _this = createVehicle ["land_nav_pier_m_2", [13225.278, 3431.5159, -6.0489159], [], 0, "CAN_COLLIDE"];
  _vehicle_0 = _this;
  _this setDir 56.571701;
  _this setVehicleLock "LOCKED";
  _this setVehicleInit "this setPosASL [getposASL this select 0, getposASL this select 1, -2.5]";
  _this setPos [13225.278, 3431.5159, -6.0489159];
};
 
_vehicle_2 = objNull;
if (true) then
{
  _this = createVehicle ["land_nav_pier_m_2", [13247.008, 3398.5906, -6.1535072], [], 0, "CAN_COLLIDE"];
  _vehicle_2 = _this;
  _this setDir 56.571701;
  _this setVehicleLock "LOCKED";
  _this setVehicleInit "this setPosASL [getposASL this select 0, getposASL this select 1, -2.5]";
  _this setPos [13247.008, 3398.5906, -6.1535072];
};
 
_vehicle_4 = objNull;
if (true) then
{
  _this = createVehicle ["land_nav_pier_m_1", [13203.401, 3464.7751, -6.2994447], [], 0, "CAN_COLLIDE"];
  _vehicle_4 = _this;
  _this setDir 236.571701;
  _this setVehicleLock "LOCKED";
  _this setVehicleInit "this setPosASL [getposASL this select 0, getposASL this select 1, -2.5]";
  _this setPos [13203.401, 3464.7751, -6.2994447];
};
 
_vehicle_6 = objNull;
if (true) then
{
  _this = createVehicle ["land_nav_pier_m_2", [13181.671, 3497.7451, -6.1785541], [], 0, "CAN_COLLIDE"];
  _vehicle_6 = _this;
  _this setDir 56.571701;
  _this setVehicleInit "this setPosASL [getposASL this select 0, getposASL this select 1, -2.5]";
  _this setPos [13181.671, 3497.7451, -6.1785541];
};
 
_vehicle_8 = objNull;
if (true) then
{
  _this = createVehicle ["land_nav_pier_m_2", [13159.978, 3530.6299, -6.3031154], [], 0, "CAN_COLLIDE"];
  _vehicle_8 = _this;
  _this setDir 56.571701;
  _this setVehicleInit "this setPosASL [getposASL this select 0, getposASL this select 1, -2.5]";
  _this setPos [13159.978, 3530.6299, -6.3031154];
};
 
_vehicle_10 = objNull;
if (true) then
{
  _this = createVehicle ["land_nav_pier_m_2", [13138.261, 3563.5496, -5.9914126], [], 0, "CAN_COLLIDE"];
  _vehicle_10 = _this;
  _this setDir 56.571701;
  _this setVehicleInit "this setPosASL [getposASL this select 0, getposASL this select 1, -2.5]";
  _this setPos [13138.261, 3563.5496, -5.9914126];
};
 
_vehicle_12 = objNull;
if (true) then
{
  _this = createVehicle ["land_nav_pier_m_2", [13116.587, 3596.4583, -6.1611514], [], 0, "CAN_COLLIDE"];
  _vehicle_12 = _this;
  _this setDir 56.571701;
  _this setVehicleInit "this setPosASL [getposASL this select 0, getposASL this select 1, -2.5]";
  _this setPos [13116.587, 3596.4583, -6.1611514];
};
 
_vehicle_14 = objNull;
if (true) then
{
  _this = createVehicle ["land_nav_pier_m_2", [13094.851, 3629.364, -6.0637994], [], 0, "CAN_COLLIDE"];
  _vehicle_14 = _this;
  _this setDir 56.571701;
  _this setVehicleInit "this setPosASL [getposASL this select 0, getposASL this select 1, -2.5]";
  _this setPos [13094.851, 3629.364, -6.0637994];
};
 
_vehicle_16 = objNull;
if (true) then
{
  _this = createVehicle ["land_nav_pier_m_1", [13073.158, 3662.2742, -6.1899328], [], 0, "CAN_COLLIDE"];
  _vehicle_16 = _this;
  _this setDir 56.571701;
  _this setVehicleLock "LOCKED";
  _this setVehicleInit "this setPosASL [getposASL this select 0, getposASL this select 1, -2.5]";
  _this setPos [13073.158, 3662.2742, -6.1899328];
};
 
_vehicle_18 = objNull;
if (true) then
{
  _this = createVehicle ["land_nav_pier_m_2", [13051.535, 3695.0833, -6.376471], [], 0, "CAN_COLLIDE"];
  _vehicle_18 = _this;
  _this setDir 56.571701;
  _this setVehicleLock "LOCKED";
  _this setVehicleInit "this setPosASL [getposASL this select 0, getposASL this select 1, -2.5]";
  _this setPos [13051.535, 3695.0833, -6.376471];
};
 
_vehicle_20 = objNull;
if (true) then
{
  _this = createVehicle ["land_nav_pier_m_2", [13029.813, 3728.052, -6.1521502], [], 0, "CAN_COLLIDE"];
  _vehicle_20 = _this;
  _this setDir 56.571701;
  _this setVehicleLock "LOCKED";
  _this setVehicleInit "this setPosASL [getposASL this select 0, getposASL this select 1, -2.5]";
  _this setPos [13029.813, 3728.052, -6.1521502];
};
 
// Control Tower near land (non-lootable) (blinking light).  Zombies and loot will not spawn over water.
_vehicle_86 = objNull;
if (true) then
{
  _this = createVehicle ["Land_Mil_ControlTower_EP1", [13067.721, 3647.5923, 4.2818656], [], 0, "CAN_COLLIDE"];
  _vehicle_86 = _this;
  _this setDir -303.12695;
  _this setVehicleInit "this setPosASL [getposASL this select 0, getposASL this select 1, 3.8]";
  _this setPos [13067.721, 3647.5923, 4.2818656];
};
 
// Cement block under Control Tower near coast
_vehicle_87 = objNull;
if (true) then
{
  _this = createVehicle ["land_nav_pier_c", [13061.675, 3654.853, 0.13833603], [], 0, "CAN_COLLIDE"];
  _vehicle_87 = _this;
  _this setDir -33.287552;
  _this setVehicleInit "this setPosASL [getposASL this select 0, getposASL this select 1, -2.5]";
  _this setPos [13061.675, 3654.853, 0.13833603];
};
 
// Grocery on land (lootable)
_vehicle_107 = objNull;
if (true) then
{
  _this = createVehicle ["Land_A_GeneralStore_01", [13062.828, 3825.6414, 0.34161228], [], 0, "CAN_COLLIDE"];
  _vehicle_107 = _this;
  _this setDir -32.551853;
  _this setPos [13062.828, 3825.6414, 0.34161228];
};
 
_vehicle_113 = objNull;
if (true) then
{
  _this = createVehicle ["land_nav_pier_m_2", [13260.079, 3378.8081, -3.0727394], [], 0, "CAN_COLLIDE"];
  _vehicle_113 = _this;
  _this setDir 56.571701;
  _this setVehicleLock "LOCKED";
  _this setVehicleInit "this setPosASL [getposASL this select 0, getposASL this select 1, -2.5]";
  _this setPos [13260.079, 3378.8081, -3.0727394];
};
 
// Industrial Hangar on land
_vehicle_133 = objNull;
if (true) then
{
  _this = createVehicle ["Land_Hangar_2", [13013.877, 3793.1804, 3.8146973e-006], [], 0, "CAN_COLLIDE"];
  _vehicle_133 = _this;
  _this setDir -33.153507;
  _this setPos [13013.877, 3793.1804, 3.8146973e-006];
};
 
// Control Tower near Island (non-lootable) (blinking light at night).  Zombies and loot will not spawn over water.
_vehicle_136 = objNull;
if (true) then
{
  _this = createVehicle ["Land_Mil_ControlTower_EP1", [13209.424, 3478.5696, 2.103996], [], 0, "CAN_COLLIDE"];
  _vehicle_136 = _this;
  _this setDir -484.14117;
  _this setVehicleInit "this setPosASL [getposASL this select 0, getposASL this select 1, 3.8]";
  _this setPos [13209.424, 3478.5696, 2.103996];
};
 
// Cement block under Control Tower near Island
_vehicle_137 = objNull;
if (true) then
{
  _this = createVehicle ["land_nav_pier_c", [13214.373, 3472.0823, -3.8479133], [], 0, "CAN_COLLIDE"];
  _vehicle_137 = _this;
  _this setDir -213.288;
  _this setVehicleInit "this setPosASL [getposASL this select 0, getposASL this select 1, -2.5]";
  _this setPos [13214.373, 3472.0823, -3.8479133];
};
 
// Spinning Radar on coast
_vehicle_150 = objNull;
if (true) then
{
  _this = createVehicle ["TK_GUE_WarfareBAntiAirRadar_Base_EP1", [13293.171, 3955.2397, 0.016692447], [], 0, "CAN_COLLIDE"];
  _vehicle_150 = _this;
  _this setDir -323.84015;
  _this setPos [13293.171, 3955.2397, 0.016692447];
};
 
// Pallet of boards on bridge (mid way protection)
_vehicle_163 = objNull;
if (true) then
{
  _this = createVehicle ["Land_Ind_BoardsPack1", [13158.683, 3537.4517, 3.5], [], 0, "CAN_COLLIDE"];
  _vehicle_163 = _this;
  _this setDir -35.139294;
  _this setVehicleInit "this setPosASL [getposASL this select 0, getposASL this select 1, 3.5]";
  _this setPos [13158.683, 3537.4517, 3.5];
};
 
// Pallet of boards on bridge (mid way protection)
_vehicle_165 = objNull;
if (true) then
{
  _this = createVehicle ["Land_Ind_BoardsPack1", [13111.459, 3599.3118, 3.5], [], 0, "CAN_COLLIDE"];
  _vehicle_165 = _this;
  _this setDir -215.18845;
  _this setVehicleInit "this setPosASL [getposASL this select 0, getposASL this select 1, 3.5]";
  _this setPos [13111.459, 3599.3118, 3.5];
};
 
};