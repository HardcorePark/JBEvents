#pragma semicolon 1

#define PLUGIN_VERSION "1.03"
#define PLUGIN_PREFIX "[\x06Tango Events\x01]"

#include <sourcemod>

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

bool g_MMDisarmT;
int g_LastPage[MAXPLAYERS + 1];

public void OnPluginStart()
{
	RegAdminCmd("sm_jbevents", Command_jbevents, ADMFLAG_RCON);
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
	
	return Plugin_Handled;
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
		
		switch(EventsMenu:StringToInt(lOption))
		{
			case michealmyers:
			{
				MichealMyersMenu(client);
			}
		}
	}	
}

public MichealMyersMenu(client)
{
	Handle mm_menu = CreateMenu(MmMenuHandle, MENU_ACTIONS_ALL);
	SetMenuTitle(mm_menu, "Tango Events - Micheal Myers");
	
	char taTmp[256];
	
	if (g_MMDisarmT)
	{
		Format(taTmp, sizeof(taTmp), "T's Disarmed - Yes");
	} else {
		Format(taTmp, sizeof(taTmp), "T's Disarmed - No");
	}
	AddMenuItem(mm_menu, taTmp, taTmp);
	
}

public MmMenuHandle(Handle menu, MenuAction action, client, option)
{
	if (action == MenuAction_Select)
	{
		switch (option)
		{
			case 0:
			{
				if (g_MMDisarmT)
				{
					g_MMDisarmT = false;
				} else {
					g_MMDisarmT = true;
				}
			}
		}
		
		g_LastPage[client] = option;
	}
}

