-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\menu_state\state\coremenustateineditor.luac 

core:module("CoreMenuStateInEditor")
core:import("CoreMenuStateInGame")
if not InEditor then
  InEditor = class(CoreMenuStateInGame.InGame)
end
InEditor.init = function(l_1_0)
  l_1_0.menu_state:_set_stable_for_loading()
end

InEditor.destroy = function(l_2_0)
  l_2_0.menu_state:_not_stable_for_loading()
end


