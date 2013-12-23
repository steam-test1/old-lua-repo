-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\controller\corecontrollerwrapper.luac 

core:module("CoreControllerWrapper")
core:import("CoreControllerWrapperSettings")
core:import("CoreAccessObjectBase")
if not ControllerWrapper then
  ControllerWrapper = class(CoreAccessObjectBase.AccessObjectBase)
end
ControllerWrapper.TYPE = "generic"
ControllerWrapper.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5, l_1_6, l_1_7, l_1_8, l_1_9)
  ControllerWrapper.super.init(l_1_0, l_1_1, l_1_3)
  l_1_0._id = l_1_2
  l_1_0._name = l_1_3
  l_1_0._controller_map = l_1_4
  l_1_0._default_controller_id = l_1_5
  l_1_0._setup = l_1_6
  l_1_0._debug = l_1_7
  if not l_1_8 then
    l_1_0._virtual_controller = Input:create_virtual_controller("ctrl_" .. tostring(l_1_0._id))
  end
  if not l_1_9 then
    l_1_0._custom_virtual_connect_func_map = {}
  end
  for controller_id in pairs(l_1_4) do
    if not l_1_0._custom_virtual_connect_func_map[controller_id] then
      l_1_0._custom_virtual_connect_func_map[controller_id] = {}
    end
  end
  l_1_0._connection_map = {}
  l_1_0._trigger_map = {}
  l_1_0._release_trigger_map = {}
  l_1_0._current_lerp_axis_map = {}
  l_1_0._claimed = false
  l_1_0._enabled = false
  l_1_0._delay_map = {}
  l_1_0._delay_bool_map = {}
  l_1_0._multi_input_map = {}
  l_1_0:setup(l_1_0._setup)
  l_1_0._was_connected = l_1_0:connected()
  l_1_0._reset_cache_time = TimerManager:wall_running():time() - 1
  l_1_0._delay_trigger_queue = {}
  l_1_0._input_pressed_cache = {}
  l_1_0._input_bool_cache = {}
  l_1_0._input_float_cache = {}
  l_1_0._input_axis_cache = {}
  l_1_0:reset_cache(false)
  l_1_0._destroy_callback_list = {}
  l_1_0._last_destroy_callback_id = 0
  l_1_0._connect_changed_callback_list = {}
  l_1_0._last_connect_changed_callback_id = 0
  l_1_0._rebind_callback_list = {}
  l_1_0._last_rebind_callback_id = 0
end

ControllerWrapper.destroy = function(l_2_0)
  for id,func in pairs(l_2_0._destroy_callback_list) do
    func(l_2_0, id)
  end
  if alive(l_2_0._virtual_controller) then
    Input:destroy_virtual_controller(l_2_0._virtual_controller)
    l_2_0._virtual_controller = nil
  end
end

ControllerWrapper.update = function(l_3_0, l_3_1, l_3_2)
  l_3_0:reset_cache(true)
  l_3_0:update_delay_trigger_queue()
  l_3_0:check_connect_changed_status()
  if alive(l_3_0._virtual_controller) then
    l_3_0._virtual_controller:clear_axis_triggers()
  end
end

ControllerWrapper.paused_update = function(l_4_0, l_4_1, l_4_2)
  l_4_0:reset_cache(true)
  l_4_0:update_delay_trigger_queue()
  l_4_0:check_connect_changed_status()
  if alive(l_4_0._virtual_controller) then
    l_4_0._virtual_controller:clear_axis_triggers()
  end
end

ControllerWrapper.reset_cache = function(l_5_0, l_5_1)
  local reset_cache_time = TimerManager:wall_running():time()
  if not l_5_1 or l_5_0._reset_cache_time < reset_cache_time then
    l_5_0._input_any_cache = nil
    l_5_0._input_any_pressed_cache = nil
    l_5_0._input_any_released_cache = nil
    if next(l_5_0._input_pressed_cache) then
      l_5_0._input_pressed_cache = {}
    end
    if next(l_5_0._input_bool_cache) then
      l_5_0._input_bool_cache = {}
    end
    if next(l_5_0._input_float_cache) then
      l_5_0._input_float_cache = {}
    end
    if next(l_5_0._input_axis_cache) then
      l_5_0._input_axis_cache = {}
    end
    l_5_0:update_multi_input()
    l_5_0:update_delay_input()
    l_5_0._reset_cache_time = reset_cache_time
  end
end

ControllerWrapper.update_delay_trigger_queue = function(l_6_0)
  if l_6_0._enabled and l_6_0._virtual_controller then
    for connection_name,data in pairs(l_6_0._delay_trigger_queue) do
      if not l_6_0._virtual_controller:down(Idstring(connection_name)) then
        l_6_0._delay_trigger_queue[connection_name] = nil
        for (for control),connection_name in (for generator) do
        end
        if l_6_0:get_input_bool(connection_name) then
          l_6_0._delay_trigger_queue[connection_name] = nil
          data.func(unpack(data.func_params))
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ControllerWrapper.check_connect_changed_status = function(l_7_0)
  local connected = l_7_0:connected()
  if connected ~= l_7_0._was_connected then
    for callback_id,func in pairs(l_7_0._connect_changed_callback_list) do
      func(l_7_0, connected, callback_id)
    end
    l_7_0._was_connected = connected
  end
end

ControllerWrapper.update_multi_input = function(l_8_0)
  if l_8_0._enabled and l_8_0._virtual_controller then
    for connection_name,single_connection_name_list in pairs(l_8_0._multi_input_map) do
      if l_8_0:get_connection_enabled(connection_name) then
        local bool = nil
        for _,single_connection_name in ipairs(single_connection_name_list) do
          bool = l_8_0._virtual_controller:down(Idstring(single_connection_name))
          if not bool then
            do return end
          end
        end
        if bool then
          l_8_0._input_bool_cache[connection_name] = bool
          for (for control),connection_name in (for generator) do
          end
          l_8_0._input_bool_cache[connection_name] = false
          l_8_0._input_pressed_cache[connection_name] = false
          l_8_0._input_float_cache[connection_name] = 0
          l_8_0._input_axis_cache[connection_name] = Vector3()
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ControllerWrapper.update_delay_input = function(l_9_0)
  if l_9_0._enabled and l_9_0._virtual_controller then
    local wall_time = TimerManager:wall():time()
    for connection_name,delay_data in pairs(l_9_0._delay_map) do
      if l_9_0:get_connection_enabled(connection_name) then
        local delay_time_map = delay_data.delay_time_map
        local connection = delay_data.connection
        local delay = connection:get_delay()
        if delay > 0 then
          if not l_9_0:get_input_bool(connection_name) then
            for delay_connection_name,delay_time in pairs(delay_time_map) do
              local down = (l_9_0:get_input_bool(delay_connection_name))
              local allow = nil
              if down then
                if not delay_time then
                  delay_time_map[delay_connection_name] = wall_time + delay
                elseif delay_time <= wall_time then
                  allow = true
                end
                if not allow then
                  l_9_0._input_bool_cache[delay_connection_name] = false
                  l_9_0._input_pressed_cache[connection_name] = false
                  l_9_0._input_float_cache[delay_connection_name] = 0
                  l_9_0._input_axis_cache[delay_connection_name] = Vector3()
                  for (for control),delay_connection_name in (for generator) do
                  end
                  if delay_time then
                    delay_time_map[delay_connection_name] = false
                  end
                end
              end
              for (for control),connection_name in (for generator) do
              end
              for delay_connection_name,delay_time in pairs(delay_time_map) do
                delay_time_map[delay_connection_name] = wall_time - delay
              end
            end
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ControllerWrapper.add_destroy_callback = function(l_10_0, l_10_1)
  l_10_0._last_destroy_callback_id = l_10_0._last_destroy_callback_id + 1
  l_10_0._destroy_callback_list[l_10_0._last_destroy_callback_id] = l_10_1
  return l_10_0._last_destroy_callback_id
end

ControllerWrapper.remove_destroy_callback = function(l_11_0, l_11_1)
  l_11_0._destroy_callback_list[l_11_1] = nil
end

ControllerWrapper.add_connect_changed_callback = function(l_12_0, l_12_1)
  l_12_0._last_connect_changed_callback_id = l_12_0._last_connect_changed_callback_id + 1
  l_12_0._connect_changed_callback_list[l_12_0._last_connect_changed_callback_id] = l_12_1
  return l_12_0._last_connect_changed_callback_id
end

ControllerWrapper.remove_connect_changed_callback = function(l_13_0, l_13_1)
  l_13_0._connect_changed_callback_list[l_13_1] = nil
end

ControllerWrapper.add_rebind_callback = function(l_14_0, l_14_1)
  l_14_0._last_rebind_callback_id = l_14_0._last_rebind_callback_id + 1
  l_14_0._rebind_callback_list[l_14_0._last_rebind_callback_id] = l_14_1
  return l_14_0._last_rebind_callback_id
end

ControllerWrapper.remove_rebind_callback = function(l_15_0, l_15_1)
  l_15_0._rebind_callback_list[l_15_1] = nil
end

ControllerWrapper.rebind_connections = function(l_16_0, l_16_1, l_16_2)
  l_16_0:clear_connections(false)
  l_16_0:clear_triggers(true)
  if not l_16_1 then
    l_16_0:setup(l_16_0._setup)
  end
  if l_16_0._enabled then
    l_16_0:restore_triggers()
  end
  for id,func in pairs(l_16_0._rebind_callback_list) do
    func(l_16_0, id)
  end
end

ControllerWrapper.setup = function(l_17_0, l_17_1)
  if l_17_1 then
    l_17_0._setup = l_17_1
    local connection_map = l_17_1:get_connection_map()
    for connection_name,connection in pairs(connection_map) do
      if not connection:get_controller_id() then
        local controller_id = l_17_0._default_controller_id
      end
      local controller = l_17_0._controller_map[controller_id]
      l_17_0:setup_connection(connection_name, connection, controller_id, controller)
    end
  end
end

ControllerWrapper.setup_connection = function(l_18_0, l_18_1, l_18_2, l_18_3, l_18_4)
  if l_18_0._debug or not l_18_2:get_debug() then
    local input_name_list = l_18_2:get_input_name_list()
    for index,input_name in ipairs(input_name_list) do
      l_18_0:connect(l_18_3, input_name, l_18_1, l_18_2, index ~= 1, (#input_name_list > 0 and not l_18_2:get_any_input()))
    end
    local delay_data = nil
    local delay_connection_list = l_18_2:get_delay_connection_list()
    for index,delay_connection_referer in ipairs(delay_connection_list) do
      local delay_connection_name = delay_connection_referer:get_name()
      do
        local delay_connection = l_18_0._setup:get_connection(delay_connection_name)
        if delay_connection then
          local delay_input_name_list = (delay_connection:get_input_name_list())
          do
            local can_delay = nil
            for _,delay_input_name in ipairs(delay_input_name_list) do
              for _,input_name in ipairs(input_name_list) do
                if delay_input_name == input_name then
                  if not delay_data then
                    delay_data = {}
                    delay_data.delay_time_map = {}
                    delay_data.connection = l_18_2
                  end
                  delay_data.delay_time_map[delay_connection_name] = false
                  l_18_0._delay_bool_map[delay_connection_name] = true
                  can_delay = true
              else
                end
              end
              if can_delay then
                for (for control),index in (for generator) do
                end
              end
            end
            for i_1,i_2 in (for generator) do
            end
            Application:error(l_18_0:to_string() .. " Unable to setup delay on non-existing connection \"" .. tostring(delay_connection_name) .. "\" in the \"" .. tostring(l_18_1) .. "\" connection.")
          end
           -- DECOMPILER ERROR: Confused about usage of registers for local variables.

        end
        l_18_0._delay_map[l_18_1] = delay_data
        if l_18_2.IS_AXIS and not l_18_2:get_init_lerp_axis() and (not l_18_0._virtual_controller or not l_18_0._virtual_controller:axis(Idstring(l_18_1))) then
          l_18_0._current_lerp_axis_map[l_18_1] = Vector3()
           -- DECOMPILER ERROR: Confused about usage of registers for local variables.

        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ControllerWrapper.connect = function(l_19_0, l_19_1, l_19_2, l_19_3, l_19_4, l_19_5, l_19_6)
  if not l_19_1 then
    local controller = l_19_0._controller_map[l_19_0._default_controller_id]
  end
  if controller then
    if l_19_0._virtual_controller then
      if not l_19_5 and l_19_0._connection_map[l_19_3] then
        Application:error(l_19_0:to_string() .. " Controller already has a \"" .. tostring(l_19_3) .. "\" connection. Overwrites existing one.")
      end
      l_19_0:virtual_connect(l_19_1, controller, l_19_2, l_19_3, l_19_4)
      l_19_0._connection_map[l_19_3] = true
      if l_19_6 then
        if not l_19_0._multi_input_map[l_19_3] then
          local single_connection_name_list = {}
        end
        local single_connection_name = tostring(l_19_3) .. "_for_single_input_" .. tostring(l_19_2)
        l_19_0:virtual_connect(l_19_1, controller, l_19_2, single_connection_name, l_19_4)
        table.insert(single_connection_name_list, single_connection_name)
        l_19_0._multi_input_map[l_19_3] = single_connection_name_list
      else
        Application:stack_dump_error("Tried to connect to a destroyed virtual controller.")
      end
    else
      error("Invalid controller wrapper. Tried to connect to non-existing controller id \"" .. tostring(l_19_1) .. "\".")
    end
  end
end

ControllerWrapper.virtual_connect = function(l_20_0, l_20_1, l_20_2, l_20_3, l_20_4, l_20_5)
  local func = l_20_0._custom_virtual_connect_func_map[l_20_1][l_20_3]
  if func then
    func(l_20_1, l_20_2, l_20_3, l_20_4, l_20_5)
  else
    l_20_0:virtual_connect2(l_20_0, l_20_1, l_20_2, l_20_3, l_20_4, l_20_5)
  end
end

ControllerWrapper.virtual_connect2 = function(l_21_0, l_21_1, l_21_2, l_21_3, l_21_4, l_21_5)
  local min_src, max_src, min_dest, max_dest = l_21_5:get_range()
  local connect_src_type = l_21_5:get_connect_src_type()
  local connect_dest_type = l_21_5:get_connect_dest_type()
  if type(l_21_3) ~= "number" then
    l_21_3 = Idstring(l_21_3)
  end
  l_21_0._virtual_controller:connect(l_21_2, Idstring(connect_src_type), l_21_3, Idstring("range"), min_src, max_src, Idstring(connect_dest_type), Idstring(l_21_4), Idstring("range"), min_dest, max_dest)
end

ControllerWrapper.connected = function(l_22_0, l_22_1)
  if l_22_1 then
    return l_22_0._controller_map[l_22_1]:connected()
  else
    for _,controller in pairs(l_22_0._controller_map) do
      if not controller:connected() then
        return false
      end
    end
    return true
  end
end

ControllerWrapper.get_setup = function(l_23_0)
  return l_23_0._setup
end

ControllerWrapper.get_connection_settings = function(l_24_0, l_24_1)
  return l_24_0._setup:get_connection(l_24_1)
end

ControllerWrapper.get_default_controller_id = function(l_25_0)
  return l_25_0._default_controller_id
end

ControllerWrapper.get_type = function(l_26_0)
  return l_26_0.TYPE
end

ControllerWrapper.get_id = function(l_27_0)
  return l_27_0._id
end

ControllerWrapper.get_name = function(l_28_0)
  return l_28_0._name
end

ControllerWrapper.get_debug = function(l_29_0)
  return l_29_0._debug
end

ControllerWrapper.get_connection_map = function(l_30_0)
  return l_30_0._connection_map
end

ControllerWrapper.get_controller_map = function(l_31_0)
  return l_31_0._controller_map
end

ControllerWrapper.get_controller = function(l_32_0, l_32_1)
  if not l_32_1 then
    return l_32_0._controller_map[l_32_0._default_controller_id]
  end
end

ControllerWrapper.connection_exist = function(l_33_0, l_33_1)
  return l_33_0._connection_map[l_33_1] ~= nil
end

ControllerWrapper.set_enabled = function(l_34_0, l_34_1)
  if l_34_1 then
    l_34_0:enable()
  else
    l_34_0:disable()
  end
end

ControllerWrapper.enable = function(l_35_0)
  l_35_0:set_active(true)
end

ControllerWrapper.disable = function(l_36_0)
  l_36_0:set_active(false)
end

ControllerWrapper._really_activate = function(l_37_0)
  ControllerWrapper.super._really_activate(l_37_0)
  if not l_37_0._enabled then
    cat_print("controller_manager", "[ControllerManager] Enabled controller \"" .. tostring(l_37_0._name) .. "\".")
    if l_37_0._virtual_controller then
      l_37_0._virtual_controller:set_enabled(true)
    end
    l_37_0._enabled = true
    l_37_0:clear_triggers(true)
    l_37_0:restore_triggers()
    l_37_0:reset_cache(false)
    l_37_0._was_connected = l_37_0:connected()
  end
end

ControllerWrapper._really_deactivate = function(l_38_0)
  ControllerWrapper.super._really_deactivate(l_38_0)
  if l_38_0._enabled then
    cat_print("controller_manager", "[ControllerManager] Disabled controller \"" .. tostring(l_38_0._name) .. "\".")
    l_38_0._enabled = false
    l_38_0:clear_triggers(true)
    l_38_0:reset_cache(false)
    if l_38_0._virtual_controller then
      l_38_0._virtual_controller:set_enabled(false)
    end
  end
end

ControllerWrapper.enabled = function(l_39_0)
  return l_39_0._enabled
end

ControllerWrapper.is_claimed = function(l_40_0)
  return l_40_0._claimed
end

ControllerWrapper.set_claimed = function(l_41_0, l_41_1)
  l_41_0._claimed = l_41_1
end

ControllerWrapper.add_trigger = function(l_42_0, l_42_1, l_42_2)
  local trigger = {}
  if not l_42_0._trigger_map[l_42_1] then
    l_42_0._trigger_map[l_42_1] = {}
  end
  if l_42_0._trigger_map[l_42_1][l_42_2] then
    Application:error(l_42_0:to_string() .. " Unable to register already existing trigger for function \"" .. tostring(l_42_2) .. "\" on connection \"" .. tostring(l_42_1) .. "\".")
    return 
  end
  trigger.original_func = l_42_2
  trigger.func = l_42_0:get_trigger_func(l_42_1, l_42_2)
  if l_42_0._enabled and l_42_0._virtual_controller and l_42_0:get_connection_enabled(l_42_1) then
    trigger.id = l_42_0._virtual_controller:add_trigger(Idstring(l_42_1), trigger.func)
  end
  l_42_0._trigger_map[l_42_1][l_42_2] = trigger
end

ControllerWrapper.add_release_trigger = function(l_43_0, l_43_1, l_43_2)
  local trigger = {}
  if not l_43_0._release_trigger_map[l_43_1] then
    l_43_0._release_trigger_map[l_43_1] = {}
  end
  trigger.original_func = l_43_2
  trigger.func = l_43_0:get_release_trigger_func(l_43_1, l_43_2)
  if l_43_0._virtual_controller and l_43_0:get_connection_enabled(l_43_1) then
    trigger.id = l_43_0._virtual_controller:add_release_trigger(Idstring(l_43_1), trigger.func)
  end
  l_43_0._release_trigger_map[l_43_1][l_43_2] = trigger
end

ControllerWrapper.get_trigger_func = function(l_44_0, l_44_1, l_44_2)
  local wrapper = l_44_0
  if l_44_0._delay_bool_map[l_44_1] or l_44_0._multi_input_map[l_44_1] then
    return function(...)
    wrapper:reset_cache(true)
    if wrapper:get_input_bool(connection_name) then
      func(...)
    else
      wrapper:queue_delay_trigger(connection_name, func, ...)
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
   end
  else
    return function(...)
    wrapper:reset_cache(true)
    func(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end
  end
end

ControllerWrapper.get_release_trigger_func = function(l_45_0, l_45_1, l_45_2)
  local wrapper = l_45_0
  if l_45_0._delay_bool_map[l_45_1] or l_45_0._multi_input_map[l_45_1] then
    return function(...)
    wrapper:reset_cache(true)
    if wrapper:get_input_bool(connection_name) then
      func(...)
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
   end
  else
    return function(...)
    wrapper:reset_cache(true)
    func(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end
  end
end

ControllerWrapper.queue_delay_trigger = function(l_46_0, l_46_1, l_46_2, ...)
  l_46_0._delay_trigger_queue[l_46_1] = {func = l_46_2, func_params = {...}}
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ControllerWrapper.has_trigger = function(l_47_0, l_47_1, l_47_2)
  local trigger_sub_map = l_47_0._trigger_map[l_47_1]
  if trigger_sub_map then
    return trigger_sub_map[l_47_2]
  end
end

ControllerWrapper.has_release_trigger = function(l_48_0, l_48_1, l_48_2)
  local release_trigger_sub_map = l_48_0._release_trigger_map[l_48_1]
  if release_trigger_sub_map then
    return release_trigger_sub_map[l_48_2]
  end
end

ControllerWrapper.remove_trigger = function(l_49_0, l_49_1, l_49_2)
  local trigger_sub_map = l_49_0._trigger_map[l_49_1]
  if trigger_sub_map then
    if l_49_2 then
      local trigger = trigger_sub_map[l_49_2]
      if trigger then
        local queued_trigger = l_49_0._delay_trigger_queue[l_49_1]
        if queued_trigger and trigger.original_func == queued_trigger.func then
          l_49_0._delay_trigger_queue[l_49_1] = nil
        end
        if trigger.id then
          l_49_0._virtual_controller:remove_trigger(trigger.id)
          trigger.id = nil
        else
          Application:error(l_49_0:to_string() .. " Unable to remove non-existing trigger for function \"" .. tostring(l_49_2) .. "\" on connection \"" .. tostring(l_49_1) .. "\".")
        end
      end
      trigger_sub_map[l_49_2] = nil
      if not next(trigger_sub_map) then
        trigger_sub_map = nil
      else
        l_49_0._delay_trigger_queue[l_49_1] = nil
        for _,trigger in pairs(trigger_sub_map) do
          l_49_0._virtual_controller:remove_trigger(trigger.id)
          trigger.id = nil
        end
        trigger_sub_map = nil
      end
    end
    l_49_0._trigger_map[l_49_1] = trigger_sub_map
  else
    Application:error(l_49_0:to_string() .. " Unable to remove trigger on non-existing connection \"" .. tostring(l_49_1) .. "\".")
  end
end

ControllerWrapper.remove_release_trigger = function(l_50_0, l_50_1, l_50_2)
  local trigger_sub_map = l_50_0._release_trigger_map[l_50_1]
  if trigger_sub_map then
    if l_50_2 then
      trigger = trigger_sub_map[l_50_2]
      if trigger and trigger.id then
        l_50_0._virtual_controller:remove_trigger(trigger.id)
        trigger.id = nil
        do return end
        Application:error(l_50_0:to_string() .. " Unable to remove non-existing release trigger for function \"" .. tostring(l_50_2) .. "\" on connection \"" .. tostring(l_50_1) .. "\".")
      end
      trigger_sub_map[l_50_2] = nil
      if not next(trigger_sub_map) then
        trigger_sub_map = nil
      else
        for _,trigger in pairs(trigger_sub_map) do
          l_50_0._virtual_controller:remove_trigger(trigger.id)
          trigger.id = nil
        end
        trigger_sub_map = nil
      end
    end
    l_50_0._release_trigger_map[l_50_1] = trigger_sub_map
  else
    Application:error(l_50_0:to_string() .. " Unable to remove release trigger on non-existing connection \"" .. tostring(l_50_1) .. "\".")
  end
end

ControllerWrapper.clear_triggers = function(l_51_0, l_51_1)
  if l_51_0._virtual_controller then
    l_51_0._virtual_controller:clear_triggers()
  end
  l_51_0._delay_trigger_queue = {}
  if l_51_1 then
    for _,trigger_sub_map in pairs(l_51_0._trigger_map) do
      for _,trigger in pairs(trigger_sub_map) do
        trigger.id = nil
      end
    end
    for _,release_trigger_sub_map in pairs(l_51_0._release_trigger_map) do
      for _,release_trigger in pairs(release_trigger_sub_map) do
        release_trigger.id = nil
      end
    end
  else
    l_51_0._trigger_map = {}
    l_51_0._release_trigger_map = {}
  end
end

ControllerWrapper.restore_triggers = function(l_52_0)
  if l_52_0._virtual_controller then
    for connection_name,trigger_sub_map in pairs(l_52_0._trigger_map) do
      for _,trigger in pairs(trigger_sub_map) do
        if l_52_0:get_connection_enabled(connection_name) then
          trigger.id = l_52_0._virtual_controller:add_trigger(Idstring(connection_name), trigger.func)
        end
      end
    end
    for connection_name,trigger_sub_map in pairs(l_52_0._release_trigger_map) do
      for _,trigger in pairs(trigger_sub_map) do
        if l_52_0:get_connection_enabled(connection_name) then
          trigger.id = l_52_0._virtual_controller:add_release_trigger(Idstring(connection_name), trigger.func)
        end
      end
    end
  end
end

ControllerWrapper.clear_connections = function(l_53_0, l_53_1)
  if l_53_0._virtual_controller then
    l_53_0._virtual_controller:clear_connections()
  end
  if not l_53_1 then
    l_53_0._connection_map = {}
    l_53_0._delay_map = {}
    l_53_0._delay_bool_map = {}
    l_53_0._multi_input_map = {}
  end
end

ControllerWrapper.get_any_input = function(l_54_0)
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if l_54_0._enabled and l_54_0._virtual_controller and #l_54_0._virtual_controller:down_list() <= 0 then
    l_54_0._input_any_cache = l_54_0._input_any_cache ~= nil
    l_54_0._input_any_cache = not not l_54_0._input_any_cache
    return l_54_0._input_any_cache
     -- Warning: missing end command somewhere! Added here
  end
end

ControllerWrapper.get_any_input_pressed = function(l_55_0)
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if l_55_0._enabled and l_55_0._virtual_controller and #l_55_0._virtual_controller:pressed_list() <= 0 then
    l_55_0._input_any_pressed_cache = l_55_0._input_any_pressed_cache ~= nil
    l_55_0._input_any_pressed_cache = not not l_55_0._input_any_pressed_cache
    return l_55_0._input_any_pressed_cache
     -- Warning: missing end command somewhere! Added here
  end
end

ControllerWrapper.get_any_input_released = function(l_56_0)
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if l_56_0._enabled and l_56_0._virtual_controller and #l_56_0._virtual_controller:released_list() <= 0 then
    l_56_0._input_any_released_cache = l_56_0._input_any_released_cache ~= nil
    l_56_0._input_any_released_cache = not not l_56_0._input_any_released_cache
    return l_56_0._input_any_released_cache
     -- Warning: missing end command somewhere! Added here
  end
end

local id_strings = {}
ControllerWrapper.get_input_pressed = function(l_57_0, l_57_1)
  local cache = l_57_0._input_pressed_cache[l_57_1]
  if cache == nil then
    if l_57_0._connection_map[l_57_1] then
      if not id_strings[l_57_1] then
        id_strings[l_57_1] = Idstring(l_57_1)
      end
      local ids = id_strings[l_57_1]
      cache = l_57_0._enabled and l_57_0._virtual_controller and l_57_0:get_connection_enabled(l_57_1) and l_57_0._virtual_controller:pressed(ids) or false
      cache = not not (cache)
    else
      l_57_0:print_invalid_connection_error(l_57_1)
      cache = false
    end
    l_57_0._input_pressed_cache[l_57_1] = cache
  end
  return cache
end

ControllerWrapper.print_invalid_connection_error = function(l_58_0, l_58_1)
  if not ControllerWrapper.INVALID_CONNECTION_ERROR then
    ControllerWrapper.INVALID_CONNECTION_ERROR = {}
  end
  if not ControllerWrapper.INVALID_CONNECTION_ERROR[l_58_1] then
    Application:stack_dump_error(l_58_0:to_string() .. " No controller input binded to connection \"" .. tostring(l_58_1) .. "\".")
    ControllerWrapper.INVALID_CONNECTION_ERROR[l_58_1] = true
  end
end

ControllerWrapper.get_input_bool = function(l_59_0, l_59_1)
  local cache = l_59_0._input_bool_cache[l_59_1]
  if cache == nil then
    if l_59_0._connection_map[l_59_1] then
      if not id_strings[l_59_1] then
        id_strings[l_59_1] = Idstring(l_59_1)
      end
      local ids = id_strings[l_59_1]
      cache = l_59_0._enabled and l_59_0._virtual_controller and l_59_0:get_connection_enabled(l_59_1) and l_59_0._virtual_controller:down(ids) or false
      cache = not not (cache)
    else
      l_59_0:print_invalid_connection_error(l_59_1)
      cache = false
    end
    l_59_0._input_bool_cache[l_59_1] = cache
  end
  return cache
end

ControllerWrapper.get_input_float = function(l_60_0, l_60_1)
  local cache = l_60_0._input_float_cache[l_60_1]
  if cache == nil then
    if l_60_0._connection_map[l_60_1] then
      if not id_strings[l_60_1] then
        id_strings[l_60_1] = Idstring(l_60_1)
      end
      local ids = id_strings[l_60_1]
      cache = l_60_0._enabled and l_60_0._virtual_controller and l_60_0:get_connection_enabled(l_60_1) and l_60_0._virtual_controller:button(ids) or 0
    else
      l_60_0:print_invalid_connection_error(l_60_1)
      cache = 0
    end
    l_60_0._input_float_cache[l_60_1] = cache
  end
  return cache
end

ControllerWrapper.get_input_axis_clbk = function(l_61_0, l_61_1, l_61_2)
  if not l_61_0:enabled() then
    return 
  end
  local id = id_strings[l_61_1]
  if not id then
    id = Idstring(l_61_1)
    id_strings[l_61_1] = id
  end
  local connection = l_61_0._setup:get_connection(l_61_1)
  local f = function(l_1_0, l_1_1, l_1_2)
    func(self:get_modified_axis(connection_name, connection, l_1_2))
   end
  l_61_0._virtual_controller:add_axis_trigger(id, f)
end

ControllerWrapper.get_input_axis = function(l_62_0, l_62_1)
  local cache = l_62_0._input_axis_cache[l_62_1]
  if cache == nil then
    if l_62_0._connection_map[l_62_1] then
      if not id_strings[l_62_1] then
        id_strings[l_62_1] = Idstring(l_62_1)
      end
      local ids = id_strings[l_62_1]
      if l_62_0._enabled and l_62_0._virtual_controller and l_62_0:get_connection_enabled(l_62_1) then
        cache = l_62_0._virtual_controller:axis(ids)
      end
      if cache then
        local connection = l_62_0._setup:get_connection(l_62_1)
        cache = l_62_0:get_modified_axis(l_62_1, connection, cache)
      else
        cache = Vector3()
      end
    else
      l_62_0:print_invalid_connection_error(l_62_1)
      cache = Vector3()
    end
    l_62_0._input_axis_cache[l_62_1] = cache
  end
  return cache
end

ControllerWrapper.get_modified_axis = function(l_63_0, l_63_1, l_63_2, l_63_3)
  if l_63_2.get_multiplier then
    local multiplier = l_63_2:get_multiplier()
  end
  if multiplier then
    mvector3.set_static(l_63_3, mvector3.x(l_63_3) * multiplier.x, mvector3.y(l_63_3) * multiplier.y, mvector3.z(l_63_3) * multiplier.z)
  end
  if l_63_2.get_inversion then
    local inversion = l_63_2:get_inversion()
  end
  if inversion then
    mvector3.set_static(l_63_3, mvector3.x(l_63_3) * inversion.x, mvector3.y(l_63_3) * inversion.y, mvector3.z(l_63_3) * inversion.z)
  end
  local x = l_63_0:rescale_x_axis(l_63_1, l_63_2, l_63_3.x)
  local y = l_63_0:rescale_y_axis(l_63_1, l_63_2, l_63_3.y)
  local z = l_63_0:rescale_z_axis(l_63_1, l_63_2, l_63_3.z)
  mvector3.set_static(l_63_3, x, y, z)
  return l_63_0:lerp_axis(l_63_1, l_63_2, l_63_3)
end

ControllerWrapper.lerp_axis = function(l_64_0, l_64_1, l_64_2, l_64_3)
  if l_64_2.get_lerp then
    local lerp = l_64_2:get_lerp()
  end
  if lerp then
    local current_axis = l_64_0._current_lerp_axis_map[l_64_1]
    mvector3.lerp(l_64_3, current_axis, l_64_3, lerp)
    l_64_0._current_lerp_axis_map[l_64_1] = l_64_3
  end
  return l_64_3
end

ControllerWrapper.rescale_x_axis = function(l_65_0, l_65_1, l_65_2, l_65_3)
  return l_65_0:rescale_axis_component(l_65_1, l_65_2, l_65_3)
end

ControllerWrapper.rescale_y_axis = function(l_66_0, l_66_1, l_66_2, l_66_3)
  return l_66_0:rescale_axis_component(l_66_1, l_66_2, l_66_3)
end

ControllerWrapper.rescale_z_axis = function(l_67_0, l_67_1, l_67_2, l_67_3)
  return l_67_0:rescale_axis_component(l_67_1, l_67_2, l_67_3)
end

ControllerWrapper.rescale_axis_component = function(l_68_0, l_68_1, l_68_2, l_68_3)
  return l_68_3
end

ControllerWrapper.set_connection_enabled = function(l_69_0, l_69_1, l_69_2)
  if l_69_0._connection_map[l_69_1] then
    local connection = l_69_0._setup:get_connection(l_69_1)
  end
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if connection and not connection:get_enabled() ~= not l_69_2 then
    connection:set_enabled(l_69_2)
    local trigger_sub_map = l_69_0._trigger_map[l_69_1]
    if trigger_sub_map then
      for _,trigger in pairs(trigger_sub_map) do
        if l_69_2 and not trigger.id then
          trigger.id = l_69_0._virtual_controller:add_trigger(Idstring(l_69_1), trigger.func)
          for (for control),_ in (for generator) do
            if trigger.id then
              l_69_0._virtual_controller:remove_trigger(trigger.id)
              trigger.id = nil
            end
          end
        end
      end
      trigger_sub_map = l_69_0._release_trigger_map[l_69_1]
      if trigger_sub_map then
        for _,trigger in pairs(trigger_sub_map) do
          if l_69_2 and not trigger.id then
            trigger.id = l_69_0._virtual_controller:add_release_trigger(Idstring(l_69_1), trigger.func)
            for (for control),_ in (for generator) do
              if trigger.id then
                l_69_0._virtual_controller:remove_trigger(trigger.id)
                trigger.id = nil
              end
            end
          end
        end
        if not l_69_2 then
          l_69_0._delay_trigger_queue[l_69_1] = nil
        end
        do
          local delay_data = l_69_0._delay_map[l_69_1]
          if delay_data then
            for delay_connection_name in pairs(delay_data.delay_time_map) do
              local trigger_sub_map = l_69_0._trigger_map[delay_connection_name]
              if trigger_sub_map then
                for _,trigger in pairs(trigger_sub_map) do
                  trigger.func = l_69_0:get_trigger_func(delay_connection_name, trigger.original_func)
                  if trigger.id then
                    l_69_0._virtual_controller:remove_trigger(trigger.id)
                    trigger.id = l_69_0._virtual_controller:add_trigger(Idstring(delay_connection_name), trigger.func)
                  end
                end
              end
              local release_trigger_sub_map = l_69_0._release_trigger_map[delay_connection_name]
              if release_trigger_sub_map then
                for _,release_trigger in pairs(release_trigger_sub_map) do
                  release_trigger.func = l_69_0:get_trigger_func(delay_connection_name, release_trigger.original_func)
                  if release_trigger.id then
                    l_69_0._virtual_controller:remove_trigger(release_trigger.id)
                    release_trigger.id = l_69_0._virtual_controller:add_release_trigger(Idstring(delay_connection_name), release_trigger.func)
                  end
                end
              end
            end
            l_69_0:update_delay_trigger_queue()
          end
          do return end
          Application:error(l_69_0:to_string() .. " Controller can't enable connection \"" .. tostring(l_69_1) .. "\" because it doesn't exist.")
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ControllerWrapper.get_connection_enabled = function(l_70_0, l_70_1)
  if l_70_0._connection_map[l_70_1] then
    local connection = l_70_0._setup:get_connection(l_70_1)
  end
  if connection then
    local ret = connection:get_enabled()
  end
  return ret
end

ControllerWrapper.to_string = function(l_71_0)
  return l_71_0:__tostring()
end

ControllerWrapper.__tostring = function(l_72_0)
  return string.format("[Controller][Wrapper][ID: %s, Type: %s, Name: %s, Enabled: %s, Debug: %s]", tostring(l_72_0._id), tostring(l_72_0:get_type()), tostring(l_72_0._name or "N/A"), tostring(l_72_0._enabled and "Yes" or "No"), tostring(l_72_0._debug and "Yes" or "No"))
end


