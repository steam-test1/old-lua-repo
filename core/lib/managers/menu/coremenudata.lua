-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\menu\coremenudata.luac 

core:module("CoreMenuData")
core:import("CoreMenuNode")
core:import("CoreSerialize")
if not Data then
  Data = class()
end
Data.init = function(l_1_0)
  l_1_0._nodes = {}
end

Data.get_node = function(l_2_0, l_2_1, ...)
  if l_2_1 and not l_2_0._nodes[l_2_1] then
    Application:error("Data:get_node(): No node named '" .. l_2_1 .. "'")
    return nil
    do return end
    if not l_2_0._default_node_name or not l_2_0._nodes[l_2_0._default_node_name] then
      Application:error("Data:get_node(): No default node")
      return nil
    end
  end
   -- DECOMPILER ERROR: Confused about usage of registers!

   -- DECOMPILER ERROR: Confused about usage of registers!

  if l_2_0._nodes[l_2_0._default_node_name]:parameters().modifier then
    for _,modify_func in ipairs(l_2_0._nodes[l_2_0._default_node_name]:parameters().modifier) do
       -- DECOMPILER ERROR: Confused at declaration of local variable

       -- DECOMPILER ERROR: Confused about usage of registers!

       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

    end
  end
  return i_3(l_2_0._nodes[l_2_0._default_node_name], ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

Data.load_data = function(l_3_0, l_3_1, l_3_2)
  local root = (PackageManager:script_data(Idstring("menu"), l_3_1:id()))
  do
    local menu = nil
    for _,c in ipairs(root) do
      if c._meta == "menu" and c.id and c.id == l_3_2 then
        menu = c
    else
      end
    end
    if not menu then
      Application:error("Data:load_data(): No menu with id '" .. l_3_2 .. "' in '" .. l_3_1 .. "'")
      return 
    end
    for _,c in ipairs(menu) do
      local type = c._meta
      if type == "node" then
        local node_class = CoreMenuNode.MenuNode
        local type = c.type
        if type then
          node_class = CoreSerialize.string_to_classtable(type)
        end
        do
          local name = c.name
          if name then
            l_3_0._nodes[name] = node_class:new(c)
            for (for control),_ in (for generator) do
            end
            Application:error("Menu node without name in '" .. l_3_2 .. "' in '" .. l_3_1 .. "'")
          end
          for (for control),_ in (for generator) do
          end
          if type == "default_node" then
            l_3_0._default_node_name = c.name
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

Data.set_callback_handler = function(l_4_0, l_4_1)
  for name,node in pairs(l_4_0._nodes) do
    node:set_callback_handler(l_4_1)
  end
end


