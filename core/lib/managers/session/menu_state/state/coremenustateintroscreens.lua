-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\menu_state\state\coremenustateintroscreens.luac 

core:module("CoreMenuStateIntroScreens")
core:import("CoreSessionResponse")
if not IntroScreens then
  IntroScreens = class()
end
IntroScreens.init = function(l_1_0)
  l_1_0._response = CoreSessionResponse.DoneOrFinished:new()
  l_1_0.pre_front_end_once.menu_state._menu_handler:show_next_intro_screen(l_1_0._response)
end

IntroScreens.destroy = function(l_2_0)
  l_2_0._response:destroy()
end

IntroScreens.transition = function(l_3_0)
  if l_3_0._response:is_finished() then
    l_3_0.pre_front_end_once.intro_screens_done = true
  else
    if l_3_0._response:is_done() or Input:any_input() then
      return IntroScreens
    end
  end
end


