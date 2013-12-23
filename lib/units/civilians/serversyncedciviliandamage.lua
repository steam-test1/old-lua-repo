-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\civilians\serversyncedciviliandamage.luac 

if not ServerSyncedCivilianDamage then
  ServerSyncedCivilianDamage = class(CivilianDamage)
end
local l_0_0 = ServerSyncedCivilianDamage
local l_0_1 = {}
l_0_1.hurt = 1
l_0_1.light_hurt = 2
l_0_1.heavy_hurt = 3
l_0_1.death = 4
l_0_0._RESULT_INDEX_TABLE = l_0_1
l_0_0 = ServerSyncedCivilianDamage
l_0_1 = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  l_1_0:_send_sync_bullet_attack_result(l_1_1, l_1_5)
end

l_0_0._send_bullet_attack_result = l_0_1
l_0_0 = ServerSyncedCivilianDamage
l_0_1 = function(l_2_0, l_2_1, l_2_2, l_2_3)
  l_2_0:_send_sync_explosion_attack_result(l_2_1)
end

l_0_0._send_explosion_attack_result = l_0_1
l_0_0 = ServerSyncedCivilianDamage
l_0_1 = function(l_3_0, l_3_1, l_3_2, l_3_3)
  l_3_0:_send_sync_melee_attack_result(l_3_1, l_3_3, 0)
end

l_0_0._send_melee_attack_result = l_0_1
l_0_0 = ServerSyncedCivilianDamage
l_0_1 = function(l_4_0, l_4_1, l_4_2)
  TeamAIDamage._send_bullet_attack_result(l_4_0, l_4_1, l_4_2)
end

l_0_0._send_sync_bullet_attack_result = l_0_1
l_0_0 = ServerSyncedCivilianDamage
l_0_1 = function(l_5_0, l_5_1)
  TeamAIDamage._send_explosion_attack_result(l_5_0, l_5_1)
end

l_0_0._send_sync_explosion_attack_result = l_0_1
l_0_0 = ServerSyncedCivilianDamage
l_0_1 = function(l_6_0, l_6_1, l_6_2, l_6_3)
  TeamAIDamage._send_melee_attack_result(l_6_0, l_6_1, l_6_2, l_6_3)
end

l_0_0._send_sync_melee_attack_result = l_0_1

