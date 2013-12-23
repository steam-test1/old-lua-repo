-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\extensions\cop\huskcopinventory.luac 

if not HuskCopInventory then
  HuskCopInventory = class(HuskPlayerInventory)
end
HuskCopInventory.init = function(l_1_0, l_1_1)
  CopInventory.init(l_1_0, l_1_1)
end

HuskCopInventory.set_visibility_state = function(l_2_0, l_2_1)
  CopInventory.set_visibility_state(l_2_0, l_2_1)
end

HuskCopInventory.add_unit_by_name = function(l_3_0, l_3_1, l_3_2)
  local new_unit = World:spawn_unit(l_3_1, Vector3(), Rotation())
  CopInventory._chk_spawn_shield(l_3_0, new_unit)
  local setup_data = {}
  setup_data.user_unit = l_3_0._unit
  setup_data.ignore_units = {l_3_0._unit, new_unit, l_3_0._shield_unit}
  setup_data.expend_ammo = false
  setup_data.hit_slotmask = managers.slot:get_mask("bullet_impact_targets_no_AI")
  setup_data.hit_player = true
  setup_data.user_sound_variant = tweak_data.character[l_3_0._unit:base()._tweak_table].weapon_voice
  new_unit:base():setup(setup_data)
  CopInventory.add_unit(l_3_0, new_unit, l_3_2)
end

HuskCopInventory.get_weapon = function(l_4_0)
  CopInventory.get_weapon(l_4_0)
end

HuskCopInventory.drop_weapon = function(l_5_0)
  CopInventory.drop_weapon(l_5_0)
end

HuskCopInventory.drop_shield = function(l_6_0)
  CopInventory.drop_shield(l_6_0)
end

HuskCopInventory.destroy_all_items = function(l_7_0)
  CopInventory.destroy_all_items(l_7_0)
end

HuskCopInventory.add_unit = function(l_8_0, l_8_1, l_8_2)
  CopInventory.add_unit(l_8_0, l_8_1, l_8_2)
end

HuskCopInventory.set_visibility_state = function(l_9_0, l_9_1)
  CopInventory.set_visibility_state(l_9_0, l_9_1)
end


