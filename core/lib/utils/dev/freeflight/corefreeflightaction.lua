-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\dev\freeflight\corefreeflightaction.luac 

core:module("CoreFreeFlightAction")
if not FreeFlightAction then
  FreeFlightAction = class()
end
FreeFlightAction.init = function(l_1_0, l_1_1, l_1_2)
  l_1_0._name = assert(l_1_1)
  l_1_0._callback = assert(l_1_2)
end

FreeFlightAction.do_action = function(l_2_0)
  l_2_0._callback()
end

FreeFlightAction.reset = function(l_3_0)
end

FreeFlightAction.name = function(l_4_0)
  return l_4_0._name
end

if not FreeFlightActionToggle then
  FreeFlightActionToggle = class()
end
FreeFlightActionToggle.init = function(l_5_0, l_5_1, l_5_2, l_5_3, l_5_4)
  l_5_0._name1 = assert(l_5_1)
  l_5_0._name2 = assert(l_5_2)
  l_5_0._callback1 = assert(l_5_3)
  l_5_0._callback2 = assert(l_5_4)
  l_5_0._toggle = 1
end

FreeFlightActionToggle.do_action = function(l_6_0)
  if l_6_0._toggle == 1 then
    l_6_0._toggle = 2
    l_6_0._callback1()
  else
    l_6_0._toggle = 1
    l_6_0._callback2()
  end
end

FreeFlightActionToggle.reset = function(l_7_0)
  if l_7_0._toggle == 2 then
    l_7_0:do_action()
  end
end

FreeFlightActionToggle.name = function(l_8_0)
  if l_8_0._toggle == 1 then
    return l_8_0._name1
  else
    return l_8_0._name2
  end
end


