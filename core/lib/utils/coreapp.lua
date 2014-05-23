core:module("CoreApp")
function arg_supplied(key)
-- fail 7
null
3
	do
		local (for generator), (for state), (for control) = ipairs(Application:argv())
		do
			do break end
			if arg == key then
				return true
			end

		end

	end

end

function arg_value(key)
	local found
	local (for generator), (for state), (for control) = ipairs(Application:argv())
	do
		do break end
		if found then
			return arg
		elseif arg == key then
			found = true
		end

	end

end

function min_exe_version(version, system_name)
end

