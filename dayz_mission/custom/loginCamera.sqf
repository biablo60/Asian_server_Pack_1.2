private [ "_camera", "_welcomeMessage", "_camDistance" ];
_welcomeMessage = format["Welcome change me %1, Enjoy your stay!",format["%1", name player]];
_camDistance = 60;
 
waituntil {!isnull (finddisplay 46)}; // Makes the script start when player is ingame
 
//intro move
showCinemaBorder true;
camUseNVG false;
 
_camera = "camera" camCreate [(position player select 0)-2, position player select 1,(position player select 2)+_camDistance];
_camera cameraEffect ["internal","back"];
 
_camera camSetFOV 2.000;
_camera camCommit 0;
waitUntil {camCommitted _camera};
 
_camera camSetTarget vehicle player;
_camera camSetRelPos [0,0,2];
_camera camCommit 8;
 
cutText [_welcomeMessage, "PLAIN DOWN"];
 
waitUntil {camCommitted _camera};
 
_camera cameraEffect ["terminate","back"];
camDestroy _camera;

//Credits

// ======= SCRIPT VERSION: v1.1 =======
// SERVER WELCOME MESSAGE IN CREDITS STYLE edited for DayZ by IT07
// ORIGINAL SCRIPT BY: Bohemia Interactive, British Armed Forces Campaign Mission 1
// IT07 does NOT take credit for original script, he only modified it so it works for DayZ
// ==================
 
// ======= Customization =======
// ADDING MORE MESSAGES:
// if you add more messages than already here, add a _role that is named +1 more than the last one.
// Be careful, if you add a role here below, also add it to the } forEach [ list that's on the bottom.
// CHANGING TRANSITION TIMES:
// where it says: _onScreenTime = 1 + (((count _memberNames) - 1) * 0.5); change the 0.5 to whatever value you want.
// 1.0 for example is already a lot slower, so be careful changing this.
// when you have changed this value, enter the same value where it says:
// _onScreenTime, 0.5
// =============================
 
// SCRIPT START
sleep 15; // wait 15 before the welcome message starts (in seconds)
 
_role1 = "SERVER OWNERS";
_role1names = ["Change me"];
_role2 = "ANOTHER MESSAGE<br />Sub message"; // Sub message shows 1 row below ANOTHER MESSAGE
_role2names = ["Change me"];
_role3 = "SERVER ADMINS";
_role3names = ["change me"];
_role4 = "WEBSITE";
_role4names = ["www.Change me.com"];
_role5 = "DONATE";
_role5names = ["HELP Keep the server ALIVE"];
//Dont change me
_role6 = "Asian Server Pack v1.2";
_role6names = ["Made By Asian Kid];
 
{
  sleep 2;
	_memberFunction = _x select 0;
	_memberNames = _x select 1;
	_finalText = format ["<t size='0.45' color='#ffffff' align='left'>%1<br /></t><t size='0.1'><br /></t>", _memberFunction];
	_finalText = _finalText + "<t size='0.65' color='#ffffff' align='left'>";
	{_finalText = _finalText + format ["%1<br />", _x]} forEach _memberNames;
	_finalText = _finalText + "</t>";
	_onScreenTime = 5 + (((count _memberNames) - 1) * 0.5);
	[
		_finalText,
		[safezoneX + safezoneW - 0.5,0.35],
		[safezoneY + safezoneH - 0.8,0.7],
		_onScreenTime,
		0.5
	] spawn BIS_fnc_dynamicText;
	sleep (_onScreenTime);
} forEach [
	[_role1, _role1names],
	[_role2, _role2names],
	[_role3, _role3names],
	[_role4, _role4names],
	[_role5, _role5names],
	[_role6, _role6names] // Keep this one in mind, NO COMMA on the last role
];