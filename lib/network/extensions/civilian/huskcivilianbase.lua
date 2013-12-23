-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\extensions\civilian\huskcivilianbase.luac 

local ids_lod = Idstring("lod")
local ids_lod1 = Idstring("lod1")
local ids_ik_aim = Idstring("ik_aim")
if not HuskCivilianBase then
  HuskCivilianBase = class(HuskCopBase)
end
HuskCivilianBase.post_init = function(l_1_0)
  l_1_0._ext_movement = l_1_0._unit:movement()
  l_1_0._unit:brain():post_init()
  l_1_0:set_anim_lod(1)
  l_1_0._lod_stage = 1
  l_1_0._allow_invisible = true
  local spawn_state = l_1_0._spawn_state or "civilian/idle/group_1/blend_1/1"
  l_1_0._ext_movement:play_state(spawn_state)
  l_1_0._ext_movement:post_init()
  managers.enemy:register_civilian(l_1_0._unit)
end

HuskCivilianBase.default_weapon_name = function(l_2_0)
end


