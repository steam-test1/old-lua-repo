-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hud\hudstageendscreen.luac 

require("lib/managers/menu/MenuBackdropGUI")
require("lib/managers/menu/WalletGuiObject")
if not HUDPackageUnlockedItem then
  HUDPackageUnlockedItem = class()
end
HUDPackageUnlockedItem.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4)
  l_1_0._panel = l_1_1:panel({w = l_1_1:w() - 20, h = l_1_1:h() * 0.5 - 15 - 10, x = 10, y = 40, alpha = 0})
  l_1_0._panel:move(0, l_1_0._panel:h() * (l_1_2 - 1))
  if l_1_2 > 2 then
    l_1_0._panel:hide()
  end
  local announcement = l_1_3.announcement
  local upgrade = l_1_3.upgrade
  local bitmap_texture = "guis/textures/pd2/endscreen/test_icon_package"
  local text_string = ""
  local blend_mode = "normal"
  if announcement then
    bitmap_texture = "guis/textures/pd2/endscreen/announcement"
    text_string = managers.localization:to_upper_text("menu_es_announcement") .. "\n" .. managers.localization:to_upper_text(announcement)
    blend_mode = "add"
  elseif upgrade then
    local upgrade_def = tweak_data.upgrades.definitions[upgrade]
    if upgrade_def then
      local category = Idstring(upgrade_def.category)
      if category == Idstring("weapon") then
        local weapon_name = managers.weapon_factory:get_weapon_name_by_factory_id(upgrade_def.factory_id)
        local weapon_class = managers.localization:text("menu_" .. tweak_data.weapon[upgrade_def.weapon_id].category)
        local weapon_category = managers.localization:text("bm_menu_" .. (tweak_data.weapon[upgrade_def.weapon_id].use_data.selection_index == 2 and "primaries" or "secondaries"))
        bitmap_texture = "guis/textures/pd2/blackmarket/icons/weapons/" .. upgrade_def.weapon_id
        text_string = managers.localization:text("menu_es_package_weapon", {weapon = utf8.to_upper(weapon_name), type = utf8.to_upper(weapon_class), category = weapon_category, INVENTORY_MENU = managers.localization:text("menu_inventory")})
      else
        if category == Idstring("armor") then
          bitmap_texture = "guis/textures/pd2/blackmarket/icons/armors/" .. upgrade_def.armor_id
          text_string = managers.localization:text("menu_es_package_armor", {armor = managers.localization:to_upper_text(upgrade_def.name_id)})
        else
          if category == Idstring("rep_upgrade") then
            bitmap_texture = "guis/textures/pd2/endscreen/" .. upgrade_def.category
            text_string = managers.localization:to_upper_text("menu_es_rep_upgrade", {point = upgrade_def.value or 2})
            blend_mode = "add"
            l_1_4:give_skill_points(upgrade_def.value or 2)
          else
            bitmap_texture = "guis/textures/pd2/endscreen/" .. upgrade_def.category
          end
        else
          Application:debug("HUDPackageUnlockedItem: Something something unknown")
        end
      end
    end
  end
  local bitmap = l_1_0._panel:bitmap({texture = bitmap_texture, blend_mode = blend_mode})
  local tw = bitmap:texture_width()
  local th = bitmap:texture_height()
  if th ~= 0 then
    local ratio = tw / th
    local size = l_1_0._panel:h() - 10
    local sw = math.max(size, size * ratio)
    local sh = math.max(size, size / ratio)
    bitmap:set_size(sw, sh)
    bitmap:set_center_x(l_1_0._panel:h() - 5)
    bitmap:set_center_y(l_1_0._panel:h() / 2)
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    local text = l_1_0._panel:text({font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size})
    text:grow(-text:x() - 5, -text:y() - 5)
    {font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size}.word_wrap, {font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size}.wrap, {font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size}.vertical, {font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size}.y, {font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size}.x, {font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size}.text, {font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size}.color = true, true, "center", bitmap:top(), bitmap:right() + 10, text_string, tweak_data.screen_colors.text
    local _, _, _, h = text:text_rect()
    if text:h() < h then
      text:set_font(tweak_data.menu.pd2_small_font_id)
      text:set_font_size(tweak_data.menu.pd2_small_font_size)
    end
  end
  l_1_0._panel:animate(callback(l_1_0, l_1_0, "create_animation"))
end

HUDPackageUnlockedItem.create_animation = function(l_2_0)
  managers.menu_component:post_event("stinger_new_weapon")
  over(0.30000001192093, function(l_1_0)
    self._panel:set_alpha(math.lerp(0, 1, l_1_0))
   end)
end

HUDPackageUnlockedItem.destroy_animation = function(l_3_0)
  over(0.10000000149012, function(l_1_0)
    self._panel:set_alpha(math.lerp(1, 0.20000000298023, l_1_0))
   end)
  over(0.30000001192093, function(l_2_0)
    self._panel:set_alpha(math.lerp(0.20000000298023, 0, l_2_0))
   end)
  l_3_0._panel:parent():remove(l_3_0._panel)
  l_3_0._panel = nil
end

HUDPackageUnlockedItem.close = function(l_4_0)
  if not alive(l_4_0._panel) then
    return 
  end
  l_4_0._panel:stop()
  l_4_0._panel:animate(callback(l_4_0, l_4_0, "destroy_animation"))
end

if not HUDStageEndScreen then
  HUDStageEndScreen = class()
end
HUDStageEndScreen.init = function(l_5_0, l_5_1, l_5_2)
  l_5_0._backdrop = MenuBackdropGUI:new(l_5_2)
  l_5_0._backdrop:create_black_borders()
  l_5_0._hud = l_5_1
  l_5_0._workspace = l_5_2
  l_5_0._singleplayer = Global.game_settings.single_player
  local bg_font = tweak_data.menu.pd2_massive_font
  local title_font = tweak_data.menu.pd2_large_font
  local content_font = tweak_data.menu.pd2_medium_font
  local small_font = tweak_data.menu.pd2_small_font
  local bg_font_size = tweak_data.menu.pd2_massive_font_size
  local title_font_size = tweak_data.menu.pd2_large_font_size
  local content_font_size = tweak_data.menu.pd2_medium_font_size
  local small_font_size = tweak_data.menu.pd2_small_font_size
  l_5_0._background_layer_safe = l_5_0._backdrop:get_new_background_layer()
  l_5_0._background_layer_full = l_5_0._backdrop:get_new_background_layer()
  l_5_0._foreground_layer_safe = l_5_0._backdrop:get_new_foreground_layer()
  l_5_0._foreground_layer_full = l_5_0._backdrop:get_new_foreground_layer()
  l_5_0._backdrop:set_panel_to_saferect(l_5_0._background_layer_safe)
  l_5_0._backdrop:set_panel_to_saferect(l_5_0._foreground_layer_safe)
  if managers.job:has_active_job() then
    local current_contact_data = managers.job:current_contact_data()
    local contact_gui = l_5_0._background_layer_full:gui(current_contact_data.assets_gui, {empty = true})
    if contact_gui:has_script() then
      local contact_pattern = contact_gui:script().pattern
    end
    if contact_pattern then
      l_5_0._backdrop:set_pattern(contact_pattern)
    end
  end
  l_5_0._stage_name = managers.job:current_level_id() and managers.localization:to_upper_text(tweak_data.levels[managers.job:current_level_id()].name_id) or ""
  l_5_0._foreground_layer_safe:text({name = "stage_text", text = l_5_0._stage_name, h = title_font_size, align = "left", vertical = "center", font_size = title_font_size, font = title_font, color = tweak_data.screen_colors.text})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local bg_text = l_5_0._background_layer_full:text({name = "stage_text", text = l_5_0._stage_name})
  bg_text:set_world_center_y(l_5_0._foreground_layer_safe:child("stage_text"):world_center_y())
  {name = "stage_text", text = l_5_0._stage_name}.alpha, {name = "stage_text", text = l_5_0._stage_name}.color, {name = "stage_text", text = l_5_0._stage_name}.font, {name = "stage_text", text = l_5_0._stage_name}.font_size, {name = "stage_text", text = l_5_0._stage_name}.vertical, {name = "stage_text", text = l_5_0._stage_name}.align, {name = "stage_text", text = l_5_0._stage_name}.h = 0.40000000596046, tweak_data.screen_colors.button_stage_3, bg_font, bg_font_size, "top", "left", bg_font_size
  bg_text:set_world_x(l_5_0._foreground_layer_safe:child("stage_text"):world_x())
  bg_text:move(-13, 9)
  l_5_0._backdrop:animate_bg_text(bg_text)
  l_5_0._lp_backpanel = l_5_0._background_layer_safe:panel({name = "lp_backpanel", w = l_5_0._background_layer_safe:w() / 2 - 10, h = l_5_0._background_layer_safe:h() / 2, y = 70})
  l_5_0._lp_forepanel = l_5_0._foreground_layer_safe:panel({name = "lp_forepanel", w = l_5_0._foreground_layer_safe:w() / 2 - 10, h = l_5_0._foreground_layer_safe:h() / 2, y = 70})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_5_0._lp_forepanel:text({name = "level_progress_text", text = managers.localization:to_upper_text("menu_es_level_progress"), align = "left", vertical = "top"})
  {name = "level_progress_text", text = managers.localization:to_upper_text("menu_es_level_progress"), align = "left", vertical = "top"}.y, {name = "level_progress_text", text = managers.localization:to_upper_text("menu_es_level_progress"), align = "left", vertical = "top"}.x, {name = "level_progress_text", text = managers.localization:to_upper_text("menu_es_level_progress"), align = "left", vertical = "top"}.color, {name = "level_progress_text", text = managers.localization:to_upper_text("menu_es_level_progress"), align = "left", vertical = "top"}.font, {name = "level_progress_text", text = managers.localization:to_upper_text("menu_es_level_progress"), align = "left", vertical = "top"}.font_size, {name = "level_progress_text", text = managers.localization:to_upper_text("menu_es_level_progress"), align = "left", vertical = "top"}.h = 10, 10, tweak_data.screen_colors.text, content_font, content_font_size, content_font_size + 2
  local lp_bg_circle = l_5_0._lp_backpanel:bitmap({name = "bg_progress_circle", texture = "guis/textures/pd2/endscreen/exp_ring", h = l_5_0._lp_backpanel:h() - content_font_size, w = l_5_0._lp_backpanel:h() - content_font_size, y = content_font_size, color = Color.black, alpha = 0.60000002384186, blend_mode = "normal"})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_5_0._lp_circle, {name = "progress_circle", texture = "guis/textures/pd2/endscreen/exp_ring"}.layer, {name = "progress_circle", texture = "guis/textures/pd2/endscreen/exp_ring"}.blend_mode, {name = "progress_circle", texture = "guis/textures/pd2/endscreen/exp_ring"}.render_template, {name = "progress_circle", texture = "guis/textures/pd2/endscreen/exp_ring"}.color, {name = "progress_circle", texture = "guis/textures/pd2/endscreen/exp_ring"}.y, {name = "progress_circle", texture = "guis/textures/pd2/endscreen/exp_ring"}.w, {name = "progress_circle", texture = "guis/textures/pd2/endscreen/exp_ring"}.h = l_5_0._lp_backpanel:bitmap({name = "progress_circle", texture = "guis/textures/pd2/endscreen/exp_ring"}), 1, "add", "VertexColorTexturedRadial", Color(0, 1, 1), content_font_size, l_5_0._lp_backpanel:h() - content_font_size, l_5_0._lp_backpanel:h() - content_font_size
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_5_0._lp_text, {name = "level_text", text = "", align = "center", vertical = "center"}.color, {name = "level_text", text = "", align = "center", vertical = "center"}.y, {name = "level_text", text = "", align = "center", vertical = "center"}.w, {name = "level_text", text = "", align = "center", vertical = "center"}.h, {name = "level_text", text = "", align = "center", vertical = "center"}.font, {name = "level_text", text = "", align = "center", vertical = "center"}.font_size = l_5_0._lp_forepanel:text({name = "level_text", text = "", align = "center", vertical = "center"}), tweak_data.screen_colors.text, content_font_size, l_5_0._lp_backpanel:h() - content_font_size, l_5_0._lp_backpanel:h() - content_font_size, bg_font, bg_font_size
  l_5_0._lp_curr_xp = l_5_0._lp_forepanel:text({name = "current_xp", text = managers.localization:to_upper_text("menu_es_current_xp"), align = "left", vertical = "center", h = small_font_size, font_size = small_font_size, font = small_font, color = tweak_data.screen_colors.text})
  l_5_0._lp_xp_gained = l_5_0._lp_forepanel:text({name = "xp_gained", text = managers.localization:to_upper_text("menu_es_xp_gained"), align = "left", vertical = "center", h = content_font_size, font_size = content_font_size, font = content_font, color = tweak_data.screen_colors.text})
  l_5_0._lp_next_level = l_5_0._lp_forepanel:text({name = "next_level", text = managers.localization:to_upper_text("menu_es_next_level"), align = "left", vertical = "center", h = small_font_size, font_size = small_font_size, font = small_font, color = tweak_data.screen_colors.text})
  l_5_0._lp_skill_points = l_5_0._lp_forepanel:text({name = "skill_points", text = managers.localization:to_upper_text("menu_es_skill_points_gained"), align = "left", vertical = "center", h = small_font_size, font_size = small_font_size, font = small_font, color = tweak_data.screen_colors.text})
  l_5_0._lp_xp_curr = l_5_0._lp_forepanel:text({name = "c_xp", text = "", align = "left", vertical = "top", h = small_font_size, font_size = small_font_size, font = small_font, color = tweak_data.screen_colors.text})
  l_5_0._lp_xp_gain = l_5_0._lp_forepanel:text({name = "xp_g", text = "", align = "left", vertical = "top", h = content_font_size, font_size = content_font_size, font = content_font, color = tweak_data.screen_colors.text})
  l_5_0._lp_xp_nl = l_5_0._lp_forepanel:text({name = "xp_nl", text = "", align = "left", vertical = "top", h = small_font_size, font_size = small_font_size, font = small_font, color = tweak_data.screen_colors.text})
  l_5_0._lp_sp_gain = l_5_0._lp_forepanel:text({name = "sp_g", text = "0", align = "left", vertical = "center", h = small_font_size, font_size = small_font_size, font = small_font, color = tweak_data.screen_colors.text})
  local _, _, cw, ch = l_5_0._lp_curr_xp:text_rect()
  local _, _, gw, gh = l_5_0._lp_xp_gained:text_rect()
  local _, _, nw, nh = l_5_0._lp_next_level:text_rect()
  local _, _, sw, sh = l_5_0._lp_skill_points:text_rect()
  local w = math.ceil(math.max(cw, gw, nw, sw)) + 20
  local squeeze_more_pixels = false
  if SystemInfo:platform() ~= Idstring("WIN32") and w > 170 then
    w = 170
    squeeze_more_pixels = true
  end
  l_5_0._num_skill_points_gained = 0
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_5_0._lp_sp_info, {name = "sp_info", text = managers.localization:text("menu_es_skill_points_info", {SKILL_MENU = managers.localization:to_upper_text("menu_skilltree")}), align = "left", vertical = "top"}.word_wrap, {name = "sp_info", text = managers.localization:text("menu_es_skill_points_info", {SKILL_MENU = managers.localization:to_upper_text("menu_skilltree")}), align = "left", vertical = "top"}.wrap, {name = "sp_info", text = managers.localization:text("menu_es_skill_points_info", {SKILL_MENU = managers.localization:to_upper_text("menu_skilltree")}), align = "left", vertical = "top"}.color, {name = "sp_info", text = managers.localization:text("menu_es_skill_points_info", {SKILL_MENU = managers.localization:to_upper_text("menu_skilltree")}), align = "left", vertical = "top"}.font, {name = "sp_info", text = managers.localization:text("menu_es_skill_points_info", {SKILL_MENU = managers.localization:to_upper_text("menu_skilltree")}), align = "left", vertical = "top"}.font_size, {name = "sp_info", text = managers.localization:text("menu_es_skill_points_info", {SKILL_MENU = managers.localization:to_upper_text("menu_skilltree")}), align = "left", vertical = "top"}.h = l_5_0._lp_forepanel:text({name = "sp_info", text = managers.localization:text("menu_es_skill_points_info", {SKILL_MENU = managers.localization:to_upper_text("menu_skilltree")}), align = "left", vertical = "top"}), true, true, tweak_data.screen_colors.text, small_font, small_font_size, small_font_size
  l_5_0._lp_sp_info:grow(-l_5_0._lp_circle:right() - 20, 0)
  local _, _, iw, ih = l_5_0._lp_sp_info:text_rect()
  l_5_0._lp_sp_info:set_h(ih)
  l_5_0._lp_sp_info:set_leftbottom(l_5_0._lp_circle:right() + 0, l_5_0._lp_forepanel:h() - 10)
  l_5_0._lp_skill_points:set_h(sh)
  l_5_0._lp_skill_points:set_left(l_5_0._lp_sp_info:left())
  l_5_0._lp_skill_points:set_bottom(l_5_0._lp_sp_info:top())
  l_5_0._lp_sp_gain:set_h(sh)
  l_5_0._lp_sp_gain:set_left(l_5_0._lp_skill_points:left() + w)
  l_5_0._lp_sp_gain:set_top(l_5_0._lp_skill_points:top())
  l_5_0._lp_next_level:set_h(nh)
  l_5_0._lp_next_level:set_left(l_5_0._lp_sp_info:left())
  l_5_0._lp_next_level:set_bottom(l_5_0._lp_skill_points:top())
  l_5_0._lp_xp_nl:set_h(nh)
  l_5_0._lp_xp_nl:set_left(l_5_0._lp_next_level:left() + w)
  l_5_0._lp_xp_nl:set_top(l_5_0._lp_next_level:top())
  l_5_0._lp_curr_xp:set_left(l_5_0._lp_sp_info:left())
  l_5_0._lp_curr_xp:set_bottom(l_5_0._lp_next_level:top())
  l_5_0._lp_curr_xp:set_h(gh)
  l_5_0._lp_xp_curr:set_left(l_5_0._lp_curr_xp:left() + w)
  l_5_0._lp_xp_curr:set_top(l_5_0._lp_curr_xp:top())
  l_5_0._lp_xp_curr:set_h(ch)
  l_5_0._lp_xp_gained:set_left(l_5_0._lp_curr_xp:left())
  l_5_0._lp_xp_gained:set_h(ch)
  l_5_0._lp_xp_gain:set_left(l_5_0._lp_xp_gained:x() + w + 5)
  l_5_0._lp_xp_gain:set_h(gh)
  if squeeze_more_pixels then
    lp_bg_circle:move(-20, 0)
    l_5_0._lp_circle:move(-20, 0)
    l_5_0._lp_text:move(-20, 0)
    l_5_0._lp_curr_xp:move(-30, 0)
    l_5_0._lp_xp_gained:move(-30, 0)
    l_5_0._lp_next_level:move(-30, 0)
    l_5_0._lp_skill_points:move(-30, 0)
    l_5_0._lp_sp_info:move(-30, 0)
  end
  l_5_0._box = BoxGuiObject:new(l_5_0._lp_backpanel, {sides = {1, 1, 1, 1}})
  WalletGuiObject.set_wallet(l_5_0._foreground_layer_safe)
  l_5_0._package_forepanel = l_5_0._foreground_layer_safe:panel({name = "package_forepanel", w = l_5_0._foreground_layer_safe:w() / 2 - 10, h = l_5_0._foreground_layer_safe:h() / 2 - 70 - 10, y = 70, alpha = 0})
  l_5_0._package_forepanel:set_right(l_5_0._foreground_layer_safe:w())
  l_5_0._package_forepanel:text({name = "title_text", font = content_font, font_size = content_font_size, text = "", x = 10, y = 10})
  local package_box_panel = l_5_0._foreground_layer_safe:panel()
  package_box_panel:set_shape(l_5_0._package_forepanel:shape())
  package_box_panel:set_layer(l_5_0._package_forepanel:layer())
  l_5_0._package_box = BoxGuiObject:new(package_box_panel, {sides = {1, 1, 1, 1}})
  l_5_0._package_items = {}
  l_5_0:clear_stage()
  if l_5_0._data then
    l_5_0:start_experience_gain()
  end
end

HUDStageEndScreen.hide = function(l_6_0)
  l_6_0._backdrop:hide()
end

HUDStageEndScreen.show = function(l_7_0)
  l_7_0._backdrop:show()
end

HUDStageEndScreen.update_layout = function(l_8_0)
  l_8_0._backdrop:_set_black_borders()
end

HUDStageEndScreen.spawn_animation = function(l_9_0, l_9_1, l_9_2, l_9_3)
  wait(l_9_2 or 0)
  if l_9_3 then
    managers.menu_component:post_event(l_9_3)
  end
  over(0.5, function(l_1_0)
    o:set_alpha(l_1_0)
   end)
end

HUDStageEndScreen.destroy_animation = function(l_10_0, l_10_1, l_10_2, l_10_3)
  wait(l_10_2 or 0)
  local start_alpha = l_10_1:alpha()
  over(0.25 * (l_10_3 or 1), function(l_1_0)
    o:set_alpha(math.lerp(start_alpha, 0, l_1_0))
    if o.children then
      for _,child in ipairs(o:children()) do
        if child.set_color then
          child:set_color(math.lerp(child:color(), tweak_data.screen_colors.text, l_1_0))
          for (for control),_ in (for generator) do
          end
          for _,object in ipairs(child:children()) do
            object:set_color(math.lerp(object:color(), tweak_data.screen_colors.text, l_1_0))
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
   end)
  l_10_1:parent():remove(l_10_1)
  l_10_1 = nil
end

HUDStageEndScreen.bonus_risk = function(l_11_0, l_11_1, l_11_2, l_11_3)
  local risk_text = l_11_1:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.risk, text = managers.localization:to_upper_text("menu_es_risk_bonus")})
  local _, _, w, h = risk_text:text_rect()
  risk_text:set_size(w, h)
  l_11_1:set_h(h)
  local has_active_job = managers.job:has_active_job()
  local job_and_difficulty_stars = has_active_job and managers.job:current_job_and_difficulty_stars() or 1
  local job_stars = has_active_job and managers.job:current_job_stars() or 1
  local difficulty_stars = job_and_difficulty_stars - job_stars
  l_11_1:animate(callback(l_11_0, l_11_0, "spawn_animation"), l_11_2, "box_tick")
  local sign_text = l_11_1:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.risk, text = "+", alpha = 0, align = "right"})
  sign_text:set_world_right(l_11_0._lp_xp_curr:world_left())
  sign_text:animate(callback(l_11_0, l_11_0, "spawn_animation"), l_11_2, false)
  local value_text = l_11_1:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.risk, text = managers.money:add_decimal_marks_to_string(tostring(math.abs(l_11_3))), alpha = 0})
  value_text:set_world_left(l_11_0._lp_xp_curr:world_left())
  value_text:animate(callback(l_11_0, l_11_0, "spawn_animation"), l_11_2, false)
  return l_11_2
end

HUDStageEndScreen.bonus_days = function(l_12_0, l_12_1, l_12_2, l_12_3)
  local text = l_12_1:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, text = managers.localization:to_upper_text("menu_es_day_bonus")})
  local _, _, w, h = text:text_rect()
  l_12_1:set_h(h)
  text:set_size(w, h)
  text:set_center_y(l_12_1:h() / 2)
  text:set_position(math.round(text:x()), math.round(text:y()))
  l_12_1:animate(callback(l_12_0, l_12_0, "spawn_animation"), l_12_2, "box_tick")
  local sign_text = l_12_1:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, text = "+", alpha = 0, align = "right"})
  sign_text:set_world_right(l_12_0._lp_xp_curr:world_left())
  sign_text:animate(callback(l_12_0, l_12_0, "spawn_animation"), l_12_2 + 0, false)
  local value_text = l_12_1:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, text = managers.money:add_decimal_marks_to_string(tostring(math.abs(l_12_3))), alpha = 0})
  value_text:set_world_left(l_12_0._lp_xp_curr:world_left())
  value_text:animate(callback(l_12_0, l_12_0, "spawn_animation"), l_12_2 + 0, false)
  return l_12_2 + 0
end

HUDStageEndScreen.bonus_skill = function(l_13_0, l_13_1, l_13_2, l_13_3)
  local text = l_13_1:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, text = managers.localization:to_upper_text("menu_es_skill_bonus")})
  local _, _, w, h = text:text_rect()
  l_13_1:set_h(h)
  text:set_size(w, h)
  text:set_center_y(l_13_1:h() / 2)
  text:set_position(math.round(text:x()), math.round(text:y()))
  l_13_1:animate(callback(l_13_0, l_13_0, "spawn_animation"), l_13_2, "box_tick")
  local sign_text = l_13_1:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, text = "+", alpha = 0, align = "right"})
  sign_text:set_world_right(l_13_0._lp_xp_curr:world_left())
  sign_text:animate(callback(l_13_0, l_13_0, "spawn_animation"), l_13_2 + 0, false)
  local value_text = l_13_1:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, text = managers.money:add_decimal_marks_to_string(tostring(math.abs(l_13_3))), alpha = 0})
  value_text:set_world_left(l_13_0._lp_xp_curr:world_left())
  value_text:animate(callback(l_13_0, l_13_0, "spawn_animation"), l_13_2 + 0, false)
  return l_13_2 + 0
end

HUDStageEndScreen.bonus_num_players = function(l_14_0, l_14_1, l_14_2, l_14_3)
  local text = l_14_1:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, text = managers.localization:to_upper_text("menu_es_alive_players_bonus")})
  local _, _, w, h = text:text_rect()
  l_14_1:set_h(h)
  text:set_size(w, h)
  text:set_center_y(l_14_1:h() / 2)
  text:set_position(math.round(text:x()), math.round(text:y()))
  l_14_1:animate(callback(l_14_0, l_14_0, "spawn_animation"), l_14_2, "box_tick")
  local sign_text = l_14_1:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, text = "+", alpha = 0, align = "right"})
  sign_text:set_world_right(l_14_0._lp_xp_curr:world_left())
  sign_text:animate(callback(l_14_0, l_14_0, "spawn_animation"), l_14_2 + 0, false)
  local value_text = l_14_1:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, text = managers.money:add_decimal_marks_to_string(tostring(math.abs(l_14_3))), alpha = 0})
  value_text:set_world_left(l_14_0._lp_xp_curr:world_left())
  value_text:animate(callback(l_14_0, l_14_0, "spawn_animation"), l_14_2 + 0, false)
  return l_14_2 + 0
end

HUDStageEndScreen.bonus_failed = function(l_15_0, l_15_1, l_15_2, l_15_3)
  local text = l_15_1:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.important_1, text = managers.localization:to_upper_text("menu_es_alive_failed_bonus")})
  local _, _, w, h = text:text_rect()
  l_15_1:set_h(h)
  text:set_size(w, h)
  text:set_center_y(l_15_1:h() / 2)
  text:set_position(math.round(text:x()), math.round(text:y()))
  l_15_1:animate(callback(l_15_0, l_15_0, "spawn_animation"), l_15_2, "box_tick")
  local sign_text = l_15_1:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.important_1, text = "-", alpha = 0, align = "right"})
  sign_text:set_world_right(l_15_0._lp_xp_curr:world_left())
  sign_text:animate(callback(l_15_0, l_15_0, "spawn_animation"), l_15_2 + 0, false)
  local value_text = l_15_1:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.important_1, text = managers.money:add_decimal_marks_to_string(tostring(math.abs(l_15_3))), alpha = 0})
  value_text:set_world_left(l_15_0._lp_xp_curr:world_left())
  value_text:animate(callback(l_15_0, l_15_0, "spawn_animation"), l_15_2 + 0, false)
  return l_15_2 + 0
end

HUDStageEndScreen.bonus_low_level = function(l_16_0, l_16_1, l_16_2, l_16_3)
  local text = l_16_1:text({5; font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, text = managers.localization:to_upper_text("menu_es_alive_low_level_bonus")})
  local _, _, w, h = text:text_rect()
  l_16_1:set_h(h)
  text:set_size(w, h)
  text:set_center_y(l_16_1:h() / 2)
  text:set_position(math.round(text:x()), math.round(text:y()))
  l_16_1:animate(callback(l_16_0, l_16_0, "spawn_animation"), l_16_2, "box_tick")
  local sign_text = l_16_1:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, text = "-", alpha = 0, align = "right"})
  sign_text:set_world_right(l_16_0._lp_xp_curr:world_left())
  sign_text:animate(callback(l_16_0, l_16_0, "spawn_animation"), l_16_2 + 0, false)
  local value_text = l_16_1:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, text = managers.money:add_decimal_marks_to_string(tostring(math.abs(l_16_3))), alpha = 0})
  value_text:set_world_left(l_16_0._lp_xp_curr:world_left())
  value_text:animate(callback(l_16_0, l_16_0, "spawn_animation"), l_16_2 + 0, false)
  return l_16_2 + 0
end

HUDStageEndScreen.start_experience_gain = function(l_17_0)
  l_17_0:reset_stage()
end

HUDStageEndScreen.clear_stage = function(l_18_0)
  l_18_0._wait_t = nil
  l_18_0._csl = nil
  l_18_0._all_done = nil
  l_18_0._playing_sound = nil
  l_18_0._lp_text:hide()
  l_18_0._lp_circle:hide()
  l_18_0._lp_backpanel:child("bg_progress_circle"):hide()
  l_18_0._lp_forepanel:child("level_progress_text"):hide()
  l_18_0._lp_curr_xp:hide()
  l_18_0._lp_xp_gained:hide()
  l_18_0._lp_next_level:hide()
  l_18_0._lp_skill_points:hide()
  l_18_0._lp_sp_info:hide()
  l_18_0._lp_xp_gain:hide()
  l_18_0._lp_xp_curr:hide()
  l_18_0._lp_xp_nl:hide()
  l_18_0._lp_sp_gain:hide()
  l_18_0._lp_text:set_text(tostring(l_18_0._data and l_18_0._data.start_t.level or 0))
  l_18_0:reset_skill_points()
  if l_18_0._background_layer_full:child("money_video") then
    l_18_0._background_layer_full:child("money_video"):stop()
    l_18_0._background_layer_full:remove(l_18_0._background_layer_full:child("money_video"))
  end
  if l_18_0._money_panel then
    l_18_0._money_panel:parent():remove(l_18_0._money_panel)
    l_18_0._money_panel = nil
  end
  WalletGuiObject.set_object_visible("wallet_level_icon", false)
  WalletGuiObject.set_object_visible("wallet_level_text", false)
  WalletGuiObject.set_object_visible("wallet_money_icon", false)
  WalletGuiObject.set_object_visible("wallet_money_text", false)
  WalletGuiObject.set_object_visible("wallet_skillpoint_icon", false)
  WalletGuiObject.set_object_visible("wallet_skillpoint_text", false)
end

HUDStageEndScreen.stop_stage = function(l_19_0)
  l_19_0:clear_stage()
  l_19_0._stage = 0
end

HUDStageEndScreen.reset_stage = function(l_20_0)
  l_20_0:clear_stage()
  l_20_0._stage = 1
end

HUDStageEndScreen.step_stage_up = function(l_21_0)
  l_21_0._stage = l_21_0._stage + 1
end

HUDStageEndScreen.step_stage_down = function(l_22_0)
  l_22_0._stage = l_22_0._stage - 1
end

HUDStageEndScreen.step_stage_to_start = function(l_23_0)
  l_23_0._stage = 1
end

HUDStageEndScreen.step_stage_to_end = function(l_24_0)
  l_24_0._stage = #l_24_0.stages
end

HUDStageEndScreen._wait_for_video = function(l_25_0)
  local time = 0
  local video = l_25_0._background_layer_full:child("money_video")
  local length = video:length()
  local fade_t = 1
  local alpha = 0
  repeat
    if alive(video) and video:loop_count() == 0 then
      local dt = coroutine.yield()
      do
        time = time + dt
        video:set_alpha(math.min(time, 1) * 0.20000000298023)
      end
    else
      if alive(video) then
        local start_alpha = video:alpha()
        over(0.25, function(l_1_0)
          video:set_alpha(math.lerp(start_alpha, 0, l_1_0))
            end)
        video:parent():remove(video)
        video = nil
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HUDStageEndScreen.create_money_counter = function(l_26_0, l_26_1, l_26_2)
  if game_state_machine:current_state().is_success then
    local is_success = game_state_machine:current_state():is_success()
  end
  l_26_0._is_fail_video = not is_success
  if SystemInfo:platform() ~= Idstring("X360") then
    if l_26_0._is_fail_video then
      local variant = math.random(2)
      local video = l_26_0._background_layer_full:video({name = "money_video", video = "movies/fail_stage" .. tostring(variant), alpha = 0, width = 1280, height = 720, blend_mode = "add", loop = false})
      video:animate((callback(l_26_0, l_26_0, "_wait_for_video")), nil)
    else
      local variant = 0
      local video = l_26_0._background_layer_full:video({name = "money_video", video = "movies/money_count" .. tostring(variant), alpha = 0, width = 1280, height = 720, blend_mode = "add", loop = true})
      video:animate(callback(l_26_0, l_26_0, "spawn_animation"), 1, false)
    end
  end
  l_26_0._money_panel = l_26_0._lp_forepanel:panel({name = "money_panel", x = 10, y = 10})
  l_26_0._money_panel:grow(-20, -20)
  local stage_payout, job_payout, bag_payout, small_loot_payout, crew_payout = managers.money:get_payouts()
  local check_if_clear = function(l_1_0)
    for _,d in ipairs(l_1_0) do
      if d[2] and d[2] > 0 then
        return false
      end
    end
    return true
   end
  l_26_0._money = {}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  l_26_0._money.income = {{}, {}, {}, {}, {}; name_id = math.round(crew_payout or 0).localization:to_upper_text("menu_cash_income", {money = ""})}
  if check_if_clear(l_26_0._money.income) then
    l_26_0._money.income = {}
  end
  l_26_0._money.costs = {name_id = managers.localization:to_upper_text("menu_cash_costs", {money = ""})}
  if check_if_clear(l_26_0._money.costs) then
    l_26_0._money.costs = {}
  end
  local spending_earned = managers.money:heist_spending()
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
l_26_0._money.balance = {{}, {math.round(managers.money:heist_offshore()), math.round(spending_earned), tweak_data.screen_colors.pro_color}; name_id = managers.localization:to_upper_text("menu_cash_balance", {money = ""})}
if check_if_clear(l_26_0._money.balance) then
  l_26_0._money.balance = {}
end
l_26_0._money_stage = {"income", "costs", "balance"}
l_26_0._money_stage_index = 1
l_26_0._money_index = 0
l_26_0._money_text_y = 10
l_26_0._start_count_money = false
l_26_0._counting_money = false
l_26_0._money_counting_amount = 0
l_26_0._wait_t = l_26_1 + 1
l_26_0:step_stage_up()
l_26_0._debug_m = nil
end

HUDStageEndScreen.set_debug_m = function(l_27_0, l_27_1)
  return 
  if l_27_0._debug_m ~= l_27_1 then
    l_27_0._debug_m = l_27_1
    Application:debug(l_27_1)
  end
end

HUDStageEndScreen.count_money = function(l_28_0, l_28_1, l_28_2)
  local money_stage = l_28_0._money_stage[l_28_0._money_stage_index]
  if money_stage then
    local money_data = l_28_0._money[money_stage]
    if money_data then
      local money_specific = money_data[l_28_0._money_index]
      if (money_specific or l_28_0._money_index == 0) and money_data.name_id then
        if l_28_0._money_index == 0 then
          local text_object = l_28_0._money_panel:text({x = 0, y = l_28_0._money_text_y, text = money_data.name_id, font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size})
          managers.hud:make_fine_text(text_object)
          text_object:grow(0, 2)
          managers.menu_component:post_event("box_tick")
          l_28_0._money_text_y = text_object:bottom()
          l_28_0._wait_t = l_28_1 + 0.64999997615814
          l_28_0._money_index = 1
        elseif l_28_0._start_count_money then
          local text_object = l_28_0._money_panel:text({name = "text" .. tostring(l_28_0._money_stage_index) .. tostring(l_28_0._money_index), x = l_28_0._money_panel:w() * 0.5, y = l_28_0._money_text_y, text = managers.experience:cash_string(0), font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size})
          managers.hud:make_fine_text(text_object)
          local dir_object = l_28_0._money_panel:text({name = "dir" .. tostring(l_28_0._money_stage_index) .. tostring(l_28_0._money_index), y = l_28_0._money_text_y, text = (money_specific[2] < 0 or money_stage == "costs") and "-" or "+", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size})
          managers.hud:make_fine_text(dir_object)
          dir_object:set_right(text_object:left())
          dir_object:hide()
          l_28_0._wait_t = l_28_1 + 0.44999998807907
          l_28_0._start_count_money = false
          l_28_0._counting_money = true
          l_28_0._money_counting_amount = 0
          l_28_0._set_count_first = true
        elseif l_28_0._counting_money then
          local text_object = l_28_0._money_panel:child("text" .. tostring(l_28_0._money_stage_index) .. tostring(l_28_0._money_index))
          local dir_object = l_28_0._money_panel:child("dir" .. tostring(l_28_0._money_stage_index) .. tostring(l_28_0._money_index))
          if l_28_0._set_count_first then
            l_28_0._set_count_first = nil
            managers.menu_component:post_event("count_1")
            dir_object:show()
          end
          l_28_0._money_counting_amount = math.round(math.step(l_28_0._money_counting_amount, money_specific[2], l_28_2 * math.max(20000, money_specific[2] / 1.5)))
          text_object:set_text(managers.experience:cash_string(math.abs(l_28_0._money_counting_amount)))
          managers.hud:make_fine_text(text_object)
          if l_28_0._money_counting_amount == money_specific[2] then
            l_28_0._counting_money = false
            l_28_0._money_index = l_28_0._money_index + 1
            l_28_0._money_text_y = text_object:bottom()
            l_28_0._wait_t = l_28_1 + 0.44999998807907
            managers.menu_component:post_event("count_1_finished")
            if not money_specific[3] then
              text_object:set_color(tweak_data.screen_colors.text)
            end
            if not money_specific[3] then
              dir_object:set_color(tweak_data.screen_colors.text)
              do return end
            end
          elseif not money_specific[2] or money_specific[2] == 0 then
            l_28_0._money_index = l_28_0._money_index + 1
          else
            local text_object = l_28_0._money_panel:text({x = 10, y = l_28_0._money_text_y, text = managers.localization:to_upper_text(money_specific[1], {money = ""}), font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size})
            managers.hud:make_fine_text(text_object)
            managers.menu_component:post_event("box_tick")
            l_28_0._start_count_money = true
          end
        else
          l_28_0._money_index = 0
          l_28_0._money_stage_index = l_28_0._money_stage_index + 1
          l_28_0._money_text_y = l_28_0._money_text_y + 15
          l_28_0._wait_t = l_28_1 + (money_data and 0 or 1)
        end
      end
    end
    return 
  end
end
WalletGuiObject.refresh()
WalletGuiObject.set_object_visible("wallet_money_icon", true)
WalletGuiObject.set_object_visible("wallet_money_text", true)
managers.menu_component:show_endscreen_cash_summary()
l_28_0._wait_t = l_28_1 + 1.25
l_28_0:step_stage_up()
end

HUDStageEndScreen.hide_money = function(l_29_0, l_29_1, l_29_2)
  Application:debug("HUDStageEndScreen:hide_money")
  if not l_29_0._is_fail_video then
    local video = l_29_0._background_layer_full:child("money_video")
    if video then
      video:animate(callback(l_29_0, l_29_0, "destroy_animation"))
    end
  end
  l_29_0._money_panel:animate(callback(l_29_0, l_29_0, "destroy_animation"))
  l_29_0._money_panel = nil
  l_29_0:step_stage_up()
end

HUDStageEndScreen.stage_init = function(l_30_0, l_30_1, l_30_2)
  local data = l_30_0._data
  l_30_0._lp_text:show()
  l_30_0._lp_circle:show()
  l_30_0._lp_backpanel:child("bg_progress_circle"):show()
  l_30_0._lp_forepanel:child("level_progress_text"):show()
  if data.gained == 0 then
    l_30_0._lp_text:set_text(tostring(data.start_t.level))
    l_30_0._lp_circle:set_color(Color(1, 1, 1))
    managers.menu_component:post_event("box_tick")
    l_30_0:step_stage_to_end()
    return 
  end
  l_30_0._lp_circle:set_alpha(0)
  l_30_0._lp_backpanel:child("bg_progress_circle"):set_alpha(0)
  l_30_0._lp_text:set_alpha(0)
  l_30_0._bonuses_panel = l_30_0._lp_forepanel:panel({x = l_30_0._lp_curr_xp:x(), y = 10})
  l_30_0._bonuses_panel:grow(-l_30_0._bonuses_panel:x(), -l_30_0._bonuses_panel:y())
  local stage_text = managers.localization:to_upper_text("menu_es_base_xp_stage")
  local base_text = l_30_0._bonuses_panel:text({name = "base_text", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, text = stage_text})
  local xp_text = l_30_0._bonuses_panel:text({name = "xp_text", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, text = managers.money:add_decimal_marks_to_string(tostring(data.bonuses.stage_xp))})
  local _, _, tw, th = base_text:text_rect()
  base_text:set_h(th)
  xp_text:set_world_left(l_30_0._lp_xp_curr:world_left())
  local delay = 0.80000001192093
  local y = math.round(base_text:bottom())
  if data.bonuses.last_stage then
    local job_text = managers.localization:to_upper_text("menu_es_base_xp_job")
    local job_xp_fade_panel = l_30_0._bonuses_panel:panel({alpha = 0})
    local base_text = job_xp_fade_panel:text({name = "base_text", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, text = job_text, y = y})
    local sign_text = job_xp_fade_panel:text({name = "sign_text", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, y = y, text = "+", align = "right"})
    local xp_text = job_xp_fade_panel:text({name = "xp_text", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, y = y, text = managers.money:add_decimal_marks_to_string(tostring(data.bonuses.job_xp))})
    local _, _, tw, th = base_text:text_rect()
    base_text:set_h(th)
    xp_text:set_world_left(l_30_0._lp_xp_curr:world_left())
    sign_text:set_world_right(l_30_0._lp_xp_curr:world_left())
    delay = 1.4500000476837
    y = math.round(base_text:bottom())
    job_xp_fade_panel:animate(callback(l_30_0, l_30_0, "spawn_animation"), 0.60000002384186, "box_tick")
  end
  local bonuses_to_string_converter = {"bonus_risk", "bonus_failed", "bonus_days", "bonus_num_players", "bonus_skill"}
  if data.bonuses.rounding_error ~= 0 then
    Application:debug("GOT A ROUNDING ERROR IN EXPERIENCE GIVING:", data.bonuses.rounding_error)
  end
  local index = 2
  for i,func_name in ipairs(bonuses_to_string_converter) do
    local bonus = data.bonuses[func_name]
    if bonus and bonus ~= 0 then
      local panel = l_30_0._bonuses_panel:panel({alpha = 0, y = y})
      delay = (callback(l_30_0, l_30_0, func_name)(panel, delay, bonus) or delay) + 0.60000002384186
      y = y + panel:h()
      index = index + 1
    end
  end
  local sum_line = l_30_0._bonuses_panel:rect({color = Color(0, 1, 1, 1), alpha = 0, h = 2})
  sum_line:set_y(y)
  l_30_0._lp_xp_gain:set_world_top(sum_line:world_top())
  if SystemInfo:platform() == Idstring("WIN32") then
    l_30_0._lp_xp_gain:move(0, l_30_0._lp_xp_gain:h())
  end
  l_30_0._lp_xp_gained:set_top(l_30_0._lp_xp_gain:top())
  local sum_text = l_30_0._bonuses_panel:text({font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, text = "= ", align = "right", alpha = 0})
  sum_text:set_world_righttop(l_30_0._lp_xp_gain:world_left(), l_30_0._lp_xp_gain:world_top())
  sum_text:animate(callback(l_30_0, l_30_0, "spawn_animation"), delay + 1, "box_tick")
  l_30_0._lp_circle:set_color(Color(data.start_t.current / data.start_t.total, 1, 1))
  l_30_0._wait_t = l_30_1 + 1
  l_30_0._start_ramp_up_t = delay
  l_30_0._ramp_up_timer = 0
  managers.menu_component:post_event("box_tick")
  l_30_0:step_stage_up()
end

HUDStageEndScreen.stage_spin_up = function(l_31_0, l_31_1, l_31_2)
  local data = l_31_0._data
  if l_31_0._start_ramp_up_t then
    l_31_0._ramp_up_timer = math.min(l_31_0._ramp_up_timer + l_31_2, l_31_0._start_ramp_up_t)
    local ratio = l_31_0._ramp_up_timer / l_31_0._start_ramp_up_t * (data.start_t.current / data.start_t.total)
    ratio = l_31_0._ramp_up_timer / l_31_0._start_ramp_up_t
    l_31_0._lp_circle:set_alpha(ratio)
    l_31_0._lp_backpanel:child("bg_progress_circle"):set_alpha(ratio * 0.60000002384186)
    l_31_0._lp_text:set_alpha(ratio)
    if l_31_0._ramp_up_timer == l_31_0._start_ramp_up_t then
      l_31_0._static_current_xp = data.start_t.xp
      l_31_0._static_gained_xp = 0
      l_31_0._static_start_xp = data.start_t.current
      l_31_0._current_xp = l_31_0._static_current_xp
      l_31_0._gained_xp = l_31_0._static_gained_xp
      l_31_0._next_level_xp = data.start_t.total - data.start_t.current
      l_31_0._speed = 1
      l_31_0._wait_t = l_31_1 + 2.4000000953674
      l_31_0._ramp_up_timer = nil
      l_31_0._start_ramp_up_t = nil
      ratio = 1
      l_31_0._lp_circle:set_alpha(ratio)
      l_31_0._lp_backpanel:child("bg_progress_circle"):set_alpha(ratio * 0.60000002384186)
      l_31_0._lp_text:set_alpha(ratio)
      l_31_0._lp_text:stop()
      l_31_0._lp_text:set_font_size(tweak_data.menu.pd2_massive_font_size)
      l_31_0._lp_text:set_text(tostring(data.start_t.level))
      l_31_0._lp_xp_curr:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(data.start_t.xp))))
      l_31_0._lp_xp_gain:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(0))))
      l_31_0._lp_xp_nl:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(data.start_t.total - data.start_t.current))))
      local clbk = callback(l_31_0, l_31_0, "spawn_animation")
      l_31_0._lp_curr_xp:show()
      l_31_0._lp_xp_gained:show()
      l_31_0._lp_next_level:show()
      l_31_0._lp_xp_gain:show()
      l_31_0._lp_xp_curr:show()
      l_31_0._lp_xp_nl:show()
      l_31_0._lp_curr_xp:animate(clbk, 0)
      l_31_0._lp_xp_gained:animate(clbk, 0)
      l_31_0._lp_next_level:animate(clbk, 0)
      l_31_0._lp_xp_gain:animate(clbk, 0)
      l_31_0._lp_xp_curr:animate(clbk, 0)
      l_31_0._lp_xp_nl:animate(clbk, 0)
      l_31_0:step_stage_up()
    end
  end
end

HUDStageEndScreen.stage_show_all = function(l_32_0, l_32_1, l_32_2)
  l_32_0._lp_curr_xp:show()
  l_32_0._lp_xp_gained:show()
  l_32_0._lp_next_level:show()
  l_32_0._lp_xp_gain:show()
  l_32_0._lp_xp_curr:show()
  l_32_0._lp_xp_nl:show()
  l_32_0:step_stage_up()
end

HUDStageEndScreen.stage_spin_levels = function(l_33_0, l_33_1, l_33_2)
  local data = l_33_0._data
  if not l_33_0._playing_sound then
    l_33_0._playing_sound = true
    managers.menu_component:post_event("count_1")
  end
  l_33_0._csl = l_33_0._csl or 1
  local current_level_data = data[l_33_0._csl]
  if current_level_data then
    local total_xp = current_level_data.total
    local xp_gained_frame = l_33_2 * l_33_0._speed * math.max(total_xp * 0.079999998211861, 450)
    l_33_0._next_level_xp = l_33_0._next_level_xp - xp_gained_frame
    if l_33_0._next_level_xp <= 0 then
      xp_gained_frame = xp_gained_frame + l_33_0._next_level_xp
      l_33_0._next_level_xp = 0
    end
    l_33_0._current_xp = l_33_0._current_xp + (xp_gained_frame)
    l_33_0._gained_xp = l_33_0._gained_xp + (xp_gained_frame)
    l_33_0._speed = l_33_0._speed + l_33_2 * 1.5499999523163
    local ratio = 1 - l_33_0._next_level_xp / total_xp
    l_33_0._lp_circle:set_color(Color(ratio, 1, 1))
    if l_33_0._next_level_xp == 0 then
      l_33_0._csl = l_33_0._csl + 1
      if data[l_33_0._csl] then
        l_33_0._next_level_xp = data[l_33_0._csl].total
      else
        l_33_0._next_level_xp = data.end_t.total
      end
      l_33_0._static_current_xp = l_33_0._static_current_xp + current_level_data.total - l_33_0._static_start_xp
      l_33_0._static_gained_xp = l_33_0._static_gained_xp + current_level_data.total - l_33_0._static_start_xp
      l_33_0._current_xp = l_33_0._static_current_xp
      l_33_0._gained_xp = l_33_0._static_gained_xp
      l_33_0._static_start_xp = 0
      l_33_0._speed = math.max(1, l_33_0._speed * 0.55000001192093)
      if l_33_0:level_up(current_level_data.level) then
        l_33_0._wait_t = l_33_1 + 1.3999999761581
        managers.menu_component:post_event("count_1_finished")
        l_33_0._playing_sound = nil
      else
        l_33_0._wait_t = l_33_1 + 0.40000000596046
        managers.menu_component:post_event("count_1_finished")
        l_33_0._playing_sound = nil
      end
    end
    l_33_0._lp_xp_curr:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(l_33_0._current_xp))))
    l_33_0._lp_xp_gain:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(l_33_0._gained_xp))))
    if current_level_data.level < managers.experience:level_cap() then
      l_33_0._lp_xp_nl:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(l_33_0._next_level_xp))))
    else
      l_33_0._lp_xp_nl:set_text("")
    end
  else
    l_33_0._speed = math.max(1.5499999523163, l_33_0._speed * 0.55000001192093)
    l_33_0._top_speed = l_33_0._speed
    l_33_0:step_stage_up()
  end
end

HUDStageEndScreen.stage_spin_slowdown = function(l_34_0, l_34_1, l_34_2)
  local data = l_34_0._data
  local xp_gained_frame = l_34_2 * l_34_0._speed * math.max(data.end_t.total * 0.10000000149012, 450)
  local total_xp = data.end_t.total - data.end_t.current
  l_34_0._next_level_xp = l_34_0._next_level_xp - xp_gained_frame
  if l_34_0._next_level_xp < total_xp then
    xp_gained_frame = xp_gained_frame + (l_34_0._next_level_xp - total_xp)
    l_34_0._next_level_xp = total_xp
    l_34_0:step_stage_up()
    managers.menu_component:post_event("count_1_finished")
  end
  l_34_0._current_xp = l_34_0._current_xp + (xp_gained_frame)
  l_34_0._gained_xp = l_34_0._gained_xp + (xp_gained_frame)
  if not l_34_0._top_speed then
    l_34_0._top_speed = data.end_t.current == 0 or 1
  end
  do
    local ex = (data.end_t.total - l_34_0._next_level_xp) / data.end_t.current
    l_34_0._speed = math.max(1, l_34_0._top_speed / l_34_0._top_speed * 2 ^ ex)
  end
  local ratio = 1 - l_34_0._next_level_xp / data.end_t.total
  l_34_0._lp_circle:set_color(Color(ratio, 1, 1))
  if data.end_t.level < managers.experience:level_cap() then
    l_34_0._lp_xp_curr:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(l_34_0._current_xp))))
    l_34_0._lp_xp_gain:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(l_34_0._gained_xp))))
    l_34_0._lp_xp_nl:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(l_34_0._next_level_xp))))
  else
    l_34_0._lp_xp_nl:set_text("")
  end
end

HUDStageEndScreen.stage_end = function(l_35_0, l_35_1, l_35_2)
  local data = l_35_0._data
  local ratio = data.end_t.current / data.end_t.total
  l_35_0._static_current_xp = data.end_t.xp
  l_35_0._static_gained_xp = data.gained
  l_35_0._current_xp = l_35_0._static_current_xp
  l_35_0._gained_xp = l_35_0._static_gained_xp
  l_35_0._lp_xp_curr:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(l_35_0._current_xp))))
  l_35_0._lp_xp_gain:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(l_35_0._gained_xp))))
  if data.end_t.level < managers.experience:level_cap() then
    l_35_0._lp_circle:set_color(Color(ratio, 1, 1))
    l_35_0._lp_xp_nl:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(data.end_t.total - data.end_t.current))))
  else
    l_35_0._lp_circle:set_color(Color(1, 1, 1))
    l_35_0._lp_xp_nl:set_text("")
  end
  l_35_0._wait_t = l_35_1
  l_35_0:step_stage_up()
end

HUDStageEndScreen.stage_done = function(l_36_0, l_36_1, l_36_2)
  if l_36_0._all_done then
    return 
  end
  if l_36_0._done_clbk then
    WalletGuiObject.refresh()
    WalletGuiObject.set_object_visible("wallet_level_icon", true)
    WalletGuiObject.set_object_visible("wallet_level_text", true)
    WalletGuiObject.set_object_visible("wallet_skillpoint_icon", managers.skilltree:points() > 0)
    WalletGuiObject.set_object_visible("wallet_skillpoint_text", managers.skilltree:points() > 0)
    l_36_0._done_clbk(true)
    l_36_0._all_done = true
  end
end

HUDStageEndScreen.level_up = function(l_37_0, l_37_1)
  local level_text_func = function(l_1_0, l_1_1, l_1_2)
    local center_x, center_y = l_1_0:center()
    local size = tweak_data.menu.pd2_massive_font_size
    local ding_size = size * (1 + l_1_1)
    wait(0.10000000149012)
    l_1_0:set_text(tostring(l_1_2))
    self:give_skill_points(1)
   end
  local text_ding_func = function(l_2_0)
    local TOTAL_T = 0.40000000596046
    local t = TOTAL_T
    local mul = 1
    do
      local size = l_2_0:font_size()
      repeat
        if t > 0 then
          local dt = coroutine.yield()
          t = t - dt
          local ratio = math.max((t) / TOTAL_T, 0)
          mul = mul + dt * 4
          l_2_0:set_font_size(size * (mul))
          l_2_0:set_alpha(ratio)
          l_2_0:set_color(math.lerp(Color.white, tweak_data.screen_colors.button_stage_2, 1 - ratio))
        else
          l_2_0:parent():remove(l_2_0)
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  local circle_ding_func = function(l_3_0)
    wait(0.15000000596046)
    local TOTAL_T = 0.60000002384186
    local t = TOTAL_T
    local mul = 1
    local c_x, c_y = l_3_0:center()
    do
      local size = l_3_0:w()
      repeat
        if t > 0 then
          local dt = coroutine.yield()
          t = t - dt
          local ratio = math.max((t) / TOTAL_T, 0)
          mul = mul + dt * 0.75
          l_3_0:set_size(size * (mul), size * (mul))
          l_3_0:set_center(c_x, c_y)
          l_3_0:set_alpha(ratio)
          l_3_0:set_color(math.lerp(Color.white, tweak_data.screen_colors.button_stage_2, 1 - ratio))
        else
          l_3_0:parent():remove(l_3_0)
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  local package_func = function(l_4_0, l_4_1)
    local start_alpha = l_4_0:alpha()
    for _,item in ipairs(self._package_items) do
      item:close()
    end
    self._package_items = {}
    wait(0.60000002384186)
    local new_items = {}
    if l_4_1.announcements then
      for i,announcement in ipairs(l_4_1.announcements) do
        table.insert(new_items, {announcement = announcement})
      end
    end
    if l_4_1.upgrades then
      for i,upgrade in ipairs(l_4_1.upgrades) do
        table.insert(new_items, {upgrade = upgrade})
      end
    end
    self._package_forepanel:child("title_text"):set_text(managers.localization:to_upper_text("menu_es_package_unlocked_" .. (#new_items == 1 and "singular" or "plural")))
    if #new_items > 2 then
      Application:error("HUDStageEndScreen: Please, max 2 announcements+upgrades per level in tweak_data.level_tree, rest will not be shown in gui!")
    end
    over(0.41999998688698, function(l_1_0)
      o:set_alpha(math.cos(652 * l_1_0) * math.rand(0.40000000596046, 0.80000001192093))
      end)
    over(0.03999999910593, function(l_2_0)
      o:set_alpha(math.step(o:alpha(), 1, l_2_0))
      end)
    l_4_0:set_alpha(1)
    for i,item in ipairs(new_items) do
      table.insert(self._package_items, HUDPackageUnlockedItem:new(l_4_0, i, item, self))
      wait(0.23999999463558)
    end
   end
  managers.menu_component:post_event("stinger_levelup")
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local ding_circle = l_37_0._lp_backpanel:bitmap({texture = "guis/textures/pd2/endscreen/exp_ring", w = l_37_0._lp_circle:w()})
  ding_circle:animate(circle_ding_func)
  {texture = "guis/textures/pd2/endscreen/exp_ring", w = l_37_0._lp_circle:w()}.rotation, {texture = "guis/textures/pd2/endscreen/exp_ring", w = l_37_0._lp_circle:w()}.layer, {texture = "guis/textures/pd2/endscreen/exp_ring", w = l_37_0._lp_circle:w()}.blend_mode, {texture = "guis/textures/pd2/endscreen/exp_ring", w = l_37_0._lp_circle:w()}.color, {texture = "guis/textures/pd2/endscreen/exp_ring", w = l_37_0._lp_circle:w()}.y, {texture = "guis/textures/pd2/endscreen/exp_ring", w = l_37_0._lp_circle:w()}.x, {texture = "guis/textures/pd2/endscreen/exp_ring", w = l_37_0._lp_circle:w()}.h = 360, 0, "add", Color.white, l_37_0._lp_circle:y(), l_37_0._lp_circle:x(), l_37_0._lp_circle:h()
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local ding_text = l_37_0._lp_forepanel:text({w = l_37_0._lp_text:w(), h = l_37_0._lp_text:h(), x = l_37_0._lp_text:x(), y = l_37_0._lp_text:y(), color = Color.white, blend_mode = "add", font_size = tweak_data.menu.pd2_massive_font_size, font = tweak_data.menu.pd2_massive_font, text = l_37_0._lp_text:text(), align = "center"})
  ding_text:animate(text_ding_func)
  {w = l_37_0._lp_text:w(), h = l_37_0._lp_text:h(), x = l_37_0._lp_text:x(), y = l_37_0._lp_text:y(), color = Color.white, blend_mode = "add", font_size = tweak_data.menu.pd2_massive_font_size, font = tweak_data.menu.pd2_massive_font, text = l_37_0._lp_text:text(), align = "center"}.rotation, {w = l_37_0._lp_text:w(), h = l_37_0._lp_text:h(), x = l_37_0._lp_text:x(), y = l_37_0._lp_text:y(), color = Color.white, blend_mode = "add", font_size = tweak_data.menu.pd2_massive_font_size, font = tweak_data.menu.pd2_massive_font, text = l_37_0._lp_text:text(), align = "center"}.layer, {w = l_37_0._lp_text:w(), h = l_37_0._lp_text:h(), x = l_37_0._lp_text:x(), y = l_37_0._lp_text:y(), color = Color.white, blend_mode = "add", font_size = tweak_data.menu.pd2_massive_font_size, font = tweak_data.menu.pd2_massive_font, text = l_37_0._lp_text:text(), align = "center"}.vertical = 360, 0, "center"
  l_37_0._lp_circle:set_color(Color(0, 1, 1))
  l_37_0._lp_text:stop()
  l_37_0._lp_text:animate(level_text_func, 1, tostring(l_37_1))
  local package_unlocked = tweak_data.upgrades.level_tree[l_37_1]
  if package_unlocked then
    l_37_0._package_forepanel:stop()
    l_37_0._package_forepanel:animate(package_func, package_unlocked)
  end
  return package_unlocked
end

HUDStageEndScreen.reset_skill_points = function(l_38_0)
  l_38_0:give_skill_points(-l_38_0._num_skill_points_gained)
end

HUDStageEndScreen.give_skill_points = function(l_39_0, l_39_1)
  l_39_0._num_skill_points_gained = l_39_0._num_skill_points_gained + l_39_1
  l_39_0._update_skill_points = true
end

HUDStageEndScreen.stage_debug_loop = function(l_40_0, l_40_1, l_40_2)
  l_40_0:reset_stage()
  l_40_0._wait_t = l_40_1 + 3
end

local l_0_0 = HUDStageEndScreen
do
  local l_0_1 = {}
   -- DECOMPILER ERROR: No list found. Setlist fails

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

end
 -- Warning: undefined locals caused missing assignments!

