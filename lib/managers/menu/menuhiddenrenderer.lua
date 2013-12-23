-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\menuhiddenrenderer.luac 

if not MenuHiddenRenderer then
  MenuHiddenRenderer = class(MenuRenderer)
end
MenuHiddenRenderer.open = function(l_1_0, ...)
  MenuHiddenRenderer.super.open(l_1_0, ...)
  l_1_0._main_panel:root():hide()
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

MenuHiddenRenderer.show = function(l_2_0)
  MenuHiddenRenderer.super.show(l_2_0)
  l_2_0._main_panel:root():hide()
end

MenuHiddenRenderer.hide = function(l_3_0)
  MenuHiddenRenderer.super.hide(l_3_0)
  l_3_0._main_panel:root():hide()
end


