-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\sequencemanager.luac 

core:module("SequenceManager")
core:import("CoreSequenceManager")
core:import("CoreClass")
if not SequenceManager then
  SequenceManager = class(CoreSequenceManager.SequenceManager)
end
SequenceManager.init = function(l_1_0)
  SequenceManager.super.init(l_1_0, managers.slot:get_mask("body_area_damage"), managers.slot:get_mask("area_damage_blocker"), managers.slot:get_mask("unit_area_damage"))
  l_1_0:register_event_element_class(InteractionElement)
  l_1_0._proximity_masks.players = managers.slot:get_mask("players")
end

if not InteractionElement then
  InteractionElement = class(CoreSequenceManager.BaseElement)
end
InteractionElement.NAME = "interaction"
InteractionElement.init = function(l_2_0, l_2_1, l_2_2)
  InteractionElement.super.init(l_2_0, l_2_1, l_2_2)
  l_2_0._enabled = l_2_0:get("enabled")
end

InteractionElement.activate_callback = function(l_3_0, l_3_1)
  local enabled = l_3_0:run_parsed_func(l_3_1, l_3_0._enabled)
  if l_3_1.dest_unit:interaction() then
    l_3_1.dest_unit:interaction():set_active(enabled)
  else
    Application:error("Unit " .. l_3_1.dest_unit:name() .. " doesn't have the interaction extension.")
  end
end

CoreClass.override_class(CoreSequenceManager.SequenceManager, SequenceManager)

