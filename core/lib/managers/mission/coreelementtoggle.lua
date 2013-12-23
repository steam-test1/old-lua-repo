-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\mission\coreelementtoggle.luac 

core:module("CoreElementToggle")
core:import("CoreMissionScriptElement")
if not ElementToggle then
  ElementToggle = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementToggle.init = function(l_1_0, ...)
  ElementToggle.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementToggle.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementToggle.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  for _,id in ipairs(l_3_0._values.elements) do
    local element = l_3_0:get_mission_element(id)
    if element then
      if l_3_0._values.toggle == "on" then
        element:set_enabled(true)
        if l_3_0._values.set_trigger_times and l_3_0._values.set_trigger_times > -1 then
          element:set_trigger_times(l_3_0._values.set_trigger_times)
        else
          if l_3_0._values.toggle == "off" then
            element:set_enabled(false)
          else
            element:set_enabled(not element:value("enabled"))
          end
        end
      end
      element:on_toggle(element:value("enabled"))
    end
  end
  ElementToggle.super.on_executed(l_3_0, l_3_1)
end


