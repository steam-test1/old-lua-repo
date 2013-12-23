-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\extensions\player_team\huskteamaibase.luac 

if not HuskTeamAIBase then
  HuskTeamAIBase = class(HuskCopBase)
end
HuskTeamAIBase.default_weapon_name = function(l_1_0)
  return TeamAIBase.default_weapon_name(l_1_0)
end

HuskTeamAIBase.post_init = function(l_2_0)
  l_2_0._unit:movement():post_init()
  l_2_0:set_anim_lod(1)
  l_2_0._lod_stage = 1
  l_2_0._allow_invisible = true
  TeamAIBase._register(l_2_0)
  managers.game_play_central:add_contour_unit(l_2_0._unit, "character")
  managers.occlusion:remove_occlusion(l_2_0._unit)
end

HuskTeamAIBase.nick_name = function(l_3_0)
  return TeamAIBase.nick_name(l_3_0)
end

HuskTeamAIBase.on_death_exit = function(l_4_0)
  HuskTeamAIBase.super.on_death_exit(l_4_0)
  TeamAIBase.unregister(l_4_0)
  l_4_0:set_slot(l_4_0._unit, 0)
end

HuskTeamAIBase.pre_destroy = function(l_5_0, l_5_1)
  managers.game_play_central:remove_contour_unit(l_5_1)
  l_5_1:movement():pre_destroy()
  l_5_1:inventory():pre_destroy(l_5_1)
  TeamAIBase.unregister(l_5_0)
  UnitBase.pre_destroy(l_5_0, l_5_1)
end

HuskTeamAIBase.load = function(l_6_0, l_6_1)
  if not l_6_1.base.tweak_table then
    l_6_0._tweak_table = l_6_0._tweak_table
  end
  local character_name = l_6_0._tweak_table
  if character_name then
    local old_unit = managers.criminals:character_unit_by_name(character_name)
    if old_unit then
      local member = managers.network:game():member_from_unit(old_unit)
      if member then
        managers.network:session():on_peer_lost(member:peer(), member:peer():id())
      end
    end
    managers.criminals:add_character(character_name, l_6_0._unit, nil, true)
    l_6_0._unit:movement():set_character_anim_variables()
  end
end

HuskTeamAIBase.chk_freeze_anims = function(l_7_0)
end

HuskTeamAIBase.unregister = function(l_8_0)
  TeamAIBase.unregister(l_8_0)
end


