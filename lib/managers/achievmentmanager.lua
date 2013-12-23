-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\achievmentmanager.luac 

if not AchievmentManager then
  AchievmentManager = class()
end
AchievmentManager.PATH = "gamedata/achievments"
AchievmentManager.FILE_EXTENSION = "achievment"
AchievmentManager.init = function(l_1_0)
  l_1_0.exp_awards = {none = 0, a = 500, b = 1500, c = 5000}
  l_1_0.script_data = {}
  if SystemInfo:platform() == Idstring("WIN32") then
    AchievmentManager.do_award = AchievmentManager.award_steam
    if not Global.achievment_manager then
      l_1_0:_parse_achievments("Steam")
      l_1_0.handler = Steam:sa_handler()
      l_1_0.handler:initialized_callback(AchievmentManager.fetch_achievments)
      l_1_0.handler:init()
      Global.achievment_manager = {handler = l_1_0.handler, achievments = l_1_0.achievments}
    else
      l_1_0.handler = Global.achievment_manager.handler
      l_1_0.achievments = Global.achievment_manager.achievments
    end
  else
    if SystemInfo:platform() == Idstring("PS3") then
      l_1_0:_parse_achievments("PSN")
      AchievmentManager.do_award = AchievmentManager.award_psn
      l_1_0._requests = {}
    else
      if SystemInfo:platform() == Idstring("X360") then
        l_1_0:_parse_achievments("X360")
        AchievmentManager.do_award = AchievmentManager.award_x360
      else
        Application:error("[AchievmentManager:init] Unsupported platform")
      end
    end
  end
end
end

AchievmentManager.fetch_trophies = function(l_2_0)
  if SystemInfo:platform() == Idstring("PS3") then
    Trophies:get_unlockstate(AchievmentManager.unlockstate_result)
  end
end

AchievmentManager.unlockstate_result = function(l_3_0, l_3_1)
  if l_3_1 then
    for i,data in ipairs(l_3_1) do
      local psn_id = data.index
      local unlocked = data.unlocked
      if unlocked then
        for id,ach in pairs(managers.achievment.achievments) do
          if ach.id == psn_id then
            ach.awarded = true
          end
        end
      end
    end
  end
  managers.network.account:achievements_fetched()
end

AchievmentManager.fetch_achievments = function(l_4_0)
  print("[AchievmentManager.fetch_achievments]", l_4_0)
  if l_4_0 == "success" then
    for id,ach in pairs(managers.achievment.achievments) do
      if managers.achievment.handler:has_achievement(ach.id) then
        print("Achievment awarded", ach.id)
        ach.awarded = true
      end
    end
  end
  managers.network.account:achievements_fetched()
end

AchievmentManager._parse_achievments = function(l_5_0, l_5_1)
  local list = PackageManager:script_data(l_5_0.FILE_EXTENSION:id(), l_5_0.PATH:id())
  l_5_0.achievments = {}
  for _,ach in ipairs(list) do
    if ach._meta == "achievment" then
      for _,reward in ipairs(ach) do
        if reward._meta == "reward" and (Application:editor() or l_5_1 == reward.platform) then
          l_5_0.achievments[ach.id] = {id = reward.id, name = ach.name, exp = l_5_0.exp_awards[ach.awards_exp], awarded = false}
        end
      end
    end
  end
end

AchievmentManager.get_script_data = function(l_6_0, l_6_1)
  return l_6_0.script_data[l_6_1]
end

AchievmentManager.set_script_data = function(l_7_0, l_7_1, l_7_2)
  l_7_0.script_data[l_7_1] = l_7_2
end

AchievmentManager.exists = function(l_8_0, l_8_1)
  return l_8_0.achievments[l_8_1] ~= nil
end

AchievmentManager.get_info = function(l_9_0, l_9_1)
  return l_9_0.achievments[l_9_1]
end

AchievmentManager.total_amount = function(l_10_0)
  return table.size(l_10_0.achievments)
end

AchievmentManager.total_unlocked = function(l_11_0)
  local i = 0
  for _,ach in pairs(l_11_0.achievments) do
    if ach.awarded then
      i = i + 1
    end
  end
  return i
end

AchievmentManager.award = function(l_12_0, l_12_1)
  if not l_12_0:exists(l_12_1) then
    return 
  end
  if l_12_0:get_info(l_12_1).awarded then
    return 
  end
  if l_12_1 == "christmas_present" then
    managers.network.account._masks.santa = true
  elseif l_12_1 == "golden_boy" then
    managers.network.account._masks.gold = true
  end
  l_12_0:do_award(l_12_1)
end

AchievmentManager._give_reward = function(l_13_0, l_13_1, l_13_2)
  print("[AchievmentManager:_give_reward] ", l_13_1)
  local data = l_13_0:get_info(l_13_1)
  data.awarded = true
end

AchievmentManager.award_steam = function(l_14_0, l_14_1)
  Application:debug("[AchievmentManager:award_steam] Awarded Steam achievment", l_14_1)
  if not l_14_0.handler:initialized() then
    print("[AchievmentManager:award_steam] Achievments are not initialized. Cannot award achievment:", l_14_1)
    return 
  end
  l_14_0.handler:achievement_store_callback(AchievmentManager.steam_unlock_result)
  l_14_0.handler:set_achievement(l_14_0:get_info(l_14_1).id)
  l_14_0.handler:store_data()
end

AchievmentManager.clear_steam = function(l_15_0, l_15_1)
  print("[AchievmentManager:clear_steam]", l_15_1)
  if not l_15_0.handler:initialized() then
    print("[AchievmentManager:clear_steam] Achievments are not initialized. Cannot clear achievment:", l_15_1)
    return 
  end
  l_15_0.handler:clear_achievement(l_15_0:get_info(l_15_1).id)
  l_15_0.handler:store_data()
end

AchievmentManager.steam_unlock_result = function(l_16_0)
  print("[AchievmentManager:steam_unlock_result] Awarded Steam achievment", l_16_0)
  for id,ach in pairs(managers.achievment.achievments) do
    if ach.id == l_16_0 then
      managers.achievment:_give_reward(id)
      return 
    end
  end
end

AchievmentManager.award_x360 = function(l_17_0, l_17_1)
  print("[AchievmentManager:award_x360] Awarded X360 achievment", l_17_1)
  local x360_unlock_result = function(l_1_0)
    print("result", l_1_0)
    if l_1_0 then
      managers.achievment:_give_reward(id)
    end
   end
  XboxLive:award_achievement(managers.user:get_platform_id(), l_17_0:get_info(l_17_1).id, x360_unlock_result)
end

AchievmentManager.award_psn = function(l_18_0, l_18_1)
  print("[AchievmentManager:award] Awarded PSN achievment", l_18_1)
  if not l_18_0._trophies_installed then
    print("[AchievmentManager:award] Trophies are not installed. Cannot award trophy:", l_18_1)
    return 
  end
  local request = Trophies:unlock_id(l_18_0:get_info(l_18_1).id, AchievmentManager.psn_unlock_result)
  l_18_0._requests[request] = l_18_1
end

AchievmentManager.psn_unlock_result = function(l_19_0, l_19_1)
  print("[AchievmentManager:psn_unlock_result] Awarded PSN achievment", l_19_0, l_19_1)
  local id = managers.achievment._requests[l_19_0]
  if l_19_1 == "success" then
    managers.achievment:_give_reward(id)
  end
end

AchievmentManager.chk_install_trophies = function(l_20_0)
  if Trophies:is_installed() then
    print("[AchievmentManager:chk_install_trophies] Already installed")
    l_20_0._trophies_installed = true
    Trophies:get_unlockstate(l_20_0.unlockstate_result)
    l_20_0:fetch_trophies()
  else
    if managers.dlc:has_full_game() then
      print("[AchievmentManager:chk_install_trophies] Installing")
      Trophies:install(callback(l_20_0, l_20_0, "clbk_install_trophies"))
    end
  end
end

AchievmentManager.clbk_install_trophies = function(l_21_0, l_21_1)
  print("[AchievmentManager:clbk_install_trophies]", l_21_1)
  if l_21_1 then
    l_21_0._trophies_installed = true
    l_21_0:fetch_trophies()
  end
end


