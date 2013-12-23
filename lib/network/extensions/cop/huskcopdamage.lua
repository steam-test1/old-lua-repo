HuskCopDamage = HuskCopDamage or class( CopDamage )

------------------------------------------------------------------------------------------

function HuskCopDamage:die( variant )
	
	self._unit:base():set_slot( self._unit, 17 )	-- Corpse slot
	
	if self._unit:inventory() then -- civilians have no inventory
		self._unit:inventory():drop_shield()
	end
	
	variant = variant or "bullet"
	self._health = 0
	self._health_ratio = 0
	self._dead = true
	
	self:set_mover_collision_state( false )
	
	if self._unit:interaction() and self._unit:interaction().tweak_data == "hostage_convert" then
		self._unit:interaction():set_active( false )
	end
	
	if self._death_sequence then
		if self._unit:damage() and self._unit:damage():has_sequence( self._death_sequence ) then
			self._unit:damage():run_sequence_simple( self._death_sequence )
		else
			debug_pause_unit( self._unit, "[HuskCopDamage:die] does not have death sequence", self._death_sequence, self._unit )
		end
	end
end

------------------------------------------------------------------------------------------