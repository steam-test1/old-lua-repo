-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementplayernumbercheck.luac 

core:import("CoreMissionScriptElement")
if not ElementPlayerNumberCheck then
  ElementPlayerNumberCheck = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementPlayerNumberCheck.init = function(l_1_0, ...)
  ElementPlayerNumberCheck.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementPlayerNumberCheck.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementPlayerNumberCheck.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  local num_plrs = managers.network:game():amount_of_members()
  if not l_3_0._values.num" .. num_plr then
    return 
  end
  ElementPlayerNumberCheck.super.on_executed(l_3_0, l_3_1)
end


