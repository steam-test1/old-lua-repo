-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\tweak_data\tweakdata.luac 

require("lib/tweak_data/WeaponTweakData")
require("lib/tweak_data/WeaponUpgradesTweakData")
require("lib/tweak_data/EquipmentsTweakData")
require("lib/tweak_data/CharacterTweakData")
require("lib/tweak_data/PlayerTweakData")
require("lib/tweak_data/StatisticsTweakData")
require("lib/tweak_data/LevelsTweakData")
require("lib/tweak_data/GroupAITweakData")
require("lib/tweak_data/DramaTweakData")
require("lib/tweak_data/SecretAssignmentTweakData")
require("lib/tweak_data/ChallengesTweakData")
require("lib/tweak_data/UpgradesTweakData")
require("lib/tweak_data/UpgradesVisualTweakData")
require("lib/tweak_data/HudIconsTweakData")
require("lib/tweak_data/TipsTweakData")
require("lib/tweak_data/BlackMarketTweakData")
require("lib/tweak_data/CarryTweakData")
require("lib/tweak_data/MissionDoorTweakData")
require("lib/tweak_data/AttentionTweakData")
require("lib/tweak_data/NarrativeTweakData")
require("lib/tweak_data/SkillTreeTweakData")
require("lib/tweak_data/TimeSpeedEffectTweakData")
require("lib/tweak_data/SoundTweakData")
require("lib/tweak_data/LootDropTweakData")
require("lib/tweak_data/GuiTweakData")
require("lib/tweak_data/MoneyTweakData")
require("lib/tweak_data/AssetsTweakData")
require("lib/tweak_data/DLCTweakData")
if not TweakData then
  TweakData = class()
end
require("lib/tweak_data/TweakDataPD2")
TweakData.RELOAD = true
TweakData.digest_tweak_data = function(l_1_0)
  Application:debug("TweakData: Digesting tweak_data. <('O'<)")
  l_1_0:digest_recursive(l_1_0.money_manager)
  l_1_0:digest_recursive(l_1_0.experience_manager)
end

TweakData.digest_recursive = function(l_2_0, l_2_1, l_2_2)
  local value = l_2_2 and l_2_2[l_2_1] or l_2_1
  if type(value) == "table" then
    for index,data in pairs(value) do
      l_2_0:digest_recursive(index, value)
    end
  else
    if type(value) == "number" then
      l_2_2[l_2_1] = Application:digest_value(value, true)
    end
  end
end

TweakData.get_value = function(l_3_0, ...)
  local arg = {...}
  do
    local value = l_3_0
    for _,v in ipairs(arg) do
      if not value[v] then
        return false
      end
      value = value[v]
    end
    if type(value) == "string" then
      return Application:digest_value(value, false)
    else
      if type(value) == "table" then
        Application:debug("TweakData:get_value() value was a table, is this correct? returning false!", inspect(arg), inspect(value))
        return false
      end
    end
    return value
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

TweakData.set_difficulty = function(l_4_0)
  if not Global.game_settings then
    return 
  end
  if Global.game_settings.difficulty == "easy" then
    l_4_0:_set_easy()
  else
    if Global.game_settings.difficulty == "normal" then
      l_4_0:_set_normal()
    else
      if Global.game_settings.difficulty == "overkill" then
        l_4_0:_set_overkill()
      else
        if Global.game_settings.difficulty == "overkill_145" then
          l_4_0:_set_overkill_145(l_4_0)
        else
          l_4_0:_set_hard()
        end
      end
    end
  end
end

TweakData._set_easy = function(l_5_0)
  l_5_0.player:_set_easy()
  l_5_0.character:_set_easy()
  l_5_0.group_ai:_set_easy()
  l_5_0.experience_manager.civilians_killed = 15
  l_5_0.difficulty_name_id = l_5_0.difficulty_name_ids.easy
  l_5_0.experience_manager.total_level_objectives = 1000
  l_5_0.experience_manager.total_criminals_finished = 25
  l_5_0.experience_manager.total_objectives_finished = 750
end

TweakData._set_normal = function(l_6_0)
  l_6_0.player:_set_normal()
  l_6_0.character:_set_normal()
  l_6_0.group_ai:_set_normal()
  l_6_0.experience_manager.civilians_killed = 35
  l_6_0.difficulty_name_id = l_6_0.difficulty_name_ids.normal
  l_6_0.experience_manager.total_level_objectives = 2000
  l_6_0.experience_manager.total_criminals_finished = 50
  l_6_0.experience_manager.total_objectives_finished = 1000
end

TweakData._set_hard = function(l_7_0)
  l_7_0.player:_set_hard()
  l_7_0.character:_set_hard()
  l_7_0.group_ai:_set_hard()
  l_7_0.experience_manager.civilians_killed = 75
  l_7_0.difficulty_name_id = l_7_0.difficulty_name_ids.hard
  l_7_0.experience_manager.total_level_objectives = 2500
  l_7_0.experience_manager.total_criminals_finished = 150
  l_7_0.experience_manager.total_objectives_finished = 1500
end

TweakData._set_overkill = function(l_8_0)
  l_8_0.player:_set_overkill()
  l_8_0.character:_set_overkill()
  l_8_0.group_ai:_set_overkill()
  l_8_0.experience_manager.civilians_killed = 150
  l_8_0.difficulty_name_id = l_8_0.difficulty_name_ids.overkill
  l_8_0.experience_manager.total_level_objectives = 5000
  l_8_0.experience_manager.total_criminals_finished = 500
  l_8_0.experience_manager.total_objectives_finished = 3000
end

TweakData._set_overkill_145 = function(l_9_0)
  l_9_0.player:_set_overkill_145(l_9_0.player)
  l_9_0.character:_set_overkill_145(l_9_0.character)
  l_9_0.group_ai:_set_overkill_145(l_9_0.group_ai)
  l_9_0.experience_manager.civilians_killed = 550
  l_9_0.difficulty_name_id = l_9_0.difficulty_name_ids.overkill_145
  l_9_0.experience_manager.total_level_objectives = 5000
  l_9_0.experience_manager.total_criminals_finished = 2000
  l_9_0.experience_manager.total_objectives_finished = 3000
end

TweakData.difficulty_to_index = function(l_10_0, l_10_1)
  for i,diff in ipairs(l_10_0.difficulties) do
    if diff == l_10_1 then
      return i
    end
  end
end

TweakData.index_to_difficulty = function(l_11_0, l_11_1)
  return l_11_0.difficulties[l_11_1]
end

TweakData.permission_to_index = function(l_12_0, l_12_1)
  for i,perm in ipairs(l_12_0.permissions) do
    if perm == l_12_1 then
      return i
    end
  end
end

TweakData.index_to_permission = function(l_13_0, l_13_1)
  return l_13_0.permissions[l_13_1]
end

TweakData.server_state_to_index = function(l_14_0, l_14_1)
  for i,server_state in ipairs(l_14_0.server_states) do
    if server_state == l_14_1 then
      return i
    end
  end
end

TweakData.index_to_server_state = function(l_15_0, l_15_1)
  return l_15_0.server_states[l_15_1]
end

TweakData.menu_sync_state_to_index = function(l_16_0, l_16_1)
  if not l_16_1 then
    return false
  end
  for i,menu_sync in ipairs(l_16_0.menu_sync_states) do
    if menu_sync == l_16_1 then
      return i
    end
  end
end

TweakData.index_to_menu_sync_state = function(l_17_0, l_17_1)
  return l_17_0.menu_sync_states[l_17_1]
end

TweakData.init = function(l_18_0)
  l_18_0.hud_icons = HudIconsTweakData:new()
  l_18_0.weapon = WeaponTweakData:new()
  l_18_0.weapon_upgrades = WeaponUpgradesTweakData:new()
  l_18_0.equipments = EquipmentsTweakData:new()
  l_18_0.player = PlayerTweakData:new()
  l_18_0.character = CharacterTweakData:new(l_18_0)
  l_18_0.statistics = StatisticsTweakData:new()
  l_18_0.levels = LevelsTweakData:new()
  l_18_0.narrative = NarrativeTweakData:new()
  l_18_0.group_ai = GroupAITweakData:new(l_18_0)
  l_18_0.drama = DramaTweakData:new()
  l_18_0.secret_assignment_manager = SecretAssignmentTweakData:new()
  l_18_0.challenges = ChallengesTweakData:new()
  l_18_0.upgrades = UpgradesTweakData:new()
  l_18_0.skilltree = SkillTreeTweakData:new()
  l_18_0.upgrades.visual = UpgradesVisualTweakData:new()
  l_18_0.tips = TipsTweakData:new()
  l_18_0.money_manager = MoneyTweakData:new()
  l_18_0.blackmarket = BlackMarketTweakData:new(l_18_0)
  l_18_0.carry = CarryTweakData:new(l_18_0)
  l_18_0.mission_door = MissionDoorTweakData:new()
  l_18_0.attention = AttentionTweakData:new()
  l_18_0.timespeed = TimeSpeedEffectTweakData:new()
  l_18_0.sound = SoundTweakData:new()
  l_18_0.lootdrop = LootDropTweakData:new(l_18_0)
  l_18_0.gui = GuiTweakData:new()
  l_18_0.assets = AssetsTweakData:new(l_18_0)
  l_18_0.dlc = DLCTweakData:new(l_18_0)
  l_18_0.EFFECT_QUALITY = 0.5
  if SystemInfo:platform() == Idstring("X360") then
    l_18_0.EFFECT_QUALITY = 0.5
  else
    if SystemInfo:platform() == Idstring("PS3") then
      l_18_0.EFFECT_QUALITY = 0.5
    end
  end
  l_18_0:set_scale()
  l_18_0:_init_pd2(l_18_0)
  l_18_0.difficulties = {"easy", "normal", "hard", "overkill", "overkill_145"}
  l_18_0.permissions = {"public", "friends_only", "private"}
  l_18_0.server_states = {"in_lobby", "loading", "in_game"}
  l_18_0.menu_sync_states = {"crimenet", "skilltree", "options", "lobby", "blackmarket", "blackmarket_weapon", "blackmarket_mask"}
  l_18_0.difficulty_name_ids = {}
  l_18_0.difficulty_name_ids.easy = "menu_difficulty_easy"
  l_18_0.difficulty_name_ids.normal = "menu_difficulty_normal"
  l_18_0.difficulty_name_ids.hard = "menu_difficulty_hard"
  l_18_0.difficulty_name_ids.overkill = "menu_difficulty_very_hard"
  l_18_0.difficulty_name_ids.overkill_145 = "menu_difficulty_overkill"
  {bg_startscreen = "guis/textures/menu/old_theme/bg_startscreen", bg_dlc = "guis/textures/menu/old_theme/bg_dlc", bg_setupgame = "guis/textures/menu/old_theme/bg_setupgame", bg_creategame = "guis/textures/menu/old_theme/bg_creategame"}.bg_challenge = "guis/textures/menu/old_theme/bg_challenge"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/old_theme/bg_startscreen", bg_dlc = "guis/textures/menu/old_theme/bg_dlc", bg_setupgame = "guis/textures/menu/old_theme/bg_setupgame", bg_creategame = "guis/textures/menu/old_theme/bg_creategame"}.bg_upgrades = "guis/textures/menu/old_theme/bg_upgrades"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/old_theme/bg_startscreen", bg_dlc = "guis/textures/menu/old_theme/bg_dlc", bg_setupgame = "guis/textures/menu/old_theme/bg_setupgame", bg_creategame = "guis/textures/menu/old_theme/bg_creategame"}.bg_stats = "guis/textures/menu/old_theme/bg_stats"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/old_theme/bg_startscreen", bg_dlc = "guis/textures/menu/old_theme/bg_dlc", bg_setupgame = "guis/textures/menu/old_theme/bg_setupgame", bg_creategame = "guis/textures/menu/old_theme/bg_creategame"}.bg_options = "guis/textures/menu/old_theme/bg_options"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/old_theme/bg_startscreen", bg_dlc = "guis/textures/menu/old_theme/bg_dlc", bg_setupgame = "guis/textures/menu/old_theme/bg_setupgame", bg_creategame = "guis/textures/menu/old_theme/bg_creategame"}.bg_assault = "guis/textures/menu/old_theme/bg_assault"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/old_theme/bg_startscreen", bg_dlc = "guis/textures/menu/old_theme/bg_dlc", bg_setupgame = "guis/textures/menu/old_theme/bg_setupgame", bg_creategame = "guis/textures/menu/old_theme/bg_creategame"}.bg_sharpshooter = "guis/textures/menu/old_theme/bg_sharpshooter"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/old_theme/bg_startscreen", bg_dlc = "guis/textures/menu/old_theme/bg_dlc", bg_setupgame = "guis/textures/menu/old_theme/bg_setupgame", bg_creategame = "guis/textures/menu/old_theme/bg_creategame"}.bg_support = "guis/textures/menu/old_theme/bg_support"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/old_theme/bg_startscreen", bg_dlc = "guis/textures/menu/old_theme/bg_dlc", bg_setupgame = "guis/textures/menu/old_theme/bg_setupgame", bg_creategame = "guis/textures/menu/old_theme/bg_creategame"}.bg_technician = "guis/textures/menu/old_theme/bg_technician"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/old_theme/bg_startscreen", bg_dlc = "guis/textures/menu/old_theme/bg_dlc", bg_setupgame = "guis/textures/menu/old_theme/bg_setupgame", bg_creategame = "guis/textures/menu/old_theme/bg_creategame"}.bg_lobby_fullteam = "guis/textures/menu/old_theme/bg_lobby_fullteam"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/old_theme/bg_startscreen", bg_dlc = "guis/textures/menu/old_theme/bg_dlc", bg_setupgame = "guis/textures/menu/old_theme/bg_setupgame", bg_creategame = "guis/textures/menu/old_theme/bg_creategame"}.bg_hoxton = "guis/textures/menu/old_theme/bg_hoxton"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/old_theme/bg_startscreen", bg_dlc = "guis/textures/menu/old_theme/bg_dlc", bg_setupgame = "guis/textures/menu/old_theme/bg_setupgame", bg_creategame = "guis/textures/menu/old_theme/bg_creategame"}.bg_wolf = "guis/textures/menu/old_theme/bg_wolf"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/old_theme/bg_startscreen", bg_dlc = "guis/textures/menu/old_theme/bg_dlc", bg_setupgame = "guis/textures/menu/old_theme/bg_setupgame", bg_creategame = "guis/textures/menu/old_theme/bg_creategame"}.bg_dallas = "guis/textures/menu/old_theme/bg_dallas"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/old_theme/bg_startscreen", bg_dlc = "guis/textures/menu/old_theme/bg_dlc", bg_setupgame = "guis/textures/menu/old_theme/bg_setupgame", bg_creategame = "guis/textures/menu/old_theme/bg_creategame"}.bg_chains = "guis/textures/menu/old_theme/bg_chains"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/old_theme/bg_startscreen", bg_dlc = "guis/textures/menu/old_theme/bg_dlc", bg_setupgame = "guis/textures/menu/old_theme/bg_setupgame", bg_creategame = "guis/textures/menu/old_theme/bg_creategame"}.background = "guis/textures/menu/old_theme/background"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/fire_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/fire_theme/bg_setupgame", bg_creategame = "guis/textures/menu/fire_theme/bg_creategame"}.bg_challenge = "guis/textures/menu/fire_theme/bg_challenge"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/fire_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/fire_theme/bg_setupgame", bg_creategame = "guis/textures/menu/fire_theme/bg_creategame"}.bg_upgrades = "guis/textures/menu/fire_theme/bg_upgrades"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/fire_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/fire_theme/bg_setupgame", bg_creategame = "guis/textures/menu/fire_theme/bg_creategame"}.bg_stats = "guis/textures/menu/fire_theme/bg_stats"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/fire_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/fire_theme/bg_setupgame", bg_creategame = "guis/textures/menu/fire_theme/bg_creategame"}.bg_options = "guis/textures/menu/fire_theme/bg_options"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/fire_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/fire_theme/bg_setupgame", bg_creategame = "guis/textures/menu/fire_theme/bg_creategame"}.bg_assault = "guis/textures/menu/fire_theme/bg_assault"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/fire_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/fire_theme/bg_setupgame", bg_creategame = "guis/textures/menu/fire_theme/bg_creategame"}.bg_sharpshooter = "guis/textures/menu/fire_theme/bg_sharpshooter"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/fire_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/fire_theme/bg_setupgame", bg_creategame = "guis/textures/menu/fire_theme/bg_creategame"}.bg_support = "guis/textures/menu/fire_theme/bg_support"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/fire_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/fire_theme/bg_setupgame", bg_creategame = "guis/textures/menu/fire_theme/bg_creategame"}.bg_technician = "guis/textures/menu/fire_theme/bg_technician"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/fire_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/fire_theme/bg_setupgame", bg_creategame = "guis/textures/menu/fire_theme/bg_creategame"}.bg_lobby_fullteam = "guis/textures/menu/fire_theme/bg_lobby_fullteam"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/fire_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/fire_theme/bg_setupgame", bg_creategame = "guis/textures/menu/fire_theme/bg_creategame"}.bg_hoxton = "guis/textures/menu/fire_theme/bg_hoxton"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/fire_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/fire_theme/bg_setupgame", bg_creategame = "guis/textures/menu/fire_theme/bg_creategame"}.bg_wolf = "guis/textures/menu/fire_theme/bg_wolf"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/fire_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/fire_theme/bg_setupgame", bg_creategame = "guis/textures/menu/fire_theme/bg_creategame"}.bg_dallas = "guis/textures/menu/fire_theme/bg_dallas"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/fire_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/fire_theme/bg_setupgame", bg_creategame = "guis/textures/menu/fire_theme/bg_creategame"}.bg_chains = "guis/textures/menu/fire_theme/bg_chains"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/fire_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/fire_theme/bg_setupgame", bg_creategame = "guis/textures/menu/fire_theme/bg_creategame"}.background = "guis/textures/menu/fire_theme/background"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/zombie_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/zombie_theme/bg_setupgame", bg_creategame = "guis/textures/menu/zombie_theme/bg_creategame"}.bg_challenge = "guis/textures/menu/zombie_theme/bg_challenge"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/zombie_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/zombie_theme/bg_setupgame", bg_creategame = "guis/textures/menu/zombie_theme/bg_creategame"}.bg_upgrades = "guis/textures/menu/zombie_theme/bg_upgrades"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/zombie_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/zombie_theme/bg_setupgame", bg_creategame = "guis/textures/menu/zombie_theme/bg_creategame"}.bg_stats = "guis/textures/menu/zombie_theme/bg_stats"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/zombie_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/zombie_theme/bg_setupgame", bg_creategame = "guis/textures/menu/zombie_theme/bg_creategame"}.bg_options = "guis/textures/menu/zombie_theme/bg_options"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/zombie_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/zombie_theme/bg_setupgame", bg_creategame = "guis/textures/menu/zombie_theme/bg_creategame"}.bg_assault = "guis/textures/menu/zombie_theme/bg_assault"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/zombie_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/zombie_theme/bg_setupgame", bg_creategame = "guis/textures/menu/zombie_theme/bg_creategame"}.bg_sharpshooter = "guis/textures/menu/zombie_theme/bg_sharpshooter"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/zombie_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/zombie_theme/bg_setupgame", bg_creategame = "guis/textures/menu/zombie_theme/bg_creategame"}.bg_support = "guis/textures/menu/zombie_theme/bg_support"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/zombie_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/zombie_theme/bg_setupgame", bg_creategame = "guis/textures/menu/zombie_theme/bg_creategame"}.bg_technician = "guis/textures/menu/zombie_theme/bg_technician"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/zombie_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/zombie_theme/bg_setupgame", bg_creategame = "guis/textures/menu/zombie_theme/bg_creategame"}.bg_lobby_fullteam = "guis/textures/menu/zombie_theme/bg_lobby_fullteam"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/zombie_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/zombie_theme/bg_setupgame", bg_creategame = "guis/textures/menu/zombie_theme/bg_creategame"}.bg_hoxton = "guis/textures/menu/zombie_theme/bg_hoxton"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/zombie_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/zombie_theme/bg_setupgame", bg_creategame = "guis/textures/menu/zombie_theme/bg_creategame"}.bg_wolf = "guis/textures/menu/zombie_theme/bg_wolf"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/zombie_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/zombie_theme/bg_setupgame", bg_creategame = "guis/textures/menu/zombie_theme/bg_creategame"}.bg_dallas = "guis/textures/menu/zombie_theme/bg_dallas"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/zombie_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/zombie_theme/bg_setupgame", bg_creategame = "guis/textures/menu/zombie_theme/bg_creategame"}.bg_chains = "guis/textures/menu/zombie_theme/bg_chains"
   -- DECOMPILER ERROR: Confused about usage of registers!

  {bg_startscreen = "guis/textures/menu/zombie_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/zombie_theme/bg_setupgame", bg_creategame = "guis/textures/menu/zombie_theme/bg_creategame"}.background = "guis/textures/menu/zombie_theme/background"
   -- DECOMPILER ERROR: Confused about usage of registers!

  l_18_0.menu_themes = {old = {bg_startscreen = "guis/textures/menu/old_theme/bg_startscreen", bg_dlc = "guis/textures/menu/old_theme/bg_dlc", bg_setupgame = "guis/textures/menu/old_theme/bg_setupgame", bg_creategame = "guis/textures/menu/old_theme/bg_creategame"}, fire = {bg_startscreen = "guis/textures/menu/fire_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/fire_theme/bg_setupgame", bg_creategame = "guis/textures/menu/fire_theme/bg_creategame"}, zombie = {bg_startscreen = "guis/textures/menu/zombie_theme/bg_startscreen", bg_dlc = "guis/textures/menu/fire_theme/bg_dlc", bg_setupgame = "guis/textures/menu/zombie_theme/bg_setupgame", bg_creategame = "guis/textures/menu/zombie_theme/bg_creategame"}}
  l_18_0.states = {}
  l_18_0.states.title = {}
  l_18_0.states.title.ATTRACT_VIDEO_DELAY = 90
  l_18_0.menu = {}
  l_18_0.menu.BRIGHTNESS_CHANGE = 0.050000000745058
  l_18_0.menu.MIN_BRIGHTNESS = 0.5
  l_18_0.menu.MAX_BRIGHTNESS = 1.5
  l_18_0.menu.MUSIC_CHANGE = 10
  l_18_0.menu.MIN_MUSIC_VOLUME = 0
  l_18_0.menu.MAX_MUSIC_VOLUME = 100
  l_18_0.menu.SFX_CHANGE = 10
  l_18_0.menu.MIN_SFX_VOLUME = 0
  l_18_0.menu.MAX_SFX_VOLUME = 100
  l_18_0.menu.VOICE_CHANGE = 0.050000000745058
  l_18_0.menu.MIN_VOICE_VOLUME = 0
  l_18_0.menu.MAX_VOICE_VOLUME = 1
  l_18_0:set_menu_scale()
  local orange = Vector3(204, 161, 102) / 255
  local green = Vector3(194, 252, 151) / 255
  local brown = Vector3(178, 104, 89) / 255
  local blue = Vector3(120, 183, 204) / 255
  local team_ai = Vector3(0.20000000298023, 0.80000001192093, 1)
  l_18_0.peer_vector_colors = {green, blue, brown, orange, team_ai}
  l_18_0.peer_colors = {"mrgreen", "mrblue", "mrbrown", "mrorange", "mrai"}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  l_18_0.screen_colors.text, l_18_0.screen_colors, l_18_0.chat_colors = Color(l_18_0.peer_vector_colors[1]:unpack())(Color(l_18_0.peer_vector_colors[2]:unpack()), Color(l_18_0.peer_vector_colors[3]:unpack()), Color(l_18_0.peer_vector_colors[4]:unpack()), Color(l_18_0.peer_vector_colors[5]:unpack())) / 255, {}, {}
  l_18_0.screen_colors.resource = Color(255, 77, 198, 255) / 255
  l_18_0.screen_colors.important_1 = Color(255, 255, 51, 51) / 255
  l_18_0.screen_colors.important_2 = Color(125, 255, 51, 51) / 255
  l_18_0.screen_colors.item_stage_1 = Color(255, 255, 255, 255) / 255
  l_18_0.screen_colors.item_stage_2 = Color(255, 89, 115, 128) / 255
  l_18_0.screen_colors.item_stage_3 = Color(255, 23, 33, 38) / 255
  l_18_0.screen_colors.button_stage_1 = Color(255, 0, 0, 0) / 255
  l_18_0.screen_colors.button_stage_2 = Color(255, 77, 198, 255) / 255
  l_18_0.screen_colors.button_stage_3 = Color(127, 0, 170, 255) / 255
  l_18_0.screen_colors.crimenet_lines = Color(255, 127, 157, 182) / 255
  l_18_0.screen_colors.risk = Color(255, 255, 204, 0) / 255
  l_18_0.screen_colors.friend_color = Color(255, 41, 204, 122) / 255
  l_18_0.screen_colors.regular_color = Color(255, 41, 150, 240) / 255
  l_18_0.screen_colors.pro_color = Color(255, 255, 51, 51) / 255
  if Global.old_colors_purple then
    l_18_0.screen_color_white = Color.purple
    l_18_0.screen_color_red = Color.purple
    l_18_0.screen_color_green = Color.purple
    l_18_0.screen_color_grey = Color.purple
    l_18_0.screen_color_light_grey = Color.purple
    l_18_0.screen_color_blue = Color.purple
    l_18_0.screen_color_blue_selected = Color.purple
    l_18_0.screen_color_blue_highlighted = Color.purple
    l_18_0.screen_color_blue_noselected = Color.purple
    l_18_0.screen_color_yellow = Color.purple
    l_18_0.screen_color_yellow_selected = Color.purple
    l_18_0.screen_color_yellow_noselected = Color.purple
  else
    l_18_0.screen_color_white = Color(1, 1, 1)
    l_18_0.screen_color_red = Color(0.71372550725937, 0.24705882370472, 0.21176470816135)
    l_18_0.screen_color_green = Color(0.12549020349979, 1, 0.51764708757401)
    l_18_0.screen_color_grey = Color(0.39215686917305, 0.39215686917305, 0.39215686917305)
    l_18_0.screen_color_light_grey = Color(0.7843137383461, 0.7843137383461, 0.7843137383461)
    l_18_0.screen_color_blue = Color(0.30196079611778, 0.77647060155869, 1)
    l_18_0.screen_color_blue_selected = Color(0.30196079611778, 0.77647060155869, 1)
    l_18_0.screen_color_blue_highlighted = l_18_0.screen_color_blue_selected:with_alpha(0.75)
    l_18_0.screen_color_blue_noselected = l_18_0.screen_color_blue_selected:with_alpha(0.5)
    l_18_0.screen_color_yellow = Color(0.86274510622025, 0.6745098233223, 0.17647059261799)
    l_18_0.screen_color_yellow_selected = Color(1, 0.80000001192093, 0)
    l_18_0.screen_color_yellow_noselected = Color(0.73333334922791, 0.42745098471642, 0.078431375324726)
  end
  l_18_0.dialog = {}
  l_18_0.dialog.WIDTH = 400
  l_18_0.dialog.HEIGHT = 300
  l_18_0.dialog.PADDING = 30
  l_18_0.dialog.BUTTON_PADDING = 5
  l_18_0.dialog.BUTTON_SPACING = 10
  l_18_0.dialog.FONT = l_18_0.menu.default_font
  l_18_0.dialog.BG_COLOR = l_18_0.menu.default_menu_background_color
  l_18_0.dialog.TITLE_TEXT_COLOR = Color(1, 1, 1, 1)
  l_18_0.dialog.TEXT_COLOR = l_18_0.menu.default_font_row_item_color
  l_18_0.dialog.BUTTON_BG_COLOR = Color(0, 0.5, 0.5, 0.5)
  l_18_0.dialog.BUTTON_TEXT_COLOR = l_18_0.menu.default_font_row_item_color
  l_18_0.dialog.SELECTED_BUTTON_BG_COLOR = l_18_0.menu.default_font_row_item_color
  l_18_0.dialog.SELECTED_BUTTON_TEXT_COLOR = l_18_0.menu.default_hightlight_row_item_color
  l_18_0.dialog.TITLE_SIZE = l_18_0.menu.topic_font_size
  l_18_0.dialog.TEXT_SIZE = l_18_0.menu.dialog_text_font_size
  l_18_0.dialog.BUTTON_SIZE = l_18_0.menu.dialog_title_font_size
  l_18_0.dialog.TITLE_TEXT_SPACING = 20
  l_18_0.dialog.BUTTON_TEXT_SPACING = 3
  l_18_0.dialog.DEFAULT_PRIORITY = 1
  l_18_0.dialog.MINIMUM_DURATION = 2
  l_18_0.dialog.DURATION_PER_CHAR = 0.070000000298023
  l_18_0.hud = {}
  l_18_0:set_hud_values()
  l_18_0.interaction = {}
  l_18_0.interaction.CULLING_DISTANCE = 2000
  l_18_0.interaction.INTERACT_DISTANCE = 200
  l_18_0.interaction.copy_machine_smuggle = {}
  l_18_0.interaction.copy_machine_smuggle.icon = "equipment_thermite"
  l_18_0.interaction.copy_machine_smuggle.text_id = "debug_interact_copy_machine"
  l_18_0.interaction.copy_machine_smuggle.interact_distance = 305
  l_18_0.interaction.safety_deposit = {}
  l_18_0.interaction.safety_deposit.icon = "develop"
  l_18_0.interaction.safety_deposit.text_id = "debug_interact_safety_deposit"
  l_18_0.interaction.paper_pickup = {}
  l_18_0.interaction.paper_pickup.icon = "develop"
  l_18_0.interaction.paper_pickup.text_id = "debug_interact_paper_pickup"
  l_18_0.interaction.thermite = {}
  l_18_0.interaction.thermite.icon = "equipment_thermite"
  l_18_0.interaction.thermite.text_id = "debug_interact_thermite"
  l_18_0.interaction.thermite.equipment_text_id = "debug_interact_equipment_thermite"
  l_18_0.interaction.thermite.special_equipment = "thermite"
  l_18_0.interaction.thermite.equipment_consume = true
  l_18_0.interaction.thermite.interact_distance = 300
  l_18_0.interaction.gasoline = {}
  l_18_0.interaction.gasoline.icon = "equipment_thermite"
  l_18_0.interaction.gasoline.text_id = "debug_interact_gas"
  l_18_0.interaction.gasoline.equipment_text_id = "debug_interact_equipment_gas"
  l_18_0.interaction.gasoline.special_equipment = "gas"
  l_18_0.interaction.gasoline.equipment_consume = true
  l_18_0.interaction.gasoline.interact_distance = 300
  l_18_0.interaction.train_car = {}
  l_18_0.interaction.train_car.icon = "develop"
  l_18_0.interaction.train_car.text_id = "debug_interact_train_car"
  l_18_0.interaction.train_car.equipment_text_id = "debug_interact_equipment_gas"
  l_18_0.interaction.train_car.special_equipment = "gas"
  l_18_0.interaction.train_car.equipment_consume = true
  l_18_0.interaction.train_car.interact_distance = 400
  l_18_0.interaction.walkout_van = {}
  l_18_0.interaction.walkout_van.icon = "develop"
  l_18_0.interaction.walkout_van.text_id = "debug_interact_walkout_van"
  l_18_0.interaction.walkout_van.equipment_text_id = "debug_interact_equipment_gold"
  l_18_0.interaction.walkout_van.special_equipment = "gold"
  l_18_0.interaction.walkout_van.equipment_consume = true
  l_18_0.interaction.walkout_van.interact_distance = 400
  l_18_0.interaction.alaska_plane = {}
  l_18_0.interaction.alaska_plane.icon = "develop"
  l_18_0.interaction.alaska_plane.text_id = "debug_interact_alaska_plane"
  l_18_0.interaction.alaska_plane.equipment_text_id = "debug_interact_equipment_organs"
  l_18_0.interaction.alaska_plane.special_equipment = "organs"
  l_18_0.interaction.alaska_plane.equipment_consume = true
  l_18_0.interaction.alaska_plane.interact_distance = 400
  l_18_0.interaction.suburbia_door_crowbar = {}
  l_18_0.interaction.suburbia_door_crowbar.icon = "equipment_crowbar"
  l_18_0.interaction.suburbia_door_crowbar.text_id = "debug_interact_crowbar"
  l_18_0.interaction.suburbia_door_crowbar.equipment_text_id = "debug_interact_equipment_crowbar"
  l_18_0.interaction.suburbia_door_crowbar.special_equipment = "crowbar"
  l_18_0.interaction.suburbia_door_crowbar.timer = 5
  l_18_0.interaction.suburbia_door_crowbar.start_active = false
  l_18_0.interaction.suburbia_door_crowbar.sound_start = "crowbar_work_loop"
  l_18_0.interaction.suburbia_door_crowbar.sound_interupt = "crowbar_cancel"
  l_18_0.interaction.suburbia_door_crowbar.sound_done = "crowbar_work_finished"
  l_18_0.interaction.suburbia_door_crowbar.interact_distance = 130
  l_18_0.interaction.secret_stash_trunk_crowbar = {}
  l_18_0.interaction.secret_stash_trunk_crowbar.icon = "equipment_crowbar"
  l_18_0.interaction.secret_stash_trunk_crowbar.text_id = "debug_interact_crowbar2"
  l_18_0.interaction.secret_stash_trunk_crowbar.equipment_text_id = "debug_interact_equipment_crowbar"
  l_18_0.interaction.secret_stash_trunk_crowbar.special_equipment = "crowbar"
  l_18_0.interaction.secret_stash_trunk_crowbar.timer = 20
  l_18_0.interaction.secret_stash_trunk_crowbar.start_active = false
  l_18_0.interaction.secret_stash_trunk_crowbar.sound_start = "und_crowbar_trunk"
  l_18_0.interaction.secret_stash_trunk_crowbar.sound_interupt = "und_crowbar_trunk_cancel"
  l_18_0.interaction.secret_stash_trunk_crowbar.sound_done = "und_crowbar_trunk_finished"
  l_18_0.interaction.requires_crowbar_interactive_template = {}
  l_18_0.interaction.requires_crowbar_interactive_template.icon = "equipment_crowbar"
  l_18_0.interaction.requires_crowbar_interactive_template.text_id = "debug_interact_crowbar_breach"
  l_18_0.interaction.requires_crowbar_interactive_template.equipment_text_id = "debug_interact_equipment_crowbar"
  l_18_0.interaction.requires_crowbar_interactive_template.special_equipment = "crowbar"
  l_18_0.interaction.requires_crowbar_interactive_template.timer = 8
  l_18_0.interaction.requires_crowbar_interactive_template.start_active = false
  l_18_0.interaction.requires_crowbar_interactive_template.sound_start = "crowbar_metal_work_loop"
  l_18_0.interaction.requires_crowbar_interactive_template.sound_interupt = "crowbar_metal_cancel"
  l_18_0.interaction.requires_crowbar_interactive_template.sound_done = "crowbar_metal_cancel"
  l_18_0.interaction.requires_saw_blade = {}
  l_18_0.interaction.requires_saw_blade.icon = "develop"
  l_18_0.interaction.requires_saw_blade.text_id = "hud_int_hold_add_blade"
  l_18_0.interaction.requires_saw_blade.equipment_text_id = "hud_equipment_no_saw_blade"
  l_18_0.interaction.requires_saw_blade.special_equipment = "saw_blade"
  l_18_0.interaction.requires_saw_blade.timer = 2
  l_18_0.interaction.requires_saw_blade.start_active = false
  l_18_0.interaction.requires_saw_blade.equipment_consume = true
  l_18_0.interaction.saw_blade = {}
  l_18_0.interaction.saw_blade.text_id = "hud_int_hold_take_blade"
  l_18_0.interaction.saw_blade.action_text_id = "hud_action_taking_saw_blade"
  l_18_0.interaction.saw_blade.timer = 0.5
  l_18_0.interaction.saw_blade.start_active = false
  l_18_0.interaction.saw_blade.special_equipment_block = "saw_blade"
  l_18_0.interaction.open_slash_close_sec_box = {}
  l_18_0.interaction.open_slash_close_sec_box.text_id = "hud_int_hold_open_slash_close_sec_box"
  l_18_0.interaction.open_slash_close_sec_box.action_text_id = "hud_action_opening_slash_closing_sec_box"
  l_18_0.interaction.open_slash_close_sec_box.timer = 0.5
  l_18_0.interaction.open_slash_close_sec_box.start_active = false
  l_18_0.interaction.activate_camera = {}
  l_18_0.interaction.activate_camera.text_id = "hud_int_hold_activate_camera"
  l_18_0.interaction.activate_camera.action_text_id = "hud_action_activating_camera"
  l_18_0.interaction.activate_camera.timer = 0.5
  l_18_0.interaction.activate_camera.start_active = false
  l_18_0.interaction.requires_ecm_jammer = {}
  l_18_0.interaction.requires_ecm_jammer.icon = "equipment_ecm_jammer"
  l_18_0.interaction.requires_ecm_jammer.contour = "interactable_icon"
  l_18_0.interaction.requires_ecm_jammer.text_id = "hud_int_use_ecm_jammer"
  l_18_0.interaction.requires_ecm_jammer.required_deployable = "ecm_jammer"
  l_18_0.interaction.requires_ecm_jammer.deployable_consume = true
  l_18_0.interaction.requires_ecm_jammer.timer = 4
  l_18_0.interaction.requires_ecm_jammer.sound_start = "bar_c4_apply"
  l_18_0.interaction.requires_ecm_jammer.sound_interupt = "bar_c4_apply_cancel"
  l_18_0.interaction.requires_ecm_jammer.sound_done = "bar_c4_apply_finished"
  l_18_0.interaction.requires_ecm_jammer.axis = "y"
  l_18_0.interaction.requires_ecm_jammer.action_text_id = "hud_action_placing_ecm_jammer"
  l_18_0.interaction.requires_ecm_jammer.requires_upgrade = {category = "ecm_jammer", upgrade = "can_open_sec_doors"}
  l_18_0.interaction.weapon_cache_drop_zone = {}
  l_18_0.interaction.weapon_cache_drop_zone.icon = "equipment_vial"
  l_18_0.interaction.weapon_cache_drop_zone.text_id = "debug_interact_hospital_veil_container"
  l_18_0.interaction.weapon_cache_drop_zone.equipment_text_id = "debug_interact_equipment_blood_sample_verified"
  l_18_0.interaction.weapon_cache_drop_zone.special_equipment = "blood_sample"
  l_18_0.interaction.weapon_cache_drop_zone.equipment_consume = true
  l_18_0.interaction.weapon_cache_drop_zone.start_active = false
  l_18_0.interaction.weapon_cache_drop_zone.timer = 2
  l_18_0.interaction.secret_stash_limo_roof_crowbar = {}
  l_18_0.interaction.secret_stash_limo_roof_crowbar.icon = "develop"
  l_18_0.interaction.secret_stash_limo_roof_crowbar.text_id = "debug_interact_hold_to_breach"
  l_18_0.interaction.secret_stash_limo_roof_crowbar.timer = 5
  l_18_0.interaction.secret_stash_limo_roof_crowbar.start_active = false
  l_18_0.interaction.secret_stash_limo_roof_crowbar.sound_start = "und_limo_chassis_open"
  l_18_0.interaction.secret_stash_limo_roof_crowbar.sound_interupt = "und_limo_chassis_open_stop"
  l_18_0.interaction.secret_stash_limo_roof_crowbar.sound_done = "und_limo_chassis_open_stop"
  l_18_0.interaction.secret_stash_limo_roof_crowbar.axis = "y"
  l_18_0.interaction.suburbia_iron_gate_crowbar = {}
  l_18_0.interaction.suburbia_iron_gate_crowbar.icon = "equipment_crowbar"
  l_18_0.interaction.suburbia_iron_gate_crowbar.text_id = "debug_interact_crowbar"
  l_18_0.interaction.suburbia_iron_gate_crowbar.equipment_text_id = "debug_interact_equipment_crowbar"
  l_18_0.interaction.suburbia_iron_gate_crowbar.special_equipment = "crowbar"
  l_18_0.interaction.suburbia_iron_gate_crowbar.timer = 5
  l_18_0.interaction.suburbia_iron_gate_crowbar.start_active = false
  l_18_0.interaction.suburbia_iron_gate_crowbar.sound_start = "crowbar_metal_work_loop"
  l_18_0.interaction.suburbia_iron_gate_crowbar.sound_interupt = "crowbar_metal_cancel"
  l_18_0.interaction.apartment_key = {}
  l_18_0.interaction.apartment_key.icon = "equipment_chavez_key"
  l_18_0.interaction.apartment_key.text_id = "debug_interact_apartment_key"
  l_18_0.interaction.apartment_key.equipment_text_id = "debug_interact_equiptment_apartment_key"
  l_18_0.interaction.apartment_key.special_equipment = "chavez_key"
  l_18_0.interaction.apartment_key.equipment_consume = true
  l_18_0.interaction.apartment_key.interact_distance = 150
  l_18_0.interaction.hospital_sample_validation_machine = {}
  l_18_0.interaction.hospital_sample_validation_machine.icon = "equipment_vial"
  l_18_0.interaction.hospital_sample_validation_machine.text_id = "debug_interact_sample_validation"
  l_18_0.interaction.hospital_sample_validation_machine.equipment_text_id = "debug_interact_equiptment_sample_validation"
  l_18_0.interaction.hospital_sample_validation_machine.special_equipment = "blood_sample"
  l_18_0.interaction.hospital_sample_validation_machine.equipment_consume = true
  l_18_0.interaction.hospital_sample_validation_machine.start_active = false
  l_18_0.interaction.hospital_sample_validation_machine.interact_distance = 150
  l_18_0.interaction.hospital_sample_validation_machine.axis = "y"
  l_18_0.interaction.methlab_bubbling = {}
  l_18_0.interaction.methlab_bubbling.icon = "develop"
  l_18_0.interaction.methlab_bubbling.text_id = "hud_int_methlab_bubbling"
  l_18_0.interaction.methlab_bubbling.equipment_text_id = "hud_int_no_acid"
  l_18_0.interaction.methlab_bubbling.special_equipment = "acid"
  l_18_0.interaction.methlab_bubbling.equipment_consume = true
  l_18_0.interaction.methlab_bubbling.start_active = false
  l_18_0.interaction.methlab_bubbling.timer = 1
  l_18_0.interaction.methlab_bubbling.action_text_id = "hud_action_methlab_bubbling"
  l_18_0.interaction.methlab_bubbling.sound_start = "liquid_pour"
  l_18_0.interaction.methlab_bubbling.sound_interupt = "liquid_pour_stop"
  l_18_0.interaction.methlab_bubbling.sound_done = "liquid_pour_stop"
  l_18_0.interaction.methlab_caustic_cooler = {}
  l_18_0.interaction.methlab_caustic_cooler.icon = "develop"
  l_18_0.interaction.methlab_caustic_cooler.text_id = "hud_int_methlab_caustic_cooler"
  l_18_0.interaction.methlab_caustic_cooler.equipment_text_id = "hud_int_no_caustic_soda"
  l_18_0.interaction.methlab_caustic_cooler.special_equipment = "caustic_soda"
  l_18_0.interaction.methlab_caustic_cooler.equipment_consume = true
  l_18_0.interaction.methlab_caustic_cooler.start_active = false
  l_18_0.interaction.methlab_caustic_cooler.timer = 1
  l_18_0.interaction.methlab_caustic_cooler.action_text_id = "hud_action_methlab_caustic_cooler"
  l_18_0.interaction.methlab_caustic_cooler.sound_start = "liquid_pour"
  l_18_0.interaction.methlab_caustic_cooler.sound_interupt = "liquid_pour_stop"
  l_18_0.interaction.methlab_caustic_cooler.sound_done = "liquid_pour_stop"
  l_18_0.interaction.methlab_gas_to_salt = {}
  l_18_0.interaction.methlab_gas_to_salt.icon = "develop"
  l_18_0.interaction.methlab_gas_to_salt.text_id = "hud_int_methlab_gas_to_salt"
  l_18_0.interaction.methlab_gas_to_salt.equipment_text_id = "hud_int_no_hydrogen_chloride"
  l_18_0.interaction.methlab_gas_to_salt.special_equipment = "hydrogen_chloride"
  l_18_0.interaction.methlab_gas_to_salt.equipment_consume = true
  l_18_0.interaction.methlab_gas_to_salt.start_active = false
  l_18_0.interaction.methlab_gas_to_salt.timer = 1
  l_18_0.interaction.methlab_gas_to_salt.action_text_id = "hud_action_methlab_gas_to_salt"
  l_18_0.interaction.methlab_gas_to_salt.sound_start = "bar_bag_generic"
  l_18_0.interaction.methlab_gas_to_salt.sound_interupt = "bar_bag_generic_cancel"
  l_18_0.interaction.methlab_gas_to_salt.sound_done = "bar_bag_generic_finished"
  l_18_0.interaction.methlab_drying_meth = {}
  l_18_0.interaction.methlab_drying_meth.icon = "develop"
  l_18_0.interaction.methlab_drying_meth.text_id = "hud_int_methlab_drying_meth"
  l_18_0.interaction.methlab_drying_meth.equipment_text_id = "hud_int_no_liquid_meth"
  l_18_0.interaction.methlab_drying_meth.special_equipment = "liquid_meth"
  l_18_0.interaction.methlab_drying_meth.equipment_consume = true
  l_18_0.interaction.methlab_drying_meth.start_active = false
  l_18_0.interaction.methlab_drying_meth.timer = 1
  l_18_0.interaction.methlab_drying_meth.action_text_id = "hud_action_methlab_drying_meth"
  l_18_0.interaction.methlab_drying_meth.sound_start = "liquid_pour"
  l_18_0.interaction.methlab_drying_meth.sound_interupt = "liquid_pour_stop"
  l_18_0.interaction.methlab_drying_meth.sound_done = "liquid_pour_stop"
  l_18_0.interaction.muriatic_acid = {}
  l_18_0.interaction.muriatic_acid.icon = "develop"
  l_18_0.interaction.muriatic_acid.text_id = "hud_int_take_acid"
  l_18_0.interaction.muriatic_acid.start_active = false
  l_18_0.interaction.muriatic_acid.interact_distance = 225
  l_18_0.interaction.muriatic_acid.special_equipment_block = "acid"
  l_18_0.interaction.caustic_soda = {}
  l_18_0.interaction.caustic_soda.icon = "develop"
  l_18_0.interaction.caustic_soda.text_id = "hud_int_take_caustic_soda"
  l_18_0.interaction.caustic_soda.start_active = false
  l_18_0.interaction.caustic_soda.interact_distance = 225
  l_18_0.interaction.caustic_soda.special_equipment_block = "caustic_soda"
  l_18_0.interaction.hydrogen_chloride = {}
  l_18_0.interaction.hydrogen_chloride.icon = "develop"
  l_18_0.interaction.hydrogen_chloride.text_id = "hud_int_take_hydrogen_chloride"
  l_18_0.interaction.hydrogen_chloride.start_active = false
  l_18_0.interaction.hydrogen_chloride.interact_distance = 225
  l_18_0.interaction.hydrogen_chloride.special_equipment_block = "hydrogen_chloride"
  l_18_0.interaction.elevator_button = {}
  l_18_0.interaction.elevator_button.icon = "interaction_elevator"
  l_18_0.interaction.elevator_button.text_id = "debug_interact_elevator_door"
  l_18_0.interaction.elevator_button.start_active = false
  l_18_0.interaction.use_computer = {}
  l_18_0.interaction.use_computer.icon = "interaction_elevator"
  l_18_0.interaction.use_computer.text_id = "hud_int_use_computer"
  l_18_0.interaction.use_computer.start_active = false
  l_18_0.interaction.use_computer.timer = 2
  l_18_0.interaction.elevator_button_roof = {}
  l_18_0.interaction.elevator_button_roof.icon = "interaction_elevator"
  l_18_0.interaction.elevator_button_roof.text_id = "debug_interact_elevator_door_roof"
  l_18_0.interaction.elevator_button_roof.start_active = false
  l_18_0.interaction.key = {}
  l_18_0.interaction.key.icon = "equipment_bank_manager_key"
  l_18_0.interaction.key.text_id = "hud_int_equipment_keycard"
  l_18_0.interaction.key.equipment_text_id = "hud_int_equipment_no_keycard"
  l_18_0.interaction.key.special_equipment = "bank_manager_key"
  l_18_0.interaction.key.equipment_consume = true
  l_18_0.interaction.key.axis = "x"
  l_18_0.interaction.key.interact_distance = 100
  l_18_0.interaction.numpad = {}
  l_18_0.interaction.numpad.icon = "equipment_bank_manager_key"
  l_18_0.interaction.numpad.text_id = "debug_interact_numpad"
  l_18_0.interaction.numpad.start_active = false
  l_18_0.interaction.numpad.axis = "z"
  l_18_0.interaction.take_weapons = {}
  l_18_0.interaction.take_weapons.icon = "develop"
  l_18_0.interaction.take_weapons.text_id = "hud_int_take_weapons"
  l_18_0.interaction.take_weapons.action_text_id = "hud_action_taking_weapons"
  l_18_0.interaction.take_weapons.timer = 3
  l_18_0.interaction.take_weapons.axis = "x"
  l_18_0.interaction.take_weapons.interact_distance = 120
  l_18_0.interaction.pick_lock_easy = {}
  l_18_0.interaction.pick_lock_easy.contour = "interactable_icon"
  l_18_0.interaction.pick_lock_easy.icon = "equipment_bank_manager_key"
  l_18_0.interaction.pick_lock_easy.text_id = "hud_int_pick_lock"
  l_18_0.interaction.pick_lock_easy.start_active = true
  l_18_0.interaction.pick_lock_easy.timer = 10
  l_18_0.interaction.pick_lock_easy.interact_distance = 100
  l_18_0.interaction.pick_lock_easy.requires_upgrade = {category = "player", upgrade = "pick_lock_easy"}
  l_18_0.interaction.pick_lock_easy.upgrade_timer_multiplier = {category = "player", upgrade = "pick_lock_easy_speed_multiplier"}
  l_18_0.interaction.pick_lock_easy.action_text_id = "hud_action_picking_lock"
  l_18_0.interaction.pick_lock_easy.sound_start = "bar_pick_lock"
  l_18_0.interaction.pick_lock_easy.sound_interupt = "bar_pick_lock_cancel"
  l_18_0.interaction.pick_lock_easy.sound_done = "bar_pick_lock_finished"
  l_18_0.interaction.pick_lock_easy_no_skill = {}
  l_18_0.interaction.pick_lock_easy_no_skill.contour = "interactable_icon"
  l_18_0.interaction.pick_lock_easy_no_skill.icon = "equipment_bank_manager_key"
  l_18_0.interaction.pick_lock_easy_no_skill.text_id = "hud_int_pick_lock"
  l_18_0.interaction.pick_lock_easy_no_skill.start_active = true
  l_18_0.interaction.pick_lock_easy_no_skill.timer = 7
  l_18_0.interaction.pick_lock_easy_no_skill.upgrade_timer_multiplier = {category = "player", upgrade = "pick_lock_easy_speed_multiplier"}
  l_18_0.interaction.pick_lock_easy_no_skill.action_text_id = "hud_action_picking_lock"
  l_18_0.interaction.pick_lock_easy_no_skill.interact_distance = 100
  l_18_0.interaction.pick_lock_easy_no_skill.sound_start = "bar_pick_lock"
  l_18_0.interaction.pick_lock_easy_no_skill.sound_interupt = "bar_pick_lock_cancel"
  l_18_0.interaction.pick_lock_easy_no_skill.sound_done = "bar_pick_lock_finished"
  l_18_0.interaction.pick_lock_hard = {}
  l_18_0.interaction.pick_lock_hard.contour = "interactable_icon"
  l_18_0.interaction.pick_lock_hard.icon = "equipment_bank_manager_key"
  l_18_0.interaction.pick_lock_hard.text_id = "hud_int_pick_lock"
  l_18_0.interaction.pick_lock_hard.start_active = true
  l_18_0.interaction.pick_lock_hard.timer = 45
  l_18_0.interaction.pick_lock_hard.interact_distance = 100
  l_18_0.interaction.pick_lock_hard.requires_upgrade = {category = "player", upgrade = "pick_lock_hard"}
  l_18_0.interaction.pick_lock_hard.action_text_id = "hud_action_picking_lock"
  l_18_0.interaction.pick_lock_hard.sound_start = "bar_pick_lock"
  l_18_0.interaction.pick_lock_hard.sound_interupt = "bar_pick_lock_cancel"
  l_18_0.interaction.pick_lock_hard.sound_done = "bar_pick_lock_finished"
  l_18_0.interaction.pick_lock_hard_no_skill = {}
  l_18_0.interaction.pick_lock_hard_no_skill.contour = "interactable_icon"
  l_18_0.interaction.pick_lock_hard_no_skill.icon = "equipment_bank_manager_key"
  l_18_0.interaction.pick_lock_hard_no_skill.text_id = "hud_int_pick_lock"
  l_18_0.interaction.pick_lock_hard_no_skill.start_active = true
  l_18_0.interaction.pick_lock_hard_no_skill.timer = 20
  l_18_0.interaction.pick_lock_hard_no_skill.action_text_id = "hud_action_picking_lock"
  l_18_0.interaction.pick_lock_hard_no_skill.upgrade_timer_multiplier = {category = "player", upgrade = "pick_lock_easy_speed_multiplier"}
  l_18_0.interaction.pick_lock_hard_no_skill.interact_distance = 100
  l_18_0.interaction.pick_lock_hard_no_skill.sound_start = "bar_pick_lock"
  l_18_0.interaction.pick_lock_hard_no_skill.sound_interupt = "bar_pick_lock_cancel"
  l_18_0.interaction.pick_lock_hard_no_skill.sound_done = "bar_pick_lock_finished"
  l_18_0.interaction.cant_pick_lock = {}
  l_18_0.interaction.cant_pick_lock.icon = "equipment_bank_manager_key"
  l_18_0.interaction.cant_pick_lock.text_id = "hud_int_pick_lock"
  l_18_0.interaction.cant_pick_lock.start_active = false
  l_18_0.interaction.cant_pick_lock.interact_distance = 80
  l_18_0.interaction.hospital_veil_container = {}
  l_18_0.interaction.hospital_veil_container.icon = "equipment_vialOK"
  l_18_0.interaction.hospital_veil_container.text_id = "debug_interact_hospital_veil_container"
  l_18_0.interaction.hospital_veil_container.equipment_text_id = "debug_interact_equipment_blood_sample_verified"
  l_18_0.interaction.hospital_veil_container.special_equipment = "blood_sample_verified"
  l_18_0.interaction.hospital_veil_container.equipment_consume = true
  l_18_0.interaction.hospital_veil_container.start_active = false
  l_18_0.interaction.hospital_veil_container.timer = 2
  l_18_0.interaction.hospital_veil_container.axis = "y"
  l_18_0.interaction.hospital_phone = {}
  l_18_0.interaction.hospital_phone.icon = "interaction_answerphone"
  l_18_0.interaction.hospital_phone.text_id = "debug_interact_hospital_phone"
  l_18_0.interaction.hospital_phone.start_active = false
  l_18_0.interaction.hospital_security_cable = {}
  l_18_0.interaction.hospital_security_cable.text_id = "debug_interact_hospital_security_cable"
  l_18_0.interaction.hospital_security_cable.icon = "interaction_wirecutter"
  l_18_0.interaction.hospital_security_cable.start_active = false
  l_18_0.interaction.hospital_security_cable.timer = 5
  l_18_0.interaction.hospital_security_cable.interact_distance = 75
  l_18_0.interaction.hospital_veil = {}
  l_18_0.interaction.hospital_veil.icon = "equipment_vial"
  l_18_0.interaction.hospital_veil.text_id = "debug_interact_hospital_veil_hold"
  l_18_0.interaction.hospital_veil.start_active = false
  l_18_0.interaction.hospital_veil.timer = 2
  l_18_0.interaction.hospital_veil_take = {}
  l_18_0.interaction.hospital_veil_take.icon = "equipment_vial"
  l_18_0.interaction.hospital_veil_take.text_id = "debug_interact_hospital_veil_take"
  l_18_0.interaction.hospital_veil_take.start_active = false
  l_18_0.interaction.hospital_sentry = {}
  l_18_0.interaction.hospital_sentry.icon = "interaction_sentrygun"
  l_18_0.interaction.hospital_sentry.text_id = "debug_interact_hospital_sentry"
  l_18_0.interaction.hospital_sentry.start_active = false
  l_18_0.interaction.hospital_sentry.timer = 2
  l_18_0.interaction.drill = {}
  l_18_0.interaction.drill.icon = "equipment_drill"
  l_18_0.interaction.drill.contour = "interactable_icon"
  l_18_0.interaction.drill.text_id = "hud_int_equipment_drill"
  l_18_0.interaction.drill.equipment_text_id = "hud_int_equipment_no_drill"
  l_18_0.interaction.drill.timer = 3
  l_18_0.interaction.drill.blocked_hint = "no_drill"
  l_18_0.interaction.drill.sound_start = "bar_drill_apply"
  l_18_0.interaction.drill.sound_interupt = "bar_drill_apply_cancel"
  l_18_0.interaction.drill.sound_done = "bar_drill_apply_finished"
  l_18_0.interaction.drill.axis = "y"
  l_18_0.interaction.drill.action_text_id = "hud_action_placing_drill"
  l_18_0.interaction.drill_jammed = {}
  l_18_0.interaction.drill_jammed.icon = "equipment_drill"
  l_18_0.interaction.drill_jammed.text_id = "hud_int_equipment_drill_jammed"
  l_18_0.interaction.drill_jammed.timer = 10
  l_18_0.interaction.drill_jammed.sound_start = "bar_drill_fix"
  l_18_0.interaction.drill_jammed.sound_interupt = "bar_drill_fix_cancel"
  l_18_0.interaction.drill_jammed.sound_done = "bar_drill_fix_finished"
  l_18_0.interaction.drill_jammed.upgrade_timer_multiplier = {category = "player", upgrade = "drill_fix_interaction_speed_multiplier"}
  l_18_0.interaction.drill_jammed.action_text_id = "hud_action_fixing_drill"
  l_18_0.interaction.lance = {}
  l_18_0.interaction.lance.icon = "equipment_drill"
  l_18_0.interaction.lance.contour = "interactable_icon"
  l_18_0.interaction.lance.text_id = "hud_int_equipment_lance"
  l_18_0.interaction.lance.equipment_text_id = "hud_int_equipment_no_lance"
  l_18_0.interaction.lance.timer = 3
  l_18_0.interaction.lance.blocked_hint = "no_lance"
  l_18_0.interaction.lance.sound_start = "bar_thermal_lance_apply"
  l_18_0.interaction.lance.sound_interupt = "bar_thermal_lance_apply_cancel"
  l_18_0.interaction.lance.sound_done = "bar_thermal_lance_apply_finished"
  l_18_0.interaction.lance.action_text_id = "hud_action_placing_lance"
  l_18_0.interaction.lance_jammed = {}
  l_18_0.interaction.lance_jammed.icon = "equipment_drill"
  l_18_0.interaction.lance_jammed.text_id = "hud_int_equipment_lance_jammed"
  l_18_0.interaction.lance_jammed.timer = 10
  l_18_0.interaction.lance_jammed.sound_start = "bar_thermal_lance_fix"
  l_18_0.interaction.lance_jammed.sound_interupt = "bar_thermal_lance_fix_cancel"
  l_18_0.interaction.lance_jammed.sound_done = "bar_thermal_lance_fix_finished"
  l_18_0.interaction.lance_jammed.upgrade_timer_multiplier = {category = "player", upgrade = "drill_fix_interaction_speed_multiplier"}
  l_18_0.interaction.lance_jammed.action_text_id = "hud_action_fixing_lance"
  l_18_0.interaction.glass_cutter = {}
  l_18_0.interaction.glass_cutter.icon = "equipment_cutter"
  l_18_0.interaction.glass_cutter.text_id = "debug_interact_glass_cutter"
  l_18_0.interaction.glass_cutter.equipment_text_id = "debug_interact_equipment_glass_cutter"
  l_18_0.interaction.glass_cutter.special_equipment = "glass_cutter"
  l_18_0.interaction.glass_cutter.timer = 3
  l_18_0.interaction.glass_cutter.blocked_hint = "no_glass_cutter"
  l_18_0.interaction.glass_cutter.sound_start = "bar_drill_apply"
  l_18_0.interaction.glass_cutter.sound_interupt = "bar_drill_apply_cancel"
  l_18_0.interaction.glass_cutter.sound_done = "bar_drill_apply_finished"
  l_18_0.interaction.glass_cutter_jammed = {}
  l_18_0.interaction.glass_cutter_jammed.icon = "equipment_cutter"
  l_18_0.interaction.glass_cutter_jammed.text_id = "debug_interact_cutter_jammed"
  l_18_0.interaction.glass_cutter_jammed.timer = 10
  l_18_0.interaction.glass_cutter_jammed.sound_start = "bar_drill_fix"
  l_18_0.interaction.glass_cutter_jammed.sound_interupt = "bar_drill_fix_cancel"
  l_18_0.interaction.glass_cutter_jammed.sound_done = "bar_drill_fix_finished"
  l_18_0.interaction.hack_ipad = {}
  l_18_0.interaction.hack_ipad.icon = "equipment_hack_ipad"
  l_18_0.interaction.hack_ipad.text_id = "debug_interact_hack_ipad"
  l_18_0.interaction.hack_ipad.timer = 3
  l_18_0.interaction.hack_ipad.sound_start = "bar_drill_apply"
  l_18_0.interaction.hack_ipad.sound_interupt = "bar_drill_apply_cancel"
  l_18_0.interaction.hack_ipad.sound_done = "bar_drill_apply_finished"
  l_18_0.interaction.hack_ipad.axis = "x"
  l_18_0.interaction.hack_ipad_jammed = {}
  l_18_0.interaction.hack_ipad_jammed.icon = "equipment_hack_ipad"
  l_18_0.interaction.hack_ipad_jammed.text_id = "debug_interact_hack_ipad_jammed"
  l_18_0.interaction.hack_ipad_jammed.timer = 10
  l_18_0.interaction.hack_ipad_jammed.sound_start = "bar_drill_fix"
  l_18_0.interaction.hack_ipad_jammed.sound_interupt = "bar_drill_fix_cancel"
  l_18_0.interaction.hack_ipad_jammed.sound_done = "bar_drill_fix_finished"
  l_18_0.interaction.hack_suburbia = {}
  l_18_0.interaction.hack_suburbia.icon = "equipment_hack_ipad"
  l_18_0.interaction.hack_suburbia.text_id = "debug_interact_hack_ipad"
  l_18_0.interaction.hack_suburbia.timer = 5
  l_18_0.interaction.hack_suburbia.sound_start = "bar_drill_apply"
  l_18_0.interaction.hack_suburbia.sound_interupt = "bar_drill_apply_cancel"
  l_18_0.interaction.hack_suburbia.sound_done = "bar_drill_apply_finished"
  l_18_0.interaction.hack_suburbia.axis = "x"
  l_18_0.interaction.hack_suburbia_jammed = {}
  l_18_0.interaction.hack_suburbia_jammed.icon = "equipment_hack_ipad"
  l_18_0.interaction.hack_suburbia_jammed.text_id = "debug_interact_hack_ipad_jammed"
  l_18_0.interaction.hack_suburbia_jammed.timer = 5
  l_18_0.interaction.hack_suburbia_jammed.sound_start = "bar_drill_fix"
  l_18_0.interaction.hack_suburbia_jammed.sound_interupt = "bar_drill_fix_cancel"
  l_18_0.interaction.hack_suburbia_jammed.sound_done = "bar_drill_fix_finished"
  l_18_0.interaction.security_station = {}
  l_18_0.interaction.security_station.icon = "equipment_hack_ipad"
  l_18_0.interaction.security_station.text_id = "debug_interact_security_station"
  l_18_0.interaction.security_station.timer = 3
  l_18_0.interaction.security_station.sound_start = "bar_drill_apply"
  l_18_0.interaction.security_station.sound_interupt = "bar_drill_apply_cancel"
  l_18_0.interaction.security_station.sound_done = "bar_drill_apply_finished"
  l_18_0.interaction.security_station.axis = "z"
  l_18_0.interaction.security_station.start_active = false
  l_18_0.interaction.security_station.sound_start = "bar_keyboard"
  l_18_0.interaction.security_station.sound_interupt = "bar_keyboard_cancel"
  l_18_0.interaction.security_station.sound_done = "bar_keyboard_finished"
  l_18_0.interaction.security_station_keyboard = {}
  l_18_0.interaction.security_station_keyboard.icon = "interaction_keyboard"
  l_18_0.interaction.security_station_keyboard.text_id = "debug_interact_security_station"
  l_18_0.interaction.security_station_keyboard.timer = 6
  l_18_0.interaction.security_station_keyboard.axis = "z"
  l_18_0.interaction.security_station_keyboard.start_active = false
  l_18_0.interaction.security_station_keyboard.interact_distance = 150
  l_18_0.interaction.security_station_keyboard.sound_start = "bar_keyboard"
  l_18_0.interaction.security_station_keyboard.sound_interupt = "bar_keyboard_cancel"
  l_18_0.interaction.security_station_keyboard.sound_done = "bar_keyboard_finished"
  l_18_0.interaction.security_station_jammed = {}
  l_18_0.interaction.security_station_jammed.icon = "interaction_keyboard"
  l_18_0.interaction.security_station_jammed.text_id = "debug_interact_security_station_jammed"
  l_18_0.interaction.security_station_jammed.timer = 10
  l_18_0.interaction.security_station_jammed.sound_start = "bar_drill_fix"
  l_18_0.interaction.security_station_jammed.sound_interupt = "bar_drill_fix_cancel"
  l_18_0.interaction.security_station_jammed.sound_done = "bar_drill_fix_finished"
  l_18_0.interaction.security_station_jammed.axis = "z"
  l_18_0.interaction.apartment_drill = {}
  l_18_0.interaction.apartment_drill.icon = "equipment_drill"
  l_18_0.interaction.apartment_drill.text_id = "debug_interact_drill"
  l_18_0.interaction.apartment_drill.equipment_text_id = "debug_interact_equipment_drill"
  l_18_0.interaction.apartment_drill.timer = 3
  l_18_0.interaction.apartment_drill.blocked_hint = "no_drill"
  l_18_0.interaction.apartment_drill.sound_start = "bar_drill_apply"
  l_18_0.interaction.apartment_drill.sound_interupt = "bar_drill_apply_cancel"
  l_18_0.interaction.apartment_drill.sound_done = "bar_drill_apply_finished"
  l_18_0.interaction.apartment_drill.interact_distance = 200
  l_18_0.interaction.apartment_drill_jammed = {}
  l_18_0.interaction.apartment_drill_jammed.icon = "equipment_drill"
  l_18_0.interaction.apartment_drill_jammed.text_id = "debug_interact_drill_jammed"
  l_18_0.interaction.apartment_drill_jammed.timer = 3
  l_18_0.interaction.apartment_drill_jammed.sound_start = "bar_drill_fix"
  l_18_0.interaction.apartment_drill_jammed.sound_interupt = "bar_drill_fix_cancel"
  l_18_0.interaction.apartment_drill_jammed.sound_done = "bar_drill_fix_finished"
  l_18_0.interaction.apartment_drill_jammed.interact_distance = 200
  l_18_0.interaction.suburbia_drill = {}
  l_18_0.interaction.suburbia_drill.icon = "equipment_drill"
  l_18_0.interaction.suburbia_drill.text_id = "debug_interact_drill"
  l_18_0.interaction.suburbia_drill.equipment_text_id = "debug_interact_equipment_drill"
  l_18_0.interaction.suburbia_drill.timer = 3
  l_18_0.interaction.suburbia_drill.blocked_hint = "no_drill"
  l_18_0.interaction.suburbia_drill.sound_start = "bar_drill_apply"
  l_18_0.interaction.suburbia_drill.sound_interupt = "bar_drill_apply_cancel"
  l_18_0.interaction.suburbia_drill.sound_done = "bar_drill_apply_finished"
  l_18_0.interaction.suburbia_drill.interact_distance = 200
  l_18_0.interaction.suburbia_drill_jammed = {}
  l_18_0.interaction.suburbia_drill_jammed.icon = "equipment_drill"
  l_18_0.interaction.suburbia_drill_jammed.text_id = "debug_interact_drill_jammed"
  l_18_0.interaction.suburbia_drill_jammed.timer = 3
  l_18_0.interaction.suburbia_drill_jammed.sound_start = "bar_drill_fix"
  l_18_0.interaction.suburbia_drill_jammed.sound_interupt = "bar_drill_fix_cancel"
  l_18_0.interaction.suburbia_drill_jammed.sound_done = "bar_drill_fix_finished"
  l_18_0.interaction.suburbia_drill_jammed.interact_distance = 200
  l_18_0.interaction.goldheist_drill = {}
  l_18_0.interaction.goldheist_drill.icon = "equipment_drill"
  l_18_0.interaction.goldheist_drill.text_id = "debug_interact_drill"
  l_18_0.interaction.goldheist_drill.equipment_text_id = "debug_interact_equipment_drill"
  l_18_0.interaction.goldheist_drill.timer = 3
  l_18_0.interaction.goldheist_drill.blocked_hint = "no_drill"
  l_18_0.interaction.goldheist_drill.sound_start = "bar_drill_apply"
  l_18_0.interaction.goldheist_drill.sound_interupt = "bar_drill_apply_cancel"
  l_18_0.interaction.goldheist_drill.sound_done = "bar_drill_apply_finished"
  l_18_0.interaction.goldheist_drill.interact_distance = 200
  l_18_0.interaction.goldheist_drill_jammed = {}
  l_18_0.interaction.goldheist_drill_jammed.icon = "equipment_drill"
  l_18_0.interaction.goldheist_drill_jammed.text_id = "debug_interact_drill_jammed"
  l_18_0.interaction.goldheist_drill_jammed.timer = 3
  l_18_0.interaction.goldheist_drill_jammed.sound_start = "bar_drill_fix"
  l_18_0.interaction.goldheist_drill_jammed.sound_interupt = "bar_drill_fix_cancel"
  l_18_0.interaction.goldheist_drill_jammed.sound_done = "bar_drill_fix_finished"
  l_18_0.interaction.goldheist_drill_jammed.interact_distance = 200
  l_18_0.interaction.hospital_saw_teddy = {}
  l_18_0.interaction.hospital_saw_teddy.icon = "equipment_saw"
  l_18_0.interaction.hospital_saw_teddy.text_id = "debug_interact_hospital_saw_teddy"
  l_18_0.interaction.hospital_saw_teddy.start_active = false
  l_18_0.interaction.hospital_saw_teddy.timer = 2
  l_18_0.interaction.hospital_saw = {}
  l_18_0.interaction.hospital_saw.icon = "equipment_saw"
  l_18_0.interaction.hospital_saw.text_id = "debug_interact_saw"
  l_18_0.interaction.hospital_saw.equipment_text_id = "debug_interact_equipment_saw"
  l_18_0.interaction.hospital_saw.special_equipment = "saw"
  l_18_0.interaction.hospital_saw.timer = 3
  l_18_0.interaction.hospital_saw.sound_start = "bar_drill_apply"
  l_18_0.interaction.hospital_saw.sound_interupt = "bar_drill_apply_cancel"
  l_18_0.interaction.hospital_saw.sound_done = "bar_drill_apply_finished"
  l_18_0.interaction.hospital_saw.interact_distance = 200
  l_18_0.interaction.hospital_saw.axis = "z"
  l_18_0.interaction.hospital_saw_jammed = {}
  l_18_0.interaction.hospital_saw_jammed.icon = "equipment_saw"
  l_18_0.interaction.hospital_saw_jammed.text_id = "debug_interact_saw_jammed"
  l_18_0.interaction.hospital_saw_jammed.timer = 3
  l_18_0.interaction.hospital_saw_jammed.sound_start = "bar_drill_fix"
  l_18_0.interaction.hospital_saw_jammed.sound_interupt = "bar_drill_fix_cancel"
  l_18_0.interaction.hospital_saw_jammed.sound_done = "bar_drill_fix_finished"
  l_18_0.interaction.hospital_saw_jammed.interact_distance = 200
  l_18_0.interaction.hospital_saw_jammed.axis = "z"
  l_18_0.interaction.hospital_saw_jammed.upgrade_timer_multiplier = {category = "player", upgrade = "drill_fix_interaction_speed_multiplier"}
  l_18_0.interaction.apartment_saw = {}
  l_18_0.interaction.apartment_saw.icon = "equipment_saw"
  l_18_0.interaction.apartment_saw.text_id = "debug_interact_saw"
  l_18_0.interaction.apartment_saw.equipment_text_id = "debug_interact_equipment_saw"
  l_18_0.interaction.apartment_saw.special_equipment = "saw"
  l_18_0.interaction.apartment_saw.timer = 3
  l_18_0.interaction.apartment_saw.sound_start = "bar_drill_apply"
  l_18_0.interaction.apartment_saw.sound_interupt = "bar_drill_apply_cancel"
  l_18_0.interaction.apartment_saw.sound_done = "bar_drill_apply_finished"
  l_18_0.interaction.apartment_saw.interact_distance = 200
  l_18_0.interaction.apartment_saw.axis = "z"
  l_18_0.interaction.apartment_saw_jammed = {}
  l_18_0.interaction.apartment_saw_jammed.icon = "equipment_saw"
  l_18_0.interaction.apartment_saw_jammed.text_id = "debug_interact_saw_jammed"
  l_18_0.interaction.apartment_saw_jammed.timer = 3
  l_18_0.interaction.apartment_saw_jammed.sound_start = "bar_drill_fix"
  l_18_0.interaction.apartment_saw_jammed.sound_interupt = "bar_drill_fix_cancel"
  l_18_0.interaction.apartment_saw_jammed.sound_done = "bar_drill_fix_finished"
  l_18_0.interaction.apartment_saw_jammed.interact_distance = 200
  l_18_0.interaction.apartment_saw_jammed.axis = "z"
  l_18_0.interaction.apartment_saw_jammed.upgrade_timer_multiplier = {category = "player", upgrade = "drill_fix_interaction_speed_multiplier"}
  l_18_0.interaction.secret_stash_saw = {}
  l_18_0.interaction.secret_stash_saw.icon = "equipment_saw"
  l_18_0.interaction.secret_stash_saw.text_id = "debug_interact_saw"
  l_18_0.interaction.secret_stash_saw.equipment_text_id = "debug_interact_equipment_saw"
  l_18_0.interaction.secret_stash_saw.special_equipment = "saw"
  l_18_0.interaction.secret_stash_saw.timer = 3
  l_18_0.interaction.secret_stash_saw.sound_start = "bar_drill_apply"
  l_18_0.interaction.secret_stash_saw.sound_interupt = "bar_drill_apply_cancel"
  l_18_0.interaction.secret_stash_saw.sound_done = "bar_drill_apply_finished"
  l_18_0.interaction.secret_stash_saw.interact_distance = 200
  l_18_0.interaction.secret_stash_saw.axis = "z"
  l_18_0.interaction.secret_stash_saw_jammed = {}
  l_18_0.interaction.secret_stash_saw_jammed.icon = "equipment_saw"
  l_18_0.interaction.secret_stash_saw_jammed.text_id = "debug_interact_saw_jammed"
  l_18_0.interaction.secret_stash_saw_jammed.timer = 3
  l_18_0.interaction.secret_stash_saw_jammed.sound_start = "bar_drill_fix"
  l_18_0.interaction.secret_stash_saw_jammed.sound_interupt = "bar_drill_fix_cancel"
  l_18_0.interaction.secret_stash_saw_jammed.sound_done = "bar_drill_fix_finished"
  l_18_0.interaction.secret_stash_saw_jammed.interact_distance = 200
  l_18_0.interaction.secret_stash_saw_jammed.axis = "z"
  l_18_0.interaction.secret_stash_saw_jammed.upgrade_timer_multiplier = {category = "player", upgrade = "drill_fix_interaction_speed_multiplier"}
  l_18_0.interaction.revive = {}
  l_18_0.interaction.revive.icon = "interaction_help"
  l_18_0.interaction.revive.text_id = "debug_interact_revive"
  l_18_0.interaction.revive.start_active = false
  l_18_0.interaction.revive.interact_distance = 300
  l_18_0.interaction.revive.no_contour = true
  l_18_0.interaction.revive.axis = "z"
  l_18_0.interaction.revive.timer = 6
  l_18_0.interaction.revive.sound_start = "bar_helpup"
  l_18_0.interaction.revive.sound_interupt = "bar_helpup_cancel"
  l_18_0.interaction.revive.sound_done = "bar_helpup_finished"
  l_18_0.interaction.revive.action_text_id = "hud_action_reviving"
  l_18_0.interaction.revive.upgrade_timer_multiplier = {category = "player", upgrade = "revive_interaction_speed_multiplier"}
  l_18_0.interaction.free = {}
  l_18_0.interaction.free.icon = "interaction_free"
  l_18_0.interaction.free.text_id = "debug_interact_free"
  l_18_0.interaction.free.start_active = false
  l_18_0.interaction.free.interact_distance = 300
  l_18_0.interaction.free.no_contour = true
  l_18_0.interaction.free.timer = 1
  l_18_0.interaction.free.sound_start = "bar_rescue"
  l_18_0.interaction.free.sound_interupt = "bar_rescue_cancel"
  l_18_0.interaction.free.sound_done = "bar_rescue_finished"
  l_18_0.interaction.free.action_text_id = "hud_action_freeing"
  l_18_0.interaction.hostage_trade = {}
  l_18_0.interaction.hostage_trade.icon = "interaction_trade"
  l_18_0.interaction.hostage_trade.text_id = "debug_interact_trade"
  l_18_0.interaction.hostage_trade.start_active = true
  l_18_0.interaction.hostage_trade.contour = "character_interactable"
  l_18_0.interaction.hostage_trade.timer = 3
  l_18_0.interaction.hostage_trade.requires_upgrade = {category = "player", upgrade = "hostage_trade"}
  l_18_0.interaction.hostage_trade.action_text_id = "hud_action_trading"
  l_18_0.interaction.trip_mine = {}
  l_18_0.interaction.trip_mine.icon = "equipment_trip_mine"
  l_18_0.interaction.trip_mine.contour = "deployable"
  l_18_0.interaction.trip_mine.requires_upgrade = {category = "trip_mine", upgrade = "can_switch_on_off"}
  l_18_0.interaction.ammo_bag = {}
  l_18_0.interaction.ammo_bag.icon = "equipment_ammo_bag"
  l_18_0.interaction.ammo_bag.text_id = "debug_interact_ammo_bag_take_ammo"
  l_18_0.interaction.ammo_bag.contour = "deployable"
  l_18_0.interaction.ammo_bag.timer = 3.5
  l_18_0.interaction.ammo_bag.blocked_hint = "full_ammo"
  l_18_0.interaction.ammo_bag.sound_start = "bar_bag_generic"
  l_18_0.interaction.ammo_bag.sound_interupt = "bar_bag_generic_cancel"
  l_18_0.interaction.ammo_bag.sound_done = "bar_bag_generic_finished"
  l_18_0.interaction.ammo_bag.action_text_id = "hud_action_taking_ammo"
  l_18_0.interaction.doctor_bag = {}
  l_18_0.interaction.doctor_bag.icon = "equipment_doctor_bag"
  l_18_0.interaction.doctor_bag.text_id = "debug_interact_doctor_bag_heal"
  l_18_0.interaction.doctor_bag.contour = "deployable"
  l_18_0.interaction.doctor_bag.timer = 3.5
  l_18_0.interaction.doctor_bag.blocked_hint = "full_health"
  l_18_0.interaction.doctor_bag.sound_start = "bar_helpup"
  l_18_0.interaction.doctor_bag.sound_interupt = "bar_helpup_cancel"
  l_18_0.interaction.doctor_bag.sound_done = "bar_helpup_finished"
  l_18_0.interaction.doctor_bag.action_text_id = "hud_action_healing"
  l_18_0.interaction.doctor_bag.upgrade_timer_multiplier = {category = "doctor_bag", upgrade = "interaction_speed_multiplier"}
  l_18_0.interaction.ecm_jammer = {}
  l_18_0.interaction.ecm_jammer.icon = "equipment_ecm_jammer"
  l_18_0.interaction.ecm_jammer.text_id = "hud_int_equipment_ecm_feedback"
  l_18_0.interaction.ecm_jammer.contour = "deployable"
  l_18_0.interaction.ecm_jammer.requires_upgrade = {category = "ecm_jammer", upgrade = "can_activate_feedback"}
  l_18_0.interaction.ecm_jammer.timer = 2
  l_18_0.interaction.laptop_objective = {}
  l_18_0.interaction.laptop_objective.icon = "laptop_objective"
  l_18_0.interaction.laptop_objective.start_active = false
  l_18_0.interaction.laptop_objective.text_id = "debug_interact_laptop_objective"
  l_18_0.interaction.laptop_objective.timer = 15
  l_18_0.interaction.laptop_objective.sound_start = "bar_keyboard"
  l_18_0.interaction.laptop_objective.sound_interupt = "bar_keyboard_cancel"
  l_18_0.interaction.laptop_objective.sound_done = "bar_keyboard_finished"
  l_18_0.interaction.laptop_objective.say_waiting = "i01x_any"
  l_18_0.interaction.laptop_objective.axis = "z"
  l_18_0.interaction.laptop_objective.interact_distance = 100
  l_18_0.interaction.money_bag = {}
  l_18_0.interaction.money_bag.icon = "equipment_money_bag"
  l_18_0.interaction.money_bag.text_id = "debug_interact_money_bag"
  l_18_0.interaction.money_bag.equipment_text_id = "debug_interact_equipment_money_bag"
  l_18_0.interaction.money_bag.special_equipment = "money_bag"
  l_18_0.interaction.money_bag.equipment_consume = false
  l_18_0.interaction.money_bag.sound_event = "ammo_bag_drop"
  l_18_0.interaction.apartment_helicopter = {}
  l_18_0.interaction.apartment_helicopter.icon = "develop"
  l_18_0.interaction.apartment_helicopter.text_id = "debug_interact_apartment_helicopter"
  l_18_0.interaction.apartment_helicopter.sound_event = "ammo_bag_drop"
  l_18_0.interaction.apartment_helicopter.timer = 13
  l_18_0.interaction.apartment_helicopter.interact_distance = 350
  l_18_0.interaction.test_interactive_door = {}
  l_18_0.interaction.test_interactive_door.icon = "develop"
  l_18_0.interaction.test_interactive_door.text_id = "debug_interact_temp_interact_box"
  l_18_0.interaction.test_interactive_door.sound_event = "ammo_bag_drop"
  l_18_0.interaction.test_interactive_door_one_direction = {}
  l_18_0.interaction.test_interactive_door_one_direction.icon = "develop"
  l_18_0.interaction.test_interactive_door_one_direction.text_id = "debug_interact_temp_interact_box"
  l_18_0.interaction.test_interactive_door_one_direction.sound_event = "ammo_bag_drop"
  l_18_0.interaction.test_interactive_door_one_direction.axis = "y"
  l_18_0.interaction.temp_interact_box = {}
  l_18_0.interaction.temp_interact_box.icon = "develop"
  l_18_0.interaction.temp_interact_box.text_id = "debug_interact_temp_interact_box"
  l_18_0.interaction.temp_interact_box.sound_event = "ammo_bag_drop"
  l_18_0.interaction.temp_interact_box.timer = 4
  l_18_0.interaction.requires_cable_ties = {}
  l_18_0.interaction.requires_cable_ties.icon = "develop"
  l_18_0.interaction.requires_cable_ties.text_id = "debug_interact_temp_interact_box"
  l_18_0.interaction.requires_cable_ties.equipment_text_id = "debug_interact_equipment_requires_cable_ties"
  l_18_0.interaction.requires_cable_ties.sound_event = "ammo_bag_drop"
  l_18_0.interaction.requires_cable_ties.special_equipment = "cable_tie"
  l_18_0.interaction.requires_cable_ties.equipment_consume = true
  l_18_0.interaction.requires_cable_ties.timer = 5
  l_18_0.interaction.requires_cable_ties.requires_upgrade = {category = "cable_tie", upgrade = "can_cable_tie_doors"}
  l_18_0.interaction.requires_cable_ties.upgrade_timer_multiplier = {category = "cable_tie", upgrade = "interact_speed_multiplier"}
  l_18_0.interaction.temp_interact_box_no_timer = {}
  l_18_0.interaction.temp_interact_box_no_timer.icon = "develop"
  l_18_0.interaction.temp_interact_box_no_timer.text_id = "debug_interact_temp_interact_box"
  l_18_0.interaction.access_camera = {}
  l_18_0.interaction.access_camera.icon = "develop"
  l_18_0.interaction.access_camera.text_id = "hud_int_access_camera"
  l_18_0.interaction.access_camera.interact_distance = 125
  l_18_0.interaction.interaction_ball = {}
  l_18_0.interaction.interaction_ball.icon = "develop"
  l_18_0.interaction.interaction_ball.text_id = "debug_interact_interaction_ball"
  l_18_0.interaction.interaction_ball.timer = 5
  l_18_0.interaction.interaction_ball.sound_start = "cft_hose_loop"
  l_18_0.interaction.interaction_ball.sound_interupt = "cft_hose_cancel"
  l_18_0.interaction.interaction_ball.sound_done = "cft_hose_end"
  l_18_0.interaction.invisible_interaction_open = {}
  l_18_0.interaction.invisible_interaction_open.icon = "develop"
  l_18_0.interaction.invisible_interaction_open.text_id = "hud_int_invisible_interaction_open"
  l_18_0.interaction.invisible_interaction_open.timer = 0.5
  l_18_0.interaction.money_briefcase = deep_clone(l_18_0.interaction.invisible_interaction_open)
  l_18_0.interaction.money_briefcase.axis = "x"
  l_18_0.interaction.cash_register = deep_clone(l_18_0.interaction.invisible_interaction_open)
  l_18_0.interaction.cash_register.axis = "x"
  l_18_0.interaction.cash_register.interact_distance = 110
  l_18_0.interaction.atm_interaction = deep_clone(l_18_0.interaction.invisible_interaction_open)
  l_18_0.interaction.atm_interaction.start_active = false
  l_18_0.interaction.weapon_case = deep_clone(l_18_0.interaction.invisible_interaction_open)
  l_18_0.interaction.weapon_case.axis = "x"
  l_18_0.interaction.weapon_case.interact_distance = 110
  l_18_0.interaction.invisible_interaction_close = deep_clone(l_18_0.interaction.invisible_interaction_open)
  l_18_0.interaction.invisible_interaction_close.text_id = "hud_int_invisible_interaction_close"
  l_18_0.interaction.interact_gen_pku_loot_take = {}
  l_18_0.interaction.interact_gen_pku_loot_take.icon = "develop"
  l_18_0.interaction.interact_gen_pku_loot_take.text_id = "debug_interact_gen_pku_loot_take"
  l_18_0.interaction.interact_gen_pku_loot_take.timer = 2
  l_18_0.interaction.water_tap = {}
  l_18_0.interaction.water_tap.icon = "develop"
  l_18_0.interaction.water_tap.text_id = "debug_interact_water_tap"
  l_18_0.interaction.water_tap.timer = 3
  l_18_0.interaction.water_tap.start_active = false
  l_18_0.interaction.water_tap.axis = "y"
  l_18_0.interaction.water_manhole = {}
  l_18_0.interaction.water_manhole.icon = "develop"
  l_18_0.interaction.water_manhole.text_id = "debug_interact_water_tap"
  l_18_0.interaction.water_manhole.timer = 3
  l_18_0.interaction.water_manhole.start_active = false
  l_18_0.interaction.water_manhole.axis = "z"
  l_18_0.interaction.water_manhole.interact_distance = 200
  l_18_0.interaction.sewer_manhole = {}
  l_18_0.interaction.sewer_manhole.icon = "develop"
  l_18_0.interaction.sewer_manhole.text_id = "debug_interact_sewer_manhole"
  l_18_0.interaction.sewer_manhole.timer = 3
  l_18_0.interaction.sewer_manhole.start_active = false
  l_18_0.interaction.sewer_manhole.axis = "z"
  l_18_0.interaction.sewer_manhole.interact_distance = 200
  l_18_0.interaction.sewer_manhole.equipment_text_id = "debug_interact_equipment_crowbar"
  l_18_0.interaction.sewer_manhole.special_equipment = "crowbar"
  l_18_0.interaction.circuit_breaker = {}
  l_18_0.interaction.circuit_breaker.icon = "interaction_powerbox"
  l_18_0.interaction.circuit_breaker.text_id = "debug_interact_circuit_breaker"
  l_18_0.interaction.circuit_breaker.start_active = false
  l_18_0.interaction.circuit_breaker.axis = "z"
  l_18_0.interaction.transformer_box = {}
  l_18_0.interaction.transformer_box.icon = "interaction_powerbox"
  l_18_0.interaction.transformer_box.text_id = "debug_interact_transformer_box"
  l_18_0.interaction.transformer_box.start_active = false
  l_18_0.interaction.transformer_box.axis = "y"
  l_18_0.interaction.transformer_box.timer = 5
  l_18_0.interaction.stash_server_cord = {}
  l_18_0.interaction.stash_server_cord.icon = "interaction_powercord"
  l_18_0.interaction.stash_server_cord.text_id = "debug_interact_stash_server_cord"
  l_18_0.interaction.stash_server_cord.start_active = false
  l_18_0.interaction.stash_server_cord.axis = "z"
  l_18_0.interaction.stash_planks = {}
  l_18_0.interaction.stash_planks.icon = "equipment_planks"
  l_18_0.interaction.stash_planks.contour = "interactable_icon"
  l_18_0.interaction.stash_planks.text_id = "debug_interact_stash_planks"
  l_18_0.interaction.stash_planks.start_active = false
  l_18_0.interaction.stash_planks.timer = 2.5
  l_18_0.interaction.stash_planks.equipment_text_id = "debug_interact_equipment_stash_planks"
  l_18_0.interaction.stash_planks.special_equipment = "planks"
  l_18_0.interaction.stash_planks.equipment_consume = true
  l_18_0.interaction.stash_planks.sound_start = "bar_barricade_window"
  l_18_0.interaction.stash_planks.sound_interupt = "bar_barricade_window_cancel"
  l_18_0.interaction.stash_planks.sound_done = "bar_barricade_window_finished"
  l_18_0.interaction.stash_planks.action_text_id = "hud_action_barricading"
  l_18_0.interaction.stash_planks.axis = "z"
  l_18_0.interaction.stash_planks_pickup = {}
  l_18_0.interaction.stash_planks_pickup.icon = "equipment_planks"
  l_18_0.interaction.stash_planks_pickup.text_id = "debug_interact_stash_planks_pickup"
  l_18_0.interaction.stash_planks_pickup.start_active = false
  l_18_0.interaction.stash_planks_pickup.timer = 2
  l_18_0.interaction.stash_planks_pickup.axis = "z"
  l_18_0.interaction.stash_planks_pickup.special_equipment_block = "planks"
  l_18_0.interaction.stash_planks_pickup.sound_start = "bar_pick_up_planks"
  l_18_0.interaction.stash_planks_pickup.sound_interupt = "bar_pick_up_planks_cancel"
  l_18_0.interaction.stash_planks_pickup.sound_done = "bar_pick_up_planks_finished"
  l_18_0.interaction.stash_planks_pickup.action_text_id = "hud_action_grabbing_planks"
  l_18_0.interaction.stash_server = {}
  l_18_0.interaction.stash_server.icon = "equipment_stash_server"
  l_18_0.interaction.stash_server.text_id = "debug_interact_stash_server"
  l_18_0.interaction.stash_server.timer = 2
  l_18_0.interaction.stash_server.start_active = false
  l_18_0.interaction.stash_server.axis = "z"
  l_18_0.interaction.stash_server.equipment_text_id = "debug_interact_equipment_stash_server"
  l_18_0.interaction.stash_server.special_equipment = "server"
  l_18_0.interaction.stash_server.equipment_consume = true
  l_18_0.interaction.stash_server_pickup = {}
  l_18_0.interaction.stash_server_pickup.icon = "equipment_stash_server"
  l_18_0.interaction.stash_server_pickup.text_id = "hud_int_hold_take_hdd"
  l_18_0.interaction.stash_server_pickup.timer = 1
  l_18_0.interaction.stash_server_pickup.start_active = false
  l_18_0.interaction.stash_server_pickup.axis = "z"
  l_18_0.interaction.stash_server_pickup.special_equipment_block = "server"
  l_18_0.interaction.shelf_sliding_suburbia = {}
  l_18_0.interaction.shelf_sliding_suburbia.icon = "develop"
  l_18_0.interaction.shelf_sliding_suburbia.text_id = "debug_interact_move_bookshelf"
  l_18_0.interaction.shelf_sliding_suburbia.start_active = false
  l_18_0.interaction.shelf_sliding_suburbia.timer = 3
  l_18_0.interaction.tear_painting = {}
  l_18_0.interaction.tear_painting.icon = "develop"
  l_18_0.interaction.tear_painting.text_id = "debug_interact_tear_painting"
  l_18_0.interaction.tear_painting.start_active = false
  l_18_0.interaction.tear_painting.axis = "y"
  l_18_0.interaction.ejection_seat_interact = {}
  l_18_0.interaction.ejection_seat_interact.icon = "equipment_ejection_seat"
  l_18_0.interaction.ejection_seat_interact.text_id = "debug_interact_temp_interact_box"
  l_18_0.interaction.ejection_seat_interact.timer = 4
  l_18_0.interaction.diamond_pickup = {}
  l_18_0.interaction.diamond_pickup.icon = "interaction_diamond"
  l_18_0.interaction.diamond_pickup.text_id = "hud_int_take_jewelry"
  l_18_0.interaction.diamond_pickup.sound_event = "money_grab"
  l_18_0.interaction.diamond_pickup.start_active = false
  l_18_0.interaction.safe_loot_pickup = deep_clone(l_18_0.interaction.diamond_pickup)
  l_18_0.interaction.safe_loot_pickup.start_active = true
  l_18_0.interaction.safe_loot_pickup.text_id = "hud_int_take"
  l_18_0.interaction.tiara_pickup = {}
  l_18_0.interaction.tiara_pickup.icon = "develop"
  l_18_0.interaction.tiara_pickup.text_id = "hud_int_pickup_tiara"
  l_18_0.interaction.tiara_pickup.sound_event = "money_grab"
  l_18_0.interaction.tiara_pickup.start_active = false
  l_18_0.interaction.patientpaper_pickup = {}
  l_18_0.interaction.patientpaper_pickup.icon = "interaction_patientfile"
  l_18_0.interaction.patientpaper_pickup.text_id = "debug_interact_patient_paper"
  l_18_0.interaction.patientpaper_pickup.timer = 2
  l_18_0.interaction.patientpaper_pickup.start_active = false
  l_18_0.interaction.diamond_case = {}
  l_18_0.interaction.diamond_case.icon = "interaction_diamond"
  l_18_0.interaction.diamond_case.text_id = "debug_interact_diamond_case"
  l_18_0.interaction.diamond_case.start_active = false
  l_18_0.interaction.diamond_case.axis = "x"
  l_18_0.interaction.diamond_case.interact_distance = 150
  l_18_0.interaction.diamond_single_pickup = {}
  l_18_0.interaction.diamond_single_pickup.icon = "interaction_diamond"
  l_18_0.interaction.diamond_single_pickup.text_id = "debug_interact_temp_interact_box_press"
  l_18_0.interaction.diamond_single_pickup.sound_event = "ammo_bag_drop"
  l_18_0.interaction.diamond_single_pickup.start_active = false
  l_18_0.interaction.suburbia_necklace_pickup = {}
  l_18_0.interaction.suburbia_necklace_pickup.icon = "interaction_diamond"
  l_18_0.interaction.suburbia_necklace_pickup.text_id = "debug_interact_temp_interact_box_press"
  l_18_0.interaction.suburbia_necklace_pickup.sound_event = "ammo_bag_drop"
  l_18_0.interaction.suburbia_necklace_pickup.start_active = false
  l_18_0.interaction.suburbia_necklace_pickup.interact_distance = 100
  l_18_0.interaction.temp_interact_box2 = {}
  l_18_0.interaction.temp_interact_box2.icon = "develop"
  l_18_0.interaction.temp_interact_box2.text_id = "debug_interact_temp_interact_box"
  l_18_0.interaction.temp_interact_box2.sound_event = "ammo_bag_drop"
  l_18_0.interaction.temp_interact_box2.timer = 20
  l_18_0.interaction.printing_plates = {}
  l_18_0.interaction.printing_plates.icon = "develop"
  l_18_0.interaction.printing_plates.text_id = "debug_interact_printing_plates"
  l_18_0.interaction.printing_plates.timer = 0.25
  l_18_0.interaction.c4 = {}
  l_18_0.interaction.c4.icon = "equipment_c4"
  l_18_0.interaction.c4.text_id = "debug_interact_c4"
  l_18_0.interaction.c4.timer = 4
  l_18_0.interaction.c4.sound_start = "bar_c4_apply"
  l_18_0.interaction.c4.sound_interupt = "bar_c4_apply_cancel"
  l_18_0.interaction.c4.sound_done = "bar_c4_apply_finished"
  l_18_0.interaction.c4.action_text_id = "hud_action_placing_c4"
  l_18_0.interaction.c4_diffusible = {}
  l_18_0.interaction.c4_diffusible.icon = "equipment_c4"
  l_18_0.interaction.c4_diffusible.text_id = "debug_c4_diffusible"
  l_18_0.interaction.c4_diffusible.timer = 4
  l_18_0.interaction.c4_diffusible.sound_start = "bar_c4_apply"
  l_18_0.interaction.c4_diffusible.sound_interupt = "bar_c4_apply_cancel"
  l_18_0.interaction.c4_diffusible.sound_done = "bar_c4_apply_finished"
  l_18_0.interaction.c4_diffusible.axis = "z"
  l_18_0.interaction.open_trunk = {}
  l_18_0.interaction.open_trunk.icon = "develop"
  l_18_0.interaction.open_trunk.text_id = "debug_interact_open_trunk"
  l_18_0.interaction.open_trunk.timer = 0.5
  l_18_0.interaction.open_trunk.axis = "x"
  l_18_0.interaction.open_trunk.action_text_id = "hud_action_opening_trunk"
  l_18_0.interaction.open_door = {}
  l_18_0.interaction.open_door.icon = "interaction_open_door"
  l_18_0.interaction.open_door.text_id = "debug_interact_open_door"
  l_18_0.interaction.open_door.interact_distance = 200
  l_18_0.interaction.embassy_door = {}
  l_18_0.interaction.embassy_door.start_active = false
  l_18_0.interaction.embassy_door.icon = "interaction_open_door"
  l_18_0.interaction.embassy_door.text_id = "debug_interact_embassy_door"
  l_18_0.interaction.embassy_door.interact_distance = 150
  l_18_0.interaction.embassy_door.timer = 5
  l_18_0.interaction.c4_special = {}
  l_18_0.interaction.c4_special.icon = "equipment_c4"
  l_18_0.interaction.c4_special.text_id = "debug_interact_c4"
  l_18_0.interaction.c4_special.equipment_text_id = "debug_interact_equipment_c4"
  l_18_0.interaction.c4_special.equipment_consume = true
  l_18_0.interaction.c4_special.timer = 4
  l_18_0.interaction.c4_special.sound_start = "bar_c4_apply"
  l_18_0.interaction.c4_special.sound_interupt = "bar_c4_apply_cancel"
  l_18_0.interaction.c4_special.sound_done = "bar_c4_apply_finished"
  l_18_0.interaction.c4_special.axis = "z"
  l_18_0.interaction.c4_special.action_text_id = "hud_action_placing_c4"
  l_18_0.interaction.c4_bag = {}
  l_18_0.interaction.c4_bag.icon = "equipment_c4"
  l_18_0.interaction.c4_bag.text_id = "debug_interact_c4_bag"
  l_18_0.interaction.c4_bag.timer = 2
  l_18_0.interaction.c4_bag.contour = "interactable"
  l_18_0.interaction.c4_bag.axis = "z"
  l_18_0.interaction.c4_bag.sound_start = "bar_bag_generic"
  l_18_0.interaction.c4_bag.sound_interupt = "bar_bag_generic_cancel"
  l_18_0.interaction.c4_bag.sound_done = "bar_bag_generic_finished"
  l_18_0.interaction.money_wrap = {}
  l_18_0.interaction.money_wrap.icon = "interaction_money_wrap"
  l_18_0.interaction.money_wrap.text_id = "debug_interact_money_wrap_take_money"
  l_18_0.interaction.money_wrap.start_active = false
  l_18_0.interaction.money_wrap.timer = 3
  l_18_0.interaction.money_wrap.action_text_id = "hud_action_taking_money"
  l_18_0.interaction.money_wrap.blocked_hint = "carry_block"
  l_18_0.interaction.money_wrap.sound_start = "bar_bag_money"
  l_18_0.interaction.money_wrap.sound_interupt = "bar_bag_money_cancel"
  l_18_0.interaction.money_wrap.sound_done = "bar_bag_money_finished"
  l_18_0.interaction.suburbia_money_wrap = {}
  l_18_0.interaction.suburbia_money_wrap.icon = "interaction_money_wrap"
  l_18_0.interaction.suburbia_money_wrap.text_id = "debug_interact_money_printed_take_money"
  l_18_0.interaction.suburbia_money_wrap.start_active = false
  l_18_0.interaction.suburbia_money_wrap.timer = 3
  l_18_0.interaction.suburbia_money_wrap.action_text_id = "hud_action_taking_money"
  l_18_0.interaction.money_wrap_single_bundle = {}
  l_18_0.interaction.money_wrap_single_bundle.icon = "interaction_money_wrap"
  l_18_0.interaction.money_wrap_single_bundle.text_id = "debug_interact_money_wrap_single_bundle_take_money"
  l_18_0.interaction.money_wrap_single_bundle.start_active = false
  l_18_0.interaction.money_wrap_single_bundle.interact_distance = 110
  l_18_0.interaction.christmas_present = {}
  l_18_0.interaction.christmas_present.icon = "interaction_christmas_present"
  l_18_0.interaction.christmas_present.text_id = "debug_interact_take_christmas_present"
  l_18_0.interaction.christmas_present.start_active = true
  l_18_0.interaction.christmas_present.interact_distance = 125
  l_18_0.interaction.gold_pile = {}
  l_18_0.interaction.gold_pile.icon = "interaction_gold"
  l_18_0.interaction.gold_pile.text_id = "debug_interact_gold_pile_take_money"
  l_18_0.interaction.gold_pile.start_active = false
  l_18_0.interaction.gold_pile.timer = 1
  l_18_0.interaction.gold_pile.action_text_id = "hud_action_taking_gold"
  l_18_0.interaction.gold_pile.blocked_hint = "carry_block"
  l_18_0.interaction.gold_bag = {}
  l_18_0.interaction.gold_bag.icon = "interaction_gold"
  l_18_0.interaction.gold_bag.text_id = "debug_interact_gold_bag"
  l_18_0.interaction.gold_bag.start_active = false
  l_18_0.interaction.gold_bag.timer = 1
  l_18_0.interaction.gold_bag.special_equipment_block = "gold_bag_equip"
  l_18_0.interaction.gold_bag.action_text_id = "hud_action_taking_gold"
  l_18_0.interaction.requires_gold_bag = {}
  l_18_0.interaction.requires_gold_bag.icon = "interaction_gold"
  l_18_0.interaction.requires_gold_bag.text_id = "debug_interact_requires_gold_bag"
  l_18_0.interaction.requires_gold_bag.equipment_text_id = "debug_interact_equipment_requires_gold_bag"
  l_18_0.interaction.requires_gold_bag.special_equipment = "gold_bag_equip"
  l_18_0.interaction.requires_gold_bag.start_active = true
  l_18_0.interaction.requires_gold_bag.equipment_consume = true
  l_18_0.interaction.requires_gold_bag.timer = 1
  l_18_0.interaction.requires_gold_bag.sound_event = "ammo_bag_drop"
  l_18_0.interaction.requires_gold_bag.axis = "x"
  l_18_0.interaction.intimidate = {}
  l_18_0.interaction.intimidate.icon = "equipment_cable_ties"
  l_18_0.interaction.intimidate.text_id = "debug_interact_intimidate"
  l_18_0.interaction.intimidate.equipment_text_id = "debug_interact_equipment_cable_tie"
  l_18_0.interaction.intimidate.start_active = false
  l_18_0.interaction.intimidate.special_equipment = "cable_tie"
  l_18_0.interaction.intimidate.equipment_consume = true
  l_18_0.interaction.intimidate.no_contour = true
  l_18_0.interaction.intimidate.timer = 2
  l_18_0.interaction.intimidate.upgrade_timer_multiplier = {category = "cable_tie", upgrade = "interact_speed_multiplier"}
  l_18_0.interaction.intimidate.action_text_id = "hud_action_cable_tying"
  l_18_0.interaction.intimidate_and_search = {}
  l_18_0.interaction.intimidate_and_search.icon = "equipment_cable_ties"
  l_18_0.interaction.intimidate_and_search.text_id = "debug_interact_intimidate"
  l_18_0.interaction.intimidate_and_search.equipment_text_id = "debug_interact_search_key"
  l_18_0.interaction.intimidate_and_search.start_active = false
  l_18_0.interaction.intimidate_and_search.special_equipment = "cable_tie"
  l_18_0.interaction.intimidate_and_search.equipment_consume = true
  l_18_0.interaction.intimidate_and_search.dont_need_equipment = true
  l_18_0.interaction.intimidate_and_search.no_contour = true
  l_18_0.interaction.intimidate_and_search.timer = 3.5
  l_18_0.interaction.intimidate_and_search.action_text_id = "hud_action_cable_tying"
  l_18_0.interaction.intimidate_with_contour = deep_clone(l_18_0.interaction.intimidate)
  l_18_0.interaction.intimidate_with_contour.no_contour = false
  l_18_0.interaction.intimidate_and_search_with_contour = deep_clone(l_18_0.interaction.intimidate_and_search)
  l_18_0.interaction.intimidate_and_search_with_contour.no_contour = false
  l_18_0.interaction.computer_test = {}
  l_18_0.interaction.computer_test.icon = "develop"
  l_18_0.interaction.computer_test.text_id = "debug_interact_computer_test"
  l_18_0.interaction.computer_test.start_active = false
  l_18_0.interaction.carry_drop = {}
  l_18_0.interaction.carry_drop.icon = "develop"
  l_18_0.interaction.carry_drop.text_id = "hud_int_hold_grab_the_bag"
  l_18_0.interaction.carry_drop.sound_event = "ammo_bag_drop"
  l_18_0.interaction.carry_drop.timer = 1
  l_18_0.interaction.carry_drop.force_update_position = true
  l_18_0.interaction.carry_drop.action_text_id = "hud_action_grabbing_bag"
  l_18_0.interaction.carry_drop.blocked_hint = "carry_block"
  l_18_0.interaction.painting_carry_drop = {}
  l_18_0.interaction.painting_carry_drop.icon = "develop"
  l_18_0.interaction.painting_carry_drop.text_id = "hud_int_hold_grab_the_painting"
  l_18_0.interaction.painting_carry_drop.sound_event = "ammo_bag_drop"
  l_18_0.interaction.painting_carry_drop.timer = 1
  l_18_0.interaction.painting_carry_drop.force_update_position = true
  l_18_0.interaction.painting_carry_drop.action_text_id = "hud_action_grabbing_painting"
  l_18_0.interaction.painting_carry_drop.blocked_hint = "carry_block"
  l_18_0.interaction.corpse_alarm_pager = {}
  l_18_0.interaction.corpse_alarm_pager.icon = "develop"
  l_18_0.interaction.corpse_alarm_pager.text_id = "hud_int_disable_alarm_pager"
  l_18_0.interaction.corpse_alarm_pager.sound_event = "ammo_bag_drop"
  l_18_0.interaction.corpse_alarm_pager.timer = 10
  l_18_0.interaction.corpse_alarm_pager.force_update_position = true
  l_18_0.interaction.corpse_alarm_pager.action_text_id = "hud_action_disabling_alarm_pager"
  l_18_0.interaction.corpse_dispose = {}
  l_18_0.interaction.corpse_dispose.icon = "develop"
  l_18_0.interaction.corpse_dispose.text_id = "hud_int_dispose_corpse"
  l_18_0.interaction.corpse_dispose.sound_event = "ammo_bag_drop"
  l_18_0.interaction.corpse_dispose.timer = 2
  l_18_0.interaction.corpse_dispose.requires_upgrade = {category = "player", upgrade = "corpse_dispose"}
  l_18_0.interaction.corpse_dispose.action_text_id = "hud_action_disposing_corpse"
  l_18_0.interaction.shaped_sharge = {}
  l_18_0.interaction.shaped_sharge.icon = "equipment_c4"
  l_18_0.interaction.shaped_sharge.text_id = "hud_int_equipment_shaped_charge"
  l_18_0.interaction.shaped_sharge.contour = "interactable_icon"
  l_18_0.interaction.shaped_sharge.required_deployable = "trip_mine"
  l_18_0.interaction.shaped_sharge.deployable_consume = true
  l_18_0.interaction.shaped_sharge.timer = 4
  l_18_0.interaction.shaped_sharge.sound_start = "bar_c4_apply"
  l_18_0.interaction.shaped_sharge.sound_interupt = "bar_c4_apply_cancel"
  l_18_0.interaction.shaped_sharge.sound_done = "bar_c4_apply_finished"
  l_18_0.interaction.shaped_sharge.requires_upgrade = {category = "player", upgrade = "trip_mine_shaped_charge"}
  l_18_0.interaction.shaped_sharge.action_text_id = "hud_action_placing_shaped_charge"
  l_18_0.interaction.hostage_convert = {}
  l_18_0.interaction.hostage_convert.icon = "develop"
  l_18_0.interaction.hostage_convert.text_id = "hud_int_hostage_convert"
  l_18_0.interaction.hostage_convert.sound_event = "ammo_bag_drop"
  l_18_0.interaction.hostage_convert.blocked_hint = "convert_enemy_failed"
  l_18_0.interaction.hostage_convert.timer = 1.5
  l_18_0.interaction.hostage_convert.requires_upgrade = {category = "player", upgrade = "convert_enemies"}
  l_18_0.interaction.hostage_convert.upgrade_timer_multiplier = {category = "player", upgrade = "convert_enemies_interaction_speed_multiplier"}
  l_18_0.interaction.hostage_convert.action_text_id = "hud_action_converting_hostage"
  l_18_0.interaction.hostage_convert.no_contour = true
  l_18_0.interaction.break_open = {}
  l_18_0.interaction.break_open.icon = "develop"
  l_18_0.interaction.break_open.text_id = "hud_int_break_open"
  l_18_0.interaction.break_open.start_active = false
  l_18_0.interaction.cut_fence = {}
  l_18_0.interaction.cut_fence.text_id = "hud_int_hold_cut_fence"
  l_18_0.interaction.cut_fence.action_text_id = "hud_action_cutting_fence"
  l_18_0.interaction.cut_fence.contour = "interactable_icon"
  l_18_0.interaction.cut_fence.timer = 0.5
  l_18_0.interaction.cut_fence.start_active = true
  l_18_0.interaction.cut_fence.sound_start = "bar_cut_fence"
  l_18_0.interaction.cut_fence.sound_interupt = "bar_cut_fence_cancel"
  l_18_0.interaction.cut_fence.sound_done = "bar_cut_fence_finished"
  l_18_0.interaction.burning_money = {}
  l_18_0.interaction.burning_money.text_id = "hud_int_hold_ignite_money"
  l_18_0.interaction.burning_money.action_text_id = "hud_action_igniting_money"
  l_18_0.interaction.burning_money.timer = 2
  l_18_0.interaction.burning_money.start_active = false
  l_18_0.interaction.burning_money.interact_distance = 250
  l_18_0.interaction.hold_take_painting = {}
  l_18_0.interaction.hold_take_painting.text_id = "hud_int_hold_take_painting"
  l_18_0.interaction.hold_take_painting.action_text_id = "hud_action_taking_painting"
  l_18_0.interaction.hold_take_painting.start_active = false
  l_18_0.interaction.hold_take_painting.axis = "y"
  l_18_0.interaction.hold_take_painting.timer = 2
  l_18_0.interaction.hold_take_painting.sound_start = "bar_steal_painting"
  l_18_0.interaction.hold_take_painting.sound_interupt = "bar_steal_painting_cancel"
  l_18_0.interaction.hold_take_painting.sound_done = "bar_steal_painting_finished"
  l_18_0.interaction.hold_take_painting.blocked_hint = "carry_block"
  l_18_0.interaction.barricade_fence = deep_clone(l_18_0.interaction.stash_planks)
  l_18_0.interaction.barricade_fence.contour = "interactable_icon"
  l_18_0.interaction.barricade_fence.sound_start = "bar_barricade_fence"
  l_18_0.interaction.barricade_fence.sound_interupt = "bar_barricade_fence_cancel"
  l_18_0.interaction.barricade_fence.sound_done = "bar_barricade_fence_finished"
  l_18_0.interaction.hack_numpad = {}
  l_18_0.interaction.hack_numpad.text_id = "hud_int_hold_hack_numpad"
  l_18_0.interaction.hack_numpad.action_text_id = "hud_action_hacking_numpad"
  l_18_0.interaction.hack_numpad.start_active = false
  l_18_0.interaction.hack_numpad.timer = 15
  l_18_0.interaction.pickup_phone = {}
  l_18_0.interaction.pickup_phone.text_id = "hud_int_pickup_phone"
  l_18_0.interaction.pickup_phone.start_active = false
  l_18_0.interaction.pickup_tablet = deep_clone(l_18_0.interaction.pickup_phone)
  l_18_0.interaction.pickup_tablet.text_id = "hud_int_pickup_tablet"
  l_18_0.interaction.hold_take_server = {}
  l_18_0.interaction.hold_take_server.text_id = "hud_int_hold_take_server"
  l_18_0.interaction.hold_take_server.action_text_id = "hud_action_taking_server"
  l_18_0.interaction.hold_take_server.timer = 4
  l_18_0.interaction.hold_take_server.sound_start = "bar_steal_circuit"
  l_18_0.interaction.hold_take_server.sound_interupt = "bar_steal_circuit_cancel"
  l_18_0.interaction.hold_take_server.sound_done = "bar_steal_circuit_finished"
  l_18_0.interaction.hold_take_blueprints = {}
  l_18_0.interaction.hold_take_blueprints.text_id = "hud_int_hold_take_blueprints"
  l_18_0.interaction.hold_take_blueprints.action_text_id = "hud_action_taking_blueprints"
  l_18_0.interaction.hold_take_blueprints.start_active = false
  l_18_0.interaction.hold_take_blueprints.timer = 0.5
  l_18_0.interaction.hold_take_blueprints.sound_start = "bar_steal_painting"
  l_18_0.interaction.hold_take_blueprints.sound_interupt = "bar_steal_painting_cancel"
  l_18_0.interaction.hold_take_blueprints.sound_done = "bar_steal_painting_finished"
  l_18_0.interaction.take_confidential_folder = {}
  l_18_0.interaction.take_confidential_folder.text_id = "hud_int_take_confidential_folder"
  l_18_0.interaction.take_confidential_folder.start_active = false
  l_18_0.interaction.take_confidential_folder_event = {}
  l_18_0.interaction.take_confidential_folder_event.text_id = "hud_int_take_confidential_folder_event"
  l_18_0.interaction.take_confidential_folder_event.start_active = false
  l_18_0.interaction.hold_take_gas_can = {}
  l_18_0.interaction.hold_take_gas_can.text_id = "hud_int_hold_take_gas"
  l_18_0.interaction.hold_take_gas_can.action_text_id = "hud_action_taking_gasoline"
  l_18_0.interaction.hold_take_gas_can.start_active = false
  l_18_0.interaction.hold_take_gas_can.timer = 0.5
  l_18_0.interaction.hold_take_gas_can.special_equipment_block = "gas"
  l_18_0.interaction.gen_ladyjustice_statue = {}
  l_18_0.interaction.gen_ladyjustice_statue.text_id = "hud_int_ladyjustice_statue"
  l_18_0.interaction.hold_place_gps_tracker = {}
  l_18_0.interaction.hold_place_gps_tracker.text_id = "hud_int_hold_place_gps_tracker"
  l_18_0.interaction.hold_place_gps_tracker.action_text_id = "hud_action_placing_gps_tracker"
  l_18_0.interaction.hold_place_gps_tracker.start_active = false
  l_18_0.interaction.hold_place_gps_tracker.timer = 1.5
  l_18_0.interaction.hold_place_gps_tracker.force_update_position = true
  l_18_0.interaction.hold_place_gps_tracker.interact_distance = 300
  l_18_0.interaction.keyboard_no_time = deep_clone(l_18_0.interaction.security_station_keyboard)
  l_18_0.interaction.keyboard_no_time.timer = 2.5
  l_18_0.interaction.hold_use_computer = {}
  l_18_0.interaction.hold_use_computer.start_active = false
  l_18_0.interaction.hold_use_computer.text_id = "hud_int_hold_use_computer"
  l_18_0.interaction.hold_use_computer.action_text_id = "hud_action_using_computer"
  l_18_0.interaction.hold_use_computer.timer = 1
  l_18_0.interaction.hold_use_computer.axis = "z"
  l_18_0.interaction.hold_use_computer.interact_distance = 100
  l_18_0.interaction.use_server_device = {}
  l_18_0.interaction.use_server_device.text_id = "hud_int_hold_use_device"
  l_18_0.interaction.use_server_device.action_text_id = "hud_action_using_device"
  l_18_0.interaction.use_server_device.timer = 1
  l_18_0.interaction.use_server_device.start_active = false
  l_18_0.interaction.iphone_answer = {}
  l_18_0.interaction.iphone_answer.text_id = "hud_int_answer_phone"
  l_18_0.interaction.iphone_answer.start_active = false
  l_18_0.interaction.use_flare = {}
  l_18_0.interaction.use_flare.text_id = "hud_int_use_flare"
  l_18_0.interaction.use_flare.start_active = false
  l_18_0.interaction.steal_methbag = {}
  l_18_0.interaction.steal_methbag.text_id = "hud_int_hold_steal_meth"
  l_18_0.interaction.steal_methbag.action_text_id = "hud_action_stealing_meth"
  l_18_0.interaction.steal_methbag.start_active = true
  l_18_0.interaction.steal_methbag.timer = 3
  l_18_0.interaction.pickup_keycard = {}
  l_18_0.interaction.pickup_keycard.text_id = "hud_int_pickup_keycard"
  l_18_0.interaction.pickup_keycard.sound_event = "ammo_bag_drop"
  l_18_0.interaction.open_from_inside = {}
  l_18_0.interaction.open_from_inside.text_id = "hud_int_invisible_interaction_open"
  l_18_0.interaction.open_from_inside.start_active = true
  l_18_0.interaction.open_from_inside.interact_distance = 100
  l_18_0.interaction.open_from_inside.timer = 0.20000000298023
  l_18_0.interaction.open_from_inside.axis = "x"
  l_18_0.interaction.money_luggage = deep_clone(l_18_0.interaction.money_wrap)
  l_18_0.interaction.money_luggage.start_active = true
  l_18_0.interaction.money_luggage.axis = "x"
  l_18_0.interaction.hold_pickup_lance = {}
  l_18_0.interaction.hold_pickup_lance.text_id = "hud_int_hold_pickup_lance"
  l_18_0.interaction.hold_pickup_lance.action_text_id = "hud_action_grabbing_lance"
  l_18_0.interaction.hold_pickup_lance.sound_event = "ammo_bag_drop"
  l_18_0.interaction.hold_pickup_lance.timer = 1
  l_18_0.interaction.barrier_numpad = {}
  l_18_0.interaction.barrier_numpad.text_id = "hud_int_barrier_numpad"
  l_18_0.interaction.barrier_numpad.start_active = false
  l_18_0.interaction.barrier_numpad.axis = "z"
  l_18_0.interaction.pickup_asset = {}
  l_18_0.interaction.pickup_asset.text_id = "hud_int_pickup_asset"
  l_18_0.interaction.pickup_asset.sound_event = "ammo_bag_drop"
  l_18_0.interaction.open_slash_close = {}
  l_18_0.interaction.open_slash_close.text_id = "hud_int_open_slash_close"
  l_18_0.interaction.open_slash_close.start_active = false
  l_18_0.interaction.stn_int_place_camera = {}
  l_18_0.interaction.stn_int_place_camera.text_id = "hud_int_place_camera"
  l_18_0.interaction.stn_int_place_camera.start_active = true
  l_18_0.interaction.stn_int_take_camera = {}
  l_18_0.interaction.stn_int_take_camera.text_id = "hud_int_take_camera"
  l_18_0.interaction.stn_int_take_camera.start_active = true
  l_18_0.interaction.exit_to_crimenet = {}
  l_18_0.interaction.exit_to_crimenet.text_id = "hud_int_exit_to_crimenet"
  l_18_0.interaction.exit_to_crimenet.start_active = false
  l_18_0.interaction.exit_to_crimenet.timer = 0.5
  l_18_0.interaction.gen_pku_fusion_reactor = {}
  l_18_0.interaction.gen_pku_fusion_reactor.text_id = "hud_int_hold_take_reaktor"
  l_18_0.interaction.gen_pku_fusion_reactor.action_text_id = "hud_action_taking_reaktor"
  l_18_0.interaction.gen_pku_fusion_reactor.blocked_hint = "carry_block"
  l_18_0.interaction.gen_pku_fusion_reactor.start_active = false
  l_18_0.interaction.gen_pku_fusion_reactor.timer = 3
  l_18_0.interaction.gen_pku_fusion_reactor.no_contour = true
  l_18_0.interaction.gen_pku_fusion_reactor.sound_start = "bar_bag_money"
  l_18_0.interaction.gen_pku_fusion_reactor.sound_interupt = "bar_bag_money_cancel"
  l_18_0.interaction.gen_pku_fusion_reactor.sound_done = "bar_bag_money_finished"
  l_18_0.interaction.gen_pku_cocaine = {}
  l_18_0.interaction.gen_pku_cocaine.text_id = "hud_int_hold_take_cocaine"
  l_18_0.interaction.gen_pku_cocaine.action_text_id = "hud_action_taking_cocaine"
  l_18_0.interaction.gen_pku_cocaine.timer = 3
  l_18_0.interaction.gen_pku_cocaine.sound_start = "bar_bag_money"
  l_18_0.interaction.gen_pku_cocaine.sound_interupt = "bar_bag_money_cancel"
  l_18_0.interaction.gen_pku_cocaine.sound_done = "bar_bag_money_finished"
  l_18_0.interaction.gen_pku_cocaine.blocked_hint = "carry_block"
  l_18_0.interaction.gen_pku_jewelry = {}
  l_18_0.interaction.gen_pku_jewelry.text_id = "hud_int_hold_take_jewelry"
  l_18_0.interaction.gen_pku_jewelry.action_text_id = "hud_action_taking_jewelry"
  l_18_0.interaction.gen_pku_jewelry.timer = 3
  l_18_0.interaction.gen_pku_jewelry.sound_start = "bar_bag_jewelry"
  l_18_0.interaction.gen_pku_jewelry.sound_interupt = "bar_bag_jewelry_cancel"
  l_18_0.interaction.gen_pku_jewelry.sound_done = "bar_bag_jewelry_finished"
  l_18_0.interaction.gen_pku_jewelry.blocked_hint = "carry_block"
  l_18_0.interaction.taking_meth = {}
  l_18_0.interaction.taking_meth.text_id = "hud_int_hold_take_meth"
  l_18_0.interaction.taking_meth.action_text_id = "hud_action_taking_meth"
  l_18_0.interaction.taking_meth.timer = 3
  l_18_0.interaction.taking_meth.sound_start = "bar_bag_money"
  l_18_0.interaction.taking_meth.sound_interupt = "bar_bag_money_cancel"
  l_18_0.interaction.taking_meth.sound_done = "bar_bag_money_finished"
  l_18_0.interaction.taking_meth.blocked_hint = "carry_block"
  l_18_0.interaction.gen_pku_crowbar = {}
  l_18_0.interaction.gen_pku_crowbar.text_id = "hud_int_take_crowbar"
  l_18_0.interaction.gen_pku_crowbar.special_equipment_block = "crowbar"
  l_18_0.interaction.button_infopad = {}
  l_18_0.interaction.button_infopad.text_id = "hud_int_press_for_info"
  l_18_0.interaction.button_infopad.start_active = false
  l_18_0.interaction.button_infopad.axis = "z"
  if not l_18_0.gui then
    l_18_0.gui = {}
  end
  l_18_0.gui.BOOT_SCREEN_LAYER = 1
  l_18_0.gui.TITLE_SCREEN_LAYER = 1
  l_18_0.gui.MENU_LAYER = 200
  l_18_0.gui.MENU_COMPONENT_LAYER = 300
  l_18_0.gui.ATTRACT_SCREEN_LAYER = 400
  l_18_0.gui.LOADING_SCREEN_LAYER = 1000
  l_18_0.gui.DIALOG_LAYER = 1100
  l_18_0.gui.MOUSE_LAYER = 1200
  l_18_0.gui.SAVEFILE_LAYER = 1400
  l_18_0.overlay_effects = {}
  l_18_0.overlay_effects.spectator = {blend_mode = "normal", sustain = nil, fade_in = 3, fade_out = 2, color = Color(1, 0, 0, 0), timer = TimerManager:main(), play_paused = true}
  l_18_0.overlay_effects.level_fade_in = {blend_mode = "normal", sustain = 1, fade_in = 0, fade_out = 3, color = Color(1, 0, 0, 0), timer = TimerManager:game(), play_paused = true}
  l_18_0.overlay_effects.fade_in = {blend_mode = "normal", sustain = 0, fade_in = 0, fade_out = 3, color = Color(1, 0, 0, 0), timer = TimerManager:main(), play_paused = true}
  l_18_0.overlay_effects.fade_out = {blend_mode = "normal", sustain = 30, fade_in = 3, fade_out = 0, color = Color(1, 0, 0, 0), timer = TimerManager:main(), play_paused = true}
  l_18_0.overlay_effects.fade_out_permanent = {blend_mode = "normal", fade_in = 1, fade_out = 0, color = Color(1, 0, 0, 0), timer = TimerManager:main(), play_paused = true}
  l_18_0.overlay_effects.fade_out_in = {blend_mode = "normal", sustain = 1, fade_in = 1, fade_out = 1, color = Color(1, 0, 0, 0), timer = TimerManager:main(), play_paused = true}
  l_18_0.overlay_effects.element_fade_in = {blend_mode = "normal", sustain = 0, fade_in = 0, fade_out = 3, color = Color(1, 0, 0, 0), timer = TimerManager:main(), play_paused = true}
  l_18_0.overlay_effects.element_fade_out = {blend_mode = "normal", sustain = 0, fade_in = 3, fade_out = 0, color = Color(1, 0, 0, 0), timer = TimerManager:main(), play_paused = true}
  local d_color = Color(0.75, 1, 1, 1)
  local d_sustain = 0.10000000149012
  local d_fade_out = 0.89999997615814
  l_18_0.overlay_effects.damage = {blend_mode = "add", sustain = d_sustain, fade_in = 0, fade_out = d_fade_out, color = d_color}
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

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  l_18_0.experience_manager.level_limit.pc_difference_multipliers, l_18_0.experience_manager.level_limit.low_cap_multiplier, l_18_0.experience_manager.level_limit.low_cap_level, l_18_0.experience_manager.level_limit, l_18_0.experience_manager.alive_humans_multiplier, l_18_0.experience_manager.difficulty_multiplier, l_18_0.experience_manager.stage_failed_multiplier, l_18_0.experience_manager.job_completion, l_18_0.experience_manager.stage_completion, l_18_0.experience_manager.values.size20, l_18_0.experience_manager.values.size18, l_18_0.experience_manager.values.size16, l_18_0.experience_manager.values.size14, l_18_0.experience_manager.values.size12, l_18_0.experience_manager.values.size10, l_18_0.experience_manager.values.size08, l_18_0.experience_manager.values.size06, l_18_0.experience_manager.values.size04, l_18_0.experience_manager.values.size03, l_18_0.experience_manager.values.size02, l_18_0.experience_manager.values, l_18_0.experience_manager, l_18_0.screen.fadein_delay, l_18_0.screen, l_18_0.materials[Idstring("heavy_swat_steel_no_decal"):key()], l_18_0.materials[Idstring("shield"):key()], l_18_0.materials[Idstring("water_shallow"):key()], l_18_0.materials[Idstring("water_puddle"):key()], l_18_0.materials[Idstring("water_deep"):key()], l_18_0.materials[Idstring("tile"):key()], l_18_0.materials[Idstring("steel_no_decal"):key()], l_18_0.materials[Idstring("steel"):key()], l_18_0.materials[Idstring("fence"):key()], l_18_0.materials[Idstring("hardwood"):key()], l_18_0.materials[Idstring("metal_catwalk"):key()], l_18_0.materials[Idstring("metal_chassis"):key()], l_18_0.materials[Idstring("metal_hollow"):key()], l_18_0.materials[Idstring("paper"):key()], l_18_0.materials[Idstring("no_material"):key()], l_18_0.materials[Idstring("plaster"):key()], l_18_0.materials[Idstring("no_decal"):key()], l_18_0.materials[Idstring("thin_layer"):key()], l_18_0.materials[Idstring("sand"):key()], l_18_0.materials[Idstring("stone"):key()], l_18_0.materials[Idstring("foliage"):key()], l_18_0.materials[Idstring("asphalt"):key()], l_18_0.materials[Idstring("plastic"):key()], l_18_0.materials[Idstring("rubber"):key()], l_18_0.materials[Idstring("glass_no_decal"):key()], l_18_0.materials[Idstring("glass_unbreakable"):key()], l_18_0.materials[Idstring("glass_breakable"):key()], l_18_0.materials[Idstring("metal"):key()], l_18_0.materials[Idstring("carpet"):key()], l_18_0.materials[Idstring("grass"):key()], l_18_0.materials[Idstring("dirt"):key()], l_18_0.materials[Idstring("cloth_stuffed"):key()], l_18_0.materials[Idstring("cloth_no_decal"):key()], l_18_0.materials[Idstring("cloth"):key()], l_18_0.materials[Idstring("gravel"):key()], l_18_0.materials[Idstring("wood"):key()], l_18_0.materials[Idstring("iron"):key()], l_18_0.materials[Idstring("sheet_metal"):key()], l_18_0.materials[Idstring("parket"):key()], l_18_0.materials[Idstring("flesh"):key()], l_18_0.materials[Idstring("marble"):key()], l_18_0.materials[Idstring("ceramic"):key()], l_18_0.materials[Idstring("concrete"):key()], l_18_0.materials, l_18_0.overlay_effects.maingun_zoomed, l_18_0.overlay_effects.damage_down, l_18_0.overlay_effects.damage_up, l_18_0.overlay_effects.damage_right, l_18_0.overlay_effects.damage_left = {1, 0.89999997615814, 0.72000002861023, 0.50400000810623, 0.30239999294281, 0.15119999647141, 0.060479998588562, Color():with_alpha(0)()[Color():with_alpha(0)](1, 0)()[Color():with_alpha(0)](0, 0)()[Color():with_alpha(0)](1, 0), 0, Color():with_alpha(0)}, 0.75, -1, {}, {1, 1.1000000238419, 1.2000000476837, 1.2999999523163}, {2, 4, 8}, 0.15000000596046, {750, 1000, 1500, 2000, 2500, 3000, 4000}, {200, 250, 300, 350, 425, 475, 0.15000000596046}, 1000, 500, 250, 150, 100, 80, 40, 25, 15, 10, 0, {}, {}, 1, {}, "shield", "shield", "water_shallow", "water_puddle", "water_deep", "tile", "steel", "steel", "fence", "hardwood", "metal_catwalk", "metal_chassis", "metal_hollow", "paper", "no_material", "plaster", "silent_material", "thin_layer", "sand", "stone", "foliage", "asphalt", "plastic", "rubber", "glass_unbreakable", "glass_unbreakable", "glass_breakable", "metal", "carpet", "grass", "dirt", "cloth_stuffed", "cloth", "cloth", "gravel", "wood", "iron", "sheet_metal", "parket", "flesh", "marble", "ceramic", "concrete", {}, {blend_mode = "add", sustain = 0, fade_in = 0, fade_out = 0.40000000596046, color = Color(0, d_color, 0.10000000149012, d_color)}, {blend_mode = "add", sustain = d_sustain, fade_in = 0, fade_out = d_fade_out, color = d_color, gradient_points = {}, orientation = "vertical"}, {blend_mode = "add", sustain = d_sustain, fade_in = 0, fade_out = d_fade_out, color = d_color, gradient_points = {}, orientation = "vertical"}, {blend_mode = "add", sustain = d_sustain, fade_in = 0, fade_out = d_fade_out, color = d_color, gradient_points = {}, orientation = "horizontal"}, {blend_mode = "add", sustain = d_sustain, fade_in = 0, fade_out = d_fade_out, color = d_color, gradient_points = {}, orientation = "horizontal"}
  l_18_0.experience_manager.civilians_killed = 0
  l_18_0.experience_manager.day_multiplier = {1, 1.1000000238419, 1.2000000476837, 1.2999999523163, 1.3999999761581, 1.5, 1.6000000238419}
  l_18_0.experience_manager.pro_day_multiplier = {1, 1.5, 2, 2.5, 3, 3.5, 4}
  l_18_0.experience_manager.total_level_objectives = 500
  l_18_0.experience_manager.total_criminals_finished = 50
  l_18_0.experience_manager.total_objectives_finished = 500
  local multiplier = 1
  l_18_0.experience_manager.levels = {}
  l_18_0.experience_manager.levels[1] = {points = 900 * multiplier}
  l_18_0.experience_manager.levels[2] = {points = 1250 * multiplier}
  l_18_0.experience_manager.levels[3] = {points = 1550 * multiplier}
  l_18_0.experience_manager.levels[4] = {points = 1850 * multiplier}
  l_18_0.experience_manager.levels[5] = {points = 2200 * multiplier}
  l_18_0.experience_manager.levels[6] = {points = 2600 * multiplier}
  l_18_0.experience_manager.levels[7] = {points = 3000 * multiplier}
  l_18_0.experience_manager.levels[8] = {points = 3500 * multiplier}
  l_18_0.experience_manager.levels[9] = {points = 4000 * multiplier}
  local exp_step_start = 10
  local exp_step_end = 100
  local exp_step = 1 / (exp_step_end - exp_step_start)
  local exp_step_last_points = 4600
  local exp_step_curve = 3
  for i = exp_step_start, exp_step_end do
    l_18_0.experience_manager.levels[i] = {points = math.round((1000000 - exp_step_last_points) * math.pow(exp_step * (i - exp_step_start), exp_step_curve) + exp_step_last_points) * multiplier}
  end
  local exp_step_start = 5
  local exp_step_end = 193
  local exp_step = 1 / (exp_step_end - exp_step_start)
  for i = 146, exp_step_end do
    l_18_0.experience_manager.levels[i] = {points = math.round(22000 * (exp_step * (i - exp_step_start)) - 6000) * multiplier}
  end
  l_18_0.achievement = {}
  l_18_0.achievement.im_a_healer_tank_damage_dealer = 10
  l_18_0.achievement.iron_man = "level_7"
  l_18_0.achievement.going_places = 1000000
  l_18_0.achievement.spend_money_to_make_money = 1000000
  l_18_0.achievement.you_gotta_start_somewhere = 5
  l_18_0.achievement.guilty_of_crime = 10
  l_18_0.achievement.gone_in_30_seconds = 25
  l_18_0.achievement.armed_and_dangerous = 50
  l_18_0.achievement.big_shot = 75
  l_18_0.achievement.most_wanted = 100
  l_18_0.achievement.fully_loaded = 9
  l_18_0.achievement.weapon_collector = 18
  l_18_0.achievement.how_do_you_like_me_now = "level_1"
  l_18_0.pickups = {}
  l_18_0.pickups.ammo = {unit = Idstring("units/pickups/ammo/ammo_pickup")}
  l_18_0.pickups.bank_manager_key = {unit = Idstring("units/pickups/pickup_bank_manager_key/pickup_bank_manager_key")}
  l_18_0.pickups.chavez_key = {unit = Idstring("units/pickups/pickup_chavez_key/pickup_chavez_key")}
  l_18_0.pickups.drill = {unit = Idstring("units/pickups/pickup_drill/pickup_drill")}
  l_18_0.pickups.keycard = {unit = Idstring("units/payday2/pickups/gen_pku_keycard/gen_pku_keycard")}
  l_18_0.danger_zones = {0.60000002384186, 0.5, 0.34999999403954, 0.10000000149012}
  l_18_0.contour = {}
  l_18_0.contour.character = {}
  l_18_0.contour.character.standard_color = Vector3(0.10000000149012, 1, 0.5)
  l_18_0.contour.character.friendly_color = Vector3(0.20000000298023, 0.80000001192093, 1)
  l_18_0.contour.character.downed_color = Vector3(1, 0.5, 0)
  l_18_0.contour.character.dead_color = Vector3(1, 0.10000000149012, 0.10000000149012)
  l_18_0.contour.character.dangerous_color = Vector3(0.60000002384186, 0.20000000298023, 0.20000000298023)
  l_18_0.contour.character.more_dangerous_color = Vector3(1, 0.10000000149012, 0.10000000149012)
  l_18_0.contour.character.standard_opacity = 0
  l_18_0.contour.character_interactable = {}
  l_18_0.contour.character_interactable.standard_color = Vector3(1, 0.5, 0)
  l_18_0.contour.character_interactable.selected_color = Vector3(1, 1, 1)
  l_18_0.contour.interactable = {}
  l_18_0.contour.interactable.standard_color = Vector3(1, 0.5, 0)
  l_18_0.contour.interactable.selected_color = Vector3(1, 1, 1)
  l_18_0.contour.deployable = {}
  l_18_0.contour.deployable.standard_color = Vector3(0.10000000149012, 1, 0.5)
  l_18_0.contour.deployable.selected_color = Vector3(1, 1, 1)
  l_18_0.contour.pickup = {}
  l_18_0.contour.pickup.standard_color = Vector3(0.10000000149012, 1, 0.5)
  l_18_0.contour.pickup.selected_color = Vector3(1, 1, 1)
  l_18_0.contour.pickup.standard_opacity = 1
  l_18_0.contour.interactable_icon = {}
  l_18_0.contour.interactable_icon.standard_color = Vector3(0, 0, 0)
  l_18_0.contour.interactable_icon.selected_color = Vector3(0, 1, 0)
  l_18_0.contour.interactable_icon.standard_opacity = 0
  l_18_0.music = {}
  l_18_0.music.hit = {}
  l_18_0.music.hit.intro = "music_hit_setup"
  l_18_0.music.hit.anticipation = "music_hit_anticipation"
  l_18_0.music.hit.assault = "music_hit_assault"
  l_18_0.music.hit.fake_assault = "music_hit_assault"
  l_18_0.music.hit.control = "music_hit_control"
  l_18_0.music.stress = {}
  l_18_0.music.stress.intro = "music_stress_setup"
  l_18_0.music.stress.anticipation = "music_stress_anticipation"
  l_18_0.music.stress.assault = "music_stress_assault"
  l_18_0.music.stress.fake_assault = "music_stress_assault"
  l_18_0.music.stress.control = "music_stress_control"
  l_18_0.music.stealth = {}
  l_18_0.music.stealth.intro = "music_stealth_setup"
  l_18_0.music.stealth.anticipation = "music_stealth_anticipation"
  l_18_0.music.stealth.assault = "music_stealth_assault"
  l_18_0.music.stealth.fake_assault = "music_stealth_assault"
  l_18_0.music.stealth.control = "music_stealth_control"
  l_18_0.music.heist = {}
  l_18_0.music.heist.intro = "music_heist_setup"
  l_18_0.music.heist.anticipation = "music_heist_anticipation"
  l_18_0.music.heist.assault = "music_heist_assault"
  l_18_0.music.heist.fake_assault = "music_heist_assault"
  l_18_0.music.heist.control = "music_heist_control"
  l_18_0.music.heist.switches = {"track_01", "track_02", "track_03", "track_04", "track_05", "track_06", "track_07"}
  l_18_0.music.default = deep_clone(l_18_0.music.heist)
  l_18_0.blame = {}
  l_18_0.blame.default = "hint_blame_missing"
  l_18_0.blame.empty = nil
  l_18_0.blame.cam_criminal = "hint_cam_criminal"
  l_18_0.blame.cam_dead_body = "hint_cam_dead_body"
  l_18_0.blame.cam_hostage = "hint_cam_hostage"
  l_18_0.blame.cam_distress = "hint_cam_distress"
  l_18_0.blame.cam_body_bag = "hint_body_bag"
  l_18_0.blame.cam_gunfire = "hint_gunfire"
  l_18_0.blame.cam_drill = "hint_cam_drill"
  l_18_0.blame.cam_saw = "hint_cam_saw"
  l_18_0.blame.cam_sentry_gun = "hint_sentry_gun"
  l_18_0.blame.cam_trip_mine = "hint_trip_mine"
  l_18_0.blame.cam_ecm_jammer = "hint_ecm_jammer"
  l_18_0.blame.cam_c4 = "hint_c4"
  l_18_0.blame.cam_computer = "hint_computer"
  l_18_0.blame.cam_glass = "hint_glass"
  l_18_0.blame.cam_broken_cam = "hint_cam_broken_cam"
  l_18_0.blame.cam_vault = "hint_vault"
  l_18_0.blame.cam_fire = "hint_fire"
  l_18_0.blame.cam_voting = "hint_voting"
  l_18_0.blame.cam_breaking_entering = "hint_breaking_entering"
  l_18_0.blame.civ_criminal = "hint_civ_criminal"
  l_18_0.blame.civ_dead_body = "hint_civ_dead_body"
  l_18_0.blame.civ_hostage = "hint_civ_hostage"
  l_18_0.blame.civ_distress = "hint_civ_distress"
  l_18_0.blame.civ_body_bag = "hint_civ_body_bag"
  l_18_0.blame.civ_gunfire = "hint_civ_gunfire"
  l_18_0.blame.civ_drill = "hint_civ_drill"
  l_18_0.blame.civ_saw = "hint_civ_saw"
  l_18_0.blame.civ_sentry_gun = "hint_civ_sentry_gun"
  l_18_0.blame.civ_trip_mine = "hint_civ_trip_mine"
  l_18_0.blame.civ_ecm_jammer = "hint_civ_ecm_jammer"
  l_18_0.blame.civ_c4 = "hint_civ_c4"
  l_18_0.blame.civ_computer = "hint_civ_computer"
  l_18_0.blame.civ_glass = "hint_civ_glass"
  l_18_0.blame.civ_broken_cam = "hint_civ_broken_cam"
  l_18_0.blame.civ_vault = "hint_civ_vault"
  l_18_0.blame.civ_fire = "hint_civ_fire"
  l_18_0.blame.civ_voting = "hint_civ_voting"
  l_18_0.blame.civ_breaking_entering = "hint_civ_breaking_entering"
  l_18_0.blame.cop_criminal = "hint_cop_criminal"
  l_18_0.blame.cop_dead_body = "hint_cop_dead_body"
  l_18_0.blame.cop_hostage = "hint_cop_hostage"
  l_18_0.blame.cop_distress = "hint_cop_distress"
  l_18_0.blame.cop_body_bag = "hint_cop_body_bag"
  l_18_0.blame.cop_gunfire = "hint_cop_gunfire"
  l_18_0.blame.cop_drill = "hint_cop_drill"
  l_18_0.blame.cop_saw = "hint_cop_saw"
  l_18_0.blame.cop_sentry_gun = "hint_cop_sentry_gun"
  l_18_0.blame.cop_trip_mine = "hint_cop_trip_mine"
  l_18_0.blame.cop_ecm_jammer = "hint_cop_ecm_jammer"
  l_18_0.blame.cop_c4 = "hint_cop_c4"
  l_18_0.blame.cop_computer = "hint_cop_computer"
  l_18_0.blame.cop_glass = "hint_cop_glass"
  l_18_0.blame.cop_broken_cam = "hint_cop_broken_cam"
  l_18_0.blame.cop_vault = "hint_cop_vault"
  l_18_0.blame.cop_fire = "hint_cop_fire"
  l_18_0.blame.cop_voting = "hint_cop_voting"
  l_18_0.blame.cop_breaking_entering = "hint_cop_breaking_entering"
  l_18_0.blame.met_criminal = "hint_met_criminal"
  l_18_0.blame.mot_criminal = "hint_mot_criminal"
  l_18_0.blame.alarm_pager_bluff_failed = "hint_alarm_pager_bluff_failed"
  l_18_0.blame.alarm_pager_not_answered = "hint_alarm_pager_not_answered"
  l_18_0.blame.alarm_pager_hang_up = "hint_alarm_pager_hang_up"
  l_18_0.blame.civ_alarm = "hint_alarm_civ"
  l_18_0.blame.cop_alarm = "hint_alarm_cop"
  l_18_0.blame.gan_alarm = "hint_alarm_cop"
  l_18_0:set_difficulty()
  l_18_0:digest_tweak_data()
end

TweakData._execute_reload_clbks = function(l_19_0)
  if l_19_0._reload_clbks then
    for key,clbk_data in pairs(l_19_0._reload_clbks) do
      if clbk_data.func then
        clbk_data.func(clbk_data.clbk_object)
      end
    end
  end
end

TweakData.add_reload_callback = function(l_20_0, l_20_1, l_20_2)
  if not l_20_0._reload_clbks then
    l_20_0._reload_clbks = {}
  end
  table.insert(l_20_0._reload_clbks, {clbk_object = l_20_1, func = l_20_2})
end

TweakData.remove_reload_callback = function(l_21_0, l_21_1)
  if l_21_0._reload_clbks then
    for i,k in ipairs(l_21_0._reload_clbks) do
      if k.clbk_object == l_21_1 then
        table.remove(l_21_0._reload_clbks, i)
        return 
      end
    end
  end
end

TweakData.set_scale = function(l_22_0)
  local lang_key = SystemInfo:language():key()
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local lang_mods = {Idstring("german"):key() = {large = 0.89999997615814, small = 1, sd_large = 0.89999997615814, sd_small = 0.89999997615814, sd_menu_border_multiplier = 0.89999997615814, stats_upgrade_kern = -1, level_up_text_kern = -1.5, objectives_text_kern = -1}}
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  lang_mods[Idstring("french"):key()], {large = 0.89999997615814, small = 1, sd_large = 0.89999997615814, sd_small = 0.94999998807907, victory_screen_kern = -0.5, objectives_text_kern = -0.80000001192093, level_up_text_kern = -1.5, sd_level_up_font_multiplier = 0.89999997615814, stats_upgrade_kern = -1, kit_desc_large = 0.89999997615814}.subtitle_multiplier, {large = 0.89999997615814, small = 1, sd_large = 0.89999997615814, sd_small = 0.94999998807907, victory_screen_kern = -0.5, objectives_text_kern = -0.80000001192093, level_up_text_kern = -1.5, sd_level_up_font_multiplier = 0.89999997615814, stats_upgrade_kern = -1, kit_desc_large = 0.89999997615814}.w_interact_multiplier, {large = 0.89999997615814, small = 1, sd_large = 0.89999997615814, sd_small = 0.94999998807907, victory_screen_kern = -0.5, objectives_text_kern = -0.80000001192093, level_up_text_kern = -1.5, sd_level_up_font_multiplier = 0.89999997615814, stats_upgrade_kern = -1, kit_desc_large = 0.89999997615814}.sd_w_interact_multiplier, {large = 0.89999997615814, small = 1, sd_large = 0.89999997615814, sd_small = 0.89999997615814, sd_menu_border_multiplier = 0.89999997615814, stats_upgrade_kern = -1, level_up_text_kern = -1.5, objectives_text_kern = -1}.w_interact_multiplier, {large = 0.89999997615814, small = 1, sd_large = 0.89999997615814, sd_small = 0.89999997615814, sd_menu_border_multiplier = 0.89999997615814, stats_upgrade_kern = -1, level_up_text_kern = -1.5, objectives_text_kern = -1}.sd_w_interact_multiplier, {large = 0.89999997615814, small = 1, sd_large = 0.89999997615814, sd_small = 0.89999997615814, sd_menu_border_multiplier = 0.89999997615814, stats_upgrade_kern = -1, level_up_text_kern = -1.5, objectives_text_kern = -1}.kit_desc_large, {large = 0.89999997615814, small = 1, sd_large = 0.89999997615814, sd_small = 0.89999997615814, sd_menu_border_multiplier = 0.89999997615814, stats_upgrade_kern = -1, level_up_text_kern = -1.5, objectives_text_kern = -1}.menu_logo_multiplier = {large = 0.89999997615814, small = 1, sd_large = 0.89999997615814, sd_small = 0.94999998807907, victory_screen_kern = -0.5, objectives_text_kern = -0.80000001192093, level_up_text_kern = -1.5, sd_level_up_font_multiplier = 0.89999997615814, stats_upgrade_kern = -1, kit_desc_large = 0.89999997615814}, 0.85000002384186, 1.3999999761581, 1.2999999523163, 1.6499999761581, 1.5499999523163, 0.89999997615814, 0.89999997615814
  lang_mods[Idstring("italian"):key()] = {large = 1, small = 1, sd_large = 1, sd_small = 1, objectives_text_kern = -0.80000001192093, kit_desc_large = 0.89999997615814, sd_w_interact_multiplier = 1.5, w_interact_multiplier = 1.3500000238419}
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  lang_mods[Idstring("spanish"):key()], {large = 1, small = 1, sd_large = 1, sd_small = 0.89999997615814}.victory_title_multiplier, {large = 1, small = 1, sd_large = 1, sd_small = 0.89999997615814}.server_list_font_multiplier, {large = 1, small = 1, sd_large = 1, sd_small = 0.89999997615814}.w_interact_multiplier, {large = 1, small = 1, sd_large = 1, sd_small = 0.89999997615814}.sd_w_interact_multiplier, {large = 1, small = 1, sd_large = 1, sd_small = 0.89999997615814}.kit_desc_large, {large = 1, small = 1, sd_large = 1, sd_small = 0.89999997615814}.sd_level_up_font_multiplier, {large = 1, small = 1, sd_large = 1, sd_small = 0.89999997615814}.level_up_text_kern, {large = 1, small = 1, sd_large = 1, sd_small = 0.89999997615814}.objectives_desc_text_kern, {large = 1, small = 1, sd_large = 1, sd_small = 0.89999997615814}.objectives_text_kern, {large = 1, small = 1, sd_large = 1, sd_small = 0.89999997615814}.menu_logo_multiplier, {large = 1, small = 1, sd_large = 1, sd_small = 0.89999997615814}.level_up_text_kern, {large = 1, small = 1, sd_large = 1, sd_small = 0.89999997615814}.upgrade_menu_kern, {large = 1, small = 1, sd_large = 1, sd_small = 0.89999997615814}.stats_upgrade_kern, {large = 1, small = 1, sd_large = 1, sd_small = 0.89999997615814}.sd_menu_border_multiplier = {large = 1, small = 1, sd_large = 1, sd_small = 0.89999997615814}, 0.89999997615814, 0.89999997615814, 1.6000000238419, 1.5, 0.89999997615814, 0.89999997615814, -1.5, 0, -0.80000001192093, 0.89999997615814, -1.5, -1.25, -1, 0.85000002384186
  local lang_l_mod = lang_mods[lang_key] and lang_mods[lang_key].large or 1
  local lang_s_mod = lang_mods[lang_key] and lang_mods[lang_key].small or 1
  local lang_lsd_mod = lang_mods[lang_key] and lang_mods[lang_key].sd_large or 1
  local lang_ssd_mod = lang_mods[lang_key] and lang_mods[lang_key].sd_large or 1
  local sd_menu_border_multiplier = lang_mods[lang_key] and lang_mods[lang_key].sd_menu_border_multiplier or 1
  local stats_upgrade_kern = lang_mods[lang_key] and lang_mods[lang_key].stats_upgrade_kern or 0
  local level_up_text_kern = lang_mods[lang_key] and lang_mods[lang_key].level_up_text_kern or 0
  if lang_mods[lang_key] then
    local victory_screen_kern = lang_mods[lang_key].victory_screen_kern
  end
  if lang_mods[lang_key] then
    local upgrade_menu_kern = lang_mods[lang_key].upgrade_menu_kern
  end
  if lang_mods[lang_key] then
    local mugshot_name_kern = lang_mods[lang_key].mugshot_name_kern
  end
  local menu_logo_multiplier = lang_mods[lang_key] and lang_mods[lang_key].menu_logo_multiplier or 1
  if lang_mods[lang_key] then
    local objectives_text_kern = lang_mods[lang_key].objectives_text_kern
  end
  if lang_mods[lang_key] then
    local objectives_desc_text_kern = lang_mods[lang_key].objectives_desc_text_kern
  end
  local kit_desc_large = lang_mods[lang_key] and lang_mods[lang_key].kit_desc_large or 1
  local sd_level_up_font_multiplier = lang_mods[lang_key] and lang_mods[lang_key].sd_level_up_font_multiplier or 1
  local sd_w_interact_multiplier = lang_mods[lang_key] and lang_mods[lang_key].sd_w_interact_multiplier or 1
  local w_interact_multiplier = lang_mods[lang_key] and lang_mods[lang_key].w_interact_multiplier or 1
  local server_list_font_multiplier = lang_mods[lang_key] and lang_mods[lang_key].server_list_font_multiplier or 1
  if lang_mods[lang_key] then
    local victory_title_multiplier = lang_mods[lang_key].victory_title_multiplier
  end
  local subtitle_multiplier = lang_mods[lang_key] and lang_mods[lang_key].subtitle_multiplier or 1
  local res = RenderSettings.resolution
  l_22_0.sd_scale = {}
  l_22_0.sd_scale.is_sd = true
  l_22_0.sd_scale.title_image_multiplier = 0.60000002384186
  l_22_0.sd_scale.menu_logo_multiplier = 0.57499998807907 * menu_logo_multiplier
  l_22_0.sd_scale.menu_border_multiplier = 0.60000002384186 * sd_menu_border_multiplier
  l_22_0.sd_scale.default_font_multiplier = 0.60000002384186 * lang_lsd_mod
  l_22_0.sd_scale.small_font_multiplier = 0.80000001192093 * lang_ssd_mod
  l_22_0.sd_scale.lobby_info_font_size_scale_multiplier = 0.64999997615814
  l_22_0.sd_scale.lobby_name_font_size_scale_multiplier = 0.60000002384186
  l_22_0.sd_scale.server_list_font_size_multiplier = 0.55000001192093
  l_22_0.sd_scale.multichoice_arrow_multiplier = 0.69999998807907
  l_22_0.sd_scale.align_line_padding_multiplier = 0.40000000596046
  l_22_0.sd_scale.menu_arrow_padding_multiplier = 0.5
  l_22_0.sd_scale.briefing_text_h_multiplier = 0.5
  l_22_0.sd_scale.experience_bar_multiplier = 0.82499998807907
  l_22_0.sd_scale.hud_equipment_icon_multiplier = 0.64999997615814
  l_22_0.sd_scale.hud_default_font_multiplier = 0.69999998807907
  l_22_0.sd_scale.hud_ammo_clip_multiplier = 0.75
  l_22_0.sd_scale.hud_ammo_clip_large_multiplier = 0.5
  l_22_0.sd_scale.hud_health_multiplier = 0.75
  l_22_0.sd_scale.hud_mugshot_multiplier = 0.75
  l_22_0.sd_scale.hud_assault_image_multiplier = 0.5
  l_22_0.sd_scale.hud_crosshair_offset_multiplier = 0.75
  l_22_0.sd_scale.hud_objectives_pad_multiplier = 0.64999997615814
  l_22_0.sd_scale.experience_upgrade_multiplier = 0.75
  l_22_0.sd_scale.level_up_multiplier = 0.69999998807907
  l_22_0.sd_scale.next_upgrade_font_multiplier = 0.75
  l_22_0.sd_scale.level_up_font_multiplier = 0.50999999046326 * sd_level_up_font_multiplier
  l_22_0.sd_scale.present_multiplier = 0.75
  l_22_0.sd_scale.lobby_info_offset_multiplier = 0.69999998807907
  l_22_0.sd_scale.info_padding_multiplier = 0.40000000596046
  l_22_0.sd_scale.loading_challenge_bar_scale = 0.80000001192093
  l_22_0.sd_scale.kit_menu_bar_scale = 0.64999997615814
  l_22_0.sd_scale.kit_menu_description_h_scale = 1.2200000286102
  l_22_0.sd_scale.button_layout_multiplier = 0.69999998807907
  l_22_0.sd_scale.subtitle_pos_multiplier = 0.69999998807907
  l_22_0.sd_scale.subtitle_font_multiplier = 0.64999997615814
  l_22_0.sd_scale.subtitle_lang_multiplier = subtitle_multiplier
  l_22_0.sd_scale.default_font_kern = 0
  l_22_0.sd_scale.stats_upgrade_kern = stats_upgrade_kern or 0
  l_22_0.sd_scale.level_up_text_kern = level_up_text_kern or 0
  l_22_0.sd_scale.victory_screen_kern = victory_screen_kern or -0.5
  l_22_0.sd_scale.upgrade_menu_kern = upgrade_menu_kern or 0
  l_22_0.sd_scale.mugshot_name_kern = mugshot_name_kern or -1
  l_22_0.sd_scale.objectives_text_kern = objectives_text_kern or 0
  l_22_0.sd_scale.objectives_desc_text_kern = objectives_desc_text_kern or 0
  l_22_0.sd_scale.kit_description_multiplier = 0.80000001192093 * lang_ssd_mod
  l_22_0.sd_scale.chat_multiplier = 0.68000000715256
  l_22_0.sd_scale.chat_menu_h_multiplier = 0.34000000357628
  l_22_0.sd_scale.w_interact_multiplier = 0.80000001192093 * sd_w_interact_multiplier
  l_22_0.sd_scale.victory_title_multiplier = victory_title_multiplier and victory_title_multiplier * 0.94999998807907 or 1
  l_22_0.scale = {}
  l_22_0.scale.is_sd = false
  l_22_0.scale.title_image_multiplier = 1
  l_22_0.scale.menu_logo_multiplier = 1
  l_22_0.scale.menu_border_multiplier = 1
  l_22_0.scale.default_font_multiplier = 1 * lang_l_mod
  l_22_0.scale.small_font_multiplier = 1 * lang_s_mod
  l_22_0.scale.lobby_info_font_size_scale_multiplier = 1 * lang_l_mod
  l_22_0.scale.lobby_name_font_size_scale_multiplier = 1 * lang_l_mod
  l_22_0.scale.server_list_font_size_multiplier = 1 * lang_l_mod * server_list_font_multiplier
  l_22_0.scale.multichoice_arrow_multiplier = 1
  l_22_0.scale.align_line_padding_multiplier = 1
  l_22_0.scale.menu_arrow_padding_multiplier = 1
  l_22_0.scale.briefing_text_h_multiplier = 1 * lang_s_mod
  l_22_0.scale.experience_bar_multiplier = 1
  l_22_0.scale.hud_equipment_icon_multiplier = 1
  l_22_0.scale.hud_default_font_multiplier = 1 * lang_l_mod
  l_22_0.scale.hud_ammo_clip_multiplier = 1
  l_22_0.scale.hud_health_multiplier = 1
  l_22_0.scale.hud_mugshot_multiplier = 1
  l_22_0.scale.hud_assault_image_multiplier = 1
  l_22_0.scale.hud_crosshair_offset_multiplier = 1
  l_22_0.scale.hud_objectives_pad_multiplier = 1
  l_22_0.scale.experience_upgrade_multiplier = 1
  l_22_0.scale.level_up_multiplier = 1
  l_22_0.scale.next_upgrade_font_multiplier = 1 * lang_l_mod
  l_22_0.scale.level_up_font_multiplier = 1 * lang_l_mod
  l_22_0.scale.present_multiplier = 1
  l_22_0.scale.lobby_info_offset_multiplier = 1
  l_22_0.scale.info_padding_multiplier = 1
  l_22_0.scale.loading_challenge_bar_scale = 1
  l_22_0.scale.kit_menu_bar_scale = 1
  l_22_0.scale.kit_menu_description_h_scale = 1
  l_22_0.scale.button_layout_multiplier = 1
  l_22_0.scale.subtitle_pos_multiplier = 1
  l_22_0.scale.subtitle_font_multiplier = 1 * lang_l_mod
  l_22_0.scale.subtitle_lang_multiplier = subtitle_multiplier
  l_22_0.scale.default_font_kern = 0
  l_22_0.scale.stats_upgrade_kern = stats_upgrade_kern or 0
  l_22_0.scale.level_up_text_kern = 0
  l_22_0.scale.victory_screen_kern = victory_screen_kern or 0
  l_22_0.scale.upgrade_menu_kern = 0
  l_22_0.scale.mugshot_name_kern = 0
  l_22_0.scale.objectives_text_kern = objectives_text_kern or 0
  l_22_0.scale.objectives_desc_text_kern = objectives_desc_text_kern or 0
  l_22_0.scale.kit_description_multiplier = 1 * kit_desc_large
  l_22_0.scale.chat_multiplier = 1
  l_22_0.scale.chat_menu_h_multiplier = 1
  l_22_0.scale.w_interact_multiplier = 1 * w_interact_multiplier
  l_22_0.scale.victory_title_multiplier = victory_title_multiplier or 1
end

TweakData.set_menu_scale = function(l_23_0)
  local lang_mods_def = {Idstring("german"):key() = {topic_font_size = 0.80000001192093, challenges_font_size = 1, upgrades_font_size = 1, mission_end_font_size = 1}, Idstring("french"):key() = {topic_font_size = 1, challenges_font_size = 1, upgrades_font_size = 1, mission_end_font_size = 1}, Idstring("italian"):key() = {topic_font_size = 1, challenges_font_size = 1, upgrades_font_size = 1, mission_end_font_size = 0.94999998807907}, Idstring("spanish"):key() = {topic_font_size = 0.94999998807907, challenges_font_size = 0.94999998807907, upgrades_font_size = 1, mission_end_font_size = 1}}
  if not lang_mods_def[SystemInfo:language():key()] then
    local lang_mods = {topic_font_size = 1, challenges_font_size = 1, upgrades_font_size = 1, mission_end_font_size = 1}
  end
  local scale_multiplier = l_23_0.scale.default_font_multiplier
  local small_scale_multiplier = l_23_0.scale.small_font_multiplier
  l_23_0.menu.default_font = "fonts/font_medium_shadow_mf"
  l_23_0.menu.default_font_no_outline = "fonts/font_medium_noshadow_mf"
  l_23_0.menu.default_font_id = Idstring(l_23_0.menu.default_font)
  l_23_0.menu.default_font_no_outline_id = Idstring(l_23_0.menu.default_font_no_outline)
  l_23_0.menu.small_font = "fonts/font_small_shadow_mf"
  l_23_0.menu.small_font_size = 14 * small_scale_multiplier
  l_23_0.menu.small_font_noshadow = "fonts/font_small_noshadow_mf"
  l_23_0.menu.medium_font = "fonts/font_medium_shadow_mf"
  l_23_0.menu.medium_font_no_outline = "fonts/font_medium_noshadow_mf"
  l_23_0.menu.meidum_font_size = 24 * scale_multiplier
  l_23_0.menu.eroded_font = "fonts/font_eroded"
  l_23_0.menu.eroded_font_size = 80
  l_23_0.menu.pd2_massive_font = "fonts/font_large_mf"
  l_23_0.menu.pd2_massive_font_id = Idstring(l_23_0.menu.pd2_massive_font)
  l_23_0.menu.pd2_massive_font_size = 80
  l_23_0.menu.pd2_large_font = "fonts/font_large_mf"
  l_23_0.menu.pd2_large_font_id = Idstring(l_23_0.menu.pd2_large_font)
  l_23_0.menu.pd2_large_font_size = 44
  l_23_0.menu.pd2_medium_font = "fonts/font_medium_mf"
  l_23_0.menu.pd2_medium_font_id = Idstring(l_23_0.menu.pd2_medium_font)
  l_23_0.menu.pd2_medium_font_size = 24
  l_23_0.menu.pd2_small_font = "fonts/font_small_mf"
  l_23_0.menu.pd2_small_font_id = Idstring(l_23_0.menu.pd2_small_font)
  l_23_0.menu.pd2_small_font_size = 20
  l_23_0.menu.default_font_size = 24 * scale_multiplier
  l_23_0.menu.default_font_row_item_color = Color.white
  l_23_0.menu.default_hightlight_row_item_color = Color(1, 0, 0, 0)
  l_23_0.menu.default_menu_background_color = Color(1, 0.32549020648003, 0.37254902720451, 0.39607843756676)
  l_23_0.menu.highlight_background_color_left = Color(1, 1, 0.65882354974747, 0)
  l_23_0.menu.highlight_background_color_right = Color(1, 1, 0.65882354974747, 0)
  l_23_0.menu.default_changeable_text_color = Color(255, 77, 198, 255) / 255
  l_23_0.menu.default_disabled_text_color = Color(1, 0.5, 0.5, 0.5)
  l_23_0.menu.arrow_available = Color(1, 1, 0.65882354974747, 0)
  l_23_0.menu.arrow_unavailable = Color(1, 0.5, 0.5, 0.5)
  l_23_0.menu.arrow_unavailable = Color(1, 0.5, 0.5, 0.5)
  l_23_0.menu.upgrade_locked_color = Color(0.75, 0, 0)
  l_23_0.menu.upgrade_not_aquired_color = Color(0.5, 0.5, 0.5)
  l_23_0.menu.awarded_challenge_color = l_23_0.menu.default_font_row_item_color
  l_23_0.menu.dialog_title_font_size = 28 * l_23_0.scale.small_font_multiplier
  l_23_0.menu.dialog_text_font_size = 24 * l_23_0.scale.small_font_multiplier
  l_23_0.menu.info_padding = 10 * l_23_0.scale.info_padding_multiplier
  l_23_0.menu.topic_font_size = 32 * scale_multiplier * lang_mods.topic_font_size
  l_23_0.menu.main_menu_background_color = Color(1, 0, 0, 0)
  l_23_0.menu.kit_default_font_size = 24 * scale_multiplier
  l_23_0.menu.stats_font_size = 24 * scale_multiplier
  l_23_0.menu.customize_controller_size = 21 * scale_multiplier
  l_23_0.menu.server_list_font_size = 22 * l_23_0.scale.server_list_font_size_multiplier
  l_23_0.menu.challenges_font_size = 24 * scale_multiplier * lang_mods.challenges_font_size
  l_23_0.menu.upgrades_font_size = 24 * scale_multiplier * lang_mods.upgrades_font_size
  l_23_0.menu.multichoice_font_size = 24 * scale_multiplier
  l_23_0.menu.mission_end_font_size = 20 * scale_multiplier * lang_mods.mission_end_font_size
  l_23_0.menu.sd_mission_end_font_size = 14 * small_scale_multiplier * lang_mods.mission_end_font_size
  l_23_0.menu.lobby_info_font_size = 22 * l_23_0.scale.lobby_info_font_size_scale_multiplier
  l_23_0.menu.lobby_name_font_size = 22 * l_23_0.scale.lobby_name_font_size_scale_multiplier
  l_23_0.menu.loading_challenge_progress_font_size = 22 * small_scale_multiplier
  l_23_0.menu.loading_challenge_name_font_size = 22 * small_scale_multiplier
  l_23_0.menu.upper_saferect_border = 64 * l_23_0.scale.menu_border_multiplier
  l_23_0.menu.border_pad = 8 * l_23_0.scale.menu_border_multiplier
  l_23_0.menu.kit_description_font_size = 14 * l_23_0.scale.kit_description_multiplier
  l_23_0.load_level = {}
  l_23_0.load_level.briefing_text = {h = 192 * l_23_0.scale.briefing_text_h_multiplier}
  l_23_0.load_level.upper_saferect_border = l_23_0.menu.upper_saferect_border
  l_23_0.load_level.border_pad = l_23_0.menu.border_pad
  l_23_0.load_level.stonecold_small_logo = "guis/textures/game_small_logo"
end

TweakData.set_hud_values = function(l_24_0)
  local lang_mods_def = {Idstring("german"):key() = {hint_font_size = 0.89999997615814, stats_challenges_font_size = 0.69999998807907, active_objective_title_font_size = 0.89999997615814, present_mid_text_font_size = 0.80000001192093, next_player_font_size = 0.85000002384186, location_font_size = 1}, Idstring("french"):key() = {hint_font_size = 0.82499998807907, stats_challenges_font_size = 1, active_objective_title_font_size = 1, present_mid_text_font_size = 1, next_player_font_size = 0.85000002384186, location_font_size = 1}, Idstring("italian"):key() = {hint_font_size = 1, stats_challenges_font_size = 1, active_objective_title_font_size = 1, present_mid_text_font_size = 1, next_player_font_size = 0.85000002384186, location_font_size = 1}, Idstring("spanish"):key() = {hint_font_size = 1, stats_challenges_font_size = 1, active_objective_title_font_size = 1, present_mid_text_font_size = 1, next_player_font_size = 0.85000002384186, location_font_size = 0.69999998807907}}
  if not lang_mods_def[SystemInfo:language():key()] then
    local lang_mods = {hint_font_size = 1, stats_challenges_font_size = 1, active_objective_title_font_size = 1, present_mid_text_font_size = 1, next_player_font_size = 1, location_font_size = 1}
  end
  l_24_0.hud.medium_font = "fonts/font_medium_mf"
  l_24_0.hud.medium_font_noshadow = "fonts/font_medium_mf"
  l_24_0.hud.small_font = "fonts/font_small_mf"
  l_24_0.hud.small_font_size = 14 * l_24_0.scale.small_font_multiplier
  l_24_0.hud.location_font_size = 28 * l_24_0.scale.hud_default_font_multiplier * lang_mods.location_font_size
  l_24_0.hud.assault_title_font_size = 30 * l_24_0.scale.hud_default_font_multiplier
  l_24_0.hud.default_font_size = 32 * l_24_0.scale.hud_default_font_multiplier
  l_24_0.hud.present_mid_text_font_size = 32 * l_24_0.scale.hud_default_font_multiplier * lang_mods.present_mid_text_font_size
  l_24_0.hud.timer_font_size = 40 * l_24_0.scale.hud_default_font_multiplier
  l_24_0.hud.medium_deafult_font_size = 28 * l_24_0.scale.hud_default_font_multiplier
  l_24_0.hud.ammo_font_size = 30 * l_24_0.scale.hud_default_font_multiplier
  l_24_0.hud.weapon_ammo_font_size = 24 * l_24_0.scale.hud_default_font_multiplier
  l_24_0.hud.name_label_font_size = 24 * l_24_0.scale.hud_default_font_multiplier
  l_24_0.hud.equipment_font_size = 24 * l_24_0.scale.hud_default_font_multiplier
  l_24_0.hud.hint_font_size = 28 * l_24_0.scale.hud_default_font_multiplier * lang_mods.hint_font_size
  l_24_0.hud.active_objective_title_font_size = 24 * l_24_0.scale.hud_default_font_multiplier * lang_mods.active_objective_title_font_size
  l_24_0.hud.completed_objective_title_font_size = 20 * l_24_0.scale.hud_default_font_multiplier
  l_24_0.hud.upgrade_awarded_font_size = 26 * l_24_0.scale.hud_default_font_multiplier
  l_24_0.hud.next_upgrade_font_size = 14 * l_24_0.scale.next_upgrade_font_multiplier
  l_24_0.hud.level_up_font_size = 32 * l_24_0.scale.level_up_font_multiplier
  l_24_0.hud.next_player_font_size = 24 * l_24_0.scale.hud_default_font_multiplier * lang_mods.next_player_font_size
  l_24_0.hud.stats_challenges_font_size = 32 * l_24_0.scale.hud_default_font_multiplier * lang_mods.stats_challenges_font_size
  l_24_0.hud.chatinput_size = 22 * l_24_0.scale.hud_default_font_multiplier
  l_24_0.hud.chatoutput_size = 14 * l_24_0.scale.small_font_multiplier
  l_24_0.hud.prime_color = Color(1, 1, 0.65882354974747, 0)
  l_24_0.hud.suspicion_color = Color(1, 0, 0.46666666865349, 0.69803923368454)
  l_24_0.hud.detected_color = Color(1, 1, 0.20000000298023, 0)
end

TweakData.resolution_changed = function(l_25_0)
  l_25_0:set_scale()
  l_25_0:set_menu_scale()
  l_25_0:set_hud_values()
end

if (not tweak_data or tweak_data.RELOAD) and managers.dlc then
  if tweak_data then
    local reload = tweak_data.RELOAD
  end
  if tweak_data then
    local reload_clbks = tweak_data._reload_clbks
  end
  tweak_data = TweakData:new()
  tweak_data._reload_clbks = reload_clbks
  if reload then
    tweak_data:_execute_reload_clbks()
  end
end
TweakData.get_controller_help_coords = function(l_26_0)
  if managers.controller:get_default_wrapper_type() == "pc" then
    return false
  end
  local coords = {}
  if SystemInfo:platform() == Idstring("PS3") then
    coords.menu_button_sprint = {x = 195, y = 255, align = "right", vertical = "top"}
    coords.menu_button_move = {x = 195, y = 280, align = "right", vertical = "top"}
    coords.menu_button_melee = {x = 319, y = 255, align = "left", vertical = "top"}
    coords.menu_button_look = {x = 319, y = 280, align = "left", vertical = "top"}
    coords.menu_button_switch_weapon = {x = 511, y = 112, align = "left"}
    coords.menu_button_reload = {x = 511, y = 214, align = "left"}
    coords.menu_button_crouch = {x = 511, y = 146, align = "left"}
    coords.menu_button_jump = {x = 511, y = 178, align = "left"}
    coords.menu_button_shout = {x = 511, y = 8, align = "left"}
    coords.menu_button_fire_weapon = {x = 511, y = 36, align = "left"}
    coords.menu_button_deploy = {x = 0, y = 8, align = "right"}
    coords.menu_button_aim_down_sight = {x = 0, y = 36, align = "right"}
    coords.menu_button_ingame_menu = {x = 280, y = 0, align = "left", vertical = "bottom"}
    coords.menu_button_stats_screen = {x = 230, y = 0, align = "right", vertical = "bottom"}
    coords.menu_button_weapon_gadget = {x = 0, y = 171, align = "right", vertical = "center"}
  else
    coords.menu_button_sprint = {x = 0, y = 138, align = "right", vertical = "bottom"}
    coords.menu_button_move = {x = 0, y = 138, align = "right", vertical = "top"}
    coords.menu_button_melee = {x = 302, y = 256, align = "left", vertical = "top"}
    coords.menu_button_look = {x = 302, y = 281, align = "left", vertical = "top"}
    coords.menu_button_switch_weapon = {x = 512, y = 97, align = "left"}
    coords.menu_button_reload = {x = 512, y = 180, align = "left"}
    coords.menu_button_crouch = {x = 512, y = 125, align = "left"}
    coords.menu_button_jump = {x = 512, y = 153, align = "left"}
    coords.menu_button_shout = {x = 512, y = 49, align = "left"}
    coords.menu_button_fire_weapon = {x = 512, y = 19, align = "left"}
    coords.menu_button_deploy = {x = 0, y = 49, align = "right"}
    coords.menu_button_aim_down_sight = {x = 0, y = 19, align = "right"}
    coords.menu_button_ingame_menu = {x = 288, y = 0, align = "left", vertical = "bottom"}
    coords.menu_button_stats_screen = {x = 223, y = 0, align = "right", vertical = "bottom"}
    coords.menu_button_weapon_gadget = {x = 209, y = 256, align = "right", vertical = "top"}
  end
  if managers.user and managers.user:get_setting("southpaw") then
    local tmp = coords.menu_button_move
    coords.menu_button_move = coords.menu_button_look
    coords.menu_button_look = tmp
  end
  return coords
end


