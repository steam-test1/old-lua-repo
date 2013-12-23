UpgradesManager = UpgradesManager or class()
-- UpgradesManager.PATH = "gamedata/objectives"
-- UpgradesManager.FILE_EXTENSION = "objective"
-- UpgradesManager.FULL_PATH = UpgradesManager.PATH .. "." .. UpgradesManager.FILE_EXTENSION

function UpgradesManager:init()
	self:_setup()
end

-- Some experience data is kept between levels (if not saved and loaded to profile)
function UpgradesManager:_setup()
	if not Global.upgrades_manager then
		Global.upgrades_manager = {}
		Global.upgrades_manager.aquired = {}
		Global.upgrades_manager.automanage = false 
		Global.upgrades_manager.progress = { 0, 0, 0, 0 } -- TREE TECH
		Global.upgrades_manager.target_tree = self:_autochange_tree() -- TREE TECH
		Global.upgrades_manager.disabled_visual_upgrades = {}
	end
	
	self._global = Global.upgrades_manager
end


function UpgradesManager:setup_current_weapon()
	--[[local p_unit = managers.player:player_unit()
	
	if not p_unit then
		return
	end
	
	local weapon_unit = p_unit:inventory():equipped_unit()
	local weapon_name = weapon_unit:base().name_id
	self:_apply_visual_weapon_upgrade( weapon_unit, tweak_data.upgrades.visual.upgrade[ weapon_name ] )
	
	local aquired_updgrades = {}
	for upgrade_id, upgrade in pairs( self._global.aquired ) do
		if not self._global.disabled_visual_upgrades[ upgrade_id ] then
			local upgrade_def = tweak_data.upgrades.definitions[ upgrade_id ]
			if upgrade_def and upgrade_def.upgrade and upgrade_def.upgrade.category == weapon_name then
				table.insert( aquired_updgrades, { id = upgrade_id } )
			end
		end
	end
	
--    table.sort( aquired_updgrades, function (n1, n2) return n1.level < n2.level end )

	for _, upgrade_data in ipairs( aquired_updgrades ) do
		self:_apply_visual_weapon_upgrade( weapon_unit, tweak_data.upgrades.visual.upgrade[ upgrade_data.id ] )
	end]]
end

function UpgradesManager:visual_weapon_upgrade_active( upgrade )
	return not self._global.disabled_visual_upgrades[ upgrade ]
end

function UpgradesManager:toggle_visual_weapon_upgrade( upgrade )
	if self._global.disabled_visual_upgrades[ upgrade ] then
		self._global.disabled_visual_upgrades[ upgrade ] = nil
	else
		self._global.disabled_visual_upgrades[ upgrade ] = true
	end
end

--[[function UpgradesManager:_apply_visual_weapon_upgrade( weapon_unit, upgrade )
	if not upgrade then
		return
	end
	
	for obj_name, vis in pairs( upgrade.objs ) do 
		weapon_unit:get_object( Idstring( obj_name ) ):set_visibility( vis )
	end
	
	if upgrade.fire_obj then
		local fire_obj = weapon_unit:get_object( Idstring( upgrade.fire_obj ) )
		weapon_unit:base():change_fire_object( fire_obj )
	end
end]]


function UpgradesManager:set_target_tree( tree )
	local level = managers.experience:current_level() -- managers.experience:current_level()+1
	local step = self._global.progress[ tree ]
	
	local cap = tweak_data.upgrades.tree_caps[ self._global.progress[ tree ] + 1 ]
	-- print( cap, level )
	if cap and level < cap then	-- NOT ALLOWED
		-- print( "NOT ALLOWED" )
		return
	end
	
	self:_set_target_tree( tree )
	-- tweak_data.upgrades.level_roofs = 
end

function UpgradesManager:_set_target_tree( tree )
	-- print( "Target tree will be set to", tree, "which is", managers.localization:text( tweak_data.upgrades.trees[ tree ].name_id ) )
	local i = self._global.progress[ tree ] + 1
	local upgrade = tweak_data.upgrades.definitions[ tweak_data.upgrades.progress[ tree ][ i ] ]
	-- print( "Next upgrade will be number", i, "which is",  managers.localization:text( upgrade.name_id ) )
	self._global.target_tree = tree
end

function UpgradesManager:current_tree_name()
	return self:tree_name( self._global.target_tree )
end

function UpgradesManager:tree_name( tree )
	return managers.localization:text( tweak_data.upgrades.trees[ tree ].name_id )
end

function UpgradesManager:tree_allowed( tree, level )
	level = level or managers.experience:current_level()
	local cap = tweak_data.upgrades.tree_caps[ self._global.progress[ tree ] + 1 ]
	return not( cap and level < cap ), cap
end

function UpgradesManager:current_tree()
	return self._global.target_tree
end

function UpgradesManager:next_upgrade( tree )
	
end

function UpgradesManager:level_up()
	local level = managers.experience:current_level()
	print( "UpgradesManager:level_up()", level )
	
	self:aquire_from_level_tree( level, false )
end

function UpgradesManager:aquire_from_level_tree( level, loading )
	local tree_data = tweak_data.upgrades.level_tree[ level ]
	if not tree_data then
		-- print( "Nothing to get in level", level )
		return
	end 
	
	-- print( "tree_data", inspect( tree_data ) )
	for _,upgrade in ipairs( tree_data.upgrades ) do
		self:aquire( upgrade, loading )
	end
end

--[[function UpgradesManager:aquire_target()
	-- local upgrade = self._global.target_tree
	self._global.progress[ self._global.target_tree ] = self._global.progress[ self._global.target_tree ] + 1
		
	-- local upgrade = self._global.progress[ self._global.target_tree ]
	local upgrade = tweak_data.upgrades.progress[ self._global.target_tree ][ self._global.progress[ self._global.target_tree ] ]
	-- print( "Get something from tree", self._global.target_tree, "on step", self._global.progress[ self._global.target_tree ] ) 
	-- print( " and it was", upgrade )
			
	self:aquire( upgrade )
		
	-- select new tree based on lowest progress
	if self._global.automanage then
		self:_set_target_tree( self:_autochange_tree() )
	end
	
	-- Check if we now are at a level roof
	local level = managers.experience:current_level() + 1
	local cap = tweak_data.upgrades.tree_caps[ self._global.progress[ self._global.target_tree ] + 1 ]
	if cap and level < cap then	-- We have reach a cap and need to change tree
		-- print( "REACHED A LEVEL CAP", cap, level )
		self:_set_target_tree( self:_autochange_tree( self._global.target_tree ) )
		-- print( " New tree is", self._global.target_tree )
		-- select lowest progress
	end
	-- self._global.progress[ self._global.target_tree ] + 1 
end]]

function UpgradesManager:_next_tree()
	local tree
	if self._global.automanage then
		tree = self:_autochange_tree()
	end
		
	-- Check if we now are at a level roof
	local level = managers.experience:current_level() + 1
	local cap = tweak_data.upgrades.tree_caps[ self._global.progress[ self._global.target_tree ] + 1 ]
	-- print( cap, level )
	if cap and level < cap then	-- We have reach a cap and need to change tree
		-- print( "_next_tree REACHED A LEVEL CAP", cap, level )
		-- self._global.target_tree = self:_autochange_tree( self._global.target_tree )
		tree = self:_autochange_tree( self._global.target_tree )
		-- print( "_next_tree tree is", self._global.target_tree )
		-- select lowest progress
	end
	return tree or self._global.target_tree
end

function UpgradesManager:num_trees()
	return managers.dlc:has_preorder() and 4 or 3
end

function UpgradesManager:_autochange_tree( exlude_tree )
	local progress = clone( Global.upgrades_manager.progress )
	if exlude_tree then 
		progress[ exlude_tree ] = nil 
	end
	
	if not managers.dlc:has_preorder() then
		progress[ 4 ] = nil
	end
	
	local n_tree = 0
	local n_v = 100
	
	for tree,v in pairs( progress ) do
		if v < n_v then
			n_tree 	= tree
			n_v		= v
		end
	end
	return n_tree
end


function UpgradesManager:aquired( id )
	if self._global.aquired[ id ] then
		return true
	end
end

function UpgradesManager:aquire_default( id )
	if not tweak_data.upgrades.definitions[ id ] then
		Application:error( "Tried to aquire an upgrade that doesn't exist: "..id.."" )
		return
	end

	if self._global.aquired[ id ] then
		-- Application:error( "Tried to aquire an upgrade that has allready been aquired: "..id.."" )
		return
	end	
	
	self._global.aquired[ id ] = true
	
	local upgrade = tweak_data.upgrades.definitions[ id ]
	self:_aquire_upgrade( upgrade, id )	
end

function UpgradesManager:aquire( id, loading )
	-- print( "UpgradesManager:aquire", id )
	if not tweak_data.upgrades.definitions[ id ] then
		Application:error( "Tried to aquire an upgrade that doesn't exist: " .. (id or "nil") .. "" )
		return
	end

	if self._global.aquired[ id ] then
		Application:error( "Tried to aquire an upgrade that has allready been aquired: "..id.."" )
		return
	end	
	
	local level = managers.experience:current_level()+1
	self._global.aquired[ id ] = true
	
	local upgrade = tweak_data.upgrades.definitions[ id ]
	self:_aquire_upgrade( upgrade, id, loading )
	self:setup_current_weapon()
end

function UpgradesManager:unaquire( id )
	-- print( "UpgradesManager:unaquire", id )
	if not tweak_data.upgrades.definitions[ id ] then
		Application:error( "Tried to unaquire an upgrade that doesn't exist: " .. (id or "nil") .. "" )
		return
	end

	if not self._global.aquired[ id ] then
		Application:error( "Tried to unaquire an upgrade that hasn't benn aquired: "..id.."" )
		return
	end	
	
	self._global.aquired[ id ] = nil
	
	local upgrade = tweak_data.upgrades.definitions[ id ]
	self:_unaquire_upgrade( upgrade, id )
end

function UpgradesManager:_aquire_upgrade( upgrade, id, loading )
	if upgrade.category == "weapon" then
		self:_aquire_weapon( upgrade, id, loading )
	elseif upgrade.category == "feature" then
		self:_aquire_feature( upgrade, id, loading )
	elseif upgrade.category == "equipment" then
		self:_aquire_equipment( upgrade, id, loading )
	elseif upgrade.category == "equipment_upgrade" then
		self:_aquire_equipment_upgrade( upgrade, id, loading )
	elseif upgrade.category == "temporary" then
		self:_aquire_temporary( upgrade, id, loading )
	elseif upgrade.category == "team" then
		self:_aquire_team( upgrade, id, loading )
	elseif upgrade.category == "armor" then
		self:_aquire_armor( upgrade, id, loading )
	elseif upgrade.category == "rep_upgrade" then
		self:_aquire_rep_upgrade( upgrade, id, loading )
	end
end

function UpgradesManager:_unaquire_upgrade( upgrade, id )
	-- Application:debug( "UpgradesManager:_unaquire_upgrade", id, upgrade.category )
	if upgrade.category == "weapon" then
		self:_unaquire_weapon( upgrade, id )
	elseif upgrade.category == "feature" then
		self:_unaquire_feature( upgrade, id )
	elseif upgrade.category == "equipment" then
		 self:_unaquire_equipment( upgrade, id )
	elseif upgrade.category == "equipment_upgrade" then
		self:_unaquire_equipment_upgrade( upgrade, id )
	elseif upgrade.category == "temporary" then
		self:_unaquire_temporary( upgrade, id )
	elseif upgrade.category == "team" then
		self:_unaquire_team( upgrade, id )
	elseif upgrade.category == "armor" then
		self:_unaquire_armor( upgrade, id )
	end
end

function UpgradesManager:_aquire_weapon( upgrade, id, loading )
	managers.player:aquire_weapon( upgrade, id )
	managers.blackmarket:on_aquired_weapon_platform( upgrade, id, loading )
end

function UpgradesManager:_unaquire_weapon( upgrade, id )
	managers.player:unaquire_weapon( upgrade, id )
	managers.blackmarket:on_unaquired_weapon_platform( upgrade, id )
end

function UpgradesManager:_aquire_feature( feature )
	if feature.incremental then
		managers.player:aquire_incremental_upgrade( feature.upgrade )
	else
		managers.player:aquire_upgrade( feature.upgrade )
	end
end

function UpgradesManager:_unaquire_feature( feature )
	if feature.incremental then
		managers.player:unaquire_incremental_upgrade( feature.upgrade )
	else
		managers.player:unaquire_upgrade( feature.upgrade )
	end
end

function UpgradesManager:_aquire_equipment( equipment, id )
	managers.player:aquire_equipment( equipment, id )
end

function UpgradesManager:_unaquire_equipment( equipment, id )
	managers.player:unaquire_equipment( equipment, id )
end

function UpgradesManager:_aquire_equipment_upgrade( equipment_upgrade )
	managers.player:aquire_upgrade( equipment_upgrade.upgrade )
end

function UpgradesManager:_unaquire_equipment_upgrade( equipment_upgrade )
	managers.player:unaquire_upgrade( equipment_upgrade.upgrade )
end

function UpgradesManager:_aquire_temporary( temporary, id )
	-- print( "UpgradesManager:_aquire_temporary", temporary, id )
	if temporary.incremental then
		managers.player:aquire_incremental_upgrade( temporary.upgrade )
	else
		managers.player:aquire_upgrade( temporary.upgrade, id )
	end
end

function UpgradesManager:_unaquire_temporary( temporary, id )
	-- print( "UpgradesManager:_unaquire_temporary", temporary, id )
	if temporary.incremental then
		managers.player:unaquire_incremental_upgrade( temporary.upgrade )
	else
		managers.player:unaquire_upgrade( temporary.upgrade )
	end
end

function UpgradesManager:_aquire_team( team, id )
	managers.player:aquire_team_upgrade( team.upgrade, id )
end

function UpgradesManager:_unaquire_team( team, id )
	managers.player:unaquire_team_upgrade( team.upgrade, id )
end

function UpgradesManager:_aquire_armor( upgrade, id, loading )
	managers.blackmarket:on_aquired_armor( upgrade, id, loading )
end

function UpgradesManager:_unaquire_armor( upgrade, id )
	managers.blackmarket:on_unaquired_armor( upgrade, id )
end

function UpgradesManager:_aquire_rep_upgrade( upgrade, id )
	managers.skilltree:rep_upgrade( upgrade, id )
end

function UpgradesManager:get_value( upgrade_id )
	local upgrade = tweak_data.upgrades.definitions[ upgrade_id ]
	local u = upgrade.upgrade
	if upgrade.category == "feature" then
		return tweak_data.upgrades.values[ u.category ][ u.upgrade ][ u.value ]
	elseif upgrade.category == "equipment" then
		return upgrade.equipment_id
	elseif upgrade.category == "equipment_upgrade" then
		return tweak_data.upgrades.values[ u.category ][ u.upgrade ][ u.value ]
	elseif upgrade.category == "temporary" then
		local temporary = tweak_data.upgrades.values[ u.category ][ u.upgrade ][ u.value ]
		return "Value: "..tostring(temporary[ 1 ]).." Time: "..temporary[ 2 ]
	elseif upgrade.category == "team" then
		local value = tweak_data.upgrades.values[ "team" ][ u.category ][ u.upgrade ][ u.value ]
		return value
	elseif upgrade.category == "weapon" then
		local default_weapons = { "glock_17", "amcar" }
		local weapon_id = upgrade.weapon_id
		
		local is_default_weapon = table.contains( default_weapons, weapon_id ) and true or false
		local weapon_level = 0
		
		for level, data in pairs( tweak_data.upgrades.level_tree ) do
			local upgrades = data.upgrades
			if upgrades and table.contains( upgrades, weapon_id ) then
				weapon_level = level
				break
			end
		end
		
		return is_default_weapon, weapon_level
	end
	
	print( "no value for", upgrade_id, upgrade.category )
end

function UpgradesManager:get_category( upgrade_id )
	local upgrade = tweak_data.upgrades.definitions[ upgrade_id ]
	return upgrade.category
end

function UpgradesManager:get_upgrade_upgrade( upgrade_id )
	local upgrade = tweak_data.upgrades.definitions[ upgrade_id ]
	return upgrade.upgrade
end

-- Returns if the step is locked by the current player level
function UpgradesManager:is_locked( step )
	local level = managers.experience:current_level()
	for i,d in ipairs( tweak_data.upgrades.itree_caps ) do
		if level < d.level then
			return step >= d.step
		end
	end
	return false
end

function UpgradesManager:get_level_from_step( step )
	for i,d in ipairs( tweak_data.upgrades.itree_caps ) do
		if step == d.step then
			return d.level
		end
	end
	return 0
end


function UpgradesManager:progress()
	if managers.dlc:has_preorder() then
		return { self._global.progress[1], self._global.progress[2], self._global.progress[3], self._global.progress[4] }
	end
	
	return { self._global.progress[1], self._global.progress[2], self._global.progress[3] }
end

function UpgradesManager:progress_by_tree( tree )
	return self._global.progress[ tree ]
end

function UpgradesManager:name( id )
	if not tweak_data.upgrades.definitions[ id ] then
		Application:error( "Tried to get name from an upgrade that doesn't exist: "..id.."" )
		return
	end
	
	local upgrade = tweak_data.upgrades.definitions[ id ]
	return managers.localization:text( upgrade.name_id )
end

function UpgradesManager:title( id )
	if not tweak_data.upgrades.definitions[ id ] then
		Application:error( "Tried to get title from an upgrade that doesn't exist: "..id.."" )
		return
	end
	
	local upgrade = tweak_data.upgrades.definitions[ id ]
	return upgrade.title_id and managers.localization:text( upgrade.title_id ) or nil
end

function UpgradesManager:subtitle( id )
	if not tweak_data.upgrades.definitions[ id ] then
		Application:error( "Tried to get subtitle from an upgrade that doesn't exist: "..id.."" )
		return
	end
	
	local upgrade = tweak_data.upgrades.definitions[ id ]
	return upgrade.subtitle_id and managers.localization:text( upgrade.subtitle_id ) or nil
end

function UpgradesManager:complete_title( id, type )
	local title = self:title( id )
	if not title then
		return nil
	end
	
	local subtitle = self:subtitle( id )
	if not subtitle then
		return title
	end
	
	if type then 
		if type == "single" then
			return title.." "..subtitle
		else
			return title..type..subtitle
		end
	end
	
	return title.."\n"..subtitle
end

function UpgradesManager:description( id )
	if not tweak_data.upgrades.definitions[ id ] then
		Application:error( "Tried to get description from an upgrade that doesn't exist: "..id.."" )
		return
	end
	
	local upgrade = tweak_data.upgrades.definitions[ id ]
	return upgrade.subtitle_id and managers.localization:text( upgrade.description_text_id or id ) or nil
end


function UpgradesManager:image( id )
	local image = tweak_data.upgrades.definitions[ id ].image
	if not image then
		return nil, nil
	end
	return tweak_data.hud_icons:get_icon_data( image )
end

function UpgradesManager:image_slice( id )
	local image_slice = tweak_data.upgrades.definitions[ id ].image_slice
	if not image_slice then
		return nil, nil
	end
	return tweak_data.hud_icons:get_icon_data( image_slice )
end

function UpgradesManager:icon( id )
	if not tweak_data.upgrades.definitions[ id ] then
		Application:error( "Tried to aquire an upgrade that doesn't exist: "..id.."" )
		return
	end
	
	return tweak_data.upgrades.definitions[ id ].icon
end

function UpgradesManager:aquired_by_category( category )
	local t = {}
	for name,_ in pairs( self._global.aquired ) do
		if tweak_data.upgrades.definitions[ name ].category == category then
			table.insert( t, name )
		end
	end
	return t
end

function UpgradesManager:aquired_features()
	return self:aquired_by_category( "feature" )
end

function UpgradesManager:aquired_weapons()
	return self:aquired_by_category( "weapon" )
end

------------------------------------------------------------------------

function UpgradesManager:all_weapon_upgrades()
	for id,data in pairs( tweak_data.upgrades.definitions ) do  
		if data.category == "weapon" then 
			print( id )
		end
	end
end

function UpgradesManager:weapon_upgrade_by_weapon_id( weapon_id )
	for id,data in pairs( tweak_data.upgrades.definitions ) do  
		if data.category == "weapon" then 
			if data.weapon_id == weapon_id then
				return data
			end 
		end
	end
end

function UpgradesManager:weapon_upgrade_by_factory_id( factory_id )
	for id,data in pairs( tweak_data.upgrades.definitions ) do  
		if data.category == "weapon" then 
			if data.factory_id == factory_id then
				return data
			end 
		end
	end
end

------------------------------------------------------------------------

function UpgradesManager:print_aquired_tree()
	local tree = {}
	
	for name, data in pairs( self._global.aquired ) do
		tree[ data.level ] = { name = name }
	end
	
	for i,data in pairs( tree ) do
		print( self:name( data.name ) )
	end
end

function UpgradesManager:analyze()
	local not_placed = {}
	local placed = {}
	local features = {}
	local amount = 0
	
	for lvl,upgrades in pairs( tweak_data.upgrades.levels ) do
		print( "Upgrades at level "..lvl..":" )
		for _,upgrade in ipairs( upgrades ) do
			print( "\t"..upgrade )
		end
	end
	
	for name,data in pairs( tweak_data.upgrades.definitions ) do
		amount = amount + 1
		for lvl,upgrades in pairs( tweak_data.upgrades.levels ) do
			for _,upgrade in ipairs( upgrades ) do
				if upgrade == name then
					if placed[ name ] then
						print( "ERROR: Upgrade "..name.." is already placed in level "..placed[ name ].."!" ) 
					else
						placed[ name ] = lvl
					end
					if data.category == "feature" then
						features[ data.upgrade.category ] = features[ data.upgrade.category ] or {}
						table.insert( features[ data.upgrade.category ], { level = lvl, name = name } )
					end
				end
			end
		end
		if not placed[ name ] then
			not_placed[ name ] = true
		end
	end
	for name,lvl in pairs( placed ) do
		print( "Upgrade "..name.." is placed in level\t\t "..lvl.."." )
	end
	for name,_ in pairs( not_placed ) do
		print( "Upgrade "..name.." is not placed any level!" )
	end
	print( "" )
	for category,upgrades in pairs( features ) do
		print( "Upgrades for category "..category.. " is recieved at:" )
		for _,upgrade in ipairs( upgrades ) do
			print( "  Level: "..upgrade.level..", "..upgrade.name.."" )
		end
	end 
	print( "\nTotal upgrades "..amount.."." )
end

function UpgradesManager:tree_stats()
	local t = { { u = {}, a = 0 }, { u = {}, a = 0 }, { u = {}, a = 0 } }
	
	for name, d in pairs( tweak_data.upgrades.definitions ) do 
		if d.tree then
			t[ d.tree ].a = t[ d.tree ].a + 1
			table.insert( t[ d.tree ].u, name )
		end
	end
	for i,d in ipairs( t ) do
		print( inspect( d.u ) )
		print( d.a )
	end
	-- print( inspect( t ) )
end

------------------------------------------------------------------------
--[[
function UpgradesManager:total_aquired()
	local i = 0
	for _,data in pairs( self._global.aquired ) do	
		i = i + 1
	end
	return i
end

function UpgradesManager:total_to_aquire()
	local i = 0
	for n,data in pairs( tweak_data.upgrades.definitions ) do	
		if data.unlock_lvl ~= 0 and not data.aquire then -- Don't count defaults or if the upgrade automaticly gives another upgrade
			i = i + 1
		-- else
		 --	print( "skip", n )
		end
	end
	return i
end
]]
------------------------------------------------------------------------

function UpgradesManager:save( data )
	local state = {
		automanage = self._global.automanage,
		progress = self._global.progress,
		target_tree = self._global.target_tree,
		disabled_visual_upgrades = self._global.disabled_visual_upgrades
	}
	
	if self._global.incompatible_data_loaded and self._global.incompatible_data_loaded.progress then
		state.progress = clone( self._global.progress )
		for i, k in pairs( self._global.incompatible_data_loaded.progress ) do
			print( "saving incompatible data", i, k )
			state.progress[ i ] = math.max( state.progress[ i ], k )
		end
	end
	
	data.UpgradesManager = state
end

function UpgradesManager:load( data )
	local state = data.UpgradesManager
	self._global.automanage				  = state.automanage
	self._global.progress				  = state.progress
	self._global.target_tree			  = state.target_tree
	self._global.disabled_visual_upgrades = state.disabled_visual_upgrades 
	
	self:_verify_loaded_data()
end


function UpgradesManager:_verify_loaded_data()
	--[[while #self._global.progress < #tweak_data.upgrades.progress do
		table.insert( self._global.progress, 0 )
	end
	while #self._global.progress > #tweak_data.upgrades.progress do
		table.remove( self._global.progress )
	end
	
	if self._global.progress[ 4 ] and not managers.dlc:has_preorder() then
		
		self._global.incompatible_data_loaded = self._global.incompatible_data_loaded or {}
		self._global.incompatible_data_loaded.progress = { [4] = self._global.progress[ 4 ] } -- remember that we have loaded incompatible data. They need to be saved.
		print( "loading incompatible data", inspect( self._global.incompatible_data_loaded ) )
		self._global.progress[ 4 ] = 0
		if self._global.target_tree == 4 then
			self:_set_target_tree( self:_autochange_tree() )
		end
	end
	
	if self._global.progress[ self._global.target_tree ] >= 48 then
		self:_set_target_tree( self:_autochange_tree() )	
	end
	
	if self._global.target_tree > #self._global.progress then
		self:_set_target_tree( self:_autochange_tree() )
	end
		
	for tree, lvl in ipairs( self._global.progress ) do
		for i = 1, lvl do
			local id = tweak_data.upgrades.progress[ tree ][ i ]
			local upgrade = tweak_data.upgrades.definitions[ id ]
			self:_aquire_upgrade( upgrade, id )
			self._global.aquired[ id ] = true
		end
	end
	
	if not self._global.disabled_visual_upgrades then
		self._global.disabled_visual_upgrades = {}
	end]]
end

function UpgradesManager:reset()
	Global.upgrades_manager = nil
	self:_setup()
end

