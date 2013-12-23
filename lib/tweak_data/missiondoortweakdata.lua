-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\tweak_data\missiondoortweakdata.luac 

if not MissionDoorTweakData then
  MissionDoorTweakData = class()
end
MissionDoorTweakData.init = function(l_1_0)
  l_1_0.default = {}
  l_1_0.default.devices = {}
  l_1_0.default.devices.drill = {{align = "a_drill_1", unit = Idstring("units/payday2/equipment/item_door_drill_small/item_door_drill_small"), can_jam = true, timer = 20}, {align = "a_drill_2", unit = Idstring("units/payday2/equipment/item_door_drill_small/item_door_drill_small")}}
  l_1_0.default.devices.c4 = {{align = "a_c4_1", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}, {align = "a_c4_2", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}, {align = "a_c4_3", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}}
  l_1_0.test = deep_clone(l_1_0.default)
  l_1_0.bank_door_test = {}
  l_1_0.bank_door_test.devices = {}
  l_1_0.bank_door_test.devices.drill = {{align = "a_drill_a", unit = Idstring("units/payday2/equipment/item_door_drill_small/item_door_drill_small"), can_jam = true, timer = 20}}
  l_1_0.crossing_armored_vehicle = {}
  l_1_0.crossing_armored_vehicle.devices = {}
  l_1_0.crossing_armored_vehicle.devices.drill = {{align = "a_drill_1", unit = Idstring("units/payday2/equipment/item_door_drill_small/item_door_drill_small"), can_jam = true, timer = 180}}
  l_1_0.reinforced_door = {}
  l_1_0.reinforced_door.devices = {}
  l_1_0.reinforced_door.devices.c4 = {{align = "a_shp_charge_1", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}}
  l_1_0.keycard_door = {}
  l_1_0.keycard_door.devices = {}
  l_1_0.keycard_door.devices.c4 = {{align = "a_shp_charge_1", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}, {align = "a_shp_charge_2", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}, {align = "a_shp_charge_3", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}}
  l_1_0.keycard_door.devices.drill = {{align = "a_drill", unit = Idstring("units/payday2/equipment/item_door_drill_small/item_door_drill_small"), can_jam = true, timer = 180}}
  l_1_0.keycard_door.devices.key = {{align = "a_keycard", unit = Idstring("units/payday2/equipment/gen_interactable_panel_keycard/gen_interactable_panel_keycard")}}
  l_1_0.keycard_door.devices.ecm = {{align = "a_ecm_hack", unit = Idstring("units/payday2/equipment/gen_interactable_door_keycard/gen_interactable_door_keycard_jammer")}}
  l_1_0.safe_small = {}
  l_1_0.safe_small.devices = {}
  l_1_0.safe_small.devices.drill = {{align = "a_drill", unit = Idstring("units/payday2/equipment/item_door_drill_small/item_door_drill_small"), can_jam = true, timer = 180}}
  l_1_0.safe_small.devices.c4 = {{align = "a_shp_charge", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}}
  l_1_0.safe_medium = {}
  l_1_0.safe_medium.devices = {}
  l_1_0.safe_medium.devices.drill = {{align = "a_drill", unit = Idstring("units/payday2/equipment/item_door_drill_small/item_door_drill_small"), can_jam = true, timer = 240}}
  l_1_0.safe_medium.devices.c4 = {{align = "a_shp_charge", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}}
  l_1_0.safe_large = {}
  l_1_0.safe_large.devices = {}
  l_1_0.safe_large.devices.drill = {{align = "a_drill", unit = Idstring("units/payday2/equipment/item_door_drill_small/item_door_drill_small"), can_jam = true, timer = 300}}
  l_1_0.safe_large.devices.c4 = {{align = "a_shp_charge", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}}
  l_1_0.safe_giga = {}
  l_1_0.safe_giga.devices = {}
  l_1_0.safe_giga.devices.drill = {{align = "a_drill", unit = Idstring("units/payday2/equipment/item_door_drill_small/item_door_drill_small"), can_jam = true, timer = 300}}
  l_1_0.safe_giga.devices.c4 = {{align = "a_shp_charge_1", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}, {align = "a_shp_charge_2", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}, {align = "a_shp_charge_3", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}, {align = "a_shp_charge_4", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}}
  l_1_0.safe = {}
  l_1_0.safe.devices = {}
  l_1_0.safe.devices.drill = {{align = "a_drill", unit = Idstring("units/payday2/equipment/item_door_drill_small/item_door_drill_small"), can_jam = true, timer = 300}}
  l_1_0.safe.devices.c4 = {{align = "a_shp_charge_1", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}, {align = "a_shp_charge_2", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}, {align = "a_shp_charge_3", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}, {align = "a_shp_charge_4", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}}
  l_1_0.security_panel = {}
  l_1_0.security_panel.devices = {}
  l_1_0.security_panel.devices.ecm = {{align = "a_ecm_hack", unit = Idstring("units/payday2/equipment/gen_interactable_door_keycard/gen_interactable_door_keycard_jammer")}}
  l_1_0.vault_door = {}
  l_1_0.vault_door.devices = {}
  l_1_0.vault_door.devices.drill = {{align = "a_lance_1", unit = Idstring("units/payday2/equipment/gen_interactable_drill_large_thermic/gen_interactable_drill_large_thermic"), can_jam = true, timer = 360}}
  l_1_0.train_door = {}
  l_1_0.train_door.devices = {}
  l_1_0.train_door.devices.drill = {{align = "a_drill", unit = Idstring("units/payday2/equipment/item_door_drill_small/item_door_drill_small"), can_jam = true, timer = 60}}
  l_1_0.shape_and_drill = {}
  l_1_0.shape_and_drill.devices = {}
  l_1_0.shape_and_drill.devices.drill = {{align = "a_drill", unit = Idstring("units/payday2/equipment/item_door_drill_small/item_door_drill_small"), can_jam = true, timer = 180}}
  l_1_0.shape_and_drill.devices.c4 = {{align = "a_shp_charge", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}}
  l_1_0.truck = {}
  l_1_0.truck.devices = {}
  l_1_0.truck.devices.drill = {{align = "a_drill", unit = Idstring("units/payday2/equipment/item_door_drill_small/item_door_drill_small"), can_jam = true, timer = 120}}
  l_1_0.truck.devices.c4 = {{align = "a_shp_charge", unit = Idstring("units/payday2/equipment/gen_equipment_shape_charge/gen_equipment_shape_charge")}}
end


