/// @description Move Down
alarm[0]=-1;
if instance_exists(oCursor) instance_destroy(oCursor);
if yOff<216
{
	yOff+=3;
	alarm[1]=1;
}