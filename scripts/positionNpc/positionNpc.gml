

function positionNpc(moveToLocation){ //0= don't, 1=do, 2=pathfind
	facePlayer=false; //whether the object faces the player
	xscale=image_xscale;
	yscale=image_yscale;
	if object_is_ancestor(object_index,enem) return true;
	npcKey=getNpc(object_index);
	if global.characterLocations[? npcKey][2]!=room return false;
	if instance_number(object_index)>1
	{
		//might want to override this in some cases
		return false;
	}
	if moveToLocation==1
	{
		x=global.characterLocations[? npcKey][0];
		y=global.characterLocations[? npcKey][1];
	}
	else if moveToLocation==2
	{
		//to be implemented
	}
	var _rm=room_get_name(room);
	check=global.characters[$ npcKey].ch;
	xscale=global.characters[$ npcKey].locations[$ _rm][$ global.characterLocations[? npcKey][4]].xs;
	if xscale==0 
	{
		facePlayer=true;
		xscale=1;
	}
	yscale=global.characters[$ npcKey].locations[$ _rm][$ global.characterLocations[? npcKey][4]].ys;
	npcSpecialVars();
	setObjFromStruct(id,global.characters[$ npcKey].locations[$ _rm][$ global.characterLocations[? npcKey][4]].varStruct);
	return true;
}