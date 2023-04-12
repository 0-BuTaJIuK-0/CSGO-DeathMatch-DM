# CSGO DeathMatch (DM) mode

## Info
This plugin does not replace the standard Deathmatch mode, but only complements it and removes unnecessary functionality.

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
- Shows only kills of the player in his feed
    - `dm_killfeed_filter_victim "1"` - show Feed to Dead Player
    - `dm_killfeed_filter_assister "0"`- show Feed to Assister Player
- Abolished
    - The system is disabled dominated/revenge/assister
    - Sound is disabled when the player kills someone and sound disabled death/spawn
    - Spawn chicken is disabled
    - Unnecessary messages are disabled to the chat

## Use
- Gamemode DeathMath `-game_mode 2 -game_type 1`
- Change the prefix to your in translate.phrases
- Config
    - CFG  
    ```
    mp_playerid 2 // Controls what information player see in the status bar: 0 all names; 1 team names; 2 no names
    mp_tdm_healthshot_killcount 0 // The damage threshold players have to exceed at the start of the round to be warned/kick.
    sv_disable_radar 1
    mp_dm_bonus_length_max 0 // Maximum time the bonus time will last (in seconds)
    mp_dm_bonus_length_min 0 // Minimum time the bonus time will last (in seconds)
    mp_dm_bonus_percent 0 // Percent of points additionally awarded when someone gets a kill with the bonus weapon during the bonus period.
    mp_dm_kill_base_score 0 // Number of base points to award for a kill in deathmatch. Cheaper weapons award 1 or 2 additional points.
    mp_dm_teammode 1 // In deathmatch, enables team DM visuals & scoring
    mp_dm_teammode_bonus_score 0 // Team deathmatch victory points to award for kill with bonus weapon
    mp_dm_teammode_dogtag_score 0 // Team deathmatch victory points to award for collecting enemy dogtags
    mp_dm_teammode_kill_score 0 // Team deathmatch victory points to award for enemy kill
    mp_dm_time_between_bonus_max 999 // Maximum time a bonus time will start after the round start or after the last bonus (in seconds)
    mp_dm_time_between_bonus_min 999 // Minimum time a bonus time will start after the round start or after the last bonus (in seconds)
    ```
    - Gamemode or exec
    ```
    mp_buy_during_immunity 0 // When set, players can buy when immune, ignoring buytime. 0 = default. 1 = both teams. 2 = Terrorists. 3 = Counter-Terrorists.
    mp_respawn_immunitytime 0 // How many seconds after respawn immunity lasts. Set to negative value to disable warmup immunity.
    mp_solid_teammates 1 // How solid are teammates: 0 = transparent; 1 = fully solid; 2 = can stand on top of heads
    spec_freeze_time "-0.5" // Time spend frozen in observer freeze cam.
    mp_buytime 99999999999 // How many seconds after round start players can buy items for.
    sv_infinite_ammo 2 // Player's active weapon will never run out of ammo. If set to 2 then player has infinite total ammo but still has to reload the
    mp_weapons_allow_zeus 0
    ammo_grenade_limit_total 0
    ammo_grenade_limit_default 0
    ammo_grenade_limit_flashbang 0
    ammo_item_limit_healthshot 0
    mp_ct_default_secondary ""
    mp_t_default_secondary ""
    mp_ct_default_primary ""
    mp_t_default_primary ""
    mp_items_prohibited "11,38" // block AutoSniper
    ```

## Thanks
[Grey83 (gunmenu)](https://github.com/Grey83/SourceMod-plugins/blob/master/SM/scripting/css_gunmenu.sp)  
[Alexey-Gamov (csgo-advanced-dm)](https://github.com/alexey-gamov/csgo-advanced-dm)