var _rName=room_get_name(room);
global.roomTime=0;
if !visitedRoom(room) ds_list_add(global.visitedRooms,room);

//show layers
var _lArr=["bg","bg2","above"];
for (var i=0;i<array_length(_lArr);i++)
{
	
	var _l=layer_get_id(_lArr[i]);
	if _l>-1 layer_set_visible(_l,true);
}

//change music
if instance_exists(oMusicChange) instance_destroy(oMusicChange);
instance_create_depth(x,y,0,oMusicChange);

//setup camera
if !instance_exists(oCamera) createCamera();

//set era-specific stuff
ds_list_clear(global.distortObj);
ds_list_clear(global.distortObjAberrate);
ds_list_add(global.distortObjAberrate,oSouldropCoin);

setRoomEra();
setRoomLighting(_rName);

scrAirChange();

//load npcs
createNPCs();

//create dropped items
createDroppedItems();

//set terrain
setTerrain();

//create soul doors
if !global.alive createSoulDoors();

//create persistent objects
persistentEventsSet("any");
persistentEventsSet(room);

//freeze npcs
if !global.alive&&room==global.dieRoom setFrozenNPC();

//water check
global.inWater=false;
if instance_exists(ply) with ply global.inWater=place_meeting(x,y,oWater);

//DEBUG: player position
global.menuOpen=false;
if global.devTeleport&&!instance_exists(oTextbox)
{
	if instance_exists(ply)
	{
		with ply
		{
			global.menuOpen=false;
			x=xstart;
			y=ystart;
		}
	}
	global.devTeleport=false;
}

if instance_exists(oPlayerCam) 
{
	oPlayerCam.x=ply.x;
	oPlayerCam.y=ply.y;
	oCamera.x=oPlayerCam.x;
	oCamera.y=oPlayerCam.y;
	oCamera.xTo=oCamera.x;
	oCamera.yTo=oCamera.y;
}
with oCamera findCameraPosition(true);

//souldrop
alarm[2]=3;


//background
switch room //room specific elements
{
	case rDevRoom:
	case rNotdon:
		//instance_create_layer(2175,600,"bg2",oReactorBG);
		var _m=instance_create_layer(588,678,"bg2",oNotdonMountains);
		_m.image_xscale=-1;
		_m.tileX=3;
		instance_create_layer(2119,744,"bg2",oNotdonMountains);
		instance_create_layer(1011,211,"bg2",oNotdonMountains);
		instance_create_layer(0,0,"bg",oOvercast);
		var _o=instance_create_layer(0,0,"bg",oOvercast);
		_o.image_index=1;
		instance_create_depth(0,0,layer_get_depth(layer_get_id("behindMyko"))+1,oSmokeBG);
		oSmokeBG.xLerp=0.3;
		oSmokeBG.yLerp=0.3;
		instance_create_depth(0,0,layer_get_depth(layer_get_id("behindMyko"))+2,oSmokeBG);
		break;
	case rWastesNotdon:
	case rNotdonWell:
		var _b=instance_create_layer(0,0,"bg",oBackground);
		_b.sprite_index=sNotdonUnderBG;
		_b.tileX=true;
		_b.tileY=true;
		break;
	case rIsland:
		instance_create_layer(1456,-70,"bg",oIslandTreeBG);
		var _t=instance_create_layer(1231,-70,"bg",oIslandTreeBG);
		with _t
		{
			image_blend=merge_color(c_white,c_black,0.3);
			xLerp=0.65;
			yLerp=0.65;
		}
		break;
	case rAirSatelliteOutside:
	case rAir:
		instance_create_layer(1200,600,"bg2",oAirClouds);
		break;
	default: break;
}
switch room //skybox/specific configs
{
	case rWastesBullet:
		instance_create_layer(0,0,"bg",oSkyWastes);
		break;
	case rWastesIntro:
	case rWastesBorder:
		var _c=instance_create_depth(0,200,layer_get_depth(layer_get_id("bg"))-5,oWastesClouds);
		var _c2=instance_create_depth(0,100,layer_get_depth(layer_get_id("bg"))-5,oWastesClouds);
		with _c2
		{
			xLerp=0.7;
			yLerp=0.7;
			image_xscale=-0.6;
			image_yscale=0.6;
		}
		if room==rWastesIntro oWastesClouds.y-=20;
		instance_create_layer(300,60,"bg2",oNotdonMountains);
		instance_create_layer(0,0,"bg2",oOvercast);
		var _o=instance_create_layer(0,0,"bg",oOvercast);
		_o.image_index=1;
		instance_create_depth(0,0,depth,oWastesBorderBGFade);
		instance_create_layer(0,0,"bg",oSkyWastes);
		instance_create_layer(0,0,"bg",oSkyNotdon);
		var _fog=instance_create_layer(0,0,"behindMyko",oFogBG);
		_fog.xLerp=0;
		_fog.yLerp=0;
		_fog.preset=1;
		_fog.image_xscale=1.5;
		_fog.image_yscale=0.1;
		_fog.image_yscale=0.2;
		break;
	case rWastesFactoryOutside:
	case rWastesCrater:
	case rWastesHilltop:
	case rWastes:
		var _fog=instance_create_layer(0,0,"behindMyko",oFogBG);
		_fog.xLerp=0;
		_fog.yLerp=0;
		_fog.preset=1;
		_fog.image_xscale=1.5;
		_fog.image_yscale=0.1;
		_fog.image_yscale=0.2;
		
		instance_create_layer(0,800,"bg2",oWastesClouds);
		var _hill=instance_create_layer(0,910,"bg2",oWastesHillBG);
		with _hill setBGPosition(x,y);
		var _xs=1;
		var _x=0;
		for (var i=0;_x<room_width;i++)
		{
			var _t=instance_create_layer(_x,960+irandom_range(-30,90),"bg2",oWastesTreeBG);
			_t.image_index=i%3;
			_t.image_xscale=_xs;
			with _t setBGPosition(x,y);
			if i%3==2 _xs*=-1;
			_x+=sprite_get_width(sWastesTreeBG)+40+irandom(60);
		}
		var _c=instance_create_layer(0,600,"bg2",oWastesClouds);
		with _c
		{
			xLerp=0.7;
			yLerp=0.7;
			image_xscale=-0.6;
			image_yscale=0.6;
		}
		
		var _hill2=instance_create_layer(0,770,"bg",oWastesHillBG);
		_hill2.xLerp=0.75;
		_hill2.yLerp=_hill2.xLerp;
		_hill2.image_blend=c_black;
		with _hill2 setBGPosition(x,y);
		var _xs=0.5;
		var _x=0;
		for (var i=0;_x<room_width;i++)
		{
			var _t=instance_create_layer(_x,820+irandom_range(-30,50),"bg",oWastesTreeBG);
			_t.image_index=i%3;
			_t.image_xscale=_xs;
			_t.image_yscale=0.5;
			_t.image_blend=merge_color(c_white,c_black,0.6);
			_t.xLerp=0.75;
			_t.yLerp=_t.xLerp;
			with _t setBGPosition(x,y);
			if i%3==2 _xs*=-1;
			_x+=sprite_get_width(sWastesTreeBG)+40+irandom(60);
		}
		instance_create_layer(0,0,"bg",oSkyWastes);
		break;
	case rWastesFactoryEntrance:
	case rWastesFactoryShaft:
	case rWastesFactoryWorkers:
	case rWastesFactory1:
	case rWastesFactory2:
		var _til=instance_create_layer(0,0,"bg",oBackground);
		_til.sprite_index=sMykoMachineBG;
		_til.tileX=true;
		_til.tileY=true;
		var _pipe=instance_create_layer(0,0,"bg2",oBackground);
		_pipe.sprite_index=sMykoMachineBG;
		_pipe.image_index=1;
		_pipe.xLerp=0.15;
		_pipe.yLerp=0.15;
		_pipe.tileX=true;
		_pipe.tileY=true;
		
		var _c=instance_create_layer(room_width/2,-200,"bg2",oBackground);
		_c.xLerp=0.23;
		_c.yLerp=0.23;
		_c.image_blend=merge_color(c_white,c_black,0.45);
		_c.sprite_index=sWastesCraneWrecked;
		_c.image_index=3;
		_c.tileXSMult=-1;
		_c.tileY=true;
		with _c setBGPosition(x,y);
		
		if room==rWastesFactory1||room==rWastesFactory2
		{
			var _c2=instance_create_layer(room_width/2,-400,"bg2",oBackground);
			_c2.xLerp=0.23;
			_c2.yLerp=0.23;
			_c2.image_blend=merge_color(c_white,c_black,0.7);
			_c2.sprite_index=sWastesCraneWrecked;
			_c2.image_index=2;
			_c2.tileXSMult=-1;
			_c2.tileY=true;
			with _c2 setBGPosition(x,y);
		}
		
		with oBackground if sprite_index==sWastesCraneWrecked yOsci=new oscillateVars(6,6);
		
		var _pipe=instance_create_layer(0,0,"bg2",oBackground);
		_pipe.sprite_index=sMykoMachineBGSmall;
		_pipe.xLerp=0.35;
		_pipe.yLerp=0.35;
		_pipe.tileX=true;
		_pipe.tileY=true;
		break;
	case rDevRoom:
	case rNotdon:
		instance_create_layer(0,0,"bg",oSkyNotdon);
		break;
	case rHaroldVRStart:
	case rVR1:
	case rVR2:
	case rVR3:
	case rVR4:
	case rVR5:
	case rVR6:
	case rVR7:
	case rVR8:
	case rVRPreBoss:
	case rVRBoss:
		instance_create_layer(0,0,"bg",oVRSkybox);
		break;
	case rVRUnfinished:
		instance_create_layer(0,0,"bg",oSkyVR);
		break;
	case rIsland:
		instance_create_layer(0,0,"bg",oSkyIsland);
		break;
	case rAirSatelliteOutside:
	case rAir:
		instance_create_layer(0,0,"bg2",oOvercast);
		var _o=instance_create_layer(0,0,"bg",oOvercast);
		_o.image_index=1;
		oOvercast.tileX=true;
		oOvercast.tileY=true;
		instance_create_layer(0,0,"bg",oSkyAir);
		break;
	default: break;
}
//discord
if !isHtml&&os_type!=os_linux setDiscordStatus();