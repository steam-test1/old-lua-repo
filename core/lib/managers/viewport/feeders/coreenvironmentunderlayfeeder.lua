-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\viewport\feeders\coreenvironmentunderlayfeeder.luac 

core:module("CoreEnvironmentUnderlayFeeder")
core:import("CoreClass")
if not EnvironmentUnderlayFeeder then
  EnvironmentUnderlayFeeder = CoreClass.class()
end
EnvironmentUnderlayFeeder.init = function(l_1_0)
end

EnvironmentUnderlayFeeder.end_feed = function(l_2_0, l_2_1)
end

EnvironmentUnderlayFeeder.feed = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4, l_3_5, ...)
  do
    local args = {...}
    if args[1] == "underlay_effect" then
      if Underlay:loaded() then
        local material_name = args[2]
        local material = Underlay:material(Idstring(material_name))
        if not material then
          return true
        end
        for k,v in pairs(l_3_5) do
          local value = v
          if k == sun_color_scale or k == color0_scale or k == color1_scale or k == color2_scale or k == color_opposite_sun_scale or k == color_sun_scale or k == sky_intensity or k == sky_intensity then
            value = v
          end
          local scalar = l_3_5[k .. "_scale"]
          if scalar then
            material:set_variable(Idstring(k), value * scalar)
            for (for control),k in (for generator) do
            end
            material:set_variable(Idstring(k), value)
          end
        end
        return true
      end
      return false
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

     -- Warning: missing end command somewhere! Added here
  end
end


