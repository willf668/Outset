/// @description Draw application surface
var _scX=window_get_width()/384;
var _scY=window_get_height()/216;
gpu_set_blendenable(false);
//Post process
var _w=1/surface_get_width(application_surface);
var _h=1/surface_get_height(application_surface);
var _xView=camera_get_view_x(global.cam);
var _yView=camera_get_view_y(global.cam);
var _hView=camera_get_view_height(global.cam);
var _wView=camera_get_view_width(global.cam);
var _roomName=room_get_name(room);
if !surface_exists(postProcessSurf) postProcessSurf=surface_create(384,216);
if pp{
var _px=camX()+192;
var _py=camY()+192;
if instance_exists(ply)
{
	_px=ply.x;
	_py=ply.y;
}

if ds_list_size(global.distortObj)>0 //Distortion
{
	if !surface_exists(distSurf) distSurf=surface_create(384,216)
	surface_set_target(distSurf);
	draw_clear_alpha(COLOUR_FOR_NO_MOVE,0);
	for (var i=0;i<ds_list_size(global.distortObj);i++)
	{
		if !instance_exists(global.distortObj[|i])
		{
			ds_list_delete(global.distortObj,i);
			i--;
			continue;
		}
		with global.distortObj[|i] draw_sprite_ext(sprite_index,image_index,x-camX(),y-camY(),image_xscale,image_yscale,image_angle,image_blend,image_alpha);
	}
	//gpu_set_blendmode(bm_subtract);
	//with ply draw_sprite(sprite_index,image_index,x-camX(),y-camY());
	//gpu_set_blendmode(bm_normal);
	//if instance_exists(ply) draw_sprite(sNormalRipple,0,ply.x-camX(),ply.y-camY());
	surface_reset_target();

	var surface_texture_page=surface_get_texture(distSurf);
	shader_set(shd_distort);
	texture_set_stage(distortion_stage, surface_texture_page);
	surface_set_target(postProcessSurf);
	draw_surface(application_surface,0,0);
	shader_reset();
	//draw_surface(distSurf,0,0)
	removePPPart();
	//with ply draw_sprite(sprite_index,image_index,x-camX(),y-camY());
}
else surface_free(distSurf);
if !global.alive&&instance_exists(ply)&&abs(ply.x-(camX()+192))<300&&abs(ply.y-(camY()+108))<200
{
	if deathGlowProg<1 deathGlowProg+=0.05;
}
else if deathGlowProg>0 deathGlowProg-=0.05;
if deathGlowProg>0 //Death vinette
{
	surface_set_target(postProcessSurf);
	var _prog=87;
	if instance_exists(oTerrain) _prog+=(1-oTerrain.deathDist/oTerrain.deathDistMax)*140;
	else _prog+=(deathGlowProg)*140;
	shader_set(shd_tunnelVision);
	shader_set_uniform_f(shader_get_uniform(shd_tunnelVision,"u_pixel"),_w,_h);
	shader_set_uniform_f(shader_get_uniform(shd_tunnelVision,"u_origin"),(lerp(192,_px-camX(),0.5))*_w,(lerp(108,_py-camY(),0.5))*_h);
	shader_set_uniform_f(shader_get_uniform(shd_tunnelVision,"u_dist"),_prog*_w,_prog*_h);
	var _tunnelCol=merge_color(global.scanColor,c_white,0.5);
	shader_set_uniform_f(shader_get_uniform(shd_tunnelVision,"u_tunnelColor"),color_get_red(_tunnelCol)/255,color_get_green(_tunnelCol)/255,color_get_blue(_tunnelCol)/255);
	draw_surface(application_surface,0,0);
	shader_reset();
	removePPPart();
}

if false&&global.rooms[$ _roomName].region==worldRegion.west
{
	surface_set_target(postProcessSurf);
	draw_clear_alpha(c_black,0);
	var _color=c_white;
	switch room
	{
		default:
			switch global.rooms[$ _roomName].region
			{
				default: break;
			}
			break;
	}
	var _a=image_alpha;
	if instance_exists(oTerrain) _a=(1-oTerrain.deathDist/oTerrain.deathDistMax);
	if global.alive fogTime+=0.001;
	ppFog(sFogBigChunky,-camX(),-camY(),1.5,0.15,min(_a+global.alive,1.1),_color,18.0-((room_height-camY())/216),fogTime,true);
	removePPPart();
}
}

//draw transition
if instance_exists(oTransition)
{
	surface_set_target(postProcessSurf);
	with oTransition draw();
	removePPPart();
}
gpu_set_blendenable(true);

//draw hud
surface_set_target(application_surface);
draw(0,0);
if instance_exists(oTextbox) with oTextbox draw(0,0);
surface_reset_target();

//draw
gpu_set_blendenable(false);
var _x=0;
var _y=0;
if instance_exists(oCamera) //fix camera shake
{
	_x=oCamera.shakeRandX;
	_y=oCamera.shakeRandY;
}
draw_surface_ext(application_surface, _x*_scX, _y*_scY, _scX,_scY, 0, c_white, 1);
gpu_set_blendenable(true);