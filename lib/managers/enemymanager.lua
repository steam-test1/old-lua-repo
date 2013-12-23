local mvec3_set = mvector3.set
local mvec3_sub = mvector3.subtract
local mvec3_dir = mvector3.direction
local mvec3_dot = mvector3.dot
local mvec3_dis = mvector3.distance

local t_rem = table.remove
local t_ins = table.insert

local m_min = math.min

local tmp_vec1 = Vector3()

EnemyManager = EnemyManager or class()

EnemyManager._MAX_NR_CORPSES = 8

EnemyManager._nr_i_lod = 
{
	{ 2, 2 },
	{ 5, 2 },
	{ 10, 5 }
}


function EnemyManager:init()
	
	self:_init_enemy_data()
	
	self._unit_clbk_key = "EnemyManager"
	
	self._corpse_disposal_upd_interval = 5	--	How often the corpse disposal check should be executed
end

-----------------------------------------------------------------------------

function EnemyManager:update( t, dt )
	self._t = t
	self._queued_task_executed = nil
	
	self:_update_gfx_lod()
	
	self:_update_queued_tasks( t )
	
	--[[for u_key, u_data in pairs( self._enemy_data.unit_data ) do
		Application:draw_sphere( u_data.unit:movement():m_com(), 30, 1,0,0 )
	end
	for u_key, u_data in pairs( self._civilian_data.unit_data ) do
		Application:draw_sphere( u_data.unit:movement():m_com(), 30, 1,0,0 )
	end]]
end

-----------------------------------------------------------------------------
-- process all hidden units and 1 visible unit each frame
function EnemyManager:_update_gfx_lod()
	if self._gfx_lod_data.enabled and managers.navigation:is_data_ready() then
		local camera_rot = managers.viewport:get_current_camera_rotation()
		if camera_rot then
			local pl_tracker, cam_pos
			local pl_fwd = camera_rot:y()
			local player = managers.player:player_unit()
			if player then
				pl_tracker = player:movement():nav_tracker()
				cam_pos = player:movement():m_head_pos()
			else
				pl_tracker = false
				cam_pos = managers.viewport:get_current_camera_position()
			end
			
			local entries = self._gfx_lod_data.entries
			local units = entries.units
			local states = entries.states
			local move_ext = entries.move_ext
			local trackers = entries.trackers
			local com = entries.com
			local chk_vis_func = pl_tracker and pl_tracker.check_visibility
			local unit_occluded = Unit.occluded
			local occ_skip_units = managers.occlusion._skip_occlusion
			--local dt_lmt = math.cos( managers.user:get_setting( "fov_standard" ) / 2 ) - 0.2


			local world_in_view_with_options = World.in_view_with_options
			
			for i, state in ipairs( states ) do



				if not state then	-- hidden unit
					if occ_skip_units[ units[i]:key() ] or ( ( not pl_tracker or chk_vis_func( pl_tracker, trackers[i] ) ) and not unit_occluded( units[i] ) ) then
						local distance = mvec3_dir( tmp_vec1, cam_pos, com[i] )
						--if mvec3_dot( tmp_vec1, pl_fwd ) > dt_lmt + 0.05 or distance < 200 then
						if world_in_view_with_options( World, com[i], 0, 110, 18000 ) then
							states[i] = 1


							units[i]:base():set_visibility_state( 1 )
						end
					end
				end
			end
			
			if #states > 0 then
				--print( "updating lod" )
				
				local anim_lod = managers.user:get_setting( "video_animation_lod" )
				local nr_lod_1 = self._nr_i_lod[anim_lod][1]	-- # high anim detail
				local nr_lod_2 = self._nr_i_lod[anim_lod][2]	-- # low anim detail
				local nr_lod_total = nr_lod_1 + nr_lod_2 -- total # of high and low
				local imp_i_list = self._gfx_lod_data.prio_i
				local imp_wgt_list = self._gfx_lod_data.prio_weights
				local nr_entries = #states
				local i = self._gfx_lod_data.next_chk_prio_i
				if i > nr_entries then
					i = 1
				end
				local start_i = i
				repeat
					if states[ i ] then -- visible unit
						--print( "checking i", i )
						if not occ_skip_units[ units[i]:key() ] and( pl_tracker and not chk_vis_func( pl_tracker, trackers[i] ) or unit_occluded( units[i] ) ) then
							--print( "occluded" )
							states[i] = false
							units[i]:base():set_visibility_state( false )
							self:_remove_i_from_lod_prio( i, anim_lod )
							
							self._gfx_lod_data.next_chk_prio_i = i + 1
							break
						else

							if not world_in_view_with_options( World, com[i], 0, 120, 18000 ) then
								-- print( "frustum occluded", my_wgt )
								states[i] = false
								units[i]:base():set_visibility_state( false )
								self:_remove_i_from_lod_prio( i, anim_lod )
								
								self._gfx_lod_data.next_chk_prio_i = i + 1
								break
							else
								local my_wgt = mvec3_dir( tmp_vec1, cam_pos, com[i] )
								local dot = mvec3_dot( tmp_vec1, pl_fwd )
								-- print( "my_wgt", my_wgt )
								local previous_prio
								for prio, i_entry in ipairs( imp_i_list ) do
									if i == i_entry then
										previous_prio = prio
										--print( "previous_prio", previous_prio )
										break
									end
								end
								
								my_wgt = my_wgt * my_wgt * ( 1 - dot )
								--print( "my_wgt", my_wgt )
								local i_wgt = #imp_wgt_list
								while i_wgt > 0 do
									if previous_prio ~= i_wgt and my_wgt >= imp_wgt_list[ i_wgt ] then
										break
									end
									i_wgt = i_wgt - 1
								end
								if not previous_prio or previous_prio >= i_wgt then
									i_wgt = i_wgt + 1	-- the position we are inserting
								end
								--print( "i_wgt", i_wgt )
								if i_wgt ~= previous_prio then
									if previous_prio then
										t_rem( imp_i_list, previous_prio )
										t_rem( imp_wgt_list, previous_prio )
										--[[print( "removing old prio" )
										for i, k in ipairs( imp_wgt_list ) do
											print( i, imp_i_list[i], k )
										end]]
										if previous_prio <= nr_lod_1 and i_wgt > nr_lod_1 and #imp_i_list >= nr_lod_1 then	-- we were on prio 1. someone needs to get promoted
											local promote_i = imp_i_list[ nr_lod_1 ]	-- this one is not in the prio list any more
											--print( "promote_i", promote_i )
											states[ promote_i ] = 1
											units[ promote_i ]:base():set_visibility_state( 1 )
										elseif previous_prio > nr_lod_1 and i_wgt <= nr_lod_1 then	-- we were on prio 2. someone needs to get denoted
											local denote_i = imp_i_list[ nr_lod_1 ]	-- this one was pushed back from prio 1 to prio 2.
											--print( "denote_i", denote_i )
											states[ denote_i ] = 2
											units[ denote_i ]:base():set_visibility_state( 2 )
										end
									elseif i_wgt <= nr_lod_total and #imp_i_list == nr_lod_total then
										local kick_i = imp_i_list[ nr_lod_total ]	-- this one is not in the prio list any more
										--print( "kick_i", kick_i )
										states[ kick_i ] = 3
										units[ kick_i ]:base():set_visibility_state( 3 )
										t_rem( imp_wgt_list )
										t_rem( imp_i_list )
									end
									
									local lod_stage
									if i_wgt <= nr_lod_total then
										--print( "entering prio list" )
										t_ins( imp_wgt_list, i_wgt, my_wgt )
										t_ins( imp_i_list, i_wgt, i )
										lod_stage = i_wgt <= nr_lod_1 and 1 or 2
									else
										--print( "left prio list" )
										lod_stage = 3
										self:_remove_i_from_lod_prio( i, anim_lod )
									end
									if states[i] ~= lod_stage then
										--print( "setting lod_stage", lod_stage )
										states[i] = lod_stage
										units[i]:base():set_visibility_state( lod_stage )
									end
								end
								self._gfx_lod_data.next_chk_prio_i = i + 1
								break
							end
						end
					end
					if i == nr_entries then
						i = 1
					else
						i = i + 1
					end
				until i == start_i
				--[[print( "result" )
				for i, k in ipairs( imp_wgt_list ) do
					print( i, imp_i_list[i], k )
				end]]
				--[[local mvec3_set_st = mvector3.set_static
				local sp_clr = Vector3()
				for prio, i_entry in ipairs( self._gfx_lod_data.prio_i ) do
					if states[ i_entry ] == 1 then
						mvec3_set_st( sp_clr, 1,1,1)
					elseif states[ i_entry ] == 2 then
						mvec3_set_st( sp_clr, 0.5,0.5,0.5)
					else
						mvec3_set_st( sp_clr, 0,0,0)
					end
					Application:draw_sphere( com[ i_entry ], 100, sp_clr.x, sp_clr.y, sp_clr.z )
				end]]
			end
		end
	end
end

-----------------------------------------------------------------------------

function EnemyManager:_remove_i_from_lod_prio( i, anim_lod )
	--print( "_remove_i_from_lod_prio", i )
	anim_lod = anim_lod or managers.user:get_setting( "video_animation_lod" )
	
	local nr_i_lod1 = self._nr_i_lod[anim_lod][1]
	for prio, i_entry in ipairs( self._gfx_lod_data.prio_i ) do
		if i == i_entry then
			table.remove( self._gfx_lod_data.prio_i, prio )
			table.remove( self._gfx_lod_data.prio_weights, prio )
			if prio <= nr_i_lod1 and #self._gfx_lod_data.prio_i > nr_i_lod1 then
				local promoted_i_entry = self._gfx_lod_data.prio_i[ prio ]
				--print( "promoting" )
				self._gfx_lod_data.entries.states[ promoted_i_entry ] = 1
				self._gfx_lod_data.entries.units[ promoted_i_entry ]:base():set_visibility_state( 1 )
			end
			--print( inspect( self._gfx_lod_data.prio_i ) )
			return
		end
	end
end

-----------------------------------------------------------------------------

function EnemyManager:_create_unit_gfx_lod_data( unit )
	local lod_entries = self._gfx_lod_data.entries
	table.insert( lod_entries.units, unit )
	table.insert( lod_entries.states, 1 )
	table.insert( lod_entries.move_ext, unit:movement() )
	table.insert( lod_entries.trackers, unit:movement():nav_tracker() )
	table.insert( lod_entries.com, unit:movement():m_com() )
end

-----------------------------------------------------------------------------

function EnemyManager:_destroy_unit_gfx_lod_data( u_key )
	local lod_entries = self._gfx_lod_data.entries
	
	for i, unit in ipairs( lod_entries.units ) do
		if u_key == unit:key() then
			if not lod_entries.states[i] then
				unit:base():set_visibility_state( 1 )
			end
			
			local nr_entries = #lod_entries.units	-- swap-erase all tables at i
			self:_remove_i_from_lod_prio( i )
			for prio, i_entry in ipairs( self._gfx_lod_data.prio_i ) do -- find and swap erase
				if i_entry == nr_entries then
					self._gfx_lod_data.prio_i[ prio ] = i
					break
				end
			end
			-- swap-erase all tables at i
			lod_entries.units[ i ] = lod_entries.units[ nr_entries ]
			table.remove( lod_entries.units )
			lod_entries.states[ i ] = lod_entries.states[ nr_entries ]
			table.remove( lod_entries.states )
			lod_entries.move_ext[ i ] = lod_entries.move_ext[ nr_entries ]
			table.remove( lod_entries.move_ext )
			lod_entries.trackers[ i ] = lod_entries.trackers[ nr_entries ]
			table.remove( lod_entries.trackers )
			lod_entries.com[ i ] = lod_entries.com[ nr_entries ]
			table.remove( lod_entries.com )
			break
		end
	end
end

-----------------------------------------------------------------------------
-- true enabled the LOD check. false instantly shows all the units and disables the LOD check
function EnemyManager:set_gfx_lod_enabled( state )
	if state then
		self._gfx_lod_data.enabled = state
	elseif self._gfx_lod_data.enabled then
		self._gfx_lod_data.enabled = state
		-- Force all units visible
		local entries = self._gfx_lod_data.entries
		local units = entries.units
		local states = entries.states
		for i, state in ipairs( states ) do
			states[i] = 1
			units[i]:base():set_visibility_state( 1 )
		end
	end
end

function EnemyManager:chk_any_unit_in_slotmask_visible( slotmask, cam_pos, cam_nav_tracker )
	--Application:set_pause( true )
	if self._gfx_lod_data.enabled and managers.navigation:is_data_ready() then
		local camera_rot = managers.viewport:get_current_camera_rotation()
		local entries = self._gfx_lod_data.entries
		local units = entries.units
		local states = entries.states
		local trackers = entries.trackers
		local move_exts = entries.move_ext
		local com = entries.com
		local chk_vis_func = cam_nav_tracker and cam_nav_tracker.check_visibility
		local unit_occluded = Unit.occluded
		local occ_skip_units = managers.occlusion._skip_occlusion
		local vis_slotmask = managers.slot:get_mask( "AI_visibility" )
		
		for i, state in ipairs( states ) do
			local unit = units[i]
			if unit:in_slot( slotmask ) then
				if occ_skip_units[ unit:key() ] or ( ( not cam_nav_tracker or chk_vis_func( cam_nav_tracker, trackers[i] ) ) and not unit_occluded( unit ) ) then
					local distance = mvec3_dir( tmp_vec1, cam_pos, com[i] )
					if distance < 300 then
						--Application:draw_line( cam_pos, com[i], 1,1,1 )
						return true
					elseif distance < 2000 then
						local u_m_head_pos = move_exts[i]:m_head_pos()
						local ray = World:raycast( "ray", cam_pos, u_m_head_pos, "slot_mask", vis_slotmask, "report" )
						if not ray then -- we are looking at the character
							--Application:draw_line( cam_pos, u_m_head_pos, 0.75,0.75,0.75 )
							return true
						else
							ray = World:raycast( "ray", cam_pos, com[i], "slot_mask", vis_slotmask, "report" )
							if not ray then
								--Application:draw_line( cam_pos, u_m_head_pos, 0.5,0.5,0.5 )
								return true
							--else
								--Application:draw_line( cam_pos, com[i], 0,0,1 )
							end
						end
					end
				--else
					--Application:draw_line( cam_pos, com[i], 0,1,0 )
				end
			--else
				--Application:draw_line( cam_pos, com[i], 1,0,0 )
			end
		end
		
	end
end
	
-----------------------------------------------------------------------------

function EnemyManager:_init_enemy_data()
	local enemy_data = {}
	local unit_data = {}
	
	self._enemy_data = enemy_data
	enemy_data.unit_data = unit_data
	enemy_data.nr_units = 0
	enemy_data.nr_active_units = 0
	enemy_data.nr_inactive_units = 0
	enemy_data.inactive_units = {}
	enemy_data.max_nr_active_units = 20
	enemy_data.corpses = {}
	enemy_data.nr_corpses = 0	-- The # of entries of the corpses table
	
	self._civilian_data = { unit_data = {} }

	self._queued_tasks = {}
	self._queued_task_executed = nil	-- This boolean flag is true when we have executed one queued task for this frame
	
	self._delayed_clbks = {}	-- indexed table of sorted callbacks from soonest to furthest execute time

	self._t = 0
	
	self._gfx_lod_data = {}
	self._gfx_lod_data.enabled = true
	self._gfx_lod_data.prio_i = {}
	self._gfx_lod_data.prio_weights = {}
	self._gfx_lod_data.next_chk_prio_i = 1
	self._gfx_lod_data.entries = {}
	local lod_entries = self._gfx_lod_data.entries
	lod_entries.units = {}
	lod_entries.states = {}
	lod_entries.move_ext = {}
	lod_entries.trackers = {}
	lod_entries.com = {}
	
	self._corpse_disposal_enabled = 0 -- > 0 means enabled. <=0 disabled
end

-----------------------------------------------------------------------------

function EnemyManager:all_enemies()
	return self._enemy_data.unit_data
end

-----------------------------------------------------------------------------

function EnemyManager:all_civilians()
	return self._civilian_data.unit_data
end

function EnemyManager:is_civilian( unit )
	return self._civilian_data.unit_data[ unit:key() ] and true or false
end

-----------------------------------------------------------------------------

function EnemyManager:queue_task( id, task_clbk, data, execute_t, verification_clbk, asap )
	local task_data = { clbk = task_clbk, id = id, data = data, t = execute_t, v_cb = verification_clbk, asap = asap }
	table.insert( self._queued_tasks, task_data )
	if not ( execute_t or #self._queued_tasks > 1 or self._queued_task_executed ) then
		self:_execute_queued_task( 1 )
	end
end

-----------------------------------------------------------------------------

function EnemyManager:unqueue_task( id )
	local tasks = self._queued_tasks
	local i = #tasks
	while i > 0 do
		if tasks[ i ].id == id then
			table.remove( tasks, i )
			return
		end
		i = i - 1
	end
	debug_pause( "[EnemyManager:unqueue_task] task", id, "was not queued!!!" )
end

-----------------------------------------------------------------------------

function EnemyManager:unqueue_task_debug( id )
	--print( "[EnemyManager:unqueue_task]", id )
	if not id then
		Application:stack_dump()
	end
	local tasks = self._queued_tasks
	local i = #tasks
	local removed
	while i > 0 do
		if tasks[ i ].id == id then
			if removed then
				debug_pause( "DOUBLE TASK AT ", i, id )
			else
				table.remove( tasks, i )
				removed = true
			end
		end
		i = i - 1
	end
	if not removed then
		debug_pause( "[EnemyManager:unqueue_task] task", id, "was not queued!!!" )
	end
end

-----------------------------------------------------------------------------

function EnemyManager:has_task( id )
	local tasks = self._queued_tasks
	local i = #tasks
	local count = 0
	while i > 0 do
		if tasks[ i ].id == id then
			count = count + 1
		end
		i = i - 1
	end
	return count > 0 and count
end

-----------------------------------------------------------------------------

function EnemyManager:_execute_queued_task( i )
	--print( "EnemyManager:_execute_queued_task", i )
	local task = table.remove( self._queued_tasks, i )
	self._queued_task_executed = true
	
	if task.data and task.data.unit and not alive( task.data.unit ) then	-- sanity check for demo
		print( "[EnemyManager:_execute_queued_task] dead unit", inspect( task ) )
		Application:stack_dump()
		--return
	end
	if task.v_cb then -- verification callback
		task.v_cb( task.id )
	end
	
	task.clbk( task.data )
end

-----------------------------------------------------------------------------

function EnemyManager:_update_queued_tasks( t )
	local i_asap_task, asp_task_t
	for i_task, task_data in ipairs( self._queued_tasks ) do
		if not task_data.t or t > task_data.t then
			self:_execute_queued_task( i_task )
			break
		elseif task_data.asap and ( not asp_task_t or asp_task_t > task_data.t ) then
			i_asap_task = i_task
			asp_task_t = task_data.t
		end
	end
	
	if i_asap_task and not self._queued_task_executed then
		self:_execute_queued_task( i_asap_task )
	end
	 
	--[[local congestion
	for i_task, task_data in ipairs( self._queued_tasks ) do
		if not task_data.t or t > task_data.t then
			congestion = ( congestion or 0 ) + 1
		end
	end
	print( "congestion", congestion )]]
	
	local all_clbks = self._delayed_clbks
	if all_clbks[1] and all_clbks[1][2] < t then
		local clbk = table.remove( all_clbks, 1 )[3] -- this copying takes place in order to allow additions/removals in the table during iteration
		clbk()
	end
end

-----------------------------------------------------------------------------

function EnemyManager:add_delayed_clbk( id, clbk, execute_t )
	if not clbk then
		debug_pause( "[EnemyManager:add_delayed_clbk] Empty callback object!!!" )
	end
	local clbk_data = { id, execute_t, clbk }
	-- the new entry is sorted and inserted 
	local all_clbks = self._delayed_clbks
	local i = #all_clbks
	while i > 0 and all_clbks[i][2] > execute_t do
		i = i - 1
	end
	table.insert( all_clbks, i + 1, clbk_data )
end

-----------------------------------------------------------------------------

function EnemyManager:remove_delayed_clbk( id )
	local all_clbks = self._delayed_clbks
	for i, clbk_data in ipairs( all_clbks ) do
		if clbk_data[1] == id then
			table.remove( all_clbks, i )
			return
		end
	end
	debug_pause( "[EnemyManager:remove_delayed_clbk] id", id, "was not scheduled!!!" )
end

-----------------------------------------------------------------------------

function EnemyManager:reschedule_delayed_clbk( id, execute_t )
	local all_clbks = self._delayed_clbks

	local clbk_data
	for i, clbk_d in ipairs( all_clbks ) do
		if clbk_d[1] == id then
			clbk_data = table.remove( all_clbks, i )
			break
		end
	end
	if clbk_data then
		clbk_data[2] = execute_t	-- new scheduled execution time
		local i = #all_clbks
		while i > 0 and all_clbks[i][2] > execute_t do
			i = i - 1
		end
		table.insert( all_clbks, i + 1, clbk_data )
		return
	end
	
	debug_pause( "[EnemyManager:reschedule_delayed_clbk] id", id, "was not scheduled!!!" )
end

-----------------------------------------------------------------------------

function EnemyManager:force_delayed_clbk( id )
	local all_clbks = self._delayed_clbks
	for i, clbk_data in ipairs( all_clbks ) do
		if clbk_data[1] == id then
			local clbk = table.remove( all_clbks, 1 )[3] -- this copying takes place in order to allow additions/removals in the table during iteration
			clbk()
			return
		end
	end
	debug_pause( "[EnemyManager:force_delayed_clbk] id", id, "was not scheduled!!!" )
end

-----------------------------------------------------------------------------

function EnemyManager:queued_tasks_by_callback()
	local t = TimerManager:game():time()
	local categorised_queued_tasks = {}
	local congestion = 0
	for i_task, task_data in ipairs( self._queued_tasks ) do
		if categorised_queued_tasks[ task_data.clbk ] then
			categorised_queued_tasks[ task_data.clbk ].amount = categorised_queued_tasks[ task_data.clbk ].amount + 1
		else
			categorised_queued_tasks[ task_data.clbk ] = { amount = 1, key = task_data.id }
		end
		if not task_data.t or t > task_data.t then
			congestion = congestion + 1
		end
	end
	print( "congestion", congestion )
	for clbk, data in pairs( categorised_queued_tasks ) do
		print( data.key, data.amount )
	end
end

-----------------------------------------------------------------------------

function EnemyManager:register_enemy( enemy )
	--print( "EnemyManager:register_enemy", enemy )
	local char_tweak = tweak_data.character[ enemy:base()._tweak_table ]
	local u_data = { 
		unit = enemy
		,m_pos = enemy:movement():m_pos()
		,tracker = enemy:movement():nav_tracker() 
		,importance = 0	-- to how many human players is this unit important
		,char_tweak = char_tweak
		,so_access = managers.navigation:convert_access_flag( char_tweak.access )
	}
	self._enemy_data.unit_data[ enemy:key() ] = u_data
	
	enemy:base():add_destroy_listener( self._unit_clbk_key, callback( self, self, "on_enemy_destroyed" ) )
	--enemy:character_damage():add_listener( self._unit_clbk_key, { "death" }, callback( self, self, "on_enemy_died" ) )
	
	self:on_enemy_registered( enemy )
	
end

-----------------------------------------------------------------------------

function EnemyManager:on_enemy_died( dead_unit, damage_info )
	--print( "EnemyManager:on_enemy_died", dead_unit )
	local u_key = dead_unit:key()
	
	local enemy_data = self._enemy_data
	local u_data = enemy_data.unit_data[ u_key ]
	self:on_enemy_unregistered( dead_unit )
	
	enemy_data.unit_data[ u_key ] = nil
	
	--dead_unit:base():remove_destroy_listener( self._unit_clbk_key )
	--dead_unit:character_damage():remove_listener( self._unit_clbk_key )
	
	if enemy_data.nr_corpses == 0 and self:is_corpse_disposal_enabled() then
		self:queue_task( "EnemyManager._upd_corpse_disposal", EnemyManager._upd_corpse_disposal, self, self._t + self._corpse_disposal_upd_interval )
	end
	enemy_data.nr_corpses = enemy_data.nr_corpses + 1
	enemy_data.corpses[ u_key ] = u_data
	u_data.death_t = self._t
	
	self:_destroy_unit_gfx_lod_data( u_key )
	--print( "detaching", dead_unit:key() )
	
	u_data.u_id = dead_unit:id()
	Network:detach_unit( dead_unit ) -- This allows us to remove the unit localy while it still appears on other clients
		
end

-----------------------------------------------------------------------------

function EnemyManager:on_enemy_destroyed( enemy )
	--print( "EnemyManager:on_enemy_destroyed", enemy )
	local u_key = enemy:key()
	
	local enemy_data = self._enemy_data
	if enemy_data.unit_data[ u_key ] then
		self:on_enemy_unregistered( enemy )
		enemy_data.unit_data[ u_key ] = nil
		self:_destroy_unit_gfx_lod_data( u_key )
	elseif enemy_data.corpses[ u_key ] then
		enemy_data.nr_corpses = enemy_data.nr_corpses - 1
		enemy_data.corpses[ u_key ] = nil
		if enemy_data.nr_corpses == 0 and self:is_corpse_disposal_enabled() then
			self:unqueue_task( "EnemyManager._upd_corpse_disposal" )
		end
	end
	
end

-----------------------------------------------------------------------------

function EnemyManager:on_enemy_registered( unit )
	self._enemy_data.nr_units = self._enemy_data.nr_units + 1
	self:_create_unit_gfx_lod_data( unit, true )
	managers.groupai:state():on_enemy_registered( unit )
end

-----------------------------------------------------------------------------
-- An enemy is out of the game. Possibly killed or removed
function EnemyManager:on_enemy_unregistered( unit )
	self._enemy_data.nr_units = self._enemy_data.nr_units - 1
	managers.groupai:state():on_enemy_unregistered( unit )
end

-----------------------------------------------------------------------------

function EnemyManager:register_civilian( unit )
	unit:base():add_destroy_listener( self._unit_clbk_key, callback( self, self, "on_civilian_destroyed" ) )
	--unit:character_damage():add_listener( self._unit_clbk_key, { "death" }, callback( self, self, "on_civilian_died" ) )
	self:_create_unit_gfx_lod_data( unit, true )
	
	local char_tweak = tweak_data.character[ unit:base()._tweak_table ]
	self._civilian_data.unit_data[ unit:key() ] = { 
		unit = unit,
		m_pos = unit:movement():m_pos(),
		tracker = unit:movement():nav_tracker(),
		char_tweak = char_tweak,
		so_access = managers.navigation:convert_access_flag( char_tweak.access ),
		is_civilian = true
	}
	
end

-----------------------------------------------------------------------------

function EnemyManager:on_civilian_died( dead_unit, damage_info )
	--print( "EnemyManager:on_civilian_died", dead_unit )
	local u_key = dead_unit:key()
	
	managers.groupai:state():on_civilian_unregistered( dead_unit )
	if Network:is_server() and damage_info.attacker_unit and not dead_unit:base().enemy then
		managers.groupai:state():hostage_killed( damage_info.attacker_unit )
	end
	
	
	local u_data = self._civilian_data.unit_data[ u_key ]
	--dead_unit:base():remove_destroy_listener( self._unit_clbk_key )
	--dead_unit:character_damage():remove_listener( self._unit_clbk_key )
		
	local enemy_data = self._enemy_data
	if enemy_data.nr_corpses == 0 and self:is_corpse_disposal_enabled() then
		self:queue_task( "EnemyManager._upd_corpse_disposal", EnemyManager._upd_corpse_disposal, self, self._t + self._corpse_disposal_upd_interval )
	end
	enemy_data.nr_corpses = enemy_data.nr_corpses + 1
	enemy_data.corpses[ u_key ] = u_data
	u_data.death_t = TimerManager:game():time()
	
	self._civilian_data.unit_data[ u_key ] = nil
	
	self:_destroy_unit_gfx_lod_data( u_key )
	u_data.u_id = dead_unit:id()
	
	Network:detach_unit( dead_unit ) -- This allows us to remove the unit locally while it still appears on other clients
end

-----------------------------------------------------------------------------

function EnemyManager:on_civilian_destroyed( enemy )
	--print( "EnemyManager:on_civilian_destroyed", enemy )
	local u_key = enemy:key()
	local enemy_data = self._enemy_data
	if enemy_data.corpses[ u_key ] then
		enemy_data.nr_corpses = enemy_data.nr_corpses - 1
		enemy_data.corpses[ u_key ] = nil
		if enemy_data.nr_corpses == 0 and self:is_corpse_disposal_enabled() then
			self:unqueue_task( "EnemyManager._upd_corpse_disposal" )
		end
	else
		managers.groupai:state():on_civilian_unregistered( enemy )
		self._civilian_data.unit_data[ u_key ] = nil
		self:_destroy_unit_gfx_lod_data( u_key )
	end
end

-----------------------------------------------------------------------------

function EnemyManager:on_criminal_registered( unit )
	self:_create_unit_gfx_lod_data( unit, false )
end

-----------------------------------------------------------------------------

function EnemyManager:on_criminal_unregistered( u_key )
	self:_destroy_unit_gfx_lod_data( u_key )
end

-----------------------------------------------------------------------------------

function EnemyManager:_upd_corpse_disposal()
	local t = TimerManager:game():time()	
	local enemy_data = self._enemy_data
	local nr_corpses = enemy_data.nr_corpses
	local disposals_needed = nr_corpses - self._MAX_NR_CORPSES
	local corpses = enemy_data.corpses
	local nav_mngr = managers.navigation
	
	local player = managers.player:player_unit()
	local pl_tracker, cam_pos, cam_fwd
	if player then
		pl_tracker = player:movement():nav_tracker()
		cam_pos = player:movement():m_head_pos()
		cam_fwd = player:camera():forward()
	elseif managers.viewport:get_current_camera() then
		cam_pos = managers.viewport:get_current_camera_position()
		cam_fwd = managers.viewport:get_current_camera_rotation():y()
	end
	
	local to_dispose = {}
	local nr_found = 0
	
	if pl_tracker then
		for u_key, u_data in pairs( corpses ) do
			local u_tracker = u_data.tracker
			if u_tracker and not pl_tracker:check_visibility( u_tracker ) then
				to_dispose[ u_key ] = true
				nr_found = nr_found + 1
			end
		end
	end
	
	if #to_dispose < disposals_needed then
		if cam_pos then
			for u_key, u_data in pairs( corpses ) do
				local u_pos = u_data.m_pos
				if not to_dispose[ u_key ] and mvec3_dis( cam_pos, u_pos ) > 300 and mvector3.dot( cam_fwd, u_pos - cam_pos ) < 0 then
					to_dispose[ u_key ] = true
					nr_found = nr_found + 1
					if nr_found == disposals_needed then
						break
					end
				end
			end
		end
		
		if nr_found < disposals_needed then
			local oldest_u_key
			local oldest_t
			for u_key, u_data in pairs( corpses ) do
				if ( not oldest_t or oldest_t > u_data.death_t ) and not to_dispose[ u_key ] then
					oldest_u_key = u_key
					oldest_t = u_data.death_t
				end
			end
			if oldest_u_key then
				to_dispose[ oldest_u_key ] = true
				nr_found = nr_found + 1
			end
		end
		
	end
	
	for u_key, _  in pairs( to_dispose ) do
		local u_data = corpses[ u_key ]
		if alive( u_data.unit ) then
			u_data.unit:base():set_slot( u_data.unit, 0 )
		end
		corpses[ u_key ] = nil
	end
		
	enemy_data.nr_corpses = nr_corpses - nr_found
	--print( "nr_corpses after_2 ", enemy_data.nr_corpses )
	
	if nr_corpses > 0 then
		local delay = enemy_data.nr_corpses > self._MAX_NR_CORPSES and 0 or self._corpse_disposal_upd_interval
		self:queue_task( "EnemyManager._upd_corpse_disposal", EnemyManager._upd_corpse_disposal, self, t + delay )
	end
end

-----------------------------------------------------------------------------------

function EnemyManager:set_corpse_disposal_enabled( state )
	local was_enabled = self._corpse_disposal_enabled > 0
	
	self._corpse_disposal_enabled = self._corpse_disposal_enabled + ( state and 1 or 0 )
	
	if was_enabled and self._corpse_disposal_enabled < 0 then
		self:unqueue_task( "EnemyManager._upd_corpse_disposal" )
	elseif not was_enabled and self._corpse_disposal_enabled > 0 and self._enemy_data.nr_corpses > 0 then
		self:queue_task( "EnemyManager._upd_corpse_disposal", EnemyManager._upd_corpse_disposal, self, TimerManager:game():time() + self._corpse_disposal_upd_interval )
	end
end

-----------------------------------------------------------------------------------

function EnemyManager:is_corpse_disposal_enabled()
	return self._corpse_disposal_enabled > 0 and true
end

-----------------------------------------------------------------------------------

function EnemyManager:on_simulation_ended()
	--self:_init_enemy_data()
end

-----------------------------------------------------------------------------------

function EnemyManager:dispose_all_corpses()
	repeat
		local u_key, corpse_data = next( self._enemy_data.corpses )
		if u_key then
			World:delete_unit( corpse_data.unit )
		else
			break
		end
	until true
end

-----------------------------------------------------------------------------------

function EnemyManager:save( data )
	local my_data
	
	if not managers.groupai:state():enemy_weapons_hot() then
		my_data = my_data or {}
		
		for u_key, u_data in pairs( self._enemy_data.corpses ) do
			my_data.corpses = my_data.corpses or {}
			local corpse_data = {
				u_data.unit:movement():m_pos(),
				u_data.is_civilian and true or false,
				u_data.unit:interaction():active() and true or false,
				u_data.unit:interaction().tweak_data,
				u_data.u_id
			}
			table.insert( my_data.corpses, corpse_data )
		end
	end
	
	data.enemy_manager = my_data
end

-----------------------------------------------------------------------------------

function EnemyManager:load( data )
	local my_data = data.enemy_manager
	if not my_data then
		return
	end
	
	if my_data.corpses then
		local civ_spawn_state = Idstring( "civilian_death_dummy" )
		local ene_spawn_state = Idstring( "enemy_death_dummy" )
		local civ_corpse_u_name = Idstring( "units/payday2/characters/civ_male_dummy_corpse/civ_male_dummy_corpse" )
		local ene_corpse_u_name = Idstring( "units/payday2/characters/ene_dummy_corpse/ene_dummy_corpse" )
		for _, corpse_data in pairs( my_data.corpses ) do
			local corpse = World:spawn_unit( corpse_data[2] and civ_corpse_u_name or ene_corpse_u_name, corpse_data[1], Rotation( math.random() * 360, 0, 0 ) )
			if corpse then
				corpse:play_state( corpse_data[2] and civ_spawn_state or ene_spawn_state )
				corpse:interaction():set_tweak_data( corpse_data[4] )
				corpse:interaction():set_active( corpse_data[3] )
				
				corpse:base():add_destroy_listener( "EnemyManager_corpse_dummy"..tostring( corpse:key()), callback( self, self, corpse_data[2] and "on_civilian_destroyed" or "on_enemy_destroyed" ) )
				self._enemy_data.corpses[ corpse:key() ] = { death_t = 0, unit = corpse, u_id = corpse_data[5], m_pos = corpse:position() }
				self._enemy_data.nr_corpses = self._enemy_data.nr_corpses + 1
			end
		end
	end
end

-----------------------------------------------------------------------------------

function EnemyManager:get_corpse_unit_data_from_key( u_key )
	return self._enemy_data.corpses[ u_key ]
end

-----------------------------------------------------------------------------------

function EnemyManager:get_corpse_unit_data_from_id( u_id )
	for u_key, u_data in pairs( self._enemy_data.corpses ) do
		if u_id == u_data.u_id then
			return u_data
		end
	end
end

-----------------------------------------------------------------------------------

function EnemyManager:remove_corpse_by_id( u_id )
	for u_key, u_data in pairs( self._enemy_data.corpses ) do
		if u_id == u_data.u_id then
			u_data.unit:set_slot( 0 )
			break
		end
	end
end

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------