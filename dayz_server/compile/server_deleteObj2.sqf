/*
[_objectID,_objectUID] call server_deleteObj;
*/
private["_id","_uid","_key"];
_uid 	= _this select 1;

if (isServer) then {
	//remove from database
		//Send request
		_key = format["CHILD:310:%1:",_uid];
		_key call server_hiveWrite;
		diag_log format["DELETE: Deleted by UID: %1",_uid];
	};