-- Decompiled using luadec 2.0.1 by sztupy (http://winmo.sztupy.hu)
-- Command line was: F:\SteamLibrary\SteamApps\common\PAYDAY 2\lua\lib\managers\menu\renderers\menunodecreditsgui.luac 

if not MenuNodeCreditsGui then
  MenuNodeCreditsGui = class(MenuNodeGui)
end
MenuNodeCreditsGui.PATH = "gamedata/"
MenuNodeCreditsGui.FILE_EXTENSION = "credits"
MenuNodeCreditsGui.init = function(l_1_0, l_1_1, l_1_2, l_1_3)
  MenuNodeCreditsGui.super.init(l_1_0, l_1_1, l_1_2, l_1_3)
  l_1_0:_build_credits_panel(l_1_1._parameters.credits_file)
end

MenuNodeCreditsGui._build_credits_panel = function(l_2_0, l_2_1)
  local lang_key = SystemInfo:language():key()
  local files = {Idstring("german"):key() = "_german", Idstring("french"):key() = "_french", Idstring("spanish"):key() = "_spanish", Idstring("italian"):key() = "_italian"}
  if Application:region() == Idstring("eu") and l_2_1 == "eula" then
    files[Idstring("english"):key()] = "_uk"
  end
   -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

end
local list = PackageManager:script_data(l_2_0.FILE_EXTENSION:id(), l_2_0.PATH .. l_2_1:id())
local ypos = 0
local safe_rect_pixels = managers.gui_data:scaled_size()
local res = RenderSettings.resolution
local global_scale = 1
local side_padding = 200
l_2_0._fullscreen_ws = managers.gui_data:create_fullscreen_16_9_workspace(managers.gui_data)
l_2_0._clipping_panel = l_2_0._fullscreen_ws:panel():panel({layer = l_2_0.layers.background})
local bg = l_2_0._clipping_panel:rect({visible = true, color = Color.black / 2, layer = l_2_0.layers.background})
bg:set_top(0)
bg:set_left(0)
bg:set_height(l_2_0._clipping_panel:height())
bg:set_width(l_2_0._clipping_panel:width())
local text_offset = l_2_0._clipping_panel:height() - 50
l_2_0._credits_panel = l_2_0._clipping_panel:panel({x = safe_rect_pixels.x + side_padding, y = text_offset, w = safe_rect_pixels.width - side_padding * 2, h = l_2_0._fullscreen_ws:panel():h()})
l_2_0._credits_panel:set_center_x(l_2_0._credits_panel:parent():w() / 2)
local text_width = l_2_0._credits_panel:width()
bg:set_width(text_width)
bg:set_size(l_2_0._clipping_panel:size())
l_2_0._clipping_panel:gradient({visible = false, x = 0, y = 0, w = l_2_0._clipping_panel:width(), h = 75 * global_scale, layer = l_2_0.layers.items + 1, orientation = "vertical", gradient_points = {}})
 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Overwrote pending register.

l_2_0._clipping_panel:gradient({visible = false, x = 0, y = l_2_0._clipping_panel:height() - 75 * global_scale, w = l_2_0._clipping_panel:width(), h = 75 * global_scale, layer = l_2_0.layers.items + 1, orientation = "vertical", gradient_points = {}})
local animate_fade_in = function(l_1_0)
  over(1, function(l_1_0)
    o:set_alpha(l_1_0)
   end)
end

bg:animate(animate_fade_in)
 -- DECOMPILER ERROR: Overwrote pending register.

 -- DECOMPILER ERROR: Overwrote pending register.

local blur = l_2_0._fullscreen_ws:panel():bitmap({texture = "guis/textures/test_blur_df", w = 0:panel():w(), h = l_2_0._fullscreen_ws:panel():h(), render_template = "VertexColorTexturedBlur3D", layer = l_2_0.layers.background - 1})
local func = function(l_2_0)
  local start_blur = 0
  over(0.60000002384186, function(l_1_0)
    o:set_alpha(math.lerp(start_blur, 1, l_1_0))
   end)
end

blur:animate(func)
local commands = {}
for _,data in ipairs(list) do
  if data._meta == "text" then
    local height = 50
    local color = Color(1, 1, 0, 0)
    if data.type == "title" then
      do return end
    end
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

    if data.type == "name" then
      do return end
    end
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

    if data.type == "fill" then
      do return end
    end
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

    if data.type == "song" then
      do return end
    end
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

    if data.type == "song-credit" then
      do return end
    end
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

    if data.type == "image-text" then
      do return end
    end
     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Overwrote pending register.

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused about usage of registers!

     -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

  end
  local text_field = l_2_0._credits_panel:text({text = data.text, x = 0, y = ypos, w = text_width, h = 0, font_size = height, align = "center", halign = "left", vertical = "bottom", font = l_2_0.font, color = color, layer = l_2_0.layers.items})
  do
    local _, _, _, h = text_field:text_rect()
    text_field:set_height(h)
  end
  for (for control),_ in (for generator) do
  end
   -- DECOMPILER ERROR: Overwrote pending register.

  if not data.scale then
    local scale = (height ~= "image" or 1) * global_scale
     -- DECOMPILER ERROR: Overwrote pending register.

  end
  do
    local bitmap = color:bitmap({layer = l_2_0.layers.items, x = 0, y = ypos, texture = data.src})
    print(res.x, bitmap:width() * scale)
    bitmap:set_width(bitmap:width() * scale)
    bitmap:set_height(bitmap:height() * scale)
    bitmap:set_center_x(l_2_0._credits_panel:width() / 2)
     -- DECOMPILER ERROR: Overwrote pending register.

  end
  for (for control),_ in (for generator) do
     -- DECOMPILER ERROR: Overwrote pending register.

    if data._meta == "br" then
      for (for control),_ in (for generator) do
      end
       -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

    end
    table.insert(commands, {pos = ypos - text_offset + (data._meta ~= "command" or 0) * global_scale + l_2_0._clipping_panel:height() / 2, cmd = data.cmd, param = data.param})
  end
  l_2_0._credits_panel:set_height(ypos + 50)
  do
    local scroll_func = function(l_3_0)
    local y = l_3_0:top()
    do
      local speed = 50 * global_scale
      repeat
        repeat
          repeat
            repeat
              repeat
                repeat
                  y = y - coroutine.yield() * speed
                  l_3_0:set_top(math.round(y))
                until commands[1]
              until y < -commands[1].pos
              do
                local cmd = table.remove(commands, 1)
                if cmd.cmd == "speed" then
                  speed = cmd.param * global_scale
                elseif cmd.cmd == "close" then
                  managers.menu:back()
                  return 
              until cmd.cmd == "stop"
              else
                return 
              end
              do return end
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
     -- DECOMPILER ERROR: Attempted to generate an assignment, but got confused about usage of registers

  end
   -- DECOMPILER ERROR: Attempted to generate an assignment, but got confused about usage of registers

end

MenuNodeCreditsGui._setup_panels = function(l_3_0, l_3_1)
  MenuNodeCreditsGui.super._setup_panels(l_3_0, l_3_1)
end

MenuNodeCreditsGui._create_menu_item = function(l_4_0, l_4_1)
  MenuNodeCreditsGui.super._create_menu_item(l_4_0, l_4_1)
end

MenuNodeCreditsGui._setup_item_panel_parent = function(l_5_0, l_5_1)
  MenuNodeCreditsGui.super._setup_item_panel_parent(l_5_0, l_5_1)
end

MenuNodeCreditsGui._setup_item_panel = function(l_6_0, l_6_1, l_6_2)
  MenuNodeCreditsGui.super._setup_item_panel(l_6_0, l_6_1, l_6_2)
end

MenuNodeCreditsGui.resolution_changed = function(l_7_0)
  MenuNodeCreditsGui.super.resolution_changed(l_7_0)
end

MenuNodeCreditsGui.set_visible = function(l_8_0, l_8_1)
  MenuNodeCreditsGui.super.set_visible(l_8_0, l_8_1)
  if l_8_1 then
    l_8_0._fullscreen_ws:show()
  else
    l_8_0._fullscreen_ws:hide()
  end
end

MenuNodeCreditsGui.close = function(l_9_0, ...)
  l_9_0._credits_panel:stop(l_9_0._credits_panel_thread)
  Overlay:gui():destroy_workspace(l_9_0._fullscreen_ws)
  MenuNodeCreditsGui.super.close(l_9_0, ...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end


