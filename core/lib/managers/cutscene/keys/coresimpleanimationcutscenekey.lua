-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\coresimpleanimationcutscenekey.luac 

require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")
if not CoreSimpleAnimationCutsceneKey then
  CoreSimpleAnimationCutsceneKey = class(CoreCutsceneKeyBase)
end
CoreSimpleAnimationCutsceneKey.ELEMENT_NAME = "simple_animation"
CoreSimpleAnimationCutsceneKey.NAME = "Simple Animation"
CoreSimpleAnimationCutsceneKey:register_serialized_attribute("unit_name", "")
CoreSimpleAnimationCutsceneKey:register_serialized_attribute("group", "")
CoreSimpleAnimationCutsceneKey:attribute_affects("unit_name", "group")
CoreSimpleAnimationCutsceneKey.control_for_group = CoreCutsceneKeyBase.standard_combo_box_control
CoreSimpleAnimationCutsceneKey.__tostring = function(l_1_0)
  return "Trigger simple animation \"" .. l_1_0:group() .. "\" on \"" .. l_1_0:unit_name() .. "\"."
end

CoreSimpleAnimationCutsceneKey.skip = function(l_2_0, l_2_1)
  local unit = l_2_0:_unit(l_2_0:unit_name())
  local group = l_2_0:group()
  unit:anim_play(group, 0)
  unit:anim_set_time(group, unit:anim_length(group))
end

CoreSimpleAnimationCutsceneKey.evaluate = function(l_3_0, l_3_1, l_3_2)
  l_3_0:_unit(l_3_0:unit_name()):anim_play(l_3_0:group(), 0)
end

CoreSimpleAnimationCutsceneKey.revert = function(l_4_0, l_4_1)
  local unit = l_4_0:_unit(l_4_0:unit_name())
  local group = l_4_0:group()
  if unit:anim_is_playing(group) then
    unit:anim_set_time(group, 0)
    unit:anim_stop(group)
  end
end

CoreSimpleAnimationCutsceneKey.update = function(l_5_0, l_5_1, l_5_2)
  l_5_0:_unit(l_5_0:unit_name()):anim_set_time(l_5_0:group(), l_5_2)
end

CoreSimpleAnimationCutsceneKey.is_valid_unit_name = function(l_6_0, l_6_1)
  return not l_6_0.super.is_valid_unit_name(l_6_0, l_6_1) or #l_6_0:_unit_animation_groups(l_6_1) > 0
end

CoreSimpleAnimationCutsceneKey.is_valid_group = function(l_7_0, l_7_1)
  return table.contains(l_7_0:_unit_animation_groups(l_7_0:unit_name()), l_7_1)
end

CoreSimpleAnimationCutsceneKey.refresh_control_for_group = function(l_8_0, l_8_1)
  l_8_1:freeze()
  l_8_1:clear()
  local groups = l_8_0:_unit_animation_groups(l_8_0:unit_name())
  if not table.empty(groups) then
    l_8_1:set_enabled(true)
    local value = l_8_0:group()
    for _,group in ipairs(groups) do
      l_8_1:append(group)
      if group == value then
        l_8_1:set_value(group)
      end
    end
  else
    l_8_1:set_enabled(false)
  end
  l_8_1:thaw()
end


