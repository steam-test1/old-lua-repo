-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementaiglobalevent.luac 

core:import("CoreMissionScriptElement")
if not ElementAiGlobalEvent then
  ElementAiGlobalEvent = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementAiGlobalEvent.init = function(l_1_0, ...)
  ElementAiGlobalEvent.super.init(l_1_0, ...)
  if l_1_0._values.event then
    l_1_0._values.wave_mode = l_1_0._values.event
    l_1_0._values.event = nil
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

ElementAiGlobalEvent.on_executed = function(l_2_0, l_2_1)
  if not l_2_0._values.enabled then
    return 
  end
  if l_2_0._values.wave_mode and l_2_0._values.wave_mode ~= "none" then
    managers.groupai:state():set_wave_mode(l_2_0._values.wave_mode)
  end
  if not l_2_0._values.blame or l_2_0._values.blame == "none" then
    Application:error("ElementAiGlobalEvent needs to be updated with blame parameter, and not none", inspect(l_2_0._values))
  end
  if l_2_0._values.AI_event and l_2_0._values.AI_event ~= "none" then
    if l_2_0._values.AI_event == "police_called" then
      managers.groupai:state():on_police_called(managers.groupai:state().analyse_giveaway(l_2_0._values.blame, l_2_1, {"vo_cbt"}))
    else
      if l_2_0._values.AI_event == "police_weapons_hot" then
        managers.groupai:state():on_police_weapons_hot(managers.groupai:state().analyse_giveaway(l_2_0._values.blame, l_2_1, {"vo_cbt"}))
      else
        if l_2_0._values.AI_event == "gangsters_called" then
          managers.groupai:state():on_gangsters_called(managers.groupai:state().analyse_giveaway(l_2_0._values.blame, l_2_1, {"vo_cbt"}))
        else
          if l_2_0._values.AI_event == "gangster_weapons_hot" then
            managers.groupai:state():on_gangster_weapons_hot(managers.groupai:state().analyse_giveaway(l_2_0._values.blame, l_2_1, {"vo_cbt"}))
          end
        end
      end
    end
  end
  ElementAiGlobalEvent.super.on_executed(l_2_0, l_2_1)
end


