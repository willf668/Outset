if global.currentChapter!=chapters.c1||getDungeonProgress(dungeons.vr)>1
{
	target_x=194;
	target_y=174;
	targetroom=rHarold;
	xscale=-1;
}
else
{
	var _i=instance_create_layer(x,y,layer,oInteractable);
	_i.mask_index=sprite_index;
	_i.text=textLoad("c1_haroldDoor");
	instance_destroy();
}