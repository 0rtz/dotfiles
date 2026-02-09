local function setup()
	ps.sub("ind-sort", function(opt)
		local cwd = cx.active.current.cwd
		if cwd:ends_with("Downloads") then
			opt.by, opt.reverse, opt.dir_first = "mtime", true, false
		end
		return opt
	end)
end

return { setup = setup }
