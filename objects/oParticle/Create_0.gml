image_speed=0

spd=0; //speed in direction
xscaleSpd=0;
xscaleMin=-1;
xscaleMax=1000;
yscaleSpd=0;
yscaleMin=-1;
yscaleMax=1000;
fade=0; //fade out (subtracted from image_alpha)
grav=0; //force of gravity
vsp=0; //vertical spd
hsp=0;
point=false; //point towards motion direction
isHit=false; //should be textured as terrain
alwaysMove=false; //move even when dead
angSpd=0; //angular speed
followObj=noone;
ghost=false; //ghostParticle
ghostFrameOffset=4;
ghostDepth=depth+1;

startOffscreen=true; //whether it starts offscreen