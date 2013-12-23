-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementcarry.luac 

core:import("CoreMissionScriptElement")
if not ElementCarry then
  ElementCarry = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementCarry.init = function(l_1_0, ...)
  ElementCarry.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementCarry.on_executed = function(l_2_0, l_2_1)
  if not l_2_0._values.enabled or not alive(l_2_1) then
    return 
  end
  if l_2_0._values.type_filter and l_2_0._values.type_filter ~= "none" then
    local carry_ext = l_2_1:carry_data()
    local carry_id = carry_ext:carry_id()
    if carry_id ~= l_2_0._values.type_filter then
      return 
    end
  end
  if l_2_0._values.operation == "remove" and Network:is_server() then
    l_2_1:set_slot(0)
    do return end
    if l_2_0._values.operation == "add_to_respawn" and Network:is_server() then
      local carry_ext = l_2_1:carry_data()
      local carry_id = carry_ext:carry_id()
      do
        local value = carry_ext:value()
        managers.loot:add_to_respawn(carry_id, value)
        l_2_1:set_slot(0)
      end
      do return end
      if l_2_0._values.operation == "freeze" then
        if l_2_1:damage():has_sequence("freeze") then
          l_2_1:damage():run_sequence_simple("freeze")
        else
          debug_pause("[ElementCarry:on_executed] instigator missing freeze sequence", l_2_1)
        end
      else
        if l_2_0._values.operation == "secure" or l_2_0._values.operation == "secure_silent" then
          if l_2_1:carry_data() then
            local carry_ext = l_2_1:carry_data()
            if l_2_0._values.operation ~= "secure_silent" then
              local silent = not Network:is_server()
            end
            local carry_id = carry_ext:carry_id()
            do
              local value = carry_ext:value()
              managers.loot:secure(carry_id, value, silent)
            end
            carry_ext:set_value(0)
            if l_2_1:damage():has_sequence("secured") then
              l_2_1:damage():run_sequence_simple("secured")
            else
              debug_pause("[ElementCarry:on_executed] instigator missing secured sequence", l_2_1)
            end
          else
            debug_pause("[ElementCarry:on_executed] instigator missing carry_data extension", l_2_1)
          end
        end
      end
    end
  end
  ElementCarry.super.on_executed(l_2_0, l_2_1)
end

ElementCarry.client_on_executed = function(l_3_0, ...)
  l_3_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end


