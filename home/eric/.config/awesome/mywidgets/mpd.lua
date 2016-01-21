require("awful")
require("awful.util")
require("awful.menu")
local freedesktop_utils = require("freedesktop.utils")

-- Create a MPD widget
mpdwidget = widget({ type = "textbox" })

local mpd_not_running = false
local mpd_playing = false

vicious.register(mpdwidget, function()
		local cmd = "mpc"
		local f = io.popen(cmd)
		local str = sectionstart_text .. sectionTitle('MPD')
		local l = f:read()
	
		if l == nul or l:find("MPD_HOST") or l:find("error: Connection refused") then
			str = str .. " not running"
			mpd_not_running = true
			mpd_playing = false
		else
			mpd_not_running = false
			mpd_playing = true
			if not l:find("volume:") then
				str = str .. ' ' .. l
				l = f:read()
				if l ~= null then
					str = str .. ' ' .. seperator_text .. ' ' .. l:gsub('[^a-zA-Z]([a-zA-Z]*)[^a-zA-Z][ ]*#([0-9]*)[^0-9]*([0-9]*)[ ]*([0-9\\:]*)[^0-9\\:]*([0-9\\:]*).*', '%4 / %5' .. seperator_text .. ' %1 ' .. seperator_text .. ' #%2 / %3')
					l = f:read()
					if l ~= null then
						str = str .. ' ' .. seperator_text .. ' ' .. l:gsub('[^r]*([^ ]* [^ ]*)[ ]*([^ ]* [^ ]*).*', '%1 ' .. seperator_text .. ' %2')
					end
				end
			else
				str = str .. " playback stopped"
				mpd_playing = false
			end
		end
		f:close()
	
		str = str .. sectionend_text
	
		return str
	end, 2)

-- start mpd menu
local mpd_start_menu = {
	{'Start MPD', function() awful.util.spawn('sudo /etc/init.d/mpd start') end,freedesktop_utils.lookup_icon({ icon = 'system-run' }) }
}

-- setup play menu
function mpd_play_menu_items()
	local items = {}
	table.insert(items, {'Play / Pause',function() awful.util.spawn('mpc toggle') end,freedesktop_utils.lookup_icon({ icon = 'media-playback-start' }) })

	if mpd_playing then
		table.insert(items, {'Stop',function() awful.util.spawn('mpc stop') end,freedesktop_utils.lookup_icon({ icon = 'media-playback-stop' }) })
		table.insert(items, {'',nil,nil})
		table.insert(items, {'Next',function() awful.util.spawn('mpc next') end,freedesktop_utils.lookup_icon({ icon = 'media-seek-forward' }) })
		table.insert(items, {'Prev',function() awful.util.spawn('mpc prev') end,freedesktop_utils.lookup_icon({ icon = 'media-seek-backward' }) })
		table.insert(items, {'',nil,nil})
		table.insert(items, {'Repeat',function() awful.util.spawn('mpc repeat') end,freedesktop_utils.lookup_icon({ icon = 'media-playlist-repeat' }) })
		table.insert(items, {'Random',function() awful.util.spawn('mpc random') end,freedesktop_utils.lookup_icon({ icon = 'media-playlist-shuffle' }) })
	end
		
	return items
end

-- setup config menu
function mpd_config_menu_items()
	local items = {}

	table.insert(items, {'MPD Control', { {'Restart',function() awful.util.spawn('sudo /etc/init.d/mpd restart') end,freedesktop_utils.lookup_icon({ icon = 'system-reboot' }) },
			 {'Stop',function() awful.util.spawn('sudo /etc/init.d/mpd stop') end,freedesktop_utils.lookup_icon({ icon = 'system-shutdown' }) } }, freedesktop_utils.lookup_icon({ icon = 'configure' }) })

	if not mpd_not_running then
		local outputs_menu = { }

		local f = io.popen('mpc outputs')

		while true do
			local l = f:read()
			local str = nil
			local icon = nil
			local cmd = nil

			if l == nul then
				break
			end

			if l:find("enabled") then
				icon = "dialog-ok"
				cmd = "disable"
			else
				icon = 'dialog-close'
				cmd = "enable"
			end
				
			local number = l:gsub("Output ([0-9]*) .*", "%1")

			local func = assert(loadstring("awful.util.spawn('mpc " .. cmd .. " " .. number .. "')"))

			table.insert(outputs_menu, {l, func, freedesktop_utils.lookup_icon({icon=icon})})
		end

		table.insert(items, {'', nil, nil})
		table.insert(items, {'Outputs', outputs_menu, freedesktop_utils.lookup_icon({icon = 'speaker'})})
	end
	if mpd_playing then
		table.insert(items, {'', nil, nil})
		table.insert(items, {'Playlist', nil, freedesktop_utils.lookup_icon({icon = 'view-media-playlist'})})
	end

	return items
end

-- create / show menus
local mpd_play_menu = nil
local mpd_config_menu = nil

function show_play_menu()
	if mpd_config_menu ~= nil then
		mpd_config_menu:hide()
		mpd_config_menu = nil
	end

	if mpd_play_menu ~= nil then
		mpd_play_menu:hide()
		mpd_play_menu = nil
	else
		local menu_items = nil
		if mpd_not_running then
			menu_items = mpd_start_menu
		else
			menu_items = mpd_play_menu_items()
		end
		mpd_play_menu = awful.menu.new({ items = menu_items })
		mpd_play_menu:show()
	end
end

function show_config_menu()
	if mpd_play_menu ~= nil then
		mpd_play_menu:hide()
		mpd_play_menu = nil
	end

	if mpd_config_menu ~= nil then
		mpd_config_menu:hide()
		mpd_config_menu = nil
	else
		local menu_items = nil
		if mpd_not_running then
			menu_items = mpd_start_menu
		else
			menu_items = mpd_config_menu_items()
		end
		mpd_config_menu = awful.menu.new({ items = menu_items })
		mpd_config_menu:show()
	end
end

mpdwidget:buttons(awful.util.table.join(awful.button({ }, 1, show_play_menu),
                                        awful.button({ }, 3, show_config_menu)))
