-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\utils\sinespline.luac 

if not SineSpline then
  SineSpline = class()
end
SineSpline.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  l_1_0._segments = l_1_1
  l_1_0._manual_first_control_point = l_1_4
  l_1_0._manual_last_control_point = l_1_5
  l_1_0._curviness = l_1_3
  l_1_0._nr_subseg = l_1_2
  l_1_0._control_points = {}
  if l_1_4 then
    l_1_0._control_points[1] = {p2 = l_1_4}
  end
  if l_1_5 then
    l_1_0._control_points[#l_1_1] = {p1 = l_1_5}
  end
end

SineSpline.prepare_walk_data = function(l_2_0, l_2_1)
  if #l_2_0._segments > 1 then
    l_2_0._mvec3_1 = Vector3()
    l_2_0._mvec3_2 = Vector3()
    if l_2_1 then
      local nr_seg = #l_2_0._segments
      if not l_2_0._control_points[nr_seg - 1] then
        l_2_0:_extract_control_points_at_index(nr_seg - 1)
      end
      if not l_2_0._control_points[nr_seg] then
        l_2_0:_extract_control_points_at_index(nr_seg)
      end
      local next_subseg = l_2_0._segments[nr_seg]
      local cur_subseg = l_2_0:_position_at_time_on_segment((l_2_0._nr_subseg - 1) / l_2_0._nr_subseg, l_2_0._segments[nr_seg - 1], l_2_0._segments[nr_seg], l_2_0._control_points[nr_seg].p1, l_2_0._control_points[nr_seg - 1].p2)
      local subseg_len = mvector3.distance(cur_subseg, next_subseg)
      local playtime_data = {}
      playtime_data.seg_i = nr_seg - 1
      playtime_data.subseg_i = l_2_0._nr_subseg - 1
      playtime_data.subseg_start = cur_subseg
      playtime_data.subseg_end = next_subseg
      playtime_data.subseg_dis = subseg_len
      playtime_data.subseg_len = subseg_len
      l_2_0._playtime_data = playtime_data
    else
      if not l_2_0._control_points[2] then
        l_2_0:_extract_control_points_at_index(2)
      end
      if not l_2_0._control_points[1] then
        l_2_0:_extract_control_points_at_index(1)
      end
      local cur_subseg = l_2_0._segments[1]
      local next_subseg = l_2_0:_position_at_time_on_segment(1 / l_2_0._nr_subseg, cur_subseg, l_2_0._segments[2], l_2_0._control_points[2].p1, l_2_0._control_points[1].p2)
      local subseg_len = mvector3.distance(cur_subseg, next_subseg)
      local playtime_data = {}
      playtime_data.seg_i = 1
      playtime_data.subseg_i = 1
      playtime_data.subseg_start = cur_subseg
      playtime_data.subseg_end = next_subseg
      playtime_data.subseg_dis = 0
      playtime_data.subseg_len = subseg_len
      l_2_0._playtime_data = playtime_data
    end
  end
end

SineSpline.delete_walk_data = function(l_3_0)
  l_3_0._mvec3_1 = nil
  l_3_0._mvec3_2 = nil
  l_3_0._control_points = {}
  l_3_0._playtime_data = nil
end

SineSpline._position_at_time_on_segment = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4, l_4_5)
  mvector3.lerp(l_4_0._mvec3_1, l_4_2, l_4_5, l_4_1)
  mvector3.lerp(l_4_0._mvec3_2, l_4_4, l_4_3, l_4_1)
  local xpo = (math.sin((l_4_1 * 2 - 1) * 90) + 1) * l_4_0._curviness
  return math.lerp(l_4_0._mvec3_1, l_4_0._mvec3_2, xpo)
end

SineSpline.walk = function(l_5_0, l_5_1)
  local result_pos = nil
  if #l_5_0._segments > 1 then
    local segments = l_5_0._segments
    local play_data = l_5_0._playtime_data
    local new_subseg_dis = play_data.subseg_dis + l_5_1
    if new_subseg_dis < 0 then
      local undershot = new_subseg_dis
      repeat
        if play_data.subseg_i == 1 then
          if play_data.seg_i == 1 then
            play_data.subseg_dis = 0
            return segments[1], undershot
          else
            play_data.seg_i = play_data.seg_i - 1
            if not l_5_0._control_points[play_data.seg_i] then
              l_5_0:_extract_control_points_at_index(play_data.seg_i)
            end
            play_data.subseg_i = l_5_0._nr_subseg
            play_data.subseg_start = l_5_0:_position_at_time_on_segment((l_5_0._nr_subseg - 1) / l_5_0._nr_subseg, segments[play_data.seg_i], segments[play_data.seg_i + 1], l_5_0._control_points[play_data.seg_i + 1].p1, l_5_0._control_points[play_data.seg_i].p2)
            play_data.subseg_end = segments[play_data.seg_i + 1]
            play_data.subseg_len = mvector3.distance(play_data.subseg_start, play_data.subseg_end)
            new_subseg_dis = play_data.subseg_len + undershot
          else
            play_data.subseg_i = play_data.subseg_i - 1
            play_data.subseg_end = play_data.subseg_start
            play_data.subseg_start = l_5_0:_position_at_time_on_segment(play_data.subseg_i / l_5_0._nr_subseg, segments[play_data.seg_i], segments[play_data.seg_i + 1], l_5_0._control_points[play_data.seg_i + 1].p1, l_5_0._control_points[play_data.seg_i].p2)
            play_data.subseg_len = mvector3.distance(play_data.subseg_start, play_data.subseg_end)
            new_subseg_dis = play_data.subseg_len + undershot
          end
        end
      until new_subseg_dis > 0
      play_data.subseg_dis = new_subseg_dis
      return math.lerp(play_data.subseg_start, play_data.subseg_end, play_data.subseg_dis / play_data.subseg_len), (play_data.subseg_i == 1 and undershot)
    else
      repeat
        repeat
          if play_data.subseg_len < new_subseg_dis then
            local overshot = new_subseg_dis - play_data.subseg_len
            if play_data.subseg_i == l_5_0._nr_subseg then
              if play_data.seg_i == #segments - 1 then
                play_data.subseg_dis = play_data.subseg_len
                return segments[#segments], overshot
              else
                play_data.seg_i = play_data.seg_i + 1
                if not l_5_0._control_points[play_data.seg_i + 1] then
                  l_5_0:_extract_control_points_at_index(play_data.seg_i + 1)
                end
                play_data.subseg_i = 1
                play_data.subseg_start = segments[play_data.seg_i]
                play_data.subseg_end = l_5_0:_position_at_time_on_segment(1 / l_5_0._nr_subseg, segments[play_data.seg_i], segments[play_data.seg_i + 1], l_5_0._control_points[play_data.seg_i + 1].p1, l_5_0._control_points[play_data.seg_i].p2)
                play_data.subseg_len = mvector3.distance(play_data.subseg_start, play_data.subseg_end)
                new_subseg_dis = overshot
              else
                play_data.subseg_i = play_data.subseg_i + 1
                play_data.subseg_start = play_data.subseg_end
                play_data.subseg_end = l_5_0:_position_at_time_on_segment(play_data.subseg_i / l_5_0._nr_subseg, segments[play_data.seg_i], segments[play_data.seg_i + 1], l_5_0._control_points[play_data.seg_i + 1].p1, l_5_0._control_points[play_data.seg_i].p2)
                play_data.subseg_len = mvector3.distance(play_data.subseg_start, play_data.subseg_end)
                new_subseg_dis = overshot
              end
          end
          play_data.subseg_dis = new_subseg_dis
          return math.lerp(play_data.subseg_start, play_data.subseg_end, play_data.subseg_dis / play_data.subseg_len), (play_data.subseg_i == l_5_0._nr_subseg and play_data.subseg_len - play_data.subseg_dis)
        else
          return l_5_0._segments[1]
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

SineSpline._extract_control_points_at_index = function(l_6_0, l_6_1)
  local segments = l_6_0._segments
  local control_points = l_6_0._control_points
  local pos = segments[l_6_1]
  local segment_control_points = {}
  if l_6_1 == #segments then
    if control_points[#segments - 1] then
      local last_seg = pos - segments[#segments - 1]
       -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

    end
    local last_vec = segments[1] - segments[#segments - 1]
    local last_angle = last_vec:angle(last_seg)
    local last_rot = last_seg:cross(last_vec)
    last_rot = Rotation(last_rot, 180 - 2 * last_angle)
    local w_vec = pos + last_vec:rotate_with(last_rot)
    segment_control_points.p1 = w_vec
  else
    segment_control_points.p1 = pos
  end
elseif l_6_1 == 1 then
  if control_points[2] then
    local first_vec = control_points[2].p1 - segments[2]
    local first_seg = segments[2] - segments[1]
    local first_angle = first_vec:angle(first_seg)
    local first_rot = first_seg:cross(first_vec)
    first_rot = Rotation(first_rot, 180 - 2 * first_angle)
    local w_vec = segments[1] + first_vec:rotate_with(first_rot)
    segment_control_points.p2 = w_vec
  else
    segment_control_points.p2 = pos
  end
else
  local tan_seg = segments[l_6_1 + 1] - segments[l_6_1 - 1]
  mvector3.set_length(tan_seg, mvector3.distance(pos, segments[l_6_1 - 1]) * l_6_0._curviness)
  segment_control_points.p1 = pos - tan_seg
  mvector3.set_length(tan_seg, mvector3.distance(pos, segments[l_6_1 + 1]) * l_6_0._curviness)
  segment_control_points.p2 = pos + tan_seg
end
l_6_0._control_points[l_6_1] = segment_control_points
end


