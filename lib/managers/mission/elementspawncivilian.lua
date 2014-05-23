core:import("CoreMissionScriptElement")
ElementSpawnCivilian = ElementSpawnCivilian or class(CoreMissionScriptElement.MissionScriptElement)
function ElementSpawnCivilian:init(...)
	ElementSpawnCivilian.super.init(self, ...)
	self._enemy_name = self._values.enemy and Idstring(self._values.enemy) or Idstring("units/characters/civilians/dummy_civilian_1/dummy_civilian_1")
	self._units = {}
	self:_finalize_values()
end

function ElementSpawnCivilian:_finalize_values()
	local state_index = table.index_of(CopActionAct._act_redirects.civilian_spawn, self._values.state)
	self._values.state = state_index ~= -1 and state_index or nil
	self._values.force_pickup = self._values.force_pickup ~= "none" and self._values.force_pickup or nil
end

function ElementSpawnCivilian:enemy_name()
	return self._enemy_name
end

function ElementSpawnCivilian:units()
	return self._units
end

function ElementSpawnCivilian:produce()
	if not managers.groupai:state():is_AI_enabled() then
		return
	end

	local unit = safe_spawn_unit(self._enemy_name, self:get_orientation())
	unit:unit_data().mission_element = self
	table.insert(self._units, unit)
	if self._values.state then
		local state = CopActionAct._act_redirects.civilian_spawn[self._values.state]
		if unit:brain() then
			local action_data = {
				type = "act",
				variant = state,
				body_part = 1,
				align_sync = true
			}
			local spawn_ai = {
				init_state = "idle",
				objective = {
					type = "act",
					action = action_data,
					interrupt_dis = -1,
					interrupt_health = 1
				}
			}
			unit:brain():set_spawn_ai(spawn_ai)
		else
			unit:base():play_state(state)
		end

	end

	if self._values.force_pickup then
		unit:character_damage():set_pickup(self._values.force_pickup)
	end

	if unit:unit_data().secret_assignment_id then
		managers.secret_assignment:register_unit(unit)
	else
		managers.secret_assignment:register_civilian(unit)
	end

	self:event("spawn", unit)
	return unit
end

function ElementSpawnCivilian:event(name, unit)
	if self._events and self._events[name] then
		local (for generator), (for state), (for control) = ipairs(self._events[name])
		do
			do break end
			callback(unit)
		end

	end

end

function ElementSpawnCivilian:add_event_callback(name, callback)
	self._events = self._events or {}
	self._events[name] = self._events[name] or {}
	table.insert(self._events[name], callback)
end

function ElementSpawnCivilian:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if not managers.groupai:state():is_AI_enabled() and not Application:editor() then
		return
	end

	local unit = self:produce()
	ElementSpawnCivilian.super.on_executed(self, unit)
end

function ElementSpawnCivilian:unspawn_all_units()
	ElementSpawnEnemyDummy.unspawn_all_units(self)
end

function ElementSpawnCivilian:kill_all_units()
	ElementSpawnEnemyDummy.kill_all_units(self)
end

function ElementSpawnCivilian:execute_on_all_units(func)
	ElementSpawnEnemyDummy.execute_on_all_units(self, func)
end

