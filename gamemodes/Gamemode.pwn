// .:--------------------------------------------------------------:.
// .:==============================================================:.
//       { Blank Y_INI Gamemode created for SA:MP by Kingunit   }
//       { Please do not remove the credits and re-release it   }
//       { This gamemode is created by Kingunit on 24/08/2011   }
//       { This Blank Y_INI Gamemode is using ZCMD and SSCANF   }
//       { Other credits are going to SSCANF and ZCMD and Y_INI }
//       { Special credits to Kush, For things out his Tutorial }
//       { Credits for Roleplay Edit of Kingunit's script goes to iNorton }
//
// .:==============================================================:.
// .:--------------------------------------------------------------:.

//-----[Main includes]-----
#include <a_samp>
#include <YSI\y_ini>
#include <zcmd>
#include <sscanf2>
#include <irc>
#include <foreach>
#pragma tabsize 0

//-----[IRC Settings]-----
#define IRC_SERVER "irc.crystalirc.net"
#define IRC_PORT (6667)
#define IRC_CHANNEL "#Warehouse"

#define BOT_1_NICKNAME "SA-MP Bot[1]"
#define BOT_1_REALNAME "SA-MP Bot[1]"
#define BOT_1_USERNAME "SA-MP Bot[1]"

#define MAX_BOTS (1)

new gBotID[MAX_BOTS], gGroupID;

//-----[INI includes]-----
#define DIALOG_REGISTER 1
#define DIALOG_LOGIN 2
#define PATH "/Users/%s.ini"

//-----[Color defines]-----
#define COLOR_WHITE             0xFFFFFFFF
#define COLOR_GREEN             0x33AA33AA
#define COLOR_RED               0xA10000AA
#define COLOR_YELLOW            0xFFFF00AA
#define COLOR_GREY				0xAFAFAFAA
#define COLOR_SYNTAX            0x33CCFFAA
#define COLOR_ERROR				0xFF3300AA
#define LIME 					0x88AA62FF
#define WHITE 					0xFFFFFFAA
#define RULE 					0xFBDF89AA
#define ORANGE 					0xDB881AAA
#define COLOR_YELLOW3 			0xFFFF00FF

#define GREY 					0xAFAFAFAA
#define GREEN 					0x9FFF00FF
#define RED 					0xA10000AA
#define YELLOW 					0xFFFF00AA
#define WHITE 					0xFFFFFFAA
#define COLOR_ME 		0x9370DBFF

//-----[0.3c Color defines]-----
#define COL_EASY           "{FFF1AF}"
#define COL_DGREEN		   "{0E8C00}"
#define COL_LOGIN		   "{98E090}"
#define COL_WHITE          "{FFFFFF}"
#define COL_BLACK          "{0E0101}"
#define COL_GREY           "{C3C3C3}"
#define COL_GREEN          "{6EF83C}"
#define COL_RED            "{F81414}"
#define COL_YELLOW         "{F3FF02}"
#define COL_ORANGE         "{F9B857}"
#define COL_LIME           "{B7FF00}"
#define COL_CYAN           "{00FFEE}"
#define COL_LBLUE          "{298ACF}"
#define COL_BLUE           "{0049FF}"
#define COL_MAGENTA        "{F300FF}"
#define COL_VIOLET         "{B700FF}"
#define COL_PINK           "{FF00EA}"
#define COL_MARONE         "{A90202}"
#define COL_CMD            "{B8FF02}"
#define COL_PARAM          "{3FCD02}"
#define COL_SERVER         "{AFE7FF}"
#define COL_VALUE          "{A3E4FF}"
#define COL_RULE           "{F9E8B7}"
#define COL_RULE2          "{FBDF89}"
#define COL_RWHITE         "{FFFFFF}"
#define COL_LGREEN         "{9FE4AA}"
#define COL_LRED           "{DA7272}"
#define COL_LRED2          "{C77D87}"
#define COL_DYELLOW		   "{FAFA52}"
#define COL_BROWN		   "{8C703F}"
#define COL_SBLACK         "{474747}"
#define COL_SGREY          "{ADADAD}"
#define COL_DGREY          "{616161}"
#define COL_SBLUE		   "{3660D1}"
//Colors for Local Chat
#define COLOR_FADE1 0xFFFFFFFF
#define COLOR_FADE2 0xC8C8C8C8
#define COLOR_FADE3 0xAAAAAAAA
#define COLOR_FADE4 0x8C8C8C8C
#define COLOR_FADE5 0x6E6E6E6E
#define COLOR_WHITE  0xFFFFFFFF
new bool:
        ooc;
forward ABroadCast(color,const string[],level);
forward PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z);
forward ProxDetectorS(Float:radi, playerid, targetid);

new Text3D:Admin[ MAX_PLAYERS ], AdminDuty[ MAX_PLAYERS ],
	checkinv = 0;
new PlayerNeedsHelp[MAX_PLAYERS];

new
	Float:g_EventPosition[4],
	g_EventWeapon = -1,
	g_EventReward = 0,
	g_EventPlayers = 0,
	pInEvent[MAX_PLAYERS] = 0,
	g_EventOpen = 0;
//-----[Enum Playerinfo]-----
enum pInfo
{
    Password,
    Cash,
    Kills,
    Deaths,
    Adminlevel
}
new PlayerInfo[MAX_PLAYERS][pInfo];

main() { }

public OnGameModeInit()
{
	gBotID[0] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_1_NICKNAME, BOT_1_REALNAME, BOT_1_USERNAME);
	IRC_SetIntData(gBotID[0], E_IRC_CONNECT_DELAY, 20);
	gGroupID = IRC_CreateGroup();
	
	SetGameModeText("BLANK");
	AddPlayerClass(28, 1743.1090,-1863.6298,13.5748,18.0448,0,0,0,0,0,0);
 	LoadStaticVehiclesFromFile("vehicles.ini");
	return 1;
}

public OnGameModeExit()
{
	IRC_Quit(gBotID[0], "SA-MP bot exiting");
	IRC_DestroyGroup(gGroupID);
	
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1743.1090,-1863.6298,13.5748);
	SetPlayerCameraPos(playerid, 1743.3180,-1855.0292,14.9000);
	SetPlayerCameraLookAt(playerid, 1743.3180,-1855.0292,14.9000);
	SpawnPlayer(playerid);
	return 1;
}

public OnPlayerConnect(playerid)
{
    new pname[MAX_PLAYER_NAME], string[22 + MAX_PLAYER_NAME];
    GetPlayerName(playerid, pname, sizeof(pname));
    format(string, sizeof(string), "[JOIN] %s has joined the server", pname);
    SendClientMessageToAll(COLOR_GREY, string);

	for(new chat = 0; chat <= 100; chat++)
	{
	SendClientMessage(playerid,COLOR_WHITE," ");
	}

  	SendClientMessage(playerid,COLOR_WHITE,""#COL_LOGIN"==========================================================================================================");
	SendClientMessage(playerid,COLOR_WHITE,""#COL_LOGIN"					» Welcome to CHANGE. ");
	SendClientMessage(playerid,COLOR_WHITE,""#COL_LOGIN"	» Version: 3 Last updated: 04/12/11, Server Developer: iNorton ");
	SendClientMessage(playerid,COLOR_WHITE,""#COL_LOGIN"==========================================================================================================");

    if(fexist(UserPath(playerid)))
    {
        INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT,""#COL_ORANGE":: "#COL_WHITE"Login", "\t\t"#COL_EASY"Palamino City "#COL_DGREEN"Roleplay "#COL_EASY"(V3)\n\n"#COL_WHITE"Welcome back, \nPlease enter your password below to start the game!", "Login", "Exit");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT,""#COL_ORANGE":: "#COL_WHITE"Register" , "\t\t"#COL_EASY"Palamino City "#COL_DGREEN"Roleplay "#COL_EASY"(V3)\n\n"#COL_WHITE"You are not registered in our database!, \nPlease enter a password below to register your account!", "Register", "Exit");
    }
    
   	new joinMsg[128], name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	format(joinMsg, sizeof(joinMsg), "02[%d] 03*** %s has joined the server!", playerid, name);
	IRC_GroupSay(gGroupID, IRC_CHANNEL, joinMsg);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{

    new pname[MAX_PLAYER_NAME], string[39 + MAX_PLAYER_NAME];
    GetPlayerName(playerid, pname, sizeof(pname));
    switch(reason)
    {
        case 0: format(string, sizeof(string), "[LEFT] %s has left the server. (Timeout)", pname);
        case 1: format(string, sizeof(string), "[LEFT] %s has left the server. (Leaving)", pname);
        case 2: format(string, sizeof(string), "[LEFT] %s has left the server. (Kicked/Banned)", pname);
    }
    SendClientMessageToAll(COLOR_GREY, string);

	new leaveMsg[128], name[MAX_PLAYER_NAME], reasonMsg[8];
	switch(reason)
	{
		case 0: reasonMsg = "Timeout";
		case 1: reasonMsg = "Leaving";
		case 2: reasonMsg = "Kicked";
	}
	GetPlayerName(playerid, name, sizeof(name));
	format(leaveMsg, sizeof(leaveMsg), "02[%d] 03*** %s has left the server! (%s)", playerid, name, reasonMsg);
	IRC_GroupSay(gGroupID, IRC_CHANNEL, leaveMsg);
	
    new INI:File = INI_Open(UserPath(playerid));
    INI_SetTag(File,"data");
    INI_WriteInt(File,"Cash",GetPlayerMoney(playerid));
    INI_WriteInt(File,"Kills",PlayerInfo[playerid][Kills]);
    INI_WriteInt(File,"Deaths",PlayerInfo[playerid][Deaths]);
    INI_WriteInt(File,"Adminlevel",PlayerInfo[playerid][Adminlevel]);
    INI_Close(File);
    return 1;
}
public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new msg[128], killerName[MAX_PLAYER_NAME], reasonMsg[32], playerName[MAX_PLAYER_NAME];
	GetPlayerName(killerid, killerName, sizeof(killerName));
	GetPlayerName(playerid, playerName, sizeof(playerName));
	if (killerid != INVALID_PLAYER_ID)
	{
		switch (reason)
		{
			case 0: reasonMsg = "Unarmed";
			case 1: reasonMsg = "Brass Knuckles";
			case 2: reasonMsg = "Golf Club";
			case 3: reasonMsg = "Night Stick";
			case 4: reasonMsg = "Knife";
			case 5: reasonMsg = "Baseball Bat";
			case 6: reasonMsg = "Shovel";
			case 7: reasonMsg = "Pool Cue";
			case 8: reasonMsg = "Katana";
			case 9: reasonMsg = "Chainsaw";
			case 10: reasonMsg = "Dildo";
			case 11: reasonMsg = "Dildo";
			case 12: reasonMsg = "Vibrator";
			case 13: reasonMsg = "Vibrator";
			case 14: reasonMsg = "Flowers";
			case 15: reasonMsg = "Cane";
			case 22: reasonMsg = "Pistol";
			case 23: reasonMsg = "Silenced Pistol";
			case 24: reasonMsg = "Desert Eagle";
			case 25: reasonMsg = "Shotgun";
			case 26: reasonMsg = "Sawn-off Shotgun";
			case 27: reasonMsg = "Combat Shotgun";
			case 28: reasonMsg = "MAC-10";
			case 29: reasonMsg = "MP5";
			case 30: reasonMsg = "AK-47";
			case 31: reasonMsg = "M4";
			case 32: reasonMsg = "TEC-9";
			case 33: reasonMsg = "Country Rifle";
			case 34: reasonMsg = "Sniper Rifle";
			case 37: reasonMsg = "Fire";
			case 38: reasonMsg = "Minigun";
			case 41: reasonMsg = "Spray Can";
			case 42: reasonMsg = "Fire Extinguisher";
			case 49: reasonMsg = "Vehicle Collision";
			case 50: reasonMsg = "Vehicle Collision";
			case 51: reasonMsg = "Explosion";
			default: reasonMsg = "Unknown";
		}
		format(msg, sizeof(msg), "04*** %s killed %s. (%s)", killerName, playerName, reasonMsg);
	}
	else
	{
		switch (reason)
		{
			case 53: format(msg, sizeof(msg), "04*** %s died! (Drowned)", playerName);
			case 54: format(msg, sizeof(msg), "04*** %s died! (Collision)", playerName);
			default: format(msg, sizeof(msg), "04*** %s died!", playerName);
		}
	}
	IRC_GroupSay(gGroupID, IRC_CHANNEL, msg);
	
    PlayerInfo[killerid][Kills]++;
    PlayerInfo[playerid][Deaths]++;
    
	if(pInEvent[playerid] == 1) {
					g_EventPlayers--;
					pInEvent[playerid] = 0;
					if(g_EventPlayers == 1) {
					foreach(Player, i) {
		            if(pInEvent[i] == 1) {
		            new string[128], player_Name[MAX_PLAYER_NAME];
		            GetPlayerRame(i, player_Name, sizeof(player_Name));
		            format(string, sizeof(string), ""#COL_BROWN"[EVENT]"#COL_EASY" %s has won the LMS event and has collected $%d!", player_Name, g_EventReward);
					SendClientMessageToAll(-1, string);
					GivePlayerMoney(i, g_EventReward);
					pInEvent[i] = 0;
					g_EventOpen = 0, g_EventPlayers = 0, g_EventReward = 0, g_EventWeapon = 0;
					SpawnPlayer(i);
					}
		       }
		   }
	}
    return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
    new pname[MAX_PLAYER_NAME], str[128];
    GetPlayerName(playerid, pname, sizeof(pname));
    strreplace(pname, '_', ' ');
    format(str, sizeof(str), "%s says: %s", pname, text);
    ProxDetector(30.0, playerid, str, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
    return 0;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch( dialogid )
    {
        case DIALOG_REGISTER:
        {
            if (!response) return Kick(playerid);
            if(response)
            {
                if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, ""#COL_ORANGE":: "#COL_WHITE"Register" , "\t\t"#COL_EASY"Blank Gamemode "#COL_DGREEN"Y_INI "#COL_EASY"(V3)\n\n"#COL_RED"You have entered a invalid password\n"#COL_WHITE"You are not registered, \nPlease enter a password below to register your account!", "Register", "Exit");
                new INI:File = INI_Open(UserPath(playerid));
                INI_SetTag(File,"data");
                INI_WriteInt(File,"Password",udb_hash(inputtext));
                INI_WriteInt(File,"Cash",0);
                INI_WriteInt(File,"Kills",0);
                INI_WriteInt(File,"Deaths",0);
            	INI_WriteInt(File,"Adminlevel",0);
                INI_Close(File);
            }
        }

        case DIALOG_LOGIN:
        {
            if ( !response ) return Kick ( playerid );
            if( response )
            {
                if(udb_hash(inputtext) == PlayerInfo[playerid][Password])
                {
                    INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
                    GivePlayerMoney(playerid, PlayerInfo[playerid][Cash]);
                    SetSpawnInfo(playerid, 28,0,1743.1090,-1863.6298,13.5748,18.0448,0,0,0,0,0,0);
                }
                else
                {
                    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT,""#COL_ORANGE":: "#COL_WHITE"Login", "\t\t"#COL_EASY"Blank Gamemode "#COL_DGREEN"Y_INI "#COL_EASY"(V3)\n\n"#COL_RED"You have entered a invalid password\n"#COL_WHITE"Welcome back, \nPlease enter your password below to start the game!", "Login", "Exit");
                }
                return 1;
            }
        }
    }
    return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

//-----[LoadUser Data]-----
forward LoadUser_data(playerid,name[],value[]);
public LoadUser_data(playerid,name[],value[])
{
    INI_Int("Password",PlayerInfo[playerid][Password]);
    INI_Int("Cash",PlayerInfo[playerid][Cash]);
    INI_Int("Kills",PlayerInfo[playerid][Kills]);
    INI_Int("Deaths",PlayerInfo[playerid][Deaths]);
    INI_Int("Adminlevel",PlayerInfo[playerid][Adminlevel]);
    return 1;
}

//-----[Userpatch]-----
stock UserPath(playerid)
{
    new string[128],playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),PATH,playername);
    return string;
}

//-----[Hash function. Thanxx to Dracoblue]-----
stock udb_hash(buf[]) {
    new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}

//-----[INV Explosion]-----
forward Explosion(playerid, adminid);
public Explosion(playerid, adminid) {
    if(checkinv == 1)
    {
        new Float:health;
        GetPlayerHealth(playerid,health);
        if(health == 100)
        {
            SendClientMessage(adminid,COLOR_YELLOW,"Invulnerability check result : [POSITIVE]");
            checkinv = 0;
        }
        else if(health != 100)
        {
            SendClientMessage(adminid,COLOR_YELLOW,"Invulnerability check result : [NEGATIVE]");
            checkinv = 0;
        }
    }
    return 1;
}

//-----[Removing underscore]-----
stock GetPlayerRame( giveplayer, name[ ], len )
{
    GetPlayerRame( giveplayer, name, len );
    for(new i = 0; i < len; i++ )
    {
        if ( name[ i ] == '_' )
        name[ i ] = ' ';
    }
}

//-----[Callbacks]-----
public IRC_OnConnect(botid, ip[], port)
{
	printf("*** IRC_OnConnect: Bot ID %d connected to %s:%d", botid, ip, port);
	IRC_JoinChannel(botid, IRC_CHANNEL);
	IRC_AddToGroup(gGroupID, botid);
	return 1;
}

public IRC_OnDisconnect(botid, ip[], port, reason[])
{
	printf("*** IRC_OnDisconnect: Bot ID %d disconnected from %s:%d (%s)", botid, ip, port, reason);
	IRC_RemoveFromGroup(gGroupID, botid);
	return 1;
}

public IRC_OnConnectAttempt(botid, ip[], port)
{
	printf("*** IRC_OnConnectAttempt: Bot ID %d attempting to connect to %s:%d...", botid, ip, port);
	return 1;
}

public IRC_OnConnectAttemptFail(botid, ip[], port, reason[])
{
	printf("*** IRC_OnConnectAttemptFail: Bot ID %d failed to connect to %s:%d (%s)", botid, ip, port, reason);
	return 1;
}

public IRC_OnReceiveRaw(botid, message[])
{
	new File:file;
	if (!fexist("irc_log.txt"))
	{
		file = fopen("irc_log.txt", io_write);
	}
	else
	{
		file = fopen("irc_log.txt", io_append);
	}
	if (file)
	{
		fwrite(file, message);
		fwrite(file, "\r\n");
		fclose(file);
	}
	return 1;
}

//-----[Unfreeze LMS]-----
//-----[Unfreezeplayer]-----
forward UnfreezeLMS(playerid);
public UnfreezeLMS(playerid)
{
	foreach(Player, i)
	{
		if(pInEvent[i] == 1)
		{
			if(g_EventOpen == 1)
			{
				TogglePlayerControllable(i, 1);
				GameTextForPlayer(i, "~r~Be the Last Man Standing!", 2000, 3);
			}
		}
	}
	return 1;
}

// .:-----------------------------------------------------------------------:.
// .:=======================================================================:.
//       { This is the start of ZCMD commands.  }
//       { Date: 04/12/11 using ZCMD and SSCANF }
//       { Last Updated: 25/08/11 By: iNorton 	}
//
// .:-----------------------------------------------------------------------:.
// .:=======================================================================:.

//-----[Commands]-----
CMD:commands(playerid, params[])
{
	SendClientMessage(playerid,COLOR_WHITE, ".:: Commands ::.");
	SendClientMessage(playerid,COLOR_WHITE, "[Communication]: /pm - /o(oc) - /me - /env - /s(hout) - /b - /low - /w(hisper) - /report - /helpme ");
	SendClientMessage(playerid,COLOR_WHITE, "[OTHER]: /rules - /kill - /pay");
	return 1;
}

//-----[Rules]-----
CMD:rules(playerid, params[])
{
	SendClientMessage(playerid,COLOR_WHITE, ".:: Server Rules::.");
	SendClientMessage(playerid,COLOR_WHITE, "Do not hack on the server.");
	SendClientMessage(playerid,COLOR_WHITE, "Do not ask for a Administrator rank.");
	return 1;
}

//-----[Kill]-----
CMD:kill(playerid, params[])
{
	SetPlayerHealth(playerid, 0.0);
	SendClientMessage(playerid, GREEN, "[INFO]: You committed a suicide!");
	return 1;
}

//-----[PM]-----
COMMAND:pm(playerid, params[])
{
    new str[128],id,pname[MAX_PLAYER_NAME], Message[128];
    if(sscanf(params, "us[128]", id, Message))SendClientMessage(playerid, COLOR_SYNTAX, "[SYNTAX]: /pm [PlayerID/PartOfName] [Message]");
    else if(id == INVALID_PLAYER_ID) SendClientMessage(playerid, COLOR_ERROR,"[ERROR]: Player not connected!");
    else
    {
        GetPlayerName(id, str, 24);
        format(str, sizeof(str), "PM To %s(%d): %s", str, id, Message);
        GetPlayerName(id, str, 24);
        format(str, sizeof(str), "PM To %s(%d): %s", str, id, Message);
        SendClientMessage(playerid, COLOR_GREEN, str);
        GetPlayerName(playerid, pname, sizeof(pname));
        format(str, sizeof(str), "PM From %s(%d): %s", pname, playerid, Message);
        SendClientMessage(id, COLOR_GREEN, str);
    }
    return 1;
}

//-----[Adminhelp]-----
CMD:ah(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	SendClientMessage(playerid,COLOR_GREEN, "===============[ Administrator Commands ]===============");
	SendClientMessage(playerid,COLOR_GREEN, "Administrator (1): /kick - /slap - /apm - /freeze - /unfreeze - /adminduty - /a(chat) - /sendtols");
	SendClientMessage(playerid,COLOR_GREEN, "Administrator (2): /goto - /gethere - /respawn - /freezeall - /unfreezeall - /inv - /ban - /setskin, - /enableooc - /disableooc - /vrespawn");
	SendClientMessage(playerid,COLOR_GREEN, "Administrator (3): /explode - /cc - /sethp - /givegun - /healall ");
	SendClientMessage(playerid,COLOR_GREEN, "Administrator (4): /jetpack - /removejet - /veh - /givemoney");
	SendClientMessage(playerid,COLOR_GREEN, "Administrator (5): /gmx - /addveh ");
	SendClientMessage(playerid,COLOR_GREEN, "========================================================");
	return 1;
}

//-----[Slap]-----
CMD:slap(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	new targetid;
	if(sscanf(params, "uz", targetid)) return SendClientMessage(playerid, COLOR_SYNTAX, "[SYNTAX]: /slap [PlayerID/PartOfName]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]: Player not connected!");
	else
	{
	new Float:SLX, Float:SLY, Float:SLZ;
	GetPlayerPos(targetid, SLX, SLY, SLZ);
	SetPlayerPos(targetid, SLX, SLY, SLZ+5);
	PlayerPlaySound(targetid, 1130, SLX, SLY, SLZ+5);
	new string[128];
	new pName[24], pTame[24];
	GetPlayerName(playerid,pName,24);
	GetPlayerName(targetid,pTame,24);
	format(string,sizeof string,""#COL_YELLOW"[SERVER]"#COL_LRED" %s has been slapped by Administrator %s.",pTame,pName);
	SendClientMessageToAll(COLOR_RED, string);
  	}
	return 1;
}

//-----[Adminhelp]-----
CMD:kick(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	new targetid, reason[64], string[128];
	if(sscanf(params, "uz", targetid, reason)) return SendClientMessage(playerid, COLOR_SYNTAX, "[SYNTAX]: /kick [PlayerID/PartOfName] [Reason]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]: Player not connected!");
	{
	new pTargetName[24], pName[24];
	GetPlayerName(playerid,pName,24);
	GetPlayerName(targetid,pTargetName,24);
	format(string, sizeof(string), ""#COL_YELLOW"[SERVER]"#COL_LRED" Administrator %s has kicked %s: Reason: %s", pName, pTargetName, reason);
	SendClientMessageToAll(COLOR_RED,string);
	Kick(targetid);
	}
	return 1;
}

//-----[Server GMX]-----
CMD:gmx(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 5) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	{
	new string[256];
	new pName[24];
	GetPlayerName(playerid,pName,24);
	format(string,sizeof string,""#COL_YELLOW"[SERVER]"#COL_LRED" Administrator %s has commenced a server restart.",pName);

 	new INI:File = INI_Open(UserPath(playerid));
    INI_SetTag(File,"data");
    INI_WriteInt(File,"Cash",GetPlayerMoney(playerid));
    INI_WriteInt(File,"Kills",PlayerInfo[playerid][Kills]);
    INI_WriteInt(File,"Deaths",PlayerInfo[playerid][Deaths]);
    INI_WriteInt(File,"Adminlevel",PlayerInfo[playerid][Adminlevel]);
    INI_Close(File);

	SendClientMessageToAll(COLOR_RED, string);
	GameTextForAll("Server Restarting",3000,0);
	SetTimer("Gmx",3000,false);
	SendRconCommand("gmx");
	}
	return 1;
}

//-----[Ban]-----
CMD:ban(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	new targetid, reason[64], string[128];
	if(sscanf(params, "uz", targetid, reason)) return SendClientMessage(playerid, COLOR_SYNTAX, "[SYNTAX]: /ban [PlayerID/PartOfName] [Reason]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]: Player not connected!");
	{
	new pTargetName[24], pName[24];
	GetPlayerName(playerid,pName,24);
	GetPlayerName(targetid,pTargetName,24);
	format(string, sizeof(string), ""#COL_YELLOW"[SERVER]"#COL_LRED" Admin %s has IP banned %s: %s", pName,  pTargetName, reason);
	SendClientMessageToAll(COLOR_RED,string);
	Ban(targetid);
	}
	return 1;
}

//----[Explode]-----
CMD:explode(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 3) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	new targetid;
	if(sscanf(params, "uz", targetid)) return SendClientMessage(playerid, COLOR_SYNTAX, "[SYNTAX]: /explode [PlayerID/PartOfName]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]: Player not connected!");
	else
	{
	new Float:SLX, Float:SLY, Float:SLZ;
	GetPlayerPos(targetid, SLX, SLY,SLZ);
	CreateExplosion(SLX, SLY, SLZ, 11, 0.25);
	new string[128];
	new pName[24], pTame[24];
	GetPlayerName(playerid,pName,24);
	GetPlayerName(targetid,pTame,24);
	format(string,sizeof string,""#COL_YELLOW"[SERVER]"#COL_LRED" %s has been exploded by Administrator %s.",pTame,pName);
	SendClientMessageToAll(COLOR_RED, string);
	}
	return 1;
}

//-----[INV]-----
CMD:inv(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	new targetid;
	if(sscanf(params, "uz", targetid)) return SendClientMessage(playerid, COLOR_SYNTAX, "[SYNTAX]: /inv [PlayerID/PartOfName]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]: Player not connected!");
	else
	{
	if(IsPlayerInAnyVehicle(targetid) == 1)
	{
	RemovePlayerFromVehicle(targetid);
	}
	TogglePlayerControllable(targetid, 1);
	SetPlayerArmour(targetid,0);
	SetPlayerHealth(targetid,100);
	checkinv = 1;
	new Float:x,Float:y,Float:z;
	GetPlayerPos(targetid,x,y,z);
	CreateExplosion(x, y, z, 12, 2.0);
	SetTimerEx("Explosion",500,0,"ii", targetid, playerid);
	SetPlayerArmour(targetid,99);
	SetPlayerHealth(targetid,99);
	}
	return 1;
}

//-----[Admin PM]-----
COMMAND:apm(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
    new str[128],id,pname[MAX_PLAYER_NAME], Message[128];
    if(sscanf(params, "us[128]", id, Message))SendClientMessage(playerid, COLOR_SYNTAX, "[SYNTAX]: /apm [PlayerID/PartOfName] [Message]");
    else if(id == INVALID_PLAYER_ID) SendClientMessage(playerid, COLOR_ERROR, "Player not connected!");
    else
    {
        GetPlayerName(id, str, 24);
        format(str, sizeof(str), "[ADMIN] %s(%d): %s", str, id, Message);
        GetPlayerName(id, str, 24);
        format(str, sizeof(str), "[ADMIN] %s(%d): %s", str, id, Message);
        SendClientMessage(playerid, COLOR_YELLOW, str);
        GetPlayerName(playerid, pname, sizeof(pname));
        format(str, sizeof(str), "[ADMIN] %s(%d): %s", pname, playerid, Message);
        SendClientMessage(id, COLOR_YELLOW, str);
    }
    return 1;
}

//-----[Make admin]-----
COMMAND:makeadmin(playerid, params[])
{
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
    new id, lvl;
    if(sscanf(params, "ui", id, lvl)) return SendClientMessage(playerid, COLOR_SYNTAX, "[SYNTAX]: /makeadmin [PlayerID/PartOfName] [Level]");
    else if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]: Invalid ID");
    else if(lvl > 5) return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]: Administrator level cannot be higher then 5!");
    else
	{
    PlayerInfo[id][Adminlevel] = lvl;
    }
    return 1;
}

//-----[Freeze]-----
CMD:freeze(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	new targetid, string[128];
	if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_SYNTAX, "[SYNTAX]: /freeze [PlayerID/PartOfName]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]: Player not connected!");
	new pTargetName[24], pName[24];
	GetPlayerName(playerid,pName,24);
	GetPlayerName(targetid,pTargetName,24);
	format(string, sizeof(string), ""#COL_YELLOW"[SERVER]"#COL_LRED" %s has been frozen by Administrator %s.",pTargetName, pName);
	SendClientMessageToAll(COLOR_RED,string);
	TogglePlayerControllable(targetid, 0);
	return 1;
}

//-----[Unfreeze]-----
CMD:unfreeze(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	new targetid, string[128];
	if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_SYNTAX, "[SYNTAX]: /unfreeze [PlayerID/PartOfName]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]: Player not connected!");
	new pTargetName[24], pName[24];
	GetPlayerName(playerid,pName,24);
	GetPlayerName(targetid,pTargetName,24);
	format(string, sizeof(string), ""#COL_YELLOW"[SERVER]"#COL_LRED" %s has been unfrozen by Administrator %s.",pTargetName, pName);
	SendClientMessageToAll(COLOR_RED,string);
	TogglePlayerControllable(targetid, 1);
	return 1;
}

//-----[Adminduty]-----
CMD:adminduty(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
    if( AdminDuty[ playerid ] == 0 )
    {
        AdminDuty[ playerid ] = 1;
        Admin[ playerid ] = Create3DTextLabel("ADMIN DUTY",0x5CD6CAFF,30.0,40.0,50.0,10.0,0);
        Attach3DTextLabelToPlayer( Admin[ playerid ], playerid, 0.0, 0.0, 0.3);
		new string[128];
  		new pName[24], pTame[24];
  		GetPlayerName(playerid,pName,24);
  		format(string,sizeof string,""#COL_YELLOW"[SERVER]"#COL_LRED" Administrator %s is on Admin Duty.",pName,pTame);
		SendClientMessageToAll(COLOR_WHITE, string);
    }
    else
    {
        AdminDuty[ playerid ] = 0;
        Delete3DTextLabel( Admin[ playerid ] );
		new string[128];
  		new pName[24], pTame[24];
  		GetPlayerName(playerid,pName,24);
  		format(string,sizeof string,""#COL_YELLOW"[SERVER]"#COL_LRED" Administrator %s is off Admin Duty.",pName,pTame);
		SendClientMessageToAll(COLOR_WHITE, string);
    }
    return 1;
}

//-----[Freeze All]-----
CMD:freezeall(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	new string[128];
	new pName[24], pTame[24];
	GetPlayerName(playerid,pName,24);
	format(string,sizeof string,""#COL_ORANGE"[SERVER]"#COL_LRED" Administrator %s has frozen everyone.",pName,pTame);
	SendClientMessageToAll(COLOR_RED, string);
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		TogglePlayerControllable(i,0);
  		}
  	}
  	return 1;
}

//-----[Unfreeze All]-----
CMD:unfreezeall(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	new string[128];
	new pName[24], pTame[24];
	GetPlayerName(playerid,pName,24);
	format(string,sizeof string,""#COL_YELLOW"[SERVER]"#COL_LRED" Administrator %s has unfrozen everyone.",pName,pTame);
	SendClientMessageToAll(COLOR_RED, string);
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
  			TogglePlayerControllable(i,1);
    	}
 	}
 	return 1;
}

//-----[Jetpack]-----
CMD:jetpack(playerid, params[])
	{
	    if(IsPlayerConnected(playerid))
	    {
	        if(PlayerInfo[playerid][Adminlevel] < 4)
			{
				SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
			    return 1;
			}
			if(!IsPlayerInAnyVehicle(playerid))
			{
			    SetPlayerSpecialAction(playerid, 2);
			    SendClientMessage(playerid, COLOR_WHITE, ""#COL_ORANGE"[ADMIN]"#COL_LRED" Jetpack spawned. Dont forget to remove it with /removejet.");
			}
		}
		return 1;
	}
//-----[Remove Jetpack]-----
CMD:removejet(playerid, params[])
	{
	    if(IsPlayerConnected(playerid))
	    {
	        if(PlayerInfo[playerid][Adminlevel] < 4)
			{
				SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
			    return 1;
			}
			if(!IsPlayerInAnyVehicle(playerid))
			{
			    SetPlayerSpecialAction(playerid, 0);
                SendClientMessage(playerid, COLOR_WHITE, ""#COL_ORANGE"[ADMIN]"#COL_LRED" Your jetpack has been removed.");
			}
		}
		return 1;
	}

//-----[Goto]-----
CMD:goto(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	new targetid, string[128];
	if(sscanf(params, "uz", targetid)) return SendClientMessage(playerid, COLOR_SYNTAX, "[SYNTAX]: /goto [PlayerID/PartOfName]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]: Player not connected!");
	else
	{
		new pName[24];
		GetPlayerName(targetid,pName,128);
		format(string, sizeof(string), ""#COL_YELLOW"[ADMIN]"#GREEN" You succesfully teleported to [%d] %s.",targetid, pName);
		SendClientMessage(playerid,COLOR_RED,string);
		SetPlayerInterior(playerid,GetPlayerInterior(targetid));
		new Float:TPX, Float:TPY, Float:TPZ;
		GetPlayerPos(targetid, TPX, TPY, TPZ);
		SetPlayerPos(playerid, TPX, TPY, TPZ+1);
	}
	return 1;
}

//-----[Respawn]-----
CMD:respawn(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	new targetid;
	if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_SYNTAX, "[SYNTAX]: /respawn [PlayerID/PartOfName]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]: Player not connected!");
	else
	{
		new string[128];
		new pName[24], pTame[24];
		GetPlayerName(playerid,pName,24);
		GetPlayerName(targetid,pTame,24);
		format(string,sizeof string,""#COL_YELLOW"[SERVER]"#COL_LRED" %s has been respawned by Administrator %s.",pTame,pName);
		SendClientMessageToAll(COLOR_RED, string);
		SpawnPlayer(targetid);
	}
	return 1;
}

//-----[Gethere]-----
CMD:gethere(playerid, params[])
{
	if(PlayerInfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	new targetid, string[128];
	if(sscanf(params, "uz", targetid)) return SendClientMessage(playerid, COLOR_SYNTAX, "[SYNTAX]: /gethere [PlayerID/PartOfName]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]: Player not connected!");
	else
	{
		new pName[24];
		GetPlayerName(playerid,pName,128);
		format(string, sizeof(string), ""#COL_YELLOW"[ADMIN]"#COL_LRED" You have been teleported to Administrator %s.",pName);
		SendClientMessage(targetid,COLOR_RED,string);
		SetPlayerInterior(targetid,GetPlayerInterior(playerid));
		new Float:TPX, Float:TPY, Float:TPZ;
		GetPlayerPos(playerid, TPX, TPY, TPZ);
		SetPlayerPos(targetid, TPX, TPY, TPZ+1);
	}
	return 1;
}
CMD:o(playerid, o[], help)
{
    #pragma unused help
    new name[ MAX_PLAYER_NAME ], string[ 128 ];
    if(isnull(o)) return SendClientMessage(playerid,COLOR_SYNTAX -1,"[SYNTAX]: /ooc [text]");
    if(ooc == false && !IsPlayerAdmin( playerid )) return SendClientMessage(playerid,COLOR_ERROR -1,"[ERROR]: OOC Chat is disabled");
    GetPlayerName(playerid, name, sizeof( name ));
    format(string, sizeof(string),"[OOC Chat] %s: %s", name, o);
    SendClientMessageToAll(LIME -1,string);
    return 1;
}
CMD:addveh(playerid, params[])
{
#pragma unused params
    if(PlayerInfo[playerid][Adminlevel] < 5) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
    if(IsPlayerInAnyVehicle(playerid)) {
        new filestring[264],Float:X,Float:Y,Float:Z,Float:Rot;
            GetPlayerPos(playerid,X,Y,Z);
            GetVehicleZAngle(GetPlayerVehicleID(playerid), Rot);
            new vid = GetVehicleModel(GetPlayerVehicleID(playerid));
            new File:pos=fopen("vehicles.ini", io_append);
            format(filestring, 256, "\n%d,%f,%f,%f,%f,-1,-1 ;", vid, X, Y, Z, Rot);
            fwrite(pos, filestring);
            fclose(pos);
            SendClientMessage(playerid,GREEN,"[SUCCESS]: You have successfully added a vehicle!");
    }
    else {
        SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not in a vehicle!.");
    }
    return 1;
}
CMD:veh(playerid, params[])
    {
            if(PlayerInfo[playerid][Adminlevel] < 4) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
            {
            new veh,color1,color2;
            if (!sscanf(params, "iii", veh, color1,color2))
            {
                      new Float:x, Float:y, Float:z;
                      GetPlayerPos(playerid, x,y,z);
                      AddStaticVehicle(veh, x,y,z,0,color1, color2);
            }
            else SendClientMessage(playerid, COLOR_SYNTAX, "[SYNTAX]: /veh [carid] [Color 1] [Color 2]");
            }
        	return 1;
}
CMD:sendtols(playerid, params[])
{
	new id, sendername[MAX_PLAYER_NAME], string[128];
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	else if(sscanf(params,"u", id)) return SendClientMessage(playerid, COLOR_SYNTAX,"[SYNTAX]: /sendtols [PlayerID]");
	else if(GetPlayerState(id) == 2)
	{
	    new tmpcar = GetPlayerVehicleID(id);
	    SetVehiclePos(tmpcar,1529.6,-1691.2,13.3);
	}
	else
	{
		SetPlayerPos(id, 1529.6,-1691.2,13.3);
	}
	GetPlayerName(playerid, sendername, sizeof(sendername));
	sendername[strfind(sendername,"_")] = ' ';
	format(string, sizeof(string),"[INFO]: You have been teleported to Los Santos by Administrator %s !", sendername);
	SendClientMessage(id, GREEN, string);
	SetPlayerInterior(id,0);
	SetPlayerVirtualWorld(id, 0);
	return 1;
}
CMD:setskin(playerid, params[])
{
    new
        id, skin, name[ MAX_PLAYER_NAME ], name2[ MAX_PLAYER_NAME ], str[ 128 ];
    if(PlayerInfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
    if( sscanf ( params, "ui", id, skin ) ) return SendClientMessage( playerid, COLOR_SYNTAX -1,#[SYNTAX]: /setskin [PlayerName/ID] [SkinModel]);
    if( id == INVALID_PLAYER_ID ) return SendClientMessage( playerid,COLOR_ERROR -1, #[ERROR]: Invalid player ID);
    if(skin > 299 || skin < 1) return SendClientMessage(playerid, -1,#Wrong Skin ID! Available ID's: 1-299);
            GetPlayerName( playerid, name, MAX_PLAYER_NAME ); GetPlayerName( id, name2, MAX_PLAYER_NAME );
            format( str, sizeof ( str ),"[SUCCESS] You have set %s skin to model %d", name2, skin);
            SendClientMessage( playerid, GREEN -1, str );
            format( str, sizeof ( str ),"[SUCCESS] Your skin has been set to model %d by %s", skin, name);
            SendClientMessage( id, GREEN -1, str );
            SetPlayerSkin( id, skin );
 			return true;
}
CMD:me(playerid, params[])
{
    new name[MAX_PLAYER_NAME], str[128];
    GetPlayerName(playerid, name, sizeof(name));
    if(isnull(params))
        return SendClientMessage(playerid,COLOR_SYNTAX -1,"[SYNTAX]: /me [Action]");
    format(str,sizeof(str),"*%s %s",name, params);
    ProxDetector(30.0, playerid, str, COLOR_ME, COLOR_ME, COLOR_ME, COLOR_ME, COLOR_ME);
    return 1;
}


CMD:env(playerid, params[])
{
    new name[MAX_PLAYER_NAME], str[128];
    GetPlayerName(playerid, name, sizeof(name));
    if(isnull(params))
        return SendClientMessage(playerid,COLOR_SYNTAX -1,"[SYNTAX]: /env [Environment]");
    format(str,sizeof(str),"*%s ((%s))",params, name);
    ProxDetector(30.0, playerid, str, COLOR_ME, COLOR_ME, COLOR_ME, COLOR_ME, COLOR_ME);
    return 1;
}


CMD:b(playerid,params[])
{
    if(isnull(params)) return SendClientMessage(playerid, COLOR_SYNTAX,"[SYNTAX]: /b [local ooc chat]");
    new sendername[MAX_PLAYER_NAME], string[128];
    GetPlayerName(playerid,sendername,sizeof(sendername));
    sendername[strfind(sendername,"_")] = ' ';
    format(string, sizeof(string), "((%s: %s ))", sendername, params);
    ProxDetector(30.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
    return 1;
}


CMD:s(playerid,params[])
{
    if(isnull(params)) return SendClientMessage(playerid, COLOR_SYNTAX,"[SYNTAX]: /s [shout]");
    new sendername[MAX_PLAYER_NAME], string[128];
    GetPlayerName(playerid, sendername, sizeof(sendername));
    format(string, sizeof(string), "%s Shouts: %s!!", sendername, params);
    ProxDetector(40.0, playerid, string,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2);
    return 1;
}


CMD:low(playerid,params[])
{
    if(isnull(params)) return SendClientMessage(playerid, COLOR_SYNTAX,"/low [Quiet Talk]");
    new sendername[MAX_PLAYER_NAME], string[128];
    GetPlayerName(playerid,sendername,sizeof(sendername));
    sendername[strfind(sendername,"_")] = ' ';
    format(string,sizeof(string), "%s says quietly: %s", sendername, params);
    ProxDetector(3.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
    return 1;
}
CMD:enableooc(playerid, o[], help)
{
    #pragma unused help
    if(PlayerInfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
    ooc = true;
    SendClientMessageToAll(GREEN-1,"[INFO]: OOC Chat has been enabled");
    return 1;
}
CMD:disableooc(playerid, o[], help)
{
    #pragma unused help
    if(PlayerInfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
    if(ooc == true)
    {
        ooc = false;
        SendClientMessageToAll(GREEN-1,"[INFO]: OOC Chat has been disabled");
    }
    return 1;
}
CMD:vrespawn(playerid, params[])
{
    #pragma unused params
    if(PlayerInfo[playerid][Adminlevel] < 2) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
    new bool:VehicleUsed[MAX_VEHICLES] = false;
    foreach(Character, i)//for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerInAnyVehicle(i)) VehicleUsed[GetPlayerVehicleID(i)] = true;
    }
    for(new i = 0; i < MAX_VEHICLES; i++)
    {
        if(VehicleUsed[i] == false) SetVehicleToRespawn(i);
    }
    return SendClientMessageToAll(GREEN,"[INFO]: All Unccupied Vehicles Have Been Respawned!");
}
COMMAND:cc( playerid, params[ ] )
{
   #pragma unused params
   if(PlayerInfo[playerid][Adminlevel] < 3) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
   for( new i = 0; i < 50; i++ ) SendClientMessageToAll(0x33FF33AA, " "); return 1;
}
CMD:sethp(playerid, params[])
{
	new id, hp, sendername[MAX_PLAYER_NAME], string[128];
	if(PlayerInfo[playerid][Adminlevel] < 3) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	else if(sscanf(params,"ui", id, hp)) return SendClientMessage(playerid, COLOR_SYNTAX,"[SYNTAX]: /sethp [PlayerID] [Amount]");
	else if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ERROR,"[ERROR]: Invalid player ID");
	else
	{
	    SetPlayerHealth(id, hp);
	    GetPlayerName(playerid, sendername, sizeof(sendername));
	    sendername[strfind(sendername,"_")] = ' ';
	    format(string, sizeof(string),"[INFO]: Your health has been set to %i by Administrator %s", hp, sendername);
	    SendClientMessage(id, GREEN, string);
	}
	return 1;
}
CMD:givegun(playerid, params[])
{
	new id, gun, ammo;
	if(PlayerInfo[playerid][Adminlevel] < 3) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	else if(sscanf(params,"uii", id, gun, ammo)) return SendClientMessage(playerid, COLOR_SYNTAX,"[SYNTAX]: /givegun [PlayerID] [GunID] [Ammo]");
	else if(gun > 47 || gun < 1) return SendClientMessage(playerid, COLOR_YELLOW,"[INFO]: GUN ID'S: 1-47");
	else if(ammo > 999 || ammo < 1) return SendClientMessage(playerid, COLOR_YELLOW,"[INFO]: Ammo 1-999");
	else
	{
	    GivePlayerWeapon(id, gun, ammo);
	}
	return 1;
}
CMD:healall(playerid, params[])
{
	new sendername[MAX_PLAYER_NAME], string[128];
	GetPlayerName(playerid, sendername, sizeof(sendername));
	sendername[strfind(sendername,"_")] = ' ';
	if(PlayerInfo[playerid][Adminlevel] < 3) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	else
	{
 	format(string, sizeof(string), "[INFO]: Administrator %s has healed everyone", sendername);
 	SendClientMessageToAll(GREEN, string);
	for(new i = 0; i < MAX_PLAYERS; i ++)
	SetPlayerHealth(i,100);
	}
	return 1;
}
CMD:report(playerid,params[])
{
	new id, reason[35], string[128], sendername[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME];
	if(sscanf(params,"uz", id, reason)) return SendClientMessage(playerid, COLOR_SYNTAX,"[SYNTAX]: /report [PlayerID] [Reason]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ERROR,"[ERROR]: Invalid player ID");
	else
	{
		GetPlayerName(id, name,sizeof(name));
		GetPlayerName(playerid, sendername, sizeof(sendername));
		sendername[strfind(sendername,"_")] = ' ';
 		format(string, sizeof(string), "[ID:%d] %s has reported %s: %s.", playerid, sendername, name, reason);
		ABroadCast(COLOR_YELLOW,string,1);
		format(string, sizeof(string), "[INFO]: Use /markfalse [ID] or /acceptreport [ID]");
		ABroadCast(COLOR_YELLOW,string,1);
		format(string, sizeof(string), "[INFO]: Your report was just send to the online admins, please wait for a reply");
		SendClientMessage(playerid,GREEN,string);
		PlayerNeedsHelp[playerid] = 1;
		return 1;
	}
}
CMD:markfalse(playerid, params[])
{
	new id, sendername[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME], string[128];
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	if(sscanf(params,"u", id)) return SendClientMessage(playerid, COLOR_SYNTAX,"[SYNTAX]: /markfalse [PlayerID]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ERROR,"[ERROR]: Player not connected!");
	else
	{
	    if(PlayerNeedsHelp[id] == 1)
	    {
	        PlayerNeedsHelp[id] = 0;
     		GetPlayerName(playerid, sendername, sizeof(sendername));
			GetPlayerName(id, name, sizeof(name));
			format(string, sizeof(string), "[Admin Decision]: %s has just marked [ID:%d]%s false!.", sendername, id, name);
			ABroadCast(COLOR_YELLOW, string, 1);
			format(string, sizeof(string), "**[INFO]: [ID:%d] %s has denied your report due variety of reasons!.", playerid, sendername);
			SendClientMessage(id, GREEN, string);
		}
		else return SendClientMessage(playerid, COLOR_ERROR,"[ERROR]: This player did not ask for help! [Wrong ID]");
	}
	return 1;
}
CMD:acceptreport(playerid, params[])
{
	new id, sendername[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME], string[128];
	if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	if(sscanf(params,"u", id)) return SendClientMessage(playerid, COLOR_SYNTAX," [SYNTAX]: /acceptreport [playerid]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ERROR,"[ERROR]: Player not connected");
	else
	{
	    if(PlayerNeedsHelp[id] == 1)
	    {
	        PlayerNeedsHelp[id] = 0;
     		GetPlayerName(playerid, sendername, sizeof(sendername));
			GetPlayerName(id, name, sizeof(name));
			format(string, sizeof(string), "[Admin Decision]: %s has just accepted the report of [ID:%d]%s.", sendername, id, name);
			ABroadCast(COLOR_YELLOW, string, 1);
			format(string, sizeof(string), "**[INFO]: [ID:%d] %s has accepted your report and now ready to assist you! Please be patience.", playerid, sendername);
			SendClientMessage(id, GREEN, string);
		}
		else return SendClientMessage(playerid, COLOR_ERROR,"[ERROR]: This player did not ask for help! [Wrong ID]");
	}
	return 1;
}
CMD:whisper(playerid, params[])
{
	new id, text[35], sendername[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME], string[128];
	if(sscanf(params,"uz", id, text)) return SendClientMessage(playerid, COLOR_SYNTAX,"[SYNTAX]: /(w)hisper [PlayerID] [Text]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ERROR,"[ERROR]: Invalid player ID");
	else
	{
	    new Float:x, Float:y, Float:z;
	    GetPlayerPos(id,x,y,z);
	    if(PlayerToPoint(5, playerid, x,y,z))
	    {
	        GetPlayerName(playerid, sendername,sizeof(sendername));
	        GetPlayerName(id, name, sizeof(name));
	        if(id == playerid)
	        {
	            format(string,sizeof(string),"%s mutters something", sendername);
	            ProxDetector(5.0, playerid, string, COLOR_ME,COLOR_ME,COLOR_ME,COLOR_ME,COLOR_ME);
			}
			else
			{
			    format(string,sizeof(string),"%s whispers something to %s", sendername, name);
			    ProxDetector(15.0, playerid, string, COLOR_ME,COLOR_ME,COLOR_ME,COLOR_ME,COLOR_ME);
			}
			format(string, sizeof(string), "%s whispers: %s", sendername, text);
			SendClientMessage(id, COLOR_YELLOW3, string);
			format(string, sizeof(string), "%s whispers: %s", sendername, text);
			SendClientMessage(playerid,  COLOR_YELLOW3, string);
		}
		else return SendClientMessage(playerid, COLOR_ERROR,"[ERROR]: That player is not near you!");
	}
	return 1;
}
CMD:w(playerid, params[])
{
  return cmd_whisper(playerid, params);
}
CMD:helpme(playerid, params[])
{
	new string[128], sendername[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME], id;
	if(isnull(params)) return SendClientMessage(playerid, COLOR_SYNTAX,"[SYNTAX]: /helpme [Description]");
	GetPlayerName(playerid,sendername,sizeof(sendername));
	GetPlayerName(id,name,sizeof(name));
	format(string,sizeof(string),"[INFO]: %s has requested for help: %s", sendername, params);
	ABroadCast(ORANGE,string,1);
	SendClientMessage(playerid, GREEN,"[INFO]: You have requested for help, please wait for a reply");
	return 1;
}
CMD:pay(playerid, params[])
{
	new id, money, sendername[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME], string[128];
	if(sscanf(params,"ui", id, money)) return SendClientMessage(playerid, COLOR_SYNTAX,"[SYNTAX]: /pay [PlayerID] [Amount]");
	if(money < 1 || money > 2000) return SendClientMessage(playerid, COLOR_ERROR, "[ERROR]: You can't pay less than 1 Dollar!.");
	if(!ProxDetectorS(5.0, playerid, id)) return SendClientMessage(playerid, COLOR_ERROR,"[ERROR]: You are too far away from that player!");
	else
	{
 		GetPlayerName(id, name, sizeof(name));
		GetPlayerName(playerid, sendername, sizeof(sendername));
		new pmoney = GetPlayerMoney(playerid);
		if (money > 0 && pmoney >= money)
		{
			GivePlayerMoney(playerid, (0 - money));
			GivePlayerMoney(id, money);
			format(string, sizeof(string), "[INFO]: You payed %s(ID: %d) $%d.", name,id, money);
			SendClientMessage(playerid, GREEN, string);
			format(string, sizeof(string), "[INFO]: You recieved $%d from %s(ID: %d).", money, sendername, playerid);
			{
			}
			sendername[strfind(sendername,"_")] = ' ';
			format(string, sizeof(string), "* %s takes out %d$ from his pocket and hands it to %s.", sendername , money ,name);
			ProxDetector(30.0, playerid, string, COLOR_ME,COLOR_ME,COLOR_ME,COLOR_ME,COLOR_ME);
			ApplyAnimation(playerid,"DEALER","shop_pay",4.1,0,0,0,0,0);
		}
	}
	return 1;
}
CMD:givemoney(playerid, params[])
{
	new id, cash, sendername[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME], string[128];
	if(PlayerInfo[playerid][Adminlevel] < 4) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
	if(sscanf(params,"ui", id, cash)) return SendClientMessage(playerid, COLOR_SYNTAX,"[SYNTAX]: /givemoney [playerid/partofname] [ammount]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ERROR,"[ERROR]: Invalid player ID");
	else
	{
	    GivePlayerMoney(id, cash);
		GetPlayerName(playerid,sendername,sizeof(sendername));
		GetPlayerName(id,name,sizeof(name));
		format(string,sizeof(string),"[INFO]: %s has given %s money in amout of: $%d", sendername, name, cash);
		ABroadCast(GREEN,string,1);
		format(string,sizeof(string),"[INFO]: You have recieved %d money from Administrator in amount of: $%s", cash, sendername);
		SendClientMessage(id, GREEN, string);
	}
	return 1;
}
//-----[Adminchat]-----
CMD:a(playerid, params[])
{
    if(PlayerInfo[playerid][Adminlevel] < 1) return SendClientMessage(playerid,COLOR_ERROR,"[ERROR]: You are not authorized to use this command ");
    new pName[MAX_PLAYER_NAME], string[128];
    GetPlayerName(playerid, pName, sizeof(pName));
    if(isnull(params)) return SendClientMessage(playerid, COLOR_SYNTAX, "[SYNTAX]: /a [Text]" );

    format(string, sizeof(string), "[ Administrator %s: %s ]", pName, params);
    SendMessageToAdmins(ORANGE,string);

    return 1;
}
CMD:ad( playerid, params[]) //This ad will not add any name or contact number, so adverts wont be MG'ed if the advertiser does not want his name in.
{
  if( !strlen ( params ) )
    return SendClientMessage ( playerid, COLOR_SYNTAX, "[SYNTAX]: /ad [Advertisement]" );

  if( strlen( params ) < 2 )
    return SendClientMessage( playerid, COLOR_ERROR, "[ERROR]: Your advertisement is not long enough." );

  new szAdMsg[255];
  format( szAdMsg, 255, "Advertisement: %s", params );
  SendClientMessageToAll( COLOR_GREEN, szAdMsg );
  return 1;
}
//-----[Create LMS]-----
	CMD:createlms(playerid, params[]) {
	    new
	        WeaponID,
	        RewardAmount,
			string[128],
			player_Name[MAX_PLAYER_NAME];

	    if(PlayerInfo[playerid][Adminlevel] < 5) {

 		if(sscanf(params, "ii", WeaponID, RewardAmount))
   			return SendClientMessage(playerid, -1, ""#COL_DGREY"[CMD] / "#COL_SGREY"[WeaponID] [Reward]");

		GetPlayerPos(playerid, g_EventPosition[0], g_EventPosition[1], g_EventPosition[2]);
  		GetPlayerFacingAngle(playerid, g_EventPosition[3]);
  		GetPlayerRame(playerid, player_Name, sizeof(player_Name));

    	g_EventWeapon = WeaponID;
	    g_EventReward = RewardAmount;
	    format(string, sizeof(string), ""COL_BROWN"[EVENT]"#COL_EASY" Administrator %s has created an LMS event! "#COL_BROWN"/join "#COL_EASY"to join the event!", player_Name);
		SendClientMessageToAll(-1, string);

		SetTimerEx("UnfreezeLMS", 20000, false, "i", playerid);

		g_EventOpen = 1;
		g_EventPlayers = 0;

		}
		else return SendClientMessage(playerid, COLOR_RED, ".:: You are not authorized to use this command ::.");
	    return true;

	}

//-----[Join LMS]-----
	CMD:join(playerid, params[]) {
	    #pragma unused params
	    if(pInEvent[playerid] == 0) {
	        if(g_EventOpen == 1) {

	            SetPlayerPos(playerid, g_EventPosition[0], g_EventPosition[1], g_EventPosition[2]);
	            SetPlayerFacingAngle(playerid, g_EventPosition[3]);

	            ResetPlayerWeapons(playerid);
	            GivePlayerWeapon(playerid, g_EventWeapon, 100000);

	            GameTextForPlayer(playerid, "~g~Joined event~n~~w~Please wait..", 3000, 3);

	            TogglePlayerControllable(playerid, 0);

	            g_EventPlayers++;
	            pInEvent[playerid] = 1; //Now in the event!

	        }
	        else return SendClientMessage(playerid, COLOR_RED, ".:: No event is going on ::.");

	    }
	    else return SendClientMessage(playerid,  COLOR_RED, ".:: You're already in the event ::.");

	    return true;

	}

// .:-----------------------------------------------------------------------:.
// .:=======================================================================:.
//       { This is the start of IRC commands.   }
//       { Date: 09/09/11 using IRC plugin      }
//       { Last Updated: 10/09/11 By: Kingunit 	}
//
// .:-----------------------------------------------------------------------:.
// .:=======================================================================:.

//-----[IRC Kick]-----
IRCCMD:kick(botid, channel[], user[], host[], params[])
{
	if (IRC_IsOp(botid, channel, user))
	{
		new playerid, reason[64];
		if (sscanf(params, "dS(No reason)[64]", playerid, reason))
		{
			return 1;
		}
		if (IsPlayerConnected(playerid))
		{
			new msg[128], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));
			format(msg, sizeof(msg), "02*** %s has been kicked by %s on IRC. (%s)", name, user, reason);
			IRC_GroupSay(gGroupID, channel, msg);
			format(msg, sizeof(msg), ""#COL_ORANGE"[SERVER]"#COL_LRED" %s has been kicked by IRC Admin %s: %s", name, user, reason);
			SendClientMessageToAll(0x0000FFFF, msg);
			
			Kick(playerid);
		}
	}
	return 1;
}

//-----[IRC Ban]-----
IRCCMD:ban(botid, channel[], user[], host[], params[])
{
	if (IRC_IsOp(botid, channel, user))
	{
		new playerid, reason[64];
		if (sscanf(params, "dS(No reason)[64]", playerid, reason))
		{
			return 1;
		}
		if (IsPlayerConnected(playerid))
		{
			new msg[128], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));
			format(msg, sizeof(msg), "02*** %s has been banned by %s on IRC. (%s)", name, user, reason);
			IRC_GroupSay(gGroupID, channel, msg);
			format(msg, sizeof(msg), ""#COL_ORANGE"[SERVER]"#COL_LRED" %s has been banned by IRC Admin %s: %s", name, user, reason);
			SendClientMessageToAll(0x0000FFFF, msg);

			BanEx(playerid, reason);
		}
	}
	return 1;
}

//-----[IRC RCON]-----
IRCCMD:rcon(botid, channel[], user[], host[], params[])
{
	if (IRC_IsOp(botid, channel, user))
	{
		if (!isnull(params))
		{
			if (strcmp(params, "exit", true) != 0 && strfind(params, "loadfs irc", true) == -1)
			{
				new msg[128];
				format(msg, sizeof(msg), "RCON command %s has been executed.", params);
				IRC_GroupSay(gGroupID, channel, msg);

				SendRconCommand(params);
			}
		}
	}
	return 1;
}

//-----[IRC Slap]-----
IRCCMD:slap(botid, channel[], user[], host[], params[])
{
	if (IRC_IsHalfop(botid, channel, user))
	{
		new playerid;
		if (IsPlayerConnected(playerid))
		{
	  		new Float:SLX, Float:SLY, Float:SLZ;
	  		GetPlayerPos(playerid, SLX, SLY,SLZ);
	  		SetPlayerPos(playerid, SLX, SLY, SLZ+5);

			new msg[128], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));

			format(msg, sizeof(msg), "02*** %s has been slapped by IRC Admin %s", name, user);
			IRC_GroupSay(gGroupID, channel, msg);
			format(msg, sizeof(msg), ""#COL_ORANGE"[SERVER]"#COL_LRED" %s has been slapped by IRC Admin %s", name, user);
			SendClientMessageToAll(0x0000FFFF, msg);
		}
	}
	return 1;
}

//-----[IRC Explode]-----
IRCCMD:explode(botid, channel[], user[], host[], params[])
{
	if (IRC_IsHalfop(botid, channel, user))
	{
		new playerid;
		if (IsPlayerConnected(playerid))
		{
	  		new Float:SLX, Float:SLY, Float:SLZ;
	  		GetPlayerPos(playerid, SLX, SLY,SLZ);
	  		CreateExplosion(SLX, SLY, SLZ, 11, 0.25);
	  		
			new msg[128], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));
			
			format(msg, sizeof(msg), "02*** %s has been exploded by IRC Admin %s", name, user);
			IRC_GroupSay(gGroupID, channel, msg);
			format(msg, sizeof(msg), ""#COL_ORANGE"[SERVER]"#COL_LRED" %s has been exploded by IRC Admin %s", name, user);
			SendClientMessageToAll(0x0000FFFF, msg);
		}
	}
	return 1;
}

//-----[IRC Armup]-----
IRCCMD:armup(botid, channel[], user[], host[], params[])
{
	if (IRC_IsHalfop(botid, channel, user))
	{
		new playerid;
		if (IsPlayerConnected(playerid))
		{
			new msg[128], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));

	  		SetPlayerHealth(playerid, 100);
	  		SetPlayerArmour(playerid, 100.0);
	  		GivePlayerWeapon(playerid, 24, 500);
	  		GivePlayerWeapon(playerid, 27, 500);
	  		GivePlayerWeapon(playerid, 31, 500);
	  		GivePlayerWeapon(playerid, 1, 1);

			format(msg, sizeof(msg), "02*** %s has been armed by IRC Admin %s", name, user);
			IRC_GroupSay(gGroupID, channel, msg);
			format(msg, sizeof(msg), ""#COL_ORANGE"[SERVER]"#COL_LRED" %s has been armed by IRC Admin %s", name, user);
			SendClientMessageToAll(0x0000FFFF, msg);
		}
	}
	return 1;
}

//-----[IRC Respawn]-----
IRCCMD:respawn(botid, channel[], user[], host[], params[])
{
	if (IRC_IsHalfop(botid, channel, user))
	{
		new playerid;
		if (IsPlayerConnected(playerid))
		{
			new msg[128], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));

			format(msg, sizeof(msg), "02*** %s has been respawned by IRC Admin %s", name, user);
			IRC_GroupSay(gGroupID, channel, msg);
			format(msg, sizeof(msg), ""#COL_ORANGE"[SERVER]"#COL_LRED" %s has been respawned by IRC Admin %s", name, user);
			SendClientMessageToAll(0x0000FFFF, msg);
			
 	    	SpawnPlayer(playerid);
		}
	}
	return 1;
}

//-----[IRC Freeze]-----
IRCCMD:freeze(botid, channel[], user[], host[], params[])
{
	if (IRC_IsHalfop(botid, channel, user))
	{
		new playerid;
		if (IsPlayerConnected(playerid))
		{
			new msg[128], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));

			format(msg, sizeof(msg), "02*** %s has been frozen by IRC Admin %s", name, user);
			IRC_GroupSay(gGroupID, channel, msg);
			format(msg, sizeof(msg), ""#COL_ORANGE"[SERVER]"#COL_LRED" %s has been frozen by IRC Admin %s", name, user);
			SendClientMessageToAll(0x0000FFFF, msg);

 	    	TogglePlayerControllable(playerid, 0);
		}
	}
	return 1;
}

//-----[IRC Unfreeze]-----
IRCCMD:unfreeze(botid, channel[], user[], host[], params[])
{
	if (IRC_IsHalfop(botid, channel, user))
	{
		new playerid;
		if (IsPlayerConnected(playerid))
		{
			new msg[128], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));

			format(msg, sizeof(msg), "02*** %s has been unfrozen by IRC Admin %s", name, user);
			IRC_GroupSay(gGroupID, channel, msg);
			format(msg, sizeof(msg), ""#COL_ORANGE"[SERVER]"#COL_LRED" %s has been unfrozen by IRC Admin %s", name, user);
			SendClientMessageToAll(0x0000FFFF, msg);

 	    	TogglePlayerControllable(playerid, 1);
		}
	}
	return 1;
}

//-----[IRC Freezeall]-----
IRCCMD:freezeall(botid, channel[], user[], host[], params[])
{
	if (IRC_IsOp(botid, channel, user))
	{
		new playerid;
		if (IsPlayerConnected(playerid))
		{
			new msg[128], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));

			format(msg, sizeof(msg), "02*** All players are frozen by IRC Admin %s", user);
			IRC_GroupSay(gGroupID, channel, msg);
			
			format(msg, sizeof(msg), ""#COL_ORANGE"[SERVER]"#COL_LRED" All players are frozen by IRC Admin %s", user);
			SendClientMessageToAll(0x0000FFFF, msg);

			for(new i=0; i<MAX_PLAYERS; i++)
			{
		 		if(IsPlayerConnected(i))
		 		{
		  			TogglePlayerControllable(i,0);
		    	}
		   	}
		}
	}
	return 1;
}
//----[PROX DETECTOR]-----
ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
    if(IsPlayerConnected(playerid))
    {
        new Float:posx, Float:posy, Float:posz;
        new Float:oldposx, Float:oldposy, Float:oldposz;
        new Float:tempposx, Float:tempposy, Float:tempposz;
        GetPlayerPos(playerid, oldposx, oldposy, oldposz);
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i))
            {
                GetPlayerPos(i, posx, posy, posz);
                tempposx = (oldposx -posx);
                tempposy = (oldposy -posy);
                tempposz = (oldposz -posz);
                if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
                {
                    if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
                    {
                        SendClientMessage(i, col1, string);
                    }
                    else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
                    {
                        SendClientMessage(i, col2, string);
                    }
                    else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
                    {
                        SendClientMessage(i, col3, string);
                    }
                    else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
                    {
                        SendClientMessage(i, col4, string);
                    }
                    else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
                    {
                        SendClientMessage(i, col5, string);
                    }
                }
            }
        }
    }
    return 1;
//======[STOCKS]======
}
stock strreplace(string[], find, replace)
{
    for(new i=0; string[i]; i++)
    {
        if(string[i] == find)
        {
            string[i] = replace;
        }
    }
}
stock LoadStaticVehiclesFromFile(const filename[])
{
    new File:file_ptr;
        new line[256];
        new var_from_line[64];
        new vehicletype;
        new Float:SpawnX;
        new Float:SpawnY;
        new Float:SpawnZ;
        new Float:SpawnRot;
        new Color1, Color2;
        new index;
        new vehicles_loaded;

        file_ptr = fopen(filename,filemode:io_read);
        if(!file_ptr) return 0;

        vehicles_loaded = 0;

    while(fread(file_ptr,line,256) > 0) {
        index = 0;

// Read type
            index = token_by_delim(line,var_from_line,',',index);
            if(index == (-1)) continue;
            vehicletype = strval(var_from_line);
            if(vehicletype < 400 || vehicletype > 611) continue;

// Read X, Y, Z, Rotation
            index = token_by_delim(line,var_from_line,',',index+1);
            if(index == (-1)) continue;
            SpawnX = floatstr(var_from_line);

            index = token_by_delim(line,var_from_line,',',index+1);
            if(index == (-1)) continue;
            SpawnY = floatstr(var_from_line);

            index = token_by_delim(line,var_from_line,',',index+1);
            if(index == (-1)) continue;
            SpawnZ = floatstr(var_from_line);

            index = token_by_delim(line,var_from_line,',',index+1);
            if(index == (-1)) continue;
            SpawnRot = floatstr(var_from_line);

// Read Color1, Color2
            index = token_by_delim(line,var_from_line,',',index+1);
            if(index == (-1)) continue;
            Color1 = strval(var_from_line);

            index = token_by_delim(line,var_from_line,';',index+1);
            Color2 = strval(var_from_line);

//printf("%d,%d,%f,%f,%f,%f,%d,%d",total_vehicles_from_files+vehicles_loaded+1,vehicletype,SpawnX,SpawnY,SpawnZ,SpawnRot,Color1,Color2);

                                                  // respawn 30 minutes
            AddStaticVehicleEx(vehicletype,SpawnX,SpawnY,SpawnZ+1,SpawnRot,Color1,Color2,(30*60));
            vehicles_loaded++;
    }

    fclose(file_ptr);
        printf("Loaded %d vehicles from: %s",vehicles_loaded,filename);
        return vehicles_loaded;
}


stock token_by_delim(const string[], return_str[], delim, start_index)
{
    new x=0;
    while(string[start_index] != EOS && string[start_index] != delim) {
        return_str[x] = string[start_index];
            x++;
            start_index++;
    }
    return_str[x] = EOS;
        if(string[start_index] == EOS) start_index = (-1);
        return start_index;
}


stock IsRolePlayName(playerid, bool:alphaonly = true)
{
    new trpn[MAX_PLAYER_NAME];
    if(GetPlayerName(playerid,trpn,sizeof(trpn))) {
        new strd = strfind(trpn, "_", false);

        if(strfind(trpn,"_",false,strd+1) == -1) {
            if(strd > 0) {
                if(trpn[strd-1] && trpn[strd+1]) {
                    if(alphaonly) {
                        for(new a = 0, l = strlen(trpn); a < l; a++) {
                            switch(trpn[a]) {
                                case '0' .. '9': return 0;

                                    case 'a' .. 'z': continue;
                                    case 'A' .. 'Z': continue;
                                                  // easier than specifying every invalid char
                                    case '_': continue;

                                    default: return 0;
                            }
                        }
                    }
                    return 1;
                }
            }
        }
    }
    return 0;
}
stock SendMessageToAdmins(color, string[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && PlayerInfo[i][Adminlevel] > 0) // Own var
        {
            SendClientMessage(i, color, string);
        }
    }
    return 1;
}
public ABroadCast(color,const string[],level)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if (PlayerInfo[i][Adminlevel] >= level)
			{
				SendClientMessage(i, color, string);
			}
		}
	}
	return 1;
}
public PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
    if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
		//printf("DEBUG: X:%f Y:%f Z:%f",posx,posy,posz);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
}
public ProxDetectorS(Float:radi, playerid, targetid)
{
    if(IsPlayerConnected(playerid)&&IsPlayerConnected(targetid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		//radi = 2.0; //Trigger Radius
		GetPlayerPos(targetid, posx, posy, posz);
		tempposx = (oldposx -posx);
		tempposy = (oldposy -posy);
		tempposz = (oldposz -posz);
		//printf("DEBUG: X:%f Y:%f Z:%f",posx,posy,posz);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
}
