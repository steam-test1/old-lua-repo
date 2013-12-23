-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\local_user\storage\coreportablelocaluserstorage.luac 

core:module("CorePortableLocalUserStorage")
core:import("CoreFakeLocalUserStorage")
if SystemInfo:platform() == Idstring("X360") then
  Storage = CoreFakeLocalUserStorage.Storage
else
  if SystemInfo:platform() == Idstring("WIN32") then
    Storage = CoreFakeLocalUserStorage.Storage
  else
    if SystemInfo:platform() == Idstring("PS3") then
      Storage = CoreFakeLocalUserStorage.Storage
    end
  end
end

