-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\props\aiattentionobject.luac 

if not AIAttentionObject then
  AIAttentionObject = class()
end
AIAttentionObject.REACT_IDLE = 1
AIAttentionObject.REACT_CURIOUS = 2
AIAttentionObject.REACT_SUSPICIOUS = 3
AIAttentionObject.REACT_SURPRISED = 4
AIAttentionObject.REACT_SCARED = 5
AIAttentionObject.REACT_AIM = 6
AIAttentionObject.REACT_ARREST = 7
AIAttentionObject.REACT_DISARM = 8
AIAttentionObject.REACT_SHOOT = 9
AIAttentionObject.REACT_MELEE = 10
AIAttentionObject.REACT_COMBAT = 11
AIAttentionObject.REACT_SPECIAL_ATTACK = 12
AIAttentionObject.REACT_MIN = AIAttentionObject.REACT_IDLE
AIAttentionObject.REACT_MAX = AIAttentionObject.REACT_SPECIAL_ATTACK
AIAttentionObject.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._unit = l_1_1
  l_1_0._attention_data = nil
  l_1_0._listener_holder = ListenerHolder:new()
  l_1_0:setup_attention_positions(nil, nil)
  l_1_0._is_extension = not l_1_2
  if l_1_0._is_extension then
    l_1_0:set_update_enabled(true)
    if Network:is_client() and l_1_1:unit_data().only_visible_in_editor then
      l_1_1:set_visible(false)
    end
    if l_1_0._initial_settings then
      local preset_list = string.split(l_1_0._initial_settings, " ")
      for _,preset_name in ipairs(preset_list) do
        local attention_desc = tweak_data.attention.settings[preset_name]
        local att_setting = PlayerMovement._create_attention_setting_from_descriptor(l_1_0, attention_desc, preset_name)
        l_1_0:add_attention(att_setting)
      end
    end
  end
end

AIAttentionObject.update = function(l_2_0, l_2_1, l_2_2, l_2_3)
  l_2_0._attention_obj:m_position(l_2_0._observer_info.m_pos)
end

AIAttentionObject.set_update_enabled = function(l_3_0, l_3_1)
  l_3_0._unit:set_extension_update_enabled(Idstring("attention"), l_3_1)
end

AIAttentionObject.set_detection_object_name = function(l_4_0, l_4_1)
  l_4_0._attention_obj_name = l_4_1
  l_4_0:setup_attention_positions()
end

AIAttentionObject.setup_attention_positions = function(l_5_0)
  if l_5_0._attention_obj_name then
    l_5_0._attention_obj = l_5_0._unit:get_object(Idstring(l_5_0._attention_obj_name))
  else
    l_5_0._attention_obj = l_5_0._unit:orientation_object()
  end
  l_5_0._observer_info = {m_pos = l_5_0._attention_obj:position()}
end

AIAttentionObject.attention_data = function(l_6_0)
  return l_6_0._attention_data
end

AIAttentionObject.unit = function(l_7_0)
  return l_7_0._unit
end

AIAttentionObject.add_attention = function(l_8_0, l_8_1)
  local needs_register = nil
  if not l_8_0._attention_data then
    l_8_0._attention_data = {}
    needs_register = true
  end
  if l_8_0._overrides and l_8_0._overrides[l_8_1.id] then
    if not l_8_0._override_restore then
      l_8_0._override_restore = {}
    end
    l_8_0._override_restore[l_8_1.id] = l_8_1
    l_8_0._attention_data[l_8_1.id] = l_8_0._overrides[l_8_1.id]
  else
    l_8_0._attention_data[l_8_1.id] = l_8_1
  end
  if needs_register then
    l_8_0:_register()
  end
  l_8_0:_call_listeners()
end

AIAttentionObject.remove_attention = function(l_9_0, l_9_1)
  if not l_9_0._attention_data then
    return 
  end
  if l_9_0._override_restore and l_9_0._override_restore[l_9_1] then
    l_9_0._override_restore[l_9_1] = nil
    if not next(l_9_0._override_restore) then
      l_9_0._override_restore = nil
    end
  end
  if l_9_0._attention_data[l_9_1] then
    l_9_0._attention_data[l_9_1] = nil
    if not next(l_9_0._attention_data) then
      if not l_9_0._parent_unit then
        managers.groupai:state():unregister_AI_attention_object(l_9_0._unit:key())
      end
      l_9_0:_call_listeners()
    end
     -- Warning: missing end command somewhere! Added here
  end
end

AIAttentionObject.set_attention = function(l_10_0, l_10_1, l_10_2)
  if l_10_0._override_restore then
    for att_id,att_setting in pairs(l_10_0._attention_data) do
      if att_id ~= l_10_2 and l_10_0._override_restore[att_id] then
        l_10_0._override_restore[att_id] = nil
      end
    end
    if not next(l_10_0._override_restore) then
      l_10_0._override_restore = nil
    end
  end
  if l_10_0._attention_data then
    if l_10_1 then
      if l_10_0._overrides and not l_10_2 then
        local override_setting = l_10_0._overrides[l_10_1.id]
      end
      l_10_0._attention_data = {l_10_1.id = not l_10_2 and override_setting or l_10_1}
    else
      l_10_0._attention_data = nil
      if not l_10_0._parent_unit then
        managers.groupai:state():unregister_AI_attention_object(l_10_0._unit:key())
      end
      l_10_0:_call_listeners()
    elseif l_10_1 then
      l_10_0._attention_data = {}
      if not l_10_2 then
        l_10_0._attention_data = {l_10_1.id = l_10_1}
        l_10_0:_register()
        l_10_0:_call_listeners()
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

AIAttentionObject.override_attention = function(l_11_0, l_11_1, l_11_2)
  if l_11_2 then
    if (not l_11_0._override_restore or not l_11_0._override_restore[l_11_1]) and l_11_0._attention_data then
      local original_preset = l_11_0._attention_data[l_11_1]
    end
    if original_preset then
      if not l_11_0._override_restore then
        l_11_0._override_restore = {}
      end
      l_11_0._override_restore[l_11_1] = original_preset
    end
    if not l_11_0._overrides then
      l_11_0._overrides = {}
    end
    l_11_0._overrides[l_11_1] = l_11_2
    if l_11_0._attention_data and l_11_0._attention_data[l_11_1] then
      l_11_0._attention_data[l_11_1] = l_11_2
      l_11_0:_call_listeners()
    elseif l_11_0._overrides then
      if l_11_0._override_restore then
        local original_preset = l_11_0._override_restore[l_11_1]
      end
      if original_preset then
        l_11_0._override_restore[l_11_1] = nil
        if not next(l_11_0._override_restore) then
          l_11_0._override_restore = nil
        end
      end
      l_11_0._overrides[l_11_1] = nil
      if not next(l_11_0._overrides) then
        l_11_0._overrides = nil
      end
      if original_preset then
        l_11_0:add_attention(original_preset)
      else
        l_11_0:remove_attention(l_11_1)
      end
    end
  end
end

AIAttentionObject.get_attention = function(l_12_0, l_12_1, l_12_2, l_12_3)
  if not l_12_0._attention_data then
    return 
  end
  if not l_12_2 then
    l_12_2 = AIAttentionObject.REACT_MIN
  end
  if not l_12_3 then
    l_12_3 = AIAttentionObject.REACT_MAX
  end
  local nav_manager = managers.navigation
  local access_f = nav_manager.check_access
  local settings_match = nil
  for id,settings in pairs(l_12_0._attention_data) do
    if l_12_2 <= settings.reaction and settings.reaction <= l_12_3 and (not settings_match or settings_match.reaction < settings.reaction) and access_f(nav_manager, settings.filter, l_12_1, 0) then
      settings_match = settings
    end
  end
  return settings_match
end

AIAttentionObject.verify_attention = function(l_13_0, l_13_1, l_13_2, l_13_3)
  if not l_13_0._attention_data then
    return 
  end
  local new_settings = l_13_0:get_attention(filter, l_13_2, l_13_3)
  return new_settings == l_13_1
end

AIAttentionObject.get_attention_m_pos = function(l_14_0, l_14_1)
  return l_14_0._observer_info.m_pos
end

AIAttentionObject.get_detection_m_pos = function(l_15_0)
  return l_15_0._observer_info.m_pos
end

AIAttentionObject.get_ground_m_pos = function(l_16_0)
  return l_16_0._observer_info.m_pos
end

AIAttentionObject.add_listener = function(l_17_0, l_17_1, l_17_2)
  l_17_0._listener_holder:add(l_17_1, l_17_2)
end

AIAttentionObject.remove_listener = function(l_18_0, l_18_1)
  l_18_0._listener_holder:remove(l_18_1)
end

AIAttentionObject._call_listeners = function(l_19_0)
  do
    if not l_19_0._parent_unit then
      local u_key = l_19_0._unit:key()
      managers.groupai:state():on_AI_attention_changed(u_key)
      l_19_0._listener_holder:call(u_key)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

AIAttentionObject._register = function(l_20_0)
  if not l_20_0._parent_unit then
    managers.groupai:state():register_AI_attention_object(l_20_0._unit, l_20_0, nil)
     -- Warning: missing end command somewhere! Added here
  end
end

AIAttentionObject.link = function(l_21_0, l_21_1, l_21_2, l_21_3)
  l_21_0._unit:unlink()
  if l_21_1 then
    l_21_0._parent_unit = l_21_1
    l_21_0._parent_obj_name = l_21_2
    l_21_0._local_pos = l_21_3
    l_21_0._parent_unit_key = l_21_1:key()
    l_21_0._unit:body(0):set_enabled(false)
    l_21_0._unit:set_moving()
    local parent_obj = l_21_1:get_object(Idstring(l_21_2))
    local parent_pos = parent_obj:position()
    local parent_rot = parent_obj:rotation()
    local att_obj_w_pos = l_21_3:rotate_with(parent_rot) + parent_pos
    l_21_1:link(Idstring(l_21_2), l_21_0._unit)
    l_21_0._unit:set_position(att_obj_w_pos)
    if Network:is_server() then
      if l_21_0._parent_unit:id() == -1 then
        debug_pause_unit(l_21_0._parent_unit, "[AIAttentionObject:set_parent_unit] attention object parent is not network synched", l_21_0._parent_unit)
      end
      managers.network:session():send_to_peers_synched("link_attention_no_rot", l_21_0._parent_unit, l_21_0._unit, l_21_2, l_21_3)
    end
    l_21_0:set_update_enabled(true)
  else
    l_21_0._parent_unit = nil
    l_21_0._parent_obj_name = nil
    l_21_0._local_pos = nil
    l_21_0._parent_unit_key = nil
    if Network:is_server() then
      managers.network:session():send_to_peers_synched("unlink_attention", l_21_0._unit)
    end
    l_21_0:set_update_enabled(false)
  end
end

AIAttentionObject.save = function(l_22_0, l_22_1)
  if alive(l_22_0._parent_unit) then
    l_22_1.parent_u_id = l_22_0._parent_unit:unit_data().unit_id
    l_22_1.parent_obj_name = l_22_0._parent_obj_name
    l_22_1.local_pos = l_22_0._local_pos
  end
end

AIAttentionObject.load = function(l_23_0, l_23_1)
  if not l_23_1 or not l_23_1.parent_u_id then
    return 
  end
  local parent_unit = nil
  if Application:editor() then
    parent_unit = managers.editor:unit_with_id(l_23_1.parent_u_id)
  else
    parent_unit = managers.worlddefinition:get_unit_on_load(l_23_1.parent_u_id, callback(l_23_0, l_23_0, "clbk_load_parent_unit"))
  end
  if parent_unit then
    l_23_0:link(parent_unit, l_23_1.parent_obj_name, l_23_1.local_pos)
  else
    if not Application:editor() then
      l_23_0._load_data = l_23_1
    else
      debug_pause_unit(l_23_0._unit, "[AIAttentionObject:load] failed to link", l_23_0._unit)
    end
  end
end

AIAttentionObject.clbk_load_parent_unit = function(l_24_0, l_24_1)
  if l_24_1 then
    l_24_0:link(l_24_1, l_24_0._load_data.parent_obj_name, l_24_0._load_data.local_pos)
  end
  l_24_0._load_data = nil
end

AIAttentionObject.destroy = function(l_25_0)
  l_25_0:set_attention(nil)
  local extensions = l_25_0._unit:extensions()
  local last_extension_name = extensions[#extensions]
  local last_extension = l_25_0._unit[last_extension_name]
  if l_25_0 == last_extension then
    l_25_0._unit:base():pre_destroy(l_25_0._unit)
  end
end


