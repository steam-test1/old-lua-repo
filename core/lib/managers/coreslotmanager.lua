-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\coreslotmanager.luac 

core:module("CoreSlotManager")
if not SlotManager then
  SlotManager = class()
end
SlotManager.init = function(l_1_0)
  local unit_manager = World:unit_manager()
  unit_manager:set_slot_limited(0, 0)
  unit_manager:set_slot_infinite(1)
  unit_manager:set_slot_infinite(10)
  unit_manager:set_slot_infinite(11)
  unit_manager:set_slot_infinite(15)
  unit_manager:set_slot_infinite(19)
  unit_manager:set_slot_infinite(29)
  unit_manager:set_slot_infinite(35)
  l_1_0._masks = {}
  l_1_0._masks.statics = World:make_slot_mask(1, 15, 36)
  l_1_0._masks.editor_all = World:make_slot_mask(1, 10, 11, 15, 19, 35, 36)
  l_1_0._masks.mission_elements = World:make_slot_mask(10)
  l_1_0._masks.surface_move = World:make_slot_mask(1, 11, 20, 21, 24, 35, 38)
  l_1_0._masks.hub_elements = World:make_slot_mask(10)
  l_1_0._masks.sound_layer = World:make_slot_mask(19)
  l_1_0._masks.environment_layer = World:make_slot_mask(19)
  l_1_0._masks.portal_layer = World:make_slot_mask(19)
  l_1_0._masks.ai_layer = World:make_slot_mask(19)
  l_1_0._masks.dynamics = World:make_slot_mask(11)
  l_1_0._masks.statics_layer = World:make_slot_mask(1, 11, 15)
  l_1_0._masks.dynamics_layer = World:make_slot_mask(11)
  l_1_0._masks.dump_all = World:make_slot_mask(1)
  l_1_0._masks.wires = World:make_slot_mask(35)
  l_1_0._masks.brush_placeable = World:make_slot_mask(1)
  l_1_0._masks.brushes = World:make_slot_mask(29)
end

SlotManager.get_mask = function(l_2_0, ...)
  do
    local arg_list = nil
    for _,name in pairs({...}) do
       -- DECOMPILER ERROR: Confused at declaration of local variable

      do
         -- DECOMPILER ERROR: Confused at declaration of local variable

         -- DECOMPILER ERROR: Confused about usage of registers!

        if l_2_0._masks[i_3] then
          if not arg_list then
            arg_list = l_2_0._masks[i_3]
            for i_1,i_2 in pairs({...}) do
            end
             -- DECOMPILER ERROR: Confused about usage of registers!

            arg_list = arg_list + l_2_0._masks[i_3]
            for i_1,i_2 in pairs({...}) do
            end
            Application:error("Invalid slotmask \"" .. tostring(i_3) .. "\".")
          end
           -- DECOMPILER ERROR: Confused about usage of registers for local variables.

        end
         -- DECOMPILER ERROR: Confused about usage of registers!

        if #{...} == 0 then
          Application:error("No parameters passed to get_mask function.")
        end
         -- DECOMPILER ERROR: Confused about usage of registers!

        return arg_list
      end
       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

SlotManager.get_mask_name = function(l_3_0, l_3_1)
  return table.get_key(l_3_0._masks, l_3_1)
end

SlotManager.get_mask_map = function(l_4_0)
  return l_4_0._masks
end


