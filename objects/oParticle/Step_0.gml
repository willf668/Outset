if alwaysMove||global.alive
{
	x+=lengthdir_x(spd,direction)+hsp;
	y+=lengthdir_y(spd,direction)+vsp;
	vsp+=grav;
	image_alpha-=fade;
	if point image_angle=point_direction(xprevious,yprevious,x,y);
	else image_angle+=angSpd;
	if image_alpha<0 instance_destroy();
	else if offscreen(x,y)
	{
		if !startOffscreen instance_destroy();
	}
	else startOffscreen=false;
	if isHit&&(x!=xprevious||y!=yprevious)
	{
		if instance_exists(oTerrain) oTerrain.render=false;
	}
}