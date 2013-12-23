-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\setups\LightLoadingSetup.luac 

require("core/lib/setups/CoreLoadingSetup")
require("lib/utils/LightLoadingScreenGuiScript")
if not LightLoadingSetup then
  LightLoadingSetup = class(CoreLoadingSetup)
end
LightLoadingSetup.init = function(l_1_0)
  l_1_0._camera = Scene:create_camera()
  LoadingViewport:set_camera(l_1_0._camera)
  l_1_0._gui_wrapper = LightLoadingScreenGuiScript:new(Scene:gui(), arg.res, -1, arg.layer, arg.is_win32)
end

LightLoadingSetup.update = function(l_2_0, l_2_1, l_2_2)
  l_2_0._gui_wrapper:update(-1, l_2_2)
end

LightLoadingSetup.destroy = function(l_3_0)
  LightLoadingSetup.super.destroy(l_3_0)
  Scene:delete_camera(l_3_0._camera)
end

if not setup then
  setup = LightLoadingSetup:new()
end
setup:make_entrypoint()

