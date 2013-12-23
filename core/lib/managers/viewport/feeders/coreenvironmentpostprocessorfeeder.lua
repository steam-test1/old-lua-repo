-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\viewport\feeders\coreenvironmentpostprocessorfeeder.luac 

core:module("CoreEnvironmentPostProcessorFeeder")
core:import("CoreClass")
core:import("CoreCode")
if not EnvironmentPostProcessorFeeder then
  EnvironmentPostProcessorFeeder = CoreClass.class()
end
EnvironmentPostProcessorFeeder.init = function(l_1_0)
  l_1_0._cached_processor = {}
end

EnvironmentPostProcessorFeeder.end_feed = function(l_2_0, l_2_1)
end

EnvironmentPostProcessorFeeder.processor = function(l_3_0, l_3_1, l_3_2, l_3_3, l_3_4)
  local name = tostring(l_3_1) .. l_3_3 .. l_3_4
  local proc = l_3_0._cached_processor[name]
  if not CoreCode.alive(proc) then
    proc = l_3_2:get_post_processor_effect(l_3_1, Idstring(l_3_3), Idstring(l_3_4))
    l_3_0._cached_processor[name] = l_3_2:get_post_processor_effect(l_3_1, Idstring(l_3_3), Idstring(l_3_4))
  end
  return proc
end

EnvironmentPostProcessorFeeder.feed = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4, l_4_5, ...)
  do
    local args = {...}
    if args[1] == "post_effect" then
      local processor_name = args[2]
      local effect_name = args[3]
      local modifier_name = args[4]
      local processor = l_4_0:processor(l_4_2, l_4_3, processor_name, effect_name)
      if processor then
        local modifier = processor:modifier(Idstring(modifier_name))
        if modifier then
          local material = modifier:material()
          if material then
            for k,v in pairs(l_4_5) do
              local value = v
              if k == "luminance_clamp" or k == "start_color" or k == "color0" or k == "color1" or k == "color2" or k == "environment_map_intensity" or k == "environment_map_intensity_shadow" or k == "ambient_color" or k == "sky_top_color" or k == "sky_bottom_color" or k == "sky_reflection_bottom_color" or k == "sky_reflection_top_color" or k == "sun_specular_color" or k == "fog_start_color" then
                value = v * LightIntensityDB:platform_intensity_scale()
                do return end
                if k == "ambient_color" or k == "sky_top_color" or k == "sky_bottom_color" or k == "fog_min_range" or k == "fog_max_range" then
                  modifier = processor:modifier(Idstring("shadow"))
                  if modifier then
                    material = modifier:material()
                    do
                      if material then
                        local scalar = l_4_5[k .. "_scale"]
                        if scalar then
                          material:set_variable(Idstring(k), value * scalar)
                          for (for control),k in (for generator) do
                          end
                          material:set_variable(Idstring(k), value)
                        end
                        for (for control),k in (for generator) do
                        end
                        do
                          local scalar = l_4_5[k .. "_scale"]
                          if scalar then
                            material:set_variable(Idstring(k), value * scalar)
                            for (for control),k in (for generator) do
                            end
                            material:set_variable(Idstring(k), value)
                          end
                          for (for control),k in (for generator) do
                          end
                          local scalar = l_4_5[k .. "_scale"]
                          if scalar then
                            material:set_variable(Idstring(k), value * scalar)
                            for (for control),k in (for generator) do
                            end
                            material:set_variable(Idstring(k), value)
                          end
                        end
                      end
                    end
                  end
                end
                return true
              end
              return false
            end
             -- DECOMPILER ERROR: Confused about usage of registers for local variables.

             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end


