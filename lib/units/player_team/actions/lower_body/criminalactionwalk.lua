-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\player_team\actions\lower_body\criminalactionwalk.luac 

if not CriminalActionWalk then
  CriminalActionWalk = class(CopActionWalk)
end
local l_0_0 = CriminalActionWalk
local l_0_1 = {}
local l_0_2 = {}
l_0_2.idle = -1
l_0_2.action = -1
l_0_2.walk = -1
l_0_2.crouch = -1
l_0_2.stand = -1
l_0_2.dodge = -1
l_0_2.shoot = -1
l_0_2.turn = -1
l_0_2.light_hurt = -1
l_0_2.hurt = -1
l_0_2.heavy_hurt = -1
l_0_2.act = -1
l_0_2.death = -1
l_0_1.block_all = l_0_2
l_0_2 = {idle = -1, walk = -1, crouch = -1, stand = -1, dodge = -1, turn = -1}
l_0_2.light_hurt = -1
l_0_2.hurt = -1
l_0_2.heavy_hurt = -1
l_0_2.act = -1
l_0_2.death = -1
l_0_1.block_lower = l_0_2
l_0_2 = {shoot = -1, action = -1, stand = -1, crouch = -1}
l_0_1.block_upper = l_0_2
l_0_2 = {stand = -1, crouch = -1}
l_0_1.block_none = l_0_2
l_0_0._anim_block_presets = l_0_1
l_0_0 = CriminalActionWalk
l_0_1 = HuskPlayerMovement
l_0_1 = l_0_1._walk_anim_velocities
l_0_0._walk_anim_velocities = l_0_1
l_0_0 = CriminalActionWalk
l_0_1 = HuskPlayerMovement
l_0_1 = l_0_1._walk_anim_lengths
l_0_0._walk_anim_lengths = l_0_1

