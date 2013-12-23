-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\input\coreinputdevicelayoutdescription.luac 

core:module("CoreInputDeviceLayoutDescription")
if not DeviceLayoutDescription then
  DeviceLayoutDescription = class()
end
DeviceLayoutDescription.init = function(l_1_0, l_1_1)
  assert(l_1_1 == "xbox_controller" or l_1_1 == "ps3_controller" or l_1_1 == "win32_mouse")
  l_1_0._device_type = l_1_1
  l_1_0._binds = {}
end

DeviceLayoutDescription.device_type = function(l_2_0)
  return l_2_0._device_type
end

DeviceLayoutDescription.add_bind_button = function(l_3_0, l_3_1, l_3_2)
  l_3_0._binds[l_3_1] = {type_name = "button", input_target_description = l_3_2}
end

DeviceLayoutDescription.add_bind_axis = function(l_4_0, l_4_1, l_4_2)
  l_4_0._binds[l_4_1] = {type_name = "axis", input_target_description = l_4_2}
end

DeviceLayoutDescription.binds = function(l_5_0)
  return l_5_0._binds
end


