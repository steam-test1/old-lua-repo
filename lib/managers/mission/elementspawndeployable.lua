-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\mission\elementspawndeployable.luac 

core:import("CoreMissionScriptElement")
if not ElementSpawnDeployable then
  ElementSpawnDeployable = class(CoreMissionScriptElement.MissionScriptElement)
end
ElementSpawnDeployable.init = function(l_1_0, ...)
  ElementSpawnDeployable.super.init(l_1_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementSpawnDeployable.client_on_executed = function(l_2_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

ElementSpawnDeployable.on_executed = function(l_3_0, l_3_1)
  if not l_3_0._values.enabled then
    return 
  end
  if l_3_0._values.deployable_id ~= "none" then
    if l_3_0._values.deployable_id == "doctor_bag" then
      DoctorBagBase.spawn(l_3_0._values.position, l_3_0._values.rotation, 0)
    else
      if l_3_0._values.deployable_id == "ammo_bag" then
        AmmoBagBase.spawn(l_3_0._values.position, l_3_0._values.rotation, 0)
      end
    end
  end
  ElementSpawnDeployable.super.on_executed(l_3_0, l_3_1)
end


