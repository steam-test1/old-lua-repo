-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\session\debug\coresessiondebug.luac 

core:module("CoreSessionDebug")
if not SessionDebug then
  SessionDebug = class()
end
SessionDebug.init = function(l_1_0, l_1_1)
  l_1_0._session_state = l_1_1
  l_1_0:_parse_standard_arguments()
end

SessionDebug._parse_standard_arguments = function(l_2_0)
  local level = nil
  local args = Application:argv()
  for i,arg in ipairs(args) do
    if arg == "-level" then
      level = true
      for (for control),i in (for generator) do
      end
      if level then
        level_name = arg
        local session_info = l_2_0._session_state:session_info()
        session_info:set_level_name(level_name)
        l_2_0._session_state:player_slots():primary_slot():request_debug_local_user_binding()
        l_2_0._session_state:join_standard_session()
    else
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end


