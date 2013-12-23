-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\states\creditsstate.luac 

require("lib/states/GameState")
if not CreditsState then
  CreditsState = class(GameState)
end
CreditsState.init = function(l_1_0, l_1_1, l_1_2)
  GameState.init(l_1_0, "menu_credits", l_1_1)
  l_1_0._setup = false
  l_1_0._active = false
end

CreditsState.set_controller_enabled = function(l_2_0, l_2_1)
  l_2_0._active = l_2_1
end

CreditsState.setup = function(l_3_0)
  l_3_0._credits_list = PackageManager:script_data(Idstring("credits"), Idstring("gamedata/credits"))
  local meta_credits = {}
  meta_credits.__index = meta_credits
  meta_credits._index = 1
  meta_credits._sub_index = 0
  meta_credits.has_next = function(l_1_0)
    return not not l_1_0[l_1_0._index]
   end
  meta_credits.get_next = function(l_2_0, l_2_1, l_2_2)
    local data = l_2_0[l_2_1]
    local name = ""
    local h = 23
    local fs = 23
    local o = 0
    if l_2_2 == 0 then
      name = data.name
      if data._meta == "header" then
        h = 125
        fs = 40
        o = 15
      else
        h = 55
        fs = 30
        o = 5
      end
    else
      name = data[l_2_2].name
    end
  end
  return {h = h, font_size = fs, offset = o, name = name}
   end
  meta_credits.step = function(l_3_0)
    if l_3_0._index == 0 then
      l_3_0._index = 1
    else
      l_3_0._sub_index = l_3_0._sub_index + 1
    end
    if #l_3_0[l_3_0._index] < l_3_0._sub_index then
      l_3_0._sub_index = 0
      l_3_0._index = l_3_0._index + 1
    end
   end
  meta_credits.next = function(l_4_0)
    local ret = l_4_0:get_next(l_4_0._index, l_4_0._sub_index)
    l_4_0:step()
    return ret
   end
  setmetatable(l_3_0._credits_list, meta_credits)
  local res = RenderSettings.resolution
  local gui = Overlay:gui()
  l_3_0._workspace = gui:create_screen_workspace()
  l_3_0._workspace:show()
  l_3_0._text_panel = l_3_0._workspace:panel():panel({h = 0, y = l_3_0._workspace:panel():h(), layer = 1})
  l_3_0:add_credit()
  l_3_0._setup = true
end

CreditsState.add_credit = function(l_4_0)
  local data = l_4_0._credits_list:next()
  local offset = data.offset
  local text_params = {h = data.h, y = l_4_0._text_panel:h(), vertical = "bottom", align = "center", font = "fonts/font_fortress_22", font_size = data.font_size, text = data.name, color = Color.white}
  local text = l_4_0._text_panel:text(text_params)
  text:set_layer(1)
  text_params.color = Color.black
  l_4_0._text_panel:text(text_params):move(-2, -2)
  l_4_0._text_panel:text(text_params):move(2, -2)
  l_4_0._text_panel:text(text_params):move(2, 2)
  l_4_0._text_panel:text(text_params):move(-2, 2)
  l_4_0._text_panel:grow(0, text:h() + offset)
end

CreditsState.at_enter = function(l_5_0, l_5_1)
  l_5_0:setup()
end

CreditsState.at_exit = function(l_6_0, l_6_1)
  l_6_0._credits_list = nil
  l_6_0._setup = false
  Overlay:gui():destroy_workspace(l_6_0._workspace)
end

CreditsState.continue = function(l_7_0)
  setup:load_start_menu()
end

CreditsState.update = function(l_8_0, l_8_1, l_8_2)
  if not l_8_0._setup or not l_8_0._active then
    return 
  end
  if alive(l_8_0._text_panel:child(0)) and l_8_0._text_panel:child(0):world_bottom() <= 0 then
    l_8_0._text_panel:remove(l_8_0._text_panel:child(0))
  end
  l_8_0._text_panel:move(0, -l_8_2 * 25 * 3.5499999523163)
   -- DECOMPILER ERROR: unhandled construct in 'if'

  if l_8_0._credits_list:has_next() and l_8_0._text_panel:bottom() < l_8_0._text_panel:parent():h() then
    l_8_0:add_credit()
    do return end
    if l_8_0._text_panel:bottom() <= 0 then
      l_8_0:continue()
    end
  end
end


