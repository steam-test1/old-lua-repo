-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementmissionend.luac 

core:import("CoreMissionScriptElement")
if not ElementMissionEnd then
  ElementMissionEnd = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementMissionEnd.init = function(l_1_0, ...)
  ElementMissionEnd.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementMissionEnd.client_on_executed = function(l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementMissionEnd.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  do
     -- DECOMPILER ERROR: unhandled construct in 'if'

     -- DECOMPILER ERROR: unhandled construct in 'if'

    if l_3_0._values.state ~= "none" and l_3_0._values.state == "success" and managers.platform:presence() == "Playing" then
      local num_winners = managers.network:game():amount_of_alive_players()
      managers.network:session():send_to_peers("mission_ended", true, num_winners)
      game_state_machine:change_state_by_name("victoryscreen", {num_winners = num_winners, personal_win = alive(managers.player:player_unit())})
    end
    do return end
    if l_3_0._values.state == "failed" then
      print("No fail state yet")
    else
      if l_3_0._values.state == "leave_safehouse" and managers.platform:presence() == "Playing" then
        MenuCallbackHandler:leave_safehouse()
        do return end
        if Application:editor() then
          managers.editor:output_error("Cant change to state " .. l_3_0._values.state .. " in mission end element " .. l_3_0._editor_name .. ".")
        end
      end
    end
  end
  ElementMissionEnd.super.on_executed(l_3_0, l_3_1)
end


