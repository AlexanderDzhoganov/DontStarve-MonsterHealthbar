local require = GLOBAL.require

local config = {
	healthbarSize = GetModConfigData("HealthbarSize"),
	wideHealthbar = GetModConfigData("WideHealthbar"),
	fontSize = GetModConfigData("FontSize"),
	showHealthText = GetModConfigData("ShowHealthText"),
	showTraitsText = GetModConfigData("ShowTraitsText")
}

local MonsterHealthbar = require "monsterhealthbar"
AddClassPostConstruct("widgets/controls", function(hud)
	MonsterHealthbar(hud, config)
end)
