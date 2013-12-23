-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\platformmanager.luac 

core:module("PlatformManager")
core:import("CoreEvent")
if not PlatformManager then
  PlatformManager = class()
end
PlatformManager.PLATFORM_CLASS_MAP = {}
PlatformManager.new = function(l_1_0, ...)
  do
    local platform = SystemInfo:platform()
    return l_1_0.PLATFORM_CLASS_MAP[platform:key()] or GenericPlatformManager:new(...)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

if not GenericPlatformManager then
  GenericPlatformManager = class()
end
GenericPlatformManager.init = function(l_2_0)
  l_2_0._event_queue_list = {}
  l_2_0._event_callback_handler_map = {}
  l_2_0._current_presence = "Idle"
  l_2_0._current_rich_presence = "Idle"
end

GenericPlatformManager.event = function(l_3_0, l_3_1, ...)
  table.insert(l_3_0._event_queue_list, {event_type = l_3_1, param_list = {...}})
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

GenericPlatformManager.destroy_context = function(l_4_0)
end

GenericPlatformManager.add_event_callback = function(l_5_0, l_5_1, l_5_2)
  if not l_5_0._event_callback_handler_map[l_5_1] then
    l_5_0._event_callback_handler_map[l_5_1] = CoreEvent.CallbackEventHandler:new()
  end
  l_5_0._event_callback_handler_map[l_5_1]:add(l_5_2)
end

GenericPlatformManager.remove_event_callback = function(l_6_0, l_6_1, l_6_2)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
assert(l_6_0._event_callback_handler_map[l_6_1], "Tried to remove non-existing callback on event type \"" .. tostring(l_6_1) .. "\".")
l_6_0._event_callback_handler_map[l_6_1]:remove(l_6_2)
if not next(l_6_0._event_callback_handler_map[l_6_1]) then
  l_6_0._event_callback_handler_map[l_6_1] = nil
end
end

GenericPlatformManager.update = function(l_7_0, l_7_1, l_7_2)
  if next(l_7_0._event_queue_list) then
    for _,event in ipairs(l_7_0._event_queue_list) do
      local callback_handler = l_7_0._event_callback_handler_map[event.event_type]
      if callback_handler then
        callback_handler:dispatch(unpack(event.param_list))
      end
    end
    l_7_0._event_queue_list = {}
  end
end

GenericPlatformManager.paused_update = function(l_8_0, l_8_1, l_8_2)
  l_8_0:update(l_8_1, l_8_2)
end

GenericPlatformManager.set_presence = function(l_9_0, l_9_1)
  l_9_0._current_presence = l_9_1
end

GenericPlatformManager.presence = function(l_10_0)
  return l_10_0._current_presence
end

GenericPlatformManager.set_rich_presence = function(l_11_0, l_11_1)
  l_11_0._current_rich_presence = l_11_1
end

GenericPlatformManager.rich_presence = function(l_12_0)
  return l_12_0._current_rich_presence
end

GenericPlatformManager.translate_path = function(l_13_0, l_13_1)
  return string.gsub(l_13_1, "/+([~/]*)", "\\%1")
end

if not Xbox360PlatformManager then
  Xbox360PlatformManager = class(GenericPlatformManager)
end
local l_0_0 = PlatformManager.PLATFORM_CLASS_MAP
local l_0_1 = _G.Idstring("X360"):key()
l_0_0[l_0_1] = Xbox360PlatformManager
l_0_0 = Xbox360PlatformManager
l_0_1 = function(l_14_0)
  GenericPlatformManager.init(l_14_0)
  XboxLive:set_callback(callback(l_14_0, l_14_0, "event"))
end

l_0_0.init = l_0_1
l_0_0 = Xbox360PlatformManager
l_0_1 = function(l_15_0)
  GenericPlatformManager.destroy_context(l_15_0)
  XboxLive:set_callback(nil)
end

l_0_0.destroy_context = l_0_1
l_0_0 = Xbox360PlatformManager
l_0_1 = function(l_16_0, l_16_1, l_16_2)
  print("Xbox360PlatformManager:set_rich_presence", l_16_1)
  GenericPlatformManager.set_rich_presence(l_16_0, l_16_1)
  if l_16_2 then
    XboxLive:set_context(managers.user:get_platform_id(), "presence", l_16_1, l_16_2)
  else
    XboxLive:set_context(managers.user:get_platform_id(), "presence", l_16_1, function()
   end)
  end
end

l_0_0.set_rich_presence = l_0_1
l_0_0 = Xbox360PlatformManager
l_0_1 = function(l_17_0, l_17_1, l_17_2)
  GenericPlatformManager.set_presence(l_17_0, l_17_1)
end

l_0_0.set_presence = l_0_1
l_0_0 = PS3PlatformManager
if not l_0_0 then
  l_0_0 = class
  l_0_1 = GenericPlatformManager
  l_0_0 = l_0_0(l_0_1)
end
PS3PlatformManager = l_0_0
l_0_0 = PlatformManager
l_0_0 = l_0_0.PLATFORM_CLASS_MAP
l_0_1 = _G
l_0_1 = l_0_1.Idstring
l_0_1 = l_0_1("PS3")
 -- DECOMPILER ERROR: Overwrote pending register.

l_0_1 = l_0_1:key
l_0_0[l_0_1] = PS3PlatformManager
l_0_0 = PS3PlatformManager
l_0_1 = function(l_18_0, ...)
  PS3PlatformManager.super.init(l_18_0, ...)
  l_18_0._current_psn_presence = ""
  l_18_0._psn_set_presence_time = 0
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

l_0_0.init = l_0_1
l_0_0 = PS3PlatformManager
l_0_1 = function(l_19_0, l_19_1)
  return string.gsub(l_19_1, "\\+([~\\]*)", "/%1")
end

l_0_0.translate_path = l_0_1
l_0_0 = PS3PlatformManager
l_0_1 = function(l_20_0, l_20_1, l_20_2)
  PS3PlatformManager.super.update(l_20_0, l_20_1, l_20_2)
  if l_20_0._current_psn_presence ~= l_20_0:presence() and l_20_0._psn_set_presence_time <= l_20_1 then
    l_20_0._psn_set_presence_time = l_20_1 + 10
    l_20_0._current_psn_presence = l_20_0:presence()
    print("SET PRESENCE", l_20_0._current_psn_presence)
    PSN:set_presence_info(l_20_0._current_psn_presence)
  end
end

l_0_0.update = l_0_1
l_0_0 = PS3PlatformManager
l_0_1 = function(l_21_0, l_21_1)
  GenericPlatformManager.set_presence(l_21_0, l_21_1)
end

l_0_0.set_presence = l_0_1
l_0_0 = WinPlatformManager
if not l_0_0 then
  l_0_0 = class
  l_0_1 = GenericPlatformManager
  l_0_0 = l_0_0(l_0_1)
end
WinPlatformManager = l_0_0
l_0_0 = PlatformManager
l_0_0 = l_0_0.PLATFORM_CLASS_MAP
l_0_1 = _G
l_0_1 = l_0_1.Idstring
l_0_1 = l_0_1("WIN32")
 -- DECOMPILER ERROR: Overwrote pending register.

l_0_1 = l_0_1:key
l_0_0[l_0_1] = WinPlatformManager

