image_speed=0;
animation=new Animation();
animation.opening={type: animType.oneOff,startFrame:0,endFrame:7,frameTime:0};
animation.closing={type: animType.oneOff,startFrame:7,endFrame:0,frameTime:0};

target_x=x;

mode=0;
spd=3;
up="1";
down="1";
hasPower=false;
drawLight=function(){
	if hasPower draw_circle(round(x-1)-camX(),round(y-1)-camY(),35,false);
}

check=4;

enter=function(dir){
	mode=dir;
	setAnimation("closing",animation);
	with oElevator 
	{
		alarm[0]=-1;
		alarm[1]=-1;
	}
	alarm[0]=1;
	ply.state=moveState.floating;
	ply.hsp=0;
	ply.vsp=0;
	ply.x=x;
}

eject=function(){
	ply.state=moveState.falling;
	setAnimation("opening",animation);
	alarm[1]=1;
}