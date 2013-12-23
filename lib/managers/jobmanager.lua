-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\jobmanager.luac 

if not JobManager then
  JobManager = class()
end
JobManager.init = function(l_1_0)
  l_1_0:_setup()
end

JobManager._setup = function(l_2_0)
  if not Global.job_manager then
    Global.job_manager = {}
  end
  l_2_0._global = Global.job_manager
end

JobManager.on_retry_job_stage = function(l_3_0)
  l_3_0._global.next_alternative_stage = nil
  l_3_0._global.next_interupt_stage = nil
end

JobManager.synced_alternative_stage = function(l_4_0, l_4_1)
  l_4_0._global.alternative_stage = l_4_1
end

JobManager.set_next_alternative_stage = function(l_5_0, l_5_1)
  l_5_0._global.next_alternative_stage = l_5_1
end

JobManager.alternative_stage = function(l_6_0)
  return l_6_0._global.alternative_stage
end

JobManager.synced_interupt_stage = function(l_7_0, l_7_1)
  l_7_0._global.interupt_stage = l_7_1
end

JobManager.set_next_interupt_stage = function(l_8_0, l_8_1)
  l_8_0._global.next_interupt_stage = l_8_1
end

JobManager.interupt_stage = function(l_9_0)
  return l_9_0._global.interupt_stage
end

JobManager.has_active_job = function(l_10_0)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end

JobManager.activate_job = function(l_11_0, l_11_1, l_11_2)
  local job = tweak_data.narrative.jobs[l_11_1]
  if not job then
    Application:error("No job named", l_11_1, "!")
    return 
  end
  l_11_0._global.current_job = {job_id = l_11_1, current_stage = l_11_2 or 1, last_completed_stage = 0, stages = #job.chain}
  l_11_0._global.start_time = TimerManager:wall_running():time()
  return true
end

JobManager.deactivate_current_job = function(l_12_0)
  l_12_0._global.current_job = nil
  l_12_0._global.alternative_stage = nil
  l_12_0._global.next_alternative_stage = nil
  l_12_0._global.interupt_stage = nil
  l_12_0._global.next_interupt_stage = nil
  l_12_0._global.start_time = nil
  managers.loot:on_job_deactivated()
  managers.mission:on_job_deactivated()
end

JobManager.complete_stage = function(l_13_0)
  l_13_0._global.current_job.current_stage = current_stage + 1
end

JobManager.on_last_stage = function(l_14_0)
  if not l_14_0._global.current_job then
    return false
  end
  return l_14_0._global.current_job.current_stage == l_14_0._global.current_job.stages
end

JobManager.is_job_finished = function(l_15_0)
  if not l_15_0._global.current_job then
    return false
  end
  return l_15_0._global.current_job.last_completed_stage == l_15_0._global.current_job.stages
end

JobManager.next_stage = function(l_16_0)
  if not l_16_0:has_active_job() then
    return 
  end
  l_16_0._global.current_job.last_completed_stage = l_16_0._global.current_job.current_stage
  if l_16_0:is_job_finished() then
    l_16_0:_check_add_to_cooldown()
    managers.achievment:award("no_turning_back")
    return 
  end
  l_16_0._global.alternative_stage = l_16_0._global.next_alternative_stage
  l_16_0._global.next_alternative_stage = nil
  l_16_0._global.interupt_stage = l_16_0._global.next_interupt_stage
  l_16_0._global.next_interupt_stage = nil
  if not l_16_0._global.interupt_stage then
    l_16_0:set_current_stage(l_16_0._global.current_job.current_stage + 1)
  end
  Global.game_settings.level_id = managers.job:current_level_id()
  Global.game_settings.mission = managers.job:current_mission()
  if Network:is_server() then
    MenuCallbackHandler:update_matchmake_attributes()
    local level_id_index = tweak_data.levels:get_index_from_level_id(Global.game_settings.level_id)
    local interupt_level_id_index = l_16_0._global.interupt_stage and tweak_data.levels:get_index_from_level_id(l_16_0._global.interupt_stage) or 0
    managers.network:session():send_to_peers("sync_stage_settings", level_id_index, l_16_0._global.current_job.current_stage, l_16_0._global.alternative_stage or 0, interupt_level_id_index)
  end
end

JobManager.set_current_stage = function(l_17_0, l_17_1)
  l_17_0._global.current_job.current_stage = l_17_1
end

JobManager.current_job_data = function(l_18_0)
  if not l_18_0._global.current_job then
    return 
  end
  return tweak_data.narrative.jobs[l_18_0._global.current_job.job_id]
end

JobManager.current_job_id = function(l_19_0)
  if not l_19_0._global.current_job then
    return 
  end
  return l_19_0._global.current_job.job_id
end

JobManager.is_current_job_professional = function(l_20_0)
  if not l_20_0._global.current_job then
    return 
  end
  return tweak_data.narrative.jobs[l_20_0._global.current_job.job_id].professional
end

JobManager.is_job_professional_by_job_id = function(l_21_0, l_21_1)
  if not l_21_1 or not tweak_data.narrative.jobs[l_21_1] then
    Application:error("[JobManager:is_job_professional_by_job_id] no job id or no job", l_21_1)
    return 
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end

JobManager.current_stage = function(l_22_0)
  if not l_22_0._global.current_job then
    return 
  end
  return l_22_0._global.current_job.current_stage
end

JobManager.current_stage_data = function(l_23_0)
  if not l_23_0._global.current_job then
    return 
  end
  local job_data = tweak_data.narrative.jobs[l_23_0._global.current_job.job_id]
  local stage = job_data.chain[l_23_0._global.current_job.current_stage]
  if not l_23_0._global.alternative_stage then
    return stage[#stage <= 0 or 1]
  end
  return stage
end

JobManager.current_level_id = function(l_24_0)
  if not l_24_0._global.current_job then
    return 
  end
  if l_24_0._global.interupt_stage then
    return l_24_0._global.interupt_stage
  end
  return l_24_0:current_stage_data().level_id
end

JobManager.current_mission = function(l_25_0)
  if not l_25_0._global.current_job then
    return 
  end
  if l_25_0._global.interupt_stage then
    return "none"
  end
  return l_25_0:current_stage_data().mission or "none"
end

JobManager.current_mission_filter = function(l_26_0)
  if not l_26_0._global.current_job then
    return 
  end
  return l_26_0:current_stage_data().mission_filter
end

JobManager.current_level_data = function(l_27_0)
  if not l_27_0._global.current_job then
    return 
  end
  return tweak_data.levels[l_27_0:current_level_id()]
end

JobManager.current_contact_id = function(l_28_0)
  if not l_28_0._global.current_job then
    return 
  end
  return tweak_data.narrative.jobs[l_28_0._global.current_job.job_id].contact
end

JobManager.current_contact_data = function(l_29_0)
  if l_29_0._global.interupt_stage then
    return tweak_data.narrative.contacts.interupt
  end
  return tweak_data.narrative.contacts[l_29_0:current_contact_id()]
end

JobManager.current_job_stars = function(l_30_0)
  return math.ceil(tweak_data.narrative.jobs[l_30_0._global.current_job.job_id].jc / 10)
end

JobManager.current_difficulty_stars = function(l_31_0)
  local difficulty = Global.game_settings.difficulty or "easy"
  local difficulty_id = math.max(0, (tweak_data:difficulty_to_index(difficulty) or 0) - 2)
  return difficulty_id
end

JobManager.current_job_and_difficulty_stars = function(l_32_0)
  local difficulty = Global.game_settings.difficulty or "easy"
  local difficulty_id = math.max(0, (tweak_data:difficulty_to_index(difficulty) or 0) - 2)
  return l_32_0:current_job_stars() + difficulty_id
end

JobManager.set_stage_success = function(l_33_0, l_33_1)
  l_33_0._stage_success = l_33_1
end

JobManager.stage_success = function(l_34_0)
  return l_34_0._stage_success
end

JobManager.check_ok_with_cooldown = function(l_35_0, l_35_1)
  if not l_35_0._global.cooldown then
    return true
  end
  if not l_35_0._global.cooldown[l_35_1] then
    return true
  end
  return l_35_0._global.cooldown[l_35_1] < TimerManager:wall_running():time()
end

JobManager._check_add_to_cooldown = function(l_36_0)
  if Network:is_server() and l_36_0._global.start_time then
    local cooldown_time = l_36_0._global.start_time + tweak_data.narrative.CONTRACT_COOLDOWN_TIME - TimerManager:wall_running():time()
    if cooldown_time > 0 then
      if not l_36_0._global.cooldown then
        l_36_0._global.cooldown = {}
      end
      l_36_0._global.cooldown[l_36_0:current_job_id()] = cooldown_time + TimerManager:wall_running():time()
    end
  end
end


