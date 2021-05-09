/// @description Move + animation
if moving
{
	x+=(target_x-x)/10;
	y+=(target_y-y)/10;
	if abs(x-target_x)<3&&abs(y-target_y)<3
	{
		x=target_x;
		y=target_y;
		moving=false;
		mode=0;
		depth=startDepth;
	}
}
else if mode>0
{
	x=mouse_x+mouseXOff;
	y=mouse_y+mouseYOff;
	var _cardPlace=-1;
	if mode==1
	{
		if card==cards.king&&place_meeting(x,y,oCardCell)&&instance_place(x,y,oCardCell).child==-1
		{
			_cardPlace=instance_place(x,y,oCardCell);
		}
		else if child==-1&&place_meeting(x,y,oCardFoundation)
		{
			var _cf=instance_place(x,y,oCardFoundation);
			if card==cards.ace&&_cf.child==-1 _cardPlace=_cf;
			else
			{
				var _place=ds_list_create();
				instance_place_list(x,y,oCard,_place,false);
				for (var i=0;i<ds_list_size(_place);i++)
				{
					var _c=_place[|i];
					if _c.depth<depth||_c.child!=-1 continue;
					if _c.suit==suit&&_c.card==card-1
					{
						_cardPlace=_c;
						break;
					}
				}
				ds_list_destroy(_place);
			}
		}
		else
		{
			var _place=ds_list_create();
			instance_place_list(x,y,oCard,_place,false);
			for (var i=0;i<ds_list_size(_place);i++)
			{
				var _c=_place[|i];
				if _c.depth<depth||_c.child!=-1||_c.inDeck continue;
				if _c.textCol!=textCol&&_c.card==card+1
				{
					_cardPlace=_c;
					break;
				}
			}
			ds_list_destroy(_place);
		}
	}
	if !buttonHold(control.confirm)&&mode==1
	{
		if _cardPlace==-1
		{
			if parent!=-1 parent.child=id;
		}
		else
		{
			if parent!=-1
			{
				if !inDeck
				{
					if sign(parent.image_xscale)==-1 parent.alarm[2]=1;
				}
				else
				{
					oCardDraw.topCard=parent;
				}
				parent.child=-1;
			}
			parent=_cardPlace;
			parent.child=id;
			target_x=parent.x;
			target_y=parent.y;
			isFound=place_meeting(target_x,target_y,oCardFoundation);
			if !isFound target_y+=2+6*(parent.object_index==oCard);
			_yOff=8;
			startDepth=parent.depth-1;
			for (var i=child;i!=-1;i=i.child) 
			{
				i.target_x=target_x;
				i.target_y=_yOff+target_y;
				_yOff+=8;
				i.startDepth=startDepth-(_yOff/8)-1;
			}
			
			if inDeck 
			{
				ds_list_delete(oCardDraw.cardList,ds_list_find_index(oCardDraw.cardList,id));
				inDeck=false;
			}
		}
		
		moving=true;
		for (var i=child;i!=-1;i=i.child) i.moving=true;
	}
}
else if mode==0
{
	if inDeck||child==-1||global.inputs[control.confirm]>1 mask_index=sCard;
	else mask_index=sCardHit;
	if buttonPressed(control.confirm)&&sign(image_xscale==1)&&place_meeting(x,y,oMouse)
	{
		if !inDeck&&!isFound
		{
			if parent!=-1 parent.child=-1;
			mode=1;
			depth-=100;
			mouseXOff=x-mouse_x;
			mouseYOff=y-mouse_y;
			for (var i=child;i!=-1;i=i.child) with i
			{
				mode=2;
				depth-=100;
				mouseXOff=x-mouse_x;
				mouseYOff=y-mouse_y;
			}
		}
		else
		{
			if child==-1
			{
				mode=1;
				depth=-100;
				mouseXOff=x-mouse_x;
				mouseYOff=y-mouse_y;
			}
		}
	}
}