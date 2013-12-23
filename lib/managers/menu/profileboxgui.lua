-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\profileboxgui.luac 

if not ProfileBoxGui then
  ProfileBoxGui = class(TextBoxGui)
end
ProfileBoxGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  if not l_1_5 then
    l_1_5 = {}
  end
  l_1_5.h = l_1_5.h or 260
  l_1_5.w = l_1_5.w or 280
  local x, y = l_1_1:size()
  l_1_5.x = l_1_5.x or 0
  if not l_1_5.y then
    l_1_5.y = y - l_1_5.h - CoreMenuRenderer.Renderer.border_height
  end
  l_1_5.no_close_legend = true
  l_1_5.no_scroll_legend = true
  l_1_5.use_minimize_legend = true
  l_1_2 = "Profile"
  l_1_0._stats_font_size = 14
  if not l_1_0._stats_items then
    l_1_0._stats_items = {}
  end
  ProfileBoxGui.super.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  l_1_0:set_layer(10)
end

ProfileBoxGui._profile_name = function(l_2_0)
  return managers.network.account:username()
end

ProfileBoxGui._profile_level = function(l_3_0)
  return "" .. managers.experience:current_level()
end

ProfileBoxGui.update = function(l_4_0, l_4_1, l_4_2)
  local name_panel = l_4_0._scroll_panel:child("profile_panel"):child("name_panel")
  local name = name_panel:child("name")
  if name_panel:w() < name:w() then
    if l_4_0._name_right then
      if name:x() < 0 then
        name:set_x(name:x() + l_4_2 * 10)
      else
        l_4_0._name_right = false
      end
    else
      if name_panel:w() < name:right() then
        name:set_x(name:x() - l_4_2 * 10)
      else
        l_4_0._name_right = true
      end
    end
  end
end

ProfileBoxGui._create_text_box = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4, l_5_5)
  ProfileBoxGui.super._create_text_box(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4, l_5_5)
  local profile_panel = l_5_0._scroll_panel:panel({name = "profile_panel", x = 0, h = 600, w = l_5_0._scroll_panel:w(), layer = 1})
  local texture, rect = tweak_data.hud_icons:get_icon_data(table.random({"mask_clown", "mask_alien"}) .. math.random(4))
  local avatar = profile_panel:bitmap({name = "avatar", visible = true, texture = texture, texture_rect = rect, layer = 0, x = 0, y = 10})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  profile_panel:gradient({name = "avatar_indicator", visible = false, orientation = "vertical", gradient_points = {}})
   -- DECOMPILER ERROR: Overwrote pending register.

  local name_panel = profile_panel:panel({name = "name_panel", w = l_5_0._panel:w() - (avatar:right() + 16) - 64})
  name_panel:set_left(avatar:right() + 16)
  name_panel:set_y(avatar:y())
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local name = name_panel:text({name = "name", text = l_5_0:_profile_name(), font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, x = 0, y = 0, align = "left", halign = "left"})
  local _, _, tw, th = name:text_rect()
   -- DECOMPILER ERROR: Overwrote pending register.

  name_panel:set_h(1)
  name:set_h(th)
  name:set_w(tw + 4)
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local level = profile_panel:text({name = "level", text = Color(1, 0.80000001192093, 0.19607843458652, 0)(l_5_0), font = tweak_data.menu.small_font_noshadow, font_size = tweak_data.menu.small_font_size, x = 16, y = math.round(0), align = "right", halign = "right", vertical = "center", hvertical = "center"})
  local _, _, sw, sh = level:text_rect()
  level:set_size(sw, sh)
  {name = "level", text = Color(1, 0.80000001192093, 0.19607843458652, 0)(l_5_0), font = tweak_data.menu.small_font_noshadow, font_size = tweak_data.menu.small_font_size, x = 16, y = math.round(0), align = "right", halign = "right", vertical = "center", hvertical = "center"}.layer, {name = "level", text = Color(1, 0.80000001192093, 0.19607843458652, 0)(l_5_0), font = tweak_data.menu.small_font_noshadow, font_size = tweak_data.menu.small_font_size, x = 16, y = math.round(0), align = "right", halign = "right", vertical = "center", hvertical = "center"}.color, {name = "level", text = Color(1, 0.80000001192093, 0.19607843458652, 0)(l_5_0), font = tweak_data.menu.small_font_noshadow, font_size = tweak_data.menu.small_font_size, x = 16, y = math.round(0), align = "right", halign = "right", vertical = "center", hvertical = "center"}.blend_mode, {name = "name", text = l_5_0:_profile_name(), font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, x = 0, y = 0, align = "left", halign = "left"}.layer, {name = "name", text = l_5_0:_profile_name(), font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, x = 0, y = 0, align = "left", halign = "left"}.color, {name = "name", text = l_5_0:_profile_name(), font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, x = 0, y = 0, align = "left", halign = "left"}.hvertical, {name = "name", text = l_5_0:_profile_name(), font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, x = 0, y = 0, align = "left", halign = "left"}.vertical, {name = "avatar_indicator", visible = false, orientation = "vertical", gradient_points = {}}.blend_mode, {name = "avatar_indicator", visible = false, orientation = "vertical", gradient_points = {}}.h, {name = "avatar_indicator", visible = false, orientation = "vertical", gradient_points = {}}.w, {name = "avatar_indicator", visible = false, orientation = "vertical", gradient_points = {}}.y, {name = "avatar_indicator", visible = false, orientation = "vertical", gradient_points = {}}.x, {name = "avatar_indicator", visible = false, orientation = "vertical", gradient_points = {}}.layer = 0, Color(0.80000001192093, 1, 0.80000001192093), "normal", 0, Color(0.80000001192093, 0.5, Color(0, 0.60392159223557, 0.40000000596046, 0)), "top", "top", "add", avatar:h(), avatar:w(), 10, 0, 1
  level:set_right(math.floor(profile_panel:w()))
  level:set_center_y(math.round(name_panel:center_y()))
  local texture, rect = tweak_data.hud_icons:get_icon_data("icon_equipped")
  local arrow = profile_panel:bitmap({name = "arrow", visible = false, texture = texture, texture_rect = rect, layer = 0, x = avatar:right()})
  arrow:set_center_y(name_panel:center_y())
  l_5_0:_add_statistics()
  if #l_5_0._stats_items == 0 then
    profile_panel:set_h(74)
  else
    profile_panel:set_h(math.ceil(l_5_0._stats_items[#l_5_0._stats_items]:bottom()) + 10)
  end
  l_5_0._scroll_panel:set_h(math.max(l_5_0._scroll_panel:h(), profile_panel:h()))
  l_5_0:_set_scroll_indicator()
end

ProfileBoxGui._add_statistics = function(l_6_0)
  l_6_0:_add_stats({topic = string.upper("Achievements:"), name = "achievements", data = managers.achievment:total_unlocked() / managers.achievment:total_amount(), text = "" .. managers.achievment:total_unlocked() .. "/" .. managers.achievment:total_amount(), type = "progress"})
  l_6_0:_add_stats({topic = managers.localization:text("menu_stats_level_progress"), data = managers.experience:current_level() / managers.experience:level_cap(), text = "" .. managers.experience:current_level() .. "/" .. managers.experience:level_cap(), type = "progress"})
  l_6_0:_add_stats({topic = managers.localization:text("menu_stats_money"), data = managers.experience:total_cash_string(), type = "text"})
  l_6_0:_add_stats({topic = managers.localization:text("menu_stats_time_played"), data = managers.statistics:time_played() .. " " .. managers.localization:text("menu_stats_time"), type = "text"})
  l_6_0:_add_stats({topic = managers.localization:text("menu_stats_total_kills"), data = "" .. managers.statistics:total_kills(), type = "text"})
end

ProfileBoxGui._add_stats = function(l_7_0, l_7_1)
  local y = 64
  for _,panel in ipairs(l_7_0._stats_items) do
    y = y + panel:h() + 4
  end
  local xo = 4
  local panel = l_7_0._scroll_panel:child("profile_panel"):panel({name = l_7_1.name, y = y, w = l_7_0._scroll_panel:child("profile_panel"):w()})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local topic = panel:text({name = "topic", font = tweak_data.menu.small_font, font_size = l_7_0._stats_font_size, color = Color.white, layer = 2, x = xo, y = 0, w = panel:w()})
  do
    local x, y, w, h = topic:text_rect()
    topic:set_h(math.ceil(h))
    {name = "topic", font = tweak_data.menu.small_font, font_size = l_7_0._stats_font_size, color = Color.white, layer = 2, x = xo, y = 0, w = panel:w()}.text, {name = "topic", font = tweak_data.menu.small_font, font_size = l_7_0._stats_font_size, color = Color.white, layer = 2, x = xo, y = 0, w = panel:w()}.vertical, {name = "topic", font = tweak_data.menu.small_font, font_size = l_7_0._stats_font_size, color = Color.white, layer = 2, x = xo, y = 0, w = panel:w()}.halign, {name = "topic", font = tweak_data.menu.small_font, font_size = l_7_0._stats_font_size, color = Color.white, layer = 2, x = xo, y = 0, w = panel:w()}.align = l_7_1.topic, "center", "left", "left"
    panel:set_h(math.ceil(h))
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    if l_7_1.type == "text" then
      local text = panel:text({name = "text", font = tweak_data.menu.small_font, font_size = l_7_0._stats_font_size, color = Color.white, layer = 2, x = -xo, y = 0, h = h, w = l_7_0._scroll_panel:child("profile_panel"):w(), align = "right", halign = "right", vertical = "center"})
    end
    {name = "text", font = tweak_data.menu.small_font, font_size = l_7_0._stats_font_size, color = Color.white, layer = 2, x = -xo, y = 0, h = h, w = l_7_0._scroll_panel:child("profile_panel"):w(), align = "right", halign = "right", vertical = "center"}.text, {name = "text", font = tweak_data.menu.small_font, font_size = l_7_0._stats_font_size, color = Color.white, layer = 2, x = -xo, y = 0, h = h, w = l_7_0._scroll_panel:child("profile_panel"):w(), align = "right", halign = "right", vertical = "center"}.valign = l_7_1.data, "center"
    if l_7_1.type == "progress" then
      h = h + 4
      topic:set_h(math.ceil(h))
      panel:set_h(math.ceil(h))
      local bg = panel:rect({name = "bg", x = 0, y = 0, w = panel:w(), h = h, color = Color.black:with_alpha(0.5), layer = 0})
       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      local bar = panel:gradient({name = "bar", orientation = "vertical", gradient_points = {}, x = 2, y = bg:y() + 2, w = (bg:w() - 4) * l_7_1.data})
       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Overwrote pending register.

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers!

      if not l_7_1.text then
        local text = panel:text({name = "bar_text", font = tweak_data.menu.small_font, font_size = l_7_0._stats_font_size, color = Color.white, layer = 2, x = -xo, y = 0, h = h, w = bg:w(), align = "right", halign = "right", vertical = "center"})
      end
      table.insert(l_7_0._stats_items, panel)
    end
     -- Warning: undefined locals caused missing assignments!
     -- Warning: missing end command somewhere! Added here
  end
end

ProfileBoxGui.mouse_pressed = function(l_8_0, l_8_1, l_8_2, l_8_3)
  if not l_8_0:can_take_input() then
    return 
  end
  if l_8_1 == Idstring("0") and l_8_0._panel:child("info_area"):inside(l_8_2, l_8_3) then
    local profile_panel = l_8_0._scroll_panel:child("profile_panel")
    local name_panel = profile_panel:child("name_panel")
    if name_panel:inside(l_8_2, l_8_3) then
      l_8_0:_trigger_stats()
      return true
    else
      if profile_panel:child("avatar"):inside(l_8_2, l_8_3) then
        l_8_0:_trigger_profile()
        return true
      else
        if profile_panel:child("achievements") and profile_panel:child("achievements"):inside(l_8_2, l_8_3) then
          l_8_0:_trigger_achievements()
          return true
        end
      end
    end
  end
end

ProfileBoxGui._trigger_stats = function(l_9_0)
  Steam:overlay_activate("game", "Stats")
end

ProfileBoxGui._trigger_profile = function(l_10_0)
  Steam:user(managers.network.account:player_id()):open_overlay("steamid")
end

ProfileBoxGui._trigger_achievements = function(l_11_0)
  Steam:overlay_activate("game", "Achievements")
end

ProfileBoxGui.mouse_moved = function(l_12_0, l_12_1, l_12_2)
  if not l_12_0:can_take_input() then
    return 
  end
  local pointer = nil
  local inside_info = l_12_0._panel:child("info_area"):inside(l_12_1, l_12_2)
  local profile_panel = l_12_0._scroll_panel:child("profile_panel")
  local name_panel = profile_panel:child("name_panel")
  if inside_info then
    local inside = name_panel:inside(l_12_1, l_12_2)
  end
  if not inside or not Color.white then
    name_panel:child("name"):set_color(Color(0.80000001192093, 1, 0.80000001192093))
  end
  if not inside or not Color.white then
    profile_panel:child("level"):set_color(Color(0.80000001192093, 1, 0.80000001192093))
  end
  profile_panel:child("arrow"):set_visible(inside)
  if (inside and "link") or inside_info then
    local inside = profile_panel:child("avatar"):inside(l_12_1, l_12_2)
  end
  profile_panel:child("avatar_indicator"):set_visible(inside)
  do
    if (inside and "link") or profile_panel:child("achievements") then
      if inside_info then
        local inside = profile_panel:child("achievements"):inside(l_12_1, l_12_2)
      end
      if not inside or not Color(0.80000001192093, 1, 0.80000001192093) then
        profile_panel:child("achievements"):child("topic"):set_color(Color.white)
      end
      if not inside or not Color(0.80000001192093, 1, 0.80000001192093) then
        profile_panel:child("achievements"):child("bar_text"):set_color(Color.white)
      end
  end
  if not inside or not "link" then
    end
  end
  if inside_info then
    local inside = profile_panel:inside(l_12_1, l_12_2)
  end
  pointer = pointer or not inside or "arrow"
  return false, pointer
end

ProfileBoxGui._check_scroll_indicator_states = function(l_13_0)
  ProfileBoxGui.super._check_scroll_indicator_states(l_13_0)
end

ProfileBoxGui.set_size = function(l_14_0, l_14_1, l_14_2)
  ProfileBoxGui.super.set_size(l_14_0, l_14_1, l_14_2)
  local profile_panel = l_14_0._scroll_panel:child("profile_panel")
end

ProfileBoxGui.set_visible = function(l_15_0, l_15_1)
  ProfileBoxGui.super.set_visible(l_15_0, l_15_1)
end

ProfileBoxGui.close = function(l_16_0)
  ProfileBoxGui.super.close(l_16_0)
end

if not LobbyProfileBoxGui then
  LobbyProfileBoxGui = class(ProfileBoxGui)
end
LobbyProfileBoxGui.init = function(l_17_0, l_17_1, l_17_2, l_17_3, l_17_4, l_17_5, l_17_6)
  l_17_0._peer_id = l_17_6
  LobbyProfileBoxGui.super.init(l_17_0, l_17_1, l_17_2, l_17_3, l_17_4, l_17_5)
end

LobbyProfileBoxGui._trigger_stats = function(l_18_0)
  local peer = managers.network:session():peer(l_18_0._peer_id)
  local user = Steam:user(peer:ip())
  user:open_overlay("stats")
end

LobbyProfileBoxGui._trigger_profile = function(l_19_0)
  local peer = managers.network:session():peer(l_19_0._peer_id)
  local user = Steam:user(peer:ip())
  user:open_overlay("steamid")
end

LobbyProfileBoxGui._trigger_achievements = function(l_20_0)
  local peer = managers.network:session():peer(l_20_0._peer_id)
  local user = Steam:user(peer:ip())
  user:open_overlay("achievements")
end

LobbyProfileBoxGui._profile_name = function(l_21_0)
  return managers.network:session():peer(l_21_0._peer_id):name()
end

LobbyProfileBoxGui._profile_level = function(l_22_0)
  local peer = managers.network:session():peer(l_22_0._peer_id)
  local user = Steam:user(peer:ip())
  if not peer:profile("level") then
    return "" .. user:rich_presence("level")
  end
end

LobbyProfileBoxGui._add_statistics = function(l_23_0)
end

if not ViewCharacterProfileBoxGui then
  ViewCharacterProfileBoxGui = class(ProfileBoxGui)
end
ViewCharacterProfileBoxGui.init = function(l_24_0, l_24_1, l_24_2, l_24_3, l_24_4, l_24_5, l_24_6)
  l_24_0._user = l_24_6
  ViewCharacterProfileBoxGui.super.init(l_24_0, l_24_1, l_24_2, l_24_3, l_24_4, l_24_5)
end

ViewCharacterProfileBoxGui._trigger_stats = function(l_25_0)
  l_25_0._user:open_overlay("stats")
end

ViewCharacterProfileBoxGui._trigger_profile = function(l_26_0)
  l_26_0._user:open_overlay("steamid")
end

ViewCharacterProfileBoxGui._trigger_achievements = function(l_27_0)
  l_27_0._user:open_overlay("achievements")
end

ViewCharacterProfileBoxGui._profile_name = function(l_28_0)
  return l_28_0._user:name()
end

ViewCharacterProfileBoxGui._profile_level = function(l_29_0)
  return "" .. l_29_0._user:rich_presence("level")
end

ViewCharacterProfileBoxGui._add_statistics = function(l_30_0)
end


