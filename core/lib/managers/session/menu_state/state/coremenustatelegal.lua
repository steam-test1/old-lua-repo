-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\menu_state\state\coremenustatelegal.luac 

core:module("CoreMenuStateLegal")
core:import("CoreMenuStateIntroScreens")
if not Legal then
  Legal = class()
end
Legal.init = function(l_1_0)
  l_1_0._start_time = TimerManager:game():time()
end

Legal.transition = function(l_2_0)
  local current_time = TimerManager:game():time()
  local time_until_intro_screens = 1
  if l_2_0._start_time + time_until_intro_screens <= current_time then
    return CoreMenuStateIntroScreens.IntroScreens
  end
end


