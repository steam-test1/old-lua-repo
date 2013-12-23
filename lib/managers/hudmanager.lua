-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hudmanager.luac 

if not HUDManager then
  HUDManager = class()
end
HUDManager.WAITING_SAFERECT = Idstring("guis/waiting_saferect")
HUDManager.STATS_SCREEN_SAFERECT = Idstring("guis/stats_screen/stats_screen_saferect_pd2")
HUDManager.STATS_SCREEN_FULLSCREEN = Idstring("guis/stats_screen/stats_screen_fullscreen")
HUDManager.ANNOUNCEMENT_HUD = Idstring("guis/announcement_hud")
HUDManager.ANNOUNCEMENT_HUD_FULLSCREEN = Idstring("guis/announcement_hud_fullscreen")
HUDManager.WAITING_FOR_PLAYERS_SAFERECT = Idstring("guis/waiting_saferect")
HUDManager.ASSAULT_DIALOGS = {"gen_ban_b01a", "gen_ban_b01b", "gen_ban_b02a", "gen_ban_b02b", "gen_ban_b02c", "gen_ban_b03x", "gen_ban_b04x", "gen_ban_b05x", "gen_ban_b10", "gen_ban_b11", "gen_ban_b12"}
core:import("CoreEvent")
HUDManager.init = function(l_1_0)
  l_1_0._component_map = {}
  local safe_rect_pixels = managers.viewport:get_safe_rect_pixels()
  local safe_rect = managers.viewport:get_safe_rect()
  local res = RenderSettings.resolution
  l_1_0._workspace_size = {x = 0, y = 0, w = res.x, h = res.y}
  l_1_0._saferect_size = {x = safe_rect.x, y = safe_rect.y, w = safe_rect.width, h = safe_rect.height}
  l_1_0._mid_saferect = managers.gui_data:create_saferect_workspace()
  l_1_0._fullscreen_workspace = managers.gui_data:create_fullscreen_16_9_workspace(managers.gui_data)
  l_1_0._saferect = managers.gui_data:create_saferect_workspace()
  managers.gui_data:layout_corner_saferect_workspace(l_1_0._saferect)
  l_1_0._workspace = Overlay:gui():create_scaled_screen_workspace(l_1_0._workspace_size.w, l_1_0._workspace_size.h, l_1_0._workspace_size.x, l_1_0._workspace_size.y, RenderSettings.resolution.x, RenderSettings.resolution.y)
  managers.gui_data:layout_fullscreen_workspace(l_1_0._workspace)
  l_1_0._updators = {}
  managers.viewport:add_resolution_changed_func(callback(l_1_0, l_1_0, "resolution_changed"))
  l_1_0._sound_source = SoundDevice:create_source("hud")
  l_1_0._reached_level_s = managers.localization:text("debug_lu_reached_level")
  l_1_0._current_spec_s = managers.localization:text("debug_lu_current_spec")
  l_1_0._unlocked_s = managers.localization:text("debug_lu_unlocked")
  l_1_0._level_locked_s = managers.localization:text("debug_lu_level_locked")
  l_1_0._tree_assault_s = managers.localization:text("debug_upgrade_tree_assault")
  l_1_0._tree_sharpshooter_s = managers.localization:text("debug_upgrade_tree_sharpshooter")
  l_1_0._tree_support_s = managers.localization:text("debug_upgrade_tree_support")
  l_1_0._tree_technician_s = managers.localization:text("debug_upgrade_tree_technician")
  managers.user:add_setting_changed_callback("controller_mod", callback(l_1_0, l_1_0, "controller_mod_changed"), true)
  l_1_0:_init_player_hud_values()
  l_1_0._chatinput_changed_callback_handler = CoreEvent.CallbackEventHandler:new()
  HUDManager.HIDEABLE_HUDS = {}
  HUDManager.HIDEABLE_HUDS[PlayerBase.PLAYER_INFO_HUD_PD2:key()] = true
  HUDManager.HIDEABLE_HUDS[PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2:key()] = true
  HUDManager.HIDEABLE_HUDS[PlayerBase.PLAYER_DOWNED_HUD:key()] = true
  HUDManager.HIDEABLE_HUDS[IngameWaitingForRespawnState.GUI_SPECTATOR:key()] = true
  HUDManager.HIDEABLE_HUDS[Idstring("guis/mask_off_hud"):key()] = true
  l_1_0._visible_huds_states = {}
end

HUDManager.saferect_w = function(l_2_0)
  return l_2_0._saferect:width()
end

HUDManager.saferect_h = function(l_3_0)
  return l_3_0._saferect:height()
end

HUDManager.add_chatinput_changed_callback = function(l_4_0, l_4_1)
  l_4_0._chatinput_changed_callback_handler:add(l_4_1)
end

HUDManager.remove_chatinput_changed_callback = function(l_5_0, l_5_1)
  l_5_0._chatinput_changed_callback_handler:remove(l_5_1)
end

HUDManager.controller_mod_changed = function(l_6_0)
  l_6_0:_selected_item_icon_text()
end

local is_PS3 = SystemInfo:platform() == Idstring("PS3")
HUDManager._selected_item_icon_text = function(l_7_0)
  local hud = l_7_0:script(PlayerBase.PLAYER_HUD)
  if not hud then
    return 
  end
  if is_PS3 then
    hud.selected_item_icon:set_text(utf8.to_upper(managers.localization:text("debug_button_y")))
    return 
  end
  local type = managers.controller:get_default_wrapper_type()
  local text = "[" .. managers.controller:get_settings(type):get_connection("use_item"):get_input_name_list()[1] .. "]"
  hud.selected_item_icon:set_text(utf8.to_upper(text))
  local _, _, w, h = hud.selected_item_icon:text_rect()
  hud.selected_item_icon:set_size(w, h)
  l_7_0:set_item_selected()
end

HUDManager.init_finalize = function(l_8_0)
  if not l_8_0:exists(l_8_0.ANNOUNCEMENT_HUD_FULLSCREEN) then
    l_8_0:load_hud(l_8_0.ANNOUNCEMENT_HUD_FULLSCREEN, true, false, false, {})
    l_8_0:load_hud(l_8_0.ANNOUNCEMENT_HUD, true, false, true, {})
  end
  if not l_8_0:exists(l_8_0.WAITING_FOR_PLAYERS_SAFERECT) then
    managers.hud:load_hud(l_8_0.WAITING_FOR_PLAYERS_SAFERECT, false, true, true, {})
  end
  if not l_8_0:exists(PlayerBase.PLAYER_DOWNED_HUD) then
    managers.hud:load_hud(PlayerBase.PLAYER_DOWNED_HUD, false, false, true, {})
  end
  if not l_8_0:exists(PlayerBase.PLAYER_CUSTODY_HUD) then
    managers.hud:load_hud(PlayerBase.PLAYER_CUSTODY_HUD, false, false, true, {})
  end
  if not l_8_0:exists(PlayerBase.PLAYER_INFO_HUD_PD2) then
    managers.hud:load_hud(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2, false, false, false, {})
    managers.hud:load_hud(PlayerBase.PLAYER_INFO_HUD_PD2, false, false, true, {})
  end
  if not l_8_0:exists(PlayerBase.PLAYER_INFO_HUD) then
    managers.hud:load_hud(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN, false, false, false, {})
    managers.hud:load_hud(PlayerBase.PLAYER_INFO_HUD, false, false, true, {})
  end
  if not l_8_0:exists(PlayerBase.PLAYER_HUD) then
    managers.hud:load_hud(PlayerBase.PLAYER_HUD, false, false, true, {})
  end
end

HUDManager.set_safe_rect = function(l_9_0, l_9_1)
  l_9_0._saferect_size = l_9_1
  l_9_0._saferect:set_screen(l_9_1.w, l_9_1.h, l_9_1.x, l_9_1.y, RenderSettings.resolution.x)
end

HUDManager.load_hud = function(l_10_0, l_10_1, l_10_2, l_10_3, l_10_4, l_10_5, l_10_6, l_10_7, l_10_8)
  if l_10_0._component_map[l_10_1:key()] then
    Application:error("ERROR! Component " .. tostring(l_10_1) .. " have already been loaded!")
    return 
  end
  local bounding_box = {}
  local panel = nil
  if l_10_8 then
    panel = l_10_0._fullscreen_workspace:panel():gui(l_10_1, {})
  elseif l_10_7 then
    panel = l_10_0._mid_saferect:panel():gui(l_10_1, {})
  elseif l_10_4 then
    panel = l_10_0._saferect:panel():gui(l_10_1, {})
  else
    panel = l_10_0._workspace:panel():gui(l_10_1, {})
  end
  panel:hide()
  local bb_list = l_10_6
  if not bb_list and panel:has_script() then
    for k,v in pairs(panel:script()) do
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if k == "get_bounding_box_list" and type(v) == "function" then
        bb_list = v()
        do return end
      end
    end
  end
  if bb_list then
    if bb_list.x then
      table.insert(bb_list, {x1 = bb_list.x, y1 = bb_list.y, x2 = bb_list.x + bb_list.w, y2 = bb_list.y + bb_list.h})
    else
      for _,rect in pairs(bb_list) do
        table.insert(bounding_box, {x1 = rect.x, y1 = rect.y, x2 = rect.x + rect.w, y2 = rect.y + rect.h})
      end
    end
  else
    bounding_box = l_10_0:_create_bounding_boxes(panel)
  end
end
l_10_0._component_map[l_10_1:key()] = {}
l_10_0._component_map[l_10_1:key()].panel = panel
l_10_0._component_map[l_10_1:key()].bb_list = bounding_box
l_10_0._component_map[l_10_1:key()].mutex_list = {}
l_10_0._component_map[l_10_1:key()].overlay_list = {}
l_10_0._component_map[l_10_1:key()].idstring = l_10_1
l_10_0._component_map[l_10_1:key()].load_visible = l_10_2
l_10_0._component_map[l_10_1:key()].load_using_collision = l_10_3
l_10_0._component_map[l_10_1:key()].load_using_saferect = l_10_4
if l_10_5 then
  l_10_0._component_map[l_10_1:key()].mutex_list = l_10_5
end
if l_10_3 then
  l_10_0._component_map[l_10_1:key()].overlay_list = l_10_0:_create_overlay_list(l_10_1)
end
if l_10_2 then
  panel:show()
end
l_10_0:setup(l_10_1)
l_10_0:layout(l_10_1)
end

HUDManager.setup = function(l_11_0, l_11_1)
  local panel = l_11_0:script(l_11_1).panel
  if not panel:has_script() then
    return 
  end
  for k,v in pairs(panel:script()) do
    if k == "setup" then
      panel:script().setup(l_11_0)
  else
    end
  end
end

HUDManager.layout = function(l_12_0, l_12_1)
  local panel = l_12_0:script(l_12_1).panel
  if not panel:has_script() then
    return 
  end
  for k,v in pairs(panel:script()) do
    if k == "layout" then
      panel:script().layout(l_12_0)
  else
    end
  end
end

HUDManager.delete = function(l_13_0, l_13_1)
  l_13_0._component_map[l_13_1:key()] = nil
end

HUDManager.set_disabled = function(l_14_0)
  l_14_0._disabled = true
  for name,_ in pairs(HUDManager.HIDEABLE_HUDS) do
    if l_14_0._visible_huds_states[name] then
      local component = l_14_0._component_map[name]
      if component and alive(component.panel) then
        component.panel:hide()
      end
    end
  end
end

HUDManager.set_enabled = function(l_15_0)
  l_15_0._disabled = false
  for name,_ in pairs(HUDManager.HIDEABLE_HUDS) do
    if l_15_0._visible_huds_states[name] then
      local component = l_15_0._component_map[name]
      if component and alive(component.panel) then
        component.panel:show()
      end
    end
  end
end

HUDManager.set_freeflight_disabled = function(l_16_0)
  l_16_0._saferect:hide()
  l_16_0._workspace:hide()
  l_16_0._mid_saferect:hide()
  l_16_0._fullscreen_workspace:hide()
end

HUDManager.set_freeflight_enabled = function(l_17_0)
  l_17_0._saferect:show()
  l_17_0._workspace:show()
  l_17_0._mid_saferect:show()
  l_17_0._fullscreen_workspace:show()
end

HUDManager.disabled = function(l_18_0)
  return l_18_0._disabled
end

HUDManager.reload_player_hud = function(l_19_0)
  local name = PlayerBase.PLAYER_HUD
  local recreate = l_19_0._component_map[name:key()]
  l_19_0:reload()
  if recreate then
    l_19_0:hide(name)
    l_19_0:delete(name)
    l_19_0:load_hud(name, false, false, true, {})
    l_19_0:show(name)
    l_19_0:_player_hud_layout()
  end
end

HUDManager.reload_all = function(l_20_0)
  l_20_0:reload()
  for name,gui in pairs(clone(l_20_0._component_map)) do
    local visible = l_20_0:visible(gui.idstring)
    l_20_0:hide(gui.idstring)
    l_20_0:delete(gui.idstring)
    l_20_0:load_hud(gui.idstring, gui.load_visible, gui.load_using_collision, gui.load_using_saferect, {})
    if visible then
      l_20_0:show(gui.idstring)
    end
  end
end

HUDManager.reload = function(l_21_0)
  l_21_0:_recompile(managers.database:root_path() .. "assets\\guis\\")
end

HUDManager._recompile = function(l_22_0, l_22_1)
  local source_files = l_22_0:_source_files(l_22_1)
  local t = {platform = "win32", source_root = managers.database:root_path() .. "/assets", target_db_root = managers.database:root_path() .. "/packages/win32/assets", target_db_name = "all", source_files = source_files, verbose = false, send_idstrings = false}
  Application:data_compile(t)
  DB:reload()
  managers.database:clear_all_cached_indices()
  for _,file in ipairs(source_files) do
    PackageManager:reload(managers.database:entry_type(file):id(), managers.database:entry_path(file):id())
  end
end

HUDManager._source_files = function(l_23_0, l_23_1)
  local files = {}
  local entry_path = managers.database:entry_path(l_23_1) .. "/"
  for _,file in ipairs(SystemFS:list(l_23_1)) do
    table.insert(files, entry_path .. file)
  end
  for _,sub_dir in ipairs(SystemFS:list(l_23_1, true)) do
    for _,file in ipairs(SystemFS:list(l_23_1 .. "/" .. sub_dir)) do
      table.insert(files, entry_path .. sub_dir .. "/" .. file)
    end
  end
  return files
end

HUDManager.panel = function(l_24_0, l_24_1)
  if not l_24_0._component_map[l_24_1:key()] then
    Application:error("ERROR! Component " .. tostring(l_24_1) .. " isn't loaded!")
  else
    return l_24_0._component_map[l_24_1:key()].panel
  end
end

HUDManager.alive = function(l_25_0, l_25_1)
  local component = l_25_0._component_map[l_25_1:key()]
  if component then
    return alive(component.panel)
  end
end

HUDManager.script = function(l_26_0, l_26_1)
  local component = l_26_0._component_map[l_26_1:key()]
  if component and alive(component.panel) then
    return l_26_0._component_map[l_26_1:key()].panel:script()
  else
     -- Warning: missing end command somewhere! Added here
  end
end

HUDManager.exists = function(l_27_0, l_27_1)
  return not not l_27_0._component_map[l_27_1:key()]
end

HUDManager.show = function(l_28_0, l_28_1)
  if l_28_1 == PlayerBase.PLAYER_INFO_HUD then
    l_28_1 = PlayerBase.PLAYER_INFO_HUD_PD2
  end
  if l_28_1 == PlayerBase.PLAYER_INFO_HUD_FULLSCREEN then
    l_28_1 = PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2
  end
  if HUDManager.disabled[l_28_1:key()] then
    return 
  end
  l_28_0._visible_huds_states[l_28_1:key()] = true
  if l_28_0._disabled and HUDManager.HIDEABLE_HUDS[l_28_1:key()] then
    return 
  end
  if l_28_0._component_map[l_28_1:key()] then
    local panel = l_28_0:script(l_28_1).panel
    if panel:has_script() then
      for k,v in pairs(panel:script()) do
        if k == "show" then
          panel:script().show(l_28_0)
      else
        end
      end
      for _,mutex_name in pairs(l_28_0._component_map[l_28_1:key()].mutex_list) do
        if l_28_0._component_map[mutex_name:key()].panel:visible() then
          l_28_0._component_map[mutex_name:key()].panel:hide()
        end
      end
      if l_28_0:_validate_components(l_28_1) then
        l_28_0._component_map[l_28_1:key()].panel:show()
      else
        Application:error("ERROR! Component " .. tostring(l_28_1) .. " isn't loaded!")
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDManager.hide = function(l_29_0, l_29_1)
  if l_29_1 == PlayerBase.PLAYER_INFO_HUD then
    l_29_1 = PlayerBase.PLAYER_INFO_HUD_PD2
  end
  if l_29_1 == PlayerBase.PLAYER_INFO_HUD_FULLSCREEN then
    l_29_1 = PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2
  end
  l_29_0._visible_huds_states[l_29_1:key()] = nil
  local panel = l_29_0:script(l_29_1).panel
  if panel:has_script() then
    for k,v in pairs(panel:script()) do
      if k == "hide" then
        panel:script().hide(l_29_0)
    else
      end
    end
    local component = l_29_0._component_map[l_29_1:key()]
    if component and alive(component.panel) then
      component.panel:hide()
    elseif not component then
      Application:error("ERROR! Component " .. tostring(l_29_1) .. " isn't loaded!")
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDManager.visible = function(l_30_0, l_30_1)
  if l_30_0._component_map[l_30_1:key()] then
    return l_30_0._component_map[l_30_1:key()].panel:visible()
  else
    Application:error("ERROR! Component " .. tostring(l_30_1) .. " isn't loaded!")
  end
end

HUDManager._collision = function(l_31_0, l_31_1, l_31_2)
  if l_31_2.x2 <= l_31_1.x1 then
    return false
  end
  if l_31_1.x2 <= l_31_2.x1 then
    return false
  end
  if l_31_2.y2 <= l_31_1.y1 then
    return false
  end
  if l_31_1.y2 <= l_31_2.y1 then
    return false
  end
  return true
end

HUDManager._inside = function(l_32_0, l_32_1, l_32_2)
  if l_32_1.x1 < l_32_2.x1 or l_32_2.x2 < l_32_1.x1 then
    return false
  end
  if l_32_1.y1 < l_32_2.y1 or l_32_2.y2 < l_32_1.y1 then
    return false
  end
  if l_32_1.x2 < l_32_2.x1 or l_32_2.x2 < l_32_1.x2 then
    return false
  end
  if l_32_1.y2 < l_32_2.x1 or l_32_2.y2 < l_32_1.y2 then
    return false
  end
  return true
end

HUDManager._collision_rects = function(l_33_0, l_33_1, l_33_2)
  for _,rc1_map in pairs(l_33_1) do
    for _,rc2_map in pairs(l_33_2) do
      if l_33_0:_collision(rc1_map, rc2_map) then
        return true
      end
    end
  end
  return false
end

HUDManager._is_mutex = function(l_34_0, l_34_1, l_34_2)
  for _,mutex_name in pairs(l_34_1.mutex_list) do
    if mutex_name:key() == l_34_2 then
      return true
    end
  end
  return false
end

HUDManager._create_bounding_boxes = function(l_35_0, l_35_1)
  local bounding_box_list = {}
  local childrens = l_35_1:children()
  do
    local rect_map = {}
    for _,object in pairs(childrens) do
      rect_map = {x1 = object:x(), y1 = object:y(), x2 = object:x() + object:w(), y2 = object:y() + object:h()}
      if #bounding_box_list == 0 then
        table.insert(bounding_box_list, rect_map)
        for (for control),_ in (for generator) do
        end
        for _,bb_rect_map in pairs(bounding_box_list) do
          if l_35_0:_inside(rect_map, bb_rect_map) == false then
            table.insert(bounding_box_list, rect_map)
            for (for control),_ in (for generator) do
            end
          end
        end
        return bounding_box_list
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDManager._create_overlay_list = function(l_36_0, l_36_1)
  local component = l_36_0._component_map[l_36_1:key()]
  local overlay_list = {}
  for cmp_name,cmp_map in pairs(l_36_0._component_map) do
    if l_36_1:key() ~= cmp_name and not l_36_0:_is_mutex(cmp_map, l_36_1:key()) and l_36_0:_collision_rects(component.bb_list, cmp_map.bb_list) then
      table.insert(overlay_list, cmp_map.idstring)
      if not l_36_0:_is_mutex(component, cmp_name) then
        table.insert(l_36_0._component_map[cmp_name].overlay_list, l_36_1)
      end
      if Application:production_build() then
        Application:error("WARNING! Component " .. tostring(l_36_1) .. " collides with " .. tostring(cmp_map.idstring))
      end
    end
  end
  return overlay_list
end

HUDManager._validate_components = function(l_37_0, l_37_1)
  for _,overlay_name in pairs(l_37_0._component_map[l_37_1:key()].overlay_list) do
    if l_37_0._component_map[overlay_name:key()] and l_37_0._component_map[overlay_name:key()].panel:visible() then
      Application:error("WARNING! Component " .. tostring(l_37_1) .. " collides with " .. tostring(overlay_name))
      return false
    end
  end
  return true
end

HUDManager.resolution_changed = function(l_38_0)
  local res = RenderSettings.resolution
  local safe_rect_pixels = managers.viewport:get_safe_rect_pixels()
  local safe_rect = managers.viewport:get_safe_rect()
  managers.gui_data:layout_corner_saferect_workspace(l_38_0._saferect)
  managers.gui_data:layout_fullscreen_workspace(l_38_0._workspace)
  managers.gui_data:layout_workspace(l_38_0._mid_saferect)
  managers.gui_data:layout_fullscreen_16_9_workspace(managers.gui_data, l_38_0._fullscreen_workspace)
  for name,gui in pairs(l_38_0._component_map) do
    l_38_0:layout(gui.idstring)
  end
end

HUDManager.update = function(l_39_0, l_39_1, l_39_2)
  for _,cb in pairs(l_39_0._updators) do
    cb(l_39_1, l_39_2)
  end
  l_39_0:_update_name_labels(l_39_1, l_39_2)
  l_39_0:_update_waypoints(l_39_1, l_39_2)
  if l_39_0._chat_state and l_39_0._chat_state.start_fade < l_39_1 then
    l_39_0._chat_state.fade = l_39_0._chat_state.fade - l_39_2
    l_39_0:_set_chat_alpha(l_39_0._chat_state.scrollus, l_39_0._chat_state.scrolllines, l_39_0._chat_state.fade)
    if l_39_0._chat_state.fade <= 0 then
      l_39_0:_set_chat_alpha(l_39_0._chat_state.scrollus, l_39_0._chat_state.scrolllines, 0)
      l_39_0._chat_state = nil
    end
  end
  if l_39_0._debug then
    local cam_pos = managers.viewport:get_current_camera_position()
    if cam_pos then
      l_39_0._debug.coord:set_text(string.format("Cam pos:   \"%.0f %.0f %.0f\" [cm]", cam_pos.x, cam_pos.y, cam_pos.z))
    end
  end
end

HUDManager.add_updator = function(l_40_0, l_40_1, l_40_2)
  l_40_0._updators[l_40_1] = l_40_2
end

HUDManager.remove_updator = function(l_41_0, l_41_1)
  l_41_0._updators[l_41_1] = nil
end

local nl_w_pos = Vector3()
local nl_pos = Vector3()
local nl_dir = Vector3()
local nl_dir_normalized = Vector3()
local nl_cam_forward = Vector3()
HUDManager._update_name_labels = function(l_42_0, l_42_1, l_42_2)
  local cam = managers.viewport:get_current_camera()
  if not cam then
    return 
  end
  local cam_pos = managers.viewport:get_current_camera_position()
  local cam_rot = managers.viewport:get_current_camera_rotation()
  mrotation.y(cam_rot, nl_cam_forward)
  do
    local panel = nil
    for _,data in ipairs(l_42_0._hud.name_labels) do
      local label_panel = data.panel
      if not panel then
        panel = label_panel:parent()
      end
      local movement = data.movement
      mvector3.set(nl_w_pos, movement:m_pos())
      mvector3.set_z(nl_w_pos, mvector3.z(movement:m_head_pos()) + 30)
      mvector3.set(nl_pos, l_42_0._workspace:world_to_screen(cam, nl_w_pos))
      mvector3.set(nl_dir, nl_w_pos)
      mvector3.subtract(nl_dir, cam_pos)
      mvector3.set(nl_dir_normalized, nl_dir)
      mvector3.normalize(nl_dir_normalized)
      local dot = mvector3.dot(nl_cam_forward, nl_dir_normalized)
      if (dot < 0 or panel:outside(mvector3.x(nl_pos), mvector3.y(nl_pos))) and label_panel:visible() then
        label_panel:set_visible(false)
        do return end
        label_panel:set_visible(true)
        if mvector3.distance_sq(cam_pos, nl_w_pos) < 250000 then
          label_panel:set_visible(true)
      else
        if dot <= 0.92500001192093 or label_panel:visible() then
          label_panel:set_center(nl_pos.x, nl_pos.y)
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDManager._init_player_hud_values = function(l_43_0)
  if not l_43_0._hud then
    l_43_0._hud = {}
  end
  l_43_0._hud.MAX_CLIP = 140
  l_43_0._hud.current_clip = l_43_0._hud.current_clip or 140
  if not l_43_0._hud.waypoints then
    l_43_0._hud.waypoints = {}
  end
  if not l_43_0._hud.stored_waypoints then
    l_43_0._hud.stored_waypoints = {}
  end
  if not l_43_0._hud.items then
    l_43_0._hud.items = {}
  end
  if not l_43_0._hud.special_equipments then
    l_43_0._hud.special_equipments = {}
  end
  if not l_43_0._hud.weapons then
    l_43_0._hud.weapons = {}
  end
  if not l_43_0._hud.pressed_d_pad then
    l_43_0._hud.pressed_d_pad = {}
  end
  if not l_43_0._hud.mugshots then
    l_43_0._hud.mugshots = {}
  end
  if not l_43_0._hud.name_labels then
    l_43_0._hud.name_labels = {}
  end
end

HUDManager._announcement_hud_layout = function(l_44_0)
end

HUDManager._player_info_hud_layout = function(l_45_0)
  if not l_45_0:alive(PlayerBase.PLAYER_INFO_HUD) then
    return 
  end
  local safe_rect_pixels = managers.viewport:get_safe_rect_pixels()
  local res = RenderSettings.resolution
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  local full_hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
  full_hud.present_background:set_w(res.x)
  hud.hint_text:set_font_size(tweak_data.hud.hint_font_size)
  hud.hint_shadow_text:set_font_size(tweak_data.hud.hint_font_size)
  local x = hud.hint_text:parent():center_x()
  local y = hud.hint_text:parent():center_y() / 2.5
  hud.hint_text:set_center(x, y)
  hud.hint_shadow_text:set_center(x + 1, y + 1)
  hud.location_text:set_font_size(tweak_data.hud.location_font_size)
  hud.location_text:set_top(0)
  hud.location_text:set_center_x(hud.location_text:parent():w() / 2)
  local x = hud.present_mid_text:parent():center_x()
  local y = hud.present_mid_text:parent():center_y() / 1.1000000238419
  hud.present_mid_text:set_font_size(tweak_data.hud.present_mid_text_font_size)
  hud.present_mid_text:set_center(x, y)
  hud.present_mid_text:set_left(50)
  hud.title_mid_text:set_font_size(tweak_data.hud.small_font_size)
  hud.title_mid_text:set_bottom(hud.present_mid_text:top())
  hud.title_mid_text:set_left(50)
  hud.present_mid_icon:set_size(48 * tweak_data.scale.present_multiplier, 48 * tweak_data.scale.present_multiplier)
  hud.present_mid_icon:set_top(hud.title_mid_text:top())
  hud.present_mid_icon:set_right(hud.present_mid_text:left() - 2)
  hud.messages_panel:set_center_x(safe_rect_pixels.width / 2)
  local hp_c = hud.health_health:h()
  local hp_t = hud.health_background:h()
  local hp_h = hud.health_health:h()
  local a_c = hud.health_armor:h()
  hud.health_panel:set_size(64 * tweak_data.scale.hud_health_multiplier, 130 * tweak_data.scale.hud_health_multiplier)
  hud.health_panel:set_left(0)
  hud.health_panel:set_bottom(hud.health_panel:parent():bottom() - (22 * tweak_data.scale.experience_bar_multiplier + 2 * tweak_data.scale.hud_health_multiplier))
  hud.health_name:set_font_size(tweak_data.hud.small_font_size)
  local _, _, w, h = hud.health_name:text_rect()
  hud.health_name:set_size(hud.health_panel:w(), h)
  hud.health_name:set_bottom(hud.health_panel:h() - 2 * tweak_data.scale.hud_health_multiplier)
  hud.control_hostages:set_font_size(tweak_data.hud.small_font_size)
  local _, _, w, h = hud.control_hostages:text_rect()
  hud.control_hostages:set_h(h)
  local image, rect = tweak_data.hud_icons:get_icon_data("assault")
  hud.assault_image:set_image(image, rect[1], rect[2], rect[3], rect[4])
  hud.assault_image:set_size(rect[3] * tweak_data.scale.hud_assault_image_multiplier, rect[4] * tweak_data.scale.hud_assault_image_multiplier)
  hud.control_panel:set_w(362)
  hud.control_panel:set_h(h + rect[4])
  hud.control_panel:set_center_x(hud.control_panel:parent():w() / 2)
  hud.control_panel:set_bottom(hud.control_panel:parent():h())
  hud.control_hostages:set_center_x(hud.control_hostages:parent():w() / 2)
  hud.control_hostages:set_bottom(hud.control_hostages:parent():h())
  hud.assault_image:set_center_x(hud.assault_image:parent():w() / 2)
  hud.assault_image:set_bottom(hud.control_hostages:top())
  hud.control_assault_title:set_text(managers.localization:text("menu_assault"))
  hud.control_assault_title:set_font_size(tweak_data.hud.assault_title_font_size)
  hud.control_assault_title:set_shape(hud.control_assault_title:text_rect())
  hud.control_assault_title:set_center_x(hud.assault_image:center_x())
  hud.control_assault_title:set_center_y(hud.assault_image:center_y() * 1.2000000476837)
  hud.control_hostages:set_text(managers.localization:text("debug_control_hostages") .. " " .. "0")
  l_45_0:_layout_point_of_no_return_panel()
  l_45_0:_layout_mugshots()
  if not is_PS3 then
    local full_hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
    local say_text = full_hud.panel:child("say_text")
    say_text:set_font_size(tweak_data.hud.chatinput_size)
    local _, _, w, h = say_text:text_rect()
    say_text:set_size(w, h)
    say_text:set_position(4, 4)
    full_hud.panel:child("chat_input"):set_size(500 * tweak_data.scale.chat_multiplier, 25 * tweak_data.scale.chat_multiplier)
    full_hud.panel:child("chat_input"):set_y(4)
    full_hud.panel:child("chat_input"):set_left(say_text:right())
    full_hud.panel:child("chat_input"):script().text:set_font_size(tweak_data.hud.chatinput_size)
    full_hud.panel:child("textscroll"):set_size(400 * tweak_data.scale.chat_multiplier, 118 * tweak_data.scale.chat_multiplier)
    full_hud.panel:child("textscroll"):script().scrollus:set_font_size(tweak_data.hud.chatoutput_size)
    full_hud.panel:child("textscroll"):set_x(4)
  end
end

HUDManager._layout_chat_output = function(l_46_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  local full_hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
  local state = full_hud:chat_output_state()
  if state == "default" then
    full_hud.panel:child("textscroll"):set_bottom(hud.health_panel:top() + l_46_0._saferect_size.y * l_46_0._workspace_size.h - 12)
  else
    full_hud.panel:child("textscroll"):set_bottom(hud.health_panel:bottom() + l_46_0._saferect_size.y * l_46_0._workspace_size.h - 4)
  end
end

HUDManager.set_chat_output_state = function(l_47_0, l_47_1)
  if is_PS3 then
    return 
  end
  if not l_47_0:alive(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN) then
    return 
  end
  local full_hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
  full_hud:set_chat_output_state(l_47_1)
end

HUDManager._layout_player_info_hud_fullscreen = function(l_48_0)
  if not l_48_0:alive(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN) then
    return 
  end
  if is_PS3 then
    return 
  end
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
  if not hud.panel:child("textscroll") then
    hud.panel:gui(Idstring("guis/chat/textscroll"), {name = "textscroll", layer = 0, h = 118, w = 400, valign = "grow", halign = "grow"})
    hud.panel:gui(Idstring("guis/chat/chat_input"), {name = "chat_input", h = 25, w = 500, layer = 5, valign = "bottom", halign = "grow", y = 125})
    hud.panel:child("chat_input"):script().enter_callback = callback(l_48_0, l_48_0, "_cb_chat")
    hud.panel:child("chat_input"):script().esc_callback = callback(l_48_0, l_48_0, "_cb_unlock")
    hud.panel:child("chat_input"):script().typing_callback = callback(l_48_0, l_48_0, "_cb_lock")
    hud.panel:child("textscroll"):script().background:set_visible(false)
    hud.panel:child("chat_input"):script().background:set_visible(false)
    hud.panel:text({name = "say_text", text = utf8.to_upper(managers.localization:text("debug_chat_say")), color = Color.white, font = tweak_data.hud.medium_font, font_size = 22, align = "center", vertical = "center", layer = 5})
    hud.panel:child("say_text"):set_visible(false)
  end
end

HUDManager._cb_chat = function(l_49_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
  local chat_text = hud.panel:child("chat_input"):child("text"):text()
  if managers.network:session() and chat_text and tostring(chat_text) ~= "" then
    local name = utf8.to_upper(managers.network:session():local_peer():name())
    local say = name .. ": " .. tostring(chat_text)
    l_49_0:_say(say, managers.network:session():local_peer():id())
    managers.network:session():send_to_peers("sync_chat_message", say)
  end
  l_49_0._chatbox_typing = false
  hud.panel:child("chat_input"):child("text"):set_text("")
  hud.panel:child("chat_input"):child("text"):set_selection(0, 0)
  setup:add_end_frame_clbk(function()
    self:set_chat_focus(false)
   end)
end

HUDManager.sync_say = function(l_50_0, ...)
  l_50_0:_say(...)
  if not l_50_0._chat_focus then
    local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
    do
      local s = hud.panel:child("textscroll"):script()
      l_50_0._chat_state = {start_fade = Application:time() + 10, fade = 1, scrollus = s.scrollus, scrolllines = s.scrolllines}
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

HUDManager._say = function(l_51_0, l_51_1, l_51_2)
  print("_say", l_51_1, l_51_2)
  l_51_0._sound_source:post_event("prompt_exit")
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
  local s = hud.panel:child("textscroll"):script()
  local i = utf8.find_char(l_51_1, ":")
  s.box_print(l_51_1, tweak_data.chat_colors[l_51_2], i)
  s.scrollus:set_color(Color.white)
end

HUDManager._cb_unlock = function(l_52_0)
  setup:add_end_frame_clbk(function()
    self:set_chat_focus(false)
   end)
end

HUDManager._cb_lock = function(l_53_0)
end

HUDManager.toggle_chatinput = function(l_54_0)
  l_54_0:set_chat_focus(true)
end

HUDManager._set_chat_alpha = function(l_55_0, l_55_1, l_55_2, l_55_3)
  l_55_1:set_color(Color.white:with_alpha(l_55_3))
  for _,line in ipairs(l_55_2) do
    l_55_1:set_range_color(line.si, line.si + line.i, line.c:with_alpha(l_55_3))
  end
end

HUDManager.set_chat_focus = function(l_56_0, l_56_1)
  if not l_56_0:alive(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2) then
    return 
  end
  if l_56_0._chat_focus == l_56_1 then
    return 
  end
  l_56_0._chat_focus = l_56_1
  l_56_0._chatinput_changed_callback_handler:dispatch(l_56_0._chat_focus)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
  hud.panel:child("chat_input"):script().set_focus(l_56_0._chat_focus, true)
  hud.panel:child("chat_input"):script().background:set_visible(l_56_0._chat_focus)
  hud.panel:child("say_text"):set_visible(l_56_0._chat_focus)
  l_56_0._chat_state = nil
  local s = hud.panel:child("textscroll"):script()
  l_56_0:_set_chat_alpha(s.scrollus, s.scrolllines, 1)
  if l_56_0._chat_focus then
    l_56_0._workspace:connect_keyboard(Input:keyboard())
  else
    l_56_0._chat_state = {start_fade = Application:time() + 10, fade = 1, scrollus = s.scrollus, scrolllines = s.scrolllines}
    l_56_0._workspace:disconnect_keyboard()
  end
end

HUDManager._player_hud_layout = function(l_57_0)
  if not l_57_0:alive(PlayerBase.PLAYER_HUD) then
    return 
  end
  l_57_0:_layout_player_info_hud_fullscreen()
  local safe_rect_pixels = managers.viewport:get_safe_rect_pixels()
  l_57_0:_init_player_hud_values()
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  hud.crosshair_panel:set_center(hud.crosshair_panel:parent():center())
  hud.interact_bitmap:set_center_y(hud.interact_bitmap:parent():center_y() / 1.6499999761581)
  hud.interact_bitmap:set_right(48 + safe_rect_pixels.width / 2 - 360 / (2 / math.max(1, tweak_data.scale.w_interact_multiplier)))
  hud.interact_background:set_h(22 * tweak_data.scale.small_font_multiplier)
  if not tweak_data.scale.w_interact_multiplier then
    hud.interact_background:set_w(360 * tweak_data.scale.small_font_multiplier)
  end
  hud.interact_background:set_left(hud.interact_bitmap:right() + 2)
  hud.interact_background:set_center_y(hud.interact_bitmap:center_y())
  hud.interact_bar:set_h(hud.interact_background:h() - 2)
  hud.interact_bar:set_w(hud.interact_background:w() - 2)
  hud.interact_bar:set_center(hud.interact_background:center())
  hud.interact_bar_stop:set_size(8 * tweak_data.scale.small_font_multiplier, 22 * tweak_data.scale.small_font_multiplier)
  hud.interact_bar_stop:set_right(hud.interact_bar:right() + 1)
  hud.interact_bar_stop:set_center_y(hud.interact_bar:center_y())
  hud.interact_text:set_font_size(tweak_data.hud.small_font_size)
  hud.interact_text:set_w(hud.interact_background:w() - 8)
  hud.interact_text:set_left(hud.interact_background:left() + 4)
  hud.interact_text:set_top(hud.interact_background:top() + 2)
  hud.ammo_warning_text:set_font_size(tweak_data.hud.default_font_size)
  hud.ammo_warning_shadow_text:set_font_size(tweak_data.hud.default_font_size)
  local x = hud.ammo_warning_text:parent():center_x()
  local y = hud.ammo_warning_text:parent():center_y() + hud.ammo_warning_text:parent():center_y() / 4
  hud.ammo_warning_text:set_center(x, y)
  hud.ammo_warning_shadow_text:set_center(x + 1, y + 1)
  local x = safe_rect_pixels.width / 3
  local y = hud.present_text:parent():bottom() - 22
  hud.present_text:set_right(x)
  hud.present_text:set_bottom(y)
  hud.objective_title:set_left(hud.objective_title:parent():left())
  hud.objective_text:set_lefttop(hud.objective_title:leftbottom())
  hud.d_pad_panel:set_visible(SystemInfo:platform() == Idstring("PS3"))
  hud.d_pad_panel:set_size(64 * tweak_data.scale.hud_equipment_icon_multiplier, 64 * tweak_data.scale.hud_equipment_icon_multiplier)
  hud.d_pad_panel:set_right(hud.d_pad_panel:parent():right())
  hud.d_pad_panel:set_bottom(hud.d_pad_panel:parent():bottom() - 32 * tweak_data.scale.hud_equipment_icon_multiplier)
  hud.weapon_panel:set_right(hud.d_pad_panel:left())
  hud.weapon_panel:set_center_y(hud.d_pad_panel:center_y())
  l_57_0:_layout_items()
  hud.item_panel:set_bottom(hud.d_pad_panel:top())
  hud.item_panel:set_center_x(hud.d_pad_panel:center_x())
  hud.selected_item_icon:set_font_size(tweak_data.hud.default_font_size)
  l_57_0:_selected_item_icon_text()
  l_57_0:_layout_special_equipment()
  l_57_0:_layout_special_equipments()
  hud.ammo_panel:set_size(512 * tweak_data.scale.hud_equipment_icon_multiplier, 128 * tweak_data.scale.hud_equipment_icon_multiplier)
  hud.ammo_panel:set_right(hud.d_pad_panel:left())
  hud.ammo_panel:set_bottom(hud.ammo_panel:parent():bottom())
  hud.weapon_name:set_font_size(tweak_data.hud.default_font_size)
  hud.weapon_name:set_w(hud.ammo_panel:w() - 24)
  hud.weapon_name:set_y(0)
  l_57_0:_arrange_weapons()
  hud.danger_zone1:set_top(hud.panel:h() / 2)
  hud.danger_zone1:set_right(hud.crosshair_panel:left())
  hud.danger_zone2:set_top(hud.panel:h() / 2)
  hud.danger_zone2:set_left(hud.crosshair_panel:right())
  hud.ammo_amount:set_size(48 * tweak_data.scale.hud_default_font_multiplier, 32 * tweak_data.scale.hud_default_font_multiplier)
  hud.ammo_amount:set_font_size(tweak_data.hud.ammo_font_size)
  hud.ammo_amount:set_rightbottom(hud.ammo_amount:parent():size())
  hud.ammo_current:set_rightbottom(hud.ammo_amount:leftbottom())
  local player = managers.player:player_unit()
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local x, y = hud.ammo_amount:righttop()
l_57_0:set_crosshair_offset(tweak_data.weapon.crosshair.DEFAULT_OFFSET)
l_57_0._ch_current_offset = l_57_0._ch_offset
l_57_0:_layout_crosshair()
l_57_0:_layout_d_pad()
l_57_0:_layout_secret_assignment_panel()
for id,data in pairs(l_57_0._hud.stored_waypoints) do
  l_57_0:add_waypoint(id, data)
end
end

HUDManager.add_waypoint = function(l_58_0, l_58_1, l_58_2)
  if l_58_0._hud.waypoints[l_58_1] then
    l_58_0:remove_waypoint(l_58_1)
  end
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
  if not hud then
    l_58_0._hud.stored_waypoints[l_58_1] = l_58_2
    return 
  end
  local waypoint_panel = hud.panel
  local icon = l_58_2.icon or "wp_standard"
  local text = ""
  local icon, texture_rect = tweak_data.hud_icons:get_icon_data(icon, {0, 0, 32, 32})
  local bitmap = waypoint_panel:bitmap({name = "bitmap" .. l_58_1, texture = icon, texture_rect = texture_rect, layer = 0, w = texture_rect[3], h = texture_rect[4], blend_mode = l_58_2.blend_mode})
  local arrow_icon, arrow_texture_rect = tweak_data.hud_icons:get_icon_data("wp_arrow")
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local arrow = (waypoint_panel:bitmap({name = "arrow" .. l_58_1, texture = arrow_icon}))
local distance = nil
{name = "arrow" .. l_58_1, texture = arrow_icon}.blend_mode, {name = "arrow" .. l_58_1, texture = arrow_icon}.h, {name = "arrow" .. l_58_1, texture = arrow_icon}.w, {name = "arrow" .. l_58_1, texture = arrow_icon}.layer, {name = "arrow" .. l_58_1, texture = arrow_icon}.visible, {name = "arrow" .. l_58_1, texture = arrow_icon}.color, {name = "arrow" .. l_58_1, texture = arrow_icon}.texture_rect = l_58_2.blend_mode, arrow_texture_rect[4], arrow_texture_rect[3], 0, false, Color.white:with_alpha(0.75), arrow_texture_rect
 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

if l_58_2.distance then
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
distance, {name = "distance" .. l_58_1, text = "16.5", color = Color.white, font = tweak_data.hud.medium_font_noshadow, font_size = tweak_data.hud.default_font_size, align = "center"}.blend_mode, {name = "distance" .. l_58_1, text = "16.5", color = Color.white, font = tweak_data.hud.medium_font_noshadow, font_size = tweak_data.hud.default_font_size, align = "center"}.layer, {name = "distance" .. l_58_1, text = "16.5", color = Color.white, font = tweak_data.hud.medium_font_noshadow, font_size = tweak_data.hud.default_font_size, align = "center"}.h, {name = "distance" .. l_58_1, text = "16.5", color = Color.white, font = tweak_data.hud.medium_font_noshadow, font_size = tweak_data.hud.default_font_size, align = "center"}.w, {name = "distance" .. l_58_1, text = "16.5", color = Color.white, font = tweak_data.hud.medium_font_noshadow, font_size = tweak_data.hud.default_font_size, align = "center"}.vertical = waypoint_panel:text({name = "distance" .. l_58_1, text = "16.5", color = Color.white, font = tweak_data.hud.medium_font_noshadow, font_size = tweak_data.hud.default_font_size, align = "center"}), l_58_2.blend_mode, 0, 24, 128, "center"
distance:set_visible(false)
end
 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local timer = waypoint_panel:text({name = "timer" .. l_58_1, text = (not l_58_2.timer or "") .. math.round(l_58_2.timer)})
 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

 -- DECOMPILER ERROR: Confused about usage of registers!

text, {name = "text" .. l_58_1, text = utf8.to_upper(" " .. text)}.layer, {name = "text" .. l_58_1, text = utf8.to_upper(" " .. text)}.h, {name = "text" .. l_58_1, text = utf8.to_upper(" " .. text)}.w, {name = "text" .. l_58_1, text = utf8.to_upper(" " .. text)}.vertical, {name = "text" .. l_58_1, text = utf8.to_upper(" " .. text)}.align, {name = "text" .. l_58_1, text = utf8.to_upper(" " .. text)}.font_size, {name = "text" .. l_58_1, text = utf8.to_upper(" " .. text)}.font, {name = "timer" .. l_58_1, text = (not l_58_2.timer or "") .. math.round(l_58_2.timer)}.layer, {name = "timer" .. l_58_1, text = (not l_58_2.timer or "") .. math.round(l_58_2.timer)}.h, {name = "timer" .. l_58_1, text = (not l_58_2.timer or "") .. math.round(l_58_2.timer)}.w, {name = "timer" .. l_58_1, text = (not l_58_2.timer or "") .. math.round(l_58_2.timer)}.vertical, {name = "timer" .. l_58_1, text = (not l_58_2.timer or "") .. math.round(l_58_2.timer)}.align, {name = "timer" .. l_58_1, text = (not l_58_2.timer or "") .. math.round(l_58_2.timer)}.font_size, {name = "timer" .. l_58_1, text = (not l_58_2.timer or "") .. math.round(l_58_2.timer)}.font = waypoint_panel:text({name = "text" .. l_58_1, text = utf8.to_upper(" " .. text)}), 0, 24, 512, "center", "center", tweak_data.hud.small_font_size, tweak_data.hud.small_font, 0, 32, 32, "center", "center", 32, tweak_data.hud.medium_font_noshadow
local _, _, w, _ = text:text_rect()
text:set_w(w)
local w, h = bitmap:size()
l_58_0._hud.waypoints[l_58_1] = {init_data = l_58_2, state = l_58_2.state or "present", present_timer = l_58_2.present_timer or 2, bitmap = bitmap, arrow = arrow, size = Vector3(w, h, 0), text = text, distance = distance, timer_gui = timer, timer = l_58_2.timer, pause_timer = l_58_2.pause_timer or not l_58_2.timer or 0, position = l_58_2.position, unit = l_58_2.unit, no_sync = l_58_2.no_sync, move_speed = 1, radius = l_58_2.radius or 160}
if not l_58_2.position then
l_58_0._hud.waypoints[l_58_1].init_data.position = l_58_2.unit:position()
end
local slot = 1
local t = {}
for _,data in pairs(l_58_0._hud.waypoints) do
if data.slot then
t[data.slot] = data.text:w()
end
end
for i = 1, 10 do
if not t[i] then
l_58_0._hud.waypoints[l_58_1].slot = i
else
end
end
l_58_0._hud.waypoints[l_58_1].slot_x = 0
if l_58_0._hud.waypoints[l_58_1].slot == 2 then
l_58_0._hud.waypoints[l_58_1].slot_x = t[1] / 2 + l_58_0._hud.waypoints[l_58_1].text:w() / 2 + 10
else
if l_58_0._hud.waypoints[l_58_1].slot == 3 then
l_58_0._hud.waypoints[l_58_1].slot_x = -t[1] / 2 - l_58_0._hud.waypoints[l_58_1].text:w() / 2 - 10
else
if l_58_0._hud.waypoints[l_58_1].slot == 4 then
  l_58_0._hud.waypoints[l_58_1].slot_x = t[1] / 2 + t[2] + l_58_0._hud.waypoints[l_58_1].text:w() / 2 + 20
else
  if l_58_0._hud.waypoints[l_58_1].slot == 5 then
    l_58_0._hud.waypoints[l_58_1].slot_x = -t[1] / 2 - t[3] - l_58_0._hud.waypoints[l_58_1].text:w() / 2 - 20
  end
end
end
end
end

HUDManager.change_waypoint_icon = function(l_59_0, l_59_1, l_59_2)
  if not l_59_0._hud.waypoints[l_59_1] then
    Application:error("[HUDManager:change_waypoint_icon] no waypoint with id", l_59_1)
    return 
  end
  local wp_data = l_59_0._hud.waypoints[l_59_1]
  local texture, rect = tweak_data.hud_icons:get_icon_data(l_59_2, {0, 0, 32, 32})
  wp_data.bitmap:set_image(texture, rect[1], rect[2], rect[3], rect[4])
end

HUDManager.change_waypoint_arrow_color = function(l_60_0, l_60_1, l_60_2)
  if not l_60_0._hud.waypoints[l_60_1] then
    Application:error("[HUDManager:change_waypoint_icon] no waypoint with id", l_60_1)
    return 
  end
  local wp_data = l_60_0._hud.waypoints[l_60_1]
  wp_data.arrow:set_color(l_60_2)
end

HUDManager.remove_waypoint = function(l_61_0, l_61_1)
  l_61_0._hud.stored_waypoints[l_61_1] = nil
  if not l_61_0._hud.waypoints[l_61_1] then
    Application:error("Trying to remove waypoint that hasn't been added! Id: " .. l_61_1 .. ".")
    return 
  end
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
  if not hud then
    return 
  end
  local waypoint_panel = hud.panel
  waypoint_panel:remove(l_61_0._hud.waypoints[l_61_1].bitmap)
  waypoint_panel:remove(l_61_0._hud.waypoints[l_61_1].text)
  waypoint_panel:remove(l_61_0._hud.waypoints[l_61_1].arrow)
  if l_61_0._hud.waypoints[l_61_1].timer_gui then
    waypoint_panel:remove(l_61_0._hud.waypoints[l_61_1].timer_gui)
  end
  if l_61_0._hud.waypoints[l_61_1].distance then
    waypoint_panel:remove(l_61_0._hud.waypoints[l_61_1].distance)
  end
  l_61_0._hud.waypoints[l_61_1] = nil
end

HUDManager.set_waypoint_timer_pause = function(l_62_0, l_62_1, l_62_2)
  if not l_62_0._hud.waypoints[l_62_1] then
    return 
  end
  l_62_0._hud.waypoints[l_62_1].pause_timer = l_62_0._hud.waypoints[l_62_1].pause_timer + (l_62_2 and 1 or -1)
end

HUDManager.get_waypoint_data = function(l_63_0, l_63_1)
  return l_63_0._hud.waypoints[l_63_1]
end

HUDManager.clear_waypoints = function(l_64_0)
  for id,_ in pairs(clone(l_64_0._hud.waypoints)) do
    l_64_0:remove_waypoint(id)
  end
end

HUDManager.add_item = function(l_65_0, l_65_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  local icon, texture_rect = tweak_data.hud_icons:get_icon_data(l_65_1.icon)
  local bitmap = hud.item_panel:bitmap({name = "bitmap", texture = icon, color = Color(0.40000000596046, 0.80000001192093, 0.80000001192093, 0.80000001192093), layer = 2, texture_rect = texture_rect, w = 48 * tweak_data.scale.hud_equipment_icon_multiplier, h = 48 * tweak_data.scale.hud_equipment_icon_multiplier})
  l_65_1.amount = l_65_1.amount or 0
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local amount = hud.item_panel:text({name = "text", text = tostring(l_65_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.equipment_font_size})
  table.insert(l_65_0._hud.items, {texture_rect = texture_rect, bitmap = bitmap, amount = amount})
  {name = "text", text = tostring(l_65_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.equipment_font_size}.h, {name = "text", text = tostring(l_65_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.equipment_font_size}.w, {name = "text", text = tostring(l_65_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.equipment_font_size}.layer, {name = "text", text = tostring(l_65_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.equipment_font_size}.vertical, {name = "text", text = tostring(l_65_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.equipment_font_size}.align, {name = "text", text = tostring(l_65_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.equipment_font_size}.color = 48 * tweak_data.scale.hud_equipment_icon_multiplier, 48 * tweak_data.scale.hud_equipment_icon_multiplier, 3, "bottom", "right", Color.white
  local sx, sy = hud.item_panel:size()
  bitmap:set_center_x(sx / 2)
  bitmap:set_bottom(l_65_0._hud.items[#l_65_0._hud.items - 1] and l_65_0._hud.items[#l_65_0._hud.items - 1].bitmap:top() or sy)
  amount:set_center(bitmap:center())
  if #l_65_0._hud.items == 1 then
    l_65_0:set_item_selected(1)
  end
  l_65_0:_layout_special_equipment()
  return #l_65_0._hud.items
end

HUDManager.remove_item = function(l_66_0, l_66_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  hud.item_panel:remove(l_66_0._hud.items[l_66_1].bitmap)
  hud.item_panel:remove(l_66_0._hud.items[l_66_1].amount)
  l_66_0._hud.items[l_66_1] = nil
  l_66_0:_layout_special_equipment()
end

HUDManager.clear_items = function(l_67_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  if not hud then
    return 
  end
  for _,data in ipairs(l_67_0._hud.items) do
    hud.item_panel:remove(data.bitmap)
    hud.item_panel:remove(data.amount)
  end
  hud.selected_item_icon:set_visible(false)
  l_67_0._hud.items = {}
  l_67_0:_layout_special_equipment()
end

HUDManager.set_next_item_selected = function(l_68_0)
  if not l_68_0._hud.selected_item or #l_68_0._hud.items == 0 then
    return 
  end
  l_68_0:set_item_selected(l_68_0._hud.selected_item + 1 <= #l_68_0._hud.items and l_68_0._hud.selected_item + 1 or 1)
end

HUDManager.set_previous_item_selected = function(l_69_0)
  if not l_69_0._hud.selected_item or #l_69_0._hud.items == 0 then
    return 
  end
  if l_69_0._hud.selected_item - 1 < 1 or not l_69_0._hud.selected_item - 1 then
    l_69_0:set_item_selected(#l_69_0._hud.items)
  end
end

HUDManager.set_item_selected = function(l_70_0, l_70_1)
  if not l_70_1 then
    l_70_0._hud.selected_item = l_70_0._hud.selected_item
  end
  for i,data in ipairs(l_70_0._hud.items) do
    data.bitmap:set_color(data.bitmap:color():with_alpha(l_70_0._hud.selected_item == i and 1 or 0.40000000596046))
  end
  if not l_70_0._hud.selected_item or not l_70_0._hud.items[l_70_0._hud.selected_item] then
    return 
  end
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  local align = l_70_0._hud.items[l_70_0._hud.selected_item].bitmap
  hud.selected_item_icon:set_visible(true)
  hud.selected_item_icon:set_center_y(align:center_y() + align:parent():y())
  hud.selected_item_icon:set_right(align:left() + 0 + align:parent():x())
end

HUDManager.set_item_amount = function(l_71_0, l_71_1, l_71_2)
  if l_71_2 ~= -1 or not "--" then
    l_71_0._hud.items[l_71_1].amount:set_text(tostring(l_71_2))
  end
end

HUDManager._layout_items = function(l_72_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  for i,data in ipairs(l_72_0._hud.items) do
    local sx, sy = hud.item_panel:size()
    data.bitmap:set_size(data.texture_rect[3] * tweak_data.scale.hud_equipment_icon_multiplier, data.texture_rect[4] * tweak_data.scale.hud_equipment_icon_multiplier)
    data.bitmap:set_center_x(sx / 2)
    data.bitmap:set_bottom(l_72_0._hud.items[#l_72_0._hud.items - 1] and l_72_0._hud.items[#l_72_0._hud.items - 1].bitmap:top() or sy)
    if data.amount then
      data.amount:set_font_size(tweak_data.hud.equipment_font_size)
      data.amount:set_size(data.texture_rect[3] * tweak_data.scale.hud_equipment_icon_multiplier, data.texture_rect[4] * tweak_data.scale.hud_equipment_icon_multiplier)
      data.amount:set_center(data.bitmap:center())
    end
  end
  if l_72_0._hud.selected_item then
    l_72_0:set_item_selected(l_72_0._hud.selected_item)
  end
end

HUDManager.add_special_equipment = function(l_73_0, l_73_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  local icon, texture_rect = tweak_data.hud_icons:get_icon_data(l_73_1.icon)
  local bitmap = (hud.special_equipment_panel:bitmap({name = "bitmap", texture = icon, color = Color.white, layer = 2, texture_rect = texture_rect, w = texture_rect[3] * tweak_data.scale.hud_equipment_icon_multiplier, h = texture_rect[4] * tweak_data.scale.hud_equipment_icon_multiplier}))
  local amount = nil
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  if l_73_1.amount then
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  amount, {name = "text", text = tostring(l_73_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.equipment_font_size}.h, {name = "text", text = tostring(l_73_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.equipment_font_size}.w, {name = "text", text = tostring(l_73_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.equipment_font_size}.layer, {name = "text", text = tostring(l_73_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.equipment_font_size}.vertical, {name = "text", text = tostring(l_73_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.equipment_font_size}.align, {name = "text", text = tostring(l_73_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.equipment_font_size}.color = hud.special_equipment_panel:text({name = "text", text = tostring(l_73_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.equipment_font_size}), 48 * tweak_data.scale.hud_equipment_icon_multiplier, 48 * tweak_data.scale.hud_equipment_icon_multiplier, 4, "bottom", "right", Color.white
end
local last_id = l_73_0._hud.special_equipments[#l_73_0._hud.special_equipments] and l_73_0._hud.special_equipments[#l_73_0._hud.special_equipments].id or 0
local id = last_id + 1
local flash_icon = hud.special_equipment_panel:bitmap({name = "bitmap", texture = icon, color = tweak_data.hud.prime_color, layer = 3, texture_rect = texture_rect, w = texture_rect[3] * tweak_data.scale.hud_equipment_icon_multiplier, h = texture_rect[4] * tweak_data.scale.hud_equipment_icon_multiplier})
table.insert(l_73_0._hud.special_equipments, {texture_rect = texture_rect, bitmap = bitmap, amount = amount, id = id, flash_icon = flash_icon})
local sx, sy = hud.special_equipment_panel:size()
bitmap:set_center_x(sx / 2)
bitmap:set_bottom(l_73_0._hud.special_equipments[#l_73_0._hud.special_equipments - 1] and l_73_0._hud.special_equipments[#l_73_0._hud.special_equipments - 1].bitmap:top() or sy)
if amount then
  amount:set_center(bitmap:center())
end
flash_icon:set_center(bitmap:center())
flash_icon:animate(hud.flash_icon, nil, hud.special_equipment_panel)
return id
end

HUDManager.remove_special_equipment = function(l_74_0, l_74_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  for i,data in ipairs(l_74_0._hud.special_equipments) do
    if data.id == l_74_1 then
      local data = table.remove(l_74_0._hud.special_equipments, i)
      hud.special_equipment_panel:remove(data.bitmap)
      if alive(data.flash_icon) then
        hud.special_equipment_panel:remove(data.flash_icon)
      end
      if data.amount then
        hud.special_equipment_panel:remove(data.amount)
      end
      l_74_0:_layout_special_equipments()
      return 
    end
  end
end

HUDManager._layout_special_equipments = function(l_75_0)
  print("HUDManager:_layout_special_equipments()")
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  for i,data in ipairs(l_75_0._hud.special_equipments) do
    print("data.bitmap", tweak_data.scale.hud_equipment_icon_multiplier)
    local sx, sy = hud.special_equipment_panel:size()
    data.bitmap:set_size(data.texture_rect[3] * tweak_data.scale.hud_equipment_icon_multiplier, data.texture_rect[4] * tweak_data.scale.hud_equipment_icon_multiplier)
    data.bitmap:set_center_x(sx / 2)
    data.bitmap:set_bottom(l_75_0._hud.special_equipments[i - 1] and l_75_0._hud.special_equipments[i - 1].bitmap:top() or sy)
    if data.amount then
      data.amount:set_font_size(tweak_data.hud.equipment_font_size)
      data.amount:set_size(data.texture_rect[3] * tweak_data.scale.hud_equipment_icon_multiplier, data.texture_rect[4] * tweak_data.scale.hud_equipment_icon_multiplier)
      data.amount:set_center(data.bitmap:center())
    end
    if alive(data.flash_icon) then
      data.flash_icon:set_center(data.bitmap:center())
    end
    if data.amount then
      data.amount:set_center(data.bitmap:center())
    end
  end
end

HUDManager.clear_special_equipments = function(l_76_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  for _,data in ipairs(l_76_0._hud.special_equipments) do
    if data then
      hud.special_equipment_panel:remove(data.bitmap)
      if data.amount then
        hud.special_equipment_panel:remove(data.amount)
      end
    end
  end
  l_76_0._hud.special_equipments = {}
end

HUDManager.set_special_equipment_amount = function(l_77_0, l_77_1, l_77_2)
  for i,data in ipairs(l_77_0._hud.special_equipments) do
    if data.id == l_77_1 then
      if l_77_2 ~= -1 or not "--" then
        data.amount:set_text(tostring(l_77_2))
        return 
      end
    end
  end
end

HUDManager._layout_special_equipment = function(l_78_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  if not hud then
    return 
  end
  local offset = 8
  for _,data in ipairs(l_78_0._hud.items) do
    local x, y = data.bitmap:size()
    offset = offset + y
  end
  hud.special_equipment_panel:set_bottom(hud.d_pad_panel:top() - (offset))
  hud.special_equipment_panel:set_center_x(hud.d_pad_panel:center_x())
end

HUDManager._arrange_weapons = function(l_79_0)
  local hud = (managers.hud:script(PlayerBase.PLAYER_HUD))
  local last = nil
  local sx, sy = hud.weapon_panel:size()
  for i = 3, 1, -1 do
    local data = l_79_0._hud.weapons[i]
    if data then
      data.bitmap:set_size(data.texture_rect[3] * tweak_data.scale.hud_equipment_icon_multiplier, data.texture_rect[4] * tweak_data.scale.hud_equipment_icon_multiplier)
      data.bitmap:set_center_y(sy / 2)
      data.bitmap:set_right(last and last.bitmap:left() or sx)
      if data.amount then
        data.amount:set_font_size(tweak_data.hud.weapon_ammo_font_size)
        data.amount:set_size(data.bitmap:size())
        data.amount:set_center(data.bitmap:center())
      end
      if alive(data.b2) then
        local x, y = hud.weapon_panel:lefttop()
        local x_, y_ = data.bitmap:center()
        data.b2:set_center(x + x_, y + y_)
      end
      last = data
    end
  end
end

HUDManager.add_weapon = function(l_80_0, l_80_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  local icon, texture_rect = tweak_data.hud_icons:get_icon_data(l_80_1.unit:base():weapon_tweak_data().hud_icon)
  local bitmap = hud.weapon_panel:bitmap({name = "bitmap", texture = icon, color = Color(0.40000000596046, 0.80000001192093, 0.80000001192093, 0.80000001192093), layer = 2, texture_rect = texture_rect, w = 48 * tweak_data.scale.hud_equipment_icon_multiplier, h = 48 * tweak_data.scale.hud_equipment_icon_multiplier})
  l_80_1.amount = l_80_1.amount or 0
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local amount = hud.weapon_panel:text({name = "text", text = tostring(l_80_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.weapon_ammo_font_size})
  l_80_0._hud.weapons[l_80_1.inventory_index], {name = "text", text = tostring(l_80_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.weapon_ammo_font_size}.h, {name = "text", text = tostring(l_80_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.weapon_ammo_font_size}.w, {name = "text", text = tostring(l_80_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.weapon_ammo_font_size}.layer, {name = "text", text = tostring(l_80_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.weapon_ammo_font_size}.vertical, {name = "text", text = tostring(l_80_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.weapon_ammo_font_size}.align, {name = "text", text = tostring(l_80_1.amount), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.weapon_ammo_font_size}.color = {texture_rect = texture_rect, bitmap = bitmap, amount = amount, inventory_index = l_80_1.inventory_index, unit = l_80_1.unit}, 48 * tweak_data.scale.hud_equipment_icon_multiplier, 48 * tweak_data.scale.hud_equipment_icon_multiplier, 3, "bottom", "right", Color(1, 1, 1, 1)
  if l_80_1.is_equip then
    l_80_0:set_weapon_selected_by_inventory_index(l_80_1.inventory_index)
  else
    local b2 = hud.panel:bitmap({name = "bitmap", texture = icon, color = Color(0.40000000596046, 1, 1, 0.89999997615814), layer = 3, texture_rect = texture_rect, w = 48 * tweak_data.scale.hud_equipment_icon_multiplier, h = 48 * tweak_data.scale.hud_equipment_icon_multiplier})
    local x, y = hud.weapon_panel:lefttop()
    local x1, y2 = bitmap:center()
    b2:set_center(x + x1, y + y2)
    b2:animate(hud.flash_icon)
    l_80_0._hud.weapons[l_80_1.inventory_index].b2 = b2
  end
  l_80_0:_arrange_weapons()
end

HUDManager.set_weapon_selected_by_inventory_index = function(l_81_0, l_81_1)
  for i,data in pairs(l_81_0._hud.weapons) do
    if data.inventory_index == l_81_1 then
      l_81_0:_set_weapon_selected(i)
      return 
    end
  end
end

HUDManager._set_weapon_selected = function(l_82_0, l_82_1)
  l_82_0._hud.selected_weapon = l_82_1
  for i,data in pairs(l_82_0._hud.weapons) do
    data.bitmap:set_color(data.bitmap:color():with_alpha(l_82_1 == i and 1 or 0.40000000596046))
    data.amount:set_visible(l_82_1 ~= i)
    l_82_0:set_weapon_ammo_by_unit(data.unit)
    if l_82_1 == i then
      l_82_0:_set_hud_ammo(data.unit)
    end
  end
end

HUDManager._set_hud_ammo = function(l_83_0, l_83_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  if not hud then
    return 
  end
  local hud_ammo = l_83_1:base():weapon_tweak_data().hud_ammo or "guis/textures/ammo"
  hud.ammo_current:set_image(hud_ammo)
  hud.ammo_used:set_image(hud_ammo)
end

HUDManager.set_weapon_ammo_by_unit = function(l_84_0, l_84_1)
  for i,data in pairs(l_84_0._hud.weapons) do
    if data.unit == l_84_1 then
      local _, _, amount = l_84_1:base():ammo_info()
      data.amount:set_text(tostring(amount))
    end
  end
end

HUDManager.clear_weapons = function(l_85_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  for _,data in pairs(l_85_0._hud.weapons) do
    if alive(data.bitmap) and alive(data.amount) then
      hud.weapon_panel:remove(data.bitmap)
      hud.weapon_panel:remove(data.amount)
    end
  end
  l_85_0._hud.weapons = {}
end

HUDManager.add_mugshot_by_unit = function(l_86_0, l_86_1)
  if l_86_1:base().is_local_player then
    return 
  end
  local character_name = l_86_1:base():nick_name()
  local name_label_id = managers.hud:_add_name_label({name = character_name, unit = l_86_1})
  l_86_1:unit_data().name_label_id = name_label_id
  local is_husk_player = l_86_1:base().is_husk_player
  if l_86_1:movement().get_location_id then
    local location_id = l_86_1:movement():get_location_id()
  end
  local location_text = utf8.to_upper(location_id and managers.localization:text(location_id) or "")
  local character_name_id = managers.criminals:character_name_by_unit(l_86_1)
  for i,data in ipairs(l_86_0._hud.mugshots) do
    if data.character_name_id == character_name_id then
      if is_husk_player and not data.peer_id then
        l_86_0:_remove_mugshot(data.id)
        do return end
        for (for control),i in (for generator) do
        end
        l_86_1:unit_data().mugshot_id = data.id
        managers.hud:set_mugshot_normal(l_86_1:unit_data().mugshot_id)
        managers.hud:set_mugshot_armor(l_86_1:unit_data().mugshot_id, 1)
        managers.hud:set_mugshot_health(l_86_1:unit_data().mugshot_id, 1)
        managers.hud:set_mugshot_location(l_86_1:unit_data().mugshot_id, location_id)
        return 
      end
    end
    local peer_id = nil
    if is_husk_player then
      peer_id = l_86_1:network():peer():id()
    end
    local mask_name = managers.criminals:character_data_by_name(character_name_id).mask_icon
    local mask_icon, mask_texture_rect = tweak_data.hud_icons:get_icon_data(mask_name)
     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  local use_lifebar = true
  local mugshot_id = managers.hud:add_mugshot({name = utf8.to_upper(character_name), use_lifebar = use_lifebar, mask_icon = mask_icon, mask_texture_rect = mask_texture_rect, peer_id = peer_id, character_name_id = character_name_id, location_text = location_text})
  l_86_1:unit_data().mugshot_id = mugshot_id
  return mugshot_id
end

HUDManager.add_mugshot_without_unit = function(l_87_0, l_87_1, l_87_2, l_87_3, l_87_4)
  local character_name = l_87_4
  local character_name_id = l_87_1
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local mask_name = managers.criminals:character_data_by_name(character_name_id).mask_icon
local mask_icon, mask_texture_rect = tweak_data.hud_icons:get_icon_data(mask_name)
local use_lifebar = not l_87_2
local mugshot_id = managers.hud:add_mugshot({name = utf8.to_upper(character_name), use_lifebar = use_lifebar, mask_icon = mask_icon, mask_texture_rect = mask_texture_rect, peer_id = l_87_3, character_name_id = character_name_id, location_text = ""})
return mugshot_id
end

HUDManager.add_mugshot = function(l_88_0, l_88_1)
  local panel_id = l_88_0:add_teammate_panel(l_88_1.character_name_id, l_88_1.name, not l_88_1.use_lifebar, l_88_1.peer_id)
  managers.criminals:character_data_by_name(l_88_1.character_name_id).panel_id = panel_id
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  local icon = l_88_1.icon or "guis/textures/mugshot1"
  local name = l_88_1.name or "SIMON ANDERSSON"
  local icon_size = 34
  local pad = 4
  local panel = hud.panel:panel({name = "panel", w = 176 * tweak_data.scale.hud_mugshot_multiplier, h = (icon_size + pad * 2) * tweak_data.scale.hud_mugshot_multiplier})
  local gradient = panel:gradient({x = 0, y = 0, w = 176 * tweak_data.scale.hud_mugshot_multiplier, h = (icon_size + pad * 2) * tweak_data.scale.hud_mugshot_multiplier, layer = 0, gradient_points = {}})
   -- DECOMPILER ERROR: Overwrote pending register.

  local mask = panel:bitmap({name = "mask", texture = 0, layer = 1, texture_rect = l_88_1.mask_texture_rect, w = icon_size, h = icon_size})
   -- DECOMPILER ERROR: Overwrote pending register.

  local state_icon = panel:bitmap({name = "state", visible = false, texture = Color(0.40000000596046, 0, 0, 0), layer = 2, texture_rect = l_88_1.mask_texture_rect, w = icon_size, h = icon_size})
  local talk_icon, talk_texture_rect = tweak_data.hud_icons:get_icon_data("mugshot_talk")
   -- DECOMPILER ERROR: Overwrote pending register.

  local talk = panel:bitmap({name = "talk", texture = talk_icon, visible = false, layer = 4, texture_rect = talk_texture_rect, w = talk_texture_rect[3], h = talk_texture_rect[4]})
  local voice_icon, voice_texture_rect = tweak_data.hud_icons:get_icon_data("mugshot_talk")
  local voice = panel:bitmap({name = "voice", texture = voice_icon, visible = false, layer = 4, texture_rect = voice_texture_rect, w = voice_texture_rect[3], h = voice_texture_rect[4], color = Color.white})
  local font_size = 14 * tweak_data.scale.hud_mugshot_multiplier
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local name = panel:text({name = "text", text = name, font = tweak_data.hud.small_font, font_size = font_size})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local state_text = panel:text({name = "text", visible = false, text = "", font = tweak_data.hud.small_font, font_size = font_size, color = tweak_data.hud.prime_color})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local timer_text = panel:text({name = "timer_text", visible = false, text = "" .. math.random(60), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size, color = Color.white})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local location_text = panel:text({name = "text", visible = true, text = l_88_1.location_text, font = tweak_data.hud.small_font, font_size = font_size, color = Color.white})
  local equipment = {}
  {name = "text", visible = true, text = l_88_1.location_text, font = tweak_data.hud.small_font, font_size = font_size, color = Color.white}.h, {name = "text", visible = true, text = l_88_1.location_text, font = tweak_data.hud.small_font, font_size = font_size, color = Color.white}.w, {name = "text", visible = true, text = l_88_1.location_text, font = tweak_data.hud.small_font, font_size = font_size, color = Color.white}.layer, {name = "text", visible = true, text = l_88_1.location_text, font = tweak_data.hud.small_font, font_size = font_size, color = Color.white}.vertical, {name = "text", visible = true, text = l_88_1.location_text, font = tweak_data.hud.small_font, font_size = font_size, color = Color.white}.align, {name = "timer_text", visible = false, text = "" .. math.random(60), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size, color = Color.white}.h, {name = "timer_text", visible = false, text = "" .. math.random(60), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size, color = Color.white}.w, {name = "timer_text", visible = false, text = "" .. math.random(60), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size, color = Color.white}.layer, {name = "timer_text", visible = false, text = "" .. math.random(60), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size, color = Color.white}.vertical, {name = "timer_text", visible = false, text = "" .. math.random(60), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size, color = Color.white}.align, {name = "text", visible = false, text = "", font = tweak_data.hud.small_font, font_size = font_size, color = tweak_data.hud.prime_color}.h, {name = "text", visible = false, text = "", font = tweak_data.hud.small_font, font_size = font_size, color = tweak_data.hud.prime_color}.w, {name = "text", visible = false, text = "", font = tweak_data.hud.small_font, font_size = font_size, color = tweak_data.hud.prime_color}.layer, {name = "text", visible = false, text = "", font = tweak_data.hud.small_font, font_size = font_size, color = tweak_data.hud.prime_color}.vertical, {name = "text", visible = false, text = "", font = tweak_data.hud.small_font, font_size = font_size, color = tweak_data.hud.prime_color}.align, {name = "text", text = name, font = tweak_data.hud.small_font, font_size = font_size}.h, {name = "text", text = name, font = tweak_data.hud.small_font, font_size = font_size}.w, {name = "text", text = name, font = tweak_data.hud.small_font, font_size = font_size}.layer, {name = "text", text = name, font = tweak_data.hud.small_font, font_size = font_size}.vertical, {name = "text", text = name, font = tweak_data.hud.small_font, font_size = font_size}.align, {name = "text", text = name, font = tweak_data.hud.small_font, font_size = font_size}.color = 18, 256, 1, "top", "left", icon_size, icon_size, 3, "center", "center", 18, 256, 1, "top", "left", 18, 256, 1, "top", "left", Color(1, 1, 1, 1)
  if l_88_1.peer_id then
    if not managers.player:get_synced_equipment_possession(l_88_1.peer_id) then
      local peer_equipment = {}
    end
    for equip,_ in pairs(peer_equipment) do
      local icon, texture_rect = tweak_data.hud_icons:get_icon_data(tweak_data.equipments.specials[equip].icon)
      icon = panel:bitmap({name = equipment, texture = icon, layer = 1, texture_rect = texture_rect, w = icon_size / 2, h = icon_size / 2})
      table.insert(equipment, {equipment = equip, icon = icon})
    end
  end
  local icon, texture_rect, armor_texture_rect, health_texture_rect, health_background, health_armor, health_health = nil, nil, nil, nil, nil, nil, nil
  icon, texture_rect = tweak_data.hud_icons:get_icon_data("mugshot_health_background")
  health_background = panel:bitmap({name = "mask", visible = l_88_1.use_lifebar, texture = icon, layer = 1, texture_rect = texture_rect, w = texture_rect[3], h = icon_size})
  icon, armor_texture_rect = tweak_data.hud_icons:get_icon_data("mugshot_health_armor")
  health_armor = panel:bitmap({name = "mask", visible = l_88_1.use_lifebar, texture = icon, layer = 3, texture_rect = armor_texture_rect, w = armor_texture_rect[3], h = icon_size})
  icon, health_texture_rect = tweak_data.hud_icons:get_icon_data("mugshot_health_health")
  health_health = panel:bitmap({name = "mask", visible = l_88_1.use_lifebar, texture = icon, layer = 2, color = Color(0.5, 0.80000001192093, 0.40000000596046), texture_rect = health_texture_rect, w = health_texture_rect[3], h = icon_size})
  local last_id = l_88_0._hud.mugshots[#l_88_0._hud.mugshots] and l_88_0._hud.mugshots[#l_88_0._hud.mugshots].id or 0
  local id = last_id + 1
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  table.insert(l_88_0._hud.mugshots, {panel = panel, gradient = gradient, mask = mask, state_icon = state_icon, state_text = state_text, location_text = location_text, timer_text = timer_text, health_background = health_background, health_armor = health_armor, armor_texture_rect = armor_texture_rect, health_health = health_health, health_texture_rect = health_texture_rect})
  {panel = panel, gradient = gradient, mask = mask, state_icon = state_icon, state_text = state_text, location_text = location_text, timer_text = timer_text, health_background = health_background, health_armor = health_armor, armor_texture_rect = armor_texture_rect, health_health = health_health, health_texture_rect = health_texture_rect}.state_name, {panel = panel, gradient = gradient, mask = mask, state_icon = state_icon, state_text = state_text, location_text = location_text, timer_text = timer_text, health_background = health_background, health_armor = health_armor, armor_texture_rect = armor_texture_rect, health_health = health_health, health_texture_rect = health_texture_rect}.peer_id, {panel = panel, gradient = gradient, mask = mask, state_icon = state_icon, state_text = state_text, location_text = location_text, timer_text = timer_text, health_background = health_background, health_armor = health_armor, armor_texture_rect = armor_texture_rect, health_health = health_health, health_texture_rect = health_texture_rect}.character_name_id, {panel = panel, gradient = gradient, mask = mask, state_icon = state_icon, state_text = state_text, location_text = location_text, timer_text = timer_text, health_background = health_background, health_armor = health_armor, armor_texture_rect = armor_texture_rect, health_health = health_health, health_texture_rect = health_texture_rect}.id, {panel = panel, gradient = gradient, mask = mask, state_icon = state_icon, state_text = state_text, location_text = location_text, timer_text = timer_text, health_background = health_background, health_armor = health_armor, armor_texture_rect = armor_texture_rect, health_health = health_health, health_texture_rect = health_texture_rect}.name, {panel = panel, gradient = gradient, mask = mask, state_icon = state_icon, state_text = state_text, location_text = location_text, timer_text = timer_text, health_background = health_background, health_armor = health_armor, armor_texture_rect = armor_texture_rect, health_health = health_health, health_texture_rect = health_texture_rect}.voice, {panel = panel, gradient = gradient, mask = mask, state_icon = state_icon, state_text = state_text, location_text = location_text, timer_text = timer_text, health_background = health_background, health_armor = health_armor, armor_texture_rect = armor_texture_rect, health_health = health_health, health_texture_rect = health_texture_rect}.talk, {panel = panel, gradient = gradient, mask = mask, state_icon = state_icon, state_text = state_text, location_text = location_text, timer_text = timer_text, health_background = health_background, health_armor = health_armor, armor_texture_rect = armor_texture_rect, health_health = health_health, health_texture_rect = health_texture_rect}.equipment, {panel = panel, gradient = gradient, mask = mask, state_icon = state_icon, state_text = state_text, location_text = location_text, timer_text = timer_text, health_background = health_background, health_armor = health_armor, armor_texture_rect = armor_texture_rect, health_health = health_health, health_texture_rect = health_texture_rect}.icon_size = "mugshot_normal", l_88_1.peer_id, l_88_1.character_name_id, id, name, voice, talk, equipment, icon_size
  l_88_0:_layout_mugshots()
  return id
end

HUDManager.remove_hud_info_by_unit = function(l_89_0, l_89_1)
  if l_89_1:unit_data().name_label_id then
    l_89_0:_remove_name_label(l_89_1:unit_data().name_label_id)
  end
end

HUDManager.remove_mugshot_by_peer_id = function(l_90_0, l_90_1)
  for i,data in ipairs(l_90_0._hud.mugshots) do
    if data.peer_id == l_90_1 then
      l_90_0:_remove_mugshot(data.id)
  else
    end
  end
end

HUDManager.remove_mugshot_by_character_name = function(l_91_0, l_91_1)
  for i,data in ipairs(l_91_0._hud.mugshots) do
    if data.character_name_id == l_91_1 then
      l_91_0:_remove_mugshot(data.id)
  else
    end
  end
end

HUDManager.remove_mugshot = function(l_92_0, l_92_1)
  l_92_0:_remove_mugshot(l_92_1)
end

HUDManager._remove_mugshot = function(l_93_0, l_93_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  if not hud then
    return 
  end
  for i,data in ipairs(l_93_0._hud.mugshots) do
    if data.id == l_93_1 then
      hud.panel:remove(data.panel)
      table.remove(l_93_0._hud.mugshots, i)
      l_93_0:remove_teammate_panel_by_name_id(data.character_name_id)
  else
    end
  end
  l_93_0:_layout_mugshots()
end

HUDManager.remove_teammate_panel_by_name_id = function(l_94_0, l_94_1)
  local character_data = managers.criminals:character_data_by_name(l_94_1)
  if character_data and character_data.panel_id then
    l_94_0:remove_teammate_panel(character_data.panel_id)
  end
end

HUDManager.set_mugshot_weapon = function(l_95_0, l_95_1, l_95_2, l_95_3)
  for i,data in ipairs(l_95_0._hud.mugshots) do
    if data.id == l_95_1 then
      print("set_mugshot_weapon", l_95_1, l_95_2, l_95_3)
      l_95_0:_set_teammate_weapon_selected(managers.criminals:character_data_by_name(data.character_name_id).panel_id, l_95_3, l_95_2)
  else
    end
  end
end

HUDManager.set_mugshot_location = function(l_96_0, l_96_1, l_96_2)
  if not l_96_2 then
    return 
  end
  for i,data in ipairs(l_96_0._hud.mugshots) do
    if data.id == l_96_1 then
      local s = utf8.to_upper(managers.localization:text(l_96_2))
      data.location_text:set_text(utf8.to_upper(s))
      local _, _, w, _ = data.location_text:text_rect()
      data.location_text:set_w(w)
      l_96_0:_update_mugshot_panel_size(data)
  else
    end
  end
end

HUDManager._update_mugshot_panel_size = function(l_97_0, l_97_1)
  l_97_1.panel:set_w(64 + l_97_1.name:w() + 4 + l_97_1.state_text:w() + 4 + l_97_1.location_text:w())
end

HUDManager.set_mugshot_damage_taken = function(l_98_0, l_98_1)
  if not l_98_1 then
    return 
  end
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  for i,data in ipairs(l_98_0._hud.mugshots) do
    if data.id == l_98_1 then
      data.gradient:animate(hud.mugshot_damage_taken)
  else
    end
  end
end

HUDManager.set_mugshot_armor = function(l_99_0, l_99_1, l_99_2)
  if not l_99_1 then
    return 
  end
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  for i,data in ipairs(l_99_0._hud.mugshots) do
    if data.id == l_99_1 then
      data.armor_amount = l_99_2
      l_99_0:layout_mugshot_armor(data, l_99_2)
      l_99_0:set_teammate_armor(managers.criminals:character_data_by_name(data.character_name_id).panel_id, {current = l_99_2, total = 1, max = 1})
  else
    end
  end
end

HUDManager.layout_mugshot_armor = function(l_100_0, l_100_1, l_100_2)
  local x = l_100_1.armor_texture_rect[1]
  local y = l_100_1.armor_texture_rect[2]
  local h = l_100_1.health_background:h()
  local y_offset = l_100_1.armor_texture_rect[4] * (1 - l_100_2)
  local h_offset = h * (1 - l_100_2)
  l_100_1.health_armor:set_texture_rect(x, y + y_offset, l_100_1.armor_texture_rect[3], l_100_1.armor_texture_rect[4] - y_offset)
  l_100_1.health_armor:set_h(h - h_offset)
  l_100_1.health_armor:set_bottom(l_100_1.health_background:bottom())
end

HUDManager.set_mugshot_health = function(l_101_0, l_101_1, l_101_2)
  if not l_101_1 then
    return 
  end
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  for i,data in ipairs(l_101_0._hud.mugshots) do
    if data.id == l_101_1 then
      data.health_amount = l_101_2
      l_101_0:layout_mugshot_health(data, l_101_2)
      l_101_0:set_teammate_health(managers.criminals:character_data_by_name(data.character_name_id).panel_id, {current = l_101_2, total = 1, max = 1})
  else
    end
  end
end

HUDManager.layout_mugshot_health = function(l_102_0, l_102_1, l_102_2)
  local x = l_102_1.health_texture_rect[1]
  local y = l_102_1.health_texture_rect[2]
  local h = l_102_1.health_background:h()
  local y_offset = l_102_1.health_texture_rect[4] * (1 - l_102_2)
  local h_offset = h * (1 - l_102_2)
  l_102_1.health_health:set_texture_rect(x, y + y_offset, l_102_1.health_texture_rect[3], l_102_1.health_texture_rect[4] - y_offset)
  l_102_1.health_health:set_h(h - h_offset)
  l_102_1.health_health:set_bottom(l_102_1.health_background:bottom())
  if l_102_2 >= 0.33000001311302 or not Color(1, 0, 0) then
    local color = Color(0.5, 0.80000001192093, 0.40000000596046)
  end
  l_102_1.health_health:set_color(color)
end

HUDManager.set_mugshot_talk = function(l_103_0, l_103_1, l_103_2)
  if not l_103_1 then
    return 
  end
  for i,data in ipairs(l_103_0._hud.mugshots) do
    if data.id == l_103_1 and not data.peer_id then
      data.talk:set_visible(l_103_2)
      do return end
    end
  end
end

HUDManager.set_mugshot_voice = function(l_104_0, l_104_1, l_104_2)
  if not l_104_1 then
    return 
  end
  for i,data in ipairs(l_104_0._hud.mugshots) do
    if data.id == l_104_1 then
      data.voice:set_visible(l_104_2)
  else
    end
  end
end

HUDManager.set_mugshot_name = function(l_105_0, l_105_1, l_105_2)
  for i,data in ipairs(l_105_0._hud.mugshots) do
    if data.id == l_105_1 then
      data.name:set_text(l_105_2)
  else
    end
  end
end

HUDManager._get_mugshot_data = function(l_106_0, l_106_1)
  if not l_106_1 then
    return nil
  end
  for i,data in ipairs(l_106_0._hud.mugshots) do
    if data.id == l_106_1 then
      return data
    end
  end
  return nil
end

HUDManager.set_mugshot_normal = function(l_107_0, l_107_1)
  local data = l_107_0:_get_mugshot_data(l_107_1)
  if not data then
    return 
  end
  l_107_0:set_teammate_condition(managers.criminals:character_data_by_name(data.character_name_id).panel_id, "mugshot_normal", "")
  data.state_name = "mugshot_normal"
  data.state_text:set_text("")
  local _, _, w, _ = data.state_text:text_rect()
  data.state_text:set_w(w)
  data.state_icon:set_visible(false)
  data.location_text:set_visible(true)
  data.mask:set_color(data.mask:color():with_alpha(1))
  data.location_text:set_left(data.name:right() + 4)
  l_107_0:_update_mugshot_panel_size(data)
end

HUDManager.set_mugshot_downed = function(l_108_0, l_108_1)
  l_108_0:_set_mugshot_state(l_108_1, "mugshot_downed", managers.localization:text("debug_mugshot_downed"))
end

HUDManager.set_mugshot_custody = function(l_109_0, l_109_1)
  l_109_0:set_mugshot_talk(l_109_1, false)
  local data = l_109_0:_set_mugshot_state(l_109_1, "mugshot_in_custody", managers.localization:text("debug_mugshot_in_custody"))
  if data then
    data.location_text:set_visible(false)
    local i = managers.criminals:character_data_by_name(data.character_name_id).panel_id
    l_109_0:set_teammate_health(i, {current = 0, total = 100, no_hint = true})
    l_109_0:set_teammate_armor(i, {current = 0, total = 100, no_hint = true})
  end
end

HUDManager.set_mugshot_cuffed = function(l_110_0, l_110_1)
  l_110_0:_set_mugshot_state(l_110_1, "mugshot_cuffed", managers.localization:text("debug_mugshot_cuffed"))
end

HUDManager.set_mugshot_tased = function(l_111_0, l_111_1)
  l_111_0:_set_mugshot_state(l_111_1, "mugshot_electrified", managers.localization:text("debug_mugshot_electrified"))
end

HUDManager._set_mugshot_state = function(l_112_0, l_112_1, l_112_2, l_112_3)
  local data = l_112_0:_get_mugshot_data(l_112_1)
  if not data then
    return 
  end
  local i = managers.criminals:character_data_by_name(data.character_name_id).panel_id
  l_112_0:set_teammate_condition(i, l_112_2, l_112_3)
  data.state_name = l_112_2
  data.mask:set_color(data.mask:color():with_alpha(0.5))
  data.state_icon:set_visible(true)
  local icon, texture_rect = tweak_data.hud_icons:get_icon_data(l_112_2)
  data.state_icon:set_image(icon, texture_rect[1], texture_rect[2], texture_rect[3], texture_rect[4])
  data.state_text:set_visible(true)
  data.state_text:set_text(utf8.to_upper(l_112_3))
  local x, y, w, h = data.state_text:text_rect()
  data.state_text:set_w(w)
  data.location_text:set_left(data.state_text:right() + 4)
  l_112_0:_update_mugshot_panel_size(data)
  return data
end

HUDManager.show_mugshot_timer = function(l_113_0, l_113_1)
  local data = l_113_0:_get_mugshot_data(l_113_1)
  if not data then
    return 
  end
  data.timer_text:set_visible(true)
end

HUDManager.hide_mugshot_timer = function(l_114_0, l_114_1)
  local data = l_114_0:_get_mugshot_data(l_114_1)
  if not data then
    return 
  end
  data.timer_text:set_visible(false)
end

HUDManager.set_mugshot_timer = function(l_115_0, l_115_1, l_115_2)
  local data = l_115_0:_get_mugshot_data(l_115_1)
  if not data then
    return 
  end
  data.timer_text:set_text(tostring(math.floor(l_115_2)))
end

HUDManager.add_mugshot_equipment = function(l_116_0, l_116_1, l_116_2)
  if not l_116_1 then
    return 
  end
  for i,data in ipairs(l_116_0._hud.mugshots) do
    if data.id == l_116_1 then
      local icon, texture_rect = tweak_data.hud_icons:get_icon_data(tweak_data.equipments.specials[l_116_2].icon)
      icon = data.panel:bitmap({name = l_116_2, texture = icon, layer = 1, texture_rect = texture_rect, w = data.icon_size / 2, h = data.icon_size / 2})
      table.insert(data.equipment, {equipment = l_116_2, icon = icon})
      l_116_0:_layout_mugshot_equipment(data)
      l_116_0:add_teammate_special_equipment(managers.criminals:character_data_by_name(data.character_name_id).panel_id, {id = l_116_2, icon = tweak_data.equipments.specials[l_116_2].icon})
  else
    end
  end
end

HUDManager.remove_mugshot_equipment = function(l_117_0, l_117_1, l_117_2)
  if not l_117_1 then
    return 
  end
  for i,data in ipairs(l_117_0._hud.mugshots) do
    if data.id == l_117_1 then
      for i,e_data in ipairs(data.equipment) do
        if e_data.equipment == l_117_2 then
          data.panel:remove(e_data.icon)
          table.remove(data.equipment, i)
      else
        end
      end
      l_117_0:_layout_mugshot_equipment(data)
      l_117_0:remove_teammate_special_equipment(managers.criminals:character_data_by_name(data.character_name_id).panel_id, l_117_2)
  else
    end
  end
end

HUDManager._layout_mugshot_equipment = function(l_118_0, l_118_1)
  local icon_size = 34
  for i,e_data in ipairs(l_118_1.equipment) do
    if i ~= 1 or not l_118_1.mask then
      local align = l_118_1.equipment[i - 1].icon
    end
    e_data.icon:set_size(icon_size / 2 * tweak_data.scale.hud_health_multiplier, icon_size / 2 * tweak_data.scale.hud_health_multiplier)
    e_data.icon:set_left(align:right() + 4 * tweak_data.scale.hud_mugshot_multiplier)
    e_data.icon:set_bottom(align:bottom())
  end
end

HUDManager.clear_mugshots = function(l_119_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  for _,mugshot in ipairs(l_119_0._hud.mugshots) do
    hud.panel:remove(mugshot.panel)
  end
  l_119_0._hud.mugshots = {}
end

HUDManager._layout_mugshots = function(l_120_0)
  if not l_120_0:exists(PlayerBase.PLAYER_HUD) then
    managers.hud:load_hud(PlayerBase.PLAYER_HUD, false, false, true, {})
  end
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  local info_hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  do
    local _, hy = hud.panel:center()
    for i,mugshot in ipairs(l_120_0._hud.mugshots) do
      local alpha = 0.5
      for _,child in ipairs(mugshot.panel:children()) do
      end
      if child.set_color then
        end
        local _, sy = mugshot.panel:size()
        local y = (i == 3 and l_120_0._hud.mugshots[2].panel:top() - 2 * tweak_data.scale.hud_health_multiplier)
        local icon_size = 34
        local pad = 4
        local w, h = 176 * tweak_data.scale.hud_mugshot_multiplier, (icon_size + pad * 2) * tweak_data.scale.hud_mugshot_multiplier
        mugshot.panel:set_size(w, h)
        mugshot.panel:set_left(info_hud.health_panel:right() + 2)
        mugshot.panel:set_bottom(y)
        mugshot.gradient:set_size(w, h)
        local _, background_rect = tweak_data.hud_icons:get_icon_data("mugshot_health_background")
        mugshot.health_background:set_size(background_rect[3] * tweak_data.scale.hud_mugshot_multiplier, icon_size * tweak_data.scale.hud_mugshot_multiplier)
        mugshot.health_background:set_left(4 * tweak_data.scale.hud_mugshot_multiplier)
        mugshot.mask:set_size(icon_size * tweak_data.scale.hud_mugshot_multiplier, icon_size * tweak_data.scale.hud_mugshot_multiplier)
        mugshot.mask:set_left(mugshot.health_background:right() + 4 * tweak_data.scale.hud_mugshot_multiplier)
        mugshot.mask:set_center_y(mugshot.gradient:h() / 2)
        mugshot.state_icon:set_shape(mugshot.mask:shape())
        mugshot.talk:set_righttop(mugshot.mask:righttop())
        mugshot.voice:set_righttop(mugshot.mask:righttop())
        mugshot.health_background:set_top(mugshot.mask:top())
        mugshot.health_armor:set_size(background_rect[3] * tweak_data.scale.hud_mugshot_multiplier, icon_size * tweak_data.scale.hud_mugshot_multiplier)
        mugshot.health_armor:set_center_x(mugshot.health_background:center_x())
        mugshot.health_armor:set_bottom(mugshot.health_background:bottom())
        mugshot.health_health:set_size(background_rect[3] * tweak_data.scale.hud_mugshot_multiplier, icon_size * tweak_data.scale.hud_mugshot_multiplier)
        mugshot.health_health:set_center_x(mugshot.health_background:center_x())
        mugshot.health_health:set_bottom(mugshot.health_background:bottom())
        l_120_0:layout_mugshot_health(mugshot, mugshot.health_amount or 1)
        l_120_0:layout_mugshot_armor(mugshot, mugshot.armor_amount or 1)
        l_120_0:_layout_mugshot_equipment(mugshot)
        local font_size = 14 * tweak_data.scale.hud_mugshot_multiplier
        mugshot.name:set_font_size(font_size)
        mugshot.name:set_kern(tweak_data.scale.mugshot_name_kern)
        local _, _, w, _ = mugshot.name:text_rect()
        mugshot.name:set_w(w)
        mugshot.name:set_left(mugshot.mask:right() + 4 * tweak_data.scale.hud_mugshot_multiplier)
        mugshot.name:set_top(mugshot.mask:top() * tweak_data.scale.hud_mugshot_multiplier)
        mugshot.state_text:set_kern(tweak_data.scale.mugshot_name_kern)
        mugshot.state_text:set_font_size(font_size)
        mugshot.state_text:set_left(mugshot.name:right() + 4)
        mugshot.state_text:set_top(mugshot.name:top())
        mugshot.location_text:set_kern(tweak_data.scale.mugshot_name_kern)
        mugshot.location_text:set_font_size(font_size)
        if mugshot.state_name ~= "mugshot_normal" or not mugshot.name:right() then
          mugshot.location_text:set_left(mugshot.state_text:right() + 4)
        end
        mugshot.location_text:set_top(mugshot.name:top())
        mugshot.panel:set_w(mugshot.name:w() + 4 + mugshot.state_text:w())
        mugshot.timer_text:set_font_size(tweak_data.hud.small_font_size)
        mugshot.timer_text:set_center(mugshot.health_background:center())
        l_120_0:_update_mugshot_panel_size(mugshot)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDManager._add_name_label = function(l_121_0, l_121_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
  local last_id = l_121_0._hud.name_labels[#l_121_0._hud.name_labels] and l_121_0._hud.name_labels[#l_121_0._hud.name_labels].id or 0
  local id = last_id + 1
  local character_name = l_121_1.name
  local peer_id = nil
  local is_husk_player = l_121_1.unit:base().is_husk_player
  if is_husk_player then
    peer_id = l_121_1.unit:network():peer():id()
    local level = l_121_1.unit:network():peer():level()
    l_121_1.name = l_121_1.name .. " [" .. level .. "]"
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local text = hud.panel:text({name = "text", text = utf8.to_upper(l_121_1.name), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.name_label_font_size})
  local _, _, w, h = text:text_rect()
  text:set_size(w + 4, h)
  {name = "text", text = utf8.to_upper(l_121_1.name), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.name_label_font_size}.h, {name = "text", text = utf8.to_upper(l_121_1.name), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.name_label_font_size}.w, {name = "text", text = utf8.to_upper(l_121_1.name), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.name_label_font_size}.layer, {name = "text", text = utf8.to_upper(l_121_1.name), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.name_label_font_size}.vertical, {name = "text", text = utf8.to_upper(l_121_1.name), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.name_label_font_size}.align, {name = "text", text = utf8.to_upper(l_121_1.name), font = tweak_data.hud.medium_font, font_size = tweak_data.hud.name_label_font_size}.color = 18, 256, -2, "center", "center", Color(1, 1, 1, 1)
  table.insert(l_121_0._hud.name_labels, {movement = l_121_1.unit:movement(), text = text, character_name = character_name, id = id, peer_id = peer_id})
  return id
end

HUDManager._remove_name_label = function(l_122_0, l_122_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
  if not hud then
    return 
  end
  for i,data in ipairs(l_122_0._hud.name_labels) do
    if data.id == l_122_1 then
      hud.panel:remove(data.text)
      table.remove(l_122_0._hud.name_labels, i)
  else
    end
  end
end

HUDManager.update_name_label_by_peer = function(l_123_0, l_123_1)
  for _,data in pairs(l_123_0._hud.name_labels) do
    if data.peer_id == l_123_1:id() then
      local name = data.character_name .. " [" .. l_123_1:level() .. "]"
      data.text:set_text(utf8.to_upper(name))
      local _, _, w, h = data.text:text_rect()
      local radius = data.interact:radius()
      h = math.max(h, radius * 2)
      data.panel:set_size(w + 4 + radius * 2, h)
      data.text:set_size(data.panel:size())
      data.panel:child("action"):set_size(data.panel:size())
      data.panel:child("action"):set_x(data.interact:radius() * 2 + 4)
      local bag = data.panel:child("bag")
      data.panel:set_w(data.panel:w() + bag:w() + 4)
      bag:set_right(data.panel:w())
      bag:set_y(4)
  else
    end
  end
end

HUDManager.set_control_info = function(l_124_0, l_124_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  if not hud then
    return 
  end
  hud.control_hostages:set_text(managers.localization:text("debug_control_hostages") .. " " .. l_124_1.nr_hostages)
end

HUDManager.start_anticipation = function(l_125_0, l_125_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  if not hud then
    return 
  end
end

HUDManager.sync_start_anticipation = function(l_126_0)
end

HUDManager.check_start_anticipation_music = function(l_127_0, l_127_1)
  if not l_127_0._anticipation_music_started and l_127_1 < 30 then
    l_127_0._anticipation_music_started = true
    managers.network:session():send_to_peers("sync_start_anticipation_music")
    l_127_0:sync_start_anticipation_music()
  end
end

HUDManager.sync_start_anticipation_music = function(l_128_0)
  managers.music:post_event(tweak_data.levels:get_music_event("anticipation"))
end

HUDManager.start_assault = function(l_129_0, l_129_1)
  l_129_0._hud.in_assault = true
  managers.network:session():send_to_peers("sync_start_assault")
  l_129_0:sync_start_assault(l_129_1)
end

HUDManager.sync_start_assault = function(l_130_0, l_130_1)
  managers.music:post_event(tweak_data.levels:get_music_event("assault"))
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  if not hud then
    return 
  end
  if not managers.groupai:state():get_hunt_mode() and managers.groupai:state():bain_state() then
    managers.dialog:queue_dialog("gen_ban_b02c", {})
  end
  hud.assault_image:set_visible(true)
  hud.control_assault_title:set_visible(true)
  hud.control_assault_title:animate(hud.flash_assault_title)
  hud.assault_image:animate(hud.flash_assault_title)
  hud.control_hostages:set_color(Color.white / 1.5)
end

HUDManager.end_assault = function(l_131_0, l_131_1)
  l_131_0._anticipation_music_started = false
  l_131_0._hud.in_assault = false
  l_131_0:sync_end_assault(l_131_1)
  managers.network:session():send_to_peers("sync_end_assault", l_131_1)
end

HUDManager.sync_end_assault = function(l_132_0, l_132_1)
  managers.music:post_event(tweak_data.levels:get_music_event("control"))
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  if not hud then
    return 
  end
  local result_diag = {"gen_ban_b12", "gen_ban_b11", "gen_ban_b10"}
  if l_132_1 and managers.groupai:state():bain_state() then
    managers.dialog:queue_dialog(result_diag[l_132_1 + 1], {})
  end
  hud.assault_image:set_visible(false)
  hud.control_assault_title:set_visible(false)
  hud.assault_image:stop()
  hud.control_assault_title:stop()
  hud.control_hostages:set_color(Color.white)
end

HUDManager.setup_anticipation = function(l_133_0, l_133_1)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local exists = true
l_133_0._anticipation_dialogs = {}
if not exists and l_133_1 == 45 then
  table.insert(l_133_0._anticipation_dialogs, {time = 45, dialog = 1})
  table.insert(l_133_0._anticipation_dialogs, {time = 30, dialog = 2})
elseif exists and l_133_1 == 45 then
  table.insert(l_133_0._anticipation_dialogs, {time = 30, dialog = 6})
end
if l_133_1 == 45 then
  table.insert(l_133_0._anticipation_dialogs, {time = 20, dialog = 3})
  table.insert(l_133_0._anticipation_dialogs, {time = 10, dialog = 4})
end
if l_133_1 == 35 then
  table.insert(l_133_0._anticipation_dialogs, {time = 20, dialog = 7})
  table.insert(l_133_0._anticipation_dialogs, {time = 10, dialog = 4})
end
if l_133_1 == 25 then
  table.insert(l_133_0._anticipation_dialogs, {time = 10, dialog = 8})
end
end

HUDManager.check_anticipation_voice = function(l_134_0, l_134_1)
  if not l_134_0._anticipation_dialogs[1] then
    return 
  end
  if l_134_1 < l_134_0._anticipation_dialogs[1].time then
    local data = table.remove(l_134_0._anticipation_dialogs, 1)
    l_134_0:sync_assault_dialog(data.dialog)
    managers.network:session():send_to_peers("sync_assault_dialog", data.dialog)
  end
end

HUDManager.sync_assault_dialog = function(l_135_0, l_135_1)
  if not managers.groupai:state():bain_state() then
    return 
  end
  local dialog = HUDManager.ASSAULT_DIALOGS[l_135_1]
  managers.dialog:queue_dialog(dialog, {})
end

HUDManager._layout_point_of_no_return_panel = function(l_136_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  if not hud then
    return 
  end
  hud.point_of_no_return_title:set_text(managers.localization:text(managers.dlc:is_trial() and "time_trial" or "time_escape"))
  hud.point_of_no_return_title:set_font_size(tweak_data.hud.completed_objective_title_font_size)
  local x, y, w, h = hud.point_of_no_return_title:text_rect()
  hud.point_of_no_return_title:set_right(hud.point_of_no_return_panel:w())
  hud.point_of_no_return_title:set_top(0)
  hud.point_of_no_return_title:set_height(h)
  hud.point_of_no_return_panel:set_right(hud.panel:right())
  hud.point_of_no_return_timer:set_font_size(tweak_data.hud.timer_font_size)
  hud.point_of_no_return_timer:set_top(hud.point_of_no_return_title:bottom())
  hud.point_of_no_return_timer:set_left(hud.point_of_no_return_title:left())
  hud.point_of_no_return_title:set_align("right")
  hud.point_of_no_return_timer:set_align("right")
end

HUDManager.feed_point_of_no_return_timer = function(l_137_0, l_137_1, l_137_2)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  if not hud then
    return 
  end
  l_137_1 = math.floor(l_137_1)
  local minutes = math.floor(l_137_1 / 60)
  local seconds = math.round(l_137_1 - minutes * 60)
  local text = (minutes < 10 and "0" .. minutes or minutes) .. ":" .. (seconds < 10 and "0" .. seconds or seconds)
  hud.point_of_no_return_timer:set_text(text .. " ")
  if not l_137_2 or not Color.green then
    local color = Color.red
  end
  if l_137_0._point_of_no_return_color ~= color then
    l_137_0._point_of_no_return_color = color
    hud.point_of_no_return_title:set_color(l_137_0._point_of_no_return_color)
    hud.point_of_no_return_timer:set_color(l_137_0._point_of_no_return_color)
  end
end

HUDManager.show_point_of_no_return_timer = function(l_138_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  if not hud then
    return 
  end
  hud.point_of_no_return_panel:set_visible(true)
end

HUDManager.flash_point_of_no_return_timer = function(l_139_0, l_139_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  if not hud then
    return 
  end
  if l_139_1 then
    l_139_0._sound_source:post_event("last_10_seconds_beep")
  end
  local flash_timer = function(l_1_0)
    local t = 0
    repeat
      if t < 0.5 then
        t = t + coroutine.yield()
        local n = 1 - math.sin((t) * 180)
        local r = math.lerp(self._point_of_no_return_color.r, 1, n)
        local g = math.lerp(self._point_of_no_return_color.g, 0.80000001192093, n)
        local b = math.lerp(self._point_of_no_return_color.b, 0.20000000298023, n)
        l_1_0:set_color(Color(r, g, b))
        l_1_0:set_font_size(math.lerp(tweak_data.hud.timer_font_size, tweak_data.hud.timer_font_size * 1.25, n))
      else
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  hud.point_of_no_return_timer:animate(flash_timer)
end

HUDManager._layout_secret_assignment_panel = function(l_140_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  if not hud then
    return 
  end
  hud.secret_assignment_title:set_font_size(tweak_data.hud.small_font_size)
  hud.secret_assignment_panel:set_right(hud.panel:right())
  hud.secret_assignment_title:set_top(4)
  hud.secret_assignment_title:set_right(hud.secret_assignment_panel:w() - 4)
  hud.secret_assignment_text:set_font_size(tweak_data.hud.small_font_size)
  hud.secret_assignment_text:set_righttop(hud.secret_assignment_title:rightbottom())
  hud.secret_assignment_status_timer:set_font_size(tweak_data.hud.medium_deafult_font_size)
  hud.secret_assignment_status_timer:set_righttop(hud.secret_assignment_text:rightbottom())
  hud.secret_assignment_status_counter:set_font_size(tweak_data.hud.medium_deafult_font_size)
  hud.secret_assignment_status_counter:set_righttop(hud.secret_assignment_text:rightbottom())
  hud.secret_assignment_description:set_font_size(tweak_data.hud.small_font_size)
  hud.secret_assignment_description:set_right(hud.secret_assignment_panel:width() - 4)
  hud.secret_assignment_description:set_top(hud.secret_assignment_status_timer:bottom() + 16)
end

HUDManager.present_secret_assignment = function(l_141_0, l_141_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  if not hud then
    return 
  end
  local assignment = l_141_1.assignment or "Test"
  hud.secret_assignment_text:set_text(utf8.to_upper(assignment))
  local description = l_141_1.description or "description"
  hud.secret_assignment_description:set_text(utf8.to_upper(description))
  hud.secret_assignment_status_timer:set_visible(l_141_1.status_time)
  hud.secret_assignment_status_counter:set_visible(l_141_1.status_counter)
  local x1, _, w1, _ = hud.secret_assignment_text:text_rect()
  local x2, _, w2, _ = hud.secret_assignment_title:text_rect()
  local w = math.max(w1, w2)
  local x = w2 < w1 and x1 or x2
  hud.secret_assignment_status_timer:set_left(x - hud.secret_assignment_panel:x())
  hud.secret_assignment_panel:animate(hud.present_secret_assignment_panel)
end

HUDManager.complete_secret_assignment = function(l_142_0, l_142_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  if not hud then
    return 
  end
  hud.secret_assignment_panel:animate(hud.complete_secret_assignment_panel, l_142_1.success)
end

HUDManager.feed_secret_assignment_timer = function(l_143_0, l_143_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  if not hud then
    return 
  end
  l_143_1 = math.round(l_143_1)
  local minutes = math.floor(l_143_1 / 60)
  local seconds = math.round(l_143_1 - minutes * 60)
  local text = (minutes < 10 and "0" .. minutes or minutes) .. ":" .. (seconds < 10 and "0" .. seconds or seconds)
  hud.secret_assignment_status_timer:set_text(text)
end

HUDManager.feed_secret_assignment_counter = function(l_144_0, l_144_1, l_144_2)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  if not hud then
    return 
  end
  local text = "" .. l_144_1 .. "/" .. l_144_2
  hud.secret_assignment_status_counter:set_text(text)
end

HUDManager.set_crosshair_offset = function(l_145_0, l_145_1)
  l_145_0._ch_offset = math.lerp(tweak_data.weapon.crosshair.MIN_OFFSET, tweak_data.weapon.crosshair.MAX_OFFSET, l_145_1)
end

HUDManager.set_crosshair_visible = function(l_146_0, l_146_1)
  l_146_0:script("guis/player_hud").crosshair_panel:set_visible(l_146_1)
end

HUDManager.set_ammo_amount = function(l_147_0, l_147_1, l_147_2, l_147_3)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  hud.ammo_amount:set_text(l_147_3)
  local width = hud.ammo_current:texture_width()
  local height = hud.ammo_current:texture_height()
  local d = l_147_1 / ((512 - hud.ammo_amount:w() - 140) / width)
  width = width / (d < 1 and 1 or d)
  if l_147_1 <= 100 or not tweak_data.scale.hud_ammo_clip_large_multiplier then
    local scale = tweak_data.scale.hud_ammo_clip_multiplier
  end
  hud.ammo_current:set_w(l_147_2 * (width) * scale)
  hud.ammo_current:set_h(height * scale)
  hud.ammo_current:set_texture_rect(0, 0, width * l_147_2, height)
  hud.ammo_used:set_w((l_147_1 - l_147_2) * (width) * scale)
  hud.ammo_used:set_h(height * scale)
  hud.ammo_used:set_texture_rect(0, 0, (l_147_1 - l_147_2) * (width), height)
  local r, g, b = 1, 1, 1
  if l_147_2 <= math.round(l_147_1 / 4) then
    g = l_147_2 / (l_147_1 / 2)
    b = l_147_2 / (l_147_1 / 2)
  end
  hud.ammo_current:set_color(Color(0.80000001192093, r, g, b))
  hud.ammo_current:set_rightbottom(hud.ammo_amount:leftbottom())
  hud.ammo_used:set_color(Color(0.20000000298023, r, g, b))
  hud.ammo_used:set_rightbottom(hud.ammo_current:leftbottom())
  l_147_0:_set_ammo_warning(l_147_1, l_147_2, l_147_3)
end

HUDManager._set_ammo_warning = function(l_148_0, l_148_1, l_148_2, l_148_3)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  local reload = l_148_2 <= math.round(l_148_1 / 4)
  local low_ammo = l_148_3 <= math.round(l_148_1 / 2)
  local out_of_ammo = l_148_3 <= 0
  local visible = reload or low_ammo or out_of_ammo
  hud.ammo_warning_text:set_visible(visible)
  hud.ammo_warning_shadow_text:set_visible(visible)
  if not visible and l_148_0._hud.ammo_flash_thread then
    hud.ammo_warning_text:stop(l_148_0._hud.ammo_flash_thread)
    l_148_0._hud.ammo_flash_thread = nil
  end
  return 
  if out_of_ammo then
    local color = Color(0.89999997615814, 0.30000001192093, 0.30000001192093)
  end
  if not color and low_ammo then
    color = Color(0.89999997615814, 0.89999997615814, 0.30000001192093)
  end
  if not color and reload then
    color = Color.white
  end
  hud.ammo_warning_text:set_color(color)
  if not l_148_0._hud.ammo_flash_thread then
    l_148_0._hud.ammo_flash_thread = hud.ammo_warning_text:animate(hud.flash_warning)
  end
  if out_of_ammo then
    local text = managers.localization:text("debug_no_ammo")
  end
  if not text and low_ammo then
    text = managers.localization:text("debug_low_ammo")
  end
  if not text and reload then
    text = managers.localization:text("debug_reload")
  end
  hud.ammo_warning_text:set_text(text)
  hud.ammo_warning_shadow_text:set_text(text)
  if low_ammo or out_of_ammo then
    local eq, _ = managers.player:equipment_data_by_name("ammo_bag")
    if eq and eq.amount > 0 then
      managers.hint:show_hint("ammo_bag", nil, nil, {BTN_USE_ITEM = managers.localization:btn_macro("use_item")})
    else
      managers.hint:show_hint("pickup_ammo")
    end
  elseif reload then
    managers.hint:show_hint("reload", nil, nil, {BTN_RELOAD = managers.localization:btn_macro("reload")})
  end
end

HUDManager.set_weapon_name = function(l_149_0, l_149_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  l_149_0._hud.weapon_name = {}
  l_149_0._hud.weapon_name.persistant_time = 3
  l_149_0._hud.weapon_name.fade_time = 1.5
  l_149_0._hud.weapon_name.fade_timer = l_149_0._hud.weapon_name.fade_time
  l_149_0._hud.weapon_name.gui = hud.weapon_name
  hud.weapon_name:set_color(hud.weapon_name:color():with_alpha(1))
  hud.weapon_name:set_text(utf8.to_upper(managers.localization:text(l_149_1)))
end

HUDManager.show_hint = function(l_150_0, l_150_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  if not hud then
    return 
  end
  local text = l_150_1.text
  hud.hint_text:set_text(utf8.to_upper(text))
  hud.hint_shadow_text:set_text(utf8.to_upper(text))
  if l_150_0._hud.show_hint_thread then
    hud.hint_text:stop(l_150_0._hud.show_hint_thread)
  end
  if l_150_1.event then
    l_150_0._sound_source:post_event(l_150_1.event)
  end
  l_150_0._hud.show_hint_thread = hud.hint_text:animate(hud.show_hint, hud.hint_shadow_text, callback(l_150_0, l_150_0, "show_hint_done"), l_150_1.time or 4)
end

HUDManager.show_hint_done = function(l_151_0)
  l_151_0._hud.show_hint_thread = nil
end

HUDManager.present_text = function(l_152_0, l_152_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  if not hud then
    return 
  end
  if not l_152_0._hud.present_text_queue then
    l_152_0._hud.present_text_queue = {}
  end
  if l_152_0._hud.present_text_thread then
    table.insert(l_152_0._hud.present_text_queue, l_152_1)
    return 
  end
  hud.present_text:set_text(l_152_1.text)
  if l_152_1.event then
    l_152_0._sound_source:post_event(l_152_1.event)
  end
  l_152_0._hud.present_text_thread = hud.present_text:animate(hud.show_present_text, callback(l_152_0, l_152_0, "present_text_done"), l_152_1.time or 1)
end

HUDManager.present_text_done = function(l_153_0)
  l_153_0._hud.present_text_thread = nil
  local queued = table.remove(l_153_0._hud.present_text_queue, 1)
  if queued then
    l_153_0:present_text(queued)
  end
end

HUDManager.present = function(l_154_0, l_154_1)
  if not l_154_0._hud.present_queue then
    l_154_0._hud.present_queue = {}
  end
  if l_154_0._hud.present_thread then
    table.insert(l_154_0._hud.present_queue, l_154_1)
    return 
  end
  if l_154_1.level_up then
    l_154_0:_present_level_up(l_154_1)
  end
  if l_154_1.present_mid_text then
    l_154_0:_present_mid_text(l_154_1)
  end
end

HUDManager._present_level_up = function(l_155_0, l_155_1)
  local hud = managers.hud:script(l_155_0.ANNOUNCEMENT_HUD)
  local full_hud = managers.hud:script(l_155_0.ANNOUNCEMENT_HUD_FULLSCREEN)
  if not managers.upgrades:complete_title(l_155_1.upgrade_id, nil) then
    local name = managers.upgrades:name(l_155_1.upgrade_id)
  end
  hud.level_up_text:set_text(l_155_0._reached_level_s .. " " .. l_155_1.level .. "!")
  local post_fix = " [" .. l_155_1.progress[l_155_1.tree] .. "/" .. #tweak_data.upgrades.progress[l_155_1.tree] - 1 .. "]"
  if #tweak_data.upgrades.progress[l_155_1.tree] - 1 < l_155_1.progress[l_155_1.tree] then
    post_fix = ""
  end
  hud.level_up_current_spec:set_text(l_155_0._current_spec_s .. " " .. managers.upgrades:tree_name(l_155_1.tree) .. post_fix)
  hud.level_up_unlocked:set_text(utf8.to_upper(name))
  if l_155_1.upgrade.image then
    local image, texture_rect = tweak_data.hud_icons:get_icon_data(l_155_1.upgrade.image)
    hud.level_up_image:set_image(image, texture_rect[1], texture_rect[2], texture_rect[3], texture_rect[4])
  else
    hud.level_up_image:set_image(nil)
  end
  if l_155_1.level < managers.experience:level_cap() then
    local next_tree = l_155_1.next_tree
    local total = #tweak_data.upgrades.progress[next_tree] - 1
    local progress = math.clamp(l_155_1.progress[next_tree] + 1, 0, total)
    local texts = {l_155_0._tree_assault_s, l_155_0._tree_sharpshooter_s, l_155_0._tree_support_s, l_155_0._tree_technician_s}
    hud.next_level_upgrade:set_text(texts[next_tree] .. " [" .. progress .. "/" .. total .. "]")
    local upgrades = l_155_1.alternative_upgrades
    if not managers.upgrades:complete_title(upgrades[next_tree], nil) then
      local tree_text = managers.upgrades:name(upgrades[next_tree])
    end
    hud.next_level_upgrade_upgrade:set_color(Color.white)
    hud.next_level_upgrade_upgrade:set_text(utf8.to_upper(tree_text))
    local image, rect = managers.upgrades:image(upgrades[next_tree])
    if ((rect and not rect) or rect and rect) then
      hud.next_level_upgrade_image:set_image(image, rect[1], rect[2], rect[3], rect[4])
    end
  end
  l_155_0._sound_source:post_event("stinger_levelup")
  l_155_0._hud.animate_bg_thread = full_hud.present_background:animate(hud.animate_bg, full_hud.present_background)
  l_155_0._hud.present_thread = hud.level_up_left:animate(hud.present_level_up, full_hud.present_background, l_155_1.level, callback(l_155_0, l_155_0, "present_done"), l_155_1.time or 1)
end

HUDManager.present_done = function(l_156_0)
  if l_156_0._hud.animate_bg_thread then
    local full_hud = managers.hud:script(l_156_0.ANNOUNCEMENT_HUD_FULLSCREEN)
    full_hud.present_background:stop(l_156_0._hud.animate_bg_thread)
    l_156_0._hud.animate_bg_thread = nil
  end
  l_156_0._hud.present_thread = nil
  local queued = table.remove(l_156_0._hud.present_queue, 1)
  if queued then
    if queued.level_up then
      l_156_0:_present_level_up(queued)
    end
    if queued.present_mid_text then
      l_156_0:_present_mid_text(queued)
    end
  end
end

HUDManager._present_mid_text = function(l_157_0, l_157_1)
  local text = l_157_1.text
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  local full_hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
  if not hud then
    return 
  end
  l_157_0._mid_text_presenting = l_157_1
  hud.title_mid_text:set_text(l_157_1.title or "ERROR")
  hud.present_mid_text:set_text(utf8.to_upper(text))
  hud.present_mid_text:set_font_size(tweak_data.hud.present_mid_text_font_size)
  local x, y, w, h = hud.present_mid_text:text_rect()
  local scale = w > 880 and 880 / w or 1
  local icon, texture_rect = nil, nil
  if l_157_1.icon then
    icon, texture_rect = tweak_data.hud_icons:get_icon_data(l_157_1.icon)
    hud.present_mid_icon:set_image(icon, texture_rect[1], texture_rect[2], texture_rect[3], texture_rect[4])
    icon = hud.present_mid_icon
  end
  if l_157_1.event then
    l_157_0._sound_source:post_event(l_157_1.event)
  end
  l_157_0._hud.present_thread = hud.present_mid_text:animate(hud.show_present_mid_text, full_hud.present_background, callback(l_157_0, l_157_0, "present_done"), l_157_1.time or 1, icon, scale)
  local safe_rect_pixels = managers.viewport:get_safe_rect_pixels()
  full_hud.present_background:set_h(56 * tweak_data.scale.present_multiplier)
  full_hud.present_background:set_center_y(hud.present_mid_icon:center_y() + safe_rect_pixels.y - 2 * tweak_data.scale.present_multiplier)
end

HUDManager.present_mid_text = function(l_158_0, l_158_1)
  l_158_1.present_mid_text = true
  l_158_0:present(l_158_1)
end

HUDManager._kick_crosshair_offset = function(l_159_0, l_159_1)
  l_159_0._ch_current_offset = l_159_0._ch_current_offset or 0
  if tweak_data.weapon.crosshair.MAX_OFFSET < l_159_0._ch_current_offset then
    l_159_0._ch_current_offset = tweak_data.weapon.crosshair.MAX_OFFSET
  end
  l_159_0._ch_current_offset = l_159_0._ch_current_offset + math.lerp(tweak_data.weapon.crosshair.MIN_KICK_OFFSET, tweak_data.weapon.crosshair.MAX_KICK_OFFSET, l_159_1)
  l_159_0:_layout_crosshair()
end

HUDManager._layout_crosshair = function(l_160_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  local x = hud.crosshair_panel:center_x() - hud.crosshair_panel:left()
  local y = hud.crosshair_panel:center_y() - hud.crosshair_panel:top()
  if not l_160_0._hud.crosshair_parts then
    l_160_0._hud.crosshair_parts = {hud.crosshair_part_left, hud.crosshair_part_top, hud.crosshair_part_right, hud.crosshair_part_bottom}
  end
  for _,part in ipairs(l_160_0._hud.crosshair_parts) do
    local rotation = part:rotation()
    part:set_center_x(x + math.cos(rotation) * l_160_0._ch_current_offset * tweak_data.scale.hud_crosshair_offset_multiplier)
    part:set_center_y(y + math.sin(rotation) * l_160_0._ch_current_offset * tweak_data.scale.hud_crosshair_offset_multiplier)
  end
end

HUDManager._layout_d_pad = function(l_161_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  local x, y = hud.d_pad_panel:size()
  local offset = 12 * tweak_data.scale.hud_equipment_icon_multiplier
  for _,part in ipairs({hud.d_pad_up, hud.d_pad_down, hud.d_pad_left, hud.d_pad_right}) do
    local rotation = part:rotation()
    part:set_size(16 * tweak_data.scale.hud_equipment_icon_multiplier, 16 * tweak_data.scale.hud_equipment_icon_multiplier)
    part:set_center_x(x / 2 + math.cos(rotation) * offset)
    part:set_center_y(y / 2 + math.sin(rotation) * offset)
    part:set_color(Color.white:with_alpha(0.40000000596046))
  end
end

HUDManager.pressed_d_pad = function(l_162_0, l_162_1)
  local hud = managers.hud:script(PlayerBase.PLAYER_HUD)
  l_162_0._hud.pressed_d_pad[l_162_1] = {}
  local bitmap = (((l_162_1 ~= "up" or not hud.d_pad_up) and l_162_1 == "down" and hud.d_pad_down))
  if (l_162_1 ~= "right" and l_162_1 ~= "left") or not Color.white:with_alpha(1) then
    local color = Color(1, 0, 0.99215686321259, 0.73333334922791)
  end
  bitmap:set_color(color)
  l_162_0._hud.pressed_d_pad[l_162_1].bitmap = bitmap
  l_162_0._hud.pressed_d_pad[l_162_1].timer = 0.25
end

HUDManager._update_crosshair_offset = function(l_163_0, l_163_1, l_163_2)
  if l_163_0._ch_current_offset and l_163_0._ch_offset < l_163_0._ch_current_offset then
    l_163_0:_kick_crosshair_offset(-l_163_2 * 3)
    if l_163_0._ch_current_offset < l_163_0._ch_offset then
      l_163_0._ch_current_offset = l_163_0._ch_offset
      l_163_0:_layout_crosshair()
    elseif l_163_0._ch_current_offset and l_163_0._ch_current_offset < l_163_0._ch_offset then
      l_163_0:_kick_crosshair_offset(l_163_2 * 3)
      if l_163_0._ch_offset < l_163_0._ch_current_offset then
        l_163_0._ch_current_offset = l_163_0._ch_offset
        l_163_0:_layout_crosshair()
      end
    end
  end
  if l_163_0._hud.weapon_name then
    l_163_0._hud.weapon_name.persistant_time = l_163_0._hud.weapon_name.persistant_time - l_163_2
    if l_163_0._hud.weapon_name.persistant_time <= 0 then
      l_163_0._hud.weapon_name.fade_timer = l_163_0._hud.weapon_name.fade_timer - l_163_2
      l_163_0._hud.weapon_name.gui:set_color(l_163_0._hud.weapon_name.gui:color():with_alpha(l_163_0._hud.weapon_name.fade_timer / l_163_0._hud.weapon_name.fade_time))
      if l_163_0._hud.weapon_name.fade_timer <= 0 then
        l_163_0._hud.weapon_name.gui:set_color(l_163_0._hud.weapon_name.gui:color():with_alpha(0))
        l_163_0._hud.weapon_name = nil
      end
    end
  end
  l_163_0:_update_pressed_d_pad(l_163_1, l_163_2)
end

HUDManager._update_pressed_d_pad = function(l_164_0, l_164_1, l_164_2)
  for dir,data in pairs(l_164_0._hud.pressed_d_pad) do
    data.timer = data.timer - l_164_2
    if data.timer < 0 then
      data.bitmap:set_color(Color.white:with_alpha(0.40000000596046))
      l_164_0._hud.pressed_d_pad[dir] = nil
    end
  end
end

local wp_pos = Vector3()
local wp_dir = Vector3()
local wp_dir_normalized = Vector3()
local wp_cam_forward = Vector3()
local wp_onscreen_direction = Vector3()
local wp_onscreen_target_pos = Vector3()
HUDManager._update_waypoints = function(l_165_0, l_165_1, l_165_2)
  local cam = managers.viewport:get_current_camera()
  if not cam then
    return 
  end
  local cam_pos = managers.viewport:get_current_camera_position()
  local cam_rot = managers.viewport:get_current_camera_rotation()
  mrotation.y(cam_rot, wp_cam_forward)
  for id,data in pairs(l_165_0._hud.waypoints) do
    local panel = data.bitmap:parent()
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if data.state ~= "dirty" or data.state == "sneak_present" then
      data.current_position = Vector3(panel:center_x(), panel:center_y())
      data.bitmap:set_center_x(data.current_position.x)
      data.bitmap:set_center_y(data.current_position.y)
      data.slot = nil
      data.current_scale = 1
      data.state = "present_ended"
      data.text_alpha = 0.5
      data.in_timer = 0
      data.target_scale = 1
      if data.distance then
        data.distance:set_visible(true)
      elseif data.state == "present" then
        data.current_position = Vector3(panel:center_x() + data.slot_x, panel:center_y() + panel:center_y() / 2)
        data.bitmap:set_center_x(data.current_position.x)
        data.bitmap:set_center_y(data.current_position.y)
        data.text:set_center_x(data.bitmap:center_x())
        data.text:set_top(data.bitmap:bottom())
        data.present_timer = data.present_timer - l_165_2
        if data.present_timer <= 0 then
          data.slot = nil
          data.current_scale = 1
          data.state = "present_ended"
          data.text_alpha = 0.5
          data.in_timer = 0
          data.target_scale = 1
          if data.distance then
            data.distance:set_visible(true)
          elseif data.text_alpha ~= 0 then
            data.text_alpha = math.clamp(data.text_alpha - l_165_2, 0, 1)
            data.text:set_color(data.text:color():with_alpha(data.text_alpha))
          end
          if not data.unit or not data.unit:position() then
            data.position = data.position
          end
          mvector3.set(wp_pos, l_165_0._saferect:world_to_screen(cam, data.position))
          mvector3.set(wp_dir, data.position)
          mvector3.subtract(wp_dir, cam_pos)
          mvector3.set(wp_dir_normalized, wp_dir)
          mvector3.normalize(wp_dir_normalized)
          local dot = mvector3.dot(wp_cam_forward, wp_dir_normalized)
          if dot < 0 or panel:outside(mvector3.x(wp_pos), mvector3.y(wp_pos)) then
            if data.state ~= "offscreen" then
              data.state = "offscreen"
              data.arrow:set_visible(true)
              data.bitmap:set_color(data.bitmap:color():with_alpha(0.75))
              data.off_timer = 0 - (1 - data.in_timer)
              data.target_scale = 0.75
              if data.distance then
                data.distance:set_visible(false)
              end
              if data.timer_gui then
                data.timer_gui:set_visible(false)
              end
            end
            local direction = wp_onscreen_direction
            local panel_center_x, panel_center_y = panel:center()
            mvector3.set_static(direction, wp_pos.x - panel_center_x, wp_pos.y - panel_center_y, 0)
            mvector3.normalize(direction)
            local distance = data.radius * tweak_data.scale.hud_crosshair_offset_multiplier
            local target_pos = wp_onscreen_target_pos
            mvector3.set_static(target_pos, panel_center_x + mvector3.x(direction) * distance, panel_center_y + mvector3.y(direction) * distance, 0)
            data.off_timer = math.clamp(data.off_timer + l_165_2 / data.move_speed, 0, 1)
            if data.off_timer ~= 1 then
              mvector3.set(data.current_position, math.bezier({data.current_position, data.current_position, target_pos, target_pos}, data.off_timer))
              data.current_scale = math.bezier({data.current_scale, data.current_scale, data.target_scale, data.target_scale}, data.off_timer)
              data.bitmap:set_size(data.size.x * data.current_scale, data.size.y * data.current_scale)
            else
              mvector3.set(data.current_position, target_pos)
            end
            data.bitmap:set_center(mvector3.x(data.current_position), mvector3.y(data.current_position))
            data.arrow:set_center(mvector3.x(data.current_position) + direction.x * 24, mvector3.y(data.current_position) + direction.y * 24)
            local angle = math.X:angle(direction) * math.sign(direction.y)
            data.arrow:set_rotation(angle)
            if data.text_alpha ~= 0 then
              data.text:set_center_x(data.bitmap:center_x())
              data.text:set_top(data.bitmap:bottom())
            elseif data.state == "offscreen" then
              data.state = "onscreen"
              data.arrow:set_visible(false)
              data.bitmap:set_color(data.bitmap:color():with_alpha(1))
              data.in_timer = 0 - (1 - data.off_timer)
              data.target_scale = 1
              if data.distance then
                data.distance:set_visible(true)
              end
              if data.timer_gui then
                data.timer_gui:set_visible(true)
              end
            end
            local alpha = 0.80000001192093
            if dot > 0.99000000953674 then
              alpha = math.clamp((1 - dot) / 0.0099999997764826, 0.40000000596046, alpha)
            end
            if data.bitmap:color().alpha ~= alpha then
              data.bitmap:set_color(data.bitmap:color():with_alpha(alpha))
              if data.distance then
                data.distance:set_color(data.distance:color():with_alpha(alpha))
              end
              if data.timer_gui then
                data.timer_gui:set_color(data.bitmap:color():with_alpha(alpha))
              end
            end
            if data.in_timer ~= 1 then
              data.in_timer = math.clamp(data.in_timer + l_165_2 / data.move_speed, 0, 1)
              mvector3.set(data.current_position, math.bezier({data.current_position, data.current_position, wp_pos, wp_pos}, data.in_timer))
              data.current_scale = math.bezier({data.current_scale, data.current_scale, data.target_scale, data.target_scale}, data.in_timer)
              data.bitmap:set_size(data.size.x * data.current_scale, data.size.y * data.current_scale)
            else
              mvector3.set(data.current_position, wp_pos)
            end
            data.bitmap:set_center(mvector3.x(data.current_position), mvector3.y(data.current_position))
            if data.text_alpha ~= 0 then
              data.text:set_center_x(data.bitmap:center_x())
              data.text:set_top(data.bitmap:bottom())
            end
            if data.distance then
              local length = wp_dir:length()
              data.distance:set_text(string.format("%.0f", length / 100) .. "m")
              data.distance:set_center_x(data.bitmap:center_x())
              data.distance:set_top(data.bitmap:bottom())
            end
          end
        end
      end
    end
    if data.timer_gui then
      data.timer_gui:set_center_x(data.bitmap:center_x())
      data.timer_gui:set_bottom(data.bitmap:top())
      if data.pause_timer == 0 then
        data.timer = data.timer - l_165_2
         -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

      end
      local text = (data.timer < 0 and "00" or "") .. math.round(data.timer)
      data.timer_gui:set_text(text)
    end
  end
end
end

HUDManager.set_player_location = function(l_166_0, l_166_1)
  if l_166_1 then
    local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
    hud.location_text:set_text(utf8.to_upper(managers.localization:text(l_166_1)))
  end
end

HUDManager.reset_player_hpbar = function(l_167_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  if not hud then
    return 
  end
  local crim_entry = managers.criminals:character_static_data_by_name(managers.criminals:local_character_name())
  if not crim_entry then
    return 
  end
  local color_id = managers.network:session():local_peer():id()
  l_167_0:set_teammate_callsign(4, color_id)
  l_167_0:set_teammate_name(4, managers.network:session():local_peer():name())
end

HUDManager.set_player_armor = function(l_168_0, l_168_1)
  if l_168_1.current == 0 and not l_168_1.no_hint then
    managers.hint:show_hint("damage_pad")
  end
  local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD)
  if not hud then
    return 
  end
end

HUDManager.set_player_health = function(l_169_0, l_169_1)
end

HUDManager.show_interact = function(l_170_0, l_170_1)
  l_170_0:remove_interact()
  local hud = l_170_0:script(PlayerBase.PLAYER_HUD)
  local text = utf8.to_upper(l_170_1.text or "Press 'F' to interact")
  local icon, texture_rect = tweak_data.hud_icons:get_icon_data(l_170_1.icon)
  hud.interact_text:set_visible(true)
  hud.interact_background:set_visible(true)
  hud.interact_bitmap:set_visible(true)
  hud.interact_text:set_text(text)
  hud.interact_bitmap:set_image(icon, texture_rect[1], texture_rect[2], texture_rect[3], texture_rect[4])
end

HUDManager.remove_interact = function(l_171_0)
  local hud = l_171_0:script(PlayerBase.PLAYER_HUD)
  if not hud then
    return 
  end
  hud.interact_text:set_visible(false)
  hud.interact_background:set_visible(false)
  hud.interact_bitmap:set_visible(false)
end

HUDManager.show_interaction_bar = function(l_172_0, l_172_1, l_172_2)
  local hud = l_172_0:script(PlayerBase.PLAYER_HUD)
  if not hud then
    return 
  end
  hud.interact_bar:set_w(l_172_1)
  hud.interact_bar:set_visible(true)
  hud.interact_bar_stop:set_visible(true)
end

HUDManager.hide_interaction_bar = function(l_173_0)
  local hud = l_173_0:script(PlayerBase.PLAYER_HUD)
  if not hud then
    return 
  end
  hud.interact_bar:set_visible(false)
  hud.interact_bar_stop:set_visible(false)
end

HUDManager.set_interaction_bar_width = function(l_174_0, l_174_1, l_174_2)
  local hud = l_174_0:script(PlayerBase.PLAYER_HUD)
  if not hud then
    return 
  end
  local _, texture_rect = tweak_data.hud_icons:get_icon_data("interaction_bar")
  local mul = l_174_1 / l_174_2
  local width = mul * (hud.interact_background:width() - 2)
  hud.interact_bar:set_w(width)
  hud.interact_bar:set_texture_rect(texture_rect[1], texture_rect[2], texture_rect[3] * mul, texture_rect[4])
end

HUDManager.activate_objective = function(l_175_0, l_175_1)
  local hud = l_175_0:script(PlayerBase.PLAYER_INFO_HUD)
  if not hud then
    return 
  end
  local panel = hud.objectives_panel:panel({name = l_175_1.text, w = 176, h = 64})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local text = panel:text({name = "text", text = "- " .. utf8.to_upper(l_175_1.text), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size})
  local x, y, w, h = text:text_rect()
  text:set_size(w, h)
  {name = "text", text = "- " .. utf8.to_upper(l_175_1.text), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size}.h, {name = "text", text = "- " .. utf8.to_upper(l_175_1.text), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size}.w, {name = "text", text = "- " .. utf8.to_upper(l_175_1.text), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size}.layer, {name = "text", text = "- " .. utf8.to_upper(l_175_1.text), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size}.vertical, {name = "text", text = "- " .. utf8.to_upper(l_175_1.text), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size}.align, {name = "text", text = "- " .. utf8.to_upper(l_175_1.text), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size}.color = 18, 256, 5, "center", "left", Color(1, 1, 1, 1)
  for id,data in pairs(l_175_1.sub_objectives) do
    local sub_panel = panel:panel({name = id, w = 176, h = 64})
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    local sub_text = sub_panel:text({name = id, text = utf8.to_upper(data.text), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size})
    local sub_bitmap = sub_panel:bitmap({name = "bitmap" .. id, texture = "guis/textures/menu_tickbox", layer = 5, texture_rect = {0, 0, 24, 24}, w = 24, h = 24, color = Color(1, 1, 1, 1)})
    local x, y, w, h = sub_text:text_rect()
    sub_panel:set_left(12)
    {name = id, text = utf8.to_upper(data.text), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size}.h, {name = id, text = utf8.to_upper(data.text), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size}.w, {name = id, text = utf8.to_upper(data.text), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size}.layer, {name = id, text = utf8.to_upper(data.text), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size}.vertical, {name = id, text = utf8.to_upper(data.text), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size}.align, {name = id, text = utf8.to_upper(data.text), font = tweak_data.hud.small_font, font_size = tweak_data.hud.small_font_size}.color = 18, 256, 5, "center", "left", Color(1, 1, 1, 1)
    sub_text:set_left(sub_bitmap:right() + 4)
    sub_text:set_center_y(sub_bitmap:center_y())
    sub_text:set_size(w, h)
    sub_panel:set_size(w + sub_bitmap:w() + 4 + 12, math.max(h, sub_bitmap:h()))
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local amount_text = panel:text({name = "amount" .. l_175_1.id, text = (not l_175_1.amount or 0) .. " / " .. l_175_1.amount .. " " .. l_175_1.amount_text, font = tweak_data.hud.medium_font, font_size = 18})
do
  local x, y, w, h = amount_text:text_rect()
  amount_text:set_size(w + 12, h)
  {name = "amount" .. l_175_1.id, text = (not l_175_1.amount or 0) .. " / " .. l_175_1.amount .. " " .. l_175_1.amount_text, font = tweak_data.hud.medium_font, font_size = 18}.h, {name = "amount" .. l_175_1.id, text = (not l_175_1.amount or 0) .. " / " .. l_175_1.amount .. " " .. l_175_1.amount_text, font = tweak_data.hud.medium_font, font_size = 18}.w, {name = "amount" .. l_175_1.id, text = (not l_175_1.amount or 0) .. " / " .. l_175_1.amount .. " " .. l_175_1.amount_text, font = tweak_data.hud.medium_font, font_size = 18}.layer, {name = "amount" .. l_175_1.id, text = (not l_175_1.amount or 0) .. " / " .. l_175_1.amount .. " " .. l_175_1.amount_text, font = tweak_data.hud.medium_font, font_size = 18}.vertical, {name = "amount" .. l_175_1.id, text = (not l_175_1.amount or 0) .. " / " .. l_175_1.amount .. " " .. l_175_1.amount_text, font = tweak_data.hud.medium_font, font_size = 18}.align, {name = "amount" .. l_175_1.id, text = (not l_175_1.amount or 0) .. " / " .. l_175_1.amount .. " " .. l_175_1.amount_text, font = tweak_data.hud.medium_font, font_size = 18}.color = 18, 256, 5, "center", "left", Color(1, 1, 1, 1)
  amount_text:set_left(12)
end
local panel_h = h
local panel_w = w
for i = 1, #panel:children() - 1 do
  panel_h = panel_h + panel:child(i):h()
  panel:child(i):set_top(panel:child(i - 1):bottom())
  local cw, ch = panel:child(i):size()
  panel_w = math.max(cw, panel_w)
end
panel:set_size(panel_w, panel_h)
local h = 8 + hud.objectives_title:h()
for i = 1, #hud.objectives_panel:children() - 1 do
  hud.objectives_panel:child(i):set_lefttop(hud.objectives_panel:child(i - 1):leftbottom())
  h = h + hud.objectives_panel:child(i):h()
end
end

HUDManager.complete_sub_objective = function(l_176_0, l_176_1)
  local hud = l_176_0:script(PlayerBase.PLAYER_INFO_HUD)
  if not hud then
    return 
  end
  local panel = hud.objectives_panel:child(l_176_1.text)
  local sub_panel = panel:child(l_176_1.sub_id)
  local bitmap = sub_panel:child("bitmap" .. l_176_1.sub_id)
  bitmap:set_image("guis/textures/menu_tickbox", 24, 0, 24, 24)
end

HUDManager.update_amount_objective = function(l_177_0, l_177_1)
  local hud = l_177_0:script(PlayerBase.PLAYER_INFO_HUD)
  if not hud then
    return 
  end
  local panel = hud.objectives_panel:child(l_177_1.text)
  local amount = panel:child("amount" .. l_177_1.id)
  amount:set_text(l_177_1.current_amount .. " / " .. l_177_1.amount .. " " .. l_177_1.amount_text)
end

HUDManager.complete_objective = function(l_178_0, l_178_1)
  local hud = l_178_0:script(PlayerBase.PLAYER_INFO_HUD)
  if not hud then
    return 
  end
  if l_178_1.remove then
    hud.objectives_panel:child(l_178_1.text):animate(hud.remove_objective)
  else
    hud.objectives_panel:child(l_178_1.text):animate(hud.complete_objective)
  end
end

HUDManager.clear_objectives = function(l_179_0)
  local hud = l_179_0:script(PlayerBase.PLAYER_INFO_HUD)
  if not hud then
    return 
  end
  local to = #hud.objectives_panel:children() - 1
  for i = 1, to do
    hud.objectives_panel:remove(hud.objectives_panel:child(1))
  end
end

HUDManager.show_stats_screen = function(l_180_0)
  local safe = l_180_0.STATS_SCREEN_SAFERECT
  local full = l_180_0.STATS_SCREEN_FULLSCREEN
  if not l_180_0:exists(safe) then
    l_180_0:load_hud(safe, false, true, true, {})
    l_180_0:load_hud(full, false, true, false, {})
  end
  l_180_0:script(safe):layout()
  managers.hud:show(safe)
  managers.hud:show(full)
  local hud = l_180_0:script(PlayerBase.PLAYER_HUD)
  if hud then
    hud.secret_assignment_description:set_visible(true)
  end
  l_180_0._showing_stats_screen = true
end

HUDManager.hide_stats_screen = function(l_181_0)
  l_181_0._showing_stats_screen = false
  local safe = l_181_0.STATS_SCREEN_SAFERECT
  local full = l_181_0.STATS_SCREEN_FULLSCREEN
  if not l_181_0:exists(safe) then
    return 
  end
  l_181_0:script(safe):hide()
  managers.hud:hide(safe)
  managers.hud:hide(full)
  local hud = l_181_0:script(PlayerBase.PLAYER_HUD)
  if hud then
    hud.secret_assignment_description:set_visible(false)
  end
end

HUDManager.showing_stats_screen = function(l_182_0)
  return l_182_0._showing_stats_screen
end

HUDManager.set_danger_visible = function(l_183_0, l_183_1, l_183_2)
  local hud = l_183_0:script(PlayerBase.PLAYER_HUD)
  hud.danger_zone1:set_visible(l_183_1)
  hud.danger_zone2:set_visible(l_183_1)
  do
    if not l_183_2 or not l_183_2.texture then
      local texture = not l_183_1 or "guis/textures/warning_gas"
    end
    if not l_183_0._hud.danger_zone1_flash_thread then
      l_183_0._hud.danger_zone1_flash_thread = hud.danger_zone1:animate(hud.flash_warning)
    end
    if not l_183_0._hud.danger_zone2_flash_thread then
      l_183_0._hud.danger_zone2_flash_thread = hud.danger_zone2:animate(hud.flash_warning)
    end
    hud.danger_zone1:set_image(texture)
    hud.danger_zone2:set_image(texture)
  end
  do return end
  if l_183_0._hud.danger_zone1_flash_thread then
    hud.ammo_warning_text:stop(l_183_0._hud.danger_zone1_flash_thread)
    l_183_0._hud.danger_zone1_flash_thread = nil
  end
  if l_183_0._hud.danger_zone2_flash_thread then
    hud.ammo_warning_text:stop(l_183_0._hud.danger_zone2_flash_thread)
    l_183_0._hud.danger_zone2_flash_thread = nil
  end
end

HUDManager.pd_start_progress = function(l_184_0, l_184_1, l_184_2, l_184_3, l_184_4)
  local hud = l_184_0:script(PlayerBase.PLAYER_DOWNED_HUD)
  if not hud then
    return 
  end
  l_184_0._pd2_hud_interaction = HUDInteraction:new(managers.hud:script(PlayerBase.PLAYER_DOWNED_HUD))
  l_184_0._pd2_hud_interaction:show_interact({text = utf8.to_upper(managers.localization:text(l_184_3))})
  l_184_0._pd2_hud_interaction:show_interaction_bar(l_184_1, l_184_2)
  l_184_0._hud_player_downed:hide_timer()
  local feed_circle = function(l_1_0, l_1_1)
    local t = 0
    repeat
      if t < l_1_1 then
        t = t + coroutine.yield()
        self._pd2_hud_interaction:set_interaction_bar_width(t, l_1_1)
      else
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  l_184_0._pd2_hud_interaction._interact_circle._circle:stop()
  l_184_0._pd2_hud_interaction._interact_circle._circle:animate(feed_circle, l_184_2)
end

HUDManager.pd_stop_progress = function(l_185_0)
  local hud = l_185_0:script(PlayerBase.PLAYER_DOWNED_HUD)
  if not hud then
    return 
  end
  if l_185_0._pd2_hud_interaction then
    l_185_0._pd2_hud_interaction:destroy()
    l_185_0._pd2_hud_interaction = nil
  end
  l_185_0._hud_player_downed:show_timer()
end

HUDManager.pd_start_timer = function(l_186_0, l_186_1)
  l_186_0:pd_stop_timer()
  local time = l_186_1.time or 10
  local hud = managers.hud:script(PlayerBase.PLAYER_DOWNED_HUD)
  l_186_0._hud.timer_thread = hud.timer:animate(hud.start_timer, time)
  l_186_0._hud_player_downed:hide_arrest_finished()
end

HUDManager.pd_pause_timer = function(l_187_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_DOWNED_HUD)
  hud.pause_timer()
end

HUDManager.pd_unpause_timer = function(l_188_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_DOWNED_HUD)
  hud.unpause_timer()
end

HUDManager.pd_stop_timer = function(l_189_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_DOWNED_HUD)
  if l_189_0._hud.timer_thread then
    hud.timer:stop(l_189_0._hud.timer_thread)
    l_189_0._hud.timer_thread = nil
  end
  hud.unpause_timer()
end

HUDManager.pd_show_text = function(l_190_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_DOWNED_HUD)
  l_190_0._hud_player_downed:hide_timer()
  l_190_0._hud_player_downed:show_arrest_finished()
end

HUDManager.pd_hide_text = function(l_191_0)
  local hud = managers.hud:script(PlayerBase.PLAYER_DOWNED_HUD)
  l_191_0._hud_player_downed:hide_arrest_finished()
end

HUDManager.on_simulation_ended = function(l_192_0)
  l_192_0:remove_updator("point_of_no_return")
  l_192_0:end_assault()
end

HUDManager.debug_show_coordinates = function(l_193_0)
  if l_193_0._debug then
    return 
  end
  l_193_0._debug = {}
  l_193_0._debug.ws = Overlay:newgui():create_screen_workspace()
  l_193_0._debug.panel = l_193_0._debug.ws:panel()
  l_193_0._debug.coord = l_193_0._debug.panel:text({name = "debug_coord", x = 14, y = 14, text = "", font = tweak_data.hud.small_font, font_size = 14, color = Color.white, layer = 2000})
end

HUDManager.debug_hide_coordinates = function(l_194_0)
  if not l_194_0._debug then
    return 
  end
  Overlay:newgui():destroy_workspace(l_194_0._debug.ws)
  l_194_0._debug = nil
end

HUDManager.save = function(l_195_0, l_195_1)
  local state = {waypoints = {}, in_assault = l_195_0._hud.in_assault}
  for id,data in pairs(l_195_0._hud.waypoints) do
    if not data.no_sync then
      state.waypoints[id] = data.init_data
      state.waypoints[id].timer = data.timer
      state.waypoints[id].pause_timer = data.pause_timer
      state.waypoints[id].unit = nil
    end
  end
  l_195_1.HUDManager = state
end

HUDManager.load = function(l_196_0, l_196_1)
  local state = l_196_1.HUDManager
  for id,init_data in pairs(state.waypoints) do
    l_196_0:add_waypoint(id, init_data)
  end
  if state.in_assault then
    l_196_0:sync_start_assault()
  end
end

require("lib/managers/HUDManagerPD2")

