-- log
function MyDump(...)
	local objects = vim.tbl_map(vim.inspect, {...})
	print(unpack(objects))
end

-- notification manager custom_instance
function MyNotificationMin(str)
	local custom_opts = {
		render = "minimal",
		stages = "static",
		timeout = 1500,
	}
	local custom_instance = vim.notify.instance(custom_opts, false)
	custom_instance(str, 2, custom_opts)
end
