-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementlookattrigger.luac 

core:import("CoreMissionScriptElement")
if not ElementLookAtTrigger then
  ElementLookAtTrigger = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementLookAtTrigger.init = function(l_1_0, ...)
  ElementLookAtTrigger.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementLookAtTrigger.on_script_activated = function(l_2_0)
  l_2_0:add_callback()
end

ElementLookAtTrigger.set_enabled = function(l_3_0, l_3_1)
  ElementLookAtTrigger.super.set_enabled(l_3_0, l_3_1)
  if l_3_1 then
    l_3_0:add_callback()
  end
end

ElementLookAtTrigger.add_callback = function(l_4_0)
  if not l_4_0._callback then
    l_4_0._callback = l_4_0._mission_script:add(callback(l_4_0, l_4_0, "update_lookat"), l_4_0._values.interval)
  end
end

ElementLookAtTrigger.remove_callback = function(l_5_0)
  if l_5_0._callback then
    l_5_0._mission_script:remove(l_5_0._callback)
    l_5_0._callback = nil
  end
end

ElementLookAtTrigger.on_executed = function(l_6_0, l_6_1)
  if not l_6_0._values.enabled then
    return 
  end
  ElementLookAtTrigger.super.on_executed(l_6_0, l_6_1)
  if not l_6_0._values.enabled then
    l_6_0:remove_callback()
  end
end

ElementLookAtTrigger.update_lookat = function(l_7_0)
  if not l_7_0._values.enabled then
    return 
  end
  local player = managers.player:player_unit()
  if alive(player) then
    local dir = l_7_0._values.position - player:camera():position()
    if l_7_0._values.distance and l_7_0._values.distance > 0 then
      local distance = dir:length()
      if l_7_0._values.distance < distance then
        return 
      end
    end
    if l_7_0._values.in_front then
      local dot = player:camera():forward():dot(l_7_0._values.rotation:y())
      if dot > 0 then
        return 
      end
    end
    dir = dir:normalized()
    local dot = player:camera():forward():dot(dir)
    if l_7_0._values.sensitivity <= dot then
      if Network:is_client() then
        managers.network:session():send_to_host("to_server_mission_element_trigger", l_7_0._id, player)
      else
        l_7_0:on_executed(player)
      end
    end
  end
end


