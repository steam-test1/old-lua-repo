-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\viewport\interfaces\coreenvironmentdebuginterface.luac 

core:module("CoreEnvironmentDebugInterface")
core:import("CoreClass")
if not EnvironmentDebugInterface then
  EnvironmentDebugInterface = CoreClass.class()
end
EnvironmentDebugInterface.DATA_PATH = nil
EnvironmentDebugInterface.SHARED = nil
EnvironmentDebugInterface.processed = function(l_1_0)
  return l_1_0._handle:processed()
end

EnvironmentDebugInterface.shared = function(l_2_0)
  return l_2_0._handle:shared()
end

EnvironmentDebugInterface.parameter_info = function(l_3_0, l_3_1)
  return l_3_0._handle:parameter_info(l_3_1)
end

EnvironmentDebugInterface.parameters = function(l_4_0)
  return table.list_copy(l_4_0._handle:parameters())
end

EnvironmentDebugInterface.init = function(l_5_0, l_5_1)
  l_5_0._handle = l_5_1
  l_5_0._init_trace_back = debug.traceback()
end


