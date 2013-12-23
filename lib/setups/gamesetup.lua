-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\setups\gamesetup.luac 

core:register_module("lib/managers/RumbleManager")
core:import("CoreAiDataManager")
require("lib/setups/Setup")
require("lib/utils/ListenerHolder")
require("lib/managers/SlotManager")
require("lib/managers/MissionManager")
require("lib/utils/dev/editor/WorldDefinition")
require("lib/managers/ObjectInteractionManager")
require("lib/managers/LocalizationManager")
require("lib/managers/DramaManager")
require("lib/managers/DialogManager")
require("lib/managers/EnemyManager")
require("lib/managers/SpawnManager")
require("lib/managers/HUDManager")
require("lib/managers/RumbleManager")
require("lib/managers/NavigationManager")
require("lib/managers/EnvironmentEffectsManager")
require("lib/managers/OverlayEffectManager")
require("lib/managers/ObjectivesManager")
require("lib/managers/GamePlayCentralManager")
require("lib/managers/HintManager")
require("lib/managers/MoneyManager")
require("lib/managers/ChallengesManager")
require("lib/managers/KillzoneManager")
require("lib/managers/ActionMessagingManager")
require("lib/managers/GroupAIManager")
require("lib/managers/SecretAssignmentManager")
require("lib/managers/StatisticsManager")
require("lib/managers/OcclusionManager")
require("lib/managers/TradeManager")
require("lib/managers/CriminalsManager")
require("lib/managers/FeedBackManager")
require("lib/managers/TimeSpeedManager")
core:import("SequenceManager")
if Application:editor() then
  require("lib/utils/dev/tools/WorldEditor")
  if Application:production_build() then
    require("lib/utils/dev/tools/ParseAllDramas")
  end
end
require("lib/units/SimpleCharacter")
require("lib/units/ScriptUnitData")
require("lib/units/UnitBase")
require("lib/units/SyncUnitData")
require("lib/units/beings/player/PlayerBase")
require("lib/units/beings/player/PlayerCamera")
require("lib/units/beings/player/PlayerSound")
require("lib/units/beings/player/PlayerAnimationData")
require("lib/units/beings/player/PlayerDamage")
require("lib/units/beings/player/PlayerInventory")
require("lib/units/beings/player/PlayerEquipment")
require("lib/units/beings/player/PlayerMovement")
require("lib/network/base/extensions/NetworkBaseExtension")
require("lib/network/extensions/player/HuskPlayerMovement")
require("lib/network/extensions/player/HuskPlayerInventory")
require("lib/network/extensions/player/HuskPlayerBase")
require("lib/network/extensions/player/HuskPlayerDamage")
require("lib/utils/SineSpline")
require("lib/units/cameras/AnimatedCamera")
require("lib/units/cameras/FPCameraPlayerBase")
require("lib/units/cameras/PrevisCamera")
require("lib/units/cameras/WaitingForPlayersCamera")
require("lib/units/cameras/MissionAccessCamera")
require("lib/units/characters/CharacterAttentionObject")
require("lib/units/enemies/cop/CopBase")
require("lib/units/enemies/cop/CopDamage")
require("lib/units/enemies/cop/CopBrain")
require("lib/units/enemies/cop/CopSound")
require("lib/units/enemies/cop/CopInventory")
require("lib/units/enemies/cop/CopMovement")
require("lib/units/enemies/tank/TankCopDamage")
require("lib/network/extensions/cop/HuskCopBase")
require("lib/network/extensions/cop/HuskCopInventory")
require("lib/network/extensions/cop/HuskCopDamage")
require("lib/network/extensions/cop/HuskCopBrain")
require("lib/network/extensions/cop/HuskCopMovement")
require("lib/network/extensions/cop/HuskTankCopDamage")
require("lib/units/characters/DummyCorpseBase")
require("lib/units/civilians/DummyCivilianBase")
require("lib/units/civilians/CivilianBase")
require("lib/units/civilians/CivilianBrain")
require("lib/units/civilians/CivilianDamage")
require("lib/units/civilians/ServerSyncedCivilianDamage")
require("lib/network/extensions/civilian/HuskCivilianBase")
require("lib/network/extensions/civilian/HuskCivilianDamage")
require("lib/network/extensions/civilian/HuskServerSyncedCivilianDamage")
require("lib/units/player_team/TeamAIBase")
require("lib/units/player_team/TeamAIBrain")
require("lib/units/player_team/TeamAIDamage")
require("lib/network/extensions/player_team/HuskTeamAIDamage")
require("lib/units/player_team/TeamAIInventory")
require("lib/network/extensions/player_team/HuskTeamAIInventory")
require("lib/units/player_team/TeamAIMovement")
require("lib/network/extensions/player_team/HuskTeamAIMovement")
require("lib/units/player_team/TeamAISound")
require("lib/network/extensions/player_team/HuskTeamAIBase")
require("lib/units/vehicles/helicopter/AnimatedHeliBase")
require("lib/levels/FortressLevel")
require("lib/levels/SandboxLevel")
require("lib/units/interactions/InteractionExt")
require("lib/units/DramaExt")
require("lib/units/pickups/Pickup")
require("lib/units/pickups/AmmoClip")
require("lib/units/pickups/SpecialEquipmentPickup")
require("lib/units/equipment/ammo_bag/AmmoBagBase")
require("lib/units/equipment/doctor_bag/DoctorBagBase")
require("lib/units/equipment/sentry_gun/SentryGunBase")
require("lib/units/equipment/sentry_gun/SentryGunBrain")
require("lib/units/equipment/sentry_gun/SentryGunMovement")
require("lib/units/equipment/sentry_gun/SentryGunDamage")
require("lib/units/equipment/ecm_jammer/ECMJammerBase")
require("lib/units/weapons/RaycastWeaponBase")
require("lib/units/weapons/NewRaycastWeaponBase")
require("lib/units/weapons/NPCRaycastWeaponBase")
require("lib/units/weapons/NewNPCRaycastWeaponBase")
require("lib/units/weapons/NPCSniperRifleBase")
require("lib/units/weapons/SawWeaponBase")
require("lib/units/weapons/NPCSawWeaponBase")
require("lib/units/weapons/trip_mine/TripMineBase")
require("lib/units/weapons/shotgun/ShotgunBase")
require("lib/units/weapons/shotgun/NewShotgunBase")
require("lib/units/weapons/shotgun/NPCShotgunBase")
require("lib/units/weapons/grenades/GrenadeBase")
require("lib/units/weapons/grenades/FragGrenade")
require("lib/units/weapons/grenades/FlashGrenade")
require("lib/units/weapons/grenades/SmokeGrenade")
require("lib/units/weapons/grenades/QuickSmokeGrenade")
require("lib/units/weapons/grenades/QuickFlashGrenade")
require("lib/units/equipment/repel_rope/RepelRopeBase")
require("lib/units/weapons/GrenadeLauncherBase")
require("lib/units/weapons/NPCGrenadeLauncherBase")
require("lib/units/weapons/grenades/M79GrenadeBase")
require("lib/units/weapons/SentryGunWeapon")
require("lib/units/weapons/WeaponGadgetBase")
require("lib/units/weapons/WeaponFlashLight")
require("lib/units/weapons/WeaponLaser")
require("lib/network/NetworkSpawnPointExt")
require("lib/units/props/MissionDoor")
require("lib/units/props/SecurityCamera")
require("lib/units/props/TimerGui")
require("lib/units/props/MoneyWrapBase")
require("lib/units/props/Drill")
require("lib/units/props/SecurityLockGui")
require("lib/units/props/ChristmasPresentBase")
require("lib/units/props/TvGui")
require("lib/units/props/CarryData")
require("lib/units/props/AIAttentionObject")
require("lib/units/props/SmallLootBase")
require("lib/units/props/SafehouseMoneyStack")
require("lib/units/props/OffshoreGui")
require("lib/managers/menu/FadeoutGuiObject")
if not GameSetup then
  GameSetup = class(Setup)
end
GameSetup.load_packages = function(l_1_0)
  Setup.load_packages(l_1_0)
  if not PackageManager:loaded("packages/game_base") then
    PackageManager:load("packages/game_base")
  end
  local level_package = nil
  if not Global.level_data or not Global.level_data.level_id then
    level_package = "packages/level_debug"
  else
    if Global.level_data and Global.level_data.level_id then
      local lvl_tweak_data = tweak_data.levels[Global.level_data.level_id]
    end
    if lvl_tweak_data then
      level_package = lvl_tweak_data.package
    end
  end
  if level_package then
    if type(level_package) == "table" then
      l_1_0._loaded_level_package = level_package
      for _,package in ipairs(level_package) do
        if not PackageManager:loaded(package) then
          PackageManager:load(package)
        end
      end
    else
      if not PackageManager:loaded(level_package) then
        l_1_0._loaded_level_package = level_package
        PackageManager:load(level_package)
      end
    end
  end
  if Global.job_manager and Global.job_manager.current_job and Global.job_manager.current_job.job_id then
    local job_tweak_data = tweak_data.narrative.jobs[Global.job_manager.current_job.job_id]
  end
  if (not Global.job_manager or not Global.job_manager.interupt_stage or not "interupt") and job_tweak_data then
    local contact = job_tweak_data.contact
  end
  local contact_tweak_data = tweak_data.narrative.contacts[contact]
  if contact_tweak_data then
    local contact_package = contact_tweak_data.package
  end
  if contact_package and not PackageManager:loaded(contact_package) then
    l_1_0._loaded_contact_package = contact_package
    PackageManager:load(contact_package)
  end
end

GameSetup.unload_packages = function(l_2_0)
  Setup.unload_packages(l_2_0)
  if not Global.load_level and PackageManager:loaded("packages/game_base") then
    PackageManager:unload("packages/game_base")
  end
  if l_2_0._loaded_level_package then
    if type(l_2_0._loaded_level_package) == "table" then
      for _,package in ipairs(l_2_0._loaded_level_package) do
        if PackageManager:loaded(package) then
          PackageManager:unload(package)
        end
      end
    else
      if PackageManager:loaded(l_2_0._loaded_level_package) then
        PackageManager:unload(l_2_0._loaded_level_package)
      end
      l_2_0._loaded_level_package = nil
    end
    if PackageManager:loaded(l_2_0._loaded_contact_package) then
      PackageManager:unload(l_2_0._loaded_contact_package)
      l_2_0._loaded_contact_package = nil
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GameSetup.init_managers = function(l_3_0, l_3_1)
  Setup.init_managers(l_3_0, l_3_1)
  l_3_1.interaction = ObjectInteractionManager:new()
  l_3_1.drama = DramaManager:new()
  l_3_1.dialog = DialogManager:new()
  l_3_1.enemy = EnemyManager:new()
  l_3_1.spawn = SpawnManager:new()
  l_3_1.hud = HUDManager:new()
  l_3_1.navigation = NavigationManager:new()
  l_3_1.objectives = ObjectivesManager:new()
  l_3_1.game_play_central = GamePlayCentralManager:new()
  l_3_1.hint = HintManager:new()
  l_3_1.money = MoneyManager:new()
  l_3_1.challenges = ChallengesManager:new()
  l_3_1.killzone = KillzoneManager:new()
  l_3_1.action_messaging = ActionMessagingManager:new()
  l_3_1.groupai = GroupAIManager:new()
  l_3_1.statistics = StatisticsManager:new()
  l_3_1.ai_data = CoreAiDataManager.AiDataManager:new()
  l_3_1.secret_assignment = SecretAssignmentManager:new()
  l_3_1.occlusion = _OcclusionManager:new()
  l_3_1.criminals = CriminalsManager:new()
  l_3_1.trade = TradeManager:new()
  l_3_1.feedback = FeedBackManager:new()
  l_3_1.time_speed = TimeSpeedManager:new()
  if SystemInfo:platform() == Idstring("X360") then
    l_3_1.blackmarket:load_equipped_weapons()
  end
end

GameSetup.init_game = function(l_4_0)
  local gsm = Setup.init_game(l_4_0)
  if not Application:editor() then
    local engine_package = PackageManager:package("engine-package")
    engine_package:unload_all_temp()
    if not managers.job:current_mission_filter() then
      managers.mission:set_mission_filter({})
    end
    local level = Global.level_data.level
    local mission = Global.level_data.mission
    local world_setting = Global.level_data.world_setting
    local level_class_name = Global.level_data.level_class_name
    if level_class_name then
      local level_class = rawget(_G, level_class_name)
    end
    if level then
      if level_class then
        script_data.level_script = level_class:new()
      end
      local level_path = "levels/" .. tostring(level)
      local t = {file_path = level_path .. "/world", file_type = "world", world_setting = world_setting}
      assert(WorldHolder:new(t):create_world("world", "all", Vector3()), "Cant load the level!")
      local mission_params = {file_path = level_path .. "/mission", activate_mission = mission, stage_name = "stage1"}
      managers.mission:parse(mission_params)
    else
      error("No level loaded! Use -level 'levelname'")
    end
    managers.worlddefinition:init_done()
  end
  return gsm
end

GameSetup.init_finalize = function(l_5_0)
  if script_data.level_script and script_data.level_script.post_init then
    script_data.level_script:post_init()
  end
  if Global.current_load_package then
    PackageManager:unload(Global.current_load_package)
    Global.current_load_package = nil
  end
  Setup.init_finalize(l_5_0)
  managers.hud:init_finalize()
  managers.dialog:init_finalize()
  if not Application:editor() then
    managers.navigation:on_game_started()
  end
  if not Application:editor() then
    game_state_machine:change_state_by_name("ingame_waiting_for_players")
  end
  if SystemInfo:platform() == Idstring("PS3") then
    managers.achievment:chk_install_trophies()
  end
  if managers.music then
    managers.music:init_finalize()
  end
  tweak_data.gui.crime_net.locations = {}
  l_5_0._keyboard = Input:keyboard()
end

GameSetup.update = function(l_6_0, l_6_1, l_6_2)
  Setup.update(l_6_0, l_6_1, l_6_2)
  managers.interaction:update(l_6_1, l_6_2)
  managers.dialog:update(l_6_1, l_6_2)
  managers.enemy:update(l_6_1, l_6_2)
  managers.groupai:update(l_6_1, l_6_2)
  managers.spawn:update(l_6_1, l_6_2)
  managers.navigation:update(l_6_1, l_6_2)
  managers.hud:update(l_6_1, l_6_2)
  managers.killzone:update(l_6_1, l_6_2)
  managers.secret_assignment:update(l_6_1, l_6_2)
  managers.game_play_central:update(l_6_1, l_6_2)
  managers.trade:update(l_6_1, l_6_2)
  managers.statistics:update(l_6_1, l_6_2)
  managers.time_speed:update()
  managers.objectives:update(l_6_1, l_6_2)
  if script_data.level_script and script_data.level_script.update then
    script_data.level_script:update(l_6_1, l_6_2)
  end
  l_6_0:_update_debug_input()
end

GameSetup.paused_update = function(l_7_0, l_7_1, l_7_2)
  Setup.paused_update(l_7_0, l_7_1, l_7_2)
  managers.groupai:paused_update(l_7_1, l_7_2)
  if script_data.level_script and script_data.level_script.paused_update then
    script_data.level_script:paused_update(l_7_1, l_7_2)
  end
  l_7_0:_update_debug_input()
end

GameSetup.destroy = function(l_8_0)
  Setup.destroy(l_8_0)
  if script_data.level_script and script_data.level_script.destroy then
    script_data.level_script:destroy()
  end
  managers.navigation:destroy()
  managers.time_speed:destroy()
end

GameSetup.end_update = function(l_9_0, l_9_1, l_9_2)
  Setup.end_update(l_9_0, l_9_1, l_9_2)
  managers.game_play_central:end_update(l_9_1, l_9_2)
end

GameSetup.save = function(l_10_0, l_10_1)
  Setup.save(l_10_0, l_10_1)
  managers.game_play_central:save(l_10_1)
  managers.hud:save(l_10_1)
  managers.objectives:save(l_10_1)
  managers.music:save(l_10_1)
  managers.environment_effects:save(l_10_1)
  managers.mission:save(l_10_1)
  managers.groupai:state():save(l_10_1)
  managers.player:sync_save(l_10_1)
  managers.trade:save(l_10_1)
  managers.groupai:state():save(l_10_1)
  managers.loot:sync_save(l_10_1)
  managers.enemy:save(l_10_1)
  managers.assets:sync_save(l_10_1)
end

GameSetup.load = function(l_11_0, l_11_1)
  Setup.load(l_11_0, l_11_1)
  managers.game_play_central:load(l_11_1)
  managers.hud:load(l_11_1)
  managers.objectives:load(l_11_1)
  managers.music:load(l_11_1)
  managers.environment_effects:load(l_11_1)
  managers.mission:load(l_11_1)
  managers.groupai:state():load(l_11_1)
  managers.player:sync_load(l_11_1)
  managers.trade:load(l_11_1)
  managers.groupai:state():load(l_11_1)
  managers.loot:sync_load(l_11_1)
  managers.enemy:load(l_11_1)
  managers.assets:sync_load(l_11_1)
end

GameSetup._update_debug_input = function(l_12_0)
  local editor_ok = (Application:editor() and Global.running_simulation)
  if not Global.DEBUG_MENU_ON then
    local debug_on_ok = Application:production_build()
  end
  if not editor_ok or not debug_on_ok then
    return 
  end
  if l_12_0._keyboard:pressed(59) then
    if not Application:paused() or not "UNPAUSING" then
      print("[GameSetup:_update_debug_input]", not l_12_0._keyboard or "PAUSING")
    end
    Application:set_pause(not Application:paused())
  else
    if l_12_0._keyboard:pressed(60) then
      if l_12_0._framerate_low then
        l_12_0._framerate_low = nil
        Application:cap_framerate(managers.user:get_setting("fps_cap"))
      else
        l_12_0._framerate_low = true
        Application:cap_framerate(30)
      end
    end
  end
end

return GameSetup

