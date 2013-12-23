-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\navfieldbuilder.luac 

if not NavFieldBuilder then
  NavFieldBuilder = class()
end
NavFieldBuilder._VERSION = 5
NavFieldBuilder.init = function(l_1_0)
  l_1_0._door_access_types = {walk = 1}
  l_1_0._opposite_side_str = {x_pos = "x_neg", x_neg = "x_pos", y_pos = "y_neg", y_neg = "y_pos"}
  l_1_0._perp_pos_dir_str_map = {x_pos = "y_pos", x_neg = "y_pos", y_pos = "x_pos", y_neg = "x_pos"}
  l_1_0._perp_neg_dir_str_map = {x_pos = "y_neg", x_neg = "y_neg", y_pos = "x_neg", y_neg = "x_neg"}
  l_1_0._dim_str_map = {x_pos = "x", x_neg = "x", y_pos = "y", y_neg = "y"}
  l_1_0._perp_dim_str_map = {x_pos = "y", x_neg = "y", y_pos = "x", y_neg = "x"}
  l_1_0._neg_dir_str_map = {x_neg = true, y_neg = true}
  l_1_0._x_dir_str_map = {x_pos = true, x_neg = true}
  l_1_0._dir_str_to_vec = {x_pos = Vector3(1, 0, 0), x_neg = Vector3(-1, 0, 0), y_pos = Vector3(0, 1, 0), y_neg = Vector3(0, -1, 0)}
  l_1_0._ground_padding = 35
  l_1_0._wall_padding = 24
  l_1_0._max_nr_rooms = 20000
  l_1_0._room_height = 70
  l_1_0._grid_size = 25
  l_1_0._air_ray_rad = l_1_0._grid_size * 1.2000000476837
  l_1_0._gnd_ray_rad = l_1_0._grid_size * 0.89999997615814
  l_1_0._room_dimention_max = 1000
  l_1_0._raycast_dis_max = 10000
  l_1_0._max_fall = 800
  l_1_0._up_vec = Vector3(0, 0, l_1_0._ground_padding + l_1_0._grid_size)
  l_1_0._down_vec = Vector3(0, 0, -l_1_0._max_fall)
  l_1_0._slotmask = managers.slot:get_mask("AI_graph_obstacle_check")
  l_1_0._rooms = {}
  l_1_0._room_doors = {}
  l_1_0._visibility_groups = {}
  l_1_0._nav_segments = {}
  l_1_0._geog_segments = {}
  l_1_0._geog_segment_size = 500
  l_1_0._nr_geog_segments = nil
  l_1_0._geog_segment_offset = nil
end

NavFieldBuilder.clear = function(l_2_0)
  l_2_0._geog_segments = {}
  l_2_0._nr_geog_segments = nil
  l_2_0._geog_segment_offset = nil
  l_2_0._rooms = {}
  l_2_0._room_doors = {}
  l_2_0._visibility_groups = {}
  l_2_0._nav_segments = {}
  l_2_0._building = nil
  l_2_0._progress_dialog_cancel = nil
  l_2_0:_reenable_all_blockers()
  l_2_0._helper_blockers = nil
  l_2_0._new_blockers = nil
end

NavFieldBuilder.update = function(l_3_0, l_3_1, l_3_2)
  if l_3_0._building then
    if l_3_0._progress_dialog_cancel then
      l_3_0._progress_dialog_cancel = nil
      l_3_0:clear()
      l_3_0:_destroy_progress_bar()
      l_3_0._building = nil
    else
      l_3_0._building.task_clbk(l_3_0)
    end
  end
end

NavFieldBuilder._create_build_progress_bar = function(l_4_0, l_4_1, l_4_2)
  if not l_4_0._progress_dialog then
    l_4_0._progress_dialog = EWS:ProgressDialog(Global.frame_panel, l_4_1, "", l_4_2, "PD_AUTO_HIDE,PD_SMOOTH,PD_CAN_ABORT,PD_ELAPSED_TIME,PD_ESTIMATED_TIME,PD_REMAINING_TIME")
    l_4_0._progress_dialog:set_focus()
    l_4_0._progress_dialog:update()
  end
end

NavFieldBuilder._destroy_progress_bar = function(l_5_0)
  if l_5_0._progress_dialog then
    l_5_0._progress_dialog:destroy()
    l_5_0._progress_dialog = nil
  end
end

NavFieldBuilder.set_field_data = function(l_6_0, l_6_1)
  for i,k in pairs(l_6_1) do
    l_6_0[i] = k
  end
end

NavFieldBuilder.set_segment_state = function(l_7_0, l_7_1, l_7_2)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_7_0._nav_segments[l_7_1].no_access = true
end

NavFieldBuilder.build_nav_segments = function(l_8_0, l_8_1, l_8_2)
  l_8_0._build_complete_clbk = l_8_2
  local all_vis_groups = l_8_0._visibility_groups
  for i_room,room in ipairs(l_8_0._rooms) do
    if not room.segment then
      room.segment = all_vis_groups[room.vis_group].seg
    end
  end
  for index,segment_settings in ipairs(l_8_1) do
    l_8_0:delete_segment(segment_settings.id)
  end
  l_8_0._nr_geog_segments = nil
  l_8_0:start_build_nav_segment(l_8_1, 1)
end

NavFieldBuilder.build_visibility_graph = function(l_9_0, l_9_1, l_9_2, l_9_3, l_9_4, l_9_5)
  local all_rooms = l_9_0._rooms
  local all_vis_groups = l_9_0._visibility_groups
  for i_room,room in ipairs(all_rooms) do
    if not room.segment then
      room.segment = all_vis_groups[room.vis_group].seg
    end
    room.vis_group = nil
  end
  l_9_0._visibility_groups = {}
  local all_vis_groups = l_9_0._visibility_groups
  if l_9_2 then
    local seg_to_vis_group_map = {}
    local nr_vis_groups = 0
    for nav_seg_id,nav_seg in pairs(l_9_0._nav_segments) do
      local new_vis_group = {rooms = {}, pos = nav_seg.pos, vis_groups = {}, seg = nav_seg_id}
      table.insert(all_vis_groups, new_vis_group)
      nr_vis_groups = nr_vis_groups + 1
      seg_to_vis_group_map[nav_seg_id] = nr_vis_groups
      nav_seg.vis_groups = {nr_vis_groups}
    end
    if nr_vis_groups > 1 then
      for i_vis_group,vis_group in ipairs(all_vis_groups) do
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
    for i_room,room in ipairs(all_rooms) do
      local i_vis_group = seg_to_vis_group_map[room.segment]
      room.vis_group = i_vis_group
      all_vis_groups[i_vis_group].rooms[i_room] = true
    end
    l_9_0:_generate_geographic_segments()
    l_9_0:_generate_coarse_navigation_graph()
    l_9_0:_cleanup_room_data_1(l_9_0)
    l_9_1()
    return 
  end
  l_9_0._build_complete_clbk = l_9_1
  l_9_0._room_visibility_data = {}
  l_9_0:_create_build_progress_bar("Building Visibility Graph", 5)
  l_9_0._building = {}
  l_9_0._building.task_clbk = l_9_0._commence_vis_graph_build
  l_9_0._building.pos_vis_filter = l_9_4
  l_9_0._building.neg_vis_filter = l_9_5
  l_9_0._building.ray_dis = l_9_3
  local nr_rooms = #l_9_0._rooms
  if nr_rooms == 1 then
    l_9_0._building.stage = 2
    l_9_0._room_visibility_data[1] = {}
  else
    local i_room_a = 1
    local i_room_b = 2
    local room_a = all_rooms[i_room_a]
    local room_b = all_rooms[i_room_b]
    l_9_0._building.stage = 1
    l_9_0._building.current_i_room_a = i_room_a
    l_9_0._building.current_i_room_b = i_room_b
    l_9_0._building.new_pair = true
  end
  l_9_0._building.stage = l_9_0._building.stage or 2
end

NavFieldBuilder._chk_room_vis_filter = function(l_10_0, l_10_1, l_10_2, l_10_3, l_10_4)
  local seg_low, seg_high = math.min_max(l_10_1.segment, l_10_2.segment)
  if seg_low == seg_high or l_10_3[seg_low] and l_10_3[seg_low][seg_high] then
    return true
  elseif l_10_4[seg_low] and l_10_4[seg_low][seg_high] then
    return false
  end
  return nil
end

NavFieldBuilder.delete_segment = function(l_11_0, l_11_1)
  local all_vis_groups = l_11_0._visibility_groups
  local all_rooms = l_11_0._rooms
  local all_blockers = l_11_0._helper_blockers
  local i_room = #l_11_0._rooms
  repeat
    if i_room > 0 then
      local room = all_rooms[i_room]
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if room.segment and room.segment == l_11_1 then
        l_11_0:_trash_room(i_room)
        l_11_0:_destroy_room(i_room)
        do return end
        if all_vis_groups[room.vis_group].seg == l_11_1 then
          l_11_0:_trash_room(i_room)
          l_11_0:_destroy_room(i_room)
        end
      end
      i_room = i_room - 1
    else
      local all_nav_segments = l_11_0._nav_segments
      local seg = all_nav_segments[l_11_1]
      if not seg then
        return 
      end
      all_nav_segments[l_11_1] = nil
      for test_seg_id,test_seg in pairs(all_nav_segments) do
        test_seg.neighbours[l_11_1] = nil
      end
      local owned_vis_groups = seg.vis_groups
      local index_owned_vis_group = #owned_vis_groups
      repeat
        repeat
          if index_owned_vis_group > 0 then
            local i_owned_vis_group = owned_vis_groups[index_owned_vis_group]
            print("removing vis group", i_owned_vis_group, "at index", index_owned_vis_group)
            l_11_0:_destroy_vis_group(i_owned_vis_group)
            index_owned_vis_group = index_owned_vis_group - 1
            local i = index_owned_vis_group
            repeat
            until i > 0
            if i_owned_vis_group < owned_vis_groups[i] then
              print("adjusting trash vis_group", owned_vis_groups[i], "at", i)
              owned_vis_groups[i] = owned_vis_groups[i] - 1
            end
            i = i - 1
            do return end
          elseif l_11_0._helper_blockers then
            for u_id,segment in pairs(all_blockers) do
              if segment == l_11_1 then
                all_blockers[u_id] = nil
              end
            end
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NavFieldBuilder._destroy_vis_group = function(l_12_0, l_12_1)
  local all_rooms = l_12_0._rooms
  local all_nav_segments = l_12_0._nav_segments
  local all_vis_groups = l_12_0._visibility_groups
  do
    local vis_group = table.remove(all_vis_groups, l_12_1)
    for i_room,room in ipairs(all_rooms) do
      if room.vis_group and l_12_1 < room.vis_group then
        room.vis_group = room.vis_group - 1
      end
    end
    for i_seg,seg in pairs(all_nav_segments) do
      local owned_vis_groups = seg.vis_groups
      for index_owned_vis_group,i_owned_vis_group in ipairs(owned_vis_groups) do
        if l_12_1 < i_owned_vis_group then
          owned_vis_groups[index_owned_vis_group] = i_owned_vis_group - 1
        end
      end
    end
    for _,test_vis_group in ipairs(all_vis_groups) do
      local visible_vis_groups = test_vis_group.vis_groups
      visible_vis_groups[l_12_1] = nil
      local new_list = {}
      for i_visibile_group,_ in pairs(visible_vis_groups) do
        if l_12_1 < i_visibile_group then
          new_list[i_visibile_group - 1] = true
          for (for control),i_visibile_group in (for generator) do
          end
          new_list[i_visibile_group] = true
        end
        test_vis_group.vis_groups = new_list
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NavFieldBuilder.start_build_nav_segment = function(l_13_0, l_13_1, l_13_2)
  l_13_0:_create_build_progress_bar("Building Navigation Segments", 6)
  local build_seg = l_13_1[l_13_2]
  l_13_0._building = {}
  l_13_0._building.build_settings = l_13_1
  l_13_0._building.segment_index = l_13_2
  l_13_0._building.task_clbk = l_13_0._commence_nav_field_build
  l_13_0._building.stage = 1
  local nav_segment_id = build_seg.id
  l_13_0._building.id = nav_segment_id
  l_13_0._new_blockers = {}
  if not l_13_0._helper_blockers then
    l_13_0._helper_blockers = {}
  end
  if not l_13_0._disabled_blockers then
    l_13_0._disabled_blockers = {}
  end
  l_13_0._nav_segments[nav_segment_id] = {build_seg.strategic_area_id; pos = build_seg.position, vis_groups = {}, neighbours = {}, location_id = build_seg.location_id}
  local all_blockers = World:find_units_quick("all", 15)
  local to_remove = {}
  for u_id,segment in pairs(l_13_0._helper_blockers) do
    local verified = nil
    if segment ~= nav_segment_id then
      for _,blocker_unit in ipairs(all_blockers) do
        local u_id_ = blocker_unit:unit_data().unit_id
        if u_id_ == u_id then
          verified = true
      else
        end
      end
      if not verified then
        table.insert(to_remove, u_id)
      end
    end
    for _,u_id in ipairs(to_remove) do
      l_13_0._helper_blockers[u_id] = nil
    end
    for _,blocker_unit in ipairs(all_blockers) do
      local u_id = blocker_unit:unit_data().unit_id
      local blocker_segment = l_13_0._helper_blockers[u_id]
      if blocker_segment then
        l_13_0:_disable_blocker(blocker_unit)
      end
    end
    local start_pos_rounded = l_13_0:_round_pos_to_grid_center(build_seg.position) + Vector3(l_13_0._grid_size * 0.5, l_13_0._grid_size * 0.5, 0)
    do
      local ground_ray = l_13_0:_sphere_ray(start_pos_rounded + l_13_0._up_vec, start_pos_rounded + l_13_0._down_vec, l_13_0._gnd_ray_rad)
      l_13_0:_analyse_room("x_pos", start_pos_rounded:with_z(ground_ray.position.z))
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NavFieldBuilder._commence_nav_field_build = function(l_14_0)
  if l_14_0._building.stage == 1 then
    l_14_0:_expand_rooms()
  else
    if l_14_0._building.stage == 2 then
      if not l_14_0._building.sorted_rooms then
        l_14_0._building.sorted_rooms = {}
        local build_id = l_14_0._building.id
        for i_room,room in ipairs(l_14_0._rooms) do
          if room.segment == build_id then
            l_14_0:_sort_room_by_area(i_room, l_14_0._building.sorted_rooms)
          end
        end
      end
      l_14_0:_update_progress_bar(2, "Merging Room " .. tostring(l_14_0._building.sorted_rooms[#l_14_0._building.sorted_rooms]))
      local done = l_14_0:_merge_rooms()
      if done then
        if not l_14_0._building.second_pass then
          l_14_0._building.stage = 3
        end
        l_14_0._building.second_pass = nil
        l_14_0._building.sorted_rooms = nil
      else
        if l_14_0._building.stage == 3 then
          for i_room,room in ipairs(l_14_0._rooms) do
            if room.segment == l_14_0._building.id then
              l_14_0:_create_room_doors(i_room)
            end
          end
          l_14_0._building.stage = 4
        else
          if l_14_0._building.stage == 4 then
            l_14_0:_update_progress_bar(3, "Calculating door heights")
            l_14_0:_calculate_door_heights()
            l_14_0._building.stage = 5
          else
            if l_14_0._building.stage == 5 then
              l_14_0:_update_progress_bar(4, "Cleaning Up room_data")
              l_14_0:_cleanup_room_data()
              l_14_0._building.stage = 6
            else
              if l_14_0._building.stage == 6 then
                l_14_0:_set_new_blockers_used()
                l_14_0:_reenable_all_blockers()
                l_14_0:_destroy_progress_bar()
                if l_14_0._building.segment_index == #l_14_0._building.build_settings then
                  l_14_0._building = false
                  l_14_0._build_complete_clbk()
                else
                  l_14_0:start_build_nav_segment(l_14_0._building.build_settings, l_14_0._building.segment_index + 1)
                end
              end
            end
          end
        end
      end
    end
  end
end

NavFieldBuilder._expand_rooms = function(l_15_0)
  local progress = nil
  local can_room_expand = function(l_1_0)
    if l_1_0 then
      for side,seg_list in pairs(l_1_0) do
        if next(seg_list) then
          return true
        end
      end
    end
   end
  local expand_room = function(l_2_0)
    local expansion_data = l_2_0.expansion_segments
    local progress = nil
    for dir_str,exp_dir_data in pairs(expansion_data) do
      for i_segment,segment in pairs(exp_dir_data) do
        if self._max_nr_rooms <= #self._rooms then
          print("!\t\tError. Room # limit exceeded")
          exp_dir_data[i_segment] = nil
        else
          local new_enter_pos = Vector3()
          local size_1 = segment[1][self._perp_dim_str_map[dir_str]] + self._grid_size * 0.5
          local size_2 = l_2_0.borders[dir_str] + (self._neg_dir_str_map[dir_str] and -1 or 1) * self._grid_size * 0.5
          mvector3.set_" .. self._perp_dim_str_map[dir_str(new_enter_pos, size_1)
          mvector3.set_" .. self._dim_str_map[dir_str(new_enter_pos, size_2)
          mvector3.set_z(new_enter_pos, segment[1].z)
          local gnd_ray = self:_sphere_ray(new_enter_pos + self._up_vec, new_enter_pos + self._down_vec, self._gnd_ray_rad)
          if gnd_ray then
            mvector3.set_z(new_enter_pos, gnd_ray.position.z)
          else
            print("! Error. NavFieldBuilder:_expand_rooms() ground ray failed! segment", segment[1], segment[2])
            Application:draw_cylinder(new_enter_pos + self._up_vec, new_enter_pos + self._down_vec, self._gnd_ray_rad, 1, 0, 0)
            managers.navigation:_draw_room(l_2_0, true)
            Application:set_pause(true)
            progress = false
          end
        else
          local new_i_room = self:_analyse_room(dir_str, new_enter_pos)
          local new_room = self._rooms[new_i_room]
          progress = true
          do return end
        end
      end
    end
    if progress then
      do return end
    end
  end
  return progress
   end
  for i_room,room in ipairs(l_15_0._rooms) do
    local expansion_segments = room.expansion_segments
    repeat
      repeat
        if not progress and can_room_expand(expansion_segments) then
          local text = "expanding room " .. tostring(i_room) .. " of " .. tostring(#l_15_0._rooms)
          l_15_0:_update_progress_bar(1, text)
          progress = expand_room(room)
        until progress
        for (for control),i_room in (for generator) do
      else
        end
        if not progress then
          l_15_0._building.stage = 2
          l_15_0._building.second_pass = true
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NavFieldBuilder._merge_rooms = function(l_16_0)
  local _remove_room_from_sorted_list = function(l_1_0, l_1_1)
    for sort_index,sorted_i_room in ipairs(l_1_1) do
      if sorted_i_room == l_1_0 then
        table.remove(l_1_1, sort_index)
    else
      end
    end
   end
  local _dispose_trash_rooms = function(l_2_0, l_2_1)
    for i,i_room in pairs(l_2_0) do
      self:_destroy_room(i_room)
      for next_i,next_i_room in pairs(l_2_0) do
        if i_room < next_i_room then
          l_2_0[next_i] = next_i_room - 1
        end
      end
      _remove_room_from_sorted_list(i_room, l_2_1)
      for sort_index,room_index in ipairs(l_2_1) do
        if i_room < room_index then
          l_2_1[sort_index] = room_index - 1
        end
      end
    end
   end
  local _find_walls_on_side = function(l_3_0, l_3_1)
    local all_doors = self._room_doors
    local borders = l_3_0.borders
    local fwd_border = borders[l_3_1]
    local along_dim = self._perp_dim_str_map[l_3_1]
    local perp_dim = self._dim_str_map[l_3_1]
    local left_corner = Vector3()
    local right_corner = Vector3()
    mvector3.set_" .. along_di(left_corner, borders[self._perp_neg_dir_str_map[l_3_1]])
    mvector3.set_" .. perp_di(left_corner, fwd_border)
    mvector3.set_" .. along_di(right_corner, borders[self._perp_pos_dir_str_map[l_3_1]])
    mvector3.set_" .. perp_di(right_corner, fwd_border)
    local walls = {{left_corner, right_corner}}
    for _,neighbour_data in ipairs(l_3_0.neighbours[l_3_1]) do
      walls = self:_remove_seg_from_seg_list(walls, neighbour_data.overlap, along_dim)
    end
    return walls
   end
  local _get_room_expandable_borders = function(l_4_0)
    local expandable_sides = {}
    do
      local neighbours = l_4_0.neighbours
      for side,obstacle_types in pairs(l_4_0.expansion) do
        local opp_side = self._opposite_side_str[side]
        local dim = self._perp_dim_str_map[side]
        if not next(_find_walls_on_side(l_4_0, side)) then
          local exp_seg = {}
          local neighbour_block = nil
          for _,neighbour_data in pairs(neighbours[side]) do
            local neighbour = self._rooms[neighbour_data.room]
            if neighbour.expansion then
              local neighbour_expansion = neighbour.expansion[opp_side]
            end
            local overlap = neighbour_data.overlap
            if not neighbour_expansion or self:_seg_to_seg_list_intersection_bool(neighbour_expansion.stairs, overlap, dim) then
              neighbour_block = true
              do return end
              for (for control),_ in (for generator) do
              end
              self:_append_seg_to_seg_list(exp_seg, overlap, dim)
            end
            if not neighbour_block and #exp_seg == 1 and exp_seg[1][1][dim] == l_4_0.borders[self._perp_neg_dir_str_map[side]] and exp_seg[1][2][dim] == l_4_0.borders[self._perp_pos_dir_str_map[side]] then
              expandable_sides[side] = true
            end
          end
        end
        return expandable_sides
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  local _is_larger_than_neighbours = function(l_5_0, l_5_1)
    local area = l_5_0.area
    for index_neightbour,neighbour_data in pairs(l_5_0.neighbours[l_5_1]) do
      local i_neighbour_room = neighbour_data.room
      local neighbour_area = self._rooms[i_neighbour_room].area
      if area < neighbour_area then
        return false
      end
    end
    return true
   end
  do
    local sorted_rooms = l_16_0._building.sorted_rooms
    repeat
      if #sorted_rooms > 0 then
        local i_room = sorted_rooms[#sorted_rooms]
        local room = l_16_0._rooms[i_room]
        local expandable_borders = _get_room_expandable_borders(room)
        local exp_border = next(expandable_borders)
        repeat
          repeat
            repeat
              repeat
                repeat
                  if exp_border then
                    if l_16_0:_chk_room_side_too_long(room.borders, exp_border) then
                      if expandable_borders[l_16_0._perp_neg_dir_str_map[exp_border]] then
                        exp_border = l_16_0._perp_neg_dir_str_map[exp_border]
                      else
                        if expandable_borders[l_16_0._perp_pos_dir_str_map[exp_border]] then
                          exp_border = l_16_0._perp_pos_dir_str_map[exp_border]
                      end
                      local border_seg = l_16_0:_get_border_segment(room.height, room.borders, exp_border)
                      local clip_size = l_16_0:_room_expansion_space_at_side(room.borders, exp_border)
                      for index_neighbour,neighbour_data in pairs(room.neighbours[exp_border]) do
                        local neighbour_room = l_16_0._rooms[neighbour_data.room]
                        local neighbour_borders = neighbour_room.borders
                        local neighbour_clip_size = l_16_0:_room_retract_space_at_side(neighbour_room, l_16_0._opposite_side_str[exp_border], border_seg)
                        if neighbour_clip_size < clip_size then
                          clip_size = neighbour_clip_size
                        end
                      end
                      if clip_size > 0 and _is_larger_than_neighbours(room, exp_border) then
                        local new_rooms, trash_rooms, shrunk_rooms = l_16_0:_expand_room_over_neighbours(i_room, exp_border, clip_size)
                        if new_rooms then
                          for _,i_new_room in pairs(new_rooms) do
                            if not l_16_0._rooms[i_new_room].trashed then
                              l_16_0:_sort_room_by_area(i_new_room, sorted_rooms)
                            end
                          end
                        end
                        if shrunk_rooms then
                          for _,i_shrunk_room in pairs(shrunk_rooms) do
                            if not l_16_0._rooms[i_shrunk_room].trashed then
                              l_16_0:_sort_room_by_area(i_shrunk_room, sorted_rooms, true)
                            end
                          end
                        end
                        if trash_rooms then
                          _dispose_trash_rooms(trash_rooms, sorted_rooms)
                          i_room = sorted_rooms[#sorted_rooms]
                          room = l_16_0._rooms[i_room]
                        end
                        expandable_borders = _get_room_expandable_borders(room)
                        exp_border = next(expandable_borders)
                      else
                        expandable_borders[exp_border] = nil
                        if expandable_borders[l_16_0._opposite_side_str[exp_border]] then
                          exp_border = l_16_0._opposite_side_str[exp_border]
                        else
                          if expandable_borders[l_16_0._perp_neg_dir_str_map[exp_border]] then
                            exp_border = l_16_0._perp_neg_dir_str_map[exp_border]
                          else
                            if expandable_borders[l_16_0._perp_pos_dir_str_map[exp_border]] then
                              exp_border = l_16_0._perp_pos_dir_str_map[exp_border]
                            else
                              exp_border = nil
                            end
                          else
                            table.remove(sorted_rooms)
                            return 
                          end
                        else
                          return true
                        end
                         -- Warning: missing end command somewhere! Added here
                      end
                       -- Warning: missing end command somewhere! Added here
                    end
                     -- Warning: missing end command somewhere! Added here
                  end
                   -- Warning: missing end command somewhere! Added here
                end
                 -- Warning: missing end command somewhere! Added here
              end
               -- Warning: missing end command somewhere! Added here
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NavFieldBuilder._sort_room_by_area = function(l_17_0, l_17_1, l_17_2, l_17_3)
  if l_17_3 then
    for sort_index,i_sorted_room in ipairs(l_17_2) do
      if l_17_1 == i_sorted_room then
        table.remove(l_17_2, sort_index)
    else
      end
    end
    local room = l_17_0._rooms[l_17_1]
    local area = room.area
    do
      local search_i = #l_17_2
      repeat
        if search_i > 0 then
          local i_test_room = l_17_2[search_i]
          local test_room = l_17_0._rooms[i_test_room]
          local test_area = test_room.area
          if test_area <= area then
            do return end
          end
          search_i = search_i - 1
        else
          table.insert(l_17_2, search_i + 1, l_17_1)
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NavFieldBuilder._update_progress_bar = function(l_18_0, l_18_1, l_18_2)
  if l_18_0._progress_dialog then
    local result = l_18_0._progress_dialog:update_bar(l_18_1, l_18_2)
    if not result then
      local confirm = EWS:message_box(Global.frame_panel, "Cancel calculation?", "AI", "YES_NO,ICON_QUESTION", Vector3(-1, -1, 0))
      if confirm == "NO" then
        l_18_0._progress_dialog:resume()
        return 
      end
      l_18_0._progress_dialog_cancel = true
    end
  end
end

NavFieldBuilder._get_border_segment = function(l_19_0, l_19_1, l_19_2, l_19_3)
  local seg = {}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  Vector3()[Vector3() .. l_19_0._dim_str_map[l_19_3]](seg[1], l_19_2[l_19_3])
  mvector3.set_" .. l_19_0._dim_str_map[l_19_3(seg[2], l_19_2[l_19_3])
  mvector3.set_" .. l_19_0._perp_dim_str_map[l_19_3(seg[1], l_19_2[l_19_0._perp_neg_dir_str_map[l_19_3]])
  mvector3.set_" .. l_19_0._perp_dim_str_map[l_19_3(seg[2], l_19_2[l_19_0._perp_pos_dir_str_map[l_19_3]])
  local pos_z = l_19_0._get_room_height_at_pos(l_19_1, l_19_2, seg[1])
  mvector3.set_z(seg[1], pos_z)
  local pos_z = l_19_0._get_room_height_at_pos(l_19_1, l_19_2, seg[2])
  mvector3.set_z(seg[2], pos_z)
  return seg
end

NavFieldBuilder._expand_room_over_neighbours = function(l_20_0, l_20_1, l_20_2, l_20_3)
  local room = l_20_0._rooms[l_20_1]
  local neighbours = room.neighbours[l_20_2]
  local expand_vec = l_20_0._dir_str_to_vec[l_20_2] * l_20_3
  local new_rooms, trash_rooms, shrunk_rooms = nil, nil, nil
  repeat
    do
      local new_room = nil
      for index_neighbour,neighbour_data in pairs(neighbours) do
        local clip_segment = neighbour_data.overlap
        new_room = l_20_0:_split_room_for_retraction(neighbour_data.room, l_20_0._opposite_side_str[l_20_2], clip_segment)
        if new_room then
          if not new_rooms then
            new_rooms = {}
          end
          table.insert(new_rooms, new_room)
      else
        end
      end
    until not new_room
  end
  local retract_rooms = {}
  for index_neighbour,neighbour_data in pairs(neighbours) do
    table.insert(retract_rooms, neighbour_data)
  end
  for obs_type,seg_list in pairs(room.expansion[l_20_2]) do
    for i_seg,seg in pairs(seg_list) do
      seg[1] = seg[1] + expand_vec
      seg[2] = seg[2] + expand_vec
    end
  end
  for _,neighbour_data in pairs(retract_rooms) do
    local clip_segment = neighbour_data.overlap
    local want_neg_data = clip_segment[1][l_20_0._perp_dim_str_map[l_20_2]] == room.borders[l_20_0._perp_neg_dir_str_map[l_20_2]]
    local want_pos_data = clip_segment[2][l_20_0._perp_dim_str_map[l_20_2]] == room.borders[l_20_0._perp_pos_dir_str_map[l_20_2]]
    local destroy, new_data = l_20_0:_clip_room_border(neighbour_data.room, l_20_0._opposite_side_str[l_20_2], l_20_3, clip_segment, want_neg_data, want_pos_data)
    if destroy then
      if not trash_rooms then
        trash_rooms = {}
      end
      table.insert(trash_rooms, neighbour_data.room)
    elseif not shrunk_rooms then
      shrunk_rooms = {}
    end
    table.insert(shrunk_rooms, neighbour_data.room)
    if new_data then
      for side,neighbour_list in pairs(new_data.neighbours) do
        for neighbour_index,neighbour_data in pairs(neighbour_list) do
          l_20_0:_append_neighbour(room.neighbours[side], neighbour_data, side)
          if l_20_0._rooms[neighbour_data.room].neighbours then
            local new_data = {room = l_20_1, overlap = {neighbour_data.overlap[1], neighbour_data.overlap[2]}}
            l_20_0:_append_neighbour(l_20_0._rooms[neighbour_data.room].neighbours[l_20_0._opposite_side_str[side]], new_data, l_20_0._opposite_side_str[side])
          end
        end
      end
      if not destroy then
        neighbour_data.overlap[1] = neighbour_data.overlap[1] + expand_vec
        neighbour_data.overlap[2] = neighbour_data.overlap[2] + expand_vec
      end
      if new_data.expansion[l_20_2] then
        for obs_type,seg_list in pairs(new_data.expansion[l_20_2]) do
          for i_seg,seg in pairs(seg_list) do
            for obs_type,old_seg_list in pairs(room.expansion[l_20_2]) do
              room.expansion[l_20_2][obs_type] = l_20_0:_remove_seg_from_seg_list(old_seg_list, seg, l_20_0._perp_dim_str_map[l_20_2])
            end
          end
        end
      end
      for side,obs_data in pairs(new_data.expansion) do
        for obs_type,seg_list in pairs(obs_data) do
          for i_seg,seg in pairs(seg_list) do
            l_20_0:_append_seg_to_seg_list(room.expansion[side][obs_type], seg, l_20_0._perp_dim_str_map[side])
          end
        end
      end
    end
  end
  local new_border = room.borders[l_20_2] + l_20_3 * (l_20_0._neg_dir_str_map[l_20_2] and -1 or 1)
  room.borders[l_20_2] = new_border
  room.area = l_20_0:_calc_room_area(room.borders)
  l_20_0:_find_room_height_from_expansion(room.expansion, room.height, "x_pos")
  return new_rooms, trash_rooms, shrunk_rooms
end

NavFieldBuilder._room_expansion_space_at_side = function(l_21_0, l_21_1, l_21_2)
  local length_size = math.abs(l_21_1[l_21_2] - l_21_1[l_21_0._opposite_side_str[l_21_2]])
  return length_size
end

NavFieldBuilder._room_retract_space_at_side = function(l_22_0, l_22_1, l_22_2, l_22_3)
  local borders = l_22_1.borders
  local expansion = l_22_1.expansion
  local perp_neg_side = l_22_0._perp_neg_dir_str_map[l_22_2]
  local perp_pos_side = l_22_0._perp_pos_dir_str_map[l_22_2]
  local side_dim = l_22_0._dim_str_map[l_22_2]
  local side_perp_dim = l_22_0._perp_dim_str_map[l_22_2]
  local max_obstacle, min_obstacle = nil, nil
  if l_22_3[1][side_perp_dim] < borders[perp_neg_side] then
    for i_seg,seg in pairs(expansion[perp_neg_side].stairs) do
      if not max_obstacle or max_obstacle < seg[2][side_dim] then
        max_obstacle = seg[2][side_dim]
      end
      if not min_obstacle or seg[1][side_dim] < min_obstacle then
        min_obstacle = seg[1][side_dim]
      end
    end
  end
  if borders[perp_pos_side] < l_22_3[2][side_perp_dim] then
    for i_seg,seg in pairs(expansion[perp_pos_side].stairs) do
      if not max_obstacle or max_obstacle < seg[2][side_dim] then
        max_obstacle = seg[2][side_dim]
      end
      if not min_obstacle or seg[1][side_dim] < min_obstacle then
        min_obstacle = seg[1][side_dim]
      end
    end
  end
  local clamp_length = nil
  if l_22_0._neg_dir_str_map[l_22_2] then
    if min_obstacle then
      clamp_length = min_obstacle - borders[l_22_2]
    else
      clamp_length = borders[l_22_0._opposite_side_str[l_22_2]] - borders[l_22_2]
    end
  elseif max_obstacle then
    clamp_length = borders[l_22_2] - max_obstacle
  else
    clamp_length = borders[l_22_2] - borders[l_22_0._opposite_side_str[l_22_2]]
  end
  return clamp_length
end

NavFieldBuilder._split_room_for_retraction = function(l_23_0, l_23_1, l_23_2, l_23_3)
  local room = l_23_0._rooms[l_23_1]
  local borders = room.borders
  local clip_perp_dim = l_23_0._perp_dim_str_map[l_23_2]
  local perp_neg_side = l_23_0._perp_neg_dir_str_map[l_23_2]
  local perp_pos_side = l_23_0._perp_pos_dir_str_map[l_23_2]
  local clip_line = {l_23_3[1][clip_perp_dim], l_23_3[2][clip_perp_dim]}
  local overlaps_neg = clip_line[1] == borders[perp_neg_side]
  local overlaps_pos = clip_line[2] == borders[perp_pos_side]
  if not overlaps_neg or not overlaps_pos then
    if not overlaps_neg or not clip_line[2] then
      local split_pos = clip_line[1]
    end
    local new_i_room = l_23_0:_split_room(l_23_1, split_pos, clip_perp_dim)
    return new_i_room
  end
end

NavFieldBuilder._clip_room_border = function(l_24_0, l_24_1, l_24_2, l_24_3, l_24_4, l_24_5, l_24_6)
  local room = l_24_0._rooms[l_24_1]
  local borders = room.borders
  local neighbours = room.neighbours
  local expansion = room.expansion
  local expansion_segments = room.expansion_segments
  local new_data = {}
  local lower_neighbours = {x_pos = {}, x_neg = {}, y_pos = {}, y_neg = {}}
  local upper_neighbours = {x_pos = {}, x_neg = {}, y_pos = {}, y_neg = {}}
  local is_clip_side_neg = l_24_0._neg_dir_str_map[l_24_2]
  local clip_dim = l_24_0._dim_str_map[l_24_2]
  local clip_perp_dim = l_24_0._perp_dim_str_map[l_24_2]
  local perp_neg_side = l_24_0._perp_neg_dir_str_map[l_24_2]
  local perp_pos_side = l_24_0._perp_pos_dir_str_map[l_24_2]
  local opp_side = l_24_0._opposite_side_str[l_24_2]
  local clip_line = {l_24_4[1][clip_perp_dim], l_24_4[2][clip_perp_dim]}
  local my_length = math.abs(borders[l_24_2] - borders[opp_side])
  if l_24_3 < my_length then
    local lower_expansion_data = {}
    local upper_expansion_data = {}
    lower_expansion_data[perp_neg_side] = {}
    lower_expansion_data[perp_pos_side] = {}
    upper_expansion_data[perp_neg_side] = {}
    upper_expansion_data[perp_pos_side] = {}
    if not l_24_0._neg_dir_str_map[l_24_2] or not borders[l_24_2] + l_24_3 then
      borders[l_24_2] = borders[l_24_2] - l_24_3
    end
    local clip_pos = Vector3()
    mvector3.set_" .. clip_di(clip_pos, borders[l_24_2])
    mvector3.set_" .. clip_perp_di(clip_pos, borders[perp_neg_side])
    for obs_type,obs_list in pairs(expansion[perp_neg_side]) do
      local lower_part, upper_part = l_24_0:_split_segment_list_at_position(obs_list, clip_pos, clip_dim)
      upper_expansion_data[perp_neg_side][obs_type] = upper_part
      lower_expansion_data[perp_neg_side][obs_type] = lower_part
    end
    local lower_part, upper_part = l_24_0:_split_side_neighbours(neighbours[perp_neg_side], clip_pos, clip_dim)
    lower_neighbours[perp_neg_side] = lower_part
    upper_neighbours[perp_neg_side] = upper_part
    mvector3.set_" .. clip_perp_di(clip_pos, borders[perp_pos_side])
    for obs_type,obs_list in pairs(expansion[perp_pos_side]) do
      local lower_part, upper_part = l_24_0:_split_segment_list_at_position(obs_list, clip_pos, clip_dim)
      upper_expansion_data[perp_pos_side][obs_type] = upper_part
      lower_expansion_data[perp_pos_side][obs_type] = lower_part
    end
    local lower_part, upper_part = l_24_0:_split_side_neighbours(neighbours[perp_pos_side], clip_pos, clip_dim)
    lower_neighbours[perp_pos_side] = lower_part
    upper_neighbours[perp_pos_side] = upper_part
    if is_clip_side_neg then
      new_data.expansion = lower_expansion_data
      new_data.neighbours = lower_neighbours
      expansion[perp_neg_side] = upper_expansion_data[perp_neg_side]
      expansion[perp_pos_side] = upper_expansion_data[perp_pos_side]
      for neighbour_index,neighbour_data in pairs(lower_neighbours[perp_neg_side]) do
        l_24_0:_update_neighbour_data(neighbour_data.room, l_24_1, nil, perp_pos_side)
      end
      for neighbour_index,neighbour_data in pairs(lower_neighbours[perp_pos_side]) do
        l_24_0:_update_neighbour_data(neighbour_data.room, l_24_1, nil, perp_neg_side)
      end
      neighbours[perp_neg_side] = upper_neighbours[perp_neg_side]
      neighbours[perp_pos_side] = upper_neighbours[perp_pos_side]
    else
      new_data.expansion = upper_expansion_data
      new_data.neighbours = upper_neighbours
      expansion[perp_neg_side] = lower_expansion_data[perp_neg_side]
      expansion[perp_pos_side] = lower_expansion_data[perp_pos_side]
      for neighbour_index,neighbour_data in pairs(upper_neighbours[perp_neg_side]) do
        l_24_0:_update_neighbour_data(neighbour_data.room, l_24_1, nil, perp_pos_side)
      end
      for neighbour_index,neighbour_data in pairs(upper_neighbours[perp_pos_side]) do
        l_24_0:_update_neighbour_data(neighbour_data.room, l_24_1, nil, perp_neg_side)
      end
      neighbours[perp_neg_side] = lower_neighbours[perp_neg_side]
      neighbours[perp_pos_side] = lower_neighbours[perp_pos_side]
    end
    if not l_24_5 then
      new_data.expansion[perp_neg_side] = {}
      new_data.neighbours[perp_neg_side] = {}
    end
    if not l_24_6 then
      new_data.expansion[perp_pos_side] = {}
      new_data.neighbours[perp_pos_side] = {}
    end
    local mid_space = l_24_0:_get_border_segment(room.height, room.borders, l_24_2)
    expansion[l_24_2].spaces = {mid_space}
    local retract_vec = l_24_0._dir_str_to_vec[opp_side] * l_24_3
    for neighbour_index,neighbour_data in pairs(neighbours[l_24_2]) do
      local overlap = neighbour_data.overlap
      overlap[1] = overlap[1] + retract_vec
      overlap[2] = overlap[2] + retract_vec
    end
    for neighbour_index,neighbour_data in pairs(neighbours[perp_neg_side]) do
      local new_data = {room = l_24_1, overlap = {neighbour_data.overlap[1], neighbour_data.overlap[2]}}
      l_24_0:_update_neighbour_data(neighbour_data.room, l_24_1, new_data, perp_pos_side)
    end
    for neighbour_index,neighbour_data in pairs(neighbours[perp_pos_side]) do
      local new_data = {room = l_24_1, overlap = {neighbour_data.overlap[1], neighbour_data.overlap[2]}}
      l_24_0:_update_neighbour_data(neighbour_data.room, l_24_1, new_data, perp_neg_side)
    end
    room.area = l_24_0:_calc_room_area(borders)
    l_24_0:_find_room_height_from_expansion(expansion, room.height, l_24_2)
  else
    new_data.expansion = {}
    new_data.neighbours = {}
    if l_24_5 then
      new_data.expansion[perp_neg_side] = expansion[perp_neg_side]
      new_data.neighbours[perp_neg_side] = neighbours[perp_neg_side]
    end
    if l_24_6 then
      new_data.expansion[perp_pos_side] = expansion[perp_pos_side]
      new_data.neighbours[perp_pos_side] = neighbours[perp_pos_side]
    end
    new_data.expansion[opp_side] = expansion[opp_side]
    new_data.neighbours[opp_side] = neighbours[opp_side]
    l_24_0:_trash_room(l_24_1)
    return true, new_data
  end
  return false, new_data
end

NavFieldBuilder._split_room = function(l_25_0, l_25_1, l_25_2, l_25_3)
  local room = l_25_0._rooms[l_25_1]
  local borders = room.borders
  local expansion = room.expansion
  local new_room = l_25_0:_create_empty_room()
  new_room.segment = room.segment
  local split_side = l_25_3 == "x" and "x_pos" or "y_pos"
  local split_perp_neg_side = l_25_0._perp_neg_dir_str_map[split_side]
  local split_perp_pos_side = l_25_0._perp_pos_dir_str_map[split_side]
  local split_perp_dim = l_25_0._perp_dim_str_map[split_side]
  local split_opp_side = l_25_0._opposite_side_str[split_side]
  local split_pos = Vector3()
  mvector3.set_" .. l_25_(split_pos, l_25_2)
  mvector3.set_" .. split_perp_di(split_pos, borders[split_perp_neg_side])
  for obs_type,obs_list in pairs(expansion[split_perp_neg_side]) do
    local lower_part, upper_part = l_25_0:_split_segment_list_at_position(obs_list, split_pos, l_25_3)
    expansion[split_perp_neg_side][obs_type] = upper_part
    new_room.expansion[split_perp_neg_side][obs_type] = lower_part
  end
  local lower_part, upper_part = l_25_0:_split_side_neighbours(room.neighbours[split_perp_neg_side], split_pos, l_25_3)
  room.neighbours[split_perp_neg_side] = upper_part
  new_room.neighbours[split_perp_neg_side] = lower_part
  mvector3.set_" .. split_perp_di(split_pos, borders[split_perp_pos_side])
  for obs_type,obs_list in pairs(expansion[split_perp_pos_side]) do
    local lower_part, upper_part = l_25_0:_split_segment_list_at_position(obs_list, split_pos, l_25_3)
    expansion[split_perp_pos_side][obs_type] = upper_part
    new_room.expansion[split_perp_pos_side][obs_type] = lower_part
  end
  local lower_part, upper_part = l_25_0:_split_side_neighbours(room.neighbours[split_perp_pos_side], split_pos, l_25_3)
  room.neighbours[split_perp_pos_side] = upper_part
  new_room.neighbours[split_perp_pos_side] = lower_part
  local space = {}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  Vector3()[Vector3() .. l_25_3](space[1], l_25_2)
  mvector3.set_" .. l_25_(space[2], l_25_2)
  mvector3.set_" .. split_perp_di(space[1], borders[split_perp_neg_side])
  mvector3.set_" .. split_perp_di(space[2], borders[split_perp_pos_side])
  local pos_z = l_25_0._get_room_height_at_pos(room.height, borders, space[1])
  mvector3.set_z(space[1], pos_z)
  pos_z = l_25_0._get_room_height_at_pos(room.height, borders, space[2])
  mvector3.set_z(space[2], pos_z)
  new_room.expansion[split_side] = {spaces = {space}, walls = {}, stairs = {}, cliffs = {}, unsorted = {}}
  new_room.expansion[split_opp_side] = room.expansion[split_opp_side]
  expansion[split_opp_side] = {spaces = {{space[1], space[2]}}, walls = {}, stairs = {}, cliffs = {}, unsorted = {}}
  new_room.neighbours[split_side] = {{room = l_25_1, overlap = {space[1], space[2]}}}
  l_25_0:_add_room(new_room)
  local i_new_room = #l_25_0._rooms
  for neighbour_index,neighbour_data in pairs(room.neighbours[split_opp_side]) do
    if l_25_0._rooms[neighbour_data.room].neighbours then
      l_25_0:_update_neighbour_data(neighbour_data.room, l_25_1, nil, split_side)
      local new_data = {room = i_new_room, overlap = {neighbour_data.overlap[1], neighbour_data.overlap[2]}}
      l_25_0:_append_neighbour(l_25_0._rooms[neighbour_data.room].neighbours[split_side], new_data, split_side)
    end
  end
  new_room.neighbours[split_opp_side] = room.neighbours[split_opp_side]
  room.neighbours[split_opp_side] = {{room = i_new_room, overlap = {space[1], space[2]}}}
  new_room.borders[split_side] = l_25_2
  new_room.borders[split_opp_side] = room.borders[split_opp_side]
  new_room.borders[split_perp_neg_side] = room.borders[split_perp_neg_side]
  new_room.borders[split_perp_pos_side] = room.borders[split_perp_pos_side]
  room.borders[split_opp_side] = l_25_2
  l_25_0:_find_room_height_from_expansion(new_room.expansion, new_room.height, "x_pos")
  l_25_0:_find_room_height_from_expansion(room.expansion, room.height, "x_pos")
  room.area = l_25_0:_calc_room_area(room.borders)
  new_room.area = l_25_0:_calc_room_area(new_room.borders)
  for neighbour_index,neighbour_data in pairs(new_room.neighbours[split_perp_neg_side]) do
    if l_25_0._rooms[neighbour_data.room].neighbours then
      l_25_0:_update_neighbour_data(neighbour_data.room, l_25_1, nil, split_perp_pos_side)
      local new_data = {room = i_new_room, overlap = {neighbour_data.overlap[1], neighbour_data.overlap[2]}}
      l_25_0:_append_neighbour(l_25_0._rooms[neighbour_data.room].neighbours[split_perp_pos_side], new_data, split_perp_pos_side)
    end
  end
  for neighbour_index,neighbour_data in pairs(new_room.neighbours[split_perp_pos_side]) do
    if l_25_0._rooms[neighbour_data.room].neighbours then
      l_25_0:_update_neighbour_data(neighbour_data.room, l_25_1, nil, split_perp_neg_side)
      local new_data = {room = i_new_room, overlap = {neighbour_data.overlap[1], neighbour_data.overlap[2]}}
      l_25_0:_append_neighbour(l_25_0._rooms[neighbour_data.room].neighbours[split_perp_neg_side], new_data, split_perp_neg_side)
    end
  end
  for neighbour_index,neighbour_data in pairs(room.neighbours[split_perp_neg_side]) do
    local new_data = {room = l_25_1, overlap = {neighbour_data.overlap[1], neighbour_data.overlap[2]}}
    l_25_0:_update_neighbour_data(neighbour_data.room, l_25_1, new_data, split_perp_pos_side)
  end
  for neighbour_index,neighbour_data in pairs(room.neighbours[split_perp_pos_side]) do
    local new_data = {room = l_25_1, overlap = {neighbour_data.overlap[1], neighbour_data.overlap[2]}}
    l_25_0:_update_neighbour_data(neighbour_data.room, l_25_1, new_data, split_perp_neg_side)
  end
  return i_new_room
end

NavFieldBuilder._create_empty_room = function(l_26_0)
  local room = {}
  room.neighbours = {}
  room.expansion = {}
  room.borders = {}
  room.height = {}
  room.doors = {}
  room.expansion_segments = {}
  for dir_str,perp_neg_dir_str in pairs(l_26_0._perp_neg_dir_str_map) do
    room.expansion[dir_str] = {walls = {}, spaces = {}, stairs = {}, cliffs = {}, unsorted = {}}
    room.expansion_segments[dir_str] = {}
    room.neighbours[dir_str] = {}
    room.doors[dir_str] = {}
  end
  return room
end

NavFieldBuilder._cleanup_room_data = function(l_27_0)
  for i_room,room in ipairs(l_27_0._rooms) do
    local clean_room = {doors = room.doors, borders = room.borders, height = room.height, segment = room.segment}
    l_27_0._rooms[i_room] = clean_room
  end
end

NavFieldBuilder._cleanup_room_data_1 = function(l_28_0)
  for i_room,room in ipairs(l_28_0._rooms) do
    room.segment = nil
  end
end

NavFieldBuilder._calculate_door_heights = function(l_29_0)
  for i_door,door in ipairs(l_29_0._room_doors) do
    local room_1 = l_29_0._rooms[door.rooms[1]]
    local room_2 = l_29_0._rooms[door.rooms[2]]
    local room_1_z = l_29_0._get_room_height_at_pos(room_1.height, room_1.borders, door.pos)
    local room_2_z = l_29_0._get_room_height_at_pos(room_2.height, room_2.borders, door.pos)
    door.pos = door.pos:with_z((room_1_z + room_2_z) * 0.5)
    room_1_z = l_29_0._get_room_height_at_pos(room_1.height, room_1.borders, door.pos1)
    room_2_z = l_29_0._get_room_height_at_pos(room_2.height, room_2.borders, door.pos1)
    door.pos1 = door.pos1:with_z((room_1_z + room_2_z) * 0.5)
  end
end

NavFieldBuilder._calculate_geographic_segment_borders = function(l_30_0, l_30_1)
  local seg_borders = {}
  local nr_seg_x = l_30_0._nr_geog_segments.x
  local seg_offset = l_30_0._geog_segment_offset
  local seg_size = l_30_0._geog_segment_size
  local grid_coorids = {}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  seg_borders.x_pos = 1 + (l_30_1 - 1) % nr_seg_x + math.ceil(l_30_1 / nr_seg_x) * seg_size
  seg_borders.x_neg = seg_borders.x_pos - seg_size
  seg_borders.y_pos = seg_offset.y + grid_coorids[2] * seg_size
  seg_borders.y_neg = seg_borders.y_pos - seg_size
  return seg_borders
end

NavFieldBuilder._generate_geographic_segments = function(l_31_0)
  l_31_0:_update_progress_bar(8, "Creating geographic segments")
  local tab_ins = table.insert
  local m_ceil = math.ceil
  local segments = {}
  l_31_0._geog_segments = segments
  local seg_size = l_31_0._geog_segment_size
  local level_limit_x_pos = -1000000
  local level_limit_x_neg = 1000000
  local level_limit_y_pos = -1000000
  local level_limit_y_neg = 1000000
  for i_room,room in ipairs(l_31_0._rooms) do
    local borders = room.borders
    if level_limit_x_pos < borders.x_pos then
      level_limit_x_pos = borders.x_pos
    end
    if borders.x_neg < level_limit_x_neg then
      level_limit_x_neg = borders.x_neg
    end
    if level_limit_y_pos < borders.y_pos then
      level_limit_y_pos = borders.y_pos
    end
    if borders.y_neg < level_limit_y_neg then
      level_limit_y_neg = borders.y_neg
    end
  end
  local safety_margin = 0
  level_limit_x_pos = level_limit_x_pos + safety_margin
  level_limit_x_neg = level_limit_x_neg - safety_margin
  level_limit_y_pos = level_limit_y_pos + safety_margin
  level_limit_y_neg = level_limit_y_neg - safety_margin
  l_31_0._geog_segment_offset = Vector3(level_limit_x_neg, level_limit_y_neg, 2000)
  local seg_offset = l_31_0._geog_segment_offset
  local nr_seg_x = math.ceil((level_limit_x_pos - (level_limit_x_neg)) / seg_size)
  local nr_seg_y = math.ceil((level_limit_y_pos - (level_limit_y_neg)) / seg_size)
  l_31_0._nr_geog_segments = {x = nr_seg_x, y = nr_seg_y}
  local i_seg = 1
  repeat
    if i_seg <= nr_seg_x * nr_seg_y then
      local segment = {}
      local seg_borders = l_31_0:_calculate_geographic_segment_borders(i_seg)
      local nr_rooms = 0
      for i_room,room in ipairs(l_31_0._rooms) do
        local room_borders = room.borders
        if l_31_0._check_room_overlap_bool(seg_borders, room_borders) then
          if not segment.rooms then
            segment.rooms = {}
          end
          segment.rooms[i_room] = true
          nr_rooms = nr_rooms + 1
        end
      end
      if next(segment) then
        segments[i_seg] = segment
      end
      i_seg = i_seg + 1
    else
      i_seg = nr_seg_x * nr_seg_y
      repeat
        if i_seg > 0 then
          if segments[i_seg] == false then
            segments[i_seg] = nil
          end
          i_seg = i_seg - 1
        else
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NavFieldBuilder._round_pos_to_grid_center = function(l_32_0, l_32_1)
  local rounded_pos = Vector3()
  mvector3.set_z(rounded_pos, l_32_1.z)
  local round_x = l_32_1.x - l_32_1.x % l_32_0._grid_size
  mvector3.set_x(rounded_pos, round_x)
  local round_y = l_32_1.y - l_32_1.y % l_32_0._grid_size
  mvector3.set_y(rounded_pos, round_y)
  return rounded_pos
end

NavFieldBuilder._add_room = function(l_33_0, l_33_1)
  table.insert(l_33_0._rooms, l_33_1)
end

NavFieldBuilder._trash_room = function(l_34_0, l_34_1)
  do
    local room = l_34_0._rooms[l_34_1]
    if room.doors then
      for side,door_list in pairs(room.doors) do
        local opp_side = l_34_0._opposite_side_str[side]
        for _,i_door in pairs(door_list) do
          local door = l_34_0._room_doors[i_door]
          if door.rooms[1] ~= l_34_1 or not door.rooms[2] then
            local i_neighbour = door.rooms[1]
          end
          local neigh_doors = l_34_0._rooms[i_neighbour].doors[opp_side]
          for neigh_door_index,i_neigh_door in pairs(neigh_doors) do
            if i_door == i_neigh_door then
              table.remove(neigh_doors, neigh_door_index)
              l_34_0:_destroy_door(i_door)
              for (for control),_ in (for generator) do
              end
            end
          end
        end
      end
      room.trashed = true
      if room.neighbours then
        for side,neighbour_list in pairs(room.neighbours) do
          local opp_side = l_34_0._opposite_side_str[side]
          for i_neighbour,neighbour_data in pairs(neighbour_list) do
            l_34_0:_update_neighbour_data(neighbour_data.room, l_34_1, nil, opp_side)
          end
        end
      end
      for i_door,door in pairs(l_34_0._room_doors) do
        if l_34_1 < door.rooms[1] then
          door.rooms[1] = door.rooms[1] - 1
        end
        if l_34_1 < door.rooms[2] then
          door.rooms[2] = door.rooms[2] - 1
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NavFieldBuilder._destroy_room = function(l_35_0, l_35_1)
  table.remove(l_35_0._rooms, l_35_1)
  for i_test_room,test_room in ipairs(l_35_0._rooms) do
    if not test_room.trashed and test_room.neighbours then
      for side,neighbour_list in pairs(test_room.neighbours) do
        for i_neighbour,neighbour_data in pairs(neighbour_list) do
          if l_35_1 < neighbour_data.room then
            neighbour_data.room = neighbour_data.room - 1
          end
        end
      end
    end
  end
end

NavFieldBuilder._add_door = function(l_36_0, l_36_1)
  table.insert(l_36_0._room_doors, l_36_1)
  return #l_36_0._room_doors
end

NavFieldBuilder._destroy_door = function(l_37_0, l_37_1)
  table.remove(l_37_0._room_doors, l_37_1)
  for i_room,room in ipairs(l_37_0._rooms) do
    for side,door_list in pairs(room.doors) do
      for door_index,i_test_door in pairs(door_list) do
        if l_37_1 < i_test_door then
          door_list[door_index] = i_test_door - 1
        end
      end
    end
  end
end

NavFieldBuilder._analyse_room = function(l_38_0, l_38_1, l_38_2)
  local opp_dir_str_map = l_38_0._opposite_side_str
  local perp_pos_dir_str_map = l_38_0._perp_pos_dir_str_map
  local perp_neg_dir_str_map = l_38_0._perp_neg_dir_str_map
  local neg_dir_str_map = l_38_0._neg_dir_str_map
  local x_dir_str_map = l_38_0._x_dir_str_map
  local dir_vec_map = l_38_0._dir_str_to_vec
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
  borders.x_pos = l_38_2.x + l_38_0._grid_size * 0.5
  borders.x_neg = l_38_2.x - l_38_0._grid_size * 0.5
  borders.y_pos = l_38_2.y + l_38_0._grid_size * 0.5
  borders.y_neg = l_38_2.y - l_38_0._grid_size * 0.5
  for dir_str,perp_neg_dir_str in pairs(perp_neg_dir_str_map) do
    room.expansion[dir_str] = {walls = {}, spaces = {}, stairs = {}, cliffs = {}, unsorted = {}}
    expansion_segments[dir_str] = {}
    expandable_sides_map[dir_str] = true
    room.neighbours[dir_str] = {}
    room.doors[dir_str] = {}
  end
  l_38_0:_measure_init_room_expansion(room, l_38_2)
  local expanding_side = l_38_1
  local i_room = #l_38_0._rooms + 1
  l_38_0:_expand_room_borders(expanding_side, room, expandable_sides_map, i_room)
  l_38_0:_fill_room_expansion_segments(room.expansion, expansion_segments, room.neighbours)
  l_38_0:_find_room_height_from_expansion(expansion, height, "x_pos")
  room.area = l_38_0:_calc_room_area(borders)
  room.segment = l_38_0._building.id
  l_38_0:_add_room(room)
  if managers.navigation._draw_data then
    managers.navigation:_draw_room(room, true)
  end
  return i_room
end

NavFieldBuilder._fill_room_expansion_segments = function(l_39_0, l_39_1, l_39_2, l_39_3)
  for side,obs_types in pairs(l_39_1) do
    local perp_dim = l_39_0._perp_dim_str_map[side]
    for i_seg,segment in pairs(obs_types.spaces) do
      table.insert(l_39_2[side], {segment[1], segment[2]})
    end
    for i_seg,segment in pairs(obs_types.stairs) do
      table.insert(l_39_2[side], {segment[1], segment[2]})
    end
    for i_neighbour,neighbour_data in pairs(l_39_3[side]) do
      l_39_2[side] = l_39_0:_remove_seg_from_seg_list(l_39_2[side], neighbour_data.overlap, perp_dim)
    end
  end
end

NavFieldBuilder._create_room_doors = function(l_40_0, l_40_1)
  local room = l_40_0._rooms[l_40_1]
  do
    local neighbours = room.neighbours
    for side,neightbour_list in pairs(neighbours) do
      if not room.doors[side] then
        room.doors[side] = {}
      end
      for neighbour_index,neightbour_data in pairs(neightbour_list) do
        local i_neighbour = neightbour_data.room
        local line = neightbour_data.overlap
        local neighbour_room = l_40_0._rooms[i_neighbour]
        local door = {}
        if l_40_0._neg_dir_str_map[side] then
          door.rooms = {i_neighbour, l_40_1}
          door.room_access = {l_40_0._door_access_types.walk, l_40_0._door_access_types.walk}
        else
          door.rooms = {l_40_1, i_neighbour}
          door.room_access = {l_40_0._door_access_types.walk, l_40_0._door_access_types.walk}
        end
        door.pos = neightbour_data.overlap[1]
        door.pos1 = neightbour_data.overlap[2]
        door.center = (door.pos + door.pos1) * 0.5
        local i_door = l_40_0:_add_door(door)
        table.insert(room.doors[side], i_door)
        table.insert(neighbour_room.doors[l_40_0._opposite_side_str[side]], i_door)
        if l_40_0._rooms[i_neighbour].neighbours then
          for _,neighbours_neighbour_list in pairs(l_40_0._rooms[i_neighbour].neighbours) do
            for i_n,neighbours_neighbour_data in pairs(neighbours_neighbour_list) do
              if neighbours_neighbour_data.room == l_40_1 then
                table.remove(neighbours_neighbour_list, i_n)
                for (for control),_ in (for generator) do
                end
              end
            end
          end
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NavFieldBuilder._expand_room_borders = function(l_41_0, l_41_1, l_41_2, l_41_3, l_41_4)
  local opp_dir_str_map = l_41_0._opposite_side_str
  local perp_pos_dir_str_map = l_41_0._perp_pos_dir_str_map
  local perp_neg_dir_str_map = l_41_0._perp_neg_dir_str_map
  local neg_dir_str_map = l_41_0._neg_dir_str_map
  local x_dir_str_map = l_41_0._x_dir_str_map
  local dir_vec_map = l_41_0._dir_str_to_vec
  local borders = l_41_2.borders
  local expansion = l_41_2.expansion
  do
    local neighbours = l_41_2.neighbours
    repeat
      repeat
        repeat
          repeat
            repeat
              repeat
                repeat
                  repeat
                    repeat
                      repeat
                        repeat
                          repeat
                            repeat
                              repeat
                                repeat
                                  repeat
                                    repeat
                                      repeat
                                        repeat
                                          if l_41_1 then
                                            local dir_str = l_41_1
                                            local exp_data = expansion[dir_str]
                                            if not exp_data.unsorted or not exp_data.unsorted[1] then
                                              local unsorted_space = exp_data.spaces[1]
                                            end
                                            if not unsorted_space then
                                              return 
                                            end
                                            exp_data.unsorted = nil
                                            local opp_dir_str = opp_dir_str_map[dir_str]
                                            local perp_pos_dir_str = perp_pos_dir_str_map[dir_str]
                                            local perp_neg_dir_str = perp_neg_dir_str_map[dir_str]
                                            local dir_vec = dir_vec_map[dir_str]
                                            local expand_dim = l_41_0._dim_str_map[dir_str]
                                            local along_dim = l_41_0._perp_dim_str_map[dir_str]
                                            local res_expansion, expansion_blocked = l_41_0:_expansion_check_obstacles(dir_str, dir_vec, unsorted_space, l_41_2.inclination)
                                            if expansion_blocked then
                                              expansion[dir_str] = res_expansion
                                              local new_neighbours = l_41_0:_expansion_check_neighbours(dir_str, unsorted_space)
                                              if new_neighbours then
                                                neighbours[dir_str] = new_neighbours
                                                for _,neighbour_data in pairs(new_neighbours) do
                                                  local neighbour = l_41_0._rooms[neighbour_data.room]
                                                  if neighbour.expansion_segments then
                                                    neighbour.expansion_segments[opp_dir_str] = l_41_0:_remove_seg_from_seg_list(neighbour.expansion_segments[opp_dir_str], neighbour_data.overlap, along_dim)
                                                  end
                                                  if neighbour.neighbours then
                                                    local new_data = {room = l_41_4, overlap = {neighbour_data.overlap[1], neighbour_data.overlap[2]}}
                                                    l_41_0:_append_neighbour(neighbour.neighbours[opp_dir_str], new_data, opp_dir_str)
                                                  end
                                                end
                                              end
                                              l_41_3[dir_str] = nil
                                              if l_41_3[opp_dir_str] then
                                                l_41_1 = opp_dir_str
                                              elseif l_41_3[perp_neg_dir_str] then
                                                local is_too_long, is_longest = l_41_0:_chk_room_side_too_long(borders, perp_neg_dir_str)
                                              until not is_too_long
                                              l_41_1 = perp_neg_dir_str
                                            elseif l_41_3[perp_pos_dir_str] then
                                              local is_too_long, is_longest = l_41_0:_chk_room_side_too_long(borders, perp_pos_dir_str)
                                            until not is_too_long
                                            l_41_1 = perp_pos_dir_str
                                          else
                                            l_41_1 = nil
                                          end
                                        else
                                          local old_border = borders[dir_str]
                                          local new_border = l_41_0:_calculate_expanded_border(dir_str, old_border, l_41_0._grid_size)
                                          local new_neighbours = l_41_0:_expansion_check_neighbours(dir_str, unsorted_space)
                                          if new_neighbours then
                                            neighbours[dir_str] = new_neighbours
                                            l_41_3[dir_str] = nil
                                            for _,neighbour_data in pairs(new_neighbours) do
                                              local neighbour = l_41_0._rooms[neighbour_data.room]
                                              if neighbour.expansion_segments then
                                                neighbour.expansion_segments[opp_dir_str] = l_41_0:_remove_seg_from_seg_list(neighbour.expansion_segments[opp_dir_str], neighbour_data.overlap, along_dim)
                                              end
                                              if neighbour.neighbours then
                                                local new_data = {room = l_41_4, overlap = {neighbour_data.overlap[1], neighbour_data.overlap[2]}}
                                                l_41_0:_append_neighbour(neighbour.neighbours[opp_dir_str], new_data, opp_dir_str)
                                              end
                                            end
                                          end
                                          if not new_neighbours then
                                            for obstacle_type,obstacle_segments in pairs(res_expansion) do
                                              for i_obs_seg,obstacle_segment in pairs(obstacle_segments) do
                                                mvector3.set_" .. expand_di(obstacle_segment[1], new_border)
                                                mvector3.set_" .. expand_di(obstacle_segment[2], new_border)
                                              end
                                            end
                                          end
                                          if new_neighbours then
                                            expansion[dir_str] = res_expansion
                                          else
                                            expansion[dir_str].unsorted = res_expansion.spaces
                                          end
                                          if not new_neighbours then
                                            borders[dir_str] = new_border
                                            local perp_neg_space = {}
                                             -- DECOMPILER ERROR: Overwrote pending register.

                                             -- DECOMPILER ERROR: Overwrote pending register.

                                            Vector3()[Vector3() .. along_dim](perp_neg_space[1], borders[perp_neg_dir_str])
                                            mvector3.set_" .. along_di(perp_neg_space[2], borders[perp_neg_dir_str])
                                            mvector3.set_" .. expand_di(perp_neg_space[1], math.min(borders[dir_str], old_border))
                                            mvector3.set_" .. expand_di(perp_neg_space[2], math.max(borders[dir_str], old_border))
                                            mvector3.set_z(perp_neg_space[1], unsorted_space[1].z)
                                            mvector3.set_z(perp_neg_space[2], unsorted_space[1].z)
                                            local perp_expansion = expansion[perp_neg_dir_str]
                                            if perp_expansion.unsorted then
                                              l_41_0:_append_seg_to_seg_list(perp_expansion.unsorted, perp_neg_space, expand_dim)
                                            else
                                              local res_expansion, expansion_blocked = l_41_0:_expansion_check_obstacles(perp_neg_dir_str, dir_vec_map[perp_neg_dir_str], perp_neg_space, l_41_2.inclination)
                                              for obstacle_type,obstacle_segments in pairs(res_expansion) do
                                                for i_obs_seg,obstacle_segment in pairs(obstacle_segments) do
                                                  l_41_0:_append_seg_to_seg_list(perp_expansion[obstacle_type], obstacle_segment, expand_dim)
                                                end
                                              end
                                              if expansion_blocked then
                                                l_41_3[perp_neg_dir_str] = nil
                                              end
                                              local new_neighbours = l_41_0:_expansion_check_neighbours(perp_neg_dir_str, perp_neg_space)
                                              if new_neighbours then
                                                l_41_0:_append_neighbour(neighbours[perp_neg_dir_str], new_neighbours[1], perp_neg_dir_str)
                                                local neighbour = l_41_0._rooms[new_neighbours[1].room]
                                                if neighbour.expansion_segments then
                                                  neighbour.expansion_segments[perp_pos_dir_str] = l_41_0:_remove_seg_from_seg_list(neighbour.expansion_segments[perp_pos_dir_str], new_neighbours[1].overlap, expand_dim)
                                                end
                                                if neighbour.neighbours then
                                                  local new_data = {room = l_41_4, overlap = {new_neighbours[1].overlap[1], new_neighbours[1].overlap[2]}}
                                                  l_41_0:_append_neighbour(neighbour.neighbours[perp_pos_dir_str], new_data, perp_pos_dir_str)
                                                end
                                              end
                                            end
                                            local perp_pos_space = {}
                                             -- DECOMPILER ERROR: Overwrote pending register.

                                             -- DECOMPILER ERROR: Overwrote pending register.

                                            Vector3()[Vector3() .. along_dim](perp_pos_space[1], borders[perp_pos_dir_str])
                                            mvector3.set_" .. along_di(perp_pos_space[2], borders[perp_pos_dir_str])
                                            mvector3.set_" .. expand_di(perp_pos_space[1], math.min(borders[dir_str], old_border))
                                            mvector3.set_" .. expand_di(perp_pos_space[2], math.max(borders[dir_str], old_border))
                                            mvector3.set_z(perp_pos_space[1], unsorted_space[2].z)
                                            mvector3.set_z(perp_pos_space[2], unsorted_space[2].z)
                                            local perp_expansion = expansion[perp_pos_dir_str]
                                            if perp_expansion.unsorted then
                                              l_41_0:_append_seg_to_seg_list(perp_expansion.unsorted, perp_pos_space, expand_dim)
                                            else
                                              local res_expansion, expansion_blocked = l_41_0:_expansion_check_obstacles(perp_pos_dir_str, dir_vec_map[perp_pos_dir_str], perp_pos_space, l_41_2.inclination)
                                              for obstacle_type,obstacle_segments in pairs(res_expansion) do
                                                for i_obs_seg,obstacle_segment in pairs(obstacle_segments) do
                                                  l_41_0:_append_seg_to_seg_list(perp_expansion[obstacle_type], obstacle_segment, expand_dim)
                                                end
                                              end
                                              if expansion_blocked then
                                                l_41_3[perp_pos_dir_str] = nil
                                              end
                                              local new_neighbours = l_41_0:_expansion_check_neighbours(perp_pos_dir_str, perp_pos_space)
                                              if new_neighbours then
                                                l_41_0:_append_neighbour(neighbours[perp_pos_dir_str], new_neighbours[1], perp_pos_dir_str)
                                                local neighbour = l_41_0._rooms[new_neighbours[1].room]
                                                if neighbour.expansion_segments then
                                                  neighbour.expansion_segments[perp_neg_dir_str] = l_41_0:_remove_seg_from_seg_list(neighbour.expansion_segments[perp_neg_dir_str], new_neighbours[1].overlap, expand_dim)
                                                end
                                                if neighbour.neighbours then
                                                  local new_data = {room = l_41_4, overlap = {new_neighbours[1].overlap[1], new_neighbours[1].overlap[2]}}
                                                  l_41_0:_append_neighbour(neighbour.neighbours[perp_neg_dir_str], new_data, perp_neg_dir_str)
                                                end
                                              end
                                            end
                                          end
                                          if new_neighbours then
                                            if l_41_3[opp_dir_str] then
                                              l_41_1 = opp_dir_str
                                            elseif l_41_3[perp_neg_dir_str] then
                                              local is_too_long, is_longest = l_41_0:_chk_room_side_too_long(borders, perp_neg_dir_str)
                                            until not is_too_long
                                            l_41_1 = perp_neg_dir_str
                                          elseif l_41_3[perp_pos_dir_str] then
                                            local is_too_long, is_longest = l_41_0:_chk_room_side_too_long(borders, perp_pos_dir_str)
                                          until not is_too_long
                                          l_41_1 = perp_pos_dir_str
                                        else
                                          l_41_1 = nil
                                        end
                                      else
                                        local is_too_long, is_longest = l_41_0:_chk_room_side_too_long(borders, dir_str)
                                        if is_too_long then
                                          if l_41_3[perp_neg_dir_str] then
                                            l_41_1 = perp_neg_dir_str
                                          elseif l_41_3[perp_pos_dir_str] then
                                            l_41_1 = perp_pos_dir_str
                                          else
                                            l_41_1 = nil
                                          end
                                      until is_longest
                                      else
                                        if l_41_3[perp_neg_dir_str] then
                                          l_41_1 = perp_neg_dir_str
                                      until l_41_3[perp_pos_dir_str]
                                      else
                                        l_41_1 = perp_pos_dir_str
                                      end
                                    else
                                      for dir_str,_ in pairs(l_41_3) do
                                        if expansion[dir_str].unsorted then
                                          local expand_seg = expansion[dir_str].unsorted[1]
                                          local res_expansion, expansion_blocked = l_41_0:_expansion_check_obstacles(dir_str, dir_vec_map[dir_str], expand_seg, l_41_2.inclination)
                                          expansion[dir_str] = res_expansion
                                          local new_neighbours = l_41_0:_expansion_check_neighbours(dir_str, expand_seg)
                                          if new_neighbours then
                                            neighbours[dir_str] = new_neighbours
                                            for _,neighbour_data in pairs(new_neighbours) do
                                              local neighbour = l_41_0._rooms[neighbour_data.room]
                                              if neighbour.expansion_segments then
                                                neighbour.expansion_segments[opp_dir_str_map[dir_str]] = l_41_0:_remove_seg_from_seg_list(neighbour.expansion_segments[opp_dir_str_map[dir_str]], neighbour_data.overlap, l_41_0._perp_dim_str_map[dir_str])
                                              end
                                              if neighbour.neighbours then
                                                local new_data = {room = l_41_4, overlap = {neighbour_data.overlap[1], neighbour_data.overlap[2]}}
                                                l_41_0:_append_neighbour(neighbour.neighbours[opp_dir_str_map[dir_str]], new_data, opp_dir_str_map[dir_str])
                                              end
                                            end
                                          end
                                          expansion[dir_str].unsorted = nil
                                        end
                                      end
                                    end
                                     -- Warning: missing end command somewhere! Added here
                                  end
                                   -- Warning: missing end command somewhere! Added here
                                end
                                 -- Warning: missing end command somewhere! Added here
                              end
                               -- Warning: missing end command somewhere! Added here
                            end
                             -- Warning: missing end command somewhere! Added here
                          end
                           -- Warning: missing end command somewhere! Added here
                        end
                         -- Warning: missing end command somewhere! Added here
                      end
                       -- Warning: missing end command somewhere! Added here
                    end
                     -- Warning: missing end command somewhere! Added here
                  end
                   -- Warning: missing end command somewhere! Added here
                end
                 -- Warning: missing end command somewhere! Added here
              end
               -- Warning: missing end command somewhere! Added here
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NavFieldBuilder._append_neighbour = function(l_42_0, l_42_1, l_42_2, l_42_3)
  local appended = nil
  local along_dim = l_42_0._perp_dim_str_map[l_42_3]
  for neighbour_index,neighbour_data in pairs(l_42_1) do
    local i_neighbour = neighbour_data.room
    if l_42_2.room == i_neighbour then
      appended = true
      if l_42_2.overlap[1][along_dim] < neighbour_data.overlap[1][along_dim] then
        neighbour_data.overlap[1] = l_42_2.overlap[1]
      end
      if neighbour_data.overlap[2][along_dim] < l_42_2.overlap[2][along_dim] then
        neighbour_data.overlap[2] = l_42_2.overlap[2]
      end
    end
  end
  if not appended then
    table.insert(l_42_1, l_42_2)
  end
end

NavFieldBuilder._update_neighbour_data = function(l_43_0, l_43_1, l_43_2, l_43_3, l_43_4)
  if l_43_0._rooms[l_43_1].neighbours then
    local along_dim = l_43_0._perp_dim_str_map[l_43_4]
    local neighbours = l_43_0._rooms[l_43_1].neighbours[l_43_4]
    for neighbour_index,neighbour_data in pairs(neighbours) do
      if neighbour_data.room == l_43_2 then
        neighbours[neighbour_index] = nil
      end
    end
    if l_43_3 then
      table.insert(neighbours, l_43_3)
    end
  end
end

NavFieldBuilder._split_side_neighbours = function(l_44_0, l_44_1, l_44_2, l_44_3)
  local low_seg_list = {}
  local high_seg_list = {}
  do
    local split_length = l_44_2[l_44_3]
    for index_neighbour,neighbour_data in pairs(l_44_1) do
      local test_seg = neighbour_data.overlap
      local room = neighbour_data.room
      local test_min = test_seg[1][l_44_3]
      local test_max = test_seg[2][l_44_3]
      local new_segment1, new_segment2 = nil, nil
      if split_length <= test_min then
        table.insert(high_seg_list, {overlap = test_seg, room = room})
        for (for control),index_neighbour in (for generator) do
        end
        if test_max <= split_length then
          table.insert(low_seg_list, {overlap = test_seg, room = room})
          for (for control),index_neighbour in (for generator) do
          end
          local mid_pos = l_44_2:with_z(math.lerp(test_seg[1].z, test_seg[2].z, (split_length - test_min) / (test_max - test_min)))
          local new_segment1 = {test_seg[1], mid_pos}
          local new_segment2 = {mid_pos, test_seg[2]}
          table.insert(low_seg_list, {overlap = new_segment1, room = room})
          table.insert(high_seg_list, {overlap = new_segment2, room = room})
        end
        return low_seg_list, high_seg_list
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NavFieldBuilder._chk_room_side_too_long = function(l_45_0, l_45_1, l_45_2)
  local exp_side_len = math.abs(l_45_1[l_45_2] - l_45_1[l_45_0._opposite_side_str[l_45_2]])
  local perp_side_len = l_45_1[l_45_0._perp_pos_dir_str_map[l_45_2]] - l_45_1[l_45_0._perp_neg_dir_str_map[l_45_2]]
  local room_dim_ratio = exp_side_len / perp_side_len
  return room_dim_ratio >= 2 and l_45_0._grid_size * 4 <= exp_side_len, room_dim_ratio > 1
end

NavFieldBuilder._append_seg_to_seg_list = function(l_46_0, l_46_1, l_46_2, l_46_3)
  local appended, i_app_seg = nil, nil
  for i_seg,test_seg in pairs(l_46_1) do
    if test_seg[1][l_46_3] == l_46_2[2][l_46_3] then
      test_seg[1] = l_46_2[1]
      appended = 1
      i_app_seg = i_seg
      do return end
      for (for control),i_seg in (for generator) do
      end
      if test_seg[2][l_46_3] == l_46_2[1][l_46_3] then
        test_seg[2] = l_46_2[2]
        appended = 2
        i_app_seg = i_seg
    else
      end
    end
    if not appended then
      table.insert(l_46_1, {l_46_2[1], l_46_2[2]})
    elseif appended == 1 then
      local app_pos = l_46_1[i_app_seg][1][l_46_3]
      for i_test_seg,test_seg in pairs(l_46_1) do
        if app_pos <= test_seg[2][l_46_3] and test_seg[1][l_46_3] < app_pos then
          l_46_1[i_app_seg][1] = test_seg[1]
          table.remove(l_46_1, i_test_seg)
      else
        end
      end
    elseif appended == 2 then
      local app_pos = l_46_1[i_app_seg][2][l_46_3]
      for i_test_seg,test_seg in pairs(l_46_1) do
        if test_seg[1][l_46_3] <= app_pos and app_pos < test_seg[2][l_46_3] then
          l_46_1[i_app_seg][2] = test_seg[2]
          table.remove(l_46_1, i_test_seg)
      else
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NavFieldBuilder._remove_seg_from_seg_list = function(l_47_0, l_47_1, l_47_2, l_47_3)
  local new_seg_list = {}
  for i_seg,test_seg in pairs(l_47_1) do
    local new_segment1, new_segment2 = nil, nil
    if test_seg[2][l_47_3] <= l_47_2[1][l_47_3] or l_47_2[2][l_47_3] <= test_seg[1][l_47_3] then
      new_segment1 = test_seg
    else
      if l_47_2[1][l_47_3] <= test_seg[1][l_47_3] and test_seg[2][l_47_3] <= l_47_2[2][l_47_3] then
        do return end
      end
      if test_seg[1][l_47_3] < l_47_2[1][l_47_3] and l_47_2[2][l_47_3] < test_seg[2][l_47_3] then
        new_segment1 = {test_seg[1], l_47_2[1]}
        new_segment2 = {l_47_2[2], test_seg[2]}
      else
        if l_47_2[1][l_47_3] <= test_seg[1][l_47_3] then
          new_segment1 = {l_47_2[2], test_seg[2]}
        else
          new_segment1 = {test_seg[1], l_47_2[1]}
        end
      end
    end
    if new_segment1 then
      table.insert(new_seg_list, new_segment1)
    end
    if new_segment2 then
      table.insert(new_seg_list, new_segment2)
    end
  end
  return new_seg_list
end

NavFieldBuilder._split_segment_list_at_position = function(l_48_0, l_48_1, l_48_2, l_48_3)
  local low_seg_list = {}
  local high_seg_list = {}
  do
    local split_length = l_48_2[l_48_3]
    for i_seg,test_seg in pairs(l_48_1) do
      local test_min = test_seg[1][l_48_3]
      local test_max = test_seg[2][l_48_3]
      local new_segment1, new_segment2 = nil, nil
      if split_length <= test_min then
        table.insert(high_seg_list, test_seg)
        for (for control),i_seg in (for generator) do
        end
        if test_max <= split_length then
          table.insert(low_seg_list, test_seg)
          for (for control),i_seg in (for generator) do
          end
          local mid_pos = l_48_2:with_z(math.lerp(test_seg[1].z, test_seg[2].z, (split_length - test_min) / (test_max - test_min)))
          local new_segment1 = {test_seg[1], mid_pos}
          local new_segment2 = {mid_pos, test_seg[2]}
          table.insert(low_seg_list, new_segment1)
          table.insert(high_seg_list, new_segment2)
        end
        return low_seg_list, high_seg_list
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NavFieldBuilder._seg_to_seg_list_intersection_bool = function(l_49_0, l_49_1, l_49_2, l_49_3)
  local seg_min = l_49_2[1][l_49_3]
  local seg_max = l_49_2[2][l_49_3]
  for i_seg,test_seg in pairs(l_49_1) do
    if seg_max > test_seg[1][l_49_3] and test_seg[2][l_49_3] > seg_min then
      return true
    end
  end
end

NavFieldBuilder._expansion_check_obstacles = function(l_50_0, l_50_1, l_50_2, l_50_3, l_50_4)
  local x_dir_str_map = l_50_0._x_dir_str_map
  local expand_dim = l_50_0._dim_str_map[l_50_1]
  local along_dim = l_50_0._perp_dim_str_map[l_50_1]
  local grid_size = l_50_0._grid_size
  local padding_gnd = l_50_0._ground_padding
  local padding_wall = l_50_0._wall_padding
  local air_ray_rad = l_50_0._air_ray_rad
  local gnd_ray_rad = l_50_0._gnd_ray_rad
  local along_vec = Vector3()
  mvector3.set_" .. along_di(along_vec, grid_size * 0.5)
  local along_vec_inclination = l_50_3[2] - l_50_3[1]
  mvector3.normalize(along_vec_inclination)
  local inclination_init = l_50_4[expand_dim]
  if l_50_0._neg_dir_str_map[l_50_1] then
    inclination_init = -inclination_init
  end
  local step_vec = 2 * along_vec
  local seg_size_grid = (l_50_3[2][along_dim] - l_50_3[1][along_dim]) / grid_size
  local travel_seg = {l_50_3[1] + along_vec, l_50_3[2] - along_vec}
  local measuring = {}
  local pos_along_border = travel_seg[1]
  local res_expansion = {walls = {}, stairs = {}, spaces = {}, cliffs = {}}
  local prev_air_pos = nil
  local i_grid = 0
  repeat
    local obstacle_found = nil
    local back_ground_ray = l_50_0:_sphere_ray(pos_along_border + l_50_0._up_vec, pos_along_border + l_50_0._down_vec, gnd_ray_rad)
    if not back_ground_ray then
      Application:draw_cylinder(pos_along_border + l_50_0._up_vec, pos_along_border + l_50_0._down_vec, gnd_ray_rad, 1, 0, 0)
      return res_expansion
    end
    local air_pos = pos_along_border:with_z(back_ground_ray.position.z + padding_gnd + air_ray_rad)
    local air_from_pos = air_pos - l_50_2 * grid_size
    local air_to_pos = air_pos + l_50_2 * (padding_wall + grid_size)
    do
      local air_ray = l_50_0:_bundle_ray(air_from_pos, air_to_pos, air_ray_rad)
      if not air_ray then
        local air_from_pos = air_to_pos - l_50_2 * (gnd_ray_rad + 2)
        local air_to_pos = air_from_pos - along_vec_inclination:normalized() * (padding_wall + grid_size * 0.5 - 1)
        air_ray = l_50_0:_bundle_ray(air_from_pos, air_to_pos, air_ray_rad * 0.80000001192093)
      end
      if not air_ray then
        local air_from_pos = air_to_pos - l_50_2 * (gnd_ray_rad + 2)
        local air_to_pos = air_from_pos + along_vec_inclination:normalized() * (padding_wall + grid_size * 0.5 - 1)
        air_ray = l_50_0:_bundle_ray(air_from_pos, air_to_pos, air_ray_rad * 0.80000001192093)
      end
      if air_ray then
        obstacle_found = "walls"
        if air_ray.unit:in_slot(15) then
          l_50_0:_on_helper_hit(air_ray.unit)
        else
          local void_ray_rad = grid_size * 0.5
          local ray_rad_dif = gnd_ray_rad - void_ray_rad
          local front_air_pos = air_pos + l_50_2 * grid_size * 2 - step_vec * 1.5
          local front_ray = l_50_0:_bundle_ray(air_pos, front_air_pos, air_ray_rad)
          local front_gnd_pos = math.step(front_air_pos, air_pos, void_ray_rad + 1)
          local front_ground_ray = (not front_ray and l_50_0:_sphere_ray(front_gnd_pos + l_50_0._up_vec, front_gnd_pos + l_50_0._down_vec, void_ray_rad))
          if front_ray or front_ground_ray and math.abs(front_ground_ray.position.z + ray_rad_dif - back_ground_ray.position.z) < 40 then
            front_air_pos = air_pos + l_50_2 * grid_size * 2
            front_ray = l_50_0:_bundle_ray(air_pos, front_air_pos, air_ray_rad)
            front_gnd_pos = math.step(front_air_pos, air_pos, void_ray_rad + 1)
            if not front_ray then
              front_ground_ray = l_50_0:_sphere_ray(front_gnd_pos + l_50_0._up_vec, front_gnd_pos + l_50_0._down_vec, void_ray_rad)
            else
              front_ground_ray = false
            end
            if front_ray or front_ground_ray and math.abs(front_ground_ray.position.z + ray_rad_dif - back_ground_ray.position.z) < 40 then
              front_air_pos = air_pos + l_50_2 * grid_size * 2 + step_vec * 1.5
              front_ray = l_50_0:_bundle_ray(air_pos, front_air_pos, air_ray_rad)
              front_gnd_pos = math.step(front_air_pos, air_pos, void_ray_rad + 1)
              if not front_ray then
                front_ground_ray = l_50_0:_sphere_ray(front_gnd_pos + l_50_0._up_vec, front_gnd_pos + l_50_0._down_vec, void_ray_rad)
              else
                front_ground_ray = false
              end
              if not front_ray then
                if front_ground_ray and math.abs(front_ground_ray.position.z + ray_rad_dif - back_ground_ray.position.z) < 40 then
                  do return end
                end
                obstacle_found = "cliffs"
              else
                obstacle_found = "cliffs"
              end
            else
              obstacle_found = "cliffs"
            end
          end
          if not obstacle_found then
            local front_air_pos = air_pos + l_50_2 * grid_size
            local front_ground_ray = l_50_0:_sphere_ray(front_air_pos + l_50_0._up_vec, front_air_pos + l_50_0._down_vec, gnd_ray_rad)
            local climb_vec = front_ground_ray.position - back_ground_ray.position
            local inclination = climb_vec.z / l_50_0._grid_size
            local abs_inc_diff = math.abs(inclination_init - inclination)
            if abs_inc_diff > 0.5 then
              obstacle_found = "stairs"
            end
          end
          if not obstacle_found then
            obstacle_found = "spaces"
          end
        end
      end
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if measuring[obstacle_found] and i_grid == seg_size_grid - 1 then
        local meas_obs_type = next(measuring)
        local measured_seg = measuring[meas_obs_type]
        measured_seg[2] = pos_along_border + along_vec
        do
          local ground_ray = l_50_0:_sphere_ray(pos_along_border + l_50_0._up_vec, pos_along_border + l_50_0._down_vec, gnd_ray_rad)
          mvector3.set_z(measured_seg[2], ground_ray.position.z)
          table.insert(res_expansion[obstacle_found], measured_seg)
        end
        do return end
        local meas_obs_type = next(measuring)
        if meas_obs_type then
          local measured_seg = measuring[meas_obs_type]
          measured_seg[2] = pos_along_border - along_vec
          local ground_ray = l_50_0:_sphere_ray(pos_along_border + l_50_0._up_vec, pos_along_border + l_50_0._down_vec, gnd_ray_rad)
          mvector3.set_z(measured_seg[2], ground_ray.position.z)
          table.insert(res_expansion[meas_obs_type], measured_seg)
          measuring[meas_obs_type] = nil
        end
        if i_grid == seg_size_grid - 1 then
          local measured_seg = {pos_along_border - along_vec, pos_along_border + along_vec}
          local ground_ray = l_50_0:_sphere_ray(pos_along_border + l_50_0._up_vec, pos_along_border + l_50_0._down_vec, gnd_ray_rad)
          mvector3.set_z(measured_seg[1], ground_ray.position.z)
          mvector3.set_z(measured_seg[2], ground_ray.position.z)
          table.insert(res_expansion[obstacle_found], measured_seg)
        else
          local new_seg = {pos_along_border - along_vec}
          local ground_ray = l_50_0:_sphere_ray(pos_along_border + l_50_0._up_vec, pos_along_border + l_50_0._down_vec, gnd_ray_rad)
          mvector3.set_z(new_seg[1], ground_ray.position.z)
          measuring[obstacle_found] = new_seg
        end
      end
      pos_along_border = pos_along_border + step_vec
      i_grid = i_grid + 1
      mvector3.set_z(pos_along_border, math.lerp(travel_seg[1].z, travel_seg[2].z, (i_grid) / seg_size_grid))
    until seg_size_grid <= i_grid
  end
  if not next(res_expansion.walls) and not next(res_expansion.stairs) then
    return res_expansion, next(res_expansion.cliffs)
  end
end

NavFieldBuilder._expansion_check_neighbours = function(l_51_0, l_51_1, l_51_2)
  local opp_dir_str_map = l_51_0._opposite_side_str
  local perp_pos_dir_str_map = l_51_0._perp_pos_dir_str_map
  local perp_neg_dir_str_map = l_51_0._perp_neg_dir_str_map
  local neg_dir_str_map = l_51_0._neg_dir_str_map
  local x_dir_str_map = l_51_0._x_dir_str_map
  local dir_vec_map = l_51_0._dir_str_to_vec
  local dim_str_map = l_51_0._dim_str_map
  local perp_dim_str_map = l_51_0._perp_dim_str_map
  local expand_dim = dim_str_map[l_51_1]
  local along_dim = perp_dim_str_map[l_51_1]
  local expand_border = l_51_2[1][dim_str_map[l_51_1]]
  local expand_seg = {l_51_2[1][perp_dim_str_map[l_51_1]], l_51_2[2][perp_dim_str_map[l_51_1]]}
  local neighbours = {}
  do
    local opp_dir_str = opp_dir_str_map[l_51_1]
    for i_room,test_room in ipairs(l_51_0._rooms) do
      local test_borders = test_room.borders
      local test_border = test_room.borders[opp_dir_str]
      if expand_border == test_border then
        local test_border_seg = {test_borders[perp_neg_dir_str_map[l_51_1]], test_borders[perp_pos_dir_str_map[l_51_1]]}
        local overlap_line = l_51_0:_chk_line_overlap(test_border_seg, expand_seg)
        if overlap_line then
          local overlap_seg = {}
           -- DECOMPILER ERROR: Overwrote pending register.

           -- DECOMPILER ERROR: Overwrote pending register.

          Vector3()[Vector3() .. dim_str_map[l_51_1]](overlap_seg[1], expand_border)
          mvector3.set_" .. perp_dim_str_map[l_51_1(overlap_seg[1], overlap_line[1])
          local z1_test_room = l_51_0._get_room_height_at_pos(test_room.height, test_room.borders, overlap_seg[1])
          local z1_exp_room = math.lerp(l_51_2[1].z, l_51_2[2].z, (overlap_line[1] - l_51_2[1][along_dim]) / (l_51_2[2][along_dim] - l_51_2[1][along_dim]))
          mvector3.set_" .. dim_str_map[l_51_1(overlap_seg[2], expand_border)
          mvector3.set_" .. perp_dim_str_map[l_51_1(overlap_seg[2], overlap_line[2])
          local z2_test_room = l_51_0._get_room_height_at_pos(test_room.height, test_room.borders, overlap_seg[2])
          local z2_exp_room = math.lerp(l_51_2[1].z, l_51_2[2].z, (overlap_line[2] - l_51_2[1][along_dim]) / (l_51_2[2][along_dim] - l_51_2[1][along_dim]))
          local min_h_diff = 150
          if min_h_diff >= z1_test_room - z1_exp_room or min_h_diff >= z2_test_room - z2_exp_room then
            if z1_test_room - z1_exp_room < -min_h_diff and z2_test_room - z2_exp_room < -min_h_diff then
              for (for control),i_room in (for generator) do
              end
              mvector3.set_z(overlap_seg[1], (z1_test_room + z1_exp_room) * 0.5)
              mvector3.set_z(overlap_seg[2], (z2_test_room + z2_exp_room) * 0.5)
              table.insert(neighbours, {room = i_room, overlap = overlap_seg})
            end
          end
        end
      end
      return not next(neighbours) or neighbours
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NavFieldBuilder._on_helper_hit = function(l_52_0, l_52_1)
  local unit_id = l_52_1:unit_data().unit_id
  l_52_0._new_blockers[unit_id] = l_52_1
end

NavFieldBuilder._set_new_blockers_used = function(l_53_0)
  for unit_id,unit in pairs(l_53_0._new_blockers) do
    l_53_0._helper_blockers[unit_id] = l_53_0._building.id
  end
  l_53_0._new_blockers = nil
end

NavFieldBuilder._disable_blocker = function(l_54_0, l_54_1)
  local u_id = l_54_1:unit_data().unit_id
  l_54_0._disabled_blockers[u_id] = l_54_1
  l_54_1:set_enabled(false)
end

NavFieldBuilder._enable_blocker = function(l_55_0, l_55_1)
  local u_id = l_55_1:unit_data().unit_id
  l_55_0._disabled_blockers[u_id] = nil
  l_55_1:set_enabled(true)
end

NavFieldBuilder._reenable_all_blockers = function(l_56_0)
  if l_56_0._disabled_blockers then
    for _,blocker_unit in pairs(l_56_0._disabled_blockers) do
      if alive(blocker_unit) then
        blocker_unit:set_enabled(true)
      end
    end
  end
  l_56_0._disabled_blockers = nil
end

NavFieldBuilder._disable_all_blockers = function(l_57_0)
  local all_blockers = World:find_units_quick("all", 15)
  if not l_57_0._disabled_blockers then
    l_57_0._disabled_blockers = {}
  end
  for _,unit in ipairs(all_blockers) do
    l_57_0:_disable_blocker(unit)
  end
end

NavFieldBuilder._chk_line_overlap = function(l_58_0, l_58_1, l_58_2)
  local overlap_max = math.min(l_58_1[2], l_58_2[2])
  local overlap_min = math.max(l_58_1[1], l_58_2[1])
  return (overlap_min < overlap_max and {overlap_min, overlap_max})
end

NavFieldBuilder._measure_init_room_expansion = function(l_59_0, l_59_1, l_59_2)
  local perp_pos_dir_str_map = l_59_0._perp_pos_dir_str_map
  local perp_neg_dir_str_map = l_59_0._perp_neg_dir_str_map
  local dim_str_map = l_59_0._dim_str_map
  local perp_dim_str_map = l_59_0._perp_dim_str_map
  local borders = l_59_1.borders
  local expansion = l_59_1.expansion
  local height = l_59_1.height
  local inclination = l_59_1.inclination
  for dir_str,perp_neg_dir_str in pairs(perp_neg_dir_str_map) do
    local perp_pos_dir_str = perp_pos_dir_str_map[dir_str]
    local dim_str = dim_str_map[dir_str]
    local perp_dim_str = perp_dim_str_map[dir_str]
    local init_space = {}
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

    Vector3()[Vector3() .. dim_str](init_space[1], borders[dir_str])
    mvector3.set_" .. dim_st(init_space[2], borders[dir_str])
    mvector3.set_" .. perp_dim_st(init_space[1], borders[perp_neg_dir_str])
    mvector3.set_" .. perp_dim_st(init_space[2], borders[perp_pos_dir_str])
    mvector3.set_z(init_space[1], l_59_2.z)
    mvector3.set_z(init_space[2], l_59_2.z)
    table.insert(expansion[dir_str].unsorted, init_space)
  end
  local ray_from_pos = expansion.x_pos.unsorted[1][2]
  local ground_ray = l_59_0:_sphere_ray(ray_from_pos + l_59_0._up_vec, ray_from_pos + l_59_0._down_vec, l_59_0._gnd_ray_rad)
  if not ground_ray or not ground_ray.position.z then
    height.xp_yp = l_59_2.z
  end
  mvector3.set_z(expansion.x_pos.unsorted[1][2], height.xp_yp)
  mvector3.set_z(expansion.y_pos.unsorted[1][2], height.xp_yp)
  local ray_from_pos = expansion.x_pos.unsorted[1][1]
  ground_ray = l_59_0:_sphere_ray(ray_from_pos + l_59_0._up_vec, ray_from_pos + l_59_0._down_vec, l_59_0._gnd_ray_rad)
  if not ground_ray or not ground_ray.position.z then
    height.xp_yn = l_59_2.z
  end
  mvector3.set_z(expansion.x_pos.unsorted[1][1], height.xp_yn)
  mvector3.set_z(expansion.y_neg.unsorted[1][2], height.xp_yn)
  local ray_from_pos = expansion.x_neg.unsorted[1][2]
  ground_ray = l_59_0:_sphere_ray(ray_from_pos + l_59_0._up_vec, ray_from_pos + l_59_0._down_vec, l_59_0._gnd_ray_rad)
  if not ground_ray or not ground_ray.position.z then
    height.xn_yp = l_59_2.z
  end
  mvector3.set_z(expansion.x_neg.unsorted[1][2], height.xn_yp)
  mvector3.set_z(expansion.y_pos.unsorted[1][1], height.xn_yp)
  local ray_from_pos = expansion.x_neg.unsorted[1][1]
  ground_ray = l_59_0:_sphere_ray(ray_from_pos + l_59_0._up_vec, ray_from_pos + l_59_0._down_vec, l_59_0._gnd_ray_rad)
  if not ground_ray or not ground_ray.position.z then
    height.xn_yn = l_59_2.z
  end
  mvector3.set_z(expansion.x_neg.unsorted[1][1], height.xn_yn)
  mvector3.set_z(expansion.y_neg.unsorted[1][1], height.xn_yn)
  local z_x_pos = (height.xp_yp + height.xp_yn) * 0.5
  local z_x_neg = (height.xn_yp + height.xn_yn) * 0.5
  local z_y_pos = (height.xp_yp + height.xn_yp) * 0.5
  local z_y_neg = (height.xp_yn + height.xn_yn) * 0.5
  inclination.x = (z_x_pos - z_x_neg) / l_59_0._grid_size
  inclination.y = (z_y_pos - z_y_neg) / l_59_0._grid_size
end

NavFieldBuilder._calculate_expanded_border = function(l_60_0, l_60_1, l_60_2, l_60_3)
  if not l_60_0._neg_dir_str_map[l_60_1] or not l_60_2 - l_60_3 then
    return l_60_2 + l_60_3
  end
end

NavFieldBuilder._find_room_height_from_expansion = function(l_61_0, l_61_1, l_61_2, l_61_3)
  local y_max, y_min = nil, nil
  for obs_type,obs_list in pairs(l_61_1[l_61_3]) do
    for i_obs,obs_seg in pairs(obs_list) do
      if not y_min or obs_seg[1].y < y_min then
        l_61_2.xp_yn = obs_seg[1].z
        y_min = obs_seg[1].y
      end
      if not y_max or y_max < obs_seg[2].y then
        l_61_2.xp_yp = obs_seg[2].z
        y_max = obs_seg[2].y
      end
    end
  end
  y_min, y_max = nil
  for obs_type,obs_list in pairs(l_61_1[l_61_0._opposite_side_str[l_61_3]]) do
    for i_obs,obs_seg in pairs(obs_list) do
      if not y_min or obs_seg[1].y < y_min then
        l_61_2.xn_yn = obs_seg[1].z
        y_min = obs_seg[1].y
      end
      if not y_max or y_max < obs_seg[2].y then
        l_61_2.xn_yp = obs_seg[2].z
        y_max = obs_seg[2].y
      end
    end
  end
end

NavFieldBuilder._get_room_height_at_pos = function(l_62_0, l_62_1, l_62_2)
  local lerp_x = (l_62_2.x - l_62_1.x_neg) / (l_62_1.x_pos - l_62_1.x_neg)
  local lerp_y = (l_62_2.y - l_62_1.y_neg) / (l_62_1.y_pos - l_62_1.y_neg)
  local side_x_pos_z = math.lerp(l_62_0.xp_yn, l_62_0.xp_yp, lerp_y)
  local side_x_neg_z = math.lerp(l_62_0.xn_yn, l_62_0.xn_yp, lerp_y)
  local plane_z = math.lerp(side_x_neg_z, side_x_pos_z, lerp_x)
  return plane_z
end

NavFieldBuilder._ground_ray = function(l_63_0, l_63_1)
  return World:raycast("ray", l_63_1, l_63_1 + l_63_0._down_vec, "slot_mask", l_63_0._slotmask, "ray_type", "walk")
end

NavFieldBuilder._sphere_ray = function(l_64_0, l_64_1, l_64_2, l_64_3)
  return World:raycast("ray", l_64_1, l_64_2, "slot_mask", l_64_0._slotmask, "sphere_cast_radius", l_64_3, "ray_type", "walk")
end

NavFieldBuilder._bundle_ray = function(l_65_0, l_65_1, l_65_2, l_65_3)
  return World:raycast("ray", l_65_1, l_65_2, "slot_mask", l_65_0._slotmask, "sphere_cast_radius", l_65_3, "bundle", math.max(3, math.ceil(l_65_3)), "ray_type", "walk")
end

NavFieldBuilder._check_line_z_overlap_bool = function(l_66_0, l_66_1, l_66_2, l_66_3, l_66_4, l_66_5, l_66_6, l_66_7)
  local is_x = l_66_5 == "x_pos" or l_66_5 == "x_neg"
  local seg_pos_1, seg_pos_2 = nil, nil
  if is_x then
    seg_pos_1 = Vector3(l_66_6, l_66_7[1], 0)
    seg_pos_2 = Vector3(l_66_6, l_66_7[2], 0)
  else
    seg_pos_1 = Vector3(l_66_7[1], l_66_6, 0)
    seg_pos_2 = Vector3(l_66_7[2], l_66_6, 0)
  end
  local exp_z_1 = l_66_0._get_room_height_at_pos(l_66_4, l_66_2, seg_pos_1)
  local exp_z_2 = l_66_0._get_room_height_at_pos(l_66_4, l_66_2, seg_pos_2)
  mvector3.set_z(seg_pos_1, exp_z_1)
  mvector3.set_z(seg_pos_2, exp_z_2)
  local overlap_z_1 = l_66_0._get_room_height_at_pos(l_66_3, l_66_1, seg_pos_1)
  local overlap_z_2 = l_66_0._get_room_height_at_pos(l_66_3, l_66_1, seg_pos_2)
  local min_h_diff = 150
  if (min_h_diff < overlap_z_1 - exp_z_1 and min_h_diff < overlap_z_2 - exp_z_2) or overlap_z_1 - exp_z_1 < -min_h_diff and overlap_z_2 - exp_z_2 < -min_h_diff then
    return false
  end
  return true
end

NavFieldBuilder._check_room_overlap_bool = function(l_67_0, l_67_1)
  return l_67_1.y_pos >= l_67_0.y_neg and l_67_0.y_pos >= l_67_1.y_neg and l_67_0.x_pos >= l_67_1.x_neg and l_67_1.x_pos >= l_67_0.x_neg
end

NavFieldBuilder._commence_vis_graph_build = function(l_68_0)
  if l_68_0._building.stage == 1 then
    local i_room_a = l_68_0._building.current_i_room_a
    local i_room_b = l_68_0._building.current_i_room_b
    local text = "Checking visibility between " .. tostring(i_room_a) .. " and " .. tostring(i_room_b) .. " of " .. tostring(#l_68_0._rooms)
    l_68_0:_update_progress_bar(1, text)
    local complete = l_68_0:_create_room_to_room_visibility_data(l_68_0._building)
    if complete then
      l_68_0._building.stage = 2
      l_68_0._building.current_i_room_a = nil
      l_68_0._building.current_i_room_b = nil
      l_68_0._building.old_rays = nil
    else
      if l_68_0._building.stage == 2 then
        l_68_0:_update_progress_bar(2, "creating visibility groups")
        l_68_0:_create_visibility_groups()
        l_68_0._building.stage = 3
      else
        if l_68_0._building.stage == 3 then
          l_68_0:_update_progress_bar(3, "linking visibility groups")
          l_68_0:_link_visibility_groups()
          l_68_0._room_visibility_data = nil
          l_68_0._building.stage = 4
        else
          if l_68_0._building.stage == 4 then
            l_68_0:_update_progress_bar(4, "generating geographic segments")
            l_68_0:_generate_geographic_segments()
            l_68_0._building.stage = 5
          else
            if l_68_0._building.stage == 5 then
              l_68_0:_update_progress_bar(5, "generating coarse navigation graph")
              l_68_0:_generate_coarse_navigation_graph()
              l_68_0:_cleanup_room_data_1(l_68_0)
              l_68_0:_reenable_all_blockers()
              l_68_0._building = false
              l_68_0:_destroy_progress_bar()
              l_68_0._build_complete_clbk()
            end
          end
        end
      end
    end
  end
end

NavFieldBuilder._create_room_to_room_visibility_data = function(l_69_0, l_69_1)
  local i_room_a = l_69_1.current_i_room_a
  local i_room_b = l_69_1.current_i_room_b
  local all_rooms = l_69_0._rooms
  local nr_rooms = #all_rooms
  local room_a = all_rooms[i_room_a]
  local room_b = all_rooms[i_room_b]
  local current_nr_raycasts = 0
  local max_nr_raycasts = 300
  local ray_dis = l_69_1.ray_dis
  repeat
    local filtered, visibility, nr_raycasts, rays_x_a, rays_y_a, rays_x_b, rays_y_b = nil, nil, nil, nil, nil, nil, nil
    if l_69_1.new_pair and (l_69_1.pos_vis_filter or l_69_1.neg_vis_filter) then
      visibility = l_69_0:_chk_room_vis_filter(room_a, room_b, l_69_1.pos_vis_filter, l_69_1.neg_vis_filter)
      if visibility ~= nil then
        filtered = true
        nr_raycasts = 1
      end
    end
    if not l_69_1.old_rays then
      local old_rays = {}
    end
    visibility, nr_raycasts, rays_x_a, rays_y_a, rays_x_b, rays_y_b = l_69_0:_chk_room_to_room_visibility(room_a, room_b, filtered or 1, old_rays.y_a or old_rays.y_a or 1, old_rays.x_b or 1, old_rays.y_b or 1, max_nr_raycasts - current_nr_raycasts, ray_dis)
    current_nr_raycasts = current_nr_raycasts + nr_raycasts
    do
      if not filtered and not visibility then
        local pair_completed = not rays_x_a
      end
      if visibility then
        l_69_0:_set_rooms_visible(i_room_a, i_room_b)
      end
      if pair_completed then
        l_69_1.old_rays = nil
        repeat
          if i_room_b == nr_rooms then
            if not l_69_0._room_visibility_data[i_room_a] then
              l_69_0._room_visibility_data[i_room_a] = {}
            end
            if i_room_a == #l_69_0._rooms - 1 then
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
          l_69_1.new_pair = true
          do return end
        until i_room_a == nr_rooms
      else
        old_rays.x_a = rays_x_a
        old_rays.y_a = rays_y_a
        old_rays.x_b = rays_x_b
        old_rays.y_b = rays_y_b
        l_69_1.old_rays = old_rays
        l_69_1.new_pair = nil
      end
    until current_nr_raycasts == max_nr_raycasts
  end
  l_69_1.current_i_room_a = i_room_a
  l_69_1.current_i_room_b = i_room_b
end

NavFieldBuilder._chk_room_to_room_visibility = function(l_70_0, l_70_1, l_70_2, l_70_3, l_70_4, l_70_5, l_70_6, l_70_7, l_70_8)
  local borders_a = l_70_1.borders
  local borders_b = l_70_2.borders
  local min_ray_dis = l_70_8
  local nr_rays_x_a = math.max(2, 1 + math.floor((borders_a.x_pos - borders_a.x_neg) / min_ray_dis))
  local nr_rays_y_a = math.max(2, 1 + math.floor((borders_a.y_pos - borders_a.y_neg) / min_ray_dis))
  local nr_rays_x_b = math.max(2, 1 + math.floor((borders_b.x_pos - borders_b.x_neg) / min_ray_dis))
  local nr_rays_y_b = math.max(2, 1 + math.floor((borders_b.y_pos - borders_b.y_neg) / min_ray_dis))
  local nr_rays = 0
  local i_ray_x_a = l_70_3
  local i_ray_y_a = l_70_4
  local i_ray_x_b = l_70_5
  local i_ray_y_b = l_70_6
  local pos_from = Vector3()
  local pos_to = Vector3()
  local mvec3_set_static = mvector3.set_static
  local mvec3_set_z = mvector3.set_z
  local m_lerp = math.lerp
  do
    local x_a, x_b, y_a, y_b = nil, nil, nil, nil
    repeat
      if i_ray_x_a <= nr_rays_x_a then
        if (i_ray_x_a ~= 1 or not borders_a.x_neg) and (i_ray_x_a ~= nr_rays_x_a or not borders_a.x_pos) then
          x_a = m_lerp(borders_a.x_neg, borders_a.x_pos, i_ray_x_a / nr_rays_x_a)
        end
        repeat
          if i_ray_y_a <= nr_rays_y_a then
            if (i_ray_y_a ~= 1 or not borders_a.y_neg) and (i_ray_y_a ~= nr_rays_y_a or not borders_a.y_pos) then
              y_a = m_lerp(borders_a.y_neg, borders_a.y_pos, i_ray_y_a / nr_rays_y_a)
            end
            mvec3_set_static(pos_from, x_a, y_a)
            local room_a_z = l_70_0._get_room_height_at_pos(l_70_1.height, l_70_1.borders, pos_from) + 120
            mvec3_set_z(pos_from, room_a_z)
            repeat
              if i_ray_x_b <= nr_rays_x_b then
                if (i_ray_x_b ~= 1 or not borders_b.x_neg) and (i_ray_x_b ~= nr_rays_x_b or not borders_b.x_pos) then
                  x_b = m_lerp(borders_b.x_neg, borders_b.x_pos, i_ray_x_b / nr_rays_x_b)
                end
                repeat
                  if i_ray_y_b <= nr_rays_y_b then
                    nr_rays = nr_rays + 1
                    if (i_ray_y_b ~= 1 or not borders_b.y_neg) and (i_ray_y_b ~= nr_rays_y_b or not borders_b.y_pos) then
                      y_b = m_lerp(borders_b.y_neg, borders_b.y_pos, i_ray_y_b / nr_rays_y_b)
                    end
                    mvec3_set_static(pos_to, x_b, y_b)
                    local room_b_z = l_70_0._get_room_height_at_pos(l_70_2.height, l_70_2.borders, pos_to) + 120
                    mvec3_set_z(pos_to, room_b_z)
                    local vis_ray = World:raycast("ray", pos_from, pos_to, "slot_mask", l_70_0._slotmask, "ray_type", "vis_graph")
                    if not vis_ray then
                      return true, nr_rays
                    elseif nr_rays == l_70_7 then
                      return false, nr_rays, i_ray_x_a, i_ray_y_a, i_ray_x_b, i_ray_y_b + 1
                    end
                    i_ray_y_b = i_ray_y_b + 1
                  else
                    i_ray_y_b = 1
                    i_ray_x_b = i_ray_x_b + 1
                  end
                else
                  i_ray_x_b = 1
                  i_ray_y_a = i_ray_y_a + 1
                end
              else
                i_ray_y_a = 1
                i_ray_x_a = i_ray_x_a + 1
              end
            else
              return false, nr_rays
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NavFieldBuilder._set_rooms_visible = function(l_71_0, l_71_1, l_71_2)
  local room_a = l_71_0._rooms[l_71_1]
  local room_b = l_71_0._rooms[l_71_2]
  if not l_71_0._room_visibility_data[l_71_1] then
    l_71_0._room_visibility_data[l_71_1] = {}
  end
  if not l_71_0._room_visibility_data[l_71_2] then
    l_71_0._room_visibility_data[l_71_2] = {}
  end
  l_71_0._room_visibility_data[l_71_1][l_71_2] = true
  l_71_0._room_visibility_data[l_71_2][l_71_1] = true
end

NavFieldBuilder._create_visibility_groups = function(l_72_0, l_72_1)
  local all_rooms = l_72_0._rooms
  local nav_segments = l_72_0._nav_segments
  l_72_0._visibility_groups = {}
  local vis_groups = l_72_0._visibility_groups
  if l_72_1 then
    nav_segments[l_72_1].vis_groups = {}
  else
    for nav_seg_id,nav_seg in pairs(nav_segments) do
      nav_seg.vis_groups = {}
    end
  end
  local sorted_vis_list = l_72_0:_sort_rooms_according_to_visibility()
  local search_index = #sorted_vis_list
  repeat
    if search_index > 0 then
      local search_i = sorted_vis_list[search_index].i_room
      if not l_72_0._rooms[search_i].vis_group then
        local search_stack = {search_i}
        local searched_rooms = {}
        local room = all_rooms[search_i]
        local pos = l_72_0:_calculate_room_center(room)
        local segment = room.segment
        local my_vis_group = {rooms = {}, pos = pos, vis_groups = {}, seg = segment}
        table.insert(vis_groups, my_vis_group)
        local i_vis_group = #vis_groups
        table.insert(nav_segments[segment].vis_groups, i_vis_group)
        repeat
          local top_stack_room_i = search_stack[1]
          my_vis_group.rooms[top_stack_room_i] = true
          l_72_0:_add_visible_neighbours_to_stack(top_stack_room_i, search_stack, searched_rooms, l_72_0._room_visibility_data[top_stack_room_i], my_vis_group.rooms, my_vis_group.pos)
          searched_rooms[top_stack_room_i] = true
          all_rooms[top_stack_room_i].vis_group = i_vis_group
          table.remove(search_stack, 1)
        until not next(search_stack)
      end
      search_index = search_index - 1
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NavFieldBuilder._add_visible_neighbours_to_stack = function(l_73_0, l_73_1, l_73_2, l_73_3, l_73_4, l_73_5, l_73_6)
  local rooms = l_73_0._rooms
  local room = rooms[l_73_1]
  local segment = room.segment
  for side_str,door_list in pairs(room.doors) do
    for i_door,door_id in pairs(door_list) do
      local door_data = l_73_0._room_doors[door_id]
      if door_data.rooms[1] ~= l_73_1 or not door_data.rooms[2] then
        local i_neighbour_room = door_data.rooms[1]
      end
      local neighbour_room = rooms[i_neighbour_room]
      if l_73_4[i_neighbour_room] and not l_73_3[i_neighbour_room] and not neighbour_room.vis_group and segment == neighbour_room.segment then
        local accepted = true
        for i_room,_ in pairs(l_73_5) do
          if not l_73_0._room_visibility_data[i_neighbour_room][i_room] then
            accepted = false
        else
          end
        end
        if accepted then
          table.insert(l_73_2, i_neighbour_room)
        end
      end
    end
  end
end

NavFieldBuilder._sort_rooms_according_to_visibility = function(l_74_0)
  do
    local sorted_vis_list = {}
    for i_room,vis_room_list in ipairs(l_74_0._room_visibility_data) do
      local my_borders = l_74_0._rooms[i_room].borders
      local my_total_area = l_74_0:_calc_room_area(my_borders)
      local my_data = {i_room = i_room, area = my_total_area}
      local search_index = #sorted_vis_list
      repeat
        if search_index > 0 and my_total_area < sorted_vis_list[search_index].area then
          search_index = search_index - 1
        else
          table.insert(sorted_vis_list, search_index + 1, my_data)
        end
        return sorted_vis_list
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

NavFieldBuilder._calc_room_area = function(l_75_0, l_75_1)
  return (l_75_1.x_pos - l_75_1.x_neg) * (l_75_1.y_pos - l_75_1.y_neg)
end

NavFieldBuilder._calculate_room_center = function(l_76_0, l_76_1)
  local borders = l_76_1.borders
  local pos = Vector3((borders.x_pos + borders.x_neg) * 0.5, (borders.y_pos + borders.y_neg) * 0.5, 0)
  local pos_z = l_76_0._get_room_height_at_pos(l_76_1.height, borders, pos)
  mvector3.set_z(pos, pos_z)
  return pos
end

NavFieldBuilder._link_visibility_groups = function(l_77_0)
  for i_group,group in ipairs(l_77_0._visibility_groups) do
    for i_room,_ in pairs(group.rooms) do
      local visible_rooms = l_77_0._room_visibility_data[i_room]
      for i_vis_room,_ in pairs(visible_rooms) do
        local test_vis_group = l_77_0._rooms[i_vis_room].vis_group
        if not group.vis_groups[test_vis_group] and test_vis_group ~= i_group then
          group.vis_groups[test_vis_group] = true
        end
      end
    end
  end
end

NavFieldBuilder._generate_coarse_navigation_graph = function(l_78_0)
  local neg_dir_str = l_78_0._neg_dir_str_map
  local all_vis_groups = l_78_0._visibility_groups
  local all_segments = l_78_0._nav_segments
  local all_rooms = l_78_0._rooms
  do
    local all_doors = l_78_0._room_doors
    for seg_id,seg in pairs(l_78_0._nav_segments) do
      seg.neighbours = {}
    end
    for seg_id,seg in pairs(l_78_0._nav_segments) do
      local my_discovered_segments = {}
      local neighbours = seg.neighbours
      local vis_groups = seg.vis_groups
      for _,i_vis_group in ipairs(vis_groups) do
        local vis_group = all_vis_groups[i_vis_group]
        if vis_group then
          local group_rooms = vis_group.rooms
          for i_room,_ in pairs(group_rooms) do
            local room = all_rooms[i_room]
            for dir_str,door_list in pairs(room.doors) do
              local is_neg = neg_dir_str[dir_str]
              for door_index,id_door in pairs(door_list) do
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
                    for (for control),door_index in (for generator) do
                    end
                    if my_discovered_segments[neighbour_seg_id] then
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
     -- Warning: missing end command somewhere! Added here
  end
end

NavFieldBuilder.set_nav_seg_metadata = function(l_79_0, l_79_1, l_79_2, l_79_3)
  if not l_79_0._nav_segments then
    return 
  end
  local nav_seg = l_79_0._nav_segments[l_79_1]
  if not nav_seg then
    return 
  end
  nav_seg[l_79_2] = l_79_3
end


