-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\coreunitvisiblecutscenekey.luac 

require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")
if not CoreUnitVisibleCutsceneKey then
  CoreUnitVisibleCutsceneKey = class(CoreCutsceneKeyBase)
end
CoreUnitVisibleCutsceneKey.ELEMENT_NAME = "unit_visible"
CoreUnitVisibleCutsceneKey.NAME = "Unit Visibility"
CoreUnitVisibleCutsceneKey:register_serialized_attribute("unit_name", "")
CoreUnitVisibleCutsceneKey:register_serialized_attribute("visible", true, toboolean)
CoreUnitVisibleCutsceneKey.__tostring = function(l_1_0)
  return (l_1_0:visible() and "Show" or "Hide") .. " \"" .. l_1_0:unit_name() .. "\"."
end

CoreUnitVisibleCutsceneKey.unload = function(l_2_0)
  if l_2_0._cast then
    l_2_0:play(nil, true)
  end
end

CoreUnitVisibleCutsceneKey.play = function(l_3_0, l_3_1, l_3_2, l_3_3)
  assert(type(l_3_0.evaluate) == "function", "Cutscene key must define the \"evaluate\" method to use the default CoreCutsceneKeyBase:play method.")
  if l_3_2 then
    local preceeding_key = l_3_0:preceeding_key({unit_name = l_3_0:unit_name()})
    if preceeding_key then
      preceeding_key:evaluate(l_3_1, false)
    else
      l_3_0:evaluate(l_3_1, false, true)
    end
  else
    l_3_0:evaluate(l_3_1, l_3_3)
  end
end

CoreUnitVisibleCutsceneKey.evaluate = function(l_4_0, l_4_1, l_4_2, l_4_3)
  assert(l_4_0._cast)
  if not l_4_3 then
    l_4_3 = l_4_0:visible()
  end
  local cast_member = l_4_0._cast:unit(l_4_0:unit_name())
  if cast_member then
    l_4_0._cast:set_unit_visible(l_4_0:unit_name(), l_4_3)
  else
    local unit_in_world = l_4_0:_unit(l_4_0:unit_name(), true)
    if unit_in_world then
      set_unit_and_children_visible(unit_in_world, l_4_3)
    end
  end
end


