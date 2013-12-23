-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\actionmessagingmanager.luac 

if not ActionMessagingManager then
  ActionMessagingManager = class()
end
ActionMessagingManager.PATH = "gamedata/action_messages"
ActionMessagingManager.FILE_EXTENSION = "action_message"
ActionMessagingManager.FULL_PATH = ActionMessagingManager.PATH .. "." .. ActionMessagingManager.FILE_EXTENSION
ActionMessagingManager.init = function(l_1_0)
  l_1_0._messages = {}
  l_1_0:_parse_messages()
end

ActionMessagingManager._parse_messages = function(l_2_0)
  do
    local list = PackageManager:script_data(l_2_0.FILE_EXTENSION:id(), l_2_0.PATH:id())
    for _,data in ipairs(list) do
      if data._meta == "message" then
        l_2_0:_parse_message(data)
        for (for control),_ in (for generator) do
        end
        Application:error("Unknown node \"" .. tostring(data._meta) .. "\" in \"" .. l_2_0.FULL_PATH .. "\". Expected \"message\" node.")
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ActionMessagingManager._parse_message = function(l_3_0, l_3_1)
  local id = l_3_1.id
  local text_id = l_3_1.text_id
  local event = l_3_1.event
  local dialog_id = l_3_1.dialog_id
  local equipment_id = l_3_1.equipment_id
  l_3_0._messages[id] = {text_id = text_id, event = event, dialog_id = dialog_id, equipment_id = equipment_id}
end

ActionMessagingManager.ids = function(l_4_0)
  local t = {}
  for id,_ in pairs(l_4_0._messages) do
    table.insert(t, id)
  end
  table.sort(t)
  return t
end

ActionMessagingManager.messages = function(l_5_0)
  return l_5_0._messages
end

ActionMessagingManager.message = function(l_6_0, l_6_1)
  return l_6_0._messages[l_6_1]
end

ActionMessagingManager.show_message = function(l_7_0, l_7_1, l_7_2)
  if not l_7_1 or not l_7_0:message(l_7_1) then
    Application:stack_dump_error("Bad id to show message, " .. tostring(l_7_1) .. ".")
    return 
  end
  l_7_0:_show_message(l_7_1, l_7_2)
end

ActionMessagingManager._show_message = function(l_8_0, l_8_1, l_8_2)
  local msg_data = l_8_0:message(l_8_1)
  local title = (l_8_2:base():nick_name())
  local icon = nil
  local msg = ""
  if msg_data.equipment_id then
    title = title .. " " .. managers.localization:text("message_obtained_equipment")
    local equipment = tweak_data.equipments.specials[msg_data.equipment_id]
    icon = equipment.icon
    msg = managers.localization:text(equipment.text_id)
  else
    title = title .. ":"
    msg = managers.localization:text(l_8_0:message(l_8_1).text_id)
  end
  managers.hud:present_mid_text({title = utf8.to_upper(title), text = utf8.to_upper(msg), icon = icon, time = 4, event = l_8_0:message(l_8_1).event})
  if l_8_0:message(l_8_1).dialog_id then
    managers.dialog:queue_dialog(l_8_0:message(l_8_1).dialog_id, {})
  end
end

ActionMessagingManager.sync_show_message = function(l_9_0, l_9_1, l_9_2)
  if alive(l_9_2) and managers.network:game():member_from_unit(l_9_2) then
    l_9_0:_show_message(l_9_1, l_9_2)
  end
end

ActionMessagingManager.save = function(l_10_0, l_10_1)
end

ActionMessagingManager.load = function(l_11_0, l_11_1)
end


