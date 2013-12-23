-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\beings\player\playermovement.luac 

require("lib/units/beings/player/states/PlayerMovementState")
require("lib/units/beings/player/states/PlayerEmpty")
require("lib/units/beings/player/states/PlayerStandard")
require("lib/units/beings/player/states/PlayerClean")
require("lib/units/beings/player/states/PlayerMaskOff")
require("lib/units/beings/player/states/PlayerBleedOut")
require("lib/units/beings/player/states/PlayerFatal")
require("lib/units/beings/player/states/PlayerArrested")
require("lib/units/beings/player/states/PlayerTased")
require("lib/units/beings/player/states/PlayerIncapacitated")
require("lib/units/beings/player/states/PlayerCarry")
if not PlayerMovement then
  PlayerMovement = class()
end
PlayerMovement._STAMINA_INIT = tweak_data.player.movement_state.stamina.STAMINA_INIT or 10
PlayerMovement.OUT_OF_WORLD_Z = -4000
PlayerMovement.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_1:set_timer(managers.player:player_timer())
  l_1_1:set_animation_timer(managers.player:player_timer())
  l_1_0._machine = l_1_0._unit:anim_state_machine()
  l_1_0._next_check_out_of_world_t = 1
  l_1_0._nav_tracker = nil
  l_1_0._pos_rsrv_id = nil
  l_1_0:set_driving("script")
  l_1_0._m_pos = l_1_1:position()
  l_1_0._m_stand_pos = mvector3.copy(l_1_0._m_pos)
  mvector3.set_z(l_1_0._m_stand_pos, l_1_0._m_pos.z + 140)
  l_1_0._m_com = math.lerp(l_1_0._m_pos, l_1_0._m_stand_pos, 0.5)
  l_1_0._kill_overlay_t = managers.player:player_timer():time() + 5
  l_1_0._state_data = {ducking = false, in_air = false}
  l_1_0._synced_suspicion = false
  l_1_0._suspicion_ratio = false
  l_1_0._SO_access = managers.navigation:convert_access_flag("teamAI1")
  l_1_0._regenerate_timer = nil
  l_1_0._stamina = l_1_0:_max_stamina()
  l_1_0._underdog_skill_data = {chk_interval_active = 6, chk_interval_inactive = 1, chk_t = 6, nr_enemies = 2, max_dis_sq = 640000, has_dmg_dampener = managers.player:has_category_upgrade("temporary", "dmg_dampener_outnumbered"), has_dmg_mul = managers.player:has_category_upgrade("temporary", "dmg_multiplier_outnumbered")}
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_1_0._rally_skill_data = {range_sq = 490000, morale_boost_delay_t = not managers.player:has_category_upgrade("player", "morale_boost") and not managers.player:has_category_upgrade("player", "long_dis_revive") or nil, long_dis_revive = managers.player:has_category_upgrade("player", "long_dis_revive"), revive_chance = 0.5}
end

PlayerMovement.post_init = function(l_2_0)
  l_2_0._m_head_rot = l_2_0._unit:camera()._m_cam_rot
  l_2_0._m_head_pos = l_2_0._unit:camera()._m_cam_pos
  if managers.navigation:is_data_ready() and (not Global.running_simulation or Global.running_simulation_with_mission) then
    l_2_0._nav_tracker = managers.navigation:create_nav_tracker(l_2_0._unit:position())
    l_2_0._pos_rsrv_id = managers.navigation:get_pos_reservation_id()
  end
  l_2_0._unit:inventory():add_listener("PlayerMovement" .. tostring(l_2_0._unit:key()), {"add", "equip"}, callback(l_2_0, l_2_0, "inventory_clbk_listener"))
  l_2_0:_setup_states()
  l_2_0._attention_handler = CharacterAttentionObject:new(l_2_0._unit, true)
  l_2_0._enemy_weapons_hot_listen_id = "PlayerMovement" .. tostring(l_2_0._unit:key())
  managers.groupai:state():add_listener(l_2_0._enemy_weapons_hot_listen_id, {"enemy_weapons_hot"}, callback(l_2_0, l_2_0, "clbk_enemy_weapons_hot"))
  if managers.player:has_category_upgrade("player", "camouflage_bonus") then
    l_2_0._unit:base():set_detection_multiplier("camouflage_bonus", managers.player:upgrade_value("player", "camouflage_bonus", 1))
  end
end

PlayerMovement.attention_handler = function(l_3_0)
  return l_3_0._attention_handler
end

PlayerMovement.nav_tracker = function(l_4_0)
  return l_4_0._nav_tracker
end

PlayerMovement.pos_rsrv_id = function(l_5_0)
  return l_5_0._pos_rsrv_id
end

PlayerMovement.warp_to = function(l_6_0, l_6_1, l_6_2)
  l_6_0._unit:warp_to(l_6_2, l_6_1)
end

PlayerMovement._setup_states = function(l_7_0)
  local unit = l_7_0._unit
  {empty = PlayerEmpty:new(unit), standard = PlayerStandard:new(unit), mask_off = PlayerMaskOff:new(unit), bleed_out = PlayerBleedOut:new(unit)}.fatal = PlayerFatal:new(unit)
   -- DECOMPILER ERROR: Confused about usage of registers!

  {empty = PlayerEmpty:new(unit), standard = PlayerStandard:new(unit), mask_off = PlayerMaskOff:new(unit), bleed_out = PlayerBleedOut:new(unit)}.arrested = PlayerArrested:new(unit)
   -- DECOMPILER ERROR: Confused about usage of registers!

  {empty = PlayerEmpty:new(unit), standard = PlayerStandard:new(unit), mask_off = PlayerMaskOff:new(unit), bleed_out = PlayerBleedOut:new(unit)}.tased = PlayerTased:new(unit)
   -- DECOMPILER ERROR: Confused about usage of registers!

  {empty = PlayerEmpty:new(unit), standard = PlayerStandard:new(unit), mask_off = PlayerMaskOff:new(unit), bleed_out = PlayerBleedOut:new(unit)}.incapacitated = PlayerIncapacitated:new(unit)
   -- DECOMPILER ERROR: Confused about usage of registers!

  {empty = PlayerEmpty:new(unit), standard = PlayerStandard:new(unit), mask_off = PlayerMaskOff:new(unit), bleed_out = PlayerBleedOut:new(unit)}.clean = PlayerClean:new(unit)
   -- DECOMPILER ERROR: Confused about usage of registers!

  {empty = PlayerEmpty:new(unit), standard = PlayerStandard:new(unit), mask_off = PlayerMaskOff:new(unit), bleed_out = PlayerBleedOut:new(unit)}.carry = PlayerCarry:new(unit)
   -- DECOMPILER ERROR: Confused about usage of registers!

  l_7_0._states = {empty = PlayerEmpty:new(unit), standard = PlayerStandard:new(unit), mask_off = PlayerMaskOff:new(unit), bleed_out = PlayerBleedOut:new(unit)}
end

PlayerMovement.set_character_anim_variables = function(l_8_0)
  local char_name = (managers.criminals:character_name_by_unit(l_8_0._unit))
  local mesh_names = nil
  if Global.level_data and Global.level_data.level_id then
    local lvl_tweak_data = tweak_data.levels[Global.level_data.level_id]
  end
  local unit_suit = lvl_tweak_data and lvl_tweak_data.unit_suit or "suit"
  if not lvl_tweak_data then
    mesh_names = {russian = "", american = "", german = "", spanish = ""}
  elseif unit_suit == "cat_suit" then
    mesh_names = {russian = "", american = "", german = "", spanish = "_chains"}
  else
    if managers.player._player_mesh_suffix == "_scrubs" then
      mesh_names = {russian = "", american = "", german = "", spanish = "_chains"}
    else
      mesh_names = {russian = "_dallas", american = "_hoxton", german = "", spanish = "_chains"}
    end
  end
  local mesh_name = Idstring("g_fps_hand" .. mesh_names[char_name] .. managers.player._player_mesh_suffix)
  local mesh_obj = l_8_0._unit:camera():camera_unit():get_object(mesh_name)
  if mesh_obj then
    if l_8_0._plr_mesh_name then
      local old_mesh_obj = l_8_0._unit:camera():camera_unit():get_object(l_8_0._plr_mesh_name)
      if old_mesh_obj then
        old_mesh_obj:set_visibility(false)
      end
    end
    l_8_0._plr_mesh_name = mesh_name
    mesh_obj:set_visibility(true)
  end
  local camera_unit = l_8_0._unit:camera():camera_unit()
  if camera_unit:damage() then
    local character = CriminalsManager.convert_old_to_new_character_workname(char_name)
    local sequence = tweak_data.blackmarket.characters.locked[character].sequence
    camera_unit:damage():run_sequence_simple(sequence)
  end
end

PlayerMovement.set_driving = function(l_9_0, l_9_1)
  l_9_0._unit:set_driving(l_9_1)
end

PlayerMovement.change_state = function(l_10_0, l_10_1)
  local exit_data = nil
  if l_10_0._current_state then
    exit_data = l_10_0._current_state:exit(l_10_0._state_data, l_10_1)
  end
  local new_state = l_10_0._states[l_10_1]
  l_10_0._current_state = new_state
  l_10_0._current_state_name = l_10_1
  l_10_0._state_enter_t = managers.player:player_timer():time()
  new_state:enter(l_10_0._state_data, exit_data)
  l_10_0._unit:network():send("sync_player_movement_state", l_10_0._current_state_name, l_10_0._unit:character_damage():down_time(), l_10_0._unit:id())
end

PlayerMovement.update = function(l_11_0, l_11_1, l_11_2, l_11_3)
  l_11_0:_calculate_m_pose()
  if l_11_0:_check_out_of_world(l_11_2) then
    return 
  end
  l_11_0:_upd_underdog_skill(l_11_2)
  if l_11_0._current_state then
    l_11_0._current_state:update(l_11_2, l_11_3)
  end
  if l_11_0._kill_overlay_t and l_11_0._kill_overlay_t < l_11_2 then
    l_11_0._kill_overlay_t = nil
    managers.overlay_effect:stop_effect()
  end
  l_11_0:update_stamina(l_11_2, l_11_3)
end

PlayerMovement.update_stamina = function(l_12_0, l_12_1, l_12_2, l_12_3)
  if not l_12_3 and l_12_0._is_running then
    l_12_0:subtract_stamina(l_12_2 * tweak_data.player.movement_state.stamina.STAMINA_DRAIN_RATE)
  elseif l_12_0._regenerate_timer then
    l_12_0._regenerate_timer = l_12_0._regenerate_timer - l_12_2
    if l_12_0._regenerate_timer < 0 then
      l_12_0:add_stamina(l_12_2 * tweak_data.player.movement_state.stamina.STAMINA_REGEN_RATE)
      if l_12_0:_max_stamina() <= l_12_0._stamina then
        l_12_0._regenerate_timer = nil
      end
    end
  end
end

PlayerMovement.set_position = function(l_13_0, l_13_1)
  l_13_0._unit:set_position(l_13_1)
end

PlayerMovement.set_m_pos = function(l_14_0, l_14_1)
  mvector3.set(l_14_0._m_pos, l_14_1)
  mvector3.set(l_14_0._m_stand_pos, l_14_1)
  mvector3.set_z(l_14_0._m_stand_pos, l_14_1.z + 140)
end

PlayerMovement.m_pos = function(l_15_0)
  return l_15_0._m_pos
end

PlayerMovement.m_stand_pos = function(l_16_0)
  return l_16_0._m_stand_pos
end

PlayerMovement.m_com = function(l_17_0)
  return l_17_0._m_com
end

PlayerMovement.m_head_pos = function(l_18_0)
  return l_18_0._m_head_pos
end

PlayerMovement.m_head_rot = function(l_19_0)
  return l_19_0._m_head_rot
end

PlayerMovement.m_detect_pos = function(l_20_0)
  return l_20_0._m_head_pos
end

PlayerMovement.get_object = function(l_21_0, l_21_1)
  return l_21_0._unit:get_object(l_21_1)
end

PlayerMovement.downed = function(l_22_0)
  return l_22_0._current_state_name == "bleed_out" or l_22_0._current_state_name == "fatal" or l_22_0._current_state_name == "arrested" or l_22_0._current_state_name == "incapacitated"
end

PlayerMovement.current_state = function(l_23_0)
  return l_23_0._current_state
end

PlayerMovement._calculate_m_pose = function(l_24_0)
  mvector3.lerp(l_24_0._m_com, l_24_0._m_pos, l_24_0._m_head_pos, 0.5)
end

PlayerMovement._check_out_of_world = function(l_25_0, l_25_1)
  if l_25_0._next_check_out_of_world_t < l_25_1 then
    l_25_0._next_check_out_of_world_t = l_25_1 + 1
    if mvector3.z(l_25_0._m_pos) < PlayerMovement.OUT_OF_WORLD_Z then
      managers.player:on_out_of_world()
      return true
    end
  end
  return false
end

PlayerMovement.play_redirect = function(l_26_0, l_26_1, l_26_2)
  local result = l_26_0._unit:play_redirect(Idstring(l_26_1), l_26_2)
  return (result ~= Idstring("") and result)
end

PlayerMovement.play_state = function(l_27_0, l_27_1, l_27_2)
  local result = l_27_0._unit:play_state(Idstring(l_27_1), l_27_2)
  return (result ~= Idstring("") and result)
end

PlayerMovement.chk_action_forbidden = function(l_28_0, l_28_1)
  if l_28_0._current_state.chk_action_forbidden then
    return l_28_0._current_state:chk_action_forbidden(l_28_1)
  end
end

PlayerMovement.get_melee_damage_result = function(l_29_0, ...)
  if l_29_0._current_state.get_melee_damage_result then
    return l_29_0._current_state:get_melee_damage_result(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

PlayerMovement.linked = function(l_30_0, l_30_1, l_30_2, l_30_3)
  if l_30_1 then
    l_30_0._link_data = {physical = l_30_2, parent = l_30_3}
    l_30_3:base():add_destroy_listener("PlayerMovement" .. tostring(l_30_0._unit:key()), callback(l_30_0, l_30_0, "parent_clbk_unit_destroyed"))
  else
    l_30_0._link_data = nil
  end
end

PlayerMovement.parent_clbk_unit_destroyed = function(l_31_0, l_31_1, l_31_2)
  l_31_0._link_data = nil
  l_31_1:base():remove_destroy_listener("PlayerMovement" .. tostring(l_31_0._unit:key()))
end

PlayerMovement.is_physically_linked = function(l_32_0)
  if l_32_0._link_data then
    return l_32_0._link_data.physical
  end
end

PlayerMovement.on_cuffed = function(l_33_0)
  if l_33_0._unit:character_damage()._god_mode then
    return 
  end
  if l_33_0._current_state_name == "standard" or l_33_0._current_state_name == "bleed_out" or l_33_0._current_state_name == "carry" or l_33_0._current_state_name == "mask_off" or l_33_0._current_state_name == "clean" then
    managers.player:set_player_state("arrested")
  else
    debug_pause("[PlayerMovement:on_cuffed] transition failed", l_33_0._current_state_name)
  end
end

PlayerMovement.on_uncovered = function(l_34_0, l_34_1)
  if l_34_0._current_state_name ~= "mask_off" and l_34_0._current_state_name ~= "clean" then
    return 
  end
  l_34_0._state_data.uncovered = true
  managers.player:set_player_state("standard")
  l_34_0._state_data.uncovered = nil
end

PlayerMovement.on_SPOOCed = function(l_35_0)
  if l_35_0._unit:character_damage()._god_mode then
    return 
  end
  if l_35_0._current_state_name == "standard" or l_35_0._current_state_name == "bleed_out" then
    managers.player:set_player_state("incapacitated")
  end
end

PlayerMovement.on_non_lethal_electrocution = function(l_36_0)
  l_36_0._state_data.non_lethal_electrocution = true
end

PlayerMovement.on_tase_ended = function(l_37_0)
  if l_37_0._current_state_name == "tased" then
    l_37_0._unit:character_damage():erase_tase_data()
    l_37_0._current_state:on_tase_ended()
  end
end

PlayerMovement.tased = function(l_38_0)
  return l_38_0._current_state_name == "tased"
end

PlayerMovement.current_state_name = function(l_39_0)
  return l_39_0._current_state_name
end

PlayerMovement.state_enter_time = function(l_40_0)
  return l_40_0._state_enter_t
end

PlayerMovement._create_attention_setting_from_descriptor = function(l_41_0, l_41_1, l_41_2)
  local setting = clone(l_41_1)
  setting.id = l_41_2
  setting.filter = managers.groupai:state():get_unit_type_filter(setting.filter)
  setting.reaction = AIAttentionObject[setting.reaction]
  if setting.notice_clbk then
    if l_41_0[setting.notice_clbk] then
      setting.notice_clbk = callback(l_41_0, l_41_0, setting.notice_clbk)
    else
      debug_pause("[PlayerMovement:_create_attention_setting_from_descriptor] no notice_clbk defined in class", l_41_0._unit, setting.notice_clbk)
    end
  end
  if l_41_0._apply_attention_setting_modifications then
    l_41_0:_apply_attention_setting_modifications(setting)
  end
  return setting
end

PlayerMovement._apply_attention_setting_modifications = function(l_42_0, l_42_1)
  l_42_1.detection = l_42_0._unit:base():detection_settings()
end

PlayerMovement.set_attention_settings = function(l_43_0, l_43_1)
  local changes = l_43_0._attention_handler:chk_settings_diff(l_43_1)
  if not changes then
    return 
  end
  local all_attentions = nil
  local _add_attentions_to_all = function(l_1_0)
    for _,setting_name in ipairs(l_1_0) do
      local setting_desc = tweak_data.attention.settings[setting_name]
      if setting_desc then
        if not all_attentions then
          all_attentions = {}
        end
        do
          local setting = self:_create_attention_setting_from_descriptor(setting_desc, setting_name)
          all_attentions[setting_name] = setting
        end
        for (for control),_ in (for generator) do
        end
        debug_pause_unit(self._unit, "[PlayerMovement:set_attention_settings] invalid setting", setting_name, self._unit)
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  if changes.added then
    _add_attentions_to_all(changes.added)
  end
  if changes.maintained then
    _add_attentions_to_all(changes.maintained)
  end
  l_43_0._attention_handler:set_settings_set(all_attentions)
  if Network:is_client() then
    if changes.added then
      for _,id in ipairs(changes.added) do
        local index = tweak_data.attention:get_attention_index(id)
        l_43_0._unit:network():send_to_host("set_attention_enabled", index, true)
      end
    end
    if changes.removed then
      for _,id in ipairs(changes.removed) do
        local index = tweak_data.attention:get_attention_index(id)
        l_43_0._unit:network():send_to_host("set_attention_enabled", index, false)
      end
    end
  end
end

PlayerMovement.set_attention_setting_enabled = function(l_44_0, l_44_1, l_44_2, l_44_3)
  if l_44_2 then
    local setting_desc = tweak_data.attention.settings[l_44_1]
    if setting_desc then
      local setting = l_44_0:_create_attention_setting_from_descriptor(setting_desc, l_44_1)
      l_44_0._unit:movement():attention_handler():add_attention(setting)
    else
      debug_pause_unit(l_44_0._unit, "[PlayerMovement:add_attention_setting] invalid setting", l_44_1, l_44_0._unit)
    end
  else
    l_44_0._unit:movement():attention_handler():remove_attention(l_44_1)
  end
  if l_44_3 then
    local index = tweak_data.player:get_attention_index("player", l_44_1)
    l_44_0._ext_network:send_to_host("set_attention_enabled", index, l_44_2)
  end
end

PlayerMovement.clbk_attention_notice_sneak = function(l_45_0, l_45_1, l_45_2)
  l_45_0:on_suspicion(l_45_1, l_45_2)
end

PlayerMovement.on_suspicion = function(l_46_0, l_46_1, l_46_2)
  if Network:is_server() then
    if not l_46_0._suspicion_debug then
      l_46_0._suspicion_debug = {}
    end
    l_46_0._suspicion_debug[l_46_1:key()] = {unit = l_46_1, name = l_46_1:name(), status = l_46_2}
    local visible_status = nil
    if managers.groupai:state():whisper_mode() then
      visible_status = l_46_2
    else
      visible_status = false
    end
    if not l_46_0._suspicion then
      l_46_0._suspicion = {}
    end
    if visible_status == false or visible_status == true then
      l_46_0._suspicion[l_46_1:key()] = nil
      if not next(l_46_0._suspicion) then
        l_46_0._suspicion = nil
      else
        if type(visible_status) == "number" then
          l_46_0._suspicion[l_46_1:key()] = visible_status
        else
          return 
        end
      end
    end
    l_46_0:_calc_suspicion_ratio_and_sync(l_46_1, visible_status)
    managers.groupai:state():on_criminal_suspicion_progress(l_46_0._unit, l_46_1, visible_status)
  else
    l_46_0._suspicion_ratio = l_46_2
  end
  l_46_0:_feed_suspicion_to_hud()
end

PlayerMovement._feed_suspicion_to_hud = function(l_47_0)
  managers.hud:set_suspicion(l_47_0._suspicion_ratio)
end

PlayerMovement._calc_suspicion_ratio_and_sync = function(l_48_0, l_48_1, l_48_2)
  local suspicion_sync = nil
  if l_48_0._suspicion and l_48_2 ~= true then
    local max_suspicion = nil
    for u_key,val in pairs(l_48_0._suspicion) do
      if not max_suspicion or max_suspicion < val then
        max_suspicion = val
      end
    end
    if max_suspicion then
      l_48_0._suspicion_ratio = max_suspicion
      suspicion_sync = math.ceil(l_48_0._suspicion_ratio * 254)
    else
      l_48_0._suspicion_ratio = false
      suspicion_sync = false
    end
  else
    if type(l_48_2) == "boolean" then
      l_48_0._suspicion_ratio = l_48_2
      suspicion_sync = l_48_2 and 255 or 0
    else
      l_48_0._suspicion_ratio = false
      suspicion_sync = 0
    end
  end
  if suspicion_sync ~= l_48_0._synced_suspicion then
    l_48_0._synced_suspicion = suspicion_sync
    local member = managers.network:game():member_from_unit(l_48_0._unit)
    if member then
      local member_id = member:peer():id()
      managers.network:session():send_to_peers_synched("suspicion", member_id, suspicion_sync)
    end
  end
end

PlayerMovement.clbk_msg_overwrite_suspicion = function(l_49_0, l_49_1, l_49_2, l_49_3, l_49_4)
  if l_49_1 then
    if l_49_0.indexes[l_49_3] then
      local index = l_49_0.indexes[l_49_3]
      local old_msg = l_49_1[index]
      old_msg[3] = l_49_4
    else
      table.insert(l_49_1, {l_49_2, l_49_3, l_49_4})
      l_49_0.indexes[l_49_3] = #l_49_1
    end
  else
    l_49_0.indexes = {}
  end
end
end

PlayerMovement.clbk_enemy_weapons_hot = function(l_50_0)
  if l_50_0._current_state_name == "mask_off" or l_50_0._current_state_name == "clean" then
    l_50_0:on_uncovered(nil)
  end
  l_50_0._suspicion_ratio = false
  l_50_0._suspicion = false
  if Network:is_server() and l_50_0._synced_suspicion ~= 0 then
    l_50_0._synced_suspicion = 0
    local member = managers.network:game():member_from_unit(l_50_0._unit)
    if member then
      local member_id = member:peer():id()
      managers.network:session():send_to_peers_synched("suspicion", member_id, 0)
    end
  end
  l_50_0:_feed_suspicion_to_hud()
end

PlayerMovement.inventory_clbk_listener = function(l_51_0, l_51_1, l_51_2)
  if l_51_2 == "add" then
    local data = l_51_0._unit:inventory():get_latest_addition_hud_data()
    managers.hud:add_weapon(data)
  end
  if l_51_0._current_state and l_51_0._current_state.inventory_clbk_listener then
    l_51_0._current_state:inventory_clbk_listener(l_51_1, l_51_2)
  end
end

PlayerMovement.chk_play_mask_on_slow_mo = function(l_52_0, l_52_1)
  if not l_52_1.uncovered and managers.enemy:chk_any_unit_in_slotmask_visible(managers.slot:get_mask("enemies"), l_52_0._unit:camera():position(), l_52_0._nav_trakcer) then
    local effect_id_world = "world_MaskOn_Peer" .. tostring(managers.network:session():local_peer():id())
    managers.time_speed:play_effect(effect_id_world, tweak_data.timespeed.mask_on)
    local effect_id_player = "player_MaskOn_Peer" .. tostring(managers.network:session():local_peer():id())
    managers.time_speed:play_effect(effect_id_player, tweak_data.timespeed.mask_on_player)
  end
end

PlayerMovement.SO_access = function(l_53_0)
  return l_53_0._SO_access
end

PlayerMovement.rally_skill_data = function(l_54_0)
  return l_54_0._rally_skill_data
end

PlayerMovement._upd_underdog_skill = function(l_55_0, l_55_1)
  local data = l_55_0._underdog_skill_data
  if l_55_0._attackers and ((not data.has_dmg_dampener and not data.has_dmg_mul) or l_55_1 < l_55_0._underdog_skill_data.chk_t) then
    return 
  end
  local my_pos = l_55_0._m_pos
  local nr_guys = 0
  do
    local activated = nil
    for u_key,attacker_unit in pairs(l_55_0._attackers) do
      if not alive(attacker_unit) then
        l_55_0._attackers[u_key] = nil
        return 
      end
      local attacker_pos = attacker_unit:movement():m_pos()
      local dis_sq = mvector3.distance_sq(attacker_pos, my_pos)
      if dis_sq < data.max_dis_sq and math.abs(attacker_pos.z - my_pos.z) < 250 then
        nr_guys = nr_guys + 1
        if data.nr_enemies <= nr_guys then
          activated = true
          if data.has_dmg_mul then
            managers.player:activate_temporary_upgrade("temporary", "dmg_multiplier_outnumbered")
          end
          if data.has_dmg_dampener then
            managers.player:activate_temporary_upgrade("temporary", "dmg_dampener_outnumbered")
        end
      end
    end
    if not activated or not data.chk_interval_active then
      data.chk_t = l_55_1 + data.chk_interval_inactive
    end
     -- Warning: missing end command somewhere! Added here
  end
end

PlayerMovement.on_targetted_for_attack = function(l_56_0, l_56_1, l_56_2)
  if l_56_1 then
    if not l_56_0._attackers then
      l_56_0._attackers = {}
    end
    l_56_0._attackers[l_56_2:key()] = l_56_2
  elseif l_56_0._attackers then
    l_56_0._attackers[l_56_2:key()] = nil
    if not next(l_56_0._attackers) then
      l_56_0._attackers = nil
    end
  end
end

PlayerMovement.set_carry_restriction = function(l_57_0, l_57_1)
  l_57_0._carry_restricted = l_57_1
end

PlayerMovement.has_carry_restriction = function(l_58_0)
  return l_58_0._carry_restricted
end

PlayerMovement.object_interaction_blocked = function(l_59_0)
  return l_59_0._current_state:interaction_blocked()
end

PlayerMovement.on_morale_boost = function(l_60_0, l_60_1)
  if l_60_0._morale_boost then
    managers.enemy:reschedule_delayed_clbk(l_60_0._morale_boost.expire_clbk_id, managers.player:player_timer():time() + 30)
  else
    l_60_0._morale_boost = {expire_clbk_id = "PlayerMovement_morale_boost" .. tostring(l_60_0._unit:key()), move_speed_bonus = 1.1000000238419, suppression_resistance = 0.89999997615814}
    managers.enemy:add_delayed_clbk(l_60_0._morale_boost.expire_clbk_id, callback(l_60_0, l_60_0, "clbk_morale_boost_expire"), managers.player:player_timer():time() + 30)
  end
end

PlayerMovement.morale_boost = function(l_61_0)
  return l_61_0._morale_boost
end

PlayerMovement.clbk_morale_boost_expire = function(l_62_0)
  l_62_0._morale_boost = nil
end

PlayerMovement.push = function(l_63_0, l_63_1)
  if l_63_0._current_state.push then
    l_63_0._current_state:push(l_63_1)
  end
end

PlayerMovement.save = function(l_64_0, l_64_1)
  local peer_id = managers.network:game():member_from_unit(l_64_0._unit):peer():id()
  l_64_1.movement = {state_name = l_64_0._current_state_name, look_fwd = l_64_0._m_head_rot:y(), peer_id = peer_id, character_name = managers.criminals:character_name_by_unit(l_64_0._unit), attentions = {}, outfit = managers.network:session():peer(peer_id):profile("outfit_string")}
  if l_64_0._current_state_name ~= "clean" then
    if l_64_0._current_state_name == "mask_off" then
      do return end
    end
    if l_64_0._state_data.in_steelsight then
      l_64_1.movement.stance = 3
    else
      l_64_1.movement.stance = 2
    end
  end
  l_64_1.movement.pose = l_64_0._state_data.ducking and 2 or 1
  if Network:is_client() then
    for _,settings in ipairs(l_64_0._attention_handler:attention_data()) do
      local index = tweak_data.player:get_attention_index("player", settings.id)
      table.insert(l_64_1.movement.attentions, index)
    end
  end
  l_64_1.down_time = l_64_0._unit:character_damage():down_time()
  l_64_0._current_state:save(l_64_1.movement)
end

PlayerMovement.pre_destroy = function(l_65_0, l_65_1)
  l_65_0._attention_handler:set_attention(nil)
  l_65_0._current_state:pre_destroy(l_65_1)
  if l_65_0._nav_tracker then
    managers.navigation:destroy_nav_tracker(l_65_0._nav_tracker)
    l_65_0._nav_tracker = nil
  end
  if l_65_0._enemy_weapons_hot_listen_id then
    managers.groupai:state():remove_listener(l_65_0._enemy_weapons_hot_listen_id)
    l_65_0._enemy_weapons_hot_listen_id = nil
  end
end

PlayerMovement.destroy = function(l_66_0, l_66_1)
  if l_66_0._link_data then
    l_66_0._link_data.parent:base():remove_destroy_listener("PlayerMovement" .. tostring(l_66_0._unit:key()))
  end
  l_66_0._current_state:destroy(l_66_1)
  managers.hud:set_suspicion(false)
  SoundDevice:set_rtpc("suspicion", 0)
  SoundDevice:set_rtpc("stamina", 100)
end

PlayerMovement._max_stamina = function(l_67_0)
  local max_stamina = l_67_0._STAMINA_INIT * managers.player:upgrade_value("player", "stamina_multiplier", 1) * managers.player:team_upgrade_value("stamina", "multiplier", 1) * managers.player:team_upgrade_value("stamina", "passive_multiplier", 1)
  managers.hud:set_max_stamina(max_stamina)
  return max_stamina
end

PlayerMovement._change_stamina = function(l_68_0, l_68_1)
  local max_stamina = l_68_0:_max_stamina()
  local stamina_maxed = l_68_0._stamina == max_stamina
  l_68_0._stamina = math.clamp(l_68_0._stamina + l_68_1, 0, max_stamina)
  managers.hud:set_stamina_value(l_68_0._stamina)
  if stamina_maxed and l_68_0._stamina < max_stamina then
    l_68_0._unit:sound():play("fatigue_breath")
  elseif not stamina_maxed and max_stamina <= l_68_0._stamina then
    l_68_0._unit:sound():play("fatigue_breath_stop")
  end
  local stamina_to_threshold = max_stamina - tweak_data.player.movement_state.stamina.MIN_STAMINA_THRESHOLD
  local stamina_breath = math.clamp((l_68_0._stamina - tweak_data.player.movement_state.stamina.MIN_STAMINA_THRESHOLD) / stamina_to_threshold, 0, 1) * 100
  SoundDevice:set_rtpc("stamina", stamina_breath)
end

PlayerMovement.subtract_stamina = function(l_69_0, l_69_1)
  l_69_0:_change_stamina(-math.abs(l_69_1))
end

PlayerMovement.add_stamina = function(l_70_0, l_70_1)
  l_70_0:_change_stamina(math.abs(l_70_1) * managers.player:upgrade_value("player", "stamina_regen_multiplier", 1))
end

PlayerMovement.is_above_stamina_threshold = function(l_71_0)
  return tweak_data.player.movement_state.stamina.MIN_STAMINA_THRESHOLD < l_71_0._stamina
end

PlayerMovement.is_stamina_drained = function(l_72_0)
  return l_72_0._stamina <= 0
end

PlayerMovement.set_running = function(l_73_0, l_73_1)
  l_73_0._is_running = l_73_1
  l_73_0._regenerate_timer = (tweak_data.player.movement_state.stamina.REGENERATE_TIME or 5) * managers.player:upgrade_value("player", "stamina_regen_timer_multiplier", 1)
end

PlayerMovement.running = function(l_74_0)
  return l_74_0._is_running
end


