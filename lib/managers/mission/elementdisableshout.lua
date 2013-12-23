-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementdisableshout.luac 

core:import("CoreMissionScriptElement")
if not ElementDisableShout then
  ElementDisableShout = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementDisableShout.init = function(l_1_0, ...)
  ElementDisableShout.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementDisableShout.client_on_executed = function(l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementDisableShout.sync_function = function(l_3_0, l_3_1)
  l_3_0:unit_data().disable_shout = l_3_1
end

ElementDisableShout.on_executed = function(l_4_0, l_4_1)
  if not l_4_0._values.enabled then
    return 
  end
  local f = function(l_1_0)
    ElementDisableShout.sync_function(l_1_0, self._values.disable_shout)
    managers.network:session():send_to_peers_synched("sync_disable_shout", l_1_0, self._values.disable_shout)
   end
  for _,id in ipairs(l_4_0._values.elements) do
    local element = l_4_0:get_mission_element(id)
    element:execute_on_all_units(f)
  end
  ElementDisableShout.super.on_executed(l_4_0, l_4_1)
end


