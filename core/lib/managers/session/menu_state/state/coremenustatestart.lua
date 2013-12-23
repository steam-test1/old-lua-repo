-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\menu_state\state\coremenustatestart.luac 

core:module("CoreMenuStateStart")
core:import("CoreMenuStateAttract")
if not Start then
  Start = class()
end
Start.init = function(l_1_0)
  l_1_0._start_time = TimerManager:game():time()
  local player_slots = l_1_0.pre_front_end.menu_state._player_slots
  l_1_0._primary_slot = player_slots:primary_slot()
  l_1_0._primary_slot:request_local_user_binding()
  local menu_handler = l_1_0.pre_front_end.menu_state._menu_handler
  menu_handler:start()
end

Start.destroy = function(l_2_0)
  l_2_0._primary_slot:stop_local_user_binding()
end

Start.transition = function(l_3_0)
  local current_time = TimerManager:game():time()
  local time_until_attract = 15
  if l_3_0._start_time + time_until_attract <= current_time then
    return CoreMenuStateAttract.Attract
  end
end


