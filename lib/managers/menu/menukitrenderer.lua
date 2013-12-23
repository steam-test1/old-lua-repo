-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\menukitrenderer.luac 

core:import("CoreMenuNodeGui")
require("lib/managers/menu/MenuNodeKitGui")
if not MenuKitRenderer then
  MenuKitRenderer = class(MenuLobbyRenderer)
end
MenuKitRenderer.init = function(l_1_0, l_1_1)
  local parameters = {layer = 0}
  MenuRenderer.init(l_1_0, l_1_1, parameters)
end

MenuKitRenderer._setup_bg = function(l_2_0)
end

MenuKitRenderer.show_node = function(l_3_0, l_3_1)
  local parameters = {font = tweak_data.menu.pd2_medium_font, row_item_color = tweak_data.menu.default_font_row_item_color, row_item_hightlight_color = tweak_data.menu.default_hightlight_row_item_color, node_gui_class = MenuNodeKitGui, font_size = tweak_data.menu.pd2_medium_font_size, spacing = l_3_1:parameters().spacing}
  MenuKitRenderer.super.super.show_node(l_3_0, l_3_1, parameters)
end

MenuKitRenderer.open = function(l_4_0, ...)
  l_4_0._all_items_enabled = true
  l_4_0._no_stencil = true
  l_4_0._server_state_string_id = "menu_lobby_server_state_in_game"
  MenuKitRenderer.super.open(l_4_0, ...)
  if l_4_0._player_slots then
    for _,slot in ipairs(l_4_0._player_slots) do
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

MenuKitRenderer._entered_menu = function(l_5_0)
  l_5_0:on_request_lobby_slot_reply()
  local kit_menu = managers.menu:get_menu("kit_menu")
  if kit_menu then
    local id = managers.network:session():local_peer():id()
    local criminal_name = managers.network:session():local_peer():character()
    kit_menu.renderer:set_slot_outfit(id, criminal_name, managers.blackmarket:outfit_string())
  end
  for peer_id,peer in pairs(managers.network:session():peers()) do
    l_5_0:set_slot_joining(peer, peer_id)
  end
end

MenuKitRenderer._set_player_slot = function(l_6_0, l_6_1, l_6_2)
  local peer = managers.network:session():peer(l_6_1)
  local ready = peer:waiting_for_player_ready()
  l_6_2.status = string.upper(managers.localization:text(ready and "menu_waiting_is_ready" or "menu_waiting_is_not_ready"))
  l_6_2.kit_panel_visible = true
  MenuKitRenderer.super._set_player_slot(l_6_0, l_6_1, l_6_2)
end

MenuKitRenderer.sync_chat_message = function(l_7_0, l_7_1, l_7_2)
  for _,node_gui in ipairs(l_7_0._node_gui_stack) do
    local row_item_chat = node_gui:row_item_by_name("chat")
    if row_item_chat then
      node_gui:sync_say(l_7_1, row_item_chat, l_7_2)
      return true
    end
  end
  return false
end

MenuKitRenderer.set_all_items_enabled = function(l_8_0, l_8_1)
  l_8_0._all_items_enabled = l_8_1
  for _,node in ipairs(l_8_0._logic._node_stack) do
    for _,item in ipairs(node:items()) do
      if item:type() == "kitslot" or item:type() == "toggle" then
        item:set_enabled(l_8_1)
      end
    end
  end
end

MenuKitRenderer.set_ready_items_enabled = function(l_9_0, l_9_1)
  if not l_9_0._all_items_enabled then
    return 
  end
  for _,node in ipairs(l_9_0._logic._node_stack) do
    for _,item in ipairs(node:items()) do
      if item:type() == "kitslot" then
        item:set_enabled(l_9_1)
      end
    end
  end
end

MenuKitRenderer.set_bg_visible = function(l_10_0, l_10_1)
  if l_10_0._menu_bg then
    l_10_0._menu_bg:set_visible(l_10_1)
  end
end

MenuKitRenderer.set_bg_area = function(l_11_0, l_11_1)
  if l_11_0._menu_bg then
    if l_11_1 == "full" then
      l_11_0._menu_bg:set_size(l_11_0._menu_bg:parent():size())
      l_11_0._menu_bg:set_position(0, 0)
    elseif l_11_1 == "half" then
      l_11_0._menu_bg:set_size(l_11_0._menu_bg:parent():w() * 0.5, l_11_0._menu_bg:parent():h())
      l_11_0._menu_bg:set_top(0)
      l_11_0._menu_bg:set_right(l_11_0._menu_bg:parent():w())
    else
      l_11_0._menu_bg:set_size(l_11_0._menu_bg:parent():size())
      l_11_0._menu_bg:set_position(0, 0)
    end
  end
end

MenuKitRenderer.close = function(l_12_0, ...)
  MenuKitRenderer.super.close(l_12_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end


