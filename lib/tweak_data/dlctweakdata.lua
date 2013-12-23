-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\tweak_data\dlctweakdata.luac 

if not DLCTweakData then
  DLCTweakData = class()
end
DLCTweakData.init = function(l_1_0, l_1_1)
  l_1_0.starter_kit = {}
  l_1_0.starter_kit.free = true
  l_1_0.starter_kit.content = {}
  l_1_0.starter_kit.content.loot_global_value = "normal"
  l_1_0.starter_kit.content.loot_drops = {{type_items = "weapon_mods", item_entry = "wpn_fps_upg_ns_pis_medium", amount = 1}, {type_items = "weapon_mods", item_entry = "wpn_fps_m4_uupg_m_std", amount = 1}}
  l_1_0.preorder = {}
  l_1_0.preorder.dlc = "has_preorder"
  l_1_0.preorder.content = {}
  l_1_0.preorder.content.loot_drops = {{type_items = "colors", item_entry = "red_black", amount = 1}, {type_items = "textures", item_entry = "fan", amount = 1}, {type_items = "masks", item_entry = "skull", amount = 1}, {type_items = "weapon_mods", item_entry = "wpn_fps_upg_o_aimpoint_2", amount = 1}, {type_items = "cash", item_entry = "cash_preorder", amount = 1}}
  l_1_0.preorder.content.upgrades = {"player_crime_net_deal"}
  l_1_0.cce = {}
  l_1_0.cce.dlc = "has_cce"
  l_1_0.cce.content = {}
  l_1_0.cce.content.loot_drops = {}
  l_1_0.cce.content.upgrades = {"player_crime_net_deal_2"}
end


