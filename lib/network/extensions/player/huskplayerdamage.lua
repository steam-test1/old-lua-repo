-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\extensions\player\huskplayerdamage.luac 

if not HuskPlayerDamage then
  HuskPlayerDamage = class()
end
HuskPlayerDamage.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._spine2_obj = l_1_1:get_object(Idstring("Spine2"))
  l_1_0._listener_holder = EventListenerHolder:new()
end

HuskPlayerDamage._call_listeners = function(l_2_0, l_2_1)
  CopDamage._call_listeners(l_2_0, l_2_1)
end

HuskPlayerDamage.add_listener = function(l_3_0, ...)
  CopDamage.add_listener(l_3_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

HuskPlayerDamage.remove_listener = function(l_4_0, l_4_1)
  CopDamage.remove_listener(l_4_0, l_4_1)
end

HuskPlayerDamage.sync_damage_bullet = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local attack_data = {attacker_unit = l_5_1, attack_dir = Vector3(1, 0, 0), pos = mvector3.copy(l_5_0._unit:movement():m_head_pos()), result = {type = "hurt", variant = "bullet"}}
l_5_0:_call_listeners(attack_data)
end

HuskPlayerDamage.shoot_pos_mid = function(l_6_0, l_6_1)
  l_6_0._spine2_obj:m_position(l_6_1)
end

HuskPlayerDamage.set_last_down_time = function(l_7_0, l_7_1)
  l_7_0._last_down_time = l_7_1
end

HuskPlayerDamage.down_time = function(l_8_0)
  return l_8_0._last_down_time
end

HuskPlayerDamage.arrested = function(l_9_0)
  return l_9_0._unit:movement():current_state_name() == "arrested"
end

HuskPlayerDamage.incapacitated = function(l_10_0)
  return l_10_0._unit:movement():current_state_name() == "incapacitated"
end

HuskPlayerDamage.dead = function(l_11_0)
end


