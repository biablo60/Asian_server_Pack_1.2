class KeypadGateNew {
idd = -1;
movingEnable = false;
controlsBackground[] = {};
controls[] = {
"B1",
"B2",
"B3",
"B4",
"B5",
"B6",
"B7",
"B8",
"B9",
"B0",
"BEnter",
"BAbort",
"KeypadImage",
"NumberDisplay"
};
objects[] = {};
class B1 {
idc = -1;
type = 1;
style = 2;
moving = false;
x = 0.39;
y = 0.39;
h = 0.08;
w = 0.06;
font = "Zeppelin32";
sizeEx = 0.05;
// action uses script commands to close dialog and display a hint
action = "CODEINPUT set [count CODEINPUT, 1]; ctrlSetText [1099, str CODEINPUT];";
text = "";
default = false;
colorText[] = {0,0,0,1}; // white
colorFocused[] = {0.1,0.1,0.1,0.1}; // green
colorShadow[] = {0,0,0,0}; // darkgrey
colorBorder[] = {0.5,0.5,0.5,0}; // grey
colorBackground[] = {0.7,0.7,0.7,1};
colorBackgroundActive[] = {0.1,0.1,0.1,0.3}; // green
colorDisabled[] = {1,0,0,1}; // red
colorBackgroundDisabled[] = {0.5,0.5,0.5,0}; // grey
borderSize = 0.015;
offsetX = 0.005;
offsetY = 0.005;
offsetPressedX = 0.002;
offsetPressedY = 0.002;
soundEnter[] = {"",0,1}; // NoSound
soundPush[] = {"",0,1}; // NoSound
soundClick[] = {"\dayz_sfx\action\cell\dtmf_1.ogg",0.5,1}; // NoSound
soundEscape[] = {"",0,1}; // NoSound
};

class B2 : B1 {
x = 0.47;
text = "";
soundClick[] = {"\dayz_sfx\action\cell\dtmf_2.ogg",0.5,1};
action = "CODEINPUT set [count CODEINPUT, 2]; ctrlSetText [1099, str CODEINPUT];";
};
class B3 : B1 {
x = 0.55;
text = "";
soundClick[] = {"\dayz_sfx\action\cell\dtmf_3.ogg",0.5,1};
action = "CODEINPUT set [count CODEINPUT, 3]; ctrlSetText [1099, str CODEINPUT];";
};
class B4 : B1 {
y = 0.50;
text = "";
soundClick[] = {"\dayz_sfx\action\cell\dtmf_4.ogg",0.5,1};
action = "CODEINPUT set [count CODEINPUT, 4]; ctrlSetText [1099, str CODEINPUT];";
};
class B5 : B4 {
x = 0.47;
text = "";
soundClick[] = {"\dayz_sfx\action\cell\dtmf_5.ogg",0.5,1};
action = "CODEINPUT set [count CODEINPUT, 5]; ctrlSetText [1099, str CODEINPUT];";
};
class B6 : B4 {
x = 0.55;
text = "";
soundClick[] = {"\dayz_sfx\action\cell\dtmf_6.ogg",0.5,1};
action = "CODEINPUT set [count CODEINPUT, 6]; ctrlSetText [1099, str CODEINPUT];";
};
class B7 : B1 {
y = 0.61;
text = "";
soundClick[] = {"\dayz_sfx\action\cell\dtmf_7.ogg",0.5,1};
action = "CODEINPUT set [count CODEINPUT, 7]; ctrlSetText [1099, str CODEINPUT];";
};
class B8 : B7 {
x = 0.47;
text = "";
soundClick[] = {"\dayz_sfx\action\cell\dtmf_8.ogg",0.5,1};
action = "CODEINPUT set [count CODEINPUT, 8]; ctrlSetText [1099, str CODEINPUT];";
};
class B9 : B7 {
x = 0.55;
text = "";
soundClick[] = {"\dayz_sfx\action\cell\dtmf_9.ogg",0.5,1};
action = "CODEINPUT set [count CODEINPUT, 9]; ctrlSetText [1099, str CODEINPUT];";
};

class B0 : B8 {
y = 0.72;
text = "";
soundClick[] = {"\dayz_sfx\action\cell\dtmf_0.ogg",0.5,1};
action = "CODEINPUT set [count CODEINPUT, 0]; ctrlSetText [1099, str CODEINPUT];";
};
class BEnter : B9 {
y = 0.72;
text = "";
soundClick[] = {"\dayz_sfx\action\cell\dtmf_hash.ogg",0.6,1};
action = "closeDialog 0; nul = [CODEINPUT] execVM 'dayz_code\external\keypad\fnc_keyPad\codeCheck.sqf';";
};
class BAbort : B7 {
y = 0.72;
text = "";
soundClick[] = {"\dayz_sfx\action\cell\dtmf_star.ogg",0.6,1};
action = "closeDialog 0; keyCode = []; CODEINPUT = [];";
};
class KeypadImage {
idc = -1;
type = CT_STATIC;
style = ST_PICTURE;
colorText[] = { };
colorBackground[] = { };
font = "Zeppelin32";
sizeEx = 0.023;
x = 0.35; y = 0.2;
w = 0.3; h = 0.8;
text = "dayz_code\external\keypad\pics\keypad.paa";
};
class NumberDisplay {
idc = 1099;
type = CT_STATIC ; // defined constant
style = ST_LEFT; // defined constant
colorText[] = { 1, 0, 0, 1 };
colorBackground[] = { 1, 1, 1, 0 };
font = Zeppelin32; // defined constant
sizeEx = 0.028;
x = 0.38; y = 0.24;
w = 0.23; h = 0.1;
text = "";
};
};