-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\localizationmanager.luac 

core:import("CoreLocalizationManager")
core:import("CoreClass")
if not LocalizationManager then
  LocalizationManager = class(CoreLocalizationManager.LocalizationManager)
end
LocalizationManager.init = function(l_1_0)
  LocalizationManager.super.init(l_1_0)
  l_1_0:_setup_macros()
  Application:set_default_letter(95)
end

LocalizationManager._setup_macros = function(l_2_0)
  local btn_a = utf8.char(57344)
  local btn_b = utf8.char(57345)
  local btn_x = utf8.char(57346)
  local btn_y = utf8.char(57347)
  local btn_back = utf8.char(57348)
  local btn_start = utf8.char(57349)
  local stick_l = utf8.char(57350)
  local stick_r = utf8.char(57351)
  local btn_top_l = utf8.char(57352)
  local btn_top_r = utf8.char(57353)
  local btn_bottom_l = utf8.char(57354)
  local btn_bottom_r = utf8.char(57355)
  local btn_stick_l = utf8.char(57356)
  local btn_stick_r = utf8.char(57357)
  local btn_dpad_u = utf8.char(57358)
  local btn_dpad_d = utf8.char(57358)
  local btn_dpad_l = utf8.char(57358)
  local btn_dpad_r = utf8.char(57358)
  local btn_inv_new = utf8.char(57362)
  if SystemInfo:platform() ~= Idstring("PS3") then
    btn_top_l = utf8.char(57354)
    btn_bottom_l = utf8.char(57352)
    btn_top_r = utf8.char(57355)
    btn_bottom_r = utf8.char(57353)
  end
  local btn_accept = btn_a
  local btn_cancel = btn_b
  local btn_attack = btn_a
  local btn_block = btn_b
  local btn_interact = btn_bottom_r
  local btn_primary = btn_top_r
  local btn_use_item = btn_bottom_l
  local btn_secondary = btn_top_l
  local btn_reload = btn_x
  local btn_jump = btn_a
  local swap_accept = false
  if SystemInfo:platform() == Idstring("PS3") and PS3:pad_cross_circle_inverted() then
    swap_accept = true
  end
  if swap_accept then
    btn_accept = btn_b
    btn_cancel = btn_a
  end
  if SystemInfo:platform() ~= Idstring("PS3") then
    btn_stick_r = stick_r
    btn_stick_l = stick_l
  end
  l_2_0:set_default_macro("BTN_BACK", btn_back)
  l_2_0:set_default_macro("BTN_START", btn_start)
  l_2_0:set_default_macro("BTN_A", btn_a)
  l_2_0:set_default_macro("BTN_B", btn_b)
  l_2_0:set_default_macro("BTN_X", btn_x)
  l_2_0:set_default_macro("BTN_Y", btn_y)
  l_2_0:set_default_macro("BTN_TOP_L", btn_top_l)
  l_2_0:set_default_macro("BTN_TOP_R", btn_top_r)
  l_2_0:set_default_macro("BTN_BOTTOM_L", btn_bottom_l)
  l_2_0:set_default_macro("BTN_BOTTOM_R", btn_bottom_r)
  l_2_0:set_default_macro("BTN_STICK_L", btn_stick_l)
  l_2_0:set_default_macro("BTN_STICK_R", btn_stick_r)
  l_2_0:set_default_macro("STICK_L", stick_l)
  l_2_0:set_default_macro("STICK_R", stick_r)
  l_2_0:set_default_macro("BTN_INTERACT", btn_interact)
  l_2_0:set_default_macro("BTN_USE_ITEM", btn_use_item)
  l_2_0:set_default_macro("BTN_PRIMARY", btn_primary)
  l_2_0:set_default_macro("BTN_SECONDARY", btn_secondary)
  l_2_0:set_default_macro("BTN_RELOAD", btn_reload)
  l_2_0:set_default_macro("BTN_JUMP", btn_jump)
  l_2_0:set_default_macro("BTN_ACCEPT", btn_accept)
  l_2_0:set_default_macro("BTN_CANCEL", btn_cancel)
  l_2_0:set_default_macro("BTN_ATTACK", btn_attack)
  l_2_0:set_default_macro("BTN_BLOCK", btn_block)
  l_2_0:set_default_macro("CONTINUE", btn_a)
  l_2_0:set_default_macro("BTN_GADGET", btn_dpad_u)
  l_2_0:set_default_macro("BTN_INV_NEW", btn_inv_new)
end

local is_PS3 = SystemInfo:platform() == Idstring("PS3")
LocalizationManager.btn_macro = function(l_3_0, l_3_1, l_3_2)
  if not managers.menu:is_pc_controller() then
    return 
  end
  local type = managers.controller:get_default_wrapper_type()
  local text = "[" .. managers.controller:get_settings(type):get_connection(l_3_1):get_input_name_list()[1] .. "]"
  return l_3_2 and utf8.to_upper(text) or text
end

LocalizationManager.ids = function(l_4_0, l_4_1)
  return Localizer:ids(Idstring(l_4_1))
end

LocalizationManager.to_upper_text = function(l_5_0, l_5_1, l_5_2)
  return utf8.to_upper(l_5_0:text(l_5_1, l_5_2))
end

LocalizationManager.debug_file = function(l_6_0, l_6_1)
  local t = {}
  local ids_in_file = l_6_0:ids(l_6_1)
  for i,ids in ipairs(ids_in_file) do
    local s = ids:s()
    local text = l_6_0:text(s, {BTN_INTERACT = l_6_0:btn_macro("interact")})
    t[s] = text
  end
  return t
end

CoreClass.override_class(CoreLocalizationManager.LocalizationManager, LocalizationManager)

