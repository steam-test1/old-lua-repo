-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\menu_state\state\coremenustatenone.luac 

core:module("CoreMenuStateNone")
core:import("CoreMenuStatePreFrontEndOnce")
core:import("CoreMenuStateInEditor")
if not None then
  None = class()
end
None.transition = function(l_1_0)
  local state = l_1_0.menu_state._game_state
  if not state:is_in_init() then
    if state:is_in_editor() then
      return CoreMenuStateInEditor.InEditor
    else
      return CoreMenuStatePreFrontEndOnce.PreFrontEndOnce
    end
  end
end


