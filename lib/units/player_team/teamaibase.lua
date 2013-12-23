-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\player_team\teamaibase.luac 

if not TeamAIBase then
  TeamAIBase = class(CopBase)
end
TeamAIBase.post_init = function(l_1_0)
  l_1_0._ext_movement = l_1_0._unit:movement()
  l_1_0._ext_movement:post_init(true)
  l_1_0._unit:brain():post_init()
  l_1_0:set_anim_lod(1)
  l_1_0._lod_stage = 1
  l_1_0._allow_invisible = true
  l_1_0:_register()
  managers.game_play_central:add_contour_unit(l_1_0._unit, "character")
  managers.occlusion:remove_occlusion(l_1_0._unit)
end

TeamAIBase.nick_name = function(l_2_0)
  local name = l_2_0._tweak_table
  return managers.localization:text("menu_" .. name)
end

TeamAIBase.default_weapon_name = function(l_3_0, l_3_1)
  return tweak_data.character[l_3_0._tweak_table].weapon.weapons_of_choice[l_3_1 or "primary"]
end

TeamAIBase.arrest_settings = function(l_4_0)
  return tweak_data.character[l_4_0._tweak_table].arrest
end

TeamAIBase.pre_destroy = function(l_5_0, l_5_1)
  managers.game_play_central:remove_contour_unit(l_5_1)
  l_5_0:unregister()
  UnitBase.pre_destroy(l_5_0, l_5_1)
  l_5_1:brain():pre_destroy(l_5_1)
  l_5_1:movement():pre_destroy()
  l_5_1:inventory():pre_destroy(l_5_1)
  l_5_1:character_damage():pre_destroy()
end

TeamAIBase.save = function(l_6_0, l_6_1)
  l_6_1.base = {tweak_table = l_6_0._tweak_table}
end

TeamAIBase.on_death_exit = function(l_7_0)
  TeamAIBase.super.on_death_exit(l_7_0)
  l_7_0:unregister()
  l_7_0:set_slot(l_7_0._unit, 0)
end

TeamAIBase._register = function(l_8_0)
  if not l_8_0._registered then
    managers.groupai:state():register_criminal(l_8_0._unit)
    l_8_0._registered = true
  end
end

TeamAIBase.unregister = function(l_9_0)
  if l_9_0._registered then
    if Network:is_server() then
      l_9_0._unit:brain():attention_handler():set_attention(nil)
    end
    if managers.groupai:state():all_AI_criminals()[l_9_0._unit:key()] then
      managers.groupai:state():unregister_criminal(l_9_0._unit)
    end
    l_9_0._char_name = managers.criminals:character_name_by_unit(l_9_0._unit)
    l_9_0._registered = nil
  end
end

TeamAIBase.chk_freeze_anims = function(l_10_0)
end


