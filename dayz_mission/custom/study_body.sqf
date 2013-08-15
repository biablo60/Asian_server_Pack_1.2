private ["_body", "_name", "_kills", "_killsH", "_killsB", "_headShots", "_humanity"];
 
titleText ["You have found a journal on the survivor's corpse TURN OFF DEBUG MONITOR TO SEE","PLAIN DOWN"]; titleFadeOut 5;
sleep 2;
 
_body = _this select 3;
_name = _body getVariable ["bodyName","unknown"];
_kills = _body getVariable ["zombieKills",0];
_killsH = _body getVariable ["humanKills",0];
_killsB = _body getVariable ["banditKills",0];
_headShots = _body getVariable ["headShots",0];
_humanity = _body getVariable ["humanity",0];
 
hint parseText format["
<t size='1.5' font='Bitstream' color='#5882FA'>%1's Journal</t><br/><br/>
<t size='1.25' font='Bitstream' align='left'>Zombies Killed: </t><t size='1.25' font='Bitstream' align='right'>%2</t><br/>
<t size='1.25' font='Bitstream' align='left'>Murders: </t><t size='1.25' font='Bitstream' align='right'>%3</t><br/>
<t size='1.25' font='Bitstream' align='left'>Bandits Killed: </t><t size='1.25' font='Bitstream' align='right'>%4</t><br/>
<t size='1.25' font='Bitstream' align='left'>Headshots: </t><t size='1.25' font='Bitstream' align='right'>%5</t><br/>
<t size='1.25' font='Bitstream' align='left'>Humanity: </t><t size='1.25' font='Bitstream' align='right'>%6</t><br/>",
_name,_kills,_killsH,_killsB,_headShots,_humanity];