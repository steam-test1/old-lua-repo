-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\syncunitdata.luac 

if not SyncUnitData then
  SyncUnitData = class()
end
SyncUnitData.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
end

SyncUnitData.save = function(l_2_0, l_2_1)
  do
    local state = {lights = {}}
    for _,light in ipairs(l_2_0._unit:get_objects_by_type(Idstring("light"))) do
      {name = light:name(), enabled = light:enable(), far_range = light:far_range(), near_range = light:near_range()}.color = light:color()
       -- DECOMPILER ERROR: Confused about usage of registers!

      {name = light:name(), enabled = light:enable(), far_range = light:far_range(), near_range = light:near_range()}.spot_angle_start = light:spot_angle_start()
       -- DECOMPILER ERROR: Confused about usage of registers!

      {name = light:name(), enabled = light:enable(), far_range = light:far_range(), near_range = light:near_range()}.spot_angle_end = light:spot_angle_end()
       -- DECOMPILER ERROR: Confused about usage of registers!

      {name = light:name(), enabled = light:enable(), far_range = light:far_range(), near_range = light:near_range()}.multiplier_nr = light:multiplier()
       -- DECOMPILER ERROR: Confused about usage of registers!

      {name = light:name(), enabled = light:enable(), far_range = light:far_range(), near_range = light:near_range()}.specular_multiplier_nr = light:specular_multiplier()
       -- DECOMPILER ERROR: Confused about usage of registers!

      {name = light:name(), enabled = light:enable(), far_range = light:far_range(), near_range = light:near_range()}.falloff_exponent = light:falloff_exponent()
       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused about usage of registers!

      table.insert(state.lights, {name = light:name(), enabled = light:enable(), far_range = light:far_range(), near_range = light:near_range()})
    end
     -- DECOMPILER ERROR: Confused about usage of registers!

    state.projection_light = l_2_0._unit:unit_data().projection_light
     -- DECOMPILER ERROR: Confused about usage of registers!

    state.projection_textures = l_2_0._unit:unit_data().projection_textures
     -- DECOMPILER ERROR: Confused about usage of registers!

    l_2_1.SyncUnitData = state
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

SyncUnitData.load = function(l_3_0, l_3_1)
  local state = l_3_1.SyncUnitData
  l_3_0._unit:unit_data().unit_id = l_3_0._unit:editor_id()
  managers.worlddefinition:setup_lights(l_3_0._unit, state)
  managers.worlddefinition:setup_projection_light(l_3_0._unit, state)
end


