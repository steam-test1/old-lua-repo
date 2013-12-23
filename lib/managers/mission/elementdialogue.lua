-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementdialogue.luac 

core:import("CoreMissionScriptElement")
if not ElementDialogue then
  ElementDialogue = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementDialogue.init = function(l_1_0, ...)
  ElementDialogue.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementDialogue.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementDialogue.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  if l_3_0._values.dialogue ~= "none" then
    managers.dialog:queue_dialog(l_3_0._values.dialogue, {case = managers.criminals:character_name_by_unit(l_3_1)})
  else
    if Application:editor() then
      managers.editor:output_error("Cant start dialogue " .. l_3_0._values.dialogue .. " in element " .. l_3_0._editor_name .. ".")
    end
  end
  ElementDialogue.super.on_executed(l_3_0, l_3_1)
end


