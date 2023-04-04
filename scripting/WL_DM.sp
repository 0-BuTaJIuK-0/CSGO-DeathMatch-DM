#include <sourcemod>

public Plugin:myinfo = 
{
	name = "WL DM",
	author = "0-BuTaJIuK-0",
	description = "DeathMath",
	version = "1.0",
	url = "https://wildleague.pro"
};

public OnPluginStart()	
{
	RegConsoleCmd("sm_guns", MainMenu);
}

