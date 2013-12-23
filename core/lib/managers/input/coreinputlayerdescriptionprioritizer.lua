-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\input\coreinputlayerdescriptionprioritizer.luac 

core:module("CoreInputLayerDescriptionPrioritizer")
if not Prioritizer then
  Prioritizer = class()
end
Prioritizer.init = function(l_1_0)
  l_1_0._layer_descriptions = {}
end

Prioritizer.add_layer_description = function(l_2_0, l_2_1)
  l_2_0._layer_descriptions[l_2_1] = l_2_1
  if not l_2_0._layer_description or l_2_1:priority() < l_2_0._layer_description:priority() then
    l_2_0._layer_description = l_2_1
  end
end

Prioritizer.remove_layer_description = function(l_3_0, l_3_1)
  local needs_to_search = l_3_0._layer_description == l_3_1
  assert(l_3_0._layer_descriptions[l_3_1] ~= nil)
  l_3_0._layer_descriptions[l_3_1] = nil
  local best_layer_description = nil
  for _,layer_description in pairs(l_3_0._layer_descriptions) do
    if not best_layer_description or layer_description:priority() < best_layer_description:priority() then
      best_layer_description = layer_description
    end
  end
  l_3_0._layer_description = best_layer_description
end

Prioritizer.active_layer_description = function(l_4_0)
  return l_4_0._layer_description
end


