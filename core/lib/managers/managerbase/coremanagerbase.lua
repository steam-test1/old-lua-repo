-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\managerbase\coremanagerbase.luac 

core:module("CoreManagerBase")
PRIO_FUTURECORE1 = 1
PRIO_FUTURECORE2 = 2
PRIO_FUTURECORE3 = 3
PRIO_FUTURECORE4 = 4
PRIO_FUTURECORE5 = 5
PRIO_FREEFLIGHT = 10
PRIO_CUTSCENE = 20
PRIO_WORLDCAMERA = 30
PRIO_GAMEPLAY = 40
PRIO_DEFAULT = PRIO_GAMEPLAY
if not ManagerBase then
  ManagerBase = class()
end
ManagerBase.init = function(l_1_0, l_1_1)
  l_1_0.__name = l_1_1
  l_1_0.__aos = {}
  l_1_0.__ao2prio = {}
  l_1_0.__really_active = {}
  l_1_0.__active_requested = {}
  l_1_0.__changed = false
end

ManagerBase._add_accessobj = function(l_2_0, l_2_1, l_2_2)
  assert(l_2_1:active_requested() == false)
  assert(l_2_1:really_active() == false)
  assert(l_2_2 > 0)
  l_2_0.__ao2prio[l_2_1] = l_2_2
  table.insert(l_2_0.__aos, l_2_1)
end

ManagerBase._del_accessobj = function(l_3_0, l_3_1)
  l_3_0.__ao2prio[l_3_1] = nil
  table.delete(l_3_0.__aos, l_3_1)
  table.delete(l_3_0.__really_active, l_3_1)
  table.delete(l_3_0.__active_requested, l_3_1)
  l_3_1:_really_deactivate()
end

ManagerBase._all_ao = function(l_4_0)
  return l_4_0.__aos
end

ManagerBase._all_really_active = function(l_5_0)
  return l_5_0.__really_active
end

ManagerBase._all_active_requested = function(l_6_0)
  return l_6_0.__active_requested
end

ManagerBase._ao_by_name = function(l_7_0, l_7_1)
  return table.find_value(l_7_0.__aos, function(l_1_0)
    return l_1_0:name() == name
   end)
end

ManagerBase._all_ao_by_prio = function(l_8_0, l_8_1)
  return table.find_all_values(l_8_0.__aos, function(l_1_0)
    return self.__ao2prio[l_1_0] == prio
   end)
end

ManagerBase._all_really_active_by_prio = function(l_9_0, l_9_1)
  return table.find_all_values(l_9_0.__really_active, function(l_1_0)
    return self.__ao2prio[l_1_0] == prio
   end)
end

ManagerBase._all_active_requested_by_prio = function(l_10_0, l_10_1)
  return table.find_all_values(l_10_0.__active_requested, function(l_1_0)
    return self.__ao2prio[l_1_0] == prio
   end)
end

ManagerBase._prioritize_and_activate = function(l_11_0)
  l_11_0.__active_requested = table.find_all_values(l_11_0.__aos, function(l_1_0)
    return l_1_0:active_requested()
   end)
  do
    local req_prio = math.huge
    for _,ao in ipairs(l_11_0.__active_requested) do
      req_prio = math.min(req_prio, l_11_0.__ao2prio[ao])
    end
    for ao,prio in pairs(l_11_0.__ao2prio) do
      if prio < req_prio and ao:really_active() then
        ao:_really_deactivate()
        for (for control),ao in (for generator) do
          if prio == req_prio and not ao:active_requested() and ao:really_active() then
            ao:_really_deactivate()
            for (for control),ao in (for generator) do
              if ao:really_active() then
                ao:_really_deactivate()
              end
            end
          end
        end
        for ao,prio in pairs(l_11_0.__ao2prio) do
          if prio == req_prio and ao:active_requested() and not ao:really_active() then
            ao:_really_activate()
          end
        end
        l_11_0.__really_active = table.find_all_values(l_11_0.__aos, function(l_2_0)
        return l_2_0:really_active()
         end)
        l_11_0.__changed = true
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ManagerBase.end_update = function(l_12_0, l_12_1, l_12_2)
  if l_12_0.__changed then
    local p2aos = {}
    for ao,p in pairs(l_12_0.__ao2prio) do
      if not p2aos[p] then
        p2aos[p] = {}
      end
      table.insert(p2aos[p], ao)
    end
    cat_print("spam", "[ManagerBase] During this frame activation states changed for manager " .. string.upper(l_12_0.__name) .. ":")
    cat_print("spam", "[ManagerBase]   <name>           <prio> <active> <really_active>")
    for _,p in ipairs(table.map_keys(p2aos)) do
      for _,ao in ipairs(p2aos[p]) do
        cat_print("spam", string.format("[ManagerBase]    %-15s %5d   %-6s   %s", tostring(ao:name()), p, ao:active_requested() and "YES" or "no", ao:really_active() and "YES" or "no"))
      end
    end
    l_12_0.__changed = false
  end
end


