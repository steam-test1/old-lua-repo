-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementactionmessage.luac 

core:import("CoreMissionScriptElement")
if not ElementActionMessage then
  ElementActionMessage = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementActionMessage.init = function(l_1_0, ...)
  ElementActionMessage.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementActionMessage.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementActionMessage.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if l_3_0._values.message_id ~= "none" and l_3_1 ~= managers.player:player_unit() then
    managers.action_messaging:show_message(l_3_0._values.message_id, l_3_1)
    do return end
    if Application:editor() then
      managers.editor:output_error("Cant show message " .. l_3_0._values.message_id .. " in element " .. l_3_0._editor_name .. ".")
    end
  end
  ElementActionMessage.super.on_executed(l_3_0, l_3_1)
end


