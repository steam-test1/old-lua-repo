TextBoxGui = TextBoxGui or class()

TextBoxGui.PRESETS = {}
TextBoxGui.PRESETS.system_menu = { w = 540, h = 260 }
TextBoxGui.PRESETS.weapon_stats = { w = 700, h = 260, x = 60, bottom = 620 }

function TextBoxGui:init( ... )
	self._target_alpha = {}
	self._visible = true
	self._enabled = true
	self._minimized = false
	self:_create_text_box( ... )
	self:_check_scroll_indicator_states()
	self._thread = self._panel:animate( self._update, self ) 
end

function TextBoxGui._update( o, self )
	-- local t = 2
  	while true do
  		local dt = coroutine.yield()
  		-- t = t - dt
  		-- print( "update" )
  		if self._up_alpha then
  			self._up_alpha.current = math.step( self._up_alpha.current, self._up_alpha.target, dt*5 )
  			self._text_box:child( "scroll_up_indicator_shade" ):set_color( self._text_box:child( "scroll_up_indicator_shade" ):color():with_alpha( self._up_alpha.current ) )
			self._text_box:child( "scroll_up_indicator_arrow" ):set_color( self._text_box:child( "scroll_up_indicator_arrow" ):color():with_alpha( self._up_alpha.current ) )
  		end
  		if self._down_alpha then
  			self._down_alpha.current = math.step( self._down_alpha.current, self._down_alpha.target, dt*5 )
  			self._text_box:child( "scroll_down_indicator_shade" ):set_color( self._text_box:child( "scroll_down_indicator_shade" ):color():with_alpha( self._down_alpha.current ) )
			self._text_box:child( "scroll_down_indicator_arrow" ):set_color( self._text_box:child( "scroll_down_indicator_arrow" ):color():with_alpha( self._down_alpha.current ) )
  		end
  		
  	end
  	-- o:set_color( o:color():with_alpha( 0 ) )
end

function TextBoxGui:set_layer( layer )
	-- self._ws:panel():set_layer( layer )
	self._panel:set_layer( self._init_layer + layer )
	if self._background then
		self._background:set_layer( self._panel:layer() - 1 )
	end
	if self._background2 then
		self._background2:set_layer( self._panel:layer() - 1 )
	end
end

function TextBoxGui:layer()
	return self._panel:layer() 
end

function TextBoxGui:add_background()


	if alive( self._fullscreen_ws ) then
		Overlay:gui():destroy_workspace( self._fullscreen_ws )
		self._fullscreen_ws = nil
	end

	self._fullscreen_ws = Overlay:gui():create_screen_workspace()
	self._background = self._fullscreen_ws:panel():bitmap( { name = "bg", texture = "guis/textures/test_blur_df", color = Color.white, alpha=0, layer=0, render_template="VertexColorTexturedBlur3D", w=self._fullscreen_ws:panel():w(), h=self._fullscreen_ws:panel():h(), valign = "grow" } )
	self._background2 = self._fullscreen_ws:panel():rect( { name = "bg", color = Color.black, alpha=0, layer=0, blend_mode="normal", halign = "grow", valign = "grow" } )
	
	-- self._background:set_render_template( Idstring( "gaussian_blur" ) )
	-- <rect name_s="bg" color="Color.black:with_alpha(0.5)" layer="0"/>
end

function TextBoxGui:set_centered()
	self._panel:set_center( self._ws:panel():center() )
end

function TextBoxGui:recreate_text_box( ... )
	self:close()
	self:_create_text_box( ... )
	self:_check_scroll_indicator_states()
	self._thread = self._panel:animate( self._update, self )
end

--[[function TextBoxGui:_init_create( ws, title, text, content_data, config )
	self._ws = ws
	if self._text_box then
		ws:panel():remove( self._text_box )
	end
	
	local scaled_size = managers.gui_data:scaled_size()
	
	local w = preset and preset.w or config and config.w or scaled_size.width/2.25
	local h = preset and preset.h or config and config.h or scaled_size.height/2
	local x = preset and preset.x or config and config.x or 0
	local y = preset and preset.y or config and config.y or 0
	local bottom = preset and preset.bottom or config and config.bottom
	
	local main = ws:panel():panel( { x = x, y = y, w = w, h = h, layer = 1 } )
	self._panel = main
	self._panel_h = self._panel:h()
	self._panel_w = self._panel:w()
	if bottom then
		main:set_bottom( bottom )
	else
		main:set_center_y( scaled_size.height/2 )
	end
end]]

function TextBoxGui:_create_text_box( ws, title, text, content_data, config )
	self._ws = ws
	self._init_layer = self._ws:panel():layer()
	if alive( self._text_box ) then
		ws:panel():remove( self._text_box )
		self._text_box = nil
	end
	if self._info_box then
		self._info_box:close()
		self._info_box = nil
	end
	self._text_box_focus_button = nil
	
	local scaled_size = managers.gui_data:scaled_size()
	
	local type 			= config and config.type
	local preset		= type and self.PRESETS[ type ]
	
	local stats_list 	= content_data and content_data.stats_list
	local stats_text 	= content_data and content_data.stats_text
	local button_list 	= content_data and content_data.button_list
	local focus_button 	= content_data and content_data.focus_button
	
	local use_indicator 	= config and config.use_indicator or false
	local no_close_legend 	= config and config.no_close_legend
	local no_scroll_legend	= config and config.no_scroll_legend
	self._no_scroll_legend = no_scroll_legend
	local only_buttons		= config and config.only_buttons
	local use_minimize_legend 	= config and config.use_minimize_legend or false
	local w = preset and preset.w or config and config.w or scaled_size.width/2.25
	local h = preset and preset.h or config and config.h or scaled_size.height/2
	local x = preset and preset.x or config and config.x or 0
	local y = preset and preset.y or config and config.y or 0
	local bottom = preset and preset.bottom or config and config.bottom
	
	local use_text_formating = preset and preset.use_text_formating or config and config.use_text_formating or false
	local text_formating_color = preset and preset.text_formating_color or config and config.text_formating_color or Color.white
	local text_formating_color_table = preset and preset.text_formating_color_table or config and config.text_formating_color_table or nil

	local is_title_outside = preset and preset.is_title_outside or config and config.is_title_outside or false

	local text_blend_mode = preset and preset.text_blend_mode or config and config.text_blend_mode or "normal"
	
	self._allow_moving = config and config.allow_moving or false
			
	local preset_or_config_y = (y ~= 0)
			
	if title then
		title = utf8.to_upper( title )
	end
	if text then
		text = text -- or "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla diam dolor, rutrum ut consequat id, feugiat sit amet turpis. Suspendisse dui orci, cursus et varius nec, ultricies a neque. Sed facilisis lobortis lectus, sed lacinia erat aliquam commodo. Donec eget metus sed arcu bibendum sodales. Aenean nulla turpis, dictum ornare dignissim sit amet, porta non justo. Nullam id orci odio. Aliquam vel ante neque, rutrum porta tortor. Sed ac felis lectus, cursus aliquam lacus. Fusce eu aliquam elit. Nullam quis nunc eget mi malesuada bibendum in nec nulla. Morbi feugiat arcu vel magna bibendum luctus.\n\nNunc vel diam vel neque sodales gravida et ac quam. Phasellus egestas, arcu in tristique mattis, velit nisi tincidunt lorem, bibendum molestie nunc purus id turpis. Donec sagittis nibh in eros ultrices aliquam. Vestibulum ante mauris, mattis quis commodo a, dictum eget sapien. Maecenas eu diam lorem. Nunc dolor metus, varius sit amet rhoncus vel, iaculis sed massa. Morbi tempus mi quis dolor posuere eu commodo magna eleifend. Pellentesque sit amet mattis nunc. Nunc lectus quam, pretium sit amet consequat sed, vestibulum vitae lorem. Sed bibendum egestas turpis, sit amet viverra risus viverra in. Suspendisse aliquam dapibus urna, posuere fermentum tellus vulputate vitae.\n\nAliquam scelerisque ante nec enim dictum in consectetur elit laoreet. Praesent in libero at quam egestas ultricies in at lacus. Donec sit amet magna eget urna luctus auctor et ut nunc. Quisque bibendum feugiat magna in mollis. Suspendisse elit augue, venenatis ut dapibus quis, lobortis nec mauris. Phasellus ipsum metus, ullamcorper sit amet molestie in, volutpat at orci. Donec nec laoreet risus. Mauris vel euismod ligula. Ut quis fringilla arcu. Curabitur blandit dolor porttitor mi euismod id venenatis orci aliquet. Cras sed odio lectus, quis euismod velit. Pellentesque nec posuere massa. In fringilla elit sit amet ligula lacinia at volutpat urna euismod."
	end
	
	local main = ws:panel():panel( { visible = self._visible, x = x, y = y, w = w, h = h, layer = self._init_layer, valign = "center" } )
	self._panel = main
	self._panel_h = self._panel:h()
	self._panel_w = self._panel:w()
	
	local title_text = main:text( { name = "title", text = title or "none", layer = 1, wrap = false, word_wrap = false, visible = title and true or false,
										-- font = tweak_data.menu.small_font, font_size = tweak_data.menu.small_font_size,
										font = tweak_data.menu.pd2_large_font, font_size = 28,
										align="left", halign="left", vertical="center", valign="top", x = 10, y = 10 } )
	
	
	local _,_,tw,th = title_text:text_rect()
	
	th = th + 10
	title_text:set_size( tw, th )
	
	if is_title_outside then
		th = 0
	end
	
	self._indicator = main:bitmap( { name = "indicator", texture = "guis/textures/icon_loading", visible = use_indicator, layer = 1 } )
	self._indicator:set_right( main:w() ) 
		
	local top_line = main:bitmap( { name = "top_line", texture = "guis/textures/headershadow", layer = 0, color = Color.white, w = main:w(), y = 0 } )
	top_line:set_bottom( th ) -- title_text:bottom() )
	local bottom_line = main:bitmap( { name = "bottom_line", texture = "guis/textures/headershadow", rotation = 180, layer = 0, color = Color.white, w = main:w(), y = 100 } )
	bottom_line:set_top( main:h() - th )
	
			top_line:hide()
			bottom_line:hide()
	
	local lower_static_panel = main:panel( { name="lower_static_panel", x = 0, y = 0, w = main:w(), h = 0, layer = 0 } )
	self:_create_lower_static_panel( lower_static_panel )
	
	
	local info_area = main:panel( { name="info_area", x = 0, y = 0, w = main:w(), h = main:h() - th*2, layer = 0 } )
	local info_bg = info_area:rect( { name="info_bg", layer=0, color=Color(0, 0, 0), alpha=0.6, halign="grow", valign="grow" } ) -- info_area:bitmap( { name="info_bg", texture = "guis/textures/textboxbg", layer = 0, color = Color.white, w = info_area:w(), h = info_area:h() } )
	-- local info_bg = info_area:rect( { color = Color( math.rand( 1 ),math.rand( 1 ),1 ), w = info_area:w(), h = info_area:h() } )
	
	-- Setup buttons panel	
	
	local buttons_panel = self:_setup_buttons_panel( info_area, button_list, focus_button, only_buttons )
	local scroll_panel = info_area:panel( { name = "scroll_panel", x = 10, y = math.round( th + 5 ), w = info_area:w() - 20, h = info_area:h(), layer = 1 } )
	
	-- Setup stats panel
	local has_stats = stats_list and #stats_list > 0
	local stats_panel = self:_setup_stats_panel( scroll_panel, stats_list, stats_text )
	-- Text
	local text = scroll_panel:text( { name = "text", text = text or "none", layer = 1, wrap = true, word_wrap = true, visible = text and true or false,
									w = scroll_panel:w() - math.round( stats_panel:w() ) - (has_stats and 20 or 0), x = math.round( stats_panel:w() ) + (has_stats and 20 or 0),
									font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size,
									align="left", halign="left", vertical="top", valign="top", blend_mode=text_blend_mode } )
	
	if use_text_formating then
		local text_string = text:text()
		local text_dissected = utf8.characters( text_string )
		local idsp = Idstring("#")

		local start_ci = {}
		local end_ci = {}
		local first_ci = true
		for i, c in ipairs( text_dissected ) do
			if Idstring( c ) == idsp then
				local next_c = text_dissected[ i + 1 ]

				if next_c and Idstring( next_c ) == idsp then
					if first_ci then
						table.insert( start_ci, i )
					else
						table.insert( end_ci, i )
					end
					first_ci = not first_ci
				end
			end
		end

		if #start_ci ~= #end_ci then
		else
			for i = 1, #start_ci do
				start_ci[ i ] = start_ci[ i ] - ( ( i - 1 ) * 4 + 1 )
				end_ci[ i ] = end_ci[ i ] - ( i * 4 - 1 )
			end
		end
		text_string = string.gsub( text_string, "##", "" )

		text:set_text( text_string )
		text:clear_range_color( 1, utf8.len( text_string ) )

		if #start_ci ~= #end_ci then
			Application:error( "TextBoxGui: Not even amount of ##'s in skill description string!", #start_ci, #end_ci )
		else
			for i = 1, #start_ci do
				text:set_range_color( start_ci[ i ], end_ci[ i ], text_formating_color_table and text_formating_color_table[ i ] or text_formating_color )
			end
		end
	end

	local _,_,ttw,tth = text:text_rect()
	text:set_h( tth )
	

	scroll_panel:set_h( math.min( h - th, tth ) )

	info_area:set_h( scroll_panel:bottom() + buttons_panel:h() + 10 + 5 )
	buttons_panel:set_bottom( info_area:h() - 10 )

	top_line:set_world_bottom( scroll_panel:world_top() )
	bottom_line:set_world_top( scroll_panel:world_bottom() )
	
	if not preset_or_config_y then
		main:set_h( info_area:h() )
		if bottom then
			main:set_bottom( bottom )
		elseif y == 0 then 
			main:set_center_y( main:parent():h()/2 )
		end
	end
	
	lower_static_panel:set_bottom( main:h() - h*2 )
	self._info_box = BoxGuiObject:new( info_area, { sides = { 1, 1, 1, 1 } } )
		
	-- Scroll indicators
	local scroll_up_indicator_shade = main:bitmap( { name = "scroll_up_indicator_shade", texture = "guis/textures/headershadow", rotation = 180, layer = 5, color = Color.white, w = main:w() - buttons_panel:w(), y = 100, halign = "right", valign = "top" } )
	scroll_up_indicator_shade:set_top( top_line:bottom() )
	local texture, rect = tweak_data.hud_icons:get_icon_data( "scroll_up" )
	local scroll_up_indicator_arrow = main:bitmap( { name = "scroll_up_indicator_arrow", texture = texture, texture_rect = rect, layer = 3, color = Color.white, halign = "right", valign = "top" } )
	scroll_up_indicator_arrow:set_righttop( scroll_panel:right() + 2 , scroll_up_indicator_shade:top() + 8 )
		
	local scroll_down_indicator_shade = main:bitmap( { name = "scroll_down_indicator_shade", texture = "guis/textures/headershadow", layer = 5, color = Color.white, w = main:w() - buttons_panel:w(), y = 100, halign = "right", valign = "bottom" } )
	scroll_down_indicator_shade:set_bottom( bottom_line:top() )
	local texture, rect = tweak_data.hud_icons:get_icon_data( "scroll_dn" )
	local scroll_down_indicator_arrow = main:bitmap( { name = "scroll_down_indicator_arrow", texture = texture, texture_rect = rect, layer = 3, color = Color.white, halign = "right", valign = "bottom" } )
	scroll_down_indicator_arrow:set_rightbottom( scroll_panel:right() + 2, scroll_down_indicator_shade:bottom() - 8 )
	
	-- Scroll bar	
	local bar_h = scroll_down_indicator_arrow:top() - scroll_up_indicator_arrow:bottom()
	local texture, rect = tweak_data.hud_icons:get_icon_data( "scrollbar" )
	local scroll_bar = main:bitmap( { name = "scroll_bar", texture = texture, texture_rect = rect, layer = 4, h = bar_h, color = Color.white, halign = "right" } )
	scroll_bar:set_bottom( scroll_down_indicator_arrow:top() )
	scroll_bar:set_center_x( scroll_down_indicator_arrow:center_x() )
	

	-- Legends
	local legend_minimize = main:text( { text = "MINIMIZE", name="legend_minimize", layer = 1, visible = use_minimize_legend,
									font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size,
									halign="left", valign="top" } )
	local _,_,lw,lh = legend_minimize:text_rect()
	legend_minimize:set_size( lw, lh )
	legend_minimize:set_bottom( top_line:bottom() - 4 )
	legend_minimize:set_right( top_line:right() )
		
	local legend_close = main:text( { text = "CLOSE", name="legend_close", layer = 1, visible = not no_close_legend,
									font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size,
									halign="left", valign="top", } )
	local _,_,lw,lh = legend_close:text_rect()
	legend_close:set_size( lw, lh )
	legend_close:set_top( bottom_line:top() + 4 )
	
	local legend_scroll = main:text( { text = "SCROLL WITH", name="legend_scroll", layer = 1, visible = not no_scroll_legend,
									font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size,
									halign="right", valign="top", } )
	local _,_,lw,lh = legend_scroll:text_rect()
	legend_scroll:set_size( lw, lh )
	legend_scroll:set_righttop( scroll_panel:right(), bottom_line:top() + 4 )
	
	self._scroll_panel = scroll_panel
	self._text_box = main
		
	self:_set_scroll_indicator()
	--[[scroll_bar:set_h( scroll_bar:h() * info_area:h()/scroll_panel:h())
	scroll_bar:set_visible( scroll_panel:h() > info_area:h() )
	legend_scroll:set_visible( scroll_panel:h() > info_area:h() )
	
	scroll_up_indicator_shade:set_visible( scroll_panel:h() > info_area:h() )
	scroll_up_indicator_arrow:set_visible( scroll_panel:h() > info_area:h() )
	scroll_down_indicator_shade:set_visible( scroll_panel:h() > info_area:h() )
	scroll_down_indicator_arrow:set_visible( scroll_panel:h() > info_area:h() )]]
	
	-- self:_check_scroll_indicator_states()
	
	if is_title_outside then
		title_text:set_bottom( -5 )
		title_text:set_rotation( 360 )
		self._is_title_outside = is_title_outside
	end
	return main
end

-- If there are stats information, setup the panel and add the stats types (types to come)
function TextBoxGui:_setup_stats_panel( scroll_panel, stats_list, stats_text )
	local has_stats = stats_list and #stats_list > 0
		
	local stats_panel = scroll_panel:panel( { name = "stats_panel", x = 10, w = has_stats and scroll_panel:w()/3 or 0, h = scroll_panel:h(), layer = 1 } )
	
	local total_h = 0
		
	if has_stats then
		for _,stats in ipairs( stats_list ) do
			if stats.type == "bar" then
				local panel = stats_panel:panel( { w = stats_panel:w(), h = 20, y = total_h, layer = -1 } )
				local bg = panel:rect( { color = Color.black:with_alpha( 0.5 ), layer = -1 } )
				local w = (bg:w() - 4) * (stats.current / stats.total)
				local progress_bar = panel:rect( { w = w, h = bg:h() - 2, x = 1, y = 1, color = tweak_data.hud.prime_color:with_alpha( 0.5 ), layer = 0 } )
				
				local text = panel:text( { text = stats.text, layer = 1, w = panel:w(), h = panel:h(), x = 4, y = -1, 
									font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size,
									align="left", halign="left", vertical="center", valign="center", blend_mode="normal", kern=0.0 } )
				-- text:set_center_y( panel:h()/2 )
				total_h = total_h + panel:h()
			elseif stats.type == "condition" then
				local panel = stats_panel:panel( { w = stats_panel:w(), h = 22, y = total_h } )
				
				local texture, rect = tweak_data.hud_icons:get_icon_data( "icon_repair" )
				local icon = panel:bitmap( { name = "icon", texture = texture, texture_rect = rect, layer = 0, color = Color.white } )
				icon:set_center_y( panel:h()/2 )
				
				local text = panel:text( { text = "CONDITION: "..stats.value.."%", layer = 0, w = panel:w(), h = panel:h(), x = icon:right(), 
									font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size,
									align="left", halign="left", vertical="center", valign="center", blend_mode="normal", kern=0.0 } )
				text:set_center_y( panel:h()/2 )
				
				total_h = total_h + panel:h()
			elseif stats.type == "empty" then
				local panel = stats_panel:panel( { w = stats_panel:w(), h = stats.h, y = total_h } )
				total_h = total_h + panel:h()
			elseif stats.type == "mods" then
				local panel = stats_panel:panel( { w = stats_panel:w(), h = 22, y = total_h } )
				local texture, rect = tweak_data.hud_icons:get_icon_data( "icon_addon" )
				local icon = panel:bitmap( { name = "icon", texture = texture, texture_rect = rect, layer = 0, color = Color.white } )
				icon:set_center_y( panel:h()/2 )
				
				local text = panel:text( { text = "ACTIVE MODS:", layer = 0, w = panel:w(), h = panel:h(), x = icon:right(), 
									font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size,
									align="left", halign="left", vertical="center", valign="center", blend_mode="normal", kern=0.0 } )
				text:set_center_y( panel:h()/2 )
				
				local s = ""
				for _,mod in ipairs( stats.list ) do
					s = s..mod.."\n"
				end
				local mods_text = panel:text( { text = s, layer = 0, w = panel:w(), h = panel:h(), y = text:bottom() ,x = icon:right(), 
									font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size, 
									align="left", halign="left", vertical="top", valign="top", blend_mode="normal", kern=0.0 } )
									
				local _,_,w,h = mods_text:text_rect()
				mods_text:set_h( h )
				
				panel:set_h( text:h() + mods_text:h() )
				total_h = total_h + panel:h()
			end
			
		end
		local stats_text = stats_panel:text( { text = stats_text or "Nunc vel diam vel neque sodales gravida et ac quam. Phasellus egestas, arcu in tristique mattis, velit nisi tincidunt lorem, bibendum molestie nunc purus id turpis. Donec sagittis nibh in eros ultrices aliquam. Vestibulum ante mauris, mattis quis commodo a, dictum eget sapien. Maecenas eu diam lorem. Nunc dolor metus, varius sit amet rhoncus vel, iaculis sed massa. Morbi tempus mi quis dolor posuere eu commodo magna eleifend. Pellentesque sit amet mattis nunc. Nunc lectus quam, pretium sit amet consequat sed, vestibulum vitae lorem. Sed bibendum egestas turpis, sit amet viverra risus viverra in. Suspendisse aliquam dapibus urna, posuere fermentum tellus vulputate vitae.", layer = 0, wrap = true, word_wrap = true,
									w = stats_panel:w(), y = total_h, 
									font = tweak_data.menu.pd2_small_font, font_size = tweak_data.menu.pd2_small_font_size,
									align="left", halign="left", vertical="top", valign="top", blend_mode="normal", kern=0.0 } )
		local _,_,w,h = stats_text:text_rect()
		stats_text:set_h( h )
		total_h = total_h + h
	end
	stats_panel:set_h( total_h )
	
	return stats_panel
end

-- If there are buttons, setup the buttons panel and create the buttons 
function TextBoxGui:_setup_buttons_panel( info_area, button_list, focus_button, only_buttons )
	local has_buttons = button_list and #button_list > 0
	
	local buttons_panel = info_area:panel( { name = "buttons_panel", x = 10, w = has_buttons and 200 or 0, h = info_area:h(), layer = 1 } )
	
	buttons_panel:set_right( info_area:w() )
	self._text_box_buttons_panel = buttons_panel
	
	if has_buttons then
		local button_text_config = { x = 10, name = "button_text", font = tweak_data.menu.pd2_medium_font, font_size = tweak_data.menu.pd2_medium_font_size, vertical = "center", halign="right", layer = 2, wrap="true", word_wrap="true", blend_mode="add", color=tweak_data.screen_colors.button_stage_3 } -- tweak_data.dialog.BUTTON_TEXT_COLOR
		
		local max_w = 0
		local max_h = 0
		
		if( button_list ) then
			-- print( "button_list", inspect( button_list ) )
			for i,button in ipairs( button_list ) do
				-- print( "button", inspect( button ) )
				local button_panel = buttons_panel:panel( { name = button.id_name, y = 100, h = 20, halign="grow" } )
								
				button_text_config.text = utf8.to_upper( button.text or "" )
				local text = button_panel:text( button_text_config )
				
				-- text:set_color( tweak_data.screen_colors.button_stage_3 )
				
				local _,_,w,h = text:text_rect()
				max_w = math.max( max_w, w )
				max_h = math.max( max_h, h )
				text:set_size( w, h )
				button_panel:set_h( h )
				text:set_right( button_panel:w() )
				
				-- button_panel:set_bottom( buttons_panel:h() - (#button_list-i) * h )
				button_panel:set_bottom( i * h )
				
				-- local unselected = button_panel:bitmap( { name = "unselected", texture = "guis/textures/menu_unselected", x = 0, y = 0, layer = 0 } )
							
				-- unselected:set_h( 64 * button_panel:h()/32 )
				-- unselected:set_center_y( button_panel:h()/2 )
				-- unselected:set_w( button_panel:w() )
			end
			buttons_panel:set_h( #button_list * max_h )
			buttons_panel:set_bottom( info_area:h() - 10 )
		end
		
		buttons_panel:set_w( only_buttons and info_area:w() or (math.max(max_w, 120) + 40) )
		buttons_panel:set_right( info_area:w() - 10 )
		
		-- local buttons_rect = buttons_panel:rect( { visible = true, name = "buttons_rect", layer = -1, color = Color.black:with_alpha( 0.35 ) } )
		-- self._target_alpha[ buttons_rect:key() ] = 0.35
		-- local selected = buttons_panel:bitmap( { visible = true, name="selected", texture = "guis/textures/menu_selected", x = 0, y = 0, layer = 1 } )
			local selected = buttons_panel:rect( { name="selected", blend_mode="add", color=tweak_data.screen_colors.button_stage_3, alpha=0.3 } )
			self:set_focus_button( focus_button )
	end
	
	return buttons_panel
end

function TextBoxGui:_create_lower_static_panel()
	
end

function TextBoxGui:check_focus_button( x ,y )
	for i,panel in ipairs( self._text_box_buttons_panel:children() ) do
		if panel.child and panel:inside( x, y ) then -- CHILD CHECK IS BAD
			self:set_focus_button( i )
			return true
		end
	end
	return false
end

function TextBoxGui:set_focus_button( focus_button )
	if( focus_button ~= self._text_box_focus_button ) then
		managers.menu:post_event( "highlight" )
		if( self._text_box_focus_button ) then
			self:_set_button_selected( self._text_box_focus_button, false )
		end

		self:_set_button_selected( focus_button, true )

		self._text_box_focus_button = focus_button
	end
end

function TextBoxGui:_set_button_selected( index, is_selected )
	local button_panel = self._text_box_buttons_panel:child( index - 1 )
	-- print( button_panel )
	if( button_panel ) then
		local button_text = button_panel:child( "button_text" )
		-- local unselected = button_panel:child( "unselected" )
		local selected = self._text_box_buttons_panel:child( "selected" )
		
		if( is_selected ) then
			button_text:set_color( tweak_data.screen_colors.button_stage_2 )
			selected:set_shape( button_panel:shape() )
			selected:move( 2,-1 )
		else
			button_text:set_color( tweak_data.screen_colors.button_stage_3 )
		end
		--[[
		if( is_selected ) then
			button_text:set_color( tweak_data.dialog.SELECTED_BUTTON_TEXT_COLOR )
			button_text:set_font( tweak_data.menu.default_font_no_outline_id )
			selected:set_size( unselected:size() )
			selected:set_center_y( button_panel:center_y() )
		else
			button_text:set_color( tweak_data.dialog.BUTTON_TEXT_COLOR )
			button_text:set_font( tweak_data.menu.default_font_id )
		end]]
	end
end

function TextBoxGui:change_focus_button( change )
	local button_count = self._text_box_buttons_panel:num_children() - 1 -- removes children which is not buttons, like selection rect, change this number when you change number of non-buttons
	local focus_button = ( self._text_box_focus_button + change ) % button_count

	if( focus_button == 0 ) then
		focus_button = button_count
	end

	self:set_focus_button( focus_button )
end

function TextBoxGui:get_focus_button()
	return self._text_box_focus_button
end

function TextBoxGui:get_focus_button_id()
	return self._text_box_buttons_panel:child( self._text_box_focus_button - 1 ):name()
end

function TextBoxGui:_set_scroll_indicator()
	local info_area = self._text_box:child( "info_area" )
	local scroll_panel = info_area:child( "scroll_panel" )
	local scroll_text = scroll_panel:child( "text" )
	local scroll_bar = self._text_box:child( "scroll_bar" )
	local legend_scroll = self._text_box:child( "legend_scroll" )

	local bar_h = self._text_box:child( "scroll_down_indicator_arrow" ):top() - self._text_box:child( "scroll_up_indicator_arrow" ):bottom()

	local is_visible = scroll_text:h() > info_area:h()
	if scroll_text:h() ~= 0 then
		scroll_bar:set_h( bar_h * scroll_panel:h()/scroll_text:h())
	end
	scroll_bar:set_visible( is_visible )
	legend_scroll:set_visible( not self._no_scroll_legend and is_visible )
	
	self._text_box:child( "scroll_up_indicator_shade" ):set_visible( is_visible )
	self._text_box:child( "scroll_up_indicator_arrow" ):set_visible( is_visible )
	self._text_box:child( "scroll_down_indicator_shade" ):set_visible( is_visible )
	self._text_box:child( "scroll_down_indicator_arrow" ):set_visible( is_visible )
end

function TextBoxGui:_check_scroll_indicator_states()
	local info_area = self._text_box:child( "info_area" )
	local scroll_panel = info_area:child( "scroll_panel" )
	local scroll_text = scroll_panel:child( "text" )
		
	if not self._up_alpha then
		self._up_alpha = { current = 0 }
		self._text_box:child( "scroll_up_indicator_shade" ):set_color( self._text_box:child( "scroll_up_indicator_shade" ):color():with_alpha( self._up_alpha.current ) )
		self._text_box:child( "scroll_up_indicator_arrow" ):set_color( self._text_box:child( "scroll_up_indicator_arrow" ):color():with_alpha( self._up_alpha.current ) )
	end
	
	if not self._down_alpha then
		self._down_alpha = { current = 1 }
		self._text_box:child( "scroll_down_indicator_shade" ):set_color( self._text_box:child( "scroll_down_indicator_shade" ):color():with_alpha( self._down_alpha.current ) )
		self._text_box:child( "scroll_down_indicator_arrow" ):set_color( self._text_box:child( "scroll_down_indicator_arrow" ):color():with_alpha( self._down_alpha.current ) )
	end
		
	self._up_alpha.target = 0 > scroll_text:top() and 1 or 0
	self._down_alpha.target = scroll_text:bottom() > scroll_panel:h() and 1 or 0 
		
	-- self._text_box:child( "scroll_up_indicator_shade" ):set_visible( 0 > scroll_panel:top() )
	-- self._text_box:child( "scroll_up_indicator_arrow" ):set_visible( 0 > scroll_panel:top() )
	-- self._text_box:child( "scroll_down_indicator_shade" ):set_visible( info_area:h() < scroll_panel:bottom() )
	-- self._text_box:child( "scroll_down_indicator_arrow" ):set_visible( info_area:h() < scroll_panel:bottom() )
	
	local up_arrow = self._text_box:child( "scroll_up_indicator_arrow" )
	
	local scroll_bar = self._text_box:child( "scroll_bar" )
	local sh = scroll_text:h() ~= 0 and scroll_text:h() or 1
	scroll_bar:set_top( up_arrow:bottom() - ( scroll_text:top()*(scroll_panel:h()-up_arrow:h()*2-16)/sh ) ) 
end

function TextBoxGui:input_focus()
	return false
end

function TextBoxGui:mouse_pressed( button, x, y )
	return false
end

function TextBoxGui:check_close( x, y )
	if not self:can_take_input() then
		return false
	end
	
	local legend_close = self._panel:child( "legend_close" )
	if not legend_close:visible() then
		return false
	end
	
	if legend_close:inside( x, y ) then
		return true
	end
	return false
end

function TextBoxGui:check_minimize( x, y )
	if not self:can_take_input() then
		return false
	end
	
	local legend_minimize = self._panel:child( "legend_minimize" )
	if not legend_minimize:visible() then
		return false
	end
	
	if legend_minimize:inside( x, y ) then
		return true
	end
	return false
end

function TextBoxGui:check_grab_scroll_bar( x, y )
	if not self:can_take_input() then
		return false
	end
		
	if self._allow_moving and self._text_box:inside( x, y ) and self._text_box:child( "top_line" ):inside( x, y ) then
		self._grabbed_title = true
		self._grabbed_offset_x = self:x() - x
		self._grabbed_offset_y = self:y() - y
		return true
	end
	
	if self._text_box:child( "scroll_bar" ) and self._text_box:child( "scroll_bar" ):inside( x, y ) then
		self._grabbed_scroll_bar = true
		self._current_y = y
		return true
	end
	if self._text_box:child( "scroll_up_indicator_arrow" ):inside( x, y ) then
		self._pressing_arrow_up = true
		return true
	end
	if self._text_box:child( "scroll_down_indicator_arrow" ):inside( x, y ) then
		self._pressing_arrow_down = true
		return true
	end
	return false
end

function TextBoxGui:release_scroll_bar()
	self._pressing_arrow_up = false
	self._pressing_arrow_down = false
	if self._grabbed_scroll_bar then
		self._grabbed_scroll_bar = false
		return true
	end
	if self._grabbed_title then
		self._grabbed_title = false
		return true
	end
	return false
end

function TextBoxGui:mouse_moved( x, y )
end

function TextBoxGui:moved_scroll_bar( x, y )
	if not self:can_take_input() then
		return false
	end
	
	if self._pressing_arrow_up then
		if self._text_box:child( "scroll_up_indicator_arrow" ):inside( x, y ) then
			self:scroll_up()
		end
	end
	if self._pressing_arrow_down then
		if self._text_box:child( "scroll_down_indicator_arrow" ):inside( x, y ) then
			self:scroll_down()
		end
	end
	if self._grabbed_scroll_bar then
		self:scroll_with_bar( y, self._current_y )
		self._current_y = y
		return true
	end
	if self._grabbed_title then
		local _x = x + self._grabbed_offset_x
		local _y = y + self._grabbed_offset_y
		if _x + self:w() > self._ws:panel():w() then
			self._grabbed_offset_x = self:x() - x
			_x = self._ws:panel():w() - self:w()
		elseif _x < self._ws:panel():x() then
			self._grabbed_offset_x = self:x() - x
			_x = self._ws:panel():x()
		end
		if _y + self:h() > self._ws:panel():h() then -- - CoreMenuRenderer.Renderer.border_height then
			self._grabbed_offset_y = self:y() - y
			_y = self._ws:panel():h() - self:h() -- - CoreMenuRenderer.Renderer.border_height
		elseif _y < self._ws:panel():y() then
			self._grabbed_offset_y = self:y() - y
			_y = self._ws:panel():y()
		end
		self:set_position( _x, _y )
		return true, "grab"
	end
	return false
end

function TextBoxGui:mouse_wheel_up( x, y )
	if not self._visible then
		return false
	end
	
	local scroll_panel = self._text_box:child( "info_area" ):child( "scroll_panel" )
	local info_area = self._text_box:child( "info_area" )
	if info_area:inside( x, y ) and scroll_panel:inside( x, y ) then
		self:scroll_up( 28 )
		return true
	end
end

function TextBoxGui:mouse_wheel_down( x, y )
	if not self._visible then
		return false
	end
	
	local scroll_panel = self._text_box:child( "info_area" ):child( "scroll_panel" )
	local info_area = self._text_box:child( "info_area" )
	if info_area:inside( x, y ) and scroll_panel:inside( x, y ) then
		self:scroll_down( 28 )
		return true
	end
end

-- Scrolls up
function TextBoxGui:scroll_up( y )
	if not alive( self._text_box ) then
		return
	end
	
	local scroll_panel = self._text_box:child( "info_area" ):child( "scroll_panel" )
	local scroll_text = scroll_panel:child( "text" )
		
	local top_y = self._is_title_outside and 5 or math.round( self._text_box:child("title"):bottom() + 5 )
	if 0 > scroll_text:top() then
		scroll_text:set_y( scroll_text:y() + (y or TimerManager:main():delta_time() * 200) )
	end
	if top_y < scroll_text:top() then
		scroll_text:set_top( top_y )
	end
	
	self:_check_scroll_indicator_states()
end

-- Scrolls down
function TextBoxGui:scroll_down( y )
	if not alive( self._text_box ) then
		return
	end
	
	local info_area = self._text_box:child( "info_area" )
	local scroll_panel = info_area:child( "scroll_panel" )
	local scroll_text = scroll_panel:child( "text" )
	
	if scroll_text:bottom() > scroll_panel:h() then
		if scroll_panel:h() < scroll_text:bottom() then
			scroll_text:set_y( scroll_text:y() - ( y or TimerManager:main():delta_time() * 200 ) )
		end
		if scroll_panel:h() > scroll_text:bottom() then
			scroll_text:set_bottom( scroll_panel:h() )
		end
	end
	self:_check_scroll_indicator_states()
end

-- Scrolls the bar based on y movement (as from a mouse pointer move)
function TextBoxGui:scroll_with_bar( target_y, current_y )
	local arrow_size = self._text_box:child( "scroll_up_indicator_arrow" ):size()
	local info_area = self._text_box:child( "info_area" )
	local scroll_panel = info_area:child( "scroll_panel" )
	local scroll_text = scroll_panel:child( "text" )

	if target_y < current_y then
		if target_y < (scroll_panel:world_bottom() - arrow_size) then
			local mul = (scroll_panel:h()-arrow_size*2)/scroll_text:h()
			self:scroll_up( (current_y - target_y)/(mul) )
		end
		current_y = target_y
	elseif target_y > current_y then
		if target_y > (scroll_panel:world_y() + arrow_size) then
			local mul = (scroll_panel:h()-arrow_size*2)/scroll_text:h()
			self:scroll_down( (target_y - current_y)/(mul) )
		end
		current_y = target_y
	end
end

function TextBoxGui:update_indicator( t, dt )
	if alive( self._indicator ) then 
		self._indicator:rotate( 180 * dt )
	end
end

function TextBoxGui:set_fade( fade )
	self:_set_alpha( fade )
	if alive( self._background ) then
		-- self._background:set_color( self._background:color():with_alpha( fade * 0.9 ) )
		self._background:set_alpha( fade * 0.9 )
	end
	if alive( self._background2 ) then
		self._background2:set_alpha( fade * 0.3 )
	end
	
	-- print( "fade", fade )
end

function TextBoxGui:_set_alpha( alpha )
	self._panel:set_alpha( alpha )
	self._panel:set_visible( alpha ~= 0 )
	-- self:_set_alpha_recursive( self._panel, alpha )
end

function TextBoxGui:_set_alpha_recursive( obj, alpha )
	if( obj.set_color ) then
		local a = (self._target_alpha[ obj:key() ] and self._target_alpha[ obj:key() ] * alpha) or alpha
		obj:set_color( obj:color():with_alpha( a ) )
	end

	if( obj.children ) then
		for _,child in ipairs( obj:children() ) do
			self:_set_alpha_recursive( child, alpha )
		end
	end
end

function TextBoxGui:set_title( title )
	local title_text = self._panel:child( "title" )
	title_text:set_text( title or "none" )
	local _,_,w,h = title_text:text_rect()
	title_text:set_size( w, h ) 
	title_text:set_visible( title and true or false )
end

function TextBoxGui:set_text( txt, no_upper )
	local text = self._panel:child( "info_area" ):child( "scroll_panel" ):child( "text" )
	-- local text = self._panel:child( "text" )
	text:set_text( (no_upper and txt) or utf8.to_upper( txt or "" ) )
end

function TextBoxGui:set_use_minimize_legend( use )
	self._panel:child( "legend_minimize" ):set_visible( use )
end

function TextBoxGui:in_focus( x, y )
	return self._panel:inside( x, y )
end

function TextBoxGui:in_info_area_focus( x, y )
	return self._panel:child( "info_area" ):inside( x, y )
end

function TextBoxGui:_set_visible_state()
	local visible = self._visible and self._enabled
	self._panel:set_visible( visible )
	
	if alive( self._background ) then
		self._background:set_visible( visible )
	end
	if alive( self._background2 ) then
		self._background2:set_visible( visible )
	end
	
end

function TextBoxGui:can_take_input()
	return self._visible and self._enabled
end

function TextBoxGui:set_visible( visible )
	self._visible = visible
	-- self._panel:set_visible( self._visible )
	self:_set_visible_state()
end

function TextBoxGui:set_enabled( enabled )
	if self._enabled == enabled then
		return
	end
	
	self._enabled = enabled
	self:_set_visible_state()
	if self._minimized then
		if not self._enabled then
			self:_remove_minimized( self._minimized_id )
		else
			self:_add_minimized()
		end
	end
end

function TextBoxGui:enabled()
	return self._enabled
end

function TextBoxGui:_maximize( data )
	self:set_visible( true )
	self:set_minimized( false, nil )
	
	self:_remove_minimized( data.id )
end

function TextBoxGui:set_minimized( minimized, minimized_data )
	self._minimized = minimized
	self._minimized_data = minimized_data
	if self._minimized then
		self:_add_minimized()
	end
end

function TextBoxGui:_add_minimized()
	self._minimized_data.callback = callback( self, self, "_maximize" )
	self:set_visible( false )
	self._minimized_id = managers.menu_component:add_minimized( self._minimized_data )
end

function TextBoxGui:_remove_minimized( id )
	self._minimized_id = nil
	managers.menu_component:remove_minimized( id )
end

function TextBoxGui:minimized()
	return self._minimized
end

function TextBoxGui:set_position( x, y )
	self._panel:set_position( x, y )
end

function TextBoxGui:position()
	return self._panel:position()
end

function TextBoxGui:set_size( x, y )
	self._panel:set_size( x, y )
	local _,_,w,h = self._panel:child( "title" ):text_rect()
	
	local lower_static_panel = self._panel:child( "lower_static_panel" )
	lower_static_panel:set_w( self._panel:w() ) 
	lower_static_panel:set_bottom( self._panel:h() - h )
	
	local lsp_h = lower_static_panel:h()
		
	local info_area = self._panel:child( "info_area" )
	info_area:set_size( self._panel:w(), self._panel:h() - h*2 - lsp_h )
	
	if self._info_box then
		self._info_box:create_sides( info_area, { sides = { 1, 1, 1, 1 } } )
	end
	-- info_area:child( "info_bg" ):set_size( info_area:size() )
			
	local buttons_panel = info_area:child( "buttons_panel" )
	local scroll_panel = info_area:child( "scroll_panel" )
	scroll_panel:set_w( info_area:w() - buttons_panel:w() - 10*3 )
	-- scroll_panel:set_h( scroll_panel:h() )
	-- scroll_panel:set_position( scroll_panel:position() )
	scroll_panel:set_y( scroll_panel:y() - 1 )
	scroll_panel:set_y( scroll_panel:y() + 1 )
		
	local scroll_up_indicator_shade = self._panel:child( "scroll_up_indicator_shade" )
	scroll_up_indicator_shade:set_w( self._panel:w() - buttons_panel:w() )
	local scroll_up_indicator_arrow = self._panel:child( "scroll_up_indicator_arrow" ) 
	scroll_up_indicator_arrow:set_lefttop( scroll_panel:right() + 2 , scroll_up_indicator_shade:top() + 8 )
	
	local top_line = self._panel:child( "top_line" )
	top_line:set_w( self._panel:w() )
	top_line:set_bottom( h )
	
	local bottom_line = self._panel:child( "bottom_line" )
	bottom_line:set_w( self._panel:w() )
	bottom_line:set_top( self._panel:h() - h )
		
	local scroll_down_indicator_shade = self._panel:child( "scroll_down_indicator_shade" )
	scroll_down_indicator_shade:set_w( self._panel:w() - buttons_panel:w() )
	scroll_down_indicator_shade:set_bottom( bottom_line:top() + 6 - lsp_h )
	local scroll_down_indicator_arrow = self._panel:child( "scroll_down_indicator_arrow" )
	scroll_down_indicator_arrow:set_leftbottom( scroll_panel:right() + 2, scroll_down_indicator_shade:bottom() - 8 )
	
	local scroll_bar = self._panel:child( "scroll_bar" )
	-- scroll_bar:set_bottom( scroll_down_indicator_arrow:top() )
	scroll_bar:set_center_x( scroll_down_indicator_arrow:center_x() )
	-- local scroll_panel = info_area:panel( { name = "scroll_panel", x = 10, w = info_area:w() - buttons_panel:w() - 10*3, h = info_area:h(), layer = 1 } )
	-- local info_area = main:panel( { name="info_area", x = 0, y = math.round( h ), w = main:w(), h = main:h() - h*2, layer = 0 } )
	
	local legend_close = self._panel:child( "legend_close" )
	legend_close:set_top( bottom_line:top() + 4 )
	
	local legend_minimize = self._panel:child( "legend_minimize" )
	legend_minimize:set_bottom( top_line:bottom() - 4 )
	legend_minimize:set_right( top_line:right() )
	
	local legend_scroll = self._panel:child( "legend_scroll" )
	legend_scroll:set_righttop( scroll_panel:right(), bottom_line:top() + 4 )
	
	self:_set_scroll_indicator()
	self:_check_scroll_indicator_states()
end

function TextBoxGui:size()
	return self._panel:size()
end

function TextBoxGui:open_page() end		-- Called when used in a book gui
function TextBoxGui:close_page() end	-- Called when used in a book gui

function TextBoxGui:x() return self._panel:x() end
function TextBoxGui:y() return self._panel:y() end
function TextBoxGui:h() return self._panel:h() end
function TextBoxGui:w()	return self._panel:w() end

function TextBoxGui:h()
	return self._panel:h()
end

function TextBoxGui:visible()
	return self._visible
end

function TextBoxGui:close()
	-- print( "TextBoxGui:close()" )
	if self._minimized then
		self:_remove_minimized( self._minimized_id )
	end
	if self._thread then
		self._panel:stop( self._thread )
		self._thread = nil
	end
	if self._info_box then
		self._info_box:close()
		self._info_box = nil
	end
	self._ws:panel():remove( self._panel )
	if alive( self._background ) then
		self._fullscreen_ws:panel():remove( self._background )
	end
	if alive( self._background2 ) then
		self._fullscreen_ws:panel():remove( self._background2 )
	end

	if alive( self._fullscreen_ws ) then
		Overlay:gui():destroy_workspace( self._fullscreen_ws )
		self._fullscreen_ws = nil
	end
end

