-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementalerttrigger.luac 

core:import("CoreMissionScriptElement")
if not ElementAlertTrigger then
  ElementAlertTrigger = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementAlertTrigger.init = function(l_1_0, ...)
  ElementAlertTrigger.super.init(l_1_0, ...)
  l_1_0._values.filter = l_1_0._values.filter or "0"
  if not l_1_0._values.alert_types then
    l_1_0._values.alert_types = {}
  end
  l_1_0._filter = managers.navigation:convert_access_filter_to_number(l_1_0._values.filter)
  l_1_0._alert_types_map = {}
  for _,alert_type in ipairs(l_1_0._values.alert_types) do
    l_1_0._alert_types_map[alert_type] = true
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementAlertTrigger.client_on_executed = function(l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementAlertTrigger.on_executed = function(l_3_0, l_3_1)
  ElementAlertTrigger.super.on_executed(l_3_0, l_3_1)
end

ElementAlertTrigger.do_synced_execute = function(l_4_0, l_4_1)
  if Network:is_server() then
    l_4_0:on_executed(l_4_1)
  else
    managers.network:session():send_to_host("to_server_mission_element_trigger", l_4_0._id, l_4_1)
  end
end

ElementAlertTrigger.operation_add = function(l_5_0)
  if l_5_0._added then
    return 
  end
  l_5_0._added = true
  managers.groupai:state():add_alert_listener(l_5_0._id, callback(l_5_0, l_5_0, "on_alert"), l_5_0._filter, l_5_0._alert_types_map, l_5_0._values.position)
end

ElementAlertTrigger.operation_remove = function(l_6_0)
  if not l_6_0._added then
    return 
  end
  l_6_0._added = nil
  managers.groupai:state():remove_alert_listener(l_6_0._id)
end

ElementAlertTrigger.on_alert = function(l_7_0, l_7_1)
  local instigator = l_7_1[5]
  l_7_0:do_synced_execute(instigator)
end


