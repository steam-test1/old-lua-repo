-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\menunodekitgui.luac 

core:import("CoreMenuNodeGui")
if not MenuNodeKitGui then
  MenuNodeKitGui = class(MenuNodeGui)
end
MenuNodeKitGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  MenuNodeKitGui.super.init(l_1_0, l_1_1, l_1_2, l_1_3)
end

MenuNodeKitGui._setup_item_panel_parent = function(l_2_0, l_2_1, l_2_2)
  MenuNodeKitGui.super._setup_item_panel_parent(l_2_0, l_2_1, l_2_2)
end

MenuNodeKitGui._update_scaled_values = function(l_3_0)
  MenuNodeKitGui.super._update_scaled_values(l_3_0)
  l_3_0.font_size = tweak_data.menu.kit_default_font_size
end

MenuNodeKitGui.resolution_changed = function(l_4_0)
  l_4_0:_update_scaled_values()
  MenuNodeKitGui.super.resolution_changed(l_4_0)
end


