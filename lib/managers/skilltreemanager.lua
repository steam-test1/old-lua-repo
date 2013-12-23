-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\skilltreemanager.luac 

if not SkillTreeManager then
  SkillTreeManager = class()
end
SkillTreeManager.VERSION = 4
SkillTreeManager.init = function(l_1_0)
  l_1_0:_setup()
end

SkillTreeManager._setup = function(l_2_0, l_2_1)
  if not Global.skilltree_manager or l_2_1 then
    Global.skilltree_manager = {}
    Global.skilltree_manager.points = Application:digest_value(0, true)
    Global.skilltree_manager.VERSION = SkillTreeManager.VERSION
    Global.skilltree_manager.reset_message = false
    Global.skilltree_manager.times_respeced = 1
    l_2_0._global = Global.skilltree_manager
    l_2_0._global.trees = {}
    for tree,data in pairs(tweak_data.skilltree.trees) do
      l_2_0:_create_tree_data(tree)
    end
    l_2_0._global.skills = {}
    for skill_id,data in pairs(tweak_data.skilltree.skills) do
      l_2_0._global.skills[skill_id] = {unlocked = 0, total = #data}
    end
  end
  l_2_0._global = Global.skilltree_manager
end

SkillTreeManager._create_tree_data = function(l_3_0, l_3_1)
  l_3_0._global.trees[l_3_1] = {unlocked = false, points_spent = Application:digest_value(0, true)}
end

SkillTreeManager.unlock_tree = function(l_4_0, l_4_1)
  if l_4_0._global.trees[l_4_1].unlocked then
    Application:error("Tree", l_4_1, "allready unlocked")
    return 
  end
  local skill_id = tweak_data.skilltree.trees[l_4_1].skill
  local to_unlock = managers.skilltree:next_skill_step(skill_id)
  local skill = tweak_data.skilltree.skills[skill_id][to_unlock]
  if not skill.cost or not Application:digest_value(skill.cost, false) then
    local points = Application:digest_value(tweak_data.skilltree.costs.unlock_tree, false)
  end
  if not skill or not skill.cost then
    print("[SkillTreeManager:unlock_tree] skill tree: \"" .. tostring(skill_id) .. "\" is missing cost!")
  end
  if l_4_0:points() < points then
    return 
  end
  l_4_0._global.trees[l_4_1].unlocked = true
  l_4_0:_spend_points(l_4_1, nil, points)
end

SkillTreeManager._spend_points = function(l_5_0, l_5_1, l_5_2, l_5_3)
  local pre_unlocked_tier = l_5_0:current_max_tier(l_5_1)
  managers.money:on_skillpoint_spent(l_5_1, l_5_2, l_5_3)
  l_5_0:_set_points(l_5_0:points() - l_5_3)
  l_5_0:_set_points_spent(l_5_1, l_5_0:points_spent(l_5_1) + l_5_3)
  local post_unlocked_tier = l_5_0:current_max_tier(l_5_1)
  if pre_unlocked_tier < post_unlocked_tier then
    l_5_0:_on_tier_unlocked(l_5_1, post_unlocked_tier)
  end
  l_5_0:_on_points_spent(l_5_1, l_5_3)
end

SkillTreeManager.points = function(l_6_0)
  return Application:digest_value(l_6_0._global.points, false)
end

SkillTreeManager._set_points = function(l_7_0, l_7_1)
  l_7_0._global.points = Application:digest_value(l_7_1, true)
end

SkillTreeManager.points_spent = function(l_8_0, l_8_1)
  return Application:digest_value(l_8_0._global.trees[l_8_1].points_spent, false)
end

SkillTreeManager._set_points_spent = function(l_9_0, l_9_1, l_9_2)
  l_9_0._global.trees[l_9_1].points_spent = Application:digest_value(l_9_2, true)
end

SkillTreeManager.current_max_tier = function(l_10_0, l_10_1)
  for tier,point in ipairs(tweak_data.skilltree.tier_unlocks) do
    if l_10_0:points_spent(l_10_1) < Application:digest_value(point, false) then
      return tier - 1
    end
  end
  return #tweak_data.skilltree.tier_unlocks
end

SkillTreeManager.skill_completed = function(l_11_0, l_11_1)
  return l_11_0._global.skills[l_11_1].unlocked == l_11_0._global.skills[l_11_1].total
end

SkillTreeManager.skill_step = function(l_12_0, l_12_1)
  return l_12_0._global.skills[l_12_1].unlocked
end

SkillTreeManager.next_skill_step = function(l_13_0, l_13_1)
  return l_13_0._global.skills[l_13_1].unlocked + 1
end

SkillTreeManager.next_skill_step_data = function(l_14_0, l_14_1)
  return tweak_data.skilltree.skills[l_14_1][l_14_0._global.skills[l_14_1].unlocked]
end

SkillTreeManager.skill_unlocked = function(l_15_0, l_15_1, l_15_2)
  if not l_15_1 then
    for tree_id,_ in pairs(tweak_data.skilltree.trees) do
      if l_15_0:skill_unlocked(tree_id, l_15_2) then
        return true
      end
    end
    return false
  end
  for tier,data in pairs(tweak_data.skilltree.trees[l_15_1].tiers) do
    for _,skill in ipairs(data) do
      if skill == l_15_2 then
        return l_15_0:tier_unlocked(l_15_1, tier)
      end
    end
  end
end

SkillTreeManager.unlock = function(l_16_0, l_16_1, l_16_2)
  if not l_16_0._global.trees[l_16_1].unlocked then
    Application:error("Cannot unlock skill", l_16_2, "in tree", l_16_1, ". Tree is locked")
    return 
  end
  if l_16_0._global.skills[l_16_2].total <= l_16_0._global.skills[l_16_2].unlocked then
    Application:error("No more steps to unlock in skill", l_16_2)
    return 
  end
  local talent = tweak_data.skilltree.skills[l_16_2]
  if not talent.prerequisites then
    local prerequisites = {}
  end
  for _,prerequisite in ipairs(prerequisites) do
    local unlocked = managers.skilltree:skill_step(prerequisite)
    if unlocked and unlocked == 0 then
      return 
    end
  end
  local to_unlock = managers.skilltree:next_skill_step(l_16_2)
  local skill = talent[to_unlock]
  local points = Application:digest_value(skill.cost, false)
  if l_16_0:points() < points then
    return 
  end
  l_16_0._global.skills[l_16_2].unlocked = to_unlock
  local tier = nil
  for i,tier_skills in ipairs(tweak_data.skilltree.trees[l_16_1].tiers) do
    if table.contains(tier_skills, l_16_2) then
      tier = i
  else
    end
  end
  l_16_0:_spend_points(l_16_1, tier, points)
  l_16_0:_aquire_skill(skill, l_16_2)
  l_16_0:_on_skill_unlocked(l_16_1, l_16_2)
end

SkillTreeManager._on_tier_unlocked = function(l_17_0, l_17_1, l_17_2)
  local skill_id = tweak_data.skilltree.trees[l_17_1].skill
  local to_unlock = managers.skilltree:next_skill_step(skill_id)
  repeat
    if to_unlock <= l_17_2 then
      local skill = tweak_data.skilltree.skills[skill_id][to_unlock]
      if not skill then
        print("SkillTreeManager:_on_tier_unlocked: No tier upgrade at tier", l_17_2, "for tree", l_17_1)
      else
        l_17_0._global.skills[skill_id].unlocked = to_unlock
        l_17_0:_aquire_skill(skill, skill_id)
        l_17_0:_on_skill_unlocked(l_17_1, skill_id)
        to_unlock = managers.skilltree:next_skill_step(skill_id)
      end
  end
  managers.menu_component:on_tier_unlocked(l_17_1, l_17_2)
end

SkillTreeManager._on_skill_unlocked = function(l_18_0, l_18_1, l_18_2)
  managers.menu_component:on_skill_unlocked(l_18_1, l_18_2)
end

SkillTreeManager._on_points_spent = function(l_19_0, l_19_1, l_19_2)
  l_19_0:_check_achievements()
  managers.menu_component:on_points_spent(l_19_1, l_19_2)
end

SkillTreeManager._check_achievements = function(l_20_0)
  for tree,data in pairs(l_20_0._global.trees) do
    if l_20_0:points_spent(tree) < tweak_data.achievement.im_a_healer_tank_damage_dealer then
      return 
    end
  end
  managers.achievment:award("im_a_healer_tank_damage_dealer")
end

SkillTreeManager.level_up = function(l_21_0)
  l_21_0:_aquire_points(1)
end

SkillTreeManager.rep_upgrade = function(l_22_0, l_22_1, l_22_2)
  l_22_0:_aquire_points(l_22_1 and l_22_1.value or 2)
end

SkillTreeManager._aquire_points = function(l_23_0, l_23_1)
  l_23_0:_set_points(l_23_0:points() + l_23_1)
end

SkillTreeManager.tier_unlocked = function(l_24_0, l_24_1, l_24_2)
  local required_points = Application:digest_value(tweak_data.skilltree.tier_unlocks[l_24_2], false)
  return required_points <= l_24_0:points_spent(l_24_1)
end

SkillTreeManager.tree_unlocked = function(l_25_0, l_25_1)
  return l_25_0._global.trees[l_25_1].unlocked
end

SkillTreeManager._unlock = function(l_26_0, l_26_1, l_26_2)
  local skill = tweak_data.skills.definitions[l_26_2]
  l_26_0:_aquire_skill(skill, l_26_2)
end

SkillTreeManager._aquire_skill = function(l_27_0, l_27_1, l_27_2)
  if l_27_1.upgrades then
    for _,upgrade in ipairs(l_27_1.upgrades) do
      managers.upgrades:aquire(upgrade)
    end
  end
end

SkillTreeManager._unaquire_skill = function(l_28_0, l_28_1)
  local progress_data = l_28_0._global.skills[l_28_1]
  local skill_data = tweak_data.skilltree.skills[l_28_1]
  for i = progress_data.unlocked, 1, -1 do
    local step_data = skill_data[i]
    local upgrades = step_data.upgrades
    if upgrades then
      for i = #upgrades, 1, -1 do
        local upgrade = upgrades[i]
        managers.upgrades:unaquire(upgrade)
      end
    end
  end
  progress_data.unlocked = 0
end

SkillTreeManager.on_respec_tree = function(l_29_0, l_29_1, l_29_2)
  local points_spent = l_29_0:points_spent(l_29_1)
  l_29_0:_set_points_spent(l_29_1, 0)
  l_29_0._global.trees[l_29_1].unlocked = false
  print("points_spent", points_spent, "give back")
  managers.money:on_respec_skilltree(l_29_1, l_29_2)
  local tree_data = tweak_data.skilltree.trees[l_29_1]
  for i = #tree_data.tiers, 1, -1 do
    local tier = tree_data.tiers[i]
    for _,skill in ipairs(tier) do
      l_29_0:_unaquire_skill(skill)
    end
  end
  l_29_0:_unaquire_skill(tree_data.skill)
  l_29_0:_aquire_points(points_spent)
end

SkillTreeManager.analyze = function(l_30_0)
end

SkillTreeManager.tree_stats = function(l_31_0)
end

SkillTreeManager.increase_times_respeced = function(l_32_0, l_32_1)
  l_32_0._global.times_respeced = math.clamp(l_32_0._global.times_respeced + l_32_1, 1, #tweak_data.money_manager.skilltree.respec.profile_cost_increaser_multiplier)
end

SkillTreeManager.get_times_respeced = function(l_33_0)
  return l_33_0._global.times_respeced
end

SkillTreeManager.reset_skilltrees = function(l_34_0)
  for tree_id,tree_data in pairs(l_34_0._global.trees) do
    l_34_0:on_respec_tree(tree_id, 1)
  end
  l_34_0._global.VERSION = SkillTreeManager.VERSION
  l_34_0._global.reset_message = true
  l_34_0._global.times_respeced = 1
end

SkillTreeManager.check_reset_message = function(l_35_0)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local show_reset_message = true
if show_reset_message then
  managers.menu:show_skilltree_reseted()
  l_35_0._global.reset_message = false
  MenuCallbackHandler:save_progress()
end
end

SkillTreeManager.get_tree_progress = function(l_36_0, l_36_1)
  if type(l_36_1) ~= "number" then
    local string_to_number = {mastermind = 1, enforcer = 2, technician = 3, ghost = 4}
    l_36_1 = string_to_number[l_36_1]
  end
  local td = tweak_data.skilltree.trees[l_36_1]
  local skill_id = td.skill
  local step = managers.skilltree:next_skill_step(skill_id)
  local unlocked = managers.skilltree:skill_unlocked(nil, skill_id)
  local completed = managers.skilltree:skill_completed(skill_id)
  local progress = step > 1 and 1 or 0
  local num_skills = 1
  if progress > 0 then
    for _,tier in ipairs(td.tiers) do
      for _,skill_id in ipairs(tier) do
        step = managers.skilltree:next_skill_step(skill_id)
        unlocked = managers.skilltree:skill_unlocked(nil, skill_id)
        completed = managers.skilltree:skill_completed(skill_id)
        num_skills = num_skills + 2
        progress = progress + (step > 1 and 1 or 0) + (completed and 1 or 0)
      end
    end
  end
  return progress, num_skills
end

SkillTreeManager.get_most_progressed_tree = function(l_37_0)
  local max_tree = 1
  local max_points = 0
  for tree,_ in ipairs(tweak_data.skilltree.trees) do
    local points = l_37_0:get_tree_progress(tree)
    if max_points < points then
      max_tree = tree
      max_points = points
    end
  end
  return max_tree
end

SkillTreeManager.save = function(l_38_0, l_38_1)
  local state = {points = l_38_0._global.points, trees = l_38_0._global.trees, skills = l_38_0._global.skills, VERSION = l_38_0._global.VERSION or 0, reset_message = l_38_0._global.reset_message, times_respeced = l_38_0._global.times_respeced or 1}
  l_38_1.SkillTreeManager = state
end

SkillTreeManager.load = function(l_39_0, l_39_1, l_39_2)
  local state = l_39_1.SkillTreeManager
  local points_aquired_during_load = l_39_0:points()
  if state then
    l_39_0._global.points = state.points
    for tree_id,tree_data in pairs(state.trees) do
      l_39_0._global.trees[tree_id] = tree_data
    end
    for skill_id,skill_data in pairs(state.skills) do
      if l_39_0._global.skills[skill_id] then
        l_39_0._global.skills[skill_id].unlocked = skill_data.unlocked
      end
    end
    l_39_0:_verify_loaded_data(points_aquired_during_load)
    l_39_0._global.VERSION = state.VERSION
    l_39_0._global.reset_message = state.reset_message
    l_39_0._global.times_respeced = state.times_respeced
    if not l_39_0._global.VERSION or l_39_0._global.VERSION < SkillTreeManager.VERSION then
      managers.savefile:add_load_done_callback(callback(l_39_0, l_39_0, "reset_skilltrees"))
    end
  end
end

SkillTreeManager._verify_loaded_data = function(l_40_0, l_40_1)
  local level_points = managers.experience:current_level()
  local assumed_points = level_points + l_40_1
  local points = l_40_0:points()
  for tree_id,data in pairs(clone(l_40_0._global.trees)) do
    points = points + Application:digest_value(data.points_spent, false)
  end
  if points < assumed_points then
    l_40_0:_set_points(l_40_0:points() + (assumed_points - (points)))
  end
  for tree_id,data in pairs(clone(l_40_0._global.trees)) do
    if not tweak_data.skilltree.trees[tree_id] then
      print("[SkillTreeManager:_verify_loaded_data] Tree doesn't exists", tree_id, ", removing loaded data.")
      l_40_0._global.trees[tree_id] = nil
    end
  end
  for tree_id,tree_data in pairs(l_40_0._global.trees) do
    if tree_data.unlocked and not tweak_data.skilltree.trees[tree_id].dlc then
      local skill_id = tweak_data.skilltree.trees[tree_id].skill
      local skill = tweak_data.skilltree.skills[skill_id]
      local skill_data = l_40_0._global.skills[skill_id]
      for i = 1, skill_data.unlocked do
        l_40_0:_aquire_skill(skill[i], skill_id)
      end
      for tier,skills in pairs(tweak_data.skilltree.trees[tree_id].tiers) do
        for _,skill_id in ipairs(skills) do
          local skill = tweak_data.skilltree.skills[skill_id]
          local skill_data = l_40_0._global.skills[skill_id]
          for i = 1, skill_data.unlocked do
            l_40_0:_aquire_skill(skill[i], skill_id)
          end
        end
      end
    end
  end
end

SkillTreeManager.debug = function(l_41_0)
  managers.debug:set_enabled(true)
  managers.debug:set_systems_enabled(true, {"gui"})
  local gui = managers.debug._system_list.gui
  gui:clear()
  local j = 1
  local add_func = function(l_1_0)
    local skill = tweak_data.skilltree.skills[l_1_0]
    local skill_data = self._global.skills[l_1_0]
    for i = 1, skill_data.unlocked do
      local sub_skill = skill[i]
      do
        local type = i == 1 and "STD" or "PRO"
        if sub_skill.upgrades then
          for _,upgrade in ipairs(sub_skill.upgrades) do
            do
              local value = managers.upgrades:get_value(upgrade)
              do
                if value then
                  if managers.upgrades:get_category(upgrade) == "temporary" then
                    local u = managers.upgrades:get_upgrade_upgrade(upgrade)
                    do
                      local index = j
                      gui:set_func(j, function()
                        if managers.player:has_activate_temporary_upgrade(u.category, u.upgrade) then
                          gui:set_color(index, 0, 1, 0)
                        else
                          if math.mod(index, 2) == 0 then
                            gui:set_color(index, 0.75, 0.75, 0.75, 0.5)
                          else
                            gui:set_color(index, 1, 1, 1, 0.5)
                          end
                        end
                        return skill_id .. " " .. type .. " - " .. upgrade .. ":    " .. tostring(value)
                                 end)
                    end
                  else
                    gui:set_func(j, function()
                    return skill_id .. " " .. type .. " - " .. upgrade .. ":    " .. tostring(value)
                           end)
                    if math.mod(j, 2) == 0 then
                      gui:set_color(j, 0.75, 0.75, 0.75)
                    else
                      gui:set_color(j, 1, 1, 1)
                    end
                  end
                  upvalue_512 = j + 1
                end
              end
            end
          end
        else
          gui:set_func(j, function()
          return skill_id .. " " .. type .. ""
            end)
          upvalue_512 = j + 1
        end
      end
    end
   end
  for tree_id,tree_data in pairs(l_41_0._global.trees) do
    if tree_data.unlocked and not tweak_data.skilltree.trees[tree_id].dlc then
      local skill_id = tweak_data.skilltree.trees[tree_id].skill
      add_func(skill_id)
      for tier,skills in pairs(tweak_data.skilltree.trees[tree_id].tiers) do
        for _,skill_id in ipairs(skills) do
          add_func(skill_id)
        end
      end
    end
  end
end

SkillTreeManager.reset = function(l_42_0)
  Global.skilltree_manager = nil
  l_42_0:_setup()
end


