-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\videomanager.luac 

if not VideoManager then
  VideoManager = class()
end
VideoManager.init = function(l_1_0)
  l_1_0._videos = {}
end

VideoManager.add_video = function(l_2_0, l_2_1)
  local volume = managers.user:get_setting("sfx_volume")
  local percentage = (volume - tweak_data.menu.MIN_SFX_VOLUME) / (tweak_data.menu.MAX_SFX_VOLUME - tweak_data.menu.MIN_SFX_VOLUME)
  l_2_1:set_volume_gain(percentage)
  table.insert(l_2_0._videos, l_2_1)
end

VideoManager.remove_video = function(l_3_0, l_3_1)
  table.delete(l_3_0._videos, l_3_1)
end

VideoManager.volume_changed = function(l_4_0, l_4_1)
  for _,video in ipairs(l_4_0._videos) do
    video:set_volume_gain(l_4_1)
  end
end


