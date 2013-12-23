-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementfilter.luac 

core:import("CoreMissionScriptElement")
if not ElementFilter then
  ElementFilter = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementFilter.init = function(l_1_0, ...)
  ElementFilter.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementFilter.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementFilter.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  if not l_3_0:_check_platform() then
    return 
  end
  if not l_3_0:_check_difficulty() then
    return 
  end
  if not l_3_0:_check_players() then
    return 
  end
  if not l_3_0:_check_mode() then
    return 
  end
  ElementFilter.super.on_executed(l_3_0, l_3_1)
end

local win32 = Idstring("WIN32")
local ps3 = Idstring("PS3")
local x360 = Idstring("X360")
ElementFilter._check_platform = function(l_4_0)
  if Global.running_simulation then
    local platform = Idstring(managers.editor:mission_platform())
  end
  if not platform then
    platform = SystemInfo:platform()
  end
  if l_4_0._values.platform_win32 and platform == win32 then
    return true
  end
  if l_4_0._values.platform_ps3 and (platform == ps3 or platform == x360) then
    return true
  end
  return false
end

ElementFilter._check_difficulty = function(l_5_0)
  local diff = Global.game_settings and Global.game_settings.difficulty or "hard"
  if l_5_0._values.difficulty_easy and diff == "easy" then
    return true
  end
  if l_5_0._values.difficulty_normal and diff == "normal" then
    return true
  end
  if l_5_0._values.difficulty_hard and diff == "hard" then
    return true
  end
  if l_5_0._values.difficulty_overkill and diff == "overkill" then
    return true
  end
  if l_5_0._values.difficulty_overkill_145 and diff == "overkill_145" then
    return true
  end
  return false
end

ElementFilter._check_players = function(l_6_0)
  if Global.running_simulation then
    local players = managers.editor:mission_player()
  end
  if not players and managers.network:game() then
    players = managers.network:game():amount_of_members()
  end
  if not players then
    return false
  end
  if l_6_0._values.player_1 and players == 1 then
    return true
  end
  if l_6_0._values.player_2 and players == 2 then
    return true
  end
  if l_6_0._values.player_3 and players == 3 then
    return true
  end
  if l_6_0._values.player_4 and players == 4 then
    return true
  end
  return false
end

ElementFilter._check_mode = function(l_7_0)
  if l_7_0._values.mode_control == nil or l_7_0._values.mode_assault == nil then
    return true
  end
  if managers.groupai:state():get_assault_mode() and l_7_0._values.mode_assault then
    return true
  end
  if not managers.groupai:state():get_assault_mode() and l_7_0._values.mode_control then
    return true
  end
  return false
end


