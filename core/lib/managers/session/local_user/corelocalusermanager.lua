-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\local_user\corelocalusermanager.luac 

core:module("CoreLocalUserManager")
core:import("CoreLocalUser")
core:import("CoreSessionGenericState")
if not Manager then
  Manager = class(CoreSessionGenericState.State)
end
Manager.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0._factory = l_1_1
  l_1_0._controller_to_user = {}
  l_1_0._profile_settings_handler = l_1_2
  l_1_0._profile_progress_handler = l_1_3
  l_1_0._profile_data_loaded_callback = profile_data_loaded_callback
  l_1_0._input_manager = l_1_4
end

Manager.has_local_user_with_input_provider_id = function(l_2_0, l_2_1)
  return l_2_0._controller_to_user[l_2_1:key()] ~= nil
end

Manager.debug_bind_primary_input_provider_id = function(l_3_0, l_3_1)
  local count = (Input:num_real_controllers())
  local best_controller = nil
  for i = 0, count do
    local controller = Input:controller(i)
    if controller:connected() then
      local c_type = controller:type()
      if c_type == "xbox_controller" then
        best_controller = controller
        do return end
      elseif best_controller == nil then
        best_controller = controller
      end
    end
  end
  return l_3_0:bind_local_user(l_3_1, best_controller)
end

Manager.bind_local_user = function(l_4_0, l_4_1, l_4_2)
  local input_provider = l_4_0._input_manager:_create_input_provider_for_controller(l_4_2)
  local local_user = l_4_0._controller_to_user[l_4_2:key()]
  if not local_user then
    local user_index = nil
    if l_4_2.user_index then
      user_index = l_4_2:user_index()
    end
    local_user = l_4_0:_create_local_user(input_provider, user_index)
    l_4_0._controller_to_user[l_4_2:key()] = local_user
  end
  l_4_1:assign_local_user(local_user)
  return local_user
end

Manager._create_local_user = function(l_5_0, l_5_1, l_5_2)
  local local_user_handler = l_5_0._factory:create_local_user_handler()
  local created_user = CoreLocalUser.User:new(local_user_handler, l_5_1, l_5_2, l_5_0._profile_settings_handler, l_5_0._profile_progress_handler, l_5_0._profile_data_loaded_callback)
  local_user_handler._core_local_user = created_user
  return created_user
end

Manager.transition = function(l_6_0)
  for _,user in pairs(l_6_0._controller_to_user) do
    user:transition()
  end
end

Manager.is_stable_for_loading = function(l_7_0)
  for _,user in pairs(l_7_0._controller_to_user) do
    if not user:is_stable_for_loading() then
      return false
    end
  end
  return true
end

Manager.users = function(l_8_0)
  return l_8_0._controller_to_user
end

Manager.update = function(l_9_0, l_9_1, l_9_2)
  for _,user in pairs(l_9_0._controller_to_user) do
    user:update(l_9_1, l_9_2)
  end
end

Manager.enter_level_handler = function(l_10_0, l_10_1)
  for _,user in pairs(l_10_0._controller_to_user) do
    user:enter_level(l_10_1)
  end
end

Manager.leave_level_handler = function(l_11_0, l_11_1)
  for _,user in pairs(l_11_0._controller_to_user) do
    user:leave_level(l_11_1)
  end
end


