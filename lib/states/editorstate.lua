-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\editorstate.luac 

require("lib/states/GameState")
if not EditorState then
  EditorState = class(GameState)
end
EditorState.init = function(l_1_0, l_1_1)
  GameState.init(l_1_0, "editor", l_1_1)
end

EditorState.at_enter = function(l_2_0)
  cat_print("game_state_machine", "GAME STATE EditorState ENTER")
end

EditorState.at_exit = function(l_3_0)
  cat_print("game_state_machine", "GAME STATE EditorState ENTER")
end


