-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\dramamanager.luac 

if not DramaManager then
  DramaManager = class()
end
DramaManager.init = function(l_1_0)
  l_1_0._cues = {}
  l_1_0:_load_data()
end

DramaManager.cue = function(l_2_0, l_2_1)
  return l_2_0._cues[l_2_1]
end

DramaManager._load_data = function(l_3_0)
  local file_name = "gamedata/dramas/index"
  local data = PackageManager:script_data(Idstring("drama_index"), file_name:id())
  for _,c in ipairs(data) do
    if c.name then
      l_3_0:_load_drama(c.name)
    end
  end
end

DramaManager._load_drama = function(l_4_0, l_4_1)
  local file_name = "gamedata/dramas/" .. l_4_1
  local data = (PackageManager:script_data(Idstring("drama"), file_name:id()))
  do
    local id = nil
    for _,c in ipairs(data) do
      if c.id then
        id = c.id
        l_4_0._cues[id] = {}
        local empty = true
        for _,node in ipairs(c) do
          if node._meta == "string_id" then
            l_4_0._cues[id].string_id = node.name
            empty = false
            for (for control),_ in (for generator) do
            end
            if node._meta == "sound" then
              l_4_0._cues[id].sound = node.name
              if node.source then
                l_4_0._cues[id].sound_source = Idstring(node.source)
              end
              empty = false
              for (for control),_ in (for generator) do
              end
              if node._meta == "animation" then
                l_4_0._cues[id].animation = node.name
                empty = false
                for (for control),_ in (for generator) do
                end
                if node._meta == "duration" then
                  l_4_0._cues[id].duration = l_4_0:_process_duration(node.value)
                end
              end
              if empty then
                Application:throw_exception("Error in 'gamedata/dramas/" .. l_4_1 .. "'! The drama '" .. tostring(id) .. "' is empty!")
              end
              if not l_4_0._cues[id].duration then
                if l_4_0._cues[id].sound then
                  l_4_0._cues[id].duration = "sound"
                else
                  if l_4_0._cues[id].string_id then
                    l_4_0._cues[id].duration = "text"
                  else
                    l_4_0._cues[id].duration = "animation"
                  end
                end
              end
              if l_4_0._cues[id].duration == "sound" and not l_4_0._cues[id].sound then
                Application:throw_exception("Error in 'gamedata/dramas/" .. l_4_1 .. "'! Duration can't be based on sound because the drama doesn't have one!")
              else
                if l_4_0._cues[id].duration == "animation" and not l_4_0._cues[id].animation then
                  Application:throw_exception("Error in 'gamedata/dramas/" .. l_4_1 .. "'! Duration can't be based on animation because the drama doesn't have one!")
                else
                  if l_4_0._cues[id].duration == "text" and not l_4_0._cues[id].string_id then
                    Application:throw_exception("Error in 'gamedata/dramas/" .. l_4_1 .. "'! Duration can't be based on text because the drama doesn't have one!")
                  end
                end
              end
              if l_4_0._cues[id].duration == "text" then
                local text = managers.localization:text(l_4_0._cues[id].string_id)
                l_4_0._cues[id].duration = text:len() * tweak_data.dialog.DURATION_PER_CHAR
                if l_4_0._cues[id].duration < tweak_data.dialog.MINIMUM_DURATION then
                  l_4_0._cues[id].duration = tweak_data.dialog.MINIMUM_DURATION
                end
              end
            end
          end
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

DramaManager._process_duration = function(l_5_0, l_5_1)
  if not l_5_1 then
    return nil
  end
  if l_5_1 == "sound" or l_5_1 == "animation" or l_5_1 == "text" then
    return l_5_1
  else
    l_5_1 = tonumber(l_5_1)
    if not l_5_1 then
      Application:throw_exception("Error in 'gamedata/dramas/'! The duration parameter in drama file isn't valid! (Use 'sound', 'animation' or a number as value)")
    end
    return l_5_1
  end
end


