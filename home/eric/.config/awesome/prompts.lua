globalkeys = awful.util.table.join(globalkeys,

    --awful.key({ modkey, "Shift",  }, "F2",    function ()
    awful.key({ modkey,  }, "F2",    function ()
                    awful.prompt.run({ prompt = "Rename tab: ", text = awful.tag.selected().name, },
                    mypromptbox[mouse.screen].widget,
                    function (s)
                        awful.tag.selected().name = s
                    end)
            end),

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
