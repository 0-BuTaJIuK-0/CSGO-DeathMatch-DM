Handle g_Assister;
Handle g_Victim;

void RemoveSound(int client)
{
	StopSound(client, SNDCHAN_ITEM, "buttons/bell1.wav");
}

public Action DisableSound(int clients[MAXPLAYERS], int &numClients, char sample[PLATFORM_MAX_PATH], int &entity, int &channel, float &volume, int &level, int &pitch, int &flags, char entry[PLATFORM_MAX_PATH], int &seed)
{
	static char sound_effects[][] =
	{
		"player/death",
		"player/pl_respawn"
		//"player/bhit_helmet" звук попадания по голове
	};

	for (int i = 0; i < sizeof(sound_effects); i++)
	{
		if (StrContains(sample, sound_effects[i]) != -1)
		{
			return Plugin_Handled;
		}
	}

	return Plugin_Continue;
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if (StrEqual(classname, "chicken"))
	{
		AcceptEntityInput(entity, "kill");
	}
}

public Action DisableRadio(UserMsg msg_id, Handle msg, const int[] players, int playersNum, bool reliable, bool init)
{
	return Plugin_Handled;
}

public Action DisableChat(UserMsg msg_id, Handle msg, const int[] players, int playersNum, bool reliable, bool init)
{
	char text[64];

	PbReadString(msg, "params", text, sizeof(text), 0);

	static char text_messages[][] =
	{
		"#Player_Point_Award",
		"#Cannot_Carry_Anymore",
		"#Cstrike_TitlesTXT_Game_teammate",
		"#Hint_try_not_to_injure_teammates",
		"#Chat_SavePlayer"
	};

	for (int i = 0; i < sizeof(text_messages); i++)
	{
		if (StrContains(text, text_messages[i], false) != -1)
		{
			return Plugin_Handled;
		}
	}

	return Plugin_Continue;
}

public Action DisableMessages(Event hEvent, const char[] name, bool dontBroadcast)
{
	return Plugin_Handled;
}

public Action DisableEffect(const char[] name, const int[] clients, int num, float delay)
{
	return Plugin_Handled;
}