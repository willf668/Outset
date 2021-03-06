event_inherited();

ind=0;
isHit=true;
hit=instance_create_depth(x,y,depth+1,hitobj);
hit.parentBranch=id;

updateColl=function(){
	hit.image_xscale=image_xscale;
	hit.image_yscale=image_yscale;
	
	with hit
	{
		while place_meeting(x,y,ply)
		{
			ply.x+=sign(parentBranch.xSpd)*(parentBranch.active-(!parentBranch.active));
			ply.y+=sign(parentBranch.ySpd)*(parentBranch.active-(!parentBranch.active));
		}
		
		while place_meeting(x,y,oSoulDoor)
		{
			var _d=instance_place(x,y,oSoulDoor);
			while place_meeting(x,y,oSoulDoor) _d.y--//+=sign(image_yscale);
		}
	}
}