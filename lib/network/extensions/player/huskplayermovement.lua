-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\extensions\player\huskplayermovement.luac 

local mvec3_set = mvector3.set
local mvec3_sub = mvector3.subtract
local mvec3_add = mvector3.add
local mvec3_mul = mvector3.multiply
local mvec3_norm = mvector3.normalize
local mvec3_dot = mvector3.dot
local mvec3_set_z = mvector3.set_z
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
if not HuskPlayerMovement then
  HuskPlayerMovement = class()
end
HuskPlayerMovement._calc_suspicion_ratio_and_sync = PlayerMovement._calc_suspicion_ratio_and_sync
HuskPlayerMovement.on_suspicion = PlayerMovement.on_suspicion
HuskPlayerMovement.state_enter_time = PlayerMovement.state_enter_time
HuskPlayerMovement.SO_access = PlayerMovement.SO_access
HuskPlayerMovement._walk_anim_velocities = {stand = {ntl = {walk = {fwd = 183.47999572754, bwd = 156.39999389648, l = 150.36000061035, r = 152.14999389648}, run = {fwd = 381.35000610352, bwd = 402.61999511719, l = 405.05999755859, r = 405.05999755859}}, cbt = {walk = {fwd = 208.27000427246, bwd = 208.27000427246, l = 192.75, r = 192.75}, run = {fwd = 457.98001098633, bwd = 416.76998901367, l = 416.35000610352, r = 411.89999389648}, sprint = {79, 35, 14, 9; fwd = 672, bwd = 547, l = 488, r = 547}}}, crouch = {cbt = {walk = {fwd = 174.44999694824, bwd = 163.74000549316, l = 152.13999938965, r = 162.85000610352}, run = {fwd = 312.25, bwd = 268.67999267578, l = 282.92999267578, r = 282.92999267578}}}}
HuskPlayerMovement._walk_anim_velocities.stand.hos = HuskPlayerMovement._walk_anim_velocities.stand.cbt
HuskPlayerMovement._walk_anim_velocities.crouch.hos = HuskPlayerMovement._walk_anim_velocities.crouch.cbt
HuskPlayerMovement._walk_anim_lengths = {stand = {ntl = {walk = {fwd = 31, bwd = 31, l = 29, r = 31}, run = {fwd = 26, bwd = 17, l = 20, r = 20}}, cbt = {walk = {fwd = 26, bwd = 26, l = 26, r = 26}, run = {fwd = 20, bwd = 18, l = 18, r = 20}, sprint = {fwd = 16, bwd = 16, l = 16, r = 19}, run_start = {fwd = 31, bwd = 34, l = 27, r = 26}, run_start_turn = {bwd = 29, l = 33, r = 31}, run_stop = {fwd = 31, bwd = 37, l = 32, r = 36}}}, crouch = {cbt = {walk = {fwd = 31, bwd = 31, l = 27, r = 28}, run = {fwd = 21, bwd = 20, l = 19, r = 19}, run_start = {fwd = 35, bwd = 19, l = 33, r = 33}, run_start_turn = {bwd = 31, l = 40, r = 37}, run_stop = {fwd = 35, bwd = 19, l = 27, r = 30}}}, wounded = {cbt = {walk = {fwd = 28, bwd = 29, l = 29, r = 29}, run = {fwd = 19, bwd = 18, l = 19, r = 19}}}, panic = {ntl = {run = {fwd = 15, bwd = 15, l = 15, r = 16}}}}
for pose,stances in pairs(HuskPlayerMovement._walk_anim_lengths) do
  for stance,speeds in pairs(stances) do
    for speed,sides in pairs(speeds) do
      for side,speed in pairs(sides) do
        sides[side] = speed * 0.033330000936985
      end
    end
  end
end
HuskPlayerMovement._walk_anim_lengths.stand.hos = HuskPlayerMovement._walk_anim_lengths.stand.cbt
HuskPlayerMovement._walk_anim_lengths.crouch.hos = HuskPlayerMovement._walk_anim_lengths.crouch.cbt
HuskPlayerMovement._matching_walk_anims = {fwd = {bwd = true}, bwd = {fwd = true}, l = {r = true}, r = {l = true}}
HuskPlayerMovement._char_name_to_index = {russian = 1, german = 2, american = 3, spanish = 4}
HuskPlayerMovement._char_model_names = {russian = "g_russian", german = "g_body", american = "g_american", spanish = "g_spaniard"}
HuskPlayerMovement._stance_names = {"ntl", "hos", "cbt", "wnd"}
HuskPlayerMovement._look_modifier_name = Idstring("action_upper_body")
HuskPlayerMovement._head_modifier_name = Idstring("look_head")
HuskPlayerMovement._arm_modifier_name = Idstring("aim_r_arm")
HuskPlayerMovement._mask_off_modifier_name = Idstring("look_mask_off")
HuskPlayerMovement.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._machine = l_1_1:anim_state_machine()
  l_1_0._m_pos = l_1_1:position()
  l_1_0._m_rot = l_1_1:rotation()
  l_1_0._look_dir = l_1_0._m_rot:y()
  l_1_0._sync_look_dir = nil
  l_1_0._look_ang_vel = 0
  l_1_0._move_data = nil
  l_1_0._last_vel_z = 0
  l_1_0._sync_pos = nil
  l_1_0._nav_tracker = nil
  l_1_0._look_modifier = l_1_0._machine:get_modifier(l_1_0._look_modifier_name)
  l_1_0._head_modifier = l_1_0._machine:get_modifier(l_1_0._head_modifier_name)
  l_1_0._arm_modifier = l_1_0._machine:get_modifier(l_1_0._arm_modifier_name)
  l_1_0._mask_off_modifier = l_1_0._machine:get_modifier(l_1_0._mask_off_modifier_name)
  l_1_0._aim_up_expire_t = nil
  l_1_0._is_weapon_gadget_on = nil
  local stance = {}
  l_1_0._stance = stance
  stance.names = l_1_0._stance_names
  stance.values = {1, 0, 0}
  stance.blend = {0.80000001192093, 0.5, 0.30000001192093}
  stance.code = 1
  stance.name = "ntl"
  stance.owner_stance_code = 1
  l_1_0._m_stand_pos = mvector3.copy(l_1_0._m_pos)
  mvector3.set_z(l_1_0._m_stand_pos, l_1_0._m_pos.z + 140)
  l_1_0._m_com = math.lerp(l_1_0._m_pos, l_1_0._m_stand_pos, 0.5)
  l_1_0._obj_head = l_1_1:get_object(Idstring("Head"))
  l_1_0._obj_spine = l_1_1:get_object(Idstring("Spine1"))
  l_1_0._m_head_rot = Rotation(l_1_0._look_dir, math.UP)
  l_1_0._m_head_pos = l_1_0._obj_head:position()
  l_1_0._m_detect_pos = mvector3.copy(l_1_0._m_head_pos)
  l_1_0._footstep_style = nil
  l_1_0._footstep_event = ""
  l_1_0._state = "mask_off"
  l_1_0._state_enter_t = TimerManager:game():time()
  l_1_0._pose_code = 1
  l_1_0._tase_effect_table = {effect = Idstring("effects/payday2/particles/character/taser_hittarget"), parent = l_1_0._unit:get_object(Idstring("e_taser"))}
  l_1_0._sequenced_events = {}
  l_1_0._synced_suspicion = false
  l_1_0._suspicion_ratio = false
  l_1_0._SO_access = managers.navigation:convert_access_flag("teamAI1")
  l_1_0._slotmask_gnd_ray = managers.slot:get_mask("AI_graph_obstacle_check")
end

HuskPlayerMovement.post_init = function(l_2_0)
  l_2_0._ext_anim = l_2_0._unit:anim_data()
  l_2_0._unit:inventory():add_listener("HuskPlayerMovement", {"equip"}, callback(l_2_0, l_2_0, "clbk_inventory_event"))
  if managers.navigation:is_data_ready() then
    l_2_0._nav_tracker = managers.navigation:create_nav_tracker(l_2_0._unit:position())
    l_2_0._standing_nav_seg_id = l_2_0._nav_tracker:nav_segment()
    l_2_0._pos_rsrv_id = managers.navigation:get_pos_reservation_id()
  end
  l_2_0._unit:inventory():synch_equipped_weapon(2)
  l_2_0._attention_handler = CharacterAttentionObject:new(l_2_0._unit)
  l_2_0._attention_handler:setup_attention_positions(l_2_0._m_detect_pos, nil)
  l_2_0._enemy_weapons_hot_listen_id = "PlayerMovement" .. tostring(l_2_0._unit:key())
  managers.groupai:state():add_listener(l_2_0._enemy_weapons_hot_listen_id, {"enemy_weapons_hot"}, callback(l_2_0, PlayerMovement, "clbk_enemy_weapons_hot"))
end

HuskPlayerMovement.set_character_anim_variables = function(l_3_0)
  local char_name = managers.criminals:character_name_by_unit(l_3_0._unit)
  if not char_name then
    return 
  end
  local mesh_name = l_3_0._char_model_names[char_name] .. (managers.player._player_mesh_suffix or "")
  local mesh_obj = l_3_0._unit:get_object(Idstring(mesh_name))
  if mesh_obj then
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  l_3_0._unit:get_object(Idstring(l_3_0._char_model_names.german)):set_visibility(false)
  mesh_obj:set_visibility(true)
  l_3_0._plr_mesh_name = mesh_name
end
local char_index = 1
l_3_0._machine:set_global("husk" .. tostring(char_index), 1)
l_3_0:check_visual_equipment()
end

HuskPlayerMovement.check_visual_equipment = function(l_4_0)
  local peer_id = managers.network:game():member_from_unit(l_4_0._unit):peer():id()
  local deploy_data = managers.player:get_synced_deployable_equipment(peer_id)
  if deploy_data then
    l_4_0:set_visual_deployable_equipment(deploy_data.deployable, deploy_data.amount)
  end
  local carry_data = managers.player:get_synced_carry(peer_id)
  if carry_data then
    l_4_0:set_visual_carry(carry_data.carry_id)
  end
end

HuskPlayerMovement.set_visual_deployable_equipment = function(l_5_0, l_5_1, l_5_2)
  local visible = l_5_2 > 0
  local tweak_data = tweak_data.equipments[l_5_1]
  local object_name = tweak_data.visual_object
  l_5_0._unit:get_object(Idstring(object_name)):set_visibility(visible)
end

HuskPlayerMovement.set_visual_carry = function(l_6_0, l_6_1)
  do
    if not tweak_data.carry[l_6_1].visual_object then
      local object_name = not l_6_1 or "g_lootbag"
    end
    l_6_0._current_visual_carry_object = l_6_0._unit:get_object(Idstring(object_name))
    l_6_0._current_visual_carry_object:set_visibility(true)
  end
  do return end
  if alive(l_6_0._current_visual_carry_object) then
    l_6_0._current_visual_carry_object:set_visibility(false)
    l_6_0._current_visual_carry_object = nil
  end
end

HuskPlayerMovement.update = function(l_7_0, l_7_1, l_7_2, l_7_3)
  l_7_0:_calculate_m_pose()
  l_7_0:_upd_sequenced_events(l_7_2, l_7_3)
  if l_7_0._attention_updator then
    l_7_0._attention_updator(l_7_3)
  end
  if not l_7_0._movement_updator and l_7_0._move_data and (l_7_0._state == "standard" or l_7_0._state == "mask_off" or l_7_0._state == "clean" or l_7_0._state == "carry") then
    l_7_0._movement_updator = callback(l_7_0, l_7_0, "_upd_move_standard")
    l_7_0._last_vel_z = 0
  end
  if l_7_0._movement_updator then
    l_7_0._movement_updator(l_7_2, l_7_3)
  end
  l_7_0:_upd_stance(l_7_2)
  if not l_7_0._peer_weapon_spawned and alive(l_7_0._unit) then
    local inventory = l_7_0._unit:inventory()
    if inventory and inventory.check_peer_weapon_spawn then
      l_7_0._peer_weapon_spawned = inventory:check_peer_weapon_spawn()
    else
      l_7_0._peer_weapon_spawned = true
    end
  end
end

HuskPlayerMovement.enable_update = function(l_8_0)
end

HuskPlayerMovement.sync_look_dir = function(l_9_0, l_9_1)
  mvector3.normalize(l_9_1)
  l_9_0._sync_look_dir = l_9_1
end

HuskPlayerMovement.set_look_dir_instant = function(l_10_0, l_10_1)
  l_10_0._look_dir = l_10_1
  l_10_0._look_modifier:set_target_y(l_10_0._look_dir)
  l_10_0._sync_look_dir = nil
end

HuskPlayerMovement.m_pos = function(l_11_0)
  return l_11_0._m_pos
end

HuskPlayerMovement.m_stand_pos = function(l_12_0)
  return l_12_0._m_stand_pos
end

HuskPlayerMovement.m_com = function(l_13_0)
  return l_13_0._m_com
end

HuskPlayerMovement.m_head_rot = function(l_14_0)
  return l_14_0._m_head_rot
end

HuskPlayerMovement.m_head_pos = function(l_15_0)
  return l_15_0._m_head_pos
end

HuskPlayerMovement.m_detect_pos = function(l_16_0)
  return l_16_0._m_detect_pos
end

HuskPlayerMovement.m_rot = function(l_17_0)
  return l_17_0._m_rot
end

HuskPlayerMovement.get_object = function(l_18_0, l_18_1)
  return l_18_0._unit:get_object(l_18_1)
end

HuskPlayerMovement.detect_look_dir = function(l_19_0)
  if not l_19_0._sync_look_dir then
    return l_19_0._look_dir
  end
end

HuskPlayerMovement.look_dir = function(l_20_0)
  return l_20_0._look_dir
end

HuskPlayerMovement._calculate_m_pose = function(l_21_0)
  mrotation.set_look_at(l_21_0._m_head_rot, l_21_0._look_dir, math.UP)
  mvector3.set(l_21_0._m_head_pos, l_21_0._obj_head:position())
  l_21_0._obj_spine:m_position(l_21_0._m_com)
  local det_pos = l_21_0._m_detect_pos
  if l_21_0._move_data then
    local path = l_21_0._move_data.path
    mvector3.set(det_pos, path[#path])
    mvector3.set_z(det_pos, det_pos.z + l_21_0._m_head_pos.z - l_21_0._m_pos.z)
  else
    mvector3.set(det_pos, l_21_0._m_head_pos)
  end
end

HuskPlayerMovement.set_position = function(l_22_0, l_22_1)
  mvector3.set(l_22_0._m_pos, l_22_1)
  l_22_0._unit:set_position(l_22_1)
  if l_22_0._nav_tracker then
    l_22_0._nav_tracker:move(l_22_1)
    local nav_seg_id = l_22_0._nav_tracker:nav_segment()
    if l_22_0._standing_nav_seg_id ~= nav_seg_id then
      l_22_0._standing_nav_seg_id = nav_seg_id
      local metadata = managers.navigation:get_nav_seg_metadata(nav_seg_id)
      local location_id = metadata.location_id
      managers.hud:set_mugshot_location(l_22_0._unit:unit_data().mugshot_id, location_id)
      l_22_0._unit:base():set_suspicion_multiplier("area", metadata.suspicion_mul)
      l_22_0._unit:base():set_detection_multiplier("area", metadata.detection_mul and 1 / metadata.detection_mul or nil)
      managers.groupai:state():on_criminal_nav_seg_change(l_22_0._unit, nav_seg_id)
    end
  end
end

HuskPlayerMovement.get_location_id = function(l_23_0)
  return l_23_0._standing_nav_seg_id and managers.navigation:get_nav_seg_metadata(l_23_0._standing_nav_seg_id).location_id or nil
end

HuskPlayerMovement.set_rotation = function(l_24_0, l_24_1)
  mrotation.set_yaw_pitch_roll(l_24_0._m_rot, l_24_1:yaw(), 0, 0)
  l_24_0._unit:set_rotation(l_24_1)
end

HuskPlayerMovement.set_m_rotation = function(l_25_0, l_25_1)
  mrotation.set_yaw_pitch_roll(l_25_0._m_rot, l_25_1:yaw(), 0, 0)
end

HuskPlayerMovement.nav_tracker = function(l_26_0)
  return l_26_0._nav_tracker
end

HuskPlayerMovement.play_redirect = function(l_27_0, l_27_1, l_27_2)
  local result = l_27_0._unit:play_redirect(Idstring(l_27_1), l_27_2)
  result = (result ~= Idstring("") and result)
  if result then
    return result
  end
  print("[HuskPlayerMovement:play_redirect] redirect", l_27_1, "failed in", l_27_0._machine:segment_state(Idstring("base")), l_27_0._machine:segment_state(Idstring("upper_body")))
  Application:stack_dump()
end

HuskPlayerMovement.play_redirect_idstr = function(l_28_0, l_28_1, l_28_2)
  local result = l_28_0._unit:play_redirect(l_28_1, l_28_2)
  result = (result ~= Idstring("") and result)
  if result then
    return result
  end
  print("[HuskPlayerMovement:play_redirect_idstr] redirect", l_28_1, "failed in", l_28_0._machine:segment_state(Idstring("base")), l_28_0._machine:segment_state(Idstring("upper_body")))
  Application:stack_dump()
end

HuskPlayerMovement.play_state = function(l_29_0, l_29_1, l_29_2)
  local result = l_29_0._unit:play_state(Idstring(l_29_1), l_29_2)
  result = (result ~= Idstring("") and result)
  if result then
    return result
  end
  print("[HuskPlayerMovement:play_state] state", l_29_1, "failed in", l_29_0._machine:segment_state(Idstring("base")), l_29_0._machine:segment_state(Idstring("upper_body")))
  Application:stack_dump()
end

HuskPlayerMovement.play_state_idstr = function(l_30_0, l_30_1, l_30_2)
  local result = l_30_0._unit:play_state(l_30_1, l_30_2)
  result = (result ~= Idstring("") and result)
  if result then
    return result
  end
  print("[HuskPlayerMovement:play_state_idstr] state", l_30_1, "failed in", l_30_0._machine:segment_state(Idstring("base")), l_30_0._machine:segment_state(Idstring("upper_body")))
  Application:stack_dump()
end

HuskPlayerMovement.set_need_revive = function(l_31_0, l_31_1, l_31_2)
  if l_31_0._need_revive == l_31_1 then
    return 
  end
  l_31_0._unit:character_damage():set_last_down_time(l_31_2)
  l_31_0._need_revive = l_31_1
  l_31_0._unit:interaction():set_active(l_31_1, false, l_31_2)
  if Network:is_server() then
    if l_31_1 and not l_31_0._revive_SO_id and not l_31_0._revive_rescuer then
      l_31_0:_register_revive_SO()
    elseif not l_31_1 and (l_31_0._revive_SO_id or l_31_0._revive_rescuer or l_31_0._deathguard_SO_id) then
      l_31_0:_unregister_revive_SO()
    end
  end
end

HuskPlayerMovement._register_revive_SO = function(l_32_0)
  local followup_objective = {type = "act", scan = true, action = {type = "act", body_part = 1, variant = "crouch", blocks = {action = -1, walk = -1, hurt = -1, heavy_hurt = -1, aim = -1}}}
  {type = "revive", follow_unit = l_32_0._unit, called = true, destroy_clbk_key = false, nav_seg = l_32_0._unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(l_32_0, l_32_0, "on_revive_SO_failed")}.complete_clbk = callback(l_32_0, l_32_0, "on_revive_SO_completed")
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "revive", follow_unit = l_32_0._unit, called = true, destroy_clbk_key = false, nav_seg = l_32_0._unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(l_32_0, l_32_0, "on_revive_SO_failed")}.scan = true
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "revive", follow_unit = l_32_0._unit, called = true, destroy_clbk_key = false, nav_seg = l_32_0._unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(l_32_0, l_32_0, "on_revive_SO_failed")}.action = {type = "act", variant = l_32_0._state == "arrested" and "untie" or "revive", body_part = 1, blocks = {action = -1, walk = -1, light_hurt = -1, hurt = -1, heavy_hurt = -1, aim = -1}, align_sync = true}
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "revive", follow_unit = l_32_0._unit, called = true, destroy_clbk_key = false, nav_seg = l_32_0._unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(l_32_0, l_32_0, "on_revive_SO_failed")}.action_duration = tweak_data.interaction[l_32_0._state == "arrested" and "free" or "revive"].timer
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "revive", follow_unit = l_32_0._unit, called = true, destroy_clbk_key = false, nav_seg = l_32_0._unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(l_32_0, l_32_0, "on_revive_SO_failed")}.followup_objective = followup_objective
   -- DECOMPILER ERROR: Confused at declaration of local variable

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused at declaration of local variable

  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

    l_32_0._revive_SO_id = "PlayerHusk_revive" .. tostring(l_32_0._unit:key())
     -- DECOMPILER ERROR: Confused about usage of registers!

    managers.groupai:state():add_special_objective("PlayerHusk_revive" .. tostring(l_32_0._unit:key()), {objective = {type = "revive", follow_unit = l_32_0._unit, called = true, destroy_clbk_key = false, nav_seg = l_32_0._unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(l_32_0, l_32_0, "on_revive_SO_failed")}, base_chance = 1, chance_inc = 0, interval = 1, search_pos = l_32_0._unit:position(), usage_amount = 1, AI_group = "friendlies", admin_clbk = callback(l_32_0, l_32_0, "on_revive_SO_administered")})
    if not l_32_0._deathguard_SO_id then
      l_32_0._deathguard_SO_id = PlayerBleedOut._register_deathguard_SO(l_32_0._unit)
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

HuskPlayerMovement._unregister_revive_SO = function(l_33_0)
  if l_33_0._deathguard_SO_id then
    PlayerBleedOut._unregister_deathguard_SO(l_33_0._deathguard_SO_id)
    l_33_0._deathguard_SO_id = nil
  end
  if l_33_0._revive_rescuer then
    local rescuer = l_33_0._revive_rescuer
    l_33_0._revive_rescuer = nil
    rescuer:brain():set_objective(nil)
  elseif l_33_0._revive_SO_id then
    managers.groupai:state():remove_special_objective(l_33_0._revive_SO_id)
    l_33_0._revive_SO_id = nil
  end
  if l_33_0._sympathy_civ then
    local sympathy_civ = l_33_0._sympathy_civ
    l_33_0._sympathy_civ = nil
    sympathy_civ:brain():set_objective(nil)
  end
end

HuskPlayerMovement.set_need_assistance = function(l_34_0, l_34_1)
  if l_34_0._need_assistance == l_34_1 then
    return 
  end
  l_34_0._need_assistance = l_34_1
  if Network:is_server() then
    if l_34_1 and not l_34_0._assist_SO_id then
      local objective = {type = "follow", follow_unit = l_34_0._unit, called = true, destroy_clbk_key = false, scan = true, nav_seg = l_34_0._unit:movement():nav_tracker():nav_segment()}
      local so_descriptor = {objective = objective, base_chance = 1, chance_inc = 0, interval = 6, search_dis_sq = 25000000, search_pos = l_34_0._unit:position(), usage_amount = 1, AI_group = "friendlies"}
      local so_id = "PlayerHusk_assistance" .. tostring(l_34_0._unit:key())
      l_34_0._assist_SO_id = so_id
      managers.groupai:state():add_special_objective(so_id, so_descriptor)
    elseif not l_34_1 and l_34_0._assist_SO_id then
      managers.groupai:state():remove_special_objective(l_34_0._assist_SO_id)
      l_34_0._assist_SO_id = nil
    end
  end
end

HuskPlayerMovement.on_revive_SO_administered = function(l_35_0, l_35_1)
  if l_35_0._revive_SO_id then
    l_35_0._revive_rescuer = l_35_1
    l_35_0._revive_SO_id = nil
  end
end

HuskPlayerMovement.on_revive_SO_failed = function(l_36_0, l_36_1)
  if l_36_0._revive_rescuer then
    l_36_0._revive_rescuer = nil
    l_36_0:_register_revive_SO()
  end
end

HuskPlayerMovement.on_revive_SO_completed = function(l_37_0, l_37_1)
  l_37_0._revive_rescuer = nil
  l_37_0:_unregister_revive_SO()
end

HuskPlayerMovement.need_revive = function(l_38_0)
  return l_38_0._need_revive
end

HuskPlayerMovement.downed = function(l_39_0)
  if not l_39_0._need_revive then
    return l_39_0._need_assistance
  end
end

HuskPlayerMovement._upd_attention_mask_off = function(l_40_0, l_40_1)
  if not l_40_0._atention_on then
    l_40_0._atention_on = true
    l_40_0._machine:force_modifier(l_40_0._mask_off_modifier_name)
  end
  if l_40_0._sync_look_dir then
    local arror_angle = l_40_0._sync_look_dir:angle(l_40_0._look_dir)
    local rot_speed_rel = math.pow(math.min(arror_angle / 90, 1), 0.5)
    local rot_speed = math.lerp(40, 360, rot_speed_rel)
    local rot_amount = math.min(rot_speed * l_40_1, arror_angle)
    local error_axis = l_40_0._look_dir:cross(l_40_0._sync_look_dir)
    local rot_adj = Rotation(error_axis, rot_amount)
    l_40_0._look_dir = l_40_0._look_dir:rotate_with(rot_adj)
    l_40_0._mask_off_modifier:set_target_z(l_40_0._look_dir)
    if rot_amount == arror_angle then
      l_40_0._sync_look_dir = nil
    end
  end
end

HuskPlayerMovement._upd_attention_standard = function(l_41_0, l_41_1)
  if not l_41_0._atention_on then
    if l_41_0._ext_anim.bleedout then
      if l_41_0._sync_look_dir and l_41_0._sync_look_dir ~= l_41_0._look_dir then
        l_41_0._look_dir = mvector3.copy(l_41_0._sync_look_dir)
      end
      return 
    else
      l_41_0._atention_on = true
      l_41_0._machine:force_modifier(l_41_0._look_modifier_name)
    end
  end
  if l_41_0._sync_look_dir then
    local tar_look_dir = tmp_vec1
    mvec3_set(tar_look_dir, l_41_0._sync_look_dir)
    local wait_for_turn = nil
    local hips_fwd = tmp_vec2
    mrotation.y(l_41_0._m_rot, hips_fwd)
    local hips_err_spin = tar_look_dir:to_polar_with_reference(hips_fwd, math.UP).spin
    local max_spin = 60
    local min_spin = -90
    if max_spin < hips_err_spin or hips_err_spin < min_spin then
      wait_for_turn = true
      if max_spin < hips_err_spin then
        mvector3.rotate_with(tar_look_dir, Rotation(max_spin - hips_err_spin))
      else
        mvector3.rotate_with(tar_look_dir, Rotation(min_spin - hips_err_spin))
      end
    end
    local arror_angle = tar_look_dir:angle(l_41_0._look_dir)
    local rot_speed_rel = math.pow(math.min(arror_angle / 90, 1), 0.5)
    local rot_speed = math.lerp(40, 360, rot_speed_rel)
    local rot_amount = math.min(rot_speed * l_41_1, arror_angle)
    local error_axis = l_41_0._look_dir:cross(tar_look_dir)
    local rot_adj = Rotation(error_axis, rot_amount)
    l_41_0._look_dir = l_41_0._look_dir:rotate_with(rot_adj)
    l_41_0._look_modifier:set_target_y(l_41_0._look_dir)
    if rot_amount == arror_angle and not wait_for_turn then
      l_41_0._sync_look_dir = nil
    end
  end
end

HuskPlayerMovement._upd_attention_bleedout = function(l_42_0, l_42_1)
  if l_42_0._sync_look_dir then
    local fwd = l_42_0._m_rot:y()
    if l_42_0._atention_on and l_42_0._ext_anim.reload then
      l_42_0._atention_on = false
      do
        local blend_out_t = 0.15000000596046
        l_42_0._machine:set_modifier_blend(l_42_0._head_modifier_name, blend_out_t)
        l_42_0._machine:set_modifier_blend(l_42_0._arm_modifier_name, blend_out_t)
        l_42_0._machine:forbid_modifier(l_42_0._head_modifier_name)
        l_42_0._machine:forbid_modifier(l_42_0._arm_modifier_name)
      end
      do return end
      if l_42_0._ext_anim.bleedout_falling or l_42_0._ext_anim.reload then
        if l_42_0._sync_look_dir ~= l_42_0._look_dir then
          l_42_0._look_dir = mvector3.copy(l_42_0._sync_look_dir)
        end
        return 
      else
        l_42_0._atention_on = true
        l_42_0._machine:force_modifier(l_42_0._head_modifier_name)
        l_42_0._machine:force_modifier(l_42_0._arm_modifier_name)
      end
    end
    local arror_angle = l_42_0._sync_look_dir:angle(l_42_0._look_dir)
    local rot_speed_rel = math.pow(math.min(arror_angle / 90, 1), 0.5)
    local rot_speed = math.lerp(40, 360, rot_speed_rel)
    local rot_amount = math.min(rot_speed * l_42_1, arror_angle)
    local error_axis = l_42_0._look_dir:cross(l_42_0._sync_look_dir)
    local rot_adj = Rotation(error_axis, rot_amount)
    l_42_0._look_dir = l_42_0._look_dir:rotate_with(rot_adj)
    l_42_0._arm_modifier:set_target_y(l_42_0._look_dir)
    l_42_0._head_modifier:set_target_z(l_42_0._look_dir)
    local aim_polar = l_42_0._look_dir:to_polar_with_reference(fwd, math.UP)
    local aim_spin = aim_polar.spin
    local anim = l_42_0._machine:segment_state(Idstring("base"))
    local fwd = 1 - math.clamp(math.abs(aim_spin / 90), 0, 1)
    l_42_0._machine:set_parameter(anim, "angle0", fwd)
    local bwd = math.clamp(math.abs(aim_spin / 90), 1, 2) - 1
    l_42_0._machine:set_parameter(anim, "angle180", bwd)
    local l = 1 - math.clamp(math.abs(aim_spin / 90 - 1), 0, 1)
    l_42_0._machine:set_parameter(anim, "angle90neg", l)
    local r = 1 - math.clamp(math.abs(aim_spin / 90 + 1), 0, 1)
    l_42_0._machine:set_parameter(anim, "angle90", r)
    if rot_amount == arror_angle then
      l_42_0._sync_look_dir = nil
    end
  end
end

HuskPlayerMovement._upd_attention_tased = function(l_43_0, l_43_1)
end

HuskPlayerMovement._upd_attention_disarmed = function(l_44_0, l_44_1)
end

HuskPlayerMovement._upd_sequenced_events = function(l_45_0, l_45_1, l_45_2)
  local sequenced_events = l_45_0._sequenced_events
  local next_event = sequenced_events[1]
  if not next_event then
    return 
  end
  if next_event.commencing then
    return 
  end
  if l_45_0._tase_effect then
    World:effect_manager():fade_kill(l_45_0._tase_effect)
  end
  local event_type = next_event.type
  if event_type == "move" then
    next_event.commencing = true
    l_45_0:_start_movement(next_event.path)
  elseif event_type == "bleedout" and l_45_0:_start_bleedout(next_event) then
    table.remove(sequenced_events, 1)
    do return end
    if event_type == "fatal" and l_45_0:_start_fatal(next_event) then
      table.remove(sequenced_events, 1)
      do return end
      if event_type == "incapacitated" and l_45_0:_start_incapacitated(next_event) then
        table.remove(sequenced_events, 1)
        do return end
        if event_type == "tased" and l_45_0:_start_tased(next_event) then
          table.remove(sequenced_events, 1)
          do return end
          if event_type == "standard" and l_45_0:_start_standard(next_event) then
            table.remove(sequenced_events, 1)
            do return end
            if event_type == "dead" and l_45_0:_start_dead(next_event) then
              table.remove(sequenced_events, 1)
              do return end
              if event_type == "arrested" and l_45_0:_start_arrested(next_event) then
                table.remove(sequenced_events, 1)
              end
            end
          end
        end
      end
    end
  end
end

HuskPlayerMovement._add_sequenced_event = function(l_46_0, l_46_1)
  table.insert(l_46_0._sequenced_events, l_46_1)
end

HuskPlayerMovement._upd_stance = function(l_47_0, l_47_1)
  if l_47_0._aim_up_expire_t and l_47_0._aim_up_expire_t < l_47_1 then
    l_47_0._aim_up_expire_t = nil
    l_47_0:_chk_change_stance()
  end
  local stance = l_47_0._stance
  if stance.transition then
    local transition = stance.transition
    if transition.next_upd_t < l_47_1 then
      transition.next_upd_t = l_47_1 + 0.032999999821186
      local values = stance.values
      local prog = (l_47_1 - transition.start_t) / transition.duration
      if prog < 1 then
        local prog_smooth = math.clamp(math.bezier({0, 0, 1, 1}, prog), 0, 1)
        local v_start = transition.start_values
        local v_end = transition.end_values
        local mlerp = math.lerp
        for i,v in ipairs(v_start) do
          values[i] = mlerp(v, v_end[i], prog_smooth)
        end
      else
        for i,v in ipairs(transition.end_values) do
          values[i] = v
        end
        if transition.delayed_shot then
          l_47_0:_shoot_blank(transition.delayed_shot.impact)
        end
        stance.transition = nil
      end
      local names = stance.names
      for i,v in ipairs(values) do
        l_47_0._machine:set_global(names[i], values[i])
      end
    end
  end
end

HuskPlayerMovement._upd_slow_pos_reservation = function(l_48_0, l_48_1, l_48_2)
  local slow_dist = 100
  mvec3_set(tmp_vec2, l_48_0._pos_reservation_slow.position)
  mvec3_sub(tmp_vec2, l_48_0._pos_reservation.position)
  if slow_dist < mvec3_norm(tmp_vec2) then
    mvec3_mul(tmp_vec2, slow_dist)
    mvec3_add(tmp_vec2, l_48_0._pos_reservation.position)
    mvec3_set(l_48_0._pos_reservation_slow.position, tmp_vec2)
    managers.navigation:move_pos_rsrv(l_48_0._pos_reservation)
  end
end

HuskPlayerMovement._upd_move_downed = function(l_49_0, l_49_1, l_49_2)
  if l_49_0._move_data then
    local data = l_49_0._move_data
    local path = data.path
    local end_pos = path[#path]
    local cur_pos = l_49_0._m_pos
    local new_pos = tmp_vec1
    local displacement = 300 * l_49_2
    local dis = mvector3.distance(cur_pos, end_pos)
    if dis < displacement then
      l_49_0._move_data = nil
      table.remove(l_49_0._sequenced_events, 1)
      mvector3.set(new_pos, end_pos)
    else
      mvector3.step(new_pos, cur_pos, end_pos, displacement)
    end
    l_49_0:set_position(new_pos)
  end
end

HuskPlayerMovement._upd_move_standard = function(l_50_0, l_50_1, l_50_2)
  local look_dir_flat = l_50_0._look_dir:with_z(0)
  mvector3.normalize(look_dir_flat)
  local leg_fwd_cur = l_50_0._m_rot:y()
  local waist_twist = look_dir_flat:to_polar_with_reference(leg_fwd_cur, math.UP).spin
  local abs_waist_twist = math.abs(waist_twist)
  if l_50_0._ext_anim.bleedout_enter or l_50_0._ext_anim.bleedout_exit or l_50_0._ext_anim.fatal_enter or l_50_0._ext_anim.fatal_exit then
    return 
  end
  if l_50_0._pose_code == 1 and not l_50_0._ext_anim.stand then
    l_50_0:play_redirect("stand")
    do return end
    if not l_50_0._ext_anim.crouch then
      l_50_0:play_redirect("crouch")
    end
  end
  if l_50_0._turning then
    l_50_0:set_m_rotation(l_50_0._unit:rotation())
    if not l_50_0._ext_anim.turn then
      l_50_0._turning = nil
      l_50_0._unit:set_driving("orientation_object")
      l_50_0._machine:set_root_blending(true)
    end
  end
  if l_50_0._move_data then
    if l_50_0._turning then
      l_50_0._turning = nil
      l_50_0._unit:set_driving("orientation_object")
      l_50_0._machine:set_root_blending(true)
    end
    local data = l_50_0._move_data
    local new_pos = nil
    local path_len_remaining = data.path_len - data.prog_in_seg
    local wanted_str8_vel, max_velocity = nil, nil
    local max_dis = 400
    local slowdown_dis = 170
    if max_dis < data.path_len or not l_50_0:_chk_groun_ray() then
      max_velocity = l_50_0:_get_max_move_speed(true) * 1.1000000238419
      wanted_str8_vel = max_velocity
    elseif slowdown_dis < data.path_len or not l_50_0:_chk_groun_ray() then
      max_velocity = l_50_0:_get_max_move_speed(true) * 0.94999998807907
      wanted_str8_vel = max_velocity
    else
      max_velocity = l_50_0:_get_max_move_speed(true) * 1.1000000238419
      local min_velocity = 200
      local min_dis = 50
      local dis_lerp = math.clamp((path_len_remaining - min_dis) / (max_dis - min_dis), 0, 1)
      wanted_str8_vel = math.lerp(min_velocity, max_velocity, dis_lerp)
    end
    local velocity = nil
    if wanted_str8_vel < data.velocity_len then
      data.velocity_len = wanted_str8_vel
    else
      local max_acc = max_velocity * 1.75
      data.velocity_len = math.clamp(data.velocity_len + l_50_2 * max_acc, 0, wanted_str8_vel)
    end
    local wanted_travel_dis = data.velocity_len * l_50_2
    local new_pos, complete = HuskPlayerMovement._walk_spline(data, l_50_0._m_pos, wanted_travel_dis)
    local last_z_vel = l_50_0._last_vel_z
    if mvector3.z(new_pos) < mvector3.z(l_50_0._m_pos) then
      last_z_vel = last_z_vel - 971 * l_50_2
      local new_z = l_50_0._m_pos.z + (last_z_vel) * l_50_2
      new_z = math.max(new_pos.z, new_z)
      mvec3_set_z(new_pos, new_z)
    elseif complete then
      l_50_0._move_data = nil
      table.remove(l_50_0._sequenced_events, 1)
    else
      last_z_vel = 0
    end
    l_50_0._last_vel_z = last_z_vel
    local displacement = tmp_vec1
    mvec3_set(displacement, new_pos)
    mvec3_sub(displacement, l_50_0._m_pos)
    mvec3_set_z(displacement, 0)
    l_50_0:set_position(new_pos)
    local waist_twist_max = 45
    local sign_waist_twist = math.sign(waist_twist)
    local leg_max_angle_adj = math.min(abs_waist_twist, 120 * l_50_2)
    local waist_twist_new = waist_twist - sign_waist_twist * leg_max_angle_adj
    if waist_twist_max < math.abs(waist_twist_new) then
      waist_twist_new = sign_waist_twist * waist_twist_max
    else
      waist_twist_new = waist_twist - sign_waist_twist * leg_max_angle_adj
    end
    local leg_rot_new = Rotation(look_dir_flat, math.UP) * Rotation(-(waist_twist_new))
    l_50_0:set_rotation(leg_rot_new)
    local anim_velocity, anim_side = nil, nil
    if l_50_0._move_data then
      local fwd_new = l_50_0._m_rot:y()
      local right_new = fwd_new:cross(math.UP)
      local walk_dir_flat = data.seg_dir:with_z(0)
      mvector3.normalize(walk_dir_flat)
      local fwd_dot = walk_dir_flat:dot(fwd_new)
      local right_dot = walk_dir_flat:dot(right_new)
      if fwd_dot <= 0 or not "fwd" then
        anim_side = math.abs(right_dot) >= math.abs(fwd_dot) or "bwd"
      end
      do return end
      anim_side = right_dot > 0 and "r" or "l"
      local vel_len = mvector3.length(displacement) / l_50_2
      local stance_name = l_50_0._stance.name
      if stance_name == "ntl" then
        if l_50_0._ext_anim.run then
          if vel_len > 250 then
            anim_velocity = "run"
          else
            anim_velocity = "walk"
          end
        elseif vel_len > 300 then
          anim_velocity = "run"
        else
          anim_velocity = "walk"
        end
      else
        if l_50_0._ext_anim.sprint then
          if vel_len > 450 and l_50_0._pose_code == 1 then
            anim_velocity = "sprint"
          elseif vel_len > 250 then
            anim_velocity = "run"
          else
            anim_velocity = "walk"
          end
        else
          if l_50_0._ext_anim.run then
            if vel_len > 500 and l_50_0._pose_code == 1 then
              anim_velocity = "sprint"
            elseif vel_len > 250 then
              anim_velocity = "run"
            else
              anim_velocity = "walk"
            end
          elseif vel_len > 500 and l_50_0._pose_code == 1 then
            anim_velocity = "sprint"
          elseif vel_len > 300 then
            anim_velocity = "run"
          else
            anim_velocity = "walk"
          end
        end
      end
      l_50_0:_adjust_move_anim(anim_side, anim_velocity)
      local animated_walk_vel = l_50_0._walk_anim_velocities[l_50_0._ext_anim.pose][l_50_0._stance.name][anim_velocity][anim_side]
      local anim_speed = vel_len / animated_walk_vel
      l_50_0:_adjust_walk_anim_speed(l_50_2, anim_speed)
    else
      if not l_50_0._ext_anim.idle then
        l_50_0:play_redirect("idle")
      else
        if l_50_0._ext_anim.idle_full_blend and not l_50_0._turning and (waist_twist > 40 or waist_twist < -65) then
          local angle = waist_twist
          local dir_str = angle > 0 and "l" or "r"
          local redir_name = "turn_" .. dir_str
          local redir_res = l_50_0:play_redirect(redir_name)
          if redir_res then
            l_50_0._turning = true
            local abs_angle = math.abs(angle)
            if abs_angle > 135 then
              l_50_0._machine:set_parameter(redir_res, "angle135", 1)
            elseif abs_angle > 90 then
              local lerp = (abs_angle - 90) / 45
              l_50_0._machine:set_parameter(redir_res, "angle135", lerp)
              l_50_0._machine:set_parameter(redir_res, "angle90", 1 - lerp)
            elseif abs_angle > 45 then
              local lerp = (abs_angle - 45) / 45
              l_50_0._machine:set_parameter(redir_res, "angle90", lerp)
              l_50_0._machine:set_parameter(redir_res, "angle45", 1 - lerp)
            else
              l_50_0._machine:set_parameter(redir_res, "angle45", 1)
            end
            l_50_0._unit:set_driving("animation")
            l_50_0._machine:set_root_blending(false)
          else
            debug_pause_unit(l_50_0._unit, "[HuskPlayerMovement:_upd_move_standard] ", redir_name, " redirect failed in", l_50_0._machine:segment_state(Idstring("base")), l_50_0._unit)
          end
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HuskPlayerMovement._adjust_move_anim = function(l_51_0, l_51_1, l_51_2)
  local anim_data = l_51_0._ext_anim
  if anim_data.haste == l_51_2 and anim_data.move_" .. l_51_ then
    return 
  end
  local redirect_name = l_51_2 .. "_" .. l_51_1
  local enter_t = nil
  local move_side = anim_data.move_side
  if move_side and (l_51_1 == move_side or l_51_0._matching_walk_anims[l_51_1][move_side]) then
    local seg_rel_t = l_51_0._machine:segment_relative_time(Idstring("base"))
    local walk_anim_length = l_51_0._walk_anim_lengths[anim_data.pose][l_51_0._stance.name][l_51_2][l_51_1]
    enter_t = seg_rel_t * walk_anim_length
  end
  local redir_res = l_51_0:play_redirect(redirect_name, enter_t)
  return redir_res
end

HuskPlayerMovement.sync_action_walk_nav_point = function(l_52_0, l_52_1)
  if Network:is_server() then
    if not l_52_0._pos_reservation then
      l_52_0._pos_reservation = {position = mvector3.copy(l_52_1), radius = 100, filter = l_52_0._pos_rsrv_id}
      l_52_0._pos_reservation_slow = {position = mvector3.copy(l_52_1), radius = 100, filter = l_52_0._pos_rsrv_id}
      managers.navigation:add_pos_reservation(l_52_0._pos_reservation)
      managers.navigation:add_pos_reservation(l_52_0._pos_reservation_slow)
    else
      l_52_0._pos_reservation.position = mvector3.copy(l_52_1)
      managers.navigation:move_pos_rsrv(l_52_0._pos_reservation)
      l_52_0:_upd_slow_pos_reservation()
    end
  end
  local nr_seq_events = #l_52_0._sequenced_events
  if nr_seq_events == 1 and l_52_0._move_data then
    local path = l_52_0._move_data.path
    local vec = tmp_vec1
    mvector3.set(vec, l_52_1)
    mvector3.subtract(vec, path[#path])
    if mvector3.z(vec) < 0 then
      mvector3.set_z(vec, 0)
    end
    l_52_0._move_data.path_len = l_52_0._move_data.path_len + mvector3.length(vec)
    table.insert(path, l_52_1)
  elseif nr_seq_events > 0 and l_52_0._sequenced_events[nr_seq_events].type == "move" then
    table.insert(l_52_0._sequenced_events[#l_52_0._sequenced_events].path, l_52_1)
  else
    local event_desc = {type = "move", path = {l_52_1}}
    l_52_0:_add_sequenced_event(event_desc)
  end
end

HuskPlayerMovement.current_state = function(l_53_0)
  return l_53_0
end

HuskPlayerMovement._start_movement = function(l_54_0, l_54_1)
  local data = {}
  l_54_0._move_data = data
  table.insert(l_54_1, 1, l_54_0._unit:position())
  data.path = l_54_1
  data.velocity_len = 0
  local old_pos = l_54_1[1]
  local nr_nodes = #l_54_1
  local path_len = 0
  do
    local i = 1
    repeat
      if i < nr_nodes then
        mvector3.set(tmp_vec1, l_54_1[i + 1])
        mvector3.subtract(tmp_vec1, l_54_1[i])
        if mvector3.z(tmp_vec1) < 0 then
          mvector3.set_z(tmp_vec1, 0)
        end
        path_len = path_len + mvector3.length(tmp_vec1)
        i = i + 1
      else
        data.path_len = path_len
        data.prog_in_seg = 0
        data.seg_dir = Vector3()
        mvec3_set(data.seg_dir, l_54_1[2])
        mvec3_sub(data.seg_dir, l_54_1[1])
        if mvector3.z(data.seg_dir) < 0 then
          mvec3_set_z(data.seg_dir, 0)
        end
        data.seg_len = mvec3_norm(data.seg_dir)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HuskPlayerMovement._start_standard = function(l_55_0, l_55_1)
  l_55_0:set_need_revive(false)
  l_55_0:set_need_assistance(false)
  managers.hud:set_mugshot_normal(l_55_0._unit:unit_data().mugshot_id)
  if l_55_0._state == "mask_off" or l_55_0._state == "clean" then
    l_55_0._unit:set_slot(5)
    l_55_0:_change_pose(1)
  else
    l_55_0._unit:set_slot(3)
    if Network:is_server() then
      managers.groupai:state():on_player_weapons_hot()
    end
    managers.groupai:state():on_criminal_recovered(l_55_0._unit)
  end
  local previous_state = l_55_1.previous_state
  if previous_state == "mask_off" or previous_state == "clean" then
    local redir_res = l_55_0:play_redirect("equip")
    if redir_res then
      local weapon = l_55_0._unit:inventory():equipped_unit()
      if weapon then
        l_55_0._unit:inventory():show_equipped_unit()
        local weap_tweak = weapon:base():weapon_tweak_data()
        local weapon_hold = weap_tweak.hold
        l_55_0._machine:set_parameter(redir_res, "to_" .. weapon_hold, 1)
      end
    end
  end
  if not l_55_0._ext_anim.stand then
    local redir_res = l_55_0:play_redirect("stand")
    if not redir_res then
      l_55_0:play_state("std/stand/still/idle/look")
    end
  end
  if l_55_0._atention_on then
    l_55_0._machine:forbid_modifier(l_55_0._look_modifier_name)
    l_55_0._machine:forbid_modifier(l_55_0._head_modifier_name)
    l_55_0._machine:forbid_modifier(l_55_0._arm_modifier_name)
    l_55_0._machine:forbid_modifier(l_55_0._mask_off_modifier_name)
    l_55_0._atention_on = false
  end
  if l_55_0._state == "mask_off" or l_55_0._state == "clean" then
    l_55_0._attention_updator = callback(l_55_0, l_55_0, "_upd_attention_mask_off")
    l_55_0._mask_off_modifier:set_target_z(l_55_0._look_dir)
  else
    l_55_0._attention_updator = callback(l_55_0, l_55_0, "_upd_attention_standard")
    l_55_0._look_modifier:set_target_y(l_55_0._look_dir)
  end
  l_55_0._movement_updator = callback(l_55_0, l_55_0, "_upd_move_standard")
  l_55_0._last_vel_z = 0
  return true
end

HuskPlayerMovement._start_bleedout = function(l_56_0, l_56_1)
  local redir_res = l_56_0:play_redirect("bleedout")
  if not redir_res then
    print("[HuskPlayerMovement:_start_bleedout] redirect failed in", l_56_0._machine:segment_state(Idstring("base")), l_56_0._unit)
    return 
  end
  l_56_0._unit:set_slot(3)
  managers.hud:set_mugshot_downed(l_56_0._unit:unit_data().mugshot_id)
  managers.groupai:state():on_criminal_disabled(l_56_0._unit)
  l_56_0._unit:interaction():set_tweak_data("revive")
  l_56_0:set_need_revive(true, l_56_1.down_time)
  if l_56_0._atention_on then
    l_56_0._machine:forbid_modifier(l_56_0._look_modifier_name)
    l_56_0._machine:forbid_modifier(l_56_0._head_modifier_name)
    l_56_0._machine:forbid_modifier(l_56_0._arm_modifier_name)
    l_56_0._machine:forbid_modifier(l_56_0._mask_off_modifier_name)
    l_56_0._atention_on = false
  end
  l_56_0._attention_updator = callback(l_56_0, l_56_0, "_upd_attention_bleedout")
  l_56_0._movement_updator = callback(l_56_0, l_56_0, "_upd_move_downed")
  return true
end

HuskPlayerMovement._start_tased = function(l_57_0, l_57_1)
  local redir_res = l_57_0:play_redirect("tased")
  if not redir_res then
    print("[HuskPlayerMovement:_start_tased] redirect failed in", l_57_0._machine:segment_state(Idstring("base")), l_57_0._unit)
    return 
  end
  l_57_0._unit:set_slot(3)
  l_57_0:set_need_revive(false)
  managers.hud:set_mugshot_tased(l_57_0._unit:unit_data().mugshot_id)
  managers.groupai:state():on_criminal_disabled(l_57_0._unit, "electrified")
  l_57_0._tase_effect = World:effect_manager():spawn(l_57_0._tase_effect_table)
  l_57_0:set_need_assistance(true)
  if l_57_0._atention_on then
    l_57_0._machine:forbid_modifier(l_57_0._look_modifier_name)
    l_57_0._machine:forbid_modifier(l_57_0._head_modifier_name)
    l_57_0._machine:forbid_modifier(l_57_0._arm_modifier_name)
    l_57_0._machine:forbid_modifier(l_57_0._mask_off_modifier_name)
    l_57_0._atention_on = false
  end
  l_57_0._attention_updator = callback(l_57_0, l_57_0, "_upd_attention_tased")
  l_57_0._movement_updator = callback(l_57_0, l_57_0, "_upd_move_downed")
  return true
end

HuskPlayerMovement._start_fatal = function(l_58_0, l_58_1)
  local redir_res = l_58_0:play_redirect("fatal")
  if not redir_res then
    print("[HuskPlayerMovement:_start_fatal] redirect failed in", l_58_0._machine:segment_state(Idstring("base")), l_58_0._unit)
    return 
  end
  l_58_0._unit:set_slot(5)
  managers.hud:set_mugshot_downed(l_58_0._unit:unit_data().mugshot_id)
  managers.groupai:state():on_criminal_neutralized(l_58_0._unit)
  l_58_0._unit:interaction():set_tweak_data("revive")
  l_58_0:set_need_revive(true, l_58_1.down_time)
  if l_58_0._atention_on then
    l_58_0._machine:forbid_modifier(l_58_0._look_modifier_name)
    l_58_0._machine:forbid_modifier(l_58_0._head_modifier_name)
    l_58_0._machine:forbid_modifier(l_58_0._arm_modifier_name)
    l_58_0._machine:forbid_modifier(l_58_0._mask_off_modifier_name)
    l_58_0._atention_on = false
  end
  l_58_0._attention_updator = false
  l_58_0._movement_updator = callback(l_58_0, l_58_0, "_upd_move_downed")
  return true
end

HuskPlayerMovement._start_incapacitated = function(l_59_0, l_59_1)
  local redir_res = l_59_0:play_redirect("incapacitated")
  if not redir_res then
    print("[HuskPlayerMovement:_start_incapacitated] redirect failed in", l_59_0._machine:segment_state(Idstring("base")), l_59_0._unit)
    return 
  end
  l_59_0:set_need_revive(true)
  if l_59_0._atention_on then
    l_59_0._machine:forbid_modifier(l_59_0._look_modifier_name)
    l_59_0._machine:forbid_modifier(l_59_0._head_modifier_name)
    l_59_0._machine:forbid_modifier(l_59_0._arm_modifier_name)
    l_59_0._machine:forbid_modifier(l_59_0._mask_off_modifier_name)
    l_59_0._atention_on = false
  end
  l_59_0._attention_updator = false
  l_59_0._movement_updator = callback(l_59_0, l_59_0, "_upd_move_downed")
  return true
end

HuskPlayerMovement._start_dead = function(l_60_0, l_60_1)
  local redir_res = l_60_0:play_redirect("death")
  if not redir_res then
    print("[HuskPlayerMovement:_start_dead] redirect failed in", l_60_0._machine:segment_state(Idstring("base")), l_60_0._unit)
    return 
  end
  if l_60_0._atention_on then
    local blend_out_t = 0.15000000596046
    l_60_0._machine:set_modifier_blend(l_60_0._look_modifier_name, blend_out_t)
    l_60_0._machine:set_modifier_blend(l_60_0._head_modifier_name, blend_out_t)
    l_60_0._machine:set_modifier_blend(l_60_0._arm_modifier_name, blend_out_t)
    l_60_0._machine:forbid_modifier(l_60_0._look_modifier_name)
    l_60_0._machine:forbid_modifier(l_60_0._head_modifier_name)
    l_60_0._machine:forbid_modifier(l_60_0._arm_modifier_name)
    l_60_0._machine:forbid_modifier(l_60_0._mask_off_modifier_name)
    l_60_0._atention_on = false
  end
  l_60_0._attention_updator = false
  l_60_0._movement_updator = callback(l_60_0, l_60_0, "_upd_move_downed")
  return true
end

HuskPlayerMovement._start_arrested = function(l_61_0, l_61_1)
  if not l_61_0._ext_anim.hands_tied then
    local redir_res = l_61_0:play_redirect("tied")
    if not redir_res then
      print("[HuskPlayerMovement:_start_arrested] redirect failed in", l_61_0._machine:segment_state(Idstring("base")), l_61_0._unit)
      return 
    end
  end
  l_61_0._unit:set_slot(5)
  managers.hud:set_mugshot_cuffed(l_61_0._unit:unit_data().mugshot_id)
  managers.groupai:state():on_criminal_neutralized(l_61_0._unit)
  l_61_0._unit:interaction():set_tweak_data("free")
  l_61_0:set_need_revive(true)
  if l_61_0._atention_on then
    l_61_0._machine:forbid_modifier(l_61_0._look_modifier_name)
    l_61_0._machine:forbid_modifier(l_61_0._head_modifier_name)
    l_61_0._machine:forbid_modifier(l_61_0._arm_modifier_name)
    l_61_0._machine:forbid_modifier(l_61_0._mask_off_modifier_name)
    l_61_0._atention_on = false
  end
  l_61_0._attention_updator = callback(l_61_0, l_61_0, "_upd_attention_disarmed")
  l_61_0._movement_updator = false
  return true
end

HuskPlayerMovement._adjust_walk_anim_speed = function(l_62_0, l_62_1, l_62_2)
  local state = l_62_0._machine:segment_state(Idstring("base"))
  local cur_speed = l_62_0._machine:get_speed(state)
  local max = 2
  local min = 0.050000000745058
  local new_speed = nil
  if cur_speed < l_62_2 and cur_speed < max then
    new_speed = l_62_2
  elseif l_62_2 < cur_speed and min < cur_speed then
    new_speed = l_62_2
  end
  if new_speed then
    l_62_0._machine:set_speed(state, new_speed)
  end
end

HuskPlayerMovement.sync_shot_blank = function(l_63_0, l_63_1)
  if l_63_0._state == "mask_off" or l_63_0._state == "clean" then
    return 
  end
  local delay = l_63_0._stance.values[3] < 0.69999998807907
  if not delay then
    l_63_0:_shoot_blank(l_63_1)
    l_63_0._aim_up_expire_t = TimerManager:game():time() + 2
  end
  if delay then
    l_63_0:_change_stance(3, {impact = l_63_1})
  end
end

HuskPlayerMovement.set_cbt_permanent = function(l_64_0, l_64_1)
  l_64_0._is_weapon_gadget_on = l_64_1
  l_64_0:_chk_change_stance()
end

HuskPlayerMovement._shoot_blank = function(l_65_0, l_65_1)
  local equipped_weapon = l_65_0._unit:inventory():equipped_unit()
  if equipped_weapon and equipped_weapon:base().fire_blank then
    equipped_weapon:base():fire_blank(l_65_0._look_dir, l_65_1)
    if l_65_0._aim_up_expire_t ~= -1 then
      l_65_0._aim_up_expire_t = TimerManager:game():time() + 2
    end
  end
  if not l_65_0._unit:anim_data().base_no_recoil then
    l_65_0:play_redirect("recoil_single")
  end
end

HuskPlayerMovement.sync_reload_weapon = function(l_66_0)
  l_66_0:play_redirect("reload")
end

HuskPlayerMovement.sync_pose = function(l_67_0, l_67_1)
  l_67_0:_change_pose(l_67_1)
end

HuskPlayerMovement._change_stance = function(l_68_0, l_68_1, l_68_2)
  local stance = l_68_0._stance
  local end_values = {0, 0, 0}
  end_values[l_68_1] = 1
  stance.code = l_68_1
  stance.name = l_68_0._stance_names[l_68_1]
  local start_values = {}
  for _,value in ipairs(stance.values) do
    table.insert(start_values, value)
  end
  local delay = stance.blend[l_68_1]
  if l_68_2 then
    delay = delay * 0.30000001192093
  end
  local t = TimerManager:game():time()
  local transition = {end_values = end_values, start_values = start_values, duration = delay, start_t = t, next_upd_t = t + 0.070000000298023, delayed_shot = l_68_2}
  stance.transition = transition
end

HuskPlayerMovement._change_pose = function(l_69_0, l_69_1)
  local redirect = l_69_1 == 1 and "stand" or "crouch"
  l_69_0._pose_code = l_69_1
  if l_69_0._ext_anim[redirect] then
    return 
  end
  local enter_t = nil
  local move_side = l_69_0._ext_anim.move_side
  if move_side then
    local seg_rel_t = l_69_0._machine:segment_relative_time(Idstring("base"))
    local speed = l_69_0._ext_anim.run and "run" or "walk"
    local walk_anim_length = l_69_0._walk_anim_lengths[l_69_0._ext_anim.pose][l_69_0._stance.name][speed][move_side]
    enter_t = seg_rel_t * walk_anim_length
  end
  l_69_0:play_redirect(redirect, enter_t)
end

HuskPlayerMovement.sync_movement_state = function(l_70_0, l_70_1, l_70_2)
  cat_print("george", "[HuskPlayerMovement:sync_movement_state]", l_70_1)
  local previous_state = l_70_0._state
  l_70_0._state = l_70_1
  l_70_0._last_down_time = l_70_2
  l_70_0._state_enter_t = TimerManager:game():time()
  local peer = l_70_0._unit:network():peer()
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if not peer or l_70_1 == "standard" then
    local event_desc = {type = "standard", previous_state = previous_state}
    l_70_0:_add_sequenced_event(event_desc)
  elseif l_70_1 == "mask_off" then
    local event_desc = {type = "standard"}
    l_70_0:_add_sequenced_event(event_desc)
  elseif l_70_1 == "fatal" then
    local event_desc = {type = "fatal", down_time = l_70_2}
    l_70_0:_add_sequenced_event(event_desc)
  elseif l_70_1 == "bleed_out" then
    local event_desc = {type = "bleedout", down_time = l_70_2}
    l_70_0:_add_sequenced_event(event_desc)
  elseif l_70_1 == "tased" then
    local event_desc = {type = "tased"}
    l_70_0:_add_sequenced_event(event_desc)
  elseif l_70_1 == "incapacitated" then
    local event_desc = {type = "fatal", down_time = l_70_2}
    l_70_0:_add_sequenced_event(event_desc)
  elseif l_70_1 == "arrested" then
    local event_desc = {type = "arrested"}
    l_70_0:_add_sequenced_event(event_desc)
  elseif l_70_1 == "clean" then
    local event_desc = {type = "standard"}
    l_70_0:_add_sequenced_event(event_desc)
  elseif l_70_1 == "carry" then
    local event_desc = {type = "standard", previous_state = previous_state}
    l_70_0:_add_sequenced_event(event_desc)
  elseif l_70_1 == "dead" then
    local peer_id = managers.network:game():member_from_unit(l_70_0._unit):peer():id()
    managers.groupai:state():on_player_criminal_death(peer_id)
  end
end

HuskPlayerMovement.on_cuffed = function(l_71_0)
  l_71_0._unit:network():send_to_unit({})
   -- Warning: undefined locals caused missing assignments!
end

HuskPlayerMovement.on_uncovered = function(l_72_0, l_72_1)
  l_72_0._unit:network():send_to_unit({"suspect_uncovered", l_72_1})
end

HuskPlayerMovement.on_SPOOCed = function(l_73_0)
  l_73_0._unit:network():send_to_unit({})
   -- Warning: undefined locals caused missing assignments!
end

HuskPlayerMovement.anim_clbk_footstep = function(l_74_0, l_74_1)
  CopMovement.anim_clbk_footstep(l_74_0, l_74_1, l_74_0._m_pos)
end

HuskPlayerMovement.get_footstep_event = function(l_75_0)
  return CopMovement.get_footstep_event(l_75_0)
end

HuskPlayerMovement.ground_ray = function(l_76_0)
end

HuskPlayerMovement.clbk_inventory_event = function(l_77_0, l_77_1, l_77_2)
  local weapon = l_77_0._unit:inventory():equipped_unit()
  if weapon then
    if l_77_0._state == "mask_off" or l_77_0._state == "clean" then
      l_77_0._unit:inventory():hide_equipped_unit()
    end
    if l_77_0._weapon_hold then
      l_77_0._machine:set_global(l_77_0._weapon_hold, 0)
    end
    local weap_tweak = weapon:base():weapon_tweak_data()
    local weapon_hold = weap_tweak.hold
    l_77_0._machine:set_global(weapon_hold, 1)
    l_77_0._weapon_hold = weapon_hold
    if l_77_0._weapon_anim_global then
      l_77_0._machine:set_global(l_77_0._weapon_anim_global, 0)
    end
    local weapon_usage = weap_tweak.usage
    l_77_0._machine:set_global(weapon_usage, 1)
    l_77_0._weapon_anim_global = weapon_usage
  end
end

HuskPlayerMovement.current_state_name = function(l_78_0)
  return l_78_0._state
end

HuskPlayerMovement.tased = function(l_79_0)
  return l_79_0._state == "tased"
end

HuskPlayerMovement.on_death_exit = function(l_80_0)
end

HuskPlayerMovement.load = function(l_81_0, l_81_1)
  l_81_0.update = HuskPlayerMovement._post_load
  l_81_0._load_data = l_81_1
  if l_81_1.movement.attentions then
    for _,setting_index in ipairs(l_81_1.movement.attentions) do
      local setting_name = tweak_data.attention:get_attention_name(setting_index)
      l_81_0:set_attention_setting_enabled(setting_name, true)
    end
  end
end

HuskPlayerMovement._post_load = function(l_82_0, l_82_1, l_82_2, l_82_3)
  if not managers.network:session() then
    return 
  end
  local peer = managers.network:session():peer(l_82_0._load_data.movement.peer_id)
  if peer then
    local data = l_82_0._load_data
    l_82_0.update = nil
    l_82_0._load_data = nil
    local my_data = data.movement
    if not my_data then
      return 
    end
    peer:set_outfit_string(my_data.outfit)
    UnitNetworkHandler.set_unit(UnitNetworkHandler, l_82_1, my_data.character_name, my_data.outfit, my_data.peer_id)
    if managers.network:game():member_from_unit(l_82_1) == nil then
      Application:error("[HuskPlayerBase:_post_load] A player husk who appears to not have an owning member was detached.")
      Network:detach_unit(l_82_1)
      l_82_1:set_slot(0)
      return 
    end
    l_82_0:sync_movement_state(my_data.state_name, data.down_time)
    l_82_0:sync_pose(my_data.pose)
    if my_data.stance then
      l_82_0:sync_stance(my_data.stance)
    end
    local unit_rot = Rotation(my_data.look_fwd:with_z(0), math.UP)
    l_82_0:set_rotation(unit_rot)
    l_82_0:set_look_dir_instant(my_data.look_fwd)
  end
end

HuskPlayerMovement.save = function(l_83_0, l_83_1)
  local peer_id = managers.network:game():member_from_unit(l_83_0._unit):peer():id()
  l_83_1.movement = {state_name = l_83_0._state, look_fwd = l_83_0:detect_look_dir(), pose = l_83_0._pose_code, stance = l_83_0._stance.code, peer_id = peer_id, character_name = managers.criminals:character_name_by_unit(l_83_0._unit), outfit = managers.network:session():peer(peer_id):profile("outfit_string")}
  l_83_1.down_time = l_83_0._last_down_time
end

HuskPlayerMovement.pre_destroy = function(l_84_0, l_84_1)
  if l_84_0._pos_reservation then
    managers.navigation:unreserve_pos(l_84_0._pos_reservation)
    managers.navigation:unreserve_pos(l_84_0._pos_reservation_slow)
    l_84_0._pos_reservation = nil
    l_84_0._pos_reservation_slow = nil
  end
  l_84_0:set_need_revive(false)
  l_84_0:set_need_assistance(false)
  l_84_0._attention_handler:set_attention(nil)
  if l_84_0._nav_tracker then
    managers.navigation:destroy_nav_tracker(l_84_0._nav_tracker)
    l_84_0._nav_tracker = nil
  end
  if l_84_0._enemy_weapons_hot_listen_id then
    managers.groupai:state():remove_listener(l_84_0._enemy_weapons_hot_listen_id)
    l_84_0._enemy_weapons_hot_listen_id = nil
  end
end

HuskPlayerMovement.set_attention_setting_enabled = function(l_85_0, l_85_1, l_85_2)
  return PlayerMovement.set_attention_setting_enabled(l_85_0, l_85_1, l_85_2, false)
end

HuskPlayerMovement.clbk_attention_notice_sneak = function(l_86_0, l_86_1, l_86_2)
  return PlayerMovement.clbk_attention_notice_sneak(l_86_0, l_86_1, l_86_2)
end

HuskPlayerMovement._create_attention_setting_from_descriptor = function(l_87_0, l_87_1, l_87_2)
  return PlayerMovement._create_attention_setting_from_descriptor(l_87_0, l_87_1, l_87_2)
end

HuskPlayerMovement.attention_handler = function(l_88_0)
  return l_88_0._attention_handler
end

HuskPlayerMovement._feed_suspicion_to_hud = function(l_89_0)
end

HuskPlayerMovement._apply_attention_setting_modifications = function(l_90_0, l_90_1)
  local mul = l_90_0._unit:base():upgrade_value("player", "camouflage_bonus")
  if not l_90_1.notice_delay_mul then
    l_90_1.notice_delay_mul = (not mul or 1) * mul
    if l_90_1.uncover_range then
      l_90_1.uncover_range = l_90_1.uncover_range * 0.5
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HuskPlayerMovement.sync_call_civilian = function(l_91_0, l_91_1)
  if not l_91_0._sympathy_civ and l_91_1:brain():is_available_for_assignment({type = "revive"}) then
    local followup_objective = {type = "free", interrupt_dis = -1, interrupt_health = 1, action = {type = "idle", body_part = 1, sync = true}}
    {type = "act", haste = "run", destroy_clbk_key = false, nav_seg = l_91_0:nav_tracker():nav_segment(), pos = l_91_0:nav_tracker():field_position(), fail_clbk = callback(l_91_0, l_91_0, "on_civ_revive_failed")}.complete_clbk = callback(l_91_0, l_91_0, "on_civ_revive_completed")
     -- DECOMPILER ERROR: Confused about usage of registers!

    {type = "act", haste = "run", destroy_clbk_key = false, nav_seg = l_91_0:nav_tracker():nav_segment(), pos = l_91_0:nav_tracker():field_position(), fail_clbk = callback(l_91_0, l_91_0, "on_civ_revive_failed")}.action_start_clbk = callback(l_91_0, l_91_0, "on_civ_revive_started")
     -- DECOMPILER ERROR: Confused about usage of registers!

    {type = "act", haste = "run", destroy_clbk_key = false, nav_seg = l_91_0:nav_tracker():nav_segment(), pos = l_91_0:nav_tracker():field_position(), fail_clbk = callback(l_91_0, l_91_0, "on_civ_revive_failed")}.action = {type = "act", variant = "revive", body_part = 1, blocks = {action = -1, walk = -1, light_hurt = -1, hurt = -1, heavy_hurt = -1, aim = -1}, align_sync = true}
     -- DECOMPILER ERROR: Confused about usage of registers!

    {type = "act", haste = "run", destroy_clbk_key = false, nav_seg = l_91_0:nav_tracker():nav_segment(), pos = l_91_0:nav_tracker():field_position(), fail_clbk = callback(l_91_0, l_91_0, "on_civ_revive_failed")}.action_duration = tweak_data.interaction.revive.timer
     -- DECOMPILER ERROR: Confused about usage of registers!

    {type = "act", haste = "run", destroy_clbk_key = false, nav_seg = l_91_0:nav_tracker():nav_segment(), pos = l_91_0:nav_tracker():field_position(), fail_clbk = callback(l_91_0, l_91_0, "on_civ_revive_failed")}.followup_objective = followup_objective
    do
       -- DECOMPILER ERROR: Confused at declaration of local variable

      l_91_0._sympathy_civ = l_91_1
       -- DECOMPILER ERROR: Confused about usage of registers!

      l_91_1:brain():set_objective({type = "act", haste = "run", destroy_clbk_key = false, nav_seg = l_91_0:nav_tracker():nav_segment(), pos = l_91_0:nav_tracker():field_position(), fail_clbk = callback(l_91_0, l_91_0, "on_civ_revive_failed")})
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

HuskPlayerMovement.on_civ_revive_started = function(l_92_0, l_92_1)
  if l_92_0._unit:interaction():active() then
    l_92_0._unit:interaction():interact_start(l_92_1)
  end
  if l_92_0._revive_rescuer then
    local rescuer = l_92_0._revive_rescuer
    l_92_0._revive_rescuer = nil
    rescuer:brain():set_objective(nil)
  elseif l_92_0._revive_SO_id then
    managers.groupai:state():remove_special_objective(l_92_0._revive_SO_id)
    l_92_0._revive_SO_id = nil
  end
end

HuskPlayerMovement.on_civ_revive_failed = function(l_93_0, l_93_1)
  if l_93_0._sympathy_civ then
    l_93_0._sympathy_civ = nil
  end
end

HuskPlayerMovement.on_civ_revive_completed = function(l_94_0, l_94_1)
  if l_94_1 ~= l_94_0._sympathy_civ then
    debug_pause_unit(l_94_1, "[HuskPlayerMovement:on_civ_revive_completed] idiot thinks he is reviving", l_94_1)
    return 
  end
  l_94_0._sympathy_civ = nil
  if l_94_0._unit:interaction():active() then
    l_94_0._unit:interaction():interact(l_94_1)
  end
  l_94_0:_unregister_revive_SO()
  if l_94_0._unit:base():upgrade_value("player", "civilian_gives_ammo") then
    managers.game_play_central:spawn_pickup({name = "ammo", position = l_94_1:position(), rotation = Rotation()})
  end
end

HuskPlayerMovement.sync_stance = function(l_95_0, l_95_1)
  l_95_0._stance.owner_stance_code = l_95_1
  l_95_0:_chk_change_stance()
end

HuskPlayerMovement._chk_change_stance = function(l_96_0)
  local wanted_stance_code = nil
  if l_96_0._is_weapon_gadget_on then
    wanted_stance_code = 3
  elseif l_96_0._aim_up_expire_t then
    wanted_stance_code = 3
  else
    wanted_stance_code = l_96_0._stance.owner_stance_code
  end
  if wanted_stance_code ~= l_96_0._stance.code then
    l_96_0:_change_stance(wanted_stance_code)
  end
end

HuskPlayerMovement._get_max_move_speed = function(l_97_0, l_97_1)
  local my_tweak = tweak_data.player.movement_state.standard
  if l_97_0._state.name == "cbt" then
    return my_tweak.movement.speed.STEELSIGHT_MAX
  end
  if not l_97_0._unit:base():upgrade_value("player", "crouch_speed_multiplier") then
    return my_tweak.movement.speed.CROUCHING_MAX * (l_97_0._pose_code ~= 2 or 1)
  end
  local move_speed = nil
  if not l_97_0._unit:base():upgrade_value("player", "run_speed_multiplier") then
    move_speed = my_tweak.movement.speed.RUNNING_MAX * (not l_97_1 or 1)
    do return end
  end
  move_speed = my_tweak.movement.speed.STANDARD_MAX * (l_97_0._unit:base():upgrade_value("player", "walk_speed_multiplier") or 1)
  return move_speed
end

HuskPlayerMovement._walk_spline = function(l_98_0, l_98_1, l_98_2)
  local path = l_98_0.path
  do
    local seg_dir = l_98_0.seg_dir
    repeat
      repeat
        repeat
          local prog_in_seg = l_98_0.prog_in_seg + l_98_2
          if l_98_0.seg_len == 0 or l_98_0.seg_len <= prog_in_seg then
            if #path == 2 then
              l_98_0.prog_in_seg = l_98_0.seg_len
              return mvector3.copy(path[2]), true
            else
              table.remove(path, 1)
              l_98_2 = l_98_2 - l_98_0.seg_len + l_98_0.prog_in_seg
              l_98_0.path_len = l_98_0.path_len - l_98_0.seg_len
              l_98_0.prog_in_seg = 0
              mvec3_set(seg_dir, path[2])
              mvec3_sub(seg_dir, path[1])
              if mvector3.z(seg_dir) < 0 then
                mvec3_set_z(seg_dir, 0)
              end
              l_98_0.seg_len = mvec3_norm(seg_dir)
            else
              l_98_0.prog_in_seg = prog_in_seg
              do
                local return_vec = Vector3()
                mvector3.lerp(return_vec, path[1], path[2], prog_in_seg / l_98_0.seg_len)
                return return_vec, nil
              end
              do return end
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HuskPlayerMovement._chk_groun_ray = function(l_99_0)
  local up_pos = tmp_vec1
  mvec3_set(up_pos, math.UP)
  mvec3_mul(up_pos, 30)
  mvec3_add(up_pos, l_99_0._m_pos)
  local down_pos = tmp_vec2
  mvec3_set(down_pos, math.UP)
  mvec3_mul(down_pos, -20)
  mvec3_add(down_pos, l_99_0._m_pos)
  return World:raycast("ray", up_pos, down_pos, "slot_mask", l_99_0._slotmask_gnd_ray, "ray_type", "walk", "report")
end


