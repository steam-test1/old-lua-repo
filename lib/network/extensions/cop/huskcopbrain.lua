-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\extensions\cop\huskcopbrain.luac 

local tmp_vec1 = Vector3()
if not HuskCopBrain then
  HuskCopBrain = class()
end
HuskCopBrain._NET_EVENTS = {weapon_laser_on = 1, weapon_laser_off = 2}
HuskCopBrain.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
end

HuskCopBrain.post_init = function(l_2_0)
  l_2_0._alert_listen_key = "HuskCopBrain" .. tostring(l_2_0._unit:key())
  local alert_listen_filter = managers.groupai:state():get_unit_type_filter("criminal")
  managers.groupai:state():add_alert_listener(l_2_0._alert_listen_key, callback(l_2_0, l_2_0, "on_alert"), alert_listen_filter, {footstep = true, bullet = true, vo_cbt = true, vo_intimidate = true, aggression = true}, l_2_0._unit:movement():m_head_pos())
  l_2_0._last_alert_t = 0
  l_2_0._unit:character_damage():add_listener("HuskCopBrain_death" .. tostring(l_2_0._unit:key()), {"death"}, callback(l_2_0, l_2_0, "clbk_death"))
end

HuskCopBrain.interaction_voice = function(l_3_0)
  return l_3_0._interaction_voice
end

HuskCopBrain.on_intimidated = function(l_4_0, l_4_1, l_4_2)
  l_4_1 = math.clamp(math.ceil(l_4_1 * 10), 0, 10)
  l_4_0._unit:network():send_to_host("long_dis_interaction", l_4_1, l_4_2)
  return l_4_0._interaction_voice
end

HuskCopBrain.clbk_death = function(l_5_0, l_5_1, l_5_2)
  if l_5_0._alert_listen_key then
    managers.groupai:state():remove_alert_listener(l_5_0._alert_listen_key)
    l_5_0._alert_listen_key = nil
  end
  if l_5_0._unit:inventory():equipped_unit() then
    l_5_0._unit:inventory():equipped_unit():base():set_laser_enabled(false)
  end
end

HuskCopBrain.set_interaction_voice = function(l_6_0, l_6_1)
  l_6_0._interaction_voice = l_6_1
end

HuskCopBrain.load = function(l_7_0, l_7_1)
  local my_load_data = l_7_1.brain
  l_7_0:set_interaction_voice(my_load_data.interaction_voice)
  if my_load_data.weapon_laser_on then
    l_7_0:sync_net_event(l_7_0._NET_EVENTS.weapon_laser_on)
  end
end

HuskCopBrain.on_tied = function(l_8_0, l_8_1)
  l_8_0._unit:network():send_to_host("unit_tied", l_8_1)
end

HuskCopBrain.on_trade = function(l_9_0, l_9_1)
  l_9_0._unit:network():send_to_host("unit_traded", l_9_1)
end

HuskCopBrain.on_cool_state_changed = function(l_10_0, l_10_1)
end

HuskCopBrain.action_complete_clbk = function(l_11_0, l_11_1)
end

HuskCopBrain.on_alert = function(l_12_0, l_12_1)
  if l_12_0._unit:id() == -1 then
    return 
  end
  if TimerManager:game():time() - l_12_0._last_alert_t < 5 then
    return 
  end
  if CopLogicBase._chk_alert_obstructed(l_12_0._unit:movement():m_head_pos(), l_12_1) then
    return 
  end
  l_12_0._unit:network():send_to_host("alert", l_12_1[5])
  l_12_0._last_alert_t = TimerManager:game():time()
end

HuskCopBrain.on_long_dis_interacted = function(l_13_0, l_13_1, l_13_2)
  l_13_1 = math.clamp(math.ceil(l_13_1 * 10), 0, 10)
  l_13_0._unit:network():send_to_host("long_dis_interaction", l_13_1, l_13_2)
end

HuskCopBrain.sync_net_event = function(l_14_0, l_14_1)
  if l_14_1 == l_14_0._NET_EVENTS.weapon_laser_on then
    l_14_0._weapon_laser_on = true
    l_14_0._unit:inventory():equipped_unit():base():set_laser_enabled(true)
    managers.enemy:_destroy_unit_gfx_lod_data(l_14_0._unit:key())
  else
    if l_14_1 == l_14_0._NET_EVENTS.weapon_laser_off then
      l_14_0._weapon_laser_on = nil
      if l_14_0._unit:inventory():equipped_unit() then
        l_14_0._unit:inventory():equipped_unit():base():set_laser_enabled(false)
      end
      if not l_14_0._unit:character_damage():dead() then
        managers.enemy:_create_unit_gfx_lod_data(l_14_0._unit)
      end
    end
  end
end

HuskCopBrain.pre_destroy = function(l_15_0)
  if l_15_0._alert_listen_key then
    managers.groupai:state():remove_alert_listener(l_15_0._alert_listen_key)
    l_15_0._alert_listen_key = nil
  end
  if l_15_0._weapon_laser_on then
    l_15_0:sync_net_event(l_15_0._NET_EVENTS.weapon_laser_off)
  end
end


