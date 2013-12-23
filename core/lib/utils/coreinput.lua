-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\utils\coreinput.luac 

core:module("CoreInput")
core:import("CoreClass")
shift = function()
  if not Input:keyboard():down(Idstring("left shift")) then
    return Input:keyboard():down(Idstring("right shift"))
  end
end

ctrl = function()
  if not Input:keyboard():down(Idstring("left ctrl")) then
    return Input:keyboard():down(Idstring("right ctrl"))
  end
end

alt = function()
  local l_3_0, l_3_1 = Input:keyboard():down, Input:keyboard()
  local l_3_2, l_3_3 = Idstring("left alt")
  return l_3_0(l_3_1, l_3_2, l_3_3)
end

if not RepKey then
  RepKey = CoreClass.class()
end
RepKey.init = function(l_4_0, l_4_1, l_4_2, l_4_3)
  if not l_4_1 then
    l_4_0._keys = {}
  end
  l_4_0._current_time = 0
  l_4_0._current_rep_time = 0
  l_4_0._pause = l_4_2 or 0.5
  l_4_0._rep = l_4_3 or 0.10000000149012
  l_4_0._input = Input:keyboard()
end

RepKey.set_input = function(l_5_0, l_5_1)
  l_5_0._input = l_5_1
end

RepKey.update = function(l_6_0, l_6_1, l_6_2)
  local anykey = false
  for _,key in ipairs(l_6_0._keys) do
    if l_6_0._input:down(Idstring(key)) then
      anykey = true
  else
    end
  end
  local down = false
  if anykey then
    if l_6_0._current_time == 0 then
      down = true
    end
    if l_6_0._pause <= l_6_0._current_time then
      down = true
      if l_6_0._rep <= l_6_0._current_rep_time then
        down = true
        l_6_0._current_rep_time = 0
      else
        down = false
        l_6_0._current_rep_time = l_6_0._current_rep_time + l_6_2
      end
    else
      l_6_0._current_time = l_6_0._current_time + l_6_2
    end
  else
    l_6_0._current_time = 0
    l_6_0._current_rep_time = 0
  end
  return down
end


