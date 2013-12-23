-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\corecutsceneactordatabase.luac 

if not CoreCutsceneActorDatabase then
  CoreCutsceneActorDatabase = class()
end
if not CoreCutsceneActorDatabaseUnitTypeInfo then
  CoreCutsceneActorDatabaseUnitTypeInfo = class()
end
CoreCutsceneActorDatabase.unit_type_info = function(l_1_0, l_1_1)
  if l_1_1 and l_1_0._registered_unit_types then
    return l_1_0._registered_unit_types[l_1_1]
  end
end

CoreCutsceneActorDatabase.append_unit_info = function(l_2_0, l_2_1)
  if not l_2_0._registered_unit_types then
    l_2_0._registered_unit_types = {}
  end
  if not l_2_0._registered_unit_types[l_2_1:name()] then
    l_2_0._registered_unit_types[l_2_1:name()] = core_or_local("CutsceneActorDatabaseUnitTypeInfo", l_2_1:name())
  end
  l_2_0._registered_unit_types[l_2_1:name()]:_append_unit_info(l_2_1)
end

CoreCutsceneActorDatabaseUnitTypeInfo.init = function(l_3_0, l_3_1)
  l_3_0._unit_type = l_3_1
end

CoreCutsceneActorDatabaseUnitTypeInfo.unit_type = function(l_4_0)
  return l_4_0._unit_type
end

CoreCutsceneActorDatabaseUnitTypeInfo.object_names = function(l_5_0)
  if not l_5_0._object_names then
    return {}
  end
end

CoreCutsceneActorDatabaseUnitTypeInfo.initial_object_visibility = function(l_6_0, l_6_1)
  return l_6_0._object_visibilities and l_6_0._object_visibilities[l_6_1] or false
end

CoreCutsceneActorDatabaseUnitTypeInfo.extensions = function(l_7_0)
  if not l_7_0._extensions then
    return {}
  end
end

CoreCutsceneActorDatabaseUnitTypeInfo.animation_groups = function(l_8_0)
  if not l_8_0._animation_groups then
    return {}
  end
end

CoreCutsceneActorDatabaseUnitTypeInfo._append_unit_info = function(l_9_0, l_9_1)
  assert(l_9_0:unit_type() == l_9_1:name())
  if l_9_0._object_names == nil then
    l_9_0._object_names = table.collect(l_9_1:get_objects("*"), function(l_1_0)
    return l_1_0:name()
   end)
    table.sort(l_9_0._object_names, string.case_insensitive_compare)
    freeze(l_9_0._object_names)
  end
  if l_9_0._object_visibilities == nil then
    l_9_0._object_visibilities = table.remap(l_9_1:get_objects("*"), function(l_2_0, l_2_1)
    return l_2_1:name(), l_2_1.visibility and l_2_1:visibility() or nil
   end)
  end
  if l_9_0._extensions == nil then
    l_9_0._extensions = {}
    for _,extension_name in ipairs(l_9_1:extensions()) do
      if l_9_1[extension_name] then
        local extension = l_9_1[extension_name](l_9_1)
      end
      if extension then
        local methods = {}
        for key,value in pairs(getmetatable(extension)) do
          if type(value) == "function" and not string.begins(key, "_") and key ~= "new" and key ~= "init" then
            methods[key] = l_9_0:_argument_names_for_function(value)
          end
        end
        l_9_0._extensions[extension_name] = methods
      end
    end
    freeze(l_9_0._extensions)
  end
  if l_9_0._animation_groups == nil then
    l_9_0._animation_groups = l_9_1:anim_groups()
  end
  freeze(l_9_0)
end

CoreCutsceneActorDatabaseUnitTypeInfo._argument_names_for_function = function(l_10_0, l_10_1)
  if not Application:ews_enabled() then
    return {}
  end
  local argument_names = {}
  local info = debug.getinfo(l_10_1)
  local source_path = managers.database:base_path() .. info.source
  local file = SystemFS:open(source_path, "r")
  local func_definition = l_10_0:_file_line(file, info.linedefined)
  file:close()
  local arg_list = string.match(string.match(func_definition, "%b()") or "", "%((.+)%)")
  if not arg_list or not string.split(arg_list, "[,%s]") then
    return {}
  end
end

CoreCutsceneActorDatabaseUnitTypeInfo._file_line = function(l_11_0, l_11_1, l_11_2)
  repeat
    repeat
      if not l_11_1:at_end() then
        local text = l_11_1:gets()
        l_11_2 = l_11_2 - 1
      until l_11_2 == 0
      return text
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end


