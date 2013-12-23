-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\setups\menusetup.luac 

require("lib/setups/Setup")
require("lib/network/base/NetworkManager")
require("lib/network/NetworkGame")
require("lib/managers/MoneyManager")
require("lib/managers/ChallengesManager")
require("lib/managers/StatisticsManager")
require("lib/managers/MissionManager")
require("lib/managers/CriminalsManager")
require("lib/units/beings/player/PlayerAnimationData")
require("lib/units/menu/MenuMovement")
require("lib/units/MenuScriptUnitData")
require("lib/units/weapons/MenuRaycastWeaponBase")
require("lib/units/weapons/MenuShotgunBase")
require("lib/units/weapons/MenuSawWeaponBase")
require("lib/units/weapons/WeaponGadgetBase")
require("lib/units/weapons/WeaponFlashLight")
require("lib/units/weapons/WeaponLaser")
core:import("SequenceManager")
if not MenuSetup then
  MenuSetup = class(Setup)
end
MenuSetup.IS_START_MENU = true
MenuSetup.load_packages = function(l_1_0)
  Setup.load_packages(l_1_0)
  if not PackageManager:loaded("packages/start_menu") then
    PackageManager:load("packages/start_menu")
  end
end

MenuSetup.unload_packages = function(l_2_0)
  Setup.unload_packages(l_2_0)
  if not Global.load_start_menu and PackageManager:loaded("packages/start_menu") then
    PackageManager:unload("packages/start_menu")
  end
end

MenuSetup.init_game = function(l_3_0)
  local gsm = Setup.init_game(l_3_0)
  if not Application:editor() then
    local event_id, checkpoint_index, level, level_class_name, mission, world_setting, intro_skipped = nil, nil, nil, nil, nil, nil, nil
    if not Global.exe_arguments_parsed then
      local arg_list = Application:argv()
      for i = 1, #arg_list do
        local arg = arg_list[i]
        if arg == "-event_id" then
          event_id = arg_list[i + 1]
          i = i + 1
        elseif arg == "-checkpoint_index" then
          checkpoint_index = tonumber(arg_list[i + 1])
          i = i + 1
        elseif arg == "-level" then
          level = arg_list[i + 1]
          i = i + 1
        elseif arg == "-class" then
          level_class_name = arg_list[i + 1]
          i = i + 1
        elseif arg == "-mission" then
          mission = arg_list[i + 1]
          i = i + 1
        elseif arg == "-world_setting" then
          world_setting = arg_list[i + 1]
          i = i + 1
        elseif arg == "-skip_intro" then
          game_state_machine:set_boot_intro_done(true)
          intro_skipped = true
        elseif arg == "+connect_lobby" then
          Global.boot_invite = arg_list[i + 1]
        end
      end
      Global.exe_arguments_parsed = true
    end
    if level then
      local preferred_index = managers.controller:get_preferred_default_wrapper_index()
      managers.user:set_index(preferred_index)
      managers.controller:set_default_wrapper_index(preferred_index)
      game_state_machine:set_boot_intro_done(true)
      managers.user:set_active_user_state_change_quit(true)
      managers.network:host_game()
      local level_id = tweak_data.levels:get_level_name_from_world_name(level)
      managers.network:session():load_level(level, mission, world_setting, level_class_name, level_id)
    else
      if game_state_machine:is_boot_intro_done() then
        if game_state_machine:is_boot_from_sign_out() or intro_skipped then
          game_state_machine:change_state_by_name("menu_titlescreen")
        else
          game_state_machine:change_state_by_name("menu_main")
        end
      else
        game_state_machine:change_state_by_name("bootup")
      end
    end
  end
  return gsm
end

MenuSetup.init_managers = function(l_4_0, l_4_1)
  Setup.init_managers(l_4_0, l_4_1)
  l_4_1.sequence:preload()
  l_4_1.menu_scene = MenuSceneManager:new()
  l_4_1.money = MoneyManager:new()
  l_4_1.challenges = ChallengesManager:new()
  l_4_1.statistics = StatisticsManager:new()
  l_4_1.network = NetworkManager:new("NetworkGame")
end

MenuSetup.init_finalize = function(l_5_0)
  Setup.init_finalize(l_5_0)
  if managers.network:session() then
    managers.network:init_finalize()
  end
  if SystemInfo:platform() == Idstring("PS3") then
    if not Global.hdd_space_checked then
      managers.savefile:check_space_required()
      l_5_0.update = l_5_0.update_wait_for_savegame_info
    else
      managers.achievment:chk_install_trophies()
    end
  end
  if managers.music then
    managers.music:init_finalize()
  end
end

MenuSetup.update_wait_for_savegame_info = function(l_6_0, l_6_1, l_6_2)
  managers.savefile:update(l_6_1, l_6_2)
  if managers.savefile:fetch_savegame_hdd_space_required() then
    Application:check_sufficient_hdd_space_to_launch(managers.savefile:fetch_savegame_hdd_space_required(), managers.dlc:has_full_game())
    if SystemInfo:platform() == Idstring("PS3") then
      Trophies:set_translation_text(managers.localization:text("err_load"), managers.localization:text("err_ins"), managers.localization:text("err_disk"))
      managers.achievment:chk_install_trophies()
    end
    Global.hdd_space_checked = true
    l_6_0.update = nil
  end
end

MenuSetup.update = function(l_7_0, l_7_1, l_7_2)
  Setup.update(l_7_0, l_7_1, l_7_2)
  managers.crimenet:update(l_7_1, l_7_2)
  managers.network:update(l_7_1, l_7_2)
end

MenuSetup.paused_update = function(l_8_0, l_8_1, l_8_2)
  Setup.paused_update(l_8_0, l_8_1, l_8_2)
  managers.network:update(l_8_1, l_8_2)
end

MenuSetup.end_update = function(l_9_0, l_9_1, l_9_2)
  Setup.end_update(l_9_0, l_9_1, l_9_2)
  managers.network:end_update()
end

MenuSetup.paused_end_update = function(l_10_0, l_10_1, l_10_2)
  Setup.paused_end_update(l_10_0, l_10_1, l_10_2)
  managers.network:end_update()
end

MenuSetup.destroy = function(l_11_0)
  MenuSetup.super.destroy(l_11_0)
end

return MenuSetup

