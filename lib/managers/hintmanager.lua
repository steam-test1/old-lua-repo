-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\hintmanager.luac 

if not HintManager then
  HintManager = class()
end
HintManager.PATH = "gamedata/hints"
HintManager.FILE_EXTENSION = "hint"
HintManager.FULL_PATH = HintManager.PATH .. "." .. HintManager.FILE_EXTENSION
HintManager.init = function(l_1_0)
  if not Global.hint_manager then
    Global.hint_manager = {hints = {}}
    l_1_0:_parse_hints()
  end
  l_1_0._cooldown = {}
end

HintManager._parse_hints = function(l_2_0)
  do
    local list = PackageManager:script_data(l_2_0.FILE_EXTENSION:id(), l_2_0.PATH:id())
    for _,data in ipairs(list) do
      if data._meta == "hint" then
        l_2_0:_parse_hint(data)
        for (for control),_ in (for generator) do
        end
        Application:error("Unknown node \"" .. tostring(data._meta) .. "\" in \"" .. l_2_0.FULL_PATH .. "\". Expected \"objective\" node.")
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

HintManager._parse_hint = function(l_3_0, l_3_1)
  local id = l_3_1.id
  local text_id = l_3_1.text_id
  local trigger_times = l_3_1.trigger_times
  local sync = l_3_1.sync
  local event = l_3_1.event
  local level = l_3_1.level
  Global.hint_manager.hints[id] = {text_id = text_id, trigger_times = trigger_times, trigger_count = 0, sync = sync, event = event, level = level}
end

HintManager.ids = function(l_4_0)
  local t = {}
  for id,_ in pairs(Global.hint_manager.hints) do
    table.insert(t, id)
  end
  table.sort(t)
  return t
end

HintManager.hints = function(l_5_0)
  return Global.hint_manager.hints
end

HintManager.hint = function(l_6_0, l_6_1)
  return Global.hint_manager.hints[l_6_1]
end

HintManager.show_hint = function(l_7_0, l_7_1, l_7_2, l_7_3, l_7_4)
  if not l_7_1 or not l_7_0:hint(l_7_1) then
    Application:stack_dump_error("Bad id to show hint, " .. tostring(l_7_1) .. ".")
    return 
  end
  if not l_7_3 then
    l_7_0:_show_hint(l_7_1, l_7_2, l_7_4)
  end
  if l_7_0:hint(l_7_1).sync then
    managers.network:session():send_to_peers_synched("sync_show_hint", l_7_1)
  end
end

HintManager._show_hint = function(l_8_0, l_8_1, l_8_2, l_8_3)
  if l_8_0:hint(l_8_1).level and l_8_0:hint(l_8_1).level <= managers.experience:current_level() then
    return 
  end
  if l_8_0:hint(l_8_1).stop_at_level and managers.experience:current_level() < l_8_0:hint(l_8_1).stop_at_level then
    return 
  end
  if l_8_0._cooldown[l_8_1] and Application:time() < l_8_0._cooldown[l_8_1] then
    return 
  end
  if not l_8_0:hint(l_8_1).trigger_times or l_8_0:hint(l_8_1).trigger_times ~= l_8_0:hint(l_8_1).trigger_count then
    l_8_0._cooldown[l_8_1] = Application:time() + 2
    l_8_0:hint(l_8_1).trigger_count = l_8_0:hint(l_8_1).trigger_count + 1
    l_8_0._last_shown_id = l_8_1
    managers.hud:show_hint({text = managers.localization:text(l_8_0:hint(l_8_1).text_id, l_8_3), event = l_8_0:hint(l_8_1).event, time = l_8_2})
  end
end

HintManager.sync_show_hint = function(l_9_0, l_9_1)
  l_9_0:_show_hint(l_9_1, nil, {BTN_INTERACT = managers.localization:btn_macro("interact")})
end

HintManager.last_shown_id = function(l_10_0)
  return l_10_0._last_shown_id
end

HintManager.on_simulation_ended = function(l_11_0)
  for _,hint in pairs(Global.hint_manager.hints) do
    if hint.trigger_times then
      hint.trigger_count = 0
    end
  end
end

HintManager.save = function(l_12_0, l_12_1)
  local state = {hints = deep_clone(Global.hint_manager.hints)}
  l_12_1.HintManager = state
end

HintManager.load = function(l_13_0, l_13_1)
  local state = l_13_1.HintManager
  Global.hint_manager.hints = deep_clone(state.hints)
end


