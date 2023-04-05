#include <sourcemod>
#include <sdktools>
#include <csgo_colors>

public Plugin:myinfo = 
{
	name = "DM",
	author = "0-BuTaJIuK-0",
	description = "DeathMath",
	version = "1.0",
	url = "https://butagames.ru"
};

enum Slots
{
	Slot_Primary,
	Slot_Secondary,
	Slot_Knife,
	Slot_Grenade,
	Slot_C4,
	Slot_None
};

enum Teams
{
	CS_TEAM_NONE,
	CS_TEAM_SPECTATOR,
	CS_TEAM_T,
	CS_TEAM_CT
};

new String:g_PrimaryGuns[32][32];
new String:g_SecondaryGuns[32][32];
new bool:g_ClientFirstConnect[MAXPLAYERS+1] = {true, ...};
int g_CountAvailableAwp;
int g_CountUsedClientsAwp;

public OnPluginStart()	
{
	RegConsoleCmd("sm_guns", GunMenuKostil);
	RegConsoleCmd("sm_gun", GunMenuKostil);
	RegConsoleCmd("sm_testcount", iCountFuncKostil);
	HookEvent("player_spawn", Event_PlayerSpawn);
}

public OnClientPutInServer(client)
{
	if (CheckClient(client))
	{
		strcopy(g_PrimaryGuns[client], sizeof(g_PrimaryGuns[]), "weapon_ak47");
		strcopy(g_SecondaryGuns[client], sizeof(g_SecondaryGuns[]), "weapon_deagle");
		iCountFuncAvailableAwp();
	}
}

public OnClientDisconnect_Post(client)
{
	if (CheckClient(client))
	{
		strcopy(g_PrimaryGuns[client], sizeof(g_PrimaryGuns[]), "weapon_ak47");
		strcopy(g_SecondaryGuns[client], sizeof(g_SecondaryGuns[]), "weapon_deagle");
		g_ClientFirstConnect[client] = true;
		iCountFuncAvailableAwp();
		iCountFuncUsedClientsAwp();
	}
}


iCountFuncAvailableAwp() 
{
	//int iCount = GetClientCount(); // Один из вариантов хука кол-во слотов, но с ботом GOTV
	int iCount = 0;
	for(new i = 1; i <= MaxClients; i++)
	{
		if(CheckClient(i))
		{
			iCount++;
		}
	}
	g_CountAvailableAwp = iCount * 50 / 100;
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


public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"))
	if(CheckClient(client))
	{
		GivePrimary(client);
		GiveSecondary(client);
		if(g_ClientFirstConnect[client])
		{
			GunMenu(client);
			CGOPrintToChat(client, "{DEFAULT}[{LIGHTBLUE}WildLeague{DEFAULT}] Для открытия меню выбора оружия используйте - {RED}[G]");
		}
	}
}


public Action:CS_OnBuyCommand(client, const String:weapon[]) 
{ 
	char szWeapon[32];
	Format(szWeapon, sizeof(szWeapon), "weapon_%s", weapon);
	if(strcmp(szWeapon, "weapon_ak47") == 0 || strcmp(szWeapon, "weapon_m4a1") == 0 || strcmp(szWeapon, "weapon_m4a1_silencer") == 0 || strcmp(szWeapon, "weapon_sg556") == 0 || strcmp(szWeapon, "weapon_aug") == 0 ||
	strcmp(szWeapon, "weapon_galilar") == 0 || strcmp(szWeapon, "weapon_famas") == 0 || strcmp(szWeapon, "weapon_nova") == 0 || strcmp(szWeapon, "weapon_xm1014") == 0 || strcmp(szWeapon, "weapon_sawedoff") == 0 || strcmp(szWeapon, "weapon_mag7") == 0 ||
	strcmp(szWeapon, "weapon_mac10") == 0 || strcmp(szWeapon, "weapon_mp9") == 0 || strcmp(szWeapon, "weapon_mp7") == 0 || strcmp(szWeapon, "weapon_mp5sd") == 0 || strcmp(szWeapon, "weapon_ump45") == 0 || strcmp(szWeapon, "weapon_p90") == 0 ||
	strcmp(szWeapon, "weapon_bizon") == 0 || strcmp(szWeapon, "weapon_ssg08") == 0 || strcmp(szWeapon, "weapon_m249") == 0 || strcmp(szWeapon, "weapon_negev") == 0)
	{
		strcopy(g_PrimaryGuns[client], sizeof(g_PrimaryGuns[]), szWeapon);
	}
	else if(strcmp(szWeapon, "weapon_glock") == 0 || strcmp(szWeapon, "weapon_usp_silencer") == 0 || strcmp(szWeapon, "weapon_hkp2000") == 0 || strcmp(szWeapon, "weapon_deagle") == 0 || strcmp(szWeapon, "weapon_p250") == 0 ||
	strcmp(szWeapon, "weapon_elite") == 0 || strcmp(szWeapon, "weapon_tec9") == 0 || strcmp(szWeapon, "weapon_fiveseven") == 0 || strcmp(szWeapon, "weapon_cz75a") == 0 || strcmp(szWeapon, "weapon_revolver") == 0)
	{
		strcopy(g_SecondaryGuns[client], sizeof(g_SecondaryGuns[]), szWeapon);
	}
	else if(strcmp(szWeapon, "weapon_g3sg1") == 0 || strcmp(szWeapon, "weapon_scar20") == 0)
	{
		CGOPrintToChat(client, "{DEFAULT}[{LIGHTBLUE}WildLeague{DEFAULT}] Автоматические снайперские винтовки - {RED}ЗАПРЕЩЕНЫ");
		return Plugin_Handled; 
	}
	else if(strcmp(szWeapon, "weapon_awp") == 0)
	{
		if (g_CountUsedClientsAwp >= g_CountAvailableAwp)
		{
			CGOPrintToChat(client, "{DEFAULT}[{LIGHTBLUE}WildLeague{DEFAULT}] Ограниченное кол-во {GREEN}AWP{DEFAULT}, что бы снять ограничение, приобретите - {OLIVE}PREMIUM");
			return Plugin_Handled; 
		}
		else
		{
			strcopy(g_PrimaryGuns[client], sizeof(g_PrimaryGuns[]), szWeapon);
		}
	}
	iCountFuncUsedClientsAwp();
}



public Action:GunMenuKostil(client, args)
{
	GunMenu(client);
}

public Action:iCountFuncKostil(client, args) // КОССТЫЛЬ НА ПРОВЕРКУ
{
	PrintToChatAll("g_CountAvailableAwp %i", g_CountAvailableAwp);
	PrintToChatAll("g_CountUsedClientsAwp %i", g_CountUsedClientsAwp);
}

/*
CheckUsedClientWeaponInMenu(client,NameWeapon,NameInMenu)
{
	if (StrEqual(g_PrimaryGuns[client],NameWeapon))
	{
		return gMenu.AddItem(NameWeapon, NameInMenu, ITEMDRAW_DISABLED);
	}
	else
	{
		return gMenu.AddItem("weapon_ak47", "AK47");
	}
}
*/

public Action:GunMenu(client)
{
	Menu gMenu = new Menu(MenuHandler_gzMenu, MenuAction_Select|MenuAction_Cancel);

	gMenu.SetTitle("Выбор Основного оружия:\n ");
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

	if (g_CountUsedClientsAwp >= g_CountAvailableAwp)
	{
		gMenu.AddItem("weapon_awp", "AWP (PREMIUM)", ITEMDRAW_DISABLED);
	}
	else
	{
		gMenu.AddItem("weapon_awp", "AWP");
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
			if (g_CountUsedClientsAwp >= g_CountAvailableAwp && StrEqual(weapon_name,"weapon_awp"))
			{
				CGOPrintToChat(client, "{DEFAULT}[{LIGHTBLUE}WildLeague{DEFAULT}] Кто-то успел взять {GREEN}AWP{DEFAULT} быстрее Вас.");
				GunMenu(client);
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

	gsMenu.SetTitle("Выбор Вторичного оружия:\n ");

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













bool CheckClient(int client)
{
	return (IsClientInGame(client) && !IsFakeClient(client));
}

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
