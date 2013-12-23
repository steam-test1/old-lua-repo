-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementequipment.luac 

core:import("CoreMissionScriptElement")
if not ElementEquipment then
  ElementEquipment = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementEquipment.init = function(l_1_0, ...)
  ElementEquipment.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementEquipment.on_executed = function(l_2_0, l_2_1)
  if not l_2_0._values.enabled then
    return 
  end
  if l_2_0._values.equipment ~= "none" then
    if l_2_1 == managers.player:player_unit() then
      managers.player:add_special({name = l_2_0._values.equipment, amount = l_2_0._values.amount})
    else
      local rpc_params = {"give_equipment", l_2_0._values.equipment, l_2_0._values.amount}
      l_2_1:network():send_to_unit(rpc_params)
    end
  else
    if Application:editor() then
      managers.editor:output_error("Cant give equipment " .. l_2_0._values.equipment .. " in element " .. l_2_0._editor_name .. ".")
    end
  end
end
ElementEquipment.super.on_executed(l_2_0, l_2_1)
end


