require("awful")
require("awful.util")
require("awful.menu")
local freedesktop_utils = require("freedesktop.utils")

-- Create an amarok widget
amarokwidget = widget({ type = "textbox" })


vicious.register(amarokwidget, function()
		local file_name = '/tmp/amarok.info'
		local f = io.open(file_name)
		local str = sectionstart_text .. sectionTitle('Amarok')

		local l = f:read()

		local cmd = "python " .. awful.util.getdir("config") .. "/scripts/amarok.py"
		os.execute(cmd .. ' > ' .. file_name ..' &')

		if l == nul then return '' end

		str = str .. ' ' .. l:gsub('|', seperator_text)

		f:close()

		str = str .. sectionend_text
	
		return str
	end, 2)
