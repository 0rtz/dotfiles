local count = ya.sync(function()
	return #cx.tabs
end)

local function entry()
	if count() > 1 then
		return ya.emit("tab_close", {})
	end

	local yes = ya.confirm {
		pos = { "center", w = 20, h = 5 },
		title = "Quit?",
	}

	if yes then
		ya.emit("quit", {})
	end
end

return { entry = entry }
