-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\units\corespawnsystem.luac 

if not CoreAiArea then
  CoreAiArea = class()
end
CoreAiArea.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0._unit = l_1_1
  l_1_0._spawn_point_index = 1
  l_1_0._obj = l_1_0._unit:get_object(Idstring(l_1_3))
  l_1_0._nav = Search:nav(l_1_2 .. l_1_3)
  l_1_0._nav:set_reference_object(l_1_0._obj)
  l_1_0._spawn_points = {}
  l_1_0:find_spawnpoints(l_1_4)
end

CoreAiArea.spawn = function(l_2_0, l_2_1, l_2_2)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  if l_2_2 ~= "" then
    do return end
  end
  if #l_2_0._spawn_points < l_2_0._spawn_point_index then
    return 
  end
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused at declaration of local variable

  l_2_0._spawn_point_index = l_2_0._spawn_point_index + 1
  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

     -- DECOMPILER ERROR: unhandled construct in 'if'

    if World:raycast("ray", l_2_0._unit:get_object(Idstring(l_2_2)):position() + l_2_0._unit:get_object(Idstring(l_2_2)):rotation():z() * 100, l_2_0._unit:get_object(Idstring(l_2_2)):position() - l_2_0._unit:get_object(Idstring(l_2_2)):rotation():z() * 500, "slot_mask", managers.slot:get_mask("statics")) and safe_spawn_unit(l_2_1, World:raycast("ray", l_2_0._unit:get_object(Idstring(l_2_2)):position() + l_2_0._unit:get_object(Idstring(l_2_2)):rotation():z() * 100, l_2_0._unit:get_object(Idstring(l_2_2)):position() - l_2_0._unit:get_object(Idstring(l_2_2)):rotation():z() * 500, "slot_mask", managers.slot:get_mask("statics")).position):base() ~= nil and safe_spawn_unit(l_2_1, World:raycast("ray", l_2_0._unit:get_object(Idstring(l_2_2)):position() + l_2_0._unit:get_object(Idstring(l_2_2)):rotation():z() * 100, l_2_0._unit:get_object(Idstring(l_2_2)):position() - l_2_0._unit:get_object(Idstring(l_2_2)):rotation():z() * 500, "slot_mask", managers.slot:get_mask("statics")).position):base().link ~= nil then
      safe_spawn_unit(l_2_1, World:raycast("ray", l_2_0._unit:get_object(Idstring(l_2_2)):position() + l_2_0._unit:get_object(Idstring(l_2_2)):rotation():z() * 100, l_2_0._unit:get_object(Idstring(l_2_2)):position() - l_2_0._unit:get_object(Idstring(l_2_2)):rotation():z() * 500, "slot_mask", managers.slot:get_mask("statics")).position):base():link(l_2_0._unit, l_2_0._obj, l_2_0._nav)
    end
    return safe_spawn_unit(l_2_1, World:raycast("ray", l_2_0._unit:get_object(Idstring(l_2_2)):position() + l_2_0._unit:get_object(Idstring(l_2_2)):rotation():z() * 100, l_2_0._unit:get_object(Idstring(l_2_2)):position() - l_2_0._unit:get_object(Idstring(l_2_2)):rotation():z() * 500, "slot_mask", managers.slot:get_mask("statics")).position)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CoreAiArea.find_spawnpoints = function(l_3_0, l_3_1)
  for point in l_3_1:children() do
    if point:name() == "ai_spawn_point" and point:parameter("name") ~= "" then
      local object = l_3_0._unit:get_object(Idstring(point:parameter("name")))
      if object ~= nil then
        cat_print("spawn_system", "[" .. l_3_0._unit:name() .. "] AI spawn point found: " .. point:parameter("name"))
        table.insert(l_3_0._spawn_points, object)
      end
    end
  end
end

if not CoreSpawnSystem then
  CoreSpawnSystem = class()
end
CoreSpawnSystem.init = function(l_4_0, l_4_1)
  l_4_0._unit = l_4_1
  l_4_0._post_init = false
  l_4_0._ai_surface_name = "surface_generic_spawner_"
  l_4_0._ai_spawn_areas = {}
  l_4_0:read_spawn_xml()
end

CoreSpawnSystem.get_linked_unit_list = function(l_5_0)
  local linked_unit_list = {}
  if l_5_0._linked_unit_map then
    for _,unit_map in pairs(l_5_0._linked_unit_map) do
      for _,unit in pairs(unit_map) do
        table.insert(linked_unit_list, unit)
      end
    end
  end
  return linked_unit_list
end

CoreSpawnSystem.destroy = function(l_6_0)
  if l_6_0._linked_unit_map then
    for _,unit_map in pairs(l_6_0._linked_unit_map) do
      for _,unit in pairs(unit_map) do
        if alive(unit) then
          cat_print("spawn_system", "[CoreSpawnSystem] Destroy unit: " .. unit:name())
          unit:set_slot(0)
        end
      end
    end
  end
end

CoreSpawnSystem.update = function(l_7_0, l_7_1, l_7_2, l_7_3)
  if l_7_0._delayed_var_and_cb_init then
    for lv2,unit in pairs(l_7_0._delayed_var_and_cb_init) do
      l_7_0:set_var_and_cb(unit, lv2)
    end
    l_7_0._delayed_var_and_cb_init = nil
  end
  l_7_0._unit:set_extension_update_enabled("spawn_system", false)
  l_7_0._post_init = true
end

CoreSpawnSystem.get_child_unit = function(l_8_0, l_8_1, l_8_2)
  if l_8_0._linked_unit_map then
    local unit_map = l_8_0._linked_unit_map[l_8_1]
    if unit_map then
      return unit_map[l_8_2]
    end
  end
  return nil
end

CoreSpawnSystem.init_ai_area = function(l_9_0, l_9_1, l_9_2)
  local object = l_9_0._unit:get_object(Idstring(l_9_1))
  if not l_9_0._ai_spawn_areas[object:name()] then
    l_9_0._ai_spawn_areas[object:name()] = CoreAiArea:new(l_9_0._unit, l_9_0._ai_surface_name, object:name(), l_9_2)
  end
end

CoreSpawnSystem.find_spawn_node = function(l_10_0, l_10_1)
  for spawn_node in l_10_1:children() do
    if spawn_node:name() == "spawn" then
      cat_print("spawn_system", "[CoreSpawnSystem] Found spawn node on: " .. l_10_0._unit:name())
      return spawn_node
    end
  end
  Application:error("[CoreSpawnSystem] Could not find spawn node on: " .. l_10_0._unit:name())
end

CoreSpawnSystem.set_var_and_cb_delayed = function(l_11_0, l_11_1, l_11_2)
  if not l_11_0._post_init then
    if not l_11_0._delayed_var_and_cb_init then
      l_11_0._delayed_var_and_cb_init = {}
    end
    l_11_0._delayed_var_and_cb_init[l_11_2] = l_11_1
  else
    l_11_0:set_var_and_cb(l_11_1, l_11_2)
  end
end

CoreSpawnSystem.set_var_and_cb = function(l_12_0, l_12_1, l_12_2)
  for lv3 in l_12_2:children() do
    if lv3:name() == "variables" and lv3:parameter("extension") ~= "" then
      cat_print("spawn_system", "Found variable block for: " .. lv3:parameter("extension"))
      for lv4 in lv3:children() do
        if lv4:name() == "var" and lv4:parameter("name") ~= "" and lv4:parameter("val") ~= "" then
          cat_print("spawn_system", "Set variable: " .. lv4:parameter("name") .. "='" .. tostring(lv4:parameter("val") .. "'"))
          local meta = getmetatable(l_12_1)
          local func = meta[lv3:parameter("extension")](l_12_1)
          func[lv4:parameter("name")] = lv4:parameter("val")
        end
      end
    end
  end
  for lv3 in l_12_2:children() do
    local lv3_name = lv3:parameter("name")
    if lv3:name() == "callback" and lv3_name ~= "" and lv3:parameter("extension") ~= "" then
      cat_print("spawn_system", "Building callback '" .. lv3_name .. "' in extension '" .. lv3:parameter("extension") .. "'.")
      local function_arg = {}
      for num_arg = 1, table.size(lv3:parameter_map()) - 2 do
        local key = "param" .. tostring(num_arg)
        if lv3:parameter(key) ~= "" then
          cat_print("spawn_system", "Found parameter: " .. key .. "=\"" .. tostring(lv3:parameter(key)) .. "\"")
          table.insert(function_arg, lv3:parameter(key))
        end
      end
      cat_print("spawn_system", "Call callback!")
      local meta = getmetatable(l_12_1)
      local func = meta[lv3:parameter("extension")](l_12_1)
      func[lv3_name](l_12_1:base(), unpack(function_arg))
    end
  end
end

CoreSpawnSystem.read_spawn_xml = function(l_13_0)
  local xml_data = l_13_0:find_spawn_node(PackageManager:unit_data(l_13_0._unit:name():id()):model_script_data())
  if xml_data then
    for lv1 in xml_data:children() do
      local lv1_element_name = lv1:name()
      local lv1_name = lv1:parameter("name")
      if lv1_element_name == "ai_area" and lv1_name ~= "" then
        cat_print("spawn_system", "[CoreSpawnSystem] AI area defined: " .. lv1_name)
        l_13_0:init_ai_area(lv1_name, lv1)
        for lv2 in lv1:children() do
          local lv2_name = lv2:parameter("name")
          if lv2:name() == "unit" and lv2_name ~= "" then
            cat_print("spawn_system", "[CoreSpawnSystem] Spawning unit: " .. lv2_name)
            local new_unit = l_13_0._ai_spawn_areas[lv1_name]:spawn(lv2_name, lv2:parameter("spawn_point"))
            if not l_13_0._linked_unit_map then
              l_13_0._linked_unit_map = {}
            end
            if not l_13_0._linked_unit_map[lv1_name] then
              local unit_map = {}
            end
            unit_map[lv2_name] = new_unit
            l_13_0._linked_unit_map[lv1_name] = unit_map
            l_13_0:set_var_and_cb_delayed(new_unit, lv2)
          end
        end
      end
      if lv1_element_name == "socket" and lv1_name ~= "" then
        for lv2 in lv1:children() do
          if lv2:name() == "unit" then
            if not l_13_0._enabled_unit_map then
              l_13_0._enabled_unit_map = {}
            end
            if not l_13_0._enabled_unit_map[lv1_name] then
              local unit_map = {}
            end
            local enabled = lv2:parameter("enabled") ~= "false"
            unit_map[lv2:parameter("name")] = enabled
            l_13_0._enabled_unit_map[lv1_name] = unit_map
            if enabled then
              l_13_0:setup_unit(lv1, lv2)
            end
          end
        end
      end
    end
  end
  if not l_13_0._delayed_var_and_cb_init then
    l_13_0._unit:set_extension_update_enabled("spawn_system", false)
    l_13_0._post_init = true
  end
end

CoreSpawnSystem.setup_unit = function(l_14_0, l_14_1, l_14_2)
  local lv1_name = l_14_1:parameter("name")
  local lv2_name = l_14_2:parameter("name")
  cat_print("spawn_system", "[CoreSpawnSystem] Spawn unit '" .. lv2_name .. "' in socket '" .. lv1_name .. "'.")
  local new_unit = nil
  local object = l_14_0._unit:get_object(Idstring(lv1_name))
  if MassUnitManager:can_spawn_unit(lv2_name) then
    cat_print("spawn_system", "Spawning mass unit!")
    new_unit = MassUnitManager:spawn_unit(lv2_name, object:position(), object:rotation())
  else
    new_unit = safe_spawn_unit(lv2_name:id(), object:position(), object:rotation())
  end
  if not l_14_0._linked_unit_map then
    l_14_0._linked_unit_map = {}
  end
  if not l_14_0._linked_unit_map[lv1_name] then
    local unit_map = {}
  end
  unit_map[lv2_name] = new_unit
  l_14_0._linked_unit_map[lv1_name] = unit_map
  if l_14_2:parameter("link_object") ~= "" then
    if new_unit:base() and new_unit:base().link then
      new_unit:base():link(l_14_0._unit, lv1_name, l_14_2:parameter("link_object"))
      if new_unit:base().link_object then
        for lv3 in l_14_2:children() do
          if lv3:name() == "object" and lv3:parameter("name") ~= "" and lv3:parameter("socket") ~= "" then
            new_unit:base():link_object(l_14_0._unit, lv3:parameter("socket"), lv3:parameter("name"))
          end
        end
      else
        l_14_0._unit:link(lv1_name, new_unit, l_14_2:parameter("link_object"))
        for lv3 in l_14_2:children() do
          local lv3_name = lv3:parameter("name")
          if lv3:name() == "object" and lv3:parameter("name") ~= "" and lv3:parameter("socket") ~= "" then
            local socket_object = l_14_0._unit:get_object(Idstring(lv3:parameter("socket")))
            new_unit:get_object(Idstring(lv3_name)):link(socket_object)
            new_unit:get_object(Idstring(lv3_name)):set_local_position(Vector3())
            new_unit:get_object(Idstring(lv3_name)):set_local_rotation(Rotation())
          end
        end
      else
        cat_print("spawn_system", "Spawning only! (No linking.)")
      end
    end
  end
  if not l_14_0._linked_unit_map then
    l_14_0._linked_unit_map = {}
  end
  if not l_14_0._linked_unit_map[lv1_name] then
    local unit_map = {}
  end
  unit_map[lv2_name] = new_unit
  l_14_0._linked_unit_map[lv1_name] = unit_map
  l_14_0:set_var_and_cb_delayed(new_unit, l_14_2)
end

CoreSpawnSystem.set_unit_enabled = function(l_15_0, l_15_1, l_15_2, l_15_3)
  local unit_map = l_15_0._enabled_unit_map[l_15_1]
  if unit_map then
    local was_enabled = unit_map[l_15_2]
    if was_enabled == nil then
      Application:error("Unable to set enabled state \"" .. tostring(l_15_3) .. "\" on unit name \"" .. tostring(l_15_2) .. "\" and socket name \"" .. tostring(l_15_1) .. "\". It doesn't exist.")
    else
      if not was_enabled ~= not l_15_3 then
        if l_15_3 then
          l_15_0:setup_unit(l_15_0:get_socket_nodes(l_15_1, l_15_2))
        else
          local unit = l_15_0._linked_unit_map[l_15_1][l_15_2]
          l_15_0._linked_unit_map[l_15_1][l_15_2] = nil
          if alive(unit) then
            unit:set_slot(0)
          end
        end
        unit_map[l_15_2] = l_15_3
      else
        Application:error("Unable to set enabled state \"" .. tostring(l_15_3) .. "\" on unit name \"" .. tostring(l_15_2) .. "\" and socket name \"" .. tostring(l_15_1) .. "\". It was either not disabled or it doesn't exist.")
      end
    end
  end
end

CoreSpawnSystem.get_socket_nodes = function(l_16_0, l_16_1, l_16_2)
  local xml_data = l_16_0:find_spawn_node(PackageManager:unit_data(l_16_0._unit:name():id()):model_script_data())
  if xml_data then
    for lv1 in xml_data:children() do
      local lv1_name = lv1:parameter("name")
      if lv1:name() == "socket" and lv1_name == l_16_1 then
        for lv2 in lv1:children() do
          local lv2_name = lv2:parameter("name")
          if lv2:name() == "unit" and lv2_name == l_16_2 then
            return lv1, lv2
          end
        end
      end
    end
  end
end


