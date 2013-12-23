-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\menu_state\state\coremenustateattract.luac 

core:module("CoreMenuStateAttract")
core:import("CoreMenuStateStart")
core:import("CoreSessionResponse")
if not Attract then
  Attract = class()
end
Attract.init = function(l_1_0)
  local menu_handler = l_1_0.pre_front_end.menu_state._menu_handler
  l_1_0._response = CoreSessionResponse.Done:new()
  menu_handler:attract(l_1_0._response)
end

Attract.destroy = function(l_2_0)
  l_2_0._response:destroy()
end

Attract.transition = function(l_3_0)
  if l_3_0._response:is_done() or Input:any_input() then
    return CoreMenuStateStart.Start
  end
end


