-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementsetoutline.luac 

core:import("CoreMissionScriptElement")
if not ElementSetOutline then
  ElementSetOutline = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementSetOutline.init = function(l_1_0, ...)
  ElementSetOutline.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementSetOutline.client_on_executed = function(l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementSetOutline.sync_function = function(l_3_0, l_3_1)
  l_3_0:base():set_contour(l_3_1)
end

ElementSetOutline.on_executed = function(l_4_0, l_4_1)
  if not l_4_0._values.enabled then
    return 
  end
  local f = function(l_1_0)
    ElementSetOutline.sync_function(l_1_0, self._values.set_outline)
    managers.network:session():send_to_peers_synched("sync_set_outline", l_1_0, self._values.set_outline)
   end
  for _,id in ipairs(l_4_0._values.elements) do
    local element = l_4_0:get_mission_element(id)
    element:execute_on_all_units(f)
  end
  ElementSetOutline.super.on_executed(l_4_0, l_4_1)
end


