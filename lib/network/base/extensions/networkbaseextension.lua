-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\base\extensions\networkbaseextension.luac 

if not NetworkBaseExtension then
  NetworkBaseExtension = class()
end
NetworkBaseExtension.init = function(l_1_0, l_1_1)
  l_1_0._unit = l_1_1
end

NetworkBaseExtension.send = function(l_2_0, l_2_1, ...)
  if managers.network:session() then
    managers.network:session():send_to_peers_synched(l_2_1, l_2_0._unit, ...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

NetworkBaseExtension.send_to_host = function(l_3_0, l_3_1, ...)
  if managers.network:session() then
    managers.network:session():send_to_host(l_3_1, l_3_0._unit, ...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

NetworkBaseExtension.send_to_unit = function(l_4_0, l_4_1)
  if managers.network:game() then
    local member = managers.network:game():member_from_unit(l_4_0._unit)
    if not member then
      return 
    end
    managers.network:session():send_to_peer(member:peer(), unpack(l_4_1))
  end
end

NetworkBaseExtension.member = function(l_5_0)
  return managers.network:game():member_from_unit(l_5_0._unit)
end

NetworkBaseExtension.peer = function(l_6_0)
  if managers.network:game() then
    local member = managers.network:game():member_from_unit(l_6_0._unit)
    if member then
      return member:peer()
    end
  end
end


