awful = require("awful")
naughty = require("naughty")

confdir = awful.util.getdir("config")
local rc, err = loadfile(confdir .. "/awesome.lua")
if rc then
	rc, err = pcall(rc);
	if rc then
		return;
	end
end

dofile("/etc/xdg/awesome/rc.lua")

--local f = io.open('~/.awesome.log', 'w')

--f:write("Awesome crashed during startup: " .. err .. "\n")
--f:close()

for s = 1, screen.count() do
	mypromptbox[s].text = awful.util.escape(err:match("[^\n]*"));
end

naughty.notify{ text = "Awesome crashed during startup: " .. err .. "\n", timeout = 0 }
