-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\civilians\actions\lower_body\escortwithsuitcaseactionwalk.luac 

if not EscortWithSuitcaseActionWalk then
  EscortWithSuitcaseActionWalk = class(CopActionWalk)
end
EscortWithSuitcaseActionWalk._walk_anim_velocities = {stand = {ntl = {run = {fwd = 138, bwd = 70, l = 93, r = 65}}}}
EscortWithSuitcaseActionWalk._walk_anim_lengths = {stand = {ntl = {run = {fwd = 28, bwd = 32, l = 45, r = 39}}}}
for pose,stances in pairs(EscortWithSuitcaseActionWalk._walk_anim_lengths) do
  for stance,speeds in pairs(stances) do
    for speed,sides in pairs(speeds) do
      for side,speed in pairs(sides) do
        sides[side] = speed * 0.033330000936985
      end
    end
  end
end
if not EscortPrisonerActionWalk then
  EscortPrisonerActionWalk = class(CopActionWalk)
end
EscortPrisonerActionWalk._walk_anim_velocities = {stand = {ntl = {run = {fwd = 329, bwd = 170, l = 170, r = 170}}}}
EscortPrisonerActionWalk._walk_anim_lengths = {stand = {ntl = {run = {fwd = 22, bwd = 19, l = 25, r = 29}}}}
for pose,stances in pairs(EscortPrisonerActionWalk._walk_anim_lengths) do
  for stance,speeds in pairs(stances) do
    for speed,sides in pairs(speeds) do
      for side,speed in pairs(sides) do
        sides[side] = speed * 0.033330000936985
      end
    end
  end
end

