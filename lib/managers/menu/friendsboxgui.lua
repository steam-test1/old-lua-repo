-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\friendsboxgui.luac 

if not FriendsBoxGui then
  FriendsBoxGui = class(TextBoxGui)
end
FriendsBoxGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6)
  l_1_0._type = l_1_6
  if not l_1_5 then
    l_1_5 = {}
  end
  l_1_5.h = 300
  l_1_5.w = 300
  local x, y = l_1_1:size()
  l_1_5.x = x - l_1_5.w
  l_1_5.y = y - l_1_5.h - CoreMenuRenderer.Renderer.border_height + 10
  l_1_5.no_close_legend = true
  l_1_5.no_scroll_legend = true
  l_1_0._default_font_size = tweak_data.menu.default_font_size
  l_1_0._topic_state_font_size = 22
  l_1_0._ingame_color = Color(0.80000001192093, 1, 0.80000001192093)
  l_1_0._online_color = Color(0.60000002384186, 0.80000001192093, 1)
  l_1_0._offline_color = Color(0.5, 0.5, 0.5)
  FriendsBoxGui.super.init(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  l_1_0._users = {}
  l_1_0:update_friends()
  l_1_0:set_layer(10)
end

FriendsBoxGui._create_friend_action_gui_by_user = function(l_2_0, l_2_1)
  if l_2_0._friend_action_gui then
    l_2_0._friend_action_gui:close()
  end
  local user = l_2_1.user
  local offline = l_2_1.main_state == "offline"
  local data = {button_list = {}}
  if managers.network.matchmake.lobby_handler then
    local my_lobby_id = managers.network.matchmake.lobby_handler:id()
  end
  if user:lobby() then
    local user_lobby_id = user:lobby():id()
  end
  if not my_lobby_id and user_lobby_id and not l_2_1.payday1 and not Global.game_settings.single_player then
    local join_game = {}
    join_game.text = "Join Game"
    join_game.id_name = "join_game"
    table.insert(data.button_list, join_game)
  end
  if not offline and managers.network.matchmake.lobby_handler and not user_lobby_id then
    local invite = {}
    invite.text = "Invite"
    invite.id_name = "invite"
    table.insert(data.button_list, invite)
  end
  local chat_button = {}
  chat_button.text = "Message"
  chat_button.id_name = "message"
  table.insert(data.button_list, chat_button)
  local profile_button = {}
  profile_button.text = "View profile"
  profile_button.id_name = "view_profile"
  table.insert(data.button_list, profile_button)
  local achievements_button = {}
  achievements_button.text = "View achievements"
  achievements_button.id_name = "view_achievements"
  table.insert(data.button_list, achievements_button)
  local stats_button = {}
  stats_button.text = "View stats"
  stats_button.id_name = "view_stats"
  table.insert(data.button_list, stats_button)
  local outfit = user:rich_presence("outfit")
  if outfit ~= "" and managers.menu_scene then
    local view_character_button = {}
    view_character_button.text = "View character"
    view_character_button.id_name = "view_character"
    table.insert(data.button_list, view_character_button)
  end
  data.focus_button = 1
  local h = 78 + #data.button_list * 24
  l_2_0._friend_action_gui = TextBoxGui:new(l_2_0._ws, nil, nil, data, {only_buttons = true, no_close_legend = true, w = 200, h = h, x = 0, y = 0})
  l_2_0._friend_action_gui:set_layer(l_2_0:layer() + 20)
end

FriendsBoxGui.set_layer = function(l_3_0, l_3_1)
  FriendsBoxGui.super.set_layer(l_3_0, l_3_1)
  if l_3_0._friend_action_gui then
    l_3_0._friend_action_gui:set_layer(l_3_1 + 20)
  end
end

FriendsBoxGui.update_friends = function(l_4_0)
  if not Steam:logged_on() then
    return 
  end
  local new_users = {}
  if (l_4_0._type ~= "recent" or not Steam:coplay_friends()) and not Steam:friends() then
    local friends = {}
  end
  for _,user in ipairs(friends) do
    local main_state, sub_state = nil, nil
    local state = user:state()
    local rich_presence_status = user:rich_presence("status")
    local rich_presence_level = user:rich_presence("level")
    local payday1 = rich_presence_level == ""
    local playing_this = user:playing_this()
    if playing_this then
      main_state = "ingame"
      sub_state = state .. (payday1 and " - PAYDAY 1" or "")
    elseif state == "online" or state == "away" then
      main_state = "online"
      sub_state = state
    else
      main_state = state
      sub_state = state
    end
    if user:lobby() then
      local numbers = managers.network.matchmake:_lobby_to_numbers(user:lobby())
      if #numbers > 0 then
        local level_id = tweak_data.levels:get_level_name_from_index(numbers[1])
        sub_state = managers.localization:text(tweak_data.levels[level_id] and tweak_data.levels[level_id].name_id or "SECRET LEVEL")
        sub_state = sub_state .. (payday1 and " - PAYDAY 1" or "")
      elseif rich_presence_status == "" then
        if main_state == "ingame" then
          do return end
        end
      else
        if main_state == "offline" then
          sub_state = rich_presence_status
        end
      end
    end
    if not l_4_0._users[user:id()] then
      l_4_0._users[user:id()] = {user = user, main_state = main_state, sub_state = sub_state, lobby = user:lobby(), level = rich_presence_level, payday1 = payday1}
      table.insert(new_users, user:id())
    end
    l_4_0._users[user:id()].user = user
    l_4_0._users[user:id()].current_main_state = main_state
    l_4_0._users[user:id()].current_sub_state = sub_state
    l_4_0._users[user:id()].current_lobby = user:lobby()
    l_4_0._users[user:id()].current_level = rich_presence_level
    l_4_0._users[user:id()].payday1 = payday1
  end
  local friends_panel = l_4_0._scroll_panel:child("friends_panel")
  local ingame_panel = friends_panel:child("ingame_panel")
  local online_panel = friends_panel:child("online_panel")
  do
    local offline_panel = friends_panel:child("offline_panel")
    for _,user_id in ipairs(new_users) do
      local user = l_4_0._users[user_id].user
      local main_state = l_4_0._users[user_id].main_state
      local sub_state = l_4_0._users[user_id].sub_state
      local level = l_4_0._users[user_id].level
      if main_state == "ingame" then
        l_4_0:_create_user(ingame_panel, 0, user, "ingame", sub_state, level)
        for (for control),_ in (for generator) do
        end
        if main_state == "online" or main_state == "away" then
          l_4_0:_create_user(online_panel, 0, user, "online", sub_state, level)
          for (for control),_ in (for generator) do
          end
          l_4_0:_create_user(offline_panel, 0, user, "offline", sub_state, level)
        end
        for _,user in pairs(l_4_0._users) do
          if user.main_state ~= user.current_main_state then
            if user.main_state == "online" then
              online_panel:remove(online_panel:child(user.user:id()))
            elseif user.main_state == "ingame" then
              ingame_panel:remove(ingame_panel:child(user.user:id()))
            else
              offline_panel:remove(offline_panel:child(user.user:id()))
            end
            if user.current_main_state == "ingame" then
              l_4_0:_create_user(ingame_panel, 0, user.user, "ingame", user.sub_state, user.level)
            elseif user.current_main_state == "online" then
              l_4_0:_create_user(online_panel, 0, user.user, "online", user.sub_state, user.level)
            else
              l_4_0:_create_user(offline_panel, 0, user.user, "offline", user.sub_state, user.level)
            end
            user.main_state = user.current_main_state
          else
            if user.sub_state ~= user.current_sub_state then
              l_4_0:_update_sub_state(user)
              user.sub_state = user.current_sub_state
            end
          end
          if user.lobby ~= user.current_lobby then
            local panel = l_4_0:_get_user_panel(user.user:id())
             -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

          end
          panel:child("lobby"):set_visible(true)
          user.lobby = user.current_lobby
        end
        if user.level ~= user.current_level then
          print("CHANGED LEVEL", user.level, user.current_level)
          user.level = user.current_level
          local panel = l_4_0:_get_user_panel(user.user:id())
          local user_level = panel:child("user_level")
          user_level:set_text(user.level)
          local _, _, w, h = user_level:text_rect()
          user_level:set_size(w, h)
          user_level:set_right(math.floor(panel:w()))
          user_level:set_center_y(math.round(panel:child("user_name"):center_y()))
          user_level:set_visible(true)
        end
      end
      l_4_0:_layout_friends_panel()
    end
     -- Warning: missing end command somewhere! Added here
  end
end

FriendsBoxGui._update_sub_state = function(l_5_0, l_5_1)
  local friends_panel = (l_5_0._scroll_panel:child("friends_panel"))
  local panel = nil
  if l_5_1.main_state == "ingame" then
    panel = friends_panel:child("ingame_panel")
  elseif l_5_1.main_state == "online" then
    panel = friends_panel:child("online_panel")
  else
    panel = friends_panel:child("offline_panel")
  end
  local user_panel = panel:child(l_5_1.user:id())
  local user_state = user_panel:child("user_state")
  user_state:set_text(string.upper(l_5_1.current_sub_state))
  local _, _, w, _ = user_state:text_rect()
  user_state:set_w(w)
end

FriendsBoxGui._layout_friends_panel = function(l_6_0)
  local friends_panel = l_6_0._scroll_panel:child("friends_panel")
  local ingame_panel = friends_panel:child("ingame_panel")
  local online_panel = friends_panel:child("online_panel")
  local offline_panel = friends_panel:child("offline_panel")
  local ingame_text = friends_panel:child("ingame_text")
  local online_text = friends_panel:child("online_text")
  local offline_text = friends_panel:child("offline_text")
  local h = 0
  ingame_text:set_y(math.round(h))
  h = h + ingame_text:h()
  ingame_panel:set_y(math.round(h))
  h = h + l_6_0:_get_state_h(ingame_panel)
  online_text:set_y(math.round(h))
  h = h + online_text:h()
  online_panel:set_y(math.round(h))
  h = h + l_6_0:_get_state_h(online_panel)
  offline_text:set_y(math.round(h))
  h = h + offline_text:h()
  offline_panel:set_y(math.round(h))
  h = h + l_6_0:_get_state_h(offline_panel)
  friends_panel:set_h(math.ceil(h))
  l_6_0._scroll_panel:set_h(math.max(l_6_0._scroll_panel:h(), friends_panel:h()))
  l_6_0:_set_scroll_indicator()
  l_6_0:_check_scroll_indicator_states()
end

FriendsBoxGui._get_state_h = function(l_7_0, l_7_1)
  local h = 0
  for _,child in ipairs(l_7_1:children()) do
    child:set_y(math.ceil(h))
    h = h + child:h()
  end
  l_7_1:set_h(h)
  return h
end

FriendsBoxGui._create_text_box = function(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4, l_8_5)
  FriendsBoxGui.super._create_text_box(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4, l_8_5)
  local friends_panel = l_8_0._scroll_panel:panel({name = "friends_panel", x = 0, h = 600, layer = 1})
  local ingame_panel = friends_panel:panel({name = "ingame_panel", x = 0, h = 100, layer = 0})
  local online_panel = friends_panel:panel({name = "online_panel", x = 0, h = 100, layer = 0})
  local offline_panel = friends_panel:panel({name = "offline_panel", x = 0, h = 100, layer = 0})
  local h = 0
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local ingame_text = friends_panel:text({name = "ingame_text", text = managers.localization:text("menu_ingame"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size})
  local _, _, tw, th = ingame_text:text_rect()
  ingame_text:set_size(tw, th)
  {name = "ingame_text", text = managers.localization:text("menu_ingame"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size}.color, {name = "ingame_text", text = managers.localization:text("menu_ingame"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size}.hvertical, {name = "ingame_text", text = managers.localization:text("menu_ingame"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size}.vertical, {name = "ingame_text", text = managers.localization:text("menu_ingame"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size}.halign, {name = "ingame_text", text = managers.localization:text("menu_ingame"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size}.align, {name = "ingame_text", text = managers.localization:text("menu_ingame"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size}.y = Color(0.75, 0.75, 0.75), "center", "center", "left", "left", h
  h = h + th
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local online_text = friends_panel:text({name = "online_text", text = managers.localization:text("menu_online"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size})
  local _, _, tw, th = online_text:text_rect()
  online_text:set_size(tw, th)
  {name = "online_text", text = managers.localization:text("menu_online"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size}.color, {name = "online_text", text = managers.localization:text("menu_online"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size}.hvertical, {name = "online_text", text = managers.localization:text("menu_online"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size}.vertical, {name = "online_text", text = managers.localization:text("menu_online"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size}.halign, {name = "online_text", text = managers.localization:text("menu_online"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size}.align, {name = "online_text", text = managers.localization:text("menu_online"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size}.y = Color(0.75, 0.75, 0.75), "center", "center", "left", "left", h
  h = h + th
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local offline_text = friends_panel:text({name = "offline_text", text = managers.localization:text("menu_offline"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size})
  local _, _, tw, th = offline_text:text_rect()
  offline_text:set_size(tw, th)
  {name = "offline_text", text = managers.localization:text("menu_offline"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size}.color, {name = "offline_text", text = managers.localization:text("menu_offline"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size}.hvertical, {name = "offline_text", text = managers.localization:text("menu_offline"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size}.vertical, {name = "offline_text", text = managers.localization:text("menu_offline"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size}.halign, {name = "offline_text", text = managers.localization:text("menu_offline"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size}.align, {name = "offline_text", text = managers.localization:text("menu_offline"), font = tweak_data.menu.default_font, font_size = l_8_0._topic_state_font_size}.y = Color(0.75, 0.75, 0.75), "center", "center", "left", "left", h
  h = h + th
  friends_panel:set_h(h)
  l_8_0._scroll_panel:set_h(math.max(l_8_0._scroll_panel:h(), friends_panel:h()))
  l_8_0:_set_scroll_indicator()
  l_8_0:_layout_friends_panel()
end

FriendsBoxGui._create_user = function(l_9_0, l_9_1, l_9_2, l_9_3, l_9_4, l_9_5, l_9_6)
  if (l_9_4 ~= "online" or not l_9_0._online_color) and (l_9_4 ~= "ingame" or not l_9_0._ingame_color) then
    local color = l_9_0._offline_color
  end
  local panel = l_9_1:panel({name = l_9_3:id(), y = l_9_2, layer = 0})
  local texture, rect = tweak_data.hud_icons:get_icon_data(table.random({"mask_clown", "mask_alien"}) .. math.random(4))
  local avatar = panel:bitmap({name = "avatar", visible = true, texture = texture, texture_rect = rect, layer = 0, x = 0, y = 0})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local user_name = panel:text({name = "user_name", text = l_9_3:name(), font = tweak_data.menu.default_font, font_size = l_9_0._default_font_size, x = 16 + avatar:right(), y = 0, align = "left", halign = "left"})
  local _, _, tw, th = user_name:text_rect()
  user_name:set_size(tw, th)
  {name = "user_name", text = l_9_3:name(), font = tweak_data.menu.default_font, font_size = l_9_0._default_font_size, x = 16 + avatar:right(), y = 0, align = "left", halign = "left"}.layer, {name = "user_name", text = l_9_3:name(), font = tweak_data.menu.default_font, font_size = l_9_0._default_font_size, x = 16 + avatar:right(), y = 0, align = "left", halign = "left"}.color, {name = "user_name", text = l_9_3:name(), font = tweak_data.menu.default_font, font_size = l_9_0._default_font_size, x = 16 + avatar:right(), y = 0, align = "left", halign = "left"}.hvertical, {name = "user_name", text = l_9_3:name(), font = tweak_data.menu.default_font, font_size = l_9_0._default_font_size, x = 16 + avatar:right(), y = 0, align = "left", halign = "left"}.vertical = 0, color, "center", "center"
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local user_level = panel:text({name = "user_level", text = l_9_6, font = tweak_data.menu.small_font_noshadow, font_size = tweak_data.menu.small_font_size, x = 16, y = math.round(0), align = "right", halign = "right", vertical = "center", hvertical = "center", blend_mode = "normal", color = color})
  local _, _, sw, sh = user_level:text_rect()
  user_level:set_size(sw, sh)
  {name = "user_level", text = l_9_6, font = tweak_data.menu.small_font_noshadow, font_size = tweak_data.menu.small_font_size, x = 16, y = math.round(0), align = "right", halign = "right", vertical = "center", hvertical = "center", blend_mode = "normal", color = color}.visible, {name = "user_level", text = l_9_6, font = tweak_data.menu.small_font_noshadow, font_size = tweak_data.menu.small_font_size, x = 16, y = math.round(0), align = "right", halign = "right", vertical = "center", hvertical = "center", blend_mode = "normal", color = color}.layer = l_9_4 ~= "offline", 0
  user_level:set_right(math.floor(panel:w()))
  user_level:set_center_y(math.round(user_name:center_y()))
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local user_state = panel:text({name = "user_state", text = string.upper(l_9_5), font = tweak_data.menu.small_font_noshadow, font_size = tweak_data.menu.small_font_size, x = 16 + avatar:right(), y = math.round(0 + th), align = "left", halign = "left", vertical = "center", hvertical = "center", blend_mode = "normal", color = color})
  local _, _, sw, sh = user_state:text_rect()
  user_state:set_size(sw, sh)
  {name = "user_state", text = string.upper(l_9_5), font = tweak_data.menu.small_font_noshadow, font_size = tweak_data.menu.small_font_size, x = 16 + avatar:right(), y = math.round(0 + th), align = "left", halign = "left", vertical = "center", hvertical = "center", blend_mode = "normal", color = color}.visible, {name = "user_state", text = string.upper(l_9_5), font = tweak_data.menu.small_font_noshadow, font_size = tweak_data.menu.small_font_size, x = 16 + avatar:right(), y = math.round(0 + th), align = "left", halign = "left", vertical = "center", hvertical = "center", blend_mode = "normal", color = color}.layer = l_9_4 ~= "offline", 0
  panel:set_h(th + sh + 4)
  panel:rect({name = "marker_rect", color = Color(0.5, 0.5, 0.5, 0.5), layer = -1, visible = false})
  local texture, rect = tweak_data.hud_icons:get_icon_data("icon_equipped")
  local arrow = panel:bitmap({name = "arrow", visible = false, texture = texture, texture_rect = rect, layer = 0, x = avatar:right()})
  arrow:set_center_y(user_name:center_y())
  local texture, rect = tweak_data.hud_icons:get_icon_data("icon_addon")
  local lobby = panel:bitmap({name = "lobby", visible = false, texture = texture, texture_rect = rect, layer = 0})
  lobby:set_center_y(user_state:center_y())
  lobby:set_right(panel:w())
end

FriendsBoxGui.mouse_pressed = function(l_10_0, l_10_1, l_10_2, l_10_3)
  if l_10_0._friend_action_gui and l_10_0._friend_action_gui:visible() and l_10_0._friend_action_gui:in_info_area_focus(l_10_2, l_10_3) then
    if l_10_1 == Idstring("0") then
      local focus_btn_id = l_10_0._friend_action_gui:get_focus_button_id()
      print("get_focus_button_id()", focus_btn_id)
      if focus_btn_id == "join_game" then
        print(" join game ", l_10_0._friend_action_user, l_10_0._friend_action_user:lobby())
        if l_10_0._friend_action_user:lobby() then
          managers.network.matchmake:join_server_with_check(l_10_0._friend_action_user:lobby():id())
        elseif focus_btn_id == "message" then
          l_10_0._friend_action_user:open_overlay("chat")
        elseif focus_btn_id == "view_profile" then
          l_10_0._friend_action_user:open_overlay("steamid")
        elseif focus_btn_id == "view_achievements" then
          l_10_0._friend_action_user:open_overlay("achievements")
        elseif focus_btn_id == "view_stats" then
          l_10_0._friend_action_user:open_overlay("stats")
        elseif focus_btn_id == "view_character" then
          managers.menu:on_view_character(l_10_0._friend_action_user)
        elseif focus_btn_id == "invite" then
          print("send invite")
          if managers.network.matchmake.lobby_handler then
            l_10_0._friend_action_user:invite(managers.network.matchmake.lobby_handler:id())
          end
        end
      end
      l_10_0:_hide_friend_action_user()
    end
    return true
  end
  if l_10_0:in_info_area_focus(l_10_2, l_10_3) and l_10_1 == Idstring("0") then
    local user_panel = l_10_0:_inside_user(l_10_2, l_10_3)
    if user_panel then
      if l_10_0._users[user_panel:name()].current_lobby then
        managers.menu_component:criment_goto_lobby(l_10_0._users[user_panel:name()].lobby)
      end
      if l_10_0._friend_action_user ~= l_10_0._users[user_panel:name()].user then
        l_10_0._friend_action_user = l_10_0._users[user_panel:name()].user
        l_10_0:_create_friend_action_gui_by_user(l_10_0._users[user_panel:name()])
        l_10_2 = l_10_2 + 16
        l_10_3 = l_10_3 - 16
        if l_10_0:x() + l_10_0:w() - 20 < l_10_2 + l_10_0._friend_action_gui:w() then
          l_10_2 = l_10_0:x() + l_10_0:w() - 20 - l_10_0._friend_action_gui:w()
        end
        if l_10_0:y() + l_10_0:h() < l_10_3 + l_10_0._friend_action_gui:h() then
          l_10_3 = l_10_0:y() + l_10_0:h() - l_10_0._friend_action_gui:h()
        end
        l_10_0._friend_action_gui:set_position(l_10_2, l_10_3)
      else
        l_10_0:_hide_friend_action_user()
      end
      return true
    end
  end
  l_10_0:_hide_friend_action_user()
end

FriendsBoxGui._hide_friend_action_user = function(l_11_0)
  l_11_0._friend_action_user = nil
  if l_11_0._friend_action_gui then
    l_11_0._friend_action_gui:set_visible(false)
  end
end

FriendsBoxGui._inside_user = function(l_12_0, l_12_1, l_12_2)
  local friends_panel = l_12_0._scroll_panel:child("friends_panel")
  local ingame_panel = friends_panel:child("ingame_panel")
  local online_panel = friends_panel:child("online_panel")
  local offline_panel = friends_panel:child("offline_panel")
  for _,user_panel in ipairs(ingame_panel:children()) do
    if user_panel:inside(l_12_1, l_12_2) then
      return user_panel
    end
  end
  for _,user_panel in ipairs(online_panel:children()) do
    if user_panel:inside(l_12_1, l_12_2) then
      return user_panel
    end
  end
  for _,user_panel in ipairs(offline_panel:children()) do
    if user_panel:inside(l_12_1, l_12_2) then
      return user_panel
    end
  end
  return nil
end

FriendsBoxGui._get_user_panel = function(l_13_0, l_13_1)
  local friends_panel = l_13_0._scroll_panel:child("friends_panel")
  local ingame_panel = friends_panel:child("ingame_panel")
  local online_panel = friends_panel:child("online_panel")
  local offline_panel = friends_panel:child("offline_panel")
  if not ingame_panel:child(l_13_1) and not online_panel:child(l_13_1) then
    return offline_panel:child(l_13_1)
  end
end

FriendsBoxGui.mouse_moved = function(l_14_0, l_14_1, l_14_2)
  if l_14_0._friend_action_gui and l_14_0._friend_action_gui:visible() and l_14_0._friend_action_gui:in_info_area_focus(l_14_1, l_14_2) then
    l_14_0._friend_action_gui:check_focus_button(l_14_1, l_14_2)
    return 
  end
  local friends_panel = l_14_0._scroll_panel:child("friends_panel")
  l_14_0:_set_user_panels_state(l_14_1, l_14_2, friends_panel:child("ingame_panel"), l_14_0._ingame_color)
  l_14_0:_set_user_panels_state(l_14_1, l_14_2, friends_panel:child("online_panel"), l_14_0._online_color)
  l_14_0:_set_user_panels_state(l_14_1, l_14_2, friends_panel:child("offline_panel"), l_14_0._offline_color)
end

FriendsBoxGui._set_user_panels_state = function(l_15_0, l_15_1, l_15_2, l_15_3, l_15_4)
  for _,user_panel in ipairs(l_15_3:children()) do
    local inside = user_panel:inside(l_15_1, l_15_2)
    user_panel:child("arrow"):set_visible(inside)
    user_panel:child("user_name"):set_color(inside and Color.white or l_15_4)
    user_panel:child("user_state"):set_color(inside and Color.white or l_15_4)
  end
end

FriendsBoxGui._check_scroll_indicator_states = function(l_16_0)
  FriendsBoxGui.super._check_scroll_indicator_states(l_16_0)
end

FriendsBoxGui.set_size = function(l_17_0, l_17_1, l_17_2)
  FriendsBoxGui.super.set_size(l_17_0, l_17_1, l_17_2)
  local friends_panel = l_17_0._scroll_panel:child("friends_panel")
  friends_panel:set_w(l_17_0._scroll_panel:w())
  local f = function(l_1_0, l_1_1)
    l_1_1:set_w(l_1_0:w())
    for _,user_panel in ipairs(l_1_1:children()) do
      user_panel:set_w(l_1_1:w())
      user_panel:child("lobby"):set_right(user_panel:w())
    end
   end
  f(friends_panel, friends_panel:child("ingame_panel"))
  f(friends_panel, friends_panel:child("online_panel"))
  f(friends_panel, friends_panel:child("offline_panel"))
end

FriendsBoxGui.set_visible = function(l_18_0, l_18_1)
  if not l_18_1 then
    l_18_0:_hide_friend_action_user()
  end
  FriendsBoxGui.super.set_visible(l_18_0, l_18_1)
end

FriendsBoxGui.close = function(l_19_0)
  print("FriendsBoxGui:close()")
  FriendsBoxGui.super.close(l_19_0)
  if l_19_0._friend_action_gui then
    l_19_0._friend_action_gui:close()
  end
end


