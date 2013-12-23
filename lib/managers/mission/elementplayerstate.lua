-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementplayerstate.luac 

core:import("CoreMissionScriptElement")
if not ElementPlayerState then
  ElementPlayerState = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementPlayerState.init = function(l_1_0, ...)
  ElementPlayerState.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementPlayerState.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementPlayerState.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  local state = l_3_0._values.state
  local player_unit = managers.player:player_unit()
  local requires_alive_player = false
  if l_3_0._values.state == "electrocution" then
    state = "tased"
    requires_alive_player = true
    if alive(player_unit) then
      player_unit:movement():on_non_lethal_electrocution()
    end
  end
  if (not l_3_0._values.use_instigator or l_3_1 == player_unit) and (not requires_alive_player or alive(player_unit)) then
    if l_3_0._values.state ~= "none" then
      managers.player:set_player_state(state)
    else
      if Application:editor() then
        managers.editor:output_error("Cant change to player state " .. state .. " in element " .. l_3_0._editor_name .. ".")
      end
    end
  end
  ElementPlayerState.super.on_executed(l_3_0, l_3_0._unit or l_3_1)
end

if not ElementPlayerStateTrigger then
  ElementPlayerStateTrigger = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementPlayerStateTrigger.init = function(l_4_0, ...)
  ElementPlayerStateTrigger.super.init(l_4_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementPlayerStateTrigger.on_script_activated = function(l_5_0)
  managers.player:add_listener(l_5_0._id, {l_5_0._values.state}, callback(l_5_0, l_5_0, Network:is_client() and "send_to_host" or "on_executed"))
end

ElementPlayerStateTrigger.send_to_host = function(l_6_0, l_6_1)
  if l_6_1 then
    managers.network:session():send_to_host("to_server_mission_element_trigger", l_6_0._id, l_6_1)
  end
end

ElementPlayerStateTrigger.on_executed = function(l_7_0, l_7_1)
  if not l_7_0._values.enabled then
    return 
  end
  ElementPlayerStateTrigger.super.on_executed(l_7_0, l_7_0._unit or l_7_1)
end


