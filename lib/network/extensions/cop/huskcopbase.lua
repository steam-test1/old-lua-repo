-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\network\extensions\cop\huskcopbase.luac 

if not HuskCopBase then
  HuskCopBase = class(CopBase)
end
HuskCopBase.post_init = function(l_1_0)
  l_1_0._ext_movement = l_1_0._unit:movement()
  l_1_0._ext_movement:post_init()
  l_1_0._unit:brain():post_init()
  l_1_0:set_anim_lod(1)
  l_1_0._lod_stage = 1
  managers.enemy:register_enemy(l_1_0._unit)
end

HuskCopBase.pre_destroy = function(l_2_0, l_2_1)
  l_2_0._unit:brain():pre_destroy()
  l_2_0._ext_movement:pre_destroy()
  if l_2_1:inventory() then
    l_2_1:inventory():pre_destroy(l_2_1)
  end
  UnitBase.pre_destroy(l_2_0, l_2_1)
end


