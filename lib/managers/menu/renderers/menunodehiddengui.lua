-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\renderers\menunodehiddengui.luac 

if not MenuNodeHiddenGui then
  MenuNodeHiddenGui = class(MenuNodeGui)
end
MenuNodeHiddenGui._create_menu_item = function(l_1_0, l_1_1)
  MenuNodeHiddenGui.super._create_menu_item(l_1_0, l_1_1)
  l_1_1.gui_panel:hide()
end


