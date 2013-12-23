-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\entry.luac 

 -- DECOMPILER ERROR: Overwrote pending register.

if Global.load_level then
  if Global.network then
    
    if not setup then
      setup = nil:new()
    end
    setup:make_entrypoint()
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

     -- Warning: missing end command somewhere! Added here
  end

