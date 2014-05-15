require("lib/managers/NavFieldBuilder")
local mvec3_n_equal = mvector3.not_equal
local mvec3_set = mvector3.set
local mvec3_set_st = mvector3.set_static
local mvec3_set_z = mvector3.set_z
local mvec3_sub = mvector3.subtract
local mvec3_norm = mvector3.normalize
local mvec3_dir = mvector3.direction
local mvec3_add = mvector3.add
local mvec3_mul = mvector3.multiply
local mvec3_div = mvector3.divide
local mvec3_lerp = mvector3.lerp
local mvec3_cpy = mvector3.copy
local mvec3_set_l = mvector3.set_length
local mvec3_dot = mvector3.dot
local mvec3_cross = mvector3.cross
local mvec3_dis = mvector3.distance
local mvec3_rot = mvector3.rotate_with
local math_abs = math.abs
local math_max = math.max
local math_clamp = math.clamp
local math_ceil = math.ceil
local math_floor = math.floor
local temp_vec1 = Vector3()
local temp_vec2 = Vector3()
NavigationManager = NavigationManager or class()
NavigationManager.nav_states = {
	"allow_access",
	"forbid_access"
}
NavigationManager.COVER_RESERVED = 4
NavigationManager.COVER_RESERVATION = 5
NavigationManager.ACCESS_FLAGS_VERSION = 1
NavigationManager.ACCESS_FLAGS = {
	"civ_male",
	"civ_female",
	"gangster",
	"security",
	"security_patrol",
	"cop",
	"fbi",
	"swat",
	"murky",
	"sniper",
	"spooc",
	"shield",
	"tank",
	"taser",
	"teamAI1",
	"teamAI2",
	"teamAI3",
	"teamAI4",
	"SO_ID1",
	"SO_ID2",
	"SO_ID3",
	"pistol",
	"rifle",
	"ntl",
	"hos",
	"run",
	"fumble",
	"sprint",
	"crawl",
	"climb"
}
NavigationManager.ACCESS_FLAGS_OLD = {}
function NavigationManager:init()
	self._debug = SystemInfo:platform() == Idstring("WIN32") and Application:production_build()
	self._builder = NavFieldBuilder:new()
	self._get_room_height_at_pos = self._builder._get_room_height_at_pos
	self._check_room_overlap_bool = self._builder._check_room_overlap_bool
	self._door_access_types = self._builder._door_access_types
	self._opposite_side_str = self._builder._opposite_side_str
	self._perp_pos_dir_str_map = self._builder._perp_pos_dir_str_map
	self._perp_neg_dir_str_map = self._builder._perp_neg_dir_str_map
	self._dim_str_map = self._builder._dim_str_map
	self._perp_dim_str_map = self._builder._perp_dim_str_map
	self._neg_dir_str_map = self._builder._neg_dir_str_map
	self._x_dir_str_map = self._builder._x_dir_str_map
	self._dir_str_to_vec = self._builder._dir_str_to_vec
	self._geog_segment_size = self._builder._geog_segment_size
	self._grid_size = self._builder._grid_size
	self._rooms = {}
	self._room_doors = {}
	self._geog_segments = {}
	self._nr_geog_segments = nil
	self._visibility_groups = {}
	self._nav_segments = {}
	self._draw_enabled = false
	self._coarse_searches = {}
	self._covers = {}
	self._next_pos_rsrv_expiry = false
	if self._debug then
		self._nav_links = {}
	end

	self._quad_field = World:quad_field()
	self._quad_field:set_nav_link_filter(NavigationManager.ACCESS_FLAGS)
	self._pos_rsrv_filters = {}
	self._obstacles = {}
	if self._debug then
		self._pos_reservations = {}
	end

end

function NavigationManager:_init_draw_data()
	local data = {}
	local duration = 10
	data.duration = duration
	local brush = {}
	brush.door = Draw:brush(Color(0.1, 0, 1, 1), duration)
	brush.room_diag = Draw:brush(Color(1, 0.5, 0.5, 0), duration)
	brush.room_diag_disabled = Draw:brush(Color(0.5, 0.7, 0, 0), duration)
	brush.room_diag_obstructed = Draw:brush(Color(0.5, 0.5, 0, 0.5), duration)
	brush.room_border = Draw:brush(Color(1, 0.5, 0.5, 0.5), duration)
	brush.coarse_graph = Draw:brush(Color(0.2, 0.05, 0.2, 0.9))
	brush.vis_graph_rooms = Draw:brush(Color(0.6, 0.5, 0.2, 0.9), duration)
	brush.vis_graph_node = Draw:brush(Color(1, 0.6, 0, 0.9), duration)
	brush.vis_graph_links = Draw:brush(Color(0.2, 0.8, 0.1, 0.6), duration)
	data.brush = brush
	local offsets = {
		Vector3(-1, -1),
		Vector3(-1, 1),
		Vector3(1, -1),
		Vector3(1, 1)
	}
	data.offsets = offsets
	data.next_draw_i_room = 1
	data.next_draw_i_door = 1
	data.next_draw_i_coarse = 1
	data.next_draw_i_vis = 1
	self._draw_data = data
end

function NavigationManager:update(t, dt)
	if self._debug then
		self._builder:update(t, dt)
		if self._draw_enabled then
			local options = self._draw_enabled
			local data = self._draw_data
			local progress = math.clamp((t - data.start_t) / (data.duration * 0.5), 0, 1)
			if options.quads then
				self:_draw_rooms(progress)
			end

			if options.doors then
				self:_draw_doors(progress)
			end

			if options.blockers then
				self:_draw_nav_blockers()
			end

			if options.vis_graph then
				self:_draw_visibility_groups(progress)
			end

			if options.coarse_graph then
				self:_draw_coarse_graph()
			end

			if options.nav_links then
				self:_draw_anim_nav_links()
			end

			if options.covers then
				self:_draw_covers()
			end

			if options.pos_rsrv then
				self:_draw_pos_reservations(t)
			end

			if progress == 1 then
				self._draw_data.start_t = t
			end

		end

	end

	self:_commence_coarce_searches(t)
end

function NavigationManager:_draw_pos_reservations(t)
	local to_remove = {}
	do
		local (for generator), (for state), (for control) = pairs(self._pos_reservations)
		do
			do break end
			local entry = res[1]
			if entry.expire_t and t > entry.expire_t then
				table.insert(to_remove, key)
			end

			if not entry.expire_t then
				Application:draw_sphere(entry.position, entry.radius, 0, 0, 0)
				if res.unit then
					if alive(res.unit) then
						Application:draw_cylinder(entry.position, res.unit:movement():m_pos(), 3, 0, 0, 0)
					else
						Application:error("[NavigationManager:_draw_pos_reservations] dead unit. reserved from:", res.stack, "unit name:", res.u_name)
						Application:draw_sphere(entry.position, entry.radius + 5, 1, 0, 1)
						Application:set_pause(true)
					end

				end

			else
				Application:draw_sphere(entry.position, entry.radius, 0.3, 0.3, 0.3)
			end

		end

	end

	(for control) = nil and res[1]
	local (for generator), (for state), (for control) = ipairs(to_remove)
	do
		do break end
		self._pos_reservations[key] = nil
	end

end

function NavigationManager:get_save_data()
-- fail 10
null
4
-- fail 18
null
4
-- fail 54
null
4
	local save_data = {}
	if not self._builder._building then
		do
			local (for generator), (for state), (for control) = ipairs(self._rooms)
			do
				do break end
				room.covers = nil
				room.nav_links = nil
			end

		end

		do
			local (for generator), (for state), (for control) = pairs(self._nav_segments)
			do
				do break end
				nav_seg.disabled = nil
				if nav_seg.neighbours then
					local (for generator), (for state), (for control) = pairs(nav_seg.neighbours)
					do
						do break end
						local (for generator), (for state), (for control) = ipairs(door_list)
						do
							do break end
							if type(door_id) == "table" then
								door_list[i_door] = nil
								if not next(door_list) then
									nav_seg.neighbours[other_nav_seg] = nil
								end

						end

						else
						end

					end

					(for control) = nil and type
				end

			end

			(for control) = nil and ipairs
		end

		do
			local (for generator), (for state), (for control) = ipairs(self._geog_segments)
			do
				do break end
				g_seg.rsrv_pos = nil
			end

		end

		local grid_size = self._grid_size
		save_data.room_borders_x_pos = {}
		save_data.room_borders_x_neg = {}
		save_data.room_borders_y_pos = {}
		save_data.room_borders_y_neg = {}
		save_data.room_heights_xp_yp = {}
		save_data.room_heights_xp_yn = {}
		save_data.room_heights_xn_yp = {}
		save_data.room_heights_xn_yn = {}
		save_data.room_vis_groups = {}
		local t_ins = table.insert
		do
			local (for generator), (for state), (for control) = ipairs(self._rooms)
			do
				do break end
				t_ins(save_data.room_borders_x_pos, room.borders.x_pos / grid_size)
				t_ins(save_data.room_borders_x_neg, room.borders.x_neg / grid_size)
				t_ins(save_data.room_borders_y_pos, room.borders.y_pos / grid_size)
				t_ins(save_data.room_borders_y_neg, room.borders.y_neg / grid_size)
				t_ins(save_data.room_heights_xp_yp, room.height.xp_yp)
				t_ins(save_data.room_heights_xp_yn, room.height.xp_yn)
				t_ins(save_data.room_heights_xn_yp, room.height.xn_yp)
				t_ins(save_data.room_heights_xn_yn, room.height.xn_yn)
				t_ins(save_data.room_vis_groups, room.vis_group)
			end

		end

		save_data.door_low_pos = pairs(nav_seg.neighbours) and {}
		save_data.door_high_pos = {}
		save_data.door_low_rooms = {}
		save_data.door_high_rooms = {}
		do
			local (for generator), (for state), (for control) = ipairs(self._room_doors)
			do
				do break end
				t_ins(save_data.door_low_pos, Vector3(door.pos.x / grid_size, door.pos.y / grid_size, door.pos.z))
				t_ins(save_data.door_high_pos, Vector3(door.pos1.x / grid_size, door.pos1.y / grid_size, door.pos1.z))
				t_ins(save_data.door_low_rooms, door.rooms[1])
				t_ins(save_data.door_high_rooms, door.rooms[2])
			end

		end

		save_data.vis_groups = pairs(nav_seg.neighbours) and self._visibility_groups
		save_data.nav_segments = self._nav_segments
		save_data.helper_blockers = self._builder._helper_blockers
		save_data.version = NavFieldBuilder._VERSION
	end

	return ScriptSerializer:to_generic_xml(save_data)
end

function NavigationManager:set_load_data(data)
	if data.version == NavFieldBuilder._VERSION then
		local t_ins = table.insert
		if Application:editor() then
			self._load_data = deep_clone(data)
		end

		local grid_size = self._grid_size
		local allow_debug_info = self._debug
		self._rooms = {}
		local nr_rooms = #data.room_borders_x_pos
		local i_room = 1
		while nr_rooms >= i_room do
			local room = {
				borders = {
					x_pos = data.room_borders_x_pos[i_room] * grid_size,
					x_neg = data.room_borders_x_neg[i_room] * grid_size,
					y_pos = data.room_borders_y_pos[i_room] * grid_size,
					y_neg = data.room_borders_y_neg[i_room] * grid_size
				},
				height = {
					xp_yp = data.room_heights_xp_yp[i_room],
					xp_yn = data.room_heights_xp_yn[i_room],
					xn_yp = data.room_heights_xn_yp[i_room],
					xn_yn = data.room_heights_xn_yn[i_room]
				},
				vis_group = data.room_vis_groups[i_room]
			}
			if allow_debug_info then
				room.doors = {
					x_pos = {},
					x_neg = {},
					y_pos = {},
					y_neg = {}
				}
			end

			t_ins(self._rooms, room)
			i_room = i_room + 1
		end

		Application:check_termination()
		local mvec3_set_x = mvector3.set_x
		local mvec3_set_y = mvector3.set_y
		self._room_doors = {}
		local nr_doors = #data.door_low_rooms
		local i_door = 1
		while nr_doors >= i_door do
			local door = {
				pos = data.door_low_pos[i_door],
				pos1 = data.door_high_pos[i_door],
				rooms = {
					data.door_low_rooms[i_door],
					data.door_high_rooms[i_door]
				}
			}
			mvec3_set_x(door.pos, door.pos.x * grid_size)
			mvec3_set_y(door.pos, door.pos.y * grid_size)
			mvec3_set_x(door.pos1, door.pos1.x * grid_size)
			mvec3_set_y(door.pos1, door.pos1.y * grid_size)
			t_ins(self._room_doors, door)
			if allow_debug_info then
				local door_dimention = door.pos.y == door.pos1.y and "x" or "y"
				t_ins(self._rooms[door.rooms[1]].doors[door_dimention .. "_pos"], i_door)
				t_ins(self._rooms[door.rooms[2]].doors[door_dimention .. "_neg"], i_door)
			end

			i_door = i_door + 1
		end

		Application:check_termination()
		if data.vis_groups and next(data.vis_groups) then
			self:_reconstruct_geographic_segments()
		end

		self._nav_segments = data.nav_segments
		do
			local (for generator), (for state), (for control) = pairs(self._nav_segments)
			do
				do break end
				local new_neighbours_list = {}
				do
					local (for generator), (for state), (for control) = pairs(nav_seg.neighbours)
					do
						do break end
						new_neighbours_list[other_nav_seg_id] = clone(door_list)
					end

				end

				nav_seg.neighbours = new_neighbours_list
			end

			(for control) = nil and clone
		end

		self._visibility_groups = self._rooms[door.rooms[2]].doors[door_dimention .. "_neg"] and data.vis_groups
		if allow_debug_info then
			local helper_blockers = data.helper_blockers
			local builder_data = {
				_rooms = self._rooms,
				_room_doors = self._room_doors,
				_geog_segments = self._geog_segments,
				_geog_segment_offset = self._geog_segment_offset,
				_nr_geog_segments = self._nr_geog_segments,
				_visibility_groups = self._visibility_groups,
				_helper_blockers = helper_blockers,
				_nav_segments = self._nav_segments
			}
			self._builder:set_field_data(builder_data)
		end

		Application:check_termination()
		if self:is_data_ready() then
			self:send_nav_field_to_engine()
			if allow_debug_info then
				self:_complete_nav_field_for_debug()
				self:set_debug_draw_state(nil)
			else
				self:_strip_nav_field_for_gameplay()
			end

		end

	else
		Application:error("! Error in NavigationManager:set_load_data( data ). The NavField in this level needs to be re-built using the latest version of the NavFieldBuilder.")
	end

end

function NavigationManager:_reconstruct_geographic_segments()
	local tab_ins = table.insert
	local m_ceil = math.ceil
	local segments = {}
	self._geog_segments = segments
	local seg_size = self._geog_segment_size
	local level_limit_x_pos = -1000000
	local level_limit_x_neg = 1000000
	local level_limit_y_pos = -1000000
	local level_limit_y_neg = 1000000
	do
		local (for generator), (for state), (for control) = ipairs(self._rooms)
		do
			do break end
			local borders = room.borders
			if level_limit_x_pos < borders.x_pos then
				level_limit_x_pos = borders.x_pos
			end

			if level_limit_x_neg > borders.x_neg then
				level_limit_x_neg = borders.x_neg
			end

			if level_limit_y_pos < borders.y_pos then
				level_limit_y_pos = borders.y_pos
			end

			if level_limit_y_neg > borders.y_neg then
				level_limit_y_neg = borders.y_neg
			end

		end

	end

	local safety_margin = 0
	level_limit_x_pos = nil and level_limit_x_pos + safety_margin
	level_limit_x_neg = level_limit_x_neg - safety_margin
	level_limit_y_pos = level_limit_y_pos + safety_margin
	level_limit_y_neg = level_limit_y_neg - safety_margin
	self._geog_segment_offset = Vector3(level_limit_x_neg, level_limit_y_neg, 2000)
	local seg_offset = self._geog_segment_offset
	local nr_seg_x = m_ceil((level_limit_x_pos - level_limit_x_neg) / seg_size)
	local nr_seg_y = m_ceil((level_limit_y_pos - level_limit_y_neg) / seg_size)
	self._nr_geog_segments = {x = nr_seg_x, y = nr_seg_y}
	local i_seg = 1
	while i_seg <= nr_seg_x * nr_seg_y do
		local segment = {}
		local seg_borders = self:_calculate_geographic_segment_borders(i_seg)
		local nr_rooms = 0
		do
			local (for generator), (for state), (for control) = ipairs(self._rooms)
			do
				do break end
				local room_borders = room.borders
				if NavFieldBuilder._check_room_overlap_bool(seg_borders, room_borders) then
					segment.rooms = segment.rooms or {}
					segment.rooms[i_room] = true
					nr_rooms = nr_rooms + 1
				end

			end

		end

		(for control) = nil and room.borders
		if next(segment) then
			segments[i_seg] = segment
		end

		i_seg = i_seg + 1
	end

	i_seg = nr_seg_x * nr_seg_y
	while i_seg > 0 do
		if segments[i_seg] == false then
			segments[i_seg] = nil
		end

		i_seg = i_seg - 1
	end

end

function NavigationManager:_calculate_geographic_segment_borders(i_seg)
	local seg_borders = {}
	local nr_seg_x = self._nr_geog_segments.x
	local seg_offset = self._geog_segment_offset
	local seg_size = self._geog_segment_size
	local grid_coorids = {
		1 + (i_seg - 1) % nr_seg_x,
		math.ceil(i_seg / nr_seg_x)
	}
	seg_borders.x_pos = seg_offset.x + grid_coorids[1] * seg_size
	seg_borders.x_neg = seg_borders.x_pos - seg_size
	seg_borders.y_pos = seg_offset.y + grid_coorids[2] * seg_size
	seg_borders.y_neg = seg_borders.y_pos - seg_size
	return seg_borders
end

function NavigationManager:clear()
	self._builder:clear()
	self:_clear()
end

function NavigationManager:_clear()
	self:_unregister_cover_units()
	self._rooms = {}
	self._room_doors = {}
	self._geog_segments = {}
	self._nr_geog_segments = nil
	self._visibility_groups = {}
	self._nav_segments = {}
	self._debug_geographic_segments = {}
	self._debug_vis_groups = {}
	self._coarse_searches = {}
end

function NavigationManager:is_data_ready()
	return self._nr_geog_segments and true or false
end

function NavigationManager:build_nav_segments(build_settings, complete_clbk)
	local draw_options = self._draw_enabled
	self:_clear()
	self:set_debug_draw_state(false)
	self._build_complete_clbk = complete_clbk
	self._builder:build_nav_segments(build_settings, callback(self, self, "build_complete_clbk", draw_options))
end

function NavigationManager:build_complete_clbk(draw_options)
	self:_refresh_data_from_builder()
	if self:is_data_ready() then
		self:send_nav_field_to_engine()
	end

	self:set_debug_draw_state(draw_options)
	if self:is_data_ready() then
		self._load_data = self:get_save_data()
	end

	if self._build_complete_clbk then
		self._build_complete_clbk()
	end

end

function NavigationManager:_refresh_data_from_builder()
	self._rooms = self._builder._rooms
	self._room_doors = self._builder._room_doors
	self._geog_segments = self._builder._geog_segments
	self._geog_segment_offset = self._builder._geog_segment_offset
	self._nr_geog_segments = self._builder._nr_geog_segments
	self._visibility_groups = self._builder._visibility_groups
	self._nav_segments = self._builder._nav_segments
end

function NavigationManager:set_nav_segment_state(id, state)
	if not self._nav_segments[id] then
		debug_pause("[NavigationManager:set_nav_segment_state] inexistent nav_segment", id)
		return
	end

	local wanted_state = state == "allow_access" and true or false
	local cur_state = self._quad_field:is_nav_segment_enabled(id)
	local seg_disabled_state
	if not wanted_state then
		seg_disabled_state = true
	end

	self._nav_segments[id].disabled = seg_disabled_state
	if wanted_state ~= cur_state then
		self._quad_field:set_nav_segment_enabled(id, wanted_state)
		managers.groupai:state():on_nav_segment_state_change(id, wanted_state)
	end

end

function NavigationManager:delete_nav_segment(id)
	local draw_options = self._draw_enabled
	self:set_debug_draw_state(false)
	self._builder:delete_segment(id)
	self:_refresh_data_from_builder()
	self:set_debug_draw_state(draw_options)
end

function NavigationManager:build_visibility_graph(complete_clbk, all_visible, neg_filter, pos_filter, ray_dis)
	if not next(self._nav_segments) then
		Application:error("[NavigationManager:build_visibility_graph] ground needs to be built before visibilty graph")
		return
	end

	local draw_options = self._draw_enabled
	self:set_debug_draw_state(false)
	self._build_complete_clbk = complete_clbk
	self._builder:build_visibility_graph(callback(self, self, "build_complete_clbk", draw_options), all_visible, ray_dis, pos_filter, neg_filter)
end

function NavigationManager:set_debug_draw_state(options)
	if options and not self._draw_enabled then
		self:_init_draw_data()
		self._draw_data.start_t = TimerManager:game():time()
	end

	self._draw_enabled = options
end

function NavigationManager:set_selected_segment(unit)
	self._selected_segment = unit and unit:unit_data().unit_id
end

function NavigationManager:_draw_rooms(progress)
-- fail 31
null
12
	local selected_seg = self._selected_segment
	local room_mask
	if selected_seg and self._nav_segments[selected_seg] and next(self._nav_segments[selected_seg].vis_groups) then
		room_mask = {}
		local (for generator), (for state), (for control) = ipairs(self._nav_segments[selected_seg].vis_groups)
		do
			do break end
			local vis_group_rooms = self._visibility_groups[i_vis_group].rooms
			local (for generator), (for state), (for control) = pairs(vis_group_rooms)
			do
				do break end
				room_mask[i_room] = true
			end

		end

	end

	local data = self._draw_data
	local rooms = nil and self._rooms
	local nr_rooms = #rooms
	local i_room = data.next_draw_i_room
	local wanted_index = math.clamp(math.ceil(nr_rooms * progress), 1, nr_rooms)
	while i_room <= wanted_index and nr_rooms >= i_room do
		local room = rooms[i_room]
		if not room_mask or room_mask[i_room] then
			self:_draw_room(room)
		end

		i_room = i_room + 1
	end

	if progress == 1 then
		data.next_draw_i_room = 1
	else
		data.next_draw_i_room = i_room
	end

end

function NavigationManager:_draw_nav_blockers()
	if self._builder._helper_blockers then
		local mvec3_set = mvector3.set
		local mvec3_rot = mvector3.rotate_with
		local mvec3_add = mvector3.add
		local obj_name = Idstring("help_blocker")
		local nav_segments = self._builder._nav_segments
		local registered_blockers = self._builder._helper_blockers
		local all_blockers = World:find_units_quick("all", 15)
		local (for generator), (for state), (for control) = ipairs(all_blockers)
		do
			do break end
			local id = blocker_unit:unit_data().unit_id
			if registered_blockers[id] then
				local draw_pos = blocker_unit:get_object(obj_name):position()
				local nav_segment = registered_blockers[id]
				if nav_segments and nav_segments[nav_segment] and self._selected_segment == nav_segment then
					Application:draw_sphere(draw_pos, 30, 0, 0, 1)
					Application:draw_cylinder(draw_pos, nav_segments[nav_segment].pos, 2, 0, 0.3, 0.6)
				end

			end

		end

	end

end

function NavigationManager:_draw_room(room, instant)
	local draw, brushes, offsets
	if instant then
		offsets = {
			Vector3(-1, -1),
			Vector3(-1, 1),
			Vector3(1, -1),
			Vector3(1, 1)
		}
	else
		draw = self._draw_data
		brushes = draw and draw.brush
		offsets = draw and draw.offsets
	end

	local dir_vec_map = self._dir_str_to_vec
	local borders = room.borders
	local height = room.height
	local my_center = self._builder:_calculate_room_center(room)
	local xp_yp_draw = Vector3(borders.x_pos + offsets[1].x, borders.y_pos + offsets[1].y, height.xp_yp)
	local xp_yn_draw = Vector3(borders.x_pos + offsets[2].x, borders.y_neg + offsets[2].y, height.xp_yn)
	local xn_yp_draw = Vector3(borders.x_neg + offsets[3].x, borders.y_pos + offsets[3].y, height.xn_yp)
	local xn_yn_draw = Vector3(borders.x_neg + offsets[4].x, borders.y_neg + offsets[4].y, height.xn_yn)
	if instant then
		Application:draw_line(xp_yp_draw, xp_yn_draw, 0.5, 0.5, 0.5)
		Application:draw_line(xn_yp_draw, xn_yn_draw, 0.5, 0.5, 0.5)
		Application:draw_line(xp_yp_draw, xn_yp_draw, 0.5, 0.5, 0.5)
		Application:draw_line(xp_yn_draw, xn_yn_draw, 0.5, 0.5, 0.5)
		Application:draw_line(xp_yp_draw, xn_yn_draw, 0.5, 0.5, 0)
		Application:draw_line(xn_yp_draw, xp_yn_draw, 0.5, 0.5, 0)
	else
		local brush = brushes.room_border
		brush:line(xp_yp_draw, xp_yn_draw)
		brush:line(xn_yp_draw, xn_yn_draw)
		brush:line(xp_yp_draw, xn_yp_draw)
		brush:line(xp_yn_draw, xn_yn_draw)
		local nsi = room.vis_group and self:get_nav_seg_from_i_vis_group(room.vis_group)
		local ns = nsi and self._nav_segments[nsi]
		if ns and ns.disabled then
			brush = brushes.room_diag_disabled
		else
			brush = brushes.room_diag
		end

		if room.obstructed then
			brush = brushes.room_diag_obstructed
		end

		brush:line(xp_yp_draw, xn_yn_draw)
		brush:line(xn_yp_draw, xp_yn_draw)
	end

	local expansion = room.expansion
	if expansion then
		local (for generator), (for state), (for control) = pairs(expansion)
		do
			do break end
			local (for generator), (for state), (for control) = pairs(side_expansion)
			do
				do break end
				local color, rad
				if obstacle_type == "walls" then
					rad = 3
					color = Vector3(1, 0, 0)
				elseif obstacle_type == "spaces" then
					rad = 2.2
					color = Vector3(0, 1, 0)
				elseif obstacle_type == "stairs" then
					rad = 1
					color = Vector3(1, 0.4, 0)
				elseif obstacle_type == "cliffs" then
					rad = 1
					color = Vector3(0.2, 0.1, 0)
				else
					rad = 1
					color = Vector3(0.5, 0.5, 0.5)
				end

				local (for generator), (for state), (for control) = pairs(obstacle_segments)
				do
					do break end
					Application:draw_cone(obstacle_segment[1], obstacle_segment[2], rad, color.x, color.y, color.z)
				end

			end

			(for control) = 0.5 and Application
		end

		(for control) = Vector3(1, 1) and nil
	end

	(for control) = brush and pairs
	if room.expansion_segments then
		local (for generator), (for state), (for control) = pairs(room.expansion_segments)
		do
			do break end
			local color, rad
			if self._neg_dir_str_map[dir_str] then
				rad = 3.5
				color = Vector3(0.5, 0.5, 0.5)
			else
				rad = 4
				color = Vector3(1, 1, 1)
			end

			local (for generator), (for state), (for control) = pairs(seg_list)
			do
				do break end
				Application:draw_cylinder(seg[1], seg[2], rad, color.x, color.y, color.z)
			end

		end

		(for control) = 1 and Application
	end

	(for control) = brush and nil
	if room.neighbours then
		local (for generator), (for state), (for control) = pairs(room.neighbours)
		do
			do break end
			local color, rad
			if self._neg_dir_str_map[side] then
				rad = 3.2
				color = Vector3(0, 0.5, 0.5)
			else
				rad = 4
				color = Vector3(0, 1, 1)
			end

			local (for generator), (for state), (for control) = pairs(neighbour_list)
			do
				do break end
				Application:draw_cylinder(neighbour_data.overlap[1], neighbour_data.overlap[2], rad, color.x, color.y, color.z)
				Application:draw_line(my_center, (neighbour_data.overlap[1] + neighbour_data.overlap[2]) * 0.5, color.x, color.y, color.z)
			end

		end

	end

end

function NavigationManager:_draw_doors(progress)
-- fail 31
null
12
	local selected_seg = self._selected_segment
	local room_mask
	if selected_seg and self._nav_segments[selected_seg] and next(self._nav_segments[selected_seg].vis_groups) then
		room_mask = {}
		local (for generator), (for state), (for control) = ipairs(self._nav_segments[selected_seg].vis_groups)
		do
			do break end
			local vis_group_rooms = self._visibility_groups[i_vis_group].rooms
			local (for generator), (for state), (for control) = pairs(vis_group_rooms)
			do
				do break end
				room_mask[i_room] = true
			end

		end

	end

	local data = self._draw_data
	local doors = nil and self._room_doors
	local nr_doors = #doors
	local i_door = data.next_draw_i_door
	local wanted_index = math.clamp(math.ceil(nr_doors * progress), 1, nr_doors)
	while i_door <= wanted_index and nr_doors >= i_door do
		local door = doors[i_door]
		if not room_mask or room_mask[door.rooms[1]] or room_mask[door.rooms[2]] then
			self:_draw_door(door)
		end

		i_door = i_door + 1
	end

	if progress == 1 then
		data.next_draw_i_door = 1
	else
		data.next_draw_i_door = i_door
	end

end

function NavigationManager:_draw_door(door)
	local brush = self._draw_data.brush.door
	brush:cylinder(door.pos, door.pos1, 2)
end

function NavigationManager:_draw_anim_nav_links()
	if not self._nav_links then
		return
	end

	local brush = Draw:brush(Color(0.3, 0.8, 0.2, 0.1))
	local (for generator), (for state), (for control) = pairs(self._nav_links)
	do
		do break end
		local start_pos = element:value("position")
		brush:cone(element:nav_link_end_pos(), start_pos, 20)
	end

end

function NavigationManager:_draw_covers()
	local reserved = self.COVER_RESERVED
	local (for generator), (for state), (for control) = ipairs(self._covers)
	do
		do break end
		local draw_pos = cover[1]
		Application:draw_rotation(draw_pos, Rotation(cover[2], math.UP))
		if cover[reserved] then
			Application:draw_sphere(draw_pos, 18, 0, 0, 0)
		end

		local tracker = cover[3]
		if tracker:lost() then
			local placed_pos = tracker:position()
			Application:draw_sphere(placed_pos, 20, 1, 0, 0)
			Application:draw_line(placed_pos, draw_pos, 1, 0, 0)
		end

	end

end

function NavigationManager:cover_info()
	local reserved = self.COVER_RESERVED
	local (for generator), (for state), (for control) = ipairs(self._covers)
	do
		do break end
		if cover[reserved] then
			print("cover", i_cover, "reserved", cover[reserved], "times")
		end

	end

end

function NavigationManager:_draw_geographic_segments()
	if not next(self._geog_segments) then
		return
	end

	local seg_rad = 3
	local seg_color = Vector3(0.8, 0.2, 0.1)
	local room_rad = 2
	local room_color = Vector3(1, 1, 1)
	local (for generator), (for state), (for control) = pairs(self._geog_segments)
	do
		do break end
		local borders = self:_calculate_geographic_segment_borders(i_seg)
		local height = 300
		local top_right = Vector3(borders.x_pos, borders.y_pos, height)
		local top_left = Vector3(borders.x_neg, borders.y_pos, height)
		local bottom_right = Vector3(borders.x_pos, borders.y_neg, height)
		local bottom_left = Vector3(borders.x_neg, borders.y_neg, height)
		Application:draw_cylinder(top_right, top_left, seg_rad, seg_color.x, seg_color.y, seg_color.z)
		Application:draw_cylinder(top_left, bottom_left, seg_rad, seg_color.x, seg_color.y, seg_color.z)
		Application:draw_cylinder(bottom_left, bottom_right, seg_rad, seg_color.x, seg_color.y, seg_color.z)
		Application:draw_cylinder(bottom_right, top_right, seg_rad, seg_color.x, seg_color.y, seg_color.z)
	end

end

function NavigationManager:_draw_visibility_groups(progress)
	local selected_seg = self._selected_segment
	if not selected_seg or not self._nav_segments[selected_seg] then
		return
	end

	local selected_vis_groups = self._nav_segments[selected_seg].vis_groups
	local nr_vis_groups = #selected_vis_groups
	if nr_vis_groups == 0 then
		return
	end

	local all_vis_groups = self._visibility_groups
	local all_rooms = self._rooms
	local builder = self._builder
	local draw_data = self._draw_data
	local brush_node = draw_data.brush.vis_graph_node
	local brush_rooms = draw_data.brush.vis_graph_rooms
	local brush_links = draw_data.brush.vis_graph_links
	local i_vis_group = draw_data.next_draw_i_vis
	local wanted_index = math.clamp(math.floor(nr_vis_groups * progress), 0, nr_vis_groups)
	while wanted_index > 0 and i_vis_group <= wanted_index do
		local vis_group = all_vis_groups[selected_vis_groups[i_vis_group]]
		brush_node:sphere(vis_group.pos, 30)
		do
			local (for generator), (for state), (for control) = pairs(vis_group.rooms)
			do
				do break end
				local room_c = builder:_calculate_room_center(all_rooms[i_vis_room])
				brush_rooms:line(vis_group.pos, room_c)
			end

		end

		(for control) = 30 and builder._calculate_room_center
		do
			local (for generator), (for state), (for control) = pairs(vis_group.vis_groups)
			do
				do break end
				local neigh_group = all_vis_groups[i_neigh_group]
				brush_links:cylinder(vis_group.pos, neigh_group.pos, 2)
				if neigh_group.seg ~= selected_seg then
					brush_links:sphere(neigh_group.pos, 20)
				end

			end

		end

		i_vis_group = i_vis_group + 1
		(for control) = 30 and all_vis_groups[i_neigh_group]
	end

	if progress == 1 then
		draw_data.next_draw_i_vis = 1
	else
		draw_data.next_draw_i_vis = i_vis_group
	end

end

function NavigationManager:_draw_coarse_graph()
	local all_nav_segments = self._nav_segments
	local all_doors = self._room_doors
	local all_vis_groups = self._visibility_groups
	local brush = self._draw_data.brush.coarse_graph
	local (for generator), (for state), (for control) = pairs(all_nav_segments)
	do
		do break end
		local neighbours = seg_data.neighbours
		local (for generator), (for state), (for control) = pairs(neighbours)
		do
			do break end
			brush:cone(all_nav_segments[neigh_i_seg].pos, seg_data.pos, 12)
		end

	end

end

function NavigationManager:get_nav_segments_in_direction(start_nav_seg_id, fwd)
-- fail 21
null
17
	local mvec3_set = mvector3.set
	local mvec3_dot = mvector3.dot
	local mvec3_sub = mvector3.subtract
	local all_nav_segs = self._nav_segments
	local start_nav_seg = all_nav_segs[start_nav_seg_id]
	local start_pos = start_nav_seg.pos
	local quad_field = self._quad_field
	local to_search = {}
	local discovered = {}
	discovered[start_nav_seg_id] = true
	local found = {}
	local search_vec = temp_vec1
	local immediate_neighbours = start_nav_seg.neighbours
	do
		local (for generator), (for state), (for control) = pairs(immediate_neighbours)
		do
			do break end
			discovered[neighbour_id] = true
			local neighbour_seg = all_nav_segs[neighbour_id]
			if not neighbour_seg.disabled then
				mvec3_set(search_vec, neighbour_seg.pos)
				mvec3_sub(search_vec, start_pos)
				local neighbour_dot = mvec3_dot(fwd, search_vec)
				if neighbour_dot > 0 then
					table.insert(to_search, neighbour_id)
					found[neighbour_id] = true
				end

			end

		end

	end

	while #to_search ~= 0 do
		local search_nav_seg_id = table.remove(to_search)
		local my_neighbours = all_nav_segs[search_nav_seg_id].neighbours
		local (for generator), (for state), (for control) = pairs(my_neighbours)
		do
			do break end
			if not discovered[neighbour_id] then
				discovered[neighbour_id] = true
				if not all_nav_segs[neighbour_id].disabled then
					table.insert(to_search, neighbour_id)
					found[neighbour_id] = true
				end

			end

		end

	end

	(for control) = all_nav_segs[neighbour_id] and discovered[neighbour_id]
	return next(found) and found
end

function NavigationManager:find_random_position_in_segment(seg_id)
	return self._quad_field:random_position_in_nav_segment(seg_id)
end

function NavigationManager:register_cover_units()
