-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\coreshapemanager.luac 

core:module("CoreShapeManager")
core:import("CoreXml")
core:import("CoreMath")
if not ShapeManager then
  ShapeManager = class()
end
ShapeManager.init = function(l_1_0)
  l_1_0._shapes = {}
  l_1_0._shape_types = {}
  l_1_0._shape_types.box = ShapeBox
  l_1_0._shape_types.sphere = ShapeSphere
  l_1_0._shape_types.cylinder = ShapeCylinder
  l_1_0._shape_types.box_middle = ShapeBoxMiddle
end

ShapeManager.update = function(l_2_0, l_2_1, l_2_2)
  for _,shape in ipairs(l_2_0._shapes) do
    shape:draw(l_2_1, l_2_2, 0.80000001192093, 0.80000001192093)
  end
end

ShapeManager.add_shape = function(l_3_0, l_3_1, l_3_2)
  l_3_2.type = l_3_1
  local shape = l_3_0._shape_types[l_3_1]:new(l_3_2)
  table.insert(l_3_0._shapes, shape)
  return shape
end

ShapeManager.shape_type = function(l_4_0, l_4_1)
  return l_4_0._shape_types[l_4_1]
end

ShapeManager.remove_shape = function(l_5_0, l_5_1)
  l_5_1:destroy()
  table.delete(l_5_0._shapes, l_5_1)
end

ShapeManager.clear_shapes = function(l_6_0)
  for _,shape in ipairs(clone(l_6_0._shapes)) do
    l_6_0:remove_shape(shape)
  end
end

ShapeManager.save = function(l_7_0)
end

ShapeManager.parse = function(l_8_0, l_8_1)
  local t = {}
  t.type = l_8_1:parameter("type")
  t.position = math.string_to_vector(l_8_1:parameter("position"))
  t.rotation = math.string_to_rotation(l_8_1:parameter("rotation"))
  for properties in l_8_1:children() do
    for value in properties:children() do
      t[value:parameter("name")] = CoreMath.string_to_value(value:parameter("type"), value:parameter("value"))
    end
  end
  return t
end

local mvec1 = Vector3()
local mvec2 = Vector3()
local mvec3 = Vector3()
local mposition = Vector3()
if not Shape then
  Shape = class()
end
Shape.init = function(l_9_0, l_9_1)
  l_9_0._name = l_9_1.name or ""
  l_9_0._type = l_9_1.type or "none"
  if not l_9_1.position then
    l_9_0._position = Vector3()
  end
  if not l_9_1.rotation then
    l_9_0._rotation = Rotation()
  end
  l_9_0._properties = {}
  l_9_0:build_dialog()
end

Shape.build_dialog = function(l_10_0)
  if not Application:editor() then
    return 
  end
  l_10_0._properties_ctrls = {}
  l_10_0._dialog = EWS:Dialog(nil, "Shape properties", "", Vector3(200, 100, 0), Vector3(750, 600, 0), "DEFAULT_DIALOG_STYLE,RESIZE_BORDER,STAY_ON_TOP")
  l_10_0._dialog_sizer = EWS:BoxSizer("VERTICAL")
  l_10_0._dialog:set_sizer(l_10_0._dialog_sizer)
  l_10_0._min_value = 10
  l_10_0._max_value = 10000000
  l_10_0:set_dialog_visible(false)
end

Shape.build_properties_ctrls = function(l_11_0)
end

Shape.name = function(l_12_0)
  if not l_12_0._unit or not l_12_0._unit:unit_data().name_id then
    return l_12_0._name
  end
end

Shape.unit = function(l_13_0)
  return l_13_0._unit
end

Shape.set_unit = function(l_14_0, l_14_1)
  l_14_0._unit = l_14_1
end

Shape.position = function(l_15_0)
  if not l_15_0._unit or not l_15_0._unit:position() then
    return l_15_0._position
  end
end

Shape.set_position = function(l_16_0, l_16_1)
  l_16_0._position = l_16_1
end

Shape.rotation = function(l_17_0)
  if not l_17_0._unit or not l_17_0._unit:rotation() then
    return l_17_0._rotation
  end
end

Shape.set_rotation = function(l_18_0, l_18_1)
  l_18_0._rotation = l_18_1
end

Shape.properties = function(l_19_0)
  return l_19_0._properties
end

Shape.property = function(l_20_0, l_20_1)
  return l_20_0._properties[l_20_1]
end

Shape.set_property = function(l_21_0, l_21_1, l_21_2)
  if not l_21_0._properties[l_21_1] then
    return 
  end
  l_21_2 = math.clamp(l_21_2, l_21_0._min_value, l_21_0._max_value)
  l_21_0._properties[l_21_1] = l_21_2
  if l_21_0._properties_ctrls then
    for _,ctrl in ipairs(l_21_0._properties_ctrls[l_21_1]) do
      ctrl:set_value(string.format("%.2f", l_21_2 / 100))
    end
  end
end

Shape.set_property_string = function(l_22_0, l_22_1, l_22_2)
  l_22_0._properties[l_22_1] = l_22_2
end

Shape.scale = function(l_23_0)
end

Shape.set_dialog_visible = function(l_24_0, l_24_1)
  l_24_0._dialog:set_visible(l_24_1)
end

Shape.panel = function(l_25_0, l_25_1, l_25_2)
  if not l_25_0._panel and l_25_1 and l_25_2 then
    l_25_0:create_panel(l_25_1, l_25_2)
  end
  return l_25_0._panel
end

Shape.create_panel = function(l_26_0, l_26_1, l_26_2)
  l_26_0._panel = EWS:Panel(l_26_1, "", "")
  l_26_0._panel_sizer = EWS:BoxSizer("VERTICAL")
  l_26_0._panel:set_sizer(l_26_0._panel_sizer)
  l_26_2:add(l_26_0._panel, 0, 0, "EXPAND")
end

Shape._create_size_ctrl = function(l_27_0, l_27_1, l_27_2, l_27_3, l_27_4, l_27_5)
  local ctrl_sizer = EWS:BoxSizer("HORIZONTAL")
  ctrl_sizer:add(EWS:StaticText(l_27_4, l_27_1, "", "ALIGN_LEFT"), 2, 0, "EXPAND")
  local ctrl = EWS:TextCtrl(l_27_4, string.format("%.2f", l_27_3 / 100), "", "TE_PROCESS_ENTER")
  local spin = EWS:SpinButton(l_27_4, "", "SP_VERTICAL")
  ctrl:connect("EVT_CHAR", callback(nil, _G, "verify_number"), ctrl)
  ctrl:set_tool_tip("Type in property " .. l_27_1)
  ctrl:connect("EVT_COMMAND_TEXT_ENTER", callback(l_27_0, l_27_0, "update_size"), {ctrl = ctrl, property = l_27_2})
  ctrl:connect("EVT_KILL_FOCUS", callback(l_27_0, l_27_0, "update_size"), {ctrl = ctrl, property = l_27_2})
  spin:connect("EVT_SCROLL_LINEUP", callback(l_27_0, l_27_0, "update_size_spin"), {ctrl = ctrl, property = l_27_2, step = 0.10000000149012})
  spin:connect("EVT_SCROLL_LINEDOWN", callback(l_27_0, l_27_0, "update_size_spin"), {ctrl = ctrl, property = l_27_2, step = -0.10000000149012})
  ctrl_sizer:add(ctrl, 3, 0, "EXPAND")
  ctrl_sizer:add(spin, 0, 0, "EXPAND")
  if not l_27_0._properties_ctrls[l_27_2] then
    l_27_0._properties_ctrls[l_27_2] = {}
  end
  table.insert(l_27_0._properties_ctrls[l_27_2], ctrl)
  l_27_5:add(ctrl_sizer, 1, 0, "EXPAND")
  return ctrl
end

Shape.connect_event = function(l_28_0, l_28_1, l_28_2, l_28_3, l_28_4)
  if not l_28_0._properties_ctrls[l_28_1] then
    local ctrls = {}
  end
  for _,ctrl in ipairs(ctrls) do
    ctrl:connect(l_28_2, l_28_3, l_28_4)
  end
end

Shape.update_size = function(l_29_0, l_29_1)
  local value = l_29_1.ctrl:get_value()
  l_29_0:set_property(l_29_1.property, value * 100)
  l_29_1.ctrl:set_selection(-1, -1)
end

Shape.update_size_spin = function(l_30_0, l_30_1)
  local value = l_30_1.ctrl:get_value() + l_30_1.step
  l_30_0:set_property(l_30_1.property, value * 100)
end

Shape.draw = function(l_31_0, l_31_1, l_31_2, l_31_3, l_31_4, l_31_5)
end

Shape.is_inside = function(l_32_0, l_32_1)
end

Shape.is_outside = function(l_33_0, l_33_1)
end

Shape.save = function(l_34_0, l_34_1)
  local t = l_34_1 or ""
  local s = t
  local pos = CoreMath.vector_to_string(l_34_0:position(), "%.4f")
  local rot = CoreMath.rotation_to_string(l_34_0:rotation(), "%.4f")
  s = s .. "<shape type=\"" .. l_34_0._type .. "\" position=\"" .. pos .. "\" rotation=\"" .. rot .. "\">\n"
  s = s .. CoreXml.save_value_string(l_34_0, "_properties", t .. "\t") .. "\n"
  s = s .. t .. "</shape>"
  return s
end

Shape.save_level_data = function(l_35_0)
  local t = {}
  t.type = l_35_0._type
  t.position = l_35_0:position()
  t.rotation = l_35_0:rotation()
  for name,value in pairs(l_35_0._properties) do
    t[name] = value
  end
  return t
end

Shape.destroy = function(l_36_0)
  l_36_0._dialog:destroy()
end

if not ShapeBox then
  ShapeBox = class(Shape)
end
ShapeBox.init = function(l_37_0, l_37_1)
  Shape.init(l_37_0, l_37_1)
  l_37_0._properties.width = l_37_1.width or 1000
  l_37_0._properties.depth = l_37_1.depth or 1000
  l_37_0._properties.height = l_37_1.height or 1000
  l_37_0:build_properties_ctrls()
end

ShapeBox.create_panel = function(l_38_0, l_38_1, l_38_2)
  Shape.create_panel(l_38_0, l_38_1, l_38_2)
  local width = l_38_0:_create_size_ctrl("Width [m]", "width", l_38_0._properties.width, l_38_0._panel, l_38_0._panel_sizer)
  local depth = l_38_0:_create_size_ctrl("Depth [m]", "depth", l_38_0._properties.depth, l_38_0._panel, l_38_0._panel_sizer)
  local height = l_38_0:_create_size_ctrl("Height [m]", "height", l_38_0._properties.height, l_38_0._panel, l_38_0._panel_sizer)
  l_38_0._panel:set_min_size(Vector3(-1, 60, 0))
  return width, depth, height
end

ShapeBox.build_properties_ctrls = function(l_39_0)
  if not Application:editor() then
    return 
  end
  l_39_0:_create_size_ctrl("Width [m]", "width", l_39_0._properties.width, l_39_0._dialog, l_39_0._dialog_sizer)
  l_39_0:_create_size_ctrl("Depth [m]", "depth", l_39_0._properties.depth, l_39_0._dialog, l_39_0._dialog_sizer)
  l_39_0:_create_size_ctrl("Height [m]", "height", l_39_0._properties.height, l_39_0._dialog, l_39_0._dialog_sizer)
  l_39_0._dialog:set_size(Vector3(190, 90, 0))
end

ShapeBox.size = function(l_40_0)
  return Vector3(l_40_0._properties.width, l_40_0._properties.depth, l_40_0._properties.height)
end

ShapeBox.width = function(l_41_0)
  return l_41_0._properties.width
end

ShapeBox.set_width = function(l_42_0, l_42_1)
  l_42_0:set_property("width", l_42_1)
end

ShapeBox.depth = function(l_43_0)
  return l_43_0._properties.depth
end

ShapeBox.set_depth = function(l_44_0, l_44_1)
  l_44_0:set_property("depth", l_44_1)
end

ShapeBox.height = function(l_45_0)
  return l_45_0._properties.height
end

ShapeBox.set_height = function(l_46_0, l_46_1)
  l_46_0:set_property("height", l_46_1)
end

ShapeBox.still_inside = function(l_47_0, l_47_1)
  return l_47_0:is_inside(l_47_1)
end

ShapeBox.is_inside = function(l_48_0, l_48_1)
  mvector3.set(mvec1, l_48_1)
  mvector3.subtract(mvec1, l_48_0:position())
  local rot = l_48_0:rotation()
  mrotation.x(rot, mvec2)
  local inside = mvector3.dot(mvec2, mvec1)
  if inside > 0 and inside < l_48_0._properties.width then
    mrotation.y(rot, mvec2)
    inside = mvector3.dot(mvec2, mvec1)
    if inside > 0 and inside < l_48_0._properties.depth then
      mrotation.z(rot, mvec2)
      inside = mvector3.dot(mvec2, mvec1)
      if inside > 0 and inside < l_48_0._properties.height then
        return true
      end
    end
  end
  return false
end

ShapeBox.draw = function(l_49_0, l_49_1, l_49_2, l_49_3, l_49_4, l_49_5)
  local brush = Draw:brush()
  brush:set_color(Color(0.5, l_49_3, l_49_4, l_49_5))
  local pos = l_49_0:position()
  local rot = l_49_0:rotation()
  pos = pos + rot:x() * l_49_0._properties.width / 2 + rot:y() * l_49_0._properties.depth / 2 + rot:z() * l_49_0._properties.height / 2
  brush:box(pos, rot:x() * l_49_0._properties.width / 2, rot:y() * l_49_0._properties.depth / 2, rot:z() * l_49_0._properties.height / 2)
  Application:draw_box_rotation(l_49_0:position(), rot, l_49_0._properties.width, l_49_0._properties.depth, l_49_0._properties.height, l_49_3, l_49_4, l_49_5)
end

if not ShapeBoxMiddle then
  ShapeBoxMiddle = class(ShapeBox)
end
ShapeBoxMiddle.init = function(l_50_0, l_50_1)
  ShapeBox.init(l_50_0, l_50_1)
end

ShapeBoxMiddle.is_inside = function(l_51_0, l_51_1)
  local rot = l_51_0:rotation()
  local x = mvec1
  local y = mvec2
  local z = mvec3
  mrotation.x(rot, x)
  mvector3.multiply(x, l_51_0._properties.width / 2)
  mrotation.y(rot, y)
  mvector3.multiply(y, l_51_0._properties.depth / 2)
  mrotation.z(rot, z)
  mvector3.multiply(z, l_51_0._properties.height / 2)
  local position = mposition
  mvector3.set(position, l_51_0:position())
  mvector3.subtract(position, x)
  mvector3.subtract(position, y)
  mvector3.subtract(position, z)
  local pos_dir = position
  mvector3.multiply(pos_dir, -1)
  mvector3.add(pos_dir, l_51_1)
  mrotation.x(rot, x)
  local inside = mvector3.dot(x, pos_dir)
  if inside > 0 and inside < l_51_0._properties.width then
    mrotation.y(rot, y)
    inside = mvector3.dot(y, pos_dir)
    if inside > 0 and inside < l_51_0._properties.depth then
      mrotation.z(rot, z)
      inside = mvector3.dot(z, pos_dir)
      if inside > 0 and inside < l_51_0._properties.height then
        return true
      end
    end
  end
  return false
end

ShapeBoxMiddle.draw = function(l_52_0, l_52_1, l_52_2, l_52_3, l_52_4, l_52_5)
  local brush = Draw:brush()
  brush:set_color(Color(0.5, l_52_3, l_52_4, l_52_5))
  local pos = l_52_0:position()
  local rot = l_52_0:rotation()
  brush:box(pos, rot:x() * l_52_0._properties.width / 2, rot:y() * l_52_0._properties.depth / 2, rot:z() * l_52_0._properties.height / 2)
  local c1 = l_52_0:position() - rot:x() * l_52_0._properties.width / 2 - rot:y() * l_52_0._properties.depth / 2 - rot:z() * l_52_0._properties.height / 2
  Application:draw_box_rotation(c1, rot, l_52_0._properties.width, l_52_0._properties.depth, l_52_0._properties.height, l_52_3, l_52_4, l_52_5)
end

if not ShapeBoxMiddleBottom then
  ShapeBoxMiddleBottom = class(ShapeBox)
end
ShapeBoxMiddleBottom.init = function(l_53_0, l_53_1)
  ShapeBox.init(l_53_0, l_53_1)
end

ShapeBoxMiddleBottom.is_inside = function(l_54_0, l_54_1)
  local rot = l_54_0:rotation()
  local x = rot:x() * l_54_0._properties.width / 2
  local y = rot:y() * l_54_0._properties.depth / 2
  local position = l_54_0:position() - x - y
  local pos_dir = l_54_1 - position
  local inside = rot:x():dot(pos_dir)
  if inside > 0 and inside < l_54_0._properties.width then
    inside = rot:y():dot(pos_dir)
    if inside > 0 and inside < l_54_0._properties.depth then
      inside = rot:z():dot(pos_dir)
      if inside > 0 and inside < l_54_0._properties.height then
        return true
      end
    end
  end
  return false
end

ShapeBoxMiddleBottom.draw = function(l_55_0, l_55_1, l_55_2, l_55_3, l_55_4, l_55_5)
  local brush = Draw:brush()
  brush:set_color(Color(0.5, l_55_3, l_55_4, l_55_5))
  local pos = l_55_0:position()
  local rot = l_55_0:rotation()
  pos = pos + rot:z() * l_55_0._properties.height / 2
  brush:box(pos, rot:x() * l_55_0._properties.width / 2, rot:y() * l_55_0._properties.depth / 2, rot:z() * l_55_0._properties.height / 2)
  local c1 = l_55_0:position() - rot:x() * l_55_0._properties.width / 2 - rot:y() * l_55_0._properties.depth / 2
  Application:draw_box_rotation(c1, rot, l_55_0._properties.width, l_55_0._properties.depth, l_55_0._properties.height, l_55_3, l_55_4, l_55_5)
end

if not ShapeSphere then
  ShapeSphere = class(Shape)
end
ShapeSphere.init = function(l_56_0, l_56_1)
  Shape.init(l_56_0, l_56_1)
  l_56_0._properties.radius = l_56_1.radius or 1000
  l_56_0:build_properties_ctrls()
end

ShapeSphere.build_properties_ctrls = function(l_57_0)
  if not Application:editor() then
    return 
  end
  l_57_0:_create_size_ctrl("Radius [m]", "radius", l_57_0._properties.radius, l_57_0._dialog_sizer)
  l_57_0._dialog:set_size(Vector3(190, 50, 0))
end

ShapeSphere.radius = function(l_58_0)
  return l_58_0._properties.radius
end

ShapeSphere.set_radius = function(l_59_0, l_59_1)
  l_59_0:set_property("radius", l_59_1)
end

ShapeSphere.is_inside = function(l_60_0, l_60_1)
  return l_60_1 - l_60_0:position():length() < l_60_0._properties.radius
end

ShapeSphere.draw = function(l_61_0, l_61_1, l_61_2, l_61_3, l_61_4, l_61_5)
  local brush = Draw:brush()
  brush:set_color(Color(0.5, l_61_3, l_61_4, l_61_5))
  brush:sphere(l_61_0:position(), l_61_0._properties.radius, 4)
  Application:draw_sphere(l_61_0:position(), l_61_0._properties.radius, l_61_3, l_61_4, l_61_5)
end

if not ShapeCylinder then
  ShapeCylinder = class(Shape)
end
ShapeCylinder.init = function(l_62_0, l_62_1)
  Shape.init(l_62_0, l_62_1)
  l_62_0._properties.radius = l_62_1.radius or 1000
  l_62_0._properties.height = l_62_1.height or 1000
  l_62_0:build_properties_ctrls()
end

ShapeCylinder.build_properties_ctrls = function(l_63_0)
  if not Application:editor() then
    return 
  end
  l_63_0:_create_size_ctrl("Radius [m]", "radius", l_63_0._properties.radius, l_63_0._dialog, l_63_0._dialog_sizer)
  l_63_0:_create_size_ctrl("Height [m]", "height", l_63_0._properties.height, l_63_0._dialog, l_63_0._dialog_sizer)
  l_63_0._dialog:set_size(Vector3(190, 70, 0))
end

ShapeCylinder.radius = function(l_64_0)
  return l_64_0._properties.radius
end

ShapeCylinder.set_radius = function(l_65_0, l_65_1)
  l_65_0:set_property("radius", l_65_1)
end

ShapeCylinder.height = function(l_66_0)
  return l_66_0._properties.height
end

ShapeCylinder.set_height = function(l_67_0, l_67_1)
  l_67_0:set_property("height", l_67_1)
end

ShapeCylinder.draw = function(l_68_0, l_68_1, l_68_2, l_68_3, l_68_4, l_68_5)
  local brush = Draw:brush()
  brush:set_color(Color(0.5, l_68_3, l_68_4, l_68_5))
  local pos = l_68_0:position()
  local rot = l_68_0:rotation()
  brush:cylinder(pos, pos + rot:z() * l_68_0._properties.height, l_68_0._properties.radius, 100)
  Application:draw_cylinder(pos, pos + rot:z() * l_68_0._properties.height, l_68_0._properties.radius, l_68_3, l_68_4, l_68_5)
end

ShapeCylinder.is_inside = function(l_69_0, l_69_1)
  local pos_dir = l_69_1 - l_69_0:position()
  local rot = l_69_0:rotation()
  local inside = rot:z():dot(pos_dir)
  if inside > 0 and inside < l_69_0._properties.height then
    local pos_a = l_69_0:position()
    local pos_b = pos_a + rot:z() * l_69_0._properties.height
    if math.distance_to_segment(l_69_1, pos_a, pos_b) <= l_69_0._properties.radius then
      return true
    end
  end
  return false
end

if not ShapeCylinderMiddle then
  ShapeCylinderMiddle = class(ShapeCylinder)
end
ShapeCylinderMiddle.init = function(l_70_0, l_70_1)
  ShapeCylinderMiddle.super.init(l_70_0, l_70_1)
end

ShapeCylinderMiddle.is_inside = function(l_71_0, l_71_1)
  local rot = l_71_0:rotation()
  local z = mvec3
  mrotation.z(rot, z)
  mvector3.multiply(z, l_71_0._properties.height / 2)
  local position = mposition
  mvector3.set(position, l_71_0:position())
  mvector3.subtract(position, z)
  local pos_dir = mvec1
  mvector3.set(pos_dir, position)
  mvector3.multiply(pos_dir, -1)
  mvector3.add(pos_dir, l_71_1)
  mrotation.z(rot, z)
  local inside = mvector3.dot(z, pos_dir)
  if inside > 0 and inside < l_71_0._properties.height then
    local to = mvec1
    mvector3.set(to, z)
    mvector3.multiply(to, l_71_0._properties.height)
    mvector3.add(to, position)
    if math.distance_to_segment(l_71_1, position, to) <= l_71_0._properties.radius then
      return true
    end
  end
  return false
end

ShapeCylinderMiddle.draw = function(l_72_0, l_72_1, l_72_2, l_72_3, l_72_4, l_72_5)
  local brush = Draw:brush()
  brush:set_color(Color(0.5, l_72_3, l_72_4, l_72_5))
  local pos = l_72_0:position()
  local rot = l_72_0:rotation()
  local from = pos - rot:z() * l_72_0._properties.height / 2
  local to = pos + rot:z() * l_72_0._properties.height / 2
  brush:cylinder(from, to, l_72_0._properties.radius, 100)
  Application:draw_cylinder(from, to, l_72_0._properties.radius, l_72_3, l_72_4, l_72_5)
end


