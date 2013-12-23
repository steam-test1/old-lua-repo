-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\viewport\coreenvironmenthandle.luac 

core:module("CoreEnvironmentHandle")
core:import("CoreClass")
if not EnvironmentHandle then
  EnvironmentHandle = CoreClass.class()
end
EnvironmentHandle.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, ...)
  l_1_0._mixer = l_1_1
  l_1_0._interface = l_1_2:new(l_1_0)
  l_1_0._full_control = l_1_3
  l_1_0._script_cb = l_1_4
  l_1_0._name = l_1_5
  l_1_0._shared = l_1_6
  l_1_0._path = {...}
  l_1_0._traceback = debug.traceback()
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

EnvironmentHandle.name = function(l_2_0)
  return l_2_0._name
end

EnvironmentHandle.traceback = function(l_3_0)
  return l_3_0._traceback
end

EnvironmentHandle.do_callback = function(l_4_0)
  if l_4_0._interface._pre_call then
    l_4_0._interface:_pre_call()
  end
  local ret = l_4_0._script_cb(l_4_0._interface)
  if l_4_0._interface._process_return then
    ret = l_4_0._interface:_process_return(ret)
  end
  return assert(ret, "[EnvironmentHandle] The script callback should return a table!")
end

EnvironmentHandle.processed = function(l_5_0)
  return l_5_0._full_control
end

EnvironmentHandle.shared = function(l_6_0)
  return l_6_0._shared
end

EnvironmentHandle.parameter_info = function(l_7_0, l_7_1)
  return l_7_0._mixer:parameter_info(l_7_1)
end

EnvironmentHandle.parameters = function(l_8_0)
  return l_8_0._mixer:internal_output(unpack(l_8_0._path))
end


