core:module("CoreControllerWrapperDebug")
core:import("CoreControllerWrapper")
ControllerWrapperDebug = ControllerWrapperDebug or class(CoreControllerWrapper.ControllerWrapper)
ControllerWrapperDebug.TYPE = "debug"
function ControllerWrapperDebug:init(controller_wrapper_list, manager, id, name, default_controller_wrapper, setup)
	self._controller_wrapper_list = controller_wrapper_list
	self._default_controller_wrapper = default_controller_wrapper
	ControllerWrapperDebug.super.init(self, manager, id, name, {}, default_controller_wrapper and default_controller_wrapper:get_default_controller_id(), setup, true, true)
	local (for generator), (for state), (for control) = ipairs(controller_wrapper_list)
	do
		do break end
		local (for generator), (for state), (for control) = pairs(controller_wrapper:get_controller_map())
		do
			do break end
			self._controller_map[controller_id] = controller
		end

	end

end

function ControllerWrapperDebug:destroy()
	ControllerWrapperDebug.super.destroy(self)
	local (for generator), (for state), (for control) = ipairs(self._controller_wrapper_list)
	do
		do break end
		controller_wrapper:destroy()
	end

end

function ControllerWrapperDebug:update(t, dt)
	ControllerWrapperDebug.super.update(self, t, dt)
	local (for generator), (for state), (for control) = ipairs(self._controller_wrapper_list)
	do
		do break end
		controller_wrapper:update(t, dt)
	end

end

function ControllerWrapperDebug:paused_update(t, dt)
	ControllerWrapperDebug.super.paused_update(self, t, dt)
	local (for generator), (for state), (for control) = ipairs(self._controller_wrapper_list)
	do
		do break end
		controller_wrapper:paused_update(t, dt)
	end

end

function ControllerWrapperDebug:connected(...)
	do
		local (for generator), (for state), (for control) = ipairs(self._controller_wrapper_list)
		do
			do break end
			if controller_wrapper:connected(...) then
				return true
			end

		end

	end

	(for control) = nil and controller_wrapper.connected
end

function ControllerWrapperDebug:rebind_connections(setup, setup_map)
	ControllerWrapperDebug.super.rebind_connections(self)
	local (for generator), (for state), (for control) = ipairs(self._controller_wrapper_list)
	do
		do break end
		controller_wrapper:rebind_connections(setup_map[controller_wrapper:get_type()], setup_map)
	end

end

function ControllerWrapperDebug:setup(...)
end

function ControllerWrapperDebug:get_any_input(...)
	do
		local (for generator), (for state), (for control) = ipairs(self._controller_wrapper_list)
		do
			do break end
			if controller_wrapper:get_any_input(...) then
				return true
			end

		end

	end

	(for control) = nil and controller_wrapper.get_any_input
end

function ControllerWrapperDebug:get_any_input_pressed(...)
	do
		local (for generator), (for state), (for control) = ipairs(self._controller_wrapper_list)
		do
			do break end
			if controller_wrapper:get_any_input_pressed(...) then
				return true
			end

		end

	end

	(for control) = nil and controller_wrapper.get_any_input_pressed
end

function ControllerWrapperDebug:get_input_pressed(...)
	do
		local (for generator), (for state), (for control) = ipairs(self._controller_wrapper_list)
		do
			do break end
			if controller_wrapper:connection_exist(...) and controller_wrapper:get_input_pressed(...) then
				return true
			end

		end

	end

	(for control) = nil and controller_wrapper.connection_exist
end

function ControllerWrapperDebug:get_input_bool(...)
	do
		local (for generator), (for state), (for control) = ipairs(self._controller_wrapper_list)
		do
			do break end
			if controller_wrapper:connection_exist(...) and controller_wrapper:get_input_bool(...) then
				return true
			end

		end

	end

	(for control) = nil and controller_wrapper.connection_exist
end

function ControllerWrapperDebug:get_input_float(...)
	local input_float = 0
	do
		local (for generator), (for state), (for control) = ipairs(self._controller_wrapper_list)
		do
			do break end
			if controller_wrapper:connection_exist(...) then
				input_float = math.max(input_float, controller_wrapper:get_input_float(...))
			end

		end

	end

end

function ControllerWrapperDebug:get_input_axis(...)
	local input_axis = Vector3(0, 0, 0)
	do
		local (for generator), (for state), (for control) = ipairs(self._controller_wrapper_list)
		do
			do break end
			if controller_wrapper:connection_exist(...) then
				local next_input_axis = controller_wrapper:get_input_axis(...)
				if next_input_axis:length() > input_axis:length() then
					input_axis = next_input_axis
				end

			end

		end

	end

end

function ControllerWrapperDebug:get_connection_map(...)
-- fail 13
null
11
	local map = {}
	do
		local (for generator), (for state), (for control) = ipairs(self._controller_wrapper_list)
		do
			do break end
			local sub_map = controller_wrapper:get_connection_map(...)
			local (for generator), (for state), (for control) = pairs(sub_map)
			do
				do break end
				map[k] = v
			end

		end

	end

end

function ControllerWrapperDebug:connection_exist(...)
	do
		local (for generator), (for state), (for control) = ipairs(self._controller_wrapper_list)
		do
			do break end
			if controller_wrapper:connection_exist(...) then
				return true
			end

		end

	end

	(for control) = nil and controller_wrapper.connection_exist
end

function ControllerWrapperDebug:set_enabled(...)
	local (for generator), (for state), (for control) = ipairs(self._controller_wrapper_list)
	do
		do break end
		controller_wrapper:set_enabled(...)
	end

end

function ControllerWrapperDebug:enable(...)
