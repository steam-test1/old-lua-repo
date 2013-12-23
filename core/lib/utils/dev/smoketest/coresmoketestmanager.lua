-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\dev\smoketest\coresmoketestmanager.luac 

core:module("CoreSmoketestManager")
core:import("CoreClass")
core:import("CoreEngineAccess")
core:import("CoreSmoketestReporter")
core:import("CoreSmoketestLoadLevelSuite")
core:import("CoreSmoketestEditorSuite")
if not Manager then
  Manager = CoreClass.class()
end
Manager.init = function(l_1_0, l_1_1)
  l_1_0._session_state = l_1_1
  l_1_0._smoketestsuites = {}
  l_1_0._reporter = CoreSmoketestReporter.Reporter:new()
  l_1_0:register("editor", CoreSmoketestEditorSuite.EditorSuite:new())
  l_1_0:register("load_level", CoreSmoketestLoadLevelSuite.LoadLevelSuite:new())
end

Manager.destroy = function(l_2_0)
end

Manager.register = function(l_3_0, l_3_1, l_3_2)
  l_3_0._smoketestsuites[l_3_1] = l_3_2
end

Manager.post_init = function(l_4_0)
  l_4_0:_parse_arguments(Application:argv())
end

Manager._parse_arguments = function(l_5_0, l_5_1)
  local suite_arguments = {}
  for i,arg in ipairs(l_5_1) do
    do
      if arg:find("-smoketest:") then
        local smoketest_class = arg:sub(12, -1)
        assert(not l_5_0._suite, "Only one smoketest suite can be run at a time")
        assert(l_5_0._smoketestsuites[smoketest_class], "Smoketest '" .. smoketest_class .. "' does't exist")
        l_5_0._suite = l_5_0._smoketestsuites[smoketest_class]
      end
      for (for control),i in (for generator) do
      end
      if arg:find("-smoketestarg:") then
        local subarg = arg:sub(15, -1)
        local separator_index = subarg:find("=")
        assert(separator_index, "smoketestargs must be on the form name=value! found this " .. subarg)
        local name = subarg:sub(1, separator_index - 1)
        local value = subarg:sub(separator_index + 1, -1)
        suite_arguments[name] = value
      end
    end
    if l_5_0._suite then
      l_5_0._suite:start(l_5_0._session_state, l_5_0._reporter, suite_arguments)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

Manager.update = function(l_6_0, l_6_1, l_6_2)
  if l_6_0._suite then
    l_6_0._suite:update(l_6_1, l_6_2)
    if l_6_0._suite:is_done() then
      if SystemInfo:platform() == Idstring("WIN32") then
        l_6_0._reporter:begin_substep("shutdown")
        CoreEngineAccess._quit()
      else
        l_6_0._reporter:tests_done()
        l_6_0._suite = nil
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end


