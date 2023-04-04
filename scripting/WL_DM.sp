#include <sourcemod>
#include <sdktools>

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
	RegConsoleCmd("sm_guns", GunMenu);
	RegConsoleCmd("sm_gun", GunMenu);
}

public Action:GunMenu(client, args)
{
	Menu gMenu = new Menu(MenuHandler_gzMenu, MenuAction_Select|MenuAction_Cancel);

	gMenu.SetTitle("Выберите Основное оружия:\n ");
	//gMenu.AddItem("test", "aboba", ITEMDRAW_SPACER|ITEMDRAW_RAWLINE);

	gMenu.AddItem("weapon_ak47", "AK-47");
	gMenu.AddItem("weapon_m4a1", "M4A4");
	gMenu.AddItem("weapon_m4a1_silencer", "M4A1-S");
	gMenu.AddItem("weapon_awp", "AWP");
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
			char gTitle[32];
			gzMenu.GetItem(item, gTitle, sizeof(gTitle));
			GivePlayerItem(client, gTitle);
			//PrintToChatAll("%s", gTitle);
		}
        case MenuAction_End:
        {
            delete gzMenu;
        }
	}
}