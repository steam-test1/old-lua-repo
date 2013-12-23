-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\tweak_data\weaponupgradestweakdata.luac 

if not WeaponUpgradesTweakData then
  WeaponUpgradesTweakData = class()
end
WeaponUpgradesTweakData.init = function(l_1_0)
  l_1_0.upgrades = {}
  l_1_0.upgrades.scope1 = {}
  l_1_0.upgrades.scope1.name_id = "bm_wu_scope1"
  l_1_0.upgrades.scope2 = {}
  l_1_0.upgrades.scope2.name_id = "bm_wu_scope2"
  l_1_0.upgrades.scope3 = {}
  l_1_0.upgrades.scope3.name_id = "bm_wu_scope3"
  l_1_0.upgrades.barrel1 = {}
  l_1_0.upgrades.barrel1.name_id = "bm_wu_barrel1"
  l_1_0.upgrades.barrel2 = {}
  l_1_0.upgrades.barrel2.name_id = "bm_wu_barrel2"
  l_1_0.upgrades.barrel3 = {}
  l_1_0.upgrades.barrel3.name_id = "bm_wu_barrel3"
  l_1_0.upgrades.grip1 = {}
  l_1_0.upgrades.grip1.name_id = "bm_wu_grip1"
  l_1_0.upgrades.grip2 = {}
  l_1_0.upgrades.grip2.name_id = "bm_wu_grip2"
  l_1_0.upgrades.grip3 = {}
  l_1_0.upgrades.grip3.name_id = "bm_wu_grip3"
  l_1_0.upgrades.m14_scope1 = {}
  l_1_0.upgrades.m14_scope1.name_id = "bm_wu_scope1"
  l_1_0.upgrades.m14_scope1.visual_upgrade = "m14_spread2"
  l_1_0.upgrades.m14_scope2 = {}
  l_1_0.upgrades.m14_scope2.name_id = "bm_wu_scope2"
  l_1_0.upgrades.m14_scope2.visual_upgrade = "m14_spread1"
  l_1_0.upgrades.m4_scope1 = {}
  l_1_0.upgrades.m4_scope1.name_id = "bm_wu_scope1"
  l_1_0.upgrades.m4_scope1.visual_upgrade = "m4_spread4"
  l_1_0.upgrades.m4_barrel1 = {}
  l_1_0.upgrades.m4_barrel1.name_id = "bm_wu_barrel1"
  l_1_0.upgrades.m4_barrel1.visual_upgrade = "m4_spread2"
  l_1_0.upgrades.hk21_grip1 = {}
  l_1_0.upgrades.hk21_grip1.name_id = "bm_wu_grip1"
  l_1_0.upgrades.hk21_grip1.visual_upgrade = "hk21_mag4"
  l_1_0.upgrades.hk21_barrel1 = {}
  l_1_0.upgrades.hk21_barrel1.name_id = "bm_wu_barrel1"
  l_1_0.upgrades.hk21_barrel1.visual_upgrade = "hk21_recoil1"
  l_1_0.upgrades.hk21_scope1 = {}
  l_1_0.upgrades.hk21_scope1.name_id = "bm_wu_scope1"
  l_1_0.upgrades.hk21_scope1.visual_upgrade = "hk21_recoil2"
  l_1_0.weapon = {}
  l_1_0.weapon.m4 = {}
  l_1_0.weapon.m4.scopes = {"m4_scope1", "scope2", "scope3"}
  l_1_0.weapon.m4.barrels = {"m4_barrel1", "barrel2"}
  l_1_0.weapon.m4.grips = {"grip1", "grip2"}
  l_1_0.weapon.m14 = {}
  l_1_0.weapon.m14.scopes = {"m14_scope1", "m14_scope2", "scope3"}
  l_1_0.weapon.m14.barrels = {"barrel1", "barrel2"}
  l_1_0.weapon.m14.grips = {"grip2"}
  l_1_0.weapon.raging_bull = {}
  l_1_0.weapon.raging_bull.scopes = {"scope3"}
  l_1_0.weapon.raging_bull.barrels = {"barrel1"}
  l_1_0.weapon.raging_bull.grips = {"grip1", "grip2"}
  l_1_0.weapon.hk21 = {}
  l_1_0.weapon.hk21.scopes = {"hk21_scope1"}
  l_1_0.weapon.hk21.barrels = {"hk21_barrel1"}
  l_1_0.weapon.hk21.grips = {"hk21_grip1"}
end


