spd=2;
if sign(image_xscale)==-1
{
	spd*=-1;
	x+=image_xscale;
	image_xscale=abs(image_xscale);
}
if sign(image_yscale)==-1
{
	spd*=-1;
	y+=image_yscale;
	image_yscale=abs(image_yscale);
}
spr=sConveyor;
sprW=sprite_get_width(spr);
sprH=sprite_get_height(spr);
playerMoved=false;
canMoveGrapple=true;
hasPower=(global.rooms[$ room_get_name(room)].region!=worldRegion.west||roomHasPower());

objs=ds_list_create();

moveObjects=function(_xDir,_yDir) {
	ds_list_clear(objs);
	instance_place_list(x+_xDir,y+_yDir,oPhysicsObj,objs,false);
	if canMoveGrapple&&instance_exists(oGrapple)&&oGrapple.state>0&&place_meeting(x,y,oGrapple)
	{
		if oGrapple.xDir==-_xDir&&oGrapple.yDir==-_yDir 
		{
			ds_list_add(objs,instance_nearest(x,y,oGrapple));
			with oConveyor canMoveGrapple=false;
			canMoveGrapple=true;
		}
	}
	var _xMove=_yDir*-image_speed;
	var _yMove=_xDir*image_speed;
	y-=2000;
	var _this=id;
	for (var i=0;i<ds_list_size(objs);i++)
	{
		var _i=objs[|i];
		if isObj(_i,ply) //stop adjacent conveyors from moving the player multiple times
		{
			if playerMoved continue;
			with oConveyor playerMoved=true;
		}
		with _i
		{
			x+=_xMove;
			y+=_yMove;
			if object_index==oGrapple
			{
				if instance_exists(ply)
				{
					ply.state=moveState.conveyor;
					if _xDir!=0 with ply if place_meeting(x,y+1,oConveyor) y--;
				}
				
				if place_meeting(x,y,oConveyor)
				{
					var _c=instance_place(x,y,oConveyor);
					_c.canMoveGrapple=true;
					xDir=0;
					yDir=0;
					if _xDir!=0 //this is terrible but I couldn't get one uniform case to work
					{
						if y>_c.y+_c.image_yscale/2 yDir=-1;
						else yDir=-1;
						if instance_exists(ply) ply.x+=_xDir;
						xDir=0;
					}
					else if _yDir!=0
					{
						if _c.y+_c.sprite_height>_this.y+2000+_this.sprite_height 
						{
							xDir=sign(_xMove);
							if instance_exists(ply) ply.y+=_yDir;
						}
						else 
						{
							yDir=-1;
							if instance_exists(ply) ply.x+=_xDir;
						}
					}
				
					_this.canMoveGrapple=false;
					while place_meeting(x,y-2000,oConveyor)
					{
						y-=sign(xDir*_c.image_speed);
						x+=sign(yDir*_c.image_speed);
					}
					while !place_meeting(x-xDir*3,y-yDir*3,_c)
					{
						x+=xDir;
						y+=yDir;
					}
					ply.hsp=0;
					ply.vsp=0;
					image_index=2;
					grapplePositionFollowCoords();
					if yDir==-1 grappleAngle=90+180*(sign(_this.spd)==-1);
					else grappleAngle=90-90*xDir;
				}
				else while groundCollision(x,y)
				{
					x-=sign(_xMove);
					y-=sign(_yMove);
				}
				
				x=round(x);
				y=round(y);
			}
			else 
			{
				while groundCollision(x,y)
				{
					x-=sign(_xMove);
					y-=sign(_yMove);
				}
			}
		}
		//if !isObj(_i,ply)&&!place_meeting(x+_xDir,y+_yD ir,_i) impulse(2,0,_i)
	}
	y+=2000;
}