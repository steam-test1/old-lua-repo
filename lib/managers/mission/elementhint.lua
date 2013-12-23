-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementhint.luac 

core:import("CoreMissionScriptElement")
if not ElementHint then
  ElementHint = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementHint.init = function(l_1_0, ...)
  ElementHint.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementHint.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementHint.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  if l_3_0._values.hint_id ~= "none" then
    managers.hint:show_hint(l_3_0._values.hint_id)
  else
    if Application:editor() then
      managers.editor:output_error("Cant show hint " .. l_3_0._values.hint_id .. " in element " .. l_3_0._editor_name .. ".")
    end
  end
  ElementHint.super.on_executed(l_3_0, l_3_1)
end


