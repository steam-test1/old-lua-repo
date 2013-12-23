-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementassettrigger.luac 

core:import("CoreMissionScriptElement")
if not ElementAssetTrigger then
  ElementAssetTrigger = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementAssetTrigger.init = function(l_1_0, ...)
  ElementAssetTrigger.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementAssetTrigger.client_on_executed = function(l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementAssetTrigger.on_script_activated = function(l_3_0)
  print("ElementAssetTrigger:on_script_activated()", inspect(l_3_0._values))
  managers.assets:add_trigger(l_3_0._id, "asset", l_3_0._values.id, callback(l_3_0, l_3_0, "on_executed"))
end

ElementAssetTrigger.on_executed = function(l_4_0, l_4_1)
  if not l_4_0._values.enabled then
    return 
  end
  print("ElementAssetTrigger:on_executed()", inspect(l_4_0._values))
  ElementAssetTrigger.super.on_executed(l_4_0, l_4_1)
end


