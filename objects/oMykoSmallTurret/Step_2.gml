/// @description Visuals
if alarm[0]>-1
{
	if alarm[0]%6==0
	{
		var _e=explosionRange(1,x-32,y-32,x+32,y+32,0);
		_e.alwaysMove=true;
	}
}