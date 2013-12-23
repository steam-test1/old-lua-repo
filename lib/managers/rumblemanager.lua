-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\rumblemanager.luac 

core:module("RumbleManager")
core:import("CoreRumbleManager")
core:import("CoreClass")
if not RumbleManager then
  RumbleManager = class(CoreRumbleManager.RumbleManager)
end
RumbleManager.init = function(l_1_0)
  RumbleManager.super.init(l_1_0)
  _G.tweak_data:add_reload_callback(l_1_0, callback(l_1_0, l_1_0, "setup_preset_rumbles"))
  l_1_0:setup_preset_rumbles()
end

RumbleManager.setup_preset_rumbles = function(l_2_0)
  l_2_0:add_preset_rumbles("weapon_fire", {engine = "both", peak = 0.5, sustain = 0.10000000149012, release = 0.050000000745058, cumulative = false})
  l_2_0:add_preset_rumbles("land", {engine = "both", peak = 0.5, sustain = 0.10000000149012, release = 0.10000000149012, cumulative = false})
  l_2_0:add_preset_rumbles("hard_land", {engine = "both", peak = 1, sustain = 0.30000001192093, release = 0.10000000149012, cumulative = false})
  l_2_0:add_preset_rumbles("electrified", {engine = "both", peak = 0.5, release = 0.050000000745058, cumulative = false})
  l_2_0:add_preset_rumbles("electric_shock", {engine = "both", peak = 1, sustain = 0.20000000298023, release = 0.10000000149012, cumulative = true})
  l_2_0:add_preset_rumbles("incapacitated_shock", {engine = "both", peak = 0.75, sustain = 0.20000000298023, release = 0.10000000149012, cumulative = true})
  l_2_0:add_preset_rumbles("damage_bullet", {engine = "both", peak = 1, sustain = 0.20000000298023, release = 0, cumulative = true})
  l_2_0:add_preset_rumbles("bullet_whizby", {engine = "both", peak = 1, sustain = 0.075000002980232, release = 0, cumulative = true})
  l_2_0:add_preset_rumbles("melee_hit", {engine = "both", peak = 1, sustain = 0.15000000596046, release = 0, cumulative = true})
  l_2_0:add_preset_rumbles("mission_triggered", {engine = "both", peak = 1, attack = 0.10000000149012, sustain = 0.30000001192093, release = 2.0999999046326, cumulative = true})
end

CoreClass.override_class(CoreRumbleManager.RumbleManager, RumbleManager)

