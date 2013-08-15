// Script writen by Krixes
//	Version 1.1
//
//
//	Change Log 1.1:
//	1: Made some minor tweaks in the code
//	2: Lowered quality of the snoring for smaller file size
//
// Animation references - http://community.bistudio.com/wiki/ArmA2:_Moves

private ["_timeLeft", "_totalSleepTime","_i","_bloodAmount","_sleepCooldown","_sleepTime"];








//////////////////////////////////////////////////////////////////////////////////////////////////////
// Config Area Start																				//
//////////////////////////////////////////////////////////////////////////////////////////////////////

// This script in its current state is set up perfectly for 45 seconds changing it can yield some wierd results!
_totalSleepTime = 30; // Total ammount of time it takes before you wake up

_bloodAmount = 6000; // Total amount of blood to give back to player on sleep (12000 is the max life for a player)

_sleepCooldown = 300; // This is how long in seconds before you can sleep again

//////////////////////////////////////////////////////////////////////////////////////////////////////
// Config Area End																					//
//////////////////////////////////////////////////////////////////////////////////////////////////////











////////////////////////////////////////////////////////////////////////////////////
// Everything below here need not be modified unless you know what you are doing! //
////////////////////////////////////////////////////////////////////////////////////


_sleepTime = time - sleepTimer; // Variable used for easy reference in determining the sleep cooldown

if(_sleepTime < _sleepCooldown) exitWith { // If cooldown is not done then exit script
	cutText [format["You are not tired yet please wait %1!",(_sleepTime - _sleepCooldown)], "PLAIN DOWN"]; //display text at bottom center of screen when players cooldown is not done
};

if (dayz_combat == 1) then { // Check if in combat (dunno why you would want to sleep in combat but the check is here anyway)
    cutText [format["You cannot sleep while in combat!"], "PLAIN DOWN"]; //display text at bottom center of screen when in combat
} else {
	
	_timeLeft = _totalSleepTime; // Variable used as a countdown timer

	disableUserInput true; // Disable the players keyboard/mouse input when sleeping

	[objNull, player, rSwitchMove,"AidlPpneMstpSnonWnonDnon_SleepA_layDown"] call RE; // Public RPC call to change animation so all players see the animation when laying down

	sleep 3;

	cutText [format["You begin sleeping. %1 seconds left.",_timeLeft], "BLACK OUT"]; // Text displayed when starting to sleep
	_nul = [objNull, player, rSAY, "playerSnoring"] call RE; // This is a RPC sound call for the snoring

	for "_i" from 0 to _totalSleepTime do { // For loop for counting down sleep timers and changing animations
		sleep 1;
		_timeLeft = _timeLeft - 1; // Minus _timeLeft by one every second
		
		if (_timeLeft > 0) then {
			cutText [format["You are sleeping. %1 seconds left.",_timeLeft], "BLACK FADED"]; // Display sleep countdown while sleeping
		} else {cutText [format["You are beginning to wake up!"], "BLACK FADED"];}; // This is a fix for when timer reaches zero... displays text
		
		if (_timeLeft == 40) then {
			[objNull, player, rSwitchMove,"AidlPpneMstpSnonWnonDnon_SleepA_sleep2"] call RE; // Public RPC call to change animation so all players see the animation while sleeping
		};
		
		if (_timeLeft == 30) then {
			[objNull, player, rSwitchMove,"AidlPpneMstpSnonWnonDnon_SleepA_sleep1"] call RE; // Public RPC call to change animation so all players see the animation while sleeping
			
		};
		
		if (_timeLeft == 20) then {
			[objNull, player, rSwitchMove,"AidlPpneMstpSnonWnonDnon_SleepA_sleep2"] call RE; // Public RPC call to change animation so all players see the animation while sleeping
		};
		
		if (_timeLeft == 10) then {
			[objNull, player, rSwitchMove,"AidlPpneMstpSnonWnonDnon_SleepA_sleep3"] call RE; // Public RPC call to change animation so all players see the animation while sleeping
		};
		
		if (_timeLeft == 5) then {
			[objNull, player, rSwitchMove,"AidlPpneMstpSnonWnonDnon_SleepA_sleep1"] call RE; // Public RPC call to change animation so all players see the animation while sleeping
		};
	};

	if (_timeLeft == 0 || _timeLeft < 0) then { // If sleep countdown is done then.....
		sleep 3;
		cutText [format["You wake up!"], "BLACK IN"]; // Display wake up text (don't think this actually gets shown)
		
		[objNull, player, rSwitchMove,"AidlPpneMstpSnonWnonDnon_SleepA_standUp"] call RE; // Public RPC call to change animation so all players see the animation on wake up

		r_player_blood = r_player_blood + _bloodAmount; // LOCAL variable to give player certain blood amount
		
		if(r_player_blood > 12000) then {
			r_player_blood = 12000; // If players blood is greater then max amount allowed set it to max allowed (this check keeps an error at bay)
		};
		
		r_player_lowblood = false;	// Set lowblood to false
		10 fadeSound 1; // Fades sound in over time
		"dynamicBlur" ppEffectAdjust [0]; "dynamicBlur" ppEffectCommit 5; // Disable post processing blur effect
		"colorCorrections" ppEffectAdjust [1, 1, 0, [1, 1, 1, 0.0], [1, 1, 1, 1],  [1, 1, 1, 1]];"colorCorrections" ppEffectCommit 5; // Give player their color back
		r_player_lowblood = false; // Just double checking players blood isnt low
		player setVariable["USEC_BloodQty",r_player_blood,true]; // Save this blood ammount to the database

		cutText [format["You are awake and fully rested!"], "PLAIN DOWN"]; // Text displayed on wakeup!
		disableUserInput false; // Give players input controls back
		
		sleepTimer = time; // Set public cooldown variable
	};
};