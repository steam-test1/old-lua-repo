-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\coreportalmanager.luac 

core:module("CorePortalManager")
core:import("CoreShapeManager")
if not PortalManager then
  PortalManager = class()
end
PortalManager.EFFECT_MANAGER = World:effect_manager()
PortalManager.init = function(l_1_0)
  l_1_0._portal_shapes = {}
  l_1_0._all_units = {}
  l_1_0._all_effects = {}
  l_1_0._unit_groups = {}
  l_1_0._check_positions = {}
  l_1_0._hide_list = {}
  l_1_0._deactivate_funtion = callback(l_1_0, l_1_0, "unit_deactivated")
end

PortalManager.clear = function(l_2_0)
  for _,portal in ipairs(l_2_0._portal_shapes) do
    portal:show_all()
  end
  l_2_0._portal_shapes = {}
  l_2_0._all_units = {}
  l_2_0._unit_groups = {}
  l_2_0._hide_list = {}
end

PortalManager.pseudo_reset = function(l_3_0)
  for _,unit in ipairs(managers.editor:layer("Statics"):created_units()) do
    if alive(unit) then
      unit:unit_data()._visibility_counter = 0
    end
  end
  for _,group in pairs(l_3_0._unit_groups) do
    group._is_inside = false
    for _,unit in ipairs(managers.editor:layer("Statics"):created_units()) do
      if group._ids[unit:unit_data().unit_id] and alive(unit) then
        unit:set_visible(true)
        unit:unit_data()._visibility_counter = 0
      end
    end
  end
end

PortalManager.add_portal = function(l_4_0, l_4_1, l_4_2, l_4_3)
  cat_print("portal", "add_portal", #l_4_1)
  if #l_4_1 > 0 then
    table.insert(l_4_0._portal_shapes, PortalShape:new(l_4_1, l_4_2, l_4_3))
  end
end

PortalManager.add_unit = function(l_5_0, l_5_1)
  if l_5_1:unit_data().ignore_portal then
    return 
  end
  do
    local added = nil
    for _,group in pairs(l_5_0._unit_groups) do
    end
    if not group:add_unit(l_5_1) then
      end
      if added then
        return 
      end
      for _,portal in ipairs(l_5_0._portal_shapes) do
        local added, amount = portal:add_unit(l_5_1)
        if not l_5_0._all_units[l_5_1:key()] then
          l_5_0._all_units[l_5_1:key()] = (not added or 0) + amount
          local inverse = l_5_1:unit_data().portal_visible_inverse
          local i = 0
          i = portal:is_inside() or (inverse and 1) or -1
          l_5_0:change_visibility(l_5_1, i, inverse)
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PortalManager.remove_dynamic_unit = function(l_6_0, l_6_1)
  l_6_0:remove_unit(l_6_1)
  if not l_6_1:body(l_6_1:orientation_object()) then
    local check_body = l_6_1:body(0)
  end
  if alive(check_body) then
    check_body:set_activate_tag("dynamic_portal")
    check_body:set_deactivate_tag("dynamic_portal")
  end
  l_6_1:add_body_activation_callback(l_6_0._deactivate_funtion)
end

PortalManager.unit_deactivated = function(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4)
  if not l_7_4 then
    cat_print("portal", "should add unit here", l_7_1, l_7_2, l_7_3, l_7_4)
    l_7_0:add_unit(l_7_2)
    l_7_2:remove_body_activation_callback(l_7_0._deactivate_funtion)
  end
end

PortalManager.remove_unit = function(l_8_0, l_8_1)
  cat_print("portal", "remove_unit", l_8_1, l_8_1:visible())
  l_8_0._all_units[l_8_1:key()] = nil
  for _,portal in ipairs(l_8_0._portal_shapes) do
    portal:remove_unit(l_8_1)
  end
  l_8_1:set_visible(true)
end

PortalManager.delete_unit = function(l_9_0, l_9_1)
  for name,group in pairs(l_9_0._unit_groups) do
    group:remove_unit_id(l_9_1)
  end
end

PortalManager.change_visibility = function(l_10_0, l_10_1, l_10_2, l_10_3)
  l_10_0._all_units[l_10_1:key()] = l_10_0._all_units[l_10_1:key()] + l_10_2
  if l_10_3 ~= false then
    l_10_1:set_visible(l_10_0._all_units[l_10_1:key()] ~= 0)
  end
  do return end
  if l_10_3 ~= true then
    l_10_1:set_visible(not l_10_1:visible() == l_10_3)
  end
end

PortalManager.add_effect = function(l_11_0, l_11_1)
  l_11_1.id = l_11_0.EFFECT_MANAGER:spawn(l_11_1)
  l_11_0._all_effects[l_11_1] = 0
  for _,portal in ipairs(l_11_0._portal_shapes) do
    local added, amount = portal:add_effect(l_11_1)
    if added then
      l_11_0._all_effects[l_11_1] = l_11_0._all_effects[l_11_1] + amount
    end
  end
end

PortalManager.change_effect_visibility = function(l_12_0, l_12_1, l_12_2)
  l_12_0._all_effects[l_12_1] = l_12_0._all_effects[l_12_1] + l_12_2
  if l_12_0._all_effects[l_12_1] == 0 then
    l_12_1.hidden = true
    l_12_0.EFFECT_MANAGER:set_frozen(l_12_1.id, true)
    l_12_0.EFFECT_MANAGER:set_hidden(l_12_1.id, true)
  elseif l_12_1.hidden then
    l_12_1.hidden = false
    l_12_0.EFFECT_MANAGER:set_frozen(l_12_1.id, false)
    l_12_0.EFFECT_MANAGER:set_hidden(l_12_1.id, false)
  end
end

PortalManager.restart_effects = function(l_13_0)
  for _,portal in ipairs(l_13_0._portal_shapes) do
    portal:clear_effects()
  end
  local restart = {}
  for e,n in pairs(l_13_0._all_effects) do
    restart[e] = n
  end
  l_13_0._all_effects = {}
  for effect,_ in pairs(restart) do
    if effect.id then
      l_13_0.EFFECT_MANAGER:kill(effect.id)
    end
    l_13_0:add_effect(effect)
  end
  restart = nil
end

PortalManager.render = function(l_14_0)
  for _,portal in ipairs(l_14_0._portal_shapes) do
    portal:update(TimerManager:wall():time(), TimerManager:wall():delta_time())
  end
  for _,group in pairs(l_14_0._unit_groups) do
    group:update(TimerManager:wall():time(), TimerManager:wall():delta_time())
  end
  local unit_id, unit = next(l_14_0._hide_list)
  if alive(unit) then
    unit:set_visible(false)
    l_14_0._hide_list[unit_id] = nil
  end
  repeat
    if table.remove(l_14_0._check_positions) then
      do return end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PortalManager.add_to_hide_list = function(l_15_0, l_15_1)
  l_15_0._hide_list[l_15_1:unit_data().unit_id] = l_15_1
end

PortalManager.remove_from_hide_list = function(l_16_0, l_16_1)
  l_16_0._hide_list[l_16_1:unit_data().unit_id] = nil
end

PortalManager.debug_draw_border = function(l_17_0, l_17_1, l_17_2, l_17_3)
  local step = 500
  local time = 10
  do
    local tbl = l_17_1:to_table()
    for x = 2, #tbl do
      local length = 0
      repeat
        if length < time then
          if l_17_2 and l_17_3 then
            local start = Vector3(tbl[x - 1].x, tbl[x - 1].y, l_17_3)
            local stop = Vector3(tbl[x].x, tbl[x].y, l_17_3)
            local stop_vertical = Vector3(tbl[x - 1].x, tbl[x - 1].y, l_17_2)
            Application:draw_line(start, stop, 1, 0, 0)
            Application:draw_line(start, stop_vertical, 0, 1, 0)
          else
            local start = Vector3(tbl[x - 1].x, tbl[x - 1].y, step * length)
            local stop = Vector3(tbl[x].x, tbl[x].y, step * length)
            local stop_vertical = Vector3(tbl[x - 1].x, tbl[x - 1].y, step * (length + 1))
            Application:draw_line(start, stop, 1, 0, 0)
            Application:draw_line(start, stop_vertical, 0, 1, 0)
          end
          length = length + 1
      else
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PortalManager.unit_groups = function(l_18_0)
  return l_18_0._unit_groups
end

PortalManager.unit_group_on_shape = function(l_19_0, l_19_1)
  for _,group in pairs(l_19_0._unit_groups) do
    for _,shape in ipairs(group:shapes()) do
      if shape == l_19_1 then
        return group
      end
    end
  end
end

PortalManager.rename_unit_group = function(l_20_0, l_20_1, l_20_2)
  if l_20_0._unit_groups[l_20_2] then
    return false
  end
  local group = l_20_0._unit_groups[l_20_1]
  l_20_0._unit_groups[l_20_1] = nil
  l_20_0._unit_groups[l_20_2] = group
  group:rename(l_20_2)
  return true
end

PortalManager.unit_group = function(l_21_0, l_21_1)
  return l_21_0._unit_groups[l_21_1]
end

PortalManager.add_unit_group = function(l_22_0, l_22_1)
  local group = PortalUnitGroup:new(l_22_1)
  l_22_0._unit_groups[l_22_1] = group
  return group
end

PortalManager.remove_unit_group = function(l_23_0, l_23_1)
  l_23_0._unit_groups[l_23_1] = nil
end

PortalManager.clear_unit_groups = function(l_24_0)
  l_24_0._unit_groups = {}
end

PortalManager.group_name = function(l_25_0)
  local name = "group"
  do
    local i = 1
    repeat
      if l_25_0._unit_groups[name .. i] then
        i = i + 1
      else
        return name .. i
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PortalManager.check_positions = function(l_26_0)
  if #l_26_0._check_positions > 0 then
    return l_26_0._check_positions
  end
  for _,vp in ipairs(managers.viewport:all_really_active_viewports()) do
    local camera = vp:camera()
    if alive(camera) and vp:is_rendering_scene("World") then
      table.insert(l_26_0._check_positions, camera:position())
    end
  end
  return l_26_0._check_positions
end

PortalManager.unit_in_any_unit_group = function(l_27_0, l_27_1)
  for name,group in pairs(l_27_0._unit_groups) do
    if group:unit_in_group(l_27_1) then
      return true
    end
  end
  return false
end

PortalManager.save = function(l_28_0, l_28_1)
  local t = l_28_1 or ""
  local s = ""
  for name,group in pairs(l_28_0._unit_groups) do
    s = s .. t .. "\t<unit_group name=\"" .. name .. "\">\n"
    for _,shape in ipairs(group:shapes()) do
      s = s .. shape:save(t .. "\t\t") .. "\n"
    end
    s = s .. t .. "\t</unit_group>\n"
  end
  return s
end

PortalManager.save_level_data = function(l_29_0)
  local t = {}
  for name,group in pairs(l_29_0._unit_groups) do
    local shapes = {}
    for _,shape in ipairs(group:shapes()) do
      table.insert(shapes, shape:save_level_data())
    end
    t[name] = {}
    t[name].shapes = shapes
    t[name].ids = group:ids()
  end
  return t
end

if not PortalShape then
  PortalShape = class()
end
PortalShape.init = function(l_30_0, l_30_1, l_30_2, l_30_3)
  l_30_0._polygon = ScriptPolygon2D(l_30_1)
  l_30_0._units = {}
  l_30_0._inverse_units = {}
  l_30_0._effects = {}
  l_30_0._is_inside = true
  l_30_0._min = l_30_2
  l_30_0._max = l_30_3
end

PortalShape.add_unit = function(l_31_0, l_31_1)
  if l_31_0:inside(l_31_1:position()) then
    l_31_0._units[l_31_1:key()] = l_31_1
    local inverse = l_31_1:unit_data().portal_visible_inverse
    if inverse then
      l_31_1:set_visible(false)
    end
    return true, inverse and -1 or 1, l_31_0
  end
end

PortalShape.remove_unit = function(l_32_0, l_32_1)
  l_32_0._units[l_32_1:key()] = nil
end

PortalShape.add_effect = function(l_33_0, l_33_1)
  if l_33_0:inside(l_33_1.position) then
    table.insert(l_33_0._effects, l_33_1)
    return true, 1
  end
end

PortalShape.clear_effects = function(l_34_0)
  l_34_0._effects = {}
end

PortalShape.show_all = function(l_35_0)
  for _,unit in pairs(l_35_0._units) do
    if alive(unit) then
      unit:set_visible(true)
    end
  end
end

PortalShape.inside = function(l_36_0, l_36_1)
  local is_inside = l_36_0._polygon:inside(l_36_1)
  if is_inside and l_36_0._min and l_36_0._max then
    local z = l_36_1.z
    if l_36_0._min < z and z < l_36_0._max then
      return true
    else
      return false
    end
  end
  return is_inside
end

PortalShape.is_inside = function(l_37_0)
  return l_37_0._is_inside
end

PortalShape.update = function(l_38_0, l_38_1, l_38_2)
  local is_inside = false
  for _,pos in ipairs(managers.portal:check_positions()) do
    is_inside = l_38_0:inside(pos)
    if is_inside then
      do return end
    end
  end
  if l_38_0._is_inside ~= is_inside then
    l_38_0._is_inside = is_inside
    for _,unit in pairs(l_38_0._units) do
      l_38_0:_change_visibility(unit)
    end
    for _,effect in ipairs(l_38_0._effects) do
      local i = l_38_0._is_inside and 1 or -1
      managers.portal:change_effect_visibility(effect, i)
    end
  end
end

PortalShape._change_visibility = function(l_39_0, l_39_1)
  if alive(l_39_1) then
    local inverse = l_39_1:unit_data().portal_visible_inverse
    local i = l_39_0._is_inside ~= inverse and 1 or -1
    managers.portal:change_visibility(l_39_1, i, inverse)
  end
end

if not PortalUnitGroup then
  PortalUnitGroup = class()
end
PortalUnitGroup.init = function(l_40_0, l_40_1)
  l_40_0._name = l_40_1
  l_40_0._shapes = {}
  l_40_0._ids = {}
  l_40_0._r = 0.5 + math.rand(0.5)
  l_40_0._g = 0.5 + math.rand(0.5)
  l_40_0._b = 0.5 + math.rand(0.5)
  l_40_0._units = {}
  l_40_0._is_inside = false
end

PortalUnitGroup.rename = function(l_41_0, l_41_1)
  l_41_0._name = l_41_1
end

PortalUnitGroup.name = function(l_42_0)
  return l_42_0._name
end

PortalUnitGroup.shapes = function(l_43_0)
  return l_43_0._shapes
end

PortalUnitGroup.ids = function(l_44_0)
  return l_44_0._ids
end

PortalUnitGroup.set_ids = function(l_45_0, l_45_1)
  if not l_45_1 then
    l_45_0._ids = l_45_0._ids
  end
end

PortalUnitGroup.add_shape = function(l_46_0, l_46_1)
  local shape = PortalUnitGroupShape:new(l_46_1)
  table.insert(l_46_0._shapes, shape)
  return shape
end

PortalUnitGroup.remove_shape = function(l_47_0, l_47_1)
  table.delete(l_47_0._shapes, l_47_1)
end

PortalUnitGroup.add_unit = function(l_48_0, l_48_1)
  if not l_48_1:unit_data()._visibility_counter then
    l_48_1:unit_data()._visibility_counter = not l_48_0._ids[l_48_1:unit_data().unit_id] or 0
  end
  l_48_0:_change_visibility(l_48_1, l_48_0._is_inside and 1 or 0)
  table.insert(l_48_0._units, l_48_1)
  return true
  return false
end

PortalUnitGroup.add_unit_id = function(l_49_0, l_49_1)
  if l_49_0._ids[l_49_1:unit_data().unit_id] then
    l_49_0:remove_unit_id(l_49_1)
    return 
  end
  l_49_0._ids[l_49_1:unit_data().unit_id] = true
end

PortalUnitGroup.remove_unit_id = function(l_50_0, l_50_1)
  l_50_0._ids[l_50_1:unit_data().unit_id] = nil
end

PortalUnitGroup.lock_units = function(l_51_0)
  for _,unit in ipairs(l_51_0._units) do
  end
end

PortalUnitGroup.inside = function(l_52_0, l_52_1)
  for _,shape in ipairs(l_52_0._shapes) do
    if shape:is_inside(l_52_1) then
      return true
    end
  end
  return false
end

PortalUnitGroup.update = function(l_53_0, l_53_1, l_53_2)
  local is_inside = false
  for _,pos in ipairs(managers.portal:check_positions()) do
    is_inside = l_53_0:inside(pos)
    if is_inside then
      do return end
    end
  end
  if l_53_0._is_inside ~= is_inside then
    l_53_0._is_inside = is_inside
    local diff = l_53_0._is_inside and 1 or -1
    l_53_0:_change_units_visibility(diff)
  end
end

PortalUnitGroup._change_units_visibility = function(l_54_0, l_54_1)
  for _,unit in pairs(l_54_0._units) do
    l_54_0:_change_visibility(unit, l_54_1)
  end
end

PortalUnitGroup._change_units_visibility_in_editor = function(l_55_0, l_55_1)
  for _,unit in ipairs(managers.editor:layer("Statics"):created_units()) do
    if l_55_0._ids[unit:unit_data().unit_id] then
      l_55_0:_change_visibility(unit, l_55_1)
    end
  end
end

PortalUnitGroup._change_visibility = function(l_56_0, l_56_1, l_56_2)
  if alive(l_56_1) then
    l_56_1:unit_data()._visibility_counter = l_56_1:unit_data()._visibility_counter + l_56_2
    if l_56_1:unit_data()._visibility_counter > 0 then
      l_56_1:set_visible(true)
      managers.portal:remove_from_hide_list(l_56_1)
    else
      managers.portal:add_to_hide_list(l_56_1)
    end
  end
end

PortalUnitGroup.unit_in_group = function(l_57_0, l_57_1)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end

PortalUnitGroup.draw = function(l_58_0, l_58_1, l_58_2, l_58_3, l_58_4)
  local r = l_58_0._r * l_58_3
  local g = l_58_0._g * l_58_3
  local b = l_58_0._b * l_58_3
  local brush = Draw:brush()
  brush:set_color(Color(0.25, r, g, b))
  for _,unit in ipairs(managers.editor:layer("Statics"):created_units()) do
    if l_58_0._ids[unit:unit_data().unit_id] then
      brush:unit(unit)
      Application:draw(unit, r, g, b)
    end
  end
  if not l_58_4 then
    for _,shape in ipairs(l_58_0._shapes) do
      shape:draw(l_58_1, l_58_2, r, g, b)
    end
  end
end

if not PortalUnitGroupShape then
  PortalUnitGroupShape = class(CoreShapeManager.ShapeBox)
end
PortalUnitGroupShape.init = function(l_59_0, l_59_1)
  l_59_1.type = "box"
  PortalUnitGroupShape.super.init(l_59_0, l_59_1)
end

PortalUnitGroupShape.draw = function(l_60_0, l_60_1, l_60_2, l_60_3, l_60_4, l_60_5)
  PortalUnitGroupShape.super.draw(l_60_0, l_60_1, l_60_2, l_60_3, l_60_4, l_60_5)
  if alive(l_60_0._unit) then
    Application:draw(l_60_0._unit, l_60_3, l_60_4, l_60_5)
  end
end


