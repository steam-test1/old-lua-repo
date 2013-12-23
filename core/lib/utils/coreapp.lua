-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\coreapp.luac 

core:module("CoreApp")
arg_supplied = function(l_1_0)
  for _,arg in ipairs(Application:argv()) do
    if arg == l_1_0 then
      return true
    end
  end
  return false
end

arg_value = function(l_2_0)
  local found = nil
  for _,arg in ipairs(Application:argv()) do
    if found then
      return arg
      for (for control),_ in (for generator) do
      end
      if arg == l_2_0 then
        found = true
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

min_exe_version = function(l_3_0, l_3_1)
end


