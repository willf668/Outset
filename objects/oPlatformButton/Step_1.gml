/// @description Press
if global.alive
{
	if (pressed||(distance_to_object(ply)<8&&place_meeting(x,y,ply)))&&roomHasPower()
	{
		setInteractText(check);
		if (pressed||buttonPressed(control.confirm)||buttonPressed(control.up))
		{
			playSound(sndButton,false);
			rumbleStart(rumbleType.lightPulse);
			var _num=8;
			for (var i=0;i<_num;i++)
			{
				particle(x,y,depth-1,sPlaceholderPixelW,0,{
					dir: i*360/_num,
					spd: 1,
					xscale: 3,
					yscale: 3,
					alpha: 3,
					fade: 0.15
				});
			}
			pressed=false;
			if platform.moving||platform.moveDir==moveDir
			{
				platform.moveDir=moveDir;
				platform.moving=true;
				if platform.y<camY()&&moveDir==1 platform.y=floor((camY()-24)/platform.ySpd)*platform.ySpd; //doesn't work for diagonal stuff
				if platform.y>camY()+216&&moveDir==-1 platform.y=floor((camY()+240)/platform.ySpd)*platform.ySpd;
			}
		}
	}
}