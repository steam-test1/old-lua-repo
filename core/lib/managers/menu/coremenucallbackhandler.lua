-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\menu\coremenucallbackhandler.luac 

core:module("CoreMenuCallbackHandler")
if not CallbackHandler then
  CallbackHandler = class()
end
CallbackHandler.init = function(l_1_0)
  getmetatable(l_1_0).__index = function(l_1_0, l_1_1)
    local value = rawget(getmetatable(l_1_0), l_1_1)
    if value then
      return value
    end
   end
end


