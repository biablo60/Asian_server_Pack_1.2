 
while {alive player}
do
{
if(daytime<6||daytime>18)//EDITABLE - Change the stop and start times for the script. No need to create lights in the day. If server set to Static time, local time seems to be 12.5007..
then {
private ["_strMessage","_brightness","_objLightPoint","_awayx","_awayy","_lp","_test","_hcount","_dir","_animlightpoint"];
_objHouse = nearestObjects [player, ["House"], 600]; //EDITABLE - Change distance, (in metres) from the player, at which houses have their lights switched on.
_housecount = count _objHouse;
_hcount=0;
{
//hint format ["(%1) %2 | Script Running..",_hcount, daytime];
_switching = random 100;//Generate random chance for power failures
_switchpercent = 85;//EDITABLE - Percentage for reliability of power supply. eg. 65 will be 65% chance of lights coming on in each house and 35% chance that lights will fail and flicker off.
_lightstate = _x animationPhase "Lights_1";//Window lights on or off
_pos = getPos _x;
_xpos = _pos select 0;
_ypos = _pos select 1;
_dir = getDir _x;
 
if(_lightstate==0) then
{
if(_switching<_switchpercent)then //Turn on lights in house windows
{
for "_i" from 1 to 5 do {
_x animate [format ["Lights_%1",_i],1];
};
sleep 0.1; // Give time for engine to register light on - I found ambient light wasn't creating without this pause.
};
};
 
 
_objLightPoint = nearestObject [_x, "#lightpoint"];
_lightpos = getPos _objLightPoint;
_lightposX = _lightpos select 0;
_lightposY = _lightpos select 1;
_awayx=_xpos-_lightposX;
_awayy=_ypos-_lightposY;// x/y distance of lightpoint from current house
_test = getDir _objLightPoint;
 
if((_awayx>1 or _awayx<-1)or(_awayy>1 or _awayy<-1))then
{
if(_x animationPhase "Lights_1"==1) then //Only create lightsource for houses with windows lit, stops unlit houses, barns etc having a light source
{
if(_switching<_switchpercent)then //Do lightpoint stuff
{
_lp = "#lightpoint" createVehicle [0,0,0];
_lp setLightColor [1, 1, 1]; // Set its colour
_lp setLightBrightness 0.01; // Set its brightness
_lp setLightAmbient[5, 5, 5]; //Light the surrounding area
_lp setPos [_xpos,_ypos,-3];// Position it underground to reduce glare and spread
_lp setDir _dir;
//hint format["(%5) %4 Houses: Create Lightpoint  ! Distance %1:%2. Test:%3",_awayx,_awayy,_test,_housecount,_hcount];
sleep 0.5;
};
};
}
else
{
if(_x animationPhase "Lights_1"==1) then //Only recreate lightsource for houses with windows lit
{
_objLightPoint setLightColor [1, 1, 1]; // Set its colour
_objLightPoint setLightBrightness 0.01; // Set its brightness
_objLightPoint setLightAmbient[5, 5, 5]; //Light the surrounding area
};
//hint format["(%5) %4 Houses: Lightpoint (%6) Found  ! Distance %1:%2. Test:%3",_awayx,_awayy,_test,_housecount,_hcount,_objLightPoint];
sleep 0.5;
};
 
 
if(_lightstate==1) then  //Decide if to turn Light Off with Animation..
{
if(_switching>_switchpercent)then
{
_animlightpoint = nearestObject [_x, "#lightpoint"];
for "_s" from 1 to 5 do {
 
if(_s%2==0)then
{
_brightness=0;
for "_l" from 1 to 5 do {
_x animate [format ["Lights_%1",_l],0];
};
}
else
{
_brightness=0.01;
for "_l" from 1 to 5 do {
_x animate [format ["Lights_%1",_l],1];
};
 
};
 
_animlightpoint setLightBrightness _brightness;
 
_sleeptime=random 100;
_sleeptime=_sleeptime/500;
sleep _sleeptime;
 
};
 
for "_l" from 1 to 5 do {
_x animate [format ["Lights_%1",_l],0];
};
_animlightpoint setLightBrightness 0;
//hint format["(%3) %2 Houses: Switch light off Test:%1",_test,_housecount,_hcount];
sleep 6;
};
};
 
_hcount=_hcount+1;
 
} forEach _objHouse;
};
}