-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogs\achievementsdialog.luac 

core:module("SystemMenuManager")
require("lib/managers/dialogs/BaseDialog")
if not AchievementsDialog then
  AchievementsDialog = class(BaseDialog)
end
AchievementsDialog.done_callback = function(l_1_0)
  if l_1_0._data.callback_func then
    l_1_0._data.callback_func()
  end
  l_1_0:fade_out_close()
end


