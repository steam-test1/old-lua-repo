core:module("CoreControllerWrapper")
core:import("CoreControllerWrapperSettings")
core:import("CoreAccessObjectBase")
ControllerWrapper = ControllerWrapper or class(CoreAccessObjectBase.AccessObjectBase)
ControllerWrapper.TYPE = "generic"
function ControllerWrapper:init(manager, id, name, controller_map, default_controller_id, setup, debug, skip_virtual_controller, custom_virtual_connect_func_map)
	ControllerWrapper.super.init(self, manager, name)
	self._id = id
	self._name = name
	self._controller_map = controller_map
	self._default_controller_id = default_controller_id
	self._setup = setup
	self._debug = debug
	if not skip_virtual_controller then
		self._virtual_controller = Input:create_virtual_controller("ctrl_" .. tostring(self._id))
	end

	self._custom_virtual_connect_func_map = custom_virtual_connect_func_map or {}
	do
		local (for generator), (for state), (for control) = pairs(controller_map)
		do
			do break end
			self._custom_virtual_connect_func_map[controller_id] = self._custom_virtual_connect_func_map[controller_id] or {}
		end

	end

	self._connection_map = tostring(self._id) and {}
	self._trigger_map = {}
	self._release_trigger_map = {}
	self._current_lerp_axis_map = {}
	self._claimed = false
	self._enabled = false
	self._delay_map = {}
	self._delay_bool_map = {}
	self._multi_input_map = {}
	self:setup(self._setup)
	self._was_connected = self:connected()
	self._reset_cache_time = TimerManager:wall_running():time() - 1
	self._delay_trigger_queue = {}
	self._input_pressed_cache = {}
	self._input_bool_cache = {}
	self._input_float_cache = {}
	self._input_axis_cache = {}
	self:reset_cache(false)
	self._destroy_callback_list = {}
	self._last_destroy_callback_id = 0
	self._connect_changed_callback_list = {}
	self._last_connect_changed_callback_id = 0
	self._rebind_callback_list = {}
	self._last_rebind_callback_id = 0
end

function ControllerWrapper:destroy()
	do
		local (for generator), (for state), (for control) = pairs(self._destroy_callback_list)
		do
			do break end
			func(self, id)
		end

	end

	(for control) = nil and func
	if alive(self._virtual_controller) then
		Input:destroy_virtual_controller(self._virtual_controller)
		self._virtual_controller = nil
	end

end

function ControllerWrapper:update(t, dt)
	self:reset_cache(true)
	self:update_delay_trigger_queue()
	self:check_connect_changed_status()
	if alive(self._virtual_controller) then
		self._virtual_controller:clear_axis_triggers()
	end

end

function ControllerWrapper:paused_update(t, dt)
	self:reset_cache(true)
	self:update_delay_trigger_queue()
	self:check_connect_changed_status()
	if alive(self._virtual_controller) then
		self._virtual_controller:clear_axis_triggers()
	end

end

function ControllerWrapper:reset_cache(check_time)
	local reset_cache_time = TimerManager:wall_running():time()
	if not check_time or reset_cache_time > self._reset_cache_time then
		self._input_any_cache = nil
		self._input_any_pressed_cache = nil
		self._input_any_released_cache = nil
		if next(self._input_pressed_cache) then
			self._input_pressed_cache = {}
		end

		if next(self._input_bool_cache) then
			self._input_bool_cache = {}
		end

		if next(self._input_float_cache) then
			self._input_float_cache = {}
		end

		if next(self._input_axis_cache) then
			self._input_axis_cache = {}
		end

		self:update_multi_input()
		self:update_delay_input()
		self._reset_cache_time = reset_cache_time
	end

end

function ControllerWrapper:update_delay_trigger_queue()
	if self._enabled and self._virtual_controller then
		local (for generator), (for state), (for control) = pairs(self._delay_trigger_queue)
		do
			do break end
			if not self._virtual_controller:down(Idstring(connection_name)) then
				self._delay_trigger_queue[connection_name] = nil
			elseif self:get_input_bool(connection_name) then
				self._delay_trigger_queue[connection_name] = nil
				data.func(unpack(data.func_params))
			end

		end

	end

end

function ControllerWrapper:check_connect_changed_status()
