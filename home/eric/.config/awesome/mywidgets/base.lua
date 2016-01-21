-- colors
section_color = "#2266FF"
highlight_color = "#DDDDDD"

--sectionstart = widget({ type = "textbox" })
sectionstart = wibox.widget.textbox()
sectionstart_text = " <span color='" .. section_color .."'><b>[</b></span>"
--sectionstart.text = sectionstart_text
sectionstart:set_markup(sectionstart_text)

--sectionend = widget({ type = "textbox" })
sectionend = wibox.widget.textbox()
sectionend_text = "<span color='" .. section_color .."'><b>]</b></span>"
--sectionend.text = sectionend_text
sectionend:set_markup(sectionend_text)

--seperator = widget({ type = "textbox" })
seperator = wibox.widget.textbox()
seperator_text = "<span color='" .. section_color .."'><b>|</b></span>"
--seperator.text = seperator_text
seperator:set_markup(seperator_text)

function sectionTitle(str)
	return "<span color='" .. highlight_color .."'><b>" .. str .. ":</b></span>"
end

return {
	sectionstart = sectionstart;
	sectionend = sectionend;
	seporator = seperator;
	sectionTitle = sectionTitle;
}
