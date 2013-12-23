-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\system\coresystem.luac 

require("core/lib/system/CorePatchLua")
require("core/lib/system/CorePatchEngine")
require("core/lib/system/CoreModule")
require("core/lib/system/CoreModules")
core:import("CoreExtendLua")
core:import("CoreEngineAccess")
if not managers then
  managers = {}
end
core:_add_to_pristine_and_global("managers", managers)
core:_copy_module_to_global("CoreClass")
core:_copy_module_to_global("CoreCode")
core:_copy_module_to_global("CoreDebug")
core:_copy_module_to_global("CoreEvent")
core:_copy_module_to_global("CoreEws")
core:_copy_module_to_global("CoreInput")
core:_copy_module_to_global("CoreMath")
core:_copy_module_to_global("CoreOldModule")
core:_copy_module_to_global("CoreString")
core:_copy_module_to_global("CoreTable")
core:_copy_module_to_global("CoreUnit")
core:_copy_module_to_global("CoreXml")
core:_copy_module_to_global("CoreApp")
core:_close_pristine_namespace()

