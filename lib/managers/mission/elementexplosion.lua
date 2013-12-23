-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementexplosion.luac 

core:import("CoreMissionScriptElement")
if not ElementExplosion then
  ElementExplosion = class(ElementFeedback)
end
ElementExplosion.init = function(l_1_0, ...)
  ElementExplosion.super.init(l_1_0, ...)
  if Application:editor() and l_1_0._values.explosion_effect ~= "none" then
    CoreEngineAccess._editor_load(l_1_0.IDS_EFFECT, l_1_0._values.explosion_effect:id())
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

  end
end

ElementExplosion.client_on_executed = function(l_2_0, ...)
  l_2_0:on_executed(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementExplosion.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  print("ElementExplosion:on_executed( instigator )")
  local player = managers.player:player_unit()
  if player then
    player:character_damage():damage_explosion({position = l_3_0._values.position, range = l_3_0._values.range, damage = l_3_0._values.player_damage})
  end
  GrenadeBase._spawn_sound_and_effects(l_3_0._values.position, l_3_0._values.rotation:z(), l_3_0._values.range, l_3_0._values.explosion_effect)
  if Network:is_server() then
    GrenadeBase._detect_and_give_dmg({_range = l_3_0._values.range, _collision_slotmask = managers.slot:get_mask("bullet_impact_targets"), _curve_pow = 5, _damage = l_3_0._values.damage, _player_damage = 0}, l_3_0._values.position)
    managers.network:session():send_to_peers_synched("element_explode_on_client", l_3_0._values.position, l_3_0._values.rotation:z(), l_3_0._values.damage, l_3_0._values.range, 5)
  end
  ElementExplosion.super.on_executed(l_3_0, l_3_1)
end


