-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\coreexpressionmanager.luac 

core:module("CoreExpressionManager")
if not ExpressionManager then
  ExpressionManager = class()
end
ExpressionManager.init = function(l_1_0)
  l_1_0._units = {}
  l_1_0._preloads = {}
end

ExpressionManager.update = function(l_2_0, l_2_1, l_2_2)
  for i,exp in pairs(l_2_0._units) do
    if not exp:update(l_2_1, l_2_2) then
      l_2_0._units[i] = nil
    end
  end
end

ExpressionManager.preload = function(l_3_0, l_3_1)
  l_3_0._preloads[l_3_1] = Database:load_node(Database:lookup("expression", l_3_1))
end

ExpressionManager.play = function(l_4_0, l_4_1, l_4_2, l_4_3, l_4_4)
  l_4_0._units[l_4_1:key()] = CoreExpressionMovie:new(l_4_1, l_4_2, l_4_3, l_4_0._preloads[l_4_3], l_4_4)
end

ExpressionManager.stop = function(l_5_0, l_5_1)
  l_5_0._units[l_5_1:key()] = nil
end


