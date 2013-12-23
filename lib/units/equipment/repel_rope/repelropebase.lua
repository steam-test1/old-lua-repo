-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\equipment\repel_rope\repelropebase.luac 

if not RepelRopeBase then
  RepelRopeBase = class()
end
RepelRopeBase.init = function(l_1_0, l_1_1)
  l_1_0._tmp_vec3 = Vector3()
  l_1_1:m_position(l_1_0._tmp_vec3)
  l_1_0._unit = l_1_1
  l_1_0._end_object = l_1_1:get_object(Idstring(l_1_0._end_object_name))
  l_1_1:set_extension_update_enabled(Idstring("base"), false)
end

RepelRopeBase.update = function(l_2_0, l_2_1, l_2_2, l_2_3)
  if l_2_0._retracting then
    local prog = (l_2_2 - l_2_0._retract_start_t) / l_2_0._retract_duration
    if prog > 1 then
      l_2_1:set_slot(0)
    else
      prog = prog ^ 3
      local new_pos = l_2_0._tmp_vec3
      l_2_0._unit:m_position(new_pos)
      mvector3.lerp(new_pos, l_2_0._retract_pos, new_pos, prog)
      l_2_0._end_object:set_position(new_pos)
    end
  else
    local new_pos = l_2_0._tmp_vec3
    l_2_0._attach_obj:m_position(new_pos)
    l_2_0._end_object:set_position(new_pos)
  end
end
end

RepelRopeBase.setup = function(l_3_0, l_3_1)
  l_3_0._attach_obj = l_3_1
  l_3_0._unit:set_extension_update_enabled(Idstring("base"), true)
end

RepelRopeBase.retract = function(l_4_0)
  if not l_4_0._retracting then
    l_4_0._retracting = true
    l_4_0._retract_start_t = TimerManager:game():time()
    l_4_0._retract_pos = l_4_0._attach_obj:position()
    l_4_0._unit:m_position(l_4_0._tmp_vec3)
    l_4_0._retract_duration = math.max(1, mvector3.distance(l_4_0._retract_pos, l_4_0._tmp_vec3)) / 600
  end
end


