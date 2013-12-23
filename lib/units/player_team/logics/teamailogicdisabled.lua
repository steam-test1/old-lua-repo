-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\player_team\logics\teamailogicdisabled.luac 

require("lib/units/enemies/cop/logics/CopLogicAttack")
TeamAILogicDisabled = class(TeamAILogicAssault)
TeamAILogicDisabled.on_long_dis_interacted = TeamAILogicIdle.on_long_dis_interacted
TeamAILogicDisabled.enter = function(l_1_0, l_1_1, l_1_2)
  TeamAILogicBase.enter(l_1_0, l_1_1, l_1_2)
  l_1_0.unit:brain():cancel_all_pathing_searches()
  local old_internal_data = l_1_0.internal_data
  local my_data = {unit = l_1_0.unit}
  l_1_0.internal_data = my_data
  my_data.detection = l_1_0.char_tweak.detection.combat
  my_data.enemy_detect_slotmask = managers.slot:get_mask("enemies")
  my_data.rsrv_pos = {}
  if old_internal_data then
    if not old_internal_data.rsrv_pos then
      my_data.rsrv_pos = my_data.rsrv_pos
    end
    CopLogicAttack._set_best_cover(l_1_0, my_data, old_internal_data.best_cover)
    CopLogicAttack._set_nearest_cover(my_data, old_internal_data.nearest_cover)
    my_data.attention = old_internal_data.attention
  end
  local key_str = tostring(l_1_0.key)
  my_data.detection_task_key = "TeamAILogicDisabled._upd_enemy_detection" .. key_str
  CopLogicBase.queue_task(my_data, my_data.detection_task_key, TeamAILogicDisabled._upd_enemy_detection, l_1_0, l_1_0.t)
  my_data.stay_cool = nil
  if l_1_0.unit:character_damage():need_revive() then
    TeamAILogicDisabled._register_revive_SO(l_1_0, my_data, "revive")
  end
  l_1_0.unit:brain():set_update_enabled_state(false)
  if not l_1_0.unit:character_damage():bleed_out() then
    my_data.invulnerable = true
    l_1_0.unit:character_damage():set_invulnerable(true)
  end
  if l_1_0.objective then
    managers.groupai:state():on_criminal_objective_failed(l_1_0.unit, l_1_0.objective, true)
    l_1_0.unit:brain():set_objective(nil)
  end
end

TeamAILogicDisabled.exit = function(l_2_0, l_2_1, l_2_2)
  TeamAILogicBase.exit(l_2_0, l_2_1, l_2_2)
  local my_data = l_2_0.internal_data
  my_data.exiting = true
  TeamAILogicDisabled._unregister_revive_SO(my_data)
  if my_data.invulnerable then
    l_2_0.unit:character_damage():set_invulnerable(false)
  end
  CopLogicBase.cancel_queued_tasks(my_data)
  if my_data.best_cover then
    managers.navigation:release_cover(my_data.best_cover[1])
  end
  if my_data.nearest_cover then
    managers.navigation:release_cover(my_data.nearest_cover[1])
  end
  if l_2_1 ~= "inactive" then
    l_2_0.unit:brain():set_update_enabled_state(true)
  end
end

TeamAILogicDisabled._upd_enemy_detection = function(l_3_0)
  l_3_0.t = TimerManager:game():time()
  local my_data = l_3_0.internal_data
  local delay = CopLogicBase._upd_attention_obj_detection(l_3_0, AIAttentionObject.REACT_SURPRISED, nil)
  local new_attention, new_prio_slot, new_reaction = TeamAILogicIdle._get_priority_attention(l_3_0, l_3_0.detected_attention_objects, nil, l_3_0.cool)
  TeamAILogicBase._set_attention_obj(l_3_0, new_attention, new_reaction)
  TeamAILogicDisabled._upd_aim(l_3_0, my_data)
  CopLogicBase.queue_task(my_data, my_data.detection_task_key, TeamAILogicDisabled._upd_enemy_detection, l_3_0, l_3_0.t + delay)
end

TeamAILogicDisabled.on_intimidated = function(l_4_0, l_4_1, l_4_2)
end

TeamAILogicDisabled._consider_surrender = function(l_5_0, l_5_1)
  l_5_1.stay_cool_chk_t = TimerManager:game():time()
  local my_health_ratio = l_5_0.unit:character_damage():health_ratio()
  if my_health_ratio < 0.10000000149012 then
    return 
  end
  local my_health = my_health_ratio * l_5_0.unit:character_damage()._HEALTH_BLEEDOUT_INIT
  local total_scare = 0
  for e_key,e_data in pairs(l_5_0.detected_attention_objects) do
    if e_data.verified and e_data.unit:in_slot(l_5_0.enemy_slotmask) then
      local scare = tweak_data.character[e_data.unit:base()._tweak_table].HEALTH_INIT / my_health
      scare = scare * (1 - math.clamp(e_data.verified_dis - 300, 0, 2500) / 2500)
      total_scare = total_scare + scare
    end
  end
  for c_key,c_data in pairs(managers.groupai:state():all_player_criminals()) do
    if not c_data.status then
      local support = tweak_data.player.damage.HEALTH_INIT / my_health
      local dis = mvector3.distance(c_data.m_pos, l_5_0.m_pos)
      if dis < 700 then
        total_scare = 0
      else
        support = 3 * support * (1 - math.clamp(dis - 300, 0, 2500) / 2500)
        total_scare = total_scare - support
      end
    end
    if total_scare > 1 then
      l_5_1.stay_cool = true
      if l_5_1.firing then
        l_5_0.unit:movement():set_allow_fire(false)
        l_5_1.firing = nil
      else
        l_5_1.stay_cool = false
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

TeamAILogicDisabled._upd_aim = function(l_6_0, l_6_1)
  local shoot, aim = nil, nil
  local focus_enemy = l_6_0.attention_obj
  if l_6_1.stay_cool then
    do return end
  end
  if focus_enemy and focus_enemy.verified and (focus_enemy.verified_dis < 2000 or not l_6_1.alert_t or l_6_0.t - l_6_1.alert_t < 7) then
    shoot = true
    do return end
    if focus_enemy.verified_t and l_6_0.t - focus_enemy.verified_t < 10 then
      aim = true
      if l_6_1.shooting and l_6_0.t - focus_enemy.verified_t < 3 then
        shoot = true
      elseif focus_enemy.verified_dis < 600 and l_6_1.walking_to_cover_shoot_pos then
        aim = true
      end
    end
  end
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if (aim or shoot) and focus_enemy.verified and l_6_1.attention ~= focus_enemy.u_key then
    CopLogicBase._set_attention(l_6_0, focus_enemy)
    l_6_1.attention = focus_enemy.u_key
    do return end
    if l_6_1.attention ~= focus_enemy.verified_pos then
      CopLogicBase._set_attention_on_pos(l_6_0, mvector3.copy(focus_enemy.verified_pos))
      l_6_1.attention = mvector3.copy(focus_enemy.verified_pos)
      do return end
      if l_6_1.shooting then
        local new_action = nil
        if l_6_0.unit:anim_data().reload then
          new_action = {type = "reload", body_part = 3}
        else
          new_action = {type = "idle", body_part = 3}
        end
        l_6_0.unit:brain():action_request(new_action)
      end
      if l_6_1.attention then
        CopLogicBase._reset_attention(l_6_0)
        l_6_1.attention = nil
      end
    end
  end
  if shoot and not l_6_1.firing then
    l_6_0.unit:movement():set_allow_fire(true)
    l_6_1.firing = true
    do return end
    if l_6_1.firing then
      l_6_0.unit:movement():set_allow_fire(false)
      l_6_1.firing = nil
    end
  end
end

TeamAILogicDisabled.on_recovered = function(l_7_0, l_7_1)
  local my_data = l_7_0.internal_data
  if l_7_1 and my_data.rescuer and my_data.rescuer:key() == l_7_1:key() then
    my_data.rescuer = nil
  else
    TeamAILogicDisabled._unregister_revive_SO(my_data)
  end
  CopLogicBase._exit(l_7_0.unit, "assault")
end

TeamAILogicDisabled._register_revive_SO = function(l_8_0, l_8_1, l_8_2)
  local followup_objective = {type = "act", scan = true, action = {type = "act", body_part = 1, variant = "crouch", blocks = {action = -1, walk = -1, hurt = -1, heavy_hurt = -1, aim = -1}}}
  {type = "revive", follow_unit = l_8_0.unit, called = true, scan = true, destroy_clbk_key = false, nav_seg = l_8_0.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(TeamAILogicDisabled, TeamAILogicDisabled, "on_revive_SO_failed", l_8_0), interrupt_dis = 400}.interrupt_health = 0.25
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "revive", follow_unit = l_8_0.unit, called = true, scan = true, destroy_clbk_key = false, nav_seg = l_8_0.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(TeamAILogicDisabled, TeamAILogicDisabled, "on_revive_SO_failed", l_8_0), interrupt_dis = 400}.action = {type = "act", variant = l_8_2, body_part = 1, blocks = {action = -1, walk = -1, light_hurt = -1, hurt = -1, heavy_hurt = -1, aim = -1}, align_sync = true}
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "revive", follow_unit = l_8_0.unit, called = true, scan = true, destroy_clbk_key = false, nav_seg = l_8_0.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(TeamAILogicDisabled, TeamAILogicDisabled, "on_revive_SO_failed", l_8_0), interrupt_dis = 400}.action_duration = tweak_data.interaction[l_8_0.name == "surrender" and "free" or "revive"].timer
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "revive", follow_unit = l_8_0.unit, called = true, scan = true, destroy_clbk_key = false, nav_seg = l_8_0.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(TeamAILogicDisabled, TeamAILogicDisabled, "on_revive_SO_failed", l_8_0), interrupt_dis = 400}.followup_objective = followup_objective
   -- DECOMPILER ERROR: Confused at declaration of local variable

   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "revive", follow_unit = l_8_0.unit, called = true, scan = true, destroy_clbk_key = false, nav_seg = l_8_0.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(TeamAILogicDisabled, TeamAILogicDisabled, "on_revive_SO_failed", l_8_0), interrupt_dis = 400}, base_chance = 1}.chance_inc = 0
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "revive", follow_unit = l_8_0.unit, called = true, scan = true, destroy_clbk_key = false, nav_seg = l_8_0.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(TeamAILogicDisabled, TeamAILogicDisabled, "on_revive_SO_failed", l_8_0), interrupt_dis = 400}, base_chance = 1}.interval = 6
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "revive", follow_unit = l_8_0.unit, called = true, scan = true, destroy_clbk_key = false, nav_seg = l_8_0.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(TeamAILogicDisabled, TeamAILogicDisabled, "on_revive_SO_failed", l_8_0), interrupt_dis = 400}, base_chance = 1}.search_dis_sq = 1000000
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "revive", follow_unit = l_8_0.unit, called = true, scan = true, destroy_clbk_key = false, nav_seg = l_8_0.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(TeamAILogicDisabled, TeamAILogicDisabled, "on_revive_SO_failed", l_8_0), interrupt_dis = 400}, base_chance = 1}.search_pos = mvector3.copy(l_8_0.m_pos)
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "revive", follow_unit = l_8_0.unit, called = true, scan = true, destroy_clbk_key = false, nav_seg = l_8_0.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(TeamAILogicDisabled, TeamAILogicDisabled, "on_revive_SO_failed", l_8_0), interrupt_dis = 400}, base_chance = 1}.usage_amount = 1
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "revive", follow_unit = l_8_0.unit, called = true, scan = true, destroy_clbk_key = false, nav_seg = l_8_0.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(TeamAILogicDisabled, TeamAILogicDisabled, "on_revive_SO_failed", l_8_0), interrupt_dis = 400}, base_chance = 1}.AI_group = "friendlies"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {objective = {type = "revive", follow_unit = l_8_0.unit, called = true, scan = true, destroy_clbk_key = false, nav_seg = l_8_0.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(TeamAILogicDisabled, TeamAILogicDisabled, "on_revive_SO_failed", l_8_0), interrupt_dis = 400}, base_chance = 1}.admin_clbk = callback(TeamAILogicDisabled, TeamAILogicDisabled, "on_revive_SO_administered", l_8_0)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

    l_8_1.SO_id = "TeamAIrevive" .. tostring(l_8_0.key)
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    managers.groupai:state():add_special_objective("TeamAIrevive" .. tostring(l_8_0.key), {objective = {type = "revive", follow_unit = l_8_0.unit, called = true, scan = true, destroy_clbk_key = false, nav_seg = l_8_0.unit:movement():nav_tracker():nav_segment(), fail_clbk = callback(TeamAILogicDisabled, TeamAILogicDisabled, "on_revive_SO_failed", l_8_0), interrupt_dis = 400}, base_chance = 1})
    l_8_1.deathguard_SO_id = PlayerBleedOut._register_deathguard_SO(l_8_0.unit)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

TeamAILogicDisabled._unregister_revive_SO = function(l_9_0)
  if l_9_0.deathguard_SO_id then
    PlayerBleedOut._unregister_deathguard_SO(l_9_0.deathguard_SO_id)
    l_9_0.deathguard_SO_id = nil
  end
  if l_9_0.rescuer then
    local rescuer = l_9_0.rescuer
    l_9_0.rescuer = nil
    if rescuer:brain():objective() then
      managers.groupai:state():on_criminal_objective_failed(rescuer, rescuer:brain():objective())
    elseif l_9_0.SO_id then
      managers.groupai:state():remove_special_objective(l_9_0.SO_id)
      l_9_0.SO_id = nil
    end
  end
end

TeamAILogicDisabled.is_available_for_assignment = function(l_10_0, l_10_1)
  return false
end

TeamAILogicDisabled.damage_clbk = function(l_11_0, l_11_1)
  local my_data = l_11_0.internal_data
  if l_11_0.unit:character_damage():need_revive() and not my_data.SO_id and not my_data.rescuer then
    TeamAILogicDisabled._register_revive_SO(l_11_0, my_data, "revive")
  end
  if l_11_1.result.type == "fatal" then
    CopLogicBase.cancel_queued_tasks(my_data)
    if not my_data.invulnerable then
      my_data.invulnerable = true
      l_11_0.unit:character_damage():set_invulnerable(true)
    end
  end
  TeamAILogicIdle.damage_clbk(l_11_0, l_11_1)
end

TeamAILogicDisabled.on_revive_SO_administered = function(l_12_0, l_12_1, l_12_2)
  local my_data = l_12_1.internal_data
  my_data.rescuer = l_12_2
  my_data.SO_id = nil
end

TeamAILogicDisabled.on_revive_SO_failed = function(l_13_0, l_13_1)
  local my_data = l_13_1.internal_data
  if my_data.rescuer and (l_13_1.unit:character_damage():need_revive() or l_13_1.unit:character_damage():arrested()) and not my_data.exiting then
    my_data.rescuer = nil
    TeamAILogicDisabled._register_revive_SO(l_13_1, my_data, "revive")
  end
end

TeamAILogicDisabled.on_new_objective = function(l_14_0, l_14_1)
  TeamAILogicBase.on_new_objective(l_14_0, l_14_1)
  if l_14_1 and l_14_1.fail_clbk then
    l_14_1.fail_clbk(l_14_0.unit)
  end
end


