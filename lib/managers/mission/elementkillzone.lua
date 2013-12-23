-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementkillzone.luac 

core:import("CoreMissionScriptElement")
if not ElementKillZone then
  ElementKillZone = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementKillZone.init = function(l_1_0, ...)
  ElementKillZone.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementKillZone.on_executed = function(l_2_0, l_2_1)
  if not l_2_0._values.enabled then
    return 
  end
  if not l_2_0._values.type then
    l_2_0._values.type = not alive(l_2_1) or "sniper"
  end
  if l_2_1 == managers.player:player_unit() then
    managers.killzone:set_unit(l_2_1, l_2_0._values.type)
  else
    local rpc_params = {"killzone_set_unit", l_2_0._values.type}
    l_2_1:network():send_to_unit(rpc_params)
  end
  ElementKillZone.super.on_executed(l_2_0, l_2_0._unit or l_2_1)
end


