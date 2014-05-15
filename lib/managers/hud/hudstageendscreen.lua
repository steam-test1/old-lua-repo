require("lib/managers/menu/MenuBackdropGUI")
require("lib/managers/menu/WalletGuiObject")
local make_fine_text = function(text)
	local x, y, w, h = text:text_rect()
	text:set_size(w, h)
	text:set_position(math.round(text:x()), math.round(text:y()))
	return x, y, w, h
end

HUDPackageUnlockedItem = HUDPackageUnlockedItem or class()
function HUDPackageUnlockedItem:init(panel, row, params, hud_stage_end_screen)
	self._panel = panel:panel({
		w = panel:w() - 20,
		h = panel:h() * 0.5 - 15 - 10,
		x = 10,
		y = 40,
		alpha = 0
	})
	self._panel:move(0, self._panel:h() * (row - 1))
	if row > 2 then
		self._panel:hide()
	end

	local announcement = params.announcement
	local upgrade = params.upgrade
	local ghost_bonus = params.ghost_bonus
	local gage_assignment = params.gage_assignment
	local bitmap_texture = "guis/textures/pd2/endscreen/test_icon_package"
	local text_string = ""
	local blend_mode = "normal"
	local post_event = "stinger_new_weapon"
	local wait_time = 0
	if announcement then
		bitmap_texture = "guis/textures/pd2/endscreen/announcement"
		text_string = managers.localization:to_upper_text("menu_es_announcement") .. "\n" .. managers.localization:to_upper_text(announcement)
		blend_mode = "add"
	elseif upgrade then
		local upgrade_def = tweak_data.upgrades.definitions[upgrade]
		if upgrade_def then
			local category = Idstring(upgrade_def.category)
			if category == Idstring("weapon") then
				local guis_catalog = "guis/"
				local weapon_id = upgrade_def.weapon_id
				local bundle_folder = tweak_data.weapon[weapon_id] and tweak_data.weapon[weapon_id].texture_bundle_folder
				if bundle_folder then
					guis_catalog = guis_catalog .. "dlcs/" .. tostring(bundle_folder) .. "/"
				end

				local weapon_name = managers.weapon_factory:get_weapon_name_by_factory_id(upgrade_def.factory_id)
				local weapon_class = managers.localization:text("menu_" .. tweak_data.weapon[upgrade_def.weapon_id].category)
				local weapon_category = managers.localization:text("bm_menu_" .. (tweak_data.weapon[upgrade_def.weapon_id].use_data.selection_index == 2 and "primaries" or "secondaries"))
				local texture_name = tweak_data.weapon[weapon_id].texture_name or tostring(weapon_id)
				bitmap_texture = guis_catalog .. "textures/pd2/blackmarket/icons/weapons/" .. texture_name
				text_string = managers.localization:text("menu_es_package_weapon", {
					weapon = utf8.to_upper(weapon_name),
					type = utf8.to_upper(weapon_class),
					category = weapon_category,
					INVENTORY_MENU = managers.localization:text("menu_inventory")
				})
			elseif category == Idstring("armor") then
				local guis_catalog = "guis/"
				local bundle_folder = tweak_data.blackmarket.armors[upgrade_def.armor_id] and tweak_data.blackmarket.armors[upgrade_def.armor_id].texture_bundle_folder
				if bundle_folder then
					guis_catalog = guis_catalog .. "dlcs/" .. tostring(bundle_folder) .. "/"
				end

				bitmap_texture = guis_catalog .. "textures/pd2/blackmarket/icons/armors/" .. upgrade_def.armor_id
				text_string = managers.localization:text("menu_es_package_armor", {
					armor = managers.localization:to_upper_text(upgrade_def.name_id)
				})
			elseif category == Idstring("melee_weapon") then
				local bm_tweak_data = tweak_data.blackmarket.melee_weapons[upgrade]
				local guis_catalog = "guis/"
				local bundle_folder = bm_tweak_data and bm_tweak_data.texture_bundle_folder
				if bundle_folder then
					guis_catalog = guis_catalog .. "dlcs/" .. tostring(bundle_folder) .. "/"
				end

				bitmap_texture = guis_catalog .. "textures/pd2/blackmarket/icons/melee_weapons/" .. upgrade
				text_string = managers.localization:text("menu_es_package_melee_weapon", {
					melee_weapon = bm_tweak_data and managers.localization:to_upper_text(bm_tweak_data.name_id)
				})
			elseif category == Idstring("rep_upgrade") then
				bitmap_texture = "guis/textures/pd2/endscreen/" .. upgrade_def.category
				text_string = managers.localization:to_upper_text("menu_es_rep_upgrade", {
					point = upgrade_def.value or 2
				})
				blend_mode = "add"
				hud_stage_end_screen:give_skill_points(upgrade_def.value or 2)
			else
				bitmap_texture = "guis/textures/pd2/endscreen/" .. upgrade_def.category
			end

		end

	elseif ghost_bonus then
		local on_last_stage = managers.job:on_last_stage()
		bitmap_texture = "guis/textures/pd2/endscreen/stealth_bonus"
		local string_id = on_last_stage and "menu_es_ghost_bonus_job" or "menu_es_ghost_bonus_day"
		text_string = managers.localization:to_upper_text(string_id, {bonus = ghost_bonus})
		blend_mode = "add"
	elseif gage_assignment then
		local completed, progressed = managers.gage_assignment:get_latest_data()
		bitmap_texture = "guis/dlcs/gage_pack_jobs/textures/pd2/endscreen/gage_assignment"
		blend_mode = "add"
		local string_id = ""
		if 0 < table.size(completed) then
			string_id = "menu_es_gage_assignment_package_complete"
			post_event = "gage_package_win"
			wait_time = 0.6
		else
			string_id = "menu_es_gage_assignment_package"
		end

		text_string = managers.localization:to_upper_text(string_id, {})
	else
		Application:debug("HUDPackageUnlockedItem: Something something unknown")
	end

	local bitmap = self._panel:bitmap({texture = bitmap_texture, blend_mode = blend_mode})
	local tw = bitmap:texture_width()
	local th = bitmap:texture_height()
	if th ~= 0 then
		local ratio = tw / th
		local size = self._panel:h() - 10
		local sw = math.max(size, size * ratio)
		local sh = math.max(size, size / ratio)
		bitmap:set_size(sw, sh)
		bitmap:set_center_x(self._panel:h() - 5)
		bitmap:set_center_y(self._panel:h() / 2)
		local text = self._panel:text({
			font = tweak_data.menu.pd2_medium_font,
			font_size = tweak_data.menu.pd2_medium_font_size,
			color = tweak_data.screen_colors.text,
			text = text_string,
			x = bitmap:right() + 10,
			y = bitmap:top(),
			vertical = "center",
			wrap = true,
			word_wrap = true
		})
		text:grow(-text:x() - 5, -text:y() - 5)
		local _, _, _, h = text:text_rect()
		if h > text:h() then
			text:set_font(tweak_data.menu.pd2_small_font_id)
			text:set_font_size(tweak_data.menu.pd2_small_font_size)
		end

		text:set_position(math.round(text:x()), math.round(text:y()))
		managers.menu_component:make_color_text(text, tweak_data.screen_colors.ghost_color)
	end

	self._panel:animate(callback(self, self, "create_animation", {post_event = post_event, wait_time = wait_time}))
end

function HUDPackageUnlockedItem:create_animation(params)
	managers.menu_component:post_event(params.post_event)
	wait(params.wait_time or 0)
	over(0.3, function(p)
		self._panel:set_alpha(math.lerp(0, 1, p))
	end
)
end

function HUDPackageUnlockedItem:destroy_animation()
	over(0.1, function(p)
		self._panel:set_alpha(math.lerp(1, 0.2, p))
	end
)
	over(0.3, function(p)
		self._panel:set_alpha(math.lerp(0.2, 0, p))
	end
)
	self._panel:parent():remove(self._panel)
	self._panel = nil
end

function HUDPackageUnlockedItem:close()
	if not alive(self._panel) then
		return
	end

	self._panel:stop()
	self._panel:animate(callback(self, self, "destroy_animation"))
end

HUDStageEndScreen = HUDStageEndScreen or class()
function HUDStageEndScreen:init(hud, workspace)
	self._backdrop = MenuBackdropGUI:new(workspace)
	self._backdrop:create_black_borders()
	self._hud = hud
	self._workspace = workspace
	self._singleplayer = Global.game_settings.single_player
	local bg_font = tweak_data.menu.pd2_massive_font
	local title_font = tweak_data.menu.pd2_large_font
	local content_font = tweak_data.menu.pd2_medium_font
	local small_font = tweak_data.menu.pd2_small_font
	local bg_font_size = tweak_data.menu.pd2_massive_font_size
	local title_font_size = tweak_data.menu.pd2_large_font_size
	local content_font_size = tweak_data.menu.pd2_medium_font_size
	local small_font_size = tweak_data.menu.pd2_small_font_size
	local massive_font = bg_font
	local large_font = title_font
	local medium_font = content_font
	local massive_font_size = bg_font_size
	local large_font_size = title_font_size
	local medium_font_size = content_font_size
	self._background_layer_safe = self._backdrop:get_new_background_layer()
	self._background_layer_full = self._backdrop:get_new_background_layer()
	self._foreground_layer_safe = self._backdrop:get_new_foreground_layer()
	self._foreground_layer_full = self._backdrop:get_new_foreground_layer()
	self._backdrop:set_panel_to_saferect(self._background_layer_safe)
	self._backdrop:set_panel_to_saferect(self._foreground_layer_safe)
	if managers.job:has_active_job() then
		local current_contact_data = managers.job:current_contact_data()
		local contact_gui = self._background_layer_full:gui(current_contact_data.assets_gui, {empty = true})
		local contact_pattern = contact_gui:has_script() and contact_gui:script().pattern
		if contact_pattern then
			self._backdrop:set_pattern(contact_pattern)
		end

	end

	do
		local padding_y = 0
		self._paygrade_panel = self._background_layer_safe:panel({
			h = 70,
			w = 210,
			y = padding_y
		})
		local pg_text = self._foreground_layer_safe:text({
			name = "pg_text",
			text = utf8.to_upper(managers.localization:text("menu_risk")),
			y = padding_y,
			h = 32,
			align = "right",
			vertical = "center",
			font_size = content_font_size,
			font = content_font,
			color = tweak_data.screen_colors.text
		})
		local _, _, w, h = pg_text:text_rect()
		pg_text:set_size(w, h)
		local job_stars = managers.job:has_active_job() and managers.job:current_job_stars() or 1
		local job_and_difficulty_stars = managers.job:has_active_job() and managers.job:current_job_and_difficulty_stars() or 1
		local difficulty_stars = managers.job:has_active_job() and managers.job:current_difficulty_stars() or 0
		local risk_color = tweak_data.screen_colors.risk
		local risks = {
			"risk_swat",
			"risk_fbi",
			"risk_death_squad"
		}
		if not Global.SKIP_OVERKILL_290 then
			table.insert(risks, "risk_murder_squad")
		end

		local panel_w = 0
		local panel_h = 0
		local x = 0
		local y = 0
		do
			local (for generator), (for state), (for control) = ipairs(risks)
			do
				do break end
				local texture, rect = tweak_data.hud_icons:get_icon_data(name)
				local active = i <= difficulty_stars
				local color = active and risk_color or tweak_data.screen_colors.text
				local alpha = active and 1 or 0.25
				local risk = self._paygrade_panel:bitmap({
					name = name,
					texture = texture,
					texture_rect = rect,
					x = 0,
					y = 0,
					alpha = alpha,
					color = color
				})
				risk:set_position(x, y)
				x = x + risk:w() + 0
				panel_w = math.max(panel_w, risk:right())
				panel_h = math.max(panel_h, risk:h())
			end

		end

		(for control) = managers.localization:text("menu_risk") and tweak_data
		pg_text:set_color(risk_color)
		self._paygrade_panel:set_h(panel_h)
		self._paygrade_panel:set_w(panel_w)
		self._paygrade_panel:set_right(self._background_layer_safe:w())
		pg_text:set_right(self._paygrade_panel:left())
		pg_text:set_center_y(self._paygrade_panel:center_y())
		pg_text:set_y(math.round(pg_text:y()))
	end

	self._stage_name = managers.job:current_level_id() and managers.localization:to_upper_text(tweak_data.levels[managers.job:current_level_id()].name_id) or ""
	self._foreground_layer_safe:text({
		name = "stage_text",
		text = self._stage_name,
		h = title_font_size,
		align = "left",
		vertical = "center",
		font_size = title_font_size,
		font = title_font,
		color = tweak_data.screen_colors.text
	})
	local bg_text = self._background_layer_full:text({
		name = "stage_text",
		text = self._stage_name,
		h = bg_font_size,
		align = "left",
		vertical = "top",
		font_size = bg_font_size,
		font = bg_font,
		color = tweak_data.screen_colors.button_stage_3,
		alpha = 0.4
	})
	bg_text:set_world_center_y(self._foreground_layer_safe:child("stage_text"):world_center_y())
	bg_text:set_world_x(self._foreground_layer_safe:child("stage_text"):world_x())
	bg_text:move(-13, 9)
	self._backdrop:animate_bg_text(bg_text)
	self._lp_backpanel = self._background_layer_safe:panel({
		name = "lp_backpanel",
		w = self._background_layer_safe:w() / 2 - 10,
		h = self._background_layer_safe:h() / 2,
		y = 70
	})
	self._lp_forepanel = self._foreground_layer_safe:panel({
		name = "lp_forepanel",
		w = self._foreground_layer_safe:w() / 2 - 10,
		h = self._foreground_layer_safe:h() / 2,
		y = 70
	})
	local level_progress_text = self._lp_forepanel:text({
		name = "level_progress_text",
		text = managers.localization:to_upper_text("menu_es_level_progress"),
		align = "left",
		vertical = "top",
		h = content_font_size + 2,
		font_size = content_font_size,
		font = content_font,
		color = tweak_data.screen_colors.text,
		x = 10,
		y = 10
	})
	local _, _, lw, lh = level_progress_text:text_rect()
	level_progress_text:set_size(lw, lh)
	local lp_bg_circle = self._lp_backpanel:bitmap({
		name = "bg_progress_circle",
		texture = "guis/textures/pd2/endscreen/exp_ring",
		h = self._lp_backpanel:h() - content_font_size,
		w = self._lp_backpanel:h() - content_font_size,
		y = content_font_size,
		color = Color.black,
		alpha = 0.6,
		blend_mode = "normal"
	})
	self._lp_circle = self._lp_backpanel:bitmap({
		name = "progress_circle",
		texture = "guis/textures/pd2/endscreen/exp_ring",
		h = self._lp_backpanel:h() - content_font_size,
		w = self._lp_backpanel:h() - content_font_size,
		y = content_font_size,
		color = Color(0, 1, 1),
		render_template = "VertexColorTexturedRadial",
		blend_mode = "add",
		layer = 1
	})
	self._lp_text = self._lp_forepanel:text({
		name = "level_text",
		text = "",
		align = "center",
		vertical = "center",
		font_size = bg_font_size,
		font = bg_font,
		h = self._lp_backpanel:h() - content_font_size,
		w = self._lp_backpanel:h() - content_font_size,
		y = content_font_size,
		color = tweak_data.screen_colors.text
	})
	self._lp_curr_xp = self._lp_forepanel:text({
		name = "current_xp",
		text = managers.localization:to_upper_text("menu_es_current_xp"),
		align = "left",
		vertical = "top",
		h = small_font_size,
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.text
	})
	self._lp_xp_gained = self._lp_forepanel:text({
		name = "xp_gained",
		text = managers.localization:to_upper_text("menu_es_xp_gained"),
		align = "left",
		vertical = "top",
		h = content_font_size,
		font_size = content_font_size,
		font = content_font,
		color = tweak_data.screen_colors.text
	})
	self._lp_next_level = self._lp_forepanel:text({
		name = "next_level",
		text = managers.localization:to_upper_text("menu_es_next_level"),
		align = "left",
		vertical = "top",
		h = small_font_size,
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.text
	})
	self._lp_skill_points = self._lp_forepanel:text({
		name = "skill_points",
		text = managers.localization:to_upper_text("menu_es_skill_points_gained"),
		align = "left",
		vertical = "top",
		h = small_font_size,
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.text
	})
	self._lp_xp_curr = self._lp_forepanel:text({
		name = "c_xp",
		text = "",
		align = "left",
		vertical = "top",
		h = small_font_size,
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.text
	})
	self._lp_xp_gain = self._lp_forepanel:text({
		name = "xp_g",
		text = "",
		align = "left",
		vertical = "top",
		h = content_font_size,
		font_size = content_font_size,
		font = content_font,
		color = tweak_data.screen_colors.text
	})
	self._lp_xp_nl = self._lp_forepanel:text({
		name = "xp_nl",
		text = "",
		align = "left",
		vertical = "top",
		h = small_font_size,
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.text
	})
	self._lp_sp_gain = self._lp_forepanel:text({
		name = "sp_g",
		text = "0",
		align = "left",
		vertical = "center",
		h = small_font_size,
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.text
	})
	local _, _, cw, ch = self._lp_curr_xp:text_rect()
	local _, _, gw, gh = self._lp_xp_gained:text_rect()
	local _, _, nw, nh = self._lp_next_level:text_rect()
	local _, _, sw, sh = self._lp_skill_points:text_rect()
	ch = ch - 2
	nh = nh - 2
	sh = sh - 2
	local w = math.ceil(math.max(cw, gw, nw, sw)) + 20
	local squeeze_more_pixels = false
	if w > 170 then
		squeeze_more_pixels = true
	end

	self._num_skill_points_gained = 0
	self._lp_sp_info = self._lp_forepanel:text({
		name = "sp_info",
		text = managers.localization:text("menu_es_skill_points_info", {
			SKILL_MENU = managers.localization:to_upper_text("menu_skilltree")
		}),
		align = "left",
		vertical = "top",
		h = small_font_size,
		font_size = small_font_size,
		font = small_font,
		color = tweak_data.screen_colors.text,
		wrap = true,
		word_wrap = true
	})
	self._lp_sp_info:grow(-self._lp_circle:right() - 10, 0)
	local _, _, iw, ih = self._lp_sp_info:text_rect()
	self._lp_sp_info:set_h(ih)
	self._lp_sp_info:set_leftbottom(self._lp_circle:right() + 0, self._lp_forepanel:h() - 10)
	local w = self._lp_forepanel:w() - self._lp_sp_info:x() - 90
	local number_text_x = self._lp_sp_info:left() + w
	self._lp_skill_points:set_size(sw, sh)
	self._lp_skill_points:set_left(self._lp_sp_info:left())
	self._lp_skill_points:set_bottom(self._lp_sp_info:top())
	self._lp_sp_gain:set_left(number_text_x)
	self._lp_sp_gain:set_top(self._lp_skill_points:top())
	self._lp_sp_gain:set_size(self._lp_forepanel:w() - self._lp_sp_gain:left() - 10, sh)
	self._lp_next_level:set_size(nw, nh)
	self._lp_next_level:set_left(self._lp_sp_info:left())
	self._lp_next_level:set_bottom(self._lp_skill_points:top())
	self._lp_xp_nl:set_left(number_text_x)
	self._lp_xp_nl:set_top(self._lp_next_level:top())
	self._lp_xp_nl:set_size(self._lp_forepanel:w() - self._lp_xp_nl:left() - 10, nh)
	self._lp_curr_xp:set_size(cw, ch)
	self._lp_curr_xp:set_left(self._lp_sp_info:left())
	self._lp_curr_xp:set_bottom(self._lp_next_level:top())
	self._lp_xp_curr:set_left(number_text_x)
	self._lp_xp_curr:set_top(self._lp_curr_xp:top())
	self._lp_xp_curr:set_size(self._lp_forepanel:w() - self._lp_xp_curr:left() - 10, ch)
	self._lp_xp_gained:set_size(gw, gh)
	self._lp_xp_gained:set_left(self._lp_curr_xp:left())
	self._lp_xp_gained:set_bottom(self._lp_curr_xp:top())
	self._lp_xp_gain:set_left(number_text_x)
	self._lp_xp_gain:set_top(self._lp_xp_gained:top())
	self._lp_xp_gain:set_size(self._lp_forepanel:w() - self._lp_xp_gain:left() - 10, gh)
	self._lp_xp_gained:set_bottom(math.round(self._lp_forepanel:h() / 2))
	self._lp_curr_xp:set_top(self._lp_xp_gained:bottom())
	self._lp_next_level:set_top(self._lp_curr_xp:bottom())
	self._lp_skill_points:set_top(self._lp_next_level:bottom())
	self._lp_sp_info:set_top(self._lp_skill_points:bottom())
	self._lp_xp_gain:set_top(self._lp_xp_gained:top())
	self._lp_xp_curr:set_top(self._lp_curr_xp:top())
	self._lp_xp_nl:set_top(self._lp_next_level:top())
	self._lp_sp_gain:set_top(self._lp_skill_points:top())
	if squeeze_more_pixels then
		lp_bg_circle:move(-20, 0)
		self._lp_circle:move(-20, 0)
		self._lp_text:move(-20, 0)
		self._lp_curr_xp:move(-30, 0)
		self._lp_xp_gained:move(-30, 0)
		self._lp_next_level:move(-30, 0)
		self._lp_skill_points:move(-30, 0)
		self._lp_sp_info:move(-30, 0)
	end

	self._box = BoxGuiObject:new(self._lp_backpanel, {
		sides = {
			1,
			1,
			1,
			1
		}
	})
	WalletGuiObject.set_wallet(self._foreground_layer_safe)
	self._package_forepanel = self._foreground_layer_safe:panel({
		name = "package_forepanel",
		w = self._foreground_layer_safe:w() / 2 - 10,
		h = self._foreground_layer_safe:h() / 2 - 70 - 10,
		y = 70,
		alpha = 1
	})
	self._package_forepanel:set_right(self._foreground_layer_safe:w())
	self._package_forepanel:text({
		name = "title_text",
		font = content_font,
		font_size = content_font_size,
		text = "",
		x = 10,
		y = 10
	})
	local package_box_panel = self._foreground_layer_safe:panel()
	package_box_panel:set_shape(self._package_forepanel:shape())
	package_box_panel:set_layer(self._package_forepanel:layer())
	self._package_box = BoxGuiObject:new(package_box_panel, {
		sides = {
			1,
			1,
			1,
			1
		}
	})
	self._package_items = {}
	self:clear_stage()
	if self._data then
		self:start_experience_gain()
	end

	local (for generator), (for state), (for control) = ipairs(self._lp_forepanel:children())
	do
		do break end
		if child.text then
			local text = child:text()
			child:set_text(string.gsub(text, ":", ""))
		end

	end

end

function HUDStageEndScreen:hide()
	self._backdrop:hide()
end

function HUDStageEndScreen:show()
	self._backdrop:show()
end

function HUDStageEndScreen:update_layout()
	self._backdrop:_set_black_borders()
end

function HUDStageEndScreen:spawn_animation(o, delay, post_event)
	wait(delay or 0)
	if post_event then
		managers.menu_component:post_event(post_event)
	end

	over(0.5, function(p)
		o:set_alpha(p)
	end
)
end

function HUDStageEndScreen:destroy_animation(o, delay, speed)
	wait(delay or 0)
	local start_alpha = o:alpha()
	over(0.25 * (speed or 1), function(p)
		o:set_alpha(math.lerp(start_alpha, 0, p))
		if o.children then
			local (for generator), (for state), (for control) = ipairs(o:children())
			do
				do break end
				if child.set_color then
					child:set_color(math.lerp(child:color(), tweak_data.screen_colors.text, p))
				else
					local (for generator), (for state), (for control) = ipairs(child:children())
					do
						do break end
						object:set_color(math.lerp(object:color(), tweak_data.screen_colors.text, p))
					end

				end

			end

		end

	end
)
	o:parent():remove(o)
	o = nil
end

function HUDStageEndScreen:_create_bonus(params)
	local panel = params.panel
	local positive_color = params.positive_color
	local negative_color = params.negative_color
	local color = params.color or params.bonus > 0 and positive_color or negative_color or Color.white
	local positive_title = params.positive_title
	local negative_title = params.negative_title
	local title_string = params.title or params.bonus > 0 and positive_title or negative_title or ""
	local sign_string = params.bonus > 0 and "+ " or "- "
	local stat_string = managers.money:add_decimal_marks_to_string(tostring(math.abs(params.bonus)))
	local bonus_panel = panel:panel({layer = 1})
	local title_text = bonus_panel:text({
		name = "title",
		text = title_string,
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = color
	})
	local sign_text = bonus_panel:text({
		name = "sign",
		text = sign_string,
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = color
	})
	local stat_text = bonus_panel:text({
		name = "stat",
		text = stat_string,
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = color
	})
	local x = self._lp_xp_gain:x() - panel:x()
	local _, _, _, h = make_fine_text(title_text)
	make_fine_text(sign_text)
	bonus_panel:set_h(h - 4)
	title_text:set_left(0)
	sign_text:set_right(x)
	stat_text:set_left(x)
	stat_text:set_top(title_text:top())
	stat_text:set_w(bonus_panel:w() - x)
	stat_text:set_h(title_text:h())
	do
		local (for generator), (for state), (for control) = ipairs(bonus_panel:children())
		do
			do break end
			if child.text then
				local text = child:text()
				child:set_text(string.gsub(text, ":", ""))
			end

		end

	end

end

function HUDStageEndScreen:bonus_risk(panel, delay, bonus)
	local risk_text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.risk,
		text = managers.localization:to_upper_text("menu_es_risk_bonus")
	})
	local _, _, w, h = risk_text:text_rect()
	risk_text:set_size(w, h)
	panel:set_h(h)
	local has_active_job = managers.job:has_active_job()
	local job_and_difficulty_stars = has_active_job and managers.job:current_job_and_difficulty_stars() or 1
	local job_stars = has_active_job and managers.job:current_job_stars() or 1
	local difficulty_stars = has_active_job and managers.job:current_difficulty_stars() or 0
	panel:animate(callback(self, self, "spawn_animation"), delay, "box_tick")
	local sign_text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.risk,
		text = "+",
		alpha = 0,
		align = "right"
	})
	make_fine_text(sign_text)
	sign_text:set_world_right(self._lp_xp_curr:world_left())
	sign_text:animate(callback(self, self, "spawn_animation"), delay, false)
	local value_text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.risk,
		text = managers.money:add_decimal_marks_to_string(tostring(math.abs(bonus))),
		alpha = 0
	})
	value_text:set_world_left(self._lp_xp_curr:world_left())
	value_text:animate(callback(self, self, "spawn_animation"), delay, false)
	make_fine_text(value_text)
	return delay
end

function HUDStageEndScreen:bonus_days(panel, delay, bonus)
	local text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.text,
		text = managers.localization:to_upper_text("menu_es_day_bonus")
	})
	local _, _, w, h = text:text_rect()
	panel:set_h(h)
	text:set_size(w, h)
	text:set_center_y(panel:h() / 2)
	text:set_position(math.round(text:x()), math.round(text:y()))
	panel:animate(callback(self, self, "spawn_animation"), delay, "box_tick")
	local sign_text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.text,
		text = "+",
		alpha = 0,
		align = "right"
	})
	make_fine_text(sign_text)
	sign_text:set_world_right(self._lp_xp_curr:world_left())
	sign_text:animate(callback(self, self, "spawn_animation"), delay + 0, false)
	local value_text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.text,
		text = managers.money:add_decimal_marks_to_string(tostring(math.abs(bonus))),
		alpha = 0
	})
	value_text:set_world_left(self._lp_xp_curr:world_left())
	value_text:animate(callback(self, self, "spawn_animation"), delay + 0, false)
	make_fine_text(value_text)
	return delay + 0
end

function HUDStageEndScreen:bonus_skill(panel, delay, bonus)
	local text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.text,
		text = managers.localization:to_upper_text("menu_es_skill_bonus")
	})
	local _, _, w, h = text:text_rect()
	panel:set_h(h)
	text:set_size(w, h)
	text:set_center_y(panel:h() / 2)
	text:set_position(math.round(text:x()), math.round(text:y()))
	panel:animate(callback(self, self, "spawn_animation"), delay, "box_tick")
	local sign_text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.text,
		text = "+",
		alpha = 0,
		align = "right"
	})
	make_fine_text(sign_text)
	sign_text:set_world_right(self._lp_xp_curr:world_left())
	sign_text:animate(callback(self, self, "spawn_animation"), delay + 0, false)
	local value_text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.text,
		text = managers.money:add_decimal_marks_to_string(tostring(math.abs(bonus))),
		alpha = 0
	})
	value_text:set_world_left(self._lp_xp_curr:world_left())
	value_text:animate(callback(self, self, "spawn_animation"), delay + 0, false)
	make_fine_text(value_text)
	return delay + 0
end

function HUDStageEndScreen:bonus_num_players(panel, delay, bonus)
	local text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.text,
		text = managers.localization:to_upper_text("menu_es_alive_players_bonus")
	})
	local _, _, w, h = text:text_rect()
	panel:set_h(h)
	text:set_size(w, h)
	text:set_center_y(panel:h() / 2)
	text:set_position(math.round(text:x()), math.round(text:y()))
	panel:animate(callback(self, self, "spawn_animation"), delay, "box_tick")
	local sign_text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.text,
		text = "+",
		alpha = 0,
		align = "right"
	})
	make_fine_text(sign_text)
	sign_text:set_world_right(self._lp_xp_curr:world_left())
	sign_text:animate(callback(self, self, "spawn_animation"), delay + 0, false)
	local value_text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.text,
		text = managers.money:add_decimal_marks_to_string(tostring(math.abs(bonus))),
		alpha = 0
	})
	value_text:set_world_left(self._lp_xp_curr:world_left())
	value_text:animate(callback(self, self, "spawn_animation"), delay + 0, false)
	make_fine_text(value_text)
	return delay + 0
end

function HUDStageEndScreen:bonus_failed(panel, delay, bonus)
	local text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.important_1,
		text = managers.localization:to_upper_text("menu_es_alive_failed_bonus")
	})
	local _, _, w, h = text:text_rect()
	panel:set_h(h)
	text:set_size(w, h)
	text:set_center_y(panel:h() / 2)
	text:set_position(math.round(text:x()), math.round(text:y()))
	panel:animate(callback(self, self, "spawn_animation"), delay, "box_tick")
	local sign_text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.important_1,
		text = "-",
		alpha = 0,
		align = "right"
	})
	make_fine_text(sign_text)
	sign_text:set_world_right(self._lp_xp_curr:world_left())
	sign_text:animate(callback(self, self, "spawn_animation"), delay + 0, false)
	local value_text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.important_1,
		text = managers.money:add_decimal_marks_to_string(tostring(math.abs(bonus))),
		alpha = 0
	})
	value_text:set_world_left(self._lp_xp_curr:world_left())
	value_text:animate(callback(self, self, "spawn_animation"), delay + 0, false)
	make_fine_text(value_text)
	return delay + 0
end

function HUDStageEndScreen:in_custody(panel, delay, bonus)
	local text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.important_1,
		text = managers.localization:to_upper_text("menu_es_in_custody_reduction")
	})
	local _, _, w, h = text:text_rect()
	panel:set_h(h)
	text:set_size(w, h)
	text:set_center_y(panel:h() / 2)
	text:set_position(math.round(text:x()), math.round(text:y()))
	panel:animate(callback(self, self, "spawn_animation"), delay, "box_tick")
	local sign_text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.important_1,
		text = "-",
		alpha = 0,
		align = "right"
	})
	make_fine_text(sign_text)
	sign_text:set_world_right(self._lp_xp_curr:world_left())
	sign_text:animate(callback(self, self, "spawn_animation"), delay + 0, false)
	local value_text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.important_1,
		text = managers.money:add_decimal_marks_to_string(tostring(math.abs(bonus))),
		alpha = 0
	})
	value_text:set_world_left(self._lp_xp_curr:world_left())
	value_text:animate(callback(self, self, "spawn_animation"), delay + 0, false)
	make_fine_text(value_text)
	return delay + 0
end

function HUDStageEndScreen:heat_xp(panel, delay, bonus)
	local heat = managers.job:last_known_heat() or managers.job:current_job_id() and managers.job:get_job_heat(managers.job:current_job_id()) or 0
	local heat_color = managers.job:get_heat_color(heat)
	local text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = heat_color,
		text = managers.localization:to_upper_text(bonus >= 0 and "menu_es_heat_bonus" or "menu_es_heat_reduction")
	})
	local _, _, w, h = text:text_rect()
	panel:set_h(h)
	text:set_size(w, h)
	text:set_center_y(panel:h() / 2)
	text:set_position(math.round(text:x()), math.round(text:y()))
	panel:animate(callback(self, self, "spawn_animation"), delay, "box_tick")
	local prefix = bonus >= 0 and "+" or "-"
	local sign_text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = heat_color,
		text = prefix,
		alpha = 0,
		align = "right"
	})
	make_fine_text(sign_text)
	sign_text:set_world_right(self._lp_xp_curr:world_left())
	sign_text:animate(callback(self, self, "spawn_animation"), delay + 0, false)
	local value_text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = heat_color,
		text = managers.money:add_decimal_marks_to_string(tostring(math.abs(bonus))),
		alpha = 0
	})
	value_text:set_world_left(self._lp_xp_curr:world_left())
	value_text:animate(callback(self, self, "spawn_animation"), delay + 0, false)
	make_fine_text(value_text)
	return delay + 0
end

function HUDStageEndScreen:bonus_low_level(panel, delay, bonus)
	local text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.text,
		5,
		text = managers.localization:to_upper_text("menu_es_alive_low_level_bonus")
	})
	local _, _, w, h = text:text_rect()
	panel:set_h(h)
	text:set_size(w, h)
	text:set_center_y(panel:h() / 2)
	text:set_position(math.round(text:x()), math.round(text:y()))
	panel:animate(callback(self, self, "spawn_animation"), delay, "box_tick")
	local sign_text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.text,
		text = "-",
		alpha = 0,
		align = "right"
	})
	make_fine_text(sign_text)
	sign_text:set_world_right(self._lp_xp_curr:world_left())
	sign_text:animate(callback(self, self, "spawn_animation"), delay + 0, false)
	local value_text = panel:text({
		font = tweak_data.menu.pd2_small_font,
		font_size = tweak_data.menu.pd2_small_font_size,
		color = tweak_data.screen_colors.text,
		text = managers.money:add_decimal_marks_to_string(tostring(math.abs(bonus))),
		alpha = 0
	})
	value_text:set_world_left(self._lp_xp_curr:world_left())
	value_text:animate(callback(self, self, "spawn_animation"), delay + 0, false)
	make_fine_text(value_text)
	return delay + 0
end

function HUDStageEndScreen:start_experience_gain()
	self:reset_stage()
end

function HUDStageEndScreen:clear_stage()
	self._wait_t = nil
	self._csl = nil
	self._all_done = nil
	self._playing_sound = nil
	self._lp_text:hide()
	self._lp_circle:hide()
	self._lp_backpanel:child("bg_progress_circle"):hide()
	self._lp_forepanel:child("level_progress_text"):hide()
	self._lp_curr_xp:hide()
	self._lp_xp_gained:hide()
	self._lp_next_level:hide()
	self._lp_skill_points:hide()
	self._lp_sp_info:hide()
	self._lp_xp_gain:hide()
	self._lp_xp_curr:hide()
	self._lp_xp_nl:hide()
	self._lp_sp_gain:hide()
	self._lp_text:set_text(tostring(self._data and self._data.start_t.level or 0))
	self:reset_skill_points()
	if self._background_layer_full:child("money_video") then
		self._background_layer_full:child("money_video"):stop()
		self._background_layer_full:remove(self._background_layer_full:child("money_video"))
	end

	if self._money_panel then
		self._money_panel:parent():remove(self._money_panel)
		self._money_panel = nil
	end

	WalletGuiObject.set_object_visible("wallet_level_icon", false)
	WalletGuiObject.set_object_visible("wallet_level_text", false)
	WalletGuiObject.set_object_visible("wallet_money_icon", false)
	WalletGuiObject.set_object_visible("wallet_money_text", false)
	WalletGuiObject.set_object_visible("wallet_skillpoint_icon", false)
	WalletGuiObject.set_object_visible("wallet_skillpoint_text", false)
end

function HUDStageEndScreen:_check_special_packages()
