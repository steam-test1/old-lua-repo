-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\player_team\teamaisound.luac 

if not TeamAISound then
  TeamAISound = class(PlayerSound)
end
TeamAISound.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_1:base():post_init()
  local ss = l_1_1:sound_source()
  ss:set_switch("robber", tweak_data.character[l_1_1:base()._tweak_table].speech_prefix)
  ss:set_switch("int_ext", "third")
end

TeamAISound.set_voice = function(l_2_0, l_2_1)
  local ss = l_2_0._unit:sound_source()
  ss:set_switch("robber", l_2_1)
  ss:set_switch("int_ext", "third")
end


