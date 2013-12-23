-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\copinventory.luac 

if not CopInventory then
  CopInventory = class(PlayerInventory)
end
CopInventory._index_to_weapon_list = HuskPlayerInventory._index_to_weapon_list
CopInventory.init = function(l_1_0, l_1_1)
  CopInventory.super.init(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._available_selections = {}
  l_1_0._equipped_selection = nil
  l_1_0._latest_addition = nil
  l_1_0._selected_primary = nil
  l_1_0._use_data_alias = "npc"
  l_1_0._align_places = {}
  l_1_0._align_places.right_hand = {obj3d_name = Idstring("a_weapon_right_front"), on_body = true}
  l_1_0._align_places.back = {obj3d_name = Idstring("Hips"), on_body = true}
  l_1_0._listener_id = "CopInventory" .. tostring(l_1_1:key())
end

CopInventory.add_unit_by_name = function(l_2_0, l_2_1, l_2_2)
  local new_unit = World:spawn_unit(l_2_1, Vector3(), Rotation())
  l_2_0:_chk_spawn_shield(new_unit)
  local setup_data = {}
  setup_data.user_unit = l_2_0._unit
  setup_data.ignore_units = {l_2_0._unit, new_unit, l_2_0._shield_unit}
  setup_data.expend_ammo = false
  setup_data.hit_slotmask = managers.slot:get_mask("bullet_impact_targets_no_police")
  setup_data.hit_player = true
  setup_data.user_sound_variant = tweak_data.character[l_2_0._unit:base()._tweak_table].weapon_voice
  setup_data.alert_AI = true
  setup_data.alert_filter = l_2_0._unit:brain():SO_access()
  new_unit:base():setup(setup_data)
  l_2_0:add_unit(new_unit, l_2_2)
end

CopInventory._chk_spawn_shield = function(l_3_0, l_3_1)
  if l_3_0._shield_unit_name and not alive(l_3_0._shield_unit) then
    local align_name = Idstring("a_weapon_left_front")
    local align_obj = l_3_0._unit:get_object(align_name)
    l_3_0._shield_unit = World:spawn_unit(Idstring(l_3_0._shield_unit_name), align_obj:position(), align_obj:rotation())
    l_3_0._unit:link(align_name, l_3_0._shield_unit, l_3_0._shield_unit:orientation_object():name())
  end
end

CopInventory.add_unit = function(l_4_0, l_4_1, l_4_2)
  CopInventory.super.add_unit(l_4_0, l_4_1, l_4_2)
end

CopInventory.get_sync_data = function(l_5_0, l_5_1)
  MPPlayerInventory.get_sync_data(l_5_0, l_5_1)
end

CopInventory.get_weapon = function(l_6_0)
  local selection = l_6_0._available_selections[l_6_0._equipped_selection]
  if selection then
    local unit = selection.unit
  end
  return unit
end

CopInventory.drop_weapon = function(l_7_0)
  local selection = l_7_0._available_selections[l_7_0._equipped_selection]
  if selection then
    local unit = selection.unit
  end
  if unit and unit:damage() then
    unit:unlink()
    unit:damage():run_sequence_simple("enable_body")
    l_7_0:_call_listeners("unequip")
    managers.game_play_central:weapon_dropped(unit)
  end
end

CopInventory.drop_shield = function(l_8_0)
  if alive(l_8_0._shield_unit) then
    l_8_0._shield_unit:unlink()
    if l_8_0._shield_unit:damage() then
      l_8_0._shield_unit:damage():run_sequence_simple("enable_body")
    end
  end
end

CopInventory.anim_clbk_weapon_attached = function(l_9_0, l_9_1, l_9_2)
  print("[CopInventory:anim_clbk_weapon_attached]", l_9_2)
  if location == true then
    print("linking")
    local weap_unit = l_9_0._equipped_selection.unit
    local weap_align_data = selection.use_data.equip
    local align_place = l_9_0._align_places[weap_align_data.align_place]
    local parent_unit = l_9_0._unit
    local res = parent_unit:link(align_place.obj3d_name, weap_unit, weap_unit:orientation_object():name())
  else
    print("unlinking")
    l_9_0._equipped_selection.unit:unlink()
  end
end

CopInventory.destroy_all_items = function(l_10_0)
  CopInventory.super.destroy_all_items(l_10_0)
  if alive(l_10_0._shield_unit) then
    l_10_0._shield_unit:set_slot(0)
    l_10_0._shield_unit = nil
  end
end


