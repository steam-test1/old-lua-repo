-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dialogmanager.luac 

if not DialogManager then
  DialogManager = class()
end
local l_0_0 = DialogManager
local l_0_1 = {}
l_0_1.sequence_node = "DialogNodeSequence"
l_0_1.select_node = "DialogNodeSelect"
l_0_1.random_node = "DialogNodeRandom"
l_0_1.case_node = "DialogNodeCase"
l_0_0.DialogNodeClasses = l_0_1
l_0_0 = DialogManager
l_0_1 = {dialog_line = "DialogActionLine", go_to_node = "DialogActionGoto", set = "DialogActionVariable", lua = "DialogActionCallback", quit = "DialogActionQuit"}
l_0_0.DialogActionClasses = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_1_0)
  l_1_0._pause = false
  l_1_0._current_dialog = nil
  l_1_0._current_node_id = 0
  l_1_0._current_node_timer = 0
  l_1_0._queued_dialog = nil
  l_1_0._option_list = {}
  l_1_0._variables = {}
  l_1_0._variables.global = {}
  l_1_0._variables.local = {}
  l_1_0._bain_unit = World:spawn_unit(Idstring("units/payday2/characters/fps_mover/bain"), Vector3(), Rotation())
end

l_0_0.init = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_2_0)
  l_2_0._node_definition_list = {}
  l_2_0._conversation_list = {}
  l_2_0:_load_dialogs()
end

l_0_0.init_finalize = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_3_0)
  if l_3_0._current_dialog then
    l_3_0._current_dialog[l_3_0._current_node_id]:stop()
  end
end

l_0_0.stop_current_dialog = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_4_0)
  if l_4_0._current_dialog then
    l_4_0._current_dialog[l_4_0._current_node_id]:stop()
  end
  l_4_0:quit_dialog()
end

l_0_0.on_simulation_ended = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_5_0, l_5_1, l_5_2)
  if not l_5_0._pause and l_5_0._current_dialog then
    l_5_0._current_node_timer = l_5_0._current_node_timer - l_5_2
    if l_5_0._current_node_timer <= 0 then
      local node_data = l_5_0._current_dialog[l_5_0._current_node_id]
      if not l_5_0._queued_dialog then
        node_data:update(l_5_0._current_dialog_params)
      else
        node_data:stop()
        l_5_0._current_dialog = l_5_0._queued_dialog
        l_5_0._current_node_timer = 0
        l_5_0._current_node_id = l_5_0._current_dialog._start
        l_5_0._queued_dialog = nil
      end
    end
  end
end

l_0_0.update = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_6_0, l_6_1, l_6_2)
  if not l_6_2.skip_idle_check and managers.platform:presence() == "Idle" then
    return 
  end
  if not l_6_0._current_dialog then
    l_6_0._current_dialog = l_6_0._conversation_list[l_6_1]
    if not l_6_0._current_dialog then
      Application:throw_exception("The dialog script tries to queue a dialog with id '" .. tostring(l_6_1) .. "' which doesn't seem to exist!")
    end
    l_6_0._current_dialog_params = l_6_2
    l_6_0._current_node_timer = 0
    l_6_0._current_node_id = l_6_0._current_dialog._start
  else
    local dialog = l_6_0._conversation_list[l_6_1]
    if not dialog then
      Application:throw_exception("The dialog script tries to queue a dialog with id '" .. tostring(l_6_1) .. "' which doesn't seem to exist!")
    end
    if l_6_0._queued_dialog and l_6_0._queued_dialog._priority < dialog._priority then
      return 
    end
    if dialog._priority < l_6_0._current_dialog._priority then
      l_6_0._queued_dialog = dialog
    end
  end
  return true
end

l_0_0.queue_dialog = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_7_0)
  if l_7_0._current_dialog then
    return true
  end
  return false
end

l_0_0.is_active = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_8_0, l_8_1)
  return l_8_0._variables.global[l_8_1]
end

l_0_0.variable = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_9_0, l_9_1)
  l_9_0._current_node_timer = 0
  l_9_0._current_node_id = l_9_1
  l_9_0._pause = false
end

l_0_0.go_to_node = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_10_0)
  l_10_0._pause = true
end

l_0_0.pause_dialog = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_11_0)
  l_11_0._pause = false
end

l_0_0.play_dialog = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_12_0)
  managers.subtitle:set_visible(false)
  managers.subtitle:set_enabled(false)
  l_12_0._current_dialog = nil
  l_12_0._queued_dialog = nil
  l_12_0._pause = false
end

l_0_0.quit_dialog = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_13_0)
  return l_13_0._option_list
end

l_0_0.option_list = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_14_0)
  local t = {}
  for name,_ in pairs(l_14_0._conversation_list) do
    table.insert(t, name)
  end
  table.sort(t)
  return t
end

l_0_0.conversation_names = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_15_0, l_15_1)
  l_15_0._option_list = l_15_1
end

l_0_0._set_option_list = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_16_0, l_16_1)
  return l_16_0._node_definition_list[l_16_1]
end

l_0_0._node_definition = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_17_0, l_17_1)
  return l_17_0._unit_list[l_17_1]
end

l_0_0._unit = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_18_0, l_18_1, l_18_2)
  return l_18_0._variables[l_18_1][l_18_2]
end

l_0_0._variable = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_19_0, l_19_1, l_19_2, l_19_3)
  l_19_0._variables[l_19_1][l_19_2] = l_19_3
end

l_0_0._set_variable = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_20_0, l_20_1)
  l_20_0._current_node_timer = l_20_1
end

l_0_0._set_duration = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_21_0)
  local units = World:find_units_quick("all")
  for _,unit in pairs(units) do
    if unit:drama() then
      l_21_0._unit_list[unit:drama():name()] = unit
    end
  end
end

l_0_0._load_units = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_22_0)
  local file_name = "gamedata/dialogs/index"
  local data = PackageManager:script_data(Idstring("dialog_index"), file_name:id())
  for _,c in ipairs(data) do
    if c.name then
      l_22_0:_load_dialog_data(c.name)
    end
  end
end

l_0_0._load_dialogs = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_23_0, l_23_1)
  local file_name = "gamedata/dialogs/" .. l_23_1
  do
    local data = PackageManager:script_data(Idstring("dialog"), file_name:id())
    for _,c in ipairs(data) do
      if c._meta == "node_definitions" then
        for _,node in ipairs(c) do
          if node.id and node.character and node.drama_cue then
            l_23_0._node_definition_list[node.id] = {character = node.character, drama_cue = node.drama_cue}
            for (for control),_ in (for generator) do
            end
            Application:throw_exception("Error in '" .. file_name .. "'! A node definition must have an id, character and drama_cue parameters!")
          end
          for (for control),_ in (for generator) do
          end
          do
            if c._meta == "conversation" then
              if c.id then
                local id = c.id
                if l_23_0._conversation_list[id] then
                  Application:throw_exception("Error in '" .. file_name .. "'! A conversation with the ID '" .. tostring(id) .. "' already exist. Choose a unique ID!")
                end
                l_23_0:_load_nodes(id, c)
              end
              for (for control),_ in (for generator) do
              end
              Application:throw_exception("Error in '" .. file_name .. "'! A conversation must have an id parameter!")
            end
          end
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

l_0_0._load_dialog_data = l_0_1
l_0_0 = DialogManager
l_0_1 = function(l_24_0, l_24_1, l_24_2)
  l_24_0._conversation_list[l_24_1] = {}
  local list = l_24_0._conversation_list[l_24_1]
  if l_24_2.priority then
    list._priority = tonumber(l_24_2.priority)
  else
    list._priority = tweak_data.dialog.DEFAULT_PRIORITY
  end
  local nodes = 0
  for _,c in ipairs(l_24_2) do
    if c.id then
      local node_id = c.id
      if list[node_id] then
        Application:throw_exception("Error in 'gamedata/dialogs/'! A sequence with the ID '" .. tostring(node_id) .. "' already exist. Choose a unique ID!")
      end
      if not list._start then
        list._start = c.id
      end
      local class = _G[l_24_0.DialogNodeClasses[c._meta]]
      if class then
        list[node_id] = class:new(c)
      else
        Application:throw_exception("Error in 'gamedata/dialogs/'! The node class '" .. tostring(c._meta) .. "' is missing from the class list!")
      end
    else
      Application:throw_exception("Error in 'gamedata/dialogs/'! The node '" .. tostring(c._meta) .. "' is missing an ID!")
    end
    nodes = nodes + 1
  end
  if nodes == 0 then
    Application:throw_exception("Error in 'gamedata/dialogs/'! The conversation '" .. tostring(l_24_2.id) .. "' is empty!")
  end
end

l_0_0._load_nodes = l_0_1
l_0_0 = DialogAction
if not l_0_0 then
  l_0_0 = class
  l_0_0 = l_0_0()
end
DialogAction = l_0_0
l_0_0 = DialogAction
l_0_1 = function(l_25_0)
end

l_0_0.init = l_0_1
l_0_0 = DialogAction
l_0_1 = function(l_26_0)
end

l_0_0.stop = l_0_1
l_0_0 = DialogAction
l_0_1 = function(l_27_0, l_27_1)
  do
    local variable = {}
    if l_27_1.variable then
      variable.name, variable.type = l_27_0:_process_variable(l_27_1.variable), l_27_0
      local condition_list = {"equal", "less_than", "greater_than", "not_equal"}
      for _,k in pairs(condition_list) do
        if l_27_1[k] then
          variable.condition = k
          variable.value = tonumber(l_27_1[k])
          if variable.value == nil then
            variable.value = l_27_1[k]
        else
          end
        end
        if not variable.condition then
          Application:throw_exception("Error in 'gamedata/dialogs/'! The variable in a 'dialog_line' action doesn't have a valid value! (Use 'equal', 'less_than', 'greater_than' or 'not_equal')")
        end
      end
      return variable
    end
     -- Warning: missing end command somewhere! Added here
  end
end

l_0_0.setup_variable = l_0_1
l_0_0 = DialogAction
l_0_1 = function(l_28_0, l_28_1)
  if not l_28_1.name then
    return true
  else
    local value = managers.dialog:_variable(l_28_1.type, l_28_1.name)
    if not value then
      value = 0
    end
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if l_28_1.condition == "equal" and l_28_1.value == value then
      return true
    end
  end
  return false
end

l_0_0.check_variable = l_0_1
l_0_0 = DialogAction
l_0_1 = function(l_29_0, l_29_1)
  local var_type = "local"
  local pos_begin, pos_end = l_29_1:find("local")
  if pos_begin ~= 1 then
    pos_begin, pos_end = l_29_1:find("global")
    if pos_begin == 1 then
      var_type = "global"
    else
      pos_begin = 1
      pos_end = -1
    end
    do
      local var_data = l_29_1:sub(pos_end + 2)
      return var_data, var_type
    end
     -- Warning: missing end command somewhere! Added here
  end
end

l_0_0._process_variable = l_0_1
l_0_0 = DialogNode
if not l_0_0 then
  l_0_0 = class
  l_0_0 = l_0_0()
end
DialogNode = l_0_0
l_0_0 = DialogNode
l_0_1 = function(l_30_0)
end

l_0_0.init = l_0_1
l_0_0 = DialogNode
l_0_1 = function(l_31_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

l_0_0.update = l_0_1
l_0_0 = DialogNode
l_0_1 = function(l_32_0)
end

l_0_0.stop = l_0_1
l_0_0 = DialogNodeSequence
if not l_0_0 then
  l_0_0 = class
  l_0_1 = DialogNode
  l_0_0 = l_0_0(l_0_1)
end
DialogNodeSequence = l_0_0
l_0_0 = DialogNodeSequence
l_0_1 = function(l_33_0, l_33_1)
  l_33_0._action_list = {}
  l_33_0._current_action_id = 1
  for _,c in ipairs(l_33_1) do
    local class = _G[managers.dialog.DialogActionClasses[c._meta]]
    if class then
      table.insert(l_33_0._action_list, class:new(c))
      for (for control),_ in (for generator) do
      end
      Application:throw_exception("Error in 'gamedata/dialogs/'! The action class '" .. tostring(c._meta) .. "' is missing from the class list!")
    end
    if #l_33_0._action_list == 0 then
      Application:throw_exception("Error in 'gamedata/dialogs/'! The sequence node '" .. tostring(l_33_1.id) .. "' is empty!")
    end
     -- Warning: missing end command somewhere! Added here
  end
end

l_0_0.init = l_0_1
l_0_0 = DialogNodeSequence
l_0_1 = function(l_34_0, ...)
  local action = l_34_0._action_list[l_34_0._current_action_id]
  do
    local duration = action:execute(...)
    managers.dialog:_set_duration(duration)
    l_34_0._current_action_id = l_34_0._current_action_id + 1
    if not l_34_0._action_list[l_34_0._current_action_id] then
      l_34_0._current_action_id = 1
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

l_0_0.update = l_0_1
l_0_0 = DialogNodeSequence
l_0_1 = function(l_35_0)
  local action = l_35_0._action_list[l_35_0._current_action_id]
  action:stop()
  l_35_0._current_action_id = 1
end

l_0_0.stop = l_0_1
l_0_0 = DialogNodeSelect
if not l_0_0 then
  l_0_0 = class
  l_0_1 = DialogNode
  l_0_0 = l_0_0(l_0_1)
end
DialogNodeSelect = l_0_0
l_0_0 = DialogNodeSelect
l_0_1 = function(l_36_0, l_36_1)
  l_36_0._action_list = {}
  for _,c in ipairs(l_36_1) do
    table.insert(l_36_0._action_list, DialogActionOption:new(c))
  end
  if #l_36_0._action_list == 0 then
    Application:throw_exception("Error in 'gamedata/dialogs/'! The select node '" .. tostring(l_36_1.id) .. "' is empty!")
  end
end

l_0_0.init = l_0_1
l_0_0 = DialogNodeSelect
l_0_1 = function(l_37_0, ...)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  for _,k in pairs(l_37_0._action_list) do
    local data = k:data()
    if data then
      table.insert({}, data)
    end
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

  managers.dialog:_set_option_list({})
  managers.dialog:pause_dialog()
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

l_0_0.update = l_0_1
l_0_0 = DialogNodeRandom
if not l_0_0 then
  l_0_0 = class
  l_0_1 = DialogNode
  l_0_0 = l_0_0(l_0_1)
end
DialogNodeRandom = l_0_0
l_0_0 = DialogNodeRandom
l_0_1 = function(l_38_0, l_38_1)
  l_38_0._action_list = {}
  for _,c in ipairs(l_38_1) do
    table.insert(l_38_0._action_list, DialogActionRandom:new(c))
  end
  if #l_38_0._action_list == 0 then
    Application:throw_exception("Error in 'gamedata/dialogs/'! The random node '" .. tostring(l_38_1.id) .. "' is empty!")
  end
end

l_0_0.init = l_0_1
l_0_0 = DialogNodeRandom
l_0_1 = function(l_39_0, ...)
  local option = math.random(#l_39_0._action_list)
  do
    local node = l_39_0._action_list[option]
    node:execute(...)
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

l_0_0.update = l_0_1
l_0_0 = DialogNodeCase
if not l_0_0 then
  l_0_0 = class
  l_0_1 = DialogNode
  l_0_0 = l_0_0(l_0_1)
end
DialogNodeCase = l_0_0
l_0_0 = DialogNodeCase
l_0_1 = function(l_40_0, l_40_1)
  l_40_0._action_list = {}
  for _,c in ipairs(l_40_1) do
    local case = DialogActionCase:new(c)
    l_40_0._action_list[case:value()] = case
  end
  if not next(l_40_0._action_list) then
    Application:throw_exception("Error in 'gamedata/dialogs/'! The case node '" .. tostring(l_40_1.id) .. "' is empty!")
  end
end

l_0_0.init = l_0_1
l_0_0 = DialogNodeCase
l_0_1 = function(l_41_0, l_41_1)
  if not l_41_1 or not l_41_1.case then
    Application:throw_exception("DialogNodeCase didn't recieve a params or case value!")
  end
  local case_node = l_41_0._action_list[l_41_1.case]
  if not case_node then
    managers.dialog:quit_dialog()
    return 
  end
  case_node:execute(l_41_1)
end

l_0_0.update = l_0_1
l_0_0 = DialogActionLine
if not l_0_0 then
  l_0_0 = class
  l_0_1 = DialogAction
  l_0_0 = l_0_0(l_0_1)
end
DialogActionLine = l_0_0
l_0_0 = DialogActionLine
l_0_1 = function(l_42_0, l_42_1)
  if not l_42_1.id then
    Application:throw_exception("Error in 'gamedata/dialogs/'! The action '" .. tostring(l_42_1._meta) .. "' doesn't have an ID!")
  end
  l_42_0._unit = nil
  l_42_0._id = l_42_1.id
  l_42_0._node = managers.dialog:_node_definition(l_42_0._id)
  l_42_0._variable = DialogAction:setup_variable(l_42_1)
  if not l_42_0._node then
    Application:throw_exception("The dialog script tries to access a node definition id '" .. tostring(l_42_0._id) .. "', which doesn't seem to exist!")
  end
end

l_0_0.init = l_0_1
l_0_0 = DialogActionLine
l_0_1 = function(l_43_0, l_43_1)
  if DialogAction:check_variable(l_43_0._variable) then
    if not l_43_1.on_unit and l_43_1.override_characters then
      l_43_0._unit = managers.player:player_unit()
    end
    if not alive(l_43_0._unit) then
      if l_43_0._node.character == "dispatch" then
        l_43_0._unit = managers.dialog._bain_unit
      else
        l_43_0._unit = managers.criminals:character_unit_by_name(l_43_0._node.character)
      end
    end
    if not alive(l_43_0._unit) then
      Application:error("The dialog script tries to access a unit named '" .. tostring(l_43_0._node.character) .. "', which doesn't seem to exist. Line will be skipped.")
    end
    if alive(l_43_0._unit) then
      local duration = l_43_0._unit:drama():play_cue(l_43_0._node.drama_cue)
      return duration
    end
  end
  return 0
end

l_0_0.execute = l_0_1
l_0_0 = DialogActionLine
l_0_1 = function(l_44_0)
  if l_44_0._unit then
    l_44_0._unit:drama():stop_cue(l_44_0._node.drama_cue)
  end
end

l_0_0.stop = l_0_1
l_0_0 = DialogActionGoto
if not l_0_0 then
  l_0_0 = class
  l_0_1 = DialogAction
  l_0_0 = l_0_0(l_0_1)
end
DialogActionGoto = l_0_0
l_0_0 = DialogActionGoto
l_0_1 = function(l_45_0, l_45_1)
  if not l_45_1.id then
    Application:throw_exception("Error in 'gamedata/dialogs/'! The action '" .. tostring(l_45_1._meta) .. "' doesn't have an ID!")
  end
  l_45_0._id = l_45_1.id
  l_45_0._variable = DialogAction:setup_variable(l_45_1)
end

l_0_0.init = l_0_1
l_0_0 = DialogActionGoto
l_0_1 = function(l_46_0, ...)
  if DialogAction:check_variable(l_46_0._variable) then
    managers.dialog:go_to_node(l_46_0._id)
  end
  return 0
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

l_0_0.execute = l_0_1
l_0_0 = DialogActionVariable
if not l_0_0 then
  l_0_0 = class
  l_0_1 = DialogAction
  l_0_0 = l_0_0(l_0_1)
end
DialogActionVariable = l_0_0
l_0_0 = DialogActionVariable
l_0_1 = function(l_47_0, l_47_1)
  if not l_47_1.variable or l_47_1.value == nil then
    Application:throw_exception("Error in 'gamedata/dialogs/'! The action '" .. tostring(l_47_1._meta) .. "' doesn't have an variable or value parameter!")
  end
  l_47_0._variable, l_47_0._type = DialogAction:_process_variable(l_47_1.variable), DialogAction
  l_47_0._value, l_47_0._sign = l_47_0:_process_value(l_47_1.value), l_47_0
end

l_0_0.init = l_0_1
l_0_0 = DialogActionVariable
l_0_1 = function(l_48_0, ...)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  do
    if l_48_0._sign then
      local old_value = managers.dialog:_variable(l_48_0._type, l_48_0._variable)
      if old_value or l_48_0._sign == "++" then
        do return end
      end
  end
  if l_48_0._sign == "--" then
    end
  end
   -- DECOMPILER ERROR: Overwrote pending register.

  old_value.dialog:_set_variable(l_48_0._type, l_48_0._variable, old_value - (old_value + l_48_0._value))
   -- DECOMPILER ERROR: Attempted to generate an assignment, but got confused about usage of registers

  return 0
   -- DECOMPILER ERROR: Attempted to generate an assignment, but got confused about usage of registers

   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   -- DECOMPILER ERROR: Attempted to generate an assignment, but got confused about usage of registers

end

l_0_0.execute = l_0_1
l_0_0 = DialogActionVariable
l_0_1 = function(l_49_0, l_49_1)
  local content = nil
  local sign = l_49_1:sub(1, 2)
  if sign == "++" or sign == "--" then
    content = tonumber(l_49_1:sub(3))
    if not content then
      sign = nil
      content = l_49_1
    else
      sign = nil
      content = tonumber(l_49_1)
      if not l_49_1 then
        content = l_49_1
      end
    end
  end
  return content, sign
end

l_0_0._process_value = l_0_1
l_0_0 = DialogActionCallback
if not l_0_0 then
  l_0_0 = class
  l_0_1 = DialogAction
  l_0_0 = l_0_0(l_0_1)
end
DialogActionCallback = l_0_0
l_0_0 = DialogActionCallback
l_0_1 = function(l_50_0, l_50_1)
  if not l_50_1.callback then
    Application:throw_exception("Error in 'gamedata/dialogs/'! The action '" .. tostring(l_50_1._meta) .. "' doesn't have an callback parameter!")
  end
  l_50_0._callback = l_50_1.callback
  l_50_0._class = l_50_1.class
  l_50_0._variable = DialogAction:setup_variable(l_50_1)
  if l_50_0._class then
    local class = _G[l_50_0._class]
    if not class then
      Application:throw_exception("Error in 'gamedata/dialogs/'! The class '" .. tostring(l_50_0._class) .. "' doesn't exist!")
    end
    if not class[l_50_0._callback] then
      Application:throw_exception("Error in 'gamedata/dialogs/'! The function '" .. tostring(l_50_0._callback) .. "' doesn't exist in '" .. tostring(l_50_0._class) .. "' class!")
    else
      if not DialogCallbacks[l_50_0._callback] then
        Application:throw_exception("Error in 'gamedata/dialogs/'! The function '" .. tostring(l_50_0._callback) .. "' doesn't exist in 'DialogCallbacks' class!")
      end
    end
  end
end

l_0_0.init = l_0_1
l_0_0 = DialogActionCallback
l_0_1 = function(l_51_0, ...)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  if DialogAction:check_variable(l_51_0._variable) and l_51_0._callback then
    if l_51_0._class then
      _G[l_51_0._class][l_51_0._callback]()
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    else
      DialogCallbacks[l_51_0._callback]()
    end
  end
  return 0
end

l_0_0.execute = l_0_1
l_0_0 = DialogActionQuit
if not l_0_0 then
  l_0_0 = class
  l_0_1 = DialogAction
  l_0_0 = l_0_0(l_0_1)
end
DialogActionQuit = l_0_0
l_0_0 = DialogActionQuit
l_0_1 = function(l_52_0, l_52_1)
  l_52_0._variable = DialogAction:setup_variable(l_52_1)
end

l_0_0.init = l_0_1
l_0_0 = DialogActionQuit
l_0_1 = function(l_53_0, ...)
  if DialogAction:check_variable(l_53_0._variable) then
    managers.dialog:quit_dialog()
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

l_0_0.execute = l_0_1
l_0_0 = DialogActionOption
if not l_0_0 then
  l_0_0 = class
  l_0_1 = DialogAction
  l_0_0 = l_0_0(l_0_1)
end
DialogActionOption = l_0_0
l_0_0 = DialogActionOption
l_0_1 = function(l_54_0, l_54_1)
  if not l_54_1.string_id or not l_54_1.go_to_node then
    Application:throw_exception("Error in 'gamedata/dialogs/'! The action '" .. tostring(l_54_1._meta) .. "' doesn't have an string_id or go_to_node parameter!")
  end
  l_54_0._data = {string_id = l_54_1.string_id, go_to_node = l_54_1.go_to_node}
  l_54_0._variable = DialogAction:setup_variable(l_54_1)
end

l_0_0.init = l_0_1
l_0_0 = DialogActionOption
l_0_1 = function(l_55_0)
  if DialogAction:check_variable(l_55_0._variable) then
    return l_55_0._data
  end
  return nil
end

l_0_0.data = l_0_1
l_0_0 = DialogActionRandom
if not l_0_0 then
  l_0_0 = class
  l_0_1 = DialogAction
  l_0_0 = l_0_0(l_0_1)
end
DialogActionRandom = l_0_0
l_0_0 = DialogActionRandom
l_0_1 = function(l_56_0, l_56_1)
  if not l_56_1.go_to_node then
    Application:throw_exception("Error in 'gamedata/dialogs/'! The action '" .. tostring(l_56_1._meta) .. "' doesn't have an 'go_to_node' parameter!")
  end
  l_56_0._go_to_node = l_56_1.go_to_node
end

l_0_0.init = l_0_1
l_0_0 = DialogActionRandom
l_0_1 = function(l_57_0, ...)
  managers.dialog:go_to_node(l_57_0._go_to_node)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

l_0_0.execute = l_0_1
l_0_0 = DialogActionCase
if not l_0_0 then
  l_0_0 = class
  l_0_1 = DialogAction
  l_0_0 = l_0_0(l_0_1)
end
DialogActionCase = l_0_0
l_0_0 = DialogActionCase
l_0_1 = function(l_58_0, l_58_1)
  if not l_58_1.value then
    Application:throw_exception("Error in 'gamedata/dialogs/'! The action '" .. tostring(l_58_1._meta) .. "' doesn't have an 'value' parameter!")
  end
  if not l_58_1.go_to_node then
    Application:throw_exception("Error in 'gamedata/dialogs/'! The action '" .. tostring(l_58_1._meta) .. "' doesn't have an 'go_to_node' parameter!")
  end
  l_58_0._value = l_58_1.value
  l_58_0._go_to_node = l_58_1.go_to_node
end

l_0_0.init = l_0_1
l_0_0 = DialogActionCase
l_0_1 = function(l_59_0)
  return l_59_0._value
end

l_0_0.value = l_0_1
l_0_0 = DialogActionCase
l_0_1 = function(l_60_0, ...)
  managers.dialog:go_to_node(l_60_0._go_to_node)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

l_0_0.execute = l_0_1
l_0_0 = DialogCallbacks
if not l_0_0 then
  l_0_0 = class
  l_0_0 = l_0_0()
end
DialogCallbacks = l_0_0
l_0_0 = DialogCallbacks
l_0_1 = function(l_61_0)
end

l_0_0.init = l_0_1

