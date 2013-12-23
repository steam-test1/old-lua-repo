-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\inventorylist.luac 

if not InventoryList then
  InventoryList = class()
end
local NOT_WIN_32 = SystemInfo:platform() ~= Idstring("WIN32")
local WIDTH_MULTIPLIER = NOT_WIN_32 and 0.68999999761581 or 0.75
local BOX_GAP = 13.5
local GRID_H_MUL = (NOT_WIN_32 and 7 or 6) / 8
local massive_font = tweak_data.menu.pd2_massive_font
local large_font = tweak_data.menu.pd2_large_font
local medium_font = tweak_data.menu.pd2_medium_font
local small_font = tweak_data.menu.pd2_small_font
local massive_font_size = tweak_data.menu.pd2_massive_font_size
local large_font_size = tweak_data.menu.pd2_large_font_size
local medium_font_size = tweak_data.menu.pd2_medium_font_size
local small_font_size = tweak_data.menu.pd2_small_font_size
InventoryList.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0._ws = l_1_1
  l_1_0._panel = l_1_1:panel():panel()
  l_1_0._panel:set_debug(true)
end

InventoryList.close = function(l_2_0)
  l_2_0._ws:panel():remove(l_2_0._panel)
end


