-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\pickups\pickup.luac 

if not Pickup then
  Pickup = class(UnitBase)
end
Pickup.init = function(l_1_0, l_1_1)
  Pickup.super.init(l_1_0, l_1_1, false)
  l_1_0._unit = l_1_1
  l_1_0._active = true
end

Pickup.sync_pickup = function(l_2_0)
  l_2_0:consume()
end

Pickup._pickup = function(l_3_0)
  Application:error("Pickup didn't have a _pickup() function!")
end

Pickup.pickup = function(l_4_0, l_4_1)
  if not l_4_0._active then
    return 
  end
  return l_4_0:_pickup(l_4_1)
end

Pickup.consume = function(l_5_0)
  l_5_0:delete_unit()
end

Pickup.set_active = function(l_6_0, l_6_1)
  l_6_0._active = l_6_1
end

Pickup.delete_unit = function(l_7_0)
  World:delete_unit(l_7_0._unit)
end

Pickup.save = function(l_8_0, l_8_1)
  local state = {}
  state.active = l_8_0._active
  l_8_1.Pickup = state
end

Pickup.load = function(l_9_0, l_9_1)
  local state = l_9_1.Pickup
  if state then
    l_9_0:set_active(state.active)
  end
end

Pickup.destroy = function(l_10_0, l_10_1)
end


