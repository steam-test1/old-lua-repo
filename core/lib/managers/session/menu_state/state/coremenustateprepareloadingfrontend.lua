-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\menu_state\state\coremenustateprepareloadingfrontend.luac 

core:module("CoreMenuStatePrepareLoadingFrontEnd")
core:import("CoreSessionResponse")
core:import("CoreMenuStatePreFrontEnd")
core:import("CoreMenuStateLoadingFrontEnd")
if not PrepareLoadingFrontEnd then
  PrepareLoadingFrontEnd = class()
end
PrepareLoadingFrontEnd.init = function(l_1_0)
  l_1_0._response = CoreSessionResponse.Done:new()
  local menu_handler = l_1_0.menu_state._menu_handler
  menu_handler:prepare_loading_front_end(l_1_0._response)
end

PrepareLoadingFrontEnd.destroy = function(l_2_0)
  l_2_0._response:destroy()
end

PrepareLoadingFrontEnd.transition = function(l_3_0)
  if l_3_0._response:is_done() then
    return CoreMenuStateLoadingFrontEnd.LoadingFrontEnd
  end
end


