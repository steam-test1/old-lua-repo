-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementplayerspawner.luac 

core:import("CoreMissionScriptElement")
if not ElementPlayerSpawner then
  ElementPlayerSpawner = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementPlayerSpawner.init = function(l_1_0, ...)
  ElementPlayerSpawner.super.init(l_1_0, ...)
  managers.player:preload()
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementPlayerSpawner.value = function(l_2_0, l_2_1)
  return l_2_0._values[l_2_1]
end

ElementPlayerSpawner.client_on_executed = function(l_3_0, ...)
  if not l_3_0._values.enabled then
    return 
  end
  if not l_3_0._values.state then
    managers.player:set_player_state(managers.player:default_player_state())
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

ElementPlayerSpawner.on_executed = function(l_4_0, l_4_1)
  if not l_4_0._values.enabled then
    return 
  end
  if not l_4_0._values.state then
    managers.player:set_player_state(managers.player:default_player_state())
  end
  if not l_4_0._values.state then
    managers.groupai:state():on_player_spawn_state_set(managers.player:default_player_state())
  end
  managers.network:register_spawn_point(l_4_0._id, {position = l_4_0._values.position, rotation = l_4_0._values.rotation})
  ElementPlayerSpawner.super.on_executed(l_4_0, l_4_0._unit or l_4_1)
end


