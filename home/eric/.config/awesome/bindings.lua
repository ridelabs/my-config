local menubar = require("menubar")

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(globalkeys,

    -- Volume Control

    awful.key({     }, "XF86AudioRaiseVolume", function() awful.util.spawn("amixer -D pulse set Master 5%+"); awful.util.spawn("canberra-gtk-play --file=/usr/share/sounds/freedesktop/stereo/message.oga", false) end),
    awful.key({     }, "XF86AudioLowerVolume", function() awful.util.spawn("amixer -D pulse set Master 5%-"); awful.util.spawn("canberra-gtk-play --file=/usr/share/sounds/freedesktop/stereo/message.oga", false) end),
    awful.key({     }, "XF86AudioMute", function() awful.util.spawn("amixer -D pulse set Headphone toggle", false); awful.util.spawn("amixer -D pulse set Master toggle", false) end),


    -- Brightness
    awful.key({ }, "XF86MonBrightnessDown", function () awful.util.spawn("xbacklight -dec 15") end),
    awful.key({ }, "XF86MonBrightnessUp", function () awful.util.spawn("xbacklight -inc 15") end),

    -- awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    -- awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    -- awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    -- menus?  sure, we do that

    --awful.key({ modkey,         }, "w", function () mymainmenu:show(true)        end),
    --awful.key({ modkey,         }, "w", function () mymainmenu:show() end),

    -- awful.key({modkey }, "e", function() awful.util.spawn( "i3-dmenu-desktop" ) end)
    -- awful.key({modkey}, "w", function() mymainmenu:toggle() end),
    awful.key({modkey}, "p", function() menubar.show() end),
    awful.key({modkey}, "d", function() awful.util.spawn( "dmenu_run" ) end),

	awful.key({ "Control", "Shift", modkey }, "l", function () awful.util.spawn("xscreensaver-command -lock") end),
    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey }, "w", function () awful.util.spawn("/home/eric/bin/wallpaper.sh")    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
--    awful.key({ modkey,           }, "Tab",
--        function ()
--            awful.client.focus.history.previous()
--            if client.focus then
--                client.focus:raise()
--            end
--        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey            }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
    awful.key({ modkey, "Shift"   }, "c",
        function (c)
            c.maximized_horizontal = false
            c.maximized_vertical   = false
            -- awful.client.floating = false
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
--for i = 1, 9 do
--    globalkeys = awful.util.table.join(globalkeys,
--        awful.key({ modkey }, "#" .. i + 9,
--                  function ()
--                        local screen = mouse.screen
--                        local tag = awful.tag.gettags(screen)[i]
--                        if tag then
--                           awful.tag.viewonly(tag)
--                        end
--                  end),
--        awful.key({ modkey, "Control" }, "#" .. i + 9,
--                  function ()
--                      local screen = mouse.screen
--                      local tag = awful.tag.gettags(screen)[i]
--                      if tag then
--                         awful.tag.viewtoggle(tag)
--                      end
--                  end),
--        awful.key({ modkey, "Shift" }, "#" .. i + 9,
--                  function ()
--                      local tag = awful.tag.gettags(client.focus.screen)[i]
--                      if client.focus and tag then
--                          awful.client.movetotag(tag)
--                     end
--                  end),
--        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
--                  function ()
--                      local tag = awful.tag.gettags(client.focus.screen)[i]
--                      if client.focus and tag then
--                          awful.client.toggletag(tag)
--                      end
--                  end))
--end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)

-- Hook function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
		local name = client_name(c)
		if c.type == "dialog" then 
			save_centered(c, true)
		end

		local floating = myrc.memory.get("floating", name, awful.client.floating.get(c))
		save_floating(c, floating)
		if floating == true then
			local centered = get_centered(c)
			if centered then 
				save_centered(c, centered)
			end
			local geom = get_geometry(c)
			if geom then
				save_geometry(c, geom)
			end
			local titlebar = get_titlebar(c)
			if titlebar then
				save_titlebar(c, titlebar)
			end
		end

		-- Set key bindings
		c:buttons(clientbuttons)
		c:keys(clientkeys)

		-- Set default app icon
		if not c.icon and theme.default_client_icon then
			c.icon = image(theme.default_client_icon)
		end

		-- New client may not receive focus
		-- if they're not focusable, so set border anyway.
		c.border_width = beautiful.border_width
		c.border_color = beautiful.border_normal
		c.size_hints_honor = false

		-- Do this after tag mapping, so you don't see it on the wrong tag for a split second.
		client.focus = c
	end)
-- }}}
