-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementsmokegrenade.luac 

core:import("CoreMissionScriptElement")
if not ElementSmokeGrenade then
  ElementSmokeGrenade = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementSmokeGrenade.init = function(l_1_0, ...)
  ElementSmokeGrenade.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementSmokeGrenade.client_on_executed = function(l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementSmokeGrenade.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  local is_flashbang = l_3_0._values.effect_type == "flash"
  if l_3_0._values.immediate and (managers.groupai:state():get_assault_mode() or l_3_0._values.ignore_control) then
    managers.network:session():send_to_peers("sync_smoke_grenade_kill")
    managers.groupai:state():sync_smoke_grenade_kill()
    do
      local pos = l_3_0._values.position
      managers.network:session():send_to_peers("sync_smoke_grenade", pos, pos, l_3_0._values.duration, is_flashbang)
      managers.groupai:state():sync_smoke_grenade(pos, pos, l_3_0._values.duration, is_flashbang)
      managers.groupai:state()._smoke_grenade_ignore_control = l_3_0._values.ignore_control
    end
    do return end
    managers.groupai:state()._smoke_grenade_queued = {l_3_0._values.position, l_3_0._values.duration, l_3_0._values.ignore_control, is_flashbang}
  end
  print(is_flashbang and "FLAAAASHBAAAAANG" or "SMOOOOOOOKEEEEEEEE")
  ElementSmokeGrenade.super.on_executed(l_3_0, l_3_1)
end


