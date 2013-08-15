private ["_object","_location","_dir","_worldspace","_objectID","_objectUID","_classname","_codeinput","_convertInput","_i","_stringInput","_numberInput","_fuel","_obj"];
_object = cursortarget; //get object
_location = getposATL _object; //get location of object
_dir = getDir _object; //get direction of object
_worldspace = [_dir,_location]; //generate worldspace like in db with direction and location
_objectID = _object getVariable["ObjectID","0"]; //get ObjectID
_objectUID = _object getVariable["ObjectUID","0"]; //get ObjectUID
_classname = _object getVariable["Classname","0"]; //get Classname
//_objectUID = _worldspace call dayz_objectUID2;; //alternative method to get worldspace, not recommended
_codeinput = _this select 0; //get input from keypanel
cutText ["Please wait until the Database has removed the old Key-Code!", "PLAIN DOWN"];
sleep 1;
playsound "beep";
sleep 1;
playsound "beep";
sleep 1;
playsound "beep";
cutText ["Old Key-Code has been removed! Please wait until the Database has stored the new Key-Code!", "PLAIN DOWN"];
_convertInput =+ _codeinput; //converts the input to positive
for "_i" from 0 to (count _convertInput - 1) do {_convertInput set [_i, (_convertInput select _i) + 48]}; //converts the array to an array that is able to convert to a string
_numberInput = parseNumber (toString _convertInput); //convert to a string and directly convert to number


	if ( _numberInput > 1000 && _numberInput < 10000) then { //checks whether the input number has 4 digits
		deletevehicle _object; 	
		dayzDeleteObj = [_objectID,_objectUID];
		publicVariableServer "dayzDeleteObj";
			if (isServer) then {
			dayzDeleteObj call local_deleteObj;
			};
	/*	dayzDeleteObj2 = [_objectID,_objectUID]; //prepare global array to pass variables to the delete function
	publicVariableServer "dayzDeleteObj2";
	if (isServer) then {
		dayzDeleteObj2 call server_deleteObj2; //delete the object in the database to be able to recreate it
		};*/
	sleep 2; //wait some time to ensure everything is deleted
	playsound "beep";
	cutText ["Please wait until the Database has stored the new Key-Code!", "PLAIN DOWN"];
	sleep 2; //wait some time to ensure everything is deleted
	playsound "beep";
	cutText ["Please wait until the Database has stored the new Key-Code!", "PLAIN DOWN"];
	sleep 2; //wait some time to ensure everything is deleted
	_object = createVehicle [_classname, _location, [], 0, "CAN_COLLIDE"];
	_object setDir _dir;
	_object enablesimulation false;
	_object addEventHandler ["HandleDamage", {false}];
	_fuel = _numberInput / 1000; //calculate fuel to make it ready for database
	_object setVariable ["Code",_numberInput,true]; //set the code
	_object setVariable ["characterID",dayz_playerUID,true]; //set the playerUID again to be sure its set to the object
	playsound "beep";
	cutText ["Please wait until the Database has stored the new Key-Code!", "PLAIN DOWN"];
	sleep 2; //wait some time to ensure everything is deleted
	playsound "beep";
	cutText ["Please wait until the Database has stored the new Key-Code!", "PLAIN DOWN"];
	sleep 2; //wait some time to ensure everything is deleted
	playsound "beep";
	cutText ["Please wait until the Database has stored the new Key-Code!", "PLAIN DOWN"];
	dayzPublishObj2 = [dayz_playerUID,_object,[_dir,_location],_classname,_fuel,_numberInput]; //added _code to pass to the publishObj function to prevent calculation errors
	publicVariableServer "dayzPublishObj2";
	if (isServer) then {
		dayzPublishObj2 call server_publishObj2;
	};
	_object setVariable ["Code",_numberInput,true]; //set the code again to be sure its set to the object
	cutText [format["You have successfully changed your code to: %1",(toString _convertInput)], "PLAIN DOWN",1]; //give positive response to player and put the code out to it can be rechecked
	playsound "beep"; //only sound response
	sleep 0.5;
	playsound "beep";
	sleep 0.5;
	playsound "beep";
	
	_codeinput = []; //empty the array for safety
	} else { cutText ["Failed to change your code, please use exact 4 numbers!", "PLAIN DOWN"];breakOut "exit"; //if the number wasn't valid it will end the script and you can try it again
	_codeinput = []; //empty the array for safety
	};