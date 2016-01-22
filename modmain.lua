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
	MonsterHealthbar.init(hud, config)
end)

AddComponentPostInit("combat", function(self, inst)
	local oldGetAttacked = self.GetAttacked
	function self:GetAttacked(attacker, damage, weapon)
		local player = nil

		if GLOBAL.TheSim:GetGameID() == "DST" then
			player = GLOBAL.ThePlayer
		else
			player = GLOBAL.GetPlayer()
		end

		if attacker == player then
			if inst.components.health then
				MonsterHealthbar.setMonster(inst)
			end
		end

		oldGetAttacked(self, attacker, damage, weapon) 
	end
end)
