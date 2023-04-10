new Handle:g_HPKill;
new Handle:g_HPKillHS;

int AMMOPrimaryGun[MAXPLAYERS+1];
int AMMOSecondaryGun[MAXPLAYERS+1];

public HpAmmoOnClientPutInServer(client)
{
		SDKHook(client, SDKHook_WeaponEquip, OnWeaponEquip);
}

public HpAmmoEvent_PlayerDeath(attack, victim, weapon, char[] szWeaponName, headshot)
{
	int szHealth = GetEntProp(attack, Prop_Send, "m_iHealth");
	if(szHealth < 100)
	{
		if(headshot)
		{
			if(szHealth + GetConVarInt(g_HPKillHS) > 100)
			{
				SetEntProp(attack, Prop_Send, "m_iHealth", 100);
			}
			else
			{
				SetEntProp(attack, Prop_Send, "m_iHealth", szHealth + GetConVarInt(g_HPKillHS));
			}
		}
		else
		{
			if(szHealth + GetConVarInt(g_HPKill) > 100)
			{
				SetEntProp(attack, Prop_Send, "m_iHealth", 100);
			}
			else
			{
				SetEntProp(attack, Prop_Send, "m_iHealth", szHealth + GetConVarInt(g_HPKill));
			}
		}
	}

	if (IsValidEntity(weapon))
	{
		if(CheckPrimaryGun(szWeaponName) || CheckAWPGun(szWeaponName))
		{
			SetEntProp(weapon, Prop_Data, "m_iClip1", AMMOPrimaryGun[attack]+1);
		}
		else if(CheckSecondaryGun(szWeaponName))
		{
			SetEntProp(weapon, Prop_Data, "m_iClip1", AMMOSecondaryGun[attack]+1);
		}
	}

}

public Action OnWeaponEquip(int client, int weapon)
{
	char szWeaponName[32];
	int iItemDefIndex = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
	CS_WeaponIDToAlias(CS_ItemDefIndexToID(iItemDefIndex), szWeaponName, sizeof(szWeaponName)); 
	Format(szWeaponName, sizeof(szWeaponName), "weapon_%s", szWeaponName); 

	if(CheckPrimaryGun(szWeaponName) || CheckAWPGun(szWeaponName))
	{
		AMMOPrimaryGun[client] = GetEntProp(weapon, Prop_Send, "m_iClip1");
	}
	else if(CheckSecondaryGun(szWeaponName))
	{
		AMMOSecondaryGun[client] = GetEntProp(weapon, Prop_Send, "m_iClip1");
	}
	return Plugin_Continue;
}