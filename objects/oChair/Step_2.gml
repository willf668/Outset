/// @description 
if !global.menuOpen
{
	if text!=-1 check=1;
	else check=9;
	if !sitting
	{
		if distance_to_object(ply)<=abs(sprite_width)&&ply.visible&&(image_index==0||text!=-1)&&place_meeting(x,y,ply)&&!place_meeting(x,y,npc)
		{
			setInteractText(check);
			if ply.state<=moveState.running&&(buttonPressed(control.confirm)||buttonPressed(control.up))
			{
				if text!=-1
				{
					conversation(text);
				}
				else
				{
					sit();
				}
			}
		}
	}
	else
	{
		ply.x=x;
		ply.y=y;
		var _exit=false;
		if buttonPressed(control.jump)
		{
			_exit=true;
			ply.state=moveState.jumping;
		}
		else if buttonPressed(control.confirm)
		{
			_exit=true;
			ply.state=moveState.standing;
		}
		else if instance_exists(oGrapple)&&oGrapple.state>1
		{
			_exit=true;
			ply.state=moveState.pulling;
		}
	
		if _exit
		{
			eject();
		}
	}
}