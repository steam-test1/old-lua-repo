-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\system\corepatchlua.luac 

local mt = getmetatable(_G)
if mt == nil then
  mt = {}
  setmetatable(_G, mt)
end
mt.__declared = {}
mt.__newindex = function(l_1_0, l_1_1, l_1_2)
  if not mt.__declared[l_1_1] then
    local info = debug.getinfo(2, "S")
    if info and info.what ~= "main" and info.what ~= "C" then
      error("cannot assign undeclared global '" .. tostring(l_1_1) .. "'", 2)
    end
    mt.__declared[l_1_1] = true
  end
  rawset(l_1_0, l_1_1, l_1_2)
end

mt.__index = function(l_2_0, l_2_1)
  if not mt.__declared[l_2_1] then
    local info = debug.getinfo(2, "S")
    if info and info.what ~= "main" and info.what ~= "C" then
      error("cannot use undeclared global '" .. tostring(l_2_1) .. "'", 2)
    end
  end
end


