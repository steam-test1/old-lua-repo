-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\menulobbyrenderer.luac 

core:import("CoreMenuRenderer")
require("lib/managers/menu/MenuNodeGui")
require("lib/managers/menu/renderers/MenuNodeTableGui")
require("lib/managers/menu/renderers/MenuNodeStatsGui")
if not MenuLobbyRenderer then
  MenuLobbyRenderer = class(CoreMenuRenderer.Renderer)
end
MenuLobbyRenderer.init = function(l_1_0, l_1_1, ...)
  MenuLobbyRenderer.super.init(l_1_0, l_1_1, ...)
  l_1_0._sound_source = SoundDevice:create_source("MenuLobbyRenderer")
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.show_node = function(l_2_0, l_2_1)
  local gui_class = MenuNodeGui
  if l_2_1:parameters().gui_class then
    gui_class = CoreSerialize.string_to_classtable(l_2_1:parameters().gui_class)
  end
  local parameters = {font = tweak_data.menu.pd2_medium_font, background_color = tweak_data.menu.main_menu_background_color:with_alpha(0), row_item_color = tweak_data.menu.default_font_row_item_color, row_item_hightlight_color = tweak_data.menu.default_hightlight_row_item_color, font_size = tweak_data.menu.pd2_medium_font_size, node_gui_class = gui_class, spacing = l_2_1:parameters().spacing}
  MenuLobbyRenderer.super.show_node(l_2_0, l_2_1, parameters)
end

local mugshots = {random = "mugshot_random", undecided = "mugshot_unassigned", american = 1, german = 2, russian = 3, spanish = 4}
local mugshot_stencil = {random = {"bg_lobby_fullteam", 65}, undecided = {"bg_lobby_fullteam", 65}, american = {"bg_hoxton", 80}, german = {"bg_wolf", 55}, russian = {"bg_dallas", 65}, spanish = {"bg_chains", 60}}
MenuLobbyRenderer.open = function(l_3_0, ...)
  MenuLobbyRenderer.super.open(l_3_0, ...)
  local safe_rect_pixels = managers.gui_data:scaled_size()
  local scaled_size = safe_rect_pixels
  MenuRenderer._create_framing(l_3_0)
  l_3_0._main_panel:hide()
  l_3_0._player_slots = {}
  l_3_0._menu_bg = l_3_0._fullscreen_panel:panel({})
  local is_server = Network:is_server()
  if not is_server or not managers.network:session():local_peer() then
    local server_peer = managers.network:session():server_peer()
  end
  local is_single_player = Global.game_settings.single_player
  do
    local is_multiplayer = not is_single_player
    if not server_peer then
      return 
    end
    for i = 1, is_single_player and 1 or 4 do
      local t = {}
      t.player = {}
      t.free = true
      t.kit_slots = {}
      t.params = {}
      for slot = 1, PlayerManager.WEAPON_SLOTS + 3 do
        table.insert(t.kit_slots, slot)
      end
      table.insert(l_3_0._player_slots, t)
    end
    if is_server then
      local level = managers.experience:current_level()
      l_3_0:_set_player_slot(1, {name = server_peer:name(), peer_id = server_peer:id(), level = level, character = "random"})
    end
    l_3_0:_entered_menu()
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.set_bottom_text = function(l_4_0, ...)
  MenuRenderer.set_bottom_text(l_4_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer._entered_menu = function(l_5_0)
  local is_server = Network:is_server()
  local local_peer = managers.network:session():local_peer()
  managers.network:game():on_entered_lobby()
  l_5_0:on_request_lobby_slot_reply()
end

MenuLobbyRenderer.close = function(l_6_0, ...)
  l_6_0:set_choose_character_enabled(true)
  MenuLobbyRenderer.super.close(l_6_0, ...)
  if managers.menu_scene then
    managers.menu_scene:hide_all_lobby_characters()
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

MenuLobbyRenderer.update_level_id = function(l_7_0, l_7_1)
  if l_7_1 or l_7_0._level_id == Global.game_settings.level_id then
    return 
  end
  if not l_7_1 then
    l_7_1 = Global.game_settings.level_id
  end
  local level_id_index = tweak_data.levels:get_index_from_level_id(l_7_1)
  managers.network:session():send_to_peers("lobby_sync_update_level_id", level_id_index)
  l_7_0:_update_level_id(l_7_1)
end

MenuLobbyRenderer.sync_update_level_id = function(l_8_0, l_8_1)
  if l_8_0._level_id == l_8_1 then
    return 
  end
  Global.game_settings.level_id = l_8_1
  l_8_0:_update_level_id(l_8_1)
end

MenuLobbyRenderer._update_level_id = function(l_9_0, l_9_1)
  l_9_0._level_id = l_9_1
  Application:debug("_update_level_id", l_9_1)
end

MenuLobbyRenderer.update_difficulty = function(l_10_0)
  local difficulty = Global.game_settings.difficulty
  managers.network:session():send_to_peers_loaded("lobby_sync_update_difficulty", difficulty)
  l_10_0:_update_difficulty(difficulty)
end

MenuLobbyRenderer.sync_update_difficulty = function(l_11_0, l_11_1)
  Global.game_settings.difficulty = l_11_1
  l_11_0:_update_difficulty(l_11_1)
end

MenuLobbyRenderer._update_difficulty = function(l_12_0, l_12_1)
  Application:debug("_update_difficulty", l_12_1)
end

MenuLobbyRenderer.set_slot_joining = function(l_13_0, l_13_1, l_13_2)
  managers.hud:set_slot_joining(l_13_1, l_13_2)
  local slot = l_13_0._player_slots[l_13_2]
  slot.peer_id = l_13_2
end

MenuLobbyRenderer.set_slot_ready = function(l_14_0, l_14_1, l_14_2)
  managers.hud:set_slot_ready(l_14_1, l_14_2)
end

MenuLobbyRenderer.set_dropin_progress = function(l_15_0, l_15_1, l_15_2)
  managers.hud:set_dropin_progress(l_15_1, l_15_2)
end

MenuLobbyRenderer.set_slot_not_ready = function(l_16_0, l_16_1, l_16_2)
  managers.hud:set_slot_not_ready(l_16_1, l_16_2)
end

MenuLobbyRenderer.set_player_slots_kit = function(l_17_0, l_17_1)
  local peer_id = l_17_0._player_slots[l_17_1].peer_id
  Application:debug("set_player_slots_kit", l_17_1)
end

MenuLobbyRenderer.set_slot_outfit = function(l_18_0, l_18_1, l_18_2, l_18_3)
  if l_18_0._player_slots then
    local outfit = managers.blackmarket:unpack_outfit_from_string(l_18_3)
    l_18_0._player_slots[l_18_1].outfit = outfit
    managers.menu_component:set_slot_outfit_mission_briefing_gui(l_18_1, l_18_2, outfit)
  end
end

MenuLobbyRenderer.set_kit_selection = function(l_19_0, l_19_1, l_19_2, l_19_3, l_19_4)
  managers.hud:set_kit_selection(l_19_1, l_19_2, l_19_3, l_19_4)
  Application:debug("set_kit_selection", l_19_1, l_19_2, l_19_3, l_19_4)
end

MenuLobbyRenderer.set_slot_voice = function(l_20_0, l_20_1, l_20_2, l_20_3)
  managers.hud:set_slot_voice(l_20_1, l_20_2, l_20_3)
  return 
end

MenuLobbyRenderer._set_player_slot = function(l_21_0, l_21_1, l_21_2)
  local slot = l_21_0._player_slots[l_21_1]
  slot.free = false
  slot.peer_id = l_21_2.peer_id
  slot.params = l_21_2
  managers.hud:set_player_slot(l_21_1, l_21_2)
end

MenuLobbyRenderer.remove_player_slot_by_peer_id = function(l_22_0, l_22_1, l_22_2)
  if not l_22_0._player_slots then
    return 
  end
  local peer_id = l_22_1:id()
  for _,slot in ipairs(l_22_0._player_slots) do
    if slot.peer_id == peer_id then
      slot.peer_id = nil
      slot.params = nil
      slot.outfit = nil
      slot.free = true
      slot.join_msg_shown = nil
      managers.hud:remove_player_slot_by_peer_id(l_22_1, l_22_2)
      managers.menu_component:set_slot_outfit_mission_briefing_gui(peer_id)
  else
    end
  end
end

MenuLobbyRenderer.set_character = function(l_23_0, l_23_1, l_23_2)
  Application:debug("set_character", l_23_1, l_23_2)
end

MenuLobbyRenderer.set_choose_character_enabled = function(l_24_0, l_24_1)
  for _,node in ipairs(l_24_0._logic._node_stack) do
    for _,item in ipairs(node:items()) do
      if item:parameters().name == "choose_character" then
        item:set_enabled(l_24_1)
        for (for control),_ in (for generator) do
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

MenuLobbyRenderer.set_server_state = function(l_25_0, l_25_1)
  local s = ""
  if l_25_1 == "loading" then
    s = string.upper(managers.localization:text("menu_lobby_server_state_loading"))
    l_25_0:set_choose_character_enabled(false)
  end
  local msg = managers.localization:text("menu_lobby_messenger_title") .. managers.localization:text("menu_lobby_message_server_is_loading")
  l_25_0:sync_chat_message(msg, 1)
end

MenuLobbyRenderer.on_request_lobby_slot_reply = function(l_26_0)
  local local_peer = managers.network:session():local_peer()
  local local_peer_id = local_peer:id()
  local level = managers.experience:current_level()
  local character = local_peer:character()
  local progress = managers.upgrades:progress()
  local mask_set = "remove"
  local_peer:set_outfit_string(managers.blackmarket:outfit_string())
  l_26_0:_set_player_slot(local_peer_id, {name = local_peer:name(), peer_id = local_peer_id, level = level, character = character, progress = progress})
  managers.network:session():send_to_peers_loaded("lobby_info", local_peer_id, level, character, mask_set, progress[1], progress[2], progress[3], progress[4] or -1)
  managers.network:session():send_to_peers_loaded("sync_profile", level)
  managers.network:session():send_to_peers_loaded("sync_outfit", managers.blackmarket:outfit_string())
end

MenuLobbyRenderer.get_player_slot_by_peer_id = function(l_27_0, l_27_1)
  for _,slot in ipairs(l_27_0._player_slots) do
    if slot.peer_id and slot.peer_id == l_27_1 then
      return slot
    end
  end
  return l_27_0._player_slots[l_27_1]
end

MenuLobbyRenderer.get_player_slot_nr_by_peer_id = function(l_28_0, l_28_1)
  for i,slot in ipairs(l_28_0._player_slots) do
    if slot.peer_id and slot.peer_id == l_28_1 then
      return i
    end
  end
  return nil
end

MenuLobbyRenderer.sync_chat_message = function(l_29_0, l_29_1, l_29_2)
  Application:debug("sync_chat_message", l_29_1, l_29_2)
  for _,node_gui in ipairs(l_29_0._node_gui_stack) do
    local row_item_chat = node_gui:row_item_by_name("chat")
    if row_item_chat then
      node_gui:sync_say(l_29_1, row_item_chat, l_29_2)
      return true
    end
  end
  return false
end

MenuLobbyRenderer.update = function(l_30_0, l_30_1, l_30_2)
  MenuLobbyRenderer.super.update(l_30_0, l_30_1, l_30_2)
end

MenuLobbyRenderer.highlight_item = function(l_31_0, l_31_1, ...)
  MenuLobbyRenderer.super.highlight_item(l_31_0, l_31_1, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.trigger_item = function(l_32_0, l_32_1)
  MenuRenderer.super.trigger_item(l_32_0, l_32_1)
  Application:debug("trigger_item", l_32_1)
  if l_32_1 and l_32_1:parameters().sound ~= "false" then
    local item_type = l_32_1:type()
    if item_type == "" then
      l_32_0:post_event("menu_enter")
    elseif item_type == "toggle" then
      if l_32_1:value() == "on" then
        l_32_0:post_event("box_tick")
      else
        l_32_0:post_event("box_untick")
      end
    do
      elseif item_type == "slider" then
        local percentage = l_32_1:percentage()
  end
  if percentage <= 0 or percentage >= 100 or item_type == "multi_choice" then
    end
  end
end

MenuLobbyRenderer.post_event = function(l_33_0, l_33_1)
  l_33_0._sound_source:post_event(l_33_1)
end

MenuLobbyRenderer.navigate_back = function(l_34_0)
  MenuLobbyRenderer.super.navigate_back(l_34_0)
  l_34_0:post_event("menu_exit")
end

MenuLobbyRenderer.resolution_changed = function(l_35_0, ...)
  MenuLobbyRenderer.super.resolution_changed(l_35_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer._layout_menu_bg = function(l_36_0)
  local res = RenderSettings.resolution
  local safe_rect_pixels = managers.gui_data:scaled_size()
  l_36_0._menu_bg:set_size(l_36_0._fullscreen_panel:h() * 2, l_36_0._fullscreen_panel:h())
  l_36_0._menu_bg:set_position(0, 0)
  l_36_0:set_stencil_align(l_36_0._menu_stencil_align, l_36_0._menu_stencil_align_percent)
end

MenuLobbyRenderer._layout_slot_progress_panel = function(l_37_0, l_37_1, l_37_2)
  print("MenuLobbyRenderer:_layout_slot_progress_panel()", l_37_1, l_37_2)
  local h = 16
  local sh = 4
  if l_37_2[4] then
    h = 17
    sh = 3
  end
  l_37_1.p_panel:set_size(38 * tweak_data.scale.lobby_info_offset_multiplier, h)
  l_37_1.p_bg:set_size(l_37_1.p_panel:size())
  l_37_1.p_ass_bg:set_size(l_37_1.p_panel:w() - 2, sh)
  l_37_1.p_sha_bg:set_size(l_37_1.p_panel:w() - 2, sh)
  l_37_1.p_sup_bg:set_size(l_37_1.p_panel:w() - 2, sh)
  l_37_1.p_tec_bg:set_size(l_37_1.p_panel:w() - 2, sh)
  if l_37_2[4] then
    l_37_1.p_tec:set_visible(true)
    l_37_1.p_tec_bg:set_visible(true)
    l_37_1.p_ass_bg:set_position(1, 1)
    l_37_1.p_sha_bg:set_position(1, 5)
    l_37_1.p_sup_bg:set_position(1, 9)
    l_37_1.p_tec_bg:set_position(1, 13)
  else
    l_37_1.p_tec:set_visible(false)
    l_37_1.p_tec_bg:set_visible(false)
    l_37_1.p_ass_bg:set_position(1, 1)
    l_37_1.p_sha_bg:set_position(1, 6)
    l_37_1.p_sup_bg:set_position(1, 11)
  end
  l_37_1.p_ass:set_shape(l_37_1.p_ass_bg:shape())
  l_37_1.p_sha:set_shape(l_37_1.p_sha_bg:shape())
  l_37_1.p_sup:set_shape(l_37_1.p_sup_bg:shape())
  l_37_1.p_tec:set_shape(l_37_1.p_tec_bg:shape())
  if not l_37_1.params or not l_37_1.p_ass_bg:w() * (l_37_2[1] / 49) then
    l_37_1.p_ass:set_w(l_37_1.p_ass:w())
  end
  if not l_37_1.params or not l_37_1.p_sha_bg:w() * (l_37_2[2] / 49) then
    l_37_1.p_sha:set_w(l_37_1.p_sha:w())
  end
  if not l_37_1.params or not l_37_1.p_sup_bg:w() * (l_37_2[3] / 49) then
    l_37_1.p_sup:set_w(l_37_1.p_sup:w())
  end
  if not l_37_1.p_sup_bg:w() * ((not l_37_1.params or 0) / 49) and not l_37_1.p_sup_bg:w() * ((not l_37_1.params or 0) / 49) then
    l_37_1.p_tec:set_w(l_37_1.p_tec:w())
  end
end

MenuLobbyRenderer._layout_info_panel = function(l_38_0)
  local res = RenderSettings.resolution
  local safe_rect = managers.gui_data:scaled_size()
  local is_single_player = Global.game_settings.single_player
  local is_multiplayer = not is_single_player
  l_38_0._gui_info_panel:set_shape(l_38_0._info_bg_rect:x() + tweak_data.menu.info_padding, l_38_0._info_bg_rect:y() + tweak_data.menu.info_padding, l_38_0._info_bg_rect:w() - tweak_data.menu.info_padding * 2, l_38_0._info_bg_rect:h() - tweak_data.menu.info_padding * 2)
  local font_size = tweak_data.menu.lobby_info_font_size
  local offset = 22 * tweak_data.scale.lobby_info_offset_multiplier
  l_38_0._server_title:set_font_size(font_size)
  l_38_0._server_text:set_font_size(font_size)
  local x, y, w, h = l_38_0._server_title:text_rect()
  l_38_0._server_title:set_x(tweak_data.menu.info_padding)
  l_38_0._server_title:set_y(tweak_data.menu.info_padding)
  l_38_0._server_title:set_w(w)
  l_38_0._server_text:set_lefttop(l_38_0._server_title:righttop())
  l_38_0._server_text:set_w(l_38_0._gui_info_panel:w())
  l_38_0._server_info_title:set_font_size(font_size)
  l_38_0._server_info_text:set_font_size(font_size)
  local x, y, w, h = l_38_0._server_info_title:text_rect()
  l_38_0._server_info_title:set_x(tweak_data.menu.info_padding)
  l_38_0._server_info_title:set_y(tweak_data.menu.info_padding + offset)
  l_38_0._server_info_title:set_w(w)
  l_38_0._server_info_text:set_lefttop(l_38_0._server_info_title:righttop())
  l_38_0._server_info_text:set_w(l_38_0._gui_info_panel:w())
  l_38_0._level_title:set_font_size(font_size)
  l_38_0._level_text:set_font_size(font_size)
  local x, y, w, h = l_38_0._level_title:text_rect()
  l_38_0._level_title:set_x(tweak_data.menu.info_padding)
  if not is_multiplayer or not tweak_data.menu.info_padding + offset * 2 then
    l_38_0._level_title:set_y(tweak_data.menu.info_padding)
  end
  l_38_0._level_title:set_w(w)
  l_38_0._level_text:set_lefttop(l_38_0._level_title:righttop())
  l_38_0._level_text:set_w(l_38_0._gui_info_panel:w())
  l_38_0._difficulty_title:set_font_size(font_size)
  l_38_0._difficulty_text:set_font_size(font_size)
  local x, y, w, h = l_38_0._difficulty_title:text_rect()
  l_38_0._difficulty_title:set_x(tweak_data.menu.info_padding)
  l_38_0._difficulty_title:set_y(tweak_data.menu.info_padding + offset * (is_multiplayer and 3 or 1))
  l_38_0._difficulty_title:set_w(w)
  l_38_0._difficulty_text:set_lefttop(l_38_0._difficulty_title:righttop())
  l_38_0._difficulty_text:set_w(l_38_0._gui_info_panel:w())
  return 
end

MenuLobbyRenderer._layout_video = function(l_39_0)
  if l_39_0._level_video then
    local w = l_39_0._gui_info_panel:w()
    local m = l_39_0._level_video:video_width() / l_39_0._level_video:video_height()
    l_39_0._level_video:set_size(w, w / m)
    l_39_0._level_video:set_y(0)
    l_39_0._level_video:set_center_x(l_39_0._gui_info_panel:w() / 2)
  end
end

MenuLobbyRenderer.set_bg_visible = function(l_40_0, l_40_1)
  l_40_0._menu_bg:set_visible(l_40_1)
end

MenuLobbyRenderer.set_bg_area = function(l_41_0, l_41_1)
  if l_41_0._menu_bg then
    if l_41_1 == "full" then
      l_41_0._menu_bg:set_size(l_41_0._menu_bg:parent():size())
      l_41_0._menu_bg:set_position(0, 0)
    elseif l_41_1 == "half" then
      l_41_0._menu_bg:set_size(l_41_0._menu_bg:parent():w() * 0.5, l_41_0._menu_bg:parent():h())
      l_41_0._menu_bg:set_top(0)
      l_41_0._menu_bg:set_right(l_41_0._menu_bg:parent():w())
    else
      l_41_0._menu_bg:set_size(l_41_0._menu_bg:parent():size())
      l_41_0._menu_bg:set_position(0, 0)
    end
  end
end

MenuLobbyRenderer.set_stencil_image = function(l_42_0, l_42_1)
  MenuRenderer.set_stencil_image(l_42_0, l_42_1)
end

MenuLobbyRenderer.refresh_theme = function(l_43_0)
  MenuRenderer.refresh_theme(l_43_0)
end

MenuLobbyRenderer.set_stencil_align = function(l_44_0, l_44_1, l_44_2)
  if not l_44_0._menu_stencil then
    return 
  end
  local d = l_44_0._menu_stencil:texture_height()
  if d == 0 then
    return 
  end
  l_44_0._menu_stencil_align = l_44_1
  l_44_0._menu_stencil_align_percent = l_44_2
  local res = RenderSettings.resolution
  local safe_rect_pixels = managers.gui_data:scaled_size()
  local y = safe_rect_pixels.height - tweak_data.load_level.upper_saferect_border * 2 + 2
  local m = l_44_0._menu_stencil:texture_width() / l_44_0._menu_stencil:texture_height()
  l_44_0._menu_stencil:set_size(y * m, y)
  l_44_0._menu_stencil:set_center_y(res.y / 2)
  local w = l_44_0._menu_stencil:texture_width()
  local h = l_44_0._menu_stencil:texture_height()
  if l_44_1 == "right" then
    l_44_0._menu_stencil:set_texture_rect(0, 0, w, h)
    l_44_0._menu_stencil:set_right(res.x)
  elseif l_44_1 == "left" then
    l_44_0._menu_stencil:set_texture_rect(0, 0, w, h)
    l_44_0._menu_stencil:set_left(0)
  elseif l_44_1 == "center" then
    l_44_0._menu_stencil:set_texture_rect(0, 0, w, h)
    l_44_0._menu_stencil:set_center_x(res.x / 2)
  elseif l_44_1 == "center-right" then
    l_44_0._menu_stencil:set_texture_rect(0, 0, w, h)
    l_44_0._menu_stencil:set_center_x(res.x * 0.66000002622604)
  elseif l_44_1 == "center-left" then
    l_44_0._menu_stencil:set_texture_rect(0, 0, w, h)
    l_44_0._menu_stencil:set_center_x(res.x * 0.33000001311302)
  elseif l_44_1 == "manual" then
    l_44_0._menu_stencil:set_texture_rect(0, 0, w, h)
    l_44_2 = l_44_2 / 100
    l_44_0._menu_stencil:set_left(res.x * (l_44_2) - y * m * (l_44_2))
  end
end

MenuLobbyRenderer.current_menu_text = function(l_45_0, l_45_1)
  local ids = {}
  for i,node_gui in ipairs(l_45_0._node_gui_stack) do
    table.insert(ids, node_gui.node:parameters().topic_id)
  end
  table.insert(ids, l_45_1)
  local s = ""
  for i,id in ipairs(ids) do
    s = s .. managers.localization:text(id)
    s = s .. (i < #ids and " > " or "")
  end
  return s
end

MenuLobbyRenderer.scroll_up = function(l_46_0, ...)
  MenuRenderer.scroll_up(l_46_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.scroll_down = function(l_47_0, ...)
  MenuRenderer.scroll_down(l_47_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.accept_input = function(l_48_0, ...)
  MenuRenderer.accept_input(l_48_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.mouse_pressed = function(l_49_0, ...)
  return MenuRenderer.mouse_pressed(l_49_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.mouse_released = function(l_50_0, ...)
  return MenuRenderer.mouse_released(l_50_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.mouse_moved = function(l_51_0, ...)
  return MenuRenderer.mouse_moved(l_51_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.input_focus = function(l_52_0, ...)
  return MenuRenderer.input_focus(l_52_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.move_up = function(l_53_0, ...)
  return MenuRenderer.move_up(l_53_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.move_down = function(l_54_0, ...)
  return MenuRenderer.move_down(l_54_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.move_left = function(l_55_0, ...)
  return MenuRenderer.move_left(l_55_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.move_right = function(l_56_0, ...)
  return MenuRenderer.move_right(l_56_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.next_page = function(l_57_0, ...)
  return MenuRenderer.next_page(l_57_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.previous_page = function(l_58_0, ...)
  return MenuRenderer.previous_page(l_58_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.confirm_pressed = function(l_59_0, ...)
  return MenuRenderer.confirm_pressed(l_59_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.special_btn_pressed = function(l_60_0, ...)
  return managers.menu_component:special_btn_pressed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.back_pressed = function(l_61_0, ...)
  return MenuRenderer.back_pressed(l_61_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.mouse_clicked = function(l_62_0, ...)
  return MenuRenderer.mouse_clicked(l_62_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuLobbyRenderer.mouse_double_click = function(l_63_0, ...)
  return MenuRenderer.mouse_double_click(l_63_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end


