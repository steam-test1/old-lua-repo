-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hudmanageranimatepd2.luac 

core:import("CoreEvent")
HUDManager._animate_test_circle = function(l_1_0)
  do
    local t = 2
    repeat
      if t > 0 then
        local dt = coroutine.yield()
        t = t - dt
      else
        print("done")
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDManager._animate_ammo_test = function(l_2_0, l_2_1)
  do
    local t = 3
    l_2_1:set_alpha(1)
    repeat
      repeat
        if t > 0 then
          local dt = coroutine.yield()
          t = t - dt
        until t < 2
        l_2_1:set_alpha((t) / 2)
      else
        l_2_1:set_alpha(0)
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end


