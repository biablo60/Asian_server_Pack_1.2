//Sector FNG Made by Phoenix @ http://fridaynightgaming.co.uk/
//Feel Free to test @ 91.121.11.49:2362 Bring a group you'll need one.
//Thanks to OpenDayZ for there hard work in helping others.
//Thanks to Sarge for his great AI work.

//Sector FNG Weapons Crate
_vehicle_103769 = objNull;
if (true) then
{
  _this = createVehicle ["TKVehicleBox_EP1", [6660.3984, 14177.261], [], 0, "CAN_COLLIDE"];
  _vehicle_103769 = _this;
  _this setDir -182.5;
    //Clear Cargo	
  clearweaponcargoGlobal _this;
  clearmagazinecargoGlobal _this;
  //Add Cargo
  _this addWeaponCargoGlobal ["M9SD",2];
  _this addWeaponCargoGlobal ["DMR",2];
  _this addWeaponCargoGlobal ["M4A1_AIM_SD_camo",2];
  _this addWeaponCargoGlobal ["FN_FAL",2];
  _this addWeaponCargoGlobal ["M249_DZ",2];
  _this addWeaponCargoGlobal ["M14_EP1",2];
  _this addWeaponCargoGlobal ["Mk_48_DZ",2];
  _this addWeaponCargoGlobal ["BAF_L85A2_RIS_SUSAT",2];
  _this addWeaponCargoGlobal ["BAF_L85A2_RIS_Holo",2];
  _this addWeaponCargoGlobal ["G36K_camo",2];
  _this addWeaponCargoGlobal ["SCAR_L_STD_Mk4CQT",2];
  _this addWeaponCargoGlobal ["SCAR_L_STD_HOLO",2];
  _this addWeaponCargoGlobal ["PK",1];
  _this addWeaponCargoGlobal ["NVGoggles",1];
  _this addWeaponCargoGlobal ["Binocular_Vector",1];
  _this addWeaponCargoGlobal ["ItemGPS",1];

  _this addmagazineCargoGlobal ["20Rnd_762x51_DMR",20];
  _this addmagazineCargoGlobal ["30Rnd_556x45_StanagSD",20];
  _this addmagazineCargoGlobal ["20Rnd_762x51_FNFAL",10];
  _this addmagazineCargoGlobal ["100Rnd_762x51_M240",10];
  _this addmagazineCargoGlobal ["200Rnd_556x45_M249",10];
  _this addmagazineCargoGlobal ["30Rnd_556x45_G36",10];
  _this addmagazineCargoGlobal ["30Rnd_556x45_Stanag",50];
  _this addmagazineCargoGlobal ["100Rnd_762x54_PK",2];
  _this addmagazineCargoGlobal ["15Rnd_9x19_M9SD",10];


  _this addbackpackCargoGlobal ["DZ_Backpack_EP1",2];
  _this setPos [6660.3984, 14177.261];
};
//Sector FNG Vehicle Part Crate
_vehicle_103770 = objNull;
if (true) then
{
  _this = createVehicle ["TKVehicleBox_EP1", [6786.0361, 14320.882], [], 0, "CAN_COLLIDE"];
  _vehicle_103770 = _this;
    //Clear Cargo	
  clearweaponcargoGlobal _this;
  clearmagazinecargoGlobal _this;
  //Add Cargo
  _this addWeaponCargoGlobal ["NVGoggles",1];
  _this addWeaponCargoGlobal ["ItemGPS",1];
  _this addWeaponCargoGlobal ["ItemToolbox",5];

  _this addmagazineCargoGlobal ["PartEngine",15];
  _this addmagazineCargoGlobal ["PartGeneric",15];
  _this addmagazineCargoGlobal ["PartVRotor",5];
  _this addmagazineCargoGlobal ["PartWheel",20];
  _this addmagazineCargoGlobal ["PartFueltank",15];
  _this addmagazineCargoGlobal ["PartGlass",30];
  _this addmagazineCargoGlobal ["ItemJerrycan",20];

  _this addbackpackCargoGlobal ["DZ_Backpack_EP1",1];
  _this setPos [6786.0361, 14320.882];
};
//Sector FNG Food and Drink Crate
_vehicle_103771 = objNull;
if (true) then
{
  _this = createVehicle ["TKVehicleBox_EP1", [6791.7695, 14091.711], [], 0, "CAN_COLLIDE"];
  _vehicle_103771 = _this;
  _this setDir -178.83;
  //Clear Cargo	
  clearweaponcargoGlobal _this;
  clearmagazinecargoGlobal _this;
  //Add Cargo
  _this addWeaponCargoGlobal ["NVGoggles",1];
  _this addWeaponCargoGlobal ["ItemGPS",1];

  _this addmagazineCargoGlobal ["FoodMRE",20];
  _this addmagazineCargoGlobal ["FoodCanBakedBeans",20];
  _this addmagazineCargoGlobal ["FoodCanPasta",20];
  _this addmagazineCargoGlobal ["ItemSodaCoke",20];
  _this addmagazineCargoGlobal ["ItemSodaPepsi",20];

  _this addbackpackCargoGlobal ["DZ_Backpack_EP1",1];
  _this setPos [6791.7695, 14091.711];
};
//Sector FNG Medical Crate
_vehicle_103772 = objNull;
if (true) then
{
  _this = createVehicle ["TKVehicleBox_EP1", [6591.8535, 14275.836], [], 0, "CAN_COLLIDE"];
  _vehicle_103772 = _this;
  _this setDir 90.560677;
  //Clear Cargo	
  clearweaponcargoGlobal _this;
  clearmagazinecargoGlobal _this;
  //Add Cargo
  _this addWeaponCargoGlobal ["NVGoggles",1];
  _this addWeaponCargoGlobal ["ItemGPS",1];

  _this addmagazineCargoGlobal ["ItemBandage",30];
  _this addmagazineCargoGlobal ["ItemPainkiller",30];
  _this addmagazineCargoGlobal ["ItemMorphine",30];
  _this addmagazineCargoGlobal ["ItemBloodBag",30];
  _this addmagazineCargoGlobal ["ItemEpinephrine",15];
  _this addmagazineCargoGlobal ["ItemAntibiotic",30];

  _this addbackpackCargoGlobal ["DZ_Backpack_EP1",1];
  _this setPos [6591.8535, 14275.836];
};
//Sector FNG BaseBuilding Crate
_vehicle_103773 = objNull;
if (true) then
{
  _this = createVehicle ["TKVehicleBox_EP1", [6668.1357, 14121.218], [], 0, "CAN_COLLIDE"];
  _vehicle_103773 = _this;
  //Clear Cargo	
  clearweaponcargoGlobal _this;
  clearmagazinecargoGlobal _this;
  //Add Cargo
  _this addWeaponCargoGlobal ["ItemEtool",5];
  _this addWeaponCargoGlobal ["ItemToolbox",5];
  _this addWeaponCargoGlobal ["NVGoggles",1];
  _this addWeaponCargoGlobal ["ItemGPS",1];

  _this addmagazineCargoGlobal ["HandGrenade_West",20];
  _this addmagazineCargoGlobal ["ItemSandbag",30];
  _this addmagazineCargoGlobal ["ItemTankTrap",30];
  _this addmagazineCargoGlobal ["ItemWire",30];
  _this addmagazineCargoGlobal ["ItemTent",20];
  _this addmagazineCargoGlobal ["PartGeneric",20];
  _this addmagazineCargoGlobal ["TrapBear",20];

  _this addbackpackCargoGlobal ["DZ_Backpack_EP1",1];
  _this setPos [6668.1357, 14121.218];
};