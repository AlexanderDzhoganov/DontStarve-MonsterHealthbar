-- This information tells other players more about the mod
name = "Monster Healthbars"

description = "Healthbar for enemies"

author = "nlight"
version = "1.2d"

forumthread = ""

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 6
api_version_dst = 10

dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true

-- DST stuff
dst_compatible = true
all_clients_require_mod = false
client_only_mod = true

configuration_options = {
	{
		name = "HealthbarSize",
		label = "Healthbar size",
		options = {
			{ description = "Extra small", data = "xs" },
			{ description = "Small", data = "small" },
			{ description = "Medium (default)", data = "med" },
			{ description = "Large", data = "large" }
		},

		default = "med"
	},
	{
		name = "WideHealthbar",
		label = "Healthbar width",
		options = {
			{ description = "Normal (default)", data = false },
			{ description = "Wide", data = true }
		},

		default = false
	},
	{
		name = "FontSize",
		label = "Font size",
		options = {
			{ description = "Extra small", data = "xs" },
			{ description = "Small", data = "small" },
			{ description = "Medium (default)", data = "med" },
			{ description = "Large", data = "large" }
		},

		default = "med"
	},
	{
		name = "ShowHealthText",
		label = "Show health values",
		options = {
			{ description = "No", data = false },
			{ description = "Yes", data = true }
		},

		default = false
	},
	{
		name = "ShowTraitsText",
		label = "Show traits text",
		options = {
			{ description = "No", data = false },
			{ description = "Yes", data = true }
		},

		default = true
	}
}
