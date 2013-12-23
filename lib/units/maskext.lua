-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\maskext.luac 

require("lib/managers/BlackMarketManager")
if not MaskExt then
  MaskExt = class()
end
local mvec1 = Vector3()
local mvec2 = Vector3()
MaskExt.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._blueprint = {}
  Application:debug("MaskExt:new()")
end

MaskExt.apply_blueprint = function(l_2_0, l_2_1)
  if not l_2_1 then
    return 
  end
  local materials = l_2_0._unit:get_objects_by_type(Idstring("material"))
  local material = materials[#materials]
  local tint_color_a = mvec1
  local tint_color_b = mvec2
  local pattern_id = l_2_1.pattern.id
  local material_id = l_2_1.material.id
  local color_data = tweak_data.blackmarket.colors[l_2_1.color.id]
  mvector3.set_static(tint_color_a, color_data.colors[1]:unpack())
  mvector3.set_static(tint_color_b, color_data.colors[2]:unpack())
  material:set_variable(Idstring("tint_color_a"), tint_color_a)
  material:set_variable(Idstring("tint_color_b"), tint_color_b)
  local old_pattern = l_2_0._blueprint[1]
  local pattern = tweak_data.blackmarket.textures[pattern_id].texture
  if old_pattern ~= Idstring(pattern) then
    local pattern_texture = TextureCache:retrieve(pattern, "normal")
    material:set_texture("material_texture", pattern_texture)
  end
  local old_reflection = l_2_0._blueprint[2]
  local reflection = tweak_data.blackmarket.materials[material_id].texture
  if old_reflection ~= Idstring(reflection) then
    local reflection_texture = TextureCache:retrieve(reflection, "normal")
    material:set_texture("reflection_texture", reflection_texture)
  end
  local material_amount = tweak_data.blackmarket.materials[material_id].material_amount or 1
  material:set_variable(Idstring("material_amount"), material_amount)
  local new_blueprint = {}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  Idstring(pattern)(Idstring(reflection), new_blueprint)
  l_2_0._blueprint = new_blueprint
end

MaskExt.unretrieve_blueprint = function(l_3_0, l_3_1)
  if l_3_0._blueprint then
    for index,texture_ids in pairs(l_3_0._blueprint) do
      if l_3_1 and l_3_1[index] == texture_ids then
        for (for control),index in (for generator) do
        end
        TextureCache:unretrieve(texture_ids)
      end
    end
    l_3_0._blueprint = {}
     -- Warning: missing end command somewhere! Added here
  end
end

MaskExt.destroy = function(l_4_0, l_4_1)
  print("MaskExt:destroy")
  l_4_0:unretrieve_blueprint()
end

MaskExt.pre_destroy = function(l_5_0, l_5_1)
  print("MaskExt:pre_destroy")
  l_5_0:unretrieve_blueprint()
end


