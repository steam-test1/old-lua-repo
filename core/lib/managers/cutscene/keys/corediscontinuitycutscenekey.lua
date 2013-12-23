-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\cutscene\keys\corediscontinuitycutscenekey.luac 

require("core/lib/managers/cutscene/keys/CoreCutsceneKeyBase")
if not CoreDiscontinuityCutsceneKey then
  CoreDiscontinuityCutsceneKey = class(CoreCutsceneKeyBase)
end
CoreDiscontinuityCutsceneKey.ELEMENT_NAME = "discontinuity"
CoreDiscontinuityCutsceneKey.NAME = "Discontinuity"
CoreDiscontinuityCutsceneKey:register_control("description")
CoreDiscontinuityCutsceneKey.refresh_control_for_description = CoreCutsceneKeyBase.VOID
CoreDiscontinuityCutsceneKey.label_for_description = CoreCutsceneKeyBase.VOID
CoreDiscontinuityCutsceneKey.is_valid_description = CoreCutsceneKeyBase.TRUE
CoreDiscontinuityCutsceneKey.__tostring = function(l_1_0)
  return "Notifies a discontinuity in linear time."
end

CoreDiscontinuityCutsceneKey.play = function(l_2_0, l_2_1, l_2_2, l_2_3)
  l_2_1:_notify_discontinuity()
end

CoreDiscontinuityCutsceneKey.control_for_description = function(l_3_0, l_3_1)
  local text = "Discontinuity keys signify a break in linear time. They enable us to dampen physics, etc. during rapid actor movement.\n\nDiscontinuity keys are inserted by the optimizer as the cutscene is exported to the game, but you can also insert them yourself."
  local control = EWS:TextCtrl(l_3_1, text, "", "NO_BORDER,TE_RICH,TE_MULTILINE,TE_READONLY")
  control:set_min_size(control:get_min_size():with_y(160))
  control:set_background_colour(l_3_1:background_colour():unpack())
  return control
end

CoreDiscontinuityCutsceneKey.validate_control_for_attribute = function(l_4_0, l_4_1)
  if l_4_1 ~= "description" then
    return l_4_0.super.validate_control_for_attribute(l_4_0, l_4_1)
  end
  return true
end


