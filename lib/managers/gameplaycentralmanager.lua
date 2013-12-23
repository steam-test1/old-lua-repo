-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\gameplaycentralmanager.luac 

local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local empty_idstr = Idstring("")
local idstr_concrete = Idstring("concrete")
local idstr_contour_color = Idstring("contour_color")
local idstr_contour_opacity = Idstring("contour_opacity")
local idstr_material = Idstring("material")
local idstr_blood_spatter = Idstring("blood_spatter")
local idstr_blood_screen = Idstring("effects/particles/character/player/blood_screen")
local idstr_bullet_hit_blood = Idstring("effects/payday2/particles/impacts/blood/blood_impact_a")
local idstr_fallback = Idstring("effects/payday2/particles/impacts/fallback_impact_pd2")
local idstr_no_material = Idstring("no_material")
local idstr_bullet_hit = Idstring("bullet_hit")
if not GamePlayCentralManager then
  GamePlayCentralManager = class()
end
GamePlayCentralManager.init = function(l_1_0)
  l_1_0._bullet_hits = {}
  l_1_0._play_effects = {}
  l_1_0._play_sounds = {}
  l_1_0._footsteps = {}
  l_1_0._effect_manager = World:effect_manager()
  l_1_0._slotmask_flesh = managers.slot:get_mask("flesh")
  l_1_0._slotmask_world_geometry = managers.slot:get_mask("world_geometry")
  l_1_0._slotmask_physics_push = managers.slot:get_mask("bullet_physics_push")
  l_1_0._slotmask_footstep = managers.slot:get_mask("footstep")
  l_1_0._slotmask_bullet_impact_targets = managers.slot:get_mask("bullet_impact_targets")
  l_1_0._contour = {index = 1, units = {}}
  l_1_0._enemy_contour_units = {}
  l_1_0._friendly_contour_units = {}
  l_1_0:_init_impact_sources()
  if Global.level_data and Global.level_data.level_id then
    local lvl_tweak_data = tweak_data.levels[Global.level_data.level_id]
  end
  if lvl_tweak_data then
    l_1_0._flashlights_on = lvl_tweak_data.flashlights_on
  end
  l_1_0._dropped_weapons = {index = 1, units = {}}
  l_1_0._flashlights_on_player_on = false
  if lvl_tweak_data and lvl_tweak_data.environment_effects then
    for _,effect in ipairs(lvl_tweak_data.environment_effects) do
      managers.environment_effects:use(effect)
    end
  end
  l_1_0._mission_disabled_units = {}
  l_1_0._heist_timer = {start_time = 0, running = false}
  local is_ps3 = SystemInfo:platform() == Idstring("PS3")
  local is_x360 = SystemInfo:platform() == Idstring("X360")
  l_1_0._block_bullet_decals = is_ps3 or is_x360
  l_1_0._block_blood_decals = is_x360
end

GamePlayCentralManager.restart_portal_effects = function(l_2_0)
  if not l_2_0._portal_effects_restarted then
    l_2_0._portal_effects_restarted = true
    if Network:is_client() then
      managers.portal:restart_effects()
    end
  end
end

GamePlayCentralManager._init_impact_sources = function(l_3_0)
  l_3_0._impact_sounds = {index = 1, sources = {}}
  for i = 1, 20 do
    table.insert(l_3_0._impact_sounds.sources, SoundDevice:create_source("impact_sound" .. i))
  end
  l_3_0._impact_sounds.max_index = #l_3_0._impact_sounds.sources
end

GamePlayCentralManager._get_impact_source = function(l_4_0)
  local source = l_4_0._impact_sounds.sources[l_4_0._impact_sounds.index]
  l_4_0._impact_sounds.index = l_4_0._impact_sounds.index < l_4_0._impact_sounds.max_index and l_4_0._impact_sounds.index + 1 or 1
  return source
end

GamePlayCentralManager.test_current_weapon_cycle = function(l_5_0, l_5_1, l_5_2)
  local unit = managers.player:player_unit()
  local weapon = unit:inventory():equipped_unit()
  if not l_5_1 or not managers.weapon_factory:create_limited_blueprints(weapon:base()._factory_id) then
    local blueprints = managers.weapon_factory:create_blueprints(weapon:base()._factory_id)
  end
  l_5_0:test_weapon_cycle(weapon, blueprints, l_5_2)
end

GamePlayCentralManager.test_weapon_cycle = function(l_6_0, l_6_1, l_6_2, l_6_3)
  l_6_0._test_weapon = l_6_1
  l_6_0._test_weapon_force_gadget = not l_6_3
  l_6_0._blueprints = l_6_2
  l_6_0._blueprint_random = not l_6_3
  l_6_0._blueprint_i = 1
  l_6_0._blueprint_t = not l_6_3 and Application:time() or nil
  l_6_0._pause_weapon_cycle = false
end

GamePlayCentralManager.toggle_pause_weapon_cycle = function(l_7_0)
  l_7_0._pause_weapon_cycle = not l_7_0._pause_weapon_cycle
end

GamePlayCentralManager.next_weapon = function(l_8_0)
  if alive(l_8_0._test_weapon) then
    if not l_8_0._blueprint_random or not l_8_0._blueprints[math.random(#l_8_0._blueprints)] then
      local blueprint = l_8_0._blueprints[l_8_0._blueprint_i]
    end
    l_8_0._test_weapon:base():change_blueprint(blueprint)
    if l_8_0._test_weapon_force_gadget then
      l_8_0._test_weapon:base():gadget_on()
    end
    l_8_0._blueprint_i = l_8_0._blueprint_i + 1
    if #l_8_0._blueprints < l_8_0._blueprint_i then
      l_8_0._blueprint_i = 1
    end
    if managers.player:player_unit() then
      managers.player:player_unit():inventory():_send_equipped_weapon()
    end
  end
end

GamePlayCentralManager.stop_test_weapon_cycle = function(l_9_0)
  l_9_0._test_weapon = nil
end

GamePlayCentralManager.update = function(l_10_0, l_10_1, l_10_2)
  if alive(l_10_0._test_weapon) and l_10_0._blueprint_t and l_10_0._blueprint_t < l_10_1 then
    l_10_0._blueprint_t = Application:time() + 0.10000000149012
    if not l_10_0._pause_weapon_cycle then
      l_10_0:next_weapon()
    end
  end
  if #l_10_0._contour.units > 0 then
    local cam_pos = managers.viewport:get_current_camera_position()
    if not cam_pos then
      return 
    end
    local data = l_10_0._contour.units[l_10_0._contour.index]
    local unit = data.unit
    local on = false
    if mvector3.distance_sq(cam_pos, data.movement:m_com()) > 16000000 then
      on = true
    else
      on = unit:raycast("ray", data.movement:m_com(), cam_pos, "slot_mask", l_10_0._slotmask_world_geometry, "report")
    end
    data.target_opacity = on and 0.64999997615814 or 0
    if data.type == "character" then
      local anim_data = data.anim_data
      if not anim_data.bleedout then
        local downed = anim_data.fatal
      end
      local dead = anim_data.death
      local hands_tied = anim_data.hands_tied
      on = downed or dead or hands_tied
      local color_id = managers.criminals:character_color_id_by_unit(unit)
      if (not dead or not data.dead_color) and ((not hands_tied and not downed) or not data.downed_color and (not color_id or not tweak_data.peer_vector_colors[color_id])) then
        data.target_color = data.standard_color
      end
      if on and ((not downed and not dead and not hands_tied) or not 1) then
        data.target_opacity = data.target_opacity
      end
    end
    if data.color ~= data.target_color then
      data.color = math.step(data.color, data.target_color, 6 * l_10_2)
      for _,material in ipairs(data.materials) do
        material:set_variable(idstr_contour_color, data.color)
      end
    end
    if data.flash > 0 then
      data.flash = math.max(0, data.flash - l_10_2 * 2)
      local o = math.sin(data.flash * 360 + 45)
      data.target_opacity = math.max(0, math.min(1, o))
    end
    if data.opacity ~= data.target_opacity then
      data.opacity = math.step(data.opacity, data.target_opacity, 6 * l_10_2)
      for _,material in ipairs(data.materials) do
        material:set_variable(idstr_contour_opacity, data.opacity)
      end
    end
    l_10_0._contour.index = l_10_0._contour.index + 1
    l_10_0._contour.index = l_10_0._contour.index <= #l_10_0._contour.units and l_10_0._contour.index or 1
  end
  for key,data in pairs(l_10_0._friendly_contour_units) do
    local unit = data.unit
    if not alive(unit) then
      l_10_0._friendly_contour_units[key] = nil
      managers.occlusion:add_occlusion(unit)
      for (for control),key in (for generator) do
      end
      if unit:character_damage() and unit:character_damage():dead() then
        l_10_0._friendly_contour_units[key] = nil
        managers.occlusion:add_occlusion(unit)
        unit:base():swap_material_config()
        unit:base():set_allow_invisible(true)
      end
    end
    for key,data in pairs(l_10_0._enemy_contour_units) do
      local unit = data.unit
      if not alive(unit) then
        l_10_0._enemy_contour_units[key] = nil
        managers.occlusion:add_occlusion(unit)
        for (for control),key in (for generator) do
        end
        if data.color ~= data.target_color then
          data.color = math.step(data.color, data.target_color, 0.30000001192093 * l_10_2)
          for _,material in ipairs(data.materials) do
            material:set_variable(idstr_contour_color, data.color)
          end
        end
        if data.opacity ~= data.target_opacity then
          data.opacity = math.step(data.opacity, data.target_opacity, 0.30000001192093 * l_10_2)
          for _,material in ipairs(data.materials) do
            material:set_variable(idstr_contour_opacity, math.min(1.5, data.opacity))
          end
        end
        if data.opacity == data.target_opacity then
          l_10_0._enemy_contour_units[key] = nil
          managers.occlusion:add_occlusion(unit)
          unit:base():swap_material_config()
          unit:base():set_allow_invisible(true)
          unit:character_damage():on_marked_state(false)
        end
      end
      if #l_10_0._dropped_weapons.units > 0 then
        local data = l_10_0._dropped_weapons.units[l_10_0._dropped_weapons.index]
        local unit = data.unit
        data.t = data.t + (l_10_1 - data.last_t)
        data.last_t = l_10_1
        local alive = alive(unit)
        if not alive then
          table.remove(l_10_0._dropped_weapons.units, l_10_0._dropped_weapons.index)
         -- DECOMPILER ERROR: unhandled construct in 'if'

        elseif data.state == "wait" and data.t > 4 then
          data.flashlight_data.light:set_enable(false)
          data.flashlight_data.effect:kill_effect()
          data.state = "off"
          data.t = 0
          do return end
           -- DECOMPILER ERROR: unhandled construct in 'if'

          if data.state == "off" and data.t > 0.20000000298023 then
            data.flashlight_data.light:set_enable(true)
            data.flashlight_data.effect:activate()
            data.state = "on"
            data.t = 0
            do return end
            if data.state == "on" and data.t > 0.10000000149012 then
              data.flashlight_data.light:set_enable(false)
              data.flashlight_data.effect:kill_effect()
              table.remove(l_10_0._dropped_weapons.units, l_10_0._dropped_weapons.index)
            end
          end
        end
        l_10_0._dropped_weapons.index = l_10_0._dropped_weapons.index + 1
        l_10_0._dropped_weapons.index = l_10_0._dropped_weapons.index <= #l_10_0._dropped_weapons.units and l_10_0._dropped_weapons.index or 1
      end
      if l_10_0._heist_timer.running then
        managers.hud:feed_heist_time(Application:time() - l_10_0._heist_timer.start_time + l_10_0._heist_timer.offset_time)
        if Network:is_server() and l_10_0._heist_timer.next_sync < Application:time() then
          l_10_0._heist_timer.next_sync = Application:time() + 9
          local heist_time = Application:time() - l_10_0._heist_timer.start_time
          for peer_id,peer in pairs(managers.network:session():peers()) do
            peer:send_queued_sync("sync_heist_time", heist_time + Network:qos(peer:rpc()).ping / 1000)
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GamePlayCentralManager.add_enemy_contour = function(l_11_0, l_11_1, l_11_2)
  if not l_11_0._enemy_contour_units[l_11_1:key()] then
    l_11_1:base():swap_material_config()
    managers.occlusion:remove_occlusion(l_11_1)
    l_11_1:base():set_allow_invisible(false)
  else
    if l_11_1:base():is_in_original_material() then
      l_11_1:base():swap_material_config()
    end
  end
  l_11_1:character_damage():on_marked_state(l_11_2)
  if not l_11_2 or not tweak_data.contour.character.more_dangerous_color then
    local color = tweak_data.contour.character.dangerous_color
  end
  local materials = l_11_1:get_objects_by_type(idstr_material)
  for _,m in ipairs(materials) do
    m:set_variable(idstr_contour_color, color)
    m:set_variable(idstr_contour_opacity, 0)
  end
  l_11_0._enemy_contour_units[l_11_1:key()] = {unit = l_11_1, materials = materials, color = color, target_color = color, opacity = tweak_data.character[l_11_1:base()._tweak_table].silent_priority_shout and 4.5 or 1.5, target_opacity = 0}
end

GamePlayCentralManager.add_friendly_contour = function(l_12_0, l_12_1)
  if not l_12_0._friendly_contour_units[l_12_1:key()] then
    l_12_1:base():swap_material_config()
    managers.occlusion:remove_occlusion(l_12_1)
    l_12_1:base():set_allow_invisible(false)
  end
  local color = tweak_data.contour.character.friendly_color
  local materials = l_12_1:get_objects_by_type(idstr_material)
  for _,m in ipairs(materials) do
    m:set_variable(idstr_contour_color, color)
    m:set_variable(idstr_contour_opacity, 1)
  end
  l_12_0._friendly_contour_units[l_12_1:key()] = {unit = l_12_1, materials = materials}
end

GamePlayCentralManager.add_contour_unit = function(l_13_0, l_13_1, l_13_2)
  local standard_color = tweak_data.contour[l_13_2].standard_color
  local downed_color = tweak_data.contour[l_13_2].downed_color
  local dead_color = tweak_data.contour[l_13_2].dead_color
  local materials = l_13_1:get_objects_by_type(idstr_material)
  for _,m in ipairs(materials) do
    m:set_variable(idstr_contour_color, standard_color)
    m:set_variable(idstr_contour_opacity, 0)
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  table.insert(l_13_0._contour.units, {unit = l_13_1, type = l_13_2, anim_data = l_13_1:anim_data(), movement = l_13_1:movement(), materials = materials, standard_color = standard_color, downed_color = downed_color, dead_color = dead_color, color = standard_color, target_color = standard_color})
  {unit = l_13_1, type = l_13_2, anim_data = l_13_1:anim_data(), movement = l_13_1:movement(), materials = materials, standard_color = standard_color, downed_color = downed_color, dead_color = dead_color, color = standard_color, target_color = standard_color}.flash, {unit = l_13_1, type = l_13_2, anim_data = l_13_1:anim_data(), movement = l_13_1:movement(), materials = materials, standard_color = standard_color, downed_color = downed_color, dead_color = dead_color, color = standard_color, target_color = standard_color}.target_opacity, {unit = l_13_1, type = l_13_2, anim_data = l_13_1:anim_data(), movement = l_13_1:movement(), materials = materials, standard_color = standard_color, downed_color = downed_color, dead_color = dead_color, color = standard_color, target_color = standard_color}.opacity = 0, 0, 0
  l_13_0._contour.index = 1
end

GamePlayCentralManager.change_contour_material_by_unit = function(l_14_0, l_14_1)
  for _,contour_data in ipairs(l_14_0._contour.units) do
    if contour_data.unit == l_14_1 then
      local materials = l_14_1:get_objects_by_type(idstr_material)
      contour_data.materials = materials
  else
    end
  end
end

GamePlayCentralManager.remove_contour_unit = function(l_15_0, l_15_1)
  for i,data in pairs(l_15_0._contour.units) do
    if data.unit == l_15_1 then
      table.remove(l_15_0._contour.units, i)
  else
    end
  end
  l_15_0._contour.index = 1
end

GamePlayCentralManager.flash_contour = function(l_16_0, l_16_1)
  for i,data in pairs(l_16_0._contour.units) do
    if data.unit == l_16_1 then
      data.flash = 3
  else
    end
  end
end

GamePlayCentralManager.end_update = function(l_17_0, l_17_1, l_17_2)
  l_17_0._camera_pos = managers.viewport:get_current_camera_position()
  l_17_0:_flush_bullet_hits()
  l_17_0:_flush_play_effects()
  l_17_0:_flush_play_sounds()
  l_17_0:_flush_footsteps()
end

GamePlayCentralManager.play_impact_sound_and_effects = function(l_18_0, l_18_1)
  table.insert(l_18_0._bullet_hits, l_18_1)
end

GamePlayCentralManager.request_play_footstep = function(l_19_0, l_19_1, l_19_2)
  if l_19_0._camera_pos then
    local dis = mvector3.distance_sq(l_19_0._camera_pos, l_19_2)
    if dis < 250000 and #l_19_0._footsteps < 3 then
      table.insert(l_19_0._footsteps, {unit = l_19_1, dis = dis})
    end
  end
end

GamePlayCentralManager.physics_push = function(l_20_0, l_20_1)
  local unit = l_20_1.unit
  if unit:in_slot(l_20_0._slotmask_physics_push) then
    local body = l_20_1.body
    if not body:dynamic() then
      local original_body_com = (body:center_of_mass())
      local closest_body_dis_sq = nil
      local nr_bodies = unit:num_bodies()
      local i_body = 0
      repeat
        if i_body < nr_bodies then
          local test_body = unit:body(i_body)
          if test_body:enabled() and test_body:dynamic() then
            local test_dis_sq = mvector3.distance_sq(test_body:center_of_mass(), original_body_com)
            if not closest_body_dis_sq or test_dis_sq < closest_body_dis_sq then
              closest_body_dis_sq = test_dis_sq
              body = test_body
            end
          end
          i_body = i_body + 1
      end
      local body_mass = math.min(50, body:mass())
      local len = mvector3.distance(l_20_1.position, body:center_of_mass())
      local body_vel = body:velocity()
      mvector3.set(tmp_vec1, l_20_1.ray)
      local vel_dot = mvector3.dot(body_vel, tmp_vec1)
      local max_vel = 600
      if vel_dot < max_vel then
        local push_vel = max_vel - math.max(vel_dot, 0)
        push_vel = math.lerp(push_vel * 0.69999998807907, push_vel, math.random())
        mvector3.multiply(tmp_vec1, push_vel)
        body:push_at(body_mass, tmp_vec1, l_20_1.position)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GamePlayCentralManager.play_impact_flesh = function(l_21_0, l_21_1)
  local col_ray = l_21_1.col_ray
  if alive(col_ray.unit) and col_ray.unit:in_slot(l_21_0._slotmask_flesh) then
    if not l_21_0._block_blood_decals then
      local splatter_from = col_ray.position
      local splatter_to = col_ray.position + col_ray.ray * 1000
      local splatter_ray = col_ray.unit:raycast("ray", splatter_from, splatter_to, "slot_mask", l_21_0._slotmask_world_geometry)
      if splatter_ray then
        World:project_decal(idstr_blood_spatter, splatter_ray.position, splatter_ray.ray, splatter_ray.unit, nil, splatter_ray.normal)
      end
    end
    if managers.player:player_unit() and mvector3.distance_sq(col_ray.position, managers.player:player_unit():movement():m_head_pos()) < 40000 then
      l_21_0._effect_manager:spawn({effect = idstr_blood_screen, position = Vector3(), rotation = Rotation()})
    end
  end
end

GamePlayCentralManager.sync_play_impact_flesh = function(l_22_0, l_22_1, l_22_2)
  local splatter_from = l_22_1
  local splatter_to = l_22_1 + l_22_2 * 1000
  local splatter_ray = World:raycast("ray", splatter_from, splatter_to, "slot_mask", l_22_0._slotmask_world_geometry)
  if splatter_ray then
    World:project_decal(idstr_blood_spatter, splatter_ray.position, splatter_ray.ray, splatter_ray.unit, nil, splatter_ray.normal)
  end
  l_22_0._effect_manager:spawn({effect = idstr_bullet_hit_blood, position = l_22_1, normal = l_22_2})
  if managers.player:player_unit() and mvector3.distance_sq(splatter_from, managers.player:player_unit():movement():m_head_pos()) < 40000 then
    l_22_0._effect_manager:spawn({effect = idstr_blood_screen, position = Vector3(), rotation = Rotation()})
  end
  local sound_source = l_22_0:_get_impact_source()
  sound_source:stop()
  sound_source:set_position(l_22_1)
  sound_source:set_switch("materials", "flesh")
  sound_source:post_event("bullet_hit")
end

GamePlayCentralManager.material_name = function(l_23_0, l_23_1)
  local material = tweak_data.materials[l_23_1:key()]
  if not material then
    Application:error("Sound for material not found: " .. tostring(l_23_1))
    material = "no_material"
  end
  return material
end

GamePlayCentralManager.spawn_pickup = function(l_24_0, l_24_1)
  if not tweak_data.pickups[l_24_1.name] then
    Application:error("No pickup definition for " .. tostring(l_24_1.name))
    return 
  end
  local unit_name = tweak_data.pickups[l_24_1.name].unit
  World:spawn_unit(unit_name, l_24_1.position, l_24_1.rotation)
end

GamePlayCentralManager._flush_bullet_hits = function(l_25_0)
  if #l_25_0._bullet_hits > 0 then
    l_25_0:_play_bullet_hit(table.remove(l_25_0._bullet_hits, 1))
  end
end

GamePlayCentralManager._flush_play_effects = function(l_26_0)
  repeat
    if #l_26_0._play_effects > 0 then
      l_26_0._effect_manager:spawn(table.remove(l_26_0._play_effects, 1))
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

GamePlayCentralManager._flush_play_sounds = function(l_27_0)
  repeat
    if #l_27_0._play_sounds > 0 then
      l_27_0:_play_sound(table.remove(l_27_0._play_sounds, 1))
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

local zero_vector = Vector3()
GamePlayCentralManager._play_bullet_hit = function(l_28_0, l_28_1)
  local hit_pos = l_28_1.col_ray.position
  local need_sound = (not l_28_1.no_sound and World:in_view_with_options(hit_pos, 2000, 0, 0))
  local need_effect = World:in_view_with_options(hit_pos, 20, 100, 5000)
  local need_decal = ((l_28_0._block_bullet_decals or l_28_1.no_decal or need_effect) and World:in_view_with_options(hit_pos, 3000, 0, 0))
  if not need_sound and not need_effect and not need_decal then
    return 
  end
  if not alive(l_28_1.col_ray.unit) then
    return 
  end
  local col_ray = l_28_1.col_ray
  local event = l_28_1.event or "bullet_hit"
  local decal = l_28_1.decal and Idstring(l_28_1.decal) or idstr_bullet_hit
  if not l_28_1.slot_mask then
    local slot_mask = l_28_0._slotmask_bullet_impact_targets
  end
  local sound_switch_name = nil
  local decal_ray_from = tmp_vec1
  local decal_ray_to = tmp_vec2
  mvector3.set(decal_ray_from, col_ray.ray)
  mvector3.set(decal_ray_to, hit_pos)
  mvector3.multiply(decal_ray_from, 25)
  mvector3.add(decal_ray_to, decal_ray_from)
  mvector3.negate(decal_ray_from)
  mvector3.add(decal_ray_from, hit_pos)
  local material_name, pos, norm = World:pick_decal_material(col_ray.unit, decal_ray_from, decal_ray_to, slot_mask)
  material_name = (material_name ~= empty_idstr and material_name)
  local effect = nil
  if not col_ray.sphere_cast_radius or not col_ray.ray * col_ray.sphere_cast_radius then
    local offset = not material_name or zero_vector
  end
  do
    local redir_name = nil
    if need_decal then
      redir_name, pos, norm = World:project_decal(decal, hit_pos + offset, col_ray.ray, col_ray.unit, math.UP, col_ray.normal)
    elseif need_effect then
      redir_name, pos, norm = World:pick_decal_effect(decal, col_ray.unit, decal_ray_from, decal_ray_to, slot_mask)
    end
    if redir_name == empty_idstr then
      redir_name = idstr_fallback
    end
    if need_effect then
      effect = {effect = redir_name, position = hit_pos + offset, normal = col_ray.normal}
    end
    sound_switch_name = not need_sound or material_name
  end
  do return end
  if need_effect then
    local generic_effect = idstr_fallback
    effect = {effect = generic_effect, position = hit_pos, normal = col_ray.normal}
  end
  sound_switch_name = not need_sound or idstr_no_material
  table.insert(l_28_0._play_effects, effect)
  if need_sound then
    table.insert(l_28_0._play_sounds, {sound_switch_name = sound_switch_name, position = hit_pos, event = event})
  end
end

GamePlayCentralManager._play_sound = function(l_29_0, l_29_1)
  local sound_source = l_29_0:_get_impact_source()
  sound_source:stop()
  sound_source:set_position(l_29_1.position)
  sound_source:set_switch("materials", l_29_0:material_name(l_29_1.sound_switch_name))
  sound_source:post_event(l_29_1.event)
end

GamePlayCentralManager._flush_footsteps = function(l_30_0)
  local footstep = table.remove(l_30_0._footsteps, 1)
  if footstep and alive(footstep.unit) then
    local sound_switch_name = nil
    if footstep.dis < 2000 then
      local ext_movement = footstep.unit:movement()
      local decal_ray_from = tmp_vec1
      local decal_ray_to = tmp_vec2
      mvector3.set(decal_ray_from, ext_movement:m_head_pos())
      mvector3.set(decal_ray_to, math.UP)
      mvector3.multiply(decal_ray_to, -250)
      mvector3.add(decal_ray_to, decal_ray_from)
      local material_name, pos, norm = nil, nil, nil
      local ground_ray = ext_movement:ground_ray()
      if ground_ray and ground_ray.unit then
        material_name, pos, norm = World:pick_decal_material(ground_ray.unit, decal_ray_from, decal_ray_to, l_30_0._slotmask_footstep)
      else
        material_name, pos, norm = World:pick_decal_material(decal_ray_from, decal_ray_to, l_30_0._slotmask_footstep)
      end
      material_name = (material_name ~= empty_idstr and material_name)
      if material_name then
        sound_switch_name = material_name
      else
        sound_switch_name = idstr_no_material
      end
    else
      sound_switch_name = idstr_concrete
    end
    local sound_source = footstep.unit:sound_source()
    sound_source:set_switch("materials", l_30_0:material_name(sound_switch_name))
    local event = footstep.unit:movement():get_footstep_event()
    sound_source:post_event(event)
  end
end

GamePlayCentralManager.weapon_dropped = function(l_31_0, l_31_1)
  local flashlight_data = l_31_1:base():flashlight_data()
  if not flashlight_data then
    return 
  end
  flashlight_data.dropped = true
  if not l_31_1:base():has_flashlight_on() then
    return 
  end
  l_31_1:set_flashlight_light_lod_enabled(true)
  table.insert(l_31_0._dropped_weapons.units, {unit = l_31_1, flashlight_data = flashlight_data, last_t = Application:time(), t = 0, state = "wait"})
end

GamePlayCentralManager.set_flashlights_on = function(l_32_0, l_32_1)
  if l_32_0._flashlights_on == l_32_1 then
    return 
  end
  l_32_0._flashlights_on = l_32_1
  local weapons = World:find_units_quick("all", 13)
  for _,weapon in ipairs(weapons) do
    weapon:base():flashlight_state_changed()
  end
end

GamePlayCentralManager.flashlights_on = function(l_33_0)
  return l_33_0._flashlights_on
end

GamePlayCentralManager.on_simulation_ended = function(l_34_0)
  l_34_0:set_flashlights_on(false)
  l_34_0:set_flashlights_on_player_on(false)
end

GamePlayCentralManager.set_flashlights_on_player_on = function(l_35_0, l_35_1)
  if l_35_0._flashlights_on_player_on == l_35_1 then
    return 
  end
  l_35_0._flashlights_on_player_on = l_35_1
  local player_unit = managers.player:player_unit()
  if player_unit and alive(player_unit:camera():camera_unit()) then
    player_unit:camera():camera_unit():base():check_flashlight_enabled()
  end
end

GamePlayCentralManager.flashlights_on_player_on = function(l_36_0)
  return l_36_0._flashlights_on_player_on
end

GamePlayCentralManager.mission_disable_unit = function(l_37_0, l_37_1)
  if alive(l_37_1) then
    if l_37_1:name() == Idstring("units/payday2/vehicles/air_vehicle_blackhawk/helicopter_cops_ref") then
      print("[GamePlayCentralManager:mission_disable_unit]", l_37_1)
    end
    l_37_0._mission_disabled_units[l_37_1:unit_data().unit_id] = true
    l_37_1:set_enabled(false)
  end
end

GamePlayCentralManager.mission_enable_unit = function(l_38_0, l_38_1)
  if alive(l_38_1) then
    if l_38_1:name() == Idstring("units/payday2/vehicles/air_vehicle_blackhawk/helicopter_cops_ref") then
      print("[GamePlayCentralManager:mission_enable_unit]", l_38_1)
    end
    l_38_0._mission_disabled_units[l_38_1:unit_data().unit_id] = nil
    l_38_1:set_enabled(true)
  end
end

GamePlayCentralManager.start_heist_timer = function(l_39_0)
  l_39_0._heist_timer.running = true
  l_39_0._heist_timer.start_time = Application:time()
  l_39_0._heist_timer.offset_time = 0
  l_39_0._heist_timer.next_sync = Application:time() + 10
end

GamePlayCentralManager.stop_heist_timer = function(l_40_0)
  l_40_0._heist_timer.running = false
end

GamePlayCentralManager.sync_heist_time = function(l_41_0, l_41_1)
  l_41_0._heist_timer.offset_time = l_41_1
  l_41_0._heist_timer.start_time = Application:time()
end

GamePlayCentralManager.save = function(l_42_0, l_42_1)
  local state = {flashlights_on = l_42_0._flashlights_on, mission_disabled_units = l_42_0._mission_disabled_units, flashlights_on_player_on = l_42_0._flashlights_on_player_on, heist_timer = Application:time() - l_42_0._heist_timer.start_time, heist_timer_running = l_42_0._heist_timer.running}
  l_42_1.GamePlayCentralManager = state
end

GamePlayCentralManager.load = function(l_43_0, l_43_1)
  local state = l_43_1.GamePlayCentralManager
  l_43_0:set_flashlights_on(state.flashlights_on)
  l_43_0:set_flashlights_on_player_on(state.flashlights_on_player_on)
  if state.mission_disabled_units then
    for id,_ in pairs(state.mission_disabled_units) do
      l_43_0:mission_disable_unit(managers.worlddefinition:get_unit_on_load(id, callback(l_43_0, l_43_0, "mission_disable_unit")))
    end
  end
  if state.heist_timer then
    l_43_0._heist_timer.offset_time = state.heist_timer
    l_43_0._heist_timer.start_time = Application:time()
    l_43_0._heist_timer.running = state.heist_timer_running
  end
end

GamePlayCentralManager.debug_weapon = function(l_44_0)
  managers.debug:set_enabled(true)
  managers.debug:set_systems_enabled(true, {"gui"})
  local gui = managers.debug._system_list.gui
  local tweak_data = tweak_data.weapon.stats
  gui:clear()
  local add_func = function()
    if not managers.player:player_unit() or not managers.player:player_unit():alive() then
      return ""
    end
    local unit = managers.player:player_unit()
    local weapon = unit:inventory():equipped_unit()
    local blueprint = weapon:base()._blueprint
    local parts_stats = managers.weapon_factory:debug_get_stats(weapon:base()._factory_id, blueprint)
    local add_line = function(l_1_0, l_1_1)
      return l_1_0 .. l_1_1 .. "\n"
      end
    local text = ""
    text = add_line(text, weapon:base()._name_id)
    local base_stats = weapon:base():weapon_tweak_data().stats
    if not base_stats or not deep_clone(base_stats) then
      local stats = {}
    end
    for part_id,part in pairs(parts_stats) do
      for stat_id,stat in pairs(part) do
        if not stats[stat_id] then
          stats[stat_id] = 0
        end
        stats[stat_id] = math.clamp(stats[stat_id] + stat, 1, #tweak_data[stat_id])
      end
    end
    for stat_id,stat in pairs(stats) do
      if stat_id ~= "damage" then
        text = add_line(text, "         " .. stat_id .. " " .. stat)
      end
    end
    for part_id,part in pairs(parts_stats) do
      text = add_line(text, part_id)
      for stat_id,stat in pairs(part) do
        if stat_id ~= "damage" then
          text = add_line(text, "         " .. stat_id .. " " .. stat)
        end
      end
    end
    return text
   end
  gui:set_func(1, add_func)
  gui:set_color(1, 1, 1, 1)
end


