-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\units\data\corecutscenedata.luac 

if not CoreCutsceneData then
  CoreCutsceneData = class()
end
CutsceneData = CoreCutsceneData
CoreCutsceneData.init = function(l_1_0, l_1_1)
  l_1_0.__unit = assert(l_1_1, "Unit not supplied to CoreCutsceneData.")
  l_1_0.__cutscene_name = l_1_0:_cutscene_name(l_1_1:name())
  l_1_0:cutscene_player(true, true)
  managers.cutscene:register_unit_with_cutscene_data_extension(l_1_0.__unit)
end

CoreCutsceneData.destroy = function(l_2_0)
  l_2_0:destroy_cutscene_player()
  managers.cutscene:unregister_unit_with_cutscene_data_extension(l_2_0.__unit)
  l_2_0.__unit = nil
  l_2_0.__cutscene_name = nil
end

CoreCutsceneData.cutscene_player = function(l_3_0, l_3_1, l_3_2)
  if l_3_0.__cutscene_player == nil then
    local cutscene = managers.cutscene:get_cutscene(l_3_0.__cutscene_name)
    do
      if not l_3_1 then
        cat_print("spam", "[CoreCutsceneData] The cutscene \"" .. cutscene:name() .. "\" has been cleaned up. Call CoreCutsceneData:reset_cutscene_player() before attempting to replay it.")
      end
      l_3_0.__cutscene_player = core_or_local("CutscenePlayer", cutscene)
      l_3_0.__cutscene_player:add_keys()
      if not l_3_2 then
        l_3_0.__cutscene_player:prime()
      end
      local actual_destroy_func = l_3_0.__cutscene_player.destroy
      l_3_0.__cutscene_player.destroy = function(l_1_0)
        assert(l_1_0 == self.__cutscene_player)
        self.__cutscene_player = nil
        actual_destroy_func(l_1_0)
         end
    end
  end
  return l_3_0.__cutscene_player
end

CoreCutsceneData.destroy_cutscene_player = function(l_4_0)
  if l_4_0.__cutscene_player then
    l_4_0.__cutscene_player:destroy()
    assert(l_4_0.__cutscene_player == nil)
  end
end

CoreCutsceneData.reset_cutscene_player = function(l_5_0)
  l_5_0:destroy_cutscene_player()
  l_5_0:cutscene_player(true)
end

CoreCutsceneData._cutscene_name = function(l_6_0, l_6_1)
  return string.match(l_6_1, "cutscene_(.+)")
end


