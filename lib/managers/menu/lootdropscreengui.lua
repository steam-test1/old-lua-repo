-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\lootdropscreengui.luac 

if not LootDropScreenGui then
  LootDropScreenGui = class()
end
LootDropScreenGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0._safe_workspace = l_1_1
  l_1_0._full_workspace = l_1_2
  l_1_0._lootscreen_hud = l_1_3
  l_1_0._lootscreen_hud:add_callback("on_peer_ready", callback(l_1_0, l_1_0, "check_all_ready"))
  l_1_0._fullscreen_panel = l_1_0._full_workspace:panel():panel()
  l_1_0._panel = l_1_0._safe_workspace:panel():panel()
  l_1_0._no_loot_for_me = not managers.job:is_job_finished()
  if not l_1_0._lootscreen_hud:is_active() then
    l_1_0._panel:hide()
    l_1_0._fullscreen_panel:hide()
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_1_0._continue_button, {name = "ready_button", text = utf8.to_upper(managers.localization:text("menu_l_waiting_for_all"))}.layer, {name = "ready_button", text = utf8.to_upper(managers.localization:text("menu_l_waiting_for_all"))}.color, {name = "ready_button", text = utf8.to_upper(managers.localization:text("menu_l_waiting_for_all"))}.font, {name = "ready_button", text = utf8.to_upper(managers.localization:text("menu_l_waiting_for_all"))}.font_size, {name = "ready_button", text = utf8.to_upper(managers.localization:text("menu_l_waiting_for_all"))}.vertical, {name = "ready_button", text = utf8.to_upper(managers.localization:text("menu_l_waiting_for_all"))}.align, {name = "ready_button", text = utf8.to_upper(managers.localization:text("menu_l_waiting_for_all"))}.h = l_1_0._panel:text({name = "ready_button", text = utf8.to_upper(managers.localization:text("menu_l_waiting_for_all"))}), 1, tweak_data.screen_colors.button_stage_3, tweak_data.menu.pd2_large_font, tweak_data.menu.pd2_large_font_size, "center", "right", 32
  local _, _, w, h = l_1_0._continue_button:text_rect()
  l_1_0._continue_button:set_size(w, h)
  l_1_0._continue_button:set_bottom(l_1_0._panel:h())
  l_1_0._continue_button:set_right(l_1_0._panel:w())
  l_1_0._button_not_clickable = true
  l_1_0._continue_button:set_color(tweak_data.screen_colors.item_stage_1)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local big_text = l_1_0._fullscreen_panel:text({name = "continue_big_text", text = utf8.to_upper(managers.localization:text("menu_l_waiting_for_all"))})
  local x, y = managers.gui_data:safe_to_full_16_9(managers.gui_data, l_1_0._continue_button:world_right(), l_1_0._continue_button:world_center_y())
  big_text:set_world_right(x)
  {name = "continue_big_text", text = utf8.to_upper(managers.localization:text("menu_l_waiting_for_all"))}.alpha, {name = "continue_big_text", text = utf8.to_upper(managers.localization:text("menu_l_waiting_for_all"))}.color, {name = "continue_big_text", text = utf8.to_upper(managers.localization:text("menu_l_waiting_for_all"))}.font, {name = "continue_big_text", text = utf8.to_upper(managers.localization:text("menu_l_waiting_for_all"))}.font_size, {name = "continue_big_text", text = utf8.to_upper(managers.localization:text("menu_l_waiting_for_all"))}.vertical, {name = "continue_big_text", text = utf8.to_upper(managers.localization:text("menu_l_waiting_for_all"))}.align, {name = "continue_big_text", text = utf8.to_upper(managers.localization:text("menu_l_waiting_for_all"))}.h = 0.40000000596046, tweak_data.screen_colors.button_stage_3, tweak_data.menu.pd2_massive_font, tweak_data.menu.pd2_massive_font_size, "bottom", "right", 90
  big_text:set_world_center_y(y)
  big_text:move(13, -9)
  if MenuBackdropGUI then
    MenuBackdropGUI.animate_bg_text(l_1_0, big_text)
  end
  l_1_0._time_left_text = l_1_0._panel:text({name = "time_left", text = "30", align = "right", vertical = "bottom", font_size = tweak_data.menu.pd2_small_font_size, font = tweak_data.menu.pd2_small_font, color = tweak_data.screen_colors.text, layer = 1})
  l_1_0._time_left_text:set_right(l_1_0._continue_button:right())
  l_1_0._time_left_text:set_bottom(l_1_0._continue_button:top())
  l_1_0._time_left_text:set_alpha(0)
  l_1_0._fade_time_left = 10
  l_1_0._time_left = 30
  l_1_0._is_alone = false
  l_1_0._selected = 0
  l_1_0._id = managers.network:session() and managers.network:session():local_peer():id() or 1
  l_1_0._card_chosen = false
  if l_1_4 then
    l_1_0:set_state(l_1_4)
  end
  if l_1_0._no_loot_for_me then
    return 
  end
  l_1_0:_set_selected_and_sync(2)
end

LootDropScreenGui.set_state = function(l_2_0, l_2_1)
  local id_state = Idstring(l_2_1)
  if id_state == Idstring("on_server_left") then
    l_2_0._lootscreen_hud:clear_other_peers(l_2_0._id)
    l_2_0._is_alone = true
    l_2_0:close_network()
    MenuMainState._create_server_left_dialog(l_2_0)
  else
    if id_state == Idstring("on_kicked") then
      l_2_0._lootscreen_hud:clear_other_peers(l_2_0._id)
      l_2_0._is_alone = true
      l_2_0:close_network()
      managers.menu:show_peer_kicked_dialog({ok_func = callback(l_2_0, l_2_0, "on_server_left_ok_pressed")})
    else
      if id_state == Idstring("on_disconnected") then
        l_2_0._lootscreen_hud:clear_other_peers(l_2_0._id)
        l_2_0._is_alone = true
        l_2_0:close_network()
        managers.menu:show_mp_disconnected_internet_dialog({ok_func = callback(l_2_0, l_2_0, "on_server_left_ok_pressed")})
      else
        Application:error("LootDropScreenGui:set_state: unrecognizable state", l_2_1)
      end
    end
  end
  l_2_0._panel:show()
  l_2_0._fullscreen_panel:show()
  managers.menu_component:post_event("menu_exit")
end

LootDropScreenGui.on_server_left_ok_pressed = function(l_3_0)
  l_3_0:check_all_ready()
end

LootDropScreenGui.close_network = function(l_4_0)
  if Network:multiplayer() then
    Network:set_multiplayer(false)
    managers.network:queue_stop_network()
    managers.network.matchmake:destroy_game()
    managers.network.voice_chat:destroy_voice()
    managers.menu_component:remove_game_chat()
    managers.menu_component:close_chat_gui()
    managers.job:deactivate_current_job()
  end
end

LootDropScreenGui.hide = function(l_5_0)
  l_5_0._enabled = false
  l_5_0._panel:set_alpha(0.5)
  l_5_0._fullscreen_panel:set_alpha(0.5)
end

LootDropScreenGui.show = function(l_6_0)
  l_6_0._enabled = true
  l_6_0._panel:set_alpha(1)
  l_6_0._fullscreen_panel:set_alpha(1)
end

LootDropScreenGui.check_all_ready = function(l_7_0)
  if l_7_0._lootscreen_hud:check_all_ready() then
    local text_id = "victory_client_waiting_for_server"
    if Global.game_settings.single_player or l_7_0._is_alone or not managers.network:session() then
      l_7_0._button_not_clickable = false
      text_id = "failed_disconnected_continue"
      if managers.menu:is_pc_controller() then
        l_7_0._continue_button:set_color(tweak_data.screen_colors.button_stage_3)
      else
        if Network:is_server() then
          l_7_0._button_not_clickable = false
          text_id = "debug_mission_end_continue"
          if managers.menu:is_pc_controller() then
            l_7_0._continue_button:set_color(tweak_data.screen_colors.button_stage_3)
        end
      end
    end
    local text = managers.localization:to_upper_text(text_id, {CONTINUE = managers.localization:btn_macro("continue")})
    l_7_0._continue_button:set_text(text)
    local _, _, w, h = l_7_0._continue_button:text_rect()
    l_7_0._continue_button:set_size(w, h)
    l_7_0._continue_button:set_bottom(l_7_0._panel:h())
    l_7_0._continue_button:set_right(l_7_0._panel:w())
    local big_text = l_7_0._fullscreen_panel:child("continue_big_text")
    big_text:set_text(text)
    local x, y = managers.gui_data:safe_to_full_16_9(managers.gui_data, l_7_0._continue_button:world_right(), l_7_0._continue_button:world_center_y())
    big_text:set_world_right(x)
    big_text:set_world_center_y(y)
    big_text:move(13, -9)
    managers.menu_component:post_event("prompt_enter")
  end
end

LootDropScreenGui.on_peer_removed = function(l_8_0, l_8_1, l_8_2)
  if l_8_1 then
    l_8_0._lootscreen_hud:remove_peer(l_8_1:id(), l_8_2)
  end
  l_8_0:check_all_ready()
end

LootDropScreenGui.update = function(l_9_0, l_9_1, l_9_2)
  l_9_0._lootscreen_hud:update(l_9_1, l_9_2)
  if l_9_0._no_loot_for_me then
    return 
  end
  if not l_9_0._is_alone then
    if l_9_0._fade_time_left then
      l_9_0._fade_time_left = l_9_0._fade_time_left - l_9_2
      if l_9_0._fade_time_left <= 0 then
        l_9_0._time_left_text:set_alpha(1)
        l_9_0._fade_time_left = nil
      elseif l_9_0._time_left then
        l_9_0._time_left = math.max(l_9_0._time_left - l_9_2, 0)
        if l_9_0._card_chosen then
          l_9_0._time_left = 0
        end
        if l_9_0._time_left > 10 then
          l_9_0._time_left_text:set_text(string.format("%1d", l_9_0._time_left))
        else
          if l_9_0._time_left_text:font_size() == tweak_data.menu.pd2_small_font_size then
            l_9_0._time_left_text:set_font(tweak_data.menu.pd2_medium_font_id)
            l_9_0._time_left_text:set_font_size(tweak_data.menu.pd2_medium_font_size)
          end
          l_9_0._time_left_text:set_text(string.format("%0.2f", l_9_0._time_left))
        end
        if l_9_0._time_left <= 0 then
          l_9_0._time_left_text:set_text("")
          l_9_0._time_left_text:set_alpha(0)
          if not l_9_0._card_chosen then
            l_9_0._card_chosen = true
            l_9_0._lootscreen_hud:begin_choose_card(l_9_0._id, l_9_0._selected or 2)
            managers.network:session():send_to_peers("choose_lootcard", Global.game_settings.single_player or not managers.network:session() or l_9_0._selected or 2)
          end
        end
      end
    end
  end
end

LootDropScreenGui.continue_to_lobby = function(l_10_0)
  if game_state_machine:current_state()._continue_cb then
    managers.menu_component:post_event("menu_enter")
    game_state_machine:current_state()._continue_cb()
  end
end

LootDropScreenGui.mouse_pressed = function(l_11_0, l_11_1, l_11_2, l_11_3)
  if l_11_0._no_loot_for_me then
    return 
  end
  if not alive(l_11_0._panel) or not alive(l_11_0._fullscreen_panel) or not l_11_0._enabled then
    return 
  end
  if l_11_1 ~= Idstring("0") then
    return 
  end
  if l_11_0._card_chosen and not l_11_0._button_not_clickable and l_11_0._continue_button:inside(l_11_2, l_11_3) then
    l_11_0:continue_to_lobby()
    return true
  end
  if l_11_0._card_chosen then
    return 
  end
  local inside = l_11_0._lootscreen_hud:check_inside_local_peer(managers.mouse_pointer:modified_fullscreen_16_9_mouse_pos(managers.mouse_pointer))
  if inside == l_11_0._selected then
    l_11_0._card_chosen = true
    managers.menu_component:post_event("menu_enter")
    l_11_0._lootscreen_hud:begin_choose_card(l_11_0._id, l_11_0._selected)
    if not Global.game_settings.single_player and managers.network:session() then
      managers.network:session():send_to_peers("choose_lootcard", l_11_0._selected)
    end
  end
end

LootDropScreenGui.mouse_moved = function(l_12_0, l_12_1, l_12_2)
  if l_12_0._no_loot_for_me then
    return 
  end
  if not alive(l_12_0._panel) or not alive(l_12_0._fullscreen_panel) or not l_12_0._enabled then
    return 
  end
  if l_12_0._button_not_clickable then
    l_12_0._continue_button:set_color(tweak_data.screen_colors.item_stage_1)
  else
    if l_12_0._continue_button:inside(l_12_1, l_12_2) and not l_12_0._continue_button_highlighted then
      l_12_0._continue_button_highlighted = true
      l_12_0._continue_button:set_color(tweak_data.screen_colors.button_stage_2)
      managers.menu_component:post_event("highlight")
      do return end
      if l_12_0._continue_button_highlighted then
        l_12_0._continue_button_highlighted = false
        l_12_0._continue_button:set_color(tweak_data.screen_colors.button_stage_3)
      end
    end
  end
  if l_12_0._card_chosen then
    return 
  end
  if l_12_0._lootscreen_hud then
    local inside = l_12_0._lootscreen_hud:check_inside_local_peer(managers.mouse_pointer:modified_fullscreen_16_9_mouse_pos(managers.mouse_pointer))
    if inside then
      l_12_0:_set_selected_and_sync(inside)
    end
  end
end

LootDropScreenGui.input_focus = function(l_13_0)
  return l_13_0._enabled
end

LootDropScreenGui.scroll_up = function(l_14_0)
  if l_14_0._no_loot_for_me then
    return 
  end
  if l_14_0._card_chosen then
    return 
  end
  if not alive(l_14_0._panel) or not alive(l_14_0._fullscreen_panel) or not l_14_0._enabled then
    return 
  end
  l_14_0:_set_selected_and_sync(l_14_0._selected - 1)
end

LootDropScreenGui.scroll_down = function(l_15_0)
  if l_15_0._no_loot_for_me then
    return 
  end
  if l_15_0._card_chosen then
    return 
  end
  if not alive(l_15_0._panel) or not alive(l_15_0._fullscreen_panel) or not l_15_0._enabled then
    return 
  end
  l_15_0:_set_selected_and_sync(l_15_0._selected + 1)
end

LootDropScreenGui.move_up = function(l_16_0)
end

LootDropScreenGui.move_down = function(l_17_0)
end

LootDropScreenGui.set_selected = function(l_18_0, l_18_1)
  local new_selected = math.clamp(l_18_1, 1, 3)
  if new_selected ~= l_18_0._selected then
    l_18_0._selected = new_selected
    l_18_0._lootscreen_hud:set_selected(l_18_0._id, l_18_0._selected)
    managers.menu_component:post_event("highlight")
    return true
  end
  return false
end

LootDropScreenGui._set_selected_and_sync = function(l_19_0, l_19_1)
  if l_19_0:set_selected(l_19_1) and not Global.game_settings.single_player and managers.network:session() then
    managers.network:session():send_to_peers("set_selected_lootcard", l_19_0._selected)
  end
end

LootDropScreenGui.move_left = function(l_20_0)
  if l_20_0._no_loot_for_me then
    return 
  end
  if l_20_0._card_chosen then
    return 
  end
  if not alive(l_20_0._panel) or not alive(l_20_0._fullscreen_panel) or not l_20_0._enabled then
    return 
  end
  l_20_0:_set_selected_and_sync(l_20_0._selected - 1)
end

LootDropScreenGui.move_right = function(l_21_0)
  if l_21_0._no_loot_for_me then
    return 
  end
  if l_21_0._card_chosen then
    return 
  end
  if not alive(l_21_0._panel) or not alive(l_21_0._fullscreen_panel) or not l_21_0._enabled then
    return 
  end
  l_21_0:_set_selected_and_sync(l_21_0._selected + 1)
end

LootDropScreenGui.next_tab = function(l_22_0)
  l_22_0:_set_selected_and_sync(l_22_0._selected + 1)
end

LootDropScreenGui.prev_tab = function(l_23_0)
  l_23_0:_set_selected_and_sync(l_23_0._selected - 1)
end

LootDropScreenGui.confirm_pressed = function(l_24_0)
  if l_24_0._no_loot_for_me then
    return 
  end
  if not alive(l_24_0._panel) or not alive(l_24_0._fullscreen_panel) or not l_24_0._enabled then
    return 
  end
  if l_24_0._card_chosen and not l_24_0._button_not_clickable then
    l_24_0:continue_to_lobby()
    return false
  end
  if l_24_0._card_chosen then
    return false
  end
  l_24_0._card_chosen = true
  managers.menu_component:post_event("menu_enter")
  l_24_0._lootscreen_hud:begin_choose_card(l_24_0._id, l_24_0._selected)
  if not Global.game_settings.single_player and managers.network:session() then
    managers.network:session():send_to_peers("choose_lootcard", l_24_0._selected)
  end
  return true
end

LootDropScreenGui.back_pressed = function(l_25_0)
  if l_25_0._no_loot_for_me then
    return 
  end
  if not alive(l_25_0._panel) or not alive(l_25_0._fullscreen_panel) or not l_25_0._enabled then
    return false
  end
end

LootDropScreenGui.next_page = function(l_26_0)
  if l_26_0._no_loot_for_me then
    return 
  end
  if l_26_0._card_chosen then
    return 
  end
  if not l_26_0._enabled then
    return 
  end
  l_26_0:next_tab()
end

LootDropScreenGui.previous_page = function(l_27_0)
  if l_27_0._no_loot_for_me then
    return 
  end
  if l_27_0._card_chosen then
    return 
  end
  if not l_27_0._enabled then
    return 
  end
  l_27_0:prev_tab()
end

LootDropScreenGui.special_btn_pressed = function(l_28_0, l_28_1)
  if l_28_0._no_loot_for_me then
    return 
  end
  if l_28_0._card_chosen then
    return false
  end
end

LootDropScreenGui.close = function(l_29_0)
  if l_29_0._panel and alive(l_29_0._panel) then
    l_29_0._panel:parent():remove(l_29_0._panel)
  end
  if l_29_0._fullscreen_panel and alive(l_29_0._fullscreen_panel) then
    l_29_0._fullscreen_panel:parent():remove(l_29_0._fullscreen_panel)
  end
end

LootDropScreenGui.reload = function(l_30_0)
  l_30_0:close()
  LootDropScreenGui.init(l_30_0, l_30_0._safe_workspace, l_30_0._full_workspace, l_30_0._lootscreen_hud)
end


