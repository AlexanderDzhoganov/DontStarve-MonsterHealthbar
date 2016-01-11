local require = GLOBAL.require

local MonsterHealthbar = require "monsterhealthbar"
AddClassPostConstruct("widgets/controls", function(hud)
	MonsterHealthbar(hud)
end)
