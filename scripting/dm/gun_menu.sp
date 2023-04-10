new Handle:g_PercentAWPPlayers;
new Handle:g_FlagUnlimitedAWP;

new String:g_PrimaryGuns[32][32];
new String:g_SecondaryGuns[32][32];
new bool:g_ClientFirstConnect[MAXPLAYERS+1] = {true, ...};
int g_CountAvailableAwp;
int g_CountUsedClientsAwp;

enum Slots
{
	Slot_Primary,
	Slot_Secondary,
	Slot_Knife,
	Slot_Grenade,
	Slot_C4,
	Slot_None
};

public GunMenuOnClientPutInServer(client)
{
	strcopy(g_PrimaryGuns[client], sizeof(g_PrimaryGuns[]), "weapon_ak47");
	strcopy(g_SecondaryGuns[client], sizeof(g_SecondaryGuns[]), "weapon_deagle");
	iCountFuncAvailableAwp();
}

public GunMenuOnClientDisconnect(client)
{
	strcopy(g_PrimaryGuns[client], sizeof(g_PrimaryGuns[]), "weapon_ak47");
	strcopy(g_SecondaryGuns[client], sizeof(g_SecondaryGuns[]), "weapon_deagle");
	g_ClientFirstConnect[client] = true;
	iCountFuncAvailableAwp();
	iCountFuncUsedClientsAwp();
}

public GunMenuEvent_PlayerSpawn(client)
{
	GivePrimary(client);
	GiveSecondary(client);
	if(g_ClientFirstConnect[client])
	{
		GunMenu(client);
		CGOPrintToChat(client, "%t%t", "Prefix", "How to buy", "G");
	}
}

public Action:BlockBuy(client, args)
{
		return Plugin_Handled;
}

public Action:BlockBuyAndMenu(client, args)
{
        GunMenu(client);
        return Plugin_Handled;
}

// ****************************************************************************************************************************************************************************************************
// Просчёт AWP

public iCountFuncAvailableAwpKostil(Handle:convar, const String:oldValue[], const String:newValue[])
{
	iCountFuncAvailableAwp() 
}

iCountFuncAvailableAwp() 
{
	int iCount = 0;
	for(new i = 1; i <= MaxClients; i++)
	{
		if(CheckClient(i))
		{
			iCount++;
		}
	}
	g_CountAvailableAwp = iCount * GetConVarInt(g_PercentAWPPlayers) / 100;
}

iCountFuncUsedClientsAwp()
{
	int iCount = 0;
	for(new i = 1; i <= MaxClients; i++)
	{
		if(CheckClient(i))
		{
			if(StrEqual(g_PrimaryGuns[i],"weapon_awp"))
			{
				iCount++
			}
		}
	}
	g_CountUsedClientsAwp = iCount;
}
// ****************************************************************************************************************************************************************************************************

// ****************************************************************************************************************************************************************************************************
// Покупка через стандартное меню на B

public Action:CS_OnBuyCommand(client, const String:weapon[]) 
{ 
	char szWeapon[32];
	Format(szWeapon, sizeof(szWeapon), "weapon_%s", weapon);
	if(CheckPrimaryGun(szWeapon))
	{
		strcopy(g_PrimaryGuns[client], sizeof(g_PrimaryGuns[]), szWeapon);
	}
	else if(CheckSecondaryGun(szWeapon))
	{
		strcopy(g_SecondaryGuns[client], sizeof(g_SecondaryGuns[]), szWeapon);
	}
	else if(CheckAutoSniperGun(szWeapon))
	{
		CGOPrintToChat(client, "%t%t", "Prefix", "Baned AutoSniper");
		return Plugin_Handled; 
	}
	else if(CheckAWPGun(szWeapon))
	{
		decl String:buffer[8]
		GetConVarString(g_FlagUnlimitedAWP, buffer, sizeof(buffer))
		if (g_CountUsedClientsAwp < g_CountAvailableAwp || (GetUserFlagBits(client) & ReadFlagString(buffer)))
		{
			strcopy(g_PrimaryGuns[client], sizeof(g_PrimaryGuns[]), szWeapon);
		}
		else
		{
			CGOPrintToChat(client, "%t%t", "Prefix", "Message when buying via B awp");
			return Plugin_Handled; 
		}
	}
	iCountFuncUsedClientsAwp();
	return Plugin_Continue; 
}

// ****************************************************************************************************************************************************************************************************

// ****************************************************************************************************************************************************************************************************
// Меню выбора оружия
public Action:GunMenuKostil(client, args)
{
	GunMenu(client);
}

public Action:GunMenu(client)
{
	Menu gMenu = new Menu(MenuHandler_gzMenu, MenuAction_Select|MenuAction_Cancel);

	char szBuffer[64];
	FormatEx(szBuffer, sizeof(szBuffer), "%T", "Title Primary GunMenu", client);

	gMenu.SetTitle(szBuffer);
	/* // Отключать пушки, которые уже у тебя.
	char WeaponName[32];
	WeaponName = g_PrimaryGuns[client];
	PrintToChatAll("%s", WeaponName);

	if (!StrEqual(WeaponName,"weapon_ak47"))
	{gMenu.AddItem("weapon_ak47", "AK47");}
	else{gMenu.AddItem("weapon_ak47", "AK47 (use)", ITEMDRAW_DISABLED);}
	*/
	gMenu.AddItem("weapon_ak47", "AK-47");
	gMenu.AddItem("weapon_m4a1", "M4A4");
	gMenu.AddItem("weapon_m4a1_silencer", "M4A1-S");

	decl String:buffer[8]
	GetConVarString(g_FlagUnlimitedAWP, buffer, sizeof(buffer))
	if (g_CountUsedClientsAwp < g_CountAvailableAwp || (GetUserFlagBits(client) & ReadFlagString(buffer)) || StrEqual(g_PrimaryGuns[client],"weapon_awp"))
	{
		gMenu.AddItem("weapon_awp", "AWP");
	}
	else
	{
		gMenu.AddItem("weapon_awp", "AWP (PREMIUM)", ITEMDRAW_DISABLED);
	}

	gMenu.AddItem("weapon_sg556", "SG 553");
	gMenu.AddItem("weapon_aug", "AUG");

	gMenu.AddItem("weapon_galilar", "Galil AR");
	gMenu.AddItem("weapon_famas", "FAMAS");
	gMenu.AddItem("weapon_nova", "Nova");
	gMenu.AddItem("weapon_xm1014", "XM1014");
	gMenu.AddItem("weapon_sawedoff", "Sawed-Off");
	gMenu.AddItem("weapon_mag7", "MAG-7");

	gMenu.AddItem("weapon_mac10", "MAC-10");
	gMenu.AddItem("weapon_mp9", "MP9");
	gMenu.AddItem("weapon_mp7", "MP7");
	gMenu.AddItem("weapon_mp5sd", "MP5-SD");
	gMenu.AddItem("weapon_ump45", "UMP-45");
	gMenu.AddItem("weapon_p90", "P90");

	gMenu.AddItem("weapon_bizon", "PP-Bizon");
	gMenu.AddItem("weapon_ssg08", "SSG 08");
	gMenu.AddItem("weapon_m249", "M249");
	gMenu.AddItem("weapon_negev", "Negev");

	gMenu.ExitButton = true;
	gMenu.Display(client, MENU_TIME_FOREVER);
}

public MenuHandler_gzMenu(Menu gzMenu, MenuAction action, int client, int item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char weapon_name[32];
			gzMenu.GetItem(item, weapon_name, sizeof(weapon_name));

			if (StrEqual(weapon_name,"weapon_awp"))
			{
				decl String:buffer[8]
				GetConVarString(g_FlagUnlimitedAWP, buffer, sizeof(buffer))
				if (g_CountUsedClientsAwp < g_CountAvailableAwp || (GetUserFlagBits(client) & ReadFlagString(buffer)) || StrEqual(g_PrimaryGuns[client],"weapon_awp"))
				{
					strcopy(g_PrimaryGuns[client], sizeof(g_PrimaryGuns[]), weapon_name);
					iCountFuncUsedClientsAwp();
					GivePrimary(client);
					GunSecondoryMenu(client);
				}
				else
				{
					CGOPrintToChat(client, "%t%t", "Prefix", "Too late to take awp");
					GunMenu(client);
				}
			}
			else
			{
				strcopy(g_PrimaryGuns[client], sizeof(g_PrimaryGuns[]), weapon_name);
				iCountFuncUsedClientsAwp();
				GivePrimary(client);
				GunSecondoryMenu(client);
			}
		}
        case MenuAction_End:
        {
            delete gzMenu;
        }
	}
}

public Action:GunSecondoryMenu(client)
{
	Menu gsMenu = new Menu(MenuHandler_gszMenu, MenuAction_Select|MenuAction_Cancel);

	char szBuffer[64];
	FormatEx(szBuffer, sizeof(szBuffer), "%T", "Title Secondary GunMenu", client);

	gsMenu.SetTitle(szBuffer);

	gsMenu.AddItem("weapon_glock", "Glock-18");
	gsMenu.AddItem("weapon_usp_silencer", "USP-S");
	gsMenu.AddItem("weapon_hkp2000", "P2000");
	gsMenu.AddItem("weapon_deagle", "Desert Eagle");
	gsMenu.AddItem("weapon_p250", "P250");
	gsMenu.AddItem("weapon_elite", "Dual Berettas");

	gsMenu.AddItem("weapon_tec9", "Tec-9");
	gsMenu.AddItem("weapon_fiveseven", "Five-SeveN");
	gsMenu.AddItem("weapon_cz75a", "CZ75-Auto");
	gsMenu.AddItem("weapon_revolver", "R8 Revolver");

	gsMenu.ExitButton = true;
	gsMenu.Display(client, MENU_TIME_FOREVER);
}

public MenuHandler_gszMenu(Menu gszMenu, MenuAction action, int client, int item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char weapon_name[32];
			gszMenu.GetItem(item, weapon_name, sizeof(weapon_name));
			strcopy(g_SecondaryGuns[client], sizeof(g_SecondaryGuns[]), weapon_name);
			GiveSecondary(client);
			g_ClientFirstConnect[client] = false;
		}
        case MenuAction_End:
        {
            delete gszMenu;
        }
	}
}
// ****************************************************************************************************************************************************************************************************

stock GivePrimary(client)
{
	if (IsPlayerAlive(client))
	{
		RemoveWeaponBySlot(client, Slot_Primary);
		GivePlayerItem(client, g_PrimaryGuns[client]);
	}
}

stock GiveSecondary(client)
{
	if (IsPlayerAlive(client))
	{
	RemoveWeaponBySlot(client, Slot_Secondary);
	GivePlayerItem(client, g_SecondaryGuns[client]);
	}
}

stock bool:RemoveWeaponBySlot(client, Slots:slot)
{
	new entity_index = GetPlayerWeaponSlot(client, _:slot);
	if (entity_index>0)
	{
		RemovePlayerItem(client, entity_index);
		AcceptEntityInput(entity_index, "Kill");
		return true;
	}
	return false;
}