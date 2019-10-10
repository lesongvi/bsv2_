// [1. INFORMATION ] ///////////////////////////////////////////////////////////
/*
Project Name:           g_FireWork
Project Author:         Gigi Falcone aka GigiTheBeast
Project Version:        v0.2 BETA
Project Started:        27.03.2011. - 16:00
Last Update:            v0.1 ALHPA [27.03.2011. - 16:07]
Last Stable:        v0.2 BETA [08.04.2011. - 11:00]
Number of Rows:     366

Desc: This FilterScript represents a simple firework sistem that i've made for
my RolePlay server. It has a built-in check sistem that connect to my webhost
to check for updates. This function is optional so you can ENABLE/DISABLE it.
You can find CHANGELOG at the bottom of the FS.

Requirements: This FilterScript is Plug&Play. Just add the .amx file in your
Filterscripts folder and you are ready to go. If you want to tweak it, then
you will need some files:
- sscanf include or sscanf plugin (recommended)
- zcmd command processor
*/
// [2. INCLUDES ] //////////////////////////////////////////////////////////////
#include <a_samp>
#include <a_http>
#include <sscanf2>
#include <zcmd>
// [3. DEFINES ] ///////////////////////////////////////////////////////////////
//Colors
#define COLOR_WHITE             0xFFFFFFAA
#define COLOR_GREY              0xAFAFAFAA
//Other
#define GIGI_DIALOG_ID  19999//set to any id that you want and that is free
#define MAX_FIREWORKS   64//number of fireworks (cmd createfwall uses 16)
#define MAX_HEIGHT      100//max allowed height
#define MIN_HEIGHT      20//min allowed height
#define MAX_SPREAD      10//it defines the spread for the lights when they explode
#define CURENTVERSION   "v0.1"//don't change
#define ONLINECHECK     //comment this line to disable the online check for version
// [4. VARIABLES ] /////////////////////////////////////////////////////////////
enum fwInfo
{
        fwid,//created object base id
        Float:fwX,//firework x
        Float:fwY,//firework y
        Float:fwZ,//firework z
        Float:fwA,//firework altitude
        fwLoop//broj pucanja
}
new Firework[MAX_FIREWORKS][fwInfo];

enum fwObjects
{
    Object0,//create launch object
        Object1,//create exploding object 1
        Object2,//create exploding object 2
        Object3,//create exploding object 3
        Object4,//create exploding object 4
        Object5,//create exploding object 5
        Object6//create exploding object 5
}
new FireworkObj[MAX_FIREWORKS][fwObjects];

new FireworkLights[10] =
{
        19281,//white
        19282,//red
        19283,//green
        19284,//blue
        19289,//white strobe
        19290,//red strobe
        19291,//green strobe
        19292,//blue strobe
        19293,//purple strobe
        19294//orange strobe
};

new FireworkCount;//counts how many fireworks are created
new VersionInfo[60];//stores the version information retrived from global server
// [5. PUBLICS ] ///////////////////////////////////////////////////////////////
public OnFilterScriptInit()
{
        for(new id = 0; id < MAX_FIREWORKS; id++)
        {
            Firework[id][fwid]   = INVALID_OBJECT_ID;
            Firework[id][fwX]    = 0.000000;
            Firework[id][fwY]    = 0.000000;
            Firework[id][fwZ]    = 0.000000;
            Firework[id][fwA]    = 0.000000;
            Firework[id][fwLoop] = 0;
            FireworkObj[id][Object0] = INVALID_OBJECT_ID;
            FireworkObj[id][Object1] = INVALID_OBJECT_ID;
            FireworkObj[id][Object2] = INVALID_OBJECT_ID;
            FireworkObj[id][Object3] = INVALID_OBJECT_ID;
            FireworkObj[id][Object4] = INVALID_OBJECT_ID;
            FireworkObj[id][Object5] = INVALID_OBJECT_ID;
            FireworkObj[id][Object6] = INVALID_OBJECT_ID;
        }
        FireworkCount = 0;
        #if defined ONLINECHECK
        HTTP(1,HTTP_GET,"www.bu-rp.info/files/bu-firework/version.txt","","VersionChecker");
        #endif
        print("BU Firework FilterScript Loaded!");
        return 1;
}
public OnFilterScriptExit()
{
        for(new id = 0; id < MAX_FIREWORKS; id++)
        {
            DestroyObject(Firework[id][fwid]);
            Firework[id][fwid]   = INVALID_OBJECT_ID;
            Firework[id][fwX]    = 0.000000;
            Firework[id][fwY]    = 0.000000;
            Firework[id][fwZ]    = 0.000000;
            Firework[id][fwA]    = 0.000000;
            Firework[id][fwLoop] = 0;
            DestroyObject(FireworkObj[id][Object0]);
            DestroyObject(FireworkObj[id][Object1]);
            DestroyObject(FireworkObj[id][Object2]);
            DestroyObject(FireworkObj[id][Object3]);
            DestroyObject(FireworkObj[id][Object4]);
            DestroyObject(FireworkObj[id][Object5]);
            DestroyObject(FireworkObj[id][Object6]);
            FireworkObj[id][Object0] = INVALID_OBJECT_ID;
            FireworkObj[id][Object1] = INVALID_OBJECT_ID;
            FireworkObj[id][Object2] = INVALID_OBJECT_ID;
            FireworkObj[id][Object3] = INVALID_OBJECT_ID;
            FireworkObj[id][Object4] = INVALID_OBJECT_ID;
            FireworkObj[id][Object5] = INVALID_OBJECT_ID;
            FireworkObj[id][Object6] = INVALID_OBJECT_ID;
        }
        FireworkCount = 0;
        print("BU Firework FilterScript UnLoaded!");
        return 1;
}
public OnObjectMoved(objectid)
{
        for(new i = 0; i < MAX_FIREWORKS; i++)
        {
                if(objectid == FireworkObj[i][Object0])
                {
                    new rand;
                    new Float:FwAltitude = Firework[i][fwZ] + Firework[i][fwA];
                    CreateExplosion(Firework[i][fwX],Firework[i][fwY],FwAltitude,12,10);
                    DestroyObject(FireworkObj[i][Object0]);
                    FireworkObj[i][Object0] = INVALID_OBJECT_ID;
                    rand = random(9);
                    FireworkObj[i][Object1] = CreateObject(FireworkLights[rand],Firework[i][fwX],Firework[i][fwY],FwAltitude,0.0,0.0,0.0,800);
					rand = random(9);
                    FireworkObj[i][Object2] = CreateObject(FireworkLights[rand],Firework[i][fwX],Firework[i][fwY],FwAltitude,0.0,0.0,0.0,800);
        			rand = random(9);
                    FireworkObj[i][Object3] = CreateObject(FireworkLights[rand],Firework[i][fwX],Firework[i][fwY],FwAltitude,0.0,0.0,0.0,800);
        			rand = random(9);
                    FireworkObj[i][Object4] = CreateObject(FireworkLights[rand],Firework[i][fwX],Firework[i][fwY],FwAltitude,0.0,0.0,0.0,800);
        			rand = random(9);
                    FireworkObj[i][Object5] = CreateObject(FireworkLights[rand],Firework[i][fwX],Firework[i][fwY],FwAltitude,0.0,0.0,0.0,800);
        			rand = random(9);
                    FireworkObj[i][Object6] = CreateObject(FireworkLights[rand],Firework[i][fwX],Firework[i][fwY],FwAltitude,0.0,0.0,0.0,800);
                    MoveObject(FireworkObj[i][Object1],Firework[i][fwX] + MAX_SPREAD,Firework[i][fwY],FwAltitude,4);
                    MoveObject(FireworkObj[i][Object2],Firework[i][fwX] - MAX_SPREAD,Firework[i][fwY],FwAltitude,4);
                    MoveObject(FireworkObj[i][Object3],Firework[i][fwX],Firework[i][fwY] + MAX_SPREAD,FwAltitude,4);
                    MoveObject(FireworkObj[i][Object4],Firework[i][fwX],Firework[i][fwY] - MAX_SPREAD,FwAltitude,4);
                    MoveObject(FireworkObj[i][Object5],Firework[i][fwX],Firework[i][fwY],FwAltitude + MAX_SPREAD,4);
                    MoveObject(FireworkObj[i][Object6],Firework[i][fwX],Firework[i][fwY],FwAltitude - MAX_SPREAD,4);
                    if(Firework[i][fwLoop] > 0) SetTimerEx("LaunchFirework",2500,0,"i",i);

                }
                else if(objectid == FireworkObj[i][Object1])
                {
                        DestroyObject(FireworkObj[i][Object1]);
                        FireworkObj[i][Object1] = INVALID_OBJECT_ID;
                }
                else if(objectid == FireworkObj[i][Object2])
                {
                        DestroyObject(FireworkObj[i][Object2]);
                        FireworkObj[i][Object2] = INVALID_OBJECT_ID;
                }
                else if(objectid == FireworkObj[i][Object3])
                {
                        DestroyObject(FireworkObj[i][Object3]);
                        FireworkObj[i][Object3] = INVALID_OBJECT_ID;
                }
                else if(objectid == FireworkObj[i][Object4])
                {
                        DestroyObject(FireworkObj[i][Object4]);
                        FireworkObj[i][Object4] = INVALID_OBJECT_ID;
                }
                else if(objectid == FireworkObj[i][Object5])
                {
                        DestroyObject(FireworkObj[i][Object5]);
                        FireworkObj[i][Object5] = INVALID_OBJECT_ID;
                }
                else if(objectid == FireworkObj[i][Object6])
                {
                        DestroyObject(FireworkObj[i][Object6]);
                        FireworkObj[i][Object6] = INVALID_OBJECT_ID;
                }
        }
}
forward VersionChecker(index,response_code,data[]);
public VersionChecker(index,response_code,data[])
{
        if(response_code == 200)
        {
                #if defined ONLINECHECK
                new string[20];
	            if(!strcmp(data,CURENTVERSION))
	                {
		                format(string,sizeof(string),"%s (Up To Date)",data);
		                sscanf(string,"s[60]",VersionInfo);
	                }
	            else
	                {
		                format(string,sizeof(string),"%s (Please Download Update)",data);
		                sscanf(string,"s[60]",VersionInfo);
	                }
	                #else
	            		print("lala2");
	                	sscanf("Function Disabled","s[60]",VersionInfo);
	                #endif
	        }
	        else sscanf("Can't Connect To Server","s[60]",VersionInfo);
}
// [6. STOCKS ] ////////////////////////////////////////////////////////////////
stock CreateFirework(id,Float:X,Float:Y,Float:Z,Float:A,Loop)
{
    Firework[id][fwid] = CreateObject(3013,X,Y,Z,0.000000,0.000000,0.000000,800);
    Firework[id][fwX] = X;
    Firework[id][fwY] = Y;
    Firework[id][fwZ] = Z;
    Firework[id][fwA] = A;
    Firework[id][fwLoop] = Loop;
}
forward LaunchFirework(id);
public LaunchFirework(id)
{
        //smoke 18715
        FireworkObj[id][Object0] = CreateObject(18716,Firework[id][fwX],Firework[id][fwY],Firework[id][fwZ],0.0,0.0,0.0,800);
        MoveObject(FireworkObj[id][Object0],Firework[id][fwX],Firework[id][fwY],Firework[id][fwZ] + Firework[id][fwA],12);
        Firework[id][fwLoop]--;
}
// [7. COMMANDS ] //////////////////////////////////////////////////////////////
CMD:checkfw(playerid,params[])
{
        new id,string[60];
        if(sscanf(params,"d",id)) SendClientMessage(playerid,COLOR_WHITE, "SERVER: /checkfw [Firework ID]");
        else
        {
                format(string,sizeof(string),"ID:%d | X:%f | Y:%f | Z:%f | A:%f",id,Firework[id][fwX],Firework[id][fwY],Firework[id][fwZ],Firework[id][fwA]);
                SendClientMessage(playerid,COLOR_WHITE,string);
        }
        return 1;
}
CMD:createfw(playerid,params[])
{
        new loop,Float:pX,Float:pY,Float:pZ,Float:altitude,string[70];
        if(sscanf(params,"fd",altitude,loop)) SendClientMessage(playerid,COLOR_WHITE, "SERVER: /createfw [Altitude] [Loop Number]");
        else
        {
                if(altitude > MAX_HEIGHT) return SendClientMessage(playerid,COLOR_GREY,"Lower your altitude, it's too high!");
                if(altitude < MIN_HEIGHT) return SendClientMessage(playerid,COLOR_GREY,"Rise your altitude, it's too low!");
                if(FireworkCount >= MAX_FIREWORKS) return SendClientMessage(playerid,COLOR_GREY,"You have reached the firework limit!");
                if(loop < 1) return SendClientMessage(playerid,COLOR_GREY,"Loop number can't be 0 or lower than 0!");
                GetPlayerPos(playerid,pX,pY,pZ);
                pX = pX + 1.000000;//offset X
                pZ = pZ - 0.800000;//offset Z
                CreateFirework(FireworkCount,pX,pY,pZ,altitude,loop);
                format(string,sizeof(string),"Firework %d created!",FireworkCount);
                SendClientMessage(playerid,COLOR_WHITE,string);
                FireworkCount ++;
        }
        return 1;
}
CMD:createfwall(playerid,params[])
{
        new rand,loop,Float:pX,Float:pY,Float:pZ,string[70];
        if(sscanf(params,"d",loop)) SendClientMessage(playerid,COLOR_WHITE, "SERVER: /createfwall [Loop Number]");
        else
        {
            	if(loop < 1) return SendClientMessage(playerid,COLOR_GREY,"Loop number can't be 0 or lower than 0!");
                GetPlayerPos(playerid,pX,pY,pZ);
                pX = pX + 1.000000;//offset X
                pZ = pZ - 0.800000;//offset Z
                for(new i = 0; i < 16; i++)
                {
                    if(i != 4 && i != 8 && i != 12) pX = pX + 4.00;
                        else
                        {
                                pX = pX - 12.00;
                                pY = pY + 4.00;
                        }
                    rand = random(20) + 25;
                    CreateFirework(FireworkCount,pX,pY,pZ,rand,loop);
                    FireworkCount ++;
                }
                format(string,sizeof(string),"There are %d fireworks total!",FireworkCount);
                SendClientMessage(playerid,COLOR_WHITE,string);
        }
        return 1;
}
CMD:firefw(playerid,params[])
{
        new id,string[70];
        if(sscanf(params,"d",id)) SendClientMessage(playerid,COLOR_WHITE, "SERVER: /firefw [Firework ID]");
        else
        {
                if(Firework[id][fwA] == 0) return SendClientMessage(playerid,COLOR_GREY,"Wrong Firework ID!");
                format(string,sizeof(string),"Firework %d launched!",id);
                SendClientMessage(playerid,COLOR_WHITE,string);
                LaunchFirework(id);
        }
        return 1;
}
CMD:firefwall(playerid,params[])
{
        SendClientMessage(playerid,COLOR_WHITE,"All fireworks are launched!");
        for(new i = 0; i < MAX_FIREWORKS; i++)
        {
                if(Firework[i][fwA] != 0 && Firework[i][fwLoop] != 0) LaunchFirework(i);
        }
        return 1;
}
CMD:destroyfwall(playerid,params[])
{
        for(new id = 0; id < MAX_FIREWORKS; id++)
        {
            DestroyObject(Firework[id][fwid]);
            Firework[id][fwid]   = INVALID_OBJECT_ID;
            Firework[id][fwX]    = 0.000000;
            Firework[id][fwY]    = 0.000000;
            Firework[id][fwZ]    = 0.000000;
            Firework[id][fwA]    = 0.000000;
            Firework[id][fwLoop] = 0;
        }
        FireworkCount = 0;
        SendClientMessage(playerid,COLOR_WHITE,"All fireworks are destroyed!");
        return 1;
}
CMD:fwhelp(playerid,params[])
{
        new string[280];
        format(string,sizeof(string),"FilterScript Name: BU Firework\nAuthor: Gigi Falcone\nVersion: v0.1 ALPHA\nLast Version: %s\nCommands:\n- createfw = this cmd is used to create firework on a location\n- firefw = it is used to fire a specific firework\n- firefwall = same as firefw except it fires all fireworks at the same time\n- destroyfwall = destroy all created fireworks",VersionInfo);
        ShowPlayerDialog(playerid,GIGI_DIALOG_ID,DIALOG_STYLE_MSGBOX,"Informacije o FilterSkripti",string,"Ok","");
        return 1;
}
// [8. CHANGELOG ] /////////////////////////////////////////////////////////////
//--[ v0.2 - 08.04.2011. 11:00 ]------------------------------------------------
/*
= created new command:
- destroyfwall
= updated commands with variable loop:
- createfw
- createfwall
= new firework variable: loop; sets how much times the firework will fire
= optimized some code
*/
//--[ v0.1 - 27.03.2011. 16:07 ]------------------------------------------------
/*
= Started Bu Firework Project
= Added four commands:
- createfw
- firefw
- firefwall
- fwhelp
= Added CreateFirework Function
*/
// [9. END OF FILE ] //////////////////////////////////////////////