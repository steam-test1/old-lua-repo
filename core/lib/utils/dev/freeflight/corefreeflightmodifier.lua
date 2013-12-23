-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\dev\freeflight\corefreeflightmodifier.luac 

core:module("CoreFreeFlightModifier")
if not FreeFlightModifier then
  FreeFlightModifier = class()
end
FreeFlightModifier.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0._name = assert(l_1_1)
  l_1_0._values = assert(l_1_2)
  l_1_0._index = assert(l_1_3)
  l_1_0._callback = l_1_4
end

FreeFlightModifier.step_up = function(l_2_0)
  l_2_0._index = math.clamp(l_2_0._index + 1, 1, #l_2_0._values)
  if l_2_0._callback then
    l_2_0._callback(l_2_0:value())
  end
end

FreeFlightModifier.step_down = function(l_3_0)
  l_3_0._index = math.clamp(l_3_0._index - 1, 1, #l_3_0._values)
  if l_3_0._callback then
    l_3_0._callback(l_3_0:value())
  end
end

FreeFlightModifier.name_value = function(l_4_0)
  return string.format("%10.10s %7.2f", l_4_0._name, l_4_0._values[l_4_0._index])
end

FreeFlightModifier.value = function(l_5_0)
  return l_5_0._values[l_5_0._index]
end


