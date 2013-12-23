-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\newsfeedgui.luac 

if not NewsFeedGui then
  NewsFeedGui = class(TextBoxGui)
end
NewsFeedGui.PRESENT_TIME = 0.5
NewsFeedGui.SUSTAIN_TIME = 6
NewsFeedGui.REMOVE_TIME = 0.5
NewsFeedGui.MAX_NEWS = 5
NewsFeedGui.init = function(l_1_0, l_1_1)
  l_1_0._ws = l_1_1
  l_1_0:_create_gui()
  l_1_0:make_news_request()
end

NewsFeedGui.update = function(l_2_0, l_2_1, l_2_2)
  if not l_2_0._titles then
    return 
  end
  if l_2_0._news and #l_2_0._titles > 0 then
    local color = math.lerp(tweak_data.screen_colors.button_stage_2, tweak_data.screen_colors.button_stage_3, (1 + math.sin(l_2_1 * 360)) / 2)
    l_2_0._title_panel:child("title"):set_color(l_2_0._mouse_over and tweak_data.screen_colors.button_stage_2 or color)
    if l_2_0._next then
      l_2_0._next = nil
      l_2_0._news.i = l_2_0._news.i + 1
      if #l_2_0._titles < l_2_0._news.i then
        l_2_0._news.i = 1
      end
      l_2_0._title_panel:child("title"):set_text(utf8.to_upper("(" .. l_2_0._news.i .. "/" .. #l_2_0._titles .. ") " .. l_2_0._titles[l_2_0._news.i]))
      local _, _, w, h = l_2_0._title_panel:child("title"):text_rect()
      l_2_0._title_panel:child("title"):set_h(h)
      l_2_0._title_panel:set_w(w + 10)
      l_2_0._title_panel:set_h(h)
      l_2_0._title_panel:set_left(l_2_0._panel:w())
      l_2_0._title_panel:set_bottom(l_2_0._panel:h())
      l_2_0._present_t = l_2_1 + l_2_0.PRESENT_TIME
    end
    if l_2_0._present_t then
      l_2_0._title_panel:set_left(0 - (managers.gui_data:safe_scaled_size().x + l_2_0._title_panel:w()) * ((l_2_0._present_t - l_2_1) / l_2_0.PRESENT_TIME))
      if l_2_0._present_t < l_2_1 then
        l_2_0._title_panel:set_left(0)
        l_2_0._present_t = nil
        l_2_0._sustain_t = l_2_1 + l_2_0.SUSTAIN_TIME
      end
    end
    if l_2_0._sustain_t and l_2_0._sustain_t < l_2_1 then
      l_2_0._sustain_t = nil
      l_2_0._remove_t = l_2_1 + l_2_0.REMOVE_TIME
    end
    if l_2_0._remove_t then
      l_2_0._title_panel:set_left(0 - (managers.gui_data:safe_scaled_size().x + l_2_0._title_panel:w()) * (1 - (l_2_0._remove_t - l_2_1) / l_2_0.REMOVE_TIME))
      if l_2_0._remove_t < l_2_1 then
        l_2_0._title_panel:set_left(0 - (managers.gui_data:safe_scaled_size().x + l_2_0._title_panel:w()))
        l_2_0._remove_t = nil
        l_2_0._next = true
      end
    end
  end
end

NewsFeedGui.make_news_request = function(l_3_0)
  print("make_news_request()")
  Steam:http_request("http://steamcommunity.com/games/218620/rss", callback(l_3_0, l_3_0, "news_result"))
end

NewsFeedGui.news_result = function(l_4_0, l_4_1, l_4_2)
  print("news_result()", l_4_1)
  if not alive(l_4_0._panel) then
    return 
  end
  if l_4_1 then
    l_4_0._titles = l_4_0:_get_text_block(l_4_2, "<title><![CDATA[", "]]></title>", l_4_0.MAX_NEWS)
    l_4_0._links = l_4_0:_get_text_block(l_4_2, "<link><![CDATA[", "]]></link>", l_4_0.MAX_NEWS)
    l_4_0._news = {i = 0}
    l_4_0._next = true
    l_4_0._panel:child("title_announcement"):set_visible(#l_4_0._titles > 0)
  end
end

NewsFeedGui._create_gui = function(l_5_0)
  local size = managers.gui_data:scaled_size()
  l_5_0._panel = l_5_0._ws:panel():panel({name = "main", w = size.width / 2, h = 44})
  l_5_0._panel:bitmap({visible = false, name = "bg_bitmap", texture = "guis/textures/textboxbg", layer = 0, color = Color.black, w = l_5_0._panel:w(), h = l_5_0._panel:h()})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_5_0._panel:text({visible = false, rotation = 360, name = "title_announcement", text = managers.localization:to_upper_text("menu_announcements"), font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size})
  {visible = false, rotation = 360, name = "title_announcement", text = managers.localization:to_upper_text("menu_announcements"), font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size}.color, {visible = false, rotation = 360, name = "title_announcement", text = managers.localization:to_upper_text("menu_announcements"), font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size}.hvertical, {visible = false, rotation = 360, name = "title_announcement", text = managers.localization:to_upper_text("menu_announcements"), font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size}.vertical, {visible = false, rotation = 360, name = "title_announcement", text = managers.localization:to_upper_text("menu_announcements"), font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size}.halign, {visible = false, rotation = 360, name = "title_announcement", text = managers.localization:to_upper_text("menu_announcements"), font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size}.align = Color.white, "top", "top", "left", "left"
  l_5_0._title_panel = l_5_0._panel:panel({name = "title_panel", layer = 1})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_5_0._title_panel:text({rotation = 360, name = "title", text = "", font = tweak_data.menu.pd2_medium_font})
  {rotation = 360, name = "title", text = "", font = tweak_data.menu.pd2_medium_font}.color, {rotation = 360, name = "title", text = "", font = tweak_data.menu.pd2_medium_font}.hvertical, {rotation = 360, name = "title", text = "", font = tweak_data.menu.pd2_medium_font}.vertical, {rotation = 360, name = "title", text = "", font = tweak_data.menu.pd2_medium_font}.halign, {rotation = 360, name = "title", text = "", font = tweak_data.menu.pd2_medium_font}.align, {rotation = 360, name = "title", text = "", font = tweak_data.menu.pd2_medium_font}.font_size = Color(0.75, 0.75, 0.75), "bottom", "bottom", "left", "left", tweak_data.menu.pd2_medium_font_size
  l_5_0._title_panel:set_right(-10)
  l_5_0._panel:set_bottom(l_5_0._panel:parent():h())
end

NewsFeedGui._get_text_block = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4)
  local result = {}
  local len = string.len(l_6_1)
  local i = 1
  do
    local f = function(l_1_0, l_1_1, l_1_2, l_1_3)
    local s1, e1 = string.find(l_1_0, l_1_1, 1, true)
    if not e1 then
      return 
    end
    local s2, e2 = string.find(l_1_0, l_1_2, e1, true)
    table.insert(result, string.sub(l_1_0, e1 + 1, s2 - 1))
   end
    repeat
      if i < len and #result < l_6_4 then
        local s1, e1 = string.find(l_6_1, "<item>", i, true)
        if not e1 then
          do return end
        end
        local s2, e2 = string.find(l_6_1, "</item>", e1, true)
        local item_s = string.sub(l_6_1, e1 + 1, s2 - 1)
        f(item_s, l_6_2, l_6_3, l_6_4)
        i = e1
      else
        return result
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NewsFeedGui.mouse_moved = function(l_7_0, l_7_1, l_7_2)
  local inside = l_7_0._panel:inside(l_7_1, l_7_2)
  l_7_0._mouse_over = inside
  return false, not inside or "link"
end

NewsFeedGui.mouse_pressed = function(l_8_0, l_8_1, l_8_2, l_8_3)
  if not l_8_0._news then
    return 
  end
  if l_8_1 == Idstring("0") and l_8_0._panel:inside(l_8_2, l_8_3) then
    Steam:overlay_activate("url", l_8_0._links[l_8_0._news.i])
    return true
  end
end

NewsFeedGui.close = function(l_9_0)
  if alive(l_9_0._panel) then
    l_9_0._ws:panel():remove(l_9_0._panel)
  end
end


