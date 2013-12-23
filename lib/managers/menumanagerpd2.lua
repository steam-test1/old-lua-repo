-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menumanagerpd2.luac 

core:import("CoreMenuManager")
core:import("CoreMenuCallbackHandler")
require("lib/managers/menu/MenuSceneManager")
require("lib/managers/menu/MenuComponentManager")
require("lib/managers/menu/items/MenuItemExpand")
require("lib/managers/menu/items/MenuItemWeaponExpand")
require("lib/managers/menu/items/MenuItemWeaponUpgradeExpand")
require("lib/managers/menu/items/MenuItemMaskExpand")
require("lib/managers/menu/items/MenuItemArmorExpand")
require("lib/managers/menu/items/MenuItemCharacterExpand")
require("lib/managers/menu/items/MenuItemDivider")
core:import("CoreEvent")
MenuManager.update = function(l_1_0, l_1_1, l_1_2, ...)
  MenuManager.super.update(l_1_0, l_1_1, l_1_2, ...)
  if managers.menu_scene then
    managers.menu_scene:update(l_1_1, l_1_2)
  end
  managers.menu_component:update(l_1_1, l_1_2)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuManager.on_view_character = function(l_2_0, l_2_1)
  local outfit = l_2_1:rich_presence("outfit")
  if outfit ~= "" then
    if managers.menu:active_menu().logic:selected_node_name() ~= "view_character" then
      managers.menu:active_menu().logic:select_node("view_character", true, {})
    end
    managers.menu_scene:set_main_character_outfit(outfit)
    managers.menu_component:create_view_character_profile_gui(l_2_1, 0, 300)
  end
end

MenuManager.on_enter_lobby = function(l_3_0)
  print("function MenuManager:on_enter_lobby()")
  managers.menu:active_menu().logic:select_node("lobby", true, {})
  managers.platform:set_rich_presence("MPLobby")
  managers.menu_component:pre_set_game_chat_leftbottom(0, 50)
  local is_server = Network:is_server()
  local local_peer = managers.network:session():local_peer()
  managers.network:game():on_entered_lobby()
  l_3_0:setup_local_lobby_character()
end

MenuManager.on_leave_active_job = function(l_4_0)
  managers.statistics:stop_session()
  managers.savefile:save_progress()
  managers.job:deactivate_current_job()
  if managers.groupai then
    managers.groupai:state():set_AI_enabled(false)
  end
  l_4_0._sound_source:post_event("menu_exit")
  managers.menu:close_menu("lobby_menu")
  managers.menu:close_menu("menu_pause")
end

MenuManager.setup_local_lobby_character = function(l_5_0)
  local local_peer = managers.network:session():local_peer()
  local level = managers.experience:current_level()
  local character = local_peer:character()
  local progress = managers.upgrades:progress()
  if managers.menu_scene then
    managers.menu_scene:set_lobby_character_out_fit(local_peer:id(), managers.blackmarket:outfit_string())
  end
  local_peer:set_outfit_string(managers.blackmarket:outfit_string())
  managers.network:session():send_to_peers_loaded("sync_profile", level)
  managers.network:session():send_to_peers_loaded("sync_outfit", managers.blackmarket:outfit_string())
end

MenuManager.http_test = function(l_6_0)
  Steam:http_request("http://www.overkillsoftware.com/?feed=rss", callback(l_6_0, l_6_0, "http_test_result"))
end

MenuManager.http_test_result = function(l_7_0, l_7_1, l_7_2)
  print("success", l_7_1)
  print("body", l_7_2)
  print(inspect(l_7_0:_get_text_block(l_7_2, "<title>", "</title>")))
  print(inspect(l_7_0:_get_text_block(l_7_2, "<link>", "</link>")))
end

MenuCallbackHandler.continue_to_lobby = function(l_8_0)
end

MenuCallbackHandler.on_view_character_focus = function(l_9_0, l_9_1, l_9_2, l_9_3)
  if l_9_2 and l_9_3 then
    do return end
  end
  managers.menu_scene:set_main_character_outfit(managers.blackmarket:outfit_string())
  managers.menu_component:close_view_character_profile_gui()
end

MenuCallbackHandler.on_character_customization = function(l_10_0)
  managers.menu_component:close_weapon_box()
end

MenuCallbackHandler.start_job = function(l_11_0, l_11_1)
  if not managers.job:activate_job(l_11_1.job_id) then
    return 
  end
  Global.game_settings.level_id = managers.job:current_level_id()
  Global.game_settings.mission = managers.job:current_mission()
  Global.game_settings.difficulty = l_11_1.difficulty
  local matchmake_attributes = l_11_0:get_matchmake_attributes()
  if Network:is_server() then
    local job_id_index = tweak_data.narrative:get_index_from_job_id(managers.job:current_job_id())
    local level_id_index = tweak_data.levels:get_index_from_level_id(Global.game_settings.level_id)
    local difficulty_index = tweak_data:difficulty_to_index(Global.game_settings.difficulty)
    managers.network:session():send_to_peers("sync_game_settings", job_id_index, level_id_index, difficulty_index)
    managers.network.matchmake:set_server_attributes(matchmake_attributes)
    managers.menu_component:on_job_updated()
    managers.menu:active_menu().logic:navigate_back(true)
    managers.menu:active_menu().logic:refresh_node("lobby", true)
  else
    managers.network.matchmake:create_lobby(matchmake_attributes)
  end
end

MenuCallbackHandler.play_single_player_job = function(l_12_0, l_12_1)
  l_12_0:play_single_player()
  l_12_0:start_single_player_job({job_id = l_12_1:parameter("job_id"), difficulty = "normal"})
end

MenuCallbackHandler.play_quick_start_job = function(l_13_0, l_13_1)
  l_13_0:start_job({job_id = l_13_1:parameter("job_id"), difficulty = "normal"})
end

MenuCallbackHandler.start_single_player_job = function(l_14_0, l_14_1)
  if not managers.job:activate_job(l_14_1.job_id) then
    return 
  end
  Global.game_settings.level_id = managers.job:current_level_id()
  Global.game_settings.mission = managers.job:current_mission()
  Global.game_settings.difficulty = l_14_1.difficulty
  l_14_0:lobby_start_the_game()
end

MenuCallbackHandler.crimenet_focus_changed = function(l_15_0, l_15_1, l_15_2)
  if l_15_2 then
    if l_15_1:parameters().no_servers then
      managers.crimenet:start_no_servers()
    else
      managers.crimenet:start()
    end
    managers.menu_component:create_crimenet_gui()
    if managers.controller:get_default_wrapper_type() ~= "pc" then
      managers.menu:active_menu().input:activate_controller_mouse()
    else
      managers.crimenet:stop()
      if managers.controller:get_default_wrapper_type() ~= "pc" then
        managers.menu:active_menu().input:deactivate_controller_mouse()
      end
      managers.menu_component:close_crimenet_gui()
    end
  end
end

MenuCallbackHandler.can_buy_weapon = function(l_16_0, l_16_1)
  return not Global.blackmarket_manager.weapons[l_16_1:parameter("weapon_id")].owned
end

MenuCallbackHandler.owns_weapon = function(l_17_0, l_17_1)
  return not l_17_0:can_buy_weapon(l_17_1)
end

MenuCallbackHandler.open_blackmarket_node = function(l_18_0)
  managers.menu:active_menu().logic:select_node("blackmarket")
end

MenuCallbackHandler.leave_blackmarket = function(l_19_0, ...)
  managers.menu_component:close_weapon_box()
  managers.menu_scene:remove_item()
  managers.blackmarket:release_preloaded_blueprints()
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuCallbackHandler._left_blackmarket = function(l_20_0)
  managers.menu_scene:remove_item()
end

MenuCallbackHandler.blackmarket_abort_customize_mask = function(l_21_0)
  managers.blackmarket:abort_customize_mask()
end

MenuCallbackHandler.got_skillpoint_to_spend = function(l_22_0)
  return not managers.skilltree or managers.skilltree:points() > 0
end

MenuCallbackHandler.got_new_lootdrop = function(l_23_0)
  if managers.blackmarket then
    return managers.blackmarket:got_any_new_drop()
  end
end

MenuCallbackHandler.test_clicked_weapon = function(l_24_0, l_24_1)
  if not l_24_1:parameter("customize") then
    managers.menu_scene:clicked_blackmarket_item()
    managers.menu_component:create_weapon_box(l_24_1:parameter("weapon_id"), {condition = math.round(l_24_1:parameter("condition") / l_24_1:_max_condition() * 100)})
  end
end

MenuCallbackHandler.buy_weapon = function(l_25_0, l_25_1)
  local name = managers.localization:text(tweak_data.weapon[l_25_1:parameter("weapon_id")].name_id)
  local cost = 50000
  local yes_func = callback(l_25_0, l_25_0, "on_buy_weapon_yes", {item = l_25_1, cost = cost})
  managers.menu:show_buy_weapon({yes_func = yes_func}, name, "$" .. cost)
end

MenuCallbackHandler.on_buy_weapon_yes = function(l_26_0, l_26_1)
  Global.blackmarket_manager.weapons[l_26_1.item:parameter("weapon_id")].owned = true
  l_26_1.item:parameter("parent_item"):parameters().owned = true
  l_26_1.item:dirty()
  l_26_1.item:parameters().parent_item:on_buy(l_26_1.item:parameters().gui_node)
end

MenuCallbackHandler.equip_weapon = function(l_27_0, l_27_1)
  Global.player_manager.kit.weapon_slots[l_27_1:parameter("weapon_slot")] = l_27_1:parameter("weapon_id")
  for weapon_id,data in pairs(Global.blackmarket_manager.weapons) do
    if weapon_id ~= l_27_1:parameter("weapon_id") then
      data.equipped = data.selection_index ~= l_27_1:parameter("weapon_slot")
    end
     -- Warning: missing end command somewhere! Added here
  end
end

MenuCallbackHandler.repair_weapon = function(l_28_0, l_28_1)
  if l_28_1:_at_max_condition() then
    return 
  end
  local name = managers.localization:text(tweak_data.weapon[l_28_1:parameter("weapon_id")].name_id)
  local cost = 50000 * (1 - l_28_1:parameter("parent_item"):condition() / l_28_1:_max_condition())
  local yes_func = callback(l_28_0, l_28_0, "on_repair_yes", {item = l_28_1, cost = cost})
  managers.menu:show_repair_weapon({yes_func = yes_func}, name, "$" .. cost)
end

MenuCallbackHandler.on_repair_yes = function(l_29_0, l_29_1)
  Global.blackmarket_manager.weapons[l_29_1.item:parameters().weapon_id].condition = l_29_1.item:_max_condition()
  l_29_1.item:dirty()
  l_29_0:test_clicked_weapon(l_29_1.item:parameters().parent_item)
end

MenuCallbackHandler.clicked_weapon_upgrade_type = function(l_30_0, l_30_1)
  managers.menu_scene:clicked_weapon_upgrade_type(l_30_1:parameters().name)
end

MenuCallbackHandler.clicked_weapon_upgrade = function(l_31_0, l_31_1)
  local weapon_id = l_31_1:parameter("weapon_id")
  local upgrade = l_31_1:parameter("weapon_upgrade")
  managers.menu_scene:view_weapon_upgrade(weapon_id, tweak_data.weapon_upgrades.upgrades[upgrade].visual_upgrade)
end

MenuCallbackHandler.can_buy_weapon_upgrade = function(l_32_0, l_32_1)
  return not l_32_0:owns_weapon_upgrade(l_32_1)
end

MenuCallbackHandler.owns_weapon_upgrade = function(l_33_0, l_33_1)
  return Global.blackmarket_manager.weapon_upgrades[l_33_1:parameter("weapon_id")][l_33_1:parameter("weapon_upgrade")].owned
end

MenuCallbackHandler.buy_weapon_upgrades = function(l_34_0, l_34_1)
end

MenuCallbackHandler.buy_weapon_upgrade = function(l_35_0, l_35_1)
  local name = managers.localization:text(tweak_data.weapon_upgrades.upgrades[l_35_1:parameter("weapon_upgrade")].name_id)
  local cost = 10000
  local yes_func = callback(l_35_0, l_35_0, "_on_buy_weapon_upgrade_yes", {item = l_35_1, cost = cost})
  managers.menu:show_buy_weapon({yes_func = yes_func}, name, "$" .. cost)
end

MenuCallbackHandler._on_buy_weapon_upgrade_yes = function(l_36_0, l_36_1)
  Global.blackmarket_manager.weapon_upgrades[l_36_1.item:parameter("weapon_id")][l_36_1.item:parameter("weapon_upgrade")].owned = true
  l_36_1.item:parameter("parent_item"):parameters().owned = true
  l_36_1.item:dirty()
  l_36_1.item:parameters().parent_item:on_buy(l_36_1.item:parameters().gui_node)
end

MenuCallbackHandler.attach_weapon_upgrade = function(l_37_0, l_37_1)
  local weapon_id = l_37_1:parameter("weapon_id")
  local upgrade = l_37_1:parameter("weapon_upgrade")
  local attach = not Global.blackmarket_manager.weapon_upgrades[weapon_id][upgrade].attached
  Global.blackmarket_manager.weapon_upgrades[weapon_id][upgrade].attached = not Global.blackmarket_manager.weapon_upgrades[weapon_id][upgrade].attached
  for _,_upgrade in ipairs(tweak_data.weapon_upgrades.weapon[weapon_id][l_37_1:parameter("upgrade_type")]) do
    if _upgrade ~= upgrade then
      Global.blackmarket_manager.weapon_upgrades[weapon_id][_upgrade].attached = false
    end
  end
end

MenuCallbackHandler.clicked_customize_character_category = function(l_38_0, l_38_1)
  local name = l_38_1:name()
  if name == "masks" and l_38_1:expanded() then
    managers.menu_scene:clicked_masks()
    return 
    do return end
    if name == "armor" and l_38_1:expanded() then
      managers.menu_scene:clicked_armor()
      return 
    end
  end
  managers.menu_scene:clicked_customize_character_category()
end

MenuCallbackHandler.test_clicked_mask = function(l_39_0, l_39_1)
  if not l_39_1:parameter("customize") then
    managers.menu_scene:clicked_blackmarket_item()
  end
  managers.menu_component:close_weapon_box()
  managers.menu_scene:spawn_mask(l_39_1:parameter("mask_id"))
end

MenuCallbackHandler.can_buy_mask = function(l_40_0, l_40_1)
  return not l_40_0:owns_mask(l_40_1)
end

MenuCallbackHandler.owns_mask = function(l_41_0, l_41_1)
  return Global.blackmarket_manager.masks[l_41_1:parameter("mask_id")].owned
end

MenuCallbackHandler.equip_mask = function(l_42_0, l_42_1)
  local mask_id = l_42_1:parameter("mask_id")
  managers.blackmarket:on_buy_mask(mask_id, "normal", 9)
  managers.blackmarket:equip_mask(9)
  l_42_0:_update_outfit_information()
end

MenuCallbackHandler._update_outfit_information = function(l_43_0)
  local outfit_string = managers.blackmarket:outfit_string()
  if l_43_0:is_win32(l_43_0) then
    Steam:set_rich_presence("outfit", outfit_string)
  end
  if managers.network:session() then
    local local_peer = managers.network:session():local_peer()
    if managers.menu_scene then
      local id = local_peer:id()
      managers.menu_scene:set_lobby_character_out_fit(id, outfit_string)
    end
    local kit_menu = managers.menu:get_menu("kit_menu")
    if kit_menu then
      local id = local_peer:id()
      local criminal_name = local_peer:character()
      kit_menu.renderer:set_slot_outfit(id, criminal_name, outfit_string)
    end
    local_peer:set_outfit_string(outfit_string)
    managers.network:session():send_to_peers_loaded("sync_outfit", outfit_string)
  end
end

MenuCallbackHandler.buy_mask = function(l_44_0, l_44_1)
  local name = managers.localization:text(tweak_data.blackmarket.masks[l_44_1:parameter("mask_id")].name_id)
  local cost = 10000
  local yes_func = callback(l_44_0, l_44_0, "_on_buy_mask_yes", {item = l_44_1, cost = cost})
  managers.menu:show_buy_weapon({yes_func = yes_func}, name, "$" .. cost)
end

MenuCallbackHandler._on_buy_mask_yes = function(l_45_0, l_45_1)
  Global.blackmarket_manager.masks[l_45_1.item:parameter("mask_id")].owned = true
  l_45_1.item:parameter("parent_item"):parameters().owned = true
  l_45_1.item:dirty()
  l_45_1.item:parameters().parent_item:on_buy(l_45_1.item:parameters().gui_node)
end

MenuCallbackHandler.leave_character_customization = function(l_46_0)
  l_46_0:leave_blackmarket()
end

MenuCallbackHandler.clicked_character = function(l_47_0, l_47_1)
  print("MenuCallbackHandler:clicked_character", l_47_1)
end

MenuCallbackHandler.equip_character = function(l_48_0, l_48_1)
  local character_id = l_48_1:parameter("character_id")
  Global.blackmarket_manager.characters[character_id].equipped = true
  managers.menu_scene:set_character(character_id)
  for id,character in pairs(Global.blackmarket_manager.characters) do
    if id ~= character_id then
      character.equipped = false
    end
  end
  l_48_0:_update_outfit_information()
end

MenuCallbackHandler.can_buy_character = function(l_49_0, l_49_1)
  return not l_49_0:owns_character(l_49_1)
end

MenuCallbackHandler.owns_character = function(l_50_0, l_50_1)
  return Global.blackmarket_manager.characters[l_50_1:parameter("character_id")].owned
end

MenuCallbackHandler.buy_character = function(l_51_0, l_51_1)
  local name = managers.localization:text(tweak_data.blackmarket.characters[l_51_1:parameter("character_id")].name_id)
  local cost = 10000
  local yes_func = callback(l_51_0, l_51_0, "_on_buy_character_yes", {item = l_51_1, cost = cost})
  managers.menu:show_buy_weapon({yes_func = yes_func}, name, "$" .. cost)
end

MenuCallbackHandler._on_buy_character_yes = function(l_52_0, l_52_1)
  Global.blackmarket_manager.characters[l_52_1.item:parameter("character_id")].owned = true
  l_52_1.item:parameter("parent_item"):parameters().owned = true
  l_52_1.item:dirty()
  l_52_1.item:parameters().parent_item:on_buy(l_52_1.item:parameters().gui_node)
end

MenuCallbackHandler.test_clicked_armor = function(l_53_0, l_53_1)
  managers.menu_component:close_weapon_box()
  if not l_53_1:parameter("customize") then
     -- Warning: missing end command somewhere! Added here
  end
end

MenuCallbackHandler.can_buy_armor = function(l_54_0, l_54_1)
  return not l_54_0:owns_armor(l_54_1)
end

MenuCallbackHandler.owns_armor = function(l_55_0, l_55_1)
  return Global.blackmarket_manager.armors[l_55_1:parameter("armor_id")].owned
end

MenuCallbackHandler.buy_armor = function(l_56_0, l_56_1)
  local name = managers.localization:text(tweak_data.blackmarket.armors[l_56_1:parameter("armor_id")].name_id)
  local cost = 20000
  local yes_func = callback(l_56_0, l_56_0, "_on_buy_armor_yes", {item = l_56_1, cost = cost})
  managers.menu:show_buy_weapon({yes_func = yes_func}, name, "$" .. cost)
end

MenuCallbackHandler._on_buy_armor_yes = function(l_57_0, l_57_1)
  Global.blackmarket_manager.armors[l_57_1.item:parameter("armor_id")].owned = true
  l_57_1.item:parameter("parent_item"):parameters().owned = true
  l_57_1.item:dirty()
  l_57_1.item:parameters().parent_item:on_buy(l_57_1.item:parameters().gui_node)
end

MenuCallbackHandler.equip_armor = function(l_58_0, l_58_1)
  local armor_id = l_58_1:parameter("armor_id")
  Global.blackmarket_manager.armors[armor_id].equipped = true
  managers.menu_scene:set_character_armor(armor_id)
  for id,armor in pairs(Global.blackmarket_manager.armors) do
    if id ~= armor_id then
      armor.equipped = false
    end
  end
  l_58_0:_update_outfit_information()
end

MenuCallbackHandler.repair_armor = function(l_59_0, l_59_1)
  if l_59_1:_at_max_condition() then
    return 
  end
  local armor_id = l_59_1:parameter("armor_id")
  local name = managers.localization:text(tweak_data.blackmarket.armors[armor_id].name_id)
  local cost = 30000 * (1 - l_59_1:parameter("parent_item"):condition() / l_59_1:_max_condition())
  local yes_func = callback(l_59_0, l_59_0, "on_repair_armor_yes", {item = l_59_1, cost = cost})
  managers.menu:show_repair_weapon({yes_func = yes_func}, name, "$" .. cost)
end

MenuCallbackHandler.on_repair_armor_yes = function(l_60_0, l_60_1)
  Global.blackmarket_manager.armors[l_60_1.item:parameters().armor_id].condition = l_60_1.item:_max_condition()
  l_60_1.item:dirty()
end

MenuCallbackHandler.stage_success = function(l_61_0)
  if not managers.job:has_active_job() then
    return true
  end
  return managers.job:stage_success()
end

MenuCallbackHandler.stage_not_success = function(l_62_0)
  return not l_62_0:stage_success()
end

MenuCallbackHandler.is_job_finished = function(l_63_0)
  return managers.job:is_job_finished()
end

MenuCallbackHandler.is_job_not_finished = function(l_64_0)
  return not l_64_0:is_job_finished()
end

MenuCallbackHandler.got_job = function(l_65_0)
  return managers.job:has_active_job()
end

MenuCallbackHandler.got_no_job = function(l_66_0)
  return not l_66_0:got_job()
end

if not MenuMarketItemInitiator then
  MenuMarketItemInitiator = class()
end
MenuMarketItemInitiator.modify_node = function(l_67_0, l_67_1)
  local node_name = l_67_1:parameters().name
  local armor_item = l_67_1:item("armor")
  l_67_0:_add_expand_armor(armor_item)
  local submachine_guns_item = l_67_1:item("submachine_guns")
  l_67_0:_add_expand_weapon(submachine_guns_item, 3)
  local assault_rifles_item = l_67_1:item("assault_rifles")
  l_67_0:_add_expand_weapon(assault_rifles_item, 2)
  local handguns_item = l_67_1:item("handguns")
  l_67_0:_add_expand_weapon(handguns_item, 1)
  local support_equipment_item = l_67_1:item("support_equipment")
  if support_equipment_item and l_67_0:_uses_owned_stats() then
    support_equipment_item:set_parameter("current", 1)
    support_equipment_item:set_parameter("total", 4)
  end
  local miscellaneous_item = l_67_1:item("miscellaneous")
  if miscellaneous_item and l_67_0:_uses_owned_stats() then
    miscellaneous_item:set_parameter("current", 0)
    miscellaneous_item:set_parameter("total", 6)
  end
  local masks_item = l_67_1:item("masks")
  l_67_0:_add_expand_mask(masks_item)
  local character_item = l_67_1:item("character")
  l_67_0:_add_expand_character(character_item)
  return l_67_1
end

MenuMarketItemInitiator._add_weapon = function(l_68_0, l_68_1)
  return true
end

MenuMarketItemInitiator._add_character = function(l_69_0, l_69_1)
  return true
end

MenuMarketItemInitiator._add_mask = function(l_70_0, l_70_1)
  return true
end

MenuMarketItemInitiator._add_armor = function(l_71_0, l_71_1)
  return true
end

MenuMarketItemInitiator._uses_owned_stats = function(l_72_0)
  return true
end

MenuMarketItemInitiator._add_weapon_params = function(l_73_0)
end

MenuMarketItemInitiator._add_mask_params = function(l_74_0, l_74_1)
end

MenuMarketItemInitiator._add_character_params = function(l_75_0, l_75_1)
end

MenuMarketItemInitiator._add_armor_params = function(l_76_0, l_76_1)
end

MenuMarketItemInitiator._add_expand_weapon = function(l_77_0, l_77_1, l_77_2)
  if not l_77_1 then
    return 
  end
  local i = 0
  local j = 0
  for weapon,data in pairs(tweak_data.weapon) do
    if data.autohit and data.use_data.selection_index == l_77_2 then
      i = i + 1
      local bm_data = Global.blackmarket_manager.weapons[weapon]
      local unlocked = bm_data.unlocked
      local owned = bm_data.owned
      if owned and unlocked then
        j = j + 1
      end
      local equipped = bm_data.equipped
      local condition = bm_data.condition
      if l_77_0:_add_weapon(bm_data) then
        local weapon_item = l_77_1:get_item(weapon)
        if not weapon_item then
           -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

        end
        local params = {type = "MenuItemWeaponExpand", name = weapon, text_id = data.name_id, callback = "test_clicked_weapon", weapon_id = weapon, unlocked = true, condition = condition, weapon_slot = l_77_2}
        l_77_0:_add_weapon_params(params)
        weapon_item = CoreMenuNode.MenuNode.create_item(l_77_1, params)
        l_77_1:add_item(weapon_item)
      end
      weapon_item:parameters().unlocked = unlocked
       -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

    end
    weapon_item:parameters().equipped = true
    weapon_item:parameters().owned = owned
    weapon_item:parameters().condition = condition
  end
end
end
if l_77_0:_uses_owned_stats() then
l_77_1:set_parameter("current", j)
l_77_1:set_parameter("total", i)
end
l_77_1:_show_items(nil)
return i
end

MenuMarketItemInitiator._add_expand_mask = function(l_78_0, l_78_1)
  local i = 0
  local j = 0
  for mask_id,data in pairs(tweak_data.blackmarket.masks) do
    i = i + 1
    local bm_data = Global.blackmarket_manager.masks[mask_id]
    local unlocked = bm_data.unlocked
    local owned = bm_data.owned
    local equipped = bm_data.equipped
    if owned then
      j = j + 1
    end
    if l_78_0:_add_mask(bm_data) then
      local mask_item = l_78_1:get_item(mask_id)
      if not mask_item then
         -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

      end
      local params = {type = "MenuItemMaskExpand", name = mask_id, text_id = data.name_id, callback = "test_clicked_mask", unlocked = true, mask_id = mask_id}
      l_78_0:_add_mask_params(params)
      mask_item = CoreMenuNode.MenuNode.create_item(l_78_1, params)
      l_78_1:add_item(mask_item)
    end
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  mask_item:parameters().equipped = true
  mask_item:parameters().owned = owned
end
end
if l_78_0:_uses_owned_stats() then
l_78_1:set_parameter("current", j)
l_78_1:set_parameter("total", i)
end
l_78_1:_show_items(nil)
return i
end

MenuMarketItemInitiator._add_expand_character = function(l_79_0, l_79_1)
  local i = 0
  local j = 0
  for character_id,data in pairs(tweak_data.blackmarket.characters) do
    i = i + 1
    local bm_data = Global.blackmarket_manager.characters[character_id]
    local unlocked = bm_data.unlocked
    local owned = bm_data.owned
    local equipped = bm_data.equipped
    if owned then
      j = j + 1
    end
    if l_79_0:_add_character(bm_data) then
      local character_item = l_79_1:get_item(character_id)
      if not character_item then
         -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

      end
      local params = {type = "MenuItemCharacterExpand", name = character_id, text_id = data.name_id, callback = "clicked_character", unlocked = true, character_id = character_id}
      l_79_0:_add_character_params(params)
      character_item = CoreMenuNode.MenuNode.create_item(l_79_1, params)
      l_79_1:add_item(character_item)
    end
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  character_item:parameters().equipped = true
  character_item:parameters().owned = owned
end
end
if l_79_0:_uses_owned_stats() then
l_79_1:set_parameter("current", j)
l_79_1:set_parameter("total", i)
end
l_79_1:_show_items(nil)
return i
end

MenuMarketItemInitiator._add_expand_armor = function(l_80_0, l_80_1)
  if not l_80_1 then
    return 
  end
  local i = 0
  local j = 0
  for armor_id,data in pairs(tweak_data.blackmarket.armors) do
    i = i + 1
    local bm_data = Global.blackmarket_manager.armors[armor_id]
    local unlocked = bm_data.unlocked
    local owned = bm_data.owned
    local equipped = bm_data.equipped
    local condition = bm_data.condition
    if owned then
      j = j + 1
    end
    if l_80_0:_add_armor(bm_data) then
      local armor_item = l_80_1:get_item(armor_id)
      if not armor_item then
        local params = {type = "MenuItemArmorExpand", name = armor_id, text_id = data.name_id, callback = "test_clicked_armor", armor_id = armor_id, condition = condition}
        l_80_0:_add_armor_params(params)
        armor_item = CoreMenuNode.MenuNode.create_item(l_80_1, params)
        l_80_1:add_item(armor_item)
      end
      armor_item:parameters().equipped = equipped
      armor_item:parameters().unlocked = unlocked
      armor_item:parameters().owned = owned
      armor_item:parameters().condition = condition
    end
  end
  if l_80_0:_uses_owned_stats() then
    l_80_1:set_parameter("current", j)
    l_80_1:set_parameter("total", i)
  end
  l_80_1:_show_items(nil)
  return i
end

if not MenuBlackMarketInitiator then
  MenuBlackMarketInitiator = class(MenuMarketItemInitiator)
end
if not MenuBuyUpgradesInitiator then
  MenuBuyUpgradesInitiator = class()
end
MenuBuyUpgradesInitiator.modify_node = function(l_81_0, l_81_1, l_81_2, l_81_3, l_81_4)
  local node = deep_clone(l_81_1)
  local node_name = node:parameters().name
  node:parameters().topic_id = tweak_data.weapon[l_81_2].name_id
  local scopes_item = node:item("scopes")
  l_81_0:_add_expand_upgrade(scopes_item, l_81_2, "scopes")
  local barrels_item = node:item("barrels")
  l_81_0:_add_expand_upgrade(barrels_item, l_81_2, "barrels")
  local grips_item = node:item("grips")
  l_81_0:_add_expand_upgrade(grips_item, l_81_2, "grips")
  return node
end

MenuBuyUpgradesInitiator._add_expand_upgrade = function(l_82_0, l_82_1, l_82_2, l_82_3)
  local i = 0
  local j = 0
  do
    local weapon_upgrades = tweak_data.weapon_upgrades.weapon[l_82_2]
    if weapon_upgrades then
      local upgrades = weapon_upgrades[l_82_3]
      if upgrades then
        for _,w_upgrade in ipairs(upgrades) do
          i = i + 1
          local owned = Global.blackmarket_manager.weapon_upgrades[l_82_2][w_upgrade].owned
          if owned then
            j = j + 1
          end
          {type = "MenuItemWeaponUpgradeExpand", name = w_upgrade, text_id = tweak_data.weapon_upgrades.upgrades[w_upgrade].name_id, callback = "clicked_weapon_upgrade"}.weapon_upgrade = w_upgrade
           -- DECOMPILER ERROR: Confused about usage of registers!

          {type = "MenuItemWeaponUpgradeExpand", name = w_upgrade, text_id = tweak_data.weapon_upgrades.upgrades[w_upgrade].name_id, callback = "clicked_weapon_upgrade"}.weapon_id = l_82_2
           -- DECOMPILER ERROR: Confused about usage of registers!

          {type = "MenuItemWeaponUpgradeExpand", name = w_upgrade, text_id = tweak_data.weapon_upgrades.upgrades[w_upgrade].name_id, callback = "clicked_weapon_upgrade"}.unlocked = Global.blackmarket_manager.weapon_upgrades[l_82_2][w_upgrade].unlocked
           -- DECOMPILER ERROR: Confused about usage of registers!

          {type = "MenuItemWeaponUpgradeExpand", name = w_upgrade, text_id = tweak_data.weapon_upgrades.upgrades[w_upgrade].name_id, callback = "clicked_weapon_upgrade"}.attached = Global.blackmarket_manager.weapon_upgrades[l_82_2][w_upgrade].attached
           -- DECOMPILER ERROR: Confused about usage of registers!

          {type = "MenuItemWeaponUpgradeExpand", name = w_upgrade, text_id = tweak_data.weapon_upgrades.upgrades[w_upgrade].name_id, callback = "clicked_weapon_upgrade"}.owned = owned
           -- DECOMPILER ERROR: Confused about usage of registers!

          {type = "MenuItemWeaponUpgradeExpand", name = w_upgrade, text_id = tweak_data.weapon_upgrades.upgrades[w_upgrade].name_id, callback = "clicked_weapon_upgrade"}.upgrade_type = l_82_3
           -- DECOMPILER ERROR: Confused at declaration of local variable

           -- DECOMPILER ERROR: Confused about usage of registers!

           -- DECOMPILER ERROR: Confused at declaration of local variable

          l_82_1:add_item(CoreMenuNode.MenuNode.create_item(l_82_1, {type = "MenuItemWeaponUpgradeExpand", name = w_upgrade, text_id = tweak_data.weapon_upgrades.upgrades[w_upgrade].name_id, callback = "clicked_weapon_upgrade"}))
        end
      end
    end
     -- DECOMPILER ERROR: Confused about usage of registers!

    l_82_1:set_parameter("current", j)
    l_82_1:set_parameter("total", i)
    l_82_1:_show_items(nil)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

if not MenuComponentInitiator then
  MenuComponentInitiator = class()
end
MenuComponentInitiator.modify_node = function(l_83_0, l_83_1, l_83_2)
  local node = deep_clone(l_83_1)
  if l_83_2 and l_83_2.back_callback then
    table.insert(node:parameters().back_callback, l_83_2.back_callback)
  end
  node:parameters().menu_component_data = l_83_2
  return node
end

if not MenuLoadoutInitiator then
  MenuLoadoutInitiator = class()
end
MenuLoadoutInitiator.modify_node = function(l_84_0, l_84_1, l_84_2)
  local node = deep_clone(l_84_1)
  node:parameters().menu_component_data = l_84_2
  node:parameters().menu_component_next_node_name = "loadout"
  return node
end

if not MenuCharacterCustomizationInitiator then
  MenuCharacterCustomizationInitiator = class(MenuMarketItemInitiator)
end
MenuCharacterCustomizationInitiator._add_weapon = function(l_85_0, l_85_1)
  if l_85_1.owned then
    return l_85_1.unlocked
  end
end

MenuCharacterCustomizationInitiator._add_character = function(l_86_0, l_86_1)
  if l_86_1.owned then
    return l_86_1.unlocked
  end
end

MenuCharacterCustomizationInitiator._add_mask = function(l_87_0, l_87_1)
  if l_87_1.owned then
    return l_87_1.unlocked
  end
end

MenuCharacterCustomizationInitiator._add_armor = function(l_88_0, l_88_1)
  if l_88_1.owned then
    return l_88_1.unlocked
  end
end

MenuCharacterCustomizationInitiator._uses_owned_stats = function(l_89_0)
  return false
end

MenuCharacterCustomizationInitiator._add_weapon_params = function(l_90_0, l_90_1)
  l_90_1.customize = true
end

MenuCharacterCustomizationInitiator._add_mask_params = function(l_91_0, l_91_1)
  l_91_1.customize = true
end

MenuCharacterCustomizationInitiator._add_character_params = function(l_92_0, l_92_1)
  l_92_1.customize = true
end

MenuCharacterCustomizationInitiator._add_armor_params = function(l_93_0, l_93_1)
  l_93_1.customize = true
end

if not MenuCrimeNetInitiator then
  MenuCrimeNetInitiator = class()
end
MenuCrimeNetInitiator.modify_node = function(l_94_0, l_94_1)
  local new_node = deep_clone(l_94_1)
  l_94_0:refresh_node(new_node)
  return new_node
end

MenuCrimeNetInitiator.refresh_node = function(l_95_0, l_95_1)
  return l_95_1
  local dead_list = {}
  for _,item in ipairs(l_95_1:items()) do
    dead_list[item:parameters().name] = true
  end
  local online = {}
  do
    local offline = {}
    for _,user in ipairs(Steam:friends()) do
      if (math.random(2) == 1 and user:state() == "online") or user:state() == "away" then
        table.insert(online, user)
        for (for control),_ in (for generator) do
        end
        table.insert(offline, user)
      end
      l_95_1:delete_item("online")
      if not l_95_1:item("online") then
        local params = {type = "MenuItemDivider", name = "online", text_id = "menu_online"}
        local new_item = l_95_1:create_item({type = "MenuItemDivider"}, params)
        l_95_1:add_item(new_item)
      end
      for _,user in ipairs(online) do
        local name = user:id()
        local item = l_95_1:item(name)
        if item then
          l_95_1:delete_item(name)
        end
        local params = {name = name, text_id = user:name(), localize = "false"}
        local new_item = l_95_1:create_item(nil, params)
        l_95_1:add_item(new_item)
      end
      l_95_1:delete_item("offline")
      if not l_95_1:item("offline") then
        local params = {type = "MenuItemDivider", name = "offline", text_id = "menu_offline"}
        local new_item = l_95_1:create_item({type = "MenuItemDivider"}, params)
        l_95_1:add_item(new_item)
      end
      for _,user in ipairs(offline) do
        local name = user:id()
        local item = l_95_1:item(name)
        if item then
          l_95_1:delete_item(name)
        end
        local params = {name = name, text_id = user:name(), localize = "false"}
        local new_item = l_95_1:create_item(nil, params)
        l_95_1:add_item(new_item)
      end
      for name,_ in pairs(dead_list) do
      end
      managers.menu:add_back_button(l_95_1)
      return l_95_1
    end
     -- Warning: missing end command somewhere! Added here
  end
end

MenuManager.show_repair_weapon = function(l_96_0, l_96_1, l_96_2, l_96_3)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_repair_weapon_title")
  dialog_data.text = managers.localization:text("dialog_repair_weapon_message", {WEAPON = l_96_2, COST = l_96_3})
  local yes_button = {}
  yes_button.text = managers.localization:text("dialog_yes")
  yes_button.callback_func = l_96_1.yes_func
  local no_button = {}
  no_button.text = managers.localization:text("dialog_no")
  dialog_data.button_list = {yes_button, no_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_buy_weapon = function(l_97_0, l_97_1, l_97_2, l_97_3)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_buy_weapon_title")
  dialog_data.text = managers.localization:text("dialog_buy_weapon_message", {WEAPON = l_97_2, COST = l_97_3})
  local yes_button = {}
  yes_button.text = managers.localization:text("dialog_yes")
  yes_button.callback_func = l_97_1.yes_func
  local no_button = {}
  no_button.text = managers.localization:text("dialog_no")
  dialog_data.button_list = {yes_button, no_button}
  managers.system_menu:show(dialog_data)
end


