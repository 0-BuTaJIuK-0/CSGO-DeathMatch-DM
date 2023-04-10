# CSGO Deathmatch (DM) mode

## Info
This does not change the standard Deathmatch mode, but only complements it and removes unnecessary functional.

## Functional 
- WeaponMenu (Integrated with the standard purchase menu)
    - To open: sm_guns or button G (first spawn, open automatically)
    - Saves weapons from the plugin menu and the standard buy menu
    - AWP limit in 35% (to change it, use in the config `dm_PercentAWPPlayers "35"`)
    - Flag for unlimited use of AWP "o" (to change it, use in the config `dm_FlagUnlimitedAWP "o"`)
    - Block autobuy/rebuy/buyrandom/drop
- HP Recovery
    - Killing restores 15 hp (to change it, use in the config `dm_HPKill "15"`)
    - Killing in the head restores 25 hp (to change it, use in the config `dm_HPKillHS "25"`)
- Recovery of ammo when killing


## Use
- -game_mode 2 -game_type 1
- config (I'll post it soon)

## Thanks
[Grey83 (gunmenu)](https://github.com/Grey83/SourceMod-plugins/blob/master/SM/scripting/css_gunmenu.sp)  
[Alexey-Gamov (csgo-advanced-dm)](https://github.com/alexey-gamov/csgo-advanced-dm)