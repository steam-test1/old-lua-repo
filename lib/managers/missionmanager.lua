-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\missionmanager.luac 

core:import("CoreMissionManager")
core:import("CoreClass")
require("lib/managers/mission/MissionScriptElement")
require("lib/managers/mission/ElementSpawnEnemyGroup")
require("lib/managers/mission/ElementEnemyPrefered")
require("lib/managers/mission/ElementAIGraph")
require("lib/managers/mission/ElementWaypoint")
require("lib/managers/mission/ElementSpawnCivilian")
require("lib/managers/mission/ElementSpawnCivilianGroup")
require("lib/managers/mission/ElementLookAtTrigger")
require("lib/managers/mission/ElementMissionEnd")
require("lib/managers/mission/ElementObjective")
require("lib/managers/mission/ElementConsoleCommand")
require("lib/managers/mission/ElementDialogue")
require("lib/managers/mission/ElementHeat")
require("lib/managers/mission/ElementHint")
require("lib/managers/mission/ElementMoney")
require("lib/managers/mission/ElementFleePoint")
require("lib/managers/mission/ElementAiGlobalEvent")
require("lib/managers/mission/ElementEquipment")
require("lib/managers/mission/ElementAreaMinPoliceForce")
require("lib/managers/mission/ElementPlayerState")
require("lib/managers/mission/ElementKillZone")
require("lib/managers/mission/ElementActionMessage")
require("lib/managers/mission/ElementGameDirection")
require("lib/managers/mission/ElementPressure")
require("lib/managers/mission/ElementDangerZone")
require("lib/managers/mission/ElementScenarioEvent")
require("lib/managers/mission/ElementSpecialObjective")
require("lib/managers/mission/ElementSpecialObjectiveTrigger")
require("lib/managers/mission/ElementSpecialObjectiveGroup")
require("lib/managers/mission/ElementSecretAssignment")
require("lib/managers/mission/ElementDifficulty")
require("lib/managers/mission/ElementBlurZone")
require("lib/managers/mission/ElementAIRemove")
require("lib/managers/mission/ElementFlashlight")
require("lib/managers/mission/ElementTeammateComment")
require("lib/managers/mission/ElementCharacterOutline")
require("lib/managers/mission/ElementFakeAssaultState")
require("lib/managers/mission/ElementWhisperState")
require("lib/managers/mission/ElementDifficultyLevelCheck")
require("lib/managers/mission/ElementAwardAchievment")
require("lib/managers/mission/ElementPlayerNumberCheck")
require("lib/managers/mission/ElementPointOfNoReturn")
require("lib/managers/mission/ElementFadeToBlack")
require("lib/managers/mission/ElementAlertTrigger")
require("lib/managers/mission/ElementFeedback")
require("lib/managers/mission/ElementExplosion")
require("lib/managers/mission/ElementFilter")
require("lib/managers/mission/ElementDisableUnit")
require("lib/managers/mission/ElementEnableUnit")
require("lib/managers/mission/ElementSmokeGrenade")
require("lib/managers/mission/ElementDisableShout")
require("lib/managers/mission/ElementSetOutline")
require("lib/managers/mission/ElementExplosionDamage")
require("lib/managers/mission/ElementSequenceCharacter")
require("lib/managers/mission/ElementPlayerStyle")
require("lib/managers/mission/ElementDropinState")
require("lib/managers/mission/ElementBainState")
require("lib/managers/mission/ElementBlackscreenVariant")
require("lib/managers/mission/ElementAccessCamera")
require("lib/managers/mission/ElementAIAttention")
require("lib/managers/mission/ElementMissionFilter")
require("lib/managers/mission/ElementAIArea")
require("lib/managers/mission/ElementSecurityCamera")
require("lib/managers/mission/ElementCarry")
require("lib/managers/mission/ElementLootBag")
require("lib/managers/mission/ElementJobValue")
require("lib/managers/mission/ElementJobStageAlternative")
require("lib/managers/mission/ElementNavObstacle")
require("lib/managers/mission/ElementLootSecuredTrigger")
require("lib/managers/mission/ElementMandatoryBags")
require("lib/managers/mission/ElementAssetTrigger")
require("lib/managers/mission/ElementSpawnDeployable")
require("lib/managers/mission/ElementInventoryDummy")
require("lib/managers/mission/ElementProfileFilter")
require("lib/managers/mission/ElementFleePoint")
require("lib/managers/mission/ElementPlayerSpawner")
require("lib/managers/mission/ElementAreaTrigger")
require("lib/managers/mission/ElementSpawnEnemyDummy")
require("lib/managers/mission/ElementEnemyDummyTrigger")
if not MissionManager then
  MissionManager = class(CoreMissionManager.MissionManager)
end
MissionManager.init = function(l_1_0, ...)
  MissionManager.super.init(l_1_0, ...)
  l_1_0:add_area_instigator_categories("player")
  l_1_0:add_area_instigator_categories("enemies")
  l_1_0:add_area_instigator_categories("civilians")
  l_1_0:add_area_instigator_categories("escorts")
  l_1_0:add_area_instigator_categories("criminals")
  l_1_0:add_area_instigator_categories("ai_teammates")
  l_1_0:add_area_instigator_categories("loot")
  l_1_0:add_area_instigator_categories("unique_loot")
  l_1_0:set_default_area_instigator("player")
  l_1_0:set_global_event_list({"bankmanager_key", "chavez_key", "blue_key", "keycard", "start_assault", "end_assault", "police_called", "police_weapons_hot", "loot_lost", "special_event_a", "special_event_b", "special_event_c", "special_event_d", "special_event_e", "special_event_f", "special_event_g", "loot_bag"})
  l_1_0._mission_filter = {}
  if not Global.mission_manager then
    Global.mission_manager = {}
    Global.mission_manager.stage_job_values = {}
    Global.mission_manager.job_values = {}
    Global.mission_manager.saved_job_values = {}
    Global.mission_manager.has_played_tutorial = false
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

MissionManager.set_saved_job_value = function(l_2_0, l_2_1, l_2_2)
  Global.mission_manager.saved_job_values[l_2_1] = l_2_2
end

MissionManager.get_saved_job_value = function(l_3_0, l_3_1)
  return Global.mission_manager.saved_job_values[l_3_1]
end

MissionManager.on_reset_profile = function(l_4_0)
  Global.mission_manager.saved_job_values.playedSafeHouseBefore = nil
end

MissionManager.set_job_value = function(l_5_0, l_5_1, l_5_2)
  Global.mission_manager.stage_job_values[l_5_1] = l_5_2
end

MissionManager.get_job_value = function(l_6_0, l_6_1)
  if not Global.mission_manager.job_values[l_6_1] then
    return Global.mission_manager.stage_job_values[l_6_1]
  end
end

MissionManager.on_job_deactivated = function(l_7_0)
  Global.mission_manager.job_values = {}
  Global.mission_manager.stage_job_values = {}
end

MissionManager.on_retry_job_stage = function(l_8_0)
  Global.mission_manager.stage_job_values = {}
end

MissionManager.on_stage_success = function(l_9_0)
  for key,value in pairs(Global.mission_manager.stage_job_values) do
    Global.mission_manager.job_values[key] = value
  end
  Global.mission_manager.stage_job_values = {}
end

MissionManager.set_mission_filter = function(l_10_0, l_10_1)
  l_10_0._mission_filter = l_10_1
end

MissionManager.check_mission_filter = function(l_11_0, l_11_1)
  return table.contains(l_11_0._mission_filter, l_11_1)
end

MissionManager.default_instigator = function(l_12_0)
  return managers.player:player_unit()
end

MissionManager.activate_script = function(l_13_0, ...)
  MissionManager.super.activate_script(l_13_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MissionManager.client_run_mission_element = function(l_14_0, l_14_1, l_14_2)
  for name,data in pairs(l_14_0._scripts) do
    if data:element(l_14_1) then
      data:element(l_14_1):client_on_executed(l_14_2)
      return 
    end
  end
end

MissionManager.client_run_mission_element_end_screen = function(l_15_0, l_15_1, l_15_2)
  for name,data in pairs(l_15_0._scripts) do
    if data:element(l_15_1) and data:element(l_15_1).client_on_executed_end_screen then
      data:element(l_15_1):client_on_executed_end_screen(l_15_2)
    end
    return 
  end
end

MissionManager.server_run_mission_element_trigger = function(l_16_0, l_16_1, l_16_2)
  for name,data in pairs(l_16_0._scripts) do
    local element = data:element(l_16_1)
    if element then
      element:on_executed(l_16_2)
      return 
    end
  end
end

MissionManager.server_enter_area = function(l_17_0, l_17_1, l_17_2)
  for name,data in pairs(l_17_0._scripts) do
    local element = data:element(l_17_1)
    if element then
      element:sync_enter_area(l_17_2)
    end
  end
end

MissionManager.server_exit_area = function(l_18_0, l_18_1, l_18_2)
  for name,data in pairs(l_18_0._scripts) do
    local element = data:element(l_18_1)
    if element then
      element:sync_exit_area(l_18_2)
    end
  end
end

MissionManager.to_server_access_camera_trigger = function(l_19_0, l_19_1, l_19_2, l_19_3)
  for name,data in pairs(l_19_0._scripts) do
    local element = data:element(l_19_1)
    if element then
      element:check_triggers(l_19_2, l_19_3)
    end
  end
end

MissionManager.save_job_values = function(l_20_0, l_20_1)
  local state = {saved_job_values = Global.mission_manager.saved_job_values, has_played_tutorial = Global.mission_manager.has_played_tutorial}
  l_20_1.ProductMissionManager = state
end

MissionManager.load_job_values = function(l_21_0, l_21_1)
  local state = l_21_1.ProductMissionManager
  if state then
    Global.mission_manager.saved_job_values = state.saved_job_values
    Global.mission_manager.has_played_tutorial = state.has_played_tutorial
  end
end

MissionManager.stop_simulation = function(l_22_0, ...)
  MissionManager.super.stop_simulation(l_22_0, ...)
  Global.mission_manager.saved_job_values = {}
  l_22_0:on_job_deactivated()
  managers.loot:reset()
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MissionManager.debug_execute_mission_element_by_name = function(l_23_0, l_23_1)
  for _,data in pairs(l_23_0._scripts) do
    for id,element in pairs(data:elements()) do
      if element:editor_name() == l_23_1 then
        element:on_executed()
        return 
      end
    end
  end
end

CoreClass.override_class(CoreMissionManager.MissionManager, MissionManager)
if not MissionScript then
  MissionScript = class(CoreMissionManager.MissionScript)
end
MissionScript.activate = function(l_24_0, ...)
  if Network:is_server() then
    MissionScript.super.activate(l_24_0, ...)
    return 
  end
  managers.mission:add_persistent_debug_output("")
  managers.mission:add_persistent_debug_output("Activate mission " .. l_24_0._name, Color(1, 0, 1, 0))
  for _,element in pairs(l_24_0._elements) do
    element:on_script_activated()
  end
  for _,element in pairs(l_24_0._elements) do
  end
  if element:value("execute_on_startup") then
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

     -- Warning: missing end command somewhere! Added here
  end
end

CoreClass.override_class(CoreMissionManager.MissionScript, MissionScript)

