-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\menumainstate.luac 

require("lib/states/GameState")
if not MenuMainState then
  MenuMainState = class(GameState)
end
MenuMainState.init = function(l_1_0, l_1_1)
  GameState.init(l_1_0, "menu_main", l_1_1)
end

MenuMainState.at_enter = function(l_2_0, l_2_1)
  managers.platform:set_rich_presence("Idle")
  if l_2_1:name() ~= "freeflight" or not managers.menu:is_active() then
    managers.menu_scene:setup_camera()
    managers.menu_scene:set_scene_template("standard")
    l_2_0._sound_listener = SoundDevice:create_listener("main_menu")
    l_2_0._sound_listener:activate(true)
    managers.menu:open_menu("menu_main")
    managers.music:post_event("menu_music")
    if Global.load_start_menu_lobby then
      if managers.network:session() and (Network:is_server() or managers.network:session():server_peer()) then
        managers.overlay_effect:play_effect({color = Color.black, fade_in = 0, sustain = 0.5, fade_out = 0.5, blend_mode = "normal"})
        managers.menu:external_enter_online_menus()
        managers.menu:on_enter_lobby()
      else
        l_2_0:on_server_left()
      end
    else
      if Global.load_start_menu then
        managers.overlay_effect:play_effect({color = Color.black, fade_in = 0, sustain = 0.25, fade_out = 0.25, blend_mode = "normal"})
      end
    end
  end
  local has_invite = false
  if SystemInfo:platform() == Idstring("PS3") then
    if not Global.boot_invite then
      Global.boot_invite = {}
    end
    if Application:is_booted_from_invitation() and not Global.boot_invite.used then
      has_invite = true
      Global.boot_invite.used = false
      Global.boot_invite.pending = true
      if #PSN:get_world_list() > 0 and PSN:is_online() then
        print("had world list, can join now")
        managers.network.matchmake:join_boot_invite()
      else
        managers.menu:open_ps3_sign_in_menu(managers.menu, function(l_1_0)
        print("success", l_1_0)
         end)
      end
    else
      if SystemInfo:platform() == Idstring("WIN32") and Global.boot_invite then
        has_invite = true
        do
          local lobby = Global.boot_invite
          Global.boot_invite = nil
          managers.network.matchmake:join_server_with_check(lobby)
        end
        do return end
        if SystemInfo:platform() == Idstring("X360") and Global.boot_invite and next(Global.boot_invite) then
          has_invite = true
          managers.network.matchmake:join_boot_invite()
        end
      end
    end
  end
  if Global.open_trial_buy then
    Global.open_trial_buy = nil
    managers.menu:open_node("trial_info")
  elseif not has_invite and not managers.network:session() and not Global.mission_manager.has_played_tutorial then
    local yes_func = function()
    MenuCallbackHandler:play_safehouse({skip_question = true})
   end
    managers.menu:show_question_start_tutorial({yes_func = yes_func})
  end
end

MenuMainState.at_exit = function(l_3_0, l_3_1)
  if l_3_1:name() ~= "freeflight" then
    managers.menu:close_menu("menu_main")
  end
  if l_3_0._sound_listener then
    l_3_0._sound_listener:delete()
    l_3_0._sound_listener = nil
  end
end

MenuMainState.on_server_left = function(l_4_0)
  if managers.network:session() and managers.network:session():has_recieved_ok_to_load_level() then
    return 
  end
  l_4_0:_create_server_left_dialog()
end

MenuMainState._create_server_left_dialog = function(l_5_0)
  local dialog_data = {}
  dialog_data.title = managers.localization:text("dialog_warning_title")
  if not Global.on_server_left_message or not managers.localization:text(Global.on_server_left_message) then
    dialog_data.text = managers.localization:text("dialog_the_host_has_left_the_game")
  end
  Global.on_server_left_message = nil
  dialog_data.id = "server_left_dialog"
  local ok_button = {}
  ok_button.text = managers.localization:text("dialog_ok")
  ok_button.callback_func = callback(l_5_0, l_5_0, "on_server_left_ok_pressed")
  dialog_data.button_list = {ok_button}
  managers.system_menu:show(dialog_data)
end

MenuMainState.on_server_left_ok_pressed = function(l_6_0)
  print("[MenuMainState:on_server_left_ok_pressed]")
  managers.menu:on_leave_lobby()
end

MenuMainState._create_disconnected_dialog = function(l_7_0)
  managers.system_menu:close("server_left_dialog")
  managers.menu:show_mp_disconnected_internet_dialog({ok_func = callback(l_7_0, l_7_0, "on_server_left_ok_pressed")})
end


