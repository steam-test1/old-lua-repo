-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\pickups\ammoclip.luac 

if not AmmoClip then
  AmmoClip = class(Pickup)
end
AmmoClip.init = function(l_1_0, l_1_1)
  AmmoClip.super.init(l_1_0, l_1_1)
  l_1_0._ammo_type = ""
end

AmmoClip._pickup = function(l_2_0, l_2_1)
  if l_2_0._picked_up then
    return 
  end
  do
    local inventory = l_2_1:inventory()
    if not l_2_1:character_damage():dead() and inventory then
      local picked_up = false
      for _,weapon in pairs(inventory:available_selections()) do
      end
      if not weapon.unit:base():add_ammo() then
        end
        if picked_up then
          l_2_0._picked_up = true
          if Network:is_client() then
            managers.network:session():send_to_host("sync_pickup", l_2_0._unit)
          end
          l_2_1:sound():play("pickup_ammo", nil, true)
          l_2_0:consume()
          return true
        end
      end
      return false
    end
     -- Warning: missing end command somewhere! Added here
  end
end


