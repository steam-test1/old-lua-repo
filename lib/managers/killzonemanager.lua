-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\killzonemanager.luac 

if not KillzoneManager then
  KillzoneManager = class()
end
KillzoneManager.init = function(l_1_0)
  l_1_0._units = {}
end

KillzoneManager.update = function(l_2_0, l_2_1, l_2_2)
  for _,data in pairs(l_2_0._units) do
    if alive(data.unit) then
      if data.type == "sniper" then
        data.timer = data.timer + l_2_2
        if data.next_shot < data.timer then
          local warning_time = 4
          data.next_shot = data.timer + math.rand(warning_time < data.timer and 0.5 or 1)
          do
            local warning_shot = math.max(warning_time - data.timer, 1)
            warning_shot = math.rand(warning_shot) > 0.75
            if warning_shot then
              l_2_0:_warning_shot(data.unit)
              for (for control),_ in (for generator) do
              end
              l_2_0:_deal_damage(data.unit)
            end
            for (for control),_ in (for generator) do
            end
            if data.type == "gas" then
              data.timer = data.timer + l_2_2
              if data.next_gas < data.timer then
                data.next_gas = data.timer + 0.25
                l_2_0:_deal_gas_damage(data.unit)
                for (for control),_ in (for generator) do
                end
                if data.type == "fire" then
                  data.timer = data.timer + l_2_2
                  if data.next_fire < data.timer then
                    data.next_fire = data.timer + 0.25
                    l_2_0:_deal_fire_damage(data.unit)
                  end
                end
              end
            end
          end
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

KillzoneManager.set_unit = function(l_3_0, l_3_1, l_3_2)
  if l_3_0._units[l_3_1:key()] then
    l_3_0:_remove_unit(l_3_1)
  else
    l_3_0:_add_unit(l_3_1, l_3_2)
  end
end

KillzoneManager._warning_shot = function(l_4_0, l_4_1)
  local rot = l_4_1:camera():rotation()
  rot = Rotation(rot:yaw(), 0, 0)
  local pos = l_4_1:position() + rot:y() * (100 + math.random(200))
  local dir = Rotation(math.rand(360), 0, 0):y()
  dir = dir:with_z(-0.40000000596046):normalized()
  local from_pos = pos + dir * -100
  local to_pos = pos + dir * 100
  local col_ray = World:raycast("ray", from_pos, to_pos, "slot_mask", managers.slot:get_mask("bullet_impact_targets"), "ignore_unit", l_4_1)
  if col_ray and col_ray.unit then
    managers.game_play_central:play_impact_sound_and_effects({col_ray = col_ray})
  end
end

KillzoneManager._deal_damage = function(l_5_0, l_5_1)
  if l_5_1:character_damage():need_revive() then
    return 
  end
  local col_ray = {}
  local ray = Rotation(math.rand(360), 0, 0):y()
  ray = ray:with_z(-0.40000000596046):normalized()
  col_ray.ray = ray
  local attack_data = {damage = 1, col_ray = col_ray}
  l_5_1:character_damage():damage_killzone(attack_data)
end

KillzoneManager._deal_gas_damage = function(l_6_0, l_6_1)
  local attack_data = {damage = 0.75, col_ray = {ray = math.UP}}
  l_6_1:character_damage():damage_killzone(attack_data)
end

KillzoneManager._deal_fire_damage = function(l_7_0, l_7_1)
  local attack_data = {damage = 0.5, col_ray = {ray = math.UP}}
  l_7_1:character_damage():damage_killzone(attack_data)
end

KillzoneManager._add_unit = function(l_8_0, l_8_1, l_8_2)
  if l_8_2 == "sniper" then
    local next_shot = math.rand(1)
    l_8_0._units[l_8_1:key()] = {type = l_8_2, timer = 0, next_shot = next_shot, unit = l_8_1}
    managers.hud:set_danger_visible(true, {texture = "guis/textures/warning_sniper"})
  elseif l_8_2 == "gas" then
    local next_gas = math.rand(1)
    l_8_0._units[l_8_1:key()] = {type = l_8_2, timer = 0, next_gas = next_gas, unit = l_8_1}
    managers.hud:set_danger_visible(true, {texture = "guis/textures/warning_gas"})
  elseif l_8_2 == "fire" then
    local next_fire = math.rand(1)
    l_8_0._units[l_8_1:key()] = {type = l_8_2, timer = 0, next_fire = next_fire, unit = l_8_1}
    managers.hud:set_danger_visible(true, {texture = "guis/textures/warning_gas"})
  end
end

KillzoneManager._remove_unit = function(l_9_0, l_9_1)
  l_9_0._units[l_9_1:key()] = nil
  managers.hud:set_danger_visible(false)
end


