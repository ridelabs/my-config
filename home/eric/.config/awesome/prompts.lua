globalkeys = awful.util.table.join(globalkeys,
    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

	-- Execute LUA Code
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = sectionTitle("Run Lua code") },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
	)
