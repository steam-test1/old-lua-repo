-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\input\coreinputcontext.luac 

core:module("CoreInputContext")
if not Context then
  Context = class()
end
Context.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._input_data = {}
  l_1_0:_construct_input_data(l_1_1)
  l_1_0._input_context_description = l_1_1
  l_1_0._input_context_stack = l_1_2
  assert(l_1_0._input_context_stack)
  l_1_0._input_context_stack:push_input_context(l_1_0)
end

Context.destroy = function(l_2_0)
  l_2_0._input_context_stack:pop_input_context(l_2_0)
  l_2_0._input_source = nil
end

Context.create_context = function(l_3_0, l_3_1)
  local context_description = l_3_0._input_context_description:context_description(l_3_1)
  assert(context_description, "Couldn't find subcontext with name:'" .. l_3_1 .. "'")
  local context = Context:new(context_description, l_3_0._input_context_stack)
  return context
end

Context.input = function(l_4_0)
  return l_4_0._input_data
end

Context._context_description = function(l_5_0)
  return l_5_0._input_context_description
end

Context._construct_input_data = function(l_6_0, l_6_1)
  for name,input_target in pairs(l_6_1:input_targets()) do
    local type_name = input_target:target_type_name()
    if type_name == "vector" then
      l_6_0._input_data[name] = Vector3(0, 0, 0)
      for (for control),name in (for generator) do
      end
      if type_name == "bool" then
        l_6_0._input_data[name] = false
        for (for control),name in (for generator) do
        end
        assert(false, "unknown type:'" .. type_name .. "'")
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end


