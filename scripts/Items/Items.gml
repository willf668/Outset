function addItem(item,showFanfare){
	if is_array(item) var _item=item[0];
	else var _item=item;
	if is_undefined(showFanfare)||!showFanfare
	{
		processItem(_item);
	}
	else
	{
		processItem(_item);
		if instance_exists(oGrapple) with oGrapple event_user(0); //set upgrade variables
		//if array_length(item)>1 
		{
			var _itemText=textLoad("itemText");
			if variable_struct_exists(_itemText,_item) _itemText=_itemText[$ _item];
			else _itemText=_itemText[$ string_letters(_item)];
			
			if object_index==oTextbox with oTextbox
			{
				if is_array(_itemText[2]) text=array_combine(text,_itemText[2]);
				else array_insert(text,diag,_itemText[2]);
				
				if array_length(_itemText)>3&&_itemText[3]!=""
				{
					if _itemText[3]=="next" text=array_combine(text,_itemText[4]);
					//else text=array_combine(text,_itemText[3]);
				}
			}
			return _itemText[2];
		}
	}
	if _item=="iGrapple"&&!instance_exists(oGrapple)&&instance_exists(ply) instance_create_depth(ply.x,ply.y,depth-1,oGrapple);
	if instance_exists(oGrapple) with oGrapple event_user(0); //set upgrade variables
	if instance_exists(ply) with ply event_user(0);
}

function removeItem(item){
	if !hasItem(item) exit;
	var _rep=1;
	if is_array(item)
	{
		_rep=item[1];
	}
	var _pos=ds_list_find_index(global.playerItems,item);
	if global.playerItems[|_pos+1]-_rep<=0 
	{
		repeat 2 ds_list_delete(global.playerItems,_pos);
		var _in=ds_list_find_index(global.inventory,item);
		if _in>-1
		{
			repeat 2 ds_list_delete(global.inventory,_in);
			if global.itemSlot>=ds_list_size(global.inventory)
			{
				global.itemSlot=max(global.itemSlot-2,0);
			}
		}
	}
	else global.playerItems[|_pos+1]-=_rep;
	
}

function addDroppedItem(xPos,yPos,roomID,itemName){
	ds_list_add(global.droppedItems,itemName,xPos,yPos,roomID);
	if roomID==room
	{
		var _i=instance_create_depth(xPos,yPos,layer_get_depth(layer_get_id("people"))-1,oDroppedItem);
		_i.item=itemName;
		return _i;
	}
	return -1;
}

function createDroppedItems(){
	if instance_exists(oDroppedItem) instance_destroy(oDroppedItem);
	for (var i=0;i<ds_list_size(global.droppedItems);i+=4) if room==global.droppedItems[|i+3]
	{
		var _i=instance_create_depth(global.droppedItems[|i+1],global.droppedItems[|i+2],layer_get_depth(layer_get_id("people"))-1,oDroppedItem);
		_i.item=global.droppedItems[|i];
	}
}

function removeDroppedItem(xPos,yPos,roomID,itemName){
	for (var i=0;i<ds_list_size(global.droppedItems);i+=4) if global.droppedItems[|i]==xPos&&global.droppedItems[|i+1]==yPos&&global.droppedItems[|i+2]==roomID&&global.droppedItems[|i+3]==itemName
	{
		repeat 4 ds_list_delete(global.droppedItems,i);
		if room==roomID&&instance_exists(oDroppedItem)
		{
			for (var k=0;k<instance_number(oDroppedItem);k++)
			{
				with instance_find(oDroppedItem,k) if x==xPos&&y==yPos&&item==itemName
				{
					instance_destroy();
					break;
				}
			}
		}
		return true;
	}
	return false;
}

function removeDroppedItemName(itemName){
	for (var i=0;i<ds_list_size(global.droppedItems);i+=4) if global.droppedItems[|i+3]==itemName
	{
		repeat 4 ds_list_delete(global.droppedItems,i);
		if room==roomID&&instance_exists(oDroppedItem)
		{
			for (var k=0;k<instance_number(oDroppedItem);k++)
			{
				with instance_find(oDroppedItem,k) if item==itemName
				{
					instance_destroy();
					break;
				}
			}
		}
		return true;
	}
	return false;
}

function hasItem(item){
	return (numOfItem(item)>0);
}

function numOfItem(item){
	var _c=0;
	for (var i=0;i<ds_list_size(global.playerItems);i++) 
	{
		if string_pos(item,global.playerItems[|i])>0 _c++;
	}
	return _c;
}

function processItem(item){
	if numOfItem(item)>0 global.playerItems[|ds_list_find_index(global.playerItems,item)+1]++;
	else 
	{
		ds_list_add(global.playerItems,item,1);
		if global.itemData[? item].viewable ds_list_add(global.inventory,item,1);
		if instance_exists(ply) with ply setItemFill();
	}
}