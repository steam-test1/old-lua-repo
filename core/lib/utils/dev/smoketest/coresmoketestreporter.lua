-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\dev\smoketest\coresmoketestreporter.luac 

core:module("CoreSmoketestReporter")
core:import("CoreClass")
if not Reporter then
  Reporter = CoreClass.class()
end
Reporter.init = function(l_1_0)
end

Reporter.begin_substep = function(l_2_0, l_2_1)
  cat_print("spam", "[Smoketest] begin_substep " .. l_2_1)
end

Reporter.end_substep = function(l_3_0, l_3_1)
  cat_print("spam", "[Smoketest] end_substep " .. l_3_1)
end

Reporter.fail_substep = function(l_4_0, l_4_1)
  cat_print("spam", "[Smoketest] fail_substep " .. l_4_1)
end

Reporter.tests_done = function(l_5_0)
  cat_print("spam", "[Smoketest] tests_done")
end


