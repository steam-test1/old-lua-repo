-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementmoney.luac 

core:import("CoreMissionScriptElement")
if not ElementMoney then
  ElementMoney = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementMoney.init = function(l_1_0, ...)
  ElementMoney.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementMoney.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementMoney.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  if l_3_0._values.action ~= "none" then
    do return end
  end
  if Application:editor() then
    managers.editor:output_error("Cant perform money action " .. l_3_0._values.action .. " in element " .. l_3_0._editor_name .. ".")
  end
  ElementMoney.super.on_executed(l_3_0, l_3_1)
end


