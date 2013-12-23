-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\camera\corecameramanager.luac 

core:module("CoreCameraManager")
core:import("CoreEngineAccess")
core:import("CoreCameraMixer")
core:import("CoreCameraDataInterpreter")
core:import("CoreTransformCameraNode")
core:import("CoreUnitLinkCameraNode")
core:import("CoreCollisionCameraNode")
core:import("CoreSpringCameraNode")
core:import("CoreAimCameraNode")
core:import("CoreClass")
core:import("CoreMath")
core:import("CoreUnit")
if not CameraBase then
  CameraBase = CoreClass.class()
end
CameraBase.init = function(l_1_0)
  l_1_0._nodes = {}
  l_1_0._name_to_nodes = {}
  l_1_0._setup = nil
  l_1_0._default_blend = 0
  l_1_0._blend_table = {}
end

CameraBase.destroy = function(l_2_0)
  for index,node in ipairs(l_2_0._nodes) do
    node:destroy()
  end
  l_2_0._nodes = {}
  l_2_0._setup = nil
end

CameraBase.name = function(l_3_0)
  return l_3_0._setup._name
end

CameraBase.transition_blend = function(l_4_0, l_4_1)
  return l_4_0._blend_table[l_4_1:name()]
end

CameraBase.default_blend = function(l_5_0)
  return l_5_0._default_blend
end

CameraBase.node = function(l_6_0, l_6_1)
  return l_6_0._name_to_nodes[l_6_1]
end

CameraBase.nodes = function(l_7_0)
  return l_7_0._nodes
end

if not CameraManager then
  CameraManager = CoreClass.class()
end
CameraManager.init = function(l_8_0, l_8_1)
  l_8_0._layers = {}
  l_8_0:create_layers(l_8_1)
end

CameraManager.destroy = function(l_9_0)
  for index,mixer in ipairs(l_9_0._layers) do
    mixer:destroy()
  end
  l_9_0._layers = {}
end

CameraManager.create_layers = function(l_10_0, l_10_1)
  for index,mixer in ipairs(l_10_0._layers) do
    mixer:destroy()
  end
  l_10_0._layers = {}
  l_10_0._name_to_layer = {}
  l_10_0._templates = l_10_1
  l_10_0._interpreter = l_10_1._interpreter_class:new()
  for index,layer_name in ipairs(l_10_1._layers) do
    local mixer = CoreCameraMixer.CameraMixer:new(layer_name)
    table.insert(l_10_0._layers, mixer)
    l_10_0._name_to_layer[layer_name] = mixer
  end
end

CameraManager.view_camera = function(l_11_0, l_11_1, l_11_2)
  local layer_name = l_11_0:get_camera_layer(l_11_1)
  local mixer = l_11_0._name_to_layer[layer_name]
  local active_camera = mixer:active_camera()
  if active_camera and not l_11_2 and active_camera:name() == l_11_1 then
    return active_camera
  end
  local camera = l_11_0:create_camera(l_11_1, l_11_0._unit)
  local blend_time = 0
  if active_camera then
    blend_time = camera:transition_blend(active_camera)
  end
  if not blend_time then
    blend_time = camera:default_blend()
  end
  assert(blend_time)
  mixer:add_camera(camera, blend_time)
  return camera
end

CameraManager.stop_all_layers = function(l_12_0)
  for index,layer in ipairs(l_12_0._layers) do
    layer:stop()
  end
end

CameraManager.stop_layer = function(l_13_0, l_13_1)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  if l_13_1 then
    do return end
  end
   -- DECOMPILER ERROR: Overwrote pending register.

  l_13_0._name_to_layer[l_13_1]:stop()
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CameraManager.get_camera_layer = function(l_14_0, l_14_1)
  local camera_setups = l_14_0._templates._setups
  local get_camera_layer = function(l_1_0)
    local camera_setup = camera_setups[l_1_0]
    assert(camera_setup)
    local layer = camera_setup._layer
    if layer then
      return layer
    end
    local parent_name = camera_setup._inherits
    if parent_name then
      return get_camera_layer(parent_name)
    end
   end
  local layer_name = get_camera_layer(l_14_1)
  assert(layer_name)
  return layer_name
end

CameraManager.create_camera = function(l_15_0, l_15_1)
  local templates = l_15_0._templates
  local camera_setups = templates._setups
  local camera_node_setups = templates._node_setups
  local camera_list = {}
  local get_camera_chain = function(l_1_0, l_1_1)
    local camera_setup = camera_setups[l_1_0]
    assert(camera_setup)
    local parent_name = camera_setup._inherits
    if parent_name then
      get_camera_chain(parent_name, l_1_1)
    end
    table.insert(l_1_1, camera_setup)
   end
  get_camera_chain(l_15_1, camera_list)
  local camera = CameraBase:new()
  local nodes = camera._nodes
  local name_to_nodes = camera._name_to_nodes
  local blend_table = camera._blend_table
  local parent_node = nil
  local num_cameras = 0
  for _,camera_setup in ipairs(camera_list) do
    num_cameras = num_cameras + 1
    for index,node_table in ipairs(camera_setup._camera_nodes) do
      local node_setup = camera_node_setups[node_table._node_name]
      local camera_node = node_setup._class:new(node_setup._settings)
      if node_table._name then
        camera_node._name = node_table._name
      end
      name_to_nodes[camera_node._name] = camera_node
      if node_table._position then
        camera_node._pivot_position = node_table._position
      end
      if node_table._rotation then
        camera_node._pivot_rotation = node_table._rotation
      end
      if parent_node then
        camera_node:set_parent(parent_node)
      end
      parent_node = camera_node
      table.insert(nodes, camera_node)
    end
    if camera_setup._default_blend then
      camera._default_blend = camera_setup._default_blend
    end
    for key,value in pairs(camera_setup._blend_table) do
      blend_table[key] = value
    end
    if camera_setup._layer then
      camera._layer = camera_setup._layer
    end
  end
  camera._setup = camera_list[num_cameras]
  return camera
end

CameraManager.update = function(l_16_0, l_16_1, l_16_2)
  l_16_0._interpreter:reset()
  local interpreter_class = l_16_0._templates._interpreter_class
  for index,mixer in ipairs(l_16_0._layers) do
    mixer:update(l_16_0._interpreter, interpreter_class, l_16_1, l_16_2)
  end
  if l_16_0._debug_render_enable then
    for index,mixer in ipairs(l_16_0._layers) do
      mixer:debug_render(l_16_1, l_16_2)
    end
  end
end

CameraManager.interpreter = function(l_17_0)
  return l_17_0._interpreter
end

CameraManager.print_cameras = function(l_18_0)
  for index,mixer in ipairs(l_18_0._layers) do
    cat_print("debug", "layer: '" .. mixer._name .. "'")
    local cameras = mixer:cameras()
    for _,camera in ipairs(cameras) do
      cat_print("debug", "camera: '" .. camera._setup._name .. "'")
    end
  end
end

if not CameraTemplateManager then
  CameraTemplateManager = CoreClass.class()
end
CameraTemplateManager.camera_db_type = "camera"
CameraTemplateManager.camera_db_path = "cameras/cameras"
CameraTemplateManager.init = function(l_19_0)
  l_19_0._camera_space = {}
  l_19_0._parse_func_table = {}
  l_19_0._parse_func_table.interpreter = CameraTemplateManager.parse_interpreter
  l_19_0._parse_func_table.layer = CameraTemplateManager.parse_layer
  l_19_0._parse_func_table.camera = CameraTemplateManager.parse_camera
  l_19_0._parse_func_table.camera_node = CameraTemplateManager.parse_camera_node
  l_19_0._parse_func_table.depends_on = CameraTemplateManager.parse_depends_on
  l_19_0._camera_managers = {}
  l_19_0:load_cameras()
end

CameraTemplateManager.create_camera_manager = function(l_20_0, l_20_1)
  local camera_space = l_20_0._camera_space[l_20_1]
  local cm = CameraManager:new(camera_space)
  table.insert(l_20_0._camera_managers, cm)
  return cm
end

CameraTemplateManager.load_cameras = function(l_21_0)
  l_21_0:clear()
  if DB:has(CameraTemplateManager.camera_db_type, CameraTemplateManager.camera_db_path) then
    local xml_node = DB:load_node(CameraTemplateManager.camera_db_type, CameraTemplateManager.camera_db_path)
    local xml_node_children = xml_node:children()
    for xml_child_node in xml_node_children do
      if xml_child_node:name() == "camera_file" and xml_child_node:has_parameter("file") then
        l_21_0:load_camera_file(xml_child_node:parameter("file"))
      end
    end
  end
  for index,cm in ipairs(l_21_0._camera_managers) do
    local template_name = cm._templates._name
    local template = l_21_0._camera_space[template_name]
    cm:create_layers(template)
  end
end

CameraTemplateManager.load_camera_file = function(l_22_0, l_22_1)
  if DB:has(CameraTemplateManager.camera_db_type, l_22_1) then
    local xml_node = DB:load_node(CameraTemplateManager.camera_db_type, l_22_1)
    if xml_node:name() == "camera_space" then
      local space_name = xml_node:parameter("name")
      if not l_22_0._camera_space[space_name] then
        l_22_0._camera_space[space_name] = {}
      end
      local space = l_22_0._camera_space[space_name]
      space._name = space_name
      space._interpreter_class = CoreCameraDataInterpreter.CameraDataInterpreter
      space._node_setups = {}
      space._setups = {}
      space._layers = {}
      local xml_node_children = xml_node:children()
      for xml_child_node in xml_node_children do
        local parse_func = l_22_0._parse_func_table[xml_child_node:name()]
        if parse_func then
          parse_func(l_22_0, xml_child_node, space)
        end
      end
    end
  end
end

CameraTemplateManager.clear = function(l_23_0)
  l_23_0._camera_space = {}
end

CameraTemplateManager.get_layers = function(l_24_0, l_24_1)
  local space = l_24_0._camera_space[l_24_1]
  return space._layers
end

CameraTemplateManager.parse_layer = function(l_25_0, l_25_1, l_25_2)
  local layer_name = l_25_1:parameter("name")
  table.insert(l_25_2._layers, layer_name)
end

CameraTemplateManager.parse_interpreter = function(l_26_0, l_26_1, l_26_2)
  local interpreter_class = l_26_1:parameter("class")
  l_26_2._interpreter_class = rawget(_G, interpreter_class)
end

CameraTemplateManager.parse_camera = function(l_27_0, l_27_1, l_27_2)
  local camera_setups = l_27_2._setups
  local setup = {}
  local name = l_27_1:parameter("name")
  assert(name)
  if l_27_1:has_parameter("inherits") then
    setup._inherits = l_27_1:parameter("inherits")
  end
  if l_27_1:has_parameter("layer") then
    setup._layer = l_27_1:parameter("layer")
  end
  setup._name = name
  setup._camera_nodes = {}
  setup._blend_table = {}
  camera_setups[name] = setup
  local parse_node = function(l_1_0)
    local node = {}
    node._node_name = l_1_0:parameter("node_name")
    assert(node._node_name)
    if l_1_0:has_parameter("name") then
      node._name = l_1_0:parameter("name")
    end
    if l_1_0:has_parameter("position") then
      node._position = math.string_to_vector(l_1_0:parameter("position"))
    end
    if l_1_0:has_parameter("rotation") then
      node._rotation = CoreMath.string_to_rotation(l_1_0:parameter("rotation"))
    end
    table.insert(setup._camera_nodes, node)
   end
  local parse_default_blend = function(l_2_0)
    if l_2_0:has_parameter("blend") then
      setup._default_blend = tonumber(l_2_0:parameter("blend"))
    end
   end
  local parse_from_blend = function(l_3_0)
    if l_3_0:has_parameter("name") then
      local name = l_3_0:parameter("name")
      local blend_value = 0
      if l_3_0:has_parameter("blend") then
        blend_value = l_3_0:parameter("blend")
      end
      setup._blend_table[name] = blend_value
    end
   end
  local parse_func_table = {}
  parse_func_table.node = parse_node
  parse_func_table.default = parse_default_blend
  parse_func_table.from = parse_from_blend
  local xml_node_children = l_27_1:children()
  for xml_child_node in xml_node_children do
    local parse_func = parse_func_table[xml_child_node:name()]
    if parse_func then
      parse_func(xml_child_node)
    end
  end
end

CameraTemplateManager.parse_camera_node = function(l_28_0, l_28_1, l_28_2)
  local split_string = function(l_1_0)
    local strings = {}
    for word in string.gmatch(l_1_0, "[^%p]+") do
      table.insert(strings, word)
    end
    return strings
   end
  if l_28_1:has_parameter("class") and l_28_1:has_parameter("name") then
    local camera_node_setups = l_28_2._node_setups
    local class_name = l_28_1:parameter("class")
    local class_hier = (split_string(class_name))
    local class = nil
    if #class_hier > 1 then
      local module = core:import(class_hier[1])
      class = module[class_hier[2]]
    else
      class = rawget(_G, class_name)
    end
    if not class then
      assert(class)
    end
    local settings = {}
    class.compile_settings(l_28_1, settings)
    local setup = {}
    setup._class = class
    setup._class_name = class_name
    setup._settings = settings
    local name = l_28_1:parameter("name")
    camera_node_setups[name] = setup
  end
end

CameraTemplateManager.parse_depends_on = function(l_29_0, l_29_1, l_29_2)
  if Application:editor() then
    if l_29_1:has_parameter("unit") then
      CoreUnit.editor_load_unit(l_29_1:parameter("unit"))
    else
      if l_29_1:has_parameter("effect") then
        CoreEngineAccess._editor_load("effect", l_29_1:parameter("effect"):id())
      end
    end
  end
end

CameraTemplateManager.update = function(l_30_0, l_30_1, l_30_2)
  for index,cam_man in ipairs(l_30_0._camera_managers) do
    cam_man:update(l_30_1, l_30_2)
  end
end


