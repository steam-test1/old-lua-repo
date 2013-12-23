-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\renderers\menunodestatsgui.luac 

if not MenuNodeStatsGui then
  MenuNodeStatsGui = class(MenuNodeGui)
end
MenuNodeStatsGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  MenuNodeStatsGui.super.init(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0._stats_items = {}
  l_1_0:_setup_stats(l_1_1)
end

MenuNodeStatsGui._setup_panels = function(l_2_0, l_2_1)
  MenuNodeStatsGui.super._setup_panels(l_2_0, l_2_1)
  local safe_rect_pixels = managers.viewport:get_safe_rect_pixels()
end

MenuNodeStatsGui._setup_stats = function(l_3_0, l_3_1)
  l_3_0:_add_stats({topic = managers.localization:text("menu_stats_money"), data = managers.experience:total_cash_string(), type = "text"})
  l_3_0:_add_stats({topic = managers.localization:text("menu_stats_level_progress"), data = managers.experience:current_level() / managers.experience:level_cap(), text = "" .. managers.experience:current_level() .. "/" .. managers.experience:level_cap(), type = "progress"})
  l_3_0:_add_stats({topic = managers.localization:text("menu_stats_time_played"), data = managers.statistics:time_played() .. " " .. managers.localization:text("menu_stats_time"), type = "text"})
  l_3_0:_add_stats({topic = managers.localization:text("menu_stats_favourite_campaign"), data = string.upper(managers.statistics:favourite_level()), type = "text"})
  l_3_0:_add_stats({topic = managers.localization:text("menu_stats_total_completed_campaigns"), data = "" .. managers.statistics:total_completed_campaigns(), type = "text"})
  l_3_0:_add_stats({topic = managers.localization:text("menu_stats_total_completed_objectives"), data = "" .. managers.statistics:total_completed_objectives(), type = "text"})
  l_3_0:_add_stats({topic = managers.localization:text("menu_stats_challenges_completion"), data = managers.challenges:amount_of_completed_challenges() / managers.challenges:amount_of_challenges(), type = "progress"})
  l_3_0:_add_stats({topic = managers.localization:text("menu_stats_favourite_weapon"), data = "" .. string.upper(managers.statistics:favourite_weapon()), type = "text"})
  l_3_0:_add_stats({topic = managers.localization:text("menu_stats_hit_accuracy"), data = "" .. managers.statistics:hit_accuracy() .. "%", type = "text"})
  l_3_0:_add_stats({topic = managers.localization:text("menu_stats_total_kills"), data = "" .. managers.statistics:total_kills(), type = "text"})
  l_3_0:_add_stats({topic = managers.localization:text("menu_stats_total_head_shots"), data = "" .. managers.statistics:total_head_shots(), type = "text"})
  if SystemInfo:platform() == Idstring("WIN32") then
    local y = 30
    for _,panel in ipairs(l_3_0._stats_items) do
      y = y + panel:h() + l_3_0.spacing
    end
    local safe_rect = managers.viewport:get_safe_rect_pixels()
    local panel = l_3_0._item_panel_parent:panel({y = y})
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    local text = panel:text({font_size = tweak_data.menu.stats_font_size, x = safe_rect.x, y = 0, w = safe_rect.width, align = "center", halign = "center", vertical = "center", font = l_3_0.font})
    local _, _, _, h = text:text_rect()
    text:set_h(h)
    {font_size = tweak_data.menu.stats_font_size, x = safe_rect.x, y = 0, w = safe_rect.width, align = "center", halign = "center", vertical = "center", font = l_3_0.font}.render_template, {font_size = tweak_data.menu.stats_font_size, x = safe_rect.x, y = 0, w = safe_rect.width, align = "center", halign = "center", vertical = "center", font = l_3_0.font}.text, {font_size = tweak_data.menu.stats_font_size, x = safe_rect.x, y = 0, w = safe_rect.width, align = "center", halign = "center", vertical = "center", font = l_3_0.font}.layer, {font_size = tweak_data.menu.stats_font_size, x = safe_rect.x, y = 0, w = safe_rect.width, align = "center", halign = "center", vertical = "center", font = l_3_0.font}.color = Idstring("VertexColorTextured"), managers.localization:text("menu_visit_more_stats"), l_3_0.layers.items, l_3_0.row_item_color
    panel:set_h(h)
  end
end

MenuNodeStatsGui._add_stats = function(l_4_0, l_4_1)
  local y = 0
  for _,panel in ipairs(l_4_0._stats_items) do
    y = y + panel:h() + l_4_0.spacing
  end
  local panel = l_4_0._item_panel_parent:panel({y = y})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local topic = panel:text({font_size = tweak_data.menu.stats_font_size, x = 0, y = 0, w = l_4_0:_left_align(), align = "right", halign = "right", vertical = "center", font = l_4_0.font})
  do
    local x, y, w, h = topic:text_rect()
    topic:set_h(h)
    {font_size = tweak_data.menu.stats_font_size, x = 0, y = 0, w = l_4_0:_left_align(), align = "right", halign = "right", vertical = "center", font = l_4_0.font}.render_template, {font_size = tweak_data.menu.stats_font_size, x = 0, y = 0, w = l_4_0:_left_align(), align = "right", halign = "right", vertical = "center", font = l_4_0.font}.text, {font_size = tweak_data.menu.stats_font_size, x = 0, y = 0, w = l_4_0:_left_align(), align = "right", halign = "right", vertical = "center", font = l_4_0.font}.layer, {font_size = tweak_data.menu.stats_font_size, x = 0, y = 0, w = l_4_0:_left_align(), align = "right", halign = "right", vertical = "center", font = l_4_0.font}.color = Idstring("VertexColorTextured"), l_4_1.topic, l_4_0.layers.items, l_4_0.row_item_color
    panel:set_h(h)
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    if l_4_1.type == "text" then
      local text = panel:text({font_size = tweak_data.menu.stats_font_size, x = l_4_0:_right_align(), y = 0, h = h, align = "left", halign = "left", vertical = "center", font = l_4_0.font})
    end
    {font_size = tweak_data.menu.stats_font_size, x = l_4_0:_right_align(), y = 0, h = h, align = "left", halign = "left", vertical = "center", font = l_4_0.font}.render_template, {font_size = tweak_data.menu.stats_font_size, x = l_4_0:_right_align(), y = 0, h = h, align = "left", halign = "left", vertical = "center", font = l_4_0.font}.text, {font_size = tweak_data.menu.stats_font_size, x = l_4_0:_right_align(), y = 0, h = h, align = "left", halign = "left", vertical = "center", font = l_4_0.font}.layer, {font_size = tweak_data.menu.stats_font_size, x = l_4_0:_right_align(), y = 0, h = h, align = "left", halign = "left", vertical = "center", font = l_4_0.font}.color = Idstring("VertexColorTextured"), l_4_1.data, l_4_0.layers.items, l_4_0.color
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    if l_4_1.type == "progress" then
      local bg = panel:rect({x = l_4_0:_right_align(), y = h / 2 - 11})
       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      local bar = panel:gradient({orientation = "vertical", gradient_points = {}, x = l_4_0:_right_align() + 2, y = bg:y() + 2})
       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

    end
    local text = panel:text({font_size = tweak_data.menu.stats_font_size, x = l_4_0:_right_align(), y = 0, h = h, w = bg:w(), align = "center", halign = "center", vertical = "center", valign = "center", font = l_4_0.font, color = l_4_0.color, layer = l_4_0.layers.items + 1})
  end
  table.insert(l_4_0._stats_items, panel)
end
 -- Warning: undefined locals caused missing assignments!
end

MenuNodeStatsGui._create_menu_item = function(l_5_0, l_5_1)
  MenuNodeStatsGui.super._create_menu_item(l_5_0, l_5_1)
end

MenuNodeStatsGui._setup_item_panel_parent = function(l_6_0, l_6_1)
  MenuNodeStatsGui.super._setup_item_panel_parent(l_6_0, l_6_1)
end

MenuNodeStatsGui._setup_item_panel = function(l_7_0, l_7_1, l_7_2)
  MenuNodeStatsGui.super._setup_item_panel(l_7_0, l_7_1, l_7_2)
end

MenuNodeStatsGui.resolution_changed = function(l_8_0)
  MenuNodeStatsGui.super.resolution_changed(l_8_0)
end


