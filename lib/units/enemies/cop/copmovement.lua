-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\cop\copmovement.luac 

require("lib/units/enemies/cop/actions/lower_body/CopActionIdle")
require("lib/units/enemies/cop/actions/lower_body/CopActionWalk")
require("lib/units/enemies/cop/actions/full_body/CopActionAct")
require("lib/units/enemies/cop/actions/lower_body/CopActionTurn")
require("lib/units/enemies/cop/actions/full_body/CopActionHurt")
require("lib/units/enemies/cop/actions/lower_body/CopActionStand")
require("lib/units/enemies/cop/actions/lower_body/CopActionCrouch")
require("lib/units/enemies/cop/actions/upper_body/CopActionShoot")
require("lib/units/enemies/cop/actions/upper_body/CopActionReload")
require("lib/units/enemies/cop/actions/upper_body/CopActionTase")
require("lib/units/enemies/cop/actions/full_body/CopActionDodge")
require("lib/units/enemies/spooc/actions/lower_body/ActionSpooc")
require("lib/units/civilians/actions/lower_body/CivilianActionWalk")
require("lib/units/civilians/actions/lower_body/EscortWithSuitcaseActionWalk")
require("lib/units/enemies/tank/actions/lower_body/TankCopActionWalk")
require("lib/units/player_team/actions/lower_body/CriminalActionWalk")
local ids_movement = Idstring("movement")
local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_lerp = mvector3.lerp
local mrot_set = mrotation.set_yaw_pitch_roll
local temp_vec1 = Vector3()
local temp_vec2 = Vector3()
local temp_vec3 = Vector3()
local stance_ctl_pts = {0, 0, 1, 1}
if not CopMovement then
  CopMovement = class()
end
 -- DECOMPILER ERROR: Unhandled construct in list

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Unhandled construct in list

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Unhandled construct in list

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Unhandled construct in list

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Unhandled construct in list

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Unhandled construct in list

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Unhandled construct in list

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Unhandled construct in list

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Unhandled construct in list

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Unhandled construct in list

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Unhandled construct in list

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: No list found. Setlist fails

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: No list found. Setlist fails

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

local action_variants = {security = {idle = CopActionIdle, act = CopActionAct, walk = CopActionWalk, turn = CopActionTurn, hurt = CopActionHurt, stand = CopActionStand, crouch = CopActionCrouch, shoot = CopActionShoot}}
local security_variant = action_variants.security
 -- DECOMPILER ERROR: Overwrote pending register.

action_variants.tank, action_variants.murky, action_variants.shield, action_variants.biker_escape, action_variants.dealer, action_variants.gangster, action_variants.sniper, action_variants.nathan, action_variants.fbi_heavy_swat, action_variants.fbi_swat, action_variants.heavy_swat, action_variants.swat, action_variants.fbi, action_variants.cop, action_variants.patrol, {idle = CopActionIdle, act = CopActionAct, walk = CopActionWalk, turn = CopActionTurn, hurt = CopActionHurt, stand = CopActionStand, crouch = CopActionCrouch, shoot = CopActionShoot}.dodge, {idle = CopActionIdle, act = CopActionAct, walk = CopActionWalk, turn = CopActionTurn, hurt = CopActionHurt, stand = CopActionStand, crouch = CopActionCrouch, shoot = CopActionShoot}.tase, {idle = CopActionIdle, act = CopActionAct, walk = CopActionWalk, turn = CopActionTurn, hurt = CopActionHurt, stand = CopActionStand, crouch = CopActionCrouch, shoot = CopActionShoot}.spooc, {idle = CopActionIdle, act = CopActionAct, walk = CopActionWalk, turn = CopActionTurn, hurt = CopActionHurt, stand = CopActionStand, crouch = CopActionCrouch, shoot = CopActionShoot}.reload, CopMovement._gadgets, {aligns = {hand_l = Idstring("a_weapon_left_front"), hand_r = Idstring("a_weapon_right_front"), head = Idstring("Head")}, cigarette = {}, briefcase = {}, briefcase2 = {}, iphone = {}, baton = {}, needle = {}, pencil = {}, bbq_fork = {}, money_bag = {}, newspaper = {}, vail = {}}.clipboard_paper, {aligns = {hand_l = Idstring("a_weapon_left_front"), hand_r = Idstring("a_weapon_right_front"), head = Idstring("Head")}, cigarette = {}, briefcase = {}, briefcase2 = {}, iphone = {}, baton = {}, needle = {}, pencil = {}, bbq_fork = {}, money_bag = {}, newspaper = {}, vail = {}}.ivstand = clone(Idstring("units/world/props/cigarette/cigarette")("units/equipment/escort_suitcase/escort_suitcase_contour")("units/equipment/escort_suitcase/escort_suitcase")("units/world/props/iphone/iphone")("units/payday2/characters/ene_acc_baton/ene_acc_baton")("units/payday2/characters/npc_acc_syringe/npc_acc_syringe")("units/world/brushes/desk_pencil/desk_pencil")("units/world/props/barbecue/bbq_fork")("units/world/architecture/secret_stash/luggage_bag/secret_stash_luggage_bag")("units/world/props/suburbia_newspaper/suburbia_newspaper")("units/world/props/hospital_veil_interaction/hospital_veil_full")("units/world/architecture/hospital/props/iv_pole/iv_pole")("units/world/architecture/hospital/props/clipboard01/clipboard_paper")), security_variant, security_variant, security_variant, security_variant, security_variant, security_variant, security_variant, security_variant, security_variant, security_variant, security_variant, security_variant, security_variant, security_variant, CopActionDodge, CopActionTase, ActionSpooc, CopActionReload, {aligns = {hand_l = Idstring("a_weapon_left_front"), hand_r = Idstring("a_weapon_right_front"), head = Idstring("Head")}, cigarette = {}, briefcase = {}, briefcase2 = {}, iphone = {}, baton = {}, needle = {}, pencil = {}, bbq_fork = {}, money_bag = {}, newspaper = {}, vail = {}}, {}, {}
action_variants.tank.walk = TankCopActionWalk
action_variants.spooc = security_variant
action_variants.taser = security_variant
action_variants.civilian = {idle = CopActionIdle, act = CopActionAct, walk = CivilianActionWalk, turn = CopActionTurn, hurt = CopActionHurt}
action_variants.civilian_female = action_variants.civilian
action_variants.bank_manager = action_variants.civilian
action_variants.escort = action_variants.civilian
action_variants.escort_suitcase = clone(action_variants.civilian)
action_variants.escort_suitcase.walk = EscortWithSuitcaseActionWalk
action_variants.escort_prisoner = clone(action_variants.civilian)
action_variants.escort_prisoner.walk = EscortPrisonerActionWalk
action_variants.escort_cfo = action_variants.civilian
action_variants.escort_ralph = action_variants.civilian
action_variants.escort_undercover = clone(action_variants.civilian)
action_variants.escort_undercover.walk = EscortWithSuitcaseActionWalk
action_variants.russian = clone(security_variant)
action_variants.russian.walk = CriminalActionWalk
action_variants.german = action_variants.russian
action_variants.spanish = action_variants.russian
action_variants.american = action_variants.russian
security_variant = nil
CopMovement._action_variants = action_variants
action_variants = nil
CopMovement._stance = {}
CopMovement._stance.names = {"ntl", "hos", "cbt", "wnd"}
CopMovement._stance.blend = {0.80000001192093, 0.5, 0.30000001192093, 0.40000000596046}
CopMovement.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._machine = l_1_0._unit:anim_state_machine()
  l_1_0._nav_tracker_id = l_1_0._unit:key()
  l_1_0._nav_tracker = nil
  l_1_0._root_blend_ref = 0
  l_1_0._m_pos = l_1_1:position()
  l_1_0._m_stand_pos = mvector3.copy(l_1_0._m_pos)
  mvec3_set_z(l_1_0._m_stand_pos, l_1_0._m_pos.z + 160)
  l_1_0._m_com = math.lerp(l_1_0._m_pos, l_1_0._m_stand_pos, 0.5)
  l_1_0._obj_head = l_1_1:get_object(Idstring("Head"))
  l_1_0._m_head_rot = l_1_0._obj_head:rotation()
  l_1_0._m_head_pos = l_1_0._obj_head:position()
  l_1_0._obj_spine = l_1_1:get_object(Idstring("Spine1"))
  l_1_0._m_rot = l_1_1:rotation()
  l_1_0._footstep_style = nil
  l_1_0._footstep_event = ""
  l_1_0._obj_com = l_1_1:get_object(Idstring("Hips"))
  l_1_0._slotmask_gnd_ray = managers.slot:get_mask("AI_graph_obstacle_check")
  l_1_0._actions = l_1_0._action_variants[l_1_0._unit:base()._tweak_table]
  l_1_0._active_actions = {false, false, false, false}
  l_1_0._need_upd = true
  l_1_0._cool = true
  l_1_0._suppression = {value = 0}
end

CopMovement.post_init = function(l_2_0)
  local unit = l_2_0._unit
  l_2_0._ext_brain = unit:brain()
  l_2_0._ext_network = unit:network()
  l_2_0._ext_anim = unit:anim_data()
  l_2_0._ext_base = unit:base()
  l_2_0._ext_damage = unit:character_damage()
  l_2_0._ext_inventory = unit:inventory()
  l_2_0._tweak_data = tweak_data.character[l_2_0._ext_base._tweak_table]
  tweak_data:add_reload_callback(l_2_0, l_2_0.tweak_data_clbk_reload)
  l_2_0._machine = l_2_0._unit:anim_state_machine()
  l_2_0._machine:set_callback_object(l_2_0)
  l_2_0._stance = {code = 1, name = "ntl", values = {1, 0, 0, 0}}
  if managers.navigation:is_data_ready() then
    l_2_0._nav_tracker = managers.navigation:create_nav_tracker(l_2_0._m_pos)
    l_2_0._pos_rsrv_id = managers.navigation:get_pos_reservation_id()
  else
    Application:error("[CopMovement:post_init] Spawned AI unit with incomplete navigation data.")
    l_2_0._unit:set_extension_update(ids_movement, false)
  end
  l_2_0._unit:kill_mover()
  l_2_0._unit:set_driving("script")
  l_2_0._unit:character_damage():add_listener("movement", {"bleedout", "light_hurt", "heavy_hurt", "hurt", "hurt_sick", "shield_knock", "counter_tased", "death", "fatal"}, callback(l_2_0, l_2_0, "damage_clbk"))
  l_2_0._unit:inventory():add_listener("movement", {"equip", "unequip"}, callback(l_2_0, l_2_0, "clbk_inventory"))
  local prim_weap_name = l_2_0._ext_base:default_weapon_name("primary")
  local sec_weap_name = l_2_0._ext_base:default_weapon_name("secondary")
  if prim_weap_name then
    l_2_0._unit:inventory():add_unit_by_name(prim_weap_name)
  end
  if sec_weap_name and sec_weap_name ~= prim_weap_name then
    l_2_0._unit:inventory():add_unit_by_name(sec_weap_name)
  end
  if l_2_0._unit:inventory():is_selection_available(2) then
    if managers.groupai:state():enemy_weapons_hot() or not l_2_0._unit:inventory():is_selection_available(1) then
      l_2_0._unit:inventory():equip_selection(2, true)
    else
      l_2_0._unit:inventory():equip_selection(1, true)
    end
  else
    if l_2_0._unit:inventory():is_selection_available(1) then
      l_2_0._unit:inventory():equip_selection(1, true)
    end
  end
  local weap_name = l_2_0._ext_base:default_weapon_name(managers.groupai:state():enemy_weapons_hot() and "primary" or "secondary")
  local fwd = l_2_0._m_rot:y()
  {stance = l_2_0._stance, pos = l_2_0._m_pos, rot = l_2_0._m_rot, fwd = fwd, right = l_2_0._m_rot:x(), unit = unit, machine = l_2_0._machine, ext_movement = l_2_0}.ext_brain = l_2_0._ext_brain
   -- DECOMPILER ERROR: Confused about usage of registers!

  {stance = l_2_0._stance, pos = l_2_0._m_pos, rot = l_2_0._m_rot, fwd = fwd, right = l_2_0._m_rot:x(), unit = unit, machine = l_2_0._machine, ext_movement = l_2_0}.ext_anim = l_2_0._ext_anim
   -- DECOMPILER ERROR: Confused about usage of registers!

  {stance = l_2_0._stance, pos = l_2_0._m_pos, rot = l_2_0._m_rot, fwd = fwd, right = l_2_0._m_rot:x(), unit = unit, machine = l_2_0._machine, ext_movement = l_2_0}.ext_inventory = l_2_0._ext_inventory
   -- DECOMPILER ERROR: Confused about usage of registers!

  {stance = l_2_0._stance, pos = l_2_0._m_pos, rot = l_2_0._m_rot, fwd = fwd, right = l_2_0._m_rot:x(), unit = unit, machine = l_2_0._machine, ext_movement = l_2_0}.ext_base = l_2_0._ext_base
   -- DECOMPILER ERROR: Confused about usage of registers!

  {stance = l_2_0._stance, pos = l_2_0._m_pos, rot = l_2_0._m_rot, fwd = fwd, right = l_2_0._m_rot:x(), unit = unit, machine = l_2_0._machine, ext_movement = l_2_0}.ext_network = l_2_0._ext_network
   -- DECOMPILER ERROR: Confused about usage of registers!

  {stance = l_2_0._stance, pos = l_2_0._m_pos, rot = l_2_0._m_rot, fwd = fwd, right = l_2_0._m_rot:x(), unit = unit, machine = l_2_0._machine, ext_movement = l_2_0}.ext_damage = l_2_0._ext_damage
   -- DECOMPILER ERROR: Confused about usage of registers!

  {stance = l_2_0._stance, pos = l_2_0._m_pos, rot = l_2_0._m_rot, fwd = fwd, right = l_2_0._m_rot:x(), unit = unit, machine = l_2_0._machine, ext_movement = l_2_0}.char_tweak = l_2_0._tweak_data
   -- DECOMPILER ERROR: Confused about usage of registers!

  {stance = l_2_0._stance, pos = l_2_0._m_pos, rot = l_2_0._m_rot, fwd = fwd, right = l_2_0._m_rot:x(), unit = unit, machine = l_2_0._machine, ext_movement = l_2_0}.nav_tracker = l_2_0._nav_tracker
   -- DECOMPILER ERROR: Confused about usage of registers!

  {stance = l_2_0._stance, pos = l_2_0._m_pos, rot = l_2_0._m_rot, fwd = fwd, right = l_2_0._m_rot:x(), unit = unit, machine = l_2_0._machine, ext_movement = l_2_0}.active_actions = l_2_0._active_actions
   -- DECOMPILER ERROR: Confused about usage of registers!

  {stance = l_2_0._stance, pos = l_2_0._m_pos, rot = l_2_0._m_rot, fwd = fwd, right = l_2_0._m_rot:x(), unit = unit, machine = l_2_0._machine, ext_movement = l_2_0}.queued_actions = l_2_0._queued_actions
   -- DECOMPILER ERROR: Confused about usage of registers!

  {stance = l_2_0._stance, pos = l_2_0._m_pos, rot = l_2_0._m_rot, fwd = fwd, right = l_2_0._m_rot:x(), unit = unit, machine = l_2_0._machine, ext_movement = l_2_0}.look_vec = mvector3.copy(fwd)
   -- DECOMPILER ERROR: Confused about usage of registers!

  l_2_0._action_common_data = {stance = l_2_0._stance, pos = l_2_0._m_pos, rot = l_2_0._m_rot, fwd = fwd, right = l_2_0._m_rot:x(), unit = unit, machine = l_2_0._machine, ext_movement = l_2_0}
  l_2_0:upd_ground_ray()
  if l_2_0._gnd_ray then
    l_2_0:set_position(l_2_0._gnd_ray.position)
  end
  l_2_0:_post_init()
end

CopMovement._post_init = function(l_3_0)
  l_3_0:set_character_anim_variables()
  if managers.groupai:state():enemy_weapons_hot() then
    l_3_0:set_cool(false)
  else
    l_3_0:set_cool(true)
  end
  l_3_0._unit:brain():on_cool_state_changed(l_3_0._cool)
end

CopMovement.set_character_anim_variables = function(l_4_0)
  if l_4_0._anim_global then
    l_4_0._machine:set_global(l_4_0._anim_global, 1)
  end
  if l_4_0._tweak_data.female then
    l_4_0._machine:set_global("female", 1)
  end
  if l_4_0._tweak_data.allowed_stances and not l_4_0._tweak_data.allowed_stances.ntl then
    if l_4_0._tweak_data.allowed_stances.hos then
      l_4_0:_change_stance(2)
    else
      l_4_0:_change_stance(3)
    end
  end
  if l_4_0._tweak_data.allowed_poses and not l_4_0._tweak_data.allowed_poses.stand then
    l_4_0:play_redirect("crouch")
  end
end

CopMovement.nav_tracker = function(l_5_0)
  return l_5_0._nav_tracker
end

CopMovement.warp_to = function(l_6_0, l_6_1, l_6_2)
  l_6_0._unit:warp_to(l_6_2, l_6_1)
end

CopMovement.update = function(l_7_0, l_7_1, l_7_2, l_7_3)
  l_7_0._gnd_ray = nil
  local old_need_upd = l_7_0._need_upd
  l_7_0._need_upd = false
  l_7_0:_upd_actions(l_7_2)
  if l_7_0._need_upd ~= old_need_upd then
    l_7_1:set_extension_update_enabled(ids_movement, l_7_0._need_upd)
  end
  if l_7_0._force_head_upd then
    l_7_0._force_head_upd = nil
    l_7_0:upd_m_head_pos()
  end
end

CopMovement._upd_actions = function(l_8_0, l_8_1)
  local a_actions = l_8_0._active_actions
  local has_no_action = true
  for i_action,action in ipairs(a_actions) do
    do
      if action then
        if action.update then
          action:update(l_8_1)
        end
        if not l_8_0._need_upd and action.need_upd then
          l_8_0._need_upd = action:need_upd()
        end
        if action.expired and action:expired() then
          a_actions[i_action] = false
          if action.on_exit then
            action:on_exit()
          end
          l_8_0._ext_brain:action_complete_clbk(action)
          l_8_0._ext_base:chk_freeze_anims()
          for _,action in ipairs(a_actions) do
            if action then
              has_no_action = nil
              for (for control),i_action in (for generator) do
              end
            end
            for i_1,i_2 in (for generator) do
            end
            has_no_action = nil
          end
           -- DECOMPILER ERROR: Confused about usage of registers for local variables.

        end
      end
      if has_no_action and not l_8_0._queued_actions then
        l_8_0:action_request({type = "idle", body_part = 1})
      end
      if not a_actions[1] and not a_actions[3] and not l_8_0._queued_actions and not l_8_0:chk_action_forbidden("action") then
        l_8_0:action_request({type = "idle", body_part = 3})
      end
      l_8_0:_upd_stance(l_8_1)
      if not l_8_0._need_upd and (l_8_0._ext_anim.base_need_upd or l_8_0._ext_anim.upper_need_upd or l_8_0._stance.transition or l_8_0._suppression.transition) then
        l_8_0._need_upd = true
         -- DECOMPILER ERROR: Confused about usage of registers for local variables.

      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CopMovement._upd_stance = function(l_9_0, l_9_1)
  if l_9_0._stance.transition then
    local stance = l_9_0._stance
    local transition = stance.transition
    if transition.next_upd_t < l_9_1 then
      local values = stance.values
      local prog = (l_9_1 - transition.start_t) / transition.duration
      if prog < 1 then
        local prog_smooth = math.clamp(math.bezier(stance_ctl_pts, prog), 0, 1)
        local v_start = transition.start_values
        local v_end = transition.end_values
        local mlerp = math.lerp
        for i,v in ipairs(v_start) do
          values[i] = mlerp(v, v_end[i], prog_smooth)
        end
        transition.next_upd_t = l_9_1 + 0.032999999821186
      else
        for i,v in ipairs(transition.end_values) do
          values[i] = v
        end
        stance.transition = nil
      end
      local names = CopMovement._stance.names
      for i,v in ipairs(values) do
        l_9_0._machine:set_global(names[i], )
      end
    end
  end
  if l_9_0._suppression.transition then
    local suppression = l_9_0._suppression
    local transition = suppression.transition
    if transition.next_upd_t < l_9_1 then
      local prog = (l_9_1 - transition.start_t) / transition.duration
      if prog < 1 then
        local prog_smooth = math.clamp(math.bezier(stance_ctl_pts, prog), 0, 1)
        local val = math.lerp(transition.start_val, transition.end_val, prog_smooth)
        suppression.value = val
        l_9_0._machine:set_global("sup", val)
        transition.next_upd_t = l_9_1 + 0.032999999821186
      else
        l_9_0._machine:set_global("sup", transition.end_val)
        suppression.value = transition.end_val
        suppression.transition = nil
      end
    end
  end
end

CopMovement.on_anim_freeze = function(l_10_0, l_10_1)
  l_10_0._frozen = l_10_1
end

CopMovement.upd_m_head_pos = function(l_11_0)
  l_11_0._obj_head:m_position(l_11_0._m_head_pos)
  l_11_0._obj_spine:m_position(l_11_0._m_com)
end

CopMovement.set_position = function(l_12_0, l_12_1)
  mvec3_set(l_12_0._m_pos, l_12_1)
  mvec3_set(l_12_0._m_stand_pos, l_12_1)
  mvec3_set_z(l_12_0._m_stand_pos, l_12_1.z + 160)
  l_12_0._obj_head:m_position(l_12_0._m_head_pos)
  l_12_0._obj_spine:m_position(l_12_0._m_com)
  l_12_0._nav_tracker:move(l_12_1)
  l_12_0._unit:set_position(l_12_1)
end

CopMovement.set_m_pos = function(l_13_0, l_13_1)
  mvec3_set(l_13_0._m_pos, l_13_1)
  mvec3_set(l_13_0._m_stand_pos, l_13_1)
  mvec3_set_z(l_13_0._m_stand_pos, l_13_1.z + 160)
  l_13_0._obj_head:m_position(l_13_0._m_head_pos)
  l_13_0._nav_tracker:move(l_13_1)
  l_13_0._obj_spine:m_position(l_13_0._m_com)
end

CopMovement.set_m_rot = function(l_14_0, l_14_1)
  mrot_set(l_14_0._m_rot, l_14_1:yaw(), 0, 0)
  l_14_0._action_common_data.fwd = l_14_1:y()
  l_14_0._action_common_data.right = l_14_1:x()
end

CopMovement.set_rotation = function(l_15_0, l_15_1)
  mrot_set(l_15_0._m_rot, l_15_1:yaw(), 0, 0)
  l_15_0._action_common_data.fwd = l_15_1:y()
  l_15_0._action_common_data.right = l_15_1:x()
  l_15_0._unit:set_rotation(l_15_1)
end

CopMovement.m_pos = function(l_16_0)
  return l_16_0._m_pos
end

CopMovement.m_stand_pos = function(l_17_0)
  return l_17_0._m_stand_pos
end

CopMovement.m_com = function(l_18_0)
  return l_18_0._m_com
end

CopMovement.m_head_pos = function(l_19_0)
  return l_19_0._m_head_pos
end

CopMovement.m_head_rot = function(l_20_0)
  return l_20_0._obj_head:rotation()
end

CopMovement.m_fwd = function(l_21_0)
  return l_21_0._action_common_data.fwd
end

CopMovement.m_rot = function(l_22_0)
  return l_22_0._m_rot
end

CopMovement.get_object = function(l_23_0, l_23_1)
  return l_23_0._unit:get_object(l_23_1)
end

CopMovement.set_m_host_stop_pos = function(l_24_0, l_24_1)
  mvec3_set(l_24_0._m_host_stop_pos, l_24_1)
end

CopMovement.m_host_stop_pos = function(l_25_0)
  return l_25_0._m_host_stop_pos
end

CopMovement.play_redirect = function(l_26_0, l_26_1, l_26_2)
  local result = l_26_0._unit:play_redirect(Idstring(l_26_1), l_26_2)
  return (result ~= Idstring("") and result)
end

CopMovement.play_state = function(l_27_0, l_27_1, l_27_2)
  local result = l_27_0._unit:play_state(Idstring(l_27_1), l_27_2)
  return (result ~= Idstring("") and result)
end

CopMovement.play_state_idstr = function(l_28_0, l_28_1, l_28_2)
  local result = l_28_0._unit:play_state(l_28_1, l_28_2)
  return (result ~= Idstring("") and result)
end

CopMovement.set_root_blend = function(l_29_0, l_29_1)
  if l_29_1 then
    if l_29_0._root_blend_ref == 1 then
      l_29_0._machine:set_root_blending(true)
    end
    l_29_0._root_blend_ref = l_29_0._root_blend_ref - 1
  elseif l_29_0._root_blend_ref == 0 then
    l_29_0._machine:set_root_blending(false)
  end
  l_29_0._root_blend_ref = l_29_0._root_blend_ref + 1
end

CopMovement.chk_action_forbidden = function(l_30_0, l_30_1)
  local t = TimerManager:game():time()
  for i_action,action in ipairs(l_30_0._active_actions) do
    if action and action.chk_block and action:chk_block(l_30_1, t) then
      return true
    end
  end
end

CopMovement.action_request = function(l_31_0, l_31_1)
  if Network:is_server() and l_31_0._active_actions[1] and l_31_0._active_actions[1]:type() == "hurt" and l_31_0._active_actions[1]:hurt_type() == "death" then
    debug_pause_unit(l_31_0._unit, "[CopMovement:action_request] Dead man walking!!!", l_31_0._unit, inspect(l_31_1))
  end
  l_31_0.has_no_action = nil
  local body_part = l_31_1.body_part
  local active_actions = l_31_0._active_actions
  local interrupted_actions = nil
  local _interrupt_action = function(l_1_0)
    local old_action = active_actions[l_1_0]
    if old_action then
      active_actions[l_1_0] = false
      if old_action.on_exit then
        old_action:on_exit()
      end
      if not interrupted_actions then
        upvalue_512 = {}
      end
      interrupted_actions[l_1_0] = old_action
    end
   end
  _interrupt_action(body_part)
  if body_part == 1 then
    _interrupt_action(2)
    _interrupt_action(3)
  elseif body_part == 2 or body_part == 3 then
    _interrupt_action(1)
  end
  if not l_31_0._actions[l_31_1.type] then
    debug_pause("[CopMovement:action_request] invalid action started", inspect(l_31_0._actions), inspect(l_31_1))
    return 
  end
  local action, success = l_31_0._actions[l_31_1.type]:new(l_31_1, l_31_0._action_common_data)
  if success and (not action.expired or not action:expired()) then
    active_actions[body_part] = action
  end
  if interrupted_actions then
    for body_part,interrupted_action in pairs(interrupted_actions) do
      l_31_0._ext_brain:action_complete_clbk(interrupted_action)
    end
  end
  l_31_0._ext_base:chk_freeze_anims()
  return not success or action
end

CopMovement.get_action = function(l_32_0, l_32_1)
  return l_32_0._active_actions[l_32_1]
end

CopMovement.set_attention = function(l_33_0, l_33_1)
  if l_33_0._attention and l_33_0._attention.destroy_listener_key then
    l_33_0._attention.unit:base():remove_destroy_listener(l_33_0._attention.destroy_listener_key)
    l_33_0._attention.destroy_listener_key = nil
  end
  if l_33_1 then
    if l_33_1.unit then
      if l_33_1.handler then
        local attention_unit = l_33_1.handler:unit()
        if attention_unit:id() ~= -1 then
          l_33_0._ext_network:send("set_attention", attention_unit, l_33_1.reaction)
        else
          l_33_0._ext_network:send("cop_set_attention_pos", mvector3.copy(l_33_1.handler:get_attention_m_pos()))
        end
      else
        local attention_unit = l_33_1.unit
        if l_33_0._ext_network and attention_unit:id() ~= -1 then
          l_33_0._ext_network:send("cop_set_attention_unit", attention_unit)
        end
      end
      if l_33_1.unit:base() and l_33_1.unit:base().add_destroy_listener then
        local attention_unit = l_33_1.unit
        local listener_key = "CopMovement" .. tostring(l_33_0._unit:key())
        l_33_1.destroy_listener_key = listener_key
        attention_unit:base():add_destroy_listener(listener_key, callback(l_33_0, l_33_0, "attention_unit_destroy_clbk"))
      elseif l_33_0._ext_network then
        l_33_0._ext_network:send("cop_set_attention_pos", l_33_1.pos)
      elseif l_33_0._attention and Network:is_server() and l_33_0._unit:id() ~= -1 then
        l_33_0._ext_network:send("cop_reset_attention")
      end
    end
  end
  local old_attention = l_33_0._attention
  l_33_0._attention = l_33_1
  l_33_0._action_common_data.attention = l_33_1
  for _,action in ipairs(l_33_0._active_actions) do
    if action and action.on_attention then
      action:on_attention(l_33_1, old_attention)
    end
  end
end

CopMovement.set_stance = function(l_34_0, l_34_1)
  for i_stance,stance_name in ipairs(CopMovement._stance.names) do
    if stance_name == l_34_1 then
      l_34_0:set_stance_by_code(i_stance)
  else
    end
  end
end

CopMovement.set_stance_by_code = function(l_35_0, l_35_1)
  if l_35_0._stance.code ~= l_35_1 then
    l_35_0._ext_network:send("set_stance", l_35_1)
    l_35_0:_change_stance(l_35_1)
  end
end

CopMovement._change_stance = function(l_36_0, l_36_1)
  if l_36_0._tweak_data.allowed_stances then
    if l_36_1 == 1 and not l_36_0._tweak_data.allowed_stances.ntl then
      return 
    elseif l_36_1 == 2 and not l_36_0._tweak_data.allowed_stances.hos then
      return 
    elseif l_36_1 == 3 and not l_36_0._tweak_data.allowed_stances.cbt then
      return 
    end
  end
  local stance = l_36_0._stance
  local end_values = {}
  if l_36_1 == 4 then
    if stance.transition then
      end_values = stance.transition.end_values
    else
      for i,value in ipairs(stance.values) do
        end_values[i] = value
      end
    end
  elseif stance.transition then
    end_values = {0, 0, 0, stance.transition.end_values[4]}
  else
    end_values = {0, 0, 0, stance.values[4]}
  end
end
end_values[l_36_1] = 1
if l_36_1 ~= 4 then
  stance.code = l_36_1
  stance.name = CopMovement._stance.names[l_36_1]
end
local delay = nil
local vis_state = l_36_0._ext_base:lod_stage()
if vis_state then
  delay = CopMovement._stance.blend[l_36_1]
  if vis_state > 2 then
    delay = delay * 0.5
  else
    stance.transition = nil
    if l_36_1 ~= 1 then
      l_36_0:_chk_play_equip_weapon()
    end
    local names = CopMovement._stance.names
    for i,v in ipairs(end_values) do
      if v ~= stance.values[i] then
        stance.values[i] = v
        l_36_0._machine:set_global(names[i], v)
      end
    end
    return 
  end
end
local start_values = {}
for _,value in ipairs(stance.values) do
  table.insert(start_values, value)
end
local t = TimerManager:game():time()
local transition = {end_values = end_values, start_values = start_values, duration = delay, start_t = t, next_upd_t = t + 0.070000000298023}
stance.transition = transition
if l_36_1 ~= 1 then
  l_36_0:_chk_play_equip_weapon()
end
l_36_0:enable_update()
end

CopMovement.sync_stance = function(l_37_0, l_37_1)
  l_37_0:_change_stance(l_37_1)
  if l_37_1 == 1 then
    l_37_0:set_cool(true)
  else
    l_37_0:set_cool(false)
  end
end

CopMovement.stance_name = function(l_38_0)
  return l_38_0._stance.name
end

CopMovement.stance_code = function(l_39_0)
  return l_39_0._stance.code
end

CopMovement._chk_play_equip_weapon = function(l_40_0)
  if l_40_0._stance.values[1] == 1 and not l_40_0._ext_anim.equip and not l_40_0._tweak_data.no_equip_anim then
    local redir_res = l_40_0:play_redirect("equip")
    if redir_res then
      local weapon_unit = l_40_0._ext_inventory:equipped_unit()
      if weapon_unit then
        local weap_tweak = weapon_unit:base():weapon_tweak_data()
        local weapon_hold = weap_tweak.hold
        l_40_0._machine:set_parameter(redir_res, "to_" .. weapon_hold, 1)
      end
    end
  end
end

CopMovement.set_cool = function(l_41_0, l_41_1, l_41_2)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_41_1 = true
if not l_41_1 and not managers.groupai:state():enemy_weapons_hot() then
  l_41_0._coolness_giveaway = managers.groupai:state():fetch_highest_giveaway(l_41_0._coolness_giveaway, l_41_2)
end
if l_41_1 == l_41_0._cool then
  return 
end
local old_state = l_41_0._cool
l_41_0._cool = l_41_1
if not l_41_1 and old_state then
  l_41_0._not_cool_t = TimerManager:game():time()
end
l_41_0._unit:brain():on_cool_state_changed(l_41_1)
if not l_41_1 and old_state and l_41_0._unit:unit_data().mission_element then
  l_41_0._unit:unit_data().mission_element:event("weapons_hot", l_41_0._unit)
end
end

CopMovement.cool = function(l_42_0)
  return l_42_0._cool
end

CopMovement.coolness_giveaway = function(l_43_0)
  return l_43_0._coolness_giveaway
end

CopMovement.set_giveaway = function(l_44_0, l_44_1)
  l_44_0._coolness_giveaway = l_44_1
end

CopMovement.remove_giveaway = function(l_45_0)
  l_45_0._coolness_giveaway = false
end

CopMovement.not_cool_t = function(l_46_0)
  return l_46_0._not_cool_t
end

CopMovement.synch_attention = function(l_47_0, l_47_1)
  if l_47_0._attention and l_47_0._attention.destroy_listener_key then
    l_47_0._attention.unit:base():remove_destroy_listener(l_47_0._attention.destroy_listener_key)
    l_47_0._attention.destroy_listener_key = nil
  end
  if l_47_1 and l_47_1.unit and l_47_1.unit:base() and l_47_1.unit:base().add_destroy_listener then
    local listener_key = "CopMovement" .. tostring(l_47_0._unit:key())
    l_47_1.destroy_listener_key = listener_key
    l_47_1.unit:base():add_destroy_listener(listener_key, callback(l_47_0, l_47_0, "attention_unit_destroy_clbk"))
  end
  l_47_0._attention = l_47_1
  l_47_0._action_common_data.attention = l_47_1
  for _,action in ipairs(l_47_0._active_actions) do
    if action and action.on_attention then
      action:on_attention(l_47_1)
    end
  end
end

CopMovement.attention = function(l_48_0)
  return l_48_0._attention
end

CopMovement.attention_unit_destroy_clbk = function(l_49_0, l_49_1)
  if Network:is_server() then
    l_49_0:set_attention()
  else
    l_49_0:synch_attention()
  end
end

CopMovement.set_allow_fire_on_client = function(l_50_0, l_50_1, l_50_2)
  if not l_50_1 or not "cop_allow_fire" then
    l_50_2:network():send_to_unit({not Network:is_server() or "cop_forbid_fire", l_50_0._unit})
     -- Warning: missing end command somewhere! Added here
  end
end

CopMovement.set_allow_fire = function(l_51_0, l_51_1)
  if l_51_0._allow_fire == l_51_1 then
    return 
  end
  l_51_0:synch_allow_fire(l_51_1)
  l_51_0._ext_network:send(not Network:is_server() or (l_51_1 and "cop_allow_fire") or "cop_forbid_fire")
  l_51_0:enable_update()
end

CopMovement.synch_allow_fire = function(l_52_0, l_52_1)
  for _,action in pairs(l_52_0._active_actions) do
    if action and action.allow_fire_clbk then
      action:allow_fire_clbk(l_52_1)
    end
  end
  l_52_0._allow_fire = l_52_1
  l_52_0._action_common_data.allow_fire = l_52_1
end

CopMovement.linked = function(l_53_0, l_53_1, l_53_2, l_53_3)
  if l_53_1 then
    l_53_0._link_data = {physical = l_53_2, parent = l_53_3}
    l_53_3:base():add_destroy_listener("CopMovement" .. tostring(l_53_0._unit:key()), callback(l_53_0, l_53_0, "parent_clbk_unit_destroyed"))
  else
    l_53_3:base():remove_destroy_listener("CopMovement" .. tostring(l_53_0._unit:key()))
    l_53_0._link_data = nil
  end
end

CopMovement.parent_clbk_unit_destroyed = function(l_54_0, l_54_1, l_54_2)
  l_54_0._link_data = nil
  l_54_1:base():remove_destroy_listener("CopMovement" .. tostring(l_54_0._unit:key()))
end

CopMovement.is_physically_linked = function(l_55_0)
  if l_55_0._link_data then
    return l_55_0._link_data.physical
  end
end

CopMovement.move_vec = function(l_56_0)
  return l_56_0._move_dir
end

CopMovement.upd_ground_ray = function(l_57_0, l_57_1)
  local ground_z = l_57_0._nav_tracker:field_z()
  local safe_pos = temp_vec1
  if not l_57_1 then
    mvec3_set(temp_vec1, l_57_0._m_pos)
  end
  mvec3_set_z(temp_vec1, ground_z + 100)
  local down_pos = temp_vec2
  mvec3_set(temp_vec2, safe_pos)
  mvec3_set_z(temp_vec2, ground_z - 140)
  local old_pos = l_57_0._m_pos
  if not l_57_1 then
    local new_pos = l_57_0._m_pos
  end
  local hit_ray = nil
  if old_pos.z == new_pos.z then
    local gnd_ray_1 = World:raycast("ray", temp_vec1, temp_vec2, "slot_mask", l_57_0._slotmask_gnd_ray, "ray_type", "walk")
    if gnd_ray_1 then
      ground_z = math.lerp(gnd_ray_1.position.z, l_57_0._m_pos.z, 0.5)
      hit_ray = gnd_ray_1
    else
      local gnd_ray_1 = World:raycast("ray", temp_vec1, temp_vec2, "slot_mask", l_57_0._slotmask_gnd_ray, "ray_type", "walk")
      local move_vec = temp_vec3
      mvec3_set(move_vec, new_pos)
      mvector3.subtract(move_vec, old_pos)
      mvec3_set_z(move_vec, 0)
      local move_vec_len = mvector3.normalize(move_vec)
      mvector3.multiply(move_vec, math.min(move_vec_len, 20))
      mvector3.add(temp_vec1, move_vec)
      mvector3.add(temp_vec2, move_vec)
      if gnd_ray_1 then
        hit_ray = gnd_ray_1
        local gnd_ray_2 = World:raycast("ray", temp_vec1, temp_vec2, "slot_mask", l_57_0._slotmask_gnd_ray, "ray_type", "walk")
        if gnd_ray_2 then
          ground_z = math.lerp(gnd_ray_1.position.z, gnd_ray_2.position.z, 0.5)
        else
          ground_z = math.lerp(gnd_ray_1.position.z, l_57_0._m_pos.z, 0.5)
        end
      else
        local gnd_ray_2 = World:raycast("ray", temp_vec1, temp_vec2, "slot_mask", l_57_0._slotmask_gnd_ray, "ray_type", "walk")
        if gnd_ray_2 then
          hit_ray = gnd_ray_2
          ground_z = math.lerp(gnd_ray_2.position.z, l_57_0._m_pos.z, 0.5)
        end
      end
    end
  end
  if hit_ray then
    local fake_ray = {position = new_pos:with_z(ground_z), ray = math.DOWN, unit = hit_ray.unit}
  end
  l_57_0._action_common_data.gnd_ray = fake_ray
  l_57_0._gnd_ray = fake_ray
end

CopMovement.on_suppressed = function(l_58_0, l_58_1)
  local suppression = l_58_0._suppression
  local end_value = l_58_1 and 1 or 0
  local vis_state = l_58_0._ext_base:lod_stage()
  if vis_state and end_value ~= suppression.value then
    local t = TimerManager:game():time()
    local duration = 0.5 * math.abs(end_value - suppression.value)
    suppression.transition = {end_val = end_value, start_val = suppression.value, duration = duration, start_t = t, next_upd_t = t + 0.070000000298023}
  else
    suppression.transition = nil
    suppression.value = end_value
    l_58_0._machine:set_global("sup", end_value)
  end
  l_58_0._action_common_data.is_suppressed = l_58_1 or nil
  if Network:is_server() and l_58_1 and l_58_0._tweak_data.allow_crouch and not l_58_0._tweak_data.no_stand and not l_58_0:chk_action_forbidden("walk") then
    if l_58_0._ext_anim.idle and (not l_58_0._active_actions[2] or l_58_0._active_actions[2]:type() == "idle") then
      local action_desc = {type = "act", body_part = 1, variant = "suppressed_reaction", blocks = {walk = -1}}
      l_58_0:action_request(action_desc)
    else
      if not l_58_0._ext_anim.crouch and l_58_0._tweak_data.crouch_move and l_58_0._tweak_data.allow_crouch then
        local action_desc = {type = "crouch", body_part = 4}
        l_58_0:action_request(action_desc)
      end
    end
  end
  l_58_0:enable_update()
  if Network:is_server() then
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  managers.network:session():send_to_peers_synched("suppressed_state", l_58_0._unit, true)
end
end

CopMovement.damage_clbk = function(l_59_0, l_59_1, l_59_2)
  local hurt_type = l_59_2.result.type
  if hurt_type == "death" and l_59_0._queued_actions then
    l_59_0._queued_actions = {}
  end
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if (not hurt_type or not Network:is_server() or l_59_0:chk_action_forbidden(hurt_type)) and hurt_type == "death" then
    debug_pause_unit(l_59_0._unit, "[CopMovement:damage_clbk] Death action skipped!!!", l_59_0._unit)
    Application:draw_cylinder(l_59_0._m_pos, l_59_0._m_pos + math.UP * 5000, 30, 1, 0, 0)
    print("active_actions")
    for body_part,action in ipairs(l_59_0._active_actions) do
      if action then
        print(body_part, action:type(), inspect(action._blocks))
      end
    end
  end
  return 
  if hurt_type == "death" and l_59_0._rope then
    l_59_0._rope:base():retract()
    l_59_0._rope = nil
  end
  if not l_59_2.col_ray or not l_59_2.col_ray.ray then
    local attack_dir = l_59_2.attack_dir
  end
  if not l_59_2.col_ray or not l_59_2.col_ray.position then
    local hit_pos = l_59_2.pos
  end
  local lgt_hurt = hurt_type == "light_hurt"
  local body_part = lgt_hurt and 4 or 1
  local blocks = nil
  if not lgt_hurt then
    blocks = {walk = -1, action = -1, act = -1, aim = -1, tase = -1}
    if hurt_type == "bleedout" then
      blocks.bleedout = -1
      blocks.hurt = -1
      blocks.heavy_hurt = -1
      blocks.hurt_sick = -1
    end
  end
  local block_type = nil
  if l_59_2.variant == "tase" then
    block_type = "bleedout"
  else
    block_type = hurt_type
  end
  local client_interrupt = nil
  if Network:is_client() and (hurt_type ~= "light_hurt" and ((hurt_type == "hurt" and l_59_2.variant ~= "tase") or hurt_type == "hurt_sick")) then
    client_interrupt = true
  end
  local tweak = l_59_0._tweak_data
  {type = "hurt", block_type = block_type, hurt_type = hurt_type, variant = l_59_2.variant, direction_vec = attack_dir, hit_pos = hit_pos}.body_part = body_part
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "hurt", block_type = block_type, hurt_type = hurt_type, variant = l_59_2.variant, direction_vec = attack_dir, hit_pos = hit_pos}.blocks = blocks
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "hurt", block_type = block_type, hurt_type = hurt_type, variant = l_59_2.variant, direction_vec = attack_dir, hit_pos = hit_pos}.client_interrupt = client_interrupt
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "hurt", block_type = block_type, hurt_type = hurt_type, variant = l_59_2.variant, direction_vec = attack_dir, hit_pos = hit_pos}.attacker_unit = l_59_2.attacker_unit
   -- DECOMPILER ERROR: Confused about usage of registers!

  {type = "hurt", block_type = block_type, hurt_type = hurt_type, variant = l_59_2.variant, direction_vec = attack_dir, hit_pos = hit_pos}.death_type = (tweak.damage.death_severity and (tweak.damage.death_severity >= l_59_2.damage / tweak.HEALTH_INIT or not "heavy") and "normal") or "normal"
  do
     -- DECOMPILER ERROR: Confused at declaration of local variable

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    if Network:is_server() or not l_59_0:chk_action_forbidden({type = "hurt", block_type = block_type, hurt_type = hurt_type, variant = l_59_2.variant, direction_vec = attack_dir, hit_pos = hit_pos}) then
      l_59_0:action_request({type = "hurt", block_type = block_type, hurt_type = hurt_type, variant = l_59_2.variant, direction_vec = attack_dir, hit_pos = hit_pos})
      if hurt_type == "death" and l_59_0._queued_actions then
        l_59_0._queued_actions = {}
      end
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
  end
end

CopMovement.anim_clbk_footstep = function(l_60_0, l_60_1)
  managers.game_play_central:request_play_footstep(l_60_1, l_60_0._m_pos)
end

CopMovement.get_footstep_event = function(l_61_0)
  local event_name = nil
  if l_61_0._footstep_style and l_61_0._unit:anim_data()[l_61_0._footstep_style] then
    event_name = l_61_0._footstep_event
  else
    l_61_0._footstep_style = l_61_0._unit:anim_data().run and "run" or "walk"
    event_name = "footstep_npc_" .. l_61_0._footwear .. "_" .. l_61_0._footstep_style
    l_61_0._footstep_event = event_name
  end
  return event_name
end

CopMovement.get_walk_to_pos = function(l_62_0)
  if not l_62_0._active_actions[1] then
    local leg_action = l_62_0._active_actions[2]
  end
  if leg_action and leg_action.get_walk_to_pos then
    return leg_action:get_walk_to_pos()
  end
end

CopMovement.anim_clbk_death_drop = function(l_63_0, ...)
  for _,action in ipairs(l_63_0._active_actions) do
    if action and action.on_death_drop then
      action:on_death_drop(...)
    end
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

CopMovement.on_death_exit = function(l_64_0)
  for _,action in ipairs(l_64_0._active_actions) do
    if action and action.on_death_exit then
      action:on_death_exit()
    end
  end
end

CopMovement.anim_clbk_reload_exit = function(l_65_0)
  if l_65_0._ext_inventory:equipped_unit() then
    l_65_0._ext_inventory:equipped_unit():base():on_reload()
  end
end

CopMovement.anim_clbk_force_ragdoll = function(l_66_0)
  for _,action in ipairs(l_66_0._active_actions) do
    if action and action.force_ragdoll then
      action:force_ragdoll()
    end
  end
end

CopMovement.anim_clbk_rope = function(l_67_0, l_67_1, l_67_2)
  if l_67_2 == "on" then
    if l_67_0._rope then
      l_67_0._rope:base():retract()
    end
    local hips_obj = l_67_0._unit:get_object(Idstring("Hips"))
    l_67_0._rope = World:spawn_unit(Idstring("units/payday2/characters/ene_acc_rope/ene_acc_rope"), hips_obj:position(), Rotation())
    l_67_0._rope:base():setup(hips_obj)
  elseif l_67_0._rope then
    l_67_0._rope:base():retract()
    l_67_0._rope = nil
  end
end

CopMovement.pos_rsrv_id = function(l_68_0)
  return l_68_0._pos_rsrv_id
end

CopMovement.anim_clbk_melee_strike = function(l_69_0, l_69_1)
  for body_part,action in pairs(l_69_0._active_actions) do
    if action and action.anim_clbk_melee_strike then
      action:anim_clbk_melee_strike()
    end
  end
end

CopMovement.anim_clbk_wanted_item = function(l_70_0, l_70_1, l_70_2, l_70_3, l_70_4)
  if not l_70_0._wanted_items then
    l_70_0._wanted_items = {}
  end
  table.insert(l_70_0._wanted_items, {l_70_2, l_70_3, l_70_4})
end

CopMovement.anim_clbk_block_info = function(l_71_0, l_71_1, l_71_2, l_71_3)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local state_bool = true
for body_part,action in pairs(l_71_0._active_actions) do
  if action and action.set_blocks then
    action:set_blocks(l_71_2, state_bool)
  end
end
end

CopMovement.anim_clbk_ik_change = function(l_72_0, l_72_1)
  local preset_name = l_72_0._ext_anim.base_aim_ik
  for body_part,action in pairs(l_72_0._active_actions) do
    if action and action.set_ik_preset then
      action:set_ik_preset(preset_name)
    end
  end
end

CopMovement.anim_clbk_police_called = function(l_73_0, l_73_1)
  if Network:is_server() and not managers.groupai:state():is_ecm_jammer_active("call") then
    local group_state = managers.groupai:state()
    local cop_type = tostring(group_state.blame_triggers[l_73_0._ext_base._tweak_table])
    if cop_type == "civ" then
      group_state:on_police_called(l_73_0:coolness_giveaway())
    else
      group_state:on_police_called(l_73_0:coolness_giveaway())
    end
  end
end

CopMovement.anim_clbk_stance = function(l_74_0, l_74_1, l_74_2, l_74_3)
  l_74_0:set_stance(l_74_2)
end

CopMovement.spawn_wanted_items = function(l_75_0)
  if l_75_0._wanted_items then
    for _,spawn_info in ipairs(l_75_0._wanted_items) do
      l_75_0:_equip_item(unpack(spawn_info))
    end
    l_75_0._wanted_items = nil
  end
end

CopMovement._equip_item = function(l_76_0, l_76_1, l_76_2, l_76_3)
  local align_name = l_76_0._gadgets.aligns[l_76_2]
  if not align_name then
    print("[CopMovement:anim_clbk_equip_item] non existent align place:", l_76_2)
    return 
  end
  local align_obj = l_76_0._unit:get_object(align_name)
  local available_items = l_76_0._gadgets[l_76_1]
  if not available_items then
    print("[CopMovement:anim_clbk_equip_item] non existent item_type:", l_76_1)
    return 
  end
  local item_name = available_items[math.random(available_items)]
  print("[CopMovement:_equip_item]", item_name)
  local item_unit = World:spawn_unit(item_name, align_obj:position(), align_obj:rotation())
  l_76_0._unit:link(align_name, item_unit, item_unit:orientation_object():name())
  if not l_76_0._equipped_gadgets then
    l_76_0._equipped_gadgets = {}
  end
  if not l_76_0._equipped_gadgets[l_76_2] then
    l_76_0._equipped_gadgets[l_76_2] = {}
  end
  table.insert(l_76_0._equipped_gadgets[l_76_2], item_unit)
  if l_76_3 then
    if not l_76_0._droppable_gadgets then
      l_76_0._droppable_gadgets = {}
    end
    table.insert(l_76_0._droppable_gadgets, item_unit)
  end
end

CopMovement.anim_clbk_drop_held_items = function(l_77_0)
  l_77_0:drop_held_items()
end

CopMovement.anim_clbk_flush_wanted_items = function(l_78_0)
  l_78_0._wanted_items = nil
end

CopMovement.drop_held_items = function(l_79_0)
  if not l_79_0._droppable_gadgets then
    return 
  end
  for _,drop_item_unit in ipairs(l_79_0._droppable_gadgets) do
    local wanted_item_key = drop_item_unit:key()
    if alive(drop_item_unit) then
      for align_place,item_list in pairs(l_79_0._equipped_gadgets) do
        do
          if wanted_item_key then
            for i_item,item_unit in ipairs(item_list) do
              if item_unit:key() == wanted_item_key then
                table.remove(item_list, i_item)
                wanted_item_key = nil
                for (for control),align_place in (for generator) do
                end
              end
              for i_1,i_2 in (for generator) do
                do return end
              end
               -- DECOMPILER ERROR: Confused about usage of registers for local variables.

            end
          end
          drop_item_unit:unlink()
          drop_item_unit:set_slot(0)
          for (for control),_ in (for generator) do
          end
          for align_place,item_list in pairs(l_79_0._equipped_gadgets) do
             -- DECOMPILER ERROR: Confused at declaration of local variable

            if wanted_item_key then
              for i_item,item_unit in ipairs(i_3) do
                 -- DECOMPILER ERROR: Confused at declaration of local variable

                 -- DECOMPILER ERROR: Confused about usage of registers!

                if not alive(i_3) then
                  table.remove(i_3, i_item)
                   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

                end
              end
            end
          end
        end
        l_79_0._droppable_gadgets = nil
         -- DECOMPILER ERROR: Confused about usage of registers for local variables.

         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CopMovement._destroy_gadgets = function(l_80_0)
  if not l_80_0._equipped_gadgets then
    return 
  end
  for align_place,item_list in pairs(l_80_0._equipped_gadgets) do
    for _,item_unit in ipairs(item_list) do
      if alive(item_unit) then
        item_unit:set_slot(0)
      end
    end
  end
  l_80_0._equipped_gadgets = nil
  l_80_0._droppable_gadgets = nil
end

CopMovement.clbk_inventory = function(l_81_0, l_81_1, l_81_2)
  local weapon = l_81_0._ext_inventory:equipped_unit()
  if weapon then
    if l_81_0._weapon_hold then
      l_81_0._machine:set_global(l_81_0._weapon_hold, 0)
    end
    if l_81_0._weapon_anim_global then
      l_81_0._machine:set_global(l_81_0._weapon_anim_global, 0)
    end
    local weap_tweak = weapon:base():weapon_tweak_data()
    local weapon_hold = weap_tweak.hold
    l_81_0._machine:set_global(weapon_hold, 1)
    l_81_0._weapon_hold = weapon_hold
    local weapon_usage = weap_tweak.usage
    l_81_0._machine:set_global(weapon_usage, 1)
    l_81_0._weapon_anim_global = weapon_usage
  end
  for _,action in ipairs(l_81_0._active_actions) do
    if action and action.on_inventory_event then
      action:on_inventory_event(l_81_2)
    end
  end
end

CopMovement.sync_shot_blank = function(l_82_0, l_82_1)
  local equipped_weapon = l_82_0._ext_inventory:equipped_unit()
  if equipped_weapon and equipped_weapon:base().fire_blank then
    local fire_dir = nil
    if l_82_0._attention then
      if l_82_0._attention.unit then
        fire_dir = l_82_0._attention.unit:movement():m_head_pos() - l_82_0:m_head_pos()
        mvector3.normalize(fire_dir)
      else
        fire_dir = l_82_0._attention.pos - l_82_0:m_head_pos()
        mvector3.normalize(fire_dir)
      end
    else
      fire_dir = l_82_0._action_common_data.fwd
    end
  end
  equipped_weapon:base():fire_blank(fire_dir, l_82_1)
end
end

CopMovement.sync_taser_fire = function(l_83_0)
  local tase_action = l_83_0._active_actions[3]
  if tase_action and tase_action:type() == "tase" and not tase_action:expired() then
    tase_action:fire_taser()
  end
end

CopMovement.save = function(l_84_0, l_84_1)
  do
    local my_save_data = {}
    if l_84_0._stance.transition then
      my_save_data.stance = l_84_0._stance.transition.end_values
    else
      if l_84_0._stance.values[1] ~= 1 then
        my_save_data.stance = l_84_0._stance.values
      end
    end
    for _,action in ipairs(l_84_0._active_actions) do
      if action and action.save then
        local action_save_data = {}
        action:save(action_save_data)
        if next(action_save_data) then
          if not my_save_data.actions then
            my_save_data.actions = {}
          end
          table.insert(my_save_data.actions, action_save_data)
        end
      end
    end
    if l_84_0._allow_fire then
      my_save_data.allow_fire = true
    end
    if l_84_0._attention then
      if l_84_0._attention.pos then
        my_save_data.attention = l_84_0._attention
      else
        if l_84_0._attention.unit:id() == -1 then
          my_save_data.attention = {pos = l_84_0._attention.unit:movement():m_com()}
        else
          managers.enemy:add_delayed_clbk("clbk_sync_attention" .. tostring(l_84_0._unit:key()), callback(l_84_0, l_84_0, "clbk_sync_attention", l_84_0._attention), TimerManager:game():time() + 0.10000000149012)
        end
      end
    end
    if l_84_0._equipped_gadgets then
      local equipped_items = {}
      my_save_data.equipped_gadgets = equipped_items
      local _get_item_type_from_unit = function(l_1_0)
      local wanted_item_name = l_1_0:name()
      for item_type,item_unit_names in pairs(self._gadgets) do
        for i_item_unit_name,item_unit_name in ipairs(item_unit_names) do
          if item_unit_name == wanted_item_name then
            return item_type
          end
        end
      end
      end
      local _is_item_droppable = function(l_2_0)
      if not self._droppable_gadgets then
        return 
      end
      local wanted_item_key = l_2_0:key()
      for _,droppable_unit in ipairs(self._droppable_gadgets) do
        if droppable_unit:key() == wanted_item_key then
          return true
        end
      end
      end
      for align_place,item_list in pairs(l_84_0._equipped_gadgets) do
        for i_item,item_unit in ipairs(item_list) do
          if alive(item_unit) then
            table.insert(equipped_items, {})
          end
        end
      end
    end
  end
  if next(my_save_data) then
     -- Warning: undefined locals caused missing assignments!
     -- Warning: missing end command somewhere! Added here
  end
end

CopMovement.load = function(l_85_0, l_85_1)
  local my_load_data = l_85_1.movement
  if not my_load_data then
    return 
  end
  local res = l_85_0:play_redirect("idle")
  if not res then
    debug_pause_unit(l_85_0._unit, "[CopMovement:load] failed idle redirect in ", l_85_0._machine:segment_state(Idstring("base")), l_85_0._unit)
  end
  l_85_0._allow_fire = my_load_data.allow_fire
  l_85_0._attention = my_load_data.attention
  if my_load_data.stance then
    for i_stance,v in ipairs(my_load_data.stance) do
      if v > 0 then
        l_85_0:_change_stance(i_stance)
        if i_stance == 1 then
          l_85_0:set_cool(true)
          for (for control),i_stance in (for generator) do
          end
          l_85_0:set_cool(false)
        end
      end
    end
    if my_load_data.actions then
      for _,action_load_data in ipairs(my_load_data.actions) do
        l_85_0:action_request(action_load_data)
      end
    end
    if my_load_data.equipped_gadgets then
      for _,item_desc in ipairs(my_load_data.equipped_gadgets) do
        l_85_0:_equip_item(unpack(item_desc))
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CopMovement.tweak_data_clbk_reload = function(l_86_0)
  l_86_0._tweak_data = tweak_data.character[l_86_0._ext_base._tweak_table]
  l_86_0._action_common_data.char_tweak = l_86_0._tweak_data
end

CopMovement._chk_start_queued_action = function(l_87_0)
  local queued_actions = l_87_0._queued_actions
  repeat
    repeat
      if next(queued_actions) then
        local action_desc = queued_actions[1]
        if l_87_0:chk_action_forbidden(action_desc) then
          l_87_0._need_upd = true
          do return end
        elseif action_desc.type == "walk" or action_desc.type == "spooc" then
          action_desc.nav_path[action_desc.path_index or 1] = mvector3.copy(l_87_0._m_pos)
        end
        table.remove(queued_actions, 1)
        CopMovement.action_request(l_87_0, action_desc)
      else
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CopMovement._push_back_queued_action = function(l_88_0, l_88_1)
  table.insert(l_88_0._queued_actions, l_88_1)
end

CopMovement._push_front_queued_action = function(l_89_0, l_89_1)
  table.insert(l_89_0._queued_actions, 1, l_89_1)
end

CopMovement._cancel_latest_action = function(l_90_0, l_90_1, l_90_2)
  for i = #l_90_0._queued_actions, 1, -1 do
    if l_90_0._queued_actions[i].type == l_90_1 then
      table.remove(l_90_0._queued_actions, i)
      return 
    end
  end
  for body_part,action in ipairs(l_90_0._active_actions) do
    if action and action:type() == l_90_1 then
      l_90_0._active_actions[body_part] = false
      if action.on_exit then
        action:on_exit()
      end
      l_90_0:_chk_start_queued_action()
      l_90_0._ext_brain:action_complete_clbk(action)
      return 
    end
  end
  if l_90_2 then
    debug_pause_unit(l_90_0._unit, "[CopMovement:_cancel_latest_action] no queued or ongoing ", l_90_1, "action", l_90_0._unit, inspect(l_90_0._queued_actions), inspect(l_90_0._active_actions))
  end
end

CopMovement._get_latest_walk_action = function(l_91_0)
  for i = #l_91_0._queued_actions, 1, -1 do
    if l_91_0._queued_actions[i].type == "walk" and l_91_0._queued_actions[i].persistent then
      return l_91_0._queued_actions[i], true
    end
  end
  if l_91_0._active_actions[2] and l_91_0._active_actions[2]:type() == "walk" then
    return l_91_0._active_actions[2]
  end
  debug_pause_unit(l_91_0._unit, "[CopMovement:_get_latest_walk_action] no queued or ongoing walk action", l_91_0._unit, inspect(l_91_0._queued_actions), inspect(l_91_0._active_actions))
end

CopMovement._get_latest_act_action = function(l_92_0)
  for i = #l_92_0._queued_actions, 1, -1 do
    if l_92_0._queued_actions[i].type == "act" and not l_92_0._queued_actions[i].host_expired then
      return l_92_0._queued_actions[i], true
    end
  end
  if l_92_0._active_actions[1] and l_92_0._active_actions[1]:type() == "act" then
    return l_92_0._active_actions[1]
  end
end

CopMovement.sync_action_walk_nav_point = function(l_93_0, l_93_1)
  local walk_action, is_queued = l_93_0:_get_latest_walk_action()
  if is_queued then
    table.insert(walk_action.nav_path, l_93_1)
  elseif walk_action then
    walk_action:append_nav_point(l_93_1)
  else
    debug_pause_unit(l_93_0._unit, "[CopMovement:sync_action_walk_nav_point] no walk action!!!", l_93_0._unit, l_93_1)
  end
end

CopMovement.sync_action_walk_nav_link = function(l_94_0, l_94_1, l_94_2, l_94_3, l_94_4)
  local nav_link = l_94_0._actions.walk.synthesize_nav_link(l_94_1, l_94_2, l_94_0._actions.act:_get_act_name_from_index(l_94_3), l_94_4)
  local walk_action, is_queued = l_94_0:_get_latest_walk_action()
  if is_queued then
    nav_link.element.value = function(l_1_0, l_1_1)
    return l_1_0[l_1_1]
   end
    nav_link.element.nav_link_wants_align_pos = function(l_2_0)
      return l_2_0.from_idle
      end
    table.insert(walk_action.nav_path, nav_link)
  elseif walk_action then
    walk_action:append_nav_point(nav_link)
  else
    debug_pause_unit(l_94_0._unit, "[CopMovement:sync_action_walk_nav_link] no walk action!!!", l_94_0._unit, l_94_1, l_94_2, l_94_3)
  end
end

CopMovement.sync_action_walk_stop = function(l_95_0, l_95_1)
  local walk_action, is_queued = l_95_0:_get_latest_walk_action()
  if is_queued then
    if not walk_action.nav_path[#walk_action.nav_path].x then
      walk_action.nav_path[#walk_action.nav_path] = l_95_0._actions.walk._nav_point_pos(walk_action.nav_path[#walk_action.nav_path])
    end
    table.insert(walk_action.nav_path, l_95_1)
    walk_action.persistent = nil
  elseif walk_action then
    walk_action:stop(l_95_1)
  else
    debug_pause("[CopMovement:sync_action_walk_stop] no walk action!!!", l_95_0._unit, l_95_1)
  end
end

CopMovement._get_latest_spooc_action = function(l_96_0)
  if l_96_0._queued_actions then
    for i = #l_96_0._queued_actions, 1, -1 do
      if l_96_0._queued_actions[i].type == "spooc" and not l_96_0._queued_actions[i].stop_pos then
        return l_96_0._queued_actions[i], true
      end
    end
  end
  if l_96_0._active_actions[1] and l_96_0._active_actions[1]:type() == "spooc" then
    return l_96_0._active_actions[1]
  end
end

CopMovement.sync_action_spooc_nav_point = function(l_97_0, l_97_1)
  local spooc_action, is_queued = l_97_0:_get_latest_spooc_action()
  if is_queued and (not spooc_action.stop_pos or spooc_action.nr_expected_nav_points) then
    table.insert(spooc_action.nav_path, l_97_1)
    if spooc_action.nr_expected_nav_points then
      if spooc_action.nr_expected_nav_points == 1 then
        spooc_action.nr_expected_nav_points = nil
        table.insert(spooc_action.nav_path, spooc_action.stop_pos)
      else
        spooc_action.nr_expected_nav_points = spooc_action.nr_expected_nav_points - 1
        do return end
        if spooc_action then
          spooc_action:sync_append_nav_point(l_97_1)
        end
      end
    end
  end
end

CopMovement.sync_action_spooc_stop = function(l_98_0, l_98_1, l_98_2)
  local spooc_action, is_queued = l_98_0:_get_latest_spooc_action()
  if is_queued then
    if spooc_action.host_stop_pos_inserted then
      l_98_2 = l_98_2 + spooc_action.host_stop_pos_inserted
    end
    local nav_path = spooc_action.nav_path
    repeat
      if l_98_2 < #nav_path then
        table.remove(nav_path)
      else
        spooc_action.stop_pos = l_98_1
        if #nav_path < l_98_2 - 1 then
          spooc_action.nr_expected_nav_points = l_98_2 - #nav_path + 1
        else
          table.insert(nav_path, l_98_1)
          spooc_action.path_index = math.max(1, math.min(spooc_action.path_index, #nav_path - 1))
        end
      elseif spooc_action then
        spooc_action:sync_stop(l_98_1, l_98_2)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

CopMovement.sync_action_spooc_strike = function(l_99_0, l_99_1)
  local spooc_action, is_queued = l_99_0:_get_latest_spooc_action()
  if is_queued then
    if spooc_action.stop_pos and not spooc_action.nr_expected_nav_points then
      return 
    end
    table.insert(spooc_action.nav_path, l_99_1)
    spooc_action.strike = true
  elseif spooc_action then
    spooc_action:sync_strike(l_99_1)
  end
end

CopMovement.sync_action_tase_end = function(l_100_0)
  l_100_0:_cancel_latest_action("tase", true)
end

CopMovement.sync_pose = function(l_101_0, l_101_1)
  if l_101_0._ext_damage:dead() then
    return 
  end
  local pose = l_101_1 == 1 and "stand" or "crouch"
  local new_action_data = {type = pose, body_part = 4}
  l_101_0:action_request(new_action_data)
end

CopMovement.sync_action_act_start = function(l_102_0, l_102_1, l_102_2, l_102_3, l_102_4)
  if l_102_0._ext_damage:dead() then
    return 
  end
  local redir_name = l_102_0._actions.act:_get_act_name_from_index(l_102_1)
  local action_data = {type = "act", body_part = 1, variant = redir_name, blocks = {act = -1, walk = -1, action = -1, idle = -1}, start_rot = l_102_3, start_pos = l_102_4}
  if l_102_2 then
    action_data.blocks.light_hurt = -1
    action_data.blocks.hurt = -1
    action_data.blocks.heavy_hurt = -1
  end
  l_102_0:action_request(action_data)
end

CopMovement.sync_action_act_end = function(l_103_0)
  local act_action, queued = l_103_0:_get_latest_act_action()
  if queued then
    act_action.host_expired = true
  elseif act_action then
    l_103_0._active_actions[1] = false
    if act_action.on_exit then
      act_action:on_exit()
    end
    l_103_0:_chk_start_queued_action()
    l_103_0._ext_brain:action_complete_clbk(act_action)
  end
end

CopMovement.sync_action_dodge_start = function(l_104_0, l_104_1, l_104_2, l_104_3, l_104_4)
  if l_104_0._ext_damage:dead() then
    return 
  end
  local action_data = {type = "dodge", body_part = 1, variation = CopActionDodge.get_variation_name(l_104_1), direction = Rotation(l_104_3):y(), side = CopActionDodge.get_side_name(l_104_2), speed = l_104_4}
  l_104_0:action_request(action_data)
end

CopMovement.sync_action_dodge_end = function(l_105_0)
  l_105_0:_cancel_latest_action("dodge")
end

CopMovement.sync_action_aim_end = function(l_106_0)
  l_106_0:_cancel_latest_action("shoot", true)
end

CopMovement.sync_action_hurt_end = function(l_107_0)
  for i = #l_107_0._queued_actions, 1, -1 do
    if l_107_0._queued_actions[i].type == "hurt" then
      table.remove(l_107_0._queued_actions, i)
      return 
    end
  end
  local action = l_107_0._active_actions[1]
  if action and action:type() == "hurt" then
    l_107_0._active_actions[1] = false
    if action.on_exit then
      action:on_exit()
    end
    local hurt_type = action:hurt_type()
    if hurt_type == "bleedout" or hurt_type == "fatal" then
      {action = -1, walk = -1}.hurt = -1
       -- DECOMPILER ERROR: Confused about usage of registers!

      {action = -1, walk = -1}.aim = -1
       -- DECOMPILER ERROR: Confused about usage of registers!

      {action = -1, walk = -1}.hurt = -1
       -- DECOMPILER ERROR: Confused about usage of registers!

      {action = -1, walk = -1}.heavy_hurt = -1
       -- DECOMPILER ERROR: Confused about usage of registers!

      {action = -1, walk = -1}.light_hurt = -1
       -- DECOMPILER ERROR: Confused about usage of registers!

      {action = -1, walk = -1}.stand = -1
       -- DECOMPILER ERROR: Confused about usage of registers!

      {action = -1, walk = -1}.crouch = -1
       -- DECOMPILER ERROR: Confused about usage of registers!

      local action_data = {type = "act", body_part = 1, variant = "stand", client_interrupt = true, blocks = {action = -1, walk = -1}}
      local res = CopMovement.action_request(l_107_0, action_data)
    else
      l_107_0:_chk_start_queued_action()
      l_107_0._ext_brain:action_complete_clbk(action)
    end
    return 
  end
  debug_pause("[CopMovement:sync_action_hurt_end] no queued or ongoing hurt action", l_107_0._unit, inspect(l_107_0._queued_actions), inspect(l_107_0._active_actions))
end

CopMovement.enable_update = function(l_108_0, l_108_1)
  if not l_108_0._need_upd then
    l_108_0._unit:set_extension_update_enabled(ids_movement, true)
    l_108_0._need_upd = true
    l_108_0._force_head_upd = l_108_1
  end
end

CopMovement.ground_ray = function(l_109_0)
  return l_109_0._gnd_ray
end

CopMovement.on_nav_link_unregistered = function(l_110_0, l_110_1)
  for body_part,action in pairs(l_110_0._active_actions) do
    if action and action.on_nav_link_unregistered then
      action:on_nav_link_unregistered(l_110_1)
    end
  end
end

CopMovement.pre_destroy = function(l_111_0)
  tweak_data:remove_reload_callback(l_111_0)
  if alive(l_111_0._rope) then
    l_111_0._rope:base():retract()
    l_111_0._rope = nil
  end
  if l_111_0._nav_tracker then
    managers.navigation:destroy_nav_tracker(l_111_0._nav_tracker)
    l_111_0._nav_tracker = nil
  end
  if l_111_0._pos_rsrv_id then
    managers.navigation:release_pos_reservation_id(l_111_0._pos_rsrv_id)
    l_111_0._pos_rsrv_id = nil
  end
  if l_111_0._link_data then
    l_111_0._link_data.parent:base():remove_destroy_listener("CopMovement" .. tostring(unit:key()))
  end
  l_111_0:_destroy_gadgets()
  for i_action,action in ipairs(l_111_0._active_actions) do
    if action and action.on_destroy then
      action:on_destroy()
    end
  end
  if l_111_0._attention and l_111_0._attention.destroy_listener_key then
    l_111_0._attention.unit:base():remove_destroy_listener(l_111_0._attention.destroy_listener_key)
    l_111_0._attention.destroy_listener_key = nil
  end
end

CopMovement.on_anim_act_clbk = function(l_112_0, l_112_1)
  for body_part,action in ipairs(l_112_0._active_actions) do
    if action and action.anim_act_clbk then
      action:anim_act_clbk(l_112_1)
    end
  end
end

CopMovement.clbk_sync_attention = function(l_113_0, l_113_1)
  if not alive(l_113_0._unit) or l_113_0._unit:id() == -1 then
    return 
  end
  if l_113_0._attention ~= l_113_1 then
    return 
  end
  if l_113_1.handler then
    l_113_0._ext_network:send("set_attention", l_113_1.handler:unit(), l_113_1.reaction)
  else
    if l_113_0._attention.unit then
      l_113_0._ext_network:send("cop_set_attention_unit", l_113_0._attention.unit)
    end
  end
end


