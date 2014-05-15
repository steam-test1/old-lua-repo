core:module("CorePortalManager")
core:import("CoreShapeManager")
PortalManager = PortalManager or class()
PortalManager.EFFECT_MANAGER = World:effect_manager()
function PortalManager:init()
	self._portal_shapes = {}
	self._all_units = {}
	self._all_effects = {}
	self._unit_groups = {}
	self._check_positions = {}
	self._hide_list = {}
	self._deactivate_funtion = callback(self, self, "unit_deactivated")
end

function PortalManager:clear()
	do
		local (for generator), (for state), (for control) = ipairs(self._portal_shapes)
		do
			do break end
			portal:show_all()
		end

	end

	self._portal_shapes = nil and {}
	self._all_units = {}
	self._unit_groups = {}
	self._hide_list = {}
end

function PortalManager:pseudo_reset()
	do
		local (for generator), (for state), (for control) = ipairs(managers.editor:layer("Statics"):created_units())
		do
			do break end
			if alive(unit) then
				unit:unit_data()._visibility_counter = 0
			end

		end

	end

	(for control) = managers.editor:layer("Statics"):created_units() and alive
	local (for generator), (for state), (for control) = pairs(self._unit_groups)
	do
		do break end
		group._is_inside = false
		local (for generator), (for state), (for control) = ipairs(managers.editor:layer("Statics"):created_units())
		do
			do break end
			if group._ids[unit:unit_data().unit_id] and alive(unit) then
				unit:set_visible(true)
				unit:unit_data()._visibility_counter = 0
			end

		end

	end

end

function PortalManager:add_portal(polygon_tbl, min, max)
	cat_print("portal", "add_portal", #polygon_tbl)
	if #polygon_tbl > 0 then
		table.insert(self._portal_shapes, PortalShape:new(polygon_tbl, min, max))
	end

end

function PortalManager:add_unit(unit)
	if unit:unit_data().ignore_portal then
		return
	end

	local added
	do
		local (for generator), (for state), (for control) = pairs(self._unit_groups)
		do
			do break end
			added = group:add_unit(unit) or added
		end

	end

	do break end
	do return end
	local (for generator), (for state), (for control) = ipairs(self._portal_shapes)
	do
		do break end
		local added, amount = portal:add_unit(unit)
		if added then
			self._all_units[unit:key()] = (self._all_units[unit:key()] or 0) + amount
			local inverse = unit:unit_data().portal_visible_inverse
			local i = 0
			i = portal:is_inside() or inverse and 1 or -1
			self:change_visibility(unit, i, inverse)
		end

	end

end

function PortalManager:remove_dynamic_unit(unit)
	self:remove_unit(unit)
	local check_body = unit:body(unit:orientation_object()) or unit:body(0)
	if alive(check_body) then
		check_body:set_activate_tag("dynamic_portal")
		check_body:set_deactivate_tag("dynamic_portal")
	end

	unit:add_body_activation_callback(self._deactivate_funtion)
end

function PortalManager:unit_deactivated(tag, unit, body, activated)
	if not activated then
		cat_print("portal", "should add unit here", tag, unit, body, activated)
		self:add_unit(unit)
		unit:remove_body_activation_callback(self._deactivate_funtion)
	end

end

function PortalManager:remove_unit(unit)
	cat_print("portal", "remove_unit", unit, unit:visible())
	self._all_units[unit:key()] = nil
	do
		local (for generator), (for state), (for control) = ipairs(self._portal_shapes)
		do
			do break end
			portal:remove_unit(unit)
		end

	end

	(for control) = unit and portal.remove_unit
	unit:set_visible(true)
end

function PortalManager:delete_unit(unit)
	local (for generator), (for state), (for control) = pairs(self._unit_groups)
	do
		do break end
		group:remove_unit_id(unit)
	end

end

function PortalManager:change_visibility(unit, i, inverse)
	self._all_units[unit:key()] = self._all_units[unit:key()] + i
	if self._all_units[unit:key()] == 0 then
		unit:set_visible(false ~= inverse)
	elseif not unit:visible() ~= inverse then
		unit:set_visible(true ~= inverse)
	end

end

function PortalManager:add_effect(effect)
	effect.id = self.EFFECT_MANAGER:spawn(effect)
	self._all_effects[effect] = 0
	local (for generator), (for state), (for control) = ipairs(self._portal_shapes)
	do
		do break end
		local added, amount = portal:add_effect(effect)
		if added then
			self._all_effects[effect] = self._all_effects[effect] + amount
		end

	end

end

function PortalManager:change_effect_visibility(effect, i)
	self._all_effects[effect] = self._all_effects[effect] + i
	if self._all_effects[effect] == 0 then
		effect.hidden = true
		self.EFFECT_MANAGER:set_frozen(effect.id, true)
		self.EFFECT_MANAGER:set_hidden(effect.id, true)
	elseif effect.hidden then
		effect.hidden = false
		self.EFFECT_MANAGER:set_frozen(effect.id, false)
		self.EFFECT_MANAGER:set_hidden(effect.id, false)
	end

end

function PortalManager:restart_effects()
