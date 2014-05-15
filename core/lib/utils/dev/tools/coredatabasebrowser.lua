CoreDBDialog = CoreDBDialog or class()
function CoreDBDialog:init(type_to_pick, cb_self, cb, db)
	self._browser_data = {}
	self._browser_data.type_to_pick = type_to_pick
	self._browser_data.cb = cb
	self._browser_data.cb_self = cb_self
	self._window = CoreDatabaseBrowser:new(self._browser_data, db)
end

function CoreDBDialog:update(t, dt)
	if self._window then
		self._window:update(t, dt)
	end

	if self._browser_data.destroy == "OK" then
		self._window = nil
		if self._browser_data.cb then
			self._browser_data.cb(self._browser_data.cb_self)
		end

		return "OK"
	elseif self._browser_data.destroy then
		self._window = nil
		return "CANCEL"
	end

end

function CoreDBDialog:get_value()
	return self._browser_data.entry
end

function CoreDBDialog:destroy()
	if self._window then
		self._window:close()
	end

end

CoreDatabaseBrowser = CoreDatabaseBrowser or class()
CoreDatabaseBrowser.LC_BUGFIX = true
function CoreDatabaseBrowser:init(browser_data, db)
	min_exe_version("1.0.0.7607", "CoreDatabaseBrowser")
	self._active_database = db or ProjectDatabase
	self._browser_data = browser_data
	self:create_main_frame()
	self:on_reload()
	if Application:vista_userfolder_enabled() then
		EWS:MessageDialog(self._main_frame, "You cannot commit or edit files when the vista user folder is enabled. Run the database browser from the editor instead.", "Error", "OK,ICON_ERROR"):show_modal()
		managers.toolhub:close("Database Browser")
	end

	self._dirty_flag = true
	self:check_news(true)
end

function CoreDatabaseBrowser:check_open()
	if open_editor and not self._browser_data then
		local frame = EWS:Frame("", Vector3(0, 0, 0), Vector3(0, 0, 0), "")
		EWS:MessageDialog(frame, "Please close the " .. open_editor .. " before open this editor.", "Conflict", "OK,ICON_INFORMATION"):show_modal()
		frame:destroy()
		managers.toolhub:close("Unit Editor")
		return true
	else
		open_editor = "Unit Editor"
	end

	return false
end

function CoreDatabaseBrowser:create_main_frame()
	local style = "FRAME_FLOAT_ON_PARENT,DEFAULT_FRAME_STYLE"
	if self._browser_data then
		style = "FRAME_FLOAT_ON_PARENT,FRAME_TOOL_WINDOW,CAPTION"
	end

	self._main_frame = EWS:Frame("Database Browser", Vector3(100, 400, 0), Vector3(500, 500, 0), style, Global.frame)
	self._main_frame:set_icon(CoreEWS.image_path("database_browser_16x16.png"))
	local menu_bar = EWS:MenuBar()
	local file_menu = EWS:Menu("")
	file_menu:append_item("MOVE", "Move\tCtrl+M", "")
	file_menu:append_item("RELOAD", "Reload\tCtrl+L", "")
	file_menu:append_item("REMOVE", "Remove\tCtrl+R", "")
	file_menu:append_item("RENAME", "Rename\tCtrl+N", "")
	file_menu:append_item("IMPORT", "Import XML", "")
	file_menu:append_item("VIEW_METADATA", "View Metadata", "")
	file_menu:append_item("METADATA", "Set Metadata", "")
	file_menu:append_separator()
	file_menu:append_item("NEWS", "Get Latest News", "")
	file_menu:append_separator()
	file_menu:append_item("EXIT", "Exit", "")
	menu_bar:append(file_menu, "File")
	if not self._browser_data then
		self._db_menu = EWS:Menu("")
		self._db_menu:append_radio_item("DB_PROJECT", "Project", "")
		self._db_menu:append_radio_item("DB_CORE", "Core", "")
		self._db_menu:set_checked("DB_PROJECT", true)
		menu_bar:append(self._db_menu, "Database")
	end

	self._op_menu = EWS:Menu("")
	self._op_menu:append_check_item("OP_AUTO_CONVERT_TEXTURES", "Auto Convert Textures", "")
	self._op_menu:set_checked("OP_AUTO_CONVERT_TEXTURES", true)
	menu_bar:append(self._op_menu, "Options")
	self._main_frame:set_menu_bar(menu_bar)
	self._main_frame:connect("MOVE", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "on_move"), "")
	self._main_frame:connect("RELOAD", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "on_reload"), "")
	self._main_frame:connect("REMOVE", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "on_remove"), "")
	self._main_frame:connect("RENAME", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "on_rename"), "")
	self._main_frame:connect("IMPORT", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "on_import_xml"), "")
	self._main_frame:connect("METADATA", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "on_set_metadata"), "")
	self._main_frame:connect("VIEW_METADATA", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "on_view_metadata"), "")
	self._main_frame:connect("NEWS", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "on_check_news"), "")
	self._main_frame:connect("EXIT", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "on_close"), "")
	self._main_frame:connect("DB_PROJECT", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "on_set_db"), ProjectDatabase)
	self._main_frame:connect("DB_CORE", "EVT_COMMAND_MENU_SELECTED", callback(self, self, "on_set_db"), CoreDatabase)
	self._main_frame:connect("", "EVT_CLOSE_WINDOW", callback(self, self, "on_close"), "")
	local main_box = EWS:BoxSizer("VERTICAL")
	self._main_notebook = EWS:Notebook(self._main_frame, "", "")
	self._main_notebook:connect("", "EVT_COMMAND_NOTEBOOK_PAGE_CHANGING", callback(self, self, "on_notebook_changing"), "")
	main_box:add(self._main_notebook, 2, 0, "EXPAND")
	self._search_box = {}
	self._search_box.panel = EWS:Panel(self._main_notebook, "", "")
	self._search_box.panel_box = EWS:BoxSizer("VERTICAL")
	local top_search_box = EWS:BoxSizer("HORIZONTAL")
	self._search_box.type_combobox = EWS:ComboBox(self._search_box.panel, "", "", "CB_READONLY,CB_SORT")
	self._search_box.type_combobox:connect("", "EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "on_read_database"), "")
	self:append_all_types(self._search_box.type_combobox)
	self._search_box.type_combobox:append("[all]")
	top_search_box:add(self._search_box.type_combobox, 1, 0, "EXPAND")
	self._search_box.search_text_ctrl = EWS:TextCtrl(self._search_box.panel, "", "", "TE_CENTRE")
	self._search_box.search_text_ctrl:connect("", "EVT_COMMAND_TEXT_UPDATED", callback(self, self, "on_search"), "")
	top_search_box:add(self._search_box.search_text_ctrl, 2, 0, "EXPAND")
	self._search_box.panel_box:add(top_search_box, 0, 0, "EXPAND")
	self._search_box.list_box = EWS:ListBox(self._search_box.panel, "", "LB_SORT,LB_EXTENDED")
	self._search_box.list_box:connect("", "EVT_COMMAND_LISTBOX_SELECTED", callback(self, self, "on_select"), "")
	if self._browser_data then
		self._search_box.list_box:connect("", "EVT_COMMAND_LISTBOX_DOUBLECLICKED", callback(self, self, "on_close"), "OK")
	end

	self._search_box.panel_box:add(self._search_box.list_box, 2, 0, "EXPAND")
	self._search_box.panel:set_sizer(self._search_box.panel_box)
	self._main_notebook:add_page(self._search_box.panel, "Search View", true)
	self._tree_box = {}
	self._tree_box.panel = EWS:Panel(self._main_notebook, "", "")
	self._tree_box.panel_box = EWS:BoxSizer("VERTICAL")
	local top_search_box = EWS:BoxSizer("HORIZONTAL")
	self._tree_box.type_combobox = EWS:ComboBox(self._tree_box.panel, "", "", "CB_READONLY,CB_SORT")
	self._tree_box.type_combobox:connect("", "EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "on_read_database"), "")
	self:append_all_types(self._tree_box.type_combobox)
	self._tree_box.type_combobox:append("[all]")
	top_search_box:add(self._tree_box.type_combobox, 1, 0, "EXPAND")
	self._tree_box.search_text_ctrl = EWS:TextCtrl(self._tree_box.panel, "", "", "TE_CENTRE")
	self._tree_box.search_text_ctrl:connect("", "EVT_COMMAND_TEXT_UPDATED", callback(self, self, "on_search"), "")
	top_search_box:add(self._tree_box.search_text_ctrl, 2, 0, "EXPAND")
	self._tree_box.panel_box:add(top_search_box, 0, 0, "EXPAND")
	self._tree_box.tree_ctrl = EWS:TreeCtrl(self._tree_box.panel, "", "TR_MULTIPLE,TR_HAS_BUTTONS")
	self._tree_box.tree_ctrl:connect("", "EVT_COMMAND_TREE_SEL_CHANGED", callback(self, self, "on_tree_ctrl_change"), "")
	if self._browser_data then
		self._tree_box.tree_ctrl:connect("", "EVT_COMMAND_TREE_ITEM_ACTIVATED", callback(self, self, "on_close"), "OK")
	end

	self._tree_box.panel_box:add(self._tree_box.tree_ctrl, 2, 0, "EXPAND")
	self._tree_box.panel:set_sizer(self._tree_box.panel_box)
	self._main_notebook:add_page(self._tree_box.panel, "Tree View", false)
	self._local_box = {}
	self._local_box.panel = EWS:Panel(self._main_notebook, "", "")
	self._local_box.panel_box = EWS:BoxSizer("VERTICAL")
	local top_local_box = EWS:BoxSizer("HORIZONTAL")
	self._local_box.type_combobox = EWS:ComboBox(self._local_box.panel, "", "", "CB_READONLY,CB_SORT")
	self._local_box.type_combobox:connect("", "EVT_COMMAND_COMBOBOX_SELECTED", callback(self, self, "on_read_database"), "")
	self:append_all_types(self._local_box.type_combobox)
	self._local_box.type_combobox:append("[all]")
	self._local_box.type_combobox:set_value("[all]")
	top_local_box:add(self._local_box.type_combobox, 1, 0, "EXPAND")
	self._local_box.search_text_ctrl = EWS:TextCtrl(self._local_box.panel, "", "", "TE_CENTRE")
	self._local_box.search_text_ctrl:connect("", "EVT_COMMAND_TEXT_UPDATED", callback(self, self, "on_search_local_changes"), "")
	top_local_box:add(self._local_box.search_text_ctrl, 2, 0, "EXPAND")
	self._local_box.panel_box:add(top_local_box, 0, 0, "EXPAND")
	self._local_box.list_box = EWS:ListBox(self._local_box.panel, "", "LB_SORT,LB_EXTENDED")
	self._local_box.list_box:connect("", "EVT_COMMAND_LISTBOX_SELECTED", callback(self, self, "on_select"), "")
	self:append_local_changes()
	self._local_box.panel_box:add(self._local_box.list_box, 2, 0, "EXPAND")
	local bottom_local_box = EWS:BoxSizer("HORIZONTAL")
	self._local_box.commit_btn = EWS:Button(self._local_box.panel, "Commit", "", "")
	self._local_box.commit_btn:connect("", "EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_commit_btn"), "")
	bottom_local_box:add(self._local_box.commit_btn, 1, 0, "EXPAND")
	self._local_box.revert_btn = EWS:Button(self._local_box.panel, "Revert", "", "")
	self._local_box.revert_btn:connect("", "EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_revert_btn"), "")
	bottom_local_box:add(self._local_box.revert_btn, 1, 0, "EXPAND")
	self._local_box.panel_box:add(bottom_local_box, 0, 0, "EXPAND")
	self._local_box.panel:set_sizer(self._local_box.panel_box)
	if not self._browser_data then
		self._main_notebook:add_page(self._local_box.panel, "Local Changes", false)
	else
		self._local_box.panel:set_visible(false)
	end

	self._preview_panel = EWS:Panel(self._main_frame, "", "")
	local text_box = EWS:BoxSizer("VERTICAL")
	local msg = EWS:StaticText(self._preview_panel, "No preview!", "", "ALIGN_CENTER_VERTICAL")
	text_box:add(msg, 1, 4, "EXPAND,ALL")
	self._preview_panel:set_sizer(text_box)
	main_box:add(self._preview_panel, 1, 0, "EXPAND")
	self._preview_text_ctrl = CoreEWS:XMLTextCtrl(self._main_frame, nil, nil, nil, "TE_MULTILINE,TE_RICH2,TE_DONTWRAP,TE_READONLY")
	self._preview_text_ctrl:text_ctrl():set_visible(false)
	main_box:add(self._preview_text_ctrl:text_ctrl(), 1, 0, "EXPAND")
	self._preview_image = EWS:BitmapButton(self._main_frame, CoreEWS.image_path("magnifying_glass_32x32.png"), "", "")
	self._preview_image:set_visible(false)
	main_box:add(self._preview_image, 1, 0, "EXPAND")
	if self._browser_data then
		local button_box = EWS:BoxSizer("HORIZONTAL")
		self._ok_btn = EWS:Button(self._main_frame, "OK", "", "")
		self._ok_btn:connect("", "EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_close"), "OK")
		button_box:add(self._ok_btn, 1, 0, "EXPAND")
		self._cancel_btn = EWS:Button(self._main_frame, "Cancel", "", "")
		self._cancel_btn:connect("", "EVT_COMMAND_BUTTON_CLICKED", callback(self, self, "on_close"), "")
		button_box:add(self._cancel_btn, 1, 0, "EXPAND")
		main_box:add(button_box, 0, 0, "EXPAND")
	end

	self._open_xml_file_dialog = EWS:FileDialog(self._main_frame, "Import XML", Application:base_path(), "", "XML files (*.xml)|*.xml", "OPEN,FILE_MUST_EXIST")
	self._remove_dialog = EWS:MessageDialog(self._main_frame, "This will delete the selected entry(s). Proceed?", "Remove", "YES_NO,ICON_QUESTION")
	self._invalid_path_dialog = EWS:MessageDialog(self._main_frame, "The path you have chosen is invalid!", "Error", "OK,ICON_ERROR")
	self._revert_dialog = EWS:MessageDialog(self._main_frame, "Do you want to revert the selected entry(s)?", "Revert", "YES_NO,ICON_QUESTION")
	self._commit_dialog = EWS:MessageDialog(self._main_frame, "Do you want to commit the selected entry(s)?", "Commit", "YES_NO,ICON_QUESTION")
	self._not_available_dialog = EWS:MessageDialog(self._main_frame, "This option is not available in this mode.", "Unavailable", "OK,ICON_INFORMATION")
	self._dirty_database_dialog = EWS:MessageDialog(self._main_frame, "The database is dirty and it needs to be reloaded.", "Database", "OK,ICON_INFORMATION")
	self._rename_error_dialog = EWS:MessageDialog(self._main_frame, "Duplicated entry!", "Error", "OK,ICON_ERROR")
	self._commit_error_dialog = EWS:MessageDialog(self._main_frame, "Could not commit the selected entry(s)!", "Error", "OK,ICON_ERROR")
	self._no_nodes_dialog = EWS:MessageDialog(self._main_frame, "You need to have at least one node in your XML file.", "Error", "OK,ICON_ERROR")
	self._move_dialog = CoreDatabaseBrowserMoveDialog:new(self, self._main_frame)
	self._import_dialog = CoreDatabaseBrowserImportDialog:new(self, self._main_frame)
	self._metadata_dialog = CoreDatabaseBrowserMetadataDialog:new(self._main_frame)
	self._comment_dialog = CoreDatabaseBrowserInputDialog:new(self._main_frame)
	self._rename_dialog = CoreDatabaseBrowserRenameDialog:new(self._main_frame)
	self._main_frame:set_sizer(main_box)
	self._main_frame:set_visible(true)
end

function CoreDatabaseBrowser:on_set_db(data, event)
	self._db_menu:set_checked("DB_PROJECT", false)
	self._db_menu:set_checked("DB_CORE", false)
	self._db_menu:set_checked(event:get_id(), true)
	self._active_database = data
	self:on_read_database()
end

function CoreDatabaseBrowser:on_check_news()
	self:check_news()
end

function CoreDatabaseBrowser:check_news(new_only)
-- fail 25
null
6
	local news
	if new_only then
		news = managers.news:get_news("database_browser", self._main_frame)
	else
		news = managers.news:get_old_news("database_browser", self._main_frame)
	end

	if news then
		local str
		do
			local (for generator), (for state), (for control) = ipairs(news)
			do
				do break end
				if not str then
					str = n
				else
					str = str .. "\n" .. n
				end

			end

		end

		EWS:MessageDialog(self._main_frame, str, "New Features!", "OK,ICON_INFORMATION"):show_modal()
	end

end

function CoreDatabaseBrowser:on_dirty_entrys()
	if self._dirty_flag then
		cat_print("debug", "The database is dirty and it needs to be reloaded. RELOADING!")
	end

	self:on_reload()
	self._dirty_flag = true
end

function CoreDatabaseBrowser:on_search_local_changes()
	self:append_local_changes()
end

function CoreDatabaseBrowser:filter_local_changes(entry)
	return string.find(entry:name(), self._local_box.search_text_ctrl:get_value()) ~= nil
end

function CoreDatabaseBrowser:append_local_changes()
	local db_changes = self._active_database:local_changes()
	local change_table = {}
	self._local_changes = {}
	self._local_box.list_box:clear()
	do
		local (for generator), (for state), (for control) = ipairs(db_changes)
		do
			do break end
			if (self._local_box.type_combobox:get_value() == "[all]" or self._local_box.type_combobox:get_value() == change.entry:type()) and self:filter_local_changes(change.entry) then
				local describe = self:create_unique_name(change.entry)
				if not change_table[describe] then
					change_table[describe] = {}
				end

				if not change_table[describe].str then
					change_table[describe].str = change.change
				else
					change_table[describe].str = change_table[describe].str .. " : " .. change.change
				end

				change_table[describe].entry = change.entry
				if change.change == "REMOVE" then
					change_table[describe].change = "REMOVE"
				elseif (not change_table[describe].change or change.change == "SET_METADATA") and (change.change == "ADD" or change.change == "MODIFY") then
					change_table[describe].change = "ADD_OR_MODIFY"
				elseif not change_table[describe].change and change.change == "SET_METADATA" then
					change_table[describe].change = "SET_METADATA"
				end

			end

		end

	end

	(for control) = nil and self._local_box
	local (for generator), (for state), (for control) = pairs(change_table)
	do
		do break end
		local str = describe .. " - " .. struct.str
		self._local_changes[str] = struct
		self._local_box.list_box:append(str)
	end

end

function CoreDatabaseBrowser:format_comment(str)
	local comment = ""
	do
		local (for generator), (for state), (for control) = string.gmatch(str, "[%w%s_]+")
		do
			do break end
			comment = comment .. word
		end

	end

end

function CoreDatabaseBrowser:is_entry_raw(entry)
	return entry:property("platform") == "raw" or entry:property("platform") == "ps3raw" or entry:property("platform") == "x360raw"
end

function CoreDatabaseBrowser:on_commit_btn()
	local conversion_dialog = self._op_menu:is_checked("OP_AUTO_CONVERT_TEXTURES") and EWS:MessageDialog(self._main_frame, "The Image Exporter Tool will try to convert this texture(s) for all other platforms.", "Conversion", "OK,ICON_INFORMATION") or nil
	if #self._local_box.list_box:selected_indices() > 0 and self._commit_dialog:show_modal() == "ID_YES" and self._comment_dialog:show_modal() then
		local comment = self:format_comment(self._comment_dialog:get_value())
		local commit_table = {}
		local progress = EWS:ProgressDialog(self._main_frame, "Commit", "", 100, "PD_AUTO_HIDE,PD_SMOOTH")
		do
			local (for generator), (for state), (for control) = ipairs(self._local_box.list_box:selected_indices())
			do
				do break end
				commit_table[tostring(id)] = self._local_box.list_box:get_string(id)
				progress:update_bar(10)
			end

		end

		local new_entrys = {}
		local i = self._local_box.list_box:selected_indices() and 1
		do
			local (for generator), (for state), (for control) = pairs(commit_table)
			do
				do break end
				if not self._local_changes[entry] then
					cat_print("debug", "############# commit_table #############")
					do
						local (for generator), (for state), (for control) = pairs(commit_table)
						do
							do break end
							cat_print("debug", id_str, entry)
						end

					end

					(for control) = self._local_box.list_box:selected_indices() and cat_print
					cat_print("debug", "############# self._local_changes #############")
					do
						local (for generator), (for state), (for control) = pairs(self._local_changes)
						do
							do break end
							cat_print("debug", k, v)
						end

					end

					(for control) = self._local_box.list_box:selected_indices() and cat_print
					cat_print("debug", "############# self._local_box.list_box:selected_indices() #############")
					do
						local (for generator), (for state), (for control) = ipairs(self._local_box.list_box:selected_indices())
						do
							do break end
							cat_print("debug", id, self._local_box.list_box:get_string(id))
						end

					end

					(for control) = self._local_box.list_box:selected_indices() and cat_print
					cat_print("debug", "############# new_entrys #############")
					do
						local (for generator), (for state), (for control) = ipairs(new_entrys)
						do
							do break end
							cat_print("debug", k, v)
						end

					end

					(for control) = self._local_box.list_box:selected_indices() and cat_print
					cat_print("debug", "############# failing entry #############")
					cat_print("debug", entry)
					cat_print("debug", "LC_BUGFIX: ", self.LC_BUGFIX)
					cat_print("debug", "failing entry index: ", i)
					error("REPORT THIS BUG TO: andreas.jonsson@grin.se (Send the entire log!)")
				end

				if self._local_changes[entry].change == "ADD_OR_MODIFY" and self._local_changes[entry].entry:type() == "texture" and (self:is_entry_raw(self._local_changes[entry].entry) or self._local_changes[entry].entry:property("platform") == "") then
					conversion_dialog = conversion_dialog and nil
					progress:update_bar(30, "Converting 3DC...")
					if not self.LC_BUGFIX then
						self:append_local_changes()
					end

					local x360_entry = self:convert_to_x360(self._local_changes[entry].entry)
					if x360_entry and x360_entry:valid() then
						table.insert(new_entrys, x360_entry)
					end

					progress:update_bar(50, "Converting GTF...")
					if not self.LC_BUGFIX then
						self:append_local_changes()
					end

					local ps3_entry = self:convert_to_ps3(self._local_changes[entry].entry)
					if ps3_entry and ps3_entry:valid() then
						table.insert(new_entrys, ps3_entry)
					end

					if not self.LC_BUGFIX then
						self:append_local_changes()
					end

				end

				i = i + 1
			end

		end

		(for control) = progress.update_bar and self._local_changes
		do
			local (for generator), (for state), (for control) = pairs(commit_table)
			do
				do break end
				progress:update_bar(70, "Sending data...")
				table.insert(new_entrys, self._local_changes[entry].entry)
			end

		end

		self._dirty_flag = false
		local commit_ret = progress.update_bar and nil
		while not commit_ret do
			commit_ret = self._active_database:commit_changes("[CoreDatabaseBrowser] " .. comment, new_entrys)
			if commit_ret == "LOCKED" then
				if EWS:message_box(self._main_frame, "The index is locked by another user... Do you want to retry?", "Retry", "YES_NO,ICON_QUESTION", Vector3(-1, -1, -1)) == "YES" then
					commit_ret = nil
				end

			elseif commit_ret == "FATAL" then
				EWS:message_box(self._main_frame, "A fatal error during commit occurred. (This could be caused by a connection problem.) Contact technical support!", "Fatal Error", "OK,ICON_ERROR", Vector3(-1, -1, -1))
			end

		end

		if commit_ret ~= "SUCCESS" then
			progress:update_bar(100)
			self._commit_error_dialog:show_modal()
		else
			progress:update_bar(100)
			EWS:MessageDialog(self._main_frame, "Success! You now need to close down the application and update your project.", "Success", "OK,ICON_INFORMATION"):show_modal()
		end

		self._active_database:load()
		self:on_read_database()
		self:append_local_changes()
	end

end

function CoreDatabaseBrowser:on_revert_btn()
-- fail 51
null
6
	if #self._local_box.list_box:selected_indices() > 0 and self._revert_dialog:show_modal() == "ID_YES" then
		local flag
		local revert_table = {}
		local progress = EWS:ProgressDialog(self._main_frame, "Revert", "Reverting data...", 100, "PD_AUTO_HIDE,PD_SMOOTH")
		progress:update_bar(0)
		do
			local (for generator), (for state), (for control) = ipairs(self._local_box.list_box:selected_indices())
			do
				do break end
				revert_table[tostring(id)] = self._local_box.list_box:get_string(id)
			end

		end

		(for control) = self._local_box.list_box:selected_indices() and tostring
		progress:update_bar(50)
		do
			local (for generator), (for state), (for control) = pairs(revert_table)
			do
				do break end
				self._dirty_flag = false
				if not self._active_database:revert_changes(self._local_changes[entry].entry) then
					self:append_local_changes()
					flag = true
				else
					self:append_local_changes()
				end

			end

		end

		do break end
		EWS:MessageDialog(self._main_frame, "Could not revert the selected entry(s)!", "Error", "OK,ICON_ERROR"):show_modal()
		self._active_database:load()
		self:on_read_database()
		progress:update_bar(100)
	end

end

function CoreDatabaseBrowser:on_update_btn()
	self._active_database:load()
	self:append_local_changes()
	self:on_read_database()
end

function CoreDatabaseBrowser:on_import_xml()
	if not self._browser_data and self._open_xml_file_dialog:show_modal() then
		local dialog_path = self._open_xml_file_dialog:get_path()
		local path = dialog_path:sub(Application:base_path():len() + 1, dialog_path:len())
		local xml_root = File:parse_xml(path)
		if xml_root and xml_root:num_children() == 0 then
			self._no_nodes_dialog:show_modal()
			return
		end

		local node
		if xml_root and self._import_dialog:show_modal() then
			node = Node(xml_root:name())
			self:create_node(node, xml_root)
			local entry_type, entry_name = self._import_dialog:get_value()
			if self._active_database:has(entry_type, entry_name) then
				self._active_database:remove(entry_type, entry_name, {})
				self._dirty_flag = false
				self._active_database:save()
				self._active_database:load()
			end

			self._active_database:save_node(node, self._active_database:add(entry_type, entry_name, {}, "xml"))
			self._dirty_flag = false
			self._active_database:save()
			self._active_database:load()
			self:on_read_database()
		end

	else
		self._not_available_dialog:show_modal()
	end

end

function CoreDatabaseBrowser:create_node(node, parent)
	do
		local (for generator), (for state), (for control) = pairs(parent:parameter_map())
		do
			do break end
			node:set_parameter(key, value)
		end

	end

	local (for generator), (for state), (for control) = parent:parameter_map() and parent:children(), parent:children()
	do
		do break end
		self:create_node(node:make_child(child:name()), child)
	end

end

function CoreDatabaseBrowser:on_read_database()
	self._entrys = {}
	local function apply_type_filter(type_combobox, dest_type_combobox)
		local t = type_combobox:get_value()
		local entries = t == "[all]" and self._active_database:all(false) or self._active_database:all(false, t)
		dest_type_combobox:set_value(t)
		return entries, t
	end

	local data_table, database_type
	local current_page = self._main_notebook:get_current_page()
	if current_page == self._main_notebook:get_page(0) then
		data_table, database_type = apply_type_filter(self._search_box.type_combobox, self._tree_box.type_combobox)
	elseif current_page == self._main_notebook:get_page(1) then
		data_table, database_type = apply_type_filter(self._tree_box.type_combobox, self._search_box.type_combobox)
	end

	do
		local (for generator), (for state), (for control) = ipairs(data_table or {})
		do
			do break end
			if not self._browser_data or entry:num_properties() == 0 or database_type ~= "texture" then
				self._entrys[self:create_unique_name(entry)] = entry
			end

		end

	end

	(for control) = nil and self._browser_data
end

function CoreDatabaseBrowser:create_unique_name(entry)
	local str = entry:type() .. " - " .. entry:name()
	do
		local (for generator), (for state), (for control) = pairs(entry:properties())
		do
			do break end
			str = str .. " : " .. value
		end

	end

end

function CoreDatabaseBrowser:get_meta_data(selected_type, selected)
	local str = ""
	local entry = self._entrys[selected]
	if entry then
		for i = 1, entry:num_metadatas() do
			local meta_key = entry:metadata_key(i - 1)
			local meta_value = entry:metadata_value(i - 1)
			str = str .. meta_key .. "->" .. meta_value .. "\n"
		end

	end

	return str
end

function CoreDatabaseBrowser:on_view_metadata()
-- fail 54
null
10
-- fail 102
null
11
	local str
	if self._main_notebook:get_current_page() == self._main_notebook:get_page(0) then
		if 0 < #self._search_box.list_box:selected_indices() then
			for i = 1, #self._search_box.list_box:selected_indices() do
				local selected = self._search_box.list_box:get_string(self._search_box.list_box:selected_indices()[i])
				local entry = self._active_database:lookup(self._entrys[selected]:type(), self._entrys[selected]:name(), self._entrys[selected]:properties())
				local (for generator), (for state), (for control) = pairs(entry:metadatas())
				do
					do break end
					str = (str or "") .. k .. "->" .. v .. "\n"
				end

			end

		end

	else
		local ids = self._tree_box.tree_ctrl:selected_items()
		if #ids > 0 then
			for i = 1, #ids do
				local selected = self._tree_box.tree_ctrl:get_item_text(ids[i])
				local entry = self._active_database:lookup(self._entrys[selected]:type(), self._entrys[selected]:name(), self._entrys[selected]:properties())
				local (for generator), (for state), (for control) = pairs(entry:metadatas())
				do
					do break end
					str = (str or "") .. k .. "->" .. v .. "\n"
				end

			end

		end

	end

	EWS:MessageDialog(self._main_frame, str or "No metadata!", "Metadata", "OK,ICON_INFORMATION"):show_modal()
end

function CoreDatabaseBrowser:on_set_metadata()
	if self._main_notebook:get_current_page() == self._main_notebook:get_page(0) then
		if 0 < #self._search_box.list_box:selected_indices() and self._metadata_dialog:show_modal() then
			for i = 1, #self._search_box.list_box:selected_indices() do
				local selected = self._search_box.list_box:get_string(self._search_box.list_box:selected_indices()[i])
				local key, value = self._metadata_dialog:get_value()
				local entry = self._active_database:lookup(self._entrys[selected]:type(), self._entrys[selected]:name(), self._entrys[selected]:properties())
				if value == "" then
					self._active_database:clear_metadata(entry, key)
					self._dirty_flag = false
					self._active_database:save()
				else
					self._active_database:set_metadata(entry, key, value)
					self._dirty_flag = false
					self._active_database:save()
				end

			end

		end

	else
		local ids = self._tree_box.tree_ctrl:selected_items()
		if #ids > 0 and self._metadata_dialog:show_modal() then
			for i = 1, #ids do
				local selected = self._tree_box.tree_ctrl:get_item_text(ids[i])
				local key, value = self._metadata_dialog:get_value()
				local entry = self._active_database:lookup(self._entrys[selected]:type(), self._entrys[selected]:name(), self._entrys[selected]:properties())
				if value == "" then
					self._active_database:clear_metadata(entry, key)
					self._dirty_flag = false
					self._active_database:save()
				else
					self._active_database:set_metadata(entry, key, value)
					self._dirty_flag = false
					self._active_database:save()
				end

			end

		end

	end

	self._active_database:load()
	self:on_read_database()
end

function CoreDatabaseBrowser:append_all_types(gui)
