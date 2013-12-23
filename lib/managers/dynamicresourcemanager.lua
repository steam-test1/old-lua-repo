-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dynamicresourcemanager.luac 

if not DynamicResourceManager then
  DynamicResourceManager = class()
end
DynamicResourceManager.DYN_RESOURCES_PACKAGE = "packages/dyn_resources"
DynamicResourceManager.init = function(l_1_0)
  if not Global.dyn_resource_manager_data then
    l_1_0._dyn_resources = {}
  end
  Global.dyn_resource_manager_data = l_1_0._dyn_resources
  l_1_0._to_unload = nil
end

DynamicResourceManager.update = function(l_2_0)
  if l_2_0._to_unload then
    for _,unload_params in ipairs(l_2_0._to_unload) do
      PackageManager:package(unload_params.package_name):unload_resource(unload_params.resource_type, unload_params.resource_name, unload_params.keep_using)
    end
    l_2_0._to_unload = nil
  end
end

DynamicResourceManager.is_ready_to_close = function(l_3_0)
  return not l_3_0._to_unload
end

DynamicResourceManager.load = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  local resource_type_key = l_4_1:key()
  local resource_name_key = l_4_2:key()
  for _package_name,resource_types in pairs(l_4_0._dyn_resources) do
    if _package_name ~= l_4_3 and resource_types[resource_type_key] then
      for _resource_name,ref_count in pairs(resource_types[resource_type_key]) do
        if _resource_name == resource_name_key then
          debug_pause("[DynamicResourceManager:load] resource ", l_4_2 .. "." .. l_4_1, "already loaded in", _package_name)
          return 
        end
      end
    end
  end
  if not l_4_0._dyn_resources[l_4_3] then
    l_4_0._dyn_resources[l_4_3] = {}
  end
  if not l_4_0._dyn_resources[l_4_3][resource_type_key] then
    l_4_0._dyn_resources[l_4_3][resource_type_key] = {}
  end
  local ref_count = 1 + (l_4_0._dyn_resources[l_4_3][resource_type_key][resource_name_key] or 0)
  l_4_0._dyn_resources[l_4_3][resource_type_key][resource_name_key] = ref_count
  if ref_count == 1 then
    local needs_loading = true
    if l_4_0._to_unload then
      for i,unload_params in ipairs(l_4_0._to_unload) do
        if unload_params.package_name == l_4_3 and unload_params.resource_type == l_4_1 and unload_params.resource_name == l_4_2 then
          needs_loading = false
          table.remove(l_4_0._to_unload, i)
          if not next(l_4_0._to_unload) then
            l_4_0._to_unload = nil
        else
          end
        end
      end
      if needs_loading then
        PackageManager:package(l_4_3):load_temp_resource(l_4_1, l_4_2, l_4_4)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

DynamicResourceManager.unload = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4)
  local resource_type_key = l_5_1:key()
  local resource_name_key = l_5_2:key()
  if not l_5_0._dyn_resources[l_5_3] then
    debug_pause("[DynamicResourceManager:unload]", l_5_1, l_5_2, l_5_3, ".\npackage has no dynamic resources")
    return 
  end
  if not l_5_0._dyn_resources[l_5_3][resource_type_key] then
    debug_pause("[DynamicResourceManager:unload]", l_5_1, l_5_2, l_5_3, ".\n no dynamic resources of this type")
    return 
  end
  if not l_5_0._dyn_resources[l_5_3][resource_type_key][resource_name_key] then
    debug_pause("[DynamicResourceManager:unload]", l_5_1, l_5_2, l_5_3, ".\n no dynamic resources of this name")
    return 
  end
  local ref_count = l_5_0._dyn_resources[l_5_3][resource_type_key][resource_name_key] - 1
  if ref_count == 0 then
    l_5_0._dyn_resources[l_5_3][resource_type_key][resource_name_key] = nil
    if not next(l_5_0._dyn_resources[l_5_3][resource_type_key]) then
      l_5_0._dyn_resources[l_5_3][resource_type_key] = nil
      if not next(l_5_0._dyn_resources[l_5_3]) then
        l_5_0._dyn_resources[l_5_3] = nil
      end
    end
    if not l_5_0._to_unload then
      l_5_0._to_unload = {}
    end
    table.insert(l_5_0._to_unload, {package_name = l_5_3, resource_type = l_5_1, resource_name = l_5_2, keep_using = l_5_4})
  else
    l_5_0._dyn_resources[l_5_3][resource_type_key][resource_name_key] = ref_count
  end
end

DynamicResourceManager.has_resource = function(l_6_0, l_6_1, l_6_2, l_6_3)
  local resource_type_key = l_6_1:key()
  local resource_name_key = l_6_2:key()
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end


