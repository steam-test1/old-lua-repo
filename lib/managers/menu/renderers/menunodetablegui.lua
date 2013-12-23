-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\renderers\menunodetablegui.luac 

if not MenuNodeTableGui then
  MenuNodeTableGui = class(MenuNodeGui)
end
MenuNodeTableGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  MenuNodeTableGui.super.init(l_1_0, l_1_1, l_1_2, l_1_3)
end

MenuNodeTableGui._setup_panels = function(l_2_0, l_2_1)
  MenuNodeTableGui.super._setup_panels(l_2_0, l_2_1)
  local safe_rect_pixels = l_2_0:_scaled_size()
  local mini_info = l_2_0.safe_rect_panel:panel({x = 0, y = 0, w = 0, h = 0})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local mini_text = mini_info:text({x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white})
  mini_info:set_width(l_2_0._info_bg_rect:w() - tweak_data.menu.info_padding * 2)
  {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.word_wrap, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.wrap, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.text, {x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = Color.white}.layer = true, true, "", l_2_0.layers.items
  mini_text:set_width(mini_info:w())
  mini_info:set_height(100)
  mini_text:set_height(100)
  mini_info:set_top(l_2_0._info_bg_rect:bottom() + tweak_data.menu.info_padding)
  mini_text:set_top(0)
  mini_info:set_left(tweak_data.menu.info_padding)
  mini_text:set_left(0)
  l_2_0._mini_info_text = mini_text
end

MenuNodeTableGui.set_mini_info = function(l_3_0, l_3_1)
  l_3_0._mini_info_text:set_text(l_3_1)
end

MenuNodeTableGui._create_menu_item = function(l_4_0, l_4_1)
  if l_4_1.type == "column" then
    local columns = l_4_1.node:columns()
    local total_proportions = l_4_1.node:parameters().total_proportions
    l_4_1.gui_panel = l_4_0.item_panel:panel({x = l_4_0:_right_align(), w = l_4_0.item_panel:w()})
    l_4_1.gui_columns = {}
    local x = 0
    for i,data in ipairs(columns) do
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      local text = l_4_1.gui_panel:text({font_size = l_4_0.font_size, x = l_4_1.position.x, y = 0, align = data.align})
      l_4_1.gui_columns[i], {font_size = l_4_0.font_size, x = l_4_1.position.x, y = 0, align = data.align}.text, {font_size = l_4_0.font_size, x = l_4_1.position.x, y = 0, align = data.align}.layer, {font_size = l_4_0.font_size, x = l_4_1.position.x, y = 0, align = data.align}.color, {font_size = l_4_0.font_size, x = l_4_1.position.x, y = 0, align = data.align}.font, {font_size = l_4_0.font_size, x = l_4_1.position.x, y = 0, align = data.align}.vertical, {font_size = l_4_0.font_size, x = l_4_1.position.x, y = 0, align = data.align}.halign = text, l_4_1.item:parameters().columns[i], l_4_0.layers.items, l_4_1.color, l_4_1.font, "center", data.align
      local _, _, w, h = text:text_rect()
      text:set_h(h)
      local w = data.proportions / total_proportions * l_4_1.gui_panel:w()
      text:set_w(w)
      text:set_x(x)
      x = x + w
    end
    local x, y, w, h = l_4_1.gui_columns[1]:text_rect()
    l_4_1.gui_panel:set_height(h)
  elseif l_4_1.type == "server_column" then
    local columns = l_4_1.node:columns()
    local total_proportions = l_4_1.node:parameters().total_proportions
    local safe_rect = l_4_0:_scaled_size()
    local xl_pad = 54
    l_4_1.gui_panel = l_4_0.item_panel:panel({x = safe_rect.width / 2 - xl_pad, w = safe_rect.width / 2 + xl_pad})
    l_4_1.gui_columns = {}
    local x = 0
    for i,data in ipairs(columns) do
       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      local text = l_4_1.gui_panel:text({font_size = tweak_data.menu.server_list_font_size, x = l_4_1.position.x, y = 0, align = data.align})
      l_4_1.gui_columns[i], {font_size = tweak_data.menu.server_list_font_size, x = l_4_1.position.x, y = 0, align = data.align}.text, {font_size = tweak_data.menu.server_list_font_size, x = l_4_1.position.x, y = 0, align = data.align}.layer, {font_size = tweak_data.menu.server_list_font_size, x = l_4_1.position.x, y = 0, align = data.align}.color, {font_size = tweak_data.menu.server_list_font_size, x = l_4_1.position.x, y = 0, align = data.align}.font, {font_size = tweak_data.menu.server_list_font_size, x = l_4_1.position.x, y = 0, align = data.align}.vertical, {font_size = tweak_data.menu.server_list_font_size, x = l_4_1.position.x, y = 0, align = data.align}.halign = text, l_4_1.item:parameters().columns[i], l_4_0.layers.items, l_4_1.color, l_4_1.font, "center", data.align
      local _, _, w, h = text:text_rect()
      text:set_h(h)
      local w = data.proportions / total_proportions * l_4_1.gui_panel:w()
      text:set_w(w)
      text:set_x(x)
      x = x + w
    end
    local x, y, w, h = l_4_1.gui_columns[1]:text_rect()
    l_4_1.gui_panel:set_height(h)
    local level_id = l_4_1.item:parameters().level_id
    l_4_1.gui_info_panel = l_4_0.safe_rect_panel:panel({visible = false, layer = l_4_0.layers.items, x = 0, y = 0, w = l_4_0:_left_align(), h = l_4_0._item_panel_parent:h()})
    l_4_1.heist_name = l_4_1.gui_info_panel:text({visible = false, text = string.upper(l_4_1.item:parameters().level_name), layer = l_4_0.layers.items, font = l_4_0.font, font_size = tweak_data.menu.challenges_font_size, color = l_4_1.color, align = "left", vertical = "left"})
    local briefing_text = string.upper(level_id and managers.localization:text(tweak_data.levels[level_id].briefing_id) or "")
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_4_1.heist_briefing, {visible = true, x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = Color.white, layer = l_4_0.layers.items}.word_wrap, {visible = true, x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = Color.white, layer = l_4_0.layers.items}.wrap, {visible = true, x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = Color.white, layer = l_4_0.layers.items}.text = l_4_1.gui_info_panel:text({visible = true, x = 0, y = 0, align = "left", halign = "top", vertical = "top", font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size, color = Color.white, layer = l_4_0.layers.items}), true, true, briefing_text
    local font_size = tweak_data.menu.lobby_info_font_size
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_4_1.server_title, {name = "server_title", text = string.upper(managers.localization:text("menu_lobby_server_title"))}.layer, {name = "server_title", text = string.upper(managers.localization:text("menu_lobby_server_title"))}.h, {name = "server_title", text = string.upper(managers.localization:text("menu_lobby_server_title"))}.w, {name = "server_title", text = string.upper(managers.localization:text("menu_lobby_server_title"))}.vertical, {name = "server_title", text = string.upper(managers.localization:text("menu_lobby_server_title"))}.align, {name = "server_title", text = string.upper(managers.localization:text("menu_lobby_server_title"))}.font_size, {name = "server_title", text = string.upper(managers.localization:text("menu_lobby_server_title"))}.font = l_4_1.gui_info_panel:text({name = "server_title", text = string.upper(managers.localization:text("menu_lobby_server_title"))}), 1, font_size, 256, "center", "left", font_size, tweak_data.menu.default_font
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_4_1.server_text, {name = "server_text", text = string.upper(l_4_1.item:parameters().host_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}.layer, {name = "server_text", text = string.upper(l_4_1.item:parameters().host_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}.h, {name = "server_text", text = string.upper(l_4_1.item:parameters().host_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}.w, {name = "server_text", text = string.upper(l_4_1.item:parameters().host_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}.vertical, {name = "server_text", text = string.upper(l_4_1.item:parameters().host_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}.align, {name = "server_text", text = string.upper(l_4_1.item:parameters().host_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}.font_size = l_4_1.gui_info_panel:text({name = "server_text", text = string.upper(l_4_1.item:parameters().host_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}), 1, font_size, 256, "center", "left", font_size
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_4_1.server_info_title, {name = "server_info_title", text = string.upper(managers.localization:text("menu_lobby_server_state_title"))}.layer, {name = "server_info_title", text = string.upper(managers.localization:text("menu_lobby_server_state_title"))}.h, {name = "server_info_title", text = string.upper(managers.localization:text("menu_lobby_server_state_title"))}.w, {name = "server_info_title", text = string.upper(managers.localization:text("menu_lobby_server_state_title"))}.vertical, {name = "server_info_title", text = string.upper(managers.localization:text("menu_lobby_server_state_title"))}.align, {name = "server_info_title", text = string.upper(managers.localization:text("menu_lobby_server_state_title"))}.font_size, {name = "server_info_title", text = string.upper(managers.localization:text("menu_lobby_server_state_title"))}.font = l_4_1.gui_info_panel:text({name = "server_info_title", text = string.upper(managers.localization:text("menu_lobby_server_state_title"))}), 1, font_size, 256, "center", "left", font_size, l_4_0.font
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_4_1.server_info_text, {name = "server_info_text", text = string.upper(l_4_1.item:parameters().state_name), font = l_4_0.font, color = tweak_data.hud.prime_color}.layer, {name = "server_info_text", text = string.upper(l_4_1.item:parameters().state_name), font = l_4_0.font, color = tweak_data.hud.prime_color}.h, {name = "server_info_text", text = string.upper(l_4_1.item:parameters().state_name), font = l_4_0.font, color = tweak_data.hud.prime_color}.w, {name = "server_info_text", text = string.upper(l_4_1.item:parameters().state_name), font = l_4_0.font, color = tweak_data.hud.prime_color}.vertical, {name = "server_info_text", text = string.upper(l_4_1.item:parameters().state_name), font = l_4_0.font, color = tweak_data.hud.prime_color}.align, {name = "server_info_text", text = string.upper(l_4_1.item:parameters().state_name), font = l_4_0.font, color = tweak_data.hud.prime_color}.font_size = l_4_1.gui_info_panel:text({name = "server_info_text", text = string.upper(l_4_1.item:parameters().state_name), font = l_4_0.font, color = tweak_data.hud.prime_color}), 1, font_size, 256, "center", "left", font_size
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_4_1.level_title, {name = "level_title", text = string.upper(managers.localization:text("menu_lobby_campaign_title"))}.layer, {name = "level_title", text = string.upper(managers.localization:text("menu_lobby_campaign_title"))}.h, {name = "level_title", text = string.upper(managers.localization:text("menu_lobby_campaign_title"))}.w, {name = "level_title", text = string.upper(managers.localization:text("menu_lobby_campaign_title"))}.vertical, {name = "level_title", text = string.upper(managers.localization:text("menu_lobby_campaign_title"))}.align, {name = "level_title", text = string.upper(managers.localization:text("menu_lobby_campaign_title"))}.font_size, {name = "level_title", text = string.upper(managers.localization:text("menu_lobby_campaign_title"))}.font = l_4_1.gui_info_panel:text({name = "level_title", text = string.upper(managers.localization:text("menu_lobby_campaign_title"))}), 1, font_size, 256, "center", "left", font_size, tweak_data.menu.default_font
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_4_1.level_text, {name = "level_text", text = string.upper(l_4_1.item:parameters().real_level_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}.layer, {name = "level_text", text = string.upper(l_4_1.item:parameters().real_level_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}.h, {name = "level_text", text = string.upper(l_4_1.item:parameters().real_level_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}.w, {name = "level_text", text = string.upper(l_4_1.item:parameters().real_level_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}.vertical, {name = "level_text", text = string.upper(l_4_1.item:parameters().real_level_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}.align, {name = "level_text", text = string.upper(l_4_1.item:parameters().real_level_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}.font_size = l_4_1.gui_info_panel:text({name = "level_text", text = string.upper(l_4_1.item:parameters().real_level_name), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}), 1, font_size, 256, "center", "left", font_size
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_4_1.difficulty_title, {name = "difficulty_title", text = string.upper(managers.localization:text("menu_lobby_difficulty_title"))}.layer, {name = "difficulty_title", text = string.upper(managers.localization:text("menu_lobby_difficulty_title"))}.h, {name = "difficulty_title", text = string.upper(managers.localization:text("menu_lobby_difficulty_title"))}.w, {name = "difficulty_title", text = string.upper(managers.localization:text("menu_lobby_difficulty_title"))}.vertical, {name = "difficulty_title", text = string.upper(managers.localization:text("menu_lobby_difficulty_title"))}.align, {name = "difficulty_title", text = string.upper(managers.localization:text("menu_lobby_difficulty_title"))}.font_size, {name = "difficulty_title", text = string.upper(managers.localization:text("menu_lobby_difficulty_title"))}.font = l_4_1.gui_info_panel:text({name = "difficulty_title", text = string.upper(managers.localization:text("menu_lobby_difficulty_title"))}), 1, font_size, 256, "center", "left", font_size, tweak_data.menu.default_font
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    l_4_1.difficulty_text, {name = "difficulty_text", text = string.upper(managers.localization:text("menu_difficulty_" .. l_4_1.item:parameters().difficulty)), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}.layer, {name = "difficulty_text", text = string.upper(managers.localization:text("menu_difficulty_" .. l_4_1.item:parameters().difficulty)), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}.h, {name = "difficulty_text", text = string.upper(managers.localization:text("menu_difficulty_" .. l_4_1.item:parameters().difficulty)), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}.w, {name = "difficulty_text", text = string.upper(managers.localization:text("menu_difficulty_" .. l_4_1.item:parameters().difficulty)), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}.vertical, {name = "difficulty_text", text = string.upper(managers.localization:text("menu_difficulty_" .. l_4_1.item:parameters().difficulty)), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}.align, {name = "difficulty_text", text = string.upper(managers.localization:text("menu_difficulty_" .. l_4_1.item:parameters().difficulty)), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}.font_size = l_4_1.gui_info_panel:text({name = "difficulty_text", text = string.upper(managers.localization:text("menu_difficulty_" .. l_4_1.item:parameters().difficulty)), font = tweak_data.menu.default_font, color = tweak_data.hud.prime_color}), 1, font_size, 256, "center", "left", font_size
    l_4_0:_align_server_column(l_4_1)
    if l_4_1.item:menu_unselected_visible(l_4_0, l_4_1) then
      local visible = not l_4_1.item:parameters().back
    end
    l_4_1.menu_unselected = l_4_0.item_panel:bitmap({visible = visible, texture = "guis/textures/menu_unselected", x = 0, y = 0, layer = -1})
    if not l_4_1.item:parameters().is_expanded or not Color(0.5, 0.5, 0.5) then
      l_4_1.menu_unselected:set_color(Color.white)
  else
    end
    MenuNodeTableGui.super._create_menu_item(l_4_0, l_4_1)
  end
end

MenuNodeTableGui._align_server_column = function(l_5_0, l_5_1)
  local safe_rect = l_5_0:_scaled_size()
  l_5_0:_align_item_gui_info_panel(l_5_1.gui_info_panel)
  local font_size = tweak_data.menu.lobby_info_font_size
  local offset = 22 * tweak_data.scale.lobby_info_offset_multiplier
  l_5_1.server_title:set_font_size(font_size)
  l_5_1.server_text:set_font_size(font_size)
  local x, y, w, h = l_5_1.server_title:text_rect()
  l_5_1.server_title:set_x(tweak_data.menu.info_padding)
  l_5_1.server_title:set_y(tweak_data.menu.info_padding)
  l_5_1.server_title:set_w(w)
  l_5_1.server_text:set_lefttop(l_5_1.server_title:righttop())
  l_5_1.server_text:set_w(l_5_1.gui_info_panel:w())
  l_5_1.server_info_title:set_font_size(font_size)
  l_5_1.server_info_text:set_font_size(font_size)
  local x, y, w, h = l_5_1.server_info_title:text_rect()
  l_5_1.server_info_title:set_x(tweak_data.menu.info_padding)
  l_5_1.server_info_title:set_y(tweak_data.menu.info_padding + offset)
  l_5_1.server_info_title:set_w(w)
  l_5_1.server_info_text:set_lefttop(l_5_1.server_info_title:righttop())
  l_5_1.server_info_text:set_w(l_5_1.gui_info_panel:w())
  l_5_1.level_title:set_font_size(font_size)
  l_5_1.level_text:set_font_size(font_size)
  local x, y, w, h = l_5_1.level_title:text_rect()
  l_5_1.level_title:set_x(tweak_data.menu.info_padding)
  l_5_1.level_title:set_y(tweak_data.menu.info_padding + offset * 2)
  l_5_1.level_title:set_w(w)
  l_5_1.level_text:set_lefttop(l_5_1.level_title:righttop())
  l_5_1.level_text:set_w(l_5_1.gui_info_panel:w())
  l_5_1.difficulty_title:set_font_size(font_size)
  l_5_1.difficulty_text:set_font_size(font_size)
  local x, y, w, h = l_5_1.difficulty_title:text_rect()
  l_5_1.difficulty_title:set_x(tweak_data.menu.info_padding)
  l_5_1.difficulty_title:set_y(tweak_data.menu.info_padding + offset * 3)
  l_5_1.difficulty_title:set_w(w)
  l_5_1.difficulty_text:set_lefttop(l_5_1.difficulty_title:righttop())
  l_5_1.difficulty_text:set_w(l_5_1.gui_info_panel:w())
  local _, _, _, h = l_5_1.heist_name:text_rect()
  local w = l_5_1.gui_info_panel:w()
  l_5_1.heist_name:set_height(h)
  l_5_1.heist_name:set_w(w)
  l_5_1.heist_briefing:set_w(w)
  l_5_1.heist_briefing:set_shape(l_5_1.heist_briefing:text_rect())
  l_5_1.heist_briefing:set_x(0)
  l_5_1.heist_briefing:set_y(tweak_data.menu.info_padding + offset * 4 + tweak_data.menu.info_padding * 2)
end

MenuNodeTableGui._setup_item_panel_parent = function(l_6_0, l_6_1)
  MenuNodeTableGui.super._setup_item_panel_parent(l_6_0, l_6_1)
end

MenuNodeTableGui._set_width_and_height = function(l_7_0, l_7_1)
  MenuNodeTableGui.super._set_width_and_height(l_7_0, l_7_1)
end

MenuNodeTableGui._setup_item_panel = function(l_8_0, l_8_1, l_8_2)
  MenuNodeTableGui.super._setup_item_panel(l_8_0, l_8_1, l_8_2)
end

MenuNodeTableGui.resolution_changed = function(l_9_0)
  MenuNodeTableGui.super.resolution_changed(l_9_0)
  local safe_rect_pixels = l_9_0:_scaled_size()
end


