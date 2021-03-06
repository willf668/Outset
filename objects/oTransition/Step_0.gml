/// @description Transition
switch (transition)
{
	case transitions.instant:
		room_goto(global.nextRoom);
		global.roomTime=0;
		instance_destroy();
		break;
	case transitions.blackToBlack:
	case transitions.blackToWhite:
	case transitions.whiteToWhite:
	case transitions.blackSudden:
	case transitions.whiteSudden:
		if mode==0
		{
			image_alpha+=0.075;
			if image_alpha>1.4
			{
				mode=1;
				if instance_exists(ply)&&ymove==0
				{
					plyMove=buttonHold(control.right)-buttonHold(control.left);
					if plyMove==-xscale plyMove=0;
					plySpd=max(abs(ply.hsp),ply.hspMax);
				}
				if global.nextRoom!=startRoom room_goto(global.nextRoom);
				else room_restart();
				global.roomTime=0;
				image_alpha=1.05;
				if transition==transitions.blackSudden||transition==transitions.whiteSudden
				{
					image_alpha+=2;
					alarm[1]=5; //give a small window to set stuff up behind the transition
				}
			}
		}
		else
		{
			if instance_exists(ply)
			{
				ply.move=plyMove;
				ply.hsp=plySpd*plyMove;
			}
			image_alpha-=0.075;
			if image_alpha<=0 instance_destroy();
		}
		break;
}