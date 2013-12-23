-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\props\moneywrapbase.luac 

if not MoneyWrapBase then
  MoneyWrapBase = class(UnitBase)
end
MoneyWrapBase.taken_wraps = MoneyWrapBase.taken_wraps or 0
MoneyWrapBase.init = function(l_1_0, l_1_1)
  UnitBase.init(l_1_0, l_1_1, false)
  l_1_0._unit = l_1_1
  l_1_0:_setup()
end

MoneyWrapBase._setup = function(l_2_0)
  l_2_0._MONEY_MAX = l_2_0.max_amount or 1000000
  l_2_0._money_amount = l_2_0._MONEY_MAX
  l_2_0._sequence_stage = 10
end

MoneyWrapBase.take_money = function(l_3_0, l_3_1)
  if l_3_0._empty then
    return 
  end
  if l_3_0.give_exp then
    l_3_1:sound():play("money_grab")
    managers.network:session():send_to_peers_synched("sync_money_wrap_money_taken", l_3_0._unit)
    l_3_0._money_amount = 0
    MoneyWrapBase.taken_wraps = MoneyWrapBase.taken_wraps + 1
    if MoneyWrapBase.taken_wraps >= 10 and Global.level_data.level_id == "apartment" then
      managers.challenges:set_flag("take_money")
    else
      local taken = l_3_0:_take_money(l_3_1)
      if taken > 0 then
        l_3_1:sound():play("money_grab")
        managers.network:session():send_to_peers_synched("sync_money_wrap_money_taken", l_3_0._unit)
      end
      managers.money:perform_action_money_wrap(taken)
    end
  end
  if l_3_0._money_amount <= 0 then
    l_3_0:_set_empty()
  end
  l_3_0:_update_sequences()
end

MoneyWrapBase.sync_money_taken = function(l_4_0)
  if l_4_0.give_exp then
    l_4_0._money_amount = 0
  do
    elseif not l_4_0.money_action or not tweak_data:get_value("money_manager", "actions", l_4_0.money_action) then
      local amount = l_4_0._MONEY_MAX / 2
    end
    managers.money:perform_action_money_wrap(amount)
    l_4_0._money_amount = math.max(l_4_0._money_amount - amount, 0)
  end
  if l_4_0._money_amount <= 0 then
    l_4_0:_set_empty()
  end
  l_4_0:_update_sequences()
end

MoneyWrapBase._take_money = function(l_5_0, l_5_1)
  if not l_5_0.money_action or not tweak_data:get_value("money_manager", "actions", l_5_0.money_action) then
    local took = l_5_0._MONEY_MAX / 2
  end
  l_5_0._money_amount = math.max(l_5_0._money_amount - took, 0)
  if l_5_0._money_amount <= 0 then
    l_5_0:_set_empty()
  end
  return took
end

MoneyWrapBase._update_sequences = function(l_6_0)
  local stage = math.round(l_6_0._money_amount / l_6_0._MONEY_MAX * 9) + 1
  if stage < l_6_0._sequence_stage then
    l_6_0._sequence_stage = stage
    l_6_0._unit:damage():run_sequence_simple("money_wrap_" .. l_6_0._sequence_stage)
  end
end

MoneyWrapBase._set_empty = function(l_7_0)
  l_7_0._empty = true
  if not l_7_0.skip_remove_unit then
    l_7_0._unit:set_slot(0)
  end
end

MoneyWrapBase.update = function(l_8_0, l_8_1, l_8_2, l_8_3)
end

MoneyWrapBase.save = function(l_9_0, l_9_1)
  MoneyWrapBase.super.save(l_9_0, l_9_1)
  local state = {}
  state.money_amount = l_9_0._money_amount
  l_9_1.MoneyWrapBase = state
end

MoneyWrapBase.load = function(l_10_0, l_10_1)
  MoneyWrapBase.super.load(l_10_0, l_10_1)
  local state = l_10_1.MoneyWrapBase
  l_10_0._money_amount = state.money_amount
end

MoneyWrapBase.destroy = function(l_11_0)
end


