-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\corelocalizationmanager.luac 

core:module("CoreLocalizationManager")
core:import("CoreClass")
core:import("CoreEvent")
if not LocalizationManager then
  LocalizationManager = CoreClass.class()
end
LocalizationManager.init = function(l_1_0)
  Localizer:set_post_processor(CoreEvent.callback(l_1_0, l_1_0, "_localizer_post_process"))
  l_1_0._default_macros = {}
  l_1_0:set_default_macro("NL", "\n")
  l_1_0:set_default_macro("EMPTY", "")
  local platform_id = SystemInfo:platform()
  if platform_id == Idstring("X360") then
    l_1_0._platform = "X360"
  else
    if platform_id == Idstring("PS3") then
      l_1_0._platform = "PS3"
    else
      l_1_0._platform = "WIN32"
    end
  end
end

LocalizationManager.add_default_macro = function(l_2_0, l_2_1, l_2_2)
  l_2_0:set_default_macro(l_2_1, l_2_2)
end

LocalizationManager.set_default_macro = function(l_3_0, l_3_1, l_3_2)
  if not l_3_0._default_macros then
    l_3_0._default_macros = {}
  end
  l_3_0._default_macros["$" .. l_3_1 .. ";"] = tostring(l_3_2)
end

LocalizationManager.get_default_macro = function(l_4_0, l_4_1)
  return l_4_0._default_macros["$" .. l_4_1 .. ";"]
end

LocalizationManager.exists = function(l_5_0, l_5_1)
  return Localizer:exists(Idstring(l_5_1))
end

LocalizationManager.text = function(l_6_0, l_6_1, l_6_2)
  local return_string = "ERROR: " .. l_6_1
  local str_id = nil
  if not l_6_1 or l_6_1 == "" then
    return_string = ""
  else
    if l_6_0:exists(l_6_1 .. "_" .. l_6_0._platform) then
      str_id = l_6_1 .. "_" .. l_6_0._platform
    else
      if l_6_0:exists(l_6_1) then
        str_id = l_6_1
      end
    end
  end
  if str_id then
    l_6_0._macro_context = l_6_2
    return_string = Localizer:lookup(Idstring(str_id))
    l_6_0._macro_context = nil
  end
  return return_string
end

LocalizationManager._localizer_post_process = function(l_7_0, l_7_1)
  local localized_string = l_7_1
  local macros = {}
  if type(l_7_0._macro_context) ~= "table" then
    l_7_0._macro_context = {}
  end
  for k,v in pairs(l_7_0._default_macros) do
    macros[k] = v
  end
  for k,v in pairs(l_7_0._macro_context) do
    macros["$" .. k .. ";"] = tostring(v)
  end
  if l_7_0._pre_process_func then
    l_7_0._pre_process_func(macros)
  end
  localized_string = l_7_1.gsub(localized_string, "%b$;", macros)
  return localized_string
end


