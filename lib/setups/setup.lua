-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\setups\setup.luac 

core:register_module("lib/managers/PlatformManager")
core:register_module("lib/managers/SystemMenuManager")
core:register_module("lib/managers/UserManager")
core:register_module("lib/managers/SequenceManager")
core:register_module("lib/managers/ControllerManager")
core:register_module("lib/managers/SlotManager")
core:register_module("lib/managers/DebugManager")
core:register_module("lib/utils/game_state_machine/GameState")
core:register_module("lib/utils/dev/FreeFlight")
Global.DEBUG_MENU_ON = Application:debug_enabled()
core:import("CoreSetup")
require("lib/managers/DLCManager")
managers.dlc = DLCManager:new()
require("lib/tweak_data/TweakData")
if Application:production_build() then
  core:import("DebugManager")
end
require("lib/utils/EventListenerHolder")
require("lib/managers/UpgradesManager")
require("lib/managers/ExperienceManager")
require("lib/managers/PlayerManager")
require("lib/managers/SavefileManager")
require("lib/managers/MenuManager")
require("lib/managers/AchievmentManager")
require("lib/managers/SkillTreeManager")
require("lib/managers/DynamicResourceManager")
core:import("PlatformManager")
core:import("SystemMenuManager")
core:import("UserManager")
core:import("ControllerManager")
core:import("SlotManager")
core:import("FreeFlight")
core:import("CoreGuiDataManager")
require("lib/managers/ControllerWrapper")
require("lib/utils/game_state_machine/GameStateMachine")
require("lib/utils/LightLoadingScreenGuiScript")
require("lib/managers/LocalizationManager")
require("lib/managers/MousePointerManager")
require("lib/managers/VideoManager")
require("lib/managers/menu/TextBoxGui")
require("lib/managers/menu/BookBoxGui")
require("lib/managers/menu/FriendsBoxGui")
require("lib/managers/menu/CircleGuiObject")
require("lib/managers/menu/BoxGuiObject")
require("lib/managers/menu/NewsFeedGui")
require("lib/managers/menu/ImageBoxGui")
require("lib/managers/menu/ProfileBoxGui")
require("lib/managers/menu/ContractBoxGui")
require("lib/managers/menu/ServerStatusBoxGui")
require("lib/managers/menu/DebugStringsBoxGui")
require("lib/managers/menu/DebugDrawFonts")
require("lib/managers/menu/MenuBackdropGUI")
require("lib/managers/WeaponFactoryManager")
require("lib/managers/BlackMarketManager")
require("lib/managers/CrimeNetManager")
require("lib/managers/LootDropManager")
require("lib/managers/ChatManager")
require("lib/managers/LootManager")
require("lib/managers/JobManager")
require("lib/managers/MissionAssetsManager")
require("lib/managers/VoiceBriefingManager")
require("lib/units/MaskExt")
if not script_data then
  script_data = {}
end
game_state_machine = game_state_machine or nil
if not Setup then
  Setup = class(CoreSetup.CoreSetup)
end
Setup.init_category_print = function(l_1_0)
  CoreSetup.CoreSetup.init_category_print(l_1_0)
  if Global.category_print_initialized.setup then
    return 
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local cat_list = {"dialog_manager", "user_manager", "exec_manager", "savefile_manager", "loading_environment", "player_intel", "player_damage", "player_action", "AI_action", "bt", "dummy_ai", "dummy_block_chance", "johan", "george", "qa", "bob", "sound_placeholder", "spam"}
for _,cat in ipairs(cat_list) do
  Global.category_print[cat] = false
end
catprint_load()
end

Setup.load_packages = function(l_2_0)
  if not PackageManager:loaded("packages/base") then
    PackageManager:load("packages/base")
  end
  if not PackageManager:loaded("packages/dyn_resources") then
    PackageManager:load("packages/dyn_resources")
  end
end

Setup.init_managers = function(l_3_0, l_3_1)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
Global.game_settings = {level_id = Global.game_settings or "bank", difficulty = "normal", permission = "public", team_ai = true, reputation_permission = 0, drop_in_allowed = true}
l_3_1.dyn_resource = DynamicResourceManager:new()
l_3_1.gui_data = CoreGuiDataManager.GuiDataManager:new()
l_3_1.platform = PlatformManager.PlatformManager:new()
l_3_1.system_menu = SystemMenuManager.SystemMenuManager:new()
l_3_1.achievment = AchievmentManager:new()
l_3_1.savefile = SavefileManager:new()
l_3_1.user = UserManager.UserManager:new()
l_3_1.upgrades = UpgradesManager:new()
l_3_1.experience = ExperienceManager:new()
l_3_1.skilltree = SkillTreeManager:new()
l_3_1.player = PlayerManager:new()
l_3_1.video = VideoManager:new()
l_3_1.menu = MenuManager:new(l_3_0.IS_START_MENU)
l_3_1.subtitle:set_presenter(CoreSubtitlePresenter.OverlayPresenter:new(tweak_data.menu.pd2_medium_font, tweak_data.menu.pd2_medium_font_size))
l_3_1.mouse_pointer = MousePointerManager:new()
l_3_1.weapon_factory = WeaponFactoryManager:new()
l_3_1.blackmarket = BlackMarketManager:new()
l_3_1.crimenet = CrimeNetManager:new()
l_3_1.lootdrop = LootDropManager:new()
l_3_1.chat = ChatManager:new()
l_3_1.menu_component = MenuComponentManager:new()
l_3_1.loot = LootManager:new()
l_3_1.job = JobManager:new()
l_3_1.assets = MissionAssetsManager:new()
l_3_1.briefing = VoiceBriefingManager:new()
game_state_machine = GameStateMachine:new()
end

Setup.start_boot_loading_screen = function(l_4_0)
  if not PackageManager:loaded("packages/boot_screen") then
    PackageManager:load("packages/boot_screen")
  end
  l_4_0:_start_loading_screen()
end

Setup.start_loading_screen = function(l_5_0)
  l_5_0:_start_loading_screen()
end

Setup.stop_loading_screen = function(l_6_0)
  if Global.is_loading then
    cat_print("loading_environment", "[LoadingEnvironment] Stop.")
    l_6_0:set_main_thread_loading_screen_visible(false)
    LoadingEnvironment:stop()
    Global.is_loading = nil
  else
    Application:stack_dump_error("[LoadingEnvironment] Tried to stop loading screen when it wasn't started.")
  end
end

Setup._start_loading_screen = function(l_7_0)
  if Global.is_loading then
    Application:stack_dump_error("[LoadingEnvironment] Tried to start loading screen when it was already started.")
    return 
  else
    if not SystemInfo:threaded_renderer() then
      cat_print("loading_environment", "[LoadingEnvironment] Skipped (renderer is not threaded).")
      Global.is_loading = true
      return 
    end
  end
  cat_print("loading_environment", "[LoadingEnvironment] Start.")
  local setup = nil
  if not LoadingEnvironmentScene:loaded() then
    LoadingEnvironmentScene:load("levels/zone")
  end
  local load_level_data = nil
  if Global.load_level then
    if not PackageManager:loaded("packages/load_level") then
      PackageManager:load("packages/load_level")
    end
    setup = "lib/setups/LevelLoadingSetup"
    load_level_data = {}
    load_level_data.level_data = Global.level_data
    if not tweak_data.levels[Global.level_data.level_id] then
      load_level_data.level_tweak_data = {}
    end
    if load_level_data.level_tweak_data.name_id then
      load_level_data.level_tweak_data.name = managers.localization:text(load_level_data.level_tweak_data.name_id)
    end
    load_level_data.gui_tweak_data = tweak_data.load_level
    load_level_data.menu_tweak_data = tweak_data.menu
    load_level_data.scale_tweak_data = tweak_data.scale
    load_level_data.tip_id = tweak_data.tips:get_a_tip()
    load_level_data.controller_coords = tweak_data:get_controller_help_coords()
    if load_level_data.controller_coords then
      for id,data in pairs(load_level_data.controller_coords) do
        data.string = managers.localization:to_upper_text(id)
      end
    end
    local load_data = load_level_data.level_tweak_data.load_data
    Global.current_load_package = load_data and load_data.package or "packages/load_default"
    if Global.current_load_package then
      PackageManager:load(Global.current_load_package)
    end
    local challenges = managers.challenges:get_near_completion()
    load_level_data.challenges = {challenges[1], challenges[2], challenges[3]}
    local safe_rect_pixels = managers.viewport:get_safe_rect_pixels()
    local safe_rect = managers.viewport:get_safe_rect()
    local aspect_ratio = managers.viewport:aspect_ratio()
    local res = RenderSettings.resolution
    load_level_data.gui_data = {safe_rect_pixels = safe_rect_pixels, safe_rect = safe_rect, aspect_ratio = aspect_ratio, res = res, workspace_size = {x = 0, y = 0, w = res.x, h = res.y}, saferect_size = {x = safe_rect.x, y = safe_rect.y, w = safe_rect.width, h = safe_rect.height}, bg_texture = load_data and load_data.image or "guis/textures/loading/loading_bg"}
  else
    if not Global.boot_loading_environment_done then
      setup = "lib/setups/LightLoadingSetup"
    else
      setup = "lib/setups/HeavyLoadingSetup"
    end
  end
  l_7_0:_setup_loading_environment()
  local data = {res = RenderSettings.resolution, layer = tweak_data.gui.LOADING_SCREEN_LAYER, load_level_data = load_level_data, is_win32 = SystemInfo:platform() == Idstring("WIN32")}
  LoadingEnvironment:start(setup, "LoadingEnvironmentScene", data)
  Global.is_loading = true
end

Setup._setup_loading_environment = function(l_8_0)
  {ambient_color = Vector3(1, 1, 1), ambient_scale = 1, ambient_falloff_scale = 0, ambient_view_falloff_sharpness = 0, sky_top_color = Vector3(0, 0, 0), sky_bottom_color = Vector3(0, 0, 0), sky_reflection_top_color = Vector3(0, 0, 0), sky_reflection_bottom_color = Vector3(0, 0, 0), sun_specular_color = Vector3(0, 0, 0), height_fade = Vector3(25000, 25000, 0), height_fade_intesity_clamp = Vector3(1, 1, 0), environment_map_intensity = 0}.environment_map_intensity_shadow = 0
   -- DECOMPILER ERROR: Confused about usage of registers!

  {ambient_color = Vector3(1, 1, 1), ambient_scale = 1, ambient_falloff_scale = 0, ambient_view_falloff_sharpness = 0, sky_top_color = Vector3(0, 0, 0), sky_bottom_color = Vector3(0, 0, 0), sky_reflection_top_color = Vector3(0, 0, 0), sky_reflection_bottom_color = Vector3(0, 0, 0), sun_specular_color = Vector3(0, 0, 0), height_fade = Vector3(25000, 25000, 0), height_fade_intesity_clamp = Vector3(1, 1, 0), environment_map_intensity = 0}.effect_light_scale = 0
   -- DECOMPILER ERROR: Confused about usage of registers!

  {start_color = Vector3(0, 0, 0), color0 = Vector3(0, 0, 0), alpha0 = 0, color1 = Vector3(0, 0, 0)}.alpha1 = 0
   -- DECOMPILER ERROR: Confused about usage of registers!

  {start_color = Vector3(0, 0, 0), color0 = Vector3(0, 0, 0), alpha0 = 0, color1 = Vector3(0, 0, 0)}.color2 = Vector3(0, 0, 0)
   -- DECOMPILER ERROR: Confused about usage of registers!

  {start_color = Vector3(0, 0, 0), color0 = Vector3(0, 0, 0), alpha0 = 0, color1 = Vector3(0, 0, 0)}.start = 0
   -- DECOMPILER ERROR: Confused about usage of registers!

  {start_color = Vector3(0, 0, 0), color0 = Vector3(0, 0, 0), alpha0 = 0, color1 = Vector3(0, 0, 0)}.end0 = 1000000
   -- DECOMPILER ERROR: Confused about usage of registers!

  {start_color = Vector3(0, 0, 0), color0 = Vector3(0, 0, 0), alpha0 = 0, color1 = Vector3(0, 0, 0)}.end1 = 1000000
   -- DECOMPILER ERROR: Confused about usage of registers!

  {start_color = Vector3(0, 0, 0), color0 = Vector3(0, 0, 0), alpha0 = 0, color1 = Vector3(0, 0, 0)}.end2 = 1000000
   -- DECOMPILER ERROR: Confused about usage of registers!

  local env_map = {hdr_post_processor = {tone_mapping = {disable_tone_mapping = 1, copy_luminance_target = 0, luminance_clamp = Vector3(0, 0, 0), white_luminance = 0, middle_grey = 0, dark_to_bright_adaption_speed = 0, bright_to_dark_adaption_speed = 0}, radial_blur = {world_pos = Vector3(0, 0, 0), kernel_size = 16, falloff_exponent = 1, opacity = 0}, light_adaption = {disable_tone_mapping = 1, copy_luminance_target = 0, luminance_clamp = Vector3(0, 0, 0), white_luminance = 0, middle_grey = 0, dark_to_bright_adaption_speed = 0, bright_to_dark_adaption_speed = 0}, bloom_brightpass = {disable_tone_mapping = 1, middle_grey = 0, white_luminance = 0, threshold = 0}, exposure_sepia_levels = {disable_tone_mapping = 1, copy_luminance_target = 0, luminance_clamp = Vector3(0, 0, 0), white_luminance = 0, middle_grey = 0, dark_to_bright_adaption_speed = 0, bright_to_dark_adaption_speed = 0}, bloom_apply = {opacity = 0}, dof = {near_focus_distance_min = 0, near_focus_distance_max = 0, far_focus_distance_min = 50000, far_focus_distance_max = 50000, clamp = 0}}, deferred = {shadow = {fadeout_blend = 1, shadow_slice_depths = Vector3(800, 1600, 5500), shadow_slice_overlap = Vector3(150, 300, 400), shadow_fadeout = Vector3(16000, 17500, 0), slice0 = Vector3(0, 800, 0), slice1 = Vector3(650, 1600, 0), slice2 = Vector3(1300, 5500, 0), slice3 = Vector3(5100, 17500, 0)}, apply_ambient = {ambient_color = Vector3(1, 1, 1), ambient_scale = 1, ambient_falloff_scale = 0, ambient_view_falloff_sharpness = 0, sky_top_color = Vector3(0, 0, 0), sky_bottom_color = Vector3(0, 0, 0), sky_reflection_top_color = Vector3(0, 0, 0), sky_reflection_bottom_color = Vector3(0, 0, 0), sun_specular_color = Vector3(0, 0, 0), height_fade = Vector3(25000, 25000, 0), height_fade_intesity_clamp = Vector3(1, 1, 0), environment_map_intensity = 0}}, fog_processor = {fog = {start_color = Vector3(0, 0, 0), color0 = Vector3(0, 0, 0), alpha0 = 0, color1 = Vector3(0, 0, 0)}}, shadow_processor = {shadow_modifier = {slice0 = Vector3(0, 800, 0), slice1 = Vector3(650, 1600, 0), slice2 = Vector3(1300, 5500, 0), slice3 = Vector3(5100, 17500, 0), shadow_slice_depths = Vector3(800, 1600, 5500), shadow_slice_overlap = Vector3(150, 300, 400), shadow_fadeout = Vector3(16000, 17500, 0)}}}
  local dummy_vp = Application:create_world_viewport(0, 0, 1, 1)
  LoadingEnvironment:viewport():set_post_processor_effect("World", Idstring("hdr_post_processor"), Idstring("empty"))
  LoadingEnvironment:viewport():set_post_processor_effect("World", Idstring("bloom_combine_post_processor"), Idstring("bloom_combine_empty"))
  Application:destroy_viewport(dummy_vp)
end

Setup.init_game = function(l_9_0)
  if not Global.initialized then
    Global.level_data = {}
    Global.initialized = true
  end
  l_9_0._end_frame_clbks = {}
  local scene_gui = Overlay:gui()
  l_9_0._main_thread_loading_screen_gui_script = LightLoadingScreenGuiScript:new(scene_gui, RenderSettings.resolution, -1, tweak_data.gui.LOADING_SCREEN_LAYER, SystemInfo:platform() == Idstring("WIN32"))
  l_9_0._main_thread_loading_screen_gui_visible = true
  return game_state_machine
end

Setup.init_finalize = function(l_10_0)
  game_state_machine:init_finilize()
  managers.dlc:init_finalize()
  managers.system_menu:init_finalize()
  managers.controller:init_finalize()
  if Application:editor() then
    managers.user:init_finalize()
  end
  managers.player:aquire_default_upgrades()
  managers.blackmarket:init_finalize()
  managers.assets:init_finalize()
end

Setup.update = function(l_11_0, l_11_1, l_11_2)
  local main_t, main_dt = TimerManager:main():time(), TimerManager:main():delta_time()
  managers.weapon_factory:update(l_11_1, l_11_2)
  managers.platform:update(l_11_1, l_11_2)
  managers.dyn_resource:update()
  managers.system_menu:update(main_t, main_dt)
  managers.savefile:update(l_11_1, l_11_2)
  managers.menu:update(main_t, main_dt)
  managers.player:update(l_11_1, l_11_2)
  managers.blackmarket:update(l_11_1, l_11_2)
  game_state_machine:update(l_11_1, l_11_2)
  if l_11_0._main_thread_loading_screen_gui_visible then
    l_11_0._main_thread_loading_screen_gui_script:update(-1, l_11_2)
  end
end

Setup.paused_update = function(l_12_0, l_12_1, l_12_2)
  managers.platform:paused_update(l_12_1, l_12_2)
  managers.dyn_resource:update()
  managers.system_menu:paused_update(l_12_1, l_12_2)
  managers.savefile:paused_update(l_12_1, l_12_2)
  managers.menu:update(l_12_1, l_12_2)
  managers.blackmarket:update(l_12_1, l_12_2)
  game_state_machine:paused_update(l_12_1, l_12_2)
end

Setup.end_update = function(l_13_0, l_13_1, l_13_2)
  game_state_machine:end_update(l_13_1, l_13_2)
  repeat
    if #l_13_0._end_frame_clbks > 0 then
      table.remove(l_13_0._end_frame_clbks, 1)()
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

Setup.paused_end_update = function(l_14_0, l_14_1, l_14_2)
  game_state_machine:end_update(l_14_1, l_14_2)
  repeat
    if #l_14_0._end_frame_clbks > 0 then
      table.remove(l_14_0._end_frame_clbks, 1)()
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

Setup.end_frame = function(l_15_0, l_15_1, l_15_2)
  repeat
    if l_15_0._end_frame_callbacks and #l_15_0._end_frame_callbacks > 0 then
      table.remove(l_15_0._end_frame_callbacks)()
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

Setup.add_end_frame_callback = function(l_16_0, l_16_1)
  if not l_16_0._end_frame_callbacks then
    l_16_0._end_frame_callbacks = {}
  end
  table.insert(l_16_0._end_frame_callbacks, l_16_1)
end

Setup.add_end_frame_clbk = function(l_17_0, l_17_1)
  table.insert(l_17_0._end_frame_clbks, l_17_1)
end

Setup.destroy = function(l_18_0)
  managers.system_menu:destroy()
  managers.menu:destroy()
  if l_18_0._main_thread_loading_screen_gui_script then
    l_18_0._main_thread_loading_screen_gui_script:destroy()
    l_18_0._main_thread_loading_screen_gui_script = nil
  end
end

Setup.load_level = function(l_19_0, l_19_1, l_19_2, l_19_3, l_19_4, l_19_5)
  managers.menu:close_all_menus()
  Global.load_level = true
  Global.load_start_menu = false
  Global.load_start_menu_lobby = false
  Global.level_data.level = l_19_1
  Global.level_data.mission = l_19_2
  Global.level_data.world_setting = l_19_3
  Global.level_data.level_class_name = l_19_4
  Global.level_data.level_id = l_19_5
  l_19_0:exec(l_19_1)
end

Setup.load_start_menu_lobby = function(l_20_0)
  l_20_0:load_start_menu()
  Global.load_start_menu_lobby = true
end

Setup.load_start_menu = function(l_21_0)
  managers.job:deactivate_current_job()
  managers.menu:close_all_menus()
  managers.mission:pre_destroy()
  Global.load_level = false
  Global.load_start_menu = true
  Global.load_start_menu_lobby = false
  Global.level_data.level = nil
  Global.level_data.mission = nil
  Global.level_data.world_setting = nil
  Global.level_data.level_class_name = nil
  Global.level_data.level_id = nil
  l_21_0:exec(nil)
end

Setup.exec = function(l_22_0, l_22_1)
  if not managers.system_menu:is_active() then
    l_22_0:set_main_thread_loading_screen_visible(true)
  end
  CoreSetup.CoreSetup.exec(l_22_0, l_22_1)
end

Setup.quit = function(l_23_0)
  CoreSetup.CoreSetup.quit(l_23_0)
  if not managers.system_menu:is_active() then
    l_23_0:set_main_thread_loading_screen_visible(true)
    l_23_0._main_thread_loading_screen_gui_script:set_text("Exiting")
  end
end

Setup.restart = function(l_24_0)
  local data = Global.level_data
  if data.level then
    l_24_0:load_level(data.level, data.mission, data.world_setting, data.level_class_name)
  else
    l_24_0:load_start_menu()
  end
end

Setup.block_exec = function(l_25_0)
  if not l_25_0._main_thread_loading_screen_gui_visible then
    l_25_0:set_main_thread_loading_screen_visible(true)
    return true
  end
  if not managers.network:is_ready_to_load() then
    print("BLOCKED BY STOPPING NETWORK")
    return true
  end
  if not managers.dyn_resource:is_ready_to_close() then
    print("BLOCKED BY DYNAMIC RESOURCE MANAGER")
    return true
  end
  if managers.system_menu:block_exec() or managers.savefile:is_active() then
    return true
  else
    return false
  end
end

Setup.block_quit = function(l_26_0)
  return l_26_0:block_exec()
end

Setup.set_main_thread_loading_screen_visible = function(l_27_0, l_27_1)
  if not l_27_0._main_thread_loading_screen_gui_visible ~= not l_27_1 then
    cat_print("loading_environment", "[LoadingEnvironment] Main thread loading screen visible: " .. tostring(l_27_1))
    l_27_0._main_thread_loading_screen_gui_script:set_visible(l_27_1, RenderSettings.resolution)
    l_27_0._main_thread_loading_screen_gui_visible = l_27_1
  end
end

Setup.set_fps_cap = function(l_28_0, l_28_1)
  if not l_28_0._framerate_low then
    Application:cap_framerate(l_28_1)
  end
end


