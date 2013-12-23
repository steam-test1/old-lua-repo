-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementteammatecomment.luac 

core:import("CoreMissionScriptElement")
if not ElementTeammateComment then
  ElementTeammateComment = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementTeammateComment.init = function(l_1_0, ...)
  ElementTeammateComment.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementTeammateComment.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementTeammateComment.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  if l_3_0._values.radius == 0 or not l_3_0._values.radius then
    local radius = l_3_0._values.comment == "none" or nil
  end
  do
    local trigger_unit = l_3_0._values.use_instigator and l_3_1 or nil
    if trigger_unit and type(trigger_unit) ~= "userdata" then
      debug_pause("[ElementTeammateComment:on_executed] instigator is not a unit", l_3_1, trigger_unit)
      trigger_unit = nil
    end
    managers.groupai:state():teammate_comment(trigger_unit, l_3_0._values.comment, l_3_0._values.position, l_3_0._values.close_to_element, radius, false)
  end
  do return end
  if Application:editor() then
    managers.editor:output_error("Cant play comment " .. l_3_0._values.comment .. " in element " .. l_3_0._editor_name .. ".")
  end
  ElementTeammateComment.super.on_executed(l_3_0, l_3_1)
end


