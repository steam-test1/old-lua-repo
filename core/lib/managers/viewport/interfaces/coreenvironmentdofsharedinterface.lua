-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\viewport\interfaces\coreenvironmentdofsharedinterface.luac 

core:module("CoreEnvironmentDOFSharedInterface")
core:import("CoreClass")
core:import("CoreEnvironmentDOFInterface")
if not EnvironmentDOFSharedInterface then
  EnvironmentDOFSharedInterface = CoreClass.class(CoreEnvironmentDOFInterface.core:import("CoreClass"))
end
EnvironmentDOFSharedInterface.SHARED = true

