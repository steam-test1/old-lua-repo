-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\coreguidatamanager.luac 

if core then
  core:module("CoreGuiDataManager")
end
if not GuiDataManager then
  GuiDataManager = class()
end
GuiDataManager.init = function(l_1_0, l_1_1, l_1_2, l_1_3, l_1_4, l_1_5)
  l_1_0._scene_gui = l_1_1
  l_1_0._static_resolution = l_1_2
  l_1_0._safe_rect_pixels = l_1_3
  l_1_0._safe_rect = l_1_4
  l_1_0._static_aspect_ratio = l_1_5
  l_1_0:_setup_workspace_data()
end

GuiDataManager.destroy = function(l_2_0)
end

GuiDataManager.create_saferect_workspace = function(l_3_0)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local ws = Overlay:gui():create_scaled_screen_workspace(10, 10, 10, 10, 10)
l_3_0:layout_workspace(ws)
return ws
end

GuiDataManager.create_fullscreen_workspace = function(l_4_0)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local ws = Overlay:gui():create_scaled_screen_workspace(10, 10, 10, 10, 10)
l_4_0:layout_fullscreen_workspace(ws)
return ws
end

GuiDataManager.create_fullscreen_16_9_workspace = function(l_5_0)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local ws = Overlay:gui():create_scaled_screen_workspace(10, 10, 10, 10, 10)
l_5_0:layout_fullscreen_16_9_workspace(l_5_0, ws)
return ws
end

GuiDataManager.destroy_workspace = function(l_6_0, l_6_1)
  if not l_6_0._scene_gui then
    Overlay:gui():destroy_workspace(l_6_1)
     -- Warning: missing end command somewhere! Added here
  end
end

GuiDataManager._get_safe_rect_pixels = function(l_7_0)
  if l_7_0._safe_rect_pixels then
    return l_7_0._safe_rect_pixels
  end
  return managers.viewport:get_safe_rect_pixels()
end

GuiDataManager._get_safe_rect = function(l_8_0)
  if l_8_0._safe_rect then
    return l_8_0._safe_rect
  end
  return managers.viewport:get_safe_rect()
end

GuiDataManager._aspect_ratio = function(l_9_0)
  if l_9_0._static_aspect_ratio then
    return l_9_0._static_aspect_ratio
  end
  return managers.viewport:aspect_ratio()
end

local base_res = {x = 1280, y = 720}
GuiDataManager._setup_workspace_data = function(l_10_0)
  print("[GuiDataManager:_setup_workspace_data]")
  l_10_0._saferect_data = {}
  l_10_0._corner_saferect_data = {}
  l_10_0._fullrect_data = {}
  l_10_0._fullrect_16_9_data = {}
  local safe_rect = l_10_0:_get_safe_rect_pixels()
  local scaled_size = l_10_0:scaled_size()
  if not l_10_0._static_resolution then
    local res = RenderSettings.resolution
  end
  local w = scaled_size.width
  local h = scaled_size.height
  local sh = math.min(safe_rect.height, safe_rect.width / (w / h))
  local sw = math.min(safe_rect.width, safe_rect.height * (w / h))
  local x = res.x / 2 - sh * (w / h) / 2
  local y = res.y / 2 - sw / (w / h) / 2
  l_10_0._safe_x = x
  l_10_0._safe_y = y
  l_10_0._saferect_data.w = w
  l_10_0._saferect_data.h = h
  l_10_0._saferect_data.width = l_10_0._saferect_data.w
  l_10_0._saferect_data.height = l_10_0._saferect_data.h
  l_10_0._saferect_data.x = x
  l_10_0._saferect_data.y = y
  l_10_0._saferect_data.on_screen_width = sw
  local h_c = w / (safe_rect.width / safe_rect.height)
  local w_c = h * (safe_rect.width / safe_rect.height)
  l_10_0._corner_saferect_data.w = w
  l_10_0._corner_saferect_data.h = h_c
  l_10_0._corner_saferect_data.width = l_10_0._corner_saferect_data.w
  l_10_0._corner_saferect_data.height = l_10_0._corner_saferect_data.h
  l_10_0._corner_saferect_data.x = safe_rect.x
  l_10_0._corner_saferect_data.y = safe_rect.y
  l_10_0._corner_saferect_data.on_screen_width = safe_rect.width
  l_10_0._fullrect_data.w = base_res.x
  l_10_0._fullrect_data.h = base_res.x / l_10_0:_aspect_ratio()
  l_10_0._fullrect_data.width = l_10_0._fullrect_data.w
  l_10_0._fullrect_data.height = l_10_0._fullrect_data.h
  l_10_0._fullrect_data.x = 0
  l_10_0._fullrect_data.y = 0
  l_10_0._fullrect_data.on_screen_width = res.x
  l_10_0._fullrect_data.convert_x = math.floor((base_res.x - l_10_0._saferect_data.w) / 2)
  l_10_0._fullrect_data.convert_y = (base_res.x / l_10_0:_aspect_ratio() - scaled_size.height) / 2
  l_10_0._fullrect_data.corner_convert_y = math.floor((l_10_0._fullrect_data.height - l_10_0._corner_saferect_data.height) / 2)
  w = base_res.x
  h = base_res.y
  sh = math.min(res.y, res.x / (w / h))
  sw = math.min(res.x, res.y * (w / h))
  x = res.x / 2 - sh * (w / h) / 2
  y = res.y / 2 - sw / (w / h) / 2
  l_10_0._fullrect_16_9_data.w = w
  l_10_0._fullrect_16_9_data.h = h
  l_10_0._fullrect_16_9_data.width = l_10_0._fullrect_16_9_data.w
  l_10_0._fullrect_16_9_data.height = l_10_0._fullrect_16_9_data.h
  l_10_0._fullrect_16_9_data.x = x
  l_10_0._fullrect_16_9_data.y = y
  l_10_0._fullrect_16_9_data.on_screen_width = sw
  l_10_0._fullrect_16_9_data.convert_x = math.floor((l_10_0._fullrect_16_9_data.w - l_10_0._saferect_data.w) / 2)
  l_10_0._fullrect_16_9_data.convert_y = (l_10_0._fullrect_16_9_data.h - l_10_0._saferect_data.h) / 2
end

GuiDataManager.layout_workspace = function(l_11_0, l_11_1)
  l_11_1:set_screen(l_11_0._saferect_data.w, l_11_0._saferect_data.h, l_11_0._saferect_data.x, l_11_0._saferect_data.y, l_11_0._saferect_data.on_screen_width)
end

GuiDataManager.layout_fullscreen_workspace = function(l_12_0, l_12_1)
  l_12_1:set_screen(l_12_0._fullrect_data.w, l_12_0._fullrect_data.h, l_12_0._fullrect_data.x, l_12_0._fullrect_data.y, l_12_0._fullrect_data.on_screen_width)
end

GuiDataManager.layout_fullscreen_16_9_workspace = function(l_13_0, l_13_1)
  l_13_1:set_screen(l_13_0._fullrect_16_9_data.w, l_13_0._fullrect_16_9_data.h, l_13_0._fullrect_16_9_data.x, l_13_0._fullrect_16_9_data.y, l_13_0._fullrect_16_9_data.on_screen_width)
end

GuiDataManager.layout_corner_saferect_workspace = function(l_14_0, l_14_1)
  l_14_1:set_screen(l_14_0._corner_saferect_data.w, l_14_0._corner_saferect_data.h, l_14_0._corner_saferect_data.x, l_14_0._corner_saferect_data.y, l_14_0._corner_saferect_data.on_screen_width)
end

GuiDataManager.scaled_size = function(l_15_0)
  local w = math.round(l_15_0:_get_safe_rect().width * base_res.x)
  local h = math.round(l_15_0:_get_safe_rect().height * base_res.y)
  return {width = w, height = h, x = 0, y = 0}
end

GuiDataManager.safe_scaled_size = function(l_16_0)
  return l_16_0._saferect_data
end

GuiDataManager.corner_scaled_size = function(l_17_0)
  return l_17_0._corner_saferect_data
end

GuiDataManager.full_scaled_size = function(l_18_0)
  return l_18_0._fullrect_data
end

GuiDataManager.full_16_9_size = function(l_19_0)
  return l_19_0._fullrect_16_9_data
end

GuiDataManager.safe_to_full_16_9 = function(l_20_0, l_20_1, l_20_2)
  return l_20_0._fullrect_16_9_data.convert_x + l_20_1, l_20_0._fullrect_16_9_data.convert_y + l_20_2
end

GuiDataManager.full_16_9_to_safe = function(l_21_0, l_21_1, l_21_2)
  return l_21_1 - l_21_0._fullrect_16_9_data.convert_x, l_21_2 - l_21_0._fullrect_16_9_data.convert_y
end

GuiDataManager.safe_to_full = function(l_22_0, l_22_1, l_22_2)
  return l_22_0._fullrect_data.convert_x + l_22_1, l_22_0._fullrect_data.convert_y + l_22_2
end

GuiDataManager.full_to_safe = function(l_23_0, l_23_1, l_23_2)
  return l_23_1 - l_23_0._fullrect_data.convert_x, l_23_2 - l_23_0._fullrect_data.convert_y
end

GuiDataManager.corner_safe_to_full = function(l_24_0, l_24_1, l_24_2)
  return l_24_0._fullrect_data.convert_x + l_24_1, l_24_0._fullrect_data.corner_convert_y + l_24_2
end

GuiDataManager.y_safe_to_full = function(l_25_0, l_25_1)
  return l_25_0._fullrect_data.convert_y + l_25_1
end

GuiDataManager.resolution_changed = function(l_26_0)
  l_26_0:_setup_workspace_data()
end


