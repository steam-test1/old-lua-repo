-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\input\coreinputmanager.luac 

core:module("CoreInputManager")
core:import("CoreInputContextFeeder")
core:import("CoreInputSettingsReader")
if not InputManager then
  InputManager = class()
end
InputManager.init = function(l_1_0)
  local settings_reader = CoreInputSettingsReader.SettingsReader:new()
  l_1_0._layer_descriptions = settings_reader:layer_descriptions()
  l_1_0._feeders = {}
  l_1_0._input_provider_to_feeder = {}
end

InputManager.destroy = function(l_2_0)
end

InputManager.update = function(l_3_0, l_3_1, l_3_2)
  for _,feeder in pairs(l_3_0._feeders) do
    feeder:update()
  end
end

InputManager.input_provider_id_that_presses_start = function(l_4_0)
  local layer_description_ids = {}
  local count = Input:num_real_controllers()
  for i = 1, count do
    local controller = Input:controller(i)
    if controller:connected() and controller:pressed(Idstring("start")) then
      table.insert(layer_description_ids, controller)
    end
  end
  return layer_description_ids
end

InputManager.debug_primary_input_provider_id = function(l_5_0)
  local count = (Input:num_real_controllers())
  local best_controller = nil
  for i = 1, count do
    local controller = Input:controller(i)
    if controller:connected() then
      if controller:type() == "xbox360" then
        best_controller = controller
        do return end
      elseif best_controller == nil then
        best_controller = controller
      end
    end
  end
  assert(best_controller, "You need at least one compatible controller plugged in")
  return best_controller
end

InputManager._create_input_provider_for_controller = function(l_6_0, l_6_1)
  local feeder = CoreInputContextFeeder.Feeder:new(l_6_1, l_6_0._layer_descriptions)
  local input_provider = feeder:input_provider()
  l_6_0._input_provider_to_feeder[input_provider] = feeder
  l_6_0._feeders[feeder] = feeder
  return input_provider
end

InputManager._destroy_input_provider = function(l_7_0, l_7_1)
  local feeder = l_7_0._input_provider_to_feeder[l_7_1]
  l_7_0._feeders[feeder] = nil
end


