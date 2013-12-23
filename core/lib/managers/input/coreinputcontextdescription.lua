-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\input\coreinputcontextdescription.luac 

core:module("CoreInputContextDescription")
if not ContextDescription then
  ContextDescription = class()
end
ContextDescription.init = function(l_1_0, l_1_1)
  l_1_0._input_target_descriptions = {}
  l_1_0._layout_descriptions = {}
  l_1_0._context_descriptions = {}
  l_1_0._name = l_1_1
  assert(l_1_0._name, "You must specify a name for a context")
end

ContextDescription.add_input_target_description = function(l_2_0, l_2_1)
  l_2_0._input_target_descriptions[l_2_1:target_name()] = l_2_1
end

ContextDescription.add_layout_description = function(l_3_0, l_3_1)
  l_3_0._layout_descriptions[l_3_1:layout_name()] = l_3_1
end

ContextDescription.add_context_description = function(l_4_0, l_4_1)
  l_4_0._context_descriptions[l_4_1:context_description_name()] = l_4_1
end

ContextDescription.device_layout_description = function(l_5_0, l_5_1, l_5_2)
  if not l_5_2 then
    l_5_2 = "default"
  end
  local layout_description = l_5_0._layout_descriptions[l_5_2]
  if layout_description == nil then
    return 
  end
  return layout_description:device_layout_description(l_5_1)
end

ContextDescription.context_description_name = function(l_6_0)
  return l_6_0._name
end

ContextDescription.context_description = function(l_7_0, l_7_1)
  return l_7_0._context_descriptions[l_7_1]
end

ContextDescription.context_descriptions = function(l_8_0)
  return l_8_0._context_descriptions
end

ContextDescription.input_targets = function(l_9_0)
  return l_9_0._input_target_descriptions
end

ContextDescription.input_target_description = function(l_10_0, l_10_1)
  local input_target = l_10_0._input_target_descriptions[l_10_1]
  assert(input_target ~= nil, "Input Target with name '" .. l_10_1 .. "' can not be found in context '" .. l_10_0._name .. "'")
  return input_target
end


