#pragma semicolon 1

#define PLUGIN_VERSION "1.11"
#define PLUGIN_PREFIX "[\x06Tango Events\x01]"

#include <sourcemod>
#include <SDKtools>
#include <basecomm>

#include "JBEvents\subs.sp"

enum EventsMenu
{
	michealmyers,
}

public Plugin myinfo = 
{
	name = "Tango Events",
	author = "Oscar Wos (OSWO)",
	description = "Tango Events",
	version = PLUGIN_VERSION,
	url = "www.tangoworldwide.net",
};

bool g_DisarmT = false;
bool g_MuteT = false;
bool g_GagT = false;
bool g_AllFrozen = false;
bool g_EventInProgress = false;
bool g_PreSetup = false;

int g_LastPage[MAXPLAYERS + 1];
char g_EventName[128];


public void OnPluginStart()
{
	RegAdminCmd("sm_jbevents", Command_jbevents, ADMFLAG_RCON);
	RegAdminCmd("sm_cancelevent", Command_cancelevent, ADMFLAG_RCON);
	HookEvent("round_end", Event_RoundEnd);
	
}

public Action Event_RoundEnd(Handle event, char[] name, bool dontBroadcast)
{
	ResetRound();
}

public Action Command_cancelevent(client, args)
{
	if (args != 0)
	{
		PrintToChat(client, "%s Too many arguements!", PLUGIN_PREFIX);
		return Plugin_Handled;
	}
	
	char clientName[128];
	GetClientName(client, clientName, sizeof(clientName));
	if (g_EventInProgress)
	{
		PrintToChatAll("%s \x10%s \x01has cancelled the event!", PLUGIN_PREFIX, clientName);
	} else {
		PrintToChat(client, "%s No event in progress!", PLUGIN_PREFIX);
	}
	
	if (g_AllFrozen)
		ServerCommand("sm_freeze @all 0");
	
	ResetRound();
	return Plugin_Continue;
}

public Action Command_jbevents(client, args)
{
	if (args != 0)
	{
		PrintToChat(client, "%s Too many arguements!", PLUGIN_PREFIX);
		return Plugin_Handled;
	}
	
	Handle events_menu = CreateMenu(EventsMenuHandle, MENU_ACTIONS_ALL);
	SetMenuTitle(events_menu, "Tango Events - Menu");
	AddMenuItem(events_menu, "0", "Micheal Myers");
	DisplayMenu(events_menu, client, 0);
	
	return Plugin_Continue;
}

public EventsMenuHandle(Handle menu, MenuAction action, client, option)
{
	if (action == MenuAction_Select)
	{
		char lOption[64];
		if (!GetMenuItem(menu, option, lOption, sizeof(lOption)))
		{
			PrintToChat(client, "%s Invalid Option!", PLUGIN_PREFIX);
		}
		
		PrintToChatAll("%s \x07Attention! An Admin is setting up an Event! Read for further Information!", PLUGIN_PREFIX);
		
		if (ServerCommand("sm_freeze @all -1"))
			g_AllFrozen = true;
		
		g_PreSetup = true;
		
		switch(EventsMenu:StringToInt(lOption))
		{
			case michealmyers:
			{
				MichealMyersMenu(client);
				g_EventName = "Micheal Myers";
			}
		}
	}

}

public MichealMyersMenu(client)
{
	Handle mm_menu = CreateMenu(MmMenuHandle, MENU_ACTIONS_ALL);
	SetMenuTitle(mm_menu, "Tango Events - Micheal Myers");
	
	char taTmp[256];
	
	if (g_DisarmT)
	{
		Format(taTmp, sizeof(taTmp), "T's Disarmed - Yes");
	} else {
		Format(taTmp, sizeof(taTmp), "T's Disarmed - No");
	}
	AddMenuItem(mm_menu, taTmp, taTmp);
	
	if (g_MuteT)
	{
		Format(taTmp, sizeof(taTmp), "T's Muted - Yes");
	} else {
		Format(taTmp, sizeof(taTmp), "T's Muted - No");
	}
	AddMenuItem(mm_menu, taTmp, taTmp);
	
	if (g_GagT)
	{
		Format(taTmp, sizeof(taTmp), "T's Gagged - Yes");
	} else {
		Format(taTmp, sizeof(taTmp), "T's Gagged - No");
	}
	AddMenuItem(mm_menu, taTmp, taTmp);
	
	Format(taTmp, sizeof(taTmp), "Initiate Event?");
	AddMenuItem(mm_menu, taTmp, taTmp);
	
	if (g_LastPage[client] < 6)
	{
		DisplayMenuAtItem(mm_menu, client, 0, 0);
	} else {
		if (g_LastPage[client] < 12)
		{
			DisplayMenuAtItem(mm_menu, client, 6, 0);
		}
	}
		
}

public MmMenuHandle(Handle menu, MenuAction action, client, option)
{
	if (action == MenuAction_Select)
	{
		bool refresh = true;
		switch (option)
		{
			case 0:
			{
				if (g_DisarmT)
				{
					g_DisarmT = false;
					PrintToChat(client, "%s T's Disarmed, Now - False", PLUGIN_PREFIX);
				} else {
					g_DisarmT = true;
					PrintToChat(client, "%s T's Disarmed, Now - True", PLUGIN_PREFIX);
				}
			}
			
			case 1:
			{
				if (g_MuteT)
				{
					g_MuteT = false;
					PrintToChat(client, "%s T's Muted, Now - False", PLUGIN_PREFIX);
				} else {
					g_MuteT = true;
					PrintToChat(client, "%s T's Muted, Now - True", PLUGIN_PREFIX);
				}
			}
			
			case 2:
			{
				if (g_GagT)
				{
					g_GagT = false;
					PrintToChat(client, "%s T's Gagged, Now - False", PLUGIN_PREFIX);
				} else {
					g_GagT = true;
					PrintToChat(client, "%s T's Gagged, Now - True", PLUGIN_PREFIX);
				}
			}
			case 3:
			{
				refresh = false;
				InitiateEvent(client);
			}
		}
		
		g_LastPage[client] = option;
		
		if (refresh)
			CreateTimer(0.1, RefreshMenu, client);	
	}
	
	else if (action == MenuAction_Cancel)
	{
		PrintToChatAll("%s Admin has stopped making an event!", PLUGIN_PREFIX);
		ResetRound();
	}
}

public InitiateEvent(client)
{
	PrintToChatAll("%s \x02EVENT HAS BEEN INITATED!", PLUGIN_PREFIX);
	PrintToChatAll("%s Event Name: \x10%s", PLUGIN_PREFIX, g_EventName);
	PrintToChatAll("%s ---------- Event Rules/Info-----------", PLUGIN_PREFIX);
	
	
	if (g_DisarmT)
	{
		PrintToChatAll("%s T's \x07Are \x01Disarmed", PLUGIN_PREFIX);
		DisarmT();
		UnloadPlugins();
	} else {
		PrintToChatAll("%s T's \x07Are Not \x01Disarmed", PLUGIN_PREFIX);
	}
	
	if (g_MuteT)
	{
		PrintToChatAll("%s T's \x07Are \x01Muted", PLUGIN_PREFIX);
		MuteT();
	} else {
		PrintToChatAll("%s T's \x07Are Not \x01Muted", PLUGIN_PREFIX);
	}
	
	if (g_GagT)
	{
		PrintToChatAll("%s T's \x07Are \x01Gagged", PLUGIN_PREFIX);
		GagT();
	} else {
		PrintToChatAll("%s T's \x07Are Not \x01Gagged", PLUGIN_PREFIX);
	}
	
	if (ServerCommand("sm_freeze @all 0"))
		g_AllFrozen = false;
		
	g_EventInProgress = true;

}

public Action RefreshMenu(Handle timer, client)
{
	if (IsValidPlayer(client))
	{
		MichealMyersMenu(client);
	}
}

public DisarmT()
{
	ServerCommand("sm_disarm @t 1");
}

public UnloadPlugins()
{
	if (g_DisarmT)
	{
		ServerCommand("sm plugins unload TangoPlugins/knifeswapper");
	}
}

public ResetRound()
{
	if (g_DisarmT)
	{
		ServerCommand("sm plugins load TangoPlugins/knifeswapper");
		for (int i = 0; i <= MaxClients; i++)
		{
			if (IsValidPlayer(i))
			{
				int playerTeam = GetClientTeam(i);
				
				if(playerTeam == 2)
				{
					GivePlayerItem(i, "weapon_knife", 0);
				}
			}
		}
		g_DisarmT = false;
	}
	
	if (g_MuteT)
	{
		UnMuteT();
		g_MuteT = false;
	}
	
	if (g_GagT)
	{
		UnGagT();
		g_GagT = false;
	}
	
	if (g_AllFrozen)
	{
		ServerCommand("sm_freeze @all 0");
		g_AllFrozen = false;
	}
	
	g_EventInProgress = false;
	g_PreSetup = false;
}