-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\levels\fortresslevel.luac 

if not FortressLevel then
  FortressLevel = class()
end
FortressLevel.init = function(l_1_0)
  l_1_0._spawn_index = 1
  l_1_0._spawn_map = {}
  table.insert(l_1_0._spawn_map, {name = Idstring("units/characters/dummy_duel/dummy_duel"), func = l_1_0.spawn_dummy})
  Global.god_mode = true
end

FortressLevel.post_init = function(l_2_0)
  l_2_0._ctrlr_debug = Input:create_virtual_controller()
  local keyboard = Input:keyboard()
  if keyboard and keyboard:has_button(Idstring("right shift")) then
    local connection_name = "step_right"
    l_2_0._ctrlr_debug:connect(keyboard, Idstring("right"), Idstring(connection_name))
    l_2_0._ctrlr_debug:add_trigger(Idstring(connection_name), callback(l_2_0, l_2_0, "step_right"))
    connection_name = "step_left"
    l_2_0._ctrlr_debug:connect(keyboard, Idstring("left"), Idstring(connection_name))
    l_2_0._ctrlr_debug:add_trigger(Idstring(connection_name), callback(l_2_0, l_2_0, "step_left"))
    if keyboard:has_button(Idstring("right shift")) then
      connection_name = "Debug Spawn"
      l_2_0._ctrlr_debug:connect(keyboard, Idstring("right shift"), Idstring(connection_name))
      l_2_0._ctrlr_debug:add_trigger(Idstring(connection_name), callback(l_2_0, l_2_0, "spawn"))
    end
  end
  l_2_0._dummy_unit = nil
end

FortressLevel.update = function(l_3_0, l_3_1, l_3_2)
  if l_3_0._spawn_btn_presses then
    l_3_0:spawn_dummy()
    l_3_0._spawn_btn_presses = false
  end
end

FortressLevel.spawn_pos = function(l_4_0)
  return Application:last_camera_position() + Application:last_camera_rotation():y() * 700
end

FortressLevel.step_right = function(l_5_0)
  l_5_0._spawn_index = l_5_0._spawn_index + 1
  if #l_5_0._spawn_map < l_5_0._spawn_index then
    l_5_0._spawn_index = 1
  end
end

FortressLevel.step_left = function(l_6_0)
  l_6_0._spawn_index = l_6_0._spawn_index - 1
  if l_6_0._spawn_index < 1 then
    l_6_0._spawn_index = #l_6_0._spawn_map
  end
end

FortressLevel._spawn_enemy_group = function(l_7_0)
  l_7_0:spawn_dummy()
end

FortressLevel.spawn = function(l_8_0)
  l_8_0._spawn_btn_press_t = TimerManager:game():time()
  l_8_0._spawn_btn_presses = (l_8_0._spawn_btn_presses or 0) + 1
end

FortressLevel.spawn_generic = function(l_9_0, l_9_1)
  World:spawn_unit(l_9_1, l_9_0:spawn_pos())
end

FortressLevel.spawn_dummy = function(l_10_0)
  l_10_0._debug_unit_name = Idstring("units/characters/drone/drone")
  local dummy_unit = World:spawn_unit(l_10_0._debug_unit_name, l_10_0:spawn_pos())
end


