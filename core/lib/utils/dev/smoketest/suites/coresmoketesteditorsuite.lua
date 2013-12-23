-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\dev\smoketest\suites\coresmoketesteditorsuite.luac 

core:module("CoreSmoketestEditorSuite")
core:import("CoreClass")
core:import("CoreSmoketestCommonSuite")
if not EditorSuite then
  EditorSuite = class(CoreSmoketestCommonSuite.CommonSuite)
end
EditorSuite.init = function(l_1_0)
  EditorSuite.super.init(l_1_0)
  l_1_0:add_step("load_editor", CoreSmoketestCommonSuite.WaitEventSubstep, CoreSmoketestCommonSuite.WaitEventSubstep.step_arguments(Idstring("game_state_editor")))
  l_1_0:add_step("load_level", CoreSmoketestCommonSuite.CallAndDoneSubstep, CoreSmoketestCommonSuite.CallAndDoneSubstep.step_arguments(callback(l_1_0, l_1_0, "load_level")))
end

EditorSuite.load_level = function(l_2_0)
  managers.editor:load_level(l_2_0:get_argument("editor_dir"), l_2_0:get_argument("editor_level"))
end

EditorSuite.run_mission_simulation = function(l_3_0)
  managers.editor:run_simulation_callback(true)
end

EditorSuite.stop_mission_simulation = function(l_4_0)
  managers.editor:run_simulation_callback(true)
end

EditorSuite.environment_editor = function(l_5_0)
  managers.toolhub:open("Environment Editor")
  managers.toolhub:close("Environment Editor")
end


