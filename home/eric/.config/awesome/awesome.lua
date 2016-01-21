-- Standard awesome library
awful = require("awful")
awful.autofocus = require("awful.autofocus")
awful.rules = require("awful.rules")
awful.menu = require("awful.menu")
awful.titlebar = require("awful.titlebar")
awful.remote = require("awful.remote")
vicious = require("vicious")
-- Theme handling library
beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")

gears = require("gears")

tsave = require("tsave")

wibox = require("wibox")

-- launch the Cairo Composite Manager
awful.util.spawn_with_shell("cairo-compmgr &")

-- main menu builder
myrc_mainmenu = require("myrc.mainmenu")
myrc_memory = require("myrc.memory")

myrc.memory.init()

-- Themes define colours, icons, and wallpapers
beautiful.init(awful.util.getdir("config") .. "/theme/black-blue/theme.lua")
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
for s = 1, screen.count() do
	gears.wallpaper.maximized(awful.util.getdir("config") .. "/wallpaper.jpg", s)
end

-- my widgets
mywidgets = require("mywidgets")

local freedesktop_utils = require("freedesktop.utils")

-- {{{ Variable definitions

-- This is used later as the default terminal and editor to run.
terminal = "gnome-terminal"
--editor = os.getenv("EDITOR") or "vi"
editor = "vi"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.

---------  tags = {}
---------  for s = 1, screen.count() do
---------      -- Each screen has its own tag table.
---------      tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, awful.layout.suit.tile)
---------  end
-- }}}

local tag_names = { 'SVR', 'PAGES', 'WEBAPP', 'API', 'HOME', 'STATUS', 'OTHER', 'OTHER2' }

tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tag_names, s, layouts[1])
end





-- {{{ Lock Icon
--mylock = widget({ type = 'imagebox'})
mylock_lock = wibox.widget.imagebox()
mylock_lock:set_image(freedesktop_utils.lookup_icon({ icon = 'system-lock-screen' }))
mylock_lock:buttons(awful.button({ }, 1, function() awful.util.spawn('xlock -mode blank -dpmsstandby 1 -dpmssuspend 1 -dpmsoff 1') end))
--awful.widget.layout.margins[mylock] = { left = 2 }
mylock = wibox.layout.margin(mylock_lock, 2, 0, 0, 0)
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
mymainmenu = myrc_mainmenu.build()
myfavmenu = myrc_mainmenu.build_favorites()

function show_main_menu()
	myfavmenu:hide()
	mymainmenu:toggle()
end

function show_fav_menu()
	mymainmenu:hide()
	myfavmenu:toggle()
end

--mylauncher = widget({ type = 'imagebox' })
mylauncher_img = wibox.widget.imagebox()
mylauncher_img:set_image(beautiful.awesome_icon)
mylauncher_img:buttons(awful.util.table.join(awful.button({ }, 1, show_main_menu),
                                         awful.button({ }, 3, show_fav_menu)))
--awful.widget.layout.margins[mylauncher] = { right = 2 }
mylauncher = wibox.layout.margin(mylauncher_img, 0, 0, 2, 0)
-- }}}

-- {{{ Wibox

-- Create a textclock widget
mytextclock = awful.widget.textclock("%a %b %d, %I:%M", 7)

--{{{ Menu generators
function client_name(c)
	local cls = c.class or ""
	local inst = c.instance or ""
	local role = c.role or ""
	local ctype = c.type or ""
	return cls..":"..inst..":"..role..":"..ctype
end

function save_floating(c, f)
	myrc.memory.set("floating", client_name(c), f)
	awful.client.floating.set(c, f)
	return f
end

function get_floating(c, def)
	if def == nil then def = awful.client.floating.get(c) end
	return myrc.memory.get("floating", client_name(c), def)
end

function save_centered(c, val)
	myrc.memory.set("centered", client_name(c), val)
	if val == true then
		awful.placement.centered(c)
		save_floating(c, true)
	end
	return val
end

function get_centered(c, def)
	return myrc.memory.get("centered", client_name(c), def)
end

function save_titlebar(c, val)
	myrc.memory.set("titlebar", client_name(c), val)
	if val == true then
		awful.titlebar.add(c, { modkey = modkey })
	elseif val == false then
		awful.titlebar.remove(c)
	end
	return val
end

function get_titlebar(c, def)
	return myrc.memory.get("titlebar", client_name(c), def)
end

function save_geometry(c, val)
	myrc.memory.set("geometry", client_name(c), val)
	c:geometry(val)
end

function get_geometry(c, def)
	return myrc.memory.get("geometry", client_name(c), def)
end


mycontextmenu = nil

-- Builds menu for client c
function build_client_menu(c, kg)
	if mycontextmenu and mycontextmenu.wibox.visible then
		awful.menu.hide(mycontextmenu)
		return
	end
	local centered = get_centered(c)
	local floating = get_floating(c)
	local titlebar = get_titlebar(c)
	local geometry = get_geometry(c)
	function checkbox(name, val) 
		if val==true then return "[X] "..name 
		elseif val==false then return "[ ] " .. name 
		else return "[?] " .. name 
		end 
	end
	function bool_submenu(f) 
		return {
				{"Set", function () f(true) end },
				{"UnSet", function() f(false) end },
			}
	end
	mycontextmenu = awful.menu.new( { 
	items = { 
			{ "Close", function() c:kill() 
				end, freedesktop.utils.lookup_icon({ icon = 'dialog-close' })} ,
			{ checkbox("Floating",floating), 
				bool_submenu(function(v) save_floating(c, v) end) },
			{ checkbox("Centered", centered),
				bool_submenu(function(v) save_centered(c, v) end) },
			{ checkbox("Titlebar", titlebar),
				bool_submenu(function(v) save_titlebar(c, v) end) },
			{ checkbox("Store geomtery", geometry ~= nil ), function() 
				save_geometry(c, c:geometry() ) 
			end, },
			{ "Toggle maximize", function () 
				c.maximized_horizontal = not c.maximized_horizontal
				c.maximized_vertical   = not c.maximized_vertical
				end, }
			}, 
			height = beautiful.menu_context_height 
		} )
	awful.menu.show(mycontextmenu, kg)
end
--}}}

-- Create a wibox for each screen and add it
mywibox = {}
--bottombox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 2, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
					 awful.button({ }, 3, function (c) build_client_menu(c) end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
	mytaglist[s] = wibox.layout.margin(awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons), 0, 0, 2, 0)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 20 })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()

    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
	left_layout:add(mylayoutbox[s])
	left_layout:add(wibox.layout.margin(mypromptbox[s], 4, 0, 4, 0))

	local right_layout = wibox.layout.fixed.horizontal()

    if s == 1 then
      local mysystray = wibox.widget.systray()
      right_layout:add(mysystray)
    end

	right_layout:add(mywidgets.cpu[s])
	right_layout:add(mywidgets.base.sectionend)
	right_layout:add(mywidgets.memory)
	right_layout:add(mywidgets.battery)
	right_layout:add(mywidgets.base.sectionstart)
	right_layout:add(mytextclock)
	right_layout:add(mywidgets.base.sectionend)

    -- --if s == 1 then
    -- tray = wibox.widget.base.make_widget()
    -- tray.draw = function() end
    -- tray.fit = function() return 100, 0 end
    -- --tray:fit(100,1)
    -- -- tray.width = screen[s].workarea.width - 
    -- -- width = screen[s].workarea.width -
    -- --tray = wibox.widget.systray()
    -- --tray:set_bg("#00000000")
    -- right_layout:add(tray)
    -- --end


	right_layout:add(mylock)

	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	layout:set_middle(mytasklist[s])
	layout:set_right(right_layout)
 
    -- Add widgets to the wibox - order matters
    mywibox[s]:set_widget(layout)
end
-- }}}


function run_once(cmd)
        findme = cmd
        firstspace = cmd:find(" ")
        if firstspace then
                findme = cmd:sub(0, firstspace-1)
        end
        awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end



globalkeys = {}




require("prompts")
require("bindings")
require("signals")
require("rules")
require("autoruns")
