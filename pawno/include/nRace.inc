#define function%0(%1) \
	forward%0(%1); public%0(%1)

new bool: Joined[MAX_PLAYERS];

function IsPlayerInRace(playerid)
{
	if(Joined[playerid] == true) return true;
	    else return false;
}