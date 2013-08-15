/*
  SHK_pos

  Author: Shuko (shuko@quakenet, miika@miikajarvinen.fi)
  Version 0.21
  Forum: http://forums.bistudio.com/showthread.php?t=89376

  Marker Based Selection
    Required Parameters:
      0 String   Area marker's name.
      
    Optional Parameters:
      1 Boolean           Allow water positions? Default is false.
      2 Array or String   One or multiple blacklist area markers which are excluded from the main marker area.

  Position Based Selection
    Required Parameters:
      0 Object or Position  Anchor point from where the relative position is calculated from.
      1 Array or Number     Distance from anchor.
      
    Optional Parameters:
      2 Array of Number     Direction from anchor. Default is random between 0 and 360.
      3 Boolean             Water position allowed? Default is false.
                              false    Allow water positions.
                              true     Find closest land. Search outwards 360 degrees (20 degree steps) and 20m steps.
      4 Array               Road positions.
                              0  Number  Road position forcing. Default is 0.
                                   0    Do not search for road positions.
                                   1    Find closest road position. Return the generated random position if none found.
                                   2    Find closest road position. Return empty array if none found.
                              1  Number   Road search range. Default is 200m.
    
  Usage:
    Preprocess the file in init.sqf:
      call compile preprocessfile "SHK_pos\shk_pos_init.sqf";
    
    Actually getting the position:
      pos = [parameters] call SHK_pos;
*/
// Functions
SHK_pos_getPos = compile preprocessfilelinenumbers "addons\shk_pos\shk_pos_getpos.sqf";
SHK_pos_getPosMarker = compile preprocessfilelinenumbers "addons\shk_pos\shk_pos_getposmarker.sqf";

// Sub functions
SHK_pos_fnc_findClosestPosition = compile preprocessfilelinenumbers "addons\shk_pos\shk_pos_fnc_findclosestposition.sqf";
SHK_pos_fnc_getMarkerCorners = compile preprocessfilelinenumbers "addons\shk_pos\shk_pos_fnc_getmarkercorners.sqf";
SHK_pos_fnc_getMarkerShape = compile preprocessfilelinenumbers "addons\shk_pos\shk_pos_fnc_getmarkershape.sqf";
SHK_pos_fnc_getPos = compile preprocessfilelinenumbers "addons\shk_pos\shk_pos_fnc_getpos.sqf";
SHK_pos_fnc_getPosFromCircle = compile preprocessfilelinenumbers "addons\shk_pos\shk_pos_fnc_getposfromcircle.sqf";
SHK_pos_fnc_getPosFromEllipse = compile preprocessfilelinenumbers "addons\shk_pos\shk_pos_fnc_getposfromellipse.sqf";
SHK_pos_fnc_getPosFromRectangle = compile preprocessfilelinenumbers "addons\shk_pos\shk_pos_fnc_getposfromrectangle.sqf";
SHK_pos_fnc_getPosFromSquare = compile preprocessfilelinenumbers "addons\shk_pos\shk_pos_fnc_getposfromsquare.sqf";
SHK_pos_fnc_isBlacklisted = compile preprocessfilelinenumbers "addons\shk_pos\shk_pos_fnc_isblacklisted.sqf";
SHK_pos_fnc_isInCircle = compile preprocessfilelinenumbers "addons\shk_pos\shk_pos_fnc_isincircle.sqf";
SHK_pos_fnc_isInEllipse = compile preprocessfilelinenumbers "addons\shk_pos\shk_pos_fnc_isinellipse.sqf";
SHK_pos_fnc_isInRectangle = compile preprocessfilelinenumbers "addons\shk_pos\shk_pos_fnc_isinrectangle.sqf";
SHK_pos_fnc_isSamePosition = compile preprocessfilelinenumbers "addons\shk_pos\shk_pos_fnc_issameposition.sqf";
SHK_pos_fnc_rotatePosition = compile preprocessfilelinenumbers "addons\shk_pos\shk_pos_fnc_rotateposition.sqf";

// Wrapper function
// Decide which function to call based on parameters.
SHK_pos = {
  private ["_pos"];
  // SARGE DEBUG
  //diag_log "SHK_pos executed";
  _pos = [];

  // Only marker is given as parameter
  if (typename _this == "STRING") then {
    _pos = [_this] call SHK_pos_getPosMarker;

  // Parameter array
  } else {
    if (typename (_this select 0) == "STRING") then {
      _pos = _this call SHK_pos_getPosMarker;
    } else {
      _pos = _this call SHK_pos_getPos;
    };
  };

  // Return position
  _pos
};