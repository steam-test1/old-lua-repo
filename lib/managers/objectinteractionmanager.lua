-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\objectinteractionmanager.luac 

if not ObjectInteractionManager then
  ObjectInteractionManager = class()
end
ObjectInteractionManager.FRAMES_TO_COMPLETE = 15
ObjectInteractionManager.init = function(l_1_0)
  l_1_0._interactive_objects = {}
  l_1_0._interactive_count = 0
  l_1_0._update_index = 0
  l_1_0._close_objects = {}
  l_1_0._close_index = 0
  l_1_0._close_freq = 1
  l_1_0._active_object = nil
end

ObjectInteractionManager.update = function(l_2_0, l_2_1, l_2_2)
  local player_unit = managers.player:player_unit()
  if l_2_0._interactive_count > 0 and alive(player_unit) then
    local player_pos = player_unit:movement():m_head_pos()
    l_2_0:_update_targeted(player_pos, player_unit)
  end
end

ObjectInteractionManager.interact = function(l_3_0, l_3_1)
  if alive(l_3_0._active_object) then
    local interacted, timer = l_3_0._active_object:interaction():interact_start(l_3_1)
    if timer then
      l_3_0._active_object_locked_data = true
    end
    return not interacted and ((interacted ~= nil and false)), timer, l_3_0._active_object
  end
  return false
end

ObjectInteractionManager.end_action_interact = function(l_4_0, l_4_1)
  l_4_0._active_object_locked_data = nil
  if alive(l_4_0._active_object) then
    l_4_0._active_object:interaction():interact(l_4_1)
  end
end

ObjectInteractionManager.interupt_action_interact = function(l_5_0)
  l_5_0._active_object_locked_data = nil
end

ObjectInteractionManager.active_object = function(l_6_0)
  return l_6_0._active_object
end

ObjectInteractionManager.add_object = function(l_7_0, l_7_1)
  table.insert(l_7_0._interactive_objects, l_7_1)
  l_7_0._interactive_count = l_7_0._interactive_count + 1
  l_7_0._close_freq = math.max(1, math.floor(#l_7_0._interactive_objects / l_7_0.FRAMES_TO_COMPLETE))
end

ObjectInteractionManager.remove_object = function(l_8_0, l_8_1)
  for k,v in pairs(l_8_0._interactive_objects) do
    if v == l_8_1 then
      table.remove(l_8_0._interactive_objects, k)
      l_8_0._interactive_count = l_8_0._interactive_count - 1
      l_8_0._close_freq = math.max(1, math.floor(#l_8_0._interactive_objects / l_8_0.FRAMES_TO_COMPLETE))
      if l_8_0._interactive_count == 0 then
        l_8_0._close_objects = {}
        if alive(l_8_0._active_object) then
          l_8_0._active_object:interaction():remove_interact()
        end
        l_8_0._active_object = nil
      end
      return 
    end
  end
end

local mvec1 = Vector3()
ObjectInteractionManager._update_targeted = function(l_9_0, l_9_1, l_9_2)
  local mvec3_dis = mvector3.distance
  if #l_9_0._close_objects > 0 then
    for k,v in pairs(l_9_0._close_objects) do
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if alive(v) and v:interaction():active() and v:interaction():interact_distance() < mvec3_dis(l_9_1, v:interaction():interact_position()) then
        table.remove(l_9_0._close_objects, k)
        for (for control),k in (for generator) do
          table.remove(l_9_0._close_objects, k)
        end
      end
    end
    for i = 1, l_9_0._close_freq do
      if l_9_0._interactive_count <= l_9_0._close_index then
        l_9_0._close_index = 1
      else
        l_9_0._close_index = l_9_0._close_index + 1
      end
      local obj = l_9_0._interactive_objects[l_9_0._close_index]
      if alive(obj) and obj:interaction():active() and not l_9_0:_in_close_list(obj) and mvec3_dis(l_9_1, obj:interaction():interact_position()) <= obj:interaction():interact_distance() then
        table.insert(l_9_0._close_objects, obj)
      end
    end
    local locked = false
    if l_9_0._active_object_locked_data then
      if not alive(l_9_0._active_object) or not l_9_0._active_object:interaction():active() then
        l_9_0._active_object_locked_data = nil
      else
        locked = mvec3_dis(l_9_1, l_9_0._active_object:interaction():interact_position()) <= l_9_0._active_object:interaction():interact_distance()
      end
      if locked then
        return 
      end
      local last_active = l_9_0._active_object
      local blocked = l_9_2:movement():object_interaction_blocked()
      if #l_9_0._close_objects > 0 and not blocked then
        local active_obj = nil
        local current_dot = 0.89999997615814
        local player_fwd = l_9_2:camera():forward()
        local camera_pos = l_9_2:camera():position()
        for k,v in pairs(l_9_0._close_objects) do
          if alive(v) then
            mvector3.set(mvec1, v:interaction():interact_position())
            mvector3.subtract(mvec1, camera_pos)
            mvector3.normalize(mvec1)
            local dot = mvector3.dot(player_fwd, mvec1)
            if current_dot < dot then
              local interact_axis = v:interaction():interact_axis()
              if not interact_axis or mvector3.dot(mvec1, interact_axis) < 0 then
                current_dot = dot
                active_obj = v
              end
            end
          end
        end
        if active_obj and l_9_0._active_object ~= active_obj then
          if alive(l_9_0._active_object) then
            l_9_0._active_object:interaction():unselect()
          end
          if not active_obj:interaction():selected(l_9_2) then
            active_obj = nil
          end
        end
        l_9_0._active_object = active_obj
      else
        l_9_0._active_object = nil
      end
      if alive(last_active) and not l_9_0._active_object then
        l_9_0._active_object = nil
        last_active:interaction():unselect()
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ObjectInteractionManager._in_close_list = function(l_10_0, l_10_1)
  if #l_10_0._close_objects > 0 then
    for k,v in pairs(l_10_0._close_objects) do
      if v == l_10_1 then
        return true
      end
    end
  end
  return false
end


