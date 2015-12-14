public MuteT()
{
	for (int i = 0; i <= MaxClients; i++)
	{
		if (IsValidPlayer(i))
		{
			int clientTeam = GetClientTeam(i);
			
			if (clientTeam == 2)
			{
				BaseComm_SetClientMute(i, true);
			}
		}
	}
}

public GagT()
{
	for (int i = 0; i <= MaxClients; i++)
	{
		if (IsValidPlayer(i))
		{
			int clientTeam = GetClientTeam(i);
			
			if (clientTeam == 2)
			{
				BaseComm_SetClientGag(i, true);
			}
		}
	}
}

public UnMuteT()
{
	for (int i = 0; i <= MaxClients; i++)
	{
		if (IsValidPlayer(i))
		{
			int clientTeam = GetClientTeam(i);
			
			if (clientTeam == 2)
			{
				BaseComm_SetClientMute(i, false);
			}
		}
	}
}

public UnGagT()
{
	for (int i = 0; i <= MaxClients; i++)
	{
		if (IsValidPlayer(i))
		{
			int clientTeam = GetClientTeam(i);
			
			if (clientTeam == 2)
			{
				BaseComm_SetClientGag(i, false);
			}
		}
	}
}

public ReArmT()
{
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
}

public DisarmT()
{
	ServerCommand("sm_disarm @t 1");
}

public UnloadKnife()
{
	ServerCommand("sm plugins unload TangoPlugins/knifeswapper");
}

stock bool IsValidPlayer(int client, bool alive = false)
{
   if(client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && (alive == false || IsPlayerAlive(client)))
   {
       return true;
   }
   return false;
}