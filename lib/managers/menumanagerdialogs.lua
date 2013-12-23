-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menumanagerdialogs.luac 

MenuManager.show_retrieving_servers_dialog = function(l_1_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_retrieving_servers_title")
  dialog_data.text = managers.localization:text("dialog_wait")
  dialog_data.id = "find_server"
  dialog_data.no_buttons = true
  managers.system_menu:show(dialog_data)
end

MenuManager.show_get_world_list_dialog = function(l_2_0, l_2_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_logging_in")
  dialog_data.text = managers.localization:text("dialog_wait")
  dialog_data.id = "get_world_list"
  local cancel_button = {}
  cancel_button.text = managers.localization:text("dialog_cancel")
  cancel_button.callback_func = l_2_1.cancel_func
  dialog_data.button_list = {cancel_button}
  dialog_data.indicator = true
  managers.system_menu:show(dialog_data)
end

MenuManager.show_game_permission_changed_dialog = function(l_3_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_error_title")
  dialog_data.text = managers.localization:text("dialog_game_permission_changed")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_too_low_level = function(l_4_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_error_title")
  dialog_data.text = managers.localization:text("dialog_too_low_level")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_too_low_level_ovk145 = function(l_5_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_error_title")
  dialog_data.text = managers.localization:text("dialog_too_low_level_ovk145")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_does_not_own_heist = function(l_6_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_error_title")
  dialog_data.text = managers.localization:text("dialog_does_not_own_heist")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_does_not_own_heist_info = function(l_7_0, l_7_1, l_7_2)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_error_title")
  dialog_data.text = managers.localization:text("dialog_does_not_own_heist_info", {HEIST = string.upper(l_7_1), PLAYER = string.upper(l_7_2)})
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_failed_joining_dialog = function(l_8_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_error_title")
  dialog_data.text = managers.localization:text("dialog_err_failed_joining_lobby")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_cant_join_from_game_dialog = function(l_9_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_error_title")
  dialog_data.text = managers.localization:text("dialog_err_cant_join_from_game")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_game_started_dialog = function(l_10_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_error_title")
  dialog_data.text = managers.localization:text("dialog_game_started")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_joining_lobby_dialog = function(l_11_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_joining_lobby_title")
  dialog_data.text = managers.localization:text("dialog_wait")
  dialog_data.id = "join_server"
  dialog_data.no_buttons = true
  dialog_data.indicator = true
  managers.system_menu:show(dialog_data)
end

MenuManager.show_no_connection_to_game_servers_dialog = function(l_12_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_error_title")
  dialog_data.text = managers.localization:text("dialog_no_connection_to_game_servers")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_person_joining = function(l_13_0, l_13_1, l_13_2)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_dropin_title", {USER = string.upper(l_13_2)})
  dialog_data.text = managers.localization:text("dialog_wait") .. " 0%"
  dialog_data.id = "user_dropin" .. l_13_1
  dialog_data.no_buttons = true
  managers.system_menu:show(dialog_data)
end

MenuManager.show_corrupt_dlc = function(l_14_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_error_title")
  dialog_data.text = managers.localization:text("dialog_fail_load_dlc_corrupt")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.close_person_joining = function(l_15_0, l_15_1)
  managers.system_menu:close("user_dropin" .. l_15_1)
end

MenuManager.update_person_joining = function(l_16_0, l_16_1, l_16_2)
  local dlg = managers.system_menu:get_dialog("user_dropin" .. l_16_1)
  if dlg then
    dlg:set_text(managers.localization:text("dialog_wait") .. " " .. tostring(l_16_2) .. "%")
  end
end

MenuManager.show_kick_peer_dialog = function(l_17_0)
end

MenuManager.show_peer_kicked_dialog = function(l_18_0, l_18_1)
  local title = Global.on_remove_dead_peer_message and "dialog_information_title" or "dialog_mp_kicked_out_title"
  local dialog_data = {}
  dialog_data.title = managers.localization:text(title)
  dialog_data.text = managers.localization:text(Global.on_remove_dead_peer_message or "dialog_mp_kicked_out_message")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  if l_18_1 then
    ok_button.callback_func = l_18_1.ok_func
  end
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
  Global.on_remove_dead_peer_message = nil
end

MenuManager.show_default_option_dialog = function(l_19_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_default_options_title")
  dialog_data.text = managers.localization:text("dialog_default_options_message")
  local yes_button = {}
  yes_button.text = managers.localization:text("dialog_yes")
  yes_button.callback_func = function()
    managers.user:reset_setting_map()
   end
  local no_button = {}
  no_button.text = managers.localization:text("dialog_no")
  no_button.cancel_button = true
  dialog_data.button_list = {yes_button, no_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_err_not_signed_in_dialog = function(l_20_0)
  local dialog_data = {}
  dialog_data.title = string.upper(managers.localization:text("dialog_error_title"))
  dialog_data.text = managers.localization:text("dialog_err_not_signed_in")
  dialog_data.no_upper = true
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  ok_button.callback_func = function()
    self._showing_disconnect_message = nil
   end
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_mp_disconnected_internet_dialog = function(l_21_0, l_21_1)
  local dialog_data = {}
  dialog_data.title = string.upper(managers.localization:text("dialog_warning_title"))
  dialog_data.text = managers.localization:text("dialog_mp_disconnected_internet")
  dialog_data.no_upper = true
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  ok_button.callback_func = l_21_1.ok_func
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_err_no_chat_parental_control = function(l_22_0)
  local dialog_data = {}
  dialog_data.title = string.upper(managers.localization:text("dialog_information_title"))
  dialog_data.text = managers.localization:text("dialog_no_chat_parental_control")
  dialog_data.no_upper = true
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_err_under_age = function(l_23_0)
  local dialog_data = {}
  dialog_data.title = string.upper(managers.localization:text("dialog_information_title"))
  dialog_data.text = managers.localization:text("dialog_age_restriction")
  dialog_data.no_upper = true
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_waiting_for_server_response = function(l_24_0, l_24_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_waiting_for_server_response_title")
  dialog_data.text = managers.localization:text("dialog_wait")
  dialog_data.id = "waiting_for_server_response"
  dialog_data.indicator = true
  local cancel_button = {}
  cancel_button.text = managers.localization:text("dialog_cancel")
  cancel_button.callback_func = l_24_1.cancel_func
  dialog_data.button_list = {cancel_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_request_timed_out_dialog = function(l_25_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_request_timed_out_title")
  dialog_data.text = managers.localization:text("dialog_request_timed_out_message")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_restart_game_dialog = function(l_26_0, l_26_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_warning_title")
  dialog_data.text = managers.localization:text("dialog_show_restart_game_message")
  local yes_button = {}
  yes_button.text = managers.localization:text("dialog_yes")
  yes_button.callback_func = l_26_1.yes_func
  local no_button = {}
  no_button.text = managers.localization:text("dialog_no")
  no_button.cancel_button = true
  dialog_data.button_list = {yes_button, no_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_no_invites_message = function(l_27_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_information_title")
  dialog_data.text = managers.localization:text("dialog_mp_no_invites_message")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_invite_wrong_version_message = function(l_28_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_information_title")
  dialog_data.text = managers.localization:text("dialog_mp_invite_wrong_version_message")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_invite_join_message = function(l_29_0, l_29_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_information_title")
  dialog_data.text = managers.localization:text("dialog_mp_invite_join_message")
  dialog_data.id = "invite_join_message"
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  ok_button.callback_func = l_29_1.ok_func
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_pending_invite_message = function(l_30_0, l_30_1)
  local dialog_data = {}
  dialog_data.title = string.upper(managers.localization:text("dialog_information_title"))
  dialog_data.text = managers.localization:text("dialog_mp_pending_invite_short_message")
  dialog_data.no_upper = true
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  ok_button.callback_func = l_30_1.ok_func
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_NPCommerce_open_fail = function(l_31_0, l_31_1)
  local dialog_data = {}
  dialog_data.title = string.upper(managers.localization:text("dialog_error_title"))
  dialog_data.text = managers.localization:text("dialog_npcommerce_fail_open")
  dialog_data.no_upper = true
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_NPCommerce_checkout_fail = function(l_32_0, l_32_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_error_title")
  dialog_data.text = managers.localization:text("dialog_npcommerce_checkout_fail")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_waiting_NPCommerce_open = function(l_33_0, l_33_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_npcommerce_opening")
  dialog_data.text = string.upper(managers.localization:text("dialog_wait"))
  dialog_data.id = "waiting_for_NPCommerce_open"
  dialog_data.no_upper = true
  dialog_data.no_buttons = true
  dialog_data.indicator = true
  managers.system_menu:show(dialog_data)
end

MenuManager.show_NPCommerce_browse_fail = function(l_34_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_error_title")
  dialog_data.text = managers.localization:text("dialog_npcommerce_browse_fail")
  dialog_data.no_upper = true
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_NPCommerce_browse_success = function(l_35_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_transaction_successful")
  dialog_data.text = managers.localization:text("dialog_npcommerce_need_install")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_accept_gfx_settings_dialog = function(l_36_0, l_36_1)
  local count = 10
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_accept_changes_title")
  dialog_data.text = managers.localization:text("dialog_accept_changes", {TIME = count})
  dialog_data.id = "accept_changes"
  local cancel_button = {}
  cancel_button.text = managers.localization:text("dialog_cancel")
  cancel_button.callback_func = l_36_1
  cancel_button.cancel_button = true
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button, cancel_button}
  dialog_data.counter = {1, function()
    count = count - 1
    if count < 0 then
      func()
      managers.system_menu:close(dialog_data.id)
    else
      local dlg = managers.system_menu:get_dialog(dialog_data.id)
      if dlg then
        dlg:set_text(managers.localization:text("dialog_accept_changes", {TIME = count}), true)
      end
    end
   end}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_key_binding_collision = function(l_37_0, l_37_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_error_title")
  dialog_data.text = managers.localization:text("dialog_key_binding_collision", l_37_1)
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_key_binding_forbidden = function(l_38_0, l_38_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_error_title")
  dialog_data.text = managers.localization:text("dialog_key_binding_forbidden", l_38_1)
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_new_item_gained = function(l_39_0, l_39_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_new_unlock_title")
  dialog_data.text = managers.localization:text("dialog_new_unlock_" .. l_39_1.category, l_39_1)
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  local texture, render_template, shapes = nil, nil, nil
  local category = l_39_1.data[1]
  local id = l_39_1.data[2]
  if category == "weapon_mods" then
    local part_id = id
    texture = "guis/textures/pd2/blackmarket/icons/mods/" .. tostring(part_id)
  elseif category == "colors" then
    local color_tweak_data = _G.tweak_data.blackmarket.colors[id]
    local shape_template = {type = "bitmap", texture = "guis/textures/pd2/blackmarket/icons/colors/color_bg", color = tweak_data.screen_colors.text, w = 128, h = 128, layer = 1, x = 0.5, y = 0.5}
    shapes = {}
    table.insert(shapes, shape_template)
    shape_template = deep_clone(shape_template)
    shape_template.layer = 0
    shape_template.color = color_tweak_data.colors[1]
    shape_template.texture = "guis/textures/pd2/blackmarket/icons/colors/color_01"
    table.insert(shapes, shape_template)
    shape_template = deep_clone(shape_template)
    shape_template.color = color_tweak_data.colors[2]
    shape_template.texture = "guis/textures/pd2/blackmarket/icons/colors/color_02"
    table.insert(shapes, shape_template)
  elseif category == "primaries" or category == "secondaries" then
    texture = "guis/textures/pd2/blackmarket/icons/weapons/" .. managers.weapon_factory:get_weapon_id_by_factory_id(id)
  elseif category == "textures" then
    texture = _G.tweak_data.blackmarket.textures[id].texture
    render_template = Idstring("VertexColorTexturedPatterns")
  else
    texture = "guis/textures/pd2/blackmarket/icons/" .. tostring(category) .. "/" .. tostring(id)
  end
  dialog_data.texture = texture
  dialog_data.render_template = render_template
  dialog_data.shapes = shapes
  dialog_data.sound_event = l_39_1.sound_event
  managers.system_menu:show_new_unlock(dialog_data)
end

MenuManager.show_mask_mods_available = function(l_40_0, l_40_1)
  local dialog_data = {}
  dialog_data.title = ""
  dialog_data.text = l_40_1.text_block
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  dialog_data.text_blend_mode = "add"
  dialog_data.use_text_formating = true
  dialog_data.text_formating_color = Color.white
  dialog_data.text_formating_color_table = l_40_1.color_table
  managers.system_menu:show_new_unlock(dialog_data)
end

MenuManager.show_weapon_mods_available = function(l_41_0, l_41_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("bm_menu_available_mods")
  dialog_data.text = l_41_1.text_block
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  dialog_data.texture = "guis/textures/pd2/blackmarket/icons/weapons/" .. tostring(l_41_1.weapon_id)
  dialog_data.text_blend_mode = "add"
  dialog_data.use_text_formating = true
  dialog_data.text_formating_color = Color.white
  dialog_data.text_formating_color_table = l_41_1.color_table
  managers.system_menu:show_new_unlock(dialog_data)
end

MenuManager.show_confirm_skillpoints = function(l_42_0, l_42_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_skills_place_title")
  dialog_data.text = managers.localization:text(l_42_1.text_string, {skill = l_42_1.skill_name_localized, points = l_42_1.points, remaining_points = l_42_1.remaining_points, cost = managers.experience:cash_string(l_42_1.cost)})
  dialog_data.focus_button = 1
  local yes_button = {}
  yes_button.text = managers.localization:text("dialog_yes")
  yes_button.callback_func = l_42_1.yes_func
  local no_button = {}
  no_button.text = managers.localization:text("dialog_no")
  no_button.callback_func = l_42_1.no_func
  no_button.cancel_button = true
  dialog_data.button_list = {yes_button, no_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_confirm_respec_skilltree = function(l_43_0, l_43_1)
  local tree_name = managers.localization:text(tweak_data.skilltree.trees[l_43_1.tree].name_id)
  local cost = managers.money:get_skilltree_tree_respec_cost(l_43_1.tree)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_skills_respec_title")
  dialog_data.text = managers.localization:text("dialog_respec_skilltree", {tree = tree_name, cost = managers.experience:cash_string(cost)})
  dialog_data.focus_button = 2
  local yes_button = {}
  yes_button.text = managers.localization:text("dialog_yes")
  yes_button.callback_func = l_43_1.yes_func
  local no_button = {}
  no_button.text = managers.localization:text("dialog_no")
  no_button.callback_func = l_43_1.no_func
  no_button.cancel_button = true
  dialog_data.button_list = {yes_button, no_button}
  dialog_data.no_upper = true
  managers.system_menu:show(dialog_data)
end

MenuManager.show_skilltree_reseted = function(l_44_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_skills_reseted_title")
  dialog_data.text = managers.localization:text("dialog_skilltree_reseted")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_confirm_blackmarket_sell_no_slot = function(l_45_0, l_45_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_bm_mask_sell_title")
  dialog_data.text = managers.localization:text("dialog_blackmarket_item", {item = l_45_1.name}) .. "\n\n" .. managers.localization:text("dialog_blackmarket_slot_item_sell", {money = l_45_1.money})
  dialog_data.focus_button = 2
  local yes_button = {}
  yes_button.text = managers.localization:text("dialog_yes")
  yes_button.callback_func = l_45_1.yes_func
  local no_button = {}
  no_button.text = managers.localization:text("dialog_no")
  no_button.callback_func = l_45_1.no_func
  no_button.cancel_button = true
  dialog_data.button_list = {yes_button, no_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_confirm_blackmarket_sell = function(l_46_0, l_46_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_bm_crafted_sell_title")
  dialog_data.text = managers.localization:text("dialog_blackmarket_slot_item", {slot = l_46_1.slot, item = l_46_1.name}) .. "\n\n" .. managers.localization:text("dialog_blackmarket_slot_item_sell", {money = l_46_1.money})
  dialog_data.focus_button = 2
  local yes_button = {}
  yes_button.text = managers.localization:text("dialog_yes")
  yes_button.callback_func = l_46_1.yes_func
  local no_button = {}
  no_button.text = managers.localization:text("dialog_no")
  no_button.callback_func = l_46_1.no_func
  no_button.cancel_button = true
  dialog_data.button_list = {yes_button, no_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_confirm_blackmarket_buy = function(l_47_0, l_47_1)
  local num_in_inventory = ""
  local num_of_same = managers.blackmarket:get_crafted_item_amount(l_47_1.category, l_47_1.weapon)
  if num_of_same > 0 then
    num_in_inventory = managers.localization:text("dialog_blackmarket_num_in_inventory", {item = l_47_1.name, amount = num_of_same})
  end
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_bm_weapon_buy_title")
  dialog_data.text = managers.localization:text("dialog_blackmarket_buy_item", {item = l_47_1.name, money = l_47_1.money, num_in_inventory = num_in_inventory})
  dialog_data.focus_button = 2
  local yes_button = {}
  yes_button.text = managers.localization:text("dialog_yes")
  yes_button.callback_func = l_47_1.yes_func
  local no_button = {}
  no_button.text = managers.localization:text("dialog_no")
  no_button.callback_func = l_47_1.no_func
  no_button.cancel_button = true
  dialog_data.button_list = {yes_button, no_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_confirm_blackmarket_mod = function(l_48_0, l_48_1)
  local l_local = managers.localization
  local dialog_data = {}
  dialog_data.focus_button = 2
  dialog_data.title = l_local:text("dialog_bm_weapon_modify_title")
  dialog_data.text = l_local:text("dialog_blackmarket_slot_item", {slot = l_48_1.slot, item = l_48_1.weapon_name}) .. "\n\n" .. l_local:text("dialog_blackmarket_mod_" .. (l_48_1.add and "add" or "remove"), {mod = l_48_1.name}) .. "\n"
  local warn_lost_mods = false
  if l_48_1.add and l_48_1.replaces and #l_48_1.replaces > 0 then
    dialog_data.text = dialog_data.text .. l_local:text("dialog_blackmarket_mod_replace", {mod = managers.weapon_factory:get_part_name_by_part_id(l_48_1.replaces[1])}) .. "\n"
    warn_lost_mods = true
  end
  if l_48_1.removes and #l_48_1.removes > 0 then
    local mods = ""
    for _,mod_name in ipairs(l_48_1.removes) do
      mods = mods .. "\n" .. managers.weapon_factory:get_part_name_by_part_id(mod_name)
    end
    dialog_data.text = dialog_data.text .. "\n" .. l_local:text("dialog_blackmarket_mod_conflict", {mods = mods}) .. "\n"
    warn_lost_mods = true
  end
  if warn_lost_mods or not l_48_1.add then
    dialog_data.text = dialog_data.text .. "\n" .. l_local:text("dialog_blackmarket_lost_mods_warning")
  end
  if l_48_1.add then
    dialog_data.text = dialog_data.text .. "\n" .. l_local:text("dialog_blackmarket_mod_cost", {money = l_48_1.money})
  end
  local yes_button = {}
  yes_button.text = managers.localization:text("dialog_yes")
  yes_button.callback_func = l_48_1.yes_func
  local no_button = {}
  no_button.text = managers.localization:text("dialog_no")
  no_button.callback_func = l_48_1.no_func
  no_button.cancel_button = true
  dialog_data.button_list = {yes_button, no_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_confirm_blackmarket_assemble = function(l_49_0, l_49_1)
  local num_in_inventory = ""
  local num_of_same = managers.blackmarket:get_crafted_item_amount(l_49_1.category, l_49_1.weapon)
  if num_of_same > 0 then
    num_in_inventory = managers.localization:text("dialog_blackmarket_num_in_inventory", {item = l_49_1.name, amount = num_of_same})
  end
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_bm_mask_assemble_title")
  dialog_data.text = managers.localization:text("dialog_blackmarket_assemble_item", {item = l_49_1.name, num_in_inventory = num_in_inventory})
  dialog_data.focus_button = 2
  local yes_button = {}
  yes_button.text = managers.localization:text("dialog_yes")
  yes_button.callback_func = l_49_1.yes_func
  local no_button = {}
  no_button.text = managers.localization:text("dialog_no")
  no_button.callback_func = l_49_1.no_func
  no_button.cancel_button = true
  dialog_data.button_list = {yes_button, no_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_confirm_blackmarket_abort = function(l_50_0, l_50_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_bm_mask_custom_abort")
  dialog_data.text = managers.localization:text("dialog_blackmarket_abort_mask_warning")
  dialog_data.focus_button = 1
  local yes_button = {}
  yes_button.text = managers.localization:text("dialog_yes")
  yes_button.callback_func = l_50_1.yes_func
  local no_button = {}
  no_button.text = managers.localization:text("dialog_no")
  no_button.callback_func = l_50_1.no_func
  no_button.cancel_button = true
  dialog_data.button_list = {yes_button, no_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_confirm_blackmarket_finalize = function(l_51_0, l_51_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_bm_mask_custom_final_title")
  dialog_data.text = managers.localization:text("dialog_blackmarket_finalize_item", {money = l_51_1.money, ITEM = managers.localization:text("dialog_blackmarket_slot_item", {item = l_51_1.name, slot = l_51_1.slot})})
  dialog_data.focus_button = 2
  local yes_button = {}
  yes_button.text = managers.localization:text("dialog_yes")
  yes_button.callback_func = l_51_1.yes_func
  local no_button = {}
  no_button.text = managers.localization:text("dialog_no")
  no_button.callback_func = l_51_1.no_func
  no_button.cancel_button = true
  dialog_data.button_list = {yes_button, no_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_confirm_mission_asset_buy = function(l_52_0, l_52_1)
  local asset_tweak_data = managers.assets:get_asset_tweak_data_by_id(l_52_1.asset_id)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_assets_buy_title")
  dialog_data.text = managers.localization:text("dialog_mission_asset_buy", {asset_desc = managers.localization:text(asset_tweak_data.unlock_desc_id or "menu_asset_unknown_unlock_desc"), cost = managers.experience:cash_string(managers.money:get_mission_asset_cost_by_id(l_52_1.asset_id))})
  dialog_data.focus_button = 2
  local yes_button = {}
  yes_button.text = managers.localization:text("dialog_yes")
  yes_button.callback_func = l_52_1.yes_func
  local no_button = {}
  no_button.text = managers.localization:text("dialog_no")
  no_button.callback_func = l_52_1.no_func
  no_button.cancel_button = true
  dialog_data.button_list = {yes_button, no_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_accept_crime_net_job = function(l_53_0, l_53_1)
  local dialog_data = {}
  dialog_data.title = l_53_1.title
  dialog_data.text = l_53_1.player_text .. "\n\n" .. l_53_1.desc
  dialog_data.focus_button = 1
  local yes_button = {}
  yes_button.text = managers.localization:text("dialog_accept")
  yes_button.callback_func = l_53_1.yes_func
  local no_button = {}
  no_button.text = managers.localization:text("dialog_no")
  no_button.callback_func = l_53_1.no_func
  no_button.cancel_button = true
  dialog_data.button_list = {yes_button, no_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_storage_removed_dialog = function(l_54_0, l_54_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_warning_title")
  dialog_data.text = managers.localization:text("dialog_storage_removed_warning_X360")
  dialog_data.force = true
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_continue")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show_platform(dialog_data)
end

MenuManager.show_game_is_full = function(l_55_0, l_55_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_error_title")
  dialog_data.text = managers.localization:text("dialog_err_room_is_full")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_game_no_longer_exists = function(l_56_0, l_56_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_error_title")
  dialog_data.text = managers.localization:text("dialog_err_room_no_longer_exists")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_game_is_full = function(l_57_0, l_57_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_error_title")
  dialog_data.text = managers.localization:text("dialog_err_room_is_full")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_wrong_version_message = function(l_58_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_information_title")
  dialog_data.text = managers.localization:text("dialog_err_wrong_version_message")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_inactive_user_accepted_invite = function(l_59_0, l_59_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_information_title")
  dialog_data.text = managers.localization:text("dialog_inactive_user_accepted_invite")
  dialog_data.id = "inactive_user_accepted_invite"
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  ok_button.callback_func = l_59_1.ok_func
  dialog_data.button_list = {ok_button}
  managers.system_menu:add_init_show(dialog_data)
end

MenuManager.show_question_start_tutorial = function(l_60_0, l_60_1)
  local dialog_data = {}
  dialog_data.focus_button = 1
  dialog_data.title = managers.localization:text("dialog_safehouse_title")
  dialog_data.text = managers.localization:text("dialog_safehouse_text")
  local yes_button = {}
  yes_button.text = managers.localization:text("dialog_yes")
  yes_button.callback_func = l_60_1.yes_func
  local no_button = {}
  no_button.text = managers.localization:text("dialog_no")
  dialog_data.button_list = {yes_button, no_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_leave_safehouse_dialog = function(l_61_0, l_61_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_safehouse_title")
  dialog_data.text = managers.localization:text("dialog_are_you_sure_you_want_to_leave_game")
  local yes_button = {}
  yes_button.text = managers.localization:text("dialog_yes")
  yes_button.callback_func = l_61_1.yes_func
  local no_button = {}
  no_button.text = managers.localization:text("dialog_no")
  dialog_data.button_list = {yes_button, no_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_save_settings_failed = function(l_62_0, l_62_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_error_title")
  dialog_data.text = managers.localization:text("dialog_save_settings_failed")
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_continue")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_play_safehouse_question = function(l_63_0, l_63_1)
  local dialog_data = {}
  dialog_data.focus_button = 1
  dialog_data.title = managers.localization:text("dialog_safehouse_title")
  dialog_data.text = managers.localization:text("dialog_safehouse_goto_text")
  local yes_button = {}
  yes_button.text = managers.localization:text("dialog_yes")
  yes_button.callback_func = l_63_1.yes_func
  local no_button = {}
  no_button.cancel_button = true
  no_button.text = managers.localization:text("dialog_no")
  dialog_data.button_list = {yes_button, no_button}
  managers.system_menu:show(dialog_data)
end

MenuManager.show_savefile_wrong_version = function(l_64_0, l_64_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_information_title")
  dialog_data.text = managers.localization:text(l_64_1.error_msg)
  dialog_data.id = "wrong_version"
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:add_init_show(dialog_data)
end

MenuManager.show_savefile_wrong_user = function(l_65_0, l_65_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_information_title")
  dialog_data.text = managers.localization:text("dialog_load_wrong_user")
  dialog_data.id = "wrong_user"
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  dialog_data.button_list = {ok_button}
  managers.system_menu:add_init_show(dialog_data)
end

MenuManager.show_abort_mission_dialog = function(l_66_0, l_66_1)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_warning_title")
  dialog_data.text = managers.localization:text("dialog_abort_mission_text")
  local yes_button = {}
  yes_button.text = managers.localization:text("dialog_yes")
  yes_button.callback_func = l_66_1.yes_func
  local no_button = {}
  no_button.text = managers.localization:text("dialog_no")
  dialog_data.button_list = {yes_button, no_button}
  managers.system_menu:show(dialog_data)
end


