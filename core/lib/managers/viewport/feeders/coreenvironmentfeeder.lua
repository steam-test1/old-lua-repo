-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\viewport\feeders\coreenvironmentfeeder.luac 

core:module("CoreEnvironmentFeeder")
core:import("CoreClass")
core:import("CoreEnvironmentNetworkFeeder")
core:import("CoreEnvironmentPostProcessorFeeder")
core:import("CoreEnvironmentUnderlayFeeder")
core:import("CoreEnvironmentOthersFeeder")
if not EnvironmentFeeder then
  EnvironmentFeeder = CoreClass.class()
end
EnvironmentFeeder.init = function(l_1_0)
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- Warning: undefined locals caused missing assignments!
end

EnvironmentFeeder.feed = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4)
  l_2_1:for_each(function(l_1_0, ...)
    for _,feeder in ipairs(self:feeders()) do
      if feeder:feed(nr, scene, vp, data, l_1_0, ...) then
        return 
      end
    end
    error("[EnvironmentFeeder] No suitable feeder found! Data: ", ...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end)
  for _,feeder in ipairs(l_2_0:feeders()) do
    feeder:end_feed(l_2_2)
  end
end

EnvironmentFeeder.feeders = function(l_3_0)
  if not managers.slave:connected() or not l_3_0._enable_slaving or not l_3_0._production_feeders then
    return l_3_0._feeders
  end
end

EnvironmentFeeder.slaving = function(l_4_0)
  return not l_4_0._enable_slaving or true
end

EnvironmentFeeder.set_slaving = function(l_5_0, l_5_1)
  l_5_0._enable_slaving = l_5_1
end


