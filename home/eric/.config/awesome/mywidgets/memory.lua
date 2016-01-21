-- Memory Status
--memtext = widget({ type = "textbox"})
local memtext = wibox.widget.textbox()
vicious.register(memtext, function()
		local cmd = "free -m | grep Mem | sed -e's#[^0-9]*\\([0-9]*\\)[ ]*\\([0-9]*\\)[ ]*\\([0-9]*\\).*#\\1\\n\\2\\n\\3#'"
		local f = io.popen(cmd)
		local str = " "
		while true do
			local l = f:read()
			if l == nul then break end
			if str ~= " " then str = str .. " " .. seperator_text .. " " end
			str = str .. string.format("%.0f", l) .. "MB "
		end
		f:close()

		return sectionstart_text .. sectionTitle('Mem') .. str .. sectionend_text
	end, 9)

return memtext
