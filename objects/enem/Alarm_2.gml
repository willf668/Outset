/// @description Soul flash
if enemActive circularParticle(x,y,depth+1,{
	alpha:1.25,
	fade:0.05,
	radiusSpd:2,
	blend: c_soulBlue,
	followObj: id
});

alarm[2]=flashTime;