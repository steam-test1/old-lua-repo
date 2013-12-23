-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementdangerzone.luac 

core:import("CoreMissionScriptElement")
if not ElementDangerZone then
  ElementDangerZone = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementDangerZone.init = function(l_1_0, ...)
  ElementDangerZone.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementDangerZone.on_executed = function(l_2_0, l_2_1)
  if not l_2_0._values.enabled then
    return 
  end
  if alive(l_2_1) then
    if l_2_1 == managers.player:player_unit() then
      l_2_1:character_damage():set_danger_level(l_2_0._values.level)
    else
      local rpc_params = {"dangerzone_set_level", l_2_0._values.level}
      l_2_1:network():send_to_unit(rpc_params)
    end
  end
  ElementDangerZone.super.on_executed(l_2_0, l_2_0._unit or l_2_1)
end


