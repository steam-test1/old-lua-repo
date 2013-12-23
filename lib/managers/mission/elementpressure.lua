-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementpressure.luac 

core:import("CoreMissionScriptElement")
if not ElementPressure then
  ElementPressure = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementPressure.init = function(l_1_0, ...)
  ElementPressure.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementPressure.client_on_executed = function(l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementPressure.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  if l_3_0._values.points ~= 0 then
    if l_3_0._values.points > 0 then
      managers.groupai:state():add_pressure(l_3_0._values.points)
    else
      managers.groupai:state():add_cooldown(math.abs(l_3_0._values.points))
    end
  else
    local interval = (l_3_0._values.interval ~= 0 and l_3_0._values.interval)
    managers.groupai:state():set_heat_build_period(interval)
  end
  ElementPressure.super.on_executed(l_3_0, l_3_1)
end


