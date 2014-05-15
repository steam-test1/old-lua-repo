NavFieldBuilder = NavFieldBuilder or class()
NavFieldBuilder._VERSION = 5
function NavFieldBuilder:init()
	self._door_access_types = {walk = 1}
	self._opposite_side_str = {
		x_pos = "x_neg",
		x_neg = "x_pos",
		y_pos = "y_neg",
		y_neg = "y_pos"
	}
	self._perp_pos_dir_str_map = {
		x_pos = "y_pos",
		x_neg = "y_pos",
		y_pos = "x_pos",
		y_neg = "x_pos"
	}
	self._perp_neg_dir_str_map = {
		x_pos = "y_neg",
		x_neg = "y_neg",
		y_pos = "x_neg",
		y_neg = "x_neg"
	}
	self._dim_str_map = {
		x_pos = "x",
		x_neg = "x",
		y_pos = "y",
		y_neg = "y"
	}
	self._perp_dim_str_map = {
		x_pos = "y",
		x_neg = "y",
		y_pos = "x",
		y_neg = "x"
	}
	self._neg_dir_str_map = {x_neg = true, y_neg = true}
	self._x_dir_str_map = {x_pos = true, x_neg = true}
	self._dir_str_to_vec = {
		x_pos = Vector3(1, 0, 0),
		x_neg = Vector3(-1, 0, 0),
		y_pos = Vector3(0, 1, 0),
		y_neg = Vector3(0, -1, 0)
	}
	self._ground_padding = 35
	self._wall_padding = 24
	self._max_nr_rooms = 20000
	self._room_height = 70
	self._grid_size = 25
	self._air_ray_rad = self._grid_size * 1.2
	self._gnd_ray_rad = self._grid_size * 0.9
	self._room_dimention_max = 1000
	self._raycast_dis_max = 10000
	self._max_fall = 800
	self._up_vec = Vector3(0, 0, self._ground_padding + self._grid_size)
	self._down_vec = Vector3(0, 0, -self._max_fall)
	self._slotmask = managers.slot:get_mask("AI_graph_obstacle_check")
	self._rooms = {}
	self._room_doors = {}
	self._visibility_groups = {}
	self._nav_segments = {}
	self._geog_segments = {}
	self._geog_segment_size = 500
	self._nr_geog_segments = nil
	self._geog_segment_offset = nil
end

function NavFieldBuilder:clear()
	self._geog_segments = {}
	self._nr_geog_segments = nil
	self._geog_segment_offset = nil
	self._rooms = {}
	self._room_doors = {}
	self._visibility_groups = {}
	self._nav_segments = {}
	self._building = nil
	self._progress_dialog_cancel = nil
	self:_reenable_all_blockers()
	self._helper_blockers = nil
	self._new_blockers = nil
end

function NavFieldBuilder:update(t, dt)
	if self._building then
		if self._progress_dialog_cancel then
			self._progress_dialog_cancel = nil
			self:clear()
			self:_destroy_progress_bar()
			self._building = nil
		else
			self._building.task_clbk(self)
		end

	end

end

function NavFieldBuilder:_create_build_progress_bar(title, num_divistions)
	if not self._progress_dialog then
		self._progress_dialog = EWS:ProgressDialog(Global.frame_panel, title, "", num_divistions, "PD_AUTO_HIDE,PD_SMOOTH,PD_CAN_ABORT,PD_ELAPSED_TIME,PD_ESTIMATED_TIME,PD_REMAINING_TIME")
		self._progress_dialog:set_focus()
		self._progress_dialog:update()
	end

end

function NavFieldBuilder:_destroy_progress_bar()
	if self._progress_dialog then
		self._progress_dialog:destroy()
		self._progress_dialog = nil
	end

end

function NavFieldBuilder:set_field_data(data)
	local (for generator), (for state), (for control) = pairs(data)
	do
		do break end
		self[i] = k
	end

end

function NavFieldBuilder:set_segment_state(id, state)
	self._nav_segments[id].no_access = not state and true or nil
end

function NavFieldBuilder:build_nav_segments(build_settings, complete_clbk)
	self._build_complete_clbk = complete_clbk
	local all_vis_groups = self._visibility_groups
	do
		local (for generator), (for state), (for control) = ipairs(self._rooms)
		do
			do break end
			if not room.segment then
				room.segment = all_vis_groups[room.vis_group].seg
			end

		end

	end

	(for control) = nil and room.segment
	do
		local (for generator), (for state), (for control) = ipairs(build_settings)
		do
			do break end
			self:delete_segment(segment_settings.id)
		end

	end

	self._nr_geog_segments = nil
	(for control) = nil and self.delete_segment
	self:start_build_nav_segment(build_settings, 1)
end

function NavFieldBuilder:build_visibility_graph(complete_clbk, all_visible, ray_dis, pos_filter, neg_filter)
	local all_rooms = self._rooms
	local all_vis_groups = self._visibility_groups
	do
		local (for generator), (for state), (for control) = ipairs(all_rooms)
		do
			do break end
			if not room.segment then
				room.segment = all_vis_groups[room.vis_group].seg
			end

			room.vis_group = nil
		end

	end

	self._visibility_groups = nil and {}
	local all_vis_groups = self._visibility_groups
	if all_visible then
		local seg_to_vis_group_map = {}
		local nr_vis_groups = 0
		do
			local (for generator), (for state), (for control) = pairs(self._nav_segments)
			do
				do break end
				local new_vis_group = {
					rooms = {},
					pos = nav_seg.pos,
					vis_groups = {},
					seg = nav_seg_id
				}
				table.insert(all_vis_groups, new_vis_group)
				nr_vis_groups = nr_vis_groups + 1
				seg_to_vis_group_map[nav_seg_id] = nr_vis_groups
				nav_seg.vis_groups = {nr_vis_groups}
			end

		end

		do break end
		do
			local (for generator), (for state), (for control) = ipairs(all_vis_groups)
			do
				do break end
				local visible_groups = vis_group.vis_groups
				local i = 1
				repeat
					if i ~= i_vis_group then
						visible_groups[i] = true
					end

					i = i + 1
				until nr_vis_groups < i
			end

		end

		(for control) = nil and vis_group.vis_groups
		do
			local (for generator), (for state), (for control) = ipairs(all_rooms)
			do
				do break end
				local i_vis_group = seg_to_vis_group_map[room.segment]
				room.vis_group = i_vis_group
				all_vis_groups[i_vis_group].rooms[i_room] = true
			end

		end

		(for control) = nil and room.segment
		self:_generate_coarse_navigation_graph()
		self:_cleanup_room_data_1()
		complete_clbk()
		return
	end

	self._build_complete_clbk = complete_clbk
	self._room_visibility_data = {}
	self:_create_build_progress_bar("Building Visibility Graph", 5)
	self._building = {}
	self._building.task_clbk = self._commence_vis_graph_build
	self._building.pos_vis_filter = pos_filter
	self._building.neg_vis_filter = neg_filter
	self._building.ray_dis = ray_dis
	local nr_rooms = #self._rooms
	if nr_rooms == 1 then
		self._building.stage = 2
		self._room_visibility_data[1] = {}
	else
		local i_room_a = 1
		local i_room_b = 2
		local room_a = all_rooms[i_room_a]
		local room_b = all_rooms[i_room_b]
		self._building.stage = 1
		self._building.current_i_room_a = i_room_a
		self._building.current_i_room_b = i_room_b
		self._building.new_pair = true
	end

	self._building.stage = self._building.stage or 2
end

function NavFieldBuilder:_chk_room_vis_filter(room_a, room_b, pos_filter, neg_filter)
	local seg_low, seg_high = math.min_max(room_a.segment, room_b.segment)
	if seg_low == seg_high or pos_filter[seg_low] and pos_filter[seg_low][seg_high] then
		return true
	elseif neg_filter[seg_low] and neg_filter[seg_low][seg_high] then
		return false
	end

	return nil
end

function NavFieldBuilder:delete_segment(id)
	local all_vis_groups = self._visibility_groups
	local all_rooms = self._rooms
	local all_blockers = self._helper_blockers
	local i_room = #self._rooms
	while i_room > 0 do
		local room = all_rooms[i_room]
		if room.segment then
			if room.segment == id then
				self:_trash_room(i_room)
				self:_destroy_room(i_room)
			end

		elseif all_vis_groups[room.vis_group].seg == id then
			self:_trash_room(i_room)
			self:_destroy_room(i_room)
		end

		i_room = i_room - 1
	end

	local all_nav_segments = self._nav_segments
	local seg = all_nav_segments[id]
	if not seg then
		return
	end

	all_nav_segments[id] = nil
	do
		local (for generator), (for state), (for control) = pairs(all_nav_segments)
		do
			do break end
			test_seg.neighbours[id] = nil
		end

	end

	local owned_vis_groups = seg.vis_groups
	local index_owned_vis_group = nil and #owned_vis_groups
	while index_owned_vis_group > 0 do
		local i_owned_vis_group = owned_vis_groups[index_owned_vis_group]
		print("removing vis group", i_owned_vis_group, "at index", index_owned_vis_group)
		self:_destroy_vis_group(i_owned_vis_group)
		index_owned_vis_group = index_owned_vis_group - 1
		local i = index_owned_vis_group
		while i > 0 do
			if i_owned_vis_group < owned_vis_groups[i] then
				print("adjusting trash vis_group", owned_vis_groups[i], "at", i)
				owned_vis_groups[i] = owned_vis_groups[i] - 1
			end

			i = i - 1
		end

	end

	if self._helper_blockers then
		local (for generator), (for state), (for control) = pairs(all_blockers)
		do
			do break end
			if segment == id then
				all_blockers[u_id] = nil
			end

		end

	end

end

function NavFieldBuilder:_destroy_vis_group(i_vis_group)
-- fail 33
null
14
-- fail 52
null
15
	local all_rooms = self._rooms
	local all_nav_segments = self._nav_segments
	local all_vis_groups = self._visibility_groups
	local vis_group = table.remove(all_vis_groups, i_vis_group)
	do
		local (for generator), (for state), (for control) = ipairs(all_rooms)
		do
			do break end
			if room.vis_group and i_vis_group < room.vis_group then
				room.vis_group = room.vis_group - 1
			end

		end

	end

	(for control) = nil and room.vis_group
	do
		local (for generator), (for state), (for control) = pairs(all_nav_segments)
		do
			do break end
			local owned_vis_groups = seg.vis_groups
			local (for generator), (for state), (for control) = ipairs(owned_vis_groups)
			do
				do break end
				if i_vis_group < i_owned_vis_group then
					owned_vis_groups[index_owned_vis_group] = i_owned_vis_group - 1
				end

			end

		end

	end

	(for control) = nil and seg.vis_groups
	local (for generator), (for state), (for control) = ipairs(all_vis_groups)
	do
		do break end
		local visible_vis_groups = test_vis_group.vis_groups
		visible_vis_groups[i_vis_group] = nil
		local new_list = {}
		do
			local (for generator), (for state), (for control) = pairs(visible_vis_groups)
			do
				do break end
				if i_vis_group < i_visibile_group then
					new_list[i_visibile_group - 1] = true
				else
					new_list[i_visibile_group] = true
				end

			end

		end

		test_vis_group.vis_groups = new_list
	end

end

function NavFieldBuilder:start_build_nav_segment(build_settings, segment_index)
	self:_create_build_progress_bar("Building Navigation Segments", 6)
	local build_seg = build_settings[segment_index]
	self._building = {}
	self._building.build_settings = build_settings
	self._building.segment_index = segment_index
	self._building.task_clbk = self._commence_nav_field_build
	self._building.stage = 1
	local nav_segment_id = build_seg.id
	self._building.id = nav_segment_id
	self._new_blockers = {}
	self._helper_blockers = self._helper_blockers or {}
	self._disabled_blockers = self._disabled_blockers or {}
	self._nav_segments[nav_segment_id] = {
		pos = build_seg.position,
		vis_groups = {},
		neighbours = {},
		location_id = build_seg.location_id,
		build_seg.strategic_area_id
	}
	local all_blockers = World:find_units_quick("all", 15)
	local to_remove = {}
	do
		local (for generator), (for state), (for control) = pairs(self._helper_blockers)
		do
			do break end
			local verified
			if segment ~= nav_segment_id then
				local (for generator), (for state), (for control) = ipairs(all_blockers)
				do
					do break end
					local u_id_ = blocker_unit:unit_data().unit_id
					if u_id_ == u_id then
						verified = true
				end

				else
				end

			end

			do break end
			table.insert(to_remove, u_id)
		end

	end

	(for control) = nil and nil
	do
		local (for generator), (for state), (for control) = ipairs(to_remove)
		do
			do break end
			self._helper_blockers[u_id] = nil
		end

	end

	(for control) = nil and self._helper_blockers
	do
		local (for generator), (for state), (for control) = ipairs(all_blockers)
		do
			do break end
			local u_id = blocker_unit:unit_data().unit_id
			local blocker_segment = self._helper_blockers[u_id]
			if blocker_segment then
				self:_disable_blocker(blocker_unit)
			end

		end

	end

	(for control) = nil and blocker_unit.unit_data
	local start_pos_rounded = self:_round_pos_to_grid_center(build_seg.position) + Vector3(self._grid_size * 0.5, self._grid_size * 0.5, 0)
	local ground_ray = self:_sphere_ray(start_pos_rounded + self._up_vec, start_pos_rounded + self._down_vec, self._gnd_ray_rad)
	self:_analyse_room("x_pos", start_pos_rounded:with_z(ground_ray.position.z))
end

function NavFieldBuilder:_commence_nav_field_build()
	if self._building.stage == 1 then
		self:_expand_rooms()
	elseif self._building.stage == 2 then
		if not self._building.sorted_rooms then
			self._building.sorted_rooms = {}
			local build_id = self._building.id
			local (for generator), (for state), (for control) = ipairs(self._rooms)
			do
				do break end
				if room.segment == build_id then
					self:_sort_room_by_area(i_room, self._building.sorted_rooms)
				end

			end

		end

		(for control) = nil and room.segment
		self:_update_progress_bar(2, "Merging Room " .. tostring(self._building.sorted_rooms[#self._building.sorted_rooms]))
		local done = self:_merge_rooms()
		if done then
			if not self._building.second_pass then
				self._building.stage = 3
			end

			self._building.second_pass = nil
			self._building.sorted_rooms = nil
		end

	elseif self._building.stage == 3 then
		do
			local (for generator), (for state), (for control) = ipairs(self._rooms)
			do
				do break end
				if room.segment == self._building.id then
					self:_create_room_doors(i_room)
				end

			end

		end

		self._building.stage = "Merging Room " .. tostring(self._building.sorted_rooms[#self._building.sorted_rooms]) and 4
	elseif self._building.stage == 4 then
		self:_update_progress_bar(3, "Calculating door heights")
		self:_calculate_door_heights()
		self._building.stage = 5
	elseif self._building.stage == 5 then
		self:_update_progress_bar(4, "Cleaning Up room_data")
		self:_cleanup_room_data()
		self._building.stage = 6
	elseif self._building.stage == 6 then
		self:_set_new_blockers_used()
		self:_reenable_all_blockers()
		self:_destroy_progress_bar()
		if self._building.segment_index == #self._building.build_settings then
			self._building = false
			self._build_complete_clbk()
		else
			self:start_build_nav_segment(self._building.build_settings, self._building.segment_index + 1)
		end

	end

end

function NavFieldBuilder:_expand_rooms()
	local progress
	local can_room_expand = function(expansion_data)
		if expansion_data then
			local (for generator), (for state), (for control) = pairs(expansion_data)
			do
				do break end
				if next(seg_list) then
					return true
				end

			end

		end

	end

	local function expand_room(room)
		local expansion_data = room.expansion_segments
		local progress
		do
			local (for generator), (for state), (for control) = pairs(expansion_data)
			do
				do break end
				do
					local (for generator), (for state), (for control) = pairs(exp_dir_data)
					do
						do break end
						if #self._rooms >= self._max_nr_rooms then
							print("!\t\tError. Room # limit exceeded")
							exp_dir_data[i_segment] = nil
						else
							local new_enter_pos = Vector3()
							local size_1 = segment[1][self._perp_dim_str_map[dir_str]] + self._grid_size * 0.5
							local size_2 = room.borders[dir_str] + (self._neg_dir_str_map[dir_str] and -1 or 1) * self._grid_size * 0.5
							mvector3["set_" .. self._perp_dim_str_map[dir_str]](new_enter_pos, size_1)
							mvector3["set_" .. self._dim_str_map[dir_str]](new_enter_pos, size_2)
							mvector3.set_z(new_enter_pos, segment[1].z)
							local gnd_ray = self:_sphere_ray(new_enter_pos + self._up_vec, new_enter_pos + self._down_vec, self._gnd_ray_rad)
							if gnd_ray then
								mvector3.set_z(new_enter_pos, gnd_ray.position.z)
							else
								Application:error("! Error. NavFieldBuilder:_expand_rooms() ground ray failed! segment", segment[1], segment[2])
								Application:draw_cylinder(new_enter_pos + self._up_vec, new_enter_pos + self._down_vec, self._gnd_ray_rad, 1, 0, 0)
								managers.navigation:_draw_room(room, true)
								Application:set_pause(true)
								progress = false
								break
							end

							local new_i_room = self:_analyse_room(dir_str, new_enter_pos)
							local new_room = self._rooms[new_i_room]
							progress = true
							break
						end

					end

				end

				do break end
				break
			end

		end

	end

	do
		local (for generator), (for state), (for control) = ipairs(self._rooms)
		do
			do break end
			local expansion_segments = room.expansion_segments
			while not progress and can_room_expand(expansion_segments) do
				local text = "expanding room " .. tostring(i_room) .. " of " .. tostring(#self._rooms)
				self:_update_progress_bar(1, text)
				progress = expand_room(room)
				if progress then
					break
				end

			end

		end

	end

	do break end
	self._building.stage = 2
	self._building.second_pass = true
end

function NavFieldBuilder:_merge_rooms()
	local _remove_room_from_sorted_list = function(i_room, sorted_rooms)
		local (for generator), (for state), (for control) = ipairs(sorted_rooms)
		do
			do break end
			if sorted_i_room == i_room then
				table.remove(sorted_rooms, sort_index)
		end

		else
		end

	end

	local function _dispose_trash_rooms(trash_rooms, sorted_rooms)
-- fail 13
null
9
		local (for generator), (for state), (for control) = pairs(trash_rooms)
		do
			do break end
			self:_destroy_room(i_room)
			do
				local (for generator), (for state), (for control) = pairs(trash_rooms)
				do
					do break end
					if i_room < next_i_room then
						trash_rooms[next_i] = next_i_room - 1
					end

				end

			end

			_remove_room_from_sorted_list(i_room, sorted_rooms)
			local (for generator), (for state), (for control) = ipairs(sorted_rooms)
			do
				do break end
				if i_room < room_index then
					sorted_rooms[sort_index] = room_index - 1
				end

			end

		end

	end

	local function _find_walls_on_side(room, side)
		local all_doors = self._room_doors
		local borders = room.borders
		local fwd_border = borders[side]
		local along_dim = self._perp_dim_str_map[side]
		local perp_dim = self._dim_str_map[side]
		local left_corner = Vector3()
		local right_corner = Vector3()
		mvector3["set_" .. along_dim](left_corner, borders[self._perp_neg_dir_str_map[side]])
		mvector3["set_" .. perp_dim](left_corner, fwd_border)
		mvector3["set_" .. along_dim](right_corner, borders[self._perp_pos_dir_str_map[side]])
		mvector3["set_" .. perp_dim](right_corner, fwd_border)
		local walls = {
			{left_corner, right_corner}
		}
		do
			local (for generator), (for state), (for control) = ipairs(room.neighbours[side])
			do
				do break end
				walls = self:_remove_seg_from_seg_list(walls, neighbour_data.overlap, along_dim)
			end

		end

	end

	local function _get_room_expandable_borders(room)
		local expandable_sides = {}
		local neighbours = room.neighbours
		do
			local (for generator), (for state), (for control) = pairs(room.expansion)
			do
				do break end
				local opp_side = self._opposite_side_str[side]
				local dim = self._perp_dim_str_map[side]
				if not next(_find_walls_on_side(room, side)) then
					local exp_seg = {}
					local neighbour_block
					do
						local (for generator), (for state), (for control) = pairs(neighbours[side])
						do
							do break end
							local neighbour = self._rooms[neighbour_data.room]
							local neighbour_expansion = neighbour.expansion and neighbour.expansion[opp_side]
							local overlap = neighbour_data.overlap
							if not neighbour_expansion or self:_seg_to_seg_list_intersection_bool(neighbour_expansion.stairs, overlap, dim) then
								neighbour_block = true
								break
							else
								self:_append_seg_to_seg_list(exp_seg, overlap, dim)
							end

						end

					end

					do break end
					if #exp_seg == 1 and exp_seg[1][1][dim] == room.borders[self._perp_neg_dir_str_map[side]] and exp_seg[1][2][dim] == room.borders[self._perp_pos_dir_str_map[side]] then
						expandable_sides[side] = true
					end

				end

			end

		end

	end

	local function _is_larger_than_neighbours(room, dir_str)
		local area = room.area
		do
			local (for generator), (for state), (for control) = pairs(room.neighbours[dir_str])
			do
				do break end
				local i_neighbour_room = neighbour_data.room
				local neighbour_area = self._rooms[i_neighbour_room].area
				if area < neighbour_area then
					return false
				end

			end

		end

		(for control) = nil and neighbour_data.room
	end

	local sorted_rooms = self._building.sorted_rooms
	while #sorted_rooms > 0 do
		local i_room = sorted_rooms[#sorted_rooms]
		local room = self._rooms[i_room]
		local expandable_borders = _get_room_expandable_borders(room)
		local exp_border = next(expandable_borders)
		while exp_border do
			if self:_chk_room_side_too_long(room.borders, exp_border) then
				if expandable_borders[self._perp_neg_dir_str_map[exp_border]] then
					exp_border = self._perp_neg_dir_str_map[exp_border]
				elseif expandable_borders[self._perp_pos_dir_str_map[exp_border]] then
					exp_border = self._perp_pos_dir_str_map[exp_border]
				end

			else
			end

			local border_seg = self:_get_border_segment(room.height, room.borders, exp_border)
			local clip_size = self:_room_expansion_space_at_side(room.borders, exp_border)
			do
				local (for generator), (for state), (for control) = pairs(room.neighbours[exp_border])
				do
					do break end
					local neighbour_room = self._rooms[neighbour_data.room]
					local neighbour_borders = neighbour_room.borders
					local neighbour_clip_size = self:_room_retract_space_at_side(neighbour_room, self._opposite_side_str[exp_border], border_seg)
					if clip_size > neighbour_clip_size then
						clip_size = neighbour_clip_size
					end

				end

			end

			do break end
			if _is_larger_than_neighbours(room, exp_border) then
				local new_rooms, trash_rooms, shrunk_rooms = self:_expand_room_over_neighbours(i_room, exp_border, clip_size)
				if new_rooms then
					local (for generator), (for state), (for control) = pairs(new_rooms)
					do
						do break end
						if not self._rooms[i_new_room].trashed then
							self:_sort_room_by_area(i_new_room, sorted_rooms)
						end

					end

				end

				do break end
				do
					local (for generator), (for state), (for control) = pairs(shrunk_rooms)
					do
						do break end
						if not self._rooms[i_shrunk_room].trashed then
							self:_sort_room_by_area(i_shrunk_room, sorted_rooms, true)
						end

					end

				end

				do break end
				_dispose_trash_rooms(trash_rooms, sorted_rooms)
				i_room = sorted_rooms[#sorted_rooms]
				room = self._rooms[i_room]
				expandable_borders = _get_room_expandable_borders(room)
				exp_border = next(expandable_borders)
			else
				expandable_borders[exp_border] = nil
				if expandable_borders[self._opposite_side_str[exp_border]] then
					exp_border = self._opposite_side_str[exp_border]
				elseif expandable_borders[self._perp_neg_dir_str_map[exp_border]] then
					exp_border = self._perp_neg_dir_str_map[exp_border]
				elseif expandable_borders[self._perp_pos_dir_str_map[exp_border]] then
					exp_border = self._perp_pos_dir_str_map[exp_border]
				else
					exp_border = nil
				end

			end

		end

		table.remove(sorted_rooms)
		return
	end

	return true
end

function NavFieldBuilder:_sort_room_by_area(i_room, room_list, resort)
	if resort then
		local (for generator), (for state), (for control) = ipairs(room_list)
		do
			do break end
			if i_room == i_sorted_room then
				table.remove(room_list, sort_index)
		end

		else
		end

	end

	local room = nil and self._rooms[i_room]
	local area = room.area
	local search_i = #room_list
	while search_i > 0 do
		local i_test_room = room_list[search_i]
		local test_room = self._rooms[i_test_room]
		local test_area = test_room.area
		if area >= test_area then
			break
		end

		search_i = search_i - 1
	end

	table.insert(room_list, search_i + 1, i_room)
end

function NavFieldBuilder:_update_progress_bar(percent_complete, text)
	if self._progress_dialog then
		local result = self._progress_dialog:update_bar(percent_complete, text)
		if not result then
			local confirm = EWS:message_box(Global.frame_panel, "Cancel calculation?", "AI", "YES_NO,ICON_QUESTION", Vector3(-1, -1, 0))
			if confirm == "NO" then
				self._progress_dialog:resume()
				return
			end

			self._progress_dialog_cancel = true
		end

	end

end

function NavFieldBuilder:_get_border_segment(height, borders, side)
	local seg = {
		Vector3(),
		Vector3()
	}
	mvector3["set_" .. self._dim_str_map[side]](seg[1], borders[side])
	mvector3["set_" .. self._dim_str_map[side]](seg[2], borders[side])
	mvector3["set_" .. self._perp_dim_str_map[side]](seg[1], borders[self._perp_neg_dir_str_map[side]])
	mvector3["set_" .. self._perp_dim_str_map[side]](seg[2], borders[self._perp_pos_dir_str_map[side]])
	local pos_z = self._get_room_height_at_pos(height, borders, seg[1])
	mvector3.set_z(seg[1], pos_z)
	local pos_z = self._get_room_height_at_pos(height, borders, seg[2])
	mvector3.set_z(seg[2], pos_z)
	return seg
end

function NavFieldBuilder:_expand_room_over_neighbours(i_room, exp_border, clip_size)
	local room = self._rooms[i_room]
	local neighbours = room.neighbours[exp_border]
	local expand_vec = self._dir_str_to_vec[exp_border] * clip_size
	local new_rooms, trash_rooms, shrunk_rooms
	while true do
		do
			local new_room
			do
				local (for generator), (for state), (for control) = pairs(neighbours)
				do
					do break end
					local clip_segment = neighbour_data.overlap
					new_room = self:_split_room_for_retraction(neighbour_data.room, self._opposite_side_str[exp_border], clip_segment)
					if new_room then
						new_rooms = new_rooms or {}
						table.insert(new_rooms, new_room)
				end

				else
				end

			end

			(for control) = nil and neighbour_data.overlap
		end

	end

	local retract_rooms = {}
	do
		local (for generator), (for state), (for control) = pairs(neighbours)
		do
			do break end
			table.insert(retract_rooms, neighbour_data)
		end

	end

	(for control) = nil and table
	do
		local (for generator), (for state), (for control) = pairs(room.expansion[exp_border])
		do
			do break end
			local (for generator), (for state), (for control) = pairs(seg_list)
			do
				do break end
				seg[1] = seg[1] + expand_vec
				seg[2] = seg[2] + expand_vec
			end

		end

		(for control) = new_room and seg[1]
	end

	(for control) = nil and pairs
	do
		local (for generator), (for state), (for control) = pairs(retract_rooms)
		do
			do break end
			local clip_segment = neighbour_data.overlap
			local want_neg_data = clip_segment[1][self._perp_dim_str_map[exp_border]] == room.borders[self._perp_neg_dir_str_map[exp_border]]
			local want_pos_data = clip_segment[2][self._perp_dim_str_map[exp_border]] == room.borders[self._perp_pos_dir_str_map[exp_border]]
			local destroy, new_data = self:_clip_room_border(neighbour_data.room, self._opposite_side_str[exp_border], clip_size, clip_segment, want_neg_data, want_pos_data)
			if destroy then
				trash_rooms = trash_rooms or {}
				table.insert(trash_rooms, neighbour_data.room)
			else
				shrunk_rooms = shrunk_rooms or {}
				table.insert(shrunk_rooms, neighbour_data.room)
			end

			if new_data then
				do
					local (for generator), (for state), (for control) = pairs(new_data.neighbours)
					do
						do break end
						local (for generator), (for state), (for control) = pairs(neighbour_list)
						do
							do break end
							self:_append_neighbour(room.neighbours[side], neighbour_data, side)
							if self._rooms[neighbour_data.room].neighbours then
								local new_data = {
									room = i_room,
									overlap = {
										neighbour_data.overlap[1],
										neighbour_data.overlap[2]
									}
								}
								self:_append_neighbour(self._rooms[neighbour_data.room].neighbours[self._opposite_side_str[side]], new_data, self._opposite_side_str[side])
							end

						end

					end

					(for control) = nil and self._append_neighbour
				end

				do break end
				neighbour_data.overlap[1] = neighbour_data.overlap[1] + expand_vec
				neighbour_data.overlap[2] = neighbour_data.overlap[2] + expand_vec
				if new_data.expansion[exp_border] then
					local (for generator), (for state), (for control) = pairs(new_data.expansion[exp_border])
					do
						do break end
						local (for generator), (for state), (for control) = pairs(seg_list)
						do
							do break end
							local (for generator), (for state), (for control) = pairs(room.expansion[exp_border])
							do
								do break end
								room.expansion[exp_border][obs_type] = self:_remove_seg_from_seg_list(old_seg_list, seg, self._perp_dim_str_map[exp_border])
							end

						end

						(for control) = self._rooms[neighbour_data.room].neighbours[self._opposite_side_str[side]] and room.expansion
					end

					(for control) = nil and pairs
				end

				(for control) = clip_segment and pairs
				local (for generator), (for state), (for control) = pairs(new_data.expansion)
				do
					do break end
					local (for generator), (for state), (for control) = pairs(obs_data)
					do
						do break end
						local (for generator), (for state), (for control) = pairs(seg_list)
						do
							do break end
							self:_append_seg_to_seg_list(room.expansion[side][obs_type], seg, self._perp_dim_str_map[side])
						end

					end

					(for control) = self._rooms[neighbour_data.room].neighbours[self._opposite_side_str[side]] and self._append_seg_to_seg_list
				end

				(for control) = nil and pairs
			end

		end

		(for control) = clip_segment and pairs
	end

	(for control) = nil and neighbour_data.overlap
	local new_border = room.borders[exp_border] + clip_size * (self._neg_dir_str_map[exp_border] and -1 or 1)
	room.borders[exp_border] = new_border
	room.area = self:_calc_room_area(room.borders)
	self:_find_room_height_from_expansion(room.expansion, room.height, "x_pos")
	return new_rooms, trash_rooms, shrunk_rooms
end

function NavFieldBuilder:_room_expansion_space_at_side(borders, exp_border)
	local length_size = math.abs(borders[exp_border] - borders[self._opposite_side_str[exp_border]])
	return length_size
end

function NavFieldBuilder:_room_retract_space_at_side(room, side, border_line)
-- fail 22
null
14
-- fail 50
null
14
	local borders = room.borders
	local expansion = room.expansion
	local perp_neg_side = self._perp_neg_dir_str_map[side]
	local perp_pos_side = self._perp_pos_dir_str_map[side]
	local side_dim = self._dim_str_map[side]
	local side_perp_dim = self._perp_dim_str_map[side]
	local max_obstacle, min_obstacle
	if border_line[1][side_perp_dim] < borders[perp_neg_side] then
		local (for generator), (for state), (for control) = pairs(expansion[perp_neg_side].stairs)
		do
			do break end
			if not max_obstacle or max_obstacle < seg[2][side_dim] then
				max_obstacle = seg[2][side_dim]
			end

			if not min_obstacle or min_obstacle > seg[1][side_dim] then
				min_obstacle = seg[1][side_dim]
			end

		end

	end

	if border_line[2][side_perp_dim] > borders[perp_pos_side] then
		local (for generator), (for state), (for control) = pairs(expansion[perp_pos_side].stairs)
		do
			do break end
			if not max_obstacle or max_obstacle < seg[2][side_dim] then
				max_obstacle = seg[2][side_dim]
			end

			if not min_obstacle or min_obstacle > seg[1][side_dim] then
				min_obstacle = seg[1][side_dim]
			end

		end

	end

	local clamp_length
	if self._neg_dir_str_map[side] then
		if min_obstacle then
			clamp_length = min_obstacle - borders[side]
		else
			clamp_length = borders[self._opposite_side_str[side]] - borders[side]
		end

	elseif max_obstacle then
		clamp_length = borders[side] - max_obstacle
	else
		clamp_length = borders[side] - borders[self._opposite_side_str[side]]
	end

	return clamp_length
end

function NavFieldBuilder:_split_room_for_retraction(i_room, side, clip_segment)
	local room = self._rooms[i_room]
	local borders = room.borders
	local clip_perp_dim = self._perp_dim_str_map[side]
	local perp_neg_side = self._perp_neg_dir_str_map[side]
	local perp_pos_side = self._perp_pos_dir_str_map[side]
	local clip_line = {
		clip_segment[1][clip_perp_dim],
		clip_segment[2][clip_perp_dim]
	}
	local overlaps_neg = clip_line[1] == borders[perp_neg_side]
	local overlaps_pos = clip_line[2] == borders[perp_pos_side]
	if not overlaps_neg or not overlaps_pos then
		local split_pos = overlaps_neg and clip_line[2] or clip_line[1]
		local new_i_room = self:_split_room(i_room, split_pos, clip_perp_dim)
		return new_i_room
	end

end

function NavFieldBuilder:_clip_room_border(i_room, side, clip_amount, clip_segment, want_neg_data, want_pos_data)
	local room = self._rooms[i_room]
	local borders = room.borders
	local neighbours = room.neighbours
	local expansion = room.expansion
	local expansion_segments = room.expansion_segments
	local new_data = {}
	local lower_neighbours = {
		x_pos = {},
		x_neg = {},
		y_pos = {},
		y_neg = {}
	}
	local upper_neighbours = {
		x_pos = {},
		x_neg = {},
		y_pos = {},
		y_neg = {}
	}
	local is_clip_side_neg = self._neg_dir_str_map[side]
	local clip_dim = self._dim_str_map[side]
	local clip_perp_dim = self._perp_dim_str_map[side]
	local perp_neg_side = self._perp_neg_dir_str_map[side]
	local perp_pos_side = self._perp_pos_dir_str_map[side]
	local opp_side = self._opposite_side_str[side]
	local clip_line = {
		clip_segment[1][clip_perp_dim],
		clip_segment[2][clip_perp_dim]
	}
	local my_length = math.abs(borders[side] - borders[opp_side])
	if clip_amount < my_length then
		local lower_expansion_data = {}
		local upper_expansion_data = {}
		lower_expansion_data[perp_neg_side] = {}
		lower_expansion_data[perp_pos_side] = {}
		upper_expansion_data[perp_neg_side] = {}
		upper_expansion_data[perp_pos_side] = {}
		borders[side] = self._neg_dir_str_map[side] and borders[side] + clip_amount or borders[side] - clip_amount
		local clip_pos = Vector3()
		mvector3["set_" .. clip_dim](clip_pos, borders[side])
		mvector3["set_" .. clip_perp_dim](clip_pos, borders[perp_neg_side])
		do
			local (for generator), (for state), (for control) = pairs(expansion[perp_neg_side])
			do
				do break end
				local lower_part, upper_part = self:_split_segment_list_at_position(obs_list, clip_pos, clip_dim)
				upper_expansion_data[perp_neg_side][obs_type] = upper_part
				lower_expansion_data[perp_neg_side][obs_type] = lower_part
			end

		end

		(for control) = nil and self._split_segment_list_at_position
		local lower_part, upper_part = self:_split_side_neighbours(neighbours[perp_neg_side], clip_pos, clip_dim)
		lower_neighbours[perp_neg_side] = lower_part
		upper_neighbours[perp_neg_side] = upper_part
		mvector3["set_" .. clip_perp_dim](clip_pos, borders[perp_pos_side])
		do
			local (for generator), (for state), (for control) = pairs(expansion[perp_pos_side])
			do
				do break end
				local lower_part, upper_part = self:_split_segment_list_at_position(obs_list, clip_pos, clip_dim)
				upper_expansion_data[perp_pos_side][obs_type] = upper_part
				lower_expansion_data[perp_pos_side][obs_type] = lower_part
			end

		end

		(for control) = self:_split_segment_list_at_position(obs_list, clip_pos, clip_dim) and self._split_segment_list_at_position
		local lower_part, upper_part = self:_split_side_neighbours(neighbours[perp_pos_side], clip_pos, clip_dim)
		lower_neighbours[perp_pos_side] = lower_part
		upper_neighbours[perp_pos_side] = upper_part
		if is_clip_side_neg then
			new_data.expansion = lower_expansion_data
			new_data.neighbours = lower_neighbours
			expansion[perp_neg_side] = upper_expansion_data[perp_neg_side]
			expansion[perp_pos_side] = upper_expansion_data[perp_pos_side]
			do
				local (for generator), (for state), (for control) = pairs(lower_neighbours[perp_neg_side])
				do
					do break end
					self:_update_neighbour_data(neighbour_data.room, i_room, nil, perp_pos_side)
				end

			end

			(for control) = self:_split_segment_list_at_position(obs_list, clip_pos, clip_dim) and self._update_neighbour_data
			do
				local (for generator), (for state), (for control) = pairs(lower_neighbours[perp_pos_side])
				do
					do break end
					self:_update_neighbour_data(neighbour_data.room, i_room, nil, perp_neg_side)
				end

			end

			neighbours[perp_neg_side] = self:_split_segment_list_at_position(obs_list, clip_pos, clip_dim) and upper_neighbours[perp_neg_side]
			neighbours[perp_pos_side] = upper_neighbours[perp_pos_side]
		else
			new_data.expansion = upper_expansion_data
			new_data.neighbours = upper_neighbours
			expansion[perp_neg_side] = lower_expansion_data[perp_neg_side]
			expansion[perp_pos_side] = lower_expansion_data[perp_pos_side]
			do
				local (for generator), (for state), (for control) = pairs(upper_neighbours[perp_neg_side])
				do
					do break end
					self:_update_neighbour_data(neighbour_data.room, i_room, nil, perp_pos_side)
				end

			end

			(for control) = self:_split_segment_list_at_position(obs_list, clip_pos, clip_dim) and self._update_neighbour_data
			do
				local (for generator), (for state), (for control) = pairs(upper_neighbours[perp_pos_side])
				do
					do break end
					self:_update_neighbour_data(neighbour_data.room, i_room, nil, perp_neg_side)
				end

			end

			neighbours[perp_neg_side] = self:_split_segment_list_at_position(obs_list, clip_pos, clip_dim) and lower_neighbours[perp_neg_side]
			neighbours[perp_pos_side] = lower_neighbours[perp_pos_side]
		end

		if not want_neg_data then
			new_data.expansion[perp_neg_side] = {}
			new_data.neighbours[perp_neg_side] = {}
		end

		if not want_pos_data then
			new_data.expansion[perp_pos_side] = {}
			new_data.neighbours[perp_pos_side] = {}
		end

		local mid_space = self:_get_border_segment(room.height, room.borders, side)
		expansion[side].spaces = {mid_space}
		local retract_vec = self._dir_str_to_vec[opp_side] * clip_amount
		do
			local (for generator), (for state), (for control) = pairs(neighbours[side])
			do
				do break end
				local overlap = neighbour_data.overlap
				overlap[1] = overlap[1] + retract_vec
				overlap[2] = overlap[2] + retract_vec
			end

		end

		(for control) = self._update_neighbour_data and neighbour_data.overlap
		do
			local (for generator), (for state), (for control) = pairs(neighbours[perp_neg_side])
			do
				do break end
				local new_data = {
					room = i_room,
					overlap = {
						neighbour_data.overlap[1],
						neighbour_data.overlap[2]
					}
				}
				self:_update_neighbour_data(neighbour_data.room, i_room, new_data, perp_pos_side)
			end

		end

		(for control) = self._update_neighbour_data and {
			room = i_room,
			overlap = {
				neighbour_data.overlap[1],
				neighbour_data.overlap[2]
			}
		}
		do
			local (for generator), (for state), (for control) = pairs(neighbours[perp_pos_side])
			do
				do break end
				local new_data = {
					room = i_room,
					overlap = {
						neighbour_data.overlap[1],
						neighbour_data.overlap[2]
					}
				}
				self:_update_neighbour_data(neighbour_data.room, i_room, new_data, perp_neg_side)
			end

		end

		(for control) = self._update_neighbour_data and {
			room = i_room,
			overlap = {
				neighbour_data.overlap[1],
				neighbour_data.overlap[2]
			}
		}
		room.area = self:_calc_room_area(borders)
		self:_find_room_height_from_expansion(expansion, room.height, side)
	else
		new_data.expansion = {}
		new_data.neighbours = {}
		if want_neg_data then
			new_data.expansion[perp_neg_side] = expansion[perp_neg_side]
			new_data.neighbours[perp_neg_side] = neighbours[perp_neg_side]
		end

		if want_pos_data then
			new_data.expansion[perp_pos_side] = expansion[perp_pos_side]
			new_data.neighbours[perp_pos_side] = neighbours[perp_pos_side]
		end

		new_data.expansion[opp_side] = expansion[opp_side]
		new_data.neighbours[opp_side] = neighbours[opp_side]
		self:_trash_room(i_room)
		return true, new_data
	end

	return false, new_data
end

function NavFieldBuilder:_split_room(i_room, split_pos_along_dim, split_dim)
	local room = self._rooms[i_room]
	local borders = room.borders
	local expansion = room.expansion
	local new_room = self:_create_empty_room()
	new_room.segment = room.segment
	local split_side = split_dim == "x" and "x_pos" or "y_pos"
	local split_perp_neg_side = self._perp_neg_dir_str_map[split_side]
	local split_perp_pos_side = self._perp_pos_dir_str_map[split_side]
	local split_perp_dim = self._perp_dim_str_map[split_side]
	local split_opp_side = self._opposite_side_str[split_side]
	local split_pos = Vector3()
	mvector3["set_" .. split_dim](split_pos, split_pos_along_dim)
	mvector3["set_" .. split_perp_dim](split_pos, borders[split_perp_neg_side])
	do
		local (for generator), (for state), (for control) = pairs(expansion[split_perp_neg_side])
		do
			do break end
			local lower_part, upper_part = self:_split_segment_list_at_position(obs_list, split_pos, split_dim)
			expansion[split_perp_neg_side][obs_type] = upper_part
			new_room.expansion[split_perp_neg_side][obs_type] = lower_part
		end

	end

	(for control) = nil and self._split_segment_list_at_position
	local lower_part, upper_part = self:_split_side_neighbours(room.neighbours[split_perp_neg_side], split_pos, split_dim)
	room.neighbours[split_perp_neg_side] = upper_part
	new_room.neighbours[split_perp_neg_side] = lower_part
	mvector3["set_" .. split_perp_dim](split_pos, borders[split_perp_pos_side])
	do
		local (for generator), (for state), (for control) = pairs(expansion[split_perp_pos_side])
		do
			do break end
			local lower_part, upper_part = self:_split_segment_list_at_position(obs_list, split_pos, split_dim)
			expansion[split_perp_pos_side][obs_type] = upper_part
			new_room.expansion[split_perp_pos_side][obs_type] = lower_part
		end

	end

	(for control) = self:_split_segment_list_at_position(obs_list, split_pos, split_dim) and self._split_segment_list_at_position
	local lower_part, upper_part = self:_split_side_neighbours(room.neighbours[split_perp_pos_side], split_pos, split_dim)
	room.neighbours[split_perp_pos_side] = upper_part
	new_room.neighbours[split_perp_pos_side] = lower_part
	local space = {
		Vector3(),
		Vector3()
	}
	mvector3["set_" .. split_dim](space[1], split_pos_along_dim)
	mvector3["set_" .. split_dim](space[2], split_pos_along_dim)
	mvector3["set_" .. split_perp_dim](space[1], borders[split_perp_neg_side])
	mvector3["set_" .. split_perp_dim](space[2], borders[split_perp_pos_side])
	local pos_z = self._get_room_height_at_pos(room.height, borders, space[1])
	mvector3.set_z(space[1], pos_z)
	pos_z = self._get_room_height_at_pos(room.height, borders, space[2])
	mvector3.set_z(space[2], pos_z)
	new_room.expansion[split_side] = {
		spaces = {space},
		walls = {},
		stairs = {},
		cliffs = {},
		unsorted = {}
	}
	new_room.expansion[split_opp_side] = room.expansion[split_opp_side]
	expansion[split_opp_side] = {
		spaces = {
			{
				space[1],
				space[2]
			}
		},
		walls = {},
		stairs = {},
		cliffs = {},
		unsorted = {}
	}
	new_room.neighbours[split_side] = {
		{
			room = i_room,
			overlap = {
				space[1],
				space[2]
			}
		}
	}
	local i_new_room = #self._rooms + 1
	do
		local (for generator), (for state), (for control) = pairs(room.neighbours[split_opp_side])
		do
			do break end
			if self._rooms[neighbour_data.room].neighbours then
				self:_update_neighbour_data(neighbour_data.room, i_room, nil, split_side)
				local new_data = {
					room = i_new_room,
					overlap = {
						neighbour_data.overlap[1],
						neighbour_data.overlap[2]
					}
				}
				self:_append_neighbour(self._rooms[neighbour_data.room].neighbours[split_side], new_data, split_side)
			end

		end

	end

	(for control) = space[1] and self._rooms
	new_room.neighbours[split_opp_side] = room.neighbours[split_opp_side]
	room.neighbours[split_opp_side] = {
		{
			room = i_new_room,
			overlap = {
				space[1],
				space[2]
			}
		}
	}
	new_room.borders[split_side] = split_pos_along_dim
	new_room.borders[split_opp_side] = room.borders[split_opp_side]
	new_room.borders[split_perp_neg_side] = room.borders[split_perp_neg_side]
	new_room.borders[split_perp_pos_side] = room.borders[split_perp_pos_side]
	room.borders[split_opp_side] = split_pos_along_dim
	self:_find_room_height_from_expansion(new_room.expansion, new_room.height, "x_pos")
	self:_find_room_height_from_expansion(room.expansion, room.height, "x_pos")
	room.area = self:_calc_room_area(room.borders)
	new_room.area = self:_calc_room_area(new_room.borders)
	do
		local (for generator), (for state), (for control) = pairs(new_room.neighbours[split_perp_neg_side])
		do
			do break end
			if self._rooms[neighbour_data.room].neighbours then
				self:_update_neighbour_data(neighbour_data.room, i_room, nil, split_perp_pos_side)
				local new_data = {
					room = i_new_room,
					overlap = {
						neighbour_data.overlap[1],
						neighbour_data.overlap[2]
					}
				}
				self:_append_neighbour(self._rooms[neighbour_data.room].neighbours[split_perp_pos_side], new_data, split_perp_pos_side)
			end

		end

	end

	(for control) = room.height and self._rooms
	do
		local (for generator), (for state), (for control) = pairs(new_room.neighbours[split_perp_pos_side])
		do
			do break end
			if self._rooms[neighbour_data.room].neighbours then
				self:_update_neighbour_data(neighbour_data.room, i_room, nil, split_perp_neg_side)
				local new_data = {
					room = i_new_room,
					overlap = {
						neighbour_data.overlap[1],
						neighbour_data.overlap[2]
					}
				}
				self:_append_neighbour(self._rooms[neighbour_data.room].neighbours[split_perp_neg_side], new_data, split_perp_neg_side)
			end

		end

	end

	(for control) = room.height and self._rooms
	do
		local (for generator), (for state), (for control) = pairs(room.neighbours[split_perp_neg_side])
		do
			do break end
			local new_data = {
				room = i_room,
				overlap = {
					neighbour_data.overlap[1],
					neighbour_data.overlap[2]
				}
			}
			self:_update_neighbour_data(neighbour_data.room, i_room, new_data, split_perp_pos_side)
		end

	end

	(for control) = room.height and {
		room = i_room,
		overlap = {
			neighbour_data.overlap[1],
			neighbour_data.overlap[2]
		}
	}
	do
		local (for generator), (for state), (for control) = pairs(room.neighbours[split_perp_pos_side])
		do
			do break end
			local new_data = {
				room = i_room,
				overlap = {
					neighbour_data.overlap[1],
					neighbour_data.overlap[2]
				}
			}
			self:_update_neighbour_data(neighbour_data.room, i_room, new_data, split_perp_neg_side)
		end

	end

	(for control) = room.height and {
		room = i_room,
		overlap = {
			neighbour_data.overlap[1],
			neighbour_data.overlap[2]
		}
	}
	self:_add_room(new_room)
	return i_new_room
end

function NavFieldBuilder:_create_empty_room()
	local room = {}
	room.neighbours = {}
	room.expansion = {}
	room.borders = {}
	room.height = {}
	room.doors = {}
	room.expansion_segments = {}
	do
		local (for generator), (for state), (for control) = pairs(self._perp_neg_dir_str_map)
		do
			do break end
			room.expansion[dir_str] = {
				walls = {},
				spaces = {},
				stairs = {},
				cliffs = {},
				unsorted = {}
			}
			room.expansion_segments[dir_str] = {}
			room.neighbours[dir_str] = {}
			room.doors[dir_str] = {}
		end

	end

end

function NavFieldBuilder:_cleanup_room_data()
	local (for generator), (for state), (for control) = ipairs(self._rooms)
	do
		do break end
		local clean_room = {
			doors = room.doors,
			borders = room.borders,
			height = room.height,
			segment = room.segment
		}
		self._rooms[i_room] = clean_room
	end

end

function NavFieldBuilder:_cleanup_room_data_1()
	local (for generator), (for state), (for control) = ipairs(self._rooms)
	do
		do break end
		room.segment = nil
	end

end

function NavFieldBuilder:_calculate_door_heights()
	local (for generator), (for state), (for control) = ipairs(self._room_doors)
	do
		do break end
		local room_1 = self._rooms[door.rooms[1]]
		local room_2 = self._rooms[door.rooms[2]]
		local room_1_z = self._get_room_height_at_pos(room_1.height, room_1.borders, door.pos)
		local room_2_z = self._get_room_height_at_pos(room_2.height, room_2.borders, door.pos)
		door.pos = door.pos:with_z((room_1_z + room_2_z) * 0.5)
		room_1_z = self._get_room_height_at_pos(room_1.height, room_1.borders, door.pos1)
		room_2_z = self._get_room_height_at_pos(room_2.height, room_2.borders, door.pos1)
		door.pos1 = door.pos1:with_z((room_1_z + room_2_z) * 0.5)
	end

end

function NavFieldBuilder:_calculate_geographic_segment_borders(i_seg)
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

function NavFieldBuilder:_generate_geographic_segments()
	self:_update_progress_bar(8, "Creating geographic segments")
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
	local nr_seg_x = math.ceil((level_limit_x_pos - level_limit_x_neg) / seg_size)
	local nr_seg_y = math.ceil((level_limit_y_pos - level_limit_y_neg) / seg_size)
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
				if self._check_room_overlap_bool(seg_borders, room_borders) then
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

function NavFieldBuilder:_round_pos_to_grid_center(pos)
	local rounded_pos = Vector3()
	mvector3.set_z(rounded_pos, pos.z)
	local round_x = pos.x - pos.x % self._grid_size
	mvector3.set_x(rounded_pos, round_x)
	local round_y = pos.y - pos.y % self._grid_size
	mvector3.set_y(rounded_pos, round_y)
	return rounded_pos
end

function NavFieldBuilder:_add_room(room)
	if not room.area then
		debug_pause("[NavFieldBuilder:_add_room] missing area", inspect(room))
		room.area = 0
	end

	table.insert(self._rooms, room)
end

function NavFieldBuilder:_trash_room(i_room)
-- fail 36
null
19
	local room = self._rooms[i_room]
	if room.doors then
		local (for generator), (for state), (for control) = pairs(room.doors)
		do
			do break end
			local opp_side = self._opposite_side_str[side]
			local (for generator), (for state), (for control) = pairs(door_list)
			do
				do break end
				local door = self._room_doors[i_door]
				local i_neighbour = door.rooms[1] == i_room and door.rooms[2] or door.rooms[1]
				local neigh_doors = self._rooms[i_neighbour].doors[opp_side]
				local (for generator), (for state), (for control) = pairs(neigh_doors)
				do
					do break end
					if i_door == i_neigh_door then
						table.remove(neigh_doors, neigh_door_index)
						self:_destroy_door(i_door)
				end

				else
				end

			end

		end

		(for control) = nil and self._room_doors
	end

	room.trashed = true
	(for control) = nil and self._opposite_side_str
	if room.neighbours then
		local (for generator), (for state), (for control) = pairs(room.neighbours)
		do
			do break end
			local opp_side = self._opposite_side_str[side]
			local (for generator), (for state), (for control) = pairs(neighbour_list)
			do
				do break end
				self:_update_neighbour_data(neighbour_data.room, i_room, nil, opp_side)
			end

		end

		(for control) = nil and self._update_neighbour_data
	end

	(for control) = nil and self._opposite_side_str
	local (for generator), (for state), (for control) = pairs(self._room_doors)
	do
		do break end
		if i_room < door.rooms[1] then
			door.rooms[1] = door.rooms[1] - 1
		end

		if i_room < door.rooms[2] then
			door.rooms[2] = door.rooms[2] - 1
		end

	end

end

function NavFieldBuilder:_destroy_room(i_room)
	table.remove(self._rooms, i_room)
	local (for generator), (for state), (for control) = ipairs(self._rooms)
	do
		do break end
		if not test_room.trashed and test_room.neighbours then
			local (for generator), (for state), (for control) = pairs(test_room.neighbours)
			do
				do break end
				local (for generator), (for state), (for control) = pairs(neighbour_list)
				do
					do break end
					if i_room < neighbour_data.room then
						neighbour_data.room = neighbour_data.room - 1
					end

				end

			end

		end

	end

end

function NavFieldBuilder:_add_door(door)
	table.insert(self._room_doors, door)
	return #self._room_doors
end

function NavFieldBuilder:_destroy_door(i_door)
	table.remove(self._room_doors, i_door)
	local (for generator), (for state), (for control) = ipairs(self._rooms)
	do
		do break end
		local (for generator), (for state), (for control) = pairs(room.doors)
		do
			do break end
			local (for generator), (for state), (for control) = pairs(door_list)
			do
				do break end
				if i_door < i_test_door then
					door_list[door_index] = i_test_door - 1
				end

			end

		end

	end

end

function NavFieldBuilder:_analyse_room(enter_dir_str, enter_pos)
	local opp_dir_str_map = self._opposite_side_str
	local perp_pos_dir_str_map = self._perp_pos_dir_str_map
	local perp_neg_dir_str_map = self._perp_neg_dir_str_map
	local neg_dir_str_map = self._neg_dir_str_map
	local x_dir_str_map = self._x_dir_str_map
	local dir_vec_map = self._dir_str_to_vec
	local room = {}
	room.neighbours = {}
	local expansion = {}
	room.expansion = expansion
	local borders = {}
	room.borders = borders
	local height = {}
	room.height = height
	local expandable_sides_map = {}
	room.inclination = {}
	local expansion_segments = {}
	room.expansion_segments = expansion_segments
	room.doors = {}
	borders.x_pos = enter_pos.x + self._grid_size * 0.5
	borders.x_neg = enter_pos.x - self._grid_size * 0.5
	borders.y_pos = enter_pos.y + self._grid_size * 0.5
	borders.y_neg = enter_pos.y - self._grid_size * 0.5
	do
		local (for generator), (for state), (for control) = pairs(perp_neg_dir_str_map)
		do
			do break end
			room.expansion[dir_str] = {
				walls = {},
				spaces = {},
				stairs = {},
				cliffs = {},
				unsorted = {}
			}
			expansion_segments[dir_str] = {}
			expandable_sides_map[dir_str] = true
			room.neighbours[dir_str] = {}
			room.doors[dir_str] = {}
		end

	end

	(for control) = nil and room.expansion
	self:_measure_init_room_expansion(room, enter_pos)
	local expanding_side = enter_dir_str
	local i_room = #self._rooms + 1
	self:_expand_room_borders(expanding_side, room, expandable_sides_map, i_room)
	self:_fill_room_expansion_segments(room.expansion, expansion_segments, room.neighbours)
	self:_find_room_height_from_expansion(expansion, height, "x_pos")
	room.area = self:_calc_room_area(borders)
	room.segment = self._building.id
	self:_add_room(room)
	if managers.navigation._draw_data then
		managers.navigation:_draw_room(room, true)
	end

	return i_room
end

function NavFieldBuilder:_fill_room_expansion_segments(expansion, expansion_segments, neighbours)
	local (for generator), (for state), (for control) = pairs(expansion)
	do
		do break end
		local perp_dim = self._perp_dim_str_map[side]
		do
			local (for generator), (for state), (for control) = pairs(obs_types.spaces)
			do
				do break end
				table.insert(expansion_segments[side], {
					segment[1],
					segment[2]
				})
			end

		end

		(for control) = nil and table
		do
			local (for generator), (for state), (for control) = pairs(obs_types.stairs)
			do
				do break end
				table.insert(expansion_segments[side], {
					segment[1],
					segment[2]
				})
			end

		end

		(for control) = nil and table
		local (for generator), (for state), (for control) = pairs(neighbours[side])
		do
			do break end
			expansion_segments[side] = self:_remove_seg_from_seg_list(expansion_segments[side], neighbour_data.overlap, perp_dim)
		end

	end

end

function NavFieldBuilder:_create_room_doors(i_room)
	local room = self._rooms[i_room]
	local neighbours = room.neighbours
	local (for generator), (for state), (for control) = pairs(neighbours)
	do
		do break end
		room.doors[side] = room.doors[side] or {}
		local (for generator), (for state), (for control) = pairs(neightbour_list)
		do
			do break end
			local i_neighbour = neightbour_data.room
			local line = neightbour_data.overlap
			local neighbour_room = self._rooms[i_neighbour]
			local door = {}
			if self._neg_dir_str_map[side] then
				door.rooms = {i_neighbour, i_room}
			else
				door.rooms = {i_room, i_neighbour}
			end

			door.pos = neightbour_data.overlap[1]
			door.pos1 = neightbour_data.overlap[2]
			door.center = (door.pos + door.pos1) * 0.5
			local i_door = self:_add_door(door)
			table.insert(room.doors[side], i_door)
			table.insert(neighbour_room.doors[self._opposite_side_str[side]], i_door)
			if self._rooms[i_neighbour].neighbours then
				local (for generator), (for state), (for control) = pairs(self._rooms[i_neighbour].neighbours)
				do
					do break end
					local (for generator), (for state), (for control) = pairs(neighbours_neighbour_list)
					do
						do break end
						if neighbours_neighbour_data.room == i_room then
							table.remove(neighbours_neighbour_list, i_n)
					end

					else
					end

				end

			end

		end

	end

end

function NavFieldBuilder:_expand_room_borders(expanding_side, room, expandable_sides_map, i_room)
	local opp_dir_str_map = self._opposite_side_str
	local perp_pos_dir_str_map = self._perp_pos_dir_str_map
	local perp_neg_dir_str_map = self._perp_neg_dir_str_map
	local neg_dir_str_map = self._neg_dir_str_map
	local x_dir_str_map = self._x_dir_str_map
	local dir_vec_map = self._dir_str_to_vec
	local borders = room.borders
	local expansion = room.expansion
	local neighbours = room.neighbours
	while expanding_side do
		local dir_str = expanding_side
		local exp_data = expansion[dir_str]
		local unsorted_space = exp_data.unsorted and exp_data.unsorted[1] or exp_data.spaces[1]
		if not unsorted_space then
			return
		end

		exp_data.unsorted = nil
		local opp_dir_str = opp_dir_str_map[dir_str]
		local perp_pos_dir_str = perp_pos_dir_str_map[dir_str]
		local perp_neg_dir_str = perp_neg_dir_str_map[dir_str]
		local dir_vec = dir_vec_map[dir_str]
		local expand_dim = self._dim_str_map[dir_str]
		local along_dim = self._perp_dim_str_map[dir_str]
		local res_expansion, expansion_blocked = self:_expansion_check_obstacles(dir_str, dir_vec, unsorted_space, room.inclination)
		if expansion_blocked then
			expansion[dir_str] = res_expansion
			local new_neighbours = self:_expansion_check_neighbours(dir_str, unsorted_space)
			if new_neighbours then
				neighbours[dir_str] = new_neighbours
				local (for generator), (for state), (for control) = pairs(new_neighbours)
				do
					do break end
					local neighbour = self._rooms[neighbour_data.room]
					if neighbour.expansion_segments then
						neighbour.expansion_segments[opp_dir_str] = self:_remove_seg_from_seg_list(neighbour.expansion_segments[opp_dir_str], neighbour_data.overlap, along_dim)
					end

					if neighbour.neighbours then
						local new_data = {
							room = i_room,
							overlap = {
								neighbour_data.overlap[1],
								neighbour_data.overlap[2]
							}
						}
						self:_append_neighbour(neighbour.neighbours[opp_dir_str], new_data, opp_dir_str)
					end

				end

			end

			expandable_sides_map[dir_str] = nil
			(for control) = nil and self._rooms
			if expandable_sides_map[opp_dir_str] then
				expanding_side = opp_dir_str
			elseif expandable_sides_map[perp_neg_dir_str] then
				local is_too_long, is_longest = self:_chk_room_side_too_long(borders, perp_neg_dir_str)
				if not is_too_long then
					expanding_side = perp_neg_dir_str
				end

			elseif expandable_sides_map[perp_pos_dir_str] then
				local is_too_long, is_longest = self:_chk_room_side_too_long(borders, perp_pos_dir_str)
				if not is_too_long then
					expanding_side = perp_pos_dir_str
				end

			else
				expanding_side = nil
			end

		else
			local old_border = borders[dir_str]
			local new_border = self:_calculate_expanded_border(dir_str, old_border, self._grid_size)
			local new_neighbours = self:_expansion_check_neighbours(dir_str, unsorted_space)
			if new_neighbours then
				neighbours[dir_str] = new_neighbours
				expandable_sides_map[dir_str] = nil
				local (for generator), (for state), (for control) = pairs(new_neighbours)
				do
					do break end
					local neighbour = self._rooms[neighbour_data.room]
					if neighbour.expansion_segments then
						neighbour.expansion_segments[opp_dir_str] = self:_remove_seg_from_seg_list(neighbour.expansion_segments[opp_dir_str], neighbour_data.overlap, along_dim)
					end

					if neighbour.neighbours then
						local new_data = {
							room = i_room,
							overlap = {
								neighbour_data.overlap[1],
								neighbour_data.overlap[2]
							}
						}
						self:_append_neighbour(neighbour.neighbours[opp_dir_str], new_data, opp_dir_str)
					end

				end

			end

			do break end
			do
				local (for generator), (for state), (for control) = pairs(res_expansion)
				do
					do break end
					local (for generator), (for state), (for control) = pairs(obstacle_segments)
					do
						do break end
						mvector3["set_" .. expand_dim](obstacle_segment[1], new_border)
						mvector3["set_" .. expand_dim](obstacle_segment[2], new_border)
					end

				end

				(for control) = self and mvector3
			end

			do break end
			expansion[dir_str] = res_expansion
			do break end
			expansion[dir_str].unsorted = res_expansion.spaces
			if not new_neighbours then
				borders[dir_str] = new_border
				local perp_neg_space = {
					Vector3(),
					Vector3()
				}
				mvector3["set_" .. along_dim](perp_neg_space[1], borders[perp_neg_dir_str])
				mvector3["set_" .. along_dim](perp_neg_space[2], borders[perp_neg_dir_str])
				mvector3["set_" .. expand_dim](perp_neg_space[1], math.min(borders[dir_str], old_border))
				mvector3["set_" .. expand_dim](perp_neg_space[2], math.max(borders[dir_str], old_border))
				mvector3.set_z(perp_neg_space[1], unsorted_space[1].z)
				mvector3.set_z(perp_neg_space[2], unsorted_space[1].z)
				local perp_expansion = expansion[perp_neg_dir_str]
				if perp_expansion.unsorted then
					self:_append_seg_to_seg_list(perp_expansion.unsorted, perp_neg_space, expand_dim)
				else
					local res_expansion, expansion_blocked = self:_expansion_check_obstacles(perp_neg_dir_str, dir_vec_map[perp_neg_dir_str], perp_neg_space, room.inclination)
					do
						local (for generator), (for state), (for control) = pairs(res_expansion)
						do
							do break end
							local (for generator), (for state), (for control) = pairs(obstacle_segments)
							do
								do break end
								self:_append_seg_to_seg_list(perp_expansion[obstacle_type], obstacle_segment, expand_dim)
							end

						end

						(for control) = math.max(borders[dir_str], old_border) and self._append_seg_to_seg_list
					end

					do break end
					expandable_sides_map[perp_neg_dir_str] = nil
					local new_neighbours = self:_expansion_check_neighbours(perp_neg_dir_str, perp_neg_space)
					if new_neighbours then
						self:_append_neighbour(neighbours[perp_neg_dir_str], new_neighbours[1], perp_neg_dir_str)
						local neighbour = self._rooms[new_neighbours[1].room]
						if neighbour.expansion_segments then
							neighbour.expansion_segments[perp_pos_dir_str] = self:_remove_seg_from_seg_list(neighbour.expansion_segments[perp_pos_dir_str], new_neighbours[1].overlap, expand_dim)
						end

						if neighbour.neighbours then
							local new_data = {
								room = i_room,
								overlap = {
									new_neighbours[1].overlap[1],
									new_neighbours[1].overlap[2]
								}
							}
							self:_append_neighbour(neighbour.neighbours[perp_pos_dir_str], new_data, perp_pos_dir_str)
						end

					end

				end

				local perp_pos_space = {
					Vector3(),
					Vector3()
				}
				mvector3["set_" .. along_dim](perp_pos_space[1], borders[perp_pos_dir_str])
				mvector3["set_" .. along_dim](perp_pos_space[2], borders[perp_pos_dir_str])
				mvector3["set_" .. expand_dim](perp_pos_space[1], math.min(borders[dir_str], old_border))
				mvector3["set_" .. expand_dim](perp_pos_space[2], math.max(borders[dir_str], old_border))
				mvector3.set_z(perp_pos_space[1], unsorted_space[2].z)
				mvector3.set_z(perp_pos_space[2], unsorted_space[2].z)
				local perp_expansion = expansion[perp_pos_dir_str]
				if perp_expansion.unsorted then
					self:_append_seg_to_seg_list(perp_expansion.unsorted, perp_pos_space, expand_dim)
				else
					local res_expansion, expansion_blocked = self:_expansion_check_obstacles(perp_pos_dir_str, dir_vec_map[perp_pos_dir_str], perp_pos_space, room.inclination)
					do
						local (for generator), (for state), (for control) = pairs(res_expansion)
						do
							do break end
							local (for generator), (for state), (for control) = pairs(obstacle_segments)
							do
								do break end
								self:_append_seg_to_seg_list(perp_expansion[obstacle_type], obstacle_segment, expand_dim)
							end

						end

						(for control) = math.max(borders[dir_str], old_border) and self._append_seg_to_seg_list
					end

					do break end
					expandable_sides_map[perp_pos_dir_str] = nil
					local new_neighbours = self:_expansion_check_neighbours(perp_pos_dir_str, perp_pos_space)
					if new_neighbours then
						self:_append_neighbour(neighbours[perp_pos_dir_str], new_neighbours[1], perp_pos_dir_str)
						local neighbour = self._rooms[new_neighbours[1].room]
						if neighbour.expansion_segments then
							neighbour.expansion_segments[perp_neg_dir_str] = self:_remove_seg_from_seg_list(neighbour.expansion_segments[perp_neg_dir_str], new_neighbours[1].overlap, expand_dim)
						end

						if neighbour.neighbours then
							local new_data = {
								room = i_room,
								overlap = {
									new_neighbours[1].overlap[1],
									new_neighbours[1].overlap[2]
								}
							}
							self:_append_neighbour(neighbour.neighbours[perp_neg_dir_str], new_data, perp_neg_dir_str)
						end

					end

				end

			end

			if new_neighbours then
				if expandable_sides_map[opp_dir_str] then
					expanding_side = opp_dir_str
				elseif expandable_sides_map[perp_neg_dir_str] then
					local is_too_long, is_longest = self:_chk_room_side_too_long(borders, perp_neg_dir_str)
					if not is_too_long then
						expanding_side = perp_neg_dir_str
					end

				elseif expandable_sides_map[perp_pos_dir_str] then
					local is_too_long, is_longest = self:_chk_room_side_too_long(borders, perp_pos_dir_str)
					if not is_too_long then
						expanding_side = perp_pos_dir_str
					end

				else
					expanding_side = nil
				end

			else
				local is_too_long, is_longest = self:_chk_room_side_too_long(borders, dir_str)
				if is_too_long then
					if expandable_sides_map[perp_neg_dir_str] then
						expanding_side = perp_neg_dir_str
					elseif expandable_sides_map[perp_pos_dir_str] then
						expanding_side = perp_pos_dir_str
					else
						expanding_side = nil
					end

				elseif is_longest then
					if expandable_sides_map[perp_neg_dir_str] then
						expanding_side = perp_neg_dir_str
					elseif expandable_sides_map[perp_pos_dir_str] then
						expanding_side = perp_pos_dir_str
					end

				end

			end

		end

	end

	local (for generator), (for state), (for control) = pairs(expandable_sides_map)
	do
		do break end
		if expansion[dir_str].unsorted then
			local expand_seg = expansion[dir_str].unsorted[1]
			local res_expansion, expansion_blocked = self:_expansion_check_obstacles(dir_str, dir_vec_map[dir_str], expand_seg, room.inclination)
			expansion[dir_str] = res_expansion
			local new_neighbours = self:_expansion_check_neighbours(dir_str, expand_seg)
			if new_neighbours then
				neighbours[dir_str] = new_neighbours
				local (for generator), (for state), (for control) = pairs(new_neighbours)
				do
					do break end
					local neighbour = self._rooms[neighbour_data.room]
					if neighbour.expansion_segments then
						neighbour.expansion_segments[opp_dir_str_map[dir_str]] = self:_remove_seg_from_seg_list(neighbour.expansion_segments[opp_dir_str_map[dir_str]], neighbour_data.overlap, self._perp_dim_str_map[dir_str])
					end

					if neighbour.neighbours then
						local new_data = {
							room = i_room,
							overlap = {
								neighbour_data.overlap[1],
								neighbour_data.overlap[2]
							}
						}
						self:_append_neighbour(neighbour.neighbours[opp_dir_str_map[dir_str]], new_data, opp_dir_str_map[dir_str])
					end

				end

			end

			expansion[dir_str].unsorted = self:_calculate_expanded_border(dir_str, old_border, self._grid_size) and nil
		end

	end

end

function NavFieldBuilder:_append_neighbour(neighbours, new_neighbour, dir_str)
	local appended
	local along_dim = self._perp_dim_str_map[dir_str]
	do
		local (for generator), (for state), (for control) = pairs(neighbours)
		do
			do break end
			local i_neighbour = neighbour_data.room
			if new_neighbour.room == i_neighbour then
				appended = true
				if new_neighbour.overlap[1][along_dim] < neighbour_data.overlap[1][along_dim] then
					neighbour_data.overlap[1] = new_neighbour.overlap[1]
				end

				if new_neighbour.overlap[2][along_dim] > neighbour_data.overlap[2][along_dim] then
					neighbour_data.overlap[2] = new_neighbour.overlap[2]
				end

			end

		end

	end

	do break end
	table.insert(neighbours, new_neighbour)
end

function NavFieldBuilder:_update_neighbour_data(i_room, i_neighbour, new_data, dir_str)
	if self._rooms[i_room].neighbours then
		local along_dim = self._perp_dim_str_map[dir_str]
		local neighbours = self._rooms[i_room].neighbours[dir_str]
		do
			local (for generator), (for state), (for control) = pairs(neighbours)
			do
				do break end
				if neighbour_data.room == i_neighbour then
					neighbours[neighbour_index] = nil
				end

			end

		end

		do break end
		table.insert(neighbours, new_data)
	end

end

function NavFieldBuilder:_split_side_neighbours(neighbours_list, split_pos, seg_dim)
	local low_seg_list = {}
	local high_seg_list = {}
	local split_length = split_pos[seg_dim]
	do
		local (for generator), (for state), (for control) = pairs(neighbours_list)
		do
			do break end
			local test_seg = neighbour_data.overlap
			local room = neighbour_data.room
			local test_min = test_seg[1][seg_dim]
			local test_max = test_seg[2][seg_dim]
			local new_segment1, new_segment2
			if split_length <= test_min then
				table.insert(high_seg_list, {overlap = test_seg, room = room})
			elseif split_length >= test_max then
				table.insert(low_seg_list, {overlap = test_seg, room = room})
			else
				local mid_pos = split_pos:with_z(math.lerp(test_seg[1].z, test_seg[2].z, (split_length - test_min) / (test_max - test_min)))
				local new_segment1 = {
					test_seg[1],
					mid_pos
				}
				local new_segment2 = {
					mid_pos,
					test_seg[2]
				}
				table.insert(low_seg_list, {overlap = new_segment1, room = room})
				table.insert(high_seg_list, {overlap = new_segment2, room = room})
			end

		end

	end

	(for control) = nil and neighbour_data.overlap
	return low_seg_list, high_seg_list
end

function NavFieldBuilder:_chk_room_side_too_long(borders, dir_str)
	local exp_side_len = math.abs(borders[dir_str] - borders[self._opposite_side_str[dir_str]])
	local perp_side_len = borders[self._perp_pos_dir_str_map[dir_str]] - borders[self._perp_neg_dir_str_map[dir_str]]
	local room_dim_ratio = exp_side_len / perp_side_len
	return room_dim_ratio >= 2 and exp_side_len >= self._grid_size * 4, room_dim_ratio > 1
end

function NavFieldBuilder:_append_seg_to_seg_list(seg_list, seg, seg_dim)
	local appended, i_app_seg
	do
		local (for generator), (for state), (for control) = pairs(seg_list)
		do
			do break end
			if test_seg[1][seg_dim] == seg[2][seg_dim] then
				test_seg[1] = seg[1]
				appended = 1
				i_app_seg = i_seg
				break
			else
				if test_seg[2][seg_dim] == seg[1][seg_dim] then
					test_seg[2] = seg[2]
					appended = 2
					i_app_seg = i_seg
			end

		end

		else
		end

	end

	do break end
	table.insert(seg_list, {
		seg[1],
		seg[2]
	})
	do break end
	if appended == 1 then
		local app_pos = seg_list[i_app_seg][1][seg_dim]
		local (for generator), (for state), (for control) = pairs(seg_list)
		do
			do break end
			if app_pos <= test_seg[2][seg_dim] and app_pos > test_seg[1][seg_dim] then
				seg_list[i_app_seg][1] = test_seg[1]
				table.remove(seg_list, i_test_seg)
		end

		else
		end

	else
		(for control) = seg[2] and test_seg[2]
		if appended == 2 then
			local app_pos = seg_list[i_app_seg][2][seg_dim]
			local (for generator), (for state), (for control) = pairs(seg_list)
			do
				do break end
				if app_pos >= test_seg[1][seg_dim] and app_pos < test_seg[2][seg_dim] then
					seg_list[i_app_seg][2] = test_seg[2]
					table.remove(seg_list, i_test_seg)
			end

			else
			end

		end

	end

end

function NavFieldBuilder:_remove_seg_from_seg_list(seg_list, seg, seg_dim)
	local new_seg_list = {}
	do
		local (for generator), (for state), (for control) = pairs(seg_list)
		do
			do break end
			local new_segment1, new_segment2
			if seg[1][seg_dim] >= test_seg[2][seg_dim] or seg[2][seg_dim] <= test_seg[1][seg_dim] then
				new_segment1 = test_seg
			elseif test_seg[1][seg_dim] >= seg[1][seg_dim] and test_seg[2][seg_dim] <= seg[2][seg_dim] then
			elseif test_seg[1][seg_dim] < seg[1][seg_dim] and test_seg[2][seg_dim] > seg[2][seg_dim] then
				new_segment1 = {
					test_seg[1],
					seg[1]
				}
				new_segment2 = {
					seg[2],
					test_seg[2]
				}
			elseif test_seg[1][seg_dim] >= seg[1][seg_dim] then
				new_segment1 = {
					seg[2],
					test_seg[2]
				}
			else
				new_segment1 = {
					test_seg[1],
					seg[1]
				}
			end

			if new_segment1 then
				table.insert(new_seg_list, new_segment1)
			end

			if new_segment2 then
				table.insert(new_seg_list, new_segment2)
			end

		end

	end

end

function NavFieldBuilder:_split_segment_list_at_position(seg_list, split_pos, seg_dim)
	local low_seg_list = {}
	local high_seg_list = {}
	local split_length = split_pos[seg_dim]
	do
		local (for generator), (for state), (for control) = pairs(seg_list)
		do
			do break end
			local test_min = test_seg[1][seg_dim]
			local test_max = test_seg[2][seg_dim]
			local new_segment1, new_segment2
			if split_length <= test_min then
				table.insert(high_seg_list, test_seg)
			elseif split_length >= test_max then
				table.insert(low_seg_list, test_seg)
			else
				local mid_pos = split_pos:with_z(math.lerp(test_seg[1].z, test_seg[2].z, (split_length - test_min) / (test_max - test_min)))
				local new_segment1 = {
					test_seg[1],
					mid_pos
				}
				local new_segment2 = {
					mid_pos,
					test_seg[2]
				}
				table.insert(low_seg_list, new_segment1)
				table.insert(high_seg_list, new_segment2)
			end

		end

	end

	(for control) = nil and test_seg[1]
	return low_seg_list, high_seg_list
end

function NavFieldBuilder:_seg_to_seg_list_intersection_bool(seg_list, seg, seg_dim)
	local seg_min = seg[1][seg_dim]
	local seg_max = seg[2][seg_dim]
	local (for generator), (for state), (for control) = pairs(seg_list)
	do
		do break end
		if not (seg_max <= test_seg[1][seg_dim]) and not (seg_min >= test_seg[2][seg_dim]) then
			return true
		end

	end

end

function NavFieldBuilder:_expansion_check_obstacles(dir_str, dir_vec, exp_space, inclination)
	local x_dir_str_map = self._x_dir_str_map
	local expand_dim = self._dim_str_map[dir_str]
	local along_dim = self._perp_dim_str_map[dir_str]
	local grid_size = self._grid_size
	local padding_gnd = self._ground_padding
	local padding_wall = self._wall_padding
	local air_ray_rad = self._air_ray_rad
	local gnd_ray_rad = self._gnd_ray_rad
	local along_vec = Vector3()
	mvector3["set_" .. along_dim](along_vec, grid_size * 0.5)
	local along_vec_inclination = exp_space[2] - exp_space[1]
	mvector3.normalize(along_vec_inclination)
	local inclination_init = inclination[expand_dim]
	if self._neg_dir_str_map[dir_str] then
		inclination_init = -inclination_init
	end

	local step_vec = 2 * along_vec
	local seg_size_grid = (exp_space[2][along_dim] - exp_space[1][along_dim]) / grid_size
	local travel_seg = {
		exp_space[1] + along_vec,
		exp_space[2] - along_vec
	}
	local measuring = {}
	local pos_along_border = travel_seg[1]
	local res_expansion = {
		walls = {},
		stairs = {},
		spaces = {},
		cliffs = {}
	}
	local prev_air_pos
	local i_grid = 0
	repeat
		local obstacle_found
		local back_ground_ray = self:_sphere_ray(pos_along_border + self._up_vec, pos_along_border + self._down_vec, gnd_ray_rad)
		if not back_ground_ray then
			Application:draw_cylinder(pos_along_border + self._up_vec, pos_along_border + self._down_vec, gnd_ray_rad, 1, 0, 0)
			return res_expansion
		end

		local air_pos = pos_along_border:with_z(back_ground_ray.position.z + padding_gnd + air_ray_rad)
		local air_from_pos = air_pos - dir_vec * grid_size
		local air_to_pos = air_pos + dir_vec * (padding_wall + grid_size)
		local air_ray = self:_bundle_ray(air_from_pos, air_to_pos, air_ray_rad)
		if not air_ray then
			local air_from_pos = air_to_pos - dir_vec * (gnd_ray_rad + 2)
			local air_to_pos = air_from_pos - along_vec_inclination:normalized() * (padding_wall + grid_size * 0.5 - 1)
			air_ray = self:_bundle_ray(air_from_pos, air_to_pos, air_ray_rad * 0.8)
		end

		if not air_ray then
			local air_from_pos = air_to_pos - dir_vec * (gnd_ray_rad + 2)
			local air_to_pos = air_from_pos + along_vec_inclination:normalized() * (padding_wall + grid_size * 0.5 - 1)
			air_ray = self:_bundle_ray(air_from_pos, air_to_pos, air_ray_rad * 0.8)
		end

		if air_ray then
			obstacle_found = "walls"
			if air_ray.unit:in_slot(15) then
				self:_on_helper_hit(air_ray.unit)
			end

		else
			local void_ray_rad = grid_size * 0.5
			local ray_rad_dif = gnd_ray_rad - void_ray_rad
			local front_air_pos = air_pos + dir_vec * grid_size * 2 - step_vec * 1.5
			local front_ray = self:_bundle_ray(air_pos, front_air_pos, air_ray_rad)
			local front_gnd_pos = math.step(front_air_pos, air_pos, void_ray_rad + 1)
			if not front_ray then
				-- unhandled boolean indicator
			else
				local front_ground_ray = true
			end

			if front_ray or front_ground_ray and math.abs(front_ground_ray.position.z + ray_rad_dif - back_ground_ray.position.z) < 40 then
				front_air_pos = air_pos + dir_vec * grid_size * 2
				front_ray = self:_bundle_ray(air_pos, front_air_pos, air_ray_rad)
				front_gnd_pos = math.step(front_air_pos, air_pos, void_ray_rad + 1)
				if not front_ray then
					front_ground_ray = self:_sphere_ray(front_gnd_pos + self._up_vec, front_gnd_pos + self._down_vec, void_ray_rad)
				else
					front_ground_ray = false
					front_ground_ray = true
				end

				if front_ray or front_ground_ray and math.abs(front_ground_ray.position.z + ray_rad_dif - back_ground_ray.position.z) < 40 then
					front_air_pos = air_pos + dir_vec * grid_size * 2 + step_vec * 1.5
					front_ray = self:_bundle_ray(air_pos, front_air_pos, air_ray_rad)
					front_gnd_pos = math.step(front_air_pos, air_pos, void_ray_rad + 1)
					if not front_ray then
						front_ground_ray = self:_sphere_ray(front_gnd_pos + self._up_vec, front_gnd_pos + self._down_vec, void_ray_rad)
					else
						front_ground_ray = false
						front_ground_ray = true
					end

					if front_ray or front_ground_ray and math.abs(front_ground_ray.position.z + ray_rad_dif - back_ground_ray.position.z) < 40 then
					else
						obstacle_found = "cliffs"
					end

				else
					obstacle_found = "cliffs"
				end

			else
				obstacle_found = "cliffs"
			end

			if not obstacle_found then
				local front_air_pos = air_pos + dir_vec * grid_size
				local front_ground_ray = self:_sphere_ray(front_air_pos + self._up_vec, front_air_pos + self._down_vec, gnd_ray_rad)
				local climb_vec = front_ground_ray.position - back_ground_ray.position
				local inclination = climb_vec.z / self._grid_size
				local abs_inc_diff = math.abs(inclination_init - inclination)
				if abs_inc_diff > 0.5 then
					obstacle_found = "stairs"
				end

			end

			obstacle_found = obstacle_found or "spaces"
		end

		if measuring[obstacle_found] then
			if i_grid == seg_size_grid - 1 then
				local meas_obs_type = next(measuring)
				local measured_seg = measuring[meas_obs_type]
				measured_seg[2] = pos_along_border + along_vec
				local ground_ray = self:_sphere_ray(pos_along_border + self._up_vec, pos_along_border + self._down_vec, gnd_ray_rad)
				mvector3.set_z(measured_seg[2], ground_ray.position.z)
				table.insert(res_expansion[obstacle_found], measured_seg)
			end

		else
			local meas_obs_type = next(measuring)
			if meas_obs_type then
				local measured_seg = measuring[meas_obs_type]
				measured_seg[2] = pos_along_border - along_vec
				local ground_ray = self:_sphere_ray(pos_along_border + self._up_vec, pos_along_border + self._down_vec, gnd_ray_rad)
				mvector3.set_z(measured_seg[2], ground_ray.position.z)
				table.insert(res_expansion[meas_obs_type], measured_seg)
				measuring[meas_obs_type] = nil
			end

			if i_grid == seg_size_grid - 1 then
				local measured_seg = {
					pos_along_border - along_vec,
					pos_along_border + along_vec
				}
				local ground_ray = self:_sphere_ray(pos_along_border + self._up_vec, pos_along_border + self._down_vec, gnd_ray_rad)
				mvector3.set_z(measured_seg[1], ground_ray.position.z)
				mvector3.set_z(measured_seg[2], ground_ray.position.z)
				table.insert(res_expansion[obstacle_found], measured_seg)
			else
				local new_seg = {
					pos_along_border - along_vec
				}
				local ground_ray = self:_sphere_ray(pos_along_border + self._up_vec, pos_along_border + self._down_vec, gnd_ray_rad)
				mvector3.set_z(new_seg[1], ground_ray.position.z)
				measuring[obstacle_found] = new_seg
			end

		end

		pos_along_border = pos_along_border + step_vec
		i_grid = i_grid + 1
		mvector3.set_z(pos_along_border, math.lerp(travel_seg[1].z, travel_seg[2].z, i_grid / seg_size_grid))
	until seg_size_grid <= i_grid
	return res_expansion, next(res_expansion.walls) or next(res_expansion.stairs) or next(res_expansion.cliffs)
end

function NavFieldBuilder:_expansion_check_neighbours(dir_str, exp_space)
	local opp_dir_str_map = self._opposite_side_str
	local perp_pos_dir_str_map = self._perp_pos_dir_str_map
	local perp_neg_dir_str_map = self._perp_neg_dir_str_map
	local neg_dir_str_map = self._neg_dir_str_map
	local x_dir_str_map = self._x_dir_str_map
	local dir_vec_map = self._dir_str_to_vec
	local dim_str_map = self._dim_str_map
	local perp_dim_str_map = self._perp_dim_str_map
	local expand_dim = dim_str_map[dir_str]
	local along_dim = perp_dim_str_map[dir_str]
	local expand_border = exp_space[1][dim_str_map[dir_str]]
	local expand_seg = {
		exp_space[1][perp_dim_str_map[dir_str]],
		exp_space[2][perp_dim_str_map[dir_str]]
	}
	local neighbours = {}
	local opp_dir_str = opp_dir_str_map[dir_str]
	do
		local (for generator), (for state), (for control) = ipairs(self._rooms)
		do
			do break end
			local test_borders = test_room.borders
			local test_border = test_room.borders[opp_dir_str]
			if expand_border == test_border then
				local test_border_seg = {
					test_borders[perp_neg_dir_str_map[dir_str]],
					test_borders[perp_pos_dir_str_map[dir_str]]
				}
				local overlap_line = self:_chk_line_overlap(test_border_seg, expand_seg)
				if overlap_line then
					local overlap_seg = {
						Vector3(),
						Vector3()
					}
					mvector3["set_" .. dim_str_map[dir_str]](overlap_seg[1], expand_border)
					mvector3["set_" .. perp_dim_str_map[dir_str]](overlap_seg[1], overlap_line[1])
					local z1_test_room = self._get_room_height_at_pos(test_room.height, test_room.borders, overlap_seg[1])
					local z1_exp_room = math.lerp(exp_space[1].z, exp_space[2].z, (overlap_line[1] - exp_space[1][along_dim]) / (exp_space[2][along_dim] - exp_space[1][along_dim]))
					mvector3["set_" .. dim_str_map[dir_str]](overlap_seg[2], expand_border)
					mvector3["set_" .. perp_dim_str_map[dir_str]](overlap_seg[2], overlap_line[2])
					local z2_test_room = self._get_room_height_at_pos(test_room.height, test_room.borders, overlap_seg[2])
					local z2_exp_room = math.lerp(exp_space[1].z, exp_space[2].z, (overlap_line[2] - exp_space[1][along_dim]) / (exp_space[2][along_dim] - exp_space[1][along_dim]))
					local min_h_diff = 150
					if min_h_diff < z1_test_room - z1_exp_room and min_h_diff < z2_test_room - z2_exp_room or z1_test_room - z1_exp_room < -min_h_diff and z2_test_room - z2_exp_room < -min_h_diff then
					else
						mvector3.set_z(overlap_seg[1], (z1_test_room + z1_exp_room) * 0.5)
						mvector3.set_z(overlap_seg[2], (z2_test_room + z2_exp_room) * 0.5)
						table.insert(neighbours, {room = i_room, overlap = overlap_seg})
					end

				end

			end

		end

	end

	(for control) = nil and test_room.borders
	return next(neighbours) and neighbours
end

function NavFieldBuilder:_on_helper_hit(unit)
	local unit_id = unit:unit_data().unit_id
	self._new_blockers[unit_id] = unit
end

function NavFieldBuilder:_set_new_blockers_used()
	do
		local (for generator), (for state), (for control) = pairs(self._new_blockers)
		do
			do break end
			self._helper_blockers[unit_id] = self._building.id
		end

	end

end

function NavFieldBuilder:_disable_blocker(unit)
	local u_id = unit:unit_data().unit_id
	self._disabled_blockers[u_id] = unit
	unit:set_enabled(false)
end

function NavFieldBuilder:_enable_blocker(unit)
	local u_id = unit:unit_data().unit_id
	self._disabled_blockers[u_id] = nil
	unit:set_enabled(true)
end

function NavFieldBuilder:_reenable_all_blockers()
	if self._disabled_blockers then
		local (for generator), (for state), (for control) = pairs(self._disabled_blockers)
		do
			do break end
			if alive(blocker_unit) then
				blocker_unit:set_enabled(true)
			end

		end

	end

end

function NavFieldBuilder:_disable_all_blockers()
	local all_blockers = World:find_units_quick("all", 15)
	self._disabled_blockers = self._disabled_blockers or {}
	local (for generator), (for state), (for control) = ipairs(all_blockers)
	do
		do break end
		self:_disable_blocker(unit)
	end

end

function NavFieldBuilder:_chk_line_overlap(line1, line2)
	local overlap_max = math.min(line1[2], line2[2])
	local overlap_min = math.max(line1[1], line2[1])
	return overlap_max > overlap_min and {overlap_min, overlap_max}
end

function NavFieldBuilder:_measure_init_room_expansion(room, enter_pos)
	local perp_pos_dir_str_map = self._perp_pos_dir_str_map
	local perp_neg_dir_str_map = self._perp_neg_dir_str_map
	local dim_str_map = self._dim_str_map
	local perp_dim_str_map = self._perp_dim_str_map
	local borders = room.borders
	local expansion = room.expansion
	local height = room.height
	local inclination = room.inclination
	do
		local (for generator), (for state), (for control) = pairs(perp_neg_dir_str_map)
		do
			do break end
			local perp_pos_dir_str = perp_pos_dir_str_map[dir_str]
			local dim_str = dim_str_map[dir_str]
			local perp_dim_str = perp_dim_str_map[dir_str]
			local init_space = {
				Vector3(),
				Vector3()
			}
			mvector3["set_" .. dim_str](init_space[1], borders[dir_str])
			mvector3["set_" .. dim_str](init_space[2], borders[dir_str])
			mvector3["set_" .. perp_dim_str](init_space[1], borders[perp_neg_dir_str])
			mvector3["set_" .. perp_dim_str](init_space[2], borders[perp_pos_dir_str])
			mvector3.set_z(init_space[1], enter_pos.z)
			mvector3.set_z(init_space[2], enter_pos.z)
			table.insert(expansion[dir_str].unsorted, init_space)
		end

	end

	(for control) = nil and perp_pos_dir_str_map[dir_str]
	local ray_from_pos = expansion.x_pos.unsorted[1][2]
	local ground_ray = self:_sphere_ray(ray_from_pos + self._up_vec, ray_from_pos + self._down_vec, self._gnd_ray_rad)
	height.xp_yp = ground_ray and ground_ray.position.z or enter_pos.z
	mvector3.set_z(expansion.x_pos.unsorted[1][2], height.xp_yp)
	mvector3.set_z(expansion.y_pos.unsorted[1][2], height.xp_yp)
	local ray_from_pos = expansion.x_pos.unsorted[1][1]
	ground_ray = self:_sphere_ray(ray_from_pos + self._up_vec, ray_from_pos + self._down_vec, self._gnd_ray_rad)
	height.xp_yn = ground_ray and ground_ray.position.z or enter_pos.z
	mvector3.set_z(expansion.x_pos.unsorted[1][1], height.xp_yn)
	mvector3.set_z(expansion.y_neg.unsorted[1][2], height.xp_yn)
	local ray_from_pos = expansion.x_neg.unsorted[1][2]
	ground_ray = self:_sphere_ray(ray_from_pos + self._up_vec, ray_from_pos + self._down_vec, self._gnd_ray_rad)
	height.xn_yp = ground_ray and ground_ray.position.z or enter_pos.z
	mvector3.set_z(expansion.x_neg.unsorted[1][2], height.xn_yp)
	mvector3.set_z(expansion.y_pos.unsorted[1][1], height.xn_yp)
	local ray_from_pos = expansion.x_neg.unsorted[1][1]
	ground_ray = self:_sphere_ray(ray_from_pos + self._up_vec, ray_from_pos + self._down_vec, self._gnd_ray_rad)
	height.xn_yn = ground_ray and ground_ray.position.z or enter_pos.z
	mvector3.set_z(expansion.x_neg.unsorted[1][1], height.xn_yn)
	mvector3.set_z(expansion.y_neg.unsorted[1][1], height.xn_yn)
	local z_x_pos = (height.xp_yp + height.xp_yn) * 0.5
	local z_x_neg = (height.xn_yp + height.xn_yn) * 0.5
	local z_y_pos = (height.xp_yp + height.xn_yp) * 0.5
	local z_y_neg = (height.xp_yn + height.xn_yn) * 0.5
	inclination.x = (z_x_pos - z_x_neg) / self._grid_size
	inclination.y = (z_y_pos - z_y_neg) / self._grid_size
end

function NavFieldBuilder:_calculate_expanded_border(dir_str, border, grid_step)
	return self._neg_dir_str_map[dir_str] and border - grid_step or border + grid_step
end

function NavFieldBuilder:_find_room_height_from_expansion(expansion, height, side)
-- fail 9
null
13
	local y_max, y_min
	do
		local (for generator), (for state), (for control) = pairs(expansion[side])
		do
			do break end
			local (for generator), (for state), (for control) = pairs(obs_list)
			do
				do break end
				if not y_min or y_min > obs_seg[1].y then
					height.xp_yn = obs_seg[1].z
					y_min = obs_seg[1].y
				end

				if not y_max or y_max < obs_seg[2].y then
					height.xp_yp = obs_seg[2].z
					y_max = obs_seg[2].y
				end

			end

		end

	end

	y_max, y_min = nil, nil
	(for control) = nil and pairs
	local (for generator), (for state), (for control) = pairs(expansion[self._opposite_side_str[side]])
	do
		do break end
		local (for generator), (for state), (for control) = pairs(obs_list)
		do
			do break end
			if not y_min or y_min > obs_seg[1].y then
				height.xn_yn = obs_seg[1].z
				y_min = obs_seg[1].y
			end

			if not y_max or y_max < obs_seg[2].y then
				height.xn_yp = obs_seg[2].z
				y_max = obs_seg[2].y
			end

		end

	end

end

function NavFieldBuilder._get_room_height_at_pos(height, borders, pos)
	local lerp_x = (pos.x - borders.x_neg) / (borders.x_pos - borders.x_neg)
	local lerp_y = (pos.y - borders.y_neg) / (borders.y_pos - borders.y_neg)
	local side_x_pos_z = math.lerp(height.xp_yn, height.xp_yp, lerp_y)
	local side_x_neg_z = math.lerp(height.xn_yn, height.xn_yp, lerp_y)
	local plane_z = math.lerp(side_x_neg_z, side_x_pos_z, lerp_x)
	return plane_z
end

function NavFieldBuilder:_ground_ray(air_pos)
	return World:raycast("ray", air_pos, air_pos + self._down_vec, "slot_mask", self._slotmask, "ray_type", "walk")
end

function NavFieldBuilder:_sphere_ray(from, to, raycast_radius)
	return World:raycast("ray", from, to, "slot_mask", self._slotmask, "sphere_cast_radius", raycast_radius, "ray_type", "walk")
end

function NavFieldBuilder:_bundle_ray(from, to, raycast_radius)
	return World:raycast("ray", from, to, "slot_mask", self._slotmask, "sphere_cast_radius", raycast_radius, "bundle", math.max(3, math.ceil(raycast_radius)), "ray_type", "walk")
end

function NavFieldBuilder:_check_line_z_overlap_bool(overlap_room_borders, ext_room_borders, overlap_room_height, ext_room_height, dir_str, clamp_a, segment)
	local is_x = dir_str == "x_pos" or dir_str == "x_neg"
	local seg_pos_1, seg_pos_2
	if is_x then
		seg_pos_1 = Vector3(clamp_a, segment[1], 0)
		seg_pos_2 = Vector3(clamp_a, segment[2], 0)
	else
		seg_pos_1 = Vector3(segment[1], clamp_a, 0)
		seg_pos_2 = Vector3(segment[2], clamp_a, 0)
	end

	local exp_z_1 = self._get_room_height_at_pos(ext_room_height, ext_room_borders, seg_pos_1)
	local exp_z_2 = self._get_room_height_at_pos(ext_room_height, ext_room_borders, seg_pos_2)
	mvector3.set_z(seg_pos_1, exp_z_1)
	mvector3.set_z(seg_pos_2, exp_z_2)
	local overlap_z_1 = self._get_room_height_at_pos(overlap_room_height, overlap_room_borders, seg_pos_1)
	local overlap_z_2 = self._get_room_height_at_pos(overlap_room_height, overlap_room_borders, seg_pos_2)
	local min_h_diff = 150
	if min_h_diff < overlap_z_1 - exp_z_1 and min_h_diff < overlap_z_2 - exp_z_2 or overlap_z_1 - exp_z_1 < -min_h_diff and overlap_z_2 - exp_z_2 < -min_h_diff then
		return false
	end

	return true
end

function NavFieldBuilder._check_room_overlap_bool(rect_1, rect_2)
	return not (rect_1.y_neg > rect_2.y_pos) and not (rect_1.y_pos < rect_2.y_neg) and not (rect_1.x_pos < rect_2.x_neg) and not (rect_1.x_neg > rect_2.x_pos)
end

function NavFieldBuilder:_commence_vis_graph_build()
	if self._building.stage == 1 then
		local i_room_a = self._building.current_i_room_a
		local i_room_b = self._building.current_i_room_b
		local text = "Checking visibility between " .. tostring(i_room_a) .. " and " .. tostring(i_room_b) .. " of " .. tostring(#self._rooms)
		self:_update_progress_bar(1, text)
		local complete = self:_create_room_to_room_visibility_data(self._building)
		if complete then
			self._building.stage = 2
			self._building.current_i_room_a = nil
			self._building.current_i_room_b = nil
			self._building.old_rays = nil
		end

	elseif self._building.stage == 2 then
		self:_update_progress_bar(2, "creating visibility groups")
		self:_create_visibility_groups()
		self._building.stage = 3
	elseif self._building.stage == 3 then
		self:_update_progress_bar(3, "linking visibility groups")
		self:_link_visibility_groups()
		self._room_visibility_data = nil
		self._building.stage = 4
	elseif self._building.stage == 4 then
		self:_update_progress_bar(4, "generating geographic segments")
		self:_generate_geographic_segments()
		self._building.stage = 5
	elseif self._building.stage == 5 then
		self:_update_progress_bar(5, "generating coarse navigation graph")
		self:_generate_coarse_navigation_graph()
		self:_cleanup_room_data_1()
		self:_reenable_all_blockers()
		self._building = false
		self:_destroy_progress_bar()
		self._build_complete_clbk()
	end

end

function NavFieldBuilder:_create_room_to_room_visibility_data(build_data)
	local i_room_a = build_data.current_i_room_a
	local i_room_b = build_data.current_i_room_b
	local all_rooms = self._rooms
	local nr_rooms = #all_rooms
	local room_a = all_rooms[i_room_a]
	local room_b = all_rooms[i_room_b]
	local current_nr_raycasts = 0
	local max_nr_raycasts = 300
	local ray_dis = build_data.ray_dis
	repeat
		local filtered, visibility, nr_raycasts, rays_x_a, rays_y_a, rays_x_b, rays_y_b
		if build_data.new_pair and (build_data.pos_vis_filter or build_data.neg_vis_filter) then
			visibility = self:_chk_room_vis_filter(room_a, room_b, build_data.pos_vis_filter, build_data.neg_vis_filter)
			if visibility ~= nil then
				filtered = true
				nr_raycasts = 1
			end

		end

		local old_rays = build_data.old_rays or {}
		if not filtered then
			visibility, nr_raycasts, rays_x_a, rays_y_a, rays_x_b, rays_y_b = self:_chk_room_to_room_visibility(room_a, room_b, old_rays.x_a or 1, old_rays.y_a or 1, old_rays.x_b or 1, old_rays.y_b or 1, max_nr_raycasts - current_nr_raycasts, ray_dis)
		end

		current_nr_raycasts = current_nr_raycasts + nr_raycasts
		local pair_completed = filtered or visibility or not rays_x_a
		if visibility then
			self:_set_rooms_visible(i_room_a, i_room_b)
		end

		if pair_completed then
			build_data.old_rays = nil
			repeat
				if i_room_b == nr_rooms then
					if not self._room_visibility_data[i_room_a] then
						self._room_visibility_data[i_room_a] = {}
					end

					if i_room_a == #self._rooms - 1 then
						return true
					else
						i_room_a = i_room_a + 1
						i_room_b = i_room_a + 1
						room_a = all_rooms[i_room_a]
						room_b = all_rooms[i_room_b]
					end

				else
					i_room_b = i_room_b + 1
					room_b = all_rooms[i_room_b]
				end

				build_data.new_pair = true
				break
			until i_room_a == nr_rooms
		else
			old_rays.x_a = rays_x_a
			old_rays.y_a = rays_y_a
			old_rays.x_b = rays_x_b
			old_rays.y_b = rays_y_b
			build_data.old_rays = old_rays
			build_data.new_pair = nil
		end

	until current_nr_raycasts == max_nr_raycasts
	build_data.current_i_room_a = i_room_a
	build_data.current_i_room_b = i_room_b
end

function NavFieldBuilder:_chk_room_to_room_visibility(room_a, room_b, old_rays_x_a, old_rays_y_a, old_rays_x_b, old_rays_y_b, nr_raycasts_allowed, ray_dis)
	local borders_a = room_a.borders
	local borders_b = room_b.borders
	local min_ray_dis = ray_dis
	local nr_rays_x_a = math.max(2, 1 + math.floor((borders_a.x_pos - borders_a.x_neg) / min_ray_dis))
	local nr_rays_y_a = math.max(2, 1 + math.floor((borders_a.y_pos - borders_a.y_neg) / min_ray_dis))
	local nr_rays_x_b = math.max(2, 1 + math.floor((borders_b.x_pos - borders_b.x_neg) / min_ray_dis))
	local nr_rays_y_b = math.max(2, 1 + math.floor((borders_b.y_pos - borders_b.y_neg) / min_ray_dis))
	local nr_rays = 0
	local i_ray_x_a = old_rays_x_a
	local i_ray_y_a = old_rays_y_a
	local i_ray_x_b = old_rays_x_b
	local i_ray_y_b = old_rays_y_b
	local pos_from = Vector3()
	local pos_to = Vector3()
	local mvec3_set_static = mvector3.set_static
	local mvec3_set_z = mvector3.set_z
	local m_lerp = math.lerp
	local x_a, x_b, y_a, y_b
	while nr_rays_x_a >= i_ray_x_a do
		x_a = i_ray_x_a == 1 and borders_a.x_neg or i_ray_x_a == nr_rays_x_a and borders_a.x_pos or m_lerp(borders_a.x_neg, borders_a.x_pos, i_ray_x_a / nr_rays_x_a)
		while nr_rays_y_a >= i_ray_y_a do
			y_a = i_ray_y_a == 1 and borders_a.y_neg or i_ray_y_a == nr_rays_y_a and borders_a.y_pos or m_lerp(borders_a.y_neg, borders_a.y_pos, i_ray_y_a / nr_rays_y_a)
			mvec3_set_static(pos_from, x_a, y_a)
			local room_a_z = self._get_room_height_at_pos(room_a.height, room_a.borders, pos_from) + 120
			mvec3_set_z(pos_from, room_a_z)
			while nr_rays_x_b >= i_ray_x_b do
				x_b = i_ray_x_b == 1 and borders_b.x_neg or i_ray_x_b == nr_rays_x_b and borders_b.x_pos or m_lerp(borders_b.x_neg, borders_b.x_pos, i_ray_x_b / nr_rays_x_b)
				while nr_rays_y_b >= i_ray_y_b do
					nr_rays = nr_rays + 1
					y_b = i_ray_y_b == 1 and borders_b.y_neg or i_ray_y_b == nr_rays_y_b and borders_b.y_pos or m_lerp(borders_b.y_neg, borders_b.y_pos, i_ray_y_b / nr_rays_y_b)
					mvec3_set_static(pos_to, x_b, y_b)
					local room_b_z = self._get_room_height_at_pos(room_b.height, room_b.borders, pos_to) + 120
					mvec3_set_z(pos_to, room_b_z)
					local vis_ray = World:raycast("ray", pos_from, pos_to, "slot_mask", self._slotmask, "ray_type", "vis_graph")
					if not vis_ray then
						return true, nr_rays
					elseif nr_rays == nr_raycasts_allowed then
						return false, nr_rays, i_ray_x_a, i_ray_y_a, i_ray_x_b, i_ray_y_b + 1
					end

					i_ray_y_b = i_ray_y_b + 1
				end

				i_ray_y_b = 1
				i_ray_x_b = i_ray_x_b + 1
			end

			i_ray_x_b = 1
			i_ray_y_a = i_ray_y_a + 1
		end

		i_ray_y_a = 1
		i_ray_x_a = i_ray_x_a + 1
	end

	return false, nr_rays
end

function NavFieldBuilder:_set_rooms_visible(i_room_a, i_room_b)
	local room_a = self._rooms[i_room_a]
	local room_b = self._rooms[i_room_b]
	self._room_visibility_data[i_room_a] = self._room_visibility_data[i_room_a] or {}
	self._room_visibility_data[i_room_b] = self._room_visibility_data[i_room_b] or {}
	self._room_visibility_data[i_room_a][i_room_b] = true
	self._room_visibility_data[i_room_b][i_room_a] = true
end

function NavFieldBuilder:_create_visibility_groups(nav_seg_id)
	local all_rooms = self._rooms
	local nav_segments = self._nav_segments
	self._visibility_groups = {}
	local vis_groups = self._visibility_groups
	if nav_seg_id then
		nav_segments[nav_seg_id].vis_groups = {}
	else
		local (for generator), (for state), (for control) = pairs(nav_segments)
		do
			do break end
			nav_seg.vis_groups = {}
		end

	end

	local sorted_vis_list = nil and self:_sort_rooms_according_to_visibility()
	local search_index = #sorted_vis_list
	while search_index > 0 do
		local search_i = sorted_vis_list[search_index].i_room
		if not self._rooms[search_i].vis_group then
			local search_stack = {search_i}
			local searched_rooms = {}
			local room = all_rooms[search_i]
			local pos = self:_calculate_room_center(room)
			local segment = room.segment
			local my_vis_group = {
				rooms = {},
				pos = pos,
				vis_groups = {},
				seg = segment
			}
			table.insert(vis_groups, my_vis_group)
			local i_vis_group = #vis_groups
			table.insert(nav_segments[segment].vis_groups, i_vis_group)
			repeat
				local top_stack_room_i = search_stack[1]
				my_vis_group.rooms[top_stack_room_i] = true
				self:_add_visible_neighbours_to_stack(top_stack_room_i, search_stack, searched_rooms, self._room_visibility_data[top_stack_room_i], my_vis_group.rooms, my_vis_group.pos)
				searched_rooms[top_stack_room_i] = true
				all_rooms[top_stack_room_i].vis_group = i_vis_group
				table.remove(search_stack, 1)
			until not next(search_stack)
		end

		search_index = search_index - 1
	end

end

function NavFieldBuilder:_add_visible_neighbours_to_stack(i_room, search_stack, searched_rooms, vip_list, rooms_in_group, node_pos)
	local rooms = self._rooms
	local room = rooms[i_room]
	local segment = room.segment
	local (for generator), (for state), (for control) = pairs(room.doors)
	do
		do break end
		local (for generator), (for state), (for control) = pairs(door_list)
		do
			do break end
			local door_data = self._room_doors[door_id]
			local i_neighbour_room = door_data.rooms[1] == i_room and door_data.rooms[2] or door_data.rooms[1]
			local neighbour_room = rooms[i_neighbour_room]
			if vip_list[i_neighbour_room] and not searched_rooms[i_neighbour_room] and not neighbour_room.vis_group and segment == neighbour_room.segment then
				local accepted = true
				do
					local (for generator), (for state), (for control) = pairs(rooms_in_group)
					do
						do break end
						if not self._room_visibility_data[i_neighbour_room][i_room] then
							accepted = false
					end

					else
					end

				end

				do break end
				table.insert(search_stack, i_neighbour_room)
			end

		end

	end

end

function NavFieldBuilder:_sort_rooms_according_to_visibility()
	local sorted_vis_list = {}
	do
		local (for generator), (for state), (for control) = ipairs(self._room_visibility_data)
		do
			do break end
			local my_borders = self._rooms[i_room].borders
			local my_total_area = self:_calc_room_area(my_borders)
			local my_data = {i_room = i_room, area = my_total_area}
			local search_index = #sorted_vis_list
			while search_index > 0 and my_total_area < sorted_vis_list[search_index].area do
				search_index = search_index - 1
			end

			table.insert(sorted_vis_list, search_index + 1, my_data)
		end

	end

end

function NavFieldBuilder:_calc_room_area(borders)
	return (borders.x_pos - borders.x_neg) * (borders.y_pos - borders.y_neg)
end

function NavFieldBuilder:_calculate_room_center(room)
	local borders = room.borders
	local pos = Vector3((borders.x_pos + borders.x_neg) * 0.5, (borders.y_pos + borders.y_neg) * 0.5, 0)
	local pos_z = self._get_room_height_at_pos(room.height, borders, pos)
	mvector3.set_z(pos, pos_z)
	return pos
end

function NavFieldBuilder:_link_visibility_groups()
	local (for generator), (for state), (for control) = ipairs(self._visibility_groups)
	do
		do break end
		local (for generator), (for state), (for control) = pairs(group.rooms)
		do
			do break end
			local visible_rooms = self._room_visibility_data[i_room]
			local (for generator), (for state), (for control) = pairs(visible_rooms)
			do
				do break end
				local test_vis_group = self._rooms[i_vis_room].vis_group
				if not group.vis_groups[test_vis_group] and test_vis_group ~= i_group then
					group.vis_groups[test_vis_group] = true
				end

			end

		end

	end

end

function NavFieldBuilder:_generate_coarse_navigation_graph()
	local neg_dir_str = self._neg_dir_str_map
	local all_vis_groups = self._visibility_groups
	local all_segments = self._nav_segments
	local all_rooms = self._rooms
	local all_doors = self._room_doors
	do
		local (for generator), (for state), (for control) = pairs(self._nav_segments)
		do
			do break end
			seg.neighbours = {}
		end

	end

	(for control) = nil and {}
	local (for generator), (for state), (for control) = pairs(self._nav_segments)
	do
		do break end
		local my_discovered_segments = {}
		local neighbours = seg.neighbours
		local vis_groups = seg.vis_groups
		local (for generator), (for state), (for control) = ipairs(vis_groups)
		do
			do break end
			local vis_group = all_vis_groups[i_vis_group]
			if vis_group then
				local group_rooms = vis_group.rooms
				local (for generator), (for state), (for control) = pairs(group_rooms)
				do
					do break end
					local room = all_rooms[i_room]
					local (for generator), (for state), (for control) = pairs(room.doors)
					do
						do break end
						local is_neg = neg_dir_str[dir_str]
						local (for generator), (for state), (for control) = pairs(door_list)
						do
							do break end
							local door = all_doors[id_door]
							local i_neighbour_room = door.rooms[is_neg and 1 or 2]
							local neighbour_seg_id = all_rooms[i_neighbour_room].segment
							if neighbour_seg_id ~= seg_id then
								local neighbour_doors = neighbours[neighbour_seg_id]
								if not neighbour_doors then
									neighbour_doors = {}
									neighbours[neighbour_seg_id] = neighbour_doors
									all_segments[neighbour_seg_id].neighbours[seg_id] = neighbour_doors
									my_discovered_segments[neighbour_seg_id] = true
									table.insert(neighbour_doors, id_door)
								elseif my_discovered_segments[neighbour_seg_id] then
									table.insert(neighbour_doors, id_door)
								end

							end

						end

					end

				end

			end

		end

	end

end

function NavFieldBuilder:set_nav_seg_metadata(nav_seg_id, param_name, param_value)
	if not self._nav_segments then
		return
	end

	local nav_seg = self._nav_segments[nav_seg_id]
	if not nav_seg then
		return
	end

	nav_seg[param_name] = param_value
end

