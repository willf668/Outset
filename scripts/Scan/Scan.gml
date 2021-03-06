function scanVars(){
	isAdded=false;
	isScanned=(ds_list_find_index(global.scanList,object_index)>-1||!hasItem("iSlate"));
	holdTime=30;
	ds_list_add(global.scanObjs,id);
	drawScanEffect=function(){
		draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,merge_color(global.scanColor,c_white,0.5),image_alpha);
	}
	scanFunc=-1;
}

function scanDraw(){
	var _inRange=(global.alive&&!isScanned&&isInRange(x,y));
	if _inRange
	{
		var _touch=instance_exists(ply)&&ply.state<moveState.jumping&&place_meeting(x,y,ply);
		if !isAdded 
		{
			ds_list_add(global.scanInRangeList,id);
			isAdded=true;
		}
		if global.scanObj==id
		{
			if global.inputs[control.confirm]>=holdTime||global.inputs[control.up]>=holdTime
			{
				isScanned=true;
				ds_list_add(global.scanList,object_index);
				var _region=global.rooms[$ room_get_name(room)].region;
				switch object_index
				{
					default:
						ds_map_replace(global.scanProgress,_region,global.scanProgress[? _region]+1);
						break;
				}
				
				var _ang;
				switch room
				{
					case rNotdon:
						_ang=point_direction(x,y,oNotdonRadar.x,oNotdonRadar.y);
						break;
					default:
						switch _region
						{
							case dungeons.vr:
							case worldRegion.east:
								_ang=point_direction(x,y,-200,-150);
								break;
							default:
								_ang=0;
								break;
						}
						break;
				}
				var _p=particle(x,y,controller.depth+1,sRadioWave,0,{
					dir:_ang,
					speed:1,
					spd:3,
					angle:_ang,
					yscale:0,
					yscaleSpd:0.075,
					yscaleMax:1,
					ghost: true,
					ghostFrameOffset: 10
				});
				if global.currentChapter==chapters.c1&&_region==worldRegion.notdon&&global.scanProgress[? _region]==1
				{
					_p.spd=5;
					if object_index==oMykoObservatoryPanel with _p conversation("c1_notdonScannedWest");
					else with _p conversation("c1_notdonScannedEast");
				}
				else save(global.lastFile);
				global.scanObj=-1;
				if scanFunc!=-1 scanFunc();
				with object_index isScanned=true;
			}
			else if buttonHold(control.up)<=0&&buttonHold(control.confirm)<=0 global.scanObj=-1;
		}
		else if global.scanObj==-1&&(buttonPressed(control.up)||buttonHold(control.confirm))&&_touch global.scanObj=id;
		drawScanEffect();
		if _touch setInteractText(6);
	}
	else
	{
		if isAdded 
		{
			ds_list_delete(global.scanInRangeList,ds_list_find_index(global.scanInRangeList,id));
			isAdded=false;
		}
	}
	return _inRange;
}

function activateScanObjs(){
	for (var i=0;i<ds_list_size(global.scanObjs);i++) if instance_exists(global.scanObjs[|i]) with global.scanObjs[|i]
	{
		isScanned=(ds_list_find_index(global.scanList,id)>-1);
	}
}