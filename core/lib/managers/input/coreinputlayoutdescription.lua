-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\input\coreinputlayoutdescription.luac 

core:module("CoreInputLayoutDescription")
if not LayoutDescription then
  LayoutDescription = class()
end
LayoutDescription.init = function(l_1_0, l_1_1)
  l_1_0._name = l_1_1
  l_1_0._device_layout_descriptions = {}
end

LayoutDescription.layout_name = function(l_2_0)
  return l_2_0._name
end

LayoutDescription.add_device_layout_description = function(l_3_0, l_3_1)
  l_3_0._device_layout_descriptions[l_3_1:device_type()] = l_3_1
end

LayoutDescription.device_layout_description = function(l_4_0, l_4_1)
  return l_4_0._device_layout_descriptions[l_4_1]
end


