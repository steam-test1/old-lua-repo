-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\serverstatusboxgui.luac 

if not ServerStatusBoxGui then
  ServerStatusBoxGui = class(TextBoxGui)
end
ServerStatusBoxGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  if not l_1_5 then
    l_1_5 = {}
  end
  l_1_5.h = l_1_5.h or 130
  l_1_5.w = l_1_5.w or 280
  local x, y = l_1_1:size()
  l_1_5.x = l_1_5.x or 0
  l_1_5.y = l_1_5.y or 1
  l_1_5.no_close_legend = true
  l_1_5.no_scroll_legend = true
  l_1_5.use_minimize_legend = true
  l_1_2 = "Server Info"
  ServerStatusBoxGui.super.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  l_1_0:set_layer(10)
end

ServerStatusBoxGui.update = function(l_2_0, l_2_1, l_2_2)
end

ServerStatusBoxGui._make_nice_text = function(l_3_0, l_3_1)
  local _, _, w, h = l_3_1:text_rect()
  l_3_1:set_size(w, h)
end

ServerStatusBoxGui._create_text_box = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4, l_4_5)
  ServerStatusBoxGui.super._create_text_box(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4, l_4_5)
  local is_server = Network:is_server()
  local server_peer = (managers.network:session() and (not is_server or not managers.network:session():local_peer()) and managers.network:session():server_peer()) or nil
  local server_name = server_peer and server_peer:name() or ""
  local server_panel = l_4_0._scroll_panel:panel({name = "server_panel", x = 0, h = 60, w = l_4_0._scroll_panel:w(), layer = 1})
  local font_size = tweak_data.menu.lobby_info_font_size
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local server_title = server_panel:text({visible = nil, name = "server_title", text = string.upper(managers.localization:text("menu_lobby_server_title")), font = tweak_data.menu.default_font})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local server_text = server_panel:text({visible = nil, name = "server_text", text = string.upper("" .. server_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color, font_size = font_size})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local server_state_title = server_panel:text({visible = nil, name = "server_state_title", text = string.upper(managers.localization:text("menu_lobby_server_state_title")), font = tweak_data.menu.default_font})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local server_state_text = server_panel:text({visible = nil, name = "server_state_text", text = string.upper(managers.localization:text(l_4_0._server_state_string_id or "menu_lobby_server_state_in_lobby")), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color, font_size = font_size})
  l_4_0:_make_nice_text(server_title)
  {visible = nil, name = "server_state_text", text = string.upper(managers.localization:text(l_4_0._server_state_string_id or "menu_lobby_server_state_in_lobby")), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color, font_size = font_size}.layer, {visible = nil, name = "server_state_text", text = string.upper(managers.localization:text(l_4_0._server_state_string_id or "menu_lobby_server_state_in_lobby")), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color, font_size = font_size}.h, {visible = nil, name = "server_state_text", text = string.upper(managers.localization:text(l_4_0._server_state_string_id or "menu_lobby_server_state_in_lobby")), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color, font_size = font_size}.w, {visible = nil, name = "server_state_text", text = string.upper(managers.localization:text(l_4_0._server_state_string_id or "menu_lobby_server_state_in_lobby")), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color, font_size = font_size}.vertical, {visible = nil, name = "server_state_text", text = string.upper(managers.localization:text(l_4_0._server_state_string_id or "menu_lobby_server_state_in_lobby")), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color, font_size = font_size}.align, {visible = nil, name = "server_state_title", text = string.upper(managers.localization:text("menu_lobby_server_state_title")), font = tweak_data.menu.default_font}.layer, {visible = nil, name = "server_state_title", text = string.upper(managers.localization:text("menu_lobby_server_state_title")), font = tweak_data.menu.default_font}.h, {visible = nil, name = "server_state_title", text = string.upper(managers.localization:text("menu_lobby_server_state_title")), font = tweak_data.menu.default_font}.w, {visible = nil, name = "server_state_title", text = string.upper(managers.localization:text("menu_lobby_server_state_title")), font = tweak_data.menu.default_font}.vertical, {visible = nil, name = "server_state_title", text = string.upper(managers.localization:text("menu_lobby_server_state_title")), font = tweak_data.menu.default_font}.align, {visible = nil, name = "server_state_title", text = string.upper(managers.localization:text("menu_lobby_server_state_title")), font = tweak_data.menu.default_font}.font_size, {visible = nil, name = "server_text", text = string.upper("" .. server_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color, font_size = font_size}.layer, {visible = nil, name = "server_text", text = string.upper("" .. server_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color, font_size = font_size}.h, {visible = nil, name = "server_text", text = string.upper("" .. server_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color, font_size = font_size}.w, {visible = nil, name = "server_text", text = string.upper("" .. server_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color, font_size = font_size}.vertical, {visible = nil, name = "server_text", text = string.upper("" .. server_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color, font_size = font_size}.align, {visible = nil, name = "server_title", text = string.upper(managers.localization:text("menu_lobby_server_title")), font = tweak_data.menu.default_font}.layer, {visible = nil, name = "server_title", text = string.upper(managers.localization:text("menu_lobby_server_title")), font = tweak_data.menu.default_font}.h, {visible = nil, name = "server_title", text = string.upper(managers.localization:text("menu_lobby_server_title")), font = tweak_data.menu.default_font}.w, {visible = nil, name = "server_title", text = string.upper(managers.localization:text("menu_lobby_server_title")), font = tweak_data.menu.default_font}.vertical, {visible = nil, name = "server_title", text = string.upper(managers.localization:text("menu_lobby_server_title")), font = tweak_data.menu.default_font}.align, {visible = nil, name = "server_title", text = string.upper(managers.localization:text("menu_lobby_server_title")), font = tweak_data.menu.default_font}.font_size = 1, font_size, 256, "center", "left", 1, font_size, 256, "center", "left", font_size, 1, font_size, 256, "center", "left", 1, font_size, 256, "center", "left", font_size
  l_4_0:_make_nice_text(server_text)
  server_text:set_right(server_panel:w())
  l_4_0:_make_nice_text(server_state_title)
  l_4_0:_make_nice_text(server_state_text)
  server_state_title:set_y(24)
  server_state_text:set_righttop(server_panel:w(), 24)
  server_panel:set_h(server_state_title:bottom())
  l_4_0._scroll_panel:set_h(math.max(l_4_0._scroll_panel:h(), server_panel:h()))
  l_4_0:_set_scroll_indicator()
end

ServerStatusBoxGui.mouse_pressed = function(l_5_0, l_5_1, l_5_2, l_5_3)
  if not l_5_0:can_take_input() then
    return 
  end
  if l_5_1 ~= Idstring("0") or l_5_0._panel:child("info_area"):inside(l_5_2, l_5_3) then
     -- Warning: missing end command somewhere! Added here
  end
end

ServerStatusBoxGui.mouse_moved = function(l_6_0, l_6_1, l_6_2)
  if not l_6_0:can_take_input() then
    return 
  end
  local pointer = nil
  return false, pointer
end

ServerStatusBoxGui._check_scroll_indicator_states = function(l_7_0)
  ServerStatusBoxGui.super._check_scroll_indicator_states(l_7_0)
end

ServerStatusBoxGui.set_size = function(l_8_0, l_8_1, l_8_2)
  ServerStatusBoxGui.super.set_size(l_8_0, l_8_1, l_8_2)
end

ServerStatusBoxGui.set_server_info_state = function(l_9_0, l_9_1)
  print("ServerStatusBoxGui:set_server_info_state", l_9_1)
  local s = ""
  if l_9_1 == "loading" then
    s = string.upper(managers.localization:text("menu_lobby_server_state_loading"))
  end
  l_9_0._scroll_panel:child("server_panel"):child("server_state_text"):set_text(string.upper(s))
end


