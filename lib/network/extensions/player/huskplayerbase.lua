-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\extensions\player\huskplayerbase.luac 

require("lib/units/enemies/cop/CopBase")
if not HuskPlayerBase then
  HuskPlayerBase = class(PlayerBase)
end
HuskPlayerBase.set_anim_lod = CopBase.set_anim_lod
HuskPlayerBase.set_visibility_state = CopBase.set_visibility_state
HuskPlayerBase._anim_lods = CopBase._anim_lods
HuskPlayerBase.init = function(l_1_0, l_1_1)
  UnitBase.init(l_1_0, l_1_1, false)
  l_1_0._unit = l_1_1
  l_1_0._upgrades = {}
  l_1_0._upgrade_levels = {}
  l_1_0:_setup_suspicion_and_detection_data()
end

HuskPlayerBase.post_init = function(l_2_0)
  l_2_0._unit:movement():post_init()
  managers.groupai:state():register_criminal(l_2_0._unit)
  managers.game_play_central:add_contour_unit(l_2_0._unit, "character")
  managers.occlusion:remove_occlusion(l_2_0._unit)
  l_2_0:set_anim_lod(1)
  l_2_0._lod_stage = 1
  l_2_0._allow_invisible = true
  local spawn_state = l_2_0._spawn_state or "std/stand/still/idle/look"
  l_2_0._unit:movement():play_state(spawn_state)
end

HuskPlayerBase.set_upgrade_value = function(l_3_0, l_3_1, l_3_2, l_3_3)
  if not l_3_0._upgrades[l_3_1] then
    l_3_0._upgrades[l_3_1] = {}
  end
  if not l_3_0._upgrade_levels[l_3_1] then
    l_3_0._upgrade_levels[l_3_1] = {}
  end
  local value = managers.player:upgrade_value_by_level(l_3_1, l_3_2, l_3_3)
  l_3_0._upgrades[l_3_1][l_3_2] = value
  l_3_0._upgrade_levels[l_3_1][l_3_2] = l_3_3
  if l_3_2 == "suspicion_multiplier" or l_3_2 == "passive_suspicion_multiplier" then
    l_3_0:set_suspicion_multiplier(l_3_2, value)
  elseif l_3_2 == "camouflage_bonus" then
    l_3_0:set_detection_multiplier(l_3_2, value)
  end
end

HuskPlayerBase.upgrade_value = function(l_4_0, l_4_1, l_4_2)
  if l_4_0._upgrades[l_4_1] then
    return l_4_0._upgrades[l_4_1][l_4_2]
  end
end

HuskPlayerBase.upgrade_level = function(l_5_0, l_5_1, l_5_2)
  if l_5_0._upgrade_levels[l_5_1] then
    return l_5_0._upgrade_levels[l_5_1][l_5_2]
  end
end

HuskPlayerBase.pre_destroy = function(l_6_0, l_6_1)
  managers.game_play_central:remove_contour_unit(l_6_1)
  l_6_0._unit:movement():pre_destroy(l_6_1)
  l_6_0._unit:inventory():pre_destroy(l_6_0._unit)
  managers.groupai:state():unregister_criminal(l_6_0._unit)
  if managers.network:game() then
    local member = managers.network:game():member_from_unit(l_6_0._unit)
    if member then
      member:set_unit(nil)
    end
  end
  UnitBase.pre_destroy(l_6_0, l_6_1)
end

HuskPlayerBase.nick_name = function(l_7_0)
  local member = managers.network:game():member_from_unit(l_7_0._unit)
  return member and member:peer():name() or ""
end

HuskPlayerBase.on_death_exit = function(l_8_0)
end

HuskPlayerBase.chk_freeze_anims = function(l_9_0)
end


