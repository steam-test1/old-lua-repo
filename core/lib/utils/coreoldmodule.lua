-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\coreoldmodule.luac 

core:module("CoreOldModule")
get_core_or_local = function(l_1_0)
  if not rawget(_G, l_1_0) then
    return rawget(_G, "Core" .. l_1_0)
  end
end

core_or_local = function(l_2_0, ...)
  do
    local metatable = get_core_or_local(l_2_0)
    if metatable then
      return metatable:new(...)
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end


