-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\criminalsmanager.luac 

if not CriminalsManager then
  CriminalsManager = class()
end
CriminalsManager.MAX_NR_TEAM_AI = 2
CriminalsManager.init = function(l_1_0)
  l_1_0._characters = {{taken = false, name = "american", unit = nil, peer_id = 0, static_data = {ai_character_id = "ai_hoxton", ssuffix = "d", color_id = 1, voice = "rb2", ai_mask_id = "hoxton", mask_id = 1}, data = {}}, {taken = false, name = "german", unit = nil, peer_id = 0, static_data = {ai_character_id = "ai_wolf", ssuffix = "c", color_id = 2, voice = "rb3", ai_mask_id = "wolf", mask_id = 2}, data = {}}, {taken = false, name = "russian", unit = nil, peer_id = 0, static_data = {ai_character_id = "ai_dallas", ssuffix = "a", color_id = 3, voice = "rb4", ai_mask_id = "dallas", mask_id = 3}, data = {}}, {taken = false, name = "spanish", unit = nil, peer_id = 0, static_data = {ai_character_id = "ai_chains", ssuffix = "b", color_id = 4, voice = "rb1", ai_mask_id = "chains", mask_id = 4}, data = {}}}
end

CriminalsManager.convert_old_to_new_character_workname = function(l_2_0)
  local t = {american = "hoxton", german = "wolf", russian = "dallas", spanish = "chains"}
  return t[l_2_0]
end

CriminalsManager.character_names = function()
  do
    local l_3_0 = {}
     -- DECOMPILER ERROR: No list found. Setlist fails

    return l_3_0
  end
   -- Warning: undefined locals caused missing assignments!
end

CriminalsManager.character_workname_by_peer_id = function(l_4_0)
  local t = {"russian", "german", "spanish", "american"}
  return t[l_4_0]
end

CriminalsManager.on_simulation_ended = function(l_5_0)
  for id,data in pairs(l_5_0._characters) do
    l_5_0:_remove(id)
  end
end

CriminalsManager.local_character_name = function(l_6_0)
  return l_6_0._local_character
end

CriminalsManager.characters = function(l_7_0)
  return l_7_0._characters
end

CriminalsManager.get_any_unit = function(l_8_0)
  for id,data in pairs(l_8_0._characters) do
    if data.taken and alive(data.unit) and data.unit:id() ~= -1 then
      return data.unit
    end
  end
end

CriminalsManager._remove = function(l_9_0, l_9_1)
  local data = l_9_0._characters[l_9_1]
  print("[CriminalsManager:_remove]", inspect(data))
  if data.name == l_9_0._local_character then
    l_9_0._local_character = nil
  end
  if data.unit then
    managers.hud:remove_mugshot_by_character_name(data.name)
  else
    managers.hud:remove_teammate_panel_by_name_id(data.name)
  end
  data.taken = false
  data.unit = nil
  data.peer_id = 0
  data.data = {}
end

CriminalsManager.add_character = function(l_10_0, l_10_1, l_10_2, l_10_3, l_10_4)
  print("[CriminalsManager:add_character]", l_10_1, l_10_2, l_10_3, l_10_4)
  Application:stack_dump()
  if l_10_2 then
    l_10_2:base()._tweak_table = l_10_1
  end
  for id,data in pairs(l_10_0._characters) do
    if data.name == l_10_1 then
      if data.taken then
        Application:error("[CriminalsManager:set_character] Error: Trying to take a unit slot that has already been taken!")
        Application:stack_dump()
        Application:error("[CriminalsManager:set_character] -----")
        l_10_0:_remove(id)
      end
      data.taken = true
      data.unit = l_10_2
      data.peer_id = l_10_3
      data.data.ai = l_10_4 or false
      data.data.mask_obj = tweak_data.blackmarket.masks[data.static_data.ai_mask_id].unit
      data.data.mask_id = nil
      data.data.mask_blueprint = nil
      if not l_10_4 and l_10_2 then
        local mask_id = managers.network:session():peer(l_10_3):mask_id()
        data.data.mask_obj = managers.blackmarket:mask_unit_name_by_mask_id(mask_id, l_10_3)
        data.data.mask_id = mask_id
        data.data.mask_blueprint = managers.network:session():peer(l_10_3):mask_blueprint()
      end
      managers.hud:remove_mugshot_by_character_name(l_10_1)
      if l_10_2 then
        data.data.mugshot_id = managers.hud:add_mugshot_by_unit(l_10_2)
        if l_10_2:base().is_local_player then
          l_10_0._local_character = l_10_1
          managers.hud:reset_player_hpbar()
        end
        l_10_2:sound():set_voice(data.static_data.voice)
        l_10_2:inventory():set_mask_visibility(l_10_2:inventory()._mask_visibility)
      else
        if not l_10_4 or not managers.localization:text("menu_" .. l_10_1) then
          data.data.mugshot_id = managers.hud:add_mugshot_without_unit(l_10_1, l_10_4, l_10_3, managers.network:session():peer(l_10_3):name())
      else
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CriminalsManager.set_unit = function(l_11_0, l_11_1, l_11_2)
  print("[CriminalsManager:set_unit] name", l_11_1, "unit", l_11_2)
  Application:stack_dump()
  l_11_2:base()._tweak_table = l_11_1
  for id,data in pairs(l_11_0._characters) do
    if data.name == l_11_1 then
      if not data.taken then
        Application:error("[CriminalsManager:set_character] Error: Trying to set a unit on a slot that has not been taken!")
        Application:stack_dump()
        return 
      end
      data.unit = l_11_2
      managers.hud:remove_mugshot_by_character_name(data.name)
      data.data.mugshot_id = managers.hud:add_mugshot_by_unit(l_11_2)
      data.data.mask_obj = tweak_data.blackmarket.masks[data.static_data.ai_mask_id].unit
      data.data.mask_id = nil
      data.data.mask_blueprint = nil
      if not data.data.ai then
        local mask_id = managers.network:session():peer(data.peer_id):mask_id()
        data.data.mask_obj = managers.blackmarket:mask_unit_name_by_mask_id(mask_id, data.peer_id)
        data.data.mask_id = mask_id
        data.data.mask_blueprint = managers.network:session():peer(data.peer_id):mask_blueprint()
      end
      if l_11_2:base().is_local_player then
        l_11_0._local_character = l_11_1
        managers.hud:reset_player_hpbar()
      end
      l_11_2:sound():set_voice(data.static_data.voice)
  else
    end
  end
end

CriminalsManager.is_taken = function(l_12_0, l_12_1)
  for _,data in pairs(l_12_0._characters) do
    if l_12_1 == data.name then
      return data.taken
    end
  end
  return false
end

CriminalsManager.character_name_by_peer_id = function(l_13_0, l_13_1)
  for _,data in pairs(l_13_0._characters) do
    if data.taken and l_13_1 == data.peer_id then
      return data.name
    end
  end
end

CriminalsManager.character_color_id_by_peer_id = function(l_14_0, l_14_1)
  local workname = l_14_0.character_workname_by_peer_id(l_14_1)
  return l_14_0:character_color_id_by_name(workname)
end

CriminalsManager.character_color_id_by_unit = function(l_15_0, l_15_1)
  local search_key = l_15_1:key()
  for id,data in pairs(l_15_0._characters) do
    if data.unit and data.taken and search_key == data.unit:key() then
      if data.data.ai then
        return 5
      end
      return data.peer_id
    end
  end
end

CriminalsManager.character_color_id_by_name = function(l_16_0, l_16_1)
  for id,data in pairs(l_16_0._characters) do
    if l_16_1 == data.name then
      return data.static_data.color_id
    end
  end
end

CriminalsManager.character_data_by_name = function(l_17_0, l_17_1)
  for _,data in pairs(l_17_0._characters) do
    if data.taken and l_17_1 == data.name then
      return data.data
    end
  end
end

CriminalsManager.character_data_by_peer_id = function(l_18_0, l_18_1)
  for _,data in pairs(l_18_0._characters) do
    if data.taken and l_18_1 == data.peer_id then
      return data.data
    end
  end
end

CriminalsManager.character_data_by_unit = function(l_19_0, l_19_1)
  local search_key = l_19_1:key()
  for id,data in pairs(l_19_0._characters) do
    if data.unit and data.taken and search_key == data.unit:key() then
      return data.data
    end
  end
end

CriminalsManager.character_static_data_by_name = function(l_20_0, l_20_1)
  for _,data in pairs(l_20_0._characters) do
    if l_20_1 == data.name then
      return data.static_data
    end
  end
end

CriminalsManager.character_unit_by_name = function(l_21_0, l_21_1)
  for _,data in pairs(l_21_0._characters) do
    if data.taken and l_21_1 == data.name then
      return data.unit
    end
  end
end

CriminalsManager.character_taken_by_name = function(l_22_0, l_22_1)
  for _,data in pairs(l_22_0._characters) do
    if l_22_1 == data.name then
      return data.taken
    end
  end
end

CriminalsManager.character_peer_id_by_name = function(l_23_0, l_23_1)
  for _,data in pairs(l_23_0._characters) do
    if data.taken and l_23_1 == data.name then
      return data.peer_id
    end
  end
end

CriminalsManager.get_free_character_name = function(l_24_0)
  local available = {}
  for id,data in pairs(l_24_0._characters) do
    local taken = data.taken
    if not taken then
      for _,member in pairs(managers.network:game():all_members()) do
        if member._assigned_name == data.name then
          taken = true
      else
        end
      end
      if not taken then
        table.insert(available, data.name)
      end
    end
    if #available > 0 then
      return available[math.random(#available)]
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CriminalsManager.get_num_player_criminals = function(l_25_0)
  local num = 0
  for id,data in pairs(l_25_0._characters) do
    if data.taken and not data.data.ai then
      num = num + 1
    end
  end
  return num
end

CriminalsManager.remove_character_by_unit = function(l_26_0, l_26_1)
  if type_name(l_26_1) ~= "Unit" then
    return 
  end
  local rem_u_key = l_26_1:key()
  for id,data in pairs(l_26_0._characters) do
    if data.unit and data.taken and rem_u_key == data.unit:key() then
      l_26_0:_remove(id)
      return 
    end
  end
end

CriminalsManager.remove_character_by_peer_id = function(l_27_0, l_27_1)
  for id,data in pairs(l_27_0._characters) do
    if data.taken and l_27_1 == data.peer_id then
      l_27_0:_remove(id)
      return 
    end
  end
end

CriminalsManager.remove_character_by_name = function(l_28_0, l_28_1)
  for id,data in pairs(l_28_0._characters) do
    if data.taken and l_28_1 == data.name then
      l_28_0:_remove(id)
      return 
    end
  end
end

CriminalsManager.character_name_by_unit = function(l_29_0, l_29_1)
  if type_name(l_29_1) ~= "Unit" then
    return nil
  end
  local search_key = l_29_1:key()
  for id,data in pairs(l_29_0._characters) do
    if data.unit and data.taken and search_key == data.unit:key() then
      return data.name
    end
  end
end

CriminalsManager.character_name_by_panel_id = function(l_30_0, l_30_1)
  for id,data in pairs(l_30_0._characters) do
    if data.taken and data.data.panel_id == l_30_1 then
      return data.name
    end
  end
end

CriminalsManager.character_static_data_by_unit = function(l_31_0, l_31_1)
  if type_name(l_31_1) ~= "Unit" then
    return nil
  end
  local search_key = l_31_1:key()
  for id,data in pairs(l_31_0._characters) do
    if data.unit and data.taken and search_key == data.unit:key() then
      return data.static_data
    end
  end
end

CriminalsManager.nr_AI_criminals = function(l_32_0)
  local nr_AI_criminals = 0
  for i,char_data in pairs(l_32_0._characters) do
    if char_data.data.ai then
      nr_AI_criminals = nr_AI_criminals + 1
    end
  end
  return nr_AI_criminals
end


