-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\pickups\specialequipmentpickup.luac 

if not SpecialEquipmentPickup then
  SpecialEquipmentPickup = class(Pickup)
end
SpecialEquipmentPickup.init = function(l_1_0, l_1_1)
  SpecialEquipmentPickup.super.init(l_1_0, l_1_1)
  managers.occlusion:remove_occlusion(l_1_1)
end

SpecialEquipmentPickup._pickup = function(l_2_0, l_2_1)
  local equipment = l_2_1:equipment()
  if not l_2_1:character_damage():dead() and equipment and managers.player:can_pickup_equipment(l_2_0._special) then
    managers.player:add_special({name = l_2_0._special, amount = l_2_0._amount})
    if Network:is_client() then
      managers.network:session():send_to_host("sync_pickup", l_2_0._unit)
    end
    if l_2_0._global_event then
      managers.mission:call_global_event(l_2_0._global_event, l_2_1)
    end
    l_2_1:sound():play("pickup_ammo", nil, true)
    l_2_0:consume()
    return true
  end
  return false
end

SpecialEquipmentPickup.destroy = function(l_3_0, ...)
  managers.occlusion:add_occlusion(l_3_0._unit)
  SpecialEquipmentPickup.super.destroy(l_3_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end


