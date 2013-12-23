-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\enemies\tank\actions\lower_body\tankcopactionwalk.luac 

if not TankCopActionWalk then
  TankCopActionWalk = class(CopActionWalk)
end
TankCopActionWalk._walk_anim_velocities = {stand = {cbt = {walk = {fwd = 144, bwd = 112.84999847412, l = 118.5299987793, r = 122.48000335693}, run = {fwd = 361.5, bwd = 357.23001098633, l = 287.42999267578, r = 318.32998657227}}}}
TankCopActionWalk._walk_anim_velocities.stand.ntl = TankCopActionWalk._walk_anim_velocities.stand.cbt
TankCopActionWalk._walk_anim_velocities.stand.hos = TankCopActionWalk._walk_anim_velocities.stand.cbt
TankCopActionWalk._walk_anim_velocities.stand.wnd = TankCopActionWalk._walk_anim_velocities.stand.cbt
TankCopActionWalk._walk_anim_velocities.crouch = TankCopActionWalk._walk_anim_velocities.stand
TankCopActionWalk._walk_anim_lengths = {stand = {cbt = {walk = {fwd = 34, bwd = 40, l = 40, r = 38}, run = {fwd = 20, bwd = 21, l = 20, r = 21}}}}
for pose,stances in pairs(TankCopActionWalk._walk_anim_lengths) do
  for stance,speeds in pairs(stances) do
    for speed,sides in pairs(speeds) do
      for side,speed in pairs(sides) do
        sides[side] = speed * 0.033330000936985
      end
    end
  end
end
TankCopActionWalk._walk_anim_lengths.stand.ntl = TankCopActionWalk._walk_anim_lengths.stand.cbt
TankCopActionWalk._walk_anim_lengths.stand.hos = TankCopActionWalk._walk_anim_lengths.stand.cbt
TankCopActionWalk._walk_anim_lengths.stand.wnd = TankCopActionWalk._walk_anim_lengths.stand.cbt
TankCopActionWalk._walk_anim_lengths.crouch = TankCopActionWalk._walk_anim_lengths.stand

