-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\units\civilians\actions\lower_body\civilianactionwalk.luac 

if not CivilianActionWalk then
  CivilianActionWalk = class(CopActionWalk)
end
local l_0_0 = CivilianActionWalk
local l_0_1 = {}
local l_0_2 = {}
local l_0_3 = {}
local l_0_4 = {}
l_0_4.fwd = 129
l_0_4.bwd = 111.30000305176
l_0_4.l = 136.10000610352
l_0_4.r = 136.10000610352
l_0_3.walk = l_0_4
l_0_4 = {fwd = 421, bwd = 222, l = 436, r = 419}
l_0_3.run = l_0_4
l_0_2.ntl = l_0_3
l_0_4 = {fwd = 170, bwd = 170, l = 170, r = 170}
l_0_4 = {fwd = 421, bwd = 222, l = 436, r = 419}
l_0_3 = {walk = l_0_4, run = l_0_4}
l_0_2.hos = l_0_3
l_0_1.stand = l_0_2
l_0_0._walk_anim_velocities = l_0_1
l_0_0 = CivilianActionWalk
l_0_4 = Vector3
l_0_4 = l_0_4(49, -161, 0)
l_0_3 = {ds = l_0_4}
l_0_4 = Vector3
l_0_4 = l_0_4(-250, 90, 0)
l_0_3 = {ds = l_0_4}
l_0_4 = Vector3
l_0_4 = l_0_4(240, 68, 0)
l_0_3 = {ds = l_0_4}
l_0_2 = {run_start_turn_bwd = l_0_3, run_start_turn_l = l_0_3, run_start_turn_r = l_0_3, run_stop_fwd = 120, run_stop_l = 110, run_stop_r = 80}
l_0_1 = {stand = l_0_2}
l_0_0._anim_movement = l_0_1

