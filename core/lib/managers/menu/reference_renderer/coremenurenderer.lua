-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\core\lib\managers\menu\reference_renderer\coremenurenderer.luac 

core:module("CoreMenuRenderer")
core:import("CoreMenuNodeGui")
if not Renderer then
  Renderer = class()
end
Renderer.border_height = 44
Renderer.preload = function(l_1_0)
end

Renderer.init = function(l_2_0, l_2_1, l_2_2)
  if not l_2_2 then
    l_2_2 = {}
  end
  l_2_0._logic = l_2_1
  l_2_0._logic:register_callback("renderer_show_node", callback(l_2_0, l_2_0, "show_node"))
  l_2_0._logic:register_callback("renderer_refresh_node", callback(l_2_0, l_2_0, "refresh_node"))
  l_2_0._logic:register_callback("renderer_select_item", callback(l_2_0, l_2_0, "highlight_item"))
  l_2_0._logic:register_callback("renderer_deselect_item", callback(l_2_0, l_2_0, "fade_item"))
  l_2_0._logic:register_callback("renderer_trigger_item", callback(l_2_0, l_2_0, "trigger_item"))
  l_2_0._logic:register_callback("renderer_navigate_back", callback(l_2_0, l_2_0, "navigate_back"))
  l_2_0._logic:register_callback("renderer_node_item_dirty", callback(l_2_0, l_2_0, "node_item_dirty"))
  l_2_0._timer = 0
  l_2_0._base_layer = l_2_2.layer or 200
  l_2_0.ws = managers.gui_data:create_saferect_workspace()
  l_2_0._fullscreen_ws = managers.gui_data:create_fullscreen_workspace()
  l_2_0._fullscreen_panel = l_2_0._fullscreen_ws:panel():panel({halign = "scale", valign = "scale", layer = l_2_0._base_layer})
  l_2_0._fullscreen_ws:hide()
  local safe_rect_pixels = managers.viewport:get_safe_rect_pixels()
  l_2_0._main_panel = l_2_0.ws:panel():panel({layer = l_2_0._base_layer})
  l_2_0.safe_rect_panel = l_2_0.ws:panel():panel({w = safe_rect_pixels.width, h = safe_rect_pixels.height, layer = l_2_0._base_layer})
end

Renderer._scaled_size = function(l_3_0)
  return managers.gui_data:scaled_size()
end

Renderer.open = function(l_4_0, ...)
  managers.gui_data:layout_workspace(l_4_0.ws)
  managers.gui_data:layout_fullscreen_workspace(l_4_0._fullscreen_ws)
  l_4_0:_layout_main_panel()
  l_4_0._resolution_changed_callback_id = managers.viewport:add_resolution_changed_func(callback(l_4_0, l_4_0, "resolution_changed"))
  l_4_0._node_gui_stack = {}
  l_4_0._open = true
  l_4_0._fullscreen_ws:show()
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

Renderer.is_open = function(l_5_0)
  return l_5_0._open
end

Renderer.show_node = function(l_6_0, l_6_1, l_6_2)
  local layer = l_6_0._base_layer
  local previous_node_gui = l_6_0:active_node_gui()
  if Application:production_build() then
    if Global.render_debug.menu_debug then
      previous_node_gui.safe_rect_panel:set_debug(not previous_node_gui or false)
    end
    previous_node_gui._item_panel_parent:set_debug(not Global.render_debug.menu_debug or false)
  end
  layer = previous_node_gui:layer()
  previous_node_gui:set_visible(false)
  local new_node_gui = nil
  if l_6_2.node_gui_class then
    new_node_gui = l_6_2.node_gui_class:new(l_6_1, layer + 1, l_6_2)
  else
    new_node_gui = CoreMenuNodeGui.NodeGui:new(l_6_1, layer + 1, l_6_2)
  end
  if Global.render_debug.menu_debug then
    new_node_gui.safe_rect_panel:set_debug(not Application:production_build() or true)
  end
  new_node_gui._item_panel_parent:set_debug(not Global.render_debug.menu_debug or true)
  table.insert(l_6_0._node_gui_stack, new_node_gui)
  if not managers.system_menu:is_active() then
    l_6_0:disable_input(0.20000000298023)
  end
end

Renderer.refresh_node = function(l_7_0, l_7_1, l_7_2)
  local layer = l_7_0._base_layer
  local node_gui = l_7_0:active_node_gui()
  node_gui:refresh_gui(l_7_1, l_7_2)
end

Renderer.highlight_item = function(l_8_0, l_8_1, l_8_2)
  local active_node_gui = l_8_0:active_node_gui()
  if active_node_gui then
    active_node_gui:highlight_item(l_8_1, l_8_2)
  end
end

Renderer.fade_item = function(l_9_0, l_9_1)
  local active_node_gui = l_9_0:active_node_gui()
  if active_node_gui then
    active_node_gui:fade_item(l_9_1)
  end
end

Renderer.trigger_item = function(l_10_0, l_10_1)
  local node_gui = l_10_0:active_node_gui()
  if node_gui then
    node_gui:reload_item(l_10_1)
  end
end

Renderer.navigate_back = function(l_11_0)
  local active_node_gui = l_11_0:active_node_gui()
  if active_node_gui then
    active_node_gui:close()
    table.remove(l_11_0._node_gui_stack, #l_11_0._node_gui_stack)
    l_11_0:active_node_gui():set_visible(true)
    if Global.render_debug.menu_debug then
      l_11_0:active_node_gui().safe_rect_panel:set_debug(not Application:production_build() or true)
    end
    l_11_0:active_node_gui()._item_panel_parent:set_debug(not Global.render_debug.menu_debug or true)
    l_11_0:disable_input(0.20000000298023)
  end
end

Renderer.node_item_dirty = function(l_12_0, l_12_1, l_12_2)
  local node_name = l_12_1:parameters().name
  for _,gui in pairs(l_12_0._node_gui_stack) do
    if gui.name == node_name then
      gui:reload_item(l_12_2)
    end
  end
end

Renderer.update = function(l_13_0, l_13_1, l_13_2)
  l_13_0:update_input_timer(l_13_2)
  for _,node_gui in ipairs(l_13_0._node_gui_stack) do
    node_gui:update(l_13_1, l_13_2)
  end
end

Renderer.update_input_timer = function(l_14_0, l_14_1)
  if l_14_0._timer > 0 then
    l_14_0._timer = l_14_0._timer - l_14_1
    if l_14_0._timer <= 0 then
      l_14_0._logic:accept_input(true)
    end
  end
end

Renderer.active_node_gui = function(l_15_0)
  return l_15_0._node_gui_stack[#l_15_0._node_gui_stack]
end

Renderer.disable_input = function(l_16_0, l_16_1)
  l_16_0._timer = l_16_1
  l_16_0._logic:accept_input(false)
end

Renderer.close = function(l_17_0)
  l_17_0._fullscreen_ws:hide()
  l_17_0._open = false
  if l_17_0._resolution_changed_callback_id then
    managers.viewport:remove_resolution_changed_func(l_17_0._resolution_changed_callback_id)
  end
  for _,node_gui in ipairs(l_17_0._node_gui_stack) do
    node_gui:close()
  end
  l_17_0._main_panel:clear()
  l_17_0._fullscreen_panel:clear()
  l_17_0.safe_rect_panel:clear()
  l_17_0._node_gui_stack = {}
  l_17_0._logic:renderer_closed()
end

Renderer.hide = function(l_18_0)
  local active_node_gui = l_18_0:active_node_gui()
  if active_node_gui then
    active_node_gui:set_visible(false)
  end
end

Renderer.show = function(l_19_0)
  local active_node_gui = l_19_0:active_node_gui()
  if active_node_gui then
    active_node_gui:set_visible(true)
  end
end

Renderer._layout_main_panel = function(l_20_0)
  local scaled_size = l_20_0:_scaled_size()
  l_20_0._main_panel:set_shape(0, 0, scaled_size.width, scaled_size.height)
  local safe_rect = l_20_0:_scaled_size()
  l_20_0.safe_rect_panel:set_shape(safe_rect.x, safe_rect.y, safe_rect.width, safe_rect.height)
end

Renderer.resolution_changed = function(l_21_0)
  local res = RenderSettings.resolution
  managers.gui_data:layout_workspace(l_21_0.ws)
  managers.gui_data:layout_fullscreen_workspace(l_21_0._fullscreen_ws)
  l_21_0:_layout_main_panel()
  for _,node_gui in ipairs(l_21_0._node_gui_stack) do
    node_gui:resolution_changed()
  end
end


