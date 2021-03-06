var _col=[color_get_red(image_blend)/255,color_get_green(image_blend)/255,color_get_blue(image_blend)/255];
if !render||!surface_exists(surf)
{
	if !surface_exists(surf) surf=surface_create(room_width,room_height);
	surface_set_target(surf);
	draw_clear_alpha(c_black,0);
	shader_set(shd_solidColor);
	shader_set_uniform_f(shader_get_uniform(shd_solidColor,"u_color"),terrainBlend[0],terrainBlend[1],terrainBlend[2]);
	for (var i=0;i<ds_list_size(terrain);i++)
	{
		var _obj=terrain[|i];
		if !instance_exists(_obj)
		{
			ds_list_delete(terrain,i);
			i--;
			continue;
		}
		if _obj.image_blend!=c_white
		{
			ds_list_add(terrainColor,_obj);
			ds_list_delete(terrain,i);
			i--;
			continue;
		}
		draw_sprite_ext(_obj.sprite_index,_obj.image_index,_obj.x,_obj.y,_obj.image_xscale,_obj.image_yscale,_obj.image_angle,_obj.image_blend,_obj.image_alpha);
	}
	if instance_exists(oTerrainHitobj) with oTerrainHitobj draw_self();
	shader_reset();
	
	surface_reset_target();
	render=true;
	texRender=false;
}

if !texRender
{
	surface_set_target(surf);
	for (var i=0;i<ds_list_size(terrainColor);i++)
	{
		var _obj=terrainColor[|i];
		if !instance_exists(_obj)
		{
			ds_list_delete(terrainColor,i);
			i--;
			continue;
		}
		draw_sprite_ext(_obj.sprite_index,_obj.image_index,_obj.x,_obj.y,_obj.image_xscale,_obj.image_yscale,_obj.image_angle,_obj.image_blend,_obj.image_alpha);
	}
	
	if layerName=="myko"
	{
		gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_src_alpha);
		if global.alive draw_sprite_repeated_fullroom(0,-11,sMykoBrickTile,texInd,1,1,0,c_white,1,0,0);
		else draw_sprite_repeated(0,-11,sMykoBrickTile,texInd,1,1,0,c_white,1,0,0); //culling fine when updating often instead of only once
		gpu_set_blendmode(bm_normal);
		if !global.alive&&alarm[0]<=0
		{
			texInd=(texInd+1)%12;
			alarm[0]=2;
		}
	}
	else switch (roomType)
	{
		case worldRegion.notdon:
			gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_src_alpha);
			draw_sprite_repeated(0,0,sNotdonTerrainTexture,texInd,1,1,0,c_white,1,0,0);
			gpu_set_blendmode(bm_normal);
			if global.alive texInd=!texInd;
			alarm[0]=15+(!instance_exists(oVShip));
			break;
		case worldRegion.west:
			gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_src_alpha);
			draw_sprite_repeated_offset(0,0,sWastesRocks,0,1,1,0,c_white,1,0,0,0,60);
			gpu_set_blendmode(bm_normal);
			break;
		case worldRegion.east:
			gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_src_alpha);
			for (var i=0;i<instance_number(oTerrainGradient);i++)
			{
				var _g=instance_find(oTerrainGradient,i);
				draw_sprite_ext(_g.sprite_index,_g.image_index,-100,_g.y,(room_width+200)/_g.sprite_width,_g.image_yscale,0,-1,_g.image_alpha);
			}
			//draw_sprite_repeated(0,0,sIslandGroundTexture,0,1,1,0,c_white,0.3,0,0);
			gpu_set_blendmode(bm_normal);
			break;
		case worldRegion.core:
			shader_set(shd_lighten);
			shader_set_uniform_f(shader_get_uniform(shd_lighten,"u_bright"),0.5);
			shader_set_uniform_f(shader_get_uniform(shd_lighten,"u_color"),1,1,1);
		case worldRegion.testing:
		case worldRegion.vr:
			gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_src_alpha);
			draw_sprite_repeated_fullroom(0,0,sMykoBrickGreyTile,0,1,1,0,c_white,1,0,0);
			gpu_set_blendmode(bm_normal);
			if shader_current()!=-1 shader_reset();
			break;
	}
	if instance_number(oTerrain)>1&&layerName!="myko"
	{
		gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_src_alpha);
		shader_set(shd_outlineOutside);
		shader_set_uniform_f(shader_get_uniform(shd_outlineOutside,"u_alpha"),1);
		shader_set_uniform_f(shader_get_uniform(shd_outlineOutside,"u_pixel"),1/room_width,1/room_height);
		shader_set_uniform_f(shader_get_uniform(shd_outlineOutside,"u_color"),colorData[roomType].outlineCol[0]*_col[0],colorData[roomType].outlineCol[1]*_col[1],colorData[roomType].outlineCol[2]*_col[2]);
		with oTerrain if layerName=="myko"&&surface_exists(surf)
		{
			draw_surface(surf,0,0);
		}
		gpu_set_blendmode(bm_normal);
		shader_reset();
	}
	surface_reset_target();
	texRender=true;
}

var _width=min(386,room_width);
var _height=min(218,room_height);
var _posX=max(floor(camX()),0);
var _posY=max(floor(camY()),0);
var _outlineAlpha=1;
if !surface_exists(surf2) surf2=surface_create(386,218);
surface_set_target(surf2);
draw_clear_alpha(c_black,0);
if layerName=="myko"
{
	shader_set(shd_outline);
	shader_set_uniform_f(shader_get_uniform(shd_outline,"u_alpha"),_outlineAlpha);
	shader_set_uniform_f(shader_get_uniform(shd_outline,"u_pixel"),texture_get_texel_width(surface_get_texture(surf)),texture_get_texel_height(surface_get_texture(surf)));
	shader_set_uniform_f(shader_get_uniform(shd_outline,"u_color"),
		colorData[mykoBlendInd].outlineCol[0]*_col[0],
		colorData[mykoBlendInd].outlineCol[1]*_col[1],
		colorData[mykoBlendInd].outlineCol[2]*_col[2]);
}
else switch (roomType)
{
	case worldRegion.core:
	case worldRegion.west:
		shader_set(shd_outlineTerrain);
		shader_set_uniform_f(shader_get_uniform(shd_outlineTerrain,"u_alpha"),_outlineAlpha);
		shader_set_uniform_f(shader_get_uniform(shd_outlineTerrain,"u_pixel"),texture_get_texel_width(surface_get_texture(surf)),texture_get_texel_height(surface_get_texture(surf)));
		switch room
		{
			default:
				shader_set_uniform_f(shader_get_uniform(shd_outlineTerrain,"u_color"),colorData[roomType].outlineCol[0]*_col[0],colorData[roomType].outlineCol[1]*_col[1],colorData[roomType].outlineCol[2]*_col[2]);
				break;
		}
		break;
	case worldRegion.east:
		_outlineAlpha=0.3;
	case worldRegion.deeptown:
	case worldRegion.notdon:
		shader_set(shd_outlineTerrain); //TODO: LINUX BUG
		if room==rNotdon&&instance_exists(oSkyNotdon) shader_set_uniform_f(shader_get_uniform(shd_outlineTerrain,"u_bw"),oSkyNotdon.vShipTime);
		shader_set_uniform_f(shader_get_uniform(shd_outlineTerrain,"u_alpha"),_outlineAlpha);
		shader_set_uniform_f(shader_get_uniform(shd_outlineTerrain,"u_pixel"),texture_get_texel_width(surface_get_texture(surf)),texture_get_texel_height(surface_get_texture(surf)));
		shader_set_uniform_f(shader_get_uniform(shd_outlineTerrain,"u_color"),colorData[roomType].outlineCol[0]*_col[0],colorData[roomType].outlineCol[1]*_col[1],colorData[roomType].outlineCol[2]*_col[2]);
		break;
	case worldRegion.testing:
	case worldRegion.vr:
		if room!=rVRUnfinished&&room!=rDevRoom&&vrAlpha<1&&(!instance_exists(oTextbox)||oTextbox.image_alpha==0)&&hasItem("iGrapple") 
		{
			if !instance_exists(oVRGrappleBG)
			{
				var _b=instance_create_layer(0,0,"bg2",oVRGrappleBG);
			}
			vrAlpha+=0.025;
		}
		shader_set(shd_outlineTerrain);
		shader_set_uniform_f(shader_get_uniform(shd_outlineTerrain,"u_alpha"),_outlineAlpha);
		shader_set_uniform_f(shader_get_uniform(shd_outlineTerrain,"u_pixel"),texture_get_texel_width(surface_get_texture(surf)),texture_get_texel_height(surface_get_texture(surf)));
		shader_set_uniform_f(shader_get_uniform(shd_outlineTerrain,"u_color"),
			lerp(colorData[worldRegion.notdon].outlineCol[0]*_col[0],colorData[vrBlendInd].outlineCol[0]*_col[0],vrAlpha),
			lerp(colorData[worldRegion.notdon].outlineCol[1]*_col[1],colorData[vrBlendInd].outlineCol[1]*_col[1],vrAlpha),
			lerp(colorData[worldRegion.notdon].outlineCol[2]*_col[2],colorData[vrBlendInd].outlineCol[2]*_col[2],vrAlpha));
		image_blend=merge_color(c_white,global.scanColor,0.15*vrAlpha);
		if instance_exists(oTileCrack) oTileCrack.image_blend=image_blend;
		break;
	default: break;
}

draw_surface_part_ext(surf,
_posX,_posY,
_width+1,_height+1,
0,0,1,1,image_blend,image_alpha
);
if shader_current()!=-1 shader_reset();

if global.alive&&room!=rCoreIntro
{
	if deathScale>0 deathScale-=0.04;
	if deathDist>0 deathDist=max(deathDist-7,0);
}
else if instance_exists(ply)
{
	if deathScale<1 deathScale+=0.02;
	if deathDist<deathDistMax deathDist+=3;
}
if deathScale>0||deathDist>0
{
	var _deathCol=merge_color(c_white,global.scanColor,0.5);
	var _isGood=true;
	var _youCol=_deathCol;
	if room==rCoreIntro||layerName=="myko"
	{
		_deathCol=merge_color(c_red,c_white,0.3+0.1*sin((global.roomTime)%360)/360*2*pi);
		_youCol=c_white;
		_isGood=false;
	}
	var _deathCol2=merge_color(_deathCol,c_black,0.3);
	var _youCol2=merge_color(_youCol,c_black,0.3);
	deathAng=(deathAng-2*ply.xscale)%360;
	gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_src_alpha);
	draw_sprite_ext(sDeathCircle,!_isGood,ply.x-camX(),ply.y-camY(),deathScale,deathScale,deathAng,_youCol,1); //outer death circle
	var _saveVis=(global.roomTime%180)/180*2*pi;
	if instance_exists(oSave)&&instance_exists(ply)
	{
		var _closestSave=instance_nearest(ply.x,ply.y,oSave);
		deathDistanceToSave=min(point_distance(_closestSave.x,_closestSave.y,ply.x,ply.y),deathMaxDistanceToSave);
		deathSaveAng=(deathSaveAng+4-(deathDistanceToSave/deathMaxDistanceToSave)*3.65)%360;
		for (var i=0;i<instance_number(oSave);i++)
		{
			var _s=instance_find(oSave,i);
			var _rayNum=6;
			for (var k=0;k<_rayNum;k++)
			{
				var _ang=360*k/_rayNum+deathSaveAng;
				repeat 1+floor(deathDistanceToSave/80)
				{
					draw_sprite_ext(sMissileTrail,1,_s.x-camX(),_s.y-camY(),deathScale,deathScale*2,_ang,_youCol,1);
					draw_sprite_ext(sMissileTrail,1,_s.x-camX(),_s.y-camY(),deathScale,deathScale*2,_ang,_youCol,1);
					_ang-=1.3;
				}
			}
			draw_sprite_ext(sDeathCircle,!_isGood,_s.x-camX(),_s.y-camY(),deathScale*0.9-0.1*sin(_saveVis),deathScale*0.9-0.1*sin(_saveVis),cos(_saveVis)*15,_youCol,1);
		}
	}
	if _isGood draw_sprite_ext(sDeathCircle,0,ply.x-camX(),ply.y-camY(),min(deathScale,0.5),min(deathScale,0.5),deathAng,_youCol2,1);
	gpu_set_blendmode(bm_normal);
	surface_reset_target();
	
	var _deathColRGB=[color_get_red(_deathCol)/255,color_get_green(_deathCol)/255,color_get_blue(_deathCol)/255];
	var _deathCol2RGB=[color_get_red(_deathCol2)/255,color_get_green(_deathCol2)/255,color_get_blue(_deathCol2)/255];
	var _shader=(_isGood? shd_outlineTerrainDeath: shd_outlineTerrainDeathThin);
	shader_set(_shader);
	var _w=1/surface_get_width(surf2);
	var _h=1/surface_get_height(surf2);
	
	shader_set_uniform_f(shader_get_uniform(_shader,"u_pixel"),_w,_h);
	shader_set_uniform_f(shader_get_uniform(_shader,"u_color"),_deathCol2RGB[0],_deathCol2RGB[1],_deathCol2RGB[2]);
	shader_set_uniform_f(shader_get_uniform(_shader,"u_origin"),(ply.x-camX())*_w,(ply.y-camY())*_h);
	shader_set_uniform_f(shader_get_uniform(_shader,"u_dist"),deathDist*_w,deathDist*_h);
	
	var _camDiff=0;
	if instance_exists(oCamera) _camDiff=sqrt(sqr(oCamera.x-oCamera.xprevious)+sqr(oCamera.y-oCamera.yprevious));
	if _camDiff==0 deathBubbleProg-=ply.xscale*(0.01);
	else deathBubbleProg=lerp(deathBubbleProg,0.5+ply.xscale*0.45,_camDiff/30);
	if deathBubbleProg<0 deathBubbleProg=1;
	else if deathBubbleProg>1 deathBubbleProg=0;
	shader_set_uniform_f(shader_get_uniform(_shader,"u_rippleProg"),deathBubbleProg*2*pi);
}
else surface_reset_target();

draw_surface(surf2,_posX,_posY);
//if layerName!="myko" draw_surface(surf2,_posX,_posY);
if shader_current()!=-1 shader_reset();

//if !global.alive pauseAlarms(0);