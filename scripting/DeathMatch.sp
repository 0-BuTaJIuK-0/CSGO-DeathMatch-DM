#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <cstrike>
#include <csgo_colors>

#include "dm/gun_menu.sp"
#include "dm/hp_ammo.sp"
#include "dm/disable_standard_func.sp"

public Plugin:myinfo = 
{
	name = "DM",
	author = "0-BuTaJIuK-0",
	description = "DeathMath",
	version = "1.0",
	url = "https://butagames.ru"
};

public OnPluginStart()	
{
	if (GetEngineVersion() != Engine_CSGO)
	{
		SetFailState("ERROR: This plugin is designed only for CS:GO");
	}

	if (GetConVarInt(FindConVar("game_mode")) != 2 || GetConVarInt(FindConVar("game_type")) != 1)
	{
		SetFailState("ERROR: This plugin is designed only for DM game mode");
	}

	g_PercentAWPPlayers = CreateConVar("dm_PercentAWPPlayers", "35", "Sets the percentage of players who can take awp (100 - allow all)", _, true, 0.0, true, 100.0);
	HookConVarChange(g_PercentAWPPlayers, iCountFuncAvailableAwpKostil);
	g_FlagUnlimitedAWP = CreateConVar("dm_FlagUnlimitedAWP", "o", "Specifies the flag of the players who have unlimited use of AWP available");
	g_HPKill = CreateConVar("dm_HPKill", "15", "the amount of hp replenished when killing", _, true, 0.0, true, 100.0);
	g_HPKillHS = CreateConVar("dm_HPKillHS", "25", "the amount of hp replenished when killing in the head", _, true, 0.0, true, 100.0);

	RegConsoleCmd("sm_guns", GunMenuKostil);
	RegConsoleCmd("sm_gun", GunMenuKostil);
	RegConsoleCmd("sm_weapon", GunMenuKostil);

	RegConsoleCmd("autobuy", BlockBuy);
	RegConsoleCmd("rebuy", BlockBuy);
	RegConsoleCmd("buyrandom", BlockBuy);
	RegConsoleCmd("drop", BlockBuyAndMenu);

	HookEvent("player_spawn", Event_PlayerSpawn);
	HookEvent("player_death", Event_PlayerDeath);

	LoadTranslations("csgo_deathmath.phrases");
}

public OnClientPutInServer(client)
{
	if (CheckClient(client))
	{
		GunMenuOnClientPutInServer(client);
		HpAmmoOnClientPutInServer(client);
	}
}

public OnClientDisconnect(client)
{
	if (CheckClient(client))
	{
		GunMenuOnClientDisconnect(client);
	}
}

public Event_PlayerSpawn(Event:event, const char[] name, bool:dontBroadcast)
{
	new client = GetClientOfUserId(event.GetInt("userid"));
	if(CheckClient(client))
	{
		GunMenuEvent_PlayerSpawn(client);
	}
}

public Event_PlayerDeath(Event:event, const char[] name, bool:dontBroadcast)
{
	int attack = GetClientOfUserId(event.GetInt("attacker"));
	int victim = GetClientOfUserId(event.GetInt("userid"));
	bool headshot = GetEventBool(event, "headshot");
	int weapon = GetEntPropEnt(attack, Prop_Data, "m_hActiveWeapon");

	char szWeaponName[32];
	GetEventString(event, "weapon", szWeaponName, sizeof(szWeaponName));
	Format(szWeaponName, sizeof(szWeaponName), "weapon_%s", szWeaponName);


	HpAmmoEvent_PlayerDeath(attack, victim, weapon, szWeaponName, headshot);
}

bool CheckClient(int client)
{
	return (IsClientInGame(client) && !IsFakeClient(client));
}

// ****************************************************************************************************************************************************************************************************
// Проверка, какое оружие

bool CheckPrimaryGun(const char[] szWeapon)
{
	if(strcmp(szWeapon, "weapon_ak47") == 0 || strcmp(szWeapon, "weapon_m4a1") == 0 || strcmp(szWeapon, "weapon_m4a1_silencer") == 0 || strcmp(szWeapon, "weapon_sg556") == 0 || strcmp(szWeapon, "weapon_aug") == 0 ||
	strcmp(szWeapon, "weapon_galilar") == 0 || strcmp(szWeapon, "weapon_famas") == 0 || strcmp(szWeapon, "weapon_nova") == 0 || strcmp(szWeapon, "weapon_xm1014") == 0 || strcmp(szWeapon, "weapon_sawedoff") == 0 || strcmp(szWeapon, "weapon_mag7") == 0 ||
	strcmp(szWeapon, "weapon_mac10") == 0 || strcmp(szWeapon, "weapon_mp9") == 0 || strcmp(szWeapon, "weapon_mp7") == 0 || strcmp(szWeapon, "weapon_mp5sd") == 0 || strcmp(szWeapon, "weapon_ump45") == 0 || strcmp(szWeapon, "weapon_p90") == 0 ||
	strcmp(szWeapon, "weapon_bizon") == 0 || strcmp(szWeapon, "weapon_ssg08") == 0 || strcmp(szWeapon, "weapon_m249") == 0 || strcmp(szWeapon, "weapon_negev") == 0)
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool CheckSecondaryGun(const char[] szWeapon)
{
	if(strcmp(szWeapon, "weapon_glock") == 0 || strcmp(szWeapon, "weapon_usp_silencer") == 0 || strcmp(szWeapon, "weapon_hkp2000") == 0 || strcmp(szWeapon, "weapon_deagle") == 0 || strcmp(szWeapon, "weapon_p250") == 0 ||
	strcmp(szWeapon, "weapon_elite") == 0 || strcmp(szWeapon, "weapon_tec9") == 0 || strcmp(szWeapon, "weapon_fiveseven") == 0 || strcmp(szWeapon, "weapon_cz75a") == 0 || strcmp(szWeapon, "weapon_revolver") == 0)
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool CheckAutoSniperGun(const char[] szWeapon)
{
	if(strcmp(szWeapon, "weapon_g3sg1") == 0 || strcmp(szWeapon, "weapon_scar20") == 0)
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool CheckAWPGun(const char[] szWeapon)
{
	if(strcmp(szWeapon, "weapon_awp") == 0)
	{
		return true;
	}
	else
	{
		return false;
	}
}
// ****************************************************************************************************************************************************************************************************