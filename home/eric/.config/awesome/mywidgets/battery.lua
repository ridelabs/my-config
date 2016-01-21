-- Battery Status
--battext = widget({ type = "textbox" })
battext = wibox.widget.textbox()
--vicious.register(battext, vicious.widgets.bat, sectionstart_text .. sectionTitle('Bat') .. " $1 " .. seperator_text .. ' $2% ' .. seperator_text ..' $3' .. sectionend_text, 11, 'BAT0')

-- note that you should use upower -e to see what devices you can monitor... Eric...  03/05/15 10:19:49 Thu


vicious.register(battext, vicious.widgets.bat, sectionstart_text .. sectionTitle('Bat') .. " $1 " .. seperator_text .. ' $2% ', 11, 'BAT1')

-- Power useage
--powertext = widget({ type = "textbox"})
powertext = wibox.widget.textbox()
vicious.register(powertext, function()
	--local cmd = "cat /proc/acpi/battery/BAT0/state | grep 'present ' | sed -e 's#[^:]*:[ ]*\\([0-9]*\\) .*#\\1#'"
	--local f = io.popen(cmd)
	--local str = ""
	--local a = f:read()
	--local v = f:read()
	--f:close()

	--if a == nul or v == nul or tonumber(a) == nul or tonumber(v) == nul then
	--	return ""
	--else
	--	str = string.format("%.1f", a * v / 1000000) .. "w"

	--	if str == '0.0w' then
	--		return ""
	--	end
	--end
	--return sectionstart_text .. sectionTitle('Power') .. " " .. str .. sectionend_text .." "

        local cmd2 = "upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep 'time to ' | awk '{ print $4, substr($5, 0, 1) }'"

        local f2 = io.popen(cmd2)
        local remaining = f2:read()
        f2:close()

        if remaining == nul then
            return sectionend_text .. " "
        end

		return seperator_text .. " " .. remaining .. sectionend_text .. " "
	end, 3)

local layout = wibox.layout.fixed.horizontal()
layout:add(battext)
layout:add(powertext)

return layout
