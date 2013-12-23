-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementpointofnoreturn.luac 

core:import("CoreMissionScriptElement")
if not ElementPointOfNoReturn then
  ElementPointOfNoReturn = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementPointOfNoReturn.init = function(l_1_0, ...)
  ElementPointOfNoReturn.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementPointOfNoReturn.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementPointOfNoReturn.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  local diff = Global.game_settings and Global.game_settings.difficulty or "hard"
  if diff == "easy" then
    managers.groupai:state():set_point_of_no_return_timer(l_3_0._values.time_easy, l_3_0._id)
  elseif diff == "normal" then
    managers.groupai:state():set_point_of_no_return_timer(l_3_0._values.time_normal, l_3_0._id)
  elseif diff == "hard" then
    managers.groupai:state():set_point_of_no_return_timer(l_3_0._values.time_hard, l_3_0._id)
  elseif diff == "overkill" then
    managers.groupai:state():set_point_of_no_return_timer(l_3_0._values.time_overkill, l_3_0._id)
  elseif diff == "overkill_145" then
    managers.groupai:state():set_point_of_no_return_timer(l_3_0._values.time_overkill_145, l_3_0._id)
  end
  ElementPointOfNoReturn.super.on_executed(l_3_0, l_3_1)
end


