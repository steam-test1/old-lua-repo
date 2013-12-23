-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\characters\characterattentionobject.luac 

require("lib/units/props/AIAttentionObject")
if not CharacterAttentionObject then
  CharacterAttentionObject = class(AIAttentionObject)
end
CharacterAttentionObject.init = function(l_1_0, l_1_1)
  CharacterAttentionObject.super.init(l_1_0, l_1_1, true)
end

CharacterAttentionObject.setup_attention_positions = function(l_2_0, l_2_1, l_2_2)
  if not l_2_1 then
    l_2_0._m_head_pos = l_2_0._unit:movement():m_head_pos()
  end
  if not l_2_2 then
    l_2_0._m_pos = l_2_0._unit:movement():m_pos()
  end
end

CharacterAttentionObject.chk_settings_diff = function(l_3_0, l_3_1)
  local attention_data = l_3_0._attention_data
  do
    local changes = nil
    if l_3_1 then
      for _,id in ipairs(l_3_1) do
        if not attention_data or not attention_data[id] then
          if not changes then
            changes = {}
          end
          if not changes.added then
            changes.added = {}
          end
          table.insert(changes.added, id)
          for (for control),_ in (for generator) do
          end
          if attention_data then
            if not changes then
              changes = {}
            end
            if not changes.maintained then
              changes.maintained = {}
            end
            table.insert(changes.maintained, id)
          end
        end
      end
      if attention_data then
        for old_id,setting in pairs(attention_data) do
          local found = nil
          if l_3_1 then
            for _,new_id in ipairs(l_3_1) do
              if old_id == new_id then
                found = true
            else
              end
            end
            if not found then
              if not changes then
                changes = {}
              end
              if not changes.removed then
                changes.removed = {}
              end
              table.insert(changes.removed, old_id)
            end
          end
        end
        return changes
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CharacterAttentionObject.set_settings_set = function(l_4_0, l_4_1)
  local attention_data = l_4_0._attention_data
  local changed, register, unregister = nil, nil, nil
  if attention_data then
    if not l_4_1 or not next(l_4_1) then
      l_4_1 = nil
      unregister = true
    else
      for id,settings in pairs(attention_data) do
        if not l_4_1[id] then
          changed = true
      else
        end
      end
      if not changed then
        for id,settings in pairs(l_4_1) do
          if not attention_data[id] then
            changed = true
        else
          end
        end
      elseif l_4_1 and next(l_4_1) then
        register = true
      end
    end
  end
end
if l_4_0._overrides and l_4_1 then
  for id,overrride_setting in pairs(l_4_0._overrides) do
    if l_4_1[id] then
      if not l_4_0._override_restore then
        l_4_0._override_restore = {}
      end
      l_4_0._override_restore[id] = l_4_1[id]
      l_4_1[id] = overrride_setting
    end
  end
  if attention_data and l_4_0._override_restore then
    for id,setting in pairs(attention_data) do
      if not l_4_1[id] then
        l_4_0._override_restore[id] = nil
      end
    end
    if not next(l_4_0._override_restore) then
      l_4_0._override_restore = nil
    else
      l_4_0._override_restore = nil
    end
  end
end
l_4_0._attention_data = l_4_1
if register then
  l_4_0:_register()
elseif unregister then
  if not l_4_0._parent_unit then
    managers.groupai:state():unregister_AI_attention_object(l_4_0._unit:key())
  end
  if changed or unregister then
    l_4_0:_call_listeners()
  end
end

CharacterAttentionObject.get_attention_m_pos = function(l_5_0, l_5_1)
  return l_5_0._m_head_pos
end

CharacterAttentionObject.get_detection_m_pos = function(l_6_0)
  return l_6_0._m_head_pos
end

CharacterAttentionObject.get_ground_m_pos = function(l_7_0)
  return l_7_0._m_pos
end

CharacterAttentionObject._register = function(l_8_0)
  if l_8_0._parent_unit or l_8_0._unit:movement() then
    managers.groupai:state():register_AI_attention_object(l_8_0._unit, l_8_0, l_8_0._unit:movement():nav_tracker())
  end
end


