-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementprofilefilter.luac 

core:import("CoreMissionScriptElement")
if not ElementProfileFilter then
  ElementProfileFilter = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementProfileFilter.init = function(l_1_0, ...)
  ElementProfileFilter.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementProfileFilter.client_on_executed = function(l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementProfileFilter.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  if not l_3_0:_check_player_lvl() then
    return 
  end
  if not l_3_0:_check_total_money_earned() then
    return 
  end
  if not l_3_0:_check_total_money_offshore() then
    return 
  end
  if not l_3_0:_check_achievement() then
    return 
  end
  ElementProfileFilter.super.on_executed(l_3_0, l_3_1)
end

ElementProfileFilter._check_player_lvl = function(l_4_0)
  local pass = l_4_0._values.player_lvl <= managers.experience:current_level()
  return pass
end

ElementProfileFilter._check_total_money_earned = function(l_5_0)
  local pass = l_5_0._values.money_earned * 1000 <= managers.money:total_collected()
  return pass
end

ElementProfileFilter._check_total_money_offshore = function(l_6_0)
  if not l_6_0._values.money_offshore then
    return false
  end
  local pass = l_6_0._values.money_offshore * 1000 <= managers.money:offshore()
  return pass
end

ElementProfileFilter._check_achievement = function(l_7_0)
  if l_7_0._values.achievement == "none" then
    return true
  end
  local info = managers.achievment:get_info(l_7_0._values.achievement)
  if info then
    local pass = info.awarded
  end
  return pass
end


