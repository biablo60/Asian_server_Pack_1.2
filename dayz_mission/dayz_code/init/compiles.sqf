// ### Base Building DayZ 1.2 Compiles ###

// This is DayZ actions code.  Base Building actions have been added in!
fnc_usec_selfActions = compile preprocessFileLineNumbers "dayz_code\compile\fn_selfActions.sqf";			// fnc_usec_selfActions - adds custom actions to dayz code

//Base Building 1.2 specific compiles
player_build = compile preprocessFileLineNumbers "dayz_code\compile\player_build.sqf"; 		// This overwrites default dayz building mechanic
antiWall = compile preprocessFileLineNumbers "dayz_code\compile\antiWall.sqf";				// This prevents players from exiting vehicles to get into bases
anti_discWall = compile preprocessFileLineNumbers "dayz_code\compile\anti_discWall.sqf";	// This prevents players from driving into a wall and disconnecting to get into bases
refresh_build_recipe_dialog = compile preprocessFileLineNumbers "buildRecipeBook\refresh_build_recipe_dialog.sqf"; 				// Builder menu dialog functionality
refresh_build_recipe_list_dialog = compile preprocessFileLineNumbers "buildRecipeBook\refresh_build_recipe_list_dialog.sqf"; 	// Builder Menu dialog list

//Epoch Overrides
	player_vaultPitch =			compile preprocessFileLineNumbers "dayz_code\actions\vault_pitch.sqf";
	player_tentPitch =			compile preprocessFileLineNumbers "dayz_code\actions\tent_pitch.sqf";
	player_packTent =			compile preprocessFileLineNumbers "dayz_code\compile\player_packTent.sqf";
	player_friendliesCheck =	compile preprocessFileLineNumbers "dayz_code\compile\player_friendliesCheck.sqf";
	fnc_usec_damageActions =	compile preprocessFileLineNumbers "dayz_code\compile\fn_damageActions.sqf";		//Checks which actions for nearby casualty
	player_knockout = compile preprocessFileLineNumbers "custom\knockout2.sqf";
//Custom Weather
	execVM "custom\DynamicWeatherEffects.sqf";
	initialized = true;