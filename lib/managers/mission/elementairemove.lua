-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementairemove.luac 

core:import("CoreMissionScriptElement")
if not ElementAIRemove then
  ElementAIRemove = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementAIRemove.init = function(l_1_0, ...)
  ElementAIRemove.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementAIRemove.on_executed = function(l_2_0, l_2_1)
  if not l_2_0._values.enabled then
    return 
  end
  if l_2_0._values.use_instigator then
    if l_2_0._values.true_death then
      l_2_1:character_damage():damage_mission({damage = 1000})
    else
      l_2_1:brain():set_active(false)
      l_2_1:base():set_slot(l_2_1, 0)
    end
  else
    for _,id in ipairs(l_2_0._values.elements) do
      local element = l_2_0:get_mission_element(id)
      if l_2_0._values.true_death then
        element:kill_all_units()
        for (for control),_ in (for generator) do
        end
        element:unspawn_all_units()
      end
    end
  end
  ElementAIRemove.super.on_executed(l_2_0, l_2_1)
end


