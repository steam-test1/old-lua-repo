-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementinventorydummy.luac 

core:import("CoreMissionScriptElement")
if not ElementInventoryDummy then
  ElementInventoryDummy = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementInventoryDummy.init = function(l_1_0, ...)
  ElementInventoryDummy.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementInventoryDummy.client_on_executed = function(l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementInventoryDummy.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  if l_3_0._values.category ~= "none" then
    if l_3_0._values.category == "primaries" or l_3_0._values.category == "secondaries" then
      l_3_0:_spawn_weapon(l_3_0._values.category, l_3_0._values.slot, l_3_0._values.position, l_3_0._values.rotation)
    else
      if l_3_0._values.category == "masks" then
        l_3_0:_spawn_mask(l_3_0._values.category, l_3_0._values.slot, l_3_0._values.position, l_3_0._values.rotation)
      end
    end
  end
  ElementInventoryDummy.super.on_executed(l_3_0, l_3_1)
end

ElementInventoryDummy._spawn_weapon = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  local category = managers.blackmarket:get_crafted_category(l_4_1)
  if not category then
    return 
  end
  local slot_data = category[l_4_2]
  if not slot_data then
    return 
  end
  local unit_name = tweak_data.weapon.factory[slot_data.factory_id].unit
  managers.dyn_resource:load(Idstring("unit"), Idstring(unit_name), DynamicResourceManager.DYN_RESOURCES_PACKAGE, false)
  l_4_0._weapon_unit = World:spawn_unit(Idstring(unit_name), l_4_3, l_4_4)
  l_4_0._parts, l_4_0._blueprint = managers.weapon_factory:assemble_from_blueprint(slot_data.factory_id, l_4_0._weapon_unit, slot_data.blueprint, true, callback(l_4_0, l_4_0, "_assemble_completed")), managers.weapon_factory
  l_4_0._weapon_unit:set_moving(true)
end

ElementInventoryDummy._assemble_completed = function(l_5_0, l_5_1, l_5_2)
  l_5_0._parts = l_5_1
  l_5_0._blueprint = l_5_2
  l_5_0._weapon_unit:set_moving(true)
end

ElementInventoryDummy._spawn_mask = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4)
  local category = managers.blackmarket:get_crafted_category(l_6_1)
  if not category then
    return 
  end
  local slot_data = category[l_6_2]
  if not slot_data then
    return 
  end
  local mask_unit_name = managers.blackmarket:mask_unit_name_by_mask_id(slot_data.mask_id)
  managers.dyn_resource:load(Idstring("unit"), Idstring(mask_unit_name), DynamicResourceManager.DYN_RESOURCES_PACKAGE, false)
  l_6_0._mask_unit = World:spawn_unit(Idstring(mask_unit_name), l_6_3, l_6_4)
  local backside = World:spawn_unit(Idstring("units/payday2/masks/msk_backside/msk_backside"), l_6_3, l_6_4, l_6_3, l_6_4)
  l_6_0._mask_unit:link(l_6_0._mask_unit:orientation_object():name(), backside, backside:orientation_object():name())
  l_6_0._mask_unit:base():apply_blueprint(slot_data.blueprint)
  l_6_0._mask_unit:set_moving(true)
end

ElementInventoryDummy.pre_destroy = function(l_7_0)
  ElementInventoryDummy.super.pre_destroy(l_7_0)
  if alive(l_7_0._weapon_unit) then
    managers.weapon_factory:disassemble(l_7_0._parts)
    local name = l_7_0._weapon_unit:name()
    l_7_0._weapon_unit:base():set_slot(l_7_0._weapon_unit, 0)
    World:delete_unit(l_7_0._weapon_unit)
    managers.dyn_resource:unload(Idstring("unit"), name, DynamicResourceManager.DYN_RESOURCES_PACKAGE, false)
  end
  if alive(l_7_0._mask_unit) then
    for _,linked_unit in ipairs(l_7_0._mask_unit:children()) do
      linked_unit:unlink()
      World:delete_unit(linked_unit)
    end
    local name = l_7_0._mask_unit:name()
    World:delete_unit(l_7_0._mask_unit)
    managers.dyn_resource:unload(Idstring("unit"), name, DynamicResourceManager.DYN_RESOURCES_PACKAGE, false)
  end
end


