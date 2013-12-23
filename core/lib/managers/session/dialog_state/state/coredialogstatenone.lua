-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\dialog_state\state\coredialogstatenone.luac 

core:module("CoreDialogStateNone")
if not None then
  None = class()
end
None.init = function(l_1_0)
  l_1_0.dialog_state:_set_stable_for_loading()
end

None.destroy = function(l_2_0)
  l_2_0.dialog_state._not_stable_for_loading()
end

None.transition = function(l_3_0)
end


