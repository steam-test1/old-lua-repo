-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementwaypoint.luac 

core:import("CoreMissionScriptElement")
if not ElementWaypoint then
  ElementWaypoint = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementWaypoint.init = function(l_1_0, ...)
  ElementWaypoint.super.init(l_1_0, ...)
  l_1_0._network_execute = true
  if l_1_0._values.icon == "guis/textures/waypoint2" or l_1_0._values.icon == "guis/textures/waypoint" then
    l_1_0._values.icon = "wp_standard"
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

ElementWaypoint.on_script_activated = function(l_2_0)
  l_2_0._mission_script:add_save_state_cb(l_2_0._id)
end

ElementWaypoint.client_on_executed = function(l_3_0, ...)
  l_3_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementWaypoint.on_executed = function(l_4_0, l_4_1)
  if not l_4_0._values.enabled then
    return 
  end
  local text = managers.localization:text(l_4_0._values.text_id)
  managers.hud:add_waypoint(l_4_0._id, {text = text, icon = l_4_0._values.icon, position = l_4_0._values.position, distance = true, present_timer = 0, state = "sneak_present"})
  ElementWaypoint.super.on_executed(l_4_0, l_4_1)
end

ElementWaypoint.operation_remove = function(l_5_0)
  managers.hud:remove_waypoint(l_5_0._id)
end

ElementWaypoint.save = function(l_6_0, l_6_1)
  l_6_1.enabled = l_6_0._values.enabled
end

ElementWaypoint.load = function(l_7_0, l_7_1)
  l_7_0:set_enabled(l_7_1.enabled)
end


