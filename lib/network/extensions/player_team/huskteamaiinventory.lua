-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\extensions\player_team\huskteamaiinventory.luac 

if not HuskTeamAIInventory then
  HuskTeamAIInventory = class(HuskCopInventory)
end
HuskTeamAIInventory.add_unit_by_name = function(l_1_0, l_1_1, l_1_2)
  local new_unit = World:spawn_unit(l_1_1, Vector3(), Rotation())
  local setup_data = {}
  setup_data.user_unit = l_1_0._unit
  setup_data.ignore_units = {l_1_0._unit, new_unit}
  setup_data.expend_ammo = false
  setup_data.hit_slotmask = managers.slot:get_mask("bullet_impact_targets_no_AI")
  setup_data.hit_player = false
  setup_data.user_sound_variant = tweak_data.character[l_1_0._unit:base()._tweak_table].weapon_voice
  new_unit:base():setup(setup_data)
  CopInventory.add_unit(l_1_0, new_unit, l_1_2)
end


