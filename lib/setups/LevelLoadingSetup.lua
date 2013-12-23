-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\setups\LevelLoadingSetup.luac 

require("core/lib/setups/CoreLoadingSetup")
require("lib/utils/LevelLoadingScreenGuiScript")
require("lib/managers/menu/MenuBackdropGUI")
require("core/lib/managers/CoreGuiDataManager")
require("core/lib/utils/CoreMath")
require("core/lib/utils/CoreEvent")
if not LevelLoadingSetup then
  LevelLoadingSetup = class(CoreLoadingSetup)
end
LevelLoadingSetup.init = function(l_1_0)
  l_1_0._camera = Scene:create_camera()
  LoadingViewport:set_camera(l_1_0._camera)
  l_1_0._gui_wrapper = LevelLoadingScreenGuiScript:new(Scene:gui(), arg.res, -1, arg.layer)
end

LevelLoadingSetup.update = function(l_2_0, l_2_1, l_2_2)
  l_2_0._gui_wrapper:update(-1, l_2_1, l_2_2)
end

LevelLoadingSetup.destroy = function(l_3_0)
  LevelLoadingSetup.super.destroy(l_3_0)
  Scene:delete_camera(l_3_0._camera)
end

if not setup then
  setup = LevelLoadingSetup:new()
end
setup:make_entrypoint()

