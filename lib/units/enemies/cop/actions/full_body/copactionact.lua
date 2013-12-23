-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\actions\full_body\copactionact.luac 

local mvec3_set_z = mvector3.set_z
local mvec3_set = mvector3.set
local mvec3_sub = mvector3.subtract
local mvec3_norm = mvector3.normalize
local mvec3_add = mvector3.add
local tmp_vec1 = Vector3()
do
  local ids_aim = Idstring("aim")
  if not CopActionAct then
    CopActionAct = class()
  end
  CopActionAct._ACT_CATEGORY_INDEX = {"script", "enemy_spawn", "civilian_spawn", "SO"}
  CopActionAct._act_redirects = {}
  CopActionAct._act_redirects.script = {"attached_collar_enter", "suppressed_reaction", "surprised", "hands_up", "hands_back", "tied", "drop", "panic", "idle", "halt", "stand", "crouch", "revive", "untie", "arrest", "arrest_call", "gesture_stop", "sabotage_device_low", "sabotage_device_mid", "sabotage_device_high", "so_civ_dummy_act_loop"}
  CopActionAct._act_redirects.enemy_spawn = {"e_sp_car_exit_to_cbt_front_l", "e_sp_car_exit_to_cbt_front_r", "e_sp_car_exit_to_cbt_front_l_var2", "e_sp_car_exit_to_cbt_front_r_var2", "e_sp_jump_down_heli_cbt_right", "e_sp_jump_down_heli_cbt_left", "e_sp_hurt_from_truck", "e_sp_aim_rifle_crh", "e_sp_aim_rifle_std", "e_sp_crh_to_std_rifle", "e_sp_down_12m", "e_sp_down_17m", "e_sp_up_1_down_9_25m", "e_sp_up_2_75_down_1_25m", "e_sp_up_1_down_9m", "e_sp_up_1_down_13m", "e_sp_down_8m", "e_sp_down_12m_var2", "e_sp_down_8m_var2", "e_sp_down_4m_var2", "e_sp_down_9_6m", "e_sp_repel_into_window", "e_sp_down_16m_right", "e_sp_down_16m_left", "e_sp_up_1_down_9m_var2"}
   -- DECOMPILER ERROR: No list found. Setlist fails

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: No list found. Setlist fails

end
 -- Warning: undefined locals caused missing assignments!

