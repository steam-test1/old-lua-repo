-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\coreenvironmentareamanager.luac 

core:module("CoreEnvironmentAreaManager")
core:import("CoreShapeManager")
if not EnvironmentAreaManager then
  EnvironmentAreaManager = class()
end
EnvironmentAreaManager.init = function(l_1_0)
  l_1_0._areas = {}
  l_1_0._current_area = nil
  l_1_0._area_iterator = 1
  l_1_0._areas_per_frame = 1
  l_1_0._blocks = 0
  l_1_0.GAME_DEFAULT_ENVIRONMENT = "core/environments/default"
  l_1_0._default_environment = l_1_0.GAME_DEFAULT_ENVIRONMENT
  l_1_0._current_environment = l_1_0.GAME_DEFAULT_ENVIRONMENT
  for _,vp in ipairs(managers.viewport:viewports()) do
    l_1_0:_set_environment(l_1_0.GAME_DEFAULT_ENVIRONMENT, 0, vp)
  end
  l_1_0._environment_changed_callback = {}
  l_1_0:set_default_transition_time(0.10000000149012)
  l_1_0.POSITION_OFFSET = 50
end

EnvironmentAreaManager.set_default_transition_time = function(l_2_0, l_2_1)
  l_2_0._default_transition_time = l_2_1
end

EnvironmentAreaManager.default_transition_time = function(l_3_0)
  return l_3_0._default_transition_time
end

EnvironmentAreaManager.areas = function(l_4_0)
  return l_4_0._areas
end

EnvironmentAreaManager.game_default_environment = function(l_5_0)
  return l_5_0.GAME_DEFAULT_ENVIRONMENT
end

EnvironmentAreaManager.default_environment = function(l_6_0)
  return l_6_0._default_environment
end

EnvironmentAreaManager.set_default_environment = function(l_7_0, l_7_1, l_7_2, l_7_3)
  l_7_0._default_environment = l_7_1
  if not l_7_0._current_area then
    if not l_7_3 then
      for _,viewport in ipairs(managers.viewport:viewports()) do
        l_7_0:_set_environment(l_7_0._default_environment, l_7_2, viewport)
      end
    else
      l_7_0:_set_environment(l_7_0._default_environment, l_7_2, l_7_3)
    end
  end
end

EnvironmentAreaManager.set_to_current_environment = function(l_8_0, l_8_1)
  l_8_0:_set_environment(l_8_0._current_environment, nil, l_8_1)
end

EnvironmentAreaManager._set_environment = function(l_9_0, l_9_1, l_9_2, l_9_3)
  l_9_0._current_environment = l_9_1
  l_9_3:set_environment(l_9_1, l_9_2)
end

EnvironmentAreaManager.current_environment = function(l_10_0)
  return l_10_0._current_environment
end

EnvironmentAreaManager.set_to_default = function(l_11_0)
  local vps = managers.viewport:active_viewports()
  for _,vp in ipairs(vps) do
    l_11_0:set_default_environment(l_11_0.GAME_DEFAULT_ENVIRONMENT, nil, vp)
  end
end

EnvironmentAreaManager.add_area = function(l_12_0, l_12_1)
  local area = EnvironmentArea:new(l_12_1)
  table.insert(l_12_0._areas, area)
  return area
end

EnvironmentAreaManager.remove_area = function(l_13_0, l_13_1)
  if l_13_1 == l_13_0._current_area then
    l_13_0:_leave_current_area(l_13_0._current_area:transition_time())
  end
  table.delete(l_13_0._areas, l_13_1)
  l_13_0._area_iterator = 1
end

local mvec1 = Vector3()
local mvec2 = Vector3()
EnvironmentAreaManager.update = function(l_14_0, l_14_1, l_14_2)
  local vps = managers.viewport:active_viewports()
  for _,vp in ipairs(vps) do
    local camera = vp:camera()
    if not camera then
      return 
    end
    if l_14_0._blocks > 0 then
      return 
    end
    local check_pos = mvec1
    local c_fwd = mvec2
    camera:m_position(check_pos)
    mrotation.y(camera:rotation(), c_fwd)
    mvector3.multiply(c_fwd, l_14_0.POSITION_OFFSET)
    mvector3.add(check_pos, c_fwd)
    local still_inside = nil
    if l_14_0._current_area then
      still_inside = l_14_0._current_area:still_inside(check_pos)
      if still_inside then
        return 
      end
      local transition_time = l_14_0._current_area:transition_time()
      l_14_0._current_area = nil
      l_14_0:_check_inside(check_pos, vp)
      if l_14_0._current_area then
        return 
      end
      l_14_0:_leave_current_area(transition_time, vp)
    end
    l_14_0:_check_inside(check_pos, vp)
  end
end

EnvironmentAreaManager._check_inside = function(l_15_0, l_15_1, l_15_2)
  if #l_15_0._areas > 0 then
    for i = 1, l_15_0._areas_per_frame do
      local area = l_15_0._areas[l_15_0._area_iterator]
      l_15_0._area_iterator = math.mod(l_15_0._area_iterator, #l_15_0._areas) + 1
      if area:is_inside(l_15_1) then
        if area:environment() ~= l_15_0._current_environment then
          local transition_time = area:transition_time()
          if area:permanent() then
            l_15_0:set_default_environment(area:environment(), transition_time, l_15_2)
            return 
          else
            l_15_0:_set_environment(area:environment(), transition_time, l_15_2)
          end
        end
        l_15_0._current_area = area
    else
      end
    end
  end
end

EnvironmentAreaManager._leave_current_area = function(l_16_0, l_16_1, l_16_2)
  l_16_0._current_area = nil
  if l_16_0._default_environment ~= l_16_0._current_environment then
    l_16_0:_set_environment(l_16_0._default_environment, l_16_1, l_16_2)
  end
end

EnvironmentAreaManager.environment_at_position = function(l_17_0, l_17_1)
  local environment = l_17_0._default_environment
  for _,area in ipairs(l_17_0._areas) do
    if area:is_inside(l_17_1) then
      environment = area:environment()
  else
    end
  end
  return environment
end

EnvironmentAreaManager.add_block = function(l_18_0)
  l_18_0._blocks = l_18_0._blocks + 1
end

EnvironmentAreaManager.remove_block = function(l_19_0)
  l_19_0._blocks = l_19_0._blocks - 1
end

EnvironmentAreaManager.add_environment_changed_callback = function(l_20_0, l_20_1)
  table.insert(l_20_0._environment_changed_callback, l_20_1)
end

EnvironmentAreaManager.remove_environment_changed_callback = function(l_21_0, l_21_1)
  table.delete(l_21_0._environment_changed_callback, l_21_1)
end

if not EnvironmentArea then
  EnvironmentArea = class(CoreShapeManager.ShapeBox)
end
EnvironmentArea.init = function(l_22_0, l_22_1)
  l_22_1.type = "box"
  EnvironmentArea.super.init(l_22_0, l_22_1)
  if not l_22_1.environment then
    l_22_0._properties.environment = managers.environment_area:game_default_environment()
  end
  l_22_0._properties.permanent = l_22_1.permanent or false
  if not l_22_1.transition_time then
    l_22_0._properties.transition_time = managers.environment_area:default_transition_time()
  end
end

EnvironmentArea.name = function(l_23_0)
  if not l_23_0._unit or not l_23_0._unit:unit_data().name_id then
    return l_23_0._name
  end
end

EnvironmentArea.environment = function(l_24_0)
  return l_24_0:property("environment")
end

EnvironmentArea.set_environment = function(l_25_0, l_25_1)
  l_25_0:set_property_string("environment", l_25_1)
end

EnvironmentArea.permanent = function(l_26_0)
  return l_26_0:property("permanent")
end

EnvironmentArea.set_permanent = function(l_27_0, l_27_1)
  l_27_0._properties.permanent = l_27_1
end

EnvironmentArea.transition_time = function(l_28_0)
  return l_28_0:property("transition_time")
end

EnvironmentArea.set_transition_time = function(l_29_0, l_29_1)
  l_29_0._properties.transition_time = l_29_1
end


