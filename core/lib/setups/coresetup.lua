-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\setups\coresetup.luac 

core:import("CoreClass")
core:import("CoreEngineAccess")
core:import("CoreLocalizationManager")
core:import("CoreNewsReportManager")
core:import("CoreSubtitleManager")
core:import("CoreViewportManager")
core:import("CoreSequenceManager")
core:import("CoreMissionManager")
core:import("CoreControllerManager")
core:import("CoreListenerManager")
core:import("CoreSlotManager")
core:import("CoreCameraManager")
core:import("CoreExpressionManager")
core:import("CoreShapeManager")
core:import("CorePortalManager")
core:import("CoreDOFManager")
core:import("CoreRumbleManager")
core:import("CoreOverlayEffectManager")
core:import("CoreSessionManager")
core:import("CoreInputManager")
core:import("CoreGTextureManager")
core:import("CoreSmoketestManager")
core:import("CoreEnvironmentAreaManager")
core:import("CoreEnvironmentEffectsManager")
core:import("CoreSlaveManager")
core:import("CoreHelperUnitManager")
require("core/lib/managers/cutscene/CoreCutsceneManager")
require("core/lib/managers/CoreWorldCameraManager")
require("core/lib/managers/CoreSoundEnvironmentManager")
require("core/lib/managers/CoreMusicManager")
require("core/lib/utils/dev/editor/WorldHolder")
require("core/lib/managers/CoreEnvironmentControllerManager")
require("core/lib/units/CoreSpawnSystem")
require("core/lib/units/CoreUnitDamage")
require("core/lib/units/CoreEditableGui")
require("core/lib/units/data/CoreScriptUnitData")
require("core/lib/units/data/CoreWireData")
require("core/lib/units/data/CoreCutsceneData")
if Application:ews_enabled() then
  core:import("CoreLuaProfilerViewer")
  core:import("CoreDatabaseManager")
  core:import("CoreToolHub")
  core:import("CoreInteractionEditor")
  core:import("CoreInteractionEditorConfig")
  require("core/lib/utils/dev/tools/CoreUnitReloader")
  require("core/lib/utils/dev/tools/CoreUnitTestBrowser")
  require("core/lib/utils/dev/tools/CoreEnvEditor")
  require("core/lib/utils/dev/tools/CoreDatabaseBrowser")
  require("core/lib/utils/dev/tools/CoreLuaProfiler")
  require("core/lib/utils/dev/tools/CoreXMLEditor")
  require("core/lib/utils/dev/ews/CoreEWSDeprecated")
  require("core/lib/utils/dev/tools/CorePuppeteer")
  require("core/lib/utils/dev/tools/material_editor/CoreMaterialEditor")
  require("core/lib/utils/dev/tools/particle_editor/CoreParticleEditor")
  require("core/lib/utils/dev/tools/cutscene_editor/CoreCutsceneEditor")
end
if Application:production_build() then
  core:import("CoreDebugManager")
  core:import("CorePrefHud")
end
if Global.DEBUG_MENU_ON or Application:production_build() then
  core:import("CoreFreeFlight")
end
if Application:editor() then
  require("core/lib/utils/dev/editor/CoreEditor")
end
if not CoreSetup then
  CoreSetup = class()
end
local _CoreSetup = CoreSetup
CoreSetup.init = function(l_1_0)
  CoreClass.close_override()
  l_1_0.__quit = false
  l_1_0.__exec = false
  l_1_0.__context = nil
  l_1_0.__firstupdate = true
end

CoreSetup.init_category_print = function(l_2_0)
end

CoreSetup.load_packages = function(l_3_0)
end

CoreSetup.unload_packages = function(l_4_0)
end

CoreSetup.start_boot_loading_screen = function(l_5_0)
end

CoreSetup.init_managers = function(l_6_0, l_6_1)
end

CoreSetup.init_toolhub = function(l_7_0, l_7_1)
end

CoreSetup.init_game = function(l_8_0)
end

CoreSetup.init_finalize = function(l_9_0)
end

CoreSetup.start_loading_screen = function(l_10_0)
end

CoreSetup.stop_loading_screen = function(l_11_0)
end

CoreSetup.update = function(l_12_0, l_12_1, l_12_2)
end

CoreSetup.paused_update = function(l_13_0, l_13_1, l_13_2)
end

CoreSetup.render = function(l_14_0)
end

CoreSetup.end_frame = function(l_15_0, l_15_1, l_15_2)
end

CoreSetup.end_update = function(l_16_0, l_16_1, l_16_2)
end

CoreSetup.paused_end_update = function(l_17_0, l_17_1, l_17_2)
end

CoreSetup.save = function(l_18_0, l_18_1)
end

CoreSetup.load = function(l_19_0, l_19_1)
end

CoreSetup.destroy = function(l_20_0)
end

CoreSetup.freeflight = function(l_21_0)
  return l_21_0.__freeflight
end

CoreSetup.exec = function(l_22_0, l_22_1)
  l_22_0.__exec = true
  l_22_0.__context = l_22_1
end

CoreSetup.quit = function(l_23_0)
  if not Application:editor() then
    l_23_0.__quit = true
  end
end

CoreSetup.block_exec = function(l_24_0)
  return false
end

CoreSetup.block_quit = function(l_25_0)
  return false
end

CoreSetup.__pre_init = function(l_26_0)
  if Application:editor() then
    managers.global_texture = CoreGTextureManager.GTextureManager:new()
    local frame_resolution = SystemInfo:desktop_resolution()
    local appwin_resolution = Vector3(frame_resolution.x * 0.75, frame_resolution.y * 0.75, 0)
    local frame = EWS:Frame("World Editor", Vector3(0, 0, 0), frame_resolution, "CAPTION,CLOSE_BOX,MINIMIZE_BOX,MAXIMIZE_BOX,MAXIMIZE,SYSTEM_MENU,RESIZE_BORDER")
    frame:set_icon(CoreEWS.image_path("world_editor_16x16.png"))
    local frame_panel = EWS:Panel(frame, "", "")
    local appwin = EWS:AppWindow(frame_panel, appwin_resolution, "SUNKEN_BORDER")
    appwin:set_max_size(Vector3(-1, -1, 0))
    appwin:connect("EVT_LEAVE_WINDOW", callback(nil, _G, "leaving_window"))
    appwin:connect("EVT_ENTER_WINDOW", callback(nil, _G, "entering_window"))
    appwin:connect("EVT_KILL_FOCUS", callback(nil, _G, "kill_focus"))
    Application:set_ews_window(appwin)
    local top_sizer = EWS:BoxSizer("VERTICAL")
    local main_sizer = EWS:BoxSizer("HORIZONTAL")
    local left_toolbar_sizer = EWS:BoxSizer("VERTICAL")
    main_sizer:add(left_toolbar_sizer, 0, 0, "EXPAND")
    local app_sizer = EWS:BoxSizer("VERTICAL")
    main_sizer:add(app_sizer, 4, 0, "EXPAND")
    app_sizer:add(appwin, 5, 0, "EXPAND")
    top_sizer:add(main_sizer, 1, 0, "EXPAND")
    frame_panel:set_sizer(top_sizer)
    Global.main_sizer = main_sizer
    Global.v_sizer = app_sizer
    Global.frame = frame
    Global.frame_panel = frame_panel
    Global.application_window = appwin
    Global.left_toolbar_sizer = left_toolbar_sizer
  end
end

CoreSetup.__init = function(l_27_0)
  l_27_0:init_category_print()
  if not PackageManager:loaded("core/packages/base") then
    PackageManager:load("core/packages/base")
  end
  if Application:ews_enabled() and not PackageManager:loaded("core/packages/editor") then
    PackageManager:load("core/packages/editor")
  end
  if Application:production_build() and not PackageManager:loaded("core/packages/debug") then
    PackageManager:load("core/packages/debug")
  end
  if not managers.global_texture then
    managers.global_texture = CoreGTextureManager.GTextureManager:new()
  end
  if not Global.__coresetup_bootdone then
    l_27_0:start_boot_loading_screen()
    Global.__coresetup_bootdone = true
  end
  l_27_0:load_packages()
  World:set_raycast_bounds(Vector3(-50000, -80000, -20000), Vector3(90000, 50000, 30000))
  World:load(Application:editor() and "core/levels/editor/editor" or "core/levels/zone")
  min_exe_version("1.0.0.7000", "Core Systems")
  rawset(_G, "UnitDamage", rawget(_G, "UnitDamage") or CoreUnitDamage)
  rawset(_G, "EditableGui", rawget(_G, "EditableGui") or CoreEditableGui)
  local aspect_ratio = nil
  if Application:editor() then
    local frame_resolution = SystemInfo:desktop_resolution()
    aspect_ratio = frame_resolution.x / frame_resolution.y
  else
    if SystemInfo:platform() == Idstring("WIN32") then
      aspect_ratio = RenderSettings.aspect_ratio
      if aspect_ratio == 0 then
        aspect_ratio = RenderSettings.resolution.x / RenderSettings.resolution.y
      else
        if SystemInfo:platform() == Idstring("X360") or SystemInfo:platform() == Idstring("PS3") and SystemInfo:widescreen() then
          aspect_ratio = RenderSettings.resolution.x / RenderSettings.resolution.y
        else
          aspect_ratio = RenderSettings.resolution.x / RenderSettings.resolution.y
        end
      end
    end
  end
  if Application:ews_enabled() then
    managers.database = CoreDatabaseManager.DatabaseManager:new()
  end
  managers.localization = CoreLocalizationManager.LocalizationManager:new()
  managers.controller = CoreControllerManager.ControllerManager:new()
  managers.slot = CoreSlotManager.SlotManager:new()
  managers.listener = CoreListenerManager.ListenerManager:new()
  managers.viewport = CoreViewportManager.ViewportManager:new(aspect_ratio)
  managers.mission = CoreMissionManager.MissionManager:new()
  managers.expression = CoreExpressionManager.ExpressionManager:new()
  managers.worldcamera = CoreWorldCameraManager:new()
  managers.environment_effects = CoreEnvironmentEffectsManager.EnvironmentEffectsManager:new()
  managers.shape = CoreShapeManager.ShapeManager:new()
  managers.portal = CorePortalManager.PortalManager:new()
  managers.sound_environment = CoreSoundEnvironmentManager:new()
  managers.environment_area = CoreEnvironmentAreaManager.EnvironmentAreaManager:new()
  managers.cutscene = CoreCutsceneManager:new()
  managers.rumble = CoreRumbleManager.RumbleManager:new()
  managers.DOF = CoreDOFManager.DOFManager:new()
  managers.subtitle = CoreSubtitleManager.SubtitleManager:new()
  managers.overlay_effect = CoreOverlayEffectManager.OverlayEffectManager:new()
  managers.sequence = CoreSequenceManager.SequenceManager:new()
  managers.camera = CoreCameraManager.CameraTemplateManager:new()
  managers.slave = CoreSlaveManager.SlaveManager:new()
  managers.music = CoreMusicManager:new()
  managers.environment_controller = CoreEnvironmentControllerManager:new()
  managers.helper_unit = CoreHelperUnitManager.HelperUnitManager:new()
  l_27_0._input = CoreInputManager.InputManager:new()
  l_27_0._session = CoreSessionManager.SessionManager:new(l_27_0.session_factory, l_27_0._input)
  l_27_0._smoketest = CoreSmoketestManager.Manager:new(l_27_0._session:session())
  managers.sequence:internal_load()
  if Application:production_build() then
    managers.prefhud = CorePrefHud.PrefHud:new()
    managers.debug = CoreDebugManager.DebugManager:new()
    rawset(_G, "d", managers.debug)
  end
  l_27_0:init_managers(managers)
  if Application:ews_enabled() then
    managers.news = CoreNewsReportManager.NewsReportManager:new()
    managers.toolhub = CoreToolHub.ToolHub:new()
    managers.toolhub:add("Environment Editor", CoreEnvEditor)
    managers.toolhub:add(CoreMaterialEditor.TOOLHUB_NAME, CoreMaterialEditor)
    managers.toolhub:add("LUA Profiler", CoreLuaProfiler)
    managers.toolhub:add("Particle Editor", CoreParticleEditor)
    managers.toolhub:add(CorePuppeteer.EDITOR_TITLE, CorePuppeteer)
    managers.toolhub:add(CoreCutsceneEditor.EDITOR_TITLE, CoreCutsceneEditor)
    if not Application:editor() then
      managers.toolhub:add("Unit Reloader", CoreUnitReloader)
    end
    l_27_0:init_toolhub(managers.toolhub)
    managers.toolhub:buildmenu()
  end
  l_27_0.__gsm = assert(l_27_0:init_game(), "self:init_game must return a GameStateMachine.")
  if Global.DEBUG_MENU_ON or Application:production_build() then
    l_27_0.__freeflight = CoreFreeFlight.FreeFlight:new(l_27_0.__gsm, managers.viewport, managers.controller)
  end
  if Application:editor() then
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  managers.editor = rawget(_G, "CoreEditor"):new(l_27_0.__gsm, l_27_0._session:session())
  managers.editor:toggle()
end
managers.cutscene:post_init()
l_27_0._smoketest:post_init()
if not Application:editor() then
  PackageManager:unload_lua()
end
l_27_0:init_finalize()
end

CoreSetup.__destroy = function(l_28_0)
  l_28_0:destroy()
  l_28_0.__gsm:destroy()
  managers.global_texture:destroy()
  managers.cutscene:destroy()
  managers.subtitle:destroy()
  managers.viewport:destroy()
  managers.worldcamera:destroy()
  managers.overlay_effect:destroy()
  if Application:ews_enabled() then
    managers.toolhub:destroy()
  end
  if Application:production_build() then
    managers.prefhud:destroy()
    managers.debug:destroy()
  end
  if Application:editor() then
    managers.editor:destroy()
  end
  l_28_0._session:destroy()
  l_28_0._input:destroy()
  l_28_0._smoketest:destroy()
end

CoreSetup.loading_update = function(l_29_0, l_29_1, l_29_2)
end

CoreSetup.__update = function(l_30_0, l_30_1, l_30_2)
  if l_30_0.__firstupdate then
    l_30_0:stop_loading_screen()
    l_30_0.__firstupdate = false
  end
  managers.controller:update(l_30_1, l_30_2)
  managers.cutscene:update()
  managers.sequence:update(l_30_1, l_30_2)
  managers.worldcamera:update(l_30_1, l_30_2)
  managers.environment_effects:update(l_30_1, l_30_2)
  managers.sound_environment:update(l_30_1, l_30_2)
  managers.environment_area:update(l_30_1, l_30_2)
  managers.expression:update(l_30_1, l_30_2)
  managers.global_texture:update(l_30_1, l_30_2)
  managers.subtitle:update(TimerManager:game_animation():time(), TimerManager:game_animation():delta_time())
  managers.overlay_effect:update(l_30_1, l_30_2)
  managers.viewport:update(l_30_1, l_30_2)
  managers.mission:update(l_30_1, l_30_2)
  managers.slave:update(l_30_1, l_30_2)
  l_30_0._session:update(l_30_1, l_30_2)
  l_30_0._input:update(l_30_1, l_30_2)
  l_30_0._smoketest:update(l_30_1, l_30_2)
  managers.environment_controller:update(l_30_1, l_30_2)
  if Application:production_build() then
    managers.prefhud:update(l_30_1, l_30_2)
    managers.debug:update(TimerManager:wall():time(), TimerManager:wall():delta_time())
  end
  if Global.DEBUG_MENU_ON or Application:production_build() then
    l_30_0.__freeflight:update(l_30_1, l_30_2)
  end
  if Application:ews_enabled() then
    managers.toolhub:update(l_30_1, l_30_2)
  end
  if Application:editor() then
    managers.editor:update(l_30_1, l_30_2)
  end
  l_30_0:update(l_30_1, l_30_2)
end

CoreSetup.__paused_update = function(l_31_0, l_31_1, l_31_2)
  managers.viewport:paused_update(l_31_1, l_31_2)
  managers.controller:paused_update(l_31_1, l_31_2)
  managers.cutscene:paused_update(l_31_1, l_31_2)
  managers.overlay_effect:paused_update(l_31_1, l_31_2)
  managers.global_texture:paused_update(l_31_1, l_31_2)
  managers.slave:paused_update(l_31_1, l_31_2)
  l_31_0._session:update(l_31_1, l_31_2)
  l_31_0._input:update(l_31_1, l_31_2)
  l_31_0._smoketest:update(l_31_1, l_31_2)
  if Application:production_build() then
    managers.debug:paused_update(TimerManager:wall():time(), TimerManager:wall():delta_time())
  end
  if Global.DEBUG_MENU_ON or Application:production_build() then
    l_31_0.__freeflight:update(l_31_1, l_31_2)
  end
  if Application:ews_enabled() then
    managers.toolhub:paused_update(l_31_1, l_31_2)
  end
  if Application:editor() then
    managers.editor:update(l_31_1, l_31_2)
  end
  l_31_0:paused_update(l_31_1, l_31_2)
end

CoreSetup.__end_update = function(l_32_0, l_32_1, l_32_2)
  managers.camera:update(l_32_1, l_32_2)
  l_32_0._session:end_update(l_32_1, l_32_2)
  l_32_0:end_update(l_32_1, l_32_2)
  l_32_0.__gsm:end_update(l_32_1, l_32_2)
  managers.viewport:end_update(l_32_1, l_32_2)
  managers.controller:end_update(l_32_1, l_32_2)
  managers.DOF:update(l_32_1, l_32_2)
  if Application:ews_enabled() then
    managers.toolhub:end_update(l_32_1, l_32_2)
  end
end

CoreSetup.__paused_end_update = function(l_33_0, l_33_1, l_33_2)
  l_33_0:paused_end_update(l_33_1, l_33_2)
  l_33_0.__gsm:end_update(l_33_1, l_33_2)
  managers.DOF:paused_update(l_33_1, l_33_2)
end

CoreSetup.__render = function(l_34_0)
  managers.portal:render()
  managers.viewport:render()
  managers.overlay_effect:render()
  l_34_0:render()
end

CoreSetup.__end_frame = function(l_35_0, l_35_1, l_35_2)
  l_35_0:end_frame(l_35_1, l_35_2)
  managers.viewport:end_frame(l_35_1, l_35_2)
  if l_35_0.__quit and not l_35_0:block_quit() then
    CoreEngineAccess._quit()
    do return end
    if l_35_0.__exec and not l_35_0:block_exec() then
      if managers.network and managers.network:session() then
        managers.network:save()
      end
      if managers.mission then
        managers.mission:destroy()
      end
      if managers.menu_scene then
        managers.menu_scene:pre_unload()
      end
      World:unload_all_units()
      if managers.menu_scene then
        managers.menu_scene:unload()
      end
      if managers.worlddefinition then
        managers.worlddefinition:flush_remaining_lights_textures()
      end
      if managers.blackmarket then
        managers.blackmarket:release_preloaded_blueprints()
      end
      if managers.dyn_resource and not managers.dyn_resource:is_ready_to_close() then
        Application:cleanup_thread_garbage()
        managers.dyn_resource:update()
      end
      if managers.sound_environment then
        managers.sound_environment:destroy()
      end
      l_35_0:start_loading_screen()
      managers.music:stop()
      SoundDevice:stop()
      if managers.worlddefinition then
        managers.worlddefinition:unload_packages()
      end
      l_35_0:unload_packages()
      managers.menu:destroy()
      Overlay:newgui():destroy_all_workspaces()
      Application:cleanup_thread_garbage()
      PackageManager:reload_lua()
      managers.music:post_event("loadout_music")
      CoreEngineAccess._exec("core/lib/CoreEntry", l_35_0.__context)
    end
  end
end

CoreSetup.__loading_update = function(l_36_0, l_36_1, l_36_2)
  l_36_0._session:update(l_36_1, l_36_2)
  l_36_0:loading_update()
end

CoreSetup.__animations_reloaded = function(l_37_0)
end

CoreSetup.__script_reloaded = function(l_38_0)
end

CoreSetup.__entering_window = function(l_39_0, l_39_1, l_39_2)
  if Global.frame:is_active() then
    Global.application_window:set_focus()
    Input:keyboard():acquire()
  end
end

CoreSetup.__leaving_window = function(l_40_0, l_40_1, l_40_2)
  if managers.editor._in_mixed_input_mode then
    Input:keyboard():unacquire()
  end
end

CoreSetup.__kill_focus = function(l_41_0, l_41_1, l_41_2)
  if managers.editor and not managers.editor:in_mixed_input_mode() and not Global.running_simulation then
    managers.editor:set_in_mixed_input_mode(true)
  end
end

CoreSetup.__save = function(l_42_0, l_42_1)
  l_42_0:save(l_42_1)
end

CoreSetup.__load = function(l_43_0, l_43_1)
  l_43_0:load(l_43_1)
end

core:module("CoreSetup")
CoreSetup = _CoreSetup
CoreSetup.make_entrypoint = function(l_44_0)
  if rawget(_G, "pre_init") == nil then
    assert(_G.CoreSetup.__entrypoint_is_setup)
  end
  assert(rawget(_G, "init") ~= nil)
  assert(rawget(_G, "destroy") ~= nil)
  assert(rawget(_G, "update") ~= nil)
  assert(rawget(_G, "end_update") ~= nil)
  assert(rawget(_G, "paused_update") ~= nil)
  assert(rawget(_G, "paused_end_update") ~= nil)
  assert(rawget(_G, "render") ~= nil)
  assert(rawget(_G, "end_frame") ~= nil)
  assert(rawget(_G, "animations_reloaded") ~= nil)
  assert(rawget(_G, "script_reloaded") ~= nil)
  assert(rawget(_G, "entering_window") ~= nil)
  assert(rawget(_G, "leaving_window") ~= nil)
  assert(rawget(_G, "kill_focus") ~= nil)
  assert(rawget(_G, "save") ~= nil)
  assert(rawget(_G, "load") ~= nil)
  _G.CoreSetup.__entrypoint_is_setup = true
  rawset(_G, "pre_init", callback(l_44_0, l_44_0, "__pre_init"))
  rawset(_G, "init", callback(l_44_0, l_44_0, "__init"))
  rawset(_G, "destroy", callback(l_44_0, l_44_0, "__destroy"))
  rawset(_G, "update", callback(l_44_0, l_44_0, "__update"))
  rawset(_G, "end_update", callback(l_44_0, l_44_0, "__end_update"))
  rawset(_G, "loading_update", callback(l_44_0, l_44_0, "__loading_update"))
  rawset(_G, "paused_update", callback(l_44_0, l_44_0, "__paused_update"))
  rawset(_G, "paused_end_update", callback(l_44_0, l_44_0, "__paused_end_update"))
  rawset(_G, "render", callback(l_44_0, l_44_0, "__render"))
  rawset(_G, "end_frame", callback(l_44_0, l_44_0, "__end_frame"))
  rawset(_G, "animations_reloaded", callback(l_44_0, l_44_0, "__animations_reloaded"))
  rawset(_G, "script_reloaded", callback(l_44_0, l_44_0, "__script_reloaded"))
  rawset(_G, "entering_window", callback(l_44_0, l_44_0, "__entering_window"))
  rawset(_G, "leaving_window", callback(l_44_0, l_44_0, "__leaving_window"))
  rawset(_G, "kill_focus", callback(l_44_0, l_44_0, "__kill_focus"))
  rawset(_G, "save", callback(l_44_0, l_44_0, "__save"))
  rawset(_G, "load", callback(l_44_0, l_44_0, "__load"))
end


