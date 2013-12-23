-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudlootscreen.luac 

require("lib/managers/menu/MenuBackdropGUI")
if not HUDLootScreen then
  HUDLootScreen = class()
end
HUDLootScreen.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  l_1_0._backdrop = MenuBackdropGUI:new(l_1_2)
  l_1_0._backdrop:create_black_borders()
  l_1_0._active = false
  l_1_0._hud = l_1_1
  l_1_0._workspace = l_1_2
  local massive_font = tweak_data.menu.pd2_massive_font
  local large_font = tweak_data.menu.pd2_large_font
  local medium_font = tweak_data.menu.pd2_medium_font
  local small_font = tweak_data.menu.pd2_small_font
  local massive_font_size = tweak_data.menu.pd2_massive_font_size
  local large_font_size = tweak_data.menu.pd2_large_font_size
  local medium_font_size = tweak_data.menu.pd2_medium_font_size
  local small_font_size = tweak_data.menu.pd2_small_font_size
  l_1_0._background_layer_safe = l_1_0._backdrop:get_new_background_layer()
  l_1_0._background_layer_full = l_1_0._backdrop:get_new_background_layer()
  l_1_0._foreground_layer_safe = l_1_0._backdrop:get_new_foreground_layer()
  l_1_0._foreground_layer_full = l_1_0._backdrop:get_new_foreground_layer()
  l_1_0._baselayer_two = l_1_0._backdrop:get_new_base_layer()
  l_1_0._backdrop:set_panel_to_saferect(l_1_0._background_layer_safe)
  l_1_0._backdrop:set_panel_to_saferect(l_1_0._foreground_layer_safe)
  l_1_0._callback_handler = {}
  local lootscreen_string = managers.localization:to_upper_text("menu_l_lootscreen")
  local loot_text = l_1_0._foreground_layer_safe:text({name = "loot_text", text = lootscreen_string, align = "center", vertical = "top", font_size = large_font_size, font = large_font, color = tweak_data.screen_colors.text})
  l_1_0:make_fine_text(loot_text)
  local bg_text = l_1_0._background_layer_full:text({text = loot_text:text(), h = 90, align = "left", vertical = "top", font_size = massive_font_size, font = massive_font, color = tweak_data.screen_colors.button_stage_3, alpha = 0.40000000596046})
  l_1_0:make_fine_text(bg_text)
  local x, y = managers.gui_data:safe_to_full_16_9(managers.gui_data, loot_text:world_x(), loot_text:world_center_y())
  bg_text:set_world_left(loot_text:world_x())
  bg_text:set_world_center_y(loot_text:world_center_y())
  bg_text:move(-13, 9)
  local icon_path, texture_rect = tweak_data.hud_icons:get_icon_data("downcard_overkill_deck")
  l_1_0._downcard_icon_path = icon_path
  l_1_0._downcard_texture_rect = texture_rect
  l_1_0._hud_panel = l_1_0._foreground_layer_safe:panel()
  l_1_0._hud_panel:set_y(25)
  l_1_0._hud_panel:set_h(l_1_0._hud_panel:h() - 25 - 150)
  l_1_0._peer_data = {}
  l_1_0._peers_panel = l_1_0._hud_panel:panel({})
  for i = 1, 4 do
    l_1_0:create_peer(l_1_0._peers_panel, i)
  end
  l_1_0._num_visible = 1
  l_1_0:set_num_visible(l_1_0:get_local_peer_id())
  if not l_1_0._lootdrops then
    l_1_0._lootdrops = {}
  end
  if l_1_3 then
    for _,lootdrop in ipairs(l_1_3) do
      l_1_0:feed_lootdrop(lootdrop)
    end
  end
  if l_1_4 then
    for peer_id,selected in pairs(l_1_4) do
      l_1_0:set_selected(peer_id, selected)
    end
  end
  if l_1_5 then
    for peer_id,card_id in pairs(l_1_5) do
      l_1_0:begin_choose_card(peer_id, card_id)
    end
  end
  local local_peer_id = l_1_0:get_local_peer_id()
  local panel = l_1_0._peers_panel:child("peer" .. tostring(local_peer_id))
  local peer_info_panel = panel:child("peer_info")
  local peer_name = peer_info_panel:child("peer_name")
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
peer_name:set_text(tostring(managers.blackmarket:get_preferred_character_real_name()) .. " (" .. managers.experience:current_level() .. ")")
l_1_0:make_fine_text(peer_name)
peer_name:set_right(peer_info_panel:w())
panel:set_alpha(1)
peer_info_panel:show()
panel:child("card_info"):hide()
end

HUDLootScreen.create_peer = function(l_2_0, l_2_1, l_2_2)
  local massive_font = tweak_data.menu.pd2_massive_font
  local large_font = tweak_data.menu.pd2_large_font
  local medium_font = tweak_data.menu.pd2_medium_font
  local small_font = tweak_data.menu.pd2_small_font
  local massive_font_size = tweak_data.menu.pd2_massive_font_size
  local large_font_size = tweak_data.menu.pd2_large_font_size
  local medium_font_size = tweak_data.menu.pd2_medium_font_size
  local small_font_size = tweak_data.menu.pd2_small_font_size
  local color = tweak_data.chat_colors[l_2_2]
  local is_local_peer = l_2_2 == l_2_0:get_local_peer_id()
  l_2_0._peer_data[l_2_2] = {}
  l_2_0._peer_data[l_2_2].selected = 2
  l_2_0._peer_data[l_2_2].wait_t = false
  l_2_0._peer_data[l_2_2].ready = false
  l_2_0._peer_data[l_2_2].active = false
  local panel = l_2_1:panel({name = "peer" .. tostring(l_2_2), x = 0, y = (l_2_2 - 1) * 110, w = l_2_1:w(), h = 110})
  local peer_info_panel = panel:panel({name = "peer_info", w = 255})
  local peer_name = peer_info_panel:text({name = "peer_name", font = medium_font, font_size = medium_font_size - 1, text = " ", h = medium_font_size, w = 1, color = color, blend_mode = "add"})
  l_2_0:make_fine_text(peer_name)
  peer_name:set_right(peer_info_panel:w())
  peer_name:set_center_y(peer_info_panel:h() * 0.5)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local max_quality = peer_info_panel:text({name = "max_quality", font = small_font})
  l_2_0:make_fine_text(max_quality)
  {name = "max_quality", font = small_font}.visible, {name = "max_quality", font = small_font}.blend_mode, {name = "max_quality", font = small_font}.color, {name = "max_quality", font = small_font}.w, {name = "max_quality", font = small_font}.h, {name = "max_quality", font = small_font}.text, {name = "max_quality", font = small_font}.font_size = false, "add", tweak_data.screen_colors.text, 1, medium_font_size, " ", small_font_size - 1
  max_quality:set_right(peer_info_panel:w())
  max_quality:set_top(peer_name:bottom())
  local card_info_panel = panel:panel({name = "card_info", w = 300})
  card_info_panel:set_right(panel:w())
  local main_text = card_info_panel:text({name = "main_text", font = medium_font, font_size = medium_font_size, text = managers.localization:to_upper_text(is_local_peer and "menu_l_choose_card_local" or "menu_l_choose_card_peer"), blend_mode = "add", wrap = true, word_wrap = true})
  local quality_text = card_info_panel:text({name = "quality_text", font = small_font, font_size = small_font_size, text = " ", blend_mode = "add", visible = false})
  local global_value_text = card_info_panel:text({name = "global_value_text", font = small_font, font_size = small_font_size, text = managers.localization:to_upper_text("menu_l_global_value_infamous"), color = tweak_data.lootdrop.global_values.infamous.color, blend_mode = "add"})
  global_value_text:hide()
  local _, _, _, hh = main_text:text_rect()
  main_text:set_h(hh + 2)
  l_2_0:make_fine_text(quality_text)
  l_2_0:make_fine_text(global_value_text)
  main_text:set_y(0)
  quality_text:set_y(main_text:bottom())
  global_value_text:set_y(main_text:bottom())
  card_info_panel:set_h(main_text:bottom())
  card_info_panel:set_center_y(panel:h() * 0.5)
  local total_cards_w = panel:w() - peer_info_panel:w() - card_info_panel:w() - 10
  local card_w = math.round((total_cards_w - 10) / 3)
  for i = 1, 3 do
    local card_panel = panel:panel({name = "card" .. i, x = peer_info_panel:right() + (i - 1) * card_w + 10, y = 10, w = card_w - 2.5, h = panel:h() - 10, halign = "scale", valign = "scale"})
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    local downcard = card_panel:bitmap({name = "downcard", texture = l_2_0._downcard_icon_path, texture_rect = l_2_0._downcard_texture_rect, w = math.round(0.71111112833023 * card_panel:h())})
    {name = "downcard", texture = l_2_0._downcard_icon_path, texture_rect = l_2_0._downcard_texture_rect, w = math.round(0.71111112833023 * card_panel:h())}.valign, {name = "downcard", texture = l_2_0._downcard_icon_path, texture_rect = l_2_0._downcard_texture_rect, w = math.round(0.71111112833023 * card_panel:h())}.halign, {name = "downcard", texture = l_2_0._downcard_icon_path, texture_rect = l_2_0._downcard_texture_rect, w = math.round(0.71111112833023 * card_panel:h())}.layer, {name = "downcard", texture = l_2_0._downcard_icon_path, texture_rect = l_2_0._downcard_texture_rect, w = math.round(0.71111112833023 * card_panel:h())}.rotation, {name = "downcard", texture = l_2_0._downcard_icon_path, texture_rect = l_2_0._downcard_texture_rect, w = math.round(0.71111112833023 * card_panel:h())}.blend_mode, {name = "downcard", texture = l_2_0._downcard_icon_path, texture_rect = l_2_0._downcard_texture_rect, w = math.round(0.71111112833023 * card_panel:h())}.h = "scale", "scale", 1, math.random(4) - 2, "add", card_panel:h()
    if downcard:rotation() == 0 then
      downcard:set_rotation(1)
    end
    if not is_local_peer then
      downcard:set_size(math.round(0.71111112833023 * card_panel:h() * 0.85000002384186), math.round(card_panel:h() * 0.85000002384186))
    end
    downcard:set_center(card_panel:w() * 0.5, card_panel:h() * 0.5)
    local bg = card_panel:bitmap({name = "bg", texture = l_2_0._downcard_icon_path, texture_rect = l_2_0._downcard_texture_rect, color = tweak_data.screen_colors.button_stage_3, halign = "scale", valign = "scale"})
    bg:set_rotation(downcard:rotation())
    bg:set_shape(downcard:shape())
    local inside_card_check = panel:panel({name = "inside_check_card" .. tostring(i), w = 100, h = 100})
    inside_card_check:set_center(card_panel:center())
    card_panel:hide()
  end
  local box = BoxGuiObject:new(panel:panel({x = peer_info_panel:right() + 5, y = 5, w = total_cards_w, h = panel:h() - 10}), {sides = {1, 1, 1, 1}})
  if not is_local_peer then
    box:set_color(tweak_data.screen_colors.item_stage_2)
  end
  card_info_panel:hide()
  peer_info_panel:hide()
  panel:set_alpha(0)
end

HUDLootScreen.set_num_visible = function(l_3_0, l_3_1)
  l_3_0._num_visible = math.max(l_3_0._num_visible, l_3_1)
  for i = 1, 4 do
    l_3_0._peers_panel:child("peer" .. i):set_visible(i <= l_3_0._num_visible)
  end
  l_3_0._peers_panel:set_h(l_3_0._num_visible * 110)
  l_3_0._peers_panel:set_center_y(l_3_0._hud_panel:h() * 0.5)
  if managers.menu:is_console() and l_3_0._num_visible >= 4 then
    l_3_0._peers_panel:move(0, 30)
  end
end

HUDLootScreen.make_fine_text = function(l_4_0, l_4_1)
  local x, y, w, h = l_4_1:text_rect()
  l_4_1:set_size(w, h)
  l_4_1:set_position(math.round(l_4_1:x()), math.round(l_4_1:y()))
end

HUDLootScreen.create_selected_panel = function(l_5_0, l_5_1)
  local panel = l_5_0._peers_panel:child("peer" .. l_5_1)
  local selected_panel = panel:panel({name = "selected_panel", w = 100, h = 100, layer = -1})
  local glow_circle = selected_panel:bitmap({texture = "guis/textures/pd2/crimenet_marker_glow", w = 200, h = 200, blend_mode = "add", color = tweak_data.screen_colors.button_stage_3, alpha = 0.40000000596046, rotation = 360})
  local glow_stretch = selected_panel:bitmap({texture = "guis/textures/pd2/crimenet_marker_glow", w = 500, h = 200, blend_mode = "add", color = tweak_data.screen_colors.button_stage_3, alpha = 0.40000000596046, rotation = 360})
  glow_circle:set_center(selected_panel:w() * 0.5, selected_panel:h() * 0.5)
  glow_stretch:set_center(selected_panel:w() * 0.5, selected_panel:h() * 0.5)
  local anim_func = function(l_1_0)
    repeat
      over(1, function(l_1_0)
        o:set_alpha(math.sin(l_1_0 * 180 % 180) * 0.20000000298023 + 0.60000002384186)
         end)
      do return end
       -- Warning: missing end command somewhere! Added here
    end
   end
  selected_panel:animate(anim_func)
  return selected_panel
end

HUDLootScreen.set_selected = function(l_6_0, l_6_1, l_6_2)
  local panel = l_6_0._peers_panel:child("peer" .. l_6_1)
  if not panel:child("selected_panel") then
    local selected_panel = l_6_0:create_selected_panel(l_6_1)
  end
  local card_panel = panel:child("card" .. l_6_2)
  selected_panel:set_center(card_panel:center())
  l_6_0._peer_data[l_6_1].selected = l_6_2
  local is_local_peer = l_6_1 == l_6_0:get_local_peer_id()
  local aspect = 0.71111112833023
  for i = 1, 3 do
    local card_panel = panel:child("card" .. i)
    local downcard = card_panel:child("downcard")
    local bg = card_panel:child("bg")
    local cx, cy = downcard:center()
    local size = card_panel:h() * (i == l_6_2 and 1.1499999761581 or 0.89999997615814) * (is_local_peer and 1 or 0.85000002384186)
    bg:set_color(tweak_data.screen_colors[i == l_6_2 and "button_stage_2" or "button_stage_3"])
    downcard:set_size(math.round(aspect * size), math.round(size))
    downcard:set_center(cx, cy)
    downcard:set_alpha(is_local_peer and 1 or 0.5799999833107)
    bg:set_alpha(1)
    bg:set_shape(downcard:shape())
  end
end

HUDLootScreen.add_callback = function(l_7_0, l_7_1, l_7_2)
  l_7_0._callback_handler[l_7_1] = l_7_2
end

HUDLootScreen.clear_other_peers = function(l_8_0, l_8_1)
  if not l_8_1 then
    l_8_1 = l_8_0:get_local_peer_id()
  end
  for i = 1, 4 do
    if i ~= l_8_1 then
      l_8_0:remove_peer(i)
    end
  end
end

HUDLootScreen.check_all_ready = function(l_9_0)
  local ready = true
  for i = 1, 4 do
    if l_9_0._peer_data[i].active and ready then
      ready = l_9_0._peer_data[i].ready
    end
  end
  return ready
end

HUDLootScreen.remove_peer = function(l_10_0, l_10_1, l_10_2)
  Application:debug("HUDLootScreen:remove_peer( peer_id, reason )", l_10_1, l_10_2)
  local panel = l_10_0._peers_panel:child("peer" .. tostring(l_10_1))
  panel:stop()
  panel:child("card_info"):hide()
  panel:child("peer_info"):hide()
  panel:child("card1"):stop()
  panel:child("card2"):stop()
  panel:child("card3"):stop()
  panel:child("card1"):hide()
  panel:child("card2"):hide()
  panel:child("card3"):hide()
  if panel:child("item") then
    panel:child("item"):stop()
    panel:child("item"):hide()
  end
  if panel:child("selected_panel") then
    panel:child("selected_panel"):hide()
  end
  l_10_0._peer_data[l_10_1] = {}
  l_10_0._peer_data[l_10_1].active = false
end

HUDLootScreen.hide = function(l_11_0)
  if l_11_0._active then
    return 
  end
  l_11_0._backdrop:hide()
  if l_11_0._video then
    managers.video:remove_video(l_11_0._video)
    l_11_0._video:parent():remove(l_11_0._video)
    l_11_0._video = nil
  end
  if l_11_0._sound_listener then
    l_11_0._sound_listener:delete()
    l_11_0._sound_listener = nil
  end
  if l_11_0._sound_source then
    l_11_0._sound_source:stop()
    l_11_0._sound_source:delete()
    l_11_0._sound_source = nil
  end
end

HUDLootScreen.show = function(l_12_0)
  if not l_12_0._video and SystemInfo:platform() ~= Idstring("X360") then
    local variant = math.random(8)
    l_12_0._video = l_12_0._baselayer_two:video({video = "movies/lootdrop" .. tostring(variant), loop = false, speed = 1, blend_mode = "add", alpha = 0.20000000298023})
    managers.video:add_video(l_12_0._video)
  end
  l_12_0._backdrop:show()
  l_12_0._active = true
  if not l_12_0._sound_listener then
    l_12_0._sound_listener = SoundDevice:create_listener("lobby_menu")
    l_12_0._sound_listener:set_position(Vector3(0, -50000, 0))
    l_12_0._sound_listener:activate(true)
  end
  if not l_12_0._sound_source then
    l_12_0._sound_source = SoundDevice:create_source("HUDLootScreen")
    l_12_0._sound_source:post_event("music_loot_drop")
  end
  local fade_rect = l_12_0._foreground_layer_full:rect({layer = 10000, color = Color.black})
  local fade_out_anim = function(l_1_0)
    over(0.5, function(l_1_0)
      o:set_alpha(1 - l_1_0)
      end)
    fade_rect:parent():remove(fade_rect)
   end
  fade_rect:animate(fade_out_anim)
  managers.menu_component:lootdrop_is_now_active()
end

HUDLootScreen.is_active = function(l_13_0)
  return l_13_0._active
end

HUDLootScreen.update_layout = function(l_14_0)
  l_14_0._backdrop:_set_black_borders()
end

HUDLootScreen.feed_lootdrop = function(l_15_0, l_15_1)
  Application:debug(inspect(l_15_1))
  if not l_15_0:is_active() then
    l_15_0:show()
  end
  local peer = l_15_1[1]
  local peer_id = peer and peer:id() or 1
  local is_local_peer = l_15_0:get_local_peer_id() == peer_id
  local peer_name_string = (is_local_peer and (not managers.network.account:username() and tostring(managers.blackmarket:get_preferred_character_real_name())) or (peer and peer:name())) or ""
  local player_level = (is_local_peer and managers.experience:current_level()) or (peer and peer:level()) or 0
  local global_value = l_15_1[2]
  local item_category = l_15_1[3]
  local item_id = l_15_1[4]
  local max_pc = l_15_1[5]
  local item_pc = l_15_1[6]
  local left_pc = l_15_1[7]
  local right_pc = l_15_1[8]
  l_15_0._peer_data[peer_id].lootdrops = l_15_1
  l_15_0._peer_data[peer_id].active = true
  local panel = l_15_0._peers_panel:child("peer" .. tostring(peer_id))
  local peer_info_panel = panel:child("peer_info")
  local peer_name = peer_info_panel:child("peer_name")
  local max_quality = peer_info_panel:child("max_quality")
  peer_name:set_text(peer_name_string .. " (" .. player_level .. ")")
  max_quality:set_text(managers.localization:to_upper_text("menu_l_max_quality", {quality = max_pc}))
  l_15_0:make_fine_text(peer_name)
  l_15_0:make_fine_text(max_quality)
  peer_name:set_right(peer_info_panel:w())
  max_quality:set_right(peer_info_panel:w())
  peer_info_panel:show()
  panel:child("card_info"):show()
  for i = 1, 3 do
    panel:child("card" .. i):show()
  end
  local anim_fadein = function(l_1_0)
    over(1, function(l_1_0)
      o:set_alpha(l_1_0)
      end)
   end
  panel:animate(anim_fadein)
  local item_panel = panel:panel({name = "item", w = panel:h(), h = panel:h(), layer = 2})
  item_panel:hide()
  local category = item_category
  if category == "weapon_mods" then
    category = "mods"
  end
  if category == "colors" then
    local colors = tweak_data.blackmarket.colors[item_id].colors
    local bg = item_panel:bitmap({texture = "guis/textures/pd2/blackmarket/icons/colors/color_bg", w = panel:h(), h = panel:h(), layer = 1})
    local c1 = item_panel:bitmap({texture = "guis/textures/pd2/blackmarket/icons/colors/color_01", w = panel:h(), h = panel:h(), layer = 0})
    local c2 = item_panel:bitmap({texture = "guis/textures/pd2/blackmarket/icons/colors/color_02", w = panel:h(), h = panel:h(), layer = 0})
    c1:set_color(colors[1])
    c2:set_color(colors[2])
  else
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  local texture_loaded_clbk = (callback(l_15_0, l_15_0, "texture_loaded_clbk", {peer_id, true}))
  local texture_path = nil
  if category == "textures" then
    texture_path = tweak_data.blackmarket.textures[item_id].texture
    if not texture_path then
      Application:error("Pattern missing", "PEER", peer_id)
      return 
    elseif category == "cash" then
      texture_path = "guis/textures/pd2/blackmarket/cash_drop"
    else
      texture_path = "guis/textures/pd2/blackmarket/icons/" .. tostring(category) .. "/" .. tostring(item_id)
    end
  end
  Application:debug("Requesting Texture", texture_path, "PEER", peer_id)
  if DB:has(Idstring("texture"), texture_path) then
    TextureCache:request(texture_path, "NORMAL", texture_loaded_clbk)
  else
    Application:error("[HUDLootScreen]", "Texture not in DB", texture_path, peer_id)
    item_panel:rect({color = Color.red})
  end
end
l_15_0:set_num_visible(math.max(l_15_0:get_local_peer_id(), peer_id))
end

HUDLootScreen.texture_loaded_clbk = function(l_16_0, l_16_1, l_16_2)
  local peer_id = l_16_1[1]
  local is_pattern = l_16_1[2]
  local panel = l_16_0._peers_panel:child("peer" .. tostring(peer_id)):child("item")
  local item = panel:bitmap({texture = l_16_2, blend_mode = "add"})
  TextureCache:unretrieve(l_16_2)
  if is_pattern then
    item:set_render_template(Idstring("VertexColorTexturedPatterns"))
    item:set_blend_mode("normal")
  end
  local texture_width = item:texture_width()
  local texture_height = item:texture_height()
  local panel_width = 100
  local panel_height = 100
  if texture_width == 0 or texture_height == 0 or panel_width == 0 or panel_height == 0 then
    Application:error("HUDLootScreen:texture_loaded_clbk():", l_16_2)
    Application:debug("HUDLootScreen:", "texture_width " .. texture_width, "texture_height " .. texture_height, "panel_width " .. panel_width, "panel_height " .. panel_height)
    panel:remove(item)
    local rect = panel:rect({w = 100, h = 100, color = Color.red, blend_mode = "add", rotation = 360})
    rect:set_center(panel:w() * 0.5, panel:h() * 0.5)
    return 
  end
  local s = math.min(texture_width, texture_height)
  local dw = texture_width / s
  local dh = texture_height / s
  Application:debug("Got texture: ", l_16_2, peer_id)
  item:set_size(math.round(dw * panel_width), math.round(dh * panel_height))
  item:set_rotation(360)
  item:set_center(panel:w() * 0.5, panel:h() * 0.5)
  if l_16_0._need_item and l_16_0._need_item[peer_id] then
    l_16_0._need_item[peer_id] = false
    l_16_0:show_item(peer_id)
  end
end

HUDLootScreen.begin_choose_card = function(l_17_0, l_17_1, l_17_2)
  print("YOU CHOOSED " .. l_17_2 .. ", mr." .. l_17_1)
  local panel = l_17_0._peers_panel:child("peer" .. tostring(l_17_1))
  panel:stop()
  panel:set_alpha(1)
  l_17_0._peer_data[l_17_1].wait_t = 5
  local card_info_panel = panel:child("card_info")
  local main_text = card_info_panel:child("main_text")
  main_text:set_text(managers.localization:to_upper_text("menu_l_choose_card_chosen", {time = 5}))
  local _, _, _, hh = main_text:text_rect()
  main_text:set_h(hh + 2)
  local lootdrop_data = l_17_0._peer_data[l_17_1].lootdrops
  local item_category = lootdrop_data[3]
  local item_pc = lootdrop_data[6]
  local left_pc = lootdrop_data[7]
  local right_pc = lootdrop_data[8]
  local cards = {}
  local card_one = l_17_2
  cards[card_one] = item_pc
  local card_two = #cards + 1
  cards[card_two] = left_pc
  local card_three = #cards + 1
  cards[card_three] = right_pc
  if tweak_data.lootdrop.joker_chance <= 0 then
    l_17_0._peer_data[l_17_1].joker = item_pc ~= 0
    local type_to_card = {weapon_mods = 2, cash = 3, masks = 1, materials = 1, colors = 1, textures = 1}
    do
      local card_nums = {"upcard_mask", "upcard_weapon", "upcard_cash"}
      for i,pc in ipairs(cards) do
        local my_card = i == l_17_2
        local card_panel = panel:child("card" .. i)
        local downcard = card_panel:child("downcard")
        local joker = pc == 0 and tweak_data.lootdrop.joker_chance > 0
        if not my_card or not type_to_card[item_category] then
          local card_i = math.max(pc, 1)
        end
        if not my_card then
          if not tweak_data.lootdrop.WEIGHTED_TYPE_CHANCE[card_i * 10] then
            local card_weights = {}
          end
          if card_i == 10 then
            card_i = 1
          else
            if math.rand((card_weights.weapon_mods or 0) + (card_weights.cash or 1)) < card_weights.cash or 1 then
              card_i = 3
            else
              card_i = 2
            end
          end
        end
        local texture, rect, coords = tweak_data.hud_icons:get_icon_data(card_nums[card_i] or "downcard_overkill_deck")
        local upcard = card_panel:bitmap({name = "upcard", texture = texture, w = math.round(0.71111112833023 * card_panel:h()), h = card_panel:h(), blend_mode = "add", layer = 1, halign = "scale", valign = "scale"})
        upcard:set_rotation(downcard:rotation())
        upcard:set_shape(downcard:shape())
        if joker then
          upcard:set_color(Color(1, 0.80000001192093, 0.80000001192093))
        end
        if coords then
          local tl = Vector3(coords[1][1], coords[1][2], 0)
          local tr = Vector3(coords[2][1], coords[2][2], 0)
          local bl = Vector3(coords[3][1], coords[3][2], 0)
          local br = Vector3(coords[4][1], coords[4][2], 0)
          upcard:set_texture_coordinates(tl, tr, bl, br)
        else
          upcard:set_texture_rect(unpack(rect))
        end
        upcard:hide()
      end
      panel:child("card" .. card_two):animate(callback(l_17_0, l_17_0, "flipcard"), 5)
      panel:child("card" .. card_three):animate(callback(l_17_0, l_17_0, "flipcard"), 5)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDLootScreen.debug_flip = function(l_18_0)
  local card = l_18_0._peers_panel:child("peer1"):child("card1")
  card:animate(callback(l_18_0, l_18_0, "flipcard"), 1.5)
end

HUDLootScreen.flipcard = function(l_19_0, l_19_1, l_19_2, l_19_3, l_19_4)
  local downcard = l_19_1:child("downcard")
  local upcard = l_19_1:child("upcard")
  local bg = l_19_1:child("bg")
  downcard:set_valign("scale")
  downcard:set_halign("scale")
  upcard:set_valign("scale")
  upcard:set_halign("scale")
  bg:set_valign("scale")
  bg:set_halign("scale")
  local start_rot = downcard:rotation()
  local start_w = downcard:w()
  local cx, cy = downcard:center()
  l_19_1:set_alpha(1)
  downcard:show()
  upcard:hide()
  local start_rotation = downcard:rotation()
  local end_rotation = start_rotation * -1
  local diff = end_rotation - start_rotation
  bg:set_rotation(downcard:rotation())
  bg:set_shape(downcard:shape())
  wait(0.5)
  managers.menu_component:post_event("loot_flip_card")
  over(0.25, function(l_1_0)
    downcard:set_rotation(start_rotation + math.sin(l_1_0 * 45) * diff)
    if downcard:rotation() == 0 then
      downcard:set_rotation(360)
    end
    downcard:set_w(start_w * math.cos(l_1_0 * 90))
    downcard:set_center(cx, cy)
    bg:set_rotation(downcard:rotation())
    bg:set_shape(downcard:shape())
   end)
  upcard:set_shape(downcard:shape())
  upcard:set_rotation(downcard:rotation())
  start_rotation = upcard:rotation()
  diff = end_rotation - start_rotation
  bg:set_color(Color.black)
  bg:set_rotation(upcard:rotation())
  bg:set_shape(upcard:shape())
  downcard:hide()
  upcard:show()
  over(0.25, function(l_2_0)
    upcard:set_rotation(start_rotation + math.sin(l_2_0 * 45 + 45) * diff)
    if upcard:rotation() == 0 then
      upcard:set_rotation(360)
    end
    upcard:set_w(start_w * math.sin(l_2_0 * 90))
    upcard:set_center(cx, cy)
    bg:set_rotation(upcard:rotation())
    bg:set_shape(upcard:shape())
   end)
  local extra_time = 0
  if l_19_3 then
    local lootdrop_data = l_19_0._peer_data[l_19_4].lootdrops
    local max_pc = lootdrop_data[5]
    local item_pc = lootdrop_data[6]
    if max_pc == 0 then
      do return end
    end
    if item_pc < max_pc then
      extra_time = -0.20000000298023
    elseif item_pc == max_pc then
      extra_time = 0.20000000298023
    elseif max_pc < item_pc then
      extra_time = 1.1000000238419
    end
  end
  wait(l_19_2 - 1.5 + extra_time)
  if not l_19_3 then
    managers.menu_component:post_event("loot_fold_cards")
  end
  over(0.25, function(l_3_0)
    card_panel:set_alpha(math.cos(l_3_0 * 45))
   end)
  if l_19_3 then
    l_19_3(l_19_4)
  end
  local cx, cy = l_19_1:center()
  local w, h = l_19_1:size()
  over(0.25, function(l_4_0)
    card_panel:set_alpha(math.cos(l_4_0 * 45 + 45))
    card_panel:set_size(w * math.cos(l_4_0 * 90), h * math.cos(l_4_0 * 90))
    card_panel:set_center(cx, cy)
   end)
end

HUDLootScreen.show_item = function(l_20_0, l_20_1)
  if not l_20_0._peer_data[l_20_1].active then
    return 
  end
  local panel = l_20_0._peers_panel:child("peer" .. l_20_1)
  if panel:child("item") then
    panel:child("item"):set_center(panel:child("selected_panel"):center())
    panel:child("item"):show()
    for _,child in ipairs(panel:child("item"):children()) do
      child:set_center(panel:child("item"):w() * 0.5, panel:child("item"):h() * 0.5)
    end
    local anim_fadein = function(l_1_0)
      over(1, function(l_1_0)
        o:set_alpha(l_1_0)
         end)
      end
    panel:child("item"):animate(anim_fadein)
    local card_info_panel = panel:child("card_info")
    local main_text = card_info_panel:child("main_text")
    local quality_text = card_info_panel:child("quality_text")
    local global_value_text = card_info_panel:child("global_value_text")
    local lootdrop_data = l_20_0._peer_data[l_20_1].lootdrops
    local global_value = lootdrop_data[2]
    local item_category = lootdrop_data[3]
    local item_id = lootdrop_data[4]
    local item_pc = lootdrop_data[6]
    local loot_tweak = tweak_data.blackmarket[item_category][item_id]
    local item_text = managers.localization:text(loot_tweak.name_id)
    if item_category == "cash" then
      local value_id = tweak_data.blackmarket[item_category][item_id].value_id
      local money = tweak_data:get_value("money_manager", "loot_drop_cash", value_id) or 100
      item_text = managers.experience:cash_string(money)
    end
    main_text:set_text(managers.localization:to_upper_text("menu_l_you_got", {category = managers.localization:text("bm_menu_" .. item_category), item = item_text}))
    quality_text:set_text(managers.localization:to_upper_text("menu_l_quality", {quality = item_pc == 0 and "?" or item_pc}))
    if global_value ~= "normal" then
      global_value_text:set_text(managers.localization:to_upper_text("menu_l_global_value_" .. global_value))
      global_value_text:set_color(tweak_data.lootdrop.global_values[global_value].color)
      l_20_0:make_fine_text(global_value_text)
      global_value_text:set_visible(true)
    end
    if item_category == "weapon_mods" then
      if not managers.weapon_factory:get_weapons_uses_part(item_id) then
        local list_of_weapons = {}
      end
      if table.size(list_of_weapons) == 1 then
        main_text:set_text(main_text:text() .. " (" .. managers.weapon_factory:get_weapon_name_by_factory_id(list_of_weapons[1]) .. ")")
      end
    end
    local _, _, _, hh = main_text:text_rect()
    main_text:set_h(hh + 2)
    l_20_0:make_fine_text(quality_text)
    main_text:set_y(0)
    quality_text:set_y(main_text:bottom())
    global_value_text:set_y(quality_text:bottom())
    if not global_value_text:visible() or not global_value_text:bottom() then
      card_info_panel:set_h(quality_text:bottom())
    end
    card_info_panel:set_center_y(panel:h() * 0.5)
    if l_20_0:get_local_peer_id() == l_20_1 then
      local player_pc = managers.experience:level_to_stars()
      if item_pc < player_pc then
        managers.menu_component:post_event("loot_gain_low")
      elseif item_pc == player_pc then
        managers.menu_component:post_event("loot_gain_med")
      elseif player_pc < item_pc then
        managers.menu_component:post_event("loot_gain_high")
      end
    end
    l_20_0._peer_data[l_20_1].ready = true
    local clbk = l_20_0._callback_handler.on_peer_ready
    if clbk then
      clbk()
    elseif not l_20_0._need_item then
      l_20_0._need_item = {}
    end
    l_20_0._need_item[l_20_1] = true
  end
end

HUDLootScreen.update = function(l_21_0, l_21_1, l_21_2)
  for peer_id = 1, 4 do
    if l_21_0._peer_data[peer_id].wait_t then
      l_21_0._peer_data[peer_id].wait_t = math.max(l_21_0._peer_data[peer_id].wait_t - l_21_2, 0)
      local panel = l_21_0._peers_panel:child("peer" .. tostring(peer_id))
      local card_info_panel = panel:child("card_info")
      local main_text = card_info_panel:child("main_text")
      main_text:set_text(managers.localization:to_upper_text("menu_l_choose_card_chosen", {time = math.ceil(l_21_0._peer_data[peer_id].wait_t)}))
      local _, _, _, hh = main_text:text_rect()
      main_text:set_h(hh + 2)
      if l_21_0._peer_data[peer_id].wait_t == 0 then
        main_text:set_text(managers.localization:to_upper_text("menu_l_choose_card_chosen_suspense"))
        local joker = l_21_0._peer_data[peer_id].joker
        panel:child("card" .. l_21_0._peer_data[peer_id].selected):animate(callback(l_21_0, l_21_0, "flipcard"), joker and 7 or 2.5, callback(l_21_0, l_21_0, "show_item"), peer_id)
        l_21_0._peer_data[peer_id].wait_t = false
      end
    end
  end
end

HUDLootScreen.fetch_local_lootdata = function(l_22_0)
  return l_22_0._peer_data[l_22_0:get_local_peer_id()].lootdrops
end

HUDLootScreen.create_stars_giving_animation = function(l_23_0)
  local lootdrops = l_23_0:fetch_local_lootdata()
  local human_players = managers.network:game() and managers.network:game():amount_of_alive_players() or 1
  local all_humans = human_players == 4
  if not lootdrops or not lootdrops[5] then
    return 
  end
  local max_pc = lootdrops[5]
  local job_stars = managers.job:has_active_job() and managers.job:current_job_and_difficulty_stars() or 1
  local difficulty_stars = managers.job:has_active_job() and managers.job:current_difficulty_stars() or 0
  local player_stars = managers.experience:level_to_stars()
  local bonus_stars = all_humans and 1 or 0
  local level_stars = player_stars < max_pc and tweak_data.lootdrop.level_limit or 0
  local max_number_of_stars = job_stars
  if l_23_0._stars_panel then
    l_23_0._stars_panel:stop()
    l_23_0._stars_panel:parent():remove(l_23_0._stars_panel)
    l_23_0._stars_panel = nil
  end
  l_23_0._stars_panel = l_23_0._foreground_layer_safe:panel()
  l_23_0._stars_panel:set_left(l_23_0._foreground_layer_safe:child("loot_text"):right() + 10)
  local star_reason_text = l_23_0._stars_panel:text({font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, text = ""})
  star_reason_text:set_left(max_number_of_stars * 35)
  star_reason_text:set_h(tweak_data.menu.pd2_medium_font_size)
  star_reason_text:set_world_center_y(math.round(l_23_0._foreground_layer_safe:child("loot_text"):world_center_y()) + 2)
  local animation_func = function(l_1_0)
    local texture, rect = tweak_data.hud_icons:get_icon_data("risk_pd")
    local latest_star = 0
    wait(1.3500000238419)
    for i = 1, max_number_of_stars do
      wait(0.10000000149012)
       -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

    end
    local star = self._stars_panel:bitmap({name = "star_" .. tostring(i), texture = texture, texture_rect = rect, w = 32, h = 32, color = tweak_data.screen_colors.text, blend_mode = "add"})
    do
      local star_color = star:color()
      star:set_alpha(0)
      star:set_x((i - 1) * 35)
      star:set_world_center_y(math.round(self._foreground_layer_safe:child("loot_text"):world_center_y()))
      managers.menu_component:post_event("Play_star_hit")
      over(0.44999998807907, function(l_1_0)
        star:set_alpha(math.min(l_1_0 * 10, 1))
        star:set_color(math.lerp(star_color, star_color, l_1_0) - math.clamp(math.sin(l_1_0 * 180), 0, 1) * Color(1, 1, 1))
        star:set_color(star:color():with_alpha(1))
         end)
      latest_star = i
    end
  end
  over(0.5, function(l_2_0)
    star_reason_text:set_alpha(1 - l_2_0)
   end)
   end
  l_23_0._stars_panel:animate(animation_func)
end

HUDLootScreen.get_local_peer_id = function(l_24_0)
  return (Global.game_settings.single_player and 1) or (managers.network:session() and managers.network:session():local_peer():id()) or 1
end

HUDLootScreen.check_inside_local_peer = function(l_25_0, l_25_1, l_25_2)
  local peer_id = l_25_0:get_local_peer_id()
  local panel = l_25_0._peers_panel:child("peer" .. tostring(peer_id))
  for i = 1, 3 do
    local inside_check_card = panel:child("inside_check_card" .. tostring(i))
    if inside_check_card:inside(l_25_1, l_25_2) then
      return i
    end
  end
end

HUDLootScreen.reload = function(l_26_0)
  l_26_0._backdrop:close()
  l_26_0._backdrop = nil
  HUDLootScreen.init(l_26_0, l_26_0._hud, l_26_0._workspace)
end


