-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\menu\items\coremenuitemoption.luac 

core:module("CoreMenuItemOption")
if not ItemOption then
  ItemOption = class()
end
ItemOption.init = function(l_1_0, l_1_1, l_1_2)
  if not l_1_2 then
    local params = {}
  end
  if l_1_1 then
    for key,value in pairs(l_1_1) do
      if key ~= "_meta" and type(value) ~= "table" then
        params[key] = value
      end
    end
  end
  l_1_0:set_parameters(params)
end

ItemOption.value = function(l_2_0)
  return l_2_0._parameters.value
end

ItemOption.parameters = function(l_3_0)
  return l_3_0._parameters
end

ItemOption.set_parameters = function(l_4_0, l_4_1)
  l_4_0._parameters = l_4_1
end


