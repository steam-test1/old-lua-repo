-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\weaponfactorymanager.luac 

local ids_unit = Idstring("unit")
if not WeaponFactoryManager then
  WeaponFactoryManager = class()
end
WeaponFactoryManager.init = function(l_1_0)
  l_1_0:_setup()
  l_1_0._tasks = {}
  l_1_0._uses_tasks = true
end

WeaponFactoryManager._setup = function(l_2_0)
  if not Global.weapon_factory then
    Global.weapon_factory = {}
  end
  l_2_0._global = Global.weapon_factory
  if not Global.weapon_factory.loaded_packages then
    Global.weapon_factory.loaded_packages = {}
  end
  l_2_0._loaded_packages = Global.weapon_factory.loaded_packages
  l_2_0:_read_factory_data()
end

WeaponFactoryManager.update = function(l_3_0, l_3_1, l_3_2)
  if l_3_0._active_task and l_3_0:_update_task(l_3_0._active_task) then
    l_3_0._active_task = nil
    l_3_0:_check_task()
    do return end
    if next(l_3_0._tasks) then
      l_3_0:_check_task()
    end
  end
end

WeaponFactoryManager._read_factory_data = function(l_4_0)
  l_4_0._parts_by_type = {}
  for id,data in pairs(tweak_data.weapon.factory.parts) do
    if not l_4_0._parts_by_type[data.type] then
      l_4_0._parts_by_type[data.type] = {}
    end
    l_4_0._parts_by_type[data.type][id] = true
  end
  l_4_0._parts_by_weapon = {}
  l_4_0._part_used_by_weapons = {}
  for factory_id,data in pairs(tweak_data.weapon.factory) do
    if factory_id ~= "parts" then
      if not l_4_0._parts_by_weapon[factory_id] then
        l_4_0._parts_by_weapon[factory_id] = {}
      end
      for _,part_id in ipairs(data.uses_parts) do
        local type = tweak_data.weapon.factory.parts[part_id].type
        if not l_4_0._parts_by_weapon[factory_id][type] then
          l_4_0._parts_by_weapon[factory_id][type] = {}
        end
        table.insert(l_4_0._parts_by_weapon[factory_id][type], part_id)
        if not string.match(factory_id, "_npc") then
          if not l_4_0._part_used_by_weapons[part_id] then
            l_4_0._part_used_by_weapons[part_id] = {}
          end
          table.insert(l_4_0._part_used_by_weapons[part_id], factory_id)
        end
      end
    end
  end
end

WeaponFactoryManager.get_weapons_uses_part = function(l_5_0, l_5_1)
  return l_5_0._part_used_by_weapons[l_5_1]
end

WeaponFactoryManager.get_weapon_id_by_factory_id = function(l_6_0, l_6_1)
  local upgrade = managers.upgrades:weapon_upgrade_by_factory_id(l_6_1)
  if not upgrade then
    Application:error("[WeaponFactoryManager:get_weapon_id_by_factory_id] Found no upgrade for factory id", l_6_1)
    return 
  end
  return upgrade.weapon_id
end

WeaponFactoryManager.get_weapon_name_by_factory_id = function(l_7_0, l_7_1)
  local upgrade = managers.upgrades:weapon_upgrade_by_factory_id(l_7_1)
  if not upgrade then
    Application:error("[WeaponFactoryManager:get_weapon_name_by_factory_id] Found no upgrade for factory id", l_7_1)
    return 
  end
  local weapon_id = upgrade.weapon_id
  return managers.localization:text(tweak_data.weapon[weapon_id].name_id)
end

WeaponFactoryManager.get_factory_id_by_weapon_id = function(l_8_0, l_8_1)
  local upgrade = managers.upgrades:weapon_upgrade_by_weapon_id(l_8_1)
  if not upgrade then
    Application:error("[WeaponFactoryManager:get_factory_id_by_weapon_id] Found no upgrade for factory id", l_8_1)
    return 
  end
  return upgrade.factory_id
end

WeaponFactoryManager.get_default_blueprint_by_factory_id = function(l_9_0, l_9_1)
  return tweak_data.weapon.factory[l_9_1].default_blueprint
end

WeaponFactoryManager.create_limited_blueprints = function(l_10_0, l_10_1)
  local i_table = l_10_0:_indexed_parts(l_10_1)
  local all_parts_used_once = {}
  for j = 1, #i_table do
    for k = j == 1 and 1 or 2, #i_table[j].parts do
      local perm = {}
      local part = i_table[j].parts[k]
      if part ~= "" then
        table.insert(perm, i_table[j].parts[k])
      end
      for l = 1, #i_table do
        if j ~= l then
          local part = i_table[l].parts[1]
          if part ~= "" then
            table.insert(perm, i_table[l].parts[1])
          end
        end
      end
      table.insert(all_parts_used_once, perm)
    end
  end
  print("Limited", #all_parts_used_once)
  return all_parts_used_once
end

WeaponFactoryManager.create_blueprints = function(l_11_0, l_11_1)
  local i_table = l_11_0:_indexed_parts(l_11_1)
  local dump = function(l_1_0, l_1_1, l_1_2)
    for i_pryl,pryl_name in ipairs(i_table[l_1_0].parts) do
      local new_combination = clone(l_1_2)
      if pryl_name ~= "" then
        table.insert(new_combination, pryl_name)
      end
      if l_1_0 == #i_table then
        table.insert(l_1_1, new_combination)
        for (for control),i_pryl in (for generator) do
        end
        dump(l_1_0 + 1, l_1_1, new_combination)
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  local result = {}
  dump(1, result, {})
  print("Combinations", #result)
  return result
end

WeaponFactoryManager._indexed_parts = function(l_12_0, l_12_1)
  local i_table = {}
  local all_parts = l_12_0._parts_by_weapon[l_12_1]
  if not tweak_data.weapon.factory[l_12_1].optional_types then
    local optional_types = {}
  end
  local num_variations = 1
  local tot_parts = 0
  for type,parts in pairs(all_parts) do
    print(type, parts)
    if type ~= "foregrip_ext" and type ~= "stock_adapter" and type ~= "sight_special" and type ~= "extra" then
      parts = clone(parts)
      if table.contains(optional_types, type) then
        table.insert(parts, "")
      end
      table.insert(i_table, {parts = parts, i = 1, amount = #parts})
      num_variations = num_variations * #parts
      tot_parts = tot_parts + #parts
    end
  end
  print("num_variations", num_variations, "tot_parts", tot_parts)
  return i_table
end

WeaponFactoryManager._check_task = function(l_13_0)
  if not l_13_0._active_task and #l_13_0._tasks > 0 then
    l_13_0._active_task = table.remove(l_13_0._tasks, 1)
    if not alive(l_13_0._active_task.p_unit) then
      l_13_0._active_task = nil
      l_13_0:_check_task()
    end
  end
end

WeaponFactoryManager.preload_blueprint = function(l_14_0, l_14_1, l_14_2, l_14_3, l_14_4, l_14_5)
  return l_14_0:_preload_blueprint(l_14_1, l_14_2, l_14_3, l_14_4, l_14_5)
end

WeaponFactoryManager._preload_blueprint = function(l_15_0, l_15_1, l_15_2, l_15_3, l_15_4, l_15_5)
  if not l_15_4 then
    Application:error("[WeaponFactoryManager] _preload_blueprint(): No done_cb!", "factory_id: " .. l_15_1, "blueprint: " .. inspect(l_15_2))
    Application:stack_dump()
  end
  local factory = tweak_data.weapon.factory
  local factory_weapon = factory[l_15_1]
  local forbidden = l_15_0:_get_forbidden_parts(l_15_1, l_15_2)
  return l_15_0:_preload_parts(l_15_1, factory_weapon, l_15_2, forbidden, l_15_3, l_15_4, l_15_5)
end

WeaponFactoryManager._preload_parts = function(l_16_0, l_16_1, l_16_2, l_16_3, l_16_4, l_16_5, l_16_6, l_16_7)
  if not l_16_0._tasks then
    l_16_0._tasks = {}
  end
  local parts = {}
  local need_parent = {}
  local override = l_16_0:_get_override_parts(l_16_1, l_16_3)
  for _,part_id in ipairs(l_16_3) do
    l_16_0:_preload_part(l_16_1, part_id, l_16_4, override, parts, l_16_5, need_parent, l_16_7)
  end
  for _,part_id in ipairs(need_parent) do
    l_16_0:_preload_part(l_16_1, part_id, l_16_4, override, parts, l_16_5, need_parent, l_16_7)
  end
  l_16_6(parts, l_16_3)
  return parts, l_16_3
end

WeaponFactoryManager._preload_part = function(l_17_0, l_17_1, l_17_2, l_17_3, l_17_4, l_17_5, l_17_6, l_17_7, l_17_8)
  if l_17_3[l_17_2] then
    return 
  end
  local factory = tweak_data.weapon.factory
  local part = l_17_0:_part_data(l_17_2, l_17_1, l_17_4)
  if factory[l_17_1].adds and factory[l_17_1].adds[l_17_2] then
    for _,add_id in ipairs(factory[l_17_1].adds[l_17_2]) do
      l_17_0:_preload_part(l_17_1, add_id, l_17_3, l_17_4, l_17_5, l_17_6, l_17_7, l_17_8)
    end
  end
  if part.adds_type then
    for _,add_type in ipairs(part.adds_type) do
      local add_id = factory[l_17_1][add_type]
      l_17_0:_preload_part(l_17_1, add_id, l_17_3, l_17_4, l_17_5, l_17_6, l_17_7, l_17_8)
    end
  end
  if part.adds then
    for _,add_id in ipairs(part.adds) do
      l_17_0:_preload_part(l_17_1, add_id, l_17_3, l_17_4, l_17_5, l_17_6, l_17_7, l_17_8)
    end
  end
  if l_17_5[l_17_2] then
    return 
  end
  if part.parent and not l_17_0:get_part_from_weapon_by_type(part.parent, l_17_5) then
    table.insert(l_17_7, l_17_2)
    return 
  end
  if not l_17_6 or not part.third_unit then
    local unit_name = part.unit
  end
  local ids_unit_name = (Idstring(unit_name))
  local package = nil
  if not l_17_6 then
    package = "packages/fps_weapon_parts/" .. l_17_2
    if DB:has(Idstring("package"), Idstring(package)) then
      l_17_5[l_17_2] = {package = package}
      if not l_17_8 then
        l_17_0:load_package(l_17_5[l_17_2].package)
      else
        Application:error("Expected weapon part packages for", l_17_2)
        package = nil
      end
    end
    if not package then
      l_17_5[l_17_2] = {ids_unit, ids_unit_name, "packages/dyn_resources", false}
      if not l_17_8 then
        managers.dyn_resource:load(unpack(l_17_5[l_17_2]))
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

WeaponFactoryManager.assemble_default = function(l_18_0, l_18_1, l_18_2, l_18_3, l_18_4, l_18_5)
  local blueprint = clone(tweak_data.weapon.factory[l_18_1].default_blueprint)
  return l_18_0:_assemble(l_18_1, l_18_2, blueprint, l_18_3, l_18_4, l_18_5), blueprint
end

WeaponFactoryManager.assemble_from_blueprint = function(l_19_0, l_19_1, l_19_2, l_19_3, l_19_4, l_19_5, l_19_6)
  return l_19_0:_assemble(l_19_1, l_19_2, l_19_3, l_19_4, l_19_5, l_19_6)
end

WeaponFactoryManager._assemble = function(l_20_0, l_20_1, l_20_2, l_20_3, l_20_4, l_20_5, l_20_6)
  if not l_20_5 then
    Application:error("-----------------------------")
    Application:stack_dump()
  end
  local factory = tweak_data.weapon.factory
  local factory_weapon = factory[l_20_1]
  local forbidden = l_20_0:_get_forbidden_parts(l_20_1, l_20_3)
  return l_20_0:_add_parts(l_20_2, l_20_1, factory_weapon, l_20_3, forbidden, l_20_4, l_20_5, l_20_6)
end

WeaponFactoryManager._get_forbidden_parts = function(l_21_0, l_21_1, l_21_2)
  local factory = tweak_data.weapon.factory
  local forbidden = {}
  for _,part_id in ipairs(l_21_2) do
    local part = l_21_0:_part_data(part_id, l_21_1)
    if part.forbids then
      for _,forbidden_id in ipairs(part.forbids) do
        forbidden[forbidden_id] = true
      end
    end
  end
  return forbidden
end

WeaponFactoryManager._get_override_parts = function(l_22_0, l_22_1, l_22_2)
  local factory = tweak_data.weapon.factory
  local overridden = {}
  for _,part_id in ipairs(l_22_2) do
    local part = l_22_0:_part_data(part_id, l_22_1)
    if part.override then
      for override_id,override_data in pairs(part.override) do
        overridden[override_id] = override_data
      end
    end
  end
  return overridden
end

WeaponFactoryManager._update_task = function(l_23_0, l_23_1)
  if not alive(l_23_1.p_unit) then
    return true
  end
  if l_23_1.blueprint_i <= #l_23_1.blueprint then
    local part_id = l_23_1.blueprint[l_23_1.blueprint_i]
    l_23_0:_add_part(l_23_1.p_unit, l_23_1.factory_id, part_id, l_23_1.forbidden, l_23_1.override, l_23_1.parts, l_23_1.third_person, l_23_1.need_parent)
    l_23_1.blueprint_i = l_23_1.blueprint_i + 1
    return 
  end
  if l_23_1.need_parent_i <= #l_23_1.need_parent then
    local part_id = l_23_1.need_parent[l_23_1.need_parent_i]
    l_23_0:_add_part(l_23_1.p_unit, l_23_1.factory_id, part_id, l_23_1.forbidden, l_23_1.override, l_23_1.parts, l_23_1.third_person, l_23_1.need_parent)
    l_23_1.need_parent_i = l_23_1.need_parent_i + 1
    return 
  end
  print("WeaponFactoryManager:_update_task done")
  l_23_1.done_cb(l_23_1.parts, l_23_1.blueprint)
  return true
end

WeaponFactoryManager._add_parts = function(l_24_0, l_24_1, l_24_2, l_24_3, l_24_4, l_24_5, l_24_6, l_24_7, l_24_8)
  if not l_24_0._tasks then
    l_24_0._tasks = {}
  end
  local parts = {}
  local need_parent = {}
  local override = l_24_0:_get_override_parts(l_24_2, l_24_4)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  if l_24_0._uses_tasks and not l_24_8 then
    table.insert(l_24_0._tasks, {done_cb = l_24_7, p_unit = l_24_1, factory_id = l_24_2, blueprint = l_24_4, blueprint_i = 1, forbidden = l_24_5})
    {done_cb = l_24_7, p_unit = l_24_1, factory_id = l_24_2, blueprint = l_24_4, blueprint_i = 1, forbidden = l_24_5}.override, {done_cb = l_24_7, p_unit = l_24_1, factory_id = l_24_2, blueprint = l_24_4, blueprint_i = 1, forbidden = l_24_5}.need_parent_i, {done_cb = l_24_7, p_unit = l_24_1, factory_id = l_24_2, blueprint = l_24_4, blueprint_i = 1, forbidden = l_24_5}.need_parent, {done_cb = l_24_7, p_unit = l_24_1, factory_id = l_24_2, blueprint = l_24_4, blueprint_i = 1, forbidden = l_24_5}.parts, {done_cb = l_24_7, p_unit = l_24_1, factory_id = l_24_2, blueprint = l_24_4, blueprint_i = 1, forbidden = l_24_5}.third_person = override, 1, need_parent, parts, l_24_6
  else
    for _,part_id in ipairs(l_24_4) do
      l_24_0:_add_part(l_24_1, l_24_2, part_id, l_24_5, override, parts, l_24_6, need_parent)
    end
    for _,part_id in ipairs(need_parent) do
      l_24_0:_add_part(l_24_1, l_24_2, part_id, l_24_5, override, parts, l_24_6, need_parent)
    end
    l_24_7(parts, l_24_4)
  end
  return parts, l_24_4
end

WeaponFactoryManager._part_data = function(l_25_0, l_25_1, l_25_2, l_25_3)
  local factory = tweak_data.weapon.factory
  local part = deep_clone(factory.parts[l_25_1])
  if factory[l_25_2].override and factory[l_25_2].override[l_25_1] then
    for d,v in pairs(factory[l_25_2].override[l_25_1]) do
      part[d] = v
    end
  end
  if l_25_3 and l_25_3[l_25_1] then
    for d,v in pairs(l_25_3[l_25_1]) do
      part[d] = v
    end
  end
  return part
end

WeaponFactoryManager._add_part = function(l_26_0, l_26_1, l_26_2, l_26_3, l_26_4, l_26_5, l_26_6, l_26_7, l_26_8)
  if l_26_4[l_26_3] then
    return 
  end
  local factory = tweak_data.weapon.factory
  local part = l_26_0:_part_data(l_26_3, l_26_2, l_26_5)
  if factory[l_26_2].adds and factory[l_26_2].adds[l_26_3] then
    for _,add_id in ipairs(factory[l_26_2].adds[l_26_3]) do
      l_26_0:_add_part(l_26_1, l_26_2, add_id, l_26_4, l_26_5, l_26_6, l_26_7, l_26_8)
    end
  end
  if part.adds_type then
    for _,add_type in ipairs(part.adds_type) do
      local add_id = factory[l_26_2][add_type]
      l_26_0:_add_part(l_26_1, l_26_2, add_id, l_26_4, l_26_5, l_26_6, l_26_7, l_26_8)
    end
  end
  if part.adds then
    for _,add_id in ipairs(part.adds) do
      l_26_0:_add_part(l_26_1, l_26_2, add_id, l_26_4, l_26_5, l_26_6, l_26_7, l_26_8)
    end
  end
  if l_26_6[l_26_3] then
    return 
  end
  local link_to_unit = l_26_1
  if part.parent then
    local parent_part = l_26_0:get_part_from_weapon_by_type(part.parent, l_26_6)
    if parent_part then
      link_to_unit = parent_part.unit
    else
      table.insert(l_26_8, l_26_3)
      return 
    end
    if not l_26_7 or not part.third_unit then
      local unit_name = part.unit
    end
    local ids_unit_name = (Idstring(unit_name))
    local package = nil
    if not l_26_7 then
      package = "packages/fps_weapon_parts/" .. l_26_3
      if DB:has(Idstring("package"), Idstring(package)) then
        print("HAS PART AS PACKAGE")
        l_26_0:load_package(package)
      else
        Application:error("Expected weapon part packages for", l_26_3)
        package = nil
      end
      if not package then
        managers.dyn_resource:load(ids_unit, ids_unit_name, "packages/dyn_resources", false)
      end
      local u_name = Idstring(unit_name)
      local unit = World:spawn_unit(u_name, Vector3(), Rotation())
      do
        local res = link_to_unit:link(Idstring(part.a_obj), unit, unit:orientation_object():name())
        if managers.occlusion and not l_26_7 then
          managers.occlusion:remove_occlusion(unit)
        end
        l_26_6[l_26_3] = {unit = unit, animations = part.animations, name = u_name, package = package}
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

WeaponFactoryManager.load_package = function(l_27_0, l_27_1)
  print("WeaponFactoryManager:_load_package", l_27_1)
  if not l_27_0._loaded_packages[l_27_1] then
    print("  Load for real", l_27_1)
    PackageManager:load(l_27_1)
    l_27_0._loaded_packages[l_27_1] = 1
  else
    l_27_0._loaded_packages[l_27_1] = l_27_0._loaded_packages[l_27_1] + 1
  end
end

WeaponFactoryManager.unload_package = function(l_28_0, l_28_1)
  print("WeaponFactoryManager:_unload_package", l_28_1)
  if not l_28_0._loaded_packages[l_28_1] then
    Application:error("Trying to unload package that wasn't loaded")
    return 
  end
  l_28_0._loaded_packages[l_28_1] = l_28_0._loaded_packages[l_28_1] - 1
  if l_28_0._loaded_packages[l_28_1] <= 0 then
    print("  Unload for real", l_28_1)
    PackageManager:unload(l_28_1)
    l_28_0._loaded_packages[l_28_1] = nil
  end
end

WeaponFactoryManager.get_part_from_weapon_by_type = function(l_29_0, l_29_1, l_29_2)
  local factory = tweak_data.weapon.factory
  for id,data in pairs(l_29_2) do
    if factory.parts[id].type == l_29_1 then
      return l_29_2[id]
    end
  end
  return false
end

WeaponFactoryManager.get_parts_from_factory_id = function(l_30_0, l_30_1)
  return l_30_0._parts_by_weapon[l_30_1]
end

WeaponFactoryManager.get_parts_from_weapon_id = function(l_31_0, l_31_1)
  local factory_id = l_31_0:get_factory_id_by_weapon_id(l_31_1)
  return l_31_0._parts_by_weapon[factory_id]
end

WeaponFactoryManager.get_part_name_by_part_id = function(l_32_0, l_32_1)
  local part_tweak_data = tweak_data.weapon.factory.parts[l_32_1]
  if not part_tweak_data then
    Application:error("[WeaponFactoryManager:get_part_name_by_part_id] Found no part with part id", l_32_1)
    return 
  end
  return managers.localization:text(part_tweak_data.name_id)
end

WeaponFactoryManager.change_part = function(l_33_0, l_33_1, l_33_2, l_33_3, l_33_4, l_33_5)
  local factory = tweak_data.weapon.factory
  local part = factory.parts[l_33_3]
  if not part then
    Application:error("WeaponFactoryManager:change_part Part", l_33_3, "doesn't exist!")
    return l_33_4
  end
  local type = part.type
  if l_33_0._parts_by_weapon[l_33_2][type] then
    if table.contains(l_33_0._parts_by_weapon[l_33_2][type], l_33_3) then
      for rem_id,rem_data in pairs(l_33_4) do
        if factory.parts[rem_id].type == type then
          table.delete(l_33_5, rem_id)
      else
        end
      end
      table.insert(l_33_5, l_33_3)
      l_33_0:disassemble(l_33_4)
      return l_33_0:assemble_from_blueprint(l_33_2, l_33_1, l_33_5)
    else
      Application:error("WeaponFactoryManager:change_part Part", l_33_3, "not allowed for weapon", l_33_2, "!")
    end
  else
    Application:error("WeaponFactoryManager:change_part Part", l_33_3, "not allowed for weapon", l_33_2, "!")
  end
  return l_33_4
end

WeaponFactoryManager.remove_part_from_blueprint = function(l_34_0, l_34_1, l_34_2)
  local factory = tweak_data.weapon.factory
  local part = factory.parts[l_34_1]
  if not part then
    Application:error("WeaponFactoryManager:remove_part_from_blueprint Part", l_34_1, "doesn't exist!")
    return 
  end
  table.delete(l_34_2, l_34_1)
end

WeaponFactoryManager.change_part_blueprint_only = function(l_35_0, l_35_1, l_35_2, l_35_3)
  local factory = tweak_data.weapon.factory
  local part = factory.parts[l_35_2]
  if not part then
    Application:error("WeaponFactoryManager:change_part Part", l_35_2, " doesn't exist!")
    return false
  end
  local type = part.type
  if l_35_0._parts_by_weapon[l_35_1][type] then
    if table.contains(l_35_0._parts_by_weapon[l_35_1][type], l_35_2) then
      for _,rem_id in ipairs(l_35_3) do
        if factory.parts[rem_id].type == type then
          table.delete(l_35_3, rem_id)
      else
        end
      end
      table.insert(l_35_3, l_35_2)
      if not WeaponFactoryManager:_get_forbidden_parts(l_35_1, l_35_3) then
        local forbidden = {}
      end
      for _,rem_id in ipairs(l_35_3) do
        if forbidden[rem_id] then
          table.delete(l_35_3, rem_id)
        end
      end
      return true
    else
      Application:error("WeaponFactoryManager:change_part Part", l_35_2, "not allowed for weapon", l_35_1, "!")
    end
  else
    Application:error("WeaponFactoryManager:change_part Part", l_35_2, "not allowed for weapon", l_35_1, "!")
  end
  return false
end

WeaponFactoryManager.get_replaces_parts = function(l_36_0, l_36_1, l_36_2, l_36_3)
  local factory = tweak_data.weapon.factory
  local part = factory.parts[l_36_2]
  if not part then
    Application:error("WeaponFactoryManager:change_part Part", l_36_2, " doesn't exist!")
    return nil
  end
  local replaces = {}
  local type = part.type
  if l_36_0._parts_by_weapon[l_36_1][type] then
    if table.contains(l_36_0._parts_by_weapon[l_36_1][type], l_36_2) then
      for _,rep_id in ipairs(l_36_3) do
        if factory.parts[rep_id].type == type then
          table.insert(replaces, rep_id)
      else
        end
      end
    else
      Application:error("WeaponFactoryManager:check_replaces_part Part", l_36_2, "not allowed for weapon", l_36_1, "!")
    end
  else
    Application:error("WeaponFactoryManager:check_replaces_part Part", l_36_2, "not allowed for weapon", l_36_1, "!")
  end
end
return replaces
end

WeaponFactoryManager.get_removes_parts = function(l_37_0, l_37_1, l_37_2, l_37_3)
  local factory = tweak_data.weapon.factory
  local part = factory.parts[l_37_2]
  if not part then
    Application:error("WeaponFactoryManager:get_removes_parts Part", l_37_2, " doesn't exist!")
    return nil
  end
  local removes = {}
  for _,b_id in ipairs(l_37_3) do
    if part.forbids and table.contains(part.forbids, b_id) then
      table.insert(removes, b_id)
    end
  end
  return removes
end

WeaponFactoryManager.can_add_part = function(l_38_0, l_38_1, l_38_2, l_38_3)
  local factory = tweak_data.weapon.factory
  local part = factory.parts[l_38_2]
  if not part then
    Application:error("WeaponFactoryManager:can_add_part Part", l_38_2, " doesn't exist!")
    return nil
  end
  local forbids = {}
  for _,b_id in ipairs(l_38_3) do
    local part = factory.parts[b_id]
    if part.forbids and table.contains(part.forbids, l_38_2) then
      table.insert(forbids, b_id)
    end
  end
  return forbids
end

WeaponFactoryManager.remove_part = function(l_39_0, l_39_1, l_39_2, l_39_3, l_39_4, l_39_5)
  local factory = tweak_data.weapon.factory
  local part = factory.parts[l_39_3]
  if not part then
    Application:error("WeaponFactoryManager:remove_part Part", l_39_3, "doesn't exist!")
    return l_39_4
  end
  table.delete(l_39_5, l_39_3)
  l_39_0:disassemble(l_39_4)
  return l_39_0:assemble_from_blueprint(l_39_2, l_39_1, l_39_5)
end

WeaponFactoryManager.remove_part_by_type = function(l_40_0, l_40_1, l_40_2, l_40_3, l_40_4, l_40_5)
  local factory = tweak_data.weapon.factory
  for part_id,part_data in pairs(l_40_4) do
    if factory.parts[part_id].type == l_40_3 then
      table.delete(l_40_5, part_id)
  else
    end
  end
  l_40_0:disassemble(l_40_4)
  return l_40_0:assemble_from_blueprint(l_40_2, l_40_1, l_40_5)
end

WeaponFactoryManager.change_blueprint = function(l_41_0, l_41_1, l_41_2, l_41_3, l_41_4)
  l_41_0:disassemble(l_41_3)
  return l_41_0:assemble_from_blueprint(l_41_2, l_41_1, l_41_4)
end

WeaponFactoryManager.blueprint_to_string = function(l_42_0, l_42_1, l_42_2)
  local factory = tweak_data.weapon.factory
  local index_table = {}
  for i,part_id in ipairs(factory[l_42_1].uses_parts) do
    index_table[part_id] = i
  end
  local s = ""
  for _,part_id in ipairs(l_42_2) do
    s = s .. index_table[part_id] .. " "
  end
  return s
end

WeaponFactoryManager.unpack_blueprint_from_string = function(l_43_0, l_43_1, l_43_2)
  local factory = tweak_data.weapon.factory
  local index_table = string.split(l_43_2, " ")
  local blueprint = {}
  for _,part_index in ipairs(index_table) do
    table.insert(blueprint, factory[l_43_1].uses_parts[tonumber(part_index)])
  end
  return blueprint
end

WeaponFactoryManager.get_stats = function(l_44_0, l_44_1, l_44_2)
  local factory = tweak_data.weapon.factory
  local forbidden = l_44_0:_get_forbidden_parts(l_44_1, l_44_2)
  local override = l_44_0:_get_override_parts(l_44_1, l_44_2)
  local stats = {}
  for _,part_id in ipairs(l_44_2) do
    if not forbidden[part_id] and factory.parts[part_id].stats then
      local part = l_44_0:_part_data(part_id, l_44_1)
      for stat_type,value in pairs(part.stats) do
        stats[stat_type] = stats[stat_type] or 0
        stats[stat_type] = stats[stat_type] + value
      end
    end
  end
  return stats
end

WeaponFactoryManager.has_perk = function(l_45_0, l_45_1, l_45_2, l_45_3)
  local factory = tweak_data.weapon.factory
  local forbidden = l_45_0:_get_forbidden_parts(l_45_2, l_45_3)
  for _,part_id in ipairs(l_45_3) do
    if not forbidden[part_id] and factory.parts[part_id].perks then
      for _,perk in ipairs(factory.parts[part_id].perks) do
        if perk == l_45_1 then
          return true
        end
      end
    end
  end
  return false
end

WeaponFactoryManager.get_perks_from_part_id = function(l_46_0, l_46_1)
  local factory = tweak_data.weapon.factory
  if not factory.parts[l_46_1] then
    return {}
  end
  local perks = {}
  if factory.parts[l_46_1].perks then
    for _,perk in ipairs(factory.parts[l_46_1].perks) do
      perks[perk] = true
    end
  end
  return perks
end

WeaponFactoryManager.get_perks = function(l_47_0, l_47_1, l_47_2)
  local factory = tweak_data.weapon.factory
  local forbidden = l_47_0:_get_forbidden_parts(l_47_1, l_47_2)
  local perks = {}
  for _,part_id in ipairs(l_47_2) do
    if not forbidden[part_id] and factory.parts[part_id].perks then
      for _,perk in ipairs(factory.parts[part_id].perks) do
        perks[perk] = true
      end
    end
  end
  return perks
end

WeaponFactoryManager.get_sound_switch = function(l_48_0, l_48_1, l_48_2, l_48_3)
  local factory = tweak_data.weapon.factory
  local forbidden = l_48_0:_get_forbidden_parts(l_48_2, l_48_3)
  for _,part_id in ipairs(l_48_3) do
    if not forbidden[part_id] and factory.parts[part_id].sound_switch and factory.parts[part_id].sound_switch[l_48_1] then
      return factory.parts[part_id].sound_switch[l_48_1]
    end
  end
  return nil
end

WeaponFactoryManager.disassemble = function(l_49_0, l_49_1)
  local names = {}
  if l_49_1 then
    for part_id,data in pairs(l_49_1) do
      if data.package then
        l_49_0:unload_package(data.package)
      else
        table.insert(names, data.name)
      end
      if alive(data.unit) then
        World:delete_unit(data.unit)
      end
    end
  end
  l_49_1 = {}
  for _,name in pairs(names) do
    managers.dyn_resource:unload(Idstring("unit"), name, "packages/dyn_resources", false)
  end
end

WeaponFactoryManager.save = function(l_50_0, l_50_1)
  l_50_1.weapon_factory = l_50_0._global
end

WeaponFactoryManager.load = function(l_51_0, l_51_1)
  l_51_0._global = l_51_1.weapon_factory
end

WeaponFactoryManager.debug_get_stats = function(l_52_0, l_52_1, l_52_2)
  local factory = tweak_data.weapon.factory
  local forbidden = l_52_0:_get_forbidden_parts(l_52_1, l_52_2)
  local stats = {}
  for _,part_id in ipairs(l_52_2) do
    if not forbidden[part_id] then
      stats[part_id] = factory.parts[part_id].stats
    end
  end
  return stats
end


