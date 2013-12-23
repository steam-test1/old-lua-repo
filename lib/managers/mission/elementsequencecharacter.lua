-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementsequencecharacter.luac 

core:import("CoreMissionScriptElement")
if not ElementSequenceCharacter then
  ElementSequenceCharacter = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementSequenceCharacter.init = function(l_1_0, ...)
  ElementSequenceCharacter.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementSequenceCharacter.client_on_executed = function(l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementSequenceCharacter.sync_function = function(l_3_0, l_3_1)
  if alive(l_3_0) and l_3_0:damage() then
    l_3_0:damage():run_sequence_simple(l_3_1)
  end
end

ElementSequenceCharacter.on_executed = function(l_4_0, l_4_1)
  if not l_4_0._values.enabled then
    return 
  end
  local f = function(l_1_0)
    ElementSequenceCharacter.sync_function(l_1_0, self._values.sequence)
    managers.network:session():send_to_peers_synched("sync_run_sequence_char", l_1_0, self._values.sequence)
   end
  for _,id in ipairs(l_4_0._values.elements) do
    local element = l_4_0:get_mission_element(id)
    element:execute_on_all_units(f)
  end
  ElementSequenceCharacter.super.on_executed(l_4_0, l_4_1)
end


