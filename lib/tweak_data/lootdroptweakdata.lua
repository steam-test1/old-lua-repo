-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\tweak_data\lootdroptweakdata.luac 

if not LootDropTweakData then
  LootDropTweakData = class()
end
LootDropTweakData.init = function(l_1_0, l_1_1)
  l_1_0.PC_STEP = 10
  l_1_0.no_drop = {}
  l_1_0.no_drop.BASE = 35
  l_1_0.no_drop.HUMAN_STEP_MODIFIER = 10
  l_1_0.joker_chance = 0
  l_1_0.level_limit = 1
  l_1_0.risk_pc_multiplier = {0, 0, 0, 0}
  l_1_0.PC_CHANCE = {}
  l_1_0.PC_CHANCE[1] = 0.69999998807907
  l_1_0.PC_CHANCE[2] = 0.69999998807907
  l_1_0.PC_CHANCE[3] = 0.69999998807907
  l_1_0.PC_CHANCE[4] = 0.69999998807907
  l_1_0.PC_CHANCE[5] = 0.69999998807907
  l_1_0.PC_CHANCE[6] = 0.69999998807907
  l_1_0.PC_CHANCE[7] = 0.69999998807907
  l_1_0.PC_CHANCE[8] = 0.69999998807907
  l_1_0.PC_CHANCE[9] = 0.69999998807907
  l_1_0.PC_CHANCE[10] = 0.69999998807907
  l_1_0.STARS = {}
  l_1_0.STARS[1] = {pcs = {10, 100, 100}}
  l_1_0.STARS[2] = {pcs = {20, 100, 100}}
  l_1_0.STARS[3] = {pcs = {30, 100, 100}}
  l_1_0.STARS[4] = {pcs = {40, 100, 100}}
  l_1_0.STARS[5] = {pcs = {40, 100, 100}}
  l_1_0.STARS[6] = {pcs = {40, 100, 100}}
  l_1_0.STARS[7] = {pcs = {40, 100, 100}}
  l_1_0.STARS[8] = {pcs = {40, 100, 100}}
  l_1_0.STARS[9] = {pcs = {40, 100, 100}}
  l_1_0.STARS[10] = {pcs = {40, 100, 100}}
  l_1_0.STARS_CURVES = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
  l_1_0.WEIGHTED_TYPE_CHANCE = {}
  local min = 10
  local max = 100
  local range = {cash = {20, 20}, weapon_mods = {50, 50}, colors = {6, 6}, textures = {7, 7}, materials = {7, 7}, masks = {10, 10}}
  for i = min, max, 10 do
    local cash = math.lerp(range.cash[1], range.cash[2], i / max)
    local weapon_mods = math.lerp(range.weapon_mods[1], range.weapon_mods[2], i / max)
    local colors = math.lerp(range.colors[1], range.colors[2], i / max)
    local textures = math.lerp(range.textures[1], range.textures[2], i / max)
    local materials = math.lerp(range.materials[1], range.materials[2], i / max)
    local masks = math.lerp(range.masks[1], range.masks[2], i / max)
    l_1_0.WEIGHTED_TYPE_CHANCE[i] = {cash = cash, weapon_mods = weapon_mods, colors = colors, textures = textures, materials = materials, masks = masks}
  end
  l_1_0.global_values = {}
  l_1_0.global_values.normal = {}
  l_1_0.global_values.normal.name_id = "bm_global_value_normal"
  l_1_0.global_values.normal.desc_id = "menu_l_global_value_normal"
  l_1_0.global_values.normal.color = Color.white
  l_1_0.global_values.normal.dlc = false
  l_1_0.global_values.normal.chance = 0.83999997377396
  l_1_0.global_values.normal.value_multiplier = l_1_1:get_value("money_manager", "global_value_multipliers", "normal")
  l_1_0.global_values.normal.durability_multiplier = 1
  l_1_0.global_values.normal.drops = true
  l_1_0.global_values.normal.track = false
  l_1_0.global_values.normal.sort_number = 0
  l_1_0.global_values.superior = {}
  l_1_0.global_values.superior.name_id = "bm_global_value_superior"
  l_1_0.global_values.superior.desc_id = "menu_l_global_value_superior"
  l_1_0.global_values.superior.color = Color.blue
  l_1_0.global_values.superior.dlc = false
  l_1_0.global_values.superior.chance = 0.10000000149012
  l_1_0.global_values.superior.value_multiplier = l_1_1:get_value("money_manager", "global_value_multipliers", "superior")
  l_1_0.global_values.superior.durability_multiplier = 1.5
  l_1_0.global_values.superior.drops = false
  l_1_0.global_values.superior.track = false
  l_1_0.global_values.superior.sort_number = 100
  l_1_0.global_values.exceptional = {}
  l_1_0.global_values.exceptional.name_id = "bm_global_value_exceptional"
  l_1_0.global_values.exceptional.desc_id = "menu_l_global_value_exceptional"
  l_1_0.global_values.exceptional.color = Color.yellow
  l_1_0.global_values.exceptional.dlc = false
  l_1_0.global_values.exceptional.chance = 0.050000000745058
  l_1_0.global_values.exceptional.value_multiplier = l_1_1:get_value("money_manager", "global_value_multipliers", "exceptional")
  l_1_0.global_values.exceptional.durability_multiplier = 2.25
  l_1_0.global_values.exceptional.drops = false
  l_1_0.global_values.exceptional.track = false
  l_1_0.global_values.exceptional.sort_number = 200
  l_1_0.global_values.infamous = {}
  l_1_0.global_values.infamous.name_id = "bm_global_value_infamous"
  l_1_0.global_values.infamous.desc_id = "menu_l_global_value_infamous"
  l_1_0.global_values.infamous.color = Color(1, 0.10000000149012, 1)
  l_1_0.global_values.infamous.dlc = false
  l_1_0.global_values.infamous.chance = 0.050000000745058
  l_1_0.global_values.infamous.value_multiplier = l_1_1:get_value("money_manager", "global_value_multipliers", "infamous")
  l_1_0.global_values.infamous.durability_multiplier = 3
  l_1_0.global_values.infamous.drops = true
  l_1_0.global_values.infamous.track = false
  l_1_0.global_values.infamous.sort_number = 300
  l_1_0.global_values.preorder = {}
  l_1_0.global_values.preorder.name_id = "bm_global_value_preorder"
  l_1_0.global_values.preorder.desc_id = "menu_l_global_value_preorder"
  l_1_0.global_values.preorder.color = Color(255, 255, 140, 0) / 255
  l_1_0.global_values.preorder.dlc = true
  l_1_0.global_values.preorder.chance = 1
  l_1_0.global_values.preorder.value_multiplier = l_1_1:get_value("money_manager", "global_value_multipliers", "preorder")
  l_1_0.global_values.preorder.durability_multiplier = 1
  l_1_0.global_values.preorder.drops = false
  l_1_0.global_values.preorder.track = true
  l_1_0.global_values.preorder.sort_number = -5
  l_1_0.global_values.overkill = {}
  l_1_0.global_values.overkill.name_id = "bm_global_value_overkill"
  l_1_0.global_values.overkill.desc_id = "menu_l_global_value_overkill"
  l_1_0.global_values.overkill.color = Color(1, 0, 0)
  l_1_0.global_values.overkill.dlc = true
  l_1_0.global_values.overkill.chance = 1
  l_1_0.global_values.overkill.value_multiplier = l_1_1:get_value("money_manager", "global_value_multipliers", "overkill")
  l_1_0.global_values.overkill.durability_multiplier = 1
  l_1_0.global_values.overkill.drops = false
  l_1_0.global_values.overkill.track = true
  l_1_0.global_values.overkill.sort_number = 0
end


