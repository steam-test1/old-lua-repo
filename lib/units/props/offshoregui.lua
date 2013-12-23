-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\props\offshoregui.luac 

if not OffshoreGui then
  OffshoreGui = class()
end
OffshoreGui.TITLE_COLOR = Color(0.5, 0.60000002384186, 0.5)
OffshoreGui.MONEY_COLOR = Color(0.5, 0.60000002384186, 0.5)
OffshoreGui.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
  l_1_0._visible = true
  l_1_0._gui_object = l_1_0._gui_object or "gui_object"
  l_1_0._new_gui = World:gui()
  l_1_0:add_workspace(l_1_0._unit:get_object(Idstring(l_1_0._gui_object)))
  l_1_0:setup()
  l_1_0._unit:set_extension_update_enabled(Idstring("offshore_gui"), false)
end

OffshoreGui.add_workspace = function(l_2_0, l_2_1)
  l_2_0._ws = l_2_0._new_gui:create_object_workspace(1280, 720, l_2_1, Vector3(0, 0, 0))
end

OffshoreGui.setup = function(l_3_0)
  if l_3_0._back_drop_gui then
    l_3_0._back_drop_gui:destroy()
  end
  l_3_0._ws:panel():clear()
  l_3_0._ws:panel():set_alpha(0.80000001192093)
  l_3_0._ws:panel():rect({color = Color.black, layer = -1})
  l_3_0._back_drop_gui = MenuBackdropGUI:new(l_3_0._ws)
  local panel = l_3_0._back_drop_gui:get_new_background_layer()
  local font_size = 120
  local default_offset = 48
  local text = managers.localization:to_upper_text("menu_offshore_account")
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_3_0._title_text, {text = text, y = -l_3_0._ws:panel():h() / 2 - default_offset}.color, {text = text, y = -l_3_0._ws:panel():h() / 2 - default_offset}.visible, {text = text, y = -l_3_0._ws:panel():h() / 2 - default_offset}.layer, {text = text, y = -l_3_0._ws:panel():h() / 2 - default_offset}.font_size, {text = text, y = -l_3_0._ws:panel():h() / 2 - default_offset}.vertical, {text = text, y = -l_3_0._ws:panel():h() / 2 - default_offset}.align, {text = text, y = -l_3_0._ws:panel():h() / 2 - default_offset}.font = panel:text({text = text, y = -l_3_0._ws:panel():h() / 2 - default_offset}), OffshoreGui.TITLE_COLOR, true, 0, font_size, "bottom", "center", "fonts/font_medium_noshadow_mf"
  local font_size = 220
  local money_text = managers.experience:cash_string(managers.money:offshore())
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  l_3_0._title_text, {text = money_text, y = l_3_0._ws:panel():h() / 2 - default_offset}.color, {text = money_text, y = l_3_0._ws:panel():h() / 2 - default_offset}.visible, {text = money_text, y = l_3_0._ws:panel():h() / 2 - default_offset}.layer, {text = money_text, y = l_3_0._ws:panel():h() / 2 - default_offset}.font_size, {text = money_text, y = l_3_0._ws:panel():h() / 2 - default_offset}.vertical, {text = money_text, y = l_3_0._ws:panel():h() / 2 - default_offset}.align, {text = money_text, y = l_3_0._ws:panel():h() / 2 - default_offset}.font = panel:text({text = money_text, y = l_3_0._ws:panel():h() / 2 - default_offset}), OffshoreGui.MONEY_COLOR, true, 0, font_size, "top", "center", "fonts/font_medium_noshadow_mf"
end

OffshoreGui._start = function(l_4_0)
end

OffshoreGui.start = function(l_5_0)
end

OffshoreGui.sync_start = function(l_6_0)
  l_6_0:_start()
end

OffshoreGui.set_visible = function(l_7_0, l_7_1)
  l_7_0._visible = l_7_1
  l_7_0._gui:set_visible(l_7_1)
end

OffshoreGui.lock_gui = function(l_8_0)
  l_8_0._ws:set_cull_distance(l_8_0._cull_distance)
  l_8_0._ws:set_frozen(true)
end

OffshoreGui.destroy = function(l_9_0)
  if alive(l_9_0._new_gui) and alive(l_9_0._ws) then
    l_9_0._new_gui:destroy_workspace(l_9_0._ws)
    l_9_0._ws = nil
    l_9_0._new_gui = nil
  end
end


