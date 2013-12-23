-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\items\menuitemdivider.luac 

core:import("CoreMenuItem")
if not MenuItemDivider then
  MenuItemDivider = class(CoreMenuItem.Item)
end
MenuItemDivider.TYPE = "divider"
MenuItemDivider.init = function(l_1_0, l_1_1, l_1_2)
  MenuItemDivider.super.init(l_1_0, l_1_1, l_1_2)
  l_1_0._type = MenuItemDivider.TYPE
end

MenuItemDivider.setup_gui = function(l_2_0, l_2_1, l_2_2)
  local scaled_size = managers.gui_data:scaled_size()
  l_2_2.gui_panel = l_2_1.item_panel:panel({w = l_2_1.item_panel:w()})
  local h = l_2_2.item:parameters().size or 10
  if l_2_2.text then
    print("HAS TEXT", l_2_2.text)
    l_2_2.text = l_2_1._text_item_part(l_2_1, l_2_2, l_2_2.gui_panel, 0)
    local _, _, tw, th = l_2_2.text:text_rect()
    l_2_2.text:set_size(tw, th)
    h = th
  end
  l_2_2.gui_panel:set_left(l_2_1._mid_align(l_2_1))
  l_2_2.gui_panel:set_w(scaled_size.width - l_2_2.gui_panel:left())
  l_2_2.gui_panel:set_h(h)
  return true
end

MenuItemDivider.reload = function(l_3_0, l_3_1, l_3_2)
  MenuItemDivider.super.reload(l_3_0, l_3_1, l_3_2)
  l_3_0:_set_row_item_state(l_3_2, l_3_1)
  return true
end

MenuItemDivider.highlight_row_item = function(l_4_0, l_4_1, l_4_2, l_4_3)
  l_4_0:_set_row_item_state(l_4_1, l_4_2)
  return true
end

MenuItemDivider.fade_row_item = function(l_5_0, l_5_1, l_5_2, l_5_3)
  l_5_0:_set_row_item_state(l_5_1, l_5_2)
  return true
end

MenuItemDivider._set_row_item_state = function(l_6_0, l_6_1, l_6_2)
  if l_6_2.highlighted then
     -- Warning: missing end command somewhere! Added here
  end
end

MenuItemDivider.menu_unselected_visible = function(l_7_0)
  return false
end

MenuItemDivider.on_delete_row_item = function(l_8_0, l_8_1, ...)
  MenuItemDivider.super.on_delete_row_item(l_8_0, l_8_1, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end


