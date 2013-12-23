-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\lootmanager.luac 

if not LootManager then
  LootManager = class()
end
LootManager.init = function(l_1_0)
  l_1_0:_setup()
end

LootManager._setup = function(l_2_0)
  local distribute = {}
  local saved_secured = {}
  if Global.loot_manager then
    local saved_mandatory_bags = Global.loot_manager.mandatory_bags
  end
  if Global.loot_manager and Global.loot_manager.secured then
    saved_secured = deep_clone(Global.loot_manager.secured)
    for _,data in ipairs(Global.loot_manager.secured) do
      if not tweak_data.carry.small_loot[data.carry_id] then
        table.insert(distribute, data)
      end
    end
  end
  Global.loot_manager = {}
  Global.loot_manager.secured = {}
  Global.loot_manager.distribute = distribute
  Global.loot_manager.saved_secured = saved_secured
  if not saved_mandatory_bags then
    Global.loot_manager.mandatory_bags = {}
  end
  l_2_0._global = Global.loot_manager
  l_2_0._triggers = {}
  l_2_0._respawns = {}
end

LootManager.clear = function(l_3_0)
  Global.loot_manager = nil
end

LootManager.reset = function(l_4_0)
  Global.loot_manager = nil
  l_4_0:_setup()
end

LootManager.on_simulation_ended = function(l_5_0)
  l_5_0._respawns = {}
  l_5_0._global.mandatory_bags = {}
end

LootManager.add_trigger = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4)
  if not l_6_0._triggers[l_6_2] then
    l_6_0._triggers[l_6_2] = {}
  end
  l_6_0._triggers[l_6_2][l_6_1] = {amount = l_6_3, callback = l_6_4}
end

LootManager._check_triggers = function(l_7_0, l_7_1)
  print("LootManager:_check_triggers", l_7_1)
  if not l_7_0._triggers[l_7_1] then
    return 
  end
  if l_7_1 == "amount" then
    local bag_total_value = l_7_0:get_real_total_loot_value()
    for id,cb_data in pairs(l_7_0._triggers[l_7_1]) do
      if l_7_1 ~= "amount" or cb_data.amount <= bag_total_value then
        cb_data.callback()
      end
    end
  elseif l_7_1 == "total_amount" then
    local total_value = l_7_0:get_real_total_value()
    for id,cb_data in pairs(l_7_0._triggers[l_7_1]) do
      if cb_data.amount <= total_value then
        cb_data.callback()
      end
    end
  elseif l_7_1 == "report_only" then
    for id,cb_data in pairs(l_7_0._triggers[l_7_1]) do
      cb_data.callback()
    end
  end
end

LootManager.on_retry_job_stage = function(l_8_0)
  l_8_0._global.secured = l_8_0._global.saved_secured
end

LootManager.get_distribute = function(l_9_0)
  return table.remove(l_9_0._global.distribute, 1)
end

LootManager.get_respawn = function(l_10_0)
  return table.remove(l_10_0._respawns, 1)
end

LootManager.add_to_respawn = function(l_11_0, l_11_1, l_11_2)
  table.insert(l_11_0._respawns, {carry_id = l_11_1, value = l_11_2})
end

LootManager.on_job_deactivated = function(l_12_0)
  l_12_0:clear()
end

LootManager.secure = function(l_13_0, l_13_1, l_13_2, l_13_3)
  print("LootManager:secure", l_13_1, l_13_2)
  if Network:is_server() then
    l_13_0:server_secure_loot(l_13_1, l_13_2, l_13_3)
  else
    managers.network:session():send_to_host("server_secure_loot", l_13_1, l_13_2)
  end
end

LootManager.server_secure_loot = function(l_14_0, l_14_1, l_14_2, l_14_3)
  managers.network:session():send_to_peers_synched("sync_secure_loot", l_14_1, l_14_2, l_14_3)
  l_14_0:sync_secure_loot(l_14_1, l_14_2, l_14_3)
end

LootManager.sync_secure_loot = function(l_15_0, l_15_1, l_15_2, l_15_3)
  table.insert(l_15_0._global.secured, {carry_id = l_15_1, value = l_15_2})
  managers.hud:loot_value_updated()
  l_15_0:_check_triggers("amount")
  l_15_0:_check_triggers("total_amount")
  if not tweak_data.carry.small_loot[l_15_1] then
    l_15_0:_check_triggers("report_only")
    if not l_15_3 then
      l_15_0:_present(l_15_1, l_15_2)
  end
end

LootManager._multiplier_by_id = function(l_16_0, l_16_1)
  if tweak_data.carry.small_loot[l_16_1] then
    return "small_loot_value_multiplier"
  end
  return "value_multiplier"
end

LootManager.secure_small_loot = function(l_17_0, l_17_1, l_17_2)
  local carry_id = l_17_1
  local value = math.round(tweak_data.carry.small_loot[l_17_1] * l_17_2)
  l_17_0:secure(carry_id, value)
end

LootManager.show_small_loot_taken_hint = function(l_18_0, l_18_1, l_18_2)
  local carry_id = l_18_1
  local value = math.round(tweak_data.carry.small_loot[l_18_1] * l_18_2)
  managers.hint:show_hint("grabbed_small_loot", 2, nil, {MONEY = managers.experience:cash_string(l_18_0:get_real_value(carry_id, value))})
end

LootManager.set_mandatory_bags_data = function(l_19_0, l_19_1, l_19_2)
  l_19_0._global.mandatory_bags.carry_id = l_19_1
  l_19_0._global.mandatory_bags.amount = l_19_2
end

LootManager.get_mandatory_bags_data = function(l_20_0)
  return l_20_0._global.mandatory_bags
end

LootManager.check_secured_mandatory_bags = function(l_21_0)
  if not l_21_0._global.mandatory_bags.amount or l_21_0._global.mandatory_bags.amount == 0 then
    return true
  end
  local amount = l_21_0:get_secured_mandatory_bags_amount()
  print("mandatory amount", amount)
  return l_21_0._global.mandatory_bags.amount <= amount
end

LootManager.get_secured_mandatory_bags_amount = function(l_22_0)
  local mandatory_bags_amount = l_22_0._global.mandatory_bags.amount or 0
  if mandatory_bags_amount == 0 then
    return 0
  end
  local amount = 0
  for _,data in ipairs(l_22_0._global.secured) do
    if mandatory_bags_amount > 0 and (l_22_0._global.mandatory_bags.carry_id == "none" or l_22_0._global.mandatory_bags.carry_id == data.carry_id) then
      amount = amount + 1
      mandatory_bags_amount = mandatory_bags_amount - 1
    end
  end
  return amount
end

LootManager.get_secured_bonus_bags_amount = function(l_23_0)
  local mandatory_bags_amount = l_23_0._global.mandatory_bags.amount or 0
  local secured_mandatory_bags_amount = l_23_0:get_secured_mandatory_bags_amount()
  do
    local amount = 0
    for _,data in ipairs(l_23_0._global.secured) do
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if not tweak_data.carry.small_loot[data.carry_id] and mandatory_bags_amount > 0 and (l_23_0._global.mandatory_bags.carry_id == "none" or l_23_0._global.mandatory_bags.carry_id == data.carry_id) then
        mandatory_bags_amount = mandatory_bags_amount - 1
        for (for control),_ in (for generator) do
        end
        amount = amount + 1
      end
      return amount
    end
     -- Warning: missing end command somewhere! Added here
  end
end

LootManager.get_secured_bonus_bags_value = function(l_24_0)
  local mandatory_bags_amount = l_24_0._global.mandatory_bags.amount or 0
  do
    local value = 0
    for _,data in ipairs(l_24_0._global.secured) do
      if not tweak_data.carry.small_loot[data.carry_id] then
        if mandatory_bags_amount > 0 and (l_24_0._global.mandatory_bags.carry_id == "none" or l_24_0._global.mandatory_bags.carry_id == data.carry_id) then
          mandatory_bags_amount = mandatory_bags_amount - 1
          value = value + data.value
          for (for control),_ in (for generator) do
          end
          value = value + data.value
        end
      end
      return value
    end
     -- Warning: missing end command somewhere! Added here
  end
end

LootManager.get_real_value = function(l_25_0, l_25_1, l_25_2)
  local has_active_job = managers.job:has_active_job()
  local job_stars = has_active_job and managers.job:current_job_stars() or 1
  local mul_value = tweak_data:get_value("carry", l_25_0:_multiplier_by_id(l_25_1), job_stars)
  return l_25_2 * mul_value
end

LootManager.get_real_total_value = function(l_26_0)
  local value = 0
  for _,data in ipairs(l_26_0._global.secured) do
    value = value + l_26_0:get_real_value(data.carry_id, data.value)
  end
  return value
end

LootManager.get_real_total_loot_value = function(l_27_0)
  local value = 0
  for _,data in ipairs(l_27_0._global.secured) do
    if not tweak_data.carry.small_loot[data.carry_id] then
      value = value + l_27_0:get_real_value(data.carry_id, data.value)
    end
  end
  return value
end

LootManager.get_real_total_small_loot_value = function(l_28_0)
  local value = 0
  for _,data in ipairs(l_28_0._global.secured) do
    if tweak_data.carry.small_loot[data.carry_id] then
      value = value + l_28_0:get_real_value(data.carry_id, data.value)
    end
  end
  return value
end

LootManager.total_value_by_carry_id = function(l_29_0, l_29_1)
  local value = 0
  for _,data in ipairs(l_29_0._global.secured) do
    if data.carry_id == l_29_1 then
      value = value + data.value
    end
  end
  return value
end

LootManager.total_small_loot_value = function(l_30_0)
  local value = 0
  for _,data in ipairs(l_30_0._global.secured) do
    if tweak_data.carry.small_loot[data.carry_id] then
      value = value + data.value
    end
  end
  return value
end

LootManager.total_value_by_type = function(l_31_0, l_31_1)
  if not tweak_data.carry.types[l_31_1] then
    Application:error("Carry type", l_31_1, "doesn't exists!")
    return 
  end
  local value = 0
  for _,data in ipairs(l_31_0._global.secured) do
    if tweak_data.carry[data.carry_id].type == l_31_1 then
      value = value + data.value
    end
  end
  return value
end

LootManager._present = function(l_32_0, l_32_1, l_32_2)
  local real_value = l_32_0:get_real_value(l_32_1, l_32_2)
  local carry_data = tweak_data.carry[l_32_1]
  local title = managers.localization:text("hud_loot_secured_title")
  if carry_data.name_id then
    local type_text = managers.localization:text(carry_data.name_id)
  end
  local text = (managers.localization:text("hud_loot_secured", {CARRY_TYPE = type_text, AMOUNT = managers.experience:cash_string(real_value)}))
  local icon = nil
  managers.hud:present_mid_text({text = text, title = title, icon = icon, time = 4, event = "stinger_objectivecomplete"})
end

LootManager.sync_save = function(l_33_0, l_33_1)
  l_33_1.LootManager = l_33_0._global
end

LootManager.sync_load = function(l_34_0, l_34_1)
  l_34_0._global = l_34_1.LootManager
end


