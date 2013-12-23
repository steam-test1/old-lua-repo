
LootManager = LootManager or class()

function LootManager:init()
	self:_setup()
end

function LootManager:_setup()
	local distribute = {}
	local saved_secured = {} -- If we restart a stage, we need this info for setting up distributed again
	local saved_mandatory_bags = Global.loot_manager and Global.loot_manager.mandatory_bags
	local postponed_small_loot = Global.loot_manager and Global.loot_manager.postponed_small_loot
	if Global.loot_manager and Global.loot_manager.secured then
		saved_secured = deep_clone( Global.loot_manager.secured )
		for _,data in ipairs( Global.loot_manager.secured ) do
			if not tweak_data.carry.small_loot[ data.carry_id ] then
				table.insert( distribute, data )
			end
		end
		-- distribute = deep_clone( Global.loot_manager.secured )
	end
	-- if not Global.loot_manager then
		Global.loot_manager = {}
		Global.loot_manager.secured = {}
		Global.loot_manager.distribute = distribute
		Global.loot_manager.saved_secured = saved_secured
		Global.loot_manager.mandatory_bags = saved_mandatory_bags or {}
		Global.loot_manager.postponed_small_loot = postponed_small_loot
	-- end
	self._global = Global.loot_manager
	
	self._triggers = {}
	self._respawns = {}
	-- self._mandatory_bags = {}
end

function LootManager:clear()
	Global.loot_manager = nil
end

function LootManager:reset()
	Global.loot_manager = nil
	self:_setup()
end

function LootManager:on_simulation_ended()
	self._respawns = {}
	self._global.mandatory_bags = {}
end

function LootManager:add_trigger( id, type, amount, callback )
	self._triggers[ type ] = self._triggers[ type ] or {}
	self._triggers[ type ][ id ] = { amount = amount, callback = callback }
end

function LootManager:_check_triggers( type )
	print( "LootManager:_check_triggers", type )
	if not self._triggers[ type ] then
		return
	end
	
	if type == "amount" then
		local bag_total_value = self:get_real_total_loot_value() -- Only value from secured bags
		for id,cb_data in pairs( self._triggers[ type ] ) do
			if type ~= "amount" or (cb_data.amount <= bag_total_value) then
				cb_data.callback()
			end
		end
	elseif type == "total_amount" then
		local total_value = self:get_real_total_value() 
		for id,cb_data in pairs( self._triggers[ type ] ) do
			if (cb_data.amount <= total_value) then
				cb_data.callback()
			end
		end
	elseif type == "report_only" then
		for id,cb_data in pairs( self._triggers[ type ] ) do
			cb_data.callback()
		end
	end
end

function LootManager:on_retry_job_stage()
	self._global.secured = self._global.saved_secured  
end

function LootManager:get_distribute()
	return table.remove( self._global.distribute, 1 )
end

function LootManager:get_respawn()
	return table.remove( self._respawns, 1 )
end

function LootManager:add_to_respawn( carry_id, value )
	table.insert( self._respawns, { carry_id = carry_id, value = value } )
end

function LootManager:on_job_deactivated()
	self:clear()
end

function LootManager:secure( carry_id, value, silent )
	print( "LootManager:secure", carry_id, value )
	
	if Network:is_server() then
		self:server_secure_loot( carry_id, value, silent )
	else
		managers.network:session():send_to_host( "server_secure_loot", carry_id, value )
	end
end

function LootManager:server_secure_loot( carry_id, value, silent )
	-- Here it is possible to check if the loot is valid
	managers.network:session():send_to_peers_synched( "sync_secure_loot", carry_id, value, silent ) -- Could be intresting to check who secured it?
	self:sync_secure_loot( carry_id, value, silent )
end

function LootManager:sync_secure_loot( carry_id, value, silent )
	table.insert( self._global.secured, { carry_id = carry_id, value = value } )
		
	managers.hud:loot_value_updated()
	
	self:_check_triggers( "amount" )
	self:_check_triggers( "total_amount" )
		
	-- Skip small loot
	if not tweak_data.carry.small_loot[ carry_id ] then
		self:_check_triggers( "report_only" )
		if not silent then
			self:_present( carry_id, value )
		end
	else -- Small loot is added to account
		-- Small loot is now awarded only at successful level
		-- managers.money:add_to_total( self:get_real_value( carry_id, value ) )
	end
	 
end

function LootManager:_multiplier_by_id( id )
	if tweak_data.carry.small_loot[ id ] then
		return "small_loot_value_multiplier"
	end
	return "value_multiplier"
end

function LootManager:secure_small_loot( type, multiplier )
	local carry_id = type
	local value = math.round( tweak_data.carry.small_loot[ type ] * multiplier )
	self:secure( carry_id, value )
end

function LootManager:show_small_loot_taken_hint( type, multiplier )
	local carry_id = type
	local value = math.round( tweak_data.carry.small_loot[ type ] * multiplier )
	managers.hint:show_hint( "grabbed_small_loot", 2, nil, { MONEY = managers.experience:cash_string( self:get_real_value( carry_id, value ) ) } )
end

---------------------------------------------------------------------------------

function LootManager:set_mandatory_bags_data( carry_id, amount )
	self._global.mandatory_bags.carry_id = carry_id
	self._global.mandatory_bags.amount = amount
end

function LootManager:get_mandatory_bags_data()
	return self._global.mandatory_bags
end

function LootManager:check_secured_mandatory_bags()
	if not self._global.mandatory_bags.amount or self._global.mandatory_bags.amount == 0 then
		return true
	end
	
	local amount = self:get_secured_mandatory_bags_amount()
	--[[for _,data in ipairs( self._global.secured ) do
		if self._global.mandatory_bags.carry_id == "none" or self._global.mandatory_bags.carry_id == data.carry_id then
			amount = amount + 1
		end 
	end]]
	
	print( "mandatory amount", amount )
	return amount >= self._global.mandatory_bags.amount
end

function LootManager:get_secured_mandatory_bags_amount()
	local mandatory_bags_amount = self._global.mandatory_bags.amount or 0
	if mandatory_bags_amount == 0 then
		return 0
	end
	
	local amount = 0
	for _,data in ipairs( self._global.secured ) do
		if mandatory_bags_amount > 0 and (self._global.mandatory_bags.carry_id == "none" or self._global.mandatory_bags.carry_id == data.carry_id) then
		-- if self._global.mandatory_bags.carry_id == "none" or self._global.mandatory_bags.carry_id == data.carry_id then
			amount = amount + 1
			mandatory_bags_amount = mandatory_bags_amount - 1
		end 
	end
	
	return amount
end

function LootManager:get_secured_bonus_bags_amount()
	local mandatory_bags_amount = self._global.mandatory_bags.amount or 0
	local secured_mandatory_bags_amount = self:get_secured_mandatory_bags_amount()
		
	local amount = 0
	for _,data in ipairs( self._global.secured ) do
		if not tweak_data.carry.small_loot[ data.carry_id ] then
			-- Is a mandatory
			if mandatory_bags_amount > 0 and (self._global.mandatory_bags.carry_id == "none" or self._global.mandatory_bags.carry_id == data.carry_id) then
				mandatory_bags_amount = mandatory_bags_amount - 1
			else
				amount = amount + 1
			end
		end
	end
	
	return amount
end

function LootManager:get_secured_bonus_bags_value()
	local mandatory_bags_amount = self._global.mandatory_bags.amount or 0
	
	local value = 0
	for _,data in ipairs( self._global.secured ) do
		if not tweak_data.carry.small_loot[ data.carry_id ] then
			-- Is a mandatory
			if mandatory_bags_amount > 0 and (self._global.mandatory_bags.carry_id == "none" or self._global.mandatory_bags.carry_id == data.carry_id) then
				mandatory_bags_amount = mandatory_bags_amount - 1
				value = value + data.value
			else
				value = value + data.value
			end
		end
	end
	
	return value
end

---------------------------------------------------------------------------------

function LootManager:get_real_value( carry_id, value )
	local has_active_job = managers.job:has_active_job()
	-- local job_and_difficulty_stars = has_active_job and managers.job:current_job_and_difficulty_stars() or 1
	local job_stars = has_active_job and managers.job:current_job_stars() or 1
	-- local difficulty_stars = job_and_difficulty_stars - job_stars
	-- local player_stars = managers.experience:level_to_stars()
	-- local is_level_limited = player_stars < job_and_difficulty_stars
	
	-- local total_stars = job_and_difficulty_stars -- math.min( job_and_difficulty_stars, player_stars )
	-- local total_difficulty_stars = math.max( 0, total_stars - job_stars )
	-- local money_multiplier = managers.money:get_contract_difficulty_multiplier( total_difficulty_stars ) or 0
	
	-- total_stars = math.min( job_stars, total_stars )	-- 1-7
	
	
	--local carry_tweak_data = tweak_data.carry[ self:_multiplier_by_id( carry_id ) ]
	--local mul_value = carry_tweak_data[job_stars]

	local mul_value = tweak_data:get_value( "carry", self:_multiplier_by_id( carry_id ), job_stars )
	
	--[[
	if is_level_limited then
		local level_limit_tweak_data = tweak_data.money_manager.level_limit
		local player_mul = mul_value
		local potential_mul = carry_tweak_data[job_stars]
		
		if managers.experience:current_level() <= level_limit_tweak_data.low_cap_level then
			player_mul = player_mul + player_mul * level_limit_tweak_data.low_cap_multiplier
			player_mul = math.round( math.min( player_mul, potential_mul ) )
		else
			local diff_in_money = potential_mul - player_mul
			local diff_in_stars = job_and_difficulty_stars - player_stars
			local tweak_multiplier = level_limit_tweak_data.pc_difference_multipliers[diff_in_stars] or 0
			
			player_mul = player_mul + diff_in_money * tweak_multiplier
			player_mul = math.round( math.min( player_mul, potential_mul ) )
		end
		mul_value = player_mul
	end]]
	
	return value * mul_value -- ( mul_value + mul_value * money_multiplier )
end

---------------------------------------------------------------------------------

-- All loot value, secured carried and picked up
function LootManager:get_real_total_value()
	local value = 0
	for _,data in ipairs( self._global.secured ) do
		value = value + self:get_real_value( data.carry_id, data.value ) -- ( data.value * tweak_data.carry[ self:_multiplier_by_id( data.carry_id ) ] )
	end
	return value
end

-- Carried stuff that been secured
function LootManager:get_real_total_loot_value()
	local value = 0
	for _,data in ipairs( self._global.secured ) do
		if not tweak_data.carry.small_loot[ data.carry_id ] then
			value = value + self:get_real_value( data.carry_id, data.value ) -- ( data.value * tweak_data.carry[ self:_multiplier_by_id( data.carry_id ) ] )
		end
	end
	return value
end

-- Small loot that has been picked up
function LootManager:get_real_total_small_loot_value()
	local value = 0
	for _,data in ipairs( self._global.secured ) do
		if tweak_data.carry.small_loot[ data.carry_id ] then
			value = value + self:get_real_value( data.carry_id, data.value ) -- ( data.value * tweak_data.carry[ self:_multiplier_by_id( data.carry_id ) ] )
		end
	end
	return value
end


function LootManager:set_postponed_small_loot()
	self._global.postponed_small_loot = {}
	for _,data in ipairs( self._global.secured ) do
		if tweak_data.carry.small_loot[ data.carry_id ] then
			table.insert( self._global.postponed_small_loot, deep_clone( data ) )
		end
	end
end

function LootManager:get_real_total_postponed_small_loot_value()
	if not self._global.postponed_small_loot then
		return 0
	end

	local value = 0
	for _,data in ipairs( self._global.postponed_small_loot ) do
		value = value + self:get_real_value( data.carry_id, data.value ) -- ( data.value * tweak_data.carry[ self:_multiplier_by_id( data.carry_id ) ] )
	end

	return value
end

function LootManager:clear_postponed_small_loot()
	self._global.postponed_small_loot = nil
end

---------------------------------------------------------------------------------

--[[function LootManager:total_value()
	local value = 0
	for _,data in ipairs( self._global.secured ) do
		value = value + data.value
	end
	return value
end]]

function LootManager:total_value_by_carry_id( carry_id )
	local value = 0
	for _,data in ipairs( self._global.secured ) do
		if data.carry_id == carry_id then
			value = value + data.value
		end
	end
	return value
end

function LootManager:total_small_loot_value()
	local value = 0
	for _,data in ipairs( self._global.secured ) do
		if tweak_data.carry.small_loot[ data.carry_id ] then
			value = value + data.value
		end
	end
	return value
end

function LootManager:total_value_by_type( type )
	if not tweak_data.carry.types[ type ] then
		Application:error( "Carry type", type, "doesn't exists!" )
		return
	end
	
	local value = 0
	for _,data in ipairs( self._global.secured ) do
		if tweak_data.carry[ data.carry_id ].type == type then
			value = value + data.value
		end
	end
	return value
end

---------------------------------------------------------------------------------

function LootManager:_present( carry_id, value )
	local real_value = self:get_real_value( carry_id, value )
	
	local carry_data = tweak_data.carry[ carry_id ]
	local title = managers.localization:text( "hud_loot_secured_title" )
	
	local type_text = carry_data.name_id and managers.localization:text( carry_data.name_id )
	local text = managers.localization:text( "hud_loot_secured", { CARRY_TYPE = type_text, AMOUNT = managers.experience:cash_string( real_value ) } )
	
	local icon = nil
	managers.hud:present_mid_text( { text = text, title = title, icon = icon, time = 4, event = "stinger_objectivecomplete" } )
end

---------------------------------------------------------------------------------

-- For drop in
function LootManager:sync_save( data )
	data.LootManager = self._global
end

-- For drop in
function LootManager:sync_load( data )
	self._global = data.LootManager 
end