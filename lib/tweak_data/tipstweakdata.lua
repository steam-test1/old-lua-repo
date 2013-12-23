-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\tweak_data\tipstweakdata.luac 

if not TipsTweakData then
  TipsTweakData = class()
end
TipsTweakData.init = function(l_1_0)
  table.insert(l_1_0, {string_id = "tip_tactical_reload"})
  table.insert(l_1_0, {string_id = "tip_help_arrested"})
  table.insert(l_1_0, {string_id = "tip_weapon_effecienty"})
  table.insert(l_1_0, {string_id = "tip_switch_to_sidearm"})
  table.insert(l_1_0, {string_id = "tip_doctor_bag"})
  table.insert(l_1_0, {string_id = "tip_ammo_bag"})
  table.insert(l_1_0, {string_id = "tip_head_shot"})
  table.insert(l_1_0, {string_id = "tip_secret_assignmnet"})
  table.insert(l_1_0, {string_id = "tip_help_bleed_out"})
  table.insert(l_1_0, {string_id = "tip_dont_shoot_civilians"})
  table.insert(l_1_0, {string_id = "tip_trading_hostage"})
  table.insert(l_1_0, {string_id = "tip_shoot_at_civilians"})
  table.insert(l_1_0, {string_id = "tip_police_free_hostage"})
  table.insert(l_1_0, {string_id = "tip_steelsight"})
  table.insert(l_1_0, {string_id = "tip_melee_attack"})
  table.insert(l_1_0, {string_id = "tip_law_enforcers_as_hostages"})
  table.insert(l_1_0, {string_id = "tip_mask_off"})
  table.insert(l_1_0, {string_id = "tip_xp"})
  table.insert(l_1_0, {string_id = "tip_xp_bar"})
  table.insert(l_1_0, {string_id = "tip_objectives"})
  table.insert(l_1_0, {string_id = "tip_select_reward"})
  table.insert(l_1_0, {string_id = "tip_shoot_in_bleed_out"})
end

TipsTweakData.get_a_tip = function(l_2_0)
  local lvl = managers.experience:current_level()
  local ids = {}
  for _,tip in ipairs(l_2_0) do
    if not tip.unlock_lvl or tip.unlock_lvl < lvl then
      table.insert(ids, tip.string_id)
    end
  end
  return ids[math.random(#ids)]
end


