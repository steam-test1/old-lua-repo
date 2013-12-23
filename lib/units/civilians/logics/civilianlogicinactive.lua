-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\civilians\logics\civilianlogicinactive.luac 

require("lib/units/enemies/cop/logics/CopLogicInactive")
CivilianLogicInactive = class(CopLogicInactive)
CivilianLogicInactive.on_enemy_weapons_hot = function(l_1_0, l_1_1)
  l_1_1.unit:brain():set_attention_settings(nil)
end

CivilianLogicInactive._register_attention = function(l_2_0, l_2_1)
  if l_2_0.unit:character_damage():dead() and not managers.groupai:state():enemy_weapons_hot() then
    l_2_1.weapons_hot_listener_key = "CopLogicInactive_corpse" .. tostring(l_2_0.key)
    managers.groupai:state():add_listener(l_2_1.weapons_hot_listener_key, {"enemy_weapons_hot"}, callback(CivilianLogicInactive, CivilianLogicInactive, "on_enemy_weapons_hot", l_2_0))
    l_2_0.unit:brain():set_attention_settings({"civ_enemy_corpse_sneak"})
  else
    l_2_0.unit:brain():set_attention_settings(nil)
  end
end

CivilianLogicInactive._set_interaction = function(l_3_0, l_3_1)
  if l_3_0.unit:character_damage():dead() and not managers.groupai:state():enemy_weapons_hot() then
    l_3_0.unit:interaction():set_tweak_data("corpse_dispose")
    l_3_0.unit:interaction():set_active(true, true, true)
  end
end


