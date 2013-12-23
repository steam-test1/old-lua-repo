-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\walletguiobject.luac 

if not WalletGuiObject then
  WalletGuiObject = class()
end
WalletGuiObject.init = function(l_1_0, l_1_1)
  WalletGuiObject.set_wallet(l_1_1)
end

WalletGuiObject.set_wallet = function(l_2_0, l_2_1)
  WalletGuiObject.remove_wallet()
  Global.wallet_panel = l_2_0:panel({name = "WalletGuiObject", layer = l_2_1 or 0})
  local money_icon = Global.wallet_panel:bitmap({name = "wallet_money_icon", texture = "guis/textures/pd2/shared_wallet_symbol"})
  local level_icon = Global.wallet_panel:bitmap({name = "wallet_level_icon", texture = "guis/textures/pd2/shared_level_symbol"})
  local skillpoint_icon = Global.wallet_panel:bitmap({name = "wallet_skillpoint_icon", texture = "guis/textures/pd2/shared_skillpoint_symbol"})
  local money_text = Global.wallet_panel:text({name = "wallet_money_text", text = managers.money:total_string_no_currency(), font_size = tweak_data.menu.pd2_small_font_size, font = tweak_data.menu.pd2_small_font, color = tweak_data.screen_colors.text})
  local level_text = Global.wallet_panel:text({name = "wallet_level_text", text = tostring(managers.experience:current_level()), font_size = tweak_data.menu.pd2_small_font_size, font = tweak_data.menu.pd2_small_font, color = tweak_data.screen_colors.text})
  local skillpoint_text = Global.wallet_panel:text({name = "wallet_skillpoint_text", text = tostring(managers.skilltree:points()), font_size = tweak_data.menu.pd2_small_font_size, font = tweak_data.menu.pd2_small_font, color = tweak_data.screen_colors.text})
  money_icon:set_leftbottom(2, Global.wallet_panel:h() - 2)
  level_icon:set_leftbottom(2, money_icon:top() - 2)
  skillpoint_icon:set_leftbottom(2, level_icon:top() - 2)
  local mw, mh = WalletGuiObject.make_fine_text(money_text)
  local lw, lh = WalletGuiObject.make_fine_text(level_text)
  local sw, sh = WalletGuiObject.make_fine_text(skillpoint_text)
  money_text:set_left(money_icon:right() + 2)
  money_text:set_center_y(money_icon:center_y())
  money_text:set_y(math.round(money_text:y()))
  level_text:set_left(level_icon:right() + 2)
  level_text:set_center_y(level_icon:center_y())
  level_text:set_y(math.round(level_text:y()))
  skillpoint_text:set_left(skillpoint_icon:right() + 2)
  skillpoint_text:set_center_y(skillpoint_icon:center_y())
  skillpoint_text:set_y(math.round(skillpoint_text:y()))
  local max_w = math.max(mw, lw, sw)
  local bg_blur = Global.wallet_panel:bitmap({name = "bg_blur", texture = "guis/textures/test_blur_df", w = 0, h = 0, render_template = "VertexColorTexturedBlur3D", layer = -1})
  bg_blur:set_leftbottom(money_icon:leftbottom())
  bg_blur:set_w(max_w + money_icon:w() + 2)
  bg_blur:set_h(Global.wallet_panel:h() - skillpoint_icon:top())
  WalletGuiObject.set_object_visible("wallet_skillpoint_icon", managers.skilltree:points() > 0)
  WalletGuiObject.set_object_visible("wallet_skillpoint_text", managers.skilltree:points() > 0)
end

WalletGuiObject.refresh = function()
  if Global.wallet_panel then
    local money_icon = Global.wallet_panel:child("wallet_money_icon")
    local level_icon = Global.wallet_panel:child("wallet_level_icon")
    local skillpoint_icon = Global.wallet_panel:child("wallet_skillpoint_icon")
    local money_text = Global.wallet_panel:child("wallet_money_text")
    local level_text = Global.wallet_panel:child("wallet_level_text")
    local skillpoint_text = Global.wallet_panel:child("wallet_skillpoint_text")
    money_text:set_text(managers.money:total_string_no_currency())
    WalletGuiObject.make_fine_text(money_text)
    money_text:set_left(money_icon:right() + 2)
    money_text:set_center_y(money_icon:center_y())
    money_text:set_y(math.round(money_text:y()))
    level_text:set_text(tostring(managers.experience:current_level()))
    WalletGuiObject.make_fine_text(level_text)
    level_text:set_left(level_icon:right() + 2)
    level_text:set_center_y(level_icon:center_y())
    level_text:set_y(math.round(level_text:y()))
    skillpoint_text:set_text(tostring(managers.skilltree:points()))
    WalletGuiObject.make_fine_text(skillpoint_text)
    skillpoint_text:set_left(skillpoint_icon:right() + 2)
    skillpoint_text:set_center_y(skillpoint_icon:center_y())
    skillpoint_text:set_y(math.round(skillpoint_text:y()))
  end
end

WalletGuiObject.make_fine_text = function(l_4_0)
  local x, y, w, h = l_4_0:text_rect()
  l_4_0:set_size(w, h)
  l_4_0:set_position(math.round(l_4_0:x()), math.round(l_4_0:y()))
  return w, h
end

WalletGuiObject.set_layer = function(l_5_0)
  if not alive(Global.wallet_panel) then
    return 
  end
  Global.wallet_panel:set_layer(l_5_0)
end

WalletGuiObject.move_wallet = function(l_6_0, l_6_1)
  if not alive(Global.wallet_panel) then
    return 
  end
  Global.wallet_panel:move(l_6_0, l_6_1)
end

WalletGuiObject.set_object_visible = function(l_7_0, l_7_1)
  if not alive(Global.wallet_panel) then
    return 
  end
  Global.wallet_panel:child(l_7_0):set_visible(l_7_1)
  local bg_blur = Global.wallet_panel:child("bg_blur")
  if Global.wallet_panel:child("wallet_skillpoint_icon"):visible() then
    bg_blur:set_h(Global.wallet_panel:h() - Global.wallet_panel:child("wallet_skillpoint_icon"):top())
  else
    if Global.wallet_panel:child("wallet_level_icon"):visible() then
      bg_blur:set_h(Global.wallet_panel:h() - Global.wallet_panel:child("wallet_level_icon"):top())
    else
      if Global.wallet_panel:child("wallet_money_icon"):visible() then
        bg_blur:set_h(Global.wallet_panel:h() - Global.wallet_panel:child("wallet_money_icon"):top())
      else
        bg_blur:set_h(0)
      end
    end
  end
  bg_blur:set_leftbottom(Global.wallet_panel:child("wallet_money_icon"):leftbottom())
end

WalletGuiObject.remove_wallet = function()
  if not alive(Global.wallet_panel) or not alive(Global.wallet_panel:parent()) then
    Global.wallet_panel = nil
    return 
  end
  Global.wallet_panel:parent():remove(Global.wallet_panel)
  Global.wallet_panel = nil
end

WalletGuiObject.close_wallet = function(l_9_0)
  if not alive(Global.wallet_panel) or not alive(Global.wallet_panel:parent()) then
    Global.wallet_panel = nil
    return 
  end
  if l_9_0 ~= Global.wallet_panel:parent() then
    return 
  end
  l_9_0:remove(Global.wallet_panel)
  Global.wallet_panel = nil
end


