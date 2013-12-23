-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\menucomponentmanager.luac 

require("lib/managers/menu/SkillTreeGui")
require("lib/managers/menu/BlackMarketGui")
require("lib/managers/menu/InventoryList")
require("lib/managers/menu/MissionBriefingGui")
require("lib/managers/menu/StageEndScreenGui")
require("lib/managers/menu/LootDropScreenGUI")
require("lib/managers/menu/CrimeNetContractGui")
require("lib/managers/menu/CrimeNetFiltersGui")
require("lib/managers/menu/MenuSceneGui")
require("lib/managers/menu/PlayerProfileGuiObject")
require("lib/managers/menu/IngameContractGui")
require("lib/managers/menu/IngameManualGui")
if not MenuComponentManager then
  MenuComponentManager = class()
end
MenuComponentManager.init = function(l_1_0)
  l_1_0._ws = Overlay:gui():create_screen_workspace()
  l_1_0._fullscreen_ws = managers.gui_data:create_fullscreen_16_9_workspace(managers.gui_data)
  managers.gui_data:layout_workspace(l_1_0._ws)
  l_1_0._main_panel = l_1_0._ws:panel():panel()
  l_1_0._cached_textures = {}
  l_1_0._requested_textures = {}
  l_1_0._removing_textures = {}
  l_1_0._requested_index = {}
  l_1_0._REFRESH_FRIENDS_TIME = 5
  l_1_0._refresh_friends_t = TimerManager:main():time() + l_1_0._REFRESH_FRIENDS_TIME
  l_1_0._sound_source = SoundDevice:create_source("MenuComponentManager")
  l_1_0._resolution_changed_callback_id = managers.viewport:add_resolution_changed_func(callback(l_1_0, l_1_0, "resolution_changed"))
  l_1_0._request_done_clbk_func = callback(l_1_0, l_1_0, "_request_done_callback")
  l_1_0._active_components = {}
  l_1_0._active_components.news = {create = callback(l_1_0, l_1_0, "_create_newsfeed_gui"), close = callback(l_1_0, l_1_0, "close_newsfeed_gui")}
  l_1_0._active_components.profile = {create = callback(l_1_0, l_1_0, "_create_profile_gui"), close = callback(l_1_0, l_1_0, "_disable_profile_gui")}
  l_1_0._active_components.friends = {create = callback(l_1_0, l_1_0, "_create_friends_gui"), close = callback(l_1_0, l_1_0, "_disable_friends_gui")}
  l_1_0._active_components.chats = {create = callback(l_1_0, l_1_0, "_create_chat_gui"), close = callback(l_1_0, l_1_0, "_disable_chat_gui")}
  l_1_0._active_components.lobby_chats = {create = callback(l_1_0, l_1_0, "_create_lobby_chat_gui"), close = callback(l_1_0, l_1_0, "hide_lobby_chat_gui")}
  l_1_0._active_components.contract = {create = callback(l_1_0, l_1_0, "_create_contract_gui"), close = callback(l_1_0, l_1_0, "_disable_contract_gui")}
  l_1_0._active_components.server_info = {create = callback(l_1_0, l_1_0, "_create_server_info_gui"), close = callback(l_1_0, l_1_0, "_disable_server_info_gui")}
  l_1_0._active_components.debug_strings = {create = callback(l_1_0, l_1_0, "_create_debug_strings_gui"), close = callback(l_1_0, l_1_0, "_disable_debug_strings_gui")}
  l_1_0._active_components.debug_fonts = {create = callback(l_1_0, l_1_0, "_create_debug_fonts_gui"), close = callback(l_1_0, l_1_0, "_disable_debug_fonts_gui")}
  l_1_0._active_components.skilltree = {create = callback(l_1_0, l_1_0, "_create_skilltree_gui"), close = callback(l_1_0, l_1_0, "close_skilltree_gui")}
  l_1_0._active_components.crimenet = {create = callback(l_1_0, l_1_0, "_create_crimenet_gui"), close = callback(l_1_0, l_1_0, "close_crimenet_gui")}
  l_1_0._active_components.crimenet_contract = {create = callback(l_1_0, l_1_0, "_create_crimenet_contract_gui"), close = callback(l_1_0, l_1_0, "close_crimenet_contract_gui")}
  l_1_0._active_components.crimenet_filters = {create = callback(l_1_0, l_1_0, "_create_crimenet_filters_gui"), close = callback(l_1_0, l_1_0, "close_crimenet_filters_gui")}
  l_1_0._active_components.blackmarket = {create = callback(l_1_0, l_1_0, "_create_blackmarket_gui"), close = callback(l_1_0, l_1_0, "close_blackmarket_gui")}
  l_1_0._active_components.mission_briefing = {create = callback(l_1_0, l_1_0, "_create_mission_briefing_gui"), close = callback(l_1_0, l_1_0, "_hide_mission_briefing_gui")}
  l_1_0._active_components.stage_endscreen = {create = callback(l_1_0, l_1_0, "_create_stage_endscreen_gui"), close = callback(l_1_0, l_1_0, "_hide_stage_endscreen_gui")}
  l_1_0._active_components.lootdrop = {create = callback(l_1_0, l_1_0, "_create_lootdrop_gui"), close = callback(l_1_0, l_1_0, "_hide_lootdrop_gui")}
  l_1_0._active_components.menuscene_info = {create = callback(l_1_0, l_1_0, "_create_menuscene_info_gui"), close = callback(l_1_0, l_1_0, "_close_menuscene_info_gui")}
  l_1_0._active_components.player_profile = {create = callback(l_1_0, l_1_0, "_create_player_profile_gui"), close = callback(l_1_0, l_1_0, "close_player_profile_gui")}
  l_1_0._active_components.ingame_contract = {create = callback(l_1_0, l_1_0, "_create_ingame_contract_gui"), close = callback(l_1_0, l_1_0, "close_ingame_contract_gui")}
  l_1_0._active_components.ingame_manual = {create = callback(l_1_0, l_1_0, "_create_ingame_manual_gui"), close = callback(l_1_0, l_1_0, "close_ingame_manual_gui")}
  l_1_0._active_components.inventory_list = {create = callback(l_1_0, l_1_0, "_create_inventory_list_gui"), close = callback(l_1_0, l_1_0, "close_inventory_list_gui")}
end

MenuComponentManager._setup_controller_input = function(l_2_0)
  if not l_2_0._controller_connected then
    l_2_0._left_axis_vector = Vector3()
    l_2_0._right_axis_vector = Vector3()
    l_2_0._fullscreen_ws:connect_controller(managers.menu:active_menu().input:get_controller(), true)
    l_2_0._fullscreen_ws:panel():axis_move(callback(l_2_0, l_2_0, "_axis_move"))
    l_2_0._controller_connected = true
    if SystemInfo:platform() == Idstring("WIN32") then
      l_2_0._fullscreen_ws:connect_keyboard(Input:keyboard())
      l_2_0._fullscreen_ws:panel():key_press(callback(l_2_0, l_2_0, "key_press_controller_support"))
    end
  end
end

MenuComponentManager._destroy_controller_input = function(l_3_0)
  if l_3_0._controller_connected then
    l_3_0._fullscreen_ws:disconnect_all_controllers()
    if alive(l_3_0._fullscreen_ws:panel()) then
      l_3_0._fullscreen_ws:panel():axis_move(nil)
    end
    l_3_0._controller_connected = nil
    if SystemInfo:platform() == Idstring("WIN32") then
      l_3_0._fullscreen_ws:panel():disconnect_keyboard()
      l_3_0._fullscreen_ws:panel():key_press(nil)
    end
  end
end

MenuComponentManager.key_press_controller_support = function(l_4_0, l_4_1, l_4_2)
  local toggle_chat = Idstring(managers.controller:get_settings("pc"):get_connection("toggle_chat"):get_input_name_list()[1])
  if l_4_2 == toggle_chat then
    if l_4_0._game_chat_gui and l_4_0._game_chat_gui:enabled() then
      l_4_0._game_chat_gui:open_page()
      return 
    end
    if managers.hud and not managers.hud:chat_focus() and managers.menu:toggle_chatinput() then
      managers.hud:set_chat_skip_first(true)
    end
    return 
  end
end

MenuComponentManager.resolution_changed = function(l_5_0)
  managers.gui_data:layout_workspace(l_5_0._ws)
  managers.gui_data:layout_fullscreen_16_9_workspace(managers.gui_data, l_5_0._fullscreen_ws)
  if l_5_0._tcst then
    managers.gui_data:layout_fullscreen_16_9_workspace(managers.gui_data, l_5_0._tcst)
  end
end

MenuComponentManager._axis_move = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4)
  if l_6_2 == Idstring("left") then
    mvector3.set(l_6_0._left_axis_vector, l_6_3)
  else
    if l_6_2 == Idstring("right") then
      mvector3.set(l_6_0._right_axis_vector, l_6_3)
    end
  end
end

MenuComponentManager.set_active_components = function(l_7_0, l_7_1, l_7_2)
  local to_close = {}
  for component,_ in pairs(l_7_0._active_components) do
    to_close[component] = true
  end
  for _,component in ipairs(l_7_1) do
    if l_7_0._active_components[component] then
      to_close[component] = nil
      l_7_0._active_components[component].create(l_7_2)
    end
  end
  for component,_ in pairs(to_close) do
    l_7_0._active_components[component]:close()
  end
  if not managers.menu:is_pc_controller() then
    l_7_0:_setup_controller_input()
  end
end

MenuComponentManager.on_job_updated = function(l_8_0)
  if l_8_0._contract_gui then
    l_8_0._contract_gui:refresh()
  end
end

MenuComponentManager.update = function(l_9_0, l_9_1, l_9_2)
  if table.size(l_9_0._removing_textures) > 0 then
    for key,texture_ids in pairs(l_9_0._removing_textures) do
      if l_9_0._cached_textures[key] and l_9_0._cached_textures[key] ~= 0 then
        Application:error("[MenuComponentManager] update(): Still holds references of texture!", texture_ids, l_9_0._cached_textures[key])
      end
      l_9_0._cached_textures[key] = nil
      l_9_0._requested_textures[key] = nil
      l_9_0._requested_index[key] = nil
      TextureCache:unretrieve(texture_ids)
    end
    l_9_0._removing_textures = {}
  end
  l_9_0:_update_newsfeed_gui(l_9_1, l_9_2)
  if l_9_0._refresh_friends_t < l_9_1 then
    l_9_0:_update_friends_gui()
    l_9_0._refresh_friends_t = l_9_1 + l_9_0._REFRESH_FRIENDS_TIME
  end
  if l_9_0._lobby_profile_gui then
    l_9_0._lobby_profile_gui:update(l_9_1, l_9_2)
  end
  if l_9_0._profile_gui then
    l_9_0._profile_gui:update(l_9_1, l_9_2)
  end
  if l_9_0._view_character_profile_gui then
    l_9_0._view_character_profile_gui:update(l_9_1, l_9_2)
  end
  if l_9_0._contract_gui then
    l_9_0._contract_gui:update(l_9_1, l_9_2)
  end
  if l_9_0._menuscene_info_gui then
    l_9_0._menuscene_info_gui:update(l_9_1, l_9_2)
  end
  if l_9_0._crimenet_contract_gui then
    l_9_0._crimenet_contract_gui:update(l_9_1, l_9_2)
  end
  if l_9_0._lootdrop_gui then
    l_9_0._lootdrop_gui:update(l_9_1, l_9_2)
  end
  if l_9_0._stage_endscreen_gui then
    l_9_0._stage_endscreen_gui:update(l_9_1, l_9_2)
  end
  if l_9_0._mission_briefing_gui then
    l_9_0._mission_briefing_gui:update(l_9_1, l_9_2)
  end
  if l_9_0._ingame_manual_gui then
    l_9_0._ingame_manual_gui:update(l_9_1, l_9_2)
  end
end

MenuComponentManager.get_left_controller_axis = function(l_10_0)
  if managers.menu:is_pc_controller() or not l_10_0._left_axis_vector then
    return 0, 0
  end
  local x = mvector3.x(l_10_0._left_axis_vector)
  local y = mvector3.y(l_10_0._left_axis_vector)
  return x, y
end

MenuComponentManager.get_right_controller_axis = function(l_11_0)
  if managers.menu:is_pc_controller() or not l_11_0._right_axis_vector then
    return 0, 0
  end
  local x = mvector3.x(l_11_0._right_axis_vector)
  local y = mvector3.y(l_11_0._right_axis_vector)
  return x, y
end

MenuComponentManager.accept_input = function(l_12_0, l_12_1)
  if not l_12_0._weapon_text_box then
    return 
  end
  if not l_12_1 then
    l_12_0._weapon_text_box:release_scroll_bar()
  end
end

MenuComponentManager.input_focus = function(l_13_0)
  if managers.system_menu and managers.system_menu:is_active() and not managers.system_menu:is_closing() then
    return true
  end
  if l_13_0._game_chat_gui then
    local input_focus = l_13_0._game_chat_gui:input_focus()
    if not l_13_0._lobby_chat_gui_active then
      return input_focus ~= true or false
      do return end
    end
    if input_focus == 1 then
      return 1
    end
  end
  if l_13_0._skilltree_gui and l_13_0._skilltree_gui:input_focus() then
    return 1
  end
  if l_13_0._blackmarket_gui then
    return l_13_0._blackmarket_gui:input_focus()
  end
  if l_13_0._mission_briefing_gui then
    return l_13_0._mission_briefing_gui:input_focus()
  end
  if l_13_0._stage_endscreen_gui then
    return l_13_0._stage_endscreen_gui:input_focus()
  end
  if l_13_0._crimenet_gui then
    return l_13_0._crimenet_gui:input_focus()
  end
  if l_13_0._lootdrop_gui then
    return l_13_0._lootdrop_gui:input_focus()
  end
  if l_13_0._ingame_manual_gui then
    return l_13_0._ingame_manual_gui:input_focus()
  end
end

MenuComponentManager.scroll_up = function(l_14_0)
  if not l_14_0._weapon_text_box then
    return 
  end
  l_14_0._weapon_text_box:scroll_up()
  if l_14_0._mission_briefing_gui and l_14_0._mission_briefing_gui:scroll_up() then
    return true
  end
  if l_14_0._stage_endscreen_gui and l_14_0._stage_endscreen_gui:scroll_up() then
    return true
  end
  if l_14_0._lootdrop_gui and l_14_0._lootdrop_gui:scroll_up() then
    return true
  end
end

MenuComponentManager.scroll_down = function(l_15_0)
  if not l_15_0._weapon_text_box then
    return 
  end
  l_15_0._weapon_text_box:scroll_down()
  if l_15_0._mission_briefing_gui and l_15_0._mission_briefing_gui:scroll_down() then
    return true
  end
  if l_15_0._stage_endscreen_gui and l_15_0._stage_endscreen_gui:scroll_down() then
    return true
  end
  if l_15_0._lootdrop_gui and l_15_0._lootdrop_gui:scroll_down() then
    return true
  end
end

MenuComponentManager.move_up = function(l_16_0)
  if l_16_0._skilltree_gui and l_16_0._skilltree_gui:move_up() then
    return true
  end
  if l_16_0._mission_briefing_gui and l_16_0._mission_briefing_gui:move_up() then
    return true
  end
  if l_16_0._stage_endscreen_gui and l_16_0._stage_endscreen_gui:move_up() then
    return true
  end
  if l_16_0._blackmarket_gui and l_16_0._blackmarket_gui:move_up() then
    return true
  end
  if l_16_0._lootdrop_gui and l_16_0._lootdrop_gui:move_up() then
    return true
  end
end

MenuComponentManager.move_down = function(l_17_0)
  if l_17_0._skilltree_gui and l_17_0._skilltree_gui:move_down() then
    return true
  end
  if l_17_0._mission_briefing_gui and l_17_0._mission_briefing_gui:move_down() then
    return true
  end
  if l_17_0._stage_endscreen_gui and l_17_0._stage_endscreen_gui:move_down() then
    return true
  end
  if l_17_0._blackmarket_gui and l_17_0._blackmarket_gui:move_down() then
    return true
  end
  if l_17_0._lootdrop_gui and l_17_0._lootdrop_gui:move_down() then
    return true
  end
end

MenuComponentManager.move_left = function(l_18_0)
  if l_18_0._skilltree_gui and l_18_0._skilltree_gui:move_left() then
    return true
  end
  if l_18_0._mission_briefing_gui and l_18_0._mission_briefing_gui:move_left() then
    return true
  end
  if l_18_0._stage_endscreen_gui and l_18_0._stage_endscreen_gui:move_left() then
    return true
  end
  if l_18_0._blackmarket_gui and l_18_0._blackmarket_gui:move_left() then
    return true
  end
  if l_18_0._lootdrop_gui and l_18_0._lootdrop_gui:move_left() then
    return true
  end
end

MenuComponentManager.move_right = function(l_19_0)
  if l_19_0._skilltree_gui and l_19_0._skilltree_gui:move_right() then
    return true
  end
  if l_19_0._mission_briefing_gui and l_19_0._mission_briefing_gui:move_right() then
    return true
  end
  if l_19_0._stage_endscreen_gui and l_19_0._stage_endscreen_gui:move_right() then
    return true
  end
  if l_19_0._blackmarket_gui and l_19_0._blackmarket_gui:move_right() then
    return true
  end
  if l_19_0._lootdrop_gui and l_19_0._lootdrop_gui:move_right() then
    return true
  end
end

MenuComponentManager.next_page = function(l_20_0)
  if l_20_0._skilltree_gui and l_20_0._skilltree_gui:next_page(true) then
    return true
  end
  if l_20_0._mission_briefing_gui and l_20_0._mission_briefing_gui:next_page() then
    return true
  end
  if l_20_0._stage_endscreen_gui and l_20_0._stage_endscreen_gui:next_page() then
    return true
  end
  if l_20_0._blackmarket_gui and l_20_0._blackmarket_gui:next_page() then
    return true
  end
  if l_20_0._crimenet_gui and l_20_0._crimenet_gui:next_page() then
    return true
  end
  if l_20_0._lootdrop_gui and l_20_0._lootdrop_gui:next_page() then
    return true
  end
  if l_20_0._ingame_manual_gui and l_20_0._ingame_manual_gui:next_page() then
    return true
  end
end

MenuComponentManager.previous_page = function(l_21_0)
  if l_21_0._skilltree_gui and l_21_0._skilltree_gui:previous_page(true) then
    return true
  end
  if l_21_0._mission_briefing_gui and l_21_0._mission_briefing_gui:previous_page() then
    return true
  end
  if l_21_0._stage_endscreen_gui and l_21_0._stage_endscreen_gui:previous_page() then
    return true
  end
  if l_21_0._blackmarket_gui and l_21_0._blackmarket_gui:previous_page() then
    return true
  end
  if l_21_0._crimenet_gui and l_21_0._crimenet_gui:previous_page() then
    return true
  end
  if l_21_0._lootdrop_gui and l_21_0._lootdrop_gui:previous_page() then
    return true
  end
  if l_21_0._ingame_manual_gui and l_21_0._ingame_manual_gui:previous_page() then
    return true
  end
end

MenuComponentManager.confirm_pressed = function(l_22_0)
  if l_22_0._skilltree_gui and l_22_0._skilltree_gui:confirm_pressed() then
    return true
  end
  if l_22_0._mission_briefing_gui and l_22_0._mission_briefing_gui:confirm_pressed() then
    return true
  end
  if l_22_0._stage_endscreen_gui and l_22_0._stage_endscreen_gui:confirm_pressed() then
    return true
  end
  if l_22_0._blackmarket_gui and l_22_0._blackmarket_gui:confirm_pressed() then
    return true
  end
  if l_22_0._crimenet_gui and l_22_0._crimenet_gui:confirm_pressed() then
    return true
  end
  if l_22_0._lootdrop_gui and l_22_0._lootdrop_gui:confirm_pressed() then
    return true
  end
  if Application:production_build() and l_22_0._debug_font_gui then
    l_22_0._debug_font_gui:toggle()
  end
end

MenuComponentManager.back_pressed = function(l_23_0)
  if l_23_0._mission_briefing_gui and l_23_0._mission_briefing_gui:back_pressed() then
    return true
  end
  if l_23_0._stage_endscreen_gui and l_23_0._stage_endscreen_gui:back_pressed() then
    return true
  end
  if l_23_0._lootdrop_gui and l_23_0._lootdrop_gui:back_pressed() then
    return true
  end
end

MenuComponentManager.special_btn_pressed = function(l_24_0, ...)
  if l_24_0._skilltree_gui and l_24_0._skilltree_gui:special_btn_pressed(...) then
    return true
  end
  if l_24_0._blackmarket_gui and l_24_0._blackmarket_gui:special_btn_pressed(...) then
    return true
  end
  if l_24_0._crimenet_contract_gui and l_24_0._crimenet_contract_gui:special_btn_pressed(...) then
    return true
  end
  if l_24_0._crimenet_gui and l_24_0._crimenet_gui:special_btn_pressed(...) then
    return true
  end
  if l_24_0._mission_briefing_gui and l_24_0._mission_briefing_gui:special_btn_pressed(...) then
    return true
  end
  if l_24_0._lootdrop_gui and l_24_0._lootdrop_gui:special_btn_pressed(...) then
    return true
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

MenuComponentManager.mouse_pressed = function(l_25_0, l_25_1, l_25_2, l_25_3, l_25_4)
  if l_25_0._skilltree_gui and l_25_0._skilltree_gui:mouse_pressed(l_25_2, l_25_3, l_25_4) then
    return true
  end
  if l_25_0._blackmarket_gui and l_25_0._blackmarket_gui:mouse_pressed(l_25_2, l_25_3, l_25_4) then
    return true
  end
  if l_25_0._game_chat_gui and l_25_0._game_chat_gui:mouse_pressed(l_25_2, l_25_3, l_25_4) then
    return true
  end
  if l_25_0._newsfeed_gui and l_25_0._newsfeed_gui:mouse_pressed(l_25_2, l_25_3, l_25_4) then
    return true
  end
  if l_25_0._profile_gui then
    if l_25_0._profile_gui:mouse_pressed(l_25_2, l_25_3, l_25_4) then
      return true
    end
    if l_25_2 == Idstring("0") then
      if l_25_0._profile_gui:check_minimize(l_25_3, l_25_4) then
        local minimized_data = {text = "PROFILE", help_text = "MAXIMIZE PROFILE WINDOW"}
        l_25_0._profile_gui:set_minimized(true, minimized_data)
        return true
      end
      if l_25_0._profile_gui:check_grab_scroll_bar(l_25_3, l_25_4) then
        return true
      else
        if l_25_2 == Idstring("mouse wheel down") and l_25_0._profile_gui:mouse_wheel_down(l_25_3, l_25_4) then
          return true
          do return end
          if l_25_2 == Idstring("mouse wheel up") and l_25_0._profile_gui:mouse_wheel_up(l_25_3, l_25_4) then
            return true
          end
        end
      end
    end
  end
  if l_25_0._contract_gui then
    if l_25_0._contract_gui:mouse_pressed(l_25_2, l_25_3, l_25_4) then
      return true
    end
    if l_25_2 == Idstring("0") then
      if l_25_0._contract_gui:check_minimize(l_25_3, l_25_4) then
        local minimized_data = {text = "CONTRACT", help_text = "MAXIMIZE CONTRACT WINDOW"}
        l_25_0._contract_gui:set_minimized(true, minimized_data)
        return true
      end
      if l_25_0._contract_gui:check_grab_scroll_bar(l_25_3, l_25_4) then
        return true
      else
        if l_25_2 == Idstring("mouse wheel down") and l_25_0._contract_gui:mouse_wheel_down(l_25_3, l_25_4) then
          return true
          do return end
          if l_25_2 == Idstring("mouse wheel up") and l_25_0._contract_gui:mouse_wheel_up(l_25_3, l_25_4) then
            return true
          end
        end
      end
    end
  end
  if l_25_0._server_info_gui then
    if l_25_0._server_info_gui:mouse_pressed(l_25_2, l_25_3, l_25_4) then
      return true
    end
    if l_25_2 == Idstring("0") then
      if l_25_0._server_info_gui:check_minimize(l_25_3, l_25_4) then
        local minimized_data = {text = "SERVER INFO", help_text = "MAXIMIZE SERVER INFO WINDOW"}
        l_25_0._server_info_gui:set_minimized(true, minimized_data)
        return true
      end
      if l_25_0._server_info_gui:check_grab_scroll_bar(l_25_3, l_25_4) then
        return true
      else
        if l_25_2 == Idstring("mouse wheel down") and l_25_0._server_info_gui:mouse_wheel_down(l_25_3, l_25_4) then
          return true
          do return end
          if l_25_2 == Idstring("mouse wheel up") and l_25_0._server_info_gui:mouse_wheel_up(l_25_3, l_25_4) then
            return true
          end
        end
      end
    end
  end
  if l_25_0._lobby_profile_gui then
    if l_25_0._lobby_profile_gui:mouse_pressed(l_25_2, l_25_3, l_25_4) then
      return true
    end
    if l_25_2 == Idstring("0") then
      if l_25_0._lobby_profile_gui:check_minimize(l_25_3, l_25_4) then
        return true
      end
      if l_25_0._lobby_profile_gui:check_grab_scroll_bar(l_25_3, l_25_4) then
        return true
      else
        if l_25_2 == Idstring("mouse wheel down") and l_25_0._lobby_profile_gui:mouse_wheel_down(l_25_3, l_25_4) then
          return true
          do return end
          if l_25_2 == Idstring("mouse wheel up") and l_25_0._lobby_profile_gui:mouse_wheel_up(l_25_3, l_25_4) then
            return true
          end
        end
      end
    end
  end
  if l_25_0._mission_briefing_gui and l_25_0._mission_briefing_gui:mouse_pressed(l_25_2, l_25_3, l_25_4) then
    return true
  end
  if l_25_0._stage_endscreen_gui and l_25_0._stage_endscreen_gui:mouse_pressed(l_25_2, l_25_3, l_25_4) then
    return true
  end
  if l_25_0._lootdrop_gui and l_25_0._lootdrop_gui:mouse_pressed(l_25_2, l_25_3, l_25_4) then
    return true
  end
  if l_25_0._view_character_profile_gui then
    if l_25_0._view_character_profile_gui:mouse_pressed(l_25_2, l_25_3, l_25_4) then
      return true
    end
    if l_25_2 == Idstring("0") then
      if l_25_0._view_character_profile_gui:check_minimize(l_25_3, l_25_4) then
        return true
      end
      if l_25_0._view_character_profile_gui:check_grab_scroll_bar(l_25_3, l_25_4) then
        return true
      else
        if l_25_2 == Idstring("mouse wheel down") and l_25_0._view_character_profile_gui:mouse_wheel_down(l_25_3, l_25_4) then
          return true
          do return end
          if l_25_2 == Idstring("mouse wheel up") and l_25_0._view_character_profile_gui:mouse_wheel_up(l_25_3, l_25_4) then
            return true
          end
        end
      end
    end
  end
  if l_25_0._test_profile1 then
    if l_25_0._test_profile1:check_grab_scroll_bar(l_25_3, l_25_4) then
      return true
    end
    if l_25_0._test_profile2:check_grab_scroll_bar(l_25_3, l_25_4) then
      return true
    end
    if l_25_0._test_profile3:check_grab_scroll_bar(l_25_3, l_25_4) then
      return true
    end
    if l_25_0._test_profile4:check_grab_scroll_bar(l_25_3, l_25_4) then
      return true
    end
  end
  if l_25_0._crimenet_contract_gui and l_25_0._crimenet_contract_gui:mouse_pressed(l_25_1, l_25_2, l_25_3, l_25_4) then
    return true
  end
  if l_25_0._crimenet_gui and l_25_0._crimenet_gui:mouse_pressed(l_25_1, l_25_2, l_25_3, l_25_4) then
    return true
  end
  if l_25_0._minimized_list and l_25_2 == Idstring("0") then
    for i,data in ipairs(l_25_0._minimized_list) do
      if data.panel:inside(l_25_3, l_25_4) then
        data.callback(data)
    else
      end
    end
    if l_25_0._friends_book then
      if l_25_0._friends_book:mouse_pressed(l_25_2, l_25_3, l_25_4) then
        return true
      end
      if l_25_2 == Idstring("0") and l_25_0._friends_book:check_grab_scroll_bar(l_25_3, l_25_4) then
        return true
        do return end
        if l_25_2 == Idstring("mouse wheel down") and l_25_0._friends_book:mouse_wheel_down(l_25_3, l_25_4) then
          return true
          do return end
          if l_25_2 == Idstring("mouse wheel up") and l_25_0._friends_book:mouse_wheel_up(l_25_3, l_25_4) then
            return true
          end
        end
      end
    end
    if l_25_0._debug_strings_book then
      if l_25_0._debug_strings_book:mouse_pressed(l_25_2, l_25_3, l_25_4) then
        return true
      end
      if l_25_2 == Idstring("0") and l_25_0._debug_strings_book:check_grab_scroll_bar(l_25_3, l_25_4) then
        return true
        do return end
        if l_25_2 == Idstring("mouse wheel down") and l_25_0._debug_strings_book:mouse_wheel_down(l_25_3, l_25_4) then
          return true
          do return end
          if l_25_2 == Idstring("mouse wheel up") and l_25_0._debug_strings_book:mouse_wheel_up(l_25_3, l_25_4) then
            return true
          end
        end
      end
    end
    if l_25_0._weapon_text_box then
      if l_25_2 == Idstring("0") then
        if l_25_0._weapon_text_box:check_close(l_25_3, l_25_4) then
          l_25_0:close_weapon_box()
          return true
        end
        if l_25_0._weapon_text_box:check_minimize(l_25_3, l_25_4) then
          l_25_0._weapon_text_box:set_visible(false)
          l_25_0._weapon_text_minimized_id = l_25_0:add_minimized({callback = callback(l_25_0, l_25_0, "_maximize_weapon_box"), text = "WEAPON"})
          return true
        end
        if l_25_0._weapon_text_box:check_grab_scroll_bar(l_25_3, l_25_4) then
          return true
        else
          if l_25_2 == Idstring("mouse wheel down") and l_25_0._weapon_text_box:mouse_wheel_down(l_25_3, l_25_4) then
            return true
            do return end
            if l_25_2 == Idstring("mouse wheel up") and l_25_0._weapon_text_box:mouse_wheel_up(l_25_3, l_25_4) then
              return true
            end
          end
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

MenuComponentManager.mouse_clicked = function(l_26_0, l_26_1, l_26_2, l_26_3, l_26_4)
  if l_26_0._blackmarket_gui then
    return l_26_0._blackmarket_gui:mouse_clicked(l_26_1, l_26_2, l_26_3, l_26_4)
  end
end

MenuComponentManager.mouse_double_click = function(l_27_0, l_27_1, l_27_2, l_27_3, l_27_4)
  if l_27_0._blackmarket_gui then
    return l_27_0._blackmarket_gui:mouse_double_click(l_27_1, l_27_2, l_27_3, l_27_4)
  end
end

MenuComponentManager.mouse_released = function(l_28_0, l_28_1, l_28_2, l_28_3, l_28_4)
  if l_28_0._game_chat_gui and l_28_0._game_chat_gui:mouse_released(l_28_1, l_28_2, l_28_3, l_28_4) then
    return true
  end
  if l_28_0._crimenet_gui and l_28_0._crimenet_gui:mouse_released(l_28_1, l_28_2, l_28_3, l_28_4) then
    return true
  end
  if l_28_0._blackmarket_gui then
    return l_28_0._blackmarket_gui:mouse_released(l_28_2, l_28_3, l_28_4)
  end
  if l_28_0._friends_book and l_28_0._friends_book:release_scroll_bar() then
    return true
  end
  if l_28_0._skilltree_gui and l_28_0._skilltree_gui:mouse_released(l_28_2, l_28_3, l_28_4) then
    return true
  end
  if l_28_0._debug_strings_book and l_28_0._debug_strings_book:release_scroll_bar() then
    return true
  end
  if l_28_0._chat_book then
    local used, pointer = l_28_0._chat_book:release_scroll_bar()
    if used then
      return true, pointer
    end
  end
  if l_28_0._profile_gui and l_28_0._profile_gui:release_scroll_bar() then
    return true
  end
  if l_28_0._contract_gui and l_28_0._contract_gui:release_scroll_bar() then
    return true
  end
  if l_28_0._server_info_gui and l_28_0._server_info_gui:release_scroll_bar() then
    return true
  end
  if l_28_0._lobby_profile_gui and l_28_0._lobby_profile_gui:release_scroll_bar() then
    return true
  end
  if l_28_0._view_character_profile_gui and l_28_0._view_character_profile_gui:release_scroll_bar() then
    return true
  end
  if l_28_0._test_profile1 then
    if l_28_0._test_profile1:release_scroll_bar() then
      return true
    end
    if l_28_0._test_profile2:release_scroll_bar() then
      return true
    end
    if l_28_0._test_profile3:release_scroll_bar() then
      return true
    end
    if l_28_0._test_profile4:release_scroll_bar() then
      return true
    end
  end
  if l_28_0._weapon_text_box and l_28_0._weapon_text_box:release_scroll_bar() then
    return true
  end
  return false
end

MenuComponentManager.mouse_moved = function(l_29_0, l_29_1, l_29_2, l_29_3)
  local wanted_pointer = "arrow"
  if l_29_0._skilltree_gui then
    local used, pointer = l_29_0._skilltree_gui:mouse_moved(l_29_1, l_29_2, l_29_3)
    if pointer or used then
      return true, wanted_pointer
    end
  end
  if l_29_0._blackmarket_gui then
    local used, pointer = l_29_0._blackmarket_gui:mouse_moved(l_29_1, l_29_2, l_29_3)
    if pointer or used then
      return true, wanted_pointer
    end
  end
  if l_29_0._crimenet_contract_gui then
    local used, pointer = l_29_0._crimenet_contract_gui:mouse_moved(l_29_1, l_29_2, l_29_3)
    if pointer or used then
      return true, wanted_pointer
    end
  end
  if l_29_0._crimenet_gui then
    local used, pointer = l_29_0._crimenet_gui:mouse_moved(l_29_1, l_29_2, l_29_3)
    if pointer or used then
      return true, wanted_pointer
    end
  end
  if l_29_0._friends_book then
    local used, pointer = l_29_0._friends_book:moved_scroll_bar(l_29_2, l_29_3)
    if used then
      return true, pointer
    end
    local used, pointer = l_29_0._friends_book:mouse_moved(l_29_2, l_29_3)
    if pointer or used then
      return true, wanted_pointer
    end
  end
  if l_29_0._debug_strings_book then
    local used, pointer = l_29_0._debug_strings_book:moved_scroll_bar(l_29_2, l_29_3)
    if used then
      return true, pointer
    end
    local used, pointer = l_29_0._debug_strings_book:mouse_moved(l_29_2, l_29_3)
    if pointer or used then
      return true, wanted_pointer
    end
  end
  if l_29_0._game_chat_gui then
    local used, pointer = l_29_0._game_chat_gui:mouse_moved(l_29_2, l_29_3)
    if pointer or used then
      return true, wanted_pointer
    end
  end
  if l_29_0._profile_gui then
    local used, pointer = l_29_0._profile_gui:moved_scroll_bar(l_29_2, l_29_3)
    if used then
      return true, pointer
    end
    local used, pointer = l_29_0._profile_gui:mouse_moved(l_29_2, l_29_3)
    if pointer or used then
      return true, wanted_pointer
    end
  end
  if l_29_0._contract_gui then
    local used, pointer = l_29_0._contract_gui:moved_scroll_bar(l_29_2, l_29_3)
    if used then
      return true, pointer
    end
    local used, pointer = l_29_0._contract_gui:mouse_moved(l_29_2, l_29_3)
    if pointer or used then
      return true, wanted_pointer
    end
  end
  if l_29_0._server_info_gui then
    local used, pointer = l_29_0._server_info_gui:moved_scroll_bar(l_29_2, l_29_3)
    if used then
      return true, pointer
    end
    local used, pointer = l_29_0._server_info_gui:mouse_moved(l_29_2, l_29_3)
    if pointer or used then
      return true, wanted_pointer
    end
  end
  if l_29_0._backdrop_gui then
    local used, pointer = l_29_0._backdrop_gui:mouse_moved(l_29_2, l_29_3)
    if pointer or used then
      return true, wanted_pointer
    end
  end
  if l_29_0._mission_briefing_gui then
    local used, pointer = l_29_0._mission_briefing_gui:mouse_moved(l_29_2, l_29_3)
    if pointer or used then
      return true, wanted_pointer
    end
  end
  if l_29_0._stage_endscreen_gui then
    local used, pointer = l_29_0._stage_endscreen_gui:mouse_moved(l_29_2, l_29_3)
    if pointer or used then
      return true, wanted_pointer
    end
  end
  if l_29_0._lootdrop_gui then
    local used, pointer = l_29_0._lootdrop_gui:mouse_moved(l_29_2, l_29_3)
    if pointer or used then
      return true, wanted_pointer
    end
  end
  if l_29_0._lobby_profile_gui then
    local used, pointer = l_29_0._lobby_profile_gui:moved_scroll_bar(l_29_2, l_29_3)
    if used then
      return true, pointer
    end
    local used, pointer = l_29_0._lobby_profile_gui:mouse_moved(l_29_2, l_29_3)
    if pointer or used then
      return true, wanted_pointer
    end
  end
  if l_29_0._view_character_profile_gui then
    local used, pointer = l_29_0._view_character_profile_gui:moved_scroll_bar(l_29_2, l_29_3)
    if used then
      return true, pointer
    end
    local used, pointer = l_29_0._view_character_profile_gui:mouse_moved(l_29_2, l_29_3)
    if pointer or used then
      return true, wanted_pointer
    end
  end
  if l_29_0._test_profile1 then
    local used, pointer = l_29_0._test_profile1:moved_scroll_bar(l_29_2, l_29_3)
    if used then
      return true, pointer
    end
    local used, pointer = l_29_0._test_profile2:moved_scroll_bar(l_29_2, l_29_3)
    if used then
      return true, pointer
    end
    local used, pointer = l_29_0._test_profile3:moved_scroll_bar(l_29_2, l_29_3)
    if used then
      return true, pointer
    end
    local used, pointer = l_29_0._test_profile4:moved_scroll_bar(l_29_2, l_29_3)
    if used then
      return true, pointer
    end
  end
  do
    if l_29_0._newsfeed_gui then
      local _, pointer = l_29_0._newsfeed_gui:mouse_moved(l_29_2, l_29_3)
  end
  if not pointer then
    end
  end
  if l_29_0._minimized_list then
    for i,data in ipairs(l_29_0._minimized_list) do
      if data.mouse_over ~= data.panel:inside(l_29_2, l_29_3) then
        data.mouse_over = data.panel:inside(l_29_2, l_29_3)
        if not data.mouse_over or not tweak_data.menu.default_font_no_outline_id then
          data.text:set_font(Idstring(tweak_data.menu.default_font))
        end
        if not data.mouse_over or not Color.black then
          data.text:set_color(Color.white)
        end
        data.selected:set_visible(data.mouse_over)
        data.help_text:set_visible(data.mouse_over)
      end
      data.help_text:set_position(l_29_2 + 12, l_29_3 + 12)
    end
  end
  if l_29_0._weapon_text_box and l_29_0._weapon_text_box:moved_scroll_bar(l_29_2, l_29_3) then
    return true, wanted_pointer
  end
  return false, wanted_pointer
end

MenuComponentManager.on_peer_removed = function(l_30_0, l_30_1, l_30_2)
  if l_30_0._lootdrop_gui then
    l_30_0._lootdrop_gui:on_peer_removed(l_30_1, l_30_2)
  end
end

MenuComponentManager._create_crimenet_contract_gui = function(l_31_0, l_31_1)
  l_31_0:close_crimenet_contract_gui()
  l_31_0._crimenet_contract_gui = CrimeNetContractGui:new(l_31_0._ws, l_31_0._fullscreen_ws, l_31_1)
  l_31_0:disable_crimenet()
end

MenuComponentManager.close_crimenet_contract_gui = function(l_32_0, ...)
  if l_32_0._crimenet_contract_gui then
    l_32_0._crimenet_contract_gui:close()
    l_32_0._crimenet_contract_gui = nil
    l_32_0:enable_crimenet()
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

MenuComponentManager._create_crimenet_filters_gui = function(l_33_0, l_33_1)
  l_33_0:close_crimenet_filters_gui()
  l_33_0._crimenet_filters_gui = CrimeNetFiltersGui:new(l_33_0._ws, l_33_0._fullscreen_ws, l_33_1)
  l_33_0:disable_crimenet()
end

MenuComponentManager.close_crimenet_filters_gui = function(l_34_0, ...)
  if l_34_0._crimenet_filters_gui then
    l_34_0._crimenet_filters_gui:close()
    l_34_0._crimenet_filters_gui = nil
    l_34_0:enable_crimenet()
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

MenuComponentManager._create_crimenet_gui = function(l_35_0, ...)
  if l_35_0._crimenet_gui then
    return 
  end
  l_35_0._crimenet_gui = CrimeNetGui:new(l_35_0._ws, l_35_0._fullscreen_ws, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuComponentManager.start_crimenet_job = function(l_36_0)
  l_36_0:enable_crimenet()
  if l_36_0._crimenet_gui then
    l_36_0._crimenet_gui:start_job()
  end
end

MenuComponentManager.enable_crimenet = function(l_37_0)
  if l_37_0._crimenet_gui then
    l_37_0._crimenet_gui:enable_crimenet()
  end
end

MenuComponentManager.disable_crimenet = function(l_38_0)
  if l_38_0._crimenet_gui then
    l_38_0._crimenet_gui:disable_crimenet()
  end
end

MenuComponentManager.update_crimenet_gui = function(l_39_0, l_39_1, l_39_2)
  if l_39_0._crimenet_gui then
    l_39_0._crimenet_gui:update(l_39_1, l_39_2)
  end
end

MenuComponentManager.update_crimenet_job = function(l_40_0, ...)
  l_40_0._crimenet_gui:update_job(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuComponentManager.feed_crimenet_job_timer = function(l_41_0, ...)
  l_41_0._crimenet_gui:feed_timer(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuComponentManager.update_crimenet_server_job = function(l_42_0, ...)
  if l_42_0._crimenet_gui then
    l_42_0._crimenet_gui:update_server_job(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

MenuComponentManager.feed_crimenet_server_timer = function(l_43_0, ...)
  l_43_0._crimenet_gui:feed_server_timer(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuComponentManager.criment_goto_lobby = function(l_44_0, ...)
  if l_44_0._crimenet_gui then
    l_44_0._crimenet_gui:goto_lobby(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

MenuComponentManager.set_crimenet_players_online = function(l_45_0, l_45_1)
  l_45_0._crimenet_gui:set_players_online(l_45_1)
end

MenuComponentManager.add_crimenet_gui_preset_job = function(l_46_0, l_46_1)
  l_46_0._crimenet_gui:add_preset_job(l_46_1)
end

MenuComponentManager.add_crimenet_server_job = function(l_47_0, ...)
  if l_47_0._crimenet_gui then
    l_47_0._crimenet_gui:add_server_job(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

MenuComponentManager.remove_crimenet_gui_job = function(l_48_0, l_48_1)
  if l_48_0._crimenet_gui then
    l_48_0._crimenet_gui:remove_job(l_48_1)
  end
end

MenuComponentManager.close_crimenet_gui = function(l_49_0)
  if l_49_0._crimenet_gui then
    l_49_0._crimenet_gui:close()
    l_49_0._crimenet_gui = nil
  end
end

MenuComponentManager.create_weapon_box = function(l_50_0, l_50_1, l_50_2)
  local title = managers.localization:text(tweak_data.weapon[l_50_1].name_id)
  local text = managers.localization:text(tweak_data.weapon[l_50_1].description_id)
  local stats_list = {{type = "bar", text = "DAMAGE: 32(+6)", current = 32, total = 50}, {type = "empty", h = 2}, {type = "bar", text = "RELOAD SPEED: 4(-2)", current = 4, total = 20}, {type = "empty", h = 2}, {type = "bar", text = "RECOIL: 8 (+0)", current = 8, total = 10}, {type = "empty", h = 2}, {type = "condition", value = l_50_2.condition or 19}, {type = "empty", h = 10}, {type = "mods", list = {"SHORTENED BARREL", "SPEEDHOLSTER SLING", "ONMILTE TRITIUM SIGHTS"}}, {type = "empty", h = 10}}
  if l_50_0._weapon_text_box then
    l_50_0._weapon_text_box:recreate_text_box(l_50_0._ws, title, text, {stats_list = stats_list}, {type = "weapon_stats", no_close_legend = true, use_minimize_legend = true})
  else
    l_50_0._weapon_text_box = TextBoxGui:new(l_50_0._ws, title, text, {stats_list = stats_list}, {type = "weapon_stats", no_close_legend = true, use_minimize_legend = true})
  end
end

MenuComponentManager.close_weapon_box = function(l_51_0)
  if l_51_0._weapon_text_box then
    l_51_0._weapon_text_box:close()
  end
  l_51_0._weapon_text_box = nil
  if l_51_0._weapon_text_minimized_id then
    l_51_0:remove_minimized(l_51_0._weapon_text_minimized_id)
    l_51_0._weapon_text_minimized_id = nil
  end
end

MenuComponentManager._create_chat_gui = function(l_52_0)
  if SystemInfo:platform() == Idstring("WIN32") and MenuCallbackHandler:is_multiplayer() then
    l_52_0._lobby_chat_gui_active = false
    if l_52_0._game_chat_gui then
      l_52_0:show_game_chat_gui()
      return 
    end
    l_52_0:add_game_chat()
  end
end

MenuComponentManager._create_lobby_chat_gui = function(l_53_0)
  if SystemInfo:platform() == Idstring("WIN32") and MenuCallbackHandler:is_multiplayer() then
    l_53_0._lobby_chat_gui_active = true
    if l_53_0._game_chat_gui then
      l_53_0:show_game_chat_gui()
      return 
    end
    l_53_0:add_game_chat()
  end
end

MenuComponentManager.create_chat_gui = function(l_54_0)
  l_54_0:close_chat_gui()
  local config = {w = 540, h = 220, x = 290, no_close_legend = true, use_minimize_legend = true, header_type = "fit"}
  l_54_0._chat_book = BookBoxGui:new(l_54_0._ws, nil, config)
  l_54_0._chat_book:set_layer(8)
  local global_gui = ChatGui:new(l_54_0._ws, "Global", "")
  global_gui:set_channel_id(ChatManager.GLOBAL)
  global_gui:set_layer(l_54_0._chat_book:layer())
  l_54_0._chat_book:add_page("Global", global_gui, false)
  l_54_0._chat_book:set_layer(tweak_data.gui.MENU_COMPONENT_LAYER)
end

MenuComponentManager.add_game_chat = function(l_55_0)
  if SystemInfo:platform() == Idstring("WIN32") then
    l_55_0._game_chat_gui = ChatGui:new(l_55_0._ws)
    if l_55_0._game_chat_params then
      l_55_0._game_chat_gui:set_params(l_55_0._game_chat_params)
      l_55_0._game_chat_params = nil
    end
  end
end

MenuComponentManager.set_max_lines_game_chat = function(l_56_0, l_56_1)
  if l_56_0._game_chat_gui then
    l_56_0._game_chat_gui:set_max_lines(l_56_1)
  elseif not l_56_0._game_chat_params then
    l_56_0._game_chat_params = {}
  end
  l_56_0._game_chat_params.max_lines = l_56_1
end

MenuComponentManager.pre_set_game_chat_leftbottom = function(l_57_0, l_57_1, l_57_2)
  if l_57_0._game_chat_gui then
    l_57_0._game_chat_gui:set_leftbottom(l_57_1, l_57_2)
  elseif not l_57_0._game_chat_params then
    l_57_0._game_chat_params = {}
  end
  l_57_0._game_chat_params.left = l_57_1
  l_57_0._game_chat_params.bottom = l_57_2
end

MenuComponentManager.remove_game_chat = function(l_58_0)
  if not l_58_0._chat_book then
    return 
  end
  l_58_0._chat_book:remove_page("Game")
end

MenuComponentManager.hide_lobby_chat_gui = function(l_59_0)
  if l_59_0._game_chat_gui and l_59_0._lobby_chat_gui_active then
    l_59_0._game_chat_gui:hide()
  end
end

MenuComponentManager.hide_game_chat_gui = function(l_60_0)
  if l_60_0._game_chat_gui then
    l_60_0._game_chat_gui:hide()
  end
end

MenuComponentManager.show_game_chat_gui = function(l_61_0)
  if l_61_0._game_chat_gui then
    l_61_0._game_chat_gui:show()
  end
end

MenuComponentManager._disable_chat_gui = function(l_62_0)
  if l_62_0._game_chat_gui and not l_62_0._lobby_chat_gui_active then
    l_62_0._game_chat_gui:set_enabled(false)
  end
end

MenuComponentManager.close_chat_gui = function(l_63_0)
  if l_63_0._game_chat_gui then
    l_63_0._game_chat_gui:close()
    l_63_0._game_chat_gui = nil
  end
  if l_63_0._chat_book_minimized_id then
    l_63_0:remove_minimized(l_63_0._chat_book_minimized_id)
    l_63_0._chat_book_minimized_id = nil
  end
  l_63_0._game_chat_bottom = nil
  l_63_0._lobby_chat_gui_active = nil
end

MenuComponentManager._create_friends_gui = function(l_64_0)
  if SystemInfo:platform() == Idstring("WIN32") then
    if l_64_0._friends_book then
      l_64_0._friends_book:set_enabled(true)
      return 
    end
    l_64_0:create_friends_gui()
  end
end

MenuComponentManager.create_friends_gui = function(l_65_0)
  l_65_0:close_friends_gui()
  l_65_0._friends_book = BookBoxGui:new(l_65_0._ws, nil, {no_close_legend = true, no_scroll_legend = true})
  l_65_0._friends_gui = FriendsBoxGui:new(l_65_0._ws, "Friends", "")
  l_65_0._friends2_gui = FriendsBoxGui:new(l_65_0._ws, "Test", "", nil, nil, "recent")
  l_65_0._friends3_gui = FriendsBoxGui:new(l_65_0._ws, "Test", "")
  l_65_0._friends_book:add_page("Friends", l_65_0._friends_gui, true)
  l_65_0._friends_book:add_page("Recent Players", l_65_0._friends2_gui)
  l_65_0._friends_book:add_page("Clan", l_65_0._friends3_gui)
  l_65_0._friends_book:set_layer(tweak_data.gui.MENU_COMPONENT_LAYER)
end

MenuComponentManager._update_friends_gui = function(l_66_0)
  if l_66_0._friends_gui then
    l_66_0._friends_gui:update_friends()
  end
end

MenuComponentManager._disable_friends_gui = function(l_67_0)
  if l_67_0._friends_book then
    l_67_0._friends_book:set_enabled(false)
  end
end

MenuComponentManager.close_friends_gui = function(l_68_0)
  if l_68_0._friends_gui then
    l_68_0._friends_gui = nil
  end
  if l_68_0._friends_book then
    l_68_0._friends_book:close()
    l_68_0._friends_book = nil
  end
end

MenuComponentManager._create_contract_gui = function(l_69_0)
  if l_69_0._contract_gui then
    l_69_0._contract_gui:set_enabled(true)
    return 
  end
  l_69_0:create_contract_gui()
end

MenuComponentManager.create_contract_gui = function(l_70_0)
  l_70_0:close_contract_gui()
  l_70_0._contract_gui = ContractBoxGui:new(l_70_0._ws, l_70_0._fullscreen_ws)
  if not managers.menu:get_all_peers_state() then
    local peers_state = {}
  end
  for i = 1, 4 do
    l_70_0._contract_gui:update_character_menu_state(i, peers_state[i])
  end
end

MenuComponentManager.update_contract_character = function(l_71_0, l_71_1)
  if l_71_0._contract_gui then
    l_71_0._contract_gui:update_character(l_71_1)
  end
end

MenuComponentManager.update_contract_character_menu_state = function(l_72_0, l_72_1, l_72_2)
  if l_72_0._contract_gui then
    l_72_0._contract_gui:update_character_menu_state(l_72_1, l_72_2)
  end
end

MenuComponentManager._disable_contract_gui = function(l_73_0)
  if l_73_0._contract_gui then
    l_73_0._contract_gui:set_enabled(false)
  end
end

MenuComponentManager.close_contract_gui = function(l_74_0)
  if l_74_0._contract_gui then
    l_74_0._contract_gui:close()
    l_74_0._contract_gui = nil
  end
end

MenuComponentManager._create_skilltree_gui = function(l_75_0)
  l_75_0:create_skilltree_gui()
end

MenuComponentManager.create_skilltree_gui = function(l_76_0, l_76_1)
  l_76_0:close_skilltree_gui()
  l_76_0._skilltree_gui = SkillTreeGui:new(l_76_0._ws, l_76_0._fullscreen_ws, l_76_1)
end

MenuComponentManager.close_skilltree_gui = function(l_77_0)
  if l_77_0._skilltree_gui then
    l_77_0._skilltree_gui:close()
    l_77_0._skilltree_gui = nil
  end
end

MenuComponentManager.on_tier_unlocked = function(l_78_0, ...)
  if l_78_0._skilltree_gui then
    l_78_0._skilltree_gui:on_tier_unlocked(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

MenuComponentManager.on_skill_unlocked = function(l_79_0, ...)
  if l_79_0._skilltree_gui then
    l_79_0._skilltree_gui:on_skill_unlocked(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

MenuComponentManager.on_points_spent = function(l_80_0, ...)
  if l_80_0._skilltree_gui then
    l_80_0._skilltree_gui:on_points_spent(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

MenuComponentManager._create_inventory_list_gui = function(l_81_0, l_81_1)
  l_81_0:create_inventory_list_gui(l_81_1)
end

MenuComponentManager.create_inventory_list_gui = function(l_82_0, l_82_1)
  l_82_0:close_inventory_list_gui()
  l_82_0._inventory_list_gui = InventoryList:new(l_82_0._ws, l_82_0._fullscreen_ws, l_82_1)
end

MenuComponentManager.close_inventory_list_gui = function(l_83_0)
  if l_83_0._inventory_list_gui then
    l_83_0._inventory_list_gui:close()
    l_83_0._inventory_list_gui = nil
  end
end

MenuComponentManager._create_blackmarket_gui = function(l_84_0, l_84_1)
  l_84_0:create_blackmarket_gui(l_84_1)
end

MenuComponentManager.create_blackmarket_gui = function(l_85_0, l_85_1)
  l_85_0:close_blackmarket_gui()
  l_85_0._blackmarket_gui = BlackMarketGui:new(l_85_0._ws, l_85_0._fullscreen_ws, l_85_1)
end

MenuComponentManager.set_blackmarket_tab_positions = function(l_86_0)
  if l_86_0._blackmarket_gui then
    l_86_0._blackmarket_gui:set_tab_positions()
  end
end

MenuComponentManager.close_blackmarket_gui = function(l_87_0)
  if l_87_0._blackmarket_gui then
    l_87_0._blackmarket_gui:close()
    l_87_0._blackmarket_gui = nil
  end
end

MenuComponentManager._create_server_info_gui = function(l_88_0)
  if l_88_0._server_info_gui then
    l_88_0:close_server_info_gui()
  end
  l_88_0:create_server_info_gui()
end

MenuComponentManager.create_server_info_gui = function(l_89_0)
  l_89_0:close_server_info_gui()
  l_89_0._server_info_gui = ServerStatusBoxGui:new(l_89_0._ws)
  l_89_0._server_info_gui:set_layer(tweak_data.gui.MENU_COMPONENT_LAYER)
end

MenuComponentManager._disable_server_info_gui = function(l_90_0)
  if l_90_0._server_info_gui then
    l_90_0._server_info_gui:set_enabled(false)
  end
end

MenuComponentManager.close_server_info_gui = function(l_91_0)
  if l_91_0._server_info_gui then
    l_91_0._server_info_gui:close()
    l_91_0._server_info_gui = nil
  end
end

MenuComponentManager.set_server_info_state = function(l_92_0, l_92_1)
  if l_92_0._server_info_gui then
    l_92_0._server_info_gui:set_server_info_state(l_92_1)
  end
end

MenuComponentManager._create_mission_briefing_gui = function(l_93_0, l_93_1)
  l_93_0:create_mission_briefing_gui(l_93_1)
end

MenuComponentManager.create_mission_briefing_gui = function(l_94_0, l_94_1)
  if not l_94_0._mission_briefing_gui then
    l_94_0._mission_briefing_gui = MissionBriefingGui:new(l_94_0._ws, l_94_0._fullscreen_ws, l_94_1)
  else
    l_94_0._mission_briefing_gui:reload_loadout()
  end
  l_94_0._mission_briefing_gui:show()
end

MenuComponentManager._hide_mission_briefing_gui = function(l_95_0)
  l_95_0:hide_mission_briefing_gui()
end

MenuComponentManager.hide_mission_briefing_gui = function(l_96_0)
  if l_96_0._mission_briefing_gui then
    l_96_0._mission_briefing_gui:hide()
  end
end

MenuComponentManager.show_mission_briefing_gui = function(l_97_0)
  if l_97_0._mission_briefing_gui then
    l_97_0._mission_briefing_gui:show()
  end
end

MenuComponentManager.close_mission_briefing_gui = function(l_98_0)
  if l_98_0._mission_briefing_gui then
    l_98_0._mission_briefing_gui:close()
    l_98_0._mission_briefing_gui = nil
  end
end

MenuComponentManager.set_mission_briefing_description = function(l_99_0, l_99_1)
  if l_99_0._mission_briefing_gui then
    l_99_0._mission_briefing_gui:set_description_text_id(l_99_1)
  end
end

MenuComponentManager.on_ready_pressed_mission_briefing_gui = function(l_100_0, l_100_1)
  if l_100_0._mission_briefing_gui then
    l_100_0._mission_briefing_gui:on_ready_pressed(l_100_1)
  end
end

MenuComponentManager.unlock_asset_mission_briefing_gui = function(l_101_0, l_101_1)
  if l_101_0._mission_briefing_gui then
    l_101_0._mission_briefing_gui:unlock_asset(l_101_1)
  end
end

MenuComponentManager.set_slot_outfit_mission_briefing_gui = function(l_102_0, l_102_1, l_102_2, l_102_3)
  if l_102_0._mission_briefing_gui then
    l_102_0._mission_briefing_gui:set_slot_outfit(l_102_1, l_102_2, l_102_3)
  end
end

MenuComponentManager.create_asset_mission_briefing_gui = function(l_103_0)
  if l_103_0._mission_briefing_gui then
    l_103_0._mission_briefing_gui:create_asset_tab()
  end
end

MenuComponentManager.close_asset_mission_briefing_gui = function(l_104_0)
  if l_104_0._mission_briefing_gui then
    l_104_0._mission_briefing_gui:close_asset()
  end
end

MenuComponentManager.flash_ready_mission_briefing_gui = function(l_105_0)
  if l_105_0._mission_briefing_gui then
    l_105_0._mission_briefing_gui:flash_ready()
  end
end

MenuComponentManager._create_lootdrop_gui = function(l_106_0)
  print("_create_lootdrop_gui()")
  l_106_0:create_lootdrop_gui()
end

MenuComponentManager.create_lootdrop_gui = function(l_107_0)
  if not l_107_0._lootdrop_gui then
    l_107_0._lootdrop_gui = LootDropScreenGui:new(l_107_0._ws, l_107_0._fullscreen_ws, managers.hud:get_lootscreen_hud(), l_107_0._saved_lootdrop_state)
    l_107_0._saved_lootdrop_state = nil
  end
  l_107_0:show_lootdrop_gui()
end

MenuComponentManager.set_lootdrop_state = function(l_108_0, l_108_1)
  if l_108_0._lootdrop_gui then
    l_108_0._lootdrop_gui:set_state(l_108_1)
  else
    l_108_0._saved_lootdrop_state = l_108_1
  end
end

MenuComponentManager._hide_lootdrop_gui = function(l_109_0)
  l_109_0:hide_lootdrop_gui()
end

MenuComponentManager.hide_lootdrop_gui = function(l_110_0)
  if l_110_0._lootdrop_gui then
    l_110_0._lootdrop_gui:hide()
  end
end

MenuComponentManager.show_lootdrop_gui = function(l_111_0)
  if l_111_0._lootdrop_gui then
    l_111_0._lootdrop_gui:show()
  end
end

MenuComponentManager.close_lootdrop_gui = function(l_112_0)
  if l_112_0._lootdrop_gui then
    l_112_0._lootdrop_gui:close()
    l_112_0._lootdrop_gui = nil
  end
end

MenuComponentManager.lootdrop_is_now_active = function(l_113_0)
  if l_113_0._lootdrop_gui then
    l_113_0._lootdrop_gui._panel:show()
    l_113_0._lootdrop_gui._fullscreen_panel:show()
  end
end

MenuComponentManager._create_stage_endscreen_gui = function(l_114_0)
  l_114_0:create_stage_endscreen_gui()
end

MenuComponentManager.create_stage_endscreen_gui = function(l_115_0)
  if not l_115_0._stage_endscreen_gui then
    l_115_0._stage_endscreen_gui = StageEndScreenGui:new(l_115_0._ws, l_115_0._fullscreen_ws)
  end
  game_state_machine:current_state():set_continue_button_text()
  l_115_0._stage_endscreen_gui:show()
  if l_115_0._endscreen_predata then
    if l_115_0._endscreen_predata.cash_summary then
      l_115_0:show_endscreen_cash_summary()
    end
    if l_115_0._endscreen_predata.stats then
      l_115_0:feed_endscreen_statistics(l_115_0._endscreen_predata.stats)
    end
    if l_115_0._endscreen_predata.continue then
      l_115_0:set_endscreen_continue_button_text(l_115_0._endscreen_predata.continue[1], l_115_0._endscreen_predata.continue[2])
    end
    l_115_0._endscreen_predata = nil
  end
end

MenuComponentManager._hide_stage_endscreen_gui = function(l_116_0)
  l_116_0:hide_stage_endscreen_gui()
end

MenuComponentManager.hide_stage_endscreen_gui = function(l_117_0)
  if l_117_0._stage_endscreen_gui then
    l_117_0._stage_endscreen_gui:hide()
  end
end

MenuComponentManager.show_stage_endscreen_gui = function(l_118_0)
  if l_118_0._stage_endscreen_gui then
    l_118_0._stage_endscreen_gui:show()
  end
end

MenuComponentManager.close_stage_endscreen_gui = function(l_119_0)
  if l_119_0._stage_endscreen_gui then
    l_119_0._stage_endscreen_gui:close()
    l_119_0._stage_endscreen_gui = nil
  end
end

MenuComponentManager.show_endscreen_cash_summary = function(l_120_0)
  if l_120_0._stage_endscreen_gui then
    l_120_0._stage_endscreen_gui:show_cash_summary()
  elseif not l_120_0._endscreen_predata then
    l_120_0._endscreen_predata = {}
  end
  l_120_0._endscreen_predata.cash_summary = true
end

MenuComponentManager.feed_endscreen_statistics = function(l_121_0, l_121_1)
  if l_121_0._stage_endscreen_gui then
    l_121_0._stage_endscreen_gui:feed_statistics(l_121_1)
  elseif not l_121_0._endscreen_predata then
    l_121_0._endscreen_predata = {}
  end
  l_121_0._endscreen_predata.stats = l_121_1
end

MenuComponentManager.set_endscreen_continue_button_text = function(l_122_0, l_122_1, l_122_2)
  if l_122_0._stage_endscreen_gui then
    l_122_0._stage_endscreen_gui:set_continue_button_text(l_122_1, l_122_2)
  elseif not l_122_0._endscreen_predata then
    l_122_0._endscreen_predata = {}
  end
  l_122_0._endscreen_predata.continue = {l_122_1, l_122_2}
end

MenuComponentManager._create_menuscene_info_gui = function(l_123_0, l_123_1)
  l_123_0:_close_menuscene_info_gui()
  if not l_123_0._menuscene_info_gui then
    l_123_0._menuscene_info_gui = MenuSceneGui:new(l_123_0._ws, l_123_0._fullscreen_ws, l_123_1)
  end
end

MenuComponentManager._close_menuscene_info_gui = function(l_124_0)
  if l_124_0._menuscene_info_gui then
    l_124_0._menuscene_info_gui:close()
    l_124_0._menuscene_info_gui = nil
  end
end

MenuComponentManager._create_player_profile_gui = function(l_125_0)
  l_125_0:create_player_profile_gui()
end

MenuComponentManager.create_player_profile_gui = function(l_126_0)
  l_126_0:close_player_profile_gui()
  l_126_0._player_profile_gui = PlayerProfileGuiObject:new(l_126_0._ws)
end

MenuComponentManager.refresh_player_profile_gui = function(l_127_0)
  if l_127_0._player_profile_gui then
    l_127_0:create_player_profile_gui()
  end
end

MenuComponentManager.close_player_profile_gui = function(l_128_0)
  if l_128_0._player_profile_gui then
    l_128_0._player_profile_gui:close()
    l_128_0._player_profile_gui = nil
  end
end

MenuComponentManager._create_ingame_manual_gui = function(l_129_0)
  l_129_0:create_ingame_manual_gui()
end

MenuComponentManager.create_ingame_manual_gui = function(l_130_0)
  l_130_0:close_ingame_manual_gui()
  l_130_0._ingame_manual_gui = IngameManualGui:new(l_130_0._ws, l_130_0._fullscreen_ws)
  l_130_0._ingame_manual_gui:set_layer(tweak_data.gui.MENU_COMPONENT_LAYER)
end

MenuComponentManager.ingame_manual_texture_done = function(l_131_0, l_131_1)
  if l_131_0._ingame_manual_gui then
    l_131_0._ingame_manual_gui:create_page(l_131_1)
  else
    local destroy_me = l_131_0._ws:panel():bitmap({texture = l_131_1, visible = false, w = 0, h = 0})
    destroy_me:parent():remove(destroy_me)
  end
end

MenuComponentManager.close_ingame_manual_gui = function(l_132_0)
  if l_132_0._ingame_manual_gui then
    l_132_0._ingame_manual_gui:close()
    l_132_0._ingame_manual_gui = nil
  end
end

MenuComponentManager._create_ingame_contract_gui = function(l_133_0)
  l_133_0:create_ingame_contract_gui()
end

MenuComponentManager.create_ingame_contract_gui = function(l_134_0)
  l_134_0:close_ingame_contract_gui()
  l_134_0._ingame_contract_gui = IngameContractGui:new(l_134_0._ws)
  l_134_0._ingame_contract_gui:set_layer(tweak_data.gui.MENU_COMPONENT_LAYER)
end

MenuComponentManager.close_ingame_contract_gui = function(l_135_0)
  if l_135_0._ingame_contract_gui then
    l_135_0._ingame_contract_gui:close()
    l_135_0._ingame_contract_gui = nil
  end
end

MenuComponentManager._create_profile_gui = function(l_136_0)
  if l_136_0._profile_gui then
    l_136_0._profile_gui:set_enabled(true)
    return 
  end
  l_136_0:create_profile_gui()
end

MenuComponentManager.create_profile_gui = function(l_137_0)
  l_137_0:close_profile_gui()
  l_137_0._profile_gui = ProfileBoxGui:new(l_137_0._ws)
  l_137_0._profile_gui:set_layer(tweak_data.gui.MENU_COMPONENT_LAYER)
end

MenuComponentManager._disable_profile_gui = function(l_138_0)
  if l_138_0._profile_gui then
    l_138_0._profile_gui:set_enabled(false)
  end
end

MenuComponentManager.close_profile_gui = function(l_139_0)
  if l_139_0._profile_gui then
    l_139_0._profile_gui:close()
    l_139_0._profile_gui = nil
  end
end

MenuComponentManager.create_test_profiles = function(l_140_0)
  l_140_0:close_test_profiles()
  l_140_0._test_profile1 = ProfileBoxGui:new(l_140_0._ws)
  l_140_0._test_profile1:set_title("")
  l_140_0._test_profile1:set_use_minimize_legend(false)
  l_140_0._test_profile2 = ProfileBoxGui:new(l_140_0._ws)
  l_140_0._test_profile2:set_title("")
  l_140_0._test_profile2:set_use_minimize_legend(false)
  l_140_0._test_profile3 = ProfileBoxGui:new(l_140_0._ws)
  l_140_0._test_profile3:set_title("")
  l_140_0._test_profile3:set_use_minimize_legend(false)
  l_140_0._test_profile4 = ProfileBoxGui:new(l_140_0._ws)
  l_140_0._test_profile4:set_title("")
  l_140_0._test_profile4:set_use_minimize_legend(false)
end

MenuComponentManager.close_test_profiles = function(l_141_0)
  if l_141_0._test_profile1 then
    l_141_0._test_profile1:close()
    l_141_0._test_profile1 = nil
    l_141_0._test_profile2:close()
    l_141_0._test_profile2 = nil
    l_141_0._test_profile3:close()
    l_141_0._test_profile3 = nil
    l_141_0._test_profile4:close()
    l_141_0._test_profile4 = nil
  end
end

MenuComponentManager.create_lobby_profile_gui = function(l_142_0, l_142_1, l_142_2, l_142_3)
  l_142_0:close_lobby_profile_gui()
  l_142_0._lobby_profile_gui = LobbyProfileBoxGui:new(l_142_0._ws, nil, nil, nil, {h = 160, x = l_142_2, y = l_142_3}, l_142_1)
  l_142_0._lobby_profile_gui:set_title(nil)
  l_142_0._lobby_profile_gui:set_use_minimize_legend(false)
end

MenuComponentManager.close_lobby_profile_gui = function(l_143_0)
  if l_143_0._lobby_profile_gui then
    l_143_0._lobby_profile_gui:close()
    l_143_0._lobby_profile_gui = nil
  end
  if l_143_0._lobby_profile_gui_minimized_id then
    l_143_0:remove_minimized(l_143_0._lobby_profile_gui_minimized_id)
    l_143_0._lobby_profile_gui_minimized_id = nil
  end
end

MenuComponentManager.create_view_character_profile_gui = function(l_144_0, l_144_1, l_144_2, l_144_3)
  l_144_0:close_view_character_profile_gui()
  l_144_0._view_character_profile_gui = ViewCharacterProfileBoxGui:new(l_144_0._ws, nil, nil, nil, {h = 160, w = 360, x = 837, y = 100}, l_144_1)
  l_144_0._view_character_profile_gui:set_title(nil)
  l_144_0._view_character_profile_gui:set_use_minimize_legend(false)
end

MenuComponentManager.close_view_character_profile_gui = function(l_145_0)
  if l_145_0._view_character_profile_gui then
    l_145_0._view_character_profile_gui:close()
    l_145_0._view_character_profile_gui = nil
  end
  if l_145_0._view_character_profile_gui_minimized_id then
    l_145_0:remove_minimized(l_145_0._view_character_profile_gui_minimized_id)
    l_145_0._view_character_profile_gui_minimized_id = nil
  end
end

MenuComponentManager._create_newsfeed_gui = function(l_146_0)
  if l_146_0._newsfeed_gui then
    return 
  end
  l_146_0:create_newsfeed_gui()
end

MenuComponentManager.create_newsfeed_gui = function(l_147_0)
  l_147_0:close_newsfeed_gui()
  if SystemInfo:platform() == Idstring("WIN32") then
    l_147_0._newsfeed_gui = NewsFeedGui:new(l_147_0._ws)
  end
end

MenuComponentManager._update_newsfeed_gui = function(l_148_0, l_148_1, l_148_2)
  if l_148_0._newsfeed_gui then
    l_148_0._newsfeed_gui:update(l_148_1, l_148_2)
  end
end

MenuComponentManager.close_newsfeed_gui = function(l_149_0)
  if l_149_0._newsfeed_gui then
    l_149_0._newsfeed_gui:close()
    l_149_0._newsfeed_gui = nil
  end
end

MenuComponentManager._create_debug_fonts_gui = function(l_150_0)
  if l_150_0._debug_fonts_gui then
    l_150_0._debug_fonts_gui:set_enabled(true)
    return 
  end
  l_150_0:create_debug_fonts_gui()
end

MenuComponentManager.create_debug_fonts_gui = function(l_151_0)
  l_151_0:close_debug_fonts_gui()
  l_151_0._debug_fonts_gui = DebugDrawFonts:new(l_151_0._fullscreen_ws)
end

MenuComponentManager._disable_debug_fonts_gui = function(l_152_0)
  if l_152_0._debug_fonts_gui then
    l_152_0._debug_fonts_gui:set_enabled(false)
  end
end

MenuComponentManager.close_debug_fonts_gui = function(l_153_0)
  if l_153_0._debug_fonts_gui then
    l_153_0._debug_fonts_gui:close()
    l_153_0._debug_fonts_gui = nil
  end
end

MenuComponentManager.toggle_debug_fonts_gui = function(l_154_0)
  if Application:production_build() and l_154_0._debug_fonts_gui then
    l_154_0._debug_fonts_gui:toggle_debug()
  end
end

MenuComponentManager.reload_debug_fonts_gui = function(l_155_0)
  if l_155_0._debug_fonts_gui then
    l_155_0._debug_fonts_gui:reload()
  end
end

MenuComponentManager._create_debug_strings_gui = function(l_156_0)
  if l_156_0._debug_strings_book then
    l_156_0._debug_strings_book:set_enabled(true)
    return 
  end
  l_156_0:create_debug_strings_gui()
end

MenuComponentManager.create_debug_strings_gui = function(l_157_0)
  l_157_0:close_debug_strings_gui()
  l_157_0._debug_strings_book = BookBoxGui:new(l_157_0._ws, nil, {no_close_legend = true, no_scroll_legend = true, w = 1088, h = 612})
  l_157_0._debug_strings_book._info_box:close()
  l_157_0._debug_strings_book._info_box = nil
  for i,file_name in ipairs({"debug", "blackmarket", "challenges", "hud", "atmospheric_text", "subtitles", "heist", "menu", "savefile", "system_text", "systemmenu", "wip"}) do
    local gui = DebugStringsBoxGui:new(l_157_0._ws, "file", "", nil, nil, "strings/" .. file_name)
    l_157_0._debug_strings_book:add_page(file_name, gui, i == 1)
  end
  l_157_0._debug_strings_book:add_background()
  l_157_0._debug_strings_book:set_layer(tweak_data.gui.DIALOG_LAYER)
  l_157_0._debug_strings_book:set_centered()
end

MenuComponentManager._disable_debug_strings_gui = function(l_158_0)
  if l_158_0._debug_strings_book then
    l_158_0._debug_strings_book:set_enabled(false)
  end
end

MenuComponentManager.close_debug_strings_gui = function(l_159_0)
  if l_159_0._debug_strings_book then
    l_159_0._debug_strings_book:close()
    l_159_0._debug_strings_book = nil
  end
end

MenuComponentManager._maximize_weapon_box = function(l_160_0, l_160_1)
  l_160_0._weapon_text_box:set_visible(true)
  l_160_0._weapon_text_minimized_id = nil
  l_160_0:remove_minimized(l_160_1.id)
end

MenuComponentManager.add_minimized = function(l_161_0, l_161_1)
  if not l_161_0._minimized_list then
    l_161_0._minimized_list = {}
  end
  l_161_0._minimized_id = (l_161_0._minimized_id or 0) + 1
  local panel = (l_161_0._main_panel:panel({w = 100, h = 20, layer = tweak_data.gui.MENU_COMPONENT_LAYER}))
  local text = nil
  if l_161_1.text then
    text = panel:text({text = l_161_1.text, align = "center", halign = "left", vertical = "center", hvertical = "center", font = tweak_data.menu.default_font, font_size = 22, layer = 2})
    text:set_center_y(panel:center_y())
    local _, _, w, h = text:text_rect()
    text:set_size(w + 8, h)
    panel:set_size(w + 8, h)
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local help_text = panel:parent():text({text = l_161_1.help_text or "CLICK TO MAXIMIZE WEAPON INFO", align = "left", halign = "left", vertical = "center"})
  help_text:set_shape(help_text:text_rect())
  {text = l_161_1.help_text or "CLICK TO MAXIMIZE WEAPON INFO", align = "left", halign = "left", vertical = "center"}.layer, {text = l_161_1.help_text or "CLICK TO MAXIMIZE WEAPON INFO", align = "left", halign = "left", vertical = "center"}.color, {text = l_161_1.help_text or "CLICK TO MAXIMIZE WEAPON INFO", align = "left", halign = "left", vertical = "center"}.font_size, {text = l_161_1.help_text or "CLICK TO MAXIMIZE WEAPON INFO", align = "left", halign = "left", vertical = "center"}.font, {text = l_161_1.help_text or "CLICK TO MAXIMIZE WEAPON INFO", align = "left", halign = "left", vertical = "center"}.visible, {text = l_161_1.help_text or "CLICK TO MAXIMIZE WEAPON INFO", align = "left", halign = "left", vertical = "center"}.hvertical = 3, Color.white, tweak_data.menu.small_font_size, tweak_data.menu.small_font, false, "center"
  local unselected = panel:bitmap({texture = "guis/textures/menu_unselected", layer = 0})
  unselected:set_h(64 * panel:h() / 32)
  unselected:set_center_y(panel:center_y())
  local selected = panel:bitmap({texture = "guis/textures/menu_selected", layer = 1, visible = false})
  selected:set_h(64 * panel:h() / 32)
  selected:set_center_y(panel:center_y())
  panel:set_bottom(l_161_0._main_panel:h() - CoreMenuRenderer.Renderer.border_height)
  local top_line = panel:parent():bitmap({visible = false, texture = "guis/textures/headershadow", layer = 1, w = panel:w()})
  top_line:set_bottom(panel:top())
  table.insert(l_161_0._minimized_list, {id = l_161_0._minimized_id, panel = panel, selected = selected, text = text, help_text = help_text, top_line = top_line, callback = l_161_1.callback, mouse_over = false})
  l_161_0:_layout_minimized()
  return l_161_0._minimized_id
end

MenuComponentManager._layout_minimized = function(l_162_0)
  local x = 0
  for i,data in ipairs(l_162_0._minimized_list) do
    data.panel:set_x(x)
    data.top_line:set_x(x)
    x = x + data.panel:w() + 2
  end
end

MenuComponentManager.remove_minimized = function(l_163_0, l_163_1)
  for i,data in ipairs(l_163_0._minimized_list) do
    if data.id == l_163_1 then
      data.help_text:parent():remove(data.help_text)
      data.top_line:parent():remove(data.top_line)
      l_163_0._main_panel:remove(data.panel)
      table.remove(l_163_0._minimized_list, i)
  else
    end
  end
  l_163_0:_layout_minimized()
end

MenuComponentManager._request_done_callback = function(l_164_0, l_164_1)
  local key = l_164_1:key()
  local requests = l_164_0._requested_textures[key]
  if not requests then
    print("[MenuComponentManager] request_done_callback(): Have no requests for this texture", l_164_1)
    return 
  end
  local count = l_164_0._cached_textures[key] or 0
  if l_164_0._cached_textures[key] then
    Application:error("[MenuComponentManager] request_done_callback(): Texture already in cache!", l_164_1)
    TextureCache:unretrieve(l_164_1)
  end
  for _,request_cb in pairs(requests) do
    count = count + 1
    request_cb(l_164_1)
  end
  l_164_0._cached_textures[key] = count
  l_164_0._requested_textures[key] = nil
  l_164_0._requested_index[key] = nil
end

MenuComponentManager.request_texture = function(l_165_0, l_165_1, l_165_2)
  local texture_ids = Idstring(l_165_1)
  local key = texture_ids:key()
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local is_removing = true
l_165_0._removing_textures[key] = nil
if l_165_0._cached_textures[key] then
  l_165_0._cached_textures[key] = l_165_0._cached_textures[key] + 1
  l_165_2(texture_ids)
  return 
else
  if l_165_0._requested_textures[key] then
    local count = l_165_0._requested_index[key] + 1
    l_165_0._requested_index[key] = count
    l_165_0._requested_textures[key][count] = l_165_2
    return count
  else
    l_165_0._requested_textures[key] = {}
    local count = 1
    l_165_0._requested_index[key] = count
    l_165_0._requested_textures[key][count] = l_165_2
    if not is_removing then
      TextureCache:request(l_165_1, "NORMAL", callback(l_165_0, l_165_0, "_request_done_callback"))
    else
      Application:debug("[MenuComponentManager] request_texture(): This code should no longer be used.")
      return count
    end
  end
end

MenuComponentManager.unretrieve_texture = function(l_166_0, l_166_1, l_166_2)
  local texture_ids = Idstring(l_166_1)
  local key = texture_ids:key()
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local is_removing = true
if l_166_0._cached_textures[key] then
  l_166_0._cached_textures[key] = l_166_0._cached_textures[key] - 1
  if l_166_0._cached_textures[key] == 0 then
    if not is_removing then
      l_166_0._removing_textures[key] = texture_ids
    else
      Application:error("[MenuComponentManager] unretrieve_texture(self._cached_textures): Trying to unretrieve a texture that is already to be unretrieved!", l_166_1)
    end
  else
    if l_166_0._cached_textures[key] < 0 then
      Application:error("[MenuComponentManager] unretrieve_texture(): To many unretrieve calls done!", l_166_1, l_166_0._cached_textures[key])
      l_166_0._cached_textures[key] = 0
    end
  end
  return 
else
  if l_166_0._requested_textures[key] then
    if not l_166_2 then
      Application:error("[MenuComponentManager] unretrieve_texture(): Index parameter needed!", l_166_1)
      Application:stack_dump()
      l_166_2 = 1
    end
    l_166_0._requested_textures[key][l_166_2] = nil
    if table.size(l_166_0._requested_textures[key]) == 0 then
      if not is_removing then
        l_166_0._removing_textures[key] = texture_ids
      else
        Application:error("[MenuComponentManager] unretrieve_texture(self._requested_textures): Trying to unretrieve a texture that is already to be unretrieved!", l_166_1)
      end
    end
    return 
  elseif is_removing then
    Application:error("[MenuComponentManager] unretrieve_texture(): Texture not cache nor requested, but still already to be unretrieved?!", l_166_1)
  else
    Application:error("[MenuComponentManager] unretrieve_texture(): Can't unretrieve texture that is not in the system!", l_166_1)
  end
end
end

MenuComponentManager.post_event = function(l_167_0, l_167_1, l_167_2)
  if alive(l_167_0._post_event) then
    l_167_0._post_event:stop()
    l_167_0._post_event = nil
  end
  local post_event = l_167_0._sound_source:post_event(l_167_1)
  if l_167_2 then
    l_167_0._post_event = post_event
  end
  return post_event
end

MenuComponentManager.stop_event = function(l_168_0)
  print("MenuComponentManager:stop_event()")
  if alive(l_168_0._post_event) then
    l_168_0._post_event:stop()
    l_168_0._post_event = nil
  end
end

MenuComponentManager.close = function(l_169_0)
  l_169_0:close_friends_gui()
  l_169_0:close_newsfeed_gui()
  l_169_0:close_profile_gui()
  l_169_0:close_player_profile_gui()
  l_169_0:close_contract_gui()
  l_169_0:close_server_info_gui()
  l_169_0:close_chat_gui()
  l_169_0:close_crimenet_gui()
  l_169_0:close_blackmarket_gui()
  l_169_0:close_stage_endscreen_gui()
  l_169_0:close_lootdrop_gui()
  l_169_0:close_mission_briefing_gui()
  l_169_0:close_debug_fonts_gui()
  if l_169_0._resolution_changed_callback_id then
    managers.viewport:remove_resolution_changed_func(l_169_0._resolution_changed_callback_id)
  end
  if alive(l_169_0._post_event) then
    l_169_0._post_event:stop()
  end
  l_169_0:_destroy_controller_input()
  for texture_ids,users in pairs(l_169_0._texture_cache) do
    TextureCache:unretrieve(texture_ids)
  end
  l_169_0._texture_cache = {}
  for texture_ids,users in pairs(l_169_0._requested_textures) do
    TextureCache:unretrieve(texture_ids)
  end
  l_169_0._requested_textures = {}
end

MenuComponentManager.test_camera_shutter_tech = function(l_170_0)
  if not l_170_0._tcst then
    l_170_0._tcst = managers.gui_data:create_fullscreen_16_9_workspace(managers.gui_data)
    local o = l_170_0._tcst:panel():panel({layer = 10000})
    local b = o:rect({name = "black", color = Color.black, layer = 5, halign = "scale", valign = "scale"})
    local one_frame_hide = function(l_1_0)
      l_1_0:hide()
      coroutine.yield()
      l_1_0:show()
      end
    b:animate(one_frame_hide)
  end
  local o = l_170_0._tcst:panel():children()[1]
  local animate_fade = function(l_2_0)
    local black = l_2_0:child("black")
    over(0.5, function(l_1_0)
      black:set_alpha(1 - l_1_0)
      end)
   end
  o:stop()
  o:animate(animate_fade)
end

MenuComponentManager.create_test_gui = function(l_171_0)
  if alive(Global.test_gui) then
    Overlay:gui():destroy_workspace(Global.test_gui)
    Global.test_gui = nil
  end
  Global.test_gui = managers.gui_data:create_fullscreen_16_9_workspace(managers.gui_data)
  local panel = Global.test_gui:panel()
  local bg = panel:rect({layer = 1000, color = Color.black})
  local a = panel:bitmap({texture = "guis/textures/pd2/lootscreen/loot_cards", layer = 1001, texture_rect = {0, 0, 128, 180}})
  local b = panel:bitmap({texture = "guis/textures/pd2/lootscreen/loot_cards", layer = 1001, texture_rect = {0, 0, 128, 180}})
  local c = panel:bitmap({texture = "guis/textures/pd2/lootscreen/loot_cards2", layer = 1001, texture_rect = {0, 0, 64, 90}})
  local d = panel:bitmap({texture = "guis/textures/pd2/lootscreen/loot_cards2", layer = 1001, texture_rect = {0, 0, 64, 90}})
  b:set_top(a:bottom() + 10)
  b:set_size(64, 90)
  c:set_left(a:right() + 10)
  c:set_top(a:top())
  d:set_left(c:left())
  d:set_top(b:top())
  d:set_size(64, 90)
end

MenuComponentManager.destroy_test_gui = function(l_172_0)
  if alive(Global.test_gui) then
    Overlay:gui():destroy_workspace(Global.test_gui)
    Global.test_gui = nil
  end
end


