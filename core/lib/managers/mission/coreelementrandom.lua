-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\mission\coreelementrandom.luac 

core:module("CoreElementRandom")
core:import("CoreMissionScriptElement")
core:import("CoreTable")
if not ElementRandom then
  ElementRandom = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementRandom.init = function(l_1_0, ...)
  ElementRandom.super.init(l_1_0, ...)
  l_1_0._original_on_executed = CoreTable.clone(l_1_0._values.on_executed)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementRandom.client_on_executed = function(l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementRandom.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  l_3_0._unused_randoms = {}
  for i,element_data in ipairs(l_3_0._original_on_executed) do
    if not l_3_0._values.ignore_disabled or l_3_0._values.ignore_disabled and l_3_0:get_mission_element(element_data.id):enabled() then
      table.insert(l_3_0._unused_randoms, i)
    end
  end
  l_3_0._values.on_executed = {}
  local amount = l_3_0._values.amount or 1
  if l_3_0._values.counter_id then
    local element = l_3_0:get_mission_element(l_3_0._values.counter_id)
    amount = element:counter_value()
  end
  for i = 1, math.min(amount, #l_3_0._original_on_executed) do
    table.insert(l_3_0._values.on_executed, l_3_0._original_on_executed[l_3_0:_get_random_elements()])
  end
  ElementRandom.super.on_executed(l_3_0, l_3_1)
end

ElementRandom._get_random_elements = function(l_4_0)
  local t = {}
  local rand = math.random(#l_4_0._unused_randoms)
  return table.remove(l_4_0._unused_randoms, rand)
end


