-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\ingameplayerbase.luac 

require("lib/states/GameState")
if not IngamePlayerBaseState then
  IngamePlayerBaseState = class(GameState)
end
IngamePlayerBaseState.init = function(l_1_0, ...)
  GameState.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

IngamePlayerBaseState.set_controller_enabled = function(l_2_0, l_2_1)
  do
    local players = managers.player:players()
    for _,player in ipairs(players) do
      local controller = player:base():controller()
      if controller then
        controller:set_enabled(l_2_1)
      end
      if l_2_1 and controller:get_input_bool("stats_screen") then
        player:base():set_stats_screen_visible(true)
        for (for control),_ in (for generator) do
          player:base():set_stats_screen_visible(false)
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end


