-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\props\safehousemoneystack.luac 

if not SafehouseMoneyStack then
  SafehouseMoneyStack = class(UnitBase)
end
SafehouseMoneyStack.SMALL_MAX_SUM = 1000000
SafehouseMoneyStack.MAX_SUM = 10000000 + SafehouseMoneyStack.SMALL_MAX_SUM - 1
SafehouseMoneyStack.STEPS = 19
SafehouseMoneyStack.SMALL_STEPS = 85
SafehouseMoneyStack.init = function(l_1_0, l_1_1)
  UnitBase.init(l_1_0, l_1_1, false)
  l_1_0._unit = l_1_1
  l_1_0:_setup()
end

SafehouseMoneyStack._setup = function(l_2_0)
  l_2_0._small_sequences = {}
  for i = 1, SafehouseMoneyStack.SMALL_STEPS do
    local post_fix = (i < 10 and "0" or "") .. i
    table.insert(l_2_0._small_sequences, "var_small_money_grow_" .. post_fix)
  end
  l_2_0._sequences = {}
  for i = 1, SafehouseMoneyStack.STEPS do
    local post_fix = (i < 10 and "0" or "") .. i
    table.insert(l_2_0._sequences, "var_money_grow_" .. post_fix)
  end
  local money = managers.money:total()
  l_2_0:_run_sequences(money)
end

SafehouseMoneyStack._run_sequences = function(l_3_0, l_3_1)
  local small_sum = math.mod(l_3_1, SafehouseMoneyStack.SMALL_MAX_SUM)
  local where = math.min(small_sum / SafehouseMoneyStack.SMALL_MAX_SUM, 1)
  local sequence_index = math.ceil(where * #l_3_0._small_sequences)
  print("where small", where, sequence_index)
  if sequence_index ~= 0 or not "var_small_money_grow_00" then
    local sequence = l_3_0._small_sequences[math.clamp(sequence_index, 1, #l_3_0._small_sequences)]
  end
  l_3_0._unit:damage():run_sequence_simple(sequence)
  l_3_1 = l_3_1 - small_sum
  local where = math.min((l_3_1) / SafehouseMoneyStack.MAX_SUM, 1)
  local sequence_index = math.ceil(where * #l_3_0._sequences)
  if sequence_index ~= 0 or not "var_money_grow_00" then
    local sequence = l_3_0._sequences[math.clamp(sequence_index, 1, #l_3_0._sequences)]
  end
  l_3_0._unit:damage():run_sequence_simple(sequence)
end

SafehouseMoneyStack.debug_test = function(l_4_0)
  l_4_0._test_money = 0
  l_4_0._unit:set_extension_update_enabled(Idstring("base"), true)
end

SafehouseMoneyStack.update = function(l_5_0)
  if l_5_0._test_money then
    l_5_0:_run_sequences(l_5_0._test_money)
    l_5_0._test_money = l_5_0._test_money + 25000
    if SafehouseMoneyStack.MAX_SUM <= l_5_0._test_money then
      l_5_0._test_money = nil
    end
  end
end

SafehouseMoneyStack.destroy = function(l_6_0)
end


