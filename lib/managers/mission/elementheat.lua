-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementheat.luac 

core:import("CoreMissionScriptElement")
if not ElementHeat then
  ElementHeat = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementHeat.init = function(l_1_0, ...)
  ElementHeat.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementHeat.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementHeat.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  if Network:is_server() then
    if l_3_0._values.level ~= 0 then
      managers.groupai:state():force_up_heat_level(l_3_0._values.level)
  if l_3_0._values.points ~= 0 then
    end
  end
  ElementHeat.super.on_executed(l_3_0, l_3_1)
end

if not ElementHeatTrigger then
  ElementHeatTrigger = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementHeatTrigger.init = function(l_4_0, ...)
  ElementHeatTrigger.super.init(l_4_0, ...)
  if Network:is_server() then
    l_4_0:add_callback()
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

ElementHeatTrigger.add_callback = function(l_5_0)
end

ElementHeatTrigger.remove_callback = function(l_6_0)
end

ElementHeatTrigger.heat_changed = function(l_7_0)
  if Network:is_client() then
    return 
  end
end

ElementHeatTrigger.on_executed = function(l_8_0, l_8_1)
  if not l_8_0._values.enabled then
    return 
  end
  l_8_1 = managers.player:player_unit()
  ElementHeatTrigger.super.on_executed(l_8_0, l_8_1)
  if not l_8_0._values.enabled then
    l_8_0:remove_callback()
  end
end


