-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\controllermanager.luac 

core:module("ControllerManager")
core:import("CoreControllerManager")
core:import("CoreClass")
if not ControllerManager then
  ControllerManager = class(CoreControllerManager.ControllerManager)
end
ControllerManager.init = function(l_1_0, l_1_1, l_1_2)
  l_1_2 = "settings/controller_settings"
  l_1_1 = l_1_2
  ControllerManager.super.init(l_1_0, l_1_1, l_1_2)
end

ControllerManager.controller_mod_changed = function(l_2_0)
  if not Global.controller_manager.user_mod then
    Global.controller_manager.user_mod = managers.user:get_setting("controller_mod")
    l_2_0:load_user_mod()
  end
end

ControllerManager.set_user_mod = function(l_3_0, l_3_1, l_3_2)
  if not Global.controller_manager.user_mod then
    Global.controller_manager.user_mod = {}
  end
  if l_3_2.axis then
    if not Global.controller_manager.user_mod[l_3_1] then
      Global.controller_manager.user_mod[l_3_1] = {axis = l_3_2.axis}
    end
    Global.controller_manager.user_mod[l_3_1][l_3_2.button] = l_3_2
  else
    Global.controller_manager.user_mod[l_3_1] = l_3_2
  end
  managers.user:set_setting("controller_mod_type", managers.controller:get_default_wrapper_type())
  managers.user:set_setting("controller_mod", Global.controller_manager.user_mod, true)
end

ControllerManager.clear_user_mod = function(l_4_0)
  Global.controller_manager.user_mod = {}
  managers.user:set_setting("controller_mod_type", managers.controller:get_default_wrapper_type())
  managers.user:set_setting("controller_mod", Global.controller_manager.user_mod, true)
end

ControllerManager.load_user_mod = function(l_5_0)
  if Global.controller_manager.user_mod then
    local connections = managers.controller:get_settings(managers.user:get_setting("controller_mod_type")):get_connection_map()
    for connection_name,params in pairs(Global.controller_manager.user_mod) do
      if params.axis then
        for button,button_params in pairs(params) do
          if type(button_params) == "table" then
            connections[params.axis]._btn_connections[button_params.button].name = button_params.connection
          end
        end
        for (for control),connection_name in (for generator) do
        end
        if connections[params.button] then
          connections[params.button]:set_controller_id(params.controller_id)
          connections[params.button]:set_input_name_list({params.connection})
        end
      end
      l_5_0:rebind_connections()
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ControllerManager.init_finalize = function(l_6_0)
  managers.user:add_setting_changed_callback("controller_mod", callback(l_6_0, l_6_0, "controller_mod_changed"), true)
  if Global.controller_manager.user_mod then
    l_6_0:load_user_mod()
  end
  l_6_0:_check_dialog()
end

ControllerManager.default_controller_connect_change = function(l_7_0, l_7_1)
  ControllerManager.super.default_controller_connect_change(l_7_0, l_7_1)
  if Global.controller_manager.default_wrapper_index and not l_7_1 and not l_7_0:_controller_changed_dialog_active() then
    l_7_0:_show_controller_changed_dialog()
  end
end

ControllerManager._check_dialog = function(l_8_0)
  if Global.controller_manager.connect_controller_dialog_visible and not l_8_0:_controller_changed_dialog_active() then
    l_8_0:_show_controller_changed_dialog()
  end
end

ControllerManager._controller_changed_dialog_active = function(l_9_0)
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
return true
end

ControllerManager._show_controller_changed_dialog = function(l_10_0)
  if l_10_0:_controller_changed_dialog_active() then
    return 
  end
  Global.controller_manager.connect_controller_dialog_visible = true
  local data = {}
  data.callback_func = callback(l_10_0, l_10_0, "connect_controller_dialog_callback")
  data.title = managers.localization:text("dialog_connect_controller_title")
  data.text = managers.localization:text("dialog_connect_controller_text", {NR = Global.controller_manager.default_wrapper_index or 1})
  data.button_list = {{text = managers.localization:text("dialog_ok")}}
  data.id = "connect_controller_dialog"
  data.force = true
  managers.system_menu:show(data)
end

ControllerManager._close_controller_changed_dialog = function(l_11_0)
  if Global.controller_manager.connect_controller_dialog_visible or l_11_0:_controller_changed_dialog_active() then
    managers.system_menu:close("connect_controller_dialog")
    l_11_0:connect_controller_dialog_callback()
  end
end

ControllerManager.connect_controller_dialog_callback = function(l_12_0)
  Global.controller_manager.connect_controller_dialog_visible = nil
end

CoreClass.override_class(CoreControllerManager.ControllerManager, ControllerManager)

