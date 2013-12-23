-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\group_ai_states\groupaistateempty.luac 

if not GroupAIStateEmpty then
  GroupAIStateEmpty = class(GroupAIStateBase)
end
GroupAIStateEmpty.assign_enemy_to_group_ai = function(l_1_0, l_1_1)
end

GroupAIStateEmpty.on_enemy_tied = function(l_2_0, l_2_1)
end

GroupAIStateEmpty.on_enemy_untied = function(l_3_0, l_3_1)
end

GroupAIStateEmpty.on_civilian_tied = function(l_4_0, l_4_1)
end

GroupAIStateEmpty.can_hostage_flee = function(l_5_0)
end

GroupAIStateEmpty.add_to_surrendered = function(l_6_0, l_6_1, l_6_2)
end

GroupAIStateEmpty.remove_from_surrendered = function(l_7_0, l_7_1)
end

GroupAIStateEmpty.flee_point = function(l_8_0, l_8_1)
end

GroupAIStateEmpty.on_security_camera_spawned = function(l_9_0)
end

GroupAIStateEmpty.on_security_camera_broken = function(l_10_0)
end

GroupAIStateEmpty.on_security_camera_destroyed = function(l_11_0)
end

GroupAIStateEmpty.on_nav_segment_state_change = function(l_12_0, l_12_1, l_12_2)
end

GroupAIStateEmpty.set_area_min_police_force = function(l_13_0, l_13_1, l_13_2, l_13_3)
end

GroupAIStateEmpty.set_wave_mode = function(l_14_0, l_14_1)
end

GroupAIStateEmpty.add_preferred_spawn_points = function(l_15_0, l_15_1, l_15_2)
end

GroupAIStateEmpty.remove_preferred_spawn_points = function(l_16_0, l_16_1)
end

GroupAIStateEmpty.register_criminal = function(l_17_0, l_17_1)
end

GroupAIStateEmpty.unregister_criminal = function(l_18_0, l_18_1)
end

GroupAIStateEmpty.on_defend_travel_end = function(l_19_0, l_19_1, l_19_2)
end

GroupAIStateEmpty.is_area_safe = function(l_20_0)
  return true
end

GroupAIStateEmpty.is_nav_seg_safe = function(l_21_0)
  return true
end

GroupAIStateEmpty.set_mission_fwd_vector = function(l_22_0, l_22_1)
end

GroupAIStateEmpty.set_drama_build_period = function(l_23_0, l_23_1)
end

GroupAIStateEmpty.add_special_objective = function(l_24_0, l_24_1, l_24_2)
end

GroupAIStateEmpty.remove_special_objective = function(l_25_0, l_25_1)
end

GroupAIStateEmpty.save = function(l_26_0, l_26_1)
end

GroupAIStateEmpty.load = function(l_27_0, l_27_1)
end

GroupAIStateEmpty.on_cop_jobless = function(l_28_0, l_28_1)
end

GroupAIStateEmpty.spawn_one_teamAI = function(l_29_0, l_29_1)
end

GroupAIStateEmpty.remove_one_teamAI = function(l_30_0, l_30_1)
end

GroupAIStateEmpty.fill_criminal_team_with_AI = function(l_31_0, l_31_1)
end

GroupAIStateEmpty.set_importance_weight = function(l_32_0, l_32_1, l_32_2)
end

GroupAIStateEmpty.on_criminal_recovered = function(l_33_0, l_33_1)
end

GroupAIStateEmpty.on_criminal_disabled = function(l_34_0, l_34_1)
end

GroupAIStateEmpty.on_criminal_neutralized = function(l_35_0, l_35_1)
end

GroupAIStateEmpty.is_detection_persistent = function(l_36_0)
end

GroupAIStateEmpty.on_nav_link_unregistered = function(l_37_0)
end

GroupAIStateEmpty.save = function(l_38_0)
end

GroupAIStateEmpty.load = function(l_39_0)
end


