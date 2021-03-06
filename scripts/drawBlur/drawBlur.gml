

function drawBlur(surface,alpha,xPos,yPos,topLeft,botRight,drawFunc){
	printCoords(xPos,yPos)
	if !surface_exists(surface) surface=surface_create(384,216);
	surface_set_target(surface);
	draw_clear_alpha(c_black,0);
	
	if drawFunc!=-1 drawFunc();
	
	shader_set(shd_blur);
	shader_set_uniform_f(shader_get_uniform(shd_blur,"u_quality"),32);
	gpu_set_blendmode_ext(bm_inv_dest_alpha,bm_dest_alpha);
	draw_surface(application_surface,0,0);
	shader_reset();
	gpu_set_blendmode(bm_normal);
	
	surface_reset_target();
	shader_set(shd_cutout);
	shader_set_uniform_f(shader_get_uniform(shd_cutout,"top"),(topLeft[1]*alpha+yPos)/216);
	shader_set_uniform_f(shader_get_uniform(shd_cutout,"bot"),(botRight[1]*alpha+yPos)/216);
	shader_set_uniform_f(shader_get_uniform(shd_cutout,"left"),(topLeft[0]*alpha+xPos)/384);
	shader_set_uniform_f(shader_get_uniform(shd_cutout,"right"),(botRight[0]*alpha+xPos)/384);
	draw_surface(surface,camX(),camY());
	drawEffectObj(global.blurObj);
	shader_reset();
	return surface; //stops memory leak
}