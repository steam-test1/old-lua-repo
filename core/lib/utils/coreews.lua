
core:module( "CoreEws" )

core:import( "CoreClass" )
core:import( "CoreApp" )


--[[

The CoreEws module contains some additional useful
EWS dialogs, and some helper functions.

]]--


----------------------------------------------------------------------
-- function: v e r i f y _ n u m b e r
--
-- connect a TextCtrl to verify_number when you only want a valid number
-- local time = EWS:TextCtrl( panel, t, "", "TE_CENTRE" )
-- time:connect( "EVT_CHAR", callback( nil, _G, "verify_number" ), time )
----------------------------------------------------------------------
function verify_number( ctrlr, event )
	if EWS:name_to_key_code( "K_BACK" ) == event:key_code() or EWS:name_to_key_code( "K_RIGHT" ) == event:key_code() or
		EWS:name_to_key_code( "K_LEFT" ) == event:key_code() or (event:key_code() >= 48 and event:key_code() <= 57) or 
			event:key_code() == 45 or -- minus
			event:key_code() == 46 or 
			EWS:name_to_key_code( "K_RETURN" ) == event:key_code() or 
			EWS:name_to_key_code( "K_TAB" ) == event:key_code() or 
			EWS:name_to_key_code( "K_DELETE" ) == event:key_code()
				then
					if event:key_code() == 46 then
						local s = ctrlr:get_value()..'.'
						if not tonumber( s ) then
							return
						end
					end
					event:skip()
	end
	
end


function image_path(file_name)	
	file_name = file_name or ""
	
	-- Start looking for the file in the game-specific image directory
	-- If called without an argument, simply returns the game-specific UI image path
	local base_path = managers.database and managers.database:base_path() or (Application:base_path() .. ( CoreApp.arg_value("-assetslocation") or "../../" ) ..  "assets\\")
	local path = base_path .. "lib\\utils\\dev\\ews\\images\\"
	
	if file_name ~= "" and EWS and not EWS:system_file_exists(path .. file_name) then
		-- No game-specific image found - return the path to the image in the core image directory
		-- Note that no check is performed as to whether or not this file exists
		path = base_path .. "core\\lib\\utils\\dev\\ews\\images\\"
	end

	return path .. file_name
end


----------------------------------------------------------------------
-- class: E W S C o n f i r m D i a l o g
--
-- Confirm dialog that should be shown modal. It creates a Yes, No 
-- and Cancel button. And the values can be checked when a button 
-- has been clicked.
----------------------------------------------------------------------
EWSConfirmDialog = EWSConfirmDialog or CoreClass.class()

function EWSConfirmDialog:init( label, message )

	self._yes = false
	self._no = false
	self._cancel = false
	
	self._dialog = EWS:Dialog( nil, label, "", Vector3( 525, 400, 0), Vector3( 250, 110, 0), "DEFAULT_DIALOG_STYLE" )
	local dialog_sizer = EWS:BoxSizer( "HORIZONTAL" )
	self._dialog:set_sizer( dialog_sizer )
	
	local panel = EWS:Panel( self._dialog, "", "" )
	local panel_sizer = EWS:BoxSizer( "VERTICAL" )
	panel:set_sizer( panel_sizer )
		
		local msg = EWS:StaticText( panel, message, "", "ALIGN_CENTRE" )
		
		panel_sizer:add( msg, 0, 20, "EXPAND,TOP,BOTTOM" )
		
		local button_sizer = EWS:BoxSizer("HORIZONTAL")

			local yes_btn = EWS:Button( panel, "Yes", "", "BU_BOTTOM" )
			button_sizer:add( yes_btn, 0, 2, "RIGHT,LEFT" )
			yes_btn:connect( "EVT_COMMAND_BUTTON_CLICKED", callback( self, self, "set_value" ), "_yes" )
			
			local no_btn = EWS:Button( panel, "No", "", "" )
			button_sizer:add( no_btn, 0, 2, "RIGHT,LEFT" )
			no_btn:connect( "EVT_COMMAND_BUTTON_CLICKED", callback( self, self, "set_value" ), "_no" )
			
			local cancel_btn = EWS:Button( panel, "Cancel", "", "" )
			button_sizer:add( cancel_btn, 0, 2, "RIGHT,LEFT" )
			cancel_btn:connect( "EVT_COMMAND_BUTTON_CLICKED", callback( self, self, "set_value" ), "_cancel" )
			
		panel_sizer:add( button_sizer, 1, 0, "EXPAND" )
		
	dialog_sizer:add( panel_sizer, 1, 0, "EXPAND" )

	panel:fit()
end

function EWSConfirmDialog:show_modal()
	self._dialog:show_modal()
	return true
end

function EWSConfirmDialog:set_value( value )
	self[ value ] = true
	self._dialog:end_modal()
end

function EWSConfirmDialog:yes()
	return self._yes
end
function EWSConfirmDialog:no()
	return self._no
end
function EWSConfirmDialog:cancel()
	return self._cancel
end


----------------------------------------------------------------------
-- class: L o c a l i z e r T e x t C t r l
--
-- LocalizerTextCtrl creates a TextCtrl, the value is 
-- set to it through using the Localizer.
----------------------------------------------------------------------
LocalizerTextCtrl = LocalizerTextCtrl or CoreClass.class()

function LocalizerTextCtrl:init( panel, sizer, text )
	self._text_ctrlr = EWS:TextCtrl( panel, Localizer:lookup( text ), "", "TE_CENTRE,TE_READONLY" )
	sizer:add( self._text_ctrlr  , 1, 0, "EXPAND" )
end

function LocalizerTextCtrl:get()
	return self._text_ctrlr
end

function LocalizerTextCtrl:get_value()
	return self._text_ctrlr:get_value()
end

function LocalizerTextCtrl:set_value( value )
	return self._text_ctrlr:set_value( Localizer:lookup( value ) )
end


----------------------------------------------------------------------
-- class: E W S R a d i o B i t m a p B u t t o n
--
-- Attempt to create a bitmap button that functions as 
-- a radio button and changes picture selected.
----------------------------------------------------------------------
EWSRadioBitmapButton = EWSRadioBitmapButton or CoreClass.class()

function EWSRadioBitmapButton:init( panel, bmp, id, style )
	self._on_bmp = bmp
	self._off_bmp = bmp
	self._button = EWS:BitmapButton( panel, bmp, "", "" )
	self._value = true
end

function EWSRadioBitmapButton:button()
	return self._button
end

function EWSRadioBitmapButton:set_on_bmp( bmp )
	self._on_bmp = bmp
end

function EWSRadioBitmapButton:set_off_bmp( bmp )
	self._off_bmp = bmp
end

function EWSRadioBitmapButton:set_value( value )
	self._value = value
	if value then
		self._button:set_label_bitmap( self._on_bmp )
	else
		self._button:set_label_bitmap( self._off_bmp )
	end
end

function EWSRadioBitmapButton:value()
	return self._value
end


----------------------------------------------------------------------
-- class: E w s T e x t D i a l o g
--
-- Created a Dialog where you can type in a text, with 
-- cancel and ok buttons
----------------------------------------------------------------------
EwsTextDialog = EwsTextDialog or CoreClass.class()

function EwsTextDialog:init( name, init_text )
	if not init_text then
		init_text = "new"
	end
	self._dialog = EWS:Dialog( nil, name, "", Vector3( 525, 400, 0), Vector3( 230, 150, 0), "CAPTION,CLOSE_BOX" )
	self._dialog:set_background_colour( "LIGHT GREY"  )
	local dialog_main_sizer = EWS:StaticBoxSizer( self._dialog, "VERTICAL" )
	self._dialog:set_sizer( dialog_main_sizer )
	
	self._text = EWS:TextCtrl( self._dialog, init_text, "", "TE_CENTRE" )
	dialog_main_sizer:add( self._text, 0, 0, "EXPAND" )
	
		local button_sizer = EWS:BoxSizer("HORIZONTAL")
		-- Create new button
			local ok_btn = EWS:Button( self._dialog, "Ok", "", "BU_EXACTFIT,NO_BORDER" )
			button_sizer:add( ok_btn, 0, 0, "EXPAND" )
			ok_btn:connect( "EVT_COMMAND_BUTTON_CLICKED", callback( self, self, "close" ), { dialog = self._dialog, cancel = false } )
			
			local cancel_btn = EWS:Button( self._dialog, "Cancel", "", "BU_EXACTFIT,NO_BORDER")
			button_sizer:add( cancel_btn, 0, 0, "EXPAND" )
			cancel_btn:connect( "EVT_COMMAND_BUTTON_CLICKED", callback( self, self, "close" ), { dialog = self._dialog, cancel = true } )
			
		dialog_main_sizer:add( button_sizer, 0, 0, "ALIGN_RIGHT" )
end

function EwsTextDialog:close( data )
	data.dialog:end_modal()
	self._cancel_dialog = data.cancel
end

function EwsTextDialog:cancel_dialog()
	return self._cancel_dialog
end

function EwsTextDialog:dialog()
	return self._dialog
end

function EwsTextDialog:text()
	return self._text
end

--[[
number_controller creates a text ctrlr that handles numbers.
The function takes a table paramas containing:
	name (optional)					- Used if a StaticText ctrlr should be added to before the TextCtrlr
	panel (required)				- The parent panel to the ctrlr(s)
	sizer(required)					- The sizer the ctrlr(s) should be added to (to function actually creates a new sizer for the ctrlrs
						  			  and then adds that sizer to the params.sizer
	value (optional)				- The default value of the ctrlr (will default to zero if not given
	name_proportions (optional)		- The proportions the name ctrlr should use when added (defaults to one)
	ctrlr_proportions (optional)	- The proportions the text ctrlr should use when added (defaults to one)
	floats (optional)				- Specifies how many floats it should allow (defaults to zero)
	tooltip (optional)				- A tooltip for the ctrlr
	max (optional)					- If specified, the entered value will be clamped to this if above
	min (optional)					- If specified, the entered value will be clamped to this if below
	events (optional)				- This should be a ipairs table containing tables with:
										event		-	The name of the event( "EVT_COMMAND_TEXT_ENTER" )
										callback	-	The function to be called.
									The function will recieve params as parameter. It contains all params used to
									create the ctrlrs as well as the created ctrlrs. It will also contain
									the last entered value, params.value.

The function returns the ctrlr, name ctrlr and params (which now also contains the ctrlrs)
]]
function number_controller( params )
	params.value = params.value or 0
	params.name_proportions = params.name_proportions or 1
	params.ctrlr_proportions = params.ctrlr_proportions or 1
	params.floats = params.floats or 0
	
	params.ctrl_sizer = EWS:BoxSizer( "HORIZONTAL" )
	
	_ctrlr_tooltip( params )
	_name_ctrlr( params )
	_number_ctrlr( params )
			
	params.ctrl_sizer:add( params.number_ctrlr, params.ctrlr_proportions, 0, "EXPAND" )
	
	params.sizer:add( params.ctrl_sizer, 0, 0, "EXPAND" )
		
	_connect_events( params )
	return params.number_ctrlr, params.name_ctrlr, params
end

-- verify_entered_number is used by number_controller to verify the entered value and
-- match it to specified params.
function verify_entered_number( params )
	local value = tonumber( params.number_ctrlr:get_value() ) or 0
	value = params.min and value < params.min and params.min or value
	value = params.max and value > params.max and params.max or value
	params.value = value
	local floats = params.floats or 0
	params.number_ctrlr:change_value( string.format( "%."..floats.."f", value ) )
	params.number_ctrlr:set_selection( -1, -1 )
end

-- This function can be called to set a number controller to a new value. First parameter should be the params
-- used to create the controller, and the second parameter is the new value.
function change_entered_number( params, value )
	local floats = params.floats or 0
	params.value = value
	params.number_ctrlr:change_value( string.format( "%."..floats.."f", params.value ) )
end

function change_slider_and_number_value( params, value )
	params.value = value
	params.slider_ctrlr:set_value( value * params.slider_multiplier )
	change_entered_number( params, value )
end

-- Private function used to connect events from params
-- params.events				- This should be a ipairs table containing tables with:
--										event		-	The name of the event( "EVT_COMMAND_TEXT_ENTER" )
--										callback	-	The function to be called.
--								The callback function will recieve params as parameter. It contains all params used to
--								create the ctrlrs as well as the created ctrlrs. It will also contain
--								the last entered value, params.value.
function _connect_events( params )
	if not params.events then
		return
	end
	
	for _,data in ipairs( params.events ) do
		params.number_ctrlr:connect( data.event, data.callback, params )
	end
end

--[[
combobox creates a combo box
The function takes a table paramas containing:
	name (optional)					- Used if a StaticText ctrlr should be added to before the ComboBox
	panel (required)				- The parent panel to the ctrlr(s)
	sizer(required)					- The sizer the ctrlr(s) should be added to (to function actually creates a new sizer for the ctrlrs
						  			  and then adds that sizer to the params.sizer
	default (optional)				- A default value to be appended first in the combo box (a "none" choice for example)
	options (required)				- A table containing all options to be appended to the combo box
	value (optional)				- The default value of the ctrlr (will default to first option if not given)
	name_proportions (optional)		- The proportions the name ctrlr should use when added (defaults to one)
	ctrlr_proportions (optional)	- The proportions the combo box ctrlr should use when added (defaults to one)
	tooltip (optional)				- A tooltip for the ctrlr
	styles (optional)				- Can be specified if a certain styles should be used (default is "CB_DROPDOWN,CB_READONLY")
	sorted (optional)				- If specified, the options table will be sorted before appended
	numbers (optional)				-- Will convert the value to a number
The function returns the ctrlr, name ctrlr and params (which now also contains the ctrlrs)
]]
function combobox( params )
	local name = params.name
	local panel = params.panel
	local sizer = params.sizer
	local default = params.default
	local options = params.options or {}
	local value = params.value or options[ 1 ]
	local name_proportions = params.name_proportions or 1
	local ctrlr_proportions = params.ctrlr_proportions or 1
	params.sizer_proportions = params.sizer_proportions or 0
	local tooltip = params.tooltip
	local styles = params.styles or "CB_DROPDOWN,CB_READONLY"
	local sorted = params.sorted
		
	local ctrl_sizer = EWS:BoxSizer( "HORIZONTAL" )

	local name_ctrlr
	if name then
		name_ctrlr = EWS:StaticText( panel, name, 0, "" )
		ctrl_sizer:add( name_ctrlr, name_proportions, 0, "ALIGN_CENTER_VERTICAL")
	end
		
	if sorted then
		table.sort( options )
	end
	
	local ctrlr = EWS:ComboBox( panel, "", "", styles )
	ctrlr:set_tool_tip( tooltip )
	
	ctrlr:freeze()
	
	if default then 
		ctrlr:append( default)
	end
	
	for _,option in ipairs( options ) do 
		ctrlr:append( option )
	end
	
	ctrlr:set_value( value )
	
	ctrlr:thaw()
	
	params.name_ctrlr = name_ctrlr
	params.ctrlr = ctrlr
		
	ctrl_sizer:add( ctrlr, ctrlr_proportions, 0, "EXPAND" )
	
	sizer:add( ctrl_sizer, params.sizer_proportions, 0, "EXPAND" )
	
	params.ctrlr:connect( "EVT_COMMAND_COMBOBOX_SELECTED", callback( nil, _M, "_set_combobox_value" ), params )
	
	_connect_events( params )
	return ctrlr, name_ctrlr, params
end

-- Private function to store the selected value made in a combobox
function _set_combobox_value( params )
	params.value = params.ctrlr:get_value()
	params.value = params.numbers and tonumber( params.value ) or params.value
end

-- Updates the availible options in a combobox. Call it with the params used to create it and a table
-- with the new options
function update_combobox_options( params, options )
	params.ctrlr:clear()
	if params.sorted then
		table.sort( options )
	end
	if params.default then 
		params.ctrlr:append( params.default)
	end
	for _,option in ipairs( options ) do 
		params.ctrlr:append( option )
	end
end

-- This function changes the set value of the combobox. Call it with the params used to create it and the new value
function change_combobox_value( params, value )
	params.value = value
	params.value = params.numbers and tonumber( params.value ) or params.value
	params.ctrlr:set_value( value )
end

--[[
slider_and_number_controller creates a slider and text ctrlr to handle numbers. The slider and text ctrlr
is updated when the other is used.
The function takes a table paramas containing:
	name (optional)					- Used if a StaticText ctrlr should be added to before the TextCtrlr
	panel (required)				- The parent panel to the ctrlr(s)
	sizer(required)					- The sizer the ctrlr(s) should be added to (to function actually creates a new sizer for the ctrlrs
						  			  and then adds that sizer to the params.sizer
	value (optional)				- The default value of the ctrlr (will default to zero if not given
	name_proportions (optional)		- The proportions the name ctrlr should use when added (defaults to one)
	ctrlr_proportions (optional)	- The proportions the text ctrlr should use when added (defaults to one)
	floats (optional)				- Specifies how many floats it should allow (defaults to zero)
	tooltip (optional)				- A tooltip for the ctrlr
	max (optional)					- If specified, the entered value will be clamped to this if above
	min (optional)					- If specified, the entered value will be clamped to this if below
The function returns params (which now also contains the ctrlrs)
]]
function slider_and_number_controller( params )
	params.value = params.value or 0
	params.name_proportions = params.name_proportions or 1
	params.ctrlr_proportions = params.ctrlr_proportions or 1
	params.slider_ctrlr_proportions = params.slider_ctrlr_proportions or 2
	params.number_ctrlr_proportions = params.number_ctrlr_proportions or 1
	params.floats = params.floats or 0
	params.slider_multiplier = math.pow( 10, params.floats )
	params.min = params.min or 0
	params.max = params.max or 10
	
	params.ctrl_sizer = EWS:BoxSizer( "HORIZONTAL" )
	
	_ctrlr_tooltip( params )
	_name_ctrlr( params )
	_number_ctrlr( params )
	_slider_ctrlr( params )
					
	params.number_ctrlr:connect( "EVT_COMMAND_TEXT_ENTER", callback( nil, _M, "update_slider_from_number" ), params )
	params.number_ctrlr:connect( "EVT_KILL_FOCUS", callback( nil, _M, "update_slider_from_number" ), params )
	
	params.slider_ctrlr:connect( "EVT_SCROLL_CHANGED", callback( nil, _M, "update_number_from_slider" ), params )
	params.slider_ctrlr:connect( "EVT_SCROLL_THUMBTRACK", callback( nil, _M, "update_number_from_slider" ), params )
	
	local ctrl_sizer2 = EWS:BoxSizer( "HORIZONTAL" )
		ctrl_sizer2:add( params.slider_ctrlr, params.slider_ctrlr_proportions, 0, "ALIGN_CENTER_VERTICAL" )
		ctrl_sizer2:add( params.number_ctrlr, params.number_ctrlr_proportions, 0, "EXPAND" )
	params.ctrl_sizer:add( ctrl_sizer2, params.ctrlr_proportions, 0, "EXPAND" )
	
	params.sizer:add( params.ctrl_sizer, params.sizer_proportions or 0, 0, "EXPAND" )
		
	-- _connect_events( params )
	return params
end

-- Private function to create the tooltip based on min and max values for sliders and number controllers
function _ctrlr_tooltip( params )
	local max = params.max
	local min = params.min
	if min and max then
		params.tooltip = (params.tooltip or "").." (Between "..string.format( "%."..params.floats.."f", min ).." and "..string.format( "%."..params.floats.."f", max )..")"
	elseif min then
		params.tooltip = (params.tooltip or "").." (Above "..string.format( "%."..params.floats.."f", min )..")"
	elseif max then
		params.tooltip = (params.tooltip or "").." (Below "..string.format( "%."..params.floats.."f", max )..")"
	end
end

-- Private function to create a slider controller and set tool tip
function _slider_ctrlr( params )
	params.slider_ctrlr = EWS:Slider( params.panel, params.value * params.slider_multiplier, params.min * params.slider_multiplier, params.max * params.slider_multiplier, "", "")
	params.slider_ctrlr:set_tool_tip( params.tooltip )
end

-- Private function to create a text controller for numbers and connect the events for verifying correct input
function _number_ctrlr( params )
	if CoreClass.type_name( params.value ) ~= "number" then
		params.value = params.min or 0
	end 
	params.number_ctrlr = EWS:TextCtrl( params.panel, string.format( "%."..params.floats.."f", params.value ), "", "TE_PROCESS_ENTER" )
	params.number_ctrlr:set_tool_tip( params.tooltip )
	
	params.number_ctrlr:connect( "EVT_CHAR", callback( nil, _G, "verify_number" ), params.number_ctrlr )
	params.number_ctrlr:connect( "EVT_COMMAND_TEXT_ENTER", callback( nil, _M, "verify_entered_number" ), params )
	params.number_ctrlr:connect( "EVT_KILL_FOCUS", callback( nil, _M, "verify_entered_number" ), params )
end

-- Private function to create a name controller
function _name_ctrlr( params )
	if params.name then
		params.name_ctrlr = EWS:StaticText( params.panel, params.name, 0, "" )
		params.ctrl_sizer:add( params.name_ctrlr, params.name_proportions, 0, "ALIGN_CENTER_VERTICAL")
	end
end

-- verify_entered_number is used by number_controller to verify the entered value and
-- match it to specified params.
function verify_entered_number( params )
	local ctrlr = params.ctrlr or params.number_ctrlr
	local value = tonumber( ctrlr:get_value() ) or 0
	value = params.min and value < params.min and params.min or value
	value = params.max and value > params.max and params.max or value
	params.value = value
	local floats = params.floats or 0
	ctrlr:change_value( string.format( "%."..floats.."f", value ) )
	ctrlr:set_selection( -1, -1 )
end

function update_slider_from_number( params )
	params.slider_ctrlr:set_value( params.value * params.slider_multiplier )
end

function update_number_from_slider( params )
	params.value = params.slider_ctrlr:get_value() / params.slider_multiplier
	change_entered_number( params, params.value )
end
