-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\dev\editor\utils\coreeditorutils.luac 

core:module("CoreEditorUtils")
core:import("CoreEngineAccess")
core:import("CoreClass")
all_lights = function()
  local lights = {}
  local all_units = World:find_units_quick("all")
  for _,unit in ipairs(all_units) do
    for _,light in ipairs(unit:get_objects_by_type(Idstring("light"))) do
      table.insert(lights, light)
    end
  end
  return lights
end

get_editable_lights = function(l_2_0)
  local lights = {}
  local object_file = CoreEngineAccess._editor_unit_data(l_2_0:name():id()):model()
  if DB:has("object", object_file) then
    local node = DB:load_node("object", object_file)
  end
  if node then
    for child in node:children() do
      if child:name() == "lights" then
        for light in child:children() do
          if light:has_parameter("editable") and light:parameter("editable") == "true" then
            table.insert(lights, l_2_0:get_object(Idstring(light:parameter("name"))))
          end
        end
      end
    end
  end
  return lights
end

has_projection_light = function(l_3_0)
  local object_file = CoreEngineAccess._editor_unit_data(l_3_0:name():id()):model()
  if DB:has("object", object_file) then
    local node = DB:load_node("object", object_file)
  end
  if node then
    for child in node:children() do
      if child:name() == "lights" then
        for light in child:children() do
          if light:has_parameter("projection") and light:parameter("projection") == "true" then
            return light:parameter("name")
          end
        end
      end
    end
  end
  return nil
end

is_projection_light = function(l_4_0, l_4_1)
  local object_file = CoreEngineAccess._editor_unit_data(l_4_0:name():id()):model()
  if DB:has("object", object_file) then
    local node = DB:load_node("object", object_file)
  end
  if node then
    for child in node:children() do
      if child:name() == "lights" then
        for light_node in child:children() do
          if light_node:has_parameter("projection") and light_node:parameter("projection") == "true" and l_4_1:name() == Idstring(light_node:parameter("name")) then
            return true
          end
        end
      end
    end
  end
  return false
end

intensity_value = function()
  local t = {}
  for _,intensity in ipairs(LightIntensityDB:list()) do
    table.insert(t, LightIntensityDB:lookup(intensity))
  end
  table.sort(t)
  return t
end

INTENSITY_VALUES = intensity_value()
get_intensity_preset = function(l_6_0)
  local intensity = LightIntensityDB:reverse_lookup(l_6_0)
  if intensity:s() ~= "undefined" then
    return intensity
  end
  local intensity_values = INTENSITY_VALUES
  for i = 1, #intensity_values do
    local next = intensity_values[i + 1]
    local this = intensity_values[i]
    if not next then
      return LightIntensityDB:reverse_lookup(this)
    end
    if this < l_6_0 and l_6_0 < next then
      if l_6_0 - this < next - l_6_0 then
        return LightIntensityDB:reverse_lookup(this)
      else
        return LightIntensityDB:reverse_lookup(next)
      end
    elseif l_6_0 < this then
      return LightIntensityDB:reverse_lookup(this)
    end
  end
end
end

get_sequence_files_by_unit = function(l_7_0, l_7_1)
  _get_sequence_file(CoreEngineAccess._editor_unit_data(l_7_0:name()), l_7_1)
end

get_sequence_files_by_unit_name = function(l_8_0, l_8_1)
  _get_sequence_file(CoreEngineAccess._editor_unit_data(l_8_0), l_8_1)
end

_get_sequence_file = function(l_9_0, l_9_1)
  for _,unit_name in ipairs(l_9_0:unit_dependencies()) do
    self:_get_sequence_file(CoreEngineAccess._editor_unit_data(unit_name), l_9_1)
  end
  table.insert(l_9_1, l_9_0:sequence_manager_filename())
end

if not GrabInfo then
  GrabInfo = CoreClass.class()
end
GrabInfo.init = function(l_10_0, l_10_1)
  l_10_0._pos = l_10_1:position()
  l_10_0._rot = l_10_1:rotation()
end

GrabInfo.rotation = function(l_11_0)
  return l_11_0._rot
end

GrabInfo.position = function(l_12_0)
  return l_12_0._pos
end

if not layer_types then
  layer_types = {}
end
parse_layer_types = function()
    assert(DB:has("xml", "core/settings/editor_types"), "Editor type settings are missing from core settings.")
    local node = DB:load_node("xml", "core/settings/editor_types")
    for layer in node:children() do
      layer_types[layer:name()] = {}
      for type in layer:children() do
        table.insert(layer_types[layer:name()], type:parameter("value"))
      end
    end
    if DB:has("xml", "settings/editor_types") then
      local node = DB:load_node("xml", "settings/editor_types")
      for layer in node:children() do
        layer_types[layer:name()] = {}
        for type in layer:children() do
          table.insert(layer_types[layer:name()], type:parameter("value"))
        end
      end
    end
   end
layer_type = function(l_14_0)
  return layer_types[l_14_0]
end

get_layer_types = function()
  return layer_types
end

toolbar_toggle = function(l_16_0, l_16_1)
  local c = l_16_0.class
  local toolbar = c[l_16_0.toolbar]
  c[l_16_0.value] = toolbar:tool_state(l_16_1:get_id())
  if c[l_16_0.menu] then
    c[l_16_0.menu]:set_checked(l_16_1:get_id(), c[l_16_0.value])
  end
end

toolbar_toggle_trg = function(l_17_0)
  local c = l_17_0.class
  local toolbar = c[l_17_0.toolbar]
  toolbar:set_tool_state(l_17_0.id, not toolbar:tool_state(l_17_0.id))
  c[l_17_0.value] = toolbar:tool_state(l_17_0.id)
  if c[l_17_0.menu] then
    c[l_17_0.menu]:set_checked(l_17_0.id, c[l_17_0.value])
  end
end

dump_mesh = function(l_18_0, l_18_1, l_18_2)
  if not l_18_1 then
    l_18_1 = "dump_mesh"
  end
  if not l_18_2 then
    l_18_2 = "g_*"
  end
  if not l_18_0 then
    l_18_0 = World:find_units_quick("all", managers.slot:get_mask("dump_mesh"))
  end
  local objects = {}
  local lods = {"e", "_e", "d", "_d", "c", "_c", "b", "_b", "a", "_a"}
  cat_print("editor", "Starting dump mesh")
  cat_print("editor", "  Dumping from " .. #l_18_0 .. " units")
  for _,u in ipairs(l_18_0) do
    local i = 1
    local objs = {}
    if #objs == 0 then
      cat_print("editor", "getting gfx instead of lod for unit " .. u:name():s())
      objs = u:get_objects(l_18_2)
    end
    cat_print("editor", "insert objs", #objs)
    for _,o in ipairs(objs) do
      cat_print("editor", "    " .. o:name():s())
      table.insert(objects, o)
    end
    objs = u:get_objects("gfx_*")
    cat_print("editor", "insert objs", #objs)
    for _,o in ipairs(objs) do
      cat_print("editor", "    " .. o:name():s())
      table.insert(objects, o)
    end
  end
  cat_print("editor", "  Dumped " .. #objects .. " objects")
  MeshDumper:dump_meshes(managers.database:root_path() .. l_18_1, objects, Rotation(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, -1, 0)))
end

dump_all = function(l_19_0, l_19_1, l_19_2)
  if not l_19_1 then
    l_19_1 = "all_dumped"
  end
  if not l_19_2 then
    l_19_2 = "g_*"
  end
  if not l_19_0 then
    l_19_0 = World:find_units_quick("all", managers.slot:get_mask("dump_all"))
  end
  local objects = {}
  cat_print("editor", "Starting dump mesh")
  cat_print("editor", "  Dumping from " .. #l_19_0 .. " units")
  for _,u in ipairs(l_19_0) do
    local objs = {}
    local all_objs = u:get_objects("g_*")
    for i = 5, 0, -1 do
      for _,o in ipairs(all_objs) do
        if string.match(o:name():s(), "lod" .. i) then
          cat_print("editor", "insert obj", o:name():s())
          table.insert(objs, o)
      else
        end
      end
      if #objs > 0 then
        cat_print("editor", "enough lods, time to break")
    else
      end
    end
    if #objs == 0 then
      cat_print("editor", "getting gfx instead of lod for unit " .. u:name():s())
      objs = u:get_objects(l_19_2)
      if #objs == 0 then
        objs = u:get_objects("gfx_*")
      end
    end
    cat_print("editor", "insert objs", #objs, "from unit", u:name():s())
    for _,o in ipairs(objs) do
      cat_print("editor", "    " .. o:name():s())
      table.insert(objects, o)
    end
  end
  cat_print("editor", "  Starting dump of " .. #objects .. " objects...")
  MeshDumper:dump_meshes(managers.database:root_path() .. l_19_1, objects, Rotation(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, -1, 0)))
  cat_print("editor", "  .. dumping done.")
end


