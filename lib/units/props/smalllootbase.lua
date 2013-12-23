-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\props\smalllootbase.luac 

if not SmallLootBase then
  SmallLootBase = class(UnitBase)
end
SmallLootBase.init = function(l_1_0, l_1_1)
  UnitBase.init(l_1_0, l_1_1, false)
  l_1_0._unit = l_1_1
  l_1_0:_setup()
end

SmallLootBase._setup = function(l_2_0)
end

SmallLootBase.take = function(l_3_0, l_3_1)
  if l_3_0._empty then
    return 
  end
  l_3_1:sound():play("money_grab")
  local small_loot_multiplier_upgrade_level = managers.player:upgrade_level("player", "small_loot_multiplier")
  local multiplier = managers.player:upgrade_value("player", "small_loot_multiplier", 1)
  managers.loot:show_small_loot_taken_hint(l_3_0.small_loot, multiplier)
  if Network:is_server() then
    l_3_0:taken(small_loot_multiplier_upgrade_level)
  else
    managers.network:session():send_to_peers_synched("sync_small_loot_taken", l_3_0._unit, small_loot_multiplier_upgrade_level)
  end
end

SmallLootBase.taken = function(l_4_0, l_4_1)
  local multiplier = managers.player:upgrade_value_by_level("player", "small_loot_multiplier", l_4_1, 1)
  managers.loot:secure_small_loot(l_4_0.small_loot, multiplier)
  l_4_0:_set_empty()
end

SmallLootBase._set_empty = function(l_5_0)
  l_5_0._empty = true
  if not l_5_0.skip_remove_unit then
    l_5_0._unit:set_slot(0)
  end
end

SmallLootBase.destroy = function(l_6_0)
end


