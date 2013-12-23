-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\skilltreegui.luac 

require("lib/managers/menu/WalletGuiObject")
if not SkillTreeLogic then
  SkillTreeLogic = class()
end
local NOT_WIN_32 = SystemInfo:platform() ~= Idstring("WIN32")
local WIDTH_MULTIPLIER = NOT_WIN_32 and 0.60000002384186 or 0.60000002384186
local CONSOLE_PAGE_ADJUSTMENT = NOT_WIN_32 and 1 or 0
local BOX_GAP = 54
if not SkillTreeItem then
  SkillTreeItem = class()
end
SkillTreeItem.init = function(l_1_0)
  l_1_0._left_item = nil
  l_1_0._right_item = nil
  l_1_0._up_item = nil
  l_1_0._down_item = nil
end

SkillTreeItem.refresh = function(l_2_0)
end

SkillTreeItem.inside = function(l_3_0)
end

SkillTreeItem.select = function(l_4_0, l_4_1)
  if not l_4_0._selected then
    l_4_0._selected = true
    l_4_0:refresh()
    if not l_4_1 then
      managers.menu_component:post_event("highlight")
    end
  end
end

SkillTreeItem.deselect = function(l_5_0)
  if l_5_0._selected then
    l_5_0._selected = false
    l_5_0:refresh()
  end
end

SkillTreeItem.trigger = function(l_6_0)
  managers.menu_component:post_event("menu_enter")
  l_6_0:refresh()
end

SkillTreeItem.flash = function(l_7_0)
end

if not SkillTreeTabItem then
  SkillTreeTabItem = class(SkillTreeItem)
end
SkillTreeTabItem.init = function(l_8_0, l_8_1, l_8_2, l_8_3, l_8_4, l_8_5)
  SkillTreeTabItem.super.init(l_8_0)
  l_8_0._tree = l_8_2
  l_8_0._tree_tab = l_8_1:panel({name = "" .. l_8_2, w = l_8_4, x = l_8_5})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_8_0._tree_tab:text({name = "tree_tab_name", text = utf8.to_upper(managers.localization:text(l_8_3.name_id)), layer = 1, wrap = false})
  {name = "tree_tab_name", text = utf8.to_upper(managers.localization:text(l_8_3.name_id)), layer = 1, wrap = false}.vertical, {name = "tree_tab_name", text = utf8.to_upper(managers.localization:text(l_8_3.name_id)), layer = 1, wrap = false}.align, {name = "tree_tab_name", text = utf8.to_upper(managers.localization:text(l_8_3.name_id)), layer = 1, wrap = false}.color, {name = "tree_tab_name", text = utf8.to_upper(managers.localization:text(l_8_3.name_id)), layer = 1, wrap = false}.font_size, {name = "tree_tab_name", text = utf8.to_upper(managers.localization:text(l_8_3.name_id)), layer = 1, wrap = false}.font, {name = "tree_tab_name", text = utf8.to_upper(managers.localization:text(l_8_3.name_id)), layer = 1, wrap = false}.word_wrap = "center", "center", tweak_data.screen_colors.button_stage_3, tweak_data.menu.pd2_medium_font_size, tweak_data.menu.pd2_medium_font, false
  local _, _, tw, th = l_8_0._tree_tab:child("tree_tab_name"):text_rect()
  l_8_0._tree_tab:set_size(tw + 15, th + 10)
  l_8_0._tree_tab:child("tree_tab_name"):set_size(l_8_0._tree_tab:size())
  l_8_0._tree_tab:bitmap({name = "tree_tab_select_rect", texture = "guis/textures/pd2/shared_tab_box", w = l_8_0._tree_tab:w(), h = l_8_0._tree_tab:h(), layer = 0, color = tweak_data.screen_colors.text, visible = false})
  l_8_0._tree_tab:move(0, 0)
end

SkillTreeTabItem.set_active = function(l_9_0, l_9_1)
  l_9_0._active = l_9_1
  l_9_0:refresh()
end

SkillTreeTabItem.tree = function(l_10_0)
  return l_10_0._tree
end

SkillTreeTabItem.inside = function(l_11_0, l_11_1, l_11_2)
  return l_11_0._tree_tab:inside(l_11_1, l_11_2)
end

SkillTreeTabItem.refresh = function(l_12_0)
  if l_12_0._active then
    l_12_0._tree_tab:child("tree_tab_select_rect"):show()
    l_12_0._tree_tab:child("tree_tab_name"):set_color(tweak_data.screen_colors.button_stage_1)
    l_12_0._tree_tab:child("tree_tab_name"):set_blend_mode("normal")
  elseif l_12_0._selected then
    l_12_0._tree_tab:child("tree_tab_select_rect"):hide()
    l_12_0._tree_tab:child("tree_tab_name"):set_color(tweak_data.screen_colors.button_stage_2)
    l_12_0._tree_tab:child("tree_tab_name"):set_blend_mode("add")
  else
    l_12_0._tree_tab:child("tree_tab_select_rect"):hide()
    l_12_0._tree_tab:child("tree_tab_name"):set_color(tweak_data.screen_colors.button_stage_3)
    l_12_0._tree_tab:child("tree_tab_name"):set_blend_mode("add")
  end
end

if not SkillTreeSkillItem then
  SkillTreeSkillItem = class(SkillTreeItem)
end
SkillTreeSkillItem.init = function(l_13_0, l_13_1, l_13_2, l_13_3, l_13_4, l_13_5, l_13_6, l_13_7, l_13_8, l_13_9)
  SkillTreeSkillItem.super.init(l_13_0)
  l_13_0._skill_id = l_13_1
  l_13_0._tree = l_13_5
  l_13_0._tier = l_13_6
  local skill_panel = l_13_2:panel({name = l_13_1, w = l_13_7, h = l_13_8})
  l_13_0._skill_panel = skill_panel
  l_13_0._skill_refresh_skills = l_13_9
  local skill = tweak_data.skilltree.skills[l_13_1]
  l_13_0._skill_name = managers.localization:text(skill.name_id)
  local texture_rect_x = skill.icon_xy and skill.icon_xy[1] or 0
  local texture_rect_y = skill.icon_xy and skill.icon_xy[2] or 0
  l_13_0._base_size = l_13_8 - 10
  local state_image = skill_panel:bitmap({name = "state_image", texture = "guis/textures/pd2/skilltree/icons_atlas", texture_rect = {texture_rect_x * 64, texture_rect_y * 64, 64, 64}, color = tweak_data.screen_colors.item_stage_3, layer = 1})
  state_image:set_size(l_13_0._base_size, l_13_0._base_size)
  state_image:set_blend_mode("add")
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local skill_text = skill_panel:text({name = "skill_text", text = "", layer = 3, wrap = true, word_wrap = true, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, align = "left", vertical = "center", color = tweak_data.screen_colors.text})
  state_image:set_x(5)
  {name = "skill_text", text = "", layer = 3, wrap = true, word_wrap = true, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, align = "left", vertical = "center", color = tweak_data.screen_colors.text}.w, {name = "skill_text", text = "", layer = 3, wrap = true, word_wrap = true, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, align = "left", vertical = "center", color = tweak_data.screen_colors.text}.x, {name = "skill_text", text = "", layer = 3, wrap = true, word_wrap = true, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, align = "left", vertical = "center", color = tweak_data.screen_colors.text}.blend_mode = skill_panel:w() - l_13_0._base_size - 10, l_13_0._base_size + 10, "add"
  state_image:set_center_y(skill_panel:h() / 2)
  l_13_0._inside_panel = skill_panel:panel({w = l_13_7 - 10, h = l_13_8 - 10})
  l_13_0._inside_panel:set_center(skill_panel:w() / 2, skill_panel:h() / 2)
  local cx = l_13_2:w() / l_13_3
  skill_panel:set_x((l_13_4 - 1) * l_13_7)
  l_13_0._box = BoxGuiObject:new(skill_panel, {sides = {2, 2, 2, 2}})
  l_13_0._box:hide()
  local state_indicator = skill_panel:bitmap({name = "state_indicator", texture = "guis/textures/pd2/skilltree/ace", alpha = 0, color = Color.white:with_alpha(1), layer = 0})
  state_indicator:set_size(state_image:w() * 2, state_image:h() * 2)
  state_indicator:set_blend_mode("add")
  state_indicator:set_rotation(360)
  state_indicator:set_center(state_image:center())
end

SkillTreeSkillItem.tier = function(l_14_0)
  return l_14_0._tier
end

SkillTreeSkillItem.skill_id = function(l_15_0)
  return l_15_0._skill_id
end

SkillTreeSkillItem.tree = function(l_16_0)
  return l_16_0._tree
end

SkillTreeSkillItem.link = function(l_17_0, l_17_1, l_17_2)
  if l_17_1 == 1 then
    l_17_0._left_item = l_17_2[2]
    l_17_0._up_item = l_17_2[3]
    l_17_0._right_item = l_17_2[4]
  elseif (l_17_1 % 3 == 2 or not l_17_2[l_17_1 - 1]) then
     -- DECOMPILER ERROR: Attempted to build a boolean expression without a pending context

    l_17_0._left_item = error_maybe_false
  end
  l_17_0._right_item = (l_17_1 % 3 ~= 1 and l_17_2[l_17_1 + 1])
  l_17_0._up_item = l_17_2[math.max(1, l_17_1 + 3)]
  l_17_0._down_item = l_17_2[math.max(1, l_17_1 - 3)]
end

SkillTreeSkillItem.inside = function(l_18_0, l_18_1, l_18_2)
  return l_18_0._inside_panel:inside(l_18_1, l_18_2)
end

SkillTreeSkillItem.flash = function(l_19_0)
  local skill_text = l_19_0._skill_panel:child("skill_text")
  local state_image = l_19_0._skill_panel:child("state_image")
  local box = l_19_0._box
  local flash_anim = function(l_1_0)
    local st_color = skill_text:color()
    local si_color = state_image:color()
    local b_color = box:color()
    local s = 0
    over(0.5, function(l_1_0)
      s = math.min(1, math.sin(l_1_0 * 180) * 2)
      skill_text:set_color(math.lerp(st_color, tweak_data.screen_colors.important_1, s))
      state_image:set_color(math.lerp(si_color, tweak_data.screen_colors.important_1, s))
      box:set_color(math.lerp(b_color, tweak_data.screen_colors.important_1, s))
      end)
    skill_text:set_color(st_color)
    state_image:set_color(si_color)
    box:set_color(b_color)
   end
  managers.menu_component:post_event("selection_next")
  l_19_0:refresh(l_19_0._locked)
  l_19_0._skill_panel:animate(flash_anim)
end

SkillTreeSkillItem.refresh = function(l_20_0, l_20_1)
  local skill_id = l_20_0._skill_panel:name()
  l_20_0._skill_panel:stop()
  local step = managers.skilltree:next_skill_step(skill_id)
  if not managers.skilltree:skill_unlocked(nil, skill_id) then
    local unlocked = not l_20_0._tier
  end
  local completed = managers.skilltree:skill_completed(skill_id)
  local talent = tweak_data.skilltree.skills[skill_id]
  l_20_0._locked = l_20_1
  if Application:production_build() then
    local selected = l_20_0._selected
  end
  l_20_0._box:set_visible(selected)
  l_20_0._box:set_color(tweak_data.screen_colors.item_stage_1)
  local skill_text = l_20_0._skill_panel:child("skill_text")
  local skill_text_string = ""
  if selected then
    if not l_20_0._tier then
      if step == 1 then
        skill_text_string = managers.localization:text("st_menu_unlock_profession", {profession = managers.localization:text(tweak_data.skilltree.trees[l_20_0._tree].name_id), points = Application:digest_value(tweak_data.skilltree.skills[l_20_0._skill_id][1].cost, false)})
      else
        skill_text_string = managers.localization:text("st_menu_profession_unlocked", {profession = managers.localization:text(tweak_data.skilltree.trees[l_20_0._tree].name_id)})
      end
    elseif completed then
      skill_text_string = managers.localization:text("st_menu_skill_maxed")
    elseif step == 2 then
      local points = Application:digest_value(tweak_data.skilltree.skills[l_20_0._skill_id][2].cost, false)
      local cost = managers.money:get_skillpoint_cost(l_20_0._tree, l_20_0._tier, points)
      skill_text_string = managers.localization:text("st_menu_buy_skill_pro" .. (points > 1 and "_plural" or ""), {cost = managers.experience:cash_string(cost), points = points})
    elseif not unlocked then
      skill_text_string = managers.localization:text("st_menu_skill_locked")
    elseif step == 1 then
      local points = Application:digest_value(tweak_data.skilltree.skills[l_20_0._skill_id][1].cost, false)
      local cost = managers.money:get_skillpoint_cost(l_20_0._tree, l_20_0._tier, points)
      skill_text_string = managers.localization:text("st_menu_buy_skill_basic" .. (points > 1 and "_plural" or ""), {cost = managers.experience:cash_string(cost), points = points})
    else
      skill_text_string = "MISSING"
    end
  elseif l_20_0._tier then
    if completed then
      skill_text_string = managers.localization:text("st_menu_skill_maxed")
    elseif step == 2 then
      skill_text_string = managers.localization:text("st_menu_skill_owned")
    end
  end
  skill_text:set_text(utf8.to_upper(skill_text_string))
  skill_text:set_color(tweak_data.screen_colors.item_stage_1)
  if not l_20_0._tier then
    l_20_0._skill_panel:child("state_indicator"):set_alpha(0)
    l_20_0._skill_panel:child("state_image"):set_color(tweak_data.screen_colors[(step > 1 or selected) and "item_stage_1" or "item_stage_2"])
    return 
  end
  if (not completed and not selected and step <= 1) or not tweak_data.screen_colors.item_stage_1 and (not unlocked or not tweak_data.screen_colors.item_stage_2) then
    local color = tweak_data.screen_colors.item_stage_3
  end
  l_20_0._skill_panel:child("state_image"):set_color(color)
  if completed then
    l_20_0._skill_panel:child("state_indicator"):set_alpha(1)
    return 
  end
  if unlocked then
    if step == 2 then
      do return end
    end
    l_20_0._skill_panel:child("state_indicator"):set_alpha(0)
  elseif not selected or unlocked then
    if not talent.prerequisites then
      local prerequisites = {}
    end
    for _,prerequisite in ipairs(prerequisites) do
      local req_unlocked = managers.skilltree:skill_step(prerequisite)
      if not selected or not "important_1" then
        l_20_0._skill_panel:child("state_image"):set_color(tweak_data.screen_colors[not req_unlocked or req_unlocked ~= 0 or "important_2"])
      end
      l_20_0._box:set_color(tweak_data.screen_colors[selected and "important_1" or "important_2"])
      if selected then
        skill_text:set_color(tweak_data.screen_colors.important_1)
        skill_text:set_text(utf8.to_upper(managers.localization:text("st_menu_skill_locked")))
        do return end
      end
    end
  end
end

SkillTreeSkillItem.trigger = function(l_21_0)
  if managers.skilltree:tier_unlocked(l_21_0._tree, l_21_0._tier) then
    managers.skilltree:unlock(l_21_0._tree, l_21_0._skill_id)
  end
  l_21_0:refresh(l_21_0._locked)
  return l_21_0._skill_refresh_skills
end

if not SkillTreeUnlockItem then
  SkillTreeUnlockItem = class(SkillTreeSkillItem)
end
SkillTreeUnlockItem.init = function(l_22_0, l_22_1, l_22_2, l_22_3, l_22_4, l_22_5)
  SkillTreeUnlockItem.super.init(l_22_0, l_22_1, l_22_2, 1, 2, l_22_3, nil, l_22_4, l_22_5)
end

SkillTreeUnlockItem.trigger = function(l_23_0)
  if not managers.skilltree:tree_unlocked(l_23_0._tree) then
    managers.skilltree:unlock_tree(l_23_0._tree)
    l_23_0:refresh(l_23_0._locked)
  end
end

if not SkillTreePage then
  SkillTreePage = class()
end
SkillTreePage.init = function(l_24_0, l_24_1, l_24_2, l_24_3, l_24_4, l_24_5, l_24_6)
  l_24_0._items = {}
  l_24_0._selected_item = nil
  l_24_0._tree = l_24_1
  local tree_panel = l_24_3:panel({name = tostring(l_24_1), visible = false, y = 0, w = math.round(l_24_3:w() * WIDTH_MULTIPLIER)})
  l_24_0._tree_panel = tree_panel
  l_24_0._bg_image = l_24_4:bitmap({name = "bg_image", texture = l_24_2.background_texture, w = l_24_4:w(), h = l_24_4:h(), layer = 1, blend_mode = "add"})
  l_24_0._bg_image:set_alpha(0.60000002384186)
  local aspect = l_24_4:w() / l_24_4:h()
  local texture_width = l_24_0._bg_image:texture_width()
  local texture_height = l_24_0._bg_image:texture_height()
  local sw = math.max(texture_width, texture_height * aspect)
  local sh = math.max(texture_height, texture_width / aspect)
  local dw = texture_width / sw
  local dh = texture_height / sh
  l_24_0._bg_image:set_size(dw * l_24_4:w(), dh * l_24_4:h())
  l_24_0._bg_image:set_right(l_24_4:w())
  l_24_0._bg_image:set_center_y(l_24_4:h() / 2)
  local panel_h = 0
  local h = (l_24_3:h() - l_24_5 - 70) / (8 - CONSOLE_PAGE_ADJUSTMENT)
  for i = 1, 7 do
    local color = Color.black
    local rect = tree_panel:rect({name = "rect" .. i, color = color, h = 2, blend_mode = "add"})
    rect:set_bottom(tree_panel:h() - (i - CONSOLE_PAGE_ADJUSTMENT) * h)
    do return end
    if i == 1 then
      rect:set_alpha(0)
      rect:hide()
    end
  end
  local tier_panels = tree_panel:panel({name = "tier_panels"})
  if l_24_2.skill then
    local tier_panel = tier_panels:panel({name = "tier_panel0", h = h})
    tier_panel:set_bottom(tree_panel:child("rect1"):top())
    local item = SkillTreeUnlockItem:new(l_24_2.skill, tier_panel, l_24_1, tier_panel:w() / 3, h)
    table.insert(l_24_0._items, item)
    item:refresh(false)
  end
  for tier,tier_data in ipairs(l_24_2.tiers) do
    local unlocked = managers.skilltree:tier_unlocked(l_24_1, tier)
    local tier_panel = tier_panels:panel({name = "tier_panel" .. tier, h = h})
    local num_skills = #tier_data
    tier_panel:set_bottom(tree_panel:child("rect" .. tostring(tier + 1)):top())
    local base_size = h
    local base_w = tier_panel:w() / math.max(#tier_data, 1)
    for i,skill_id in ipairs(tier_data) do
      local item = SkillTreeSkillItem:new(skill_id, tier_panel, num_skills, i, l_24_1, tier, base_w, base_size, l_24_6[skill_id])
      table.insert(l_24_0._items, item)
      item:refresh(not unlocked)
    end
    local tier_string = tostring(tier)
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    local debug_text = tier_panel:text({name = "debug_text", text = tier_string, layer = 2, wrap = false, word_wrap = false, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, h = tweak_data.menu.pd2_small_font_size, align = "right", vertical = "bottom"})
    debug_text:set_world_bottom(tree_panel:child("rect" .. tostring(tier + 1)):world_top() + 2)
    {name = "debug_text", text = tier_string, layer = 2, wrap = false, word_wrap = false, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, h = tweak_data.menu.pd2_small_font_size, align = "right", vertical = "bottom"}.rotation, {name = "debug_text", text = tier_string, layer = 2, wrap = false, word_wrap = false, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, h = tweak_data.menu.pd2_small_font_size, align = "right", vertical = "bottom"}.blend_mode, {name = "debug_text", text = tier_string, layer = 2, wrap = false, word_wrap = false, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, h = tweak_data.menu.pd2_small_font_size, align = "right", vertical = "bottom"}.color = 360, "add", tweak_data.screen_colors.item_stage_3
    local _, _, tw, _ = debug_text:text_rect()
    debug_text:move(tw * 2, 0)
    local lock_image = tier_panel:bitmap({name = "lock", texture = "guis/textures/pd2/skilltree/padlock", layer = 3, w = tweak_data.menu.pd2_small_font_size, h = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.item_stage_3})
    lock_image:set_blend_mode("add")
    lock_image:set_rotation(360)
    lock_image:set_world_position(debug_text:world_right(), debug_text:world_y() - 2)
    lock_image:set_visible(false)
    local cost_string = (Application:digest_value(tweak_data.skilltree.tier_unlocks[tier], false) < 10 and "0" or "") .. tostring(Application:digest_value(tweak_data.skilltree.tier_unlocks[tier], false))
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    local cost_text = tier_panel:text({name = "cost_text", text = cost_string, layer = 2, wrap = false, word_wrap = false, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, h = tweak_data.menu.pd2_small_font_size, align = "left", vertical = "bottom"})
    cost_text:set_world_bottom(tree_panel:child("rect" .. tostring(tier + 1)):world_top() + 2)
    {name = "cost_text", text = cost_string, layer = 2, wrap = false, word_wrap = false, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, h = tweak_data.menu.pd2_small_font_size, align = "left", vertical = "bottom"}.rotation, {name = "cost_text", text = cost_string, layer = 2, wrap = false, word_wrap = false, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, h = tweak_data.menu.pd2_small_font_size, align = "left", vertical = "bottom"}.blend_mode, {name = "cost_text", text = cost_string, layer = 2, wrap = false, word_wrap = false, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, h = tweak_data.menu.pd2_small_font_size, align = "left", vertical = "bottom"}.color = 360, "add", tweak_data.screen_colors.item_stage_3
    cost_text:set_x(debug_text:right() + tw * 3)
    do
      if not unlocked or not tweak_data.screen_colors.item_stage_1 then
        local color = tweak_data.screen_colors.item_stage_2
      end
      debug_text:set_color(color)
      cost_text:set_color(color)
  end
  if not unlocked then
    end
    local ps = managers.skilltree:points_spent(l_24_0._tree)
    local max_points = 1
    for _,tier in ipairs(tweak_data.skilltree.trees[l_24_0._tree].tiers) do
      for _,skill in ipairs(tier) do
        for _,upgrade in ipairs(tweak_data.skilltree.skills[skill]) do
          max_points = max_points + Application:digest_value(upgrade.cost, false)
        end
      end
    end
    local prev_tier_p = 0
    local next_tier_p = max_points
    local ct = 0
    for i = 1, 6 do
      local tier_unlocks = Application:digest_value(tweak_data.skilltree.tier_unlocks[i], false)
      if ps < tier_unlocks then
        next_tier_p = tier_unlocks
      else
        ct = 
        prev_tier_p = tier_unlocks
      end
    end
    local diff_p = next_tier_p - prev_tier_p
    local diff_ps = ps - prev_tier_p
    local dh = l_24_0._tree_panel:child("rect2"):bottom()
    local prev_tier_object = l_24_0._tree_panel:child("rect" .. tostring(ct + 1))
    local next_tier_object = l_24_0._tree_panel:child("rect" .. tostring(ct + 2))
    local prev_tier_y = prev_tier_object and prev_tier_object:top() or 0
    local next_tier_y = next_tier_object and next_tier_object:top() or 0
    if not next_tier_object then
      next_tier_object = l_24_0._tree_panel:child("rect" .. tostring(ct))
      next_tier_y = next_tier_object and next_tier_object:top() or 0
      next_tier_y = 2 * prev_tier_y - (next_tier_y)
    end
    if ct > 0 then
      dh = math.max(2, tier_panels:child("tier_panel1"):world_bottom() - math.lerp(prev_tier_y, next_tier_y, diff_ps / diff_p))
    else
      dh = 0
    end
    do
      local points_spent_panel = tree_panel:panel({name = "points_spent_panel", w = 4, h = dh})
      l_24_0._points_spent_line = BoxGuiObject:new(points_spent_panel, {sides = {2, 2, 0, 0}})
      l_24_0._points_spent_line:set_clipping(dh == 0)
      points_spent_panel:set_world_center_x(tier_panels:child("tier_panel1"):child("lock"):world_center())
      points_spent_panel:set_world_bottom(tier_panels:child("tier_panel1"):world_bottom())
      for i,item in ipairs(l_24_0._items) do
        item:link(i, l_24_0._items)
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

SkillTreePage.unlock_tier = function(l_25_0, l_25_1)
  local tier_panels = l_25_0._tree_panel:child("tier_panels")
  local tier_panel = tier_panels:child("tier_panel" .. l_25_1)
  tier_panel:child("lock"):hide()
  local color = tweak_data.screen_colors.item_stage_1
  l_25_0._tree_panel:child("rect" .. tostring(l_25_1 + 1)):set_color(color)
  tier_panel:child("debug_text"):set_color(color)
  tier_panel:child("cost_text"):set_color(color)
  for _,item in ipairs(l_25_0._items) do
    item:refresh(false)
  end
end

SkillTreePage.on_points_spent = function(l_26_0)
  local points_spent_panel = l_26_0._tree_panel:child("points_spent_panel")
  local tier_panels = l_26_0._tree_panel:child("tier_panels")
  local ps = managers.skilltree:points_spent(l_26_0._tree)
  local max_points = 1
  for _,tier in ipairs(tweak_data.skilltree.trees[l_26_0._tree].tiers) do
    for _,skill in ipairs(tier) do
      for _,upgrade in ipairs(tweak_data.skilltree.skills[skill]) do
        max_points = max_points + Application:digest_value(upgrade.cost, false)
      end
    end
  end
  local prev_tier_p = 0
  local next_tier_p = max_points
  local ct = 0
  for i = 1, 6 do
    local tier_unlocks = Application:digest_value(tweak_data.skilltree.tier_unlocks[i], false)
    if ps < tier_unlocks then
      next_tier_p = tier_unlocks
    else
      ct = 
      prev_tier_p = tier_unlocks
    end
  end
  local diff_p = next_tier_p - prev_tier_p
  local diff_ps = ps - prev_tier_p
  local dh = l_26_0._tree_panel:child("rect2"):bottom()
  local prev_tier_object = l_26_0._tree_panel:child("rect" .. tostring(ct + 1))
  local next_tier_object = l_26_0._tree_panel:child("rect" .. tostring(ct + 2))
  local prev_tier_y = prev_tier_object and prev_tier_object:top() or 0
  local next_tier_y = next_tier_object and next_tier_object:top() or 0
  if not next_tier_object then
    next_tier_object = l_26_0._tree_panel:child("rect" .. tostring(ct))
    next_tier_y = next_tier_object and next_tier_object:top() or 0
    next_tier_y = 2 * prev_tier_y - (next_tier_y)
  end
  if ct > 0 then
    dh = math.max(2, tier_panels:child("tier_panel1"):world_bottom() - math.lerp(prev_tier_y, next_tier_y, diff_ps / diff_p))
  else
    dh = 0
  end
  points_spent_panel:set_h(dh)
  l_26_0._points_spent_line:create_sides(points_spent_panel, {sides = {2, 2, 2, 2}})
  l_26_0._points_spent_line:set_clipping(dh == 0)
  points_spent_panel:set_world_center_x(tier_panels:child("tier_panel1"):child("lock"):world_center())
  points_spent_panel:set_world_bottom(tier_panels:child("tier_panel1"):world_bottom())
end

SkillTreePage.item = function(l_27_0, l_27_1)
  return l_27_0._items[l_27_1 or 1]
end

SkillTreePage.activate = function(l_28_0)
  l_28_0._tree_panel:set_visible(true)
  l_28_0._bg_image:set_visible(true)
end

SkillTreePage.deactivate = function(l_29_0)
  l_29_0._tree_panel:set_visible(false)
  l_29_0._bg_image:set_visible(false)
end

if not SkillTreeGui then
  SkillTreeGui = class()
end
SkillTreeGui.init = function(l_30_0, l_30_1, l_30_2, l_30_3)
  managers.menu:active_menu().renderer.ws:hide()
  l_30_0._ws = l_30_1
  l_30_0._fullscreen_ws = l_30_2
  l_30_0._node = l_30_3
  l_30_0._init_layer = l_30_0._ws:panel():layer()
  l_30_0._selected_item = nil
  l_30_0._active_page = nil
  l_30_0._active_tree = nil
  l_30_0._prerequisites_links = {}
  managers.menu_component:close_contract_gui()
  l_30_0:_setup()
  l_30_0:set_layer(1000)
end

SkillTreeGui.make_fine_text = function(l_31_0, l_31_1)
  local x, y, w, h = l_31_1:text_rect()
  l_31_1:set_size(w, h)
  l_31_1:set_position(math.round(l_31_1:x()), math.round(l_31_1:y()))
end

SkillTreeGui._setup = function(l_32_0)
  managers.menu_component:test_camera_shutter_tech()
  if alive(l_32_0._panel) then
    l_32_0._ws:panel():remove(l_32_0._panel)
  end
  local scaled_size = managers.gui_data:scaled_size()
  l_32_0._panel = l_32_0._ws:panel():panel({visible = true, layer = l_32_0._init_layer, valign = "center"})
  l_32_0._fullscreen_panel = l_32_0._fullscreen_ws:panel():panel()
  WalletGuiObject.set_wallet(l_32_0._panel)
  l_32_0._panel:text({name = "skilltree_text", text = utf8.to_upper(managers.localization:text("menu_skilltree")), align = "left", vertical = "top", h = tweak_data.menu.pd2_large_font_size, font_size = tweak_data.menu.pd2_large_font_size, font = tweak_data.menu.pd2_large_font, color = tweak_data.screen_colors.text})
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local bg_text = l_32_0._fullscreen_panel:text({name = "skilltree_text", text = utf8.to_upper(managers.localization:text("menu_skilltree")), h = 90, align = "left", vertical = "top", font_size = tweak_data.menu.pd2_massive_font_size})
  local x, y = managers.gui_data:safe_to_full_16_9(managers.gui_data, l_32_0._panel:child("skilltree_text"):world_x(), l_32_0._panel:child("skilltree_text"):world_center_y())
  bg_text:set_world_left(x)
  {name = "skilltree_text", text = utf8.to_upper(managers.localization:text("menu_skilltree")), h = 90, align = "left", vertical = "top", font_size = tweak_data.menu.pd2_massive_font_size}.layer, {name = "skilltree_text", text = utf8.to_upper(managers.localization:text("menu_skilltree")), h = 90, align = "left", vertical = "top", font_size = tweak_data.menu.pd2_massive_font_size}.blend_mode, {name = "skilltree_text", text = utf8.to_upper(managers.localization:text("menu_skilltree")), h = 90, align = "left", vertical = "top", font_size = tweak_data.menu.pd2_massive_font_size}.alpha, {name = "skilltree_text", text = utf8.to_upper(managers.localization:text("menu_skilltree")), h = 90, align = "left", vertical = "top", font_size = tweak_data.menu.pd2_massive_font_size}.color, {name = "skilltree_text", text = utf8.to_upper(managers.localization:text("menu_skilltree")), h = 90, align = "left", vertical = "top", font_size = tweak_data.menu.pd2_massive_font_size}.font = 1, "add", 0.40000000596046, tweak_data.screen_colors.button_stage_3, tweak_data.menu.pd2_massive_font
  bg_text:set_world_center_y(y)
  bg_text:move(-13, 9)
  MenuBackdropGUI.animate_bg_text(l_32_0, bg_text)
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  local points_text = l_32_0._panel:text({name = "points_text", text = utf8.to_upper(managers.localization:text("st_menu_available_skill_points", {points = managers.skilltree:points()})), layer = 1, wrap = false})
  points_text:set_left(l_32_0._panel:w() * WIDTH_MULTIPLIER * 2 / 3 + 10)
  {name = "points_text", text = utf8.to_upper(managers.localization:text("st_menu_available_skill_points", {points = managers.skilltree:points()})), layer = 1, wrap = false}.vertical, {name = "points_text", text = utf8.to_upper(managers.localization:text("st_menu_available_skill_points", {points = managers.skilltree:points()})), layer = 1, wrap = false}.align, {name = "points_text", text = utf8.to_upper(managers.localization:text("st_menu_available_skill_points", {points = managers.skilltree:points()})), layer = 1, wrap = false}.color, {name = "points_text", text = utf8.to_upper(managers.localization:text("st_menu_available_skill_points", {points = managers.skilltree:points()})), layer = 1, wrap = false}.font_size, {name = "points_text", text = utf8.to_upper(managers.localization:text("st_menu_available_skill_points", {points = managers.skilltree:points()})), layer = 1, wrap = false}.font, {name = "points_text", text = utf8.to_upper(managers.localization:text("st_menu_available_skill_points", {points = managers.skilltree:points()})), layer = 1, wrap = false}.word_wrap = "top", "left", tweak_data.screen_colors.text, tweak_data.menu.pd2_medium_font_size, tweak_data.menu.pd2_medium_font, false
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  if managers.menu:is_pc_controller() then
    l_32_0._panel:text({name = "back_button", text = utf8.to_upper(managers.localization:text("menu_back"))})
    {name = "back_button", text = utf8.to_upper(managers.localization:text("menu_back"))}.color, {name = "back_button", text = utf8.to_upper(managers.localization:text("menu_back"))}.blend_mode, {name = "back_button", text = utf8.to_upper(managers.localization:text("menu_back"))}.font, {name = "back_button", text = utf8.to_upper(managers.localization:text("menu_back"))}.font_size, {name = "back_button", text = utf8.to_upper(managers.localization:text("menu_back"))}.h, {name = "back_button", text = utf8.to_upper(managers.localization:text("menu_back"))}.vertical, {name = "back_button", text = utf8.to_upper(managers.localization:text("menu_back"))}.align = tweak_data.screen_colors.button_stage_3, "add", tweak_data.menu.pd2_large_font, tweak_data.menu.pd2_large_font_size, tweak_data.menu.pd2_large_font_size, "bottom", "right"
    l_32_0:make_fine_text(l_32_0._panel:child("back_button"))
    l_32_0._panel:child("back_button"):set_right(l_32_0._panel:w())
    l_32_0._panel:child("back_button"):set_bottom(l_32_0._panel:h())
     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

    local bg_back = l_32_0._fullscreen_panel:text({name = "back_button", text = utf8.to_upper(managers.localization:text("menu_back")), h = 90, align = "right", vertical = "bottom", blend_mode = "add"})
    local x, y = managers.gui_data:safe_to_full_16_9(managers.gui_data, l_32_0._panel:child("back_button"):world_right(), l_32_0._panel:child("back_button"):world_center_y())
    bg_back:set_world_right(x)
    {name = "back_button", text = utf8.to_upper(managers.localization:text("menu_back")), h = 90, align = "right", vertical = "bottom", blend_mode = "add"}.layer, {name = "back_button", text = utf8.to_upper(managers.localization:text("menu_back")), h = 90, align = "right", vertical = "bottom", blend_mode = "add"}.alpha, {name = "back_button", text = utf8.to_upper(managers.localization:text("menu_back")), h = 90, align = "right", vertical = "bottom", blend_mode = "add"}.color, {name = "back_button", text = utf8.to_upper(managers.localization:text("menu_back")), h = 90, align = "right", vertical = "bottom", blend_mode = "add"}.font, {name = "back_button", text = utf8.to_upper(managers.localization:text("menu_back")), h = 90, align = "right", vertical = "bottom", blend_mode = "add"}.font_size = 1, 0.40000000596046, tweak_data.screen_colors.button_stage_3, tweak_data.menu.pd2_massive_font, tweak_data.menu.pd2_massive_font_size
    bg_back:set_world_center_y(y)
    bg_back:move(13, -9)
    MenuBackdropGUI.animate_bg_text(l_32_0, bg_back)
  end
  local prefix = not managers.menu:is_pc_controller() and managers.localization:get_default_macro("BTN_Y") or ""
  l_32_0._panel:text({name = "respec_tree_button", text = prefix .. managers.localization:to_upper_text("st_menu_respec_tree"), align = "left", vertical = "top", font_size = tweak_data.menu.pd2_medium_font_size, font = tweak_data.menu.pd2_medium_font, color = Color.black, blend_mode = "add"})
  l_32_0:make_fine_text(l_32_0._panel:child("respec_tree_button"))
  l_32_0._panel:child("respec_tree_button"):set_left(points_text:left())
  l_32_0._respec_text_id = "st_menu_respec_tree"
  local black_rect = l_32_0._fullscreen_panel:rect({color = Color(0.20000000298023, 0, 0, 0), layer = 1})
  local blur = l_32_0._fullscreen_panel:bitmap({texture = "guis/textures/test_blur_df", w = l_32_0._fullscreen_ws:panel():w(), h = l_32_0._fullscreen_ws:panel():h(), render_template = "VertexColorTexturedBlur3D"})
  local func = function(l_1_0)
    over(0.60000002384186, function(l_1_0)
      o:set_alpha(l_1_0)
      end)
   end
  blur:animate(func)
  local tree_tab_h = math.round(l_32_0._panel:h() / 14)
  local tree_tabs_panel = l_32_0._panel:panel({name = "tree_tabs_panel", h = tree_tab_h, y = 70})
  local skill_title_panel = l_32_0._panel:panel({name = "skill_title_panel", w = math.round(l_32_0._panel:w() * 0.40000000596046 - 54), h = math.round(tweak_data.menu.pd2_medium_font_size * 2)})
  l_32_0._skill_title_panel = skill_title_panel
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  skill_title_panel:text({name = "text", text = "", layer = 1, font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, color = tweak_data.screen_colors.text})
  {name = "text", text = "", layer = 1, font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, color = tweak_data.screen_colors.text}.blend_mode, {name = "text", text = "", layer = 1, font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, color = tweak_data.screen_colors.text}.word_wrap, {name = "text", text = "", layer = 1, font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, color = tweak_data.screen_colors.text}.wrap, {name = "text", text = "", layer = 1, font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, color = tweak_data.screen_colors.text}.vertical, {name = "text", text = "", layer = 1, font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, color = tweak_data.screen_colors.text}.align = "add", true, true, "top", "left"
  local skill_description_panel = l_32_0._panel:panel({name = "skill_description_panel", w = math.round(l_32_0._panel:w() * (1 - WIDTH_MULTIPLIER) - BOX_GAP), h = math.round(l_32_0._panel:h() * 0.80000001192093)})
  l_32_0._skill_description_panel = skill_description_panel
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  skill_description_panel:text({name = "text", text = "", layer = 1, wrap = false, word_wrap = false, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, align = "left", vertical = "top", halign = "scale", valign = "scale"})
  {name = "text", text = "", layer = 1, wrap = false, word_wrap = false, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, align = "left", vertical = "top", halign = "scale", valign = "scale"}.word_wrap, {name = "text", text = "", layer = 1, wrap = false, word_wrap = false, font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, color = tweak_data.screen_colors.text, align = "left", vertical = "top", halign = "scale", valign = "scale"}.wrap = true, true
  skill_description_panel:text({name = "prerequisites_text", text = "", layer = 1, wrap = false, word_wrap = false, blend_mode = "add", font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, h = tweak_data.menu.pd2_small_font_size + 10, color = tweak_data.screen_colors.important_1, align = "left", vertical = "top", halign = "scale", valign = "scale", wrap = true, word_wrap = true})
  l_32_0._tab_items = {}
  l_32_0._pages_order = {}
  l_32_0._pages = {}
  local tab_x = 0
  if not managers.menu:is_pc_controller() then
    local prev_page = tree_tabs_panel:text({name = "prev_page", y = 0, w = 0, h = tweak_data.menu.pd2_medium_font_size, font_size = tweak_data.menu.pd2_medium_font_size, font = tweak_data.menu.pd2_medium_font, layer = 2, text = managers.localization:get_default_macro("BTN_BOTTOM_L")})
    local _, _, w = prev_page:text_rect()
    prev_page:set_w(w)
    prev_page:set_left(tab_x)
    tab_x = math.round(tab_x + w + 15)
  end
  local skill_prerequisites = {}
  for skill_id,data in pairs(tweak_data.skilltree.skills) do
    if data.prerequisites then
      for _,id in ipairs(data.prerequisites) do
        if not skill_prerequisites[id] then
          skill_prerequisites[id] = {}
        end
        table.insert(skill_prerequisites[id], skill_id)
      end
    end
  end
  for tree,data in pairs(tweak_data.skilltree.trees) do
    local w = math.round(tree_tabs_panel:w() / #tweak_data.skilltree.trees * WIDTH_MULTIPLIER)
    local tab_item = SkillTreeTabItem:new(tree_tabs_panel, tree, data, w, tab_x)
    table.insert(l_32_0._tab_items, tab_item)
    local page = SkillTreePage:new(tree, data, l_32_0._panel, l_32_0._fullscreen_panel, tab_item._tree_tab:h(), skill_prerequisites)
    table.insert(l_32_0._pages_order, tree)
    l_32_0._pages[tree] = page
    local _, _, tw, _ = l_32_0._tab_items[tree]._tree_tab:child("tree_tab_name"):text_rect()
    tab_x = math.round(tab_x + tw + 15 + 5)
  end
  local top_tier_panel = l_32_0._panel:child("1"):child("tier_panels"):child("tier_panel" .. tostring(#tweak_data.skilltree.trees[1].tiers))
  local bottom_tier_panel = l_32_0._panel:child("1"):child("tier_panels"):child("tier_panel1")
  skill_description_panel:set_right(l_32_0._panel:w())
  skill_description_panel:set_h(bottom_tier_panel:world_bottom() - top_tier_panel:world_top())
  skill_description_panel:set_world_top(top_tier_panel:world_top())
  local skill_box_panel = l_32_0._panel:panel({w = skill_description_panel:w(), h = skill_description_panel:h()})
  skill_box_panel:set_position(skill_description_panel:position())
  BoxGuiObject:new(skill_box_panel, {sides = {1, 1, 1, 1}})
  points_text:set_top(skill_box_panel:bottom() + 10)
  local _, _, _, pth = points_text:text_rect()
  points_text:set_h(pth)
  local respec_tree_button = l_32_0._panel:child("respec_tree_button")
  if alive(respec_tree_button) then
    respec_tree_button:set_top(points_text:bottom())
  end
  skill_title_panel:set_left(skill_box_panel:left() + 10)
  skill_title_panel:set_top(skill_box_panel:top() + 10)
  skill_title_panel:set_w(skill_box_panel:w() - 20)
  skill_description_panel:set_top(skill_title_panel:bottom())
  skill_description_panel:set_h(skill_box_panel:h() - 20 - skill_title_panel:h())
  skill_description_panel:set_left(skill_box_panel:left() + 10)
  skill_description_panel:set_w(skill_box_panel:w() - 20)
  local tiers_box_panel = l_32_0._panel:panel({name = "tiers_box_panel"})
  tiers_box_panel:set_world_shape(top_tier_panel:world_left(), top_tier_panel:world_top(), top_tier_panel:w(), bottom_tier_panel:world_bottom() - top_tier_panel:world_top())
  BoxGuiObject:new(tiers_box_panel, {sides = {1, 1, 2, 1}})
  if not managers.menu:is_pc_controller() then
    local next_page = tree_tabs_panel:text({name = "next_page", y = 0, w = 0, h = tweak_data.menu.pd2_medium_font_size, font_size = tweak_data.menu.pd2_medium_font_size, font = tweak_data.menu.pd2_medium_font, layer = 2, text = managers.localization:get_default_macro("BTN_BOTTOM_R")})
    local _, _, w = next_page:text_rect()
    next_page:set_w(w)
    next_page:set_right(tree_tabs_panel:w() * WIDTH_MULTIPLIER)
  end
  l_32_0:set_active_page(managers.skilltree:get_most_progressed_tree())
  l_32_0:set_selected_item(l_32_0._active_page:item(), true)
end

SkillTreeGui.activate_next_tree_panel = function(l_33_0, l_33_1)
  for i,tree_name in ipairs(l_33_0._pages_order) do
    if tree_name == l_33_0._active_tree then
      if i == #l_33_0._pages_order then
        return 
      end
      local next_i = i + 1
      l_33_0:set_active_page(l_33_0._pages_order[next_i], l_33_1)
      return true
    end
  end
end

SkillTreeGui.activate_prev_tree_panel = function(l_34_0, l_34_1)
  for i,tree_name in ipairs(l_34_0._pages_order) do
    if tree_name == l_34_0._active_tree then
      if i == 1 then
        return 
      end
      local prev_i = i - 1
      l_34_0:set_active_page(l_34_0._pages_order[prev_i], l_34_1)
      return true
    end
  end
end

SkillTreeGui.set_active_page = function(l_35_0, l_35_1, l_35_2)
  for tree,page in pairs(l_35_0._pages) do
    if tree == l_35_1 then
      if l_35_0._selected_item then
        l_35_0._selected_item:deselect()
        l_35_0._selected_item = nil
      end
      end
      for (for control),tree in (for generator) do
      end
       -- DECOMPILER ERROR: Overwrote pending register.

      page:activate()(item)
    end
    l_35_0._active_page = l_35_0._pages[l_35_1]
    l_35_0._active_tree = l_35_1
    local prev_page_button = l_35_0._panel:child("tree_tabs_panel"):child("prev_page")
    local next_page_button = l_35_0._panel:child("tree_tabs_panel"):child("next_page")
    if l_35_0._active_tree <= 1 then
      prev_page_button:set_visible(not prev_page_button)
    end
    if l_35_0._active_tree >= #l_35_0._pages then
      next_page_button:set_visible(not next_page_button)
    end
    do
      local respec_cost_text = l_35_0._panel:child("respec_cost_text")
      if alive(respec_cost_text) then
        respec_cost_text:set_text(managers.localization:text("st_menu_respec_cost", {cost = managers.experience:cash_string(managers.money:get_skilltree_tree_respec_cost(l_35_1))}))
        l_35_0:make_fine_text(respec_cost_text)
        respec_cost_text:set_bottom(l_35_0._panel:child("money_text"):top())
      end
      l_35_0:check_respec_button(nil, nil, true)
      if l_35_2 then
        managers.menu_component:post_event("highlight")
      end
      for _,tab_item in ipairs(l_35_0._tab_items) do
        tab_item:set_active(l_35_1 == tab_item:tree())
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

SkillTreeGui.set_layer = function(l_36_0, l_36_1)
  l_36_0._panel:set_layer(l_36_0._init_layer + l_36_1)
end

SkillTreeGui.layer = function(l_37_0)
  return l_37_0._panel:layer()
end

SkillTreeGui.set_selected_item = function(l_38_0, l_38_1, l_38_2)
  if l_38_0._selected_item ~= l_38_1 then
    if l_38_0._selected_item then
      l_38_0._selected_item:deselect()
    end
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if l_38_1.tree and l_38_2 and l_38_0._active_tree ~= l_38_1:tree() then
      l_38_2 = not l_38_1
    end
    l_38_1:select(l_38_2)
    l_38_0._selected_item = l_38_1
  end
  local text = ""
  local prerequisite_text = ""
  local title_text = ""
  if not l_38_0._prerequisites_links then
    l_38_0._prerequisites_links = {}
  end
  for _,data in ipairs(l_38_0._prerequisites_links) do
    if data ~= l_38_1 then
      data:refresh()
    end
  end
  l_38_0._prerequisites_links = {}
  local can_afford = {}
  local tier_bonus_text = ""
  if l_38_0._selected_item and l_38_0._selected_item._skill_panel then
    local skill_id = l_38_0._selected_item._skill_id
    local tweak_data_skill = tweak_data.skilltree.skills[skill_id]
    local basic_cost = tweak_data_skill[1] and tweak_data_skill[1].cost and Application:digest_value(tweak_data_skill[1].cost, false) or 0
    local pro_cost = tweak_data_skill[2] and tweak_data_skill[2].cost and Application:digest_value(tweak_data_skill[2].cost, false) or 0
    local talent = tweak_data.skilltree.skills[skill_id]
    local unlocked = managers.skilltree:skill_unlocked(nil, skill_id)
    local step = managers.skilltree:next_skill_step(skill_id)
    local completed = managers.skilltree:skill_completed(skill_id)
    local points = managers.skilltree:points()
    local spending_money = managers.money:total()
    if step > 1 then
      basic_cost = utf8.to_upper(managers.localization:text("st_menu_skill_owned"))
      can_afford[1] = true
    else
      local money_cost = managers.money:get_skillpoint_cost(l_38_0._selected_item._tree, l_38_0._selected_item._tier, tweak_data_skill[1] and tweak_data_skill[1].cost and Application:digest_value(tweak_data_skill[1].cost, false) or 0)
      can_afford[1] = basic_cost <= points and money_cost <= spending_money
      basic_cost = managers.localization:text(basic_cost == 1 and "st_menu_point" or "st_menu_point_plural", {points = basic_cost}) .. " / " .. managers.experience:cash_string(money_cost)
    end
    if step > 2 then
      pro_cost = utf8.to_upper(managers.localization:text("st_menu_skill_owned"))
      can_afford[2] = true
    else
      local money_cost = managers.money:get_skillpoint_cost(l_38_0._selected_item._tree, l_38_0._selected_item._tier, tweak_data_skill[2] and tweak_data_skill[2].cost and Application:digest_value(tweak_data_skill[2].cost, false) or 0)
      can_afford[2] = pro_cost <= points and money_cost <= spending_money
      pro_cost = managers.localization:text(pro_cost == 1 and "st_menu_point" or "st_menu_point_plural", {points = pro_cost}) .. " / " .. managers.experience:cash_string(money_cost)
    end
    title_text = utf8.to_upper(managers.localization:text(tweak_data.skilltree.skills[skill_id].name_id))
    text = managers.localization:text(tweak_data_skill.desc_id, {basic = basic_cost, pro = pro_cost})
    if not unlocked then
      if not managers.skilltree:points_spent(l_38_0._selected_item._tree) then
        local point_spent = not l_38_0._selected_item._tier or 0
      end
      local tier_unlocks = Application:digest_value(tweak_data.skilltree.tier_unlocks[l_38_0._selected_item._tier], false) or 0
      prerequisite_text = prerequisite_text .. managers.localization:text("st_menu_points_to_unlock_tier", {points = tier_unlocks - point_spent, tier = l_38_0._selected_item._tier}) .. "\n"
    end
    tier_bonus_text = "\n\n" .. utf8.to_upper(managers.localization:text(unlocked and "st_menu_tier_unlocked" or "st_menu_tier_locked")) .. "\n" .. managers.localization:text(tweak_data.skilltree.skills[tweak_data.skilltree.trees[l_38_0._selected_item._tree].skill][l_38_0._selected_item._tier].desc_id)
    if not talent.prerequisites then
      local prerequisites = {}
    end
    local add_prerequisite = true
    for _,prerequisite in ipairs(prerequisites) do
      local unlocked = managers.skilltree:skill_step(prerequisite)
      if add_prerequisite then
        if #prerequisites <= 1 or not "_plural" then
          prerequisite_text = prerequisite_text .. managers.localization:text("st_menu_prerequisite_following_skill" .. (not unlocked or unlocked ~= 0 or ""))
          add_prerequisite = nil
        end
        prerequisite_text = prerequisite_text .. "   " .. managers.localization:text(tweak_data.skilltree.skills[prerequisite].name_id) .. "\n"
        if l_38_0._active_page then
          for _,item in ipairs(l_38_0._active_page._items) do
            if item._skill_id == prerequisite then
              item._skill_panel:child("state_image"):set_color(tweak_data.screen_colors.important_1)
              table.insert(l_38_0._prerequisites_links, item)
            end
          end
        end
      end
    end
    l_38_0._skill_title_panel:child("text"):set_text(title_text)
    local desc_pre_text = l_38_0._skill_description_panel:child("prerequisites_text")
    if prerequisite_text == "" then
      desc_pre_text:hide()
      desc_pre_text:set_h(0)
    else
      prerequisite_text = utf8.to_upper(prerequisite_text)
      desc_pre_text:show()
      desc_pre_text:set_text(prerequisite_text)
      local x, y, w, h = desc_pre_text:text_rect()
      desc_pre_text:set_h(h)
    end
    local text_dissected = utf8.characters(text)
    local idsp = Idstring("#")
    local start_ci = {}
    local end_ci = {}
    local first_ci = true
    for i,c in ipairs(text_dissected) do
      if Idstring(c) == idsp then
        local next_c = text_dissected[i + 1]
        if next_c and Idstring(next_c) == idsp then
          if first_ci then
            table.insert(start_ci, i)
          else
            table.insert(end_ci, i)
            first_ci = not first_ci
          end
        end
      end
      if #start_ci ~= #end_ci then
        do return end
      end
      for i = 1, #start_ci do
        start_ci[i] = start_ci[i] - ((i - 1) * 4 + 1)
        end_ci[i] = end_ci[i] - (i * 4 - 1)
      end
      text = string.gsub(text, "##", "")
      text = text .. tier_bonus_text
      local desc_text = l_38_0._skill_description_panel:child("text")
      desc_text:set_text(text)
      desc_text:set_y(math.round(desc_pre_text:h() * 1.1499999761581))
      desc_text:clear_range_color(1, utf8.len(text))
      if #start_ci ~= #end_ci then
        Application:error("SkillTreeGui: Not even amount of ##'s in skill description string!", #start_ci, #end_ci)
      else
        for i = 1, #start_ci do
          if not can_afford[i] or not tweak_data.screen_colors.resource then
            desc_text:set_range_color(start_ci[i], end_ci[i], tweak_data.screen_colors.important_1)
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

SkillTreeGui.check_respec_button = function(l_39_0, l_39_1, l_39_2, l_39_3)
  local text_id = "st_menu_respec_tree"
  local prefix = not managers.menu:is_pc_controller() and managers.localization:get_default_macro("BTN_Y") or ""
  local macroes = {}
  if not managers.menu:is_pc_controller() then
    l_39_0._panel:child("respec_tree_button"):set_color(tweak_data.screen_colors.text)
  end
  if managers.skilltree:points_spent(l_39_0._active_tree) == 0 then
    l_39_0._panel:child("respec_tree_button"):set_color(Color.black)
    l_39_0._respec_highlight = false
    prefix = ""
  elseif l_39_1 and l_39_2 and l_39_0._panel:child("respec_tree_button"):inside(l_39_1, l_39_2) and not l_39_0._respec_highlight then
    l_39_0._respec_highlight = true
    l_39_0._panel:child("respec_tree_button"):set_color(tweak_data.screen_colors.button_stage_2)
    managers.menu_component:post_event("highlight")
    do return end
    l_39_0._respec_highlight = false
    if not managers.menu:is_pc_controller() then
      l_39_0._panel:child("respec_tree_button"):set_color(tweak_data.screen_colors.text)
    else
      l_39_0._panel:child("respec_tree_button"):set_color(tweak_data.screen_colors.button_stage_3)
    end
  end
  if l_39_0._respec_text_id ~= text_id or l_39_3 then
    l_39_0._respec_text_id = text_id
    l_39_0._panel:child("respec_tree_button"):set_text(prefix .. managers.localization:to_upper_text(text_id, macroes))
    l_39_0:make_fine_text(l_39_0._panel:child("respec_tree_button"))
  end
end

SkillTreeGui.mouse_moved = function(l_40_0, l_40_1, l_40_2, l_40_3)
  l_40_0:check_respec_button(l_40_2, l_40_3)
  if l_40_0._active_page then
    for _,item in ipairs(l_40_0._active_page._items) do
      if item:inside(l_40_2, l_40_3) then
        l_40_0:set_selected_item(item)
        return true
      end
    end
  end
  for _,tab_item in ipairs(l_40_0._tab_items) do
    if tab_item:inside(l_40_2, l_40_3) then
      l_40_0:set_selected_item(tab_item, true)
      return true
    end
  end
  if managers.menu:is_pc_controller() and l_40_0._panel:child("back_button"):inside(l_40_2, l_40_3) and not l_40_0._back_highlight then
    l_40_0._back_highlight = true
    l_40_0._panel:child("back_button"):set_color(tweak_data.screen_colors.button_stage_2)
    managers.menu_component:post_event("highlight")
    do return end
    l_40_0._back_highlight = false
    l_40_0._panel:child("back_button"):set_color(tweak_data.screen_colors.button_stage_3)
  end
  if l_40_0._panel:inside(l_40_2, l_40_3) then
    return true
  end
end

SkillTreeGui.mouse_released = function(l_41_0, l_41_1, l_41_2, l_41_3)
end

SkillTreeGui.mouse_pressed = function(l_42_0, l_42_1, l_42_2, l_42_3)
  if l_42_1 == Idstring("mouse wheel down") then
    l_42_0:activate_next_tree_panel()
    return 
  else
    if l_42_1 == Idstring("mouse wheel up") then
      l_42_0:activate_prev_tree_panel()
      return 
    end
  end
  if l_42_1 == Idstring("0") then
    if l_42_0._panel:child("back_button"):inside(l_42_2, l_42_3) then
      managers.menu:back()
      return 
    end
    if l_42_0._panel:child("respec_tree_button"):inside(l_42_2, l_42_3) then
      l_42_0:respec_active_tree()
      return 
    end
    if l_42_0._active_page then
      for _,item in ipairs(l_42_0._active_page._items) do
        if item:inside(l_42_2, l_42_3) then
          l_42_0:place_point(item)
          return true
        end
      end
    end
    for _,tab_item in ipairs(l_42_0._tab_items) do
      if tab_item:inside(l_42_2, l_42_3) then
        if l_42_0._active_tree ~= tab_item:tree() then
          l_42_0:set_active_page(tab_item:tree(), true)
        end
        return true
      end
    end
  end
end

SkillTreeGui.move_up = function(l_43_0)
  if not l_43_0._selected_item and l_43_0._active_page then
    l_43_0:set_selected_item(l_43_0._active_page:item())
  elseif l_43_0._selected_item and l_43_0._selected_item._up_item then
    l_43_0:set_selected_item(l_43_0._selected_item._up_item)
  end
end

SkillTreeGui.move_down = function(l_44_0)
  if not l_44_0._selected_item and l_44_0._active_page then
    l_44_0:set_selected_item(l_44_0._active_page:item())
  elseif l_44_0._selected_item and l_44_0._selected_item._down_item then
    l_44_0:set_selected_item(l_44_0._selected_item._down_item)
  end
end

SkillTreeGui.move_left = function(l_45_0)
  if not l_45_0._selected_item and l_45_0._active_page then
    l_45_0:set_selected_item(l_45_0._active_page:item())
  elseif l_45_0._selected_item and l_45_0._selected_item._left_item then
    l_45_0:set_selected_item(l_45_0._selected_item._left_item)
  end
end

SkillTreeGui.move_right = function(l_46_0)
  if not l_46_0._selected_item and l_46_0._active_page then
    l_46_0:set_selected_item(l_46_0._active_page:item())
  elseif l_46_0._selected_item and l_46_0._selected_item._right_item then
    l_46_0:set_selected_item(l_46_0._selected_item._right_item)
  end
end

SkillTreeGui.next_page = function(l_47_0, l_47_1)
  if l_47_0:activate_next_tree_panel(l_47_1) then
    l_47_0:set_selected_item(l_47_0._active_page:item(), true)
  end
end

SkillTreeGui.previous_page = function(l_48_0, l_48_1)
  if l_48_0:activate_prev_tree_panel(l_48_1) then
    l_48_0:set_selected_item(l_48_0._active_page:item(), true)
  end
end

SkillTreeGui.confirm_pressed = function(l_49_0)
  if l_49_0._selected_item and l_49_0._selected_item._skill_panel then
    l_49_0:place_point(l_49_0._selected_item)
    return true
  end
  return false
end

SkillTreeGui.special_btn_pressed = function(l_50_0, l_50_1)
  if l_50_1 == Idstring("menu_respec_tree") then
    l_50_0:respec_active_tree()
    return true
  end
  return false
end

SkillTreeGui.flash_item = function(l_51_0, l_51_1)
  l_51_1:flash()
end

SkillTreeGui.place_point = function(l_52_0, l_52_1)
  local tree = l_52_1:tree()
  local tier = l_52_1:tier()
  local skill_id = l_52_1:skill_id()
  if tier and not managers.skilltree:tree_unlocked(tree) then
    l_52_0:flash_item(l_52_1)
    return 
  end
  if managers.skilltree:skill_completed(skill_id) then
    return 
  end
  if not tier and managers.skilltree:tree_unlocked(tree) then
    return 
  end
  local params = {}
  local to_unlock = managers.skilltree:next_skill_step(skill_id)
  local talent = tweak_data.skilltree.skills[skill_id]
  local skill = talent[to_unlock]
  local points = Application:digest_value(skill.cost, false)
  local point_cost = managers.money:get_skillpoint_cost(tree, tier, points)
  if not talent.prerequisites then
    local prerequisites = {}
  end
  for _,prerequisite in ipairs(prerequisites) do
    local unlocked = managers.skilltree:skill_step(prerequisite)
    if unlocked and unlocked == 0 then
      l_52_0:flash_item(l_52_1)
      return 
    end
  end
  if not managers.money:can_afford_spend_skillpoint(tree, tier, points) then
    l_52_0:flash_item(l_52_1)
    return 
  end
  if tier then
    if managers.skilltree:points() < points then
      l_52_0:flash_item(l_52_1)
      return 
    end
    if managers.skilltree:tier_unlocked(tree, tier) then
      params.skill_name_localized = l_52_1._skill_name
      params.points = points
      params.cost = point_cost
      params.remaining_points = managers.skilltree:points()
      params.text_string = "dialog_allocate_skillpoint"
    else
      if points <= managers.skilltree:points() then
        params.skill_name_localized = l_52_1._skill_name
        params.points = points
        params.cost = point_cost
        params.remaining_points = managers.skilltree:points()
        params.text_string = "dialog_unlock_skilltree"
      end
    end
  end
  if params.text_string then
    params.yes_func = callback(l_52_0, l_52_0, "_dialog_confirm_yes", l_52_1)
    params.no_func = callback(l_52_0, l_52_0, "_dialog_confirm_no")
    managers.menu:show_confirm_skillpoints(params)
  else
    l_52_0:flash_item(l_52_1)
  end
end

SkillTreeGui._dialog_confirm_yes = function(l_53_0, l_53_1)
  if l_53_1 then
    if not l_53_1:trigger() then
      local skill_refresh_skills = {}
    end
    for _,id in ipairs(skill_refresh_skills) do
      for _,item in ipairs(l_53_0._active_page._items) do
        if item._skill_id == id then
          item:refresh()
          for (for control),_ in (for generator) do
          end
        end
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

SkillTreeGui._dialog_confirm_no = function(l_54_0, l_54_1)
end

SkillTreeGui.on_tier_unlocked = function(l_55_0, l_55_1, l_55_2)
  l_55_0._pages[l_55_1]:unlock_tier(l_55_2)
end

SkillTreeGui.on_skill_unlocked = function(l_56_0, l_56_1, l_56_2)
end

SkillTreeGui.on_points_spent = function(l_57_0)
  local points_text = l_57_0._panel:child("points_text")
  points_text:set_text(utf8.to_upper(managers.localization:text("st_menu_available_skill_points", {points = managers.skilltree:points()})))
  WalletGuiObject.set_object_visible("wallet_skillpoint_icon", managers.skilltree:points() > 0)
  WalletGuiObject.set_object_visible("wallet_skillpoint_text", managers.skilltree:points() > 0)
  local respec_cost_text = l_57_0._panel:child("respec_cost_text")
  if alive(respec_cost_text) then
    respec_cost_text:set_text(managers.localization:text("st_menu_respec_cost", {cost = managers.experience:cash_string(managers.money:get_skilltree_tree_respec_cost(l_57_0._active_tree))}))
    l_57_0:make_fine_text(respec_cost_text)
    respec_cost_text:set_bottom(l_57_0._panel:child("money_text"):top())
  end
  l_57_0._active_page:on_points_spent()
  l_57_0:check_respec_button(nil, nil, true)
  l_57_0:set_selected_item(l_57_0._selected_item, true)
  WalletGuiObject.refresh()
end

SkillTreeGui.respec_active_tree = function(l_58_0)
  if not managers.money:can_afford_respec_skilltree(l_58_0._active_tree) or managers.skilltree:points_spent(l_58_0._active_tree) == 0 then
    return 
  end
  l_58_0:respec_tree(l_58_0._active_tree)
end

SkillTreeGui.respec_tree = function(l_59_0, l_59_1)
  local params = {}
  params.tree = l_59_1
  params.yes_func = callback(l_59_0, l_59_0, "_dialog_respec_yes", l_59_1)
  params.no_func = callback(l_59_0, l_59_0, "_dialog_respec_no")
  managers.menu:show_confirm_respec_skilltree(params)
end

SkillTreeGui._dialog_respec_yes = function(l_60_0, l_60_1)
  SkillTreeGui._respec_tree(l_60_0, l_60_1)
end

SkillTreeGui._dialog_respec_no = function(l_61_0)
end

SkillTreeGui._respec_tree = function(l_62_0, l_62_1)
  managers.skilltree:on_respec_tree(l_62_1)
  l_62_0:_pre_reload()
  SkillTreeGui.init(l_62_0, l_62_0._ws, l_62_0._fullscreen_ws, l_62_0._node)
  l_62_0:_post_reload()
  l_62_0:set_active_page(l_62_1)
  l_62_0:set_selected_item(l_62_0._active_page:item(), true)
end

SkillTreeGui._pre_reload = function(l_63_0)
  l_63_0._temp_panel = l_63_0._panel
  l_63_0._temp_fullscreen_panel = l_63_0._fullscreen_panel
  l_63_0._panel = nil
  l_63_0._fullscreen_panel = nil
  l_63_0._temp_panel:hide()
  l_63_0._temp_fullscreen_panel:hide()
end

SkillTreeGui._post_reload = function(l_64_0)
  l_64_0._ws:panel():remove(l_64_0._temp_panel)
  l_64_0._fullscreen_ws:panel():remove(l_64_0._temp_fullscreen_panel)
end

SkillTreeGui.input_focus = function(l_65_0)
  return 1
end

SkillTreeGui.visible = function(l_66_0)
  return l_66_0._visible
end

SkillTreeGui.close = function(l_67_0)
  managers.menu:active_menu().renderer.ws:show()
  WalletGuiObject.close_wallet(l_67_0._panel)
  l_67_0._ws:panel():remove(l_67_0._panel)
  l_67_0._fullscreen_ws:panel():remove(l_67_0._fullscreen_panel)
end


