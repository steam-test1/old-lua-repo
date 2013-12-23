-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementcharacteroutline.luac 

core:import("CoreMissionScriptElement")
if not ElementCharacterOutline then
  ElementCharacterOutline = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementCharacterOutline.init = function(l_1_0, ...)
  ElementCharacterOutline.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementCharacterOutline.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementCharacterOutline.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  local all_civilians = managers.enemy:all_civilians()
  for u_key,u_data in pairs(all_civilians) do
    local data = u_data.unit:brain()._logic_data
    if data and not data.been_outlined and data.char_tweak.outline_on_discover then
      CivilianLogicIdle._enable_outline(data)
    end
  end
  ElementCharacterOutline.super.on_executed(l_3_0, l_3_1)
end


