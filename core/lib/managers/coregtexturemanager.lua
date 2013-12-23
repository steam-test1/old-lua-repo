-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\coregtexturemanager.luac 

core:module("CoreGTextureManager")
if not GTextureManager then
  GTextureManager = class()
end
GTextureManager.init = function(l_1_0)
  l_1_0._preloaded = {}
  l_1_0._global_texture = nil
  l_1_0._texture_name = nil
  l_1_0._texture_type = nil
  l_1_0._texture = nil
  l_1_0._delay = nil
end

GTextureManager.set_texture = function(l_2_0, l_2_1, l_2_2, l_2_3)
  l_2_0._delay = (SystemInfo:platform() ~= Idstring("PS3") and l_2_3)
  l_2_0._texture_name = l_2_1
  l_2_0._texture_type = l_2_2
  if l_2_3 then
    TextureCache:request(l_2_1, l_2_2, function()
   end)
  else
    l_2_0:_retrieve()
  end
end

GTextureManager.preload = function(l_3_0, l_3_1, l_3_2)
  if type(l_3_1) == "string" and not l_3_0._preloaded[l_3_1] then
    l_3_0._preloaded[l_3_1] = TextureCache:retrieve(l_3_1, l_3_2)
    do return end
    for _,v in ipairs(l_3_1) do
      if not l_3_0._preloaded[v.name] then
        l_3_0._preloaded[v.name] = TextureCache:retrieve(v.name, v.type)
      end
    end
  end
end

GTextureManager.current_texture_name = function(l_4_0)
  return l_4_0._texture_name
end

GTextureManager.prepare_full_load = function(l_5_0, l_5_1)
  l_5_0:_unretrieve()
  l_5_1._preloaded = l_5_0._preloaded
end

GTextureManager.is_streaming = function(l_6_0)
  return l_6_0._delay ~= nil
end

GTextureManager.reload = function(l_7_0)
  if l_7_0._texture then
    l_7_0:_retrieve()
  end
end

GTextureManager.update = function(l_8_0, l_8_1, l_8_2)
  if l_8_0._delay then
    l_8_0._delay = l_8_0._delay - l_8_2
    if l_8_0._delay <= 0 then
      l_8_0:_retrieve()
      l_8_0._delay = nil
    end
  end
end

GTextureManager.paused_update = function(l_9_0, l_9_1, l_9_2)
  l_9_0:update(l_9_1, l_9_2)
end

GTextureManager.destroy = function(l_10_0)
  l_10_0:_unretrieve()
  l_10_0:_unref_preloaded()
end

GTextureManager._unref_preloaded = function(l_11_0)
  for _,v in pairs(l_11_0._preloaded) do
    TextureCache:unretrieve(v)
  end
end

GTextureManager._unretrieve = function(l_12_0)
  if l_12_0._texture then
    GlobalTextureManager:set_texture("current_global_texture", nil)
    TextureCache:unretrieve(l_12_0._texture)
    l_12_0._texture = nil
  end
end

GTextureManager._retrieve = function(l_13_0)
  l_13_0:_unretrieve()
  l_13_0._texture = TextureCache:retrieve(l_13_0._texture_name, l_13_0._texture_type)
  GlobalTextureManager:set_texture("current_global_texture", l_13_0._texture)
end


