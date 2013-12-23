-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\levels\sandboxlevel.luac 

if not SandboxLevel then
  SandboxLevel = class()
end
SandboxLevel.post_init = function(l_1_0)
  l_1_0._ctrlr_debug = Input:create_virtual_controller()
  if Input:keyboard():has_button("right shift") then
    local connection_name = "Debug spawn dummy"
    l_1_0._ctrlr_debug:connect(Input:keyboard(), "right shift", connection_name)
    l_1_0._ctrlr_debug:add_trigger(connection_name, callback(l_1_0, l_1_0, "spawn_dummy"))
  end
  l_1_0._debug_unit_name = "dummy_duel"
  l_1_0._dummy_unit = nil
end

SandboxLevel.spawn_pos = function(l_2_0)
  return managers.viewport:get_current_camera():position() + managers.viewport:get_current_camera():rotation():y() * 750
end

SandboxLevel.spawn_dummy = function(l_3_0)
  if not l_3_0._dummy_unit then
    l_3_0._dummy_unit = World:spawn_unit(l_3_0._debug_unit_name, l_3_0:spawn_pos())
    l_3_0._dummy_unit:base():setup(l_3_0._ctrlr_debug)
  else
    l_3_0._dummy_unit:warp_to_floor(l_3_0._dummy_unit:rotation(), l_3_0:spawn_pos())
  end
end


