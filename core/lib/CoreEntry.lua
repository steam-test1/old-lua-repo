-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\CoreEntry.luac 

require("core/lib/system/CoreSystem")
if table.contains(Application:argv(), "-slave") then
  require("core/lib/setups/CoreSlaveSetup")
else
  require("lib/Entry")
end

