-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hudmanagerpd2.luac 

core:import("CoreEvent")
require("lib/managers/HUDManagerAnimatePD2")
require("lib/managers/hud/HUDTeammate")
require("lib/managers/hud/HUDInteraction")
require("lib/managers/hud/HUDStatsScreen")
require("lib/managers/hud/HUDObjectives")
require("lib/managers/hud/HUDPresenter")
require("lib/managers/hud/HUDAssaultCorner")
require("lib/managers/hud/HUDChat")
require("lib/managers/hud/HUDHint")
require("lib/managers/hud/HUDAccessCamera")
require("lib/managers/hud/HUDHeistTimer")
require("lib/managers/hud/HUDTemp")
require("lib/managers/hud/HUDSuspicion")
require("lib/managers/hud/HUDBlackScreen")
require("lib/managers/hud/HUDMissionBriefing")
require("lib/managers/hud/HUDStageEndScreen")
require("lib/managers/hud/HUDLootScreen")
require("lib/managers/hud/HUDHitConfirm")
require("lib/managers/hud/HUDHitDirection")
require("lib/managers/hud/HUDPlayerDowned")
require("lib/managers/hud/HUDPlayerCustody")
HUDManager.disabled = {}
HUDManager.disabled[Idstring("guis/player_info_hud"):key()] = true
HUDManager.disabled[Idstring("guis/player_info_hud_fullscreen"):key()] = true
HUDManager.disabled[Idstring("guis/player_hud"):key()] = true
HUDManager.disabled[Idstring("guis/experience_hud"):key()] = true
HUDManager.PLAYER_PANEL = 4
HUDManager.controller_mod_changed = function(l_1_0)
  if l_1_0:alive("guis/mask_off_hud") then
    l_1_0:script("guis/mask_off_hud").mask_on_text:set_text(utf8.to_upper(managers.localization:text("hud_instruct_mask_on", {BTN_USE_ITEM = managers.localization:btn_macro("use_item")})))
  end
  if l_1_0._hud_temp then
    l_1_0._hud_temp:set_throw_bag_text()
  end
  if l_1_0._hud_player_downed then
    l_1_0._hud_player_downed:set_arrest_finished_text()
  end
  if alive(managers.interaction:active_object()) then
    managers.interaction:active_object():interaction():selected()
  end
end

HUDManager.make_fine_text = function(l_2_0, l_2_1)
  local x, y, w, h = l_2_1:text_rect()
  l_2_1:set_size(w, h)
  l_2_1:set_position(math.round(l_2_1:x()), math.round(l_2_1:y()))
end

HUDManager.text_clone = function(l_3_0, l_3_1)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  return l_3_1:parent():text({font = tweak_data.hud.medium_font_noshadow, font_size = l_3_1:font_size(), text = l_3_1:text(), x = l_3_1:x(), y = l_3_1:y(), w = l_3_1:w(), h = l_3_1:h(), align = l_3_1:align()})
  {font = tweak_data.hud.medium_font_noshadow, font_size = l_3_1:font_size(), text = l_3_1:text(), x = l_3_1:x(), y = l_3_1:y(), w = l_3_1:w(), h = l_3_1:h(), align = l_3_1:align()}.visible, {font = tweak_data.hud.medium_font_noshadow, font_size = l_3_1:font_size(), text = l_3_1:text(), x = l_3_1:x(), y = l_3_1:y(), w = l_3_1:w(), h = l_3_1:h(), align = l_3_1:align()}.color, {font = tweak_data.hud.medium_font_noshadow, font_size = l_3_1:font_size(), text = l_3_1:text(), x = l_3_1:x(), y = l_3_1:y(), w = l_3_1:w(), h = l_3_1:h(), align = l_3_1:align()}.layer, {font = tweak_data.hud.medium_font_noshadow, font_size = l_3_1:font_size(), text = l_3_1:text(), x = l_3_1:x(), y = l_3_1:y(), w = l_3_1:w(), h = l_3_1:h(), align = l_3_1:align()}.vertical = l_3_1:visible(), l_3_1:color(), l_3_1:layer(), l_3_1:vertical()
end

HUDManager.set_player_location = function(l_4_0, l_4_1)
  if l_4_1 then
    local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
    hud.location_text:set_text(utf8.to_upper(managers.localization:text(l_4_1)))
  end
end

HUDManager.add_weapon = function(l_5_0, l_5_1)
  l_5_0:_set_weapon(l_5_1)
  print("add_weapon", inspect(l_5_1))
  local teammate_panel = l_5_0._teammate_panels[HUDManager.PLAYER_PANEL]:panel()
  local mask = teammate_panel:child("mask")
  local pad = 4
  local icon, texture_rect = tweak_data.hud_icons:get_icon_data(l_5_1.unit:base():weapon_tweak_data().hud_icon)
  local weapon = teammate_panel:bitmap({name = "weapon" .. l_5_1.inventory_index, visible = l_5_1.is_equip, texture = icon, color = Color(1, 0.80000001192093, 0.80000001192093, 0.80000001192093), layer = 2, texture_rect = texture_rect, x = mask:right() + pad})
  weapon:set_bottom(mask:bottom())
  l_5_0._hud.weapons[l_5_1.inventory_index] = {texture_rect = texture_rect, bitmap = weapon, inventory_index = l_5_1.inventory_index, unit = l_5_1.unit}
  if l_5_1.is_equip then
    l_5_0:set_weapon_selected_by_inventory_index(l_5_1.inventory_index)
  end
  if not l_5_1.is_equip and (l_5_1.inventory_index == 1 or l_5_1.inventory_index == 2) then
    l_5_0:_update_second_weapon_ammo_info(HUDManager.PLAYER_PANEL, l_5_1.unit)
  end
end

HUDManager._set_weapon = function(l_6_0, l_6_1)
  if l_6_1.inventory_index > 2 then
    return 
  end
end

HUDManager.set_weapon_selected_by_inventory_index = function(l_7_0, l_7_1)
  l_7_0:_set_weapon_selected(l_7_1)
end

HUDManager._set_weapon_selected = function(l_8_0, l_8_1)
  l_8_0._hud.selected_weapon = l_8_1
  local icon = l_8_0._hud.weapons[l_8_0._hud.selected_weapon].unit:base():weapon_tweak_data().hud_icon
  l_8_0:_set_teammate_weapon_selected(HUDManager.PLAYER_PANEL, l_8_1, icon)
end

HUDManager._set_teammate_weapon_selected = function(l_9_0, l_9_1, l_9_2, l_9_3)
  l_9_0._teammate_panels[l_9_1]:set_weapon_selected(l_9_2, l_9_3)
  for i,data in pairs(l_9_0._hud.weapons) do
    do
      data.bitmap:set_visible(not alive(data.bitmap))
  end
  if l_9_2 == i then
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDManager.set_ammo_amount = function(l_10_0, l_10_1, l_10_2, l_10_3, l_10_4, l_10_5)
  if l_10_1 > 2 then
    print("set_ammo_amount", l_10_1, l_10_2, l_10_3, l_10_4, l_10_5)
    Application:stack_dump()
    debug_pause("WRONG SELECTION INDEX!")
  end
  managers.player:update_synced_ammo_info_to_peers(l_10_1, l_10_2, l_10_3, l_10_4, l_10_5)
  l_10_0:set_teammate_ammo_amount(HUDManager.PLAYER_PANEL, l_10_1, l_10_2, l_10_3, l_10_4, l_10_5)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
  if hud.panel:child("ammo_test") then
    local panel = hud.panel:child("ammo_test")
    local ammo_rect = panel:child("ammo_test_rect")
    ammo_rect:set_w(panel:w() * l_10_3 / l_10_2)
    ammo_rect:set_center_x(panel:w() / 2)
    panel:stop()
    panel:animate(callback(l_10_0, l_10_0, "_animate_ammo_test"))
  end
end

HUDManager.set_teammate_ammo_amount = function(l_11_0, l_11_1, l_11_2, l_11_3, l_11_4, l_11_5, l_11_6)
  local type = l_11_2 == 1 and "secondary" or "primary"
  l_11_0._teammate_panels[l_11_1]:set_ammo_amount_by_type(type, l_11_3, l_11_4, l_11_5, l_11_6)
end

HUDManager.set_weapon_ammo_by_unit = function(l_12_0, l_12_1)
  local second_weapon_index = l_12_0._hud.selected_weapon == 1 and 2 or 1
  if second_weapon_index == l_12_1:base():weapon_tweak_data().use_data.selection_index then
    l_12_0:_update_second_weapon_ammo_info(HUDManager.PLAYER_PANEL, l_12_1)
  end
end

HUDManager._update_second_weapon_ammo_info = function(l_13_0, l_13_1, l_13_2)
end

HUDManager.set_player_health = function(l_14_0, l_14_1)
  l_14_0:set_teammate_health(HUDManager.PLAYER_PANEL, l_14_1)
end

HUDManager.set_teammate_health = function(l_15_0, l_15_1, l_15_2)
  l_15_0._teammate_panels[l_15_1]:set_health(l_15_2)
end

HUDManager.set_player_armor = function(l_16_0, l_16_1)
  if l_16_1.current == 0 and not l_16_1.no_hint then
    managers.hint:show_hint("damage_pad")
  end
  l_16_0:set_teammate_armor(HUDManager.PLAYER_PANEL, l_16_1)
end

HUDManager.set_teammate_armor = function(l_17_0, l_17_1, l_17_2)
  l_17_0._teammate_panels[l_17_1]:set_armor(l_17_2)
end

HUDManager.set_teammate_name = function(l_18_0, l_18_1, l_18_2)
  l_18_0._teammate_panels[l_18_1]:set_name(l_18_2)
end

HUDManager.set_teammate_callsign = function(l_19_0, l_19_1, l_19_2)
  l_19_0._teammate_panels[l_19_1]:set_callsign(l_19_2)
end

HUDManager.set_cable_tie = function(l_20_0, l_20_1, l_20_2)
  l_20_0._teammate_panels[l_20_1]:set_cable_tie(l_20_2)
end

HUDManager.set_cable_ties_amount = function(l_21_0, l_21_1, l_21_2)
  l_21_0._teammate_panels[l_21_1]:set_cable_ties_amount(l_21_2)
end

HUDManager.set_teammate_state = function(l_22_0, l_22_1, l_22_2)
  l_22_0._teammate_panels[l_22_1]:set_state(l_22_2)
end

HUDManager.add_special_equipment = function(l_23_0, l_23_1)
  l_23_0:add_teammate_special_equipment(HUDManager.PLAYER_PANEL, l_23_1)
end

HUDManager.add_teammate_special_equipment = function(l_24_0, l_24_1, l_24_2)
  if not l_24_1 then
    print("[HUDManager:add_teammate_special_equipment] - Didn't get a number")
    Application:stack_dump()
    return 
  end
  l_24_0._teammate_panels[l_24_1]:add_special_equipment(l_24_2)
end

HUDManager.remove_special_equipment = function(l_25_0, l_25_1)
  l_25_0:remove_teammate_special_equipment(HUDManager.PLAYER_PANEL, l_25_1)
end

HUDManager.remove_teammate_special_equipment = function(l_26_0, l_26_1, l_26_2)
  l_26_0._teammate_panels[l_26_1]:remove_special_equipment(l_26_2)
end

HUDManager.set_special_equipment_amount = function(l_27_0, l_27_1, l_27_2)
  l_27_0:set_teammate_special_equipment_amount(HUDManager.PLAYER_PANEL, l_27_1, l_27_2)
end

HUDManager.set_teammate_special_equipment_amount = function(l_28_0, l_28_1, l_28_2, l_28_3)
  l_28_0._teammate_panels[l_28_1]:set_special_equipment_amount(l_28_2, l_28_3)
end

HUDManager._layout_special_equipments = function(l_29_0, l_29_1)
  if not l_29_1 then
    return 
  end
  l_29_0._teammate_panels[l_29_1]:layout_special_equipments()
end

HUDManager.clear_player_special_equipments = function(l_30_0)
  l_30_0._teammate_panels[HUDManager.PLAYER_PANEL]:clear_special_equipment()
end

HUDManager.set_perk_equipment = function(l_31_0, l_31_1, l_31_2)
  l_31_0._teammate_panels[l_31_1]:set_perk_equipment(l_31_2)
end

HUDManager.add_item = function(l_32_0, l_32_1)
  l_32_0:set_deployable_equipment(HUDManager.PLAYER_PANEL, l_32_1)
end

HUDManager.set_deployable_equipment = function(l_33_0, l_33_1, l_33_2)
  l_33_0._teammate_panels[l_33_1]:set_deployable_equipment(l_33_2)
end

HUDManager.set_item_amount = function(l_34_0, l_34_1, l_34_2)
  l_34_0:set_teammate_deployable_equipment_amount(HUDManager.PLAYER_PANEL, l_34_1, {amount = l_34_2})
end

HUDManager.set_teammate_deployable_equipment_amount = function(l_35_0, l_35_1, l_35_2, l_35_3)
  l_35_0._teammate_panels[l_35_1]:set_deployable_equipment_amount(l_35_2, l_35_3)
end

HUDManager.set_player_condition = function(l_36_0, l_36_1, l_36_2)
  l_36_0:set_teammate_condition(HUDManager.PLAYER_PANEL, l_36_1, l_36_2)
end

HUDManager.set_teammate_condition = function(l_37_0, l_37_1, l_37_2, l_37_3)
  if not l_37_1 then
    print("Didn't get a number")
    Application:stack_dump()
    return 
  end
  l_37_0._teammate_panels[l_37_1]:set_condition(l_37_2, l_37_3)
end

HUDManager.set_teammate_carry_info = function(l_38_0, l_38_1, l_38_2, l_38_3)
  if l_38_1 == HUDManager.PLAYER_PANEL then
    return 
  end
  l_38_0._teammate_panels[l_38_1]:set_carry_info(l_38_2, l_38_3)
end

HUDManager.remove_teammate_carry_info = function(l_39_0, l_39_1)
  if l_39_1 == HUDManager.PLAYER_PANEL then
    return 
  end
  l_39_0._teammate_panels[l_39_1]:remove_carry_info()
end

HUDManager.start_teammate_timer = function(l_40_0, l_40_1, l_40_2)
  l_40_0._teammate_panels[l_40_1]:start_timer(l_40_2)
end

HUDManager.is_teammate_timer_running = function(l_41_0, l_41_1)
  return l_41_0._teammate_panels[l_41_1]:is_timer_running()
end

HUDManager.pause_teammate_timer = function(l_42_0, l_42_1, l_42_2)
  l_42_0._teammate_panels[l_42_1]:set_pause_timer(l_42_2)
end

HUDManager.stop_teammate_timer = function(l_43_0, l_43_1)
  l_43_0._teammate_panels[l_43_1]:stop_timer()
end

HUDManager._setup_player_info_hud_pd2 = function(l_44_0)
  print("_setup_player_info_hud_pd2")
  if not l_44_0:alive(PlayerBase.PLAYER_INFO_HUD_PD2) then
    return 
  end
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
  hud.location_text:set_font_size(tweak_data.hud.location_font_size)
  hud.location_text:set_top(0)
  hud.location_text:set_center_x(hud.location_text:parent():w() / 2)
  l_44_0:_create_teammates_panel(hud)
  l_44_0:_create_present_panel(hud)
  l_44_0:_create_interaction(hud)
  l_44_0:_create_progress_timer(hud)
  l_44_0:_create_objectives(hud)
  l_44_0:_create_hint(hud)
  l_44_0:_create_heist_timer(hud)
  l_44_0:_create_temp_hud(hud)
  l_44_0:_create_suspicion(hud)
  l_44_0:_create_hit_confirm(hud)
  l_44_0:_create_hit_direction(hud)
  l_44_0:_create_downed_hud()
  l_44_0:_create_custody_hud()
  l_44_0:_create_hud_chat()
  l_44_0:_create_assault_corner()
end

HUDManager._create_ammo_test = function(l_45_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
  if hud.panel:child("ammo_test") then
    hud.panel:remove(hud.panel:child("ammo_test"))
  end
  local panel = hud.panel:panel({name = "ammo_test", w = 100, h = 4, x = 550, y = 200})
  panel:set_center_y(hud.panel:h() / 2 - 40)
  panel:set_center_x(hud.panel:w() / 2)
  panel:rect({name = "ammo_test_bg_rect", color = Color.black:with_alpha(0.5)})
  panel:rect({name = "ammo_test_rect", color = Color.white, layer = 1})
end

HUDManager._create_hud_chat = function(l_46_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
  if l_46_0._hud_chat then
    l_46_0._hud_chat:remove()
  end
  l_46_0._hud_chat = HUDChat:new(l_46_0._saferect, hud)
end

HUDManager._create_assault_corner = function(l_47_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
  local full_hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
  full_hud.panel:clear()
  l_47_0._hud_assault_corner = HUDAssaultCorner:new(hud, full_hud)
end

HUDManager.add_teammate_panel = function(l_48_0, l_48_1, l_48_2, l_48_3, l_48_4)
  for i,data in ipairs(l_48_0._hud.teammate_panels_data) do
    if not data.taken then
      l_48_0._teammate_panels[i]:add_panel()
      l_48_0._teammate_panels[i]:set_peer_id(l_48_4)
      l_48_0._teammate_panels[i]:set_ai(l_48_3)
      l_48_0:set_teammate_callsign(i, l_48_3 and 5 or l_48_4)
      l_48_0:set_teammate_name(i, l_48_2)
      l_48_0:set_teammate_state(i, l_48_3 and "ai" or "player")
      if l_48_4 then
        if not managers.player:get_synced_equipment_possession(l_48_4) then
          local peer_equipment = {}
        end
        for equipment,amount in pairs(peer_equipment) do
          l_48_0:add_teammate_special_equipment(i, {id = equipment, icon = tweak_data.equipments.specials[equipment].icon, amount = amount})
        end
        local peer_deployable_equipment = managers.player:get_synced_deployable_equipment(l_48_4)
        if peer_deployable_equipment then
          local icon = tweak_data.equipments[peer_deployable_equipment.deployable].icon
          l_48_0:set_deployable_equipment(i, {icon = icon, amount = peer_deployable_equipment.amount})
        end
        local peer_cable_ties = managers.player:get_synced_cable_ties(l_48_4)
        if peer_cable_ties then
          local icon = tweak_data.equipments.specials.cable_tie.icon
          l_48_0:set_cable_tie(i, {icon = icon, amount = peer_cable_ties.amount})
        end
        local peer_perk = managers.player:get_synced_perk(l_48_4)
        if peer_perk then
          local icon = tweak_data.upgrades.definitions[peer_perk.perk].icon
          l_48_0:set_perk_equipment(i, {icon = icon})
        end
      end
      local unit = managers.criminals:character_unit_by_name(l_48_1)
      if alive(unit) then
        local weapon = unit:inventory():equipped_unit()
        if alive(weapon) then
          local icon = weapon:base():weapon_tweak_data().hud_icon
          local equipped_selection = unit:inventory():equipped_selection()
          l_48_0:_set_teammate_weapon_selected(i, equipped_selection, icon)
        end
      end
      local peer_ammo_info = managers.player:get_synced_ammo_info(l_48_4)
      if peer_ammo_info then
        for selection_index,ammo_info in pairs(peer_ammo_info) do
          l_48_0:set_teammate_ammo_amount(i, selection_index, unpack(ammo_info))
        end
      end
      local peer_carry_data = managers.player:get_synced_carry(l_48_4)
      if peer_carry_data then
        l_48_0:set_teammate_carry_info(i, peer_carry_data.carry_id, managers.loot:get_real_value(peer_carry_data.carry_id, peer_carry_data.value))
      end
      data.taken = true
      return i
    end
  end
end

HUDManager.remove_teammate_panel = function(l_49_0, l_49_1)
  l_49_0._teammate_panels[l_49_1]:remove_panel()
  l_49_0._hud.teammate_panels_data[l_49_1].taken = false
  local is_ai = l_49_0._teammate_panels[HUDManager.PLAYER_PANEL]._ai
  if (l_49_0._teammate_panels[HUDManager.PLAYER_PANEL]._peer_id and l_49_0._teammate_panels[HUDManager.PLAYER_PANEL]._peer_id ~= managers.network:session():local_peer():id()) or is_ai then
    print(" MOVE!!!", l_49_0._teammate_panels[HUDManager.PLAYER_PANEL]._peer_id, is_ai)
    local peer_id = l_49_0._teammate_panels[HUDManager.PLAYER_PANEL]._peer_id
    l_49_0:remove_teammate_panel(HUDManager.PLAYER_PANEL)
    if is_ai then
      local character_name = managers.criminals:character_name_by_panel_id(HUDManager.PLAYER_PANEL)
      local name = managers.localization:text("menu_" .. character_name)
      local panel_id = l_49_0:add_teammate_panel(character_name, name, true, nil)
      managers.criminals:character_data_by_name(character_name).panel_id = panel_id
    else
      local character_name = managers.criminals:character_name_by_peer_id(peer_id)
      local panel_id = l_49_0:add_teammate_panel(character_name, managers.network:session():peer(peer_id):name(), false, peer_id)
      managers.criminals:character_data_by_name(character_name).panel_id = panel_id
    end
  end
  managers.hud._teammate_panels[HUDManager.PLAYER_PANEL]:add_panel()
  managers.hud._teammate_panels[HUDManager.PLAYER_PANEL]:set_state("player")
end

HUDManager.teampanels_height = function(l_50_0)
  return 120
end

HUDManager._create_teammates_panel = function(l_51_0, l_51_1)
  if not l_51_1 then
    l_51_1 = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
  end
  if not l_51_0._hud.teammate_panels_data then
    l_51_0._hud.teammate_panels_data = {}
  end
  l_51_0._teammate_panels = {}
  if l_51_1.panel:child("teammates_panel") then
    l_51_1.panel:remove(l_51_1.panel:child("teammates_panel"))
  end
  local h = l_51_0:teampanels_height()
  local teammates_panel = l_51_1.panel:panel({name = "teammates_panel", h = h, y = l_51_1.panel:h() - h, valign = "bottom"})
  local teammate_w = 204
  local player_gap = 240
  local small_gap = (teammates_panel:w() - player_gap - teammate_w * 4) / 3
  for i = 1, 4 do
    local is_player = i == HUDManager.PLAYER_PANEL
    l_51_0._hud.teammate_panels_data[i] = {taken = false, special_equipments = {}}
    local pw = teammate_w + (is_player and 0 or 64)
    local teammate = HUDTeammate:new(i, teammates_panel, is_player, pw)
    local x = math.floor((pw + small_gap) * (i - 1) + (i == HUDManager.PLAYER_PANEL and player_gap or 0))
    teammate._panel:set_x(math.floor(x))
    table.insert(l_51_0._teammate_panels, teammate)
    if is_player then
      teammate:add_panel()
    end
  end
end

HUDManager._create_present_panel = function(l_52_0, l_52_1)
  if not l_52_1 then
    l_52_1 = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
  end
  l_52_0._hud_presenter = HUDPresenter:new(l_52_1)
end

HUDManager.present = function(l_53_0, l_53_1)
  if l_53_0._hud_presenter then
    l_53_0._hud_presenter:present(l_53_1)
  end
end

HUDManager.present_done = function(l_54_0)
end

HUDManager._create_interaction = function(l_55_0, l_55_1)
  if not l_55_1 then
    l_55_1 = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
  end
  l_55_0._hud_interaction = HUDInteraction:new(l_55_1)
end

HUDManager.show_interact = function(l_56_0, l_56_1)
  l_56_0._hud_interaction:show_interact(l_56_1)
end

HUDManager.remove_interact = function(l_57_0)
  if not l_57_0._hud_interaction then
    return 
  end
  l_57_0._hud_interaction:remove_interact()
end

HUDManager.show_interaction_bar = function(l_58_0, l_58_1, l_58_2)
  l_58_0._hud_interaction:show_interaction_bar(l_58_1, l_58_2)
end

HUDManager.set_interaction_bar_width = function(l_59_0, l_59_1, l_59_2)
  l_59_0._hud_interaction:set_interaction_bar_width(l_59_1, l_59_2)
end

HUDManager.hide_interaction_bar = function(l_60_0, l_60_1)
  l_60_0._hud_interaction:hide_interaction_bar(l_60_1)
end

HUDManager._create_progress_timer = function(l_61_0, l_61_1)
  if not l_61_1 then
    l_61_1 = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
  end
  l_61_0._progress_timer = HUDInteraction:new(l_61_1, "progress_timer")
end

HUDManager.show_progress_timer = function(l_62_0, l_62_1)
  l_62_0._progress_timer:show_interact(l_62_1)
end

HUDManager.remove_progress_timer = function(l_63_0)
  l_63_0._progress_timer:remove_interact()
end

HUDManager.show_progress_timer_bar = function(l_64_0, l_64_1, l_64_2)
  l_64_0._progress_timer:show_interaction_bar(l_64_1, l_64_2)
end

HUDManager.set_progress_timer_bar_width = function(l_65_0, l_65_1, l_65_2)
  l_65_0._progress_timer:set_interaction_bar_width(l_65_1, l_65_2)
end

HUDManager.set_progress_timer_bar_valid = function(l_66_0, l_66_1, l_66_2)
  l_66_0._progress_timer:set_bar_valid(l_66_1, l_66_2)
end

HUDManager.hide_progress_timer_bar = function(l_67_0, l_67_1)
  l_67_0._progress_timer:hide_interaction_bar(l_67_1)
end

HUDManager.set_control_info = function(l_68_0, l_68_1)
  l_68_0._hud_assault_corner:set_control_info(l_68_1)
end

HUDManager.sync_start_assault = function(l_69_0, l_69_1)
  managers.music:post_event(tweak_data.levels:get_music_event("assault"))
  if not managers.groupai:state():get_hunt_mode() then
    managers.dialog:queue_dialog("gen_ban_b02c", {})
  end
  l_69_0._hud_assault_corner:sync_start_assault(l_69_1)
end

HUDManager.sync_end_assault = function(l_70_0, l_70_1)
  managers.music:post_event(tweak_data.levels:get_music_event("control"))
  local result_diag = {"gen_ban_b12", "gen_ban_b11", "gen_ban_b10"}
  if l_70_1 then
    managers.dialog:queue_dialog(result_diag[l_70_1 + 1], {})
  end
  l_70_0._hud_assault_corner:sync_end_assault(l_70_1)
end

HUDManager.show_casing = function(l_71_0)
  l_71_0._hud_assault_corner:show_casing()
end

HUDManager.hide_casing = function(l_72_0)
  l_72_0._hud_assault_corner:hide_casing()
end

HUDManager._setup_stats_screen = function(l_73_0)
  print("HUDManager:_setup_stats_screen")
  if not l_73_0:alive(PlayerBase.PLAYER_INFO_HUD_PD2) then
    return 
  end
  l_73_0._hud_statsscreen = HUDStatsScreen:new()
end

HUDManager.show_stats_screen = function(l_74_0)
  local safe = l_74_0.STATS_SCREEN_SAFERECT
  local full = l_74_0.STATS_SCREEN_FULLSCREEN
  if not l_74_0:exists(safe) then
    l_74_0:load_hud(full, false, true, false, {})
    l_74_0:load_hud(safe, false, true, true, {})
  end
  l_74_0._hud_statsscreen:show()
  l_74_0._showing_stats_screen = true
end

HUDManager.hide_stats_screen = function(l_75_0)
  l_75_0._showing_stats_screen = false
  if l_75_0._hud_statsscreen then
    l_75_0._hud_statsscreen:hide()
  end
end

HUDManager.showing_stats_screen = function(l_76_0)
  return l_76_0._showing_stats_screen
end

HUDManager.loot_value_updated = function(l_77_0)
  if l_77_0._hud_statsscreen then
    l_77_0._hud_statsscreen:loot_value_updated()
  end
end

HUDManager.feed_point_of_no_return_timer = function(l_78_0, l_78_1, l_78_2)
  l_78_0._hud_assault_corner:feed_point_of_no_return_timer(l_78_1, l_78_2)
end

HUDManager.show_point_of_no_return_timer = function(l_79_0)
  l_79_0._hud_assault_corner:show_point_of_no_return_timer()
end

HUDManager.hide_point_of_no_return_timer = function(l_80_0)
  l_80_0._hud_assault_corner:hide_point_of_no_return_timer()
end

HUDManager.flash_point_of_no_return_timer = function(l_81_0, l_81_1)
  if l_81_1 then
    l_81_0._sound_source:post_event("last_10_seconds_beep")
  end
  l_81_0._hud_assault_corner:flash_point_of_no_return_timer(l_81_1)
end

HUDManager._create_objectives = function(l_82_0, l_82_1)
  if not l_82_1 then
    l_82_1 = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
  end
  l_82_0._hud_objectives = HUDObjectives:new(l_82_1)
end

HUDManager.activate_objective = function(l_83_0, l_83_1)
  l_83_0._hud_objectives:activate_objective(l_83_1)
end

HUDManager.complete_sub_objective = function(l_84_0, l_84_1)
end

HUDManager.update_amount_objective = function(l_85_0, l_85_1)
  print("HUDManager:update_amount_objective", inspect(l_85_1))
  l_85_0._hud_objectives:update_amount_objective(l_85_1)
end

HUDManager.remind_objective = function(l_86_0, l_86_1)
  l_86_0._hud_objectives:remind_objective(l_86_1)
end

HUDManager.complete_objective = function(l_87_0, l_87_1)
  l_87_0._hud_objectives:complete_objective(l_87_1)
end

HUDManager._create_hint = function(l_88_0, l_88_1)
  if not l_88_1 then
    l_88_1 = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
  end
  l_88_0._hud_hint = HUDHint:new(l_88_1)
end

HUDManager.show_hint = function(l_89_0, l_89_1)
  l_89_0._hud_hint:show(l_89_1)
  if l_89_1.event then
    l_89_0._sound_source:post_event(l_89_1.event)
  end
end

HUDManager.stop_hint = function(l_90_0)
  l_90_0._hud_hint:stop()
end

HUDManager._create_heist_timer = function(l_91_0, l_91_1)
  if not l_91_1 then
    l_91_1 = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
  end
  l_91_0._hud_heist_timer = HUDHeistTimer:new(l_91_1)
end

HUDManager.feed_heist_time = function(l_92_0, l_92_1)
  l_92_0._hud_heist_timer:set_time(l_92_1)
end

HUDManager._create_temp_hud = function(l_93_0, l_93_1)
  if not l_93_1 then
    l_93_1 = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
  end
  l_93_0._hud_temp = HUDTemp:new(l_93_1)
end

HUDManager.temp_show_carry_bag = function(l_94_0, l_94_1, l_94_2)
  l_94_0._hud_temp:show_carry_bag(l_94_1, l_94_2)
  l_94_0._sound_source:post_event("Play_bag_generic_pickup")
end

HUDManager.temp_hide_carry_bag = function(l_95_0)
  l_95_0._hud_temp:hide_carry_bag()
  l_95_0._sound_source:post_event("Play_bag_generic_throw")
end

HUDManager.set_stamina_value = function(l_96_0, l_96_1)
  l_96_0._hud_temp:set_stamina_value(l_96_1)
end

HUDManager.set_max_stamina = function(l_97_0, l_97_1)
  l_97_0._hud_temp:set_max_stamina(l_97_1)
end

HUDManager._create_suspicion = function(l_98_0, l_98_1)
  if not l_98_1 then
    l_98_1 = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
  end
  l_98_0._hud_suspicion = HUDSuspicion:new(l_98_1, l_98_0._sound_source)
end

HUDManager.set_suspicion = function(l_99_0, l_99_1)
  if type(l_99_1) == "boolean" then
    if l_99_1 then
      l_99_0._hud_suspicion:discovered()
    else
      l_99_0._hud_suspicion:back_to_stealth()
    end
  else
    l_99_0._hud_suspicion:feed_value(l_99_1)
  end
end

HUDManager._create_hit_confirm = function(l_100_0, l_100_1)
  if not l_100_1 then
    l_100_1 = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
  end
  l_100_0._hud_hit_confirm = HUDHitConfirm:new(l_100_1)
end

HUDManager.on_hit_confirmed = function(l_101_0)
  if not managers.user:get_setting("hit_indicator") then
    return 
  end
  l_101_0._hud_hit_confirm:on_hit_confirmed()
end

HUDManager._create_hit_direction = function(l_102_0, l_102_1)
  if not l_102_1 then
    l_102_1 = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
  end
  l_102_0._hud_hit_direction = HUDHitDirection:new(l_102_1)
end

HUDManager.on_hit_direction = function(l_103_0, l_103_1)
  l_103_0._hud_hit_direction:on_hit_direction(l_103_1)
end

HUDManager._create_downed_hud = function(l_104_0, l_104_1)
  if not l_104_1 then
    l_104_1 = managers.hud:script(PlayerBase.PLAYER_DOWNED_HUD)
  end
  l_104_0._hud_player_downed = HUDPlayerDowned:new(l_104_1)
end

HUDManager.on_downed = function(l_105_0)
  l_105_0._hud_player_downed:on_downed()
end

HUDManager.on_arrested = function(l_106_0)
  l_106_0._hud_player_downed:on_arrested()
end

HUDManager._create_custody_hud = function(l_107_0, l_107_1)
  if not l_107_1 then
    l_107_1 = managers.hud:script(PlayerBase.PLAYER_CUSTODY_HUD)
  end
  l_107_0._hud_player_custody = HUDPlayerCustody:new(l_107_1)
end

HUDManager.set_custody_respawn_time = function(l_108_0, l_108_1)
  l_108_0._hud_player_custody:set_respawn_time(l_108_1)
end

HUDManager.set_custody_timer_visibility = function(l_109_0, l_109_1)
  l_109_0._hud_player_custody:set_timer_visibility(l_109_1)
end

HUDManager.set_custody_civilians_killed = function(l_110_0, l_110_1)
  l_110_0._hud_player_custody:set_civilians_killed(l_110_1)
end

HUDManager.set_custody_trade_delay = function(l_111_0, l_111_1)
  l_111_0._hud_player_custody:set_trade_delay(l_111_1)
end

HUDManager.set_custody_trade_delay_visible = function(l_112_0, l_112_1)
  l_112_0._hud_player_custody:set_trade_delay_visible(l_112_1)
end

HUDManager.set_custody_negotiating_visible = function(l_113_0, l_113_1)
  l_113_0._hud_player_custody:set_negotiating_visible(l_113_1)
end

HUDManager.set_custody_can_be_trade_visible = function(l_114_0, l_114_1)
  l_114_0._hud_player_custody:set_can_be_trade_visible(l_114_1)
end

HUDManager._add_name_label = function(l_115_0, l_115_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
  local last_id = l_115_0._hud.name_labels[#l_115_0._hud.name_labels] and l_115_0._hud.name_labels[#l_115_0._hud.name_labels].id or 0
  local id = last_id + 1
  local character_name = l_115_1.name
  local peer_id = nil
  local is_husk_player = l_115_1.unit:base().is_husk_player
  if is_husk_player then
    peer_id = l_115_1.unit:network():peer():id()
    local level = l_115_1.unit:network():peer():level()
    l_115_1.name = l_115_1.name .. " [" .. level .. "]"
  end
  local panel = hud.panel:panel({name = "name_label" .. id})
  local radius = 24
  local interact = CircleBitmapGuiObject:new(panel, {use_bg = true, radius = radius, blend_mode = "add", color = Color.white, layer = 0})
  interact:set_visible(false)
  local tabs_texture = "guis/textures/pd2/hud_tabs"
  local bag_rect = {2, 34, 20, 17}
  local color_id = managers.criminals:character_color_id_by_unit(l_115_1.unit)
  local crim_color = tweak_data.chat_colors[color_id]
  local bag = panel:bitmap({name = "bag", texture = tabs_texture, texture_rect = bag_rect, visible = false, layer = 0, color = crim_color * 1.1000000238419:with_alpha(1), x = 1, y = 1})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local text = panel:text({name = "text", text = utf8.to_upper(l_115_1.name), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.name_label_font_size})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local action = panel:text({name = "action", rotation = 360, visible = false, text = utf8.to_upper("Fixing"), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.name_label_font_size, color = crim_color * 1.1000000238419:with_alpha(1), align = "left"})
  local _, _, w, h = text:text_rect()
  h, {name = "action", rotation = 360, visible = false, text = utf8.to_upper("Fixing"), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.name_label_font_size, color = crim_color * 1.1000000238419:with_alpha(1), align = "left"}.h, {name = "action", rotation = 360, visible = false, text = utf8.to_upper("Fixing"), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.name_label_font_size, color = crim_color * 1.1000000238419:with_alpha(1), align = "left"}.w, {name = "action", rotation = 360, visible = false, text = utf8.to_upper("Fixing"), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.name_label_font_size, color = crim_color * 1.1000000238419:with_alpha(1), align = "left"}.layer, {name = "action", rotation = 360, visible = false, text = utf8.to_upper("Fixing"), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.name_label_font_size, color = crim_color * 1.1000000238419:with_alpha(1), align = "left"}.vertical, {name = "text", text = utf8.to_upper(l_115_1.name), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.name_label_font_size}.h, {name = "text", text = utf8.to_upper(l_115_1.name), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.name_label_font_size}.w, {name = "text", text = utf8.to_upper(l_115_1.name), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.name_label_font_size}.layer, {name = "text", text = utf8.to_upper(l_115_1.name), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.name_label_font_size}.vertical, {name = "text", text = utf8.to_upper(l_115_1.name), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.name_label_font_size}.align, {name = "text", text = utf8.to_upper(l_115_1.name), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.name_label_font_size}.color = math.max(h, radius * 2), 18, 256, -1, "bottom", 18, 256, -1, "top", "right", crim_color
  panel:set_size(w + 4 + radius * 2, h)
  text:set_size(panel:size())
  action:set_size(panel:size())
  action:set_x(radius * 2 + 4)
  panel:set_w(panel:w() + bag:w() + 4)
  bag:set_right(panel:w())
  bag:set_y(4)
  table.insert(l_115_0._hud.name_labels, {movement = l_115_1.unit:movement(), panel = panel, text = text, id = id, peer_id = peer_id, character_name = character_name, interact = interact, bag = bag})
  return id
end

HUDManager._remove_name_label = function(l_116_0, l_116_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
  if not hud then
    return 
  end
  for i,data in ipairs(l_116_0._hud.name_labels) do
    if data.id == l_116_1 then
      hud.panel:remove(data.panel)
      table.remove(l_116_0._hud.name_labels, i)
  else
    end
  end
end

HUDManager._name_label_by_peer_id = function(l_117_0, l_117_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
  if not hud then
    return 
  end
  for i,data in ipairs(l_117_0._hud.name_labels) do
    if data.peer_id == l_117_1 then
      return data
    end
  end
end

HUDManager.set_name_label_carry_info = function(l_118_0, l_118_1, l_118_2, l_118_3)
  local name_label = l_118_0:_name_label_by_peer_id(l_118_1)
  if name_label then
    name_label.panel:child("bag"):set_visible(true)
  end
end

HUDManager.remove_name_label_carry_info = function(l_119_0, l_119_1)
  local name_label = l_119_0:_name_label_by_peer_id(l_119_1)
  if name_label then
    name_label.panel:child("bag"):set_visible(false)
  end
end

HUDManager.teammate_progress = function(l_120_0, l_120_1, l_120_2, l_120_3, l_120_4, l_120_5, l_120_6)
  local name_label = l_120_0:_name_label_by_peer_id(l_120_1)
  if name_label then
    name_label.interact:set_visible(l_120_3)
    name_label.panel:child("action"):set_visible(l_120_3)
    local action_text = ""
    if not tweak_data.interaction[l_120_4].action_text_id then
      action_text = managers.localization:text(l_120_2 ~= 1 or "hud_action_generic")
      do return end
      do
        if l_120_2 == 2 and l_120_3 then
          local equipment_name = managers.localization:text(tweak_data.equipments[l_120_4].text_id)
          action_text = managers.localization:text("hud_deploying_equipment", {EQUIPMENT = equipment_name})
        end
        do return end
        if l_120_2 == 3 then
          action_text = managers.localization:text("hud_starting_heist")
        end
      end
      name_label.panel:child("action"):set_text(utf8.to_upper(action_text))
      name_label.panel:stop()
      if l_120_3 then
        name_label.panel:animate(callback(l_120_0, l_120_0, "_animate_label_interact"), name_label.interact, l_120_5)
      elseif l_120_6 then
        local panel = name_label.panel
        local bitmap = panel:bitmap({rotation = 360, texture = "guis/textures/pd2/hud_progress_active", blend_mode = "add", align = "center", valign = "center", layer = 2})
        bitmap:set_size(name_label.interact:size())
        bitmap:set_position(name_label.interact:position())
        local radius = name_label.interact:radius()
        local circle = CircleBitmapGuiObject:new(panel, {rotation = 360, radius = radius, color = Color.white:with_alpha(1), blend_mode = "normal", layer = 3})
        circle:set_position(name_label.interact:position())
        bitmap:animate(callback(HUDInteraction, HUDInteraction, "_animate_interaction_complete"), circle)
      end
    end
    local character_data = managers.criminals:character_data_by_peer_id(l_120_1)
    if character_data then
      l_120_0._teammate_panels[character_data.panel_id]:teammate_progress(l_120_3, l_120_4, l_120_5, l_120_6)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDManager._animate_label_interact = function(l_121_0, l_121_1, l_121_2, l_121_3)
  do
    local t = 0
    repeat
      if t <= l_121_3 then
        local dt = coroutine.yield()
        t = t + dt
        l_121_2:set_current((t) / l_121_3)
      else
        l_121_2:set_current(1)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDManager.toggle_chatinput = function(l_122_0)
  l_122_0:set_chat_focus(true)
end

HUDManager.chat_focus = function(l_123_0)
  return l_123_0._chat_focus
end

HUDManager.set_chat_skip_first = function(l_124_0, l_124_1)
  if l_124_0._hud_chat then
    l_124_0._hud_chat:set_skip_first(l_124_1)
  end
end

HUDManager.set_chat_focus = function(l_125_0, l_125_1)
  if not l_125_0:alive(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2) then
    return 
  end
  if l_125_0._chat_focus == l_125_1 then
    return 
  end
  setup:add_end_frame_callback(function()
    self._chat_focus = focus
   end)
  l_125_0._chatinput_changed_callback_handler:dispatch(l_125_1)
  if l_125_1 then
    l_125_0._hud_chat:_on_focus()
  else
    l_125_0._hud_chat:_loose_focus()
  end
end

HUDManager.setup_access_camera_hud = function(l_126_0)
  local hud = managers.hud:script(IngameAccessCamera.GUI_SAFERECT)
  local full_hud = managers.hud:script(IngameAccessCamera.GUI_FULLSCREEN)
  l_126_0._hud_access_camera = HUDAccessCamera:new(hud, full_hud)
end

HUDManager.set_access_camera_name = function(l_127_0, l_127_1)
  l_127_0._hud_access_camera:set_camera_name(l_127_1)
end

HUDManager.set_access_camera_destroyed = function(l_128_0, l_128_1, l_128_2)
  l_128_0._hud_access_camera:set_destroyed(l_128_1, l_128_2)
end

HUDManager.start_access_camera = function(l_129_0)
  l_129_0._hud_access_camera:start()
end

HUDManager.stop_access_camera = function(l_130_0)
  l_130_0._hud_access_camera:stop()
end

HUDManager.access_camera_track = function(l_131_0, l_131_1, l_131_2, l_131_3)
  l_131_0._hud_access_camera:draw_marker(l_131_1, l_131_0._workspace:world_to_screen(l_131_2, l_131_3))
end

HUDManager.access_camera_track_max_amount = function(l_132_0, l_132_1)
  l_132_0._hud_access_camera:max_markers(l_132_1)
end

HUDManager.setup_blackscreen_hud = function(l_133_0)
  local hud = managers.hud:script(IngameWaitingForPlayersState.LEVEL_INTRO_GUI)
  l_133_0._hud_blackscreen = HUDBlackScreen:new(hud)
end

HUDManager.set_blackscreen_mid_text = function(l_134_0, ...)
  l_134_0._hud_blackscreen:set_mid_text(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

HUDManager.blackscreen_fade_in_mid_text = function(l_135_0)
  l_135_0._hud_blackscreen:fade_in_mid_text()
end

HUDManager.blackscreen_fade_out_mid_text = function(l_136_0)
  l_136_0._hud_blackscreen:fade_out_mid_text()
end

HUDManager.set_blackscreen_job_data = function(l_137_0)
  l_137_0._hud_blackscreen:set_job_data()
end

HUDManager.set_blackscreen_skip_circle = function(l_138_0, l_138_1, l_138_2)
  l_138_0._hud_blackscreen:set_skip_circle(l_138_1, l_138_2)
end

HUDManager.blackscreen_skip_circle_done = function(l_139_0)
  l_139_0._hud_blackscreen:skip_circle_done()
end

HUDManager.setup_mission_briefing_hud = function(l_140_0)
  local hud = managers.hud:script(IngameWaitingForPlayersState.GUI_FULLSCREEN)
  l_140_0._hud_mission_briefing = HUDMissionBriefing:new(hud, l_140_0._fullscreen_workspace)
end

HUDManager.hide_mission_briefing_hud = function(l_141_0)
  if l_141_0._hud_mission_briefing then
    l_141_0._hud_mission_briefing:hide()
  end
end

HUDManager.layout_mission_briefing_hud = function(l_142_0)
  if l_142_0._hud_mission_briefing then
    l_142_0._hud_mission_briefing:update_layout()
  end
end

HUDManager.set_player_slot = function(l_143_0, l_143_1, l_143_2)
  l_143_0._hud_mission_briefing:set_player_slot(l_143_1, l_143_2)
end

HUDManager.set_slot_joining = function(l_144_0, l_144_1, l_144_2)
  l_144_0._hud_mission_briefing:set_slot_joining(l_144_1, l_144_2)
end

HUDManager.set_slot_ready = function(l_145_0, l_145_1, l_145_2)
  l_145_0._hud_mission_briefing:set_slot_ready(l_145_1, l_145_2)
end

HUDManager.set_slot_not_ready = function(l_146_0, l_146_1, l_146_2)
  l_146_0._hud_mission_briefing:set_slot_not_ready(l_146_1, l_146_2)
end

HUDManager.set_dropin_progress = function(l_147_0, l_147_1, l_147_2)
  l_147_0._hud_mission_briefing:set_dropin_progress(l_147_1, l_147_2)
end

HUDManager.set_player_slots_kit = function(l_148_0, l_148_1)
  l_148_0._hud_mission_briefing:set_player_slots_kit(l_148_1)
end

HUDManager.set_kit_selection = function(l_149_0, l_149_1, l_149_2, l_149_3, l_149_4)
  l_149_0._hud_mission_briefing:set_kit_selection(l_149_1, l_149_2, l_149_3, l_149_4)
end

HUDManager.set_slot_voice = function(l_150_0, l_150_1, l_150_2, l_150_3)
  l_150_0._hud_mission_briefing:set_slot_voice(l_150_1, l_150_2, l_150_3)
end

HUDManager.remove_player_slot_by_peer_id = function(l_151_0, l_151_1, l_151_2)
  l_151_0._hud_mission_briefing:remove_player_slot_by_peer_id(l_151_1, l_151_2)
end

HUDManager.setup_endscreen_hud = function(l_152_0)
  local hud = managers.hud:script(MissionEndState.GUI_ENDSCREEN)
  l_152_0._hud_stage_endscreen = HUDStageEndScreen:new(hud, l_152_0._fullscreen_workspace)
end

HUDManager.hide_endscreen_hud = function(l_153_0)
  if l_153_0._hud_stage_endscreen then
    l_153_0._hud_stage_endscreen:hide()
  end
end

HUDManager.show_endscreen_hud = function(l_154_0)
  if l_154_0._hud_stage_endscreen then
    l_154_0._hud_stage_endscreen:show()
  end
end

HUDManager.layout_endscreen_hud = function(l_155_0)
  if l_155_0._hud_stage_endscreen then
    l_155_0._hud_stage_endscreen:update_layout()
  end
end

HUDManager.set_continue_button_text_endscreen_hud = function(l_156_0, l_156_1)
  if l_156_0._hud_stage_endscreen then
    l_156_0._hud_stage_endscreen:set_continue_button_text(l_156_1)
  end
end

HUDManager.set_success_endscreen_hud = function(l_157_0, l_157_1, l_157_2)
  if l_157_0._hud_stage_endscreen then
    l_157_0._hud_stage_endscreen:set_success(l_157_1, l_157_2)
  end
end

HUDManager.set_statistics_endscreen_hud = function(l_158_0, l_158_1, l_158_2)
  if l_158_0._hud_stage_endscreen then
    l_158_0._hud_stage_endscreen:set_statistics(l_158_1, l_158_2)
  end
end

HUDManager.set_group_statistics_endscreen_hud = function(l_159_0, l_159_1, l_159_2, l_159_3, l_159_4, l_159_5, l_159_6, l_159_7, l_159_8, l_159_9, l_159_10, l_159_11, l_159_12, l_159_13)
  if l_159_0._hud_stage_endscreen then
    l_159_0._hud_stage_endscreen:set_group_statistics(l_159_1, l_159_2, l_159_3, l_159_4, l_159_5, l_159_6, l_159_7, l_159_8, l_159_9, l_159_10, l_159_11, l_159_12, l_159_13)
  end
end

HUDManager.send_xp_data_endscreen_hud = function(l_160_0, l_160_1, l_160_2)
  if l_160_0._hud_stage_endscreen then
    l_160_0._hud_stage_endscreen:send_xp_data(l_160_1, l_160_2)
  end
end

HUDManager.update_endscreen_hud = function(l_161_0, l_161_1, l_161_2)
  if l_161_0._hud_stage_endscreen then
    l_161_0._hud_stage_endscreen:update(l_161_1, l_161_2)
  end
end

HUDManager.setup_lootscreen_hud = function(l_162_0)
  local hud = managers.hud:script(IngameLobbyMenuState.GUI_LOOTSCREEN)
  l_162_0._hud_lootscreen = HUDLootScreen:new(hud, l_162_0._fullscreen_workspace, l_162_0._saved_lootdrop, l_162_0._saved_selected, l_162_0._saved_card_chosen)
  l_162_0._saved_lootdrop = nil
  l_162_0._saved_selected = nil
  l_162_0._saved_card_chosen = nil
end

HUDManager.hide_lootscreen_hud = function(l_163_0)
  if l_163_0._hud_lootscreen then
    l_163_0._hud_lootscreen:hide()
  end
end

HUDManager.show_lootscreen_hud = function(l_164_0)
  if l_164_0._hud_lootscreen then
    l_164_0._hud_lootscreen:show()
  end
end

HUDManager.feed_lootdrop_hud = function(l_165_0, l_165_1)
  if l_165_0._hud_lootscreen then
    l_165_0._hud_lootscreen:feed_lootdrop(l_165_1)
  elseif not l_165_0._saved_lootdrop then
    l_165_0._saved_lootdrop = {}
  end
  table.insert(l_165_0._saved_lootdrop, l_165_1)
end

HUDManager.set_selected_lootcard = function(l_166_0, l_166_1, l_166_2)
  if l_166_0._hud_lootscreen then
    l_166_0._hud_lootscreen:set_selected(l_166_1, l_166_2)
  elseif not l_166_0._saved_selected then
    l_166_0._saved_selected = {}
  end
  l_166_0._saved_selected[l_166_1] = l_166_2
end

HUDManager.confirm_choose_lootcard = function(l_167_0, l_167_1, l_167_2)
  if l_167_0._hud_lootscreen then
    l_167_0._hud_lootscreen:begin_choose_card(l_167_1, l_167_2)
  elseif not l_167_0._saved_card_chosen then
    l_167_0._saved_card_chosen = {}
  end
  l_167_0._saved_card_chosen[l_167_1] = l_167_2
end

HUDManager.get_lootscreen_hud = function(l_168_0)
  return l_168_0._hud_lootscreen
end

HUDManager.layout_lootscreen_hud = function(l_169_0)
  if l_169_0._hud_lootscreen then
    l_169_0._hud_lootscreen:update_layout()
  end
end

HUDManager._create_test_circle = function(l_170_0)
  if l_170_0._test_circle then
    l_170_0._test_circle:remove()
    l_170_0._test_circle = nil
  end
  l_170_0._test_circle = CircleGuiObject:new(managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2).panel, {radius = 10, sides = 64, current = 10, total = 10})
  l_170_0._test_circle._circle:animate(callback(l_170_0, l_170_0, "_animate_test_circle"))
end


