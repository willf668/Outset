/// @description New pathfinding target
if pfInd<array_length(moveCommand)
{
	pathfindCommandProcess(moveCommand);
	if pfWait>0
	{
		alarm[1]=pfWait;
		pfWait=0;
	}
}
else moveCommand=-1;