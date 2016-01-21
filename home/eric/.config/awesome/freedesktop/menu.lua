-- Grab environment
local utils = require("freedesktop.utils")
local io = io
local ipairs = ipairs
local table = table
local os = os

module("freedesktop.menu")

function new()
	-- the categories and their synonyms where shamelessly copied from lxpanel
	-- source code.
	local programs = {}
	programs['AudioVideo'] = {}
	--programs['Audio'] = {}
	--programs['Video'] = {}
	programs['Development'] = {}
	--programs['Education'] = {}
	programs['Game'] = {}
	programs['Graphics'] = {}
	programs['Network'] = {}
	programs['Office'] = {}
	programs['Settings'] = {}
	programs['System'] = {}
	programs['Utility'] = {}
	programs['Other'] = {}

	local apps = utils.parse_dir('/usr/share/applications/')
	for i, app in ipairs(utils.parse_dir('/usr/share/applications/kde4')) do
		table.insert(apps, app)
	end
	for i, app in ipairs(utils.parse_dir(os.getenv('HOME') .. '/.local/share/applications')) do
		table.insert(apps, app)
	end

	for i, program in ipairs(apps) do

		-- check whether to include in the menu
		if program.show and program.Name and program.cmdline then
			local target_category = nil
			if program.categories then
				for _, category in ipairs(program.categories) do
					if programs[category] then
						target_category = category
						break
					end
				end
			end
			if not target_category then
				target_category = 'Other'
			end
			if target_category then
				table.insert(programs[target_category], { program.Name, program.cmdline, program.icon_path })
			end
		end

	end

	local menu = {
		{ "Accessories", programs["Utility"], utils.lookup_icon({ icon = 'applications-accessories.png' }) },
		{ "Development", programs["Development"], utils.lookup_icon({ icon = 'applications-development.png' }) },
		{ "Education", programs["Education"], utils.lookup_icon({ icon = 'applications-science.png' }) },
		{ "Games", programs["Game"], utils.lookup_icon({ icon = 'applications-games.png' }) },
		{ "Graphics", programs["Graphics"], utils.lookup_icon({ icon = 'applications-graphics.png' }) },
		{ "Internet", programs["Network"], utils.lookup_icon({ icon = 'applications-internet.png' }) },
		{ "Multimedia", programs["AudioVideo"], utils.lookup_icon({ icon = 'applications-multimedia.png' }) },
		{ "Office", programs["Office"], utils.lookup_icon({ icon = 'applications-office.png' }) },
		{ "Other", programs["Other"], utils.lookup_icon({ icon = 'applications-other.png' }) },
		{ "Settings", programs["Settings"], utils.lookup_icon({ icon = 'applications-utilities.png' }) },
		{ "System Tools", programs["System"], utils.lookup_icon({ icon = 'applications-system.png' }) },
	}

	-- Removing empty entries from menu and sort the sub menus
	local bad_indexes = {}
	for index , item in ipairs(menu) do
		if not item[2] then
			table.insert(bad_indexes, index)
		else
			table.sort(item[2], function(a,b) return a[1] < b[1] end)
		end
	end
	table.sort(bad_indexes, function (a,b) return a > b end)
	for _, index in ipairs(bad_indexes) do
		table.remove(menu, index)
	end

	return menu
end
