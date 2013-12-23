-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\menu\coremenumanager.luac 

core:module("CoreMenuManager")
core:import("CoreMenuData")
core:import("CoreMenuLogic")
core:import("CoreMenuInput")
core:import("CoreMenuRenderer")
if not Manager then
  Manager = class()
end
Manager.init = function(l_1_0)
  managers.menu = managers.menu or l_1_0
  l_1_0._registered_menus = {}
  l_1_0._open_menus = {}
end

Manager.destroy = function(l_2_0)
  for _,menu in ipairs(l_2_0._open_menus) do
    l_2_0:close_menu(menu.name)
  end
end

Manager.register_menu = function(l_3_0, l_3_1)
  if l_3_1.name and l_3_0._registered_menus[l_3_1.name] then
    return 
  end
  l_3_1.data = CoreMenuData.Data:new()
  l_3_1.data:load_data(l_3_1.content_file, l_3_1.id)
  l_3_1.data:set_callback_handler(l_3_1.callback_handler)
  l_3_1.logic = CoreMenuLogic.Logic:new(l_3_1.data)
  l_3_1.logic:register_callback("menu_manager_menu_closed", callback(l_3_0, l_3_0, "_menu_closed", l_3_1.name))
  l_3_1.logic:register_callback("menu_manager_select_node", callback(l_3_0, l_3_0, "_node_selected", l_3_1.name))
  if not l_3_1.input then
    l_3_1.input = CoreMenuInput.MenuInput:new(l_3_1.logic, l_3_1.name)
  else
    l_3_1.input = loadstring("return " .. l_3_1.input)()
    l_3_1.input = l_3_1.input:new(l_3_1.logic, l_3_1.name)
  end
  if not l_3_1.renderer then
    l_3_1.renderer = CoreMenuRenderer.Renderer:new(l_3_1.logic)
  else
    l_3_1.renderer = loadstring("return " .. l_3_1.renderer)()
    l_3_1.renderer = l_3_1.renderer:new(l_3_1.logic)
  end
  l_3_1.renderer:preload()
  if l_3_1.name then
    l_3_0._registered_menus[l_3_1.name] = l_3_1
  else
    Application:error("Manager:register_menu(): Menu '" .. l_3_1.id .. "' is missing a name, in '" .. l_3_1.content_file .. "'")
  end
end

Manager.get_menu = function(l_4_0, l_4_1)
  local menu = l_4_0._registered_menus[l_4_1]
  return menu
end

Manager.open_menu = function(l_5_0, l_5_1, l_5_2, ...)
  do
    local menu = l_5_0._registered_menus[l_5_1]
    if menu then
      for _,open_menu in ipairs(l_5_0._open_menus) do
        if open_menu.name == l_5_1 then
          return false
        end
      end
      local current_open_menu = l_5_0._open_menus[#l_5_0._open_menus]
      if not l_5_0._open_menus[#l_5_0._open_menus] or l_5_2 then
        table.insert(l_5_0._open_menus, l_5_2, menu)
      else
        table.insert(l_5_0._open_menus, menu)
      end
      if current_open_menu and current_open_menu ~= l_5_0._open_menus[#l_5_0._open_menus] then
        current_open_menu.renderer:hide()
      end
      menu.renderer:open(...)
      menu.logic:open(...)
      menu.input:open(l_5_2, ...)
      l_5_0:input_enabled(true)
      return true
    else
      Application:error("Manager:open_menu: No menu named '" .. l_5_1 .. "'")
      return false
    end
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

Manager.close_menu = function(l_6_0, l_6_1)
   -- DECOMPILER ERROR: Confused at declaration of local variable

  if l_6_1 then
    for _,open_menu in ipairs(l_6_0._open_menus) do
      do
         -- DECOMPILER ERROR: Confused at declaration of local variable

        if i_3.name == l_6_1 then
          do return end
        end
         -- DECOMPILER ERROR: Confused about usage of registers for local variables.

      end
    end
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Confused about usage of registers!

  else
    if i_3 then
      i_3.logic:close(true)
       -- DECOMPILER ERROR: Confused about usage of registers!

      i_3.input:close()
       -- DECOMPILER ERROR: Confused about usage of registers!

      i_3.renderer:close()
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
     -- Warning: missing end command somewhere! Added here
  end
end

Manager._menu_closed = function(l_7_0, l_7_1)
  if l_7_1 then
    for i,menu in ipairs(l_7_0._open_menus) do
      if menu.name == l_7_1 then
        table.remove(l_7_0._open_menus, i)
      end
    end
  else
    table.remove(l_7_0._open_menus, #l_7_0._open_menus)
  end
  if l_7_0._open_menus[#l_7_0._open_menus] then
    l_7_0._open_menus[#l_7_0._open_menus].renderer:show()
    l_7_0._open_menus[#l_7_0._open_menus].logic:accept_input(true)
    l_7_0._open_menus[#l_7_0._open_menus].logic:soft_open()
  end
end

Manager._node_selected = function(l_8_0, l_8_1, l_8_2)
end

Manager.input_enabled = function(l_9_0, l_9_1)
  l_9_0._input_enabled = l_9_1
  for _,menu in ipairs(l_9_0._open_menus) do
    menu.input:focus(l_9_1)
  end
end

Manager.update = function(l_10_0, l_10_1, l_10_2)
  local active_menu = l_10_0._open_menus[#l_10_0._open_menus]
  if active_menu then
    active_menu.logic:update(l_10_1, l_10_2)
    if l_10_0._input_enabled then
      active_menu.input:update(l_10_1, l_10_2)
    end
  end
  for _,menu in ipairs(l_10_0._open_menus) do
    menu.renderer:update(l_10_1, l_10_2)
  end
end


