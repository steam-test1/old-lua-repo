-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementblackscreenvariant.luac 

core:import("CoreMissionScriptElement")
if not ElementBlackscreenVariant then
  ElementBlackscreenVariant = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementBlackscreenVariant.init = function(l_1_0, ...)
  ElementBlackscreenVariant.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementBlackscreenVariant.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementBlackscreenVariant.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  managers.groupai:state():set_blackscreen_variant(tonumber(l_3_0._values.variant))
  ElementBlackscreenVariant.super.on_executed(l_3_0, l_3_1)
end

if not ElementEndscreenVariant then
  ElementEndscreenVariant = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementEndscreenVariant.init = function(l_4_0, ...)
  ElementEndscreenVariant.super.init(l_4_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementEndscreenVariant.client_on_executed = function(l_5_0, ...)
  l_5_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementEndscreenVariant.on_executed = function(l_6_0, l_6_1)
  if not l_6_0._values.enabled then
    return 
  end
  managers.groupai:state():set_endscreen_variant(tonumber(l_6_0._values.variant))
  ElementEndscreenVariant.super.on_executed(l_6_0, l_6_1)
end


