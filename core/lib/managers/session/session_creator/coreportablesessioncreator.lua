-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\session_creator\coreportablesessioncreator.luac 

core:module("CorePortableSessionCreator")
core:import("CoreFakeSessionCreator")
if SystemInfo:platform() == Idstring("X360") then
  Creator = CoreFakeSessionCreator.Creator
else
  if SystemInfo:platform() == Idstring("WIN32") then
    Creator = CoreFakeSessionCreator.Creator
  else
    if SystemInfo:platform() == Idstring("PS3") then
      Creator = CoreFakeSessionCreator.Creator
    end
  end
end

