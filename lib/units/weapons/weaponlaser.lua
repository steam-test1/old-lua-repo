WeaponLaser = WeaponLaser or class( WeaponGadgetBase )

function WeaponLaser:init( unit )
	WeaponLaser.super.init( self, unit )
		
	self._on_event = "gadget_laser_aim_on"
	self._off_event = "gadget_laser_aim_off"
		
	local obj = self._unit:get_object( Idstring( "a_laser" ) )
	self._laser_obj = obj
	self._max_distance = 3000
	self._scale_distance = 1000
	
	self._g_laser = self._unit:get_object( Idstring( "g_laser" ) )
	self._g_indicator = self._unit:get_object( Idstring( "g_indicator" ) )
	
	-- g_laser, g_indicator
			
	--[[self._light = World:create_light( "spot|specular" )
	self._light:set_spot_angle_end( 0.5 )
	self._light:set_far_range( 8000 )
	self._light:set_color( Vector3( 5, 0, 0 ) )
			
	self._light:link( obj )
	self._light:set_rotation( Rotation( obj:rotation():z(), -obj:rotation():x(), -obj:rotation():y() ) )]]
	
	--[[self._light = World:create_light( "omni|specular" )
	self._light:set_far_range( 50 )
	self._light:set_color( Vector3( 5, 0, 0 ) )]]
	
	self._spot_angle_end = 0
	self._light = World:create_light( "spot|specular" )
	self._light:set_spot_angle_end( 3 )
	self._light:set_far_range( 75 )
	self._light:set_near_range( 40 )
	
	self._light:link( obj )
	self._light:set_rotation( Rotation( obj:rotation():z(), -obj:rotation():x(), -obj:rotation():y() ) )
	
	self._colors = { { light = Vector3( 0, 10, 0 ), brush = Color( 0.05, 0, 1, 0 ) },
					 { light = Vector3( 10, 0, 0 ), brush = Color( 0.05, 1, 0, 0 ) },
					 { light = Vector3( 0, 0, 10 ), brush = Color( 0.05, 0, 0, 1 ) },
					}
	-- local color = math.random( #self._colors )
	
	-- self._light_color = Vector3( 10, 0, 0 )
	self._light_color = self._colors[1].light -- Vector3( 0, 10, 0 )
	self._light:set_color( self._light_color )
	
	self._light:set_enable( false )
	
	--[[self._light_glow = World:create_light( "omni|specular" )
	self._light_glow:set_far_range( 25 )
	self._light_glow_color = Vector3( 0.20, 0, 0 )
	self._light_glow:set_color( self._light_glow_color )
	self._light_glow:set_enable( false )
	self._light_glow:link( obj )]]
	
	self._light_glow = World:create_light( "spot|specular" )
	self._light_glow:set_spot_angle_end( 20 )
	self._light_glow:set_far_range( 75 )
	self._light_glow:set_near_range( 40 )
	-- self._light_glow_color = Vector3( 0.40, 0, 0 )
	self._light_glow_color = Vector3( 0.0, 0.2, 0 )
	self._light_glow:set_color( self._light_glow_color )
	self._light_glow:set_enable( false )
	self._light_glow:link( obj )
	self._light_glow:set_rotation( Rotation( obj:rotation():z(), -obj:rotation():x(), -obj:rotation():y() ) )
	
	self._slotmask = managers.slot:get_mask( "bullet_impact_targets" )
	
	self._brush = Draw:brush( self._colors[1].brush ) -- Color( 0.05, 0, 1, 0 ) )
	self._brush:set_blend_mode( "opacity_add" )
end

-----------------------------------------------------------------------------------

local mvec1 = Vector3()
local mvec2 = Vector3()
local mvec_l_dir = Vector3()
function WeaponLaser:update( unit, t, dt )
	--[[local b = Draw:brush( Color( 0.05, 0, 1, 0 ) )
	b:set_blend_mode( "opacity_add" )]]

	mrotation.y( self._laser_obj:rotation(), mvec_l_dir )
	-- mvector3.set( mvec_l_dir, mrotation.y( self._laser_obj:rotation() ) )
	local from = mvec1
	mvector3.set( from, self._laser_obj:position() )
	
	local to = mvec2
	mvector3.set( to, mvec_l_dir )
	mvector3.multiply( to, self._max_distance )
	mvector3.add( to, from )
	local ray = self._unit:raycast( from, to, self._slotmask )
	if ray then
		-- self._brush:cylinder( self._light:position(), self._laser_obj:position(), self._is_npc and 0.5 or 0.25 )
		if not self._is_npc then
			self._light:set_spot_angle_end( self._spot_angle_end )
			self._spot_angle_end = math.lerp( 1, 18, ray.distance/self._max_distance )
			-- self._light:set_spot_angle_end( math.lerp( 1, 20, ray.distance/self._max_distance ) )
			-- self._light_glow:set_far_range( math.lerp( 10, 50, ray.distance/self._max_distance ) )
			self._light_glow:set_spot_angle_end( math.lerp( 8, 80, ray.distance/self._max_distance ) )
			
			local scale = (math.clamp( ray.distance, self._max_distance - self._scale_distance, self._max_distance ) - (self._max_distance - self._scale_distance))/self._scale_distance
			scale = (1-scale)
			-- print( "scale", scale )
			self._light:set_multiplier( scale )
			self._light_glow:set_multiplier( scale * 0.1 )
			
		end
		-- b:cylinder( from, ray.position, self._is_npc and 0.5 or 0.25 )
		-- mvector3.lerp( to, from, ray.position, 1 )
		-- b:cone( to, from, self._is_npc and 0.5 or 0.25 )
		-- self._brush:cylinder( to, from, self._is_npc and 0.5 or 0.25 )
		self._brush:cylinder( ray.position, from, self._is_npc and 0.5 or 0.25 )
		
		local pos = mvec1
		mvector3.set( pos, mvec_l_dir )
		mvector3.multiply( pos, 50 )
		mvector3.negate( pos )
		mvector3.add( pos, ray.position )
		self._light:set_position( pos )
		-- self._light:set_rotation( Rotation( self._laser_obj:rotation():z(), -self._laser_obj:rotation():x(), -self._laser_obj:rotation():y() ) )
		self._light_glow:set_position( pos )
		-- self._light_glow:set_rotation( Rotation( self._laser_obj:rotation():z(), -self._laser_obj:rotation():x(), -self._laser_obj:rotation():y() ) )
				
	else
		self._light:set_position( to )
		self._light_glow:set_position( to )
		self._brush:cylinder( from, to, self._is_npc and 0.5 or 0.25 )
	end
end

-----------------------------------------------------------------------------------

function WeaponLaser:_check_state()
	WeaponLaser.super._check_state( self )
	self._light:set_enable( self._on )
	self._light_glow:set_enable( self._on )
	self._g_laser:set_visibility( self._on )
	self._g_indicator:set_visibility( self._on )
	self._unit:set_extension_update_enabled( Idstring( "base" ), self._on )
end

function WeaponLaser:set_npc()
	self._is_npc = true
end

-----------------------------------------------------------------------------------

function WeaponLaser:destroy( unit )
	WeaponLaser.super.destroy( self, unit )
	
	if alive( self._light ) then
		World:delete_light( self._light )
	end
	
	if alive( self._light_glow ) then
		World:delete_light( self._light_glow )
	end
end

-----------------------------------------------------------------------------------

function WeaponLaser:set_color( color )
	self._light_color = Vector3( color.r*10, color.g*10, color.b*10 )
	self._light:set_color( self._light_color )
	
	self._light_glow_color = Vector3( color.r*0.2, color.g*0.2, color.b*0.2 )
	self._light_glow:set_color( self._light_glow_color )
	
	self._brush:set_color( color )
end

-----------------------------------------------------------------------------------

function WeaponLaser:set_max_distace( dis )
	self._max_distance = dis
end

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------