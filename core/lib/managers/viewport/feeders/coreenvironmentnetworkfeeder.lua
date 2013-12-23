-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\viewport\feeders\coreenvironmentnetworkfeeder.luac 

core:module("CoreEnvironmentNetworkFeeder")
core:import("CoreClass")
core:import("CoreCode")
NETWORK_SLAVE_RECEIVER = Idstring("envnetfeeder_slave")
NETWORK_MASTER_RECEIVER = Idstring("envnetfeeder_master")
if not EnvironmentNetworkFeeder then
  EnvironmentNetworkFeeder = CoreClass.class()
end
EnvironmentNetworkFeeder.init = function(l_1_0)
  l_1_0._verification_table = {}
  l_1_0._block_nr = 1
end

EnvironmentNetworkFeeder.feed = function(l_2_0, l_2_1, l_2_2, l_2_3, l_2_4, l_2_5, ...)
  if l_2_1 == 1 then
    if assert(managers.slave:type()) == "slave" then
      if not l_2_0._data_cache then
        l_2_0._data_cache = l_2_4:copy()
        Network:set_receiver(NETWORK_SLAVE_RECEIVER, l_2_0)
      end
      l_2_4:set_parameter_block(l_2_0._data_cache:parameter_block(...), ...)
    elseif not l_2_0._peer then
      Network:set_receiver(NETWORK_MASTER_RECEIVER, l_2_0)
    end
    l_2_0._peer = assert(managers.slave:peer())
    l_2_0:send(l_2_0._block_nr, l_2_5, {...}, l_2_0._peer)
    l_2_0._block_nr = l_2_0._block_nr + 1
  end
  return false
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

EnvironmentNetworkFeeder.end_feed = function(l_3_0, l_3_1)
  if l_3_1 ~= 1 or not 1 then
    l_3_0._block_nr = l_3_0._block_nr
  end
end

EnvironmentNetworkFeeder.env_data_block_sync = function(l_4_0, l_4_1, l_4_2, l_4_3)
  local block, params = assert(loadstring("return " .. l_4_1))()
  l_4_0._data_cache:set_parameter_block(block, unpack(params))
  l_4_3:env_data_verify_block(l_4_2)
end

EnvironmentNetworkFeeder.env_data_verify_block = function(l_5_0, l_5_1)
  l_5_0._verification_table[tostring(l_5_1)] = true
end

EnvironmentNetworkFeeder.send = function(l_6_0, l_6_1, l_6_2, l_6_3, l_6_4)
  local id_str = tostring(l_6_1)
  local ver = l_6_0._verification_table[id_str]
  if ver == nil or ver == true then
    l_6_0._verification_table[id_str] = false
    l_6_4:env_data_block_sync(l_6_0:pack_data(l_6_2, l_6_3), l_6_1)
  end
end

EnvironmentNetworkFeeder.pack_data = function(l_7_0, l_7_1, l_7_2)
  assert(table.size(l_7_1) > 0 and table.size(l_7_2) > 0)
  local str = ""
  local bstr, pstr = nil, nil
  for k,v in pairs(l_7_1) do
    bstr = bstr and bstr .. "," or "{"
    bstr = string.format("%s%s=", bstr, string.match(k, "[%w_]+"))
    if type(v) ~= "string" or not string.format("%s'%s'", bstr, v) then
      bstr = bstr .. tostring(v)
    end
  end
  str = str .. bstr .. "},"
  for _,v in pairs(l_7_2) do
    pstr = pstr and pstr .. "," or "{"
    pstr = string.format("%s'%s'", pstr, v)
  end
  return str .. pstr .. "}"
end


