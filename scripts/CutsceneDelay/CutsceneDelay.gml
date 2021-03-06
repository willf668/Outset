function createCutsceneDelay(_val){
	var _cd=instance_create_layer(0,0,"above",oCutsceneDelay);
	if variable_struct_exists(_val,"key") 
	{
		_cd.key=_val.key;
		_cd.originalKey=_val.key;
	}
	if variable_struct_exists(_val,"myRoom") 
	{
		_cd.startroom=asset_get_index(_val[$ "myRoom"]);
	}
	_cd.mode=(!variable_struct_exists(_val,"delay"));
	if !_cd.mode
	{
		_cd.delay=_val.delay;
		_cd.delayCount=_cd.delay;
	}
	else 
	{
		if variable_struct_exists(_val,"condition") _cd.delay=_val.condition;
	}
	if variable_struct_exists(_val,"args") _cd.args=_val.args;
	if variable_struct_exists(_val,"merge") _cd.merge=_val.merge;
	if variable_struct_exists(_val,"scr") _cd.scr=asset_get_index(_val.scr);
	var _layer="above";
	if variable_struct_exists(_val,"force") _layer="force"
	if _cd.delay!="alive"||true //not sure what this is for
	{
		with _cd 
		{
			if eventExists(oCutsceneDelay,startroom,key,delay,_layer,args) instance_destroy();
			else eventAddObject(oCutsceneDelay,startroom,key,delay,_layer,args);
		}
	}
	if _cd.startroom!="any"&&_cd.startroom!=room instance_destroy(_cd,false);
}
function cancelCutsceneDelay(_key){
	for (var i=0;i<instance_number(oCutsceneDelay);i++) with instance_find(oCutsceneDelay,i) 
	{
		if _key=="any"||key==_key 
		{
			instance_destroy();
		}
	}
}

function scr_pro_launchEugene(){
	if room==rNotdonArchives key="pro_launchEugeneEnter";
	else if room!=rNotdon
	{
		setNPCRoom("eugene",rNotdonArchives,"pro_arch1");
		return false;
	}
	return true;
}

function scr_pro_parachuteBreak(){
	if instance_exists(ply) with ply if place_meeting(x,y,oParachute) with instance_place(x,y,oParachute) alarm[0]=1;
	return false;
}

function scr_startingRoom(){
	return (room==startroom);
}