-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\props\christmaspresentbase.luac 

if not ChristmasPresentBase then
  ChristmasPresentBase = class(UnitBase)
end
ChristmasPresentBase.init = function(l_1_0, l_1_1)
  UnitBase.init(l_1_0, l_1_1, false)
  l_1_0._unit = l_1_1
  l_1_0._unit:set_slot(0)
end

ChristmasPresentBase.take_money = function(l_2_0, l_2_1)
  managers.challenges:set_flag("take_christmas_present")
  local params = {}
  params.effect = Idstring("effects/particles/environment/player_snowflakes")
  params.position = Vector3()
  params.rotation = Rotation()
  World:effect_manager():spawn(params)
  managers.hud._sound_source:post_event("jingle_bells")
  Network:detach_unit(l_2_0._unit)
  l_2_0._unit:set_slot(0)
end

ChristmasPresentBase.update = function(l_3_0, l_3_1, l_3_2, l_3_3)
end

ChristmasPresentBase.destroy = function(l_4_0)
end


