CoreUnitTestBrowser = CoreUnitTestBrowser or class()
function CoreUnitTestBrowser:init()
	self._unit_msg = {}
	self._ignore_list = {}
	self._report_xml = File:parse_xml("/unit_test_results.xml")
	if self._report_xml then
		self:error_frame()
		self:init_tree_view()
	end

end

function CoreUnitTestBrowser:error_frame()
	self._error_frame = EWS:Frame("Unit Test Browser", Vector3(100, 400, 0), Vector3(500, 500, 0), "FRAME_FLOAT_ON_PARENT,DEFAULT_FRAME_STYLE", Global.frame)
	local menu_bar = EWS:MenuBar()
	local file_menu = EWS:Menu("")
	file_menu:append_item("EMAILS", "Send E-Mails", "")
	file_menu:append_item("EMAILS_TO", "Send E-Mails To", "")
	file_menu:append_separator()
	file_menu:append_item("EXIT", "Exit", "")
	menu_bar:append(file_menu, "File")
	local ignore_menu = EWS:Menu("")
	ignore_menu:append_item("IGNORE_ALL", "All", "")
	ignore_menu:append_item("IGNORE_NONE", "None", "")
	menu_bar:append(ignore_menu, "Ignore")
	local search_menu = EWS:Menu("")
	search_menu:append_item("FINDUNIT", "Find Unit", "")
	menu_bar:append(search_menu, "Search")
	self._error_frame:set_menu_bar(menu_bar)
	self._error_frame:connect("EMAILS", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "on_send_emails"), "")
	self._error_frame:connect("EMAILS_TO", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "on_send_emails_to"), "")
	self._error_frame:connect("EXIT", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "on_close"), "")
	self._error_frame:connect("IGNORE_ALL", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "on_ignore_all"), "")
	self._error_frame:connect("IGNORE_NONE", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "on_ignore_none"), "")
	self._error_frame:connect("FINDUNIT", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "on_find_unit"), "")
	self._error_frame:connect("", "EVT_CLOSE_WINDOW", callback(self, self, "on_close"), "")
	local error_box = EWS:BoxSizer("VERTICAL")
	self._error_box = {}
	self._error_box.tree_ctrl = EWS:TreeCtrl(self._error_frame, "", "")
	self._error_box.tree_ctrl:connect("", "EVT_COMMAND_TREE_SEL_CHANGED", callback(self, self, "on_tree_ctrl_change"), "")
	self._error_box.tree_ctrl:connect("", "EVT_RIGHT_UP", callback(self, self, "on_popup"), "")
	error_box:add(self._error_box.tree_ctrl, 2, 0, "EXPAND")
	self._error_box.text_ctrl = EWS:TextCtrl(self._error_frame, "", "", "TE_MULTILINE")
	error_box:add(self._error_box.text_ctrl, 1, 0, "EXPAND")
	self._warning_mail_dialog = EWS:MessageDialog(self._error_frame, "This will send a e-mail to all non-ignored authors. Do not proceed unless you are authorized. Proceed?", "WARNING", "")
	self._warning_mail_admin_dialog = EWS:MessageDialog(self._error_frame, "This will send a e-mail to viktor@grin.se, andreas.jonsson@grin.se and perj@grin.se. Do not proceed unless you are authorized. Proceed?", "WARNING", "")
	self._receiver_dialog = CoreUnitTestBrowserInputDialog:new(self)
	self._error_frame:set_sizer(error_box)
	self._error_frame:set_visible(true)
end

function CoreUnitTestBrowser:search_frame()
	self._search_frame = EWS:Frame("Search Unit", Vector3(100, 400, 0), Vector3(250, 350, 0), "")
	self._search_frame:connect("", "EVT_CLOSE_WINDOW", callback(self, self, "on_close_search"), "")
	local search_box = EWS:BoxSizer("VERTICAL")
	local top_search_box = EWS:BoxSizer("HORIZONTAL")
	self._search_box = {}
	self._search_box.type_combobox = EWS:ComboBox(self._search_frame, "", "", "CB_READONLY")
	self._search_box.type_combobox:connect("", "EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "on_search"), "")
	self._search_box.type_combobox:append("Search By Author")
	self._search_box.type_combobox:append("Search By Name")
	self._search_box.type_combobox:append("Search By Diesel Path")
	self._search_box.type_combobox:set_value("Search By Author")
	search_box:add(self._search_box.type_combobox, 0, 0, "EXPAND")
	self._search_box.search_text_ctrl = EWS:TextCtrl(self._search_frame, "", "", "")
	self._search_box.search_text_ctrl:connect("", "EVT_COMMAND_TEXT_UPDATED", callback(self, self, "on_search"), "")
	top_search_box:add(self._search_box.search_text_ctrl, 1, 0, "EXPAND")
	search_box:add(top_search_box, 0, 0, "EXPAND")
	self._search_box.list_box = EWS:ListBox(self._search_frame, "", "")
	self._search_box.list_box:connect("", "EVT_COMMAND_LISTBOX_SELECTED", callback(self, self, "on_listbox_selected"), "")
	self._search_box.list_box:connect("", "EVT_RIGHT_UP", callback(self, self, "on_popup"), "")
	search_box:add(self._search_box.list_box, 1, 0, "EXPAND")
	self._search_frame:set_sizer(search_box)
	self._search_frame:set_visible(true)
end

function CoreUnitTestBrowser:set_position(newpos)
	self._error_frame:set_position(newpos)
end

function CoreUnitTestBrowser:update(t, dt)
end

function CoreUnitTestBrowser:on_popup()
-- fail 22
null
10
-- fail 16
null
5
-- fail 53
null
10
	local selected_item = self._error_box.tree_ctrl:selected_item()
	if selected_item > -1 then
		local found = false
		do
			local (for generator), (for state), (for control) = ipairs(self._error_box.tree_ctrl:get_children(self._failed_id))
			do
				do break end
				if id == selected_item then
					do
						local (for generator), (for state), (for control) = ipairs(self._ignore_list)
						do
							do break end
							if ignore_id == selected_item then
								self:include_popup()
								found = true
						end

						else
						end

					end

					do break end
					self:ignore_popup()
			end

			else
			end

		end

		do break end
		local (for generator), (for state), (for control) = ipairs(self._error_box.tree_ctrl:get_children(self._critical_id))
		do
			do break end
			if id == selected_item then
				do
					local (for generator), (for state), (for control) = ipairs(self._ignore_list)
					do
						do break end
						if ignore_id == selected_item then
							self:include_popup(true)
							found = true
					end

					else
					end

				end

				do break end
				self:ignore_popup(true)
		end

		else
		end

	end

end

function CoreUnitTestBrowser:ignore_popup(critical)
	local popup = EWS:Menu("")
	popup:append_item("IGNORE", "Ignore", "")
	popup:connect("IGNORE", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "on_ignore"), critical)
	self._error_frame:popup_menu(popup, Vector3(-1, -1, 0))
end

function CoreUnitTestBrowser:include_popup(critical)
	local popup = EWS:Menu("")
	popup:append_item("INCLUDE", "Include", "")
	popup:connect("INCLUDE", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "on_include"), critical)
	self._error_frame:popup_menu(popup, Vector3(-1, -1, 0))
end

function CoreUnitTestBrowser:on_ignore(custom_data, event)
	local id = self._error_box.tree_ctrl:selected_item()
	if custom_data then
		self._error_box.tree_ctrl:set_item_text_colour(id, Vector3(1, 1, 1))
		self._error_box.tree_ctrl:set_item_background_colour(id, Vector3(1, 0, 0))
	else
		self._error_box.tree_ctrl:set_item_text_colour(id, Vector3(1, 1, 1))
		self._error_box.tree_ctrl:set_item_background_colour(id, Vector3(0.5, 0, 0))
	end

	table.insert(self._ignore_list, id)
end

function CoreUnitTestBrowser:on_include(custom_data, event)
	local id = self._error_box.tree_ctrl:selected_item()
	if custom_data then
		self._error_box.tree_ctrl:set_item_text_colour(id, Vector3(1, 0, 0))
		self._error_box.tree_ctrl:set_item_background_colour(id, Vector3(1, 1, 1))
	else
		self._error_box.tree_ctrl:set_item_text_colour(id, Vector3(0.5, 0, 0))
		self._error_box.tree_ctrl:set_item_background_colour(id, Vector3(1, 1, 1))
	end

	table.delete(self._ignore_list, id)
end

function CoreUnitTestBrowser:on_ignore_all()
-- fail 14
null
9
-- fail 62
null
9
	do
		local (for generator), (for state), (for control) = ipairs(self._error_box.tree_ctrl:get_children(self._failed_id))
		do
			do break end
			local found = false
			do
				local (for generator), (for state), (for control) = ipairs(self._ignore_list)
				do
					do break end
					if ignore_id == id then
						found = true
				end

				else
				end

			end

			do break end
			self._error_box.tree_ctrl:set_item_text_colour(id, Vector3(1, 1, 1))
			self._error_box.tree_ctrl:set_item_background_colour(id, Vector3(0.5, 0, 0))
			table.insert(self._ignore_list, id)
		end

	end

	(for control) = self._error_box.tree_ctrl:get_children(self._failed_id) and false
	local (for generator), (for state), (for control) = ipairs(self._error_box.tree_ctrl:get_children(self._critical_id))
	do
		do break end
		local found = false
		do
			local (for generator), (for state), (for control) = ipairs(self._ignore_list)
			do
				do break end
				if ignore_id == id then
					found = true
			end

			else
			end

		end

		do break end
		self._error_box.tree_ctrl:set_item_text_colour(id, Vector3(1, 1, 1))
		self._error_box.tree_ctrl:set_item_background_colour(id, Vector3(1, 0, 0))
		table.insert(self._ignore_list, id)
	end

end

function CoreUnitTestBrowser:on_ignore_none()
-- fail 18
null
9
-- fail 54
null
9
