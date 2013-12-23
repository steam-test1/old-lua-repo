-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\occlusionmanager.luac 

if not _OcclusionManager then
  _OcclusionManager = class()
end
_OcclusionManager.init = function(l_1_0)
  l_1_0._obj_id = Idstring("object3d")
  l_1_0._skip_occlusion = {}
end

_OcclusionManager.is_occluded = function(l_2_0, l_2_1)
  if l_2_0._skip_occlusion[l_2_1:key()] then
    return false
  end
  return l_2_1:occluded()
end

_OcclusionManager.remove_occlusion = function(l_3_0, l_3_1)
  if alive(l_3_1) then
    local objects = l_3_1:get_objects_by_type(l_3_0._obj_id)
    for _,obj in pairs(objects) do
      obj:set_skip_occlusion(true)
    end
  end
  l_3_0._skip_occlusion[l_3_1:key()] = true
end

_OcclusionManager.add_occlusion = function(l_4_0, l_4_1)
  if alive(l_4_1) then
    local objects = l_4_1:get_objects_by_type(l_4_0._obj_id)
    for _,obj in pairs(objects) do
      obj:set_skip_occlusion(false)
    end
  end
  l_4_0._skip_occlusion[l_4_1:key()] = nil
end


