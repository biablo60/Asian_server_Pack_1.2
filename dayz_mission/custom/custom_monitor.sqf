//Credit to nullpo for his original debug and Superlube for the picture
//Modified by Matt L
dayz_spaceInterrupt = {
    private ["_dikCode", "_handled"];
    _dikCode = _this select 1;
    _handled = false;
 
    if (_dikCode == 0x44) then {
        if (debugMonitor) then {
            debugMonitor = false;
            hintSilent "";
        } else {[] spawn fnc_debug;};
    };
    _handled
};
 
fnc_debug = {
    debugMonitor = true;
    while {debugMonitor} do
    {
        _kills =        player getVariable["zombieKills",0];
        _killsH =        player getVariable["humanKills",0];
        _killsB =        player getVariable["banditKills",0];
        _humanity =        player getVariable["humanity",0];
        _headShots =    player getVariable["headShots",0];
        _zombies =              count entities "zZombie_Base";
        _zombiesA =    {alive _x} count entities "zZombie_Base";
        _banditCount = {(isPlayer _x) && ((_x getVariable ["humanity",0]) < 0)} count playableUnits;
        _heroCount  = {(isPlayer _x) && ((_x getVariable ["humanity",0]) >= 5000)} count playableUnits;
        _pic = (gettext (configFile >> 'CfgVehicles' >> (typeof vehicle player) >> 'picture'));
            if (player == vehicle player) then
            {
                _pic = (gettext (configFile >> 'cfgWeapons' >> (currentWeapon player) >> 'picture'));
            }
                else
            {
                _pic = (gettext (configFile >> 'CfgVehicles' >> (typeof vehicle player) >> 'picture'));
            };
        hintSilent parseText format ["
        <t size='1'font='Bitstream'align='center' color='#00FF00' >%1</t><br/>
        <t size='1'font='Bitstream'align='left' color='#EE0000' >Blood Left:</t><t size='1' font='Bitstream'align='right' color='#EE0000' >%2</t><br/>
        <t size='1'font='Bitstream'align='left' color='#EEC900' >Humanity:</t><t size='1'font='Bitstream'align='right' color='#EEC900' >%3</t><br/>
        <t size='1'font='Bitstream'align='left' color='#EEC900' >Noobs Killed:</t><t size='1'font='Bitstream'align='right' color='#EEC900' >%4</t><br/>
        <t size='1'font='Bitstream'align='left' color='#EEC900' >Assholes Killed:</t><t size='1'font='Bitstream'align='right' color='#EEC900' >%5</t><br/>
        <t size='1'font='Bitstream'align='left' color='#EEC900' >Zombitches Killed:</t><t size='1'font='Bitstream'align='right' color='#EEC900' >%6</t><br/>
        <t size='1'font='Bitstream'align='left' color='#EEC900' >Dome Shots:</t><t size='1'font='Bitstream'align='right' color='#EEC900' >%7</t><br/>
        <t size='1' font='Bitstream' align='left' color='#EEC900' >Zombitches (alive/total): </t><t size='1' font='Bitstream' align='right' color='#EEC900' >%9/%8</t><br/>
        <t size='1'font='Bitstream'align='left' color='#104E8B' >Current Asshole Count:</t><t size='1'font='Bitstream'align='right' color='#FF0000' >%11</t><br/>
        <t size='1'font='Bitstream'align='left' color='#104E8B' >Current NiceGuy Count:</t><t size='1'font='Bitstream'align='right' color='#00FF00' >%12</t><br/>
        <t size='1' font='Bitstream' align='left' color='#104E8B' >FPS: </t><t size='1' font='Bitstream' align='right' color='#104E8B' >%10</t><br/>
        <img size='3' image='%13'/><br/>
        <t size='1'font='Bitstream'align='left' color='#FF00FF' >Press F10 to toggle! </t><br/>
        <t size='1'font='Bitstream'align='left' color='#00FFFF' >dayzfallendead.cu.cc </t><br/>
		<t size='1'font='Bitstream'align='left' color='#00FF00' >IP:192.31.185.209:3357 </t><br/>
 
        ",dayz_playerName,r_player_blood,round _humanity,_killsH,_killsB,_kills,_headShots,count entities "zZombie_Base",{alive _x} count entities "zZombie_Base",diag_fps,_banditCount,_heroCount,_pic];
    sleep 1;
    };
};
 
[] spawn fnc_debug;