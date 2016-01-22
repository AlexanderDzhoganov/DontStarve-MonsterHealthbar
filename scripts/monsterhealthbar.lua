local Widget = require "widgets/widget"
local ProgressBar = require "widgets/progressbar"
local Util = require "mutil"
local Config = require "modconfig"

local currentMonster = nil
local hideTimer = 0.0

return {
  init = function(controls, userConfig)
    local width = 256
    local height = 22

    if userConfig.healthbarSize == "xs" then
      width = 128
      height = 14
    elseif userConfig.healthbarSize == "small" then
      width = 200
      height = 18
    elseif userConfig.healthbarSize == "large" then
      width = 400
      height = 32
    end

    if userConfig.wideHealthbar then
      width = width * 1.6
    end

    local fontSize = 22

    if userConfig.fontSize == "xs" then
      fontSize = 12
    elseif userConfig.fontSize == "small" then
      fontSize = 16
    elseif userConfig.fontSize == "large" then
      fontSize = 28
    end

    local container = controls:AddChild(Widget("RPGMonsterInfoContainer"))
    container:SetHAnchor(ANCHOR_MIDDLE)
    container:SetVAnchor(ANCHOR_TOP)
    container:SetPosition(0.0, -26.0, 0.0)
    container:SetClickable(false)
    container:SetScaleMode(SCALEMODE_PROPORTIONAL)

    local monsterHP = container:AddChild(ProgressBar("", fontSize, Config.font, width, height, Config.color_hostile, container))
    monsterHP:Hide()

    local entity = CreateEntity()

    entity:DoPeriodicTask(0.5, function()
      if hideTimer <= 0.0 then
        return
      end

      hideTimer = hideTimer - 0.5
      if hideTimer <= 0.0 then
        local inst = TheInput:GetWorldEntityUnderMouse()
        if inst ~= currentMonster then
          currentMonster = nil
          monsterHP:Hide()
        end
      end
    end)

    entity:DoPeriodicTask(0, function()
      local inst = TheInput:GetWorldEntityUnderMouse()
    
      local player = nil

      if TheSim:GetGameID() == "DST" then
        player = ThePlayer

        if inst ~= nil and inst.replica ~= nil and inst.replica.health ~= nil then
          currentMonster = inst
        end
      else
        player = GetPlayer()

        if inst ~= nil and inst.components.health ~= nil and inst ~= player then
          currentMonster = inst
          hideTimer = 5.0
        end
      end

      if currentMonster == nil then
        monsterHP:Hide()
        return
      end

      local playerPos = Vector3(player.Transform:GetWorldPosition());
      local monsterPos = Vector3(currentMonster.Transform:GetWorldPosition());
      local dist = math.sqrt(distsq(playerPos, monsterPos))

      if dist <= 20.0 or inst == currentMonster then
        monsterHP:Show()
      else
        monsterHP:Hide()
        currentMonster = nil
        return
      end

      if currentMonster:HasTag("hostile") then
        monsterHP:SetColor(Config.color_hostile)
      else
        monsterHP:SetColor(Config.color_friendly)
      end

      if currentMonster.components.combat and currentMonster.components.combat.target == player then
        monsterHP:SetColor(Config.color_hostile)
      end
      
      local hp = 10
      local maxHP = 10
      
      if currentMonster.components.health then
        hp = currentMonster.components.health.currenthealth
        maxHP = currentMonster.components.health.maxhealth

        if currentMonster.components.health:IsDead() then
          currentMonster = nil
          monsterHP:Hide()
          return
        end
      elseif currentMonster.replica and currentMonster.replica.health then
        hp = currentMonster.replica.health:GetCurrent()
        maxHP = currentMonster.replica.health:Max()

        if currentMonster.replica.health:IsDead() then
          currentMonster = nil
          monsterHP:Hide()
          return
        end
      end
      
      local name = Util.firstToUpper(currentMonster.prefab)
      
      if currentMonster.name ~= nil then
        name = currentMonster.name
      end
      
      if currentMonster.components.named and currentMonster.components.named.name then
        name = currentMonster.components.named.name
      end

      local text = name

      if userConfig.showHealthText then
        text = text .. " [ " .. hp .. " / " .. maxHP .. " ]"
      end

      monsterHP:SetLabel(Util.trim(text))

      local percent = (hp / maxHP) * 100.0
      monsterHP:SetPercent(percent)

      if not userConfig.showTraitsText then
        return 
      end

      local subtext = ""

      if not currentMonster:HasTag("hostile") then
        subtext = subtext .. "Friendly "
      end

      if currentMonster:HasTag("epic") then
        subtext = subtext .. "Epic "
      elseif currentMonster:HasTag("smallcreature") then
          subtext = subtext .. "Small "
      elseif currentMonster:HasTag("largecreature") then
        subtext = subtext .. "Large "
      end

      if currentMonster:HasTag("canbetrapped") then
        subtext = subtext .. "Trappable "
      end

      if currentMonster:HasTag("monster") then
        subtext = subtext .. "Monster "
      elseif currentMonster:HasTag("insect") then
        subtext = subtext .. "Insect "
      elseif currentMonster:HasTag("bird") then
        subtext = subtext .. "Bird "
      elseif currentMonster:HasTag("animal") then
        subtext = subtext .. "Animal "
      end

      monsterHP:SetSubLabel(Util.trim(subtext))
    end)
  end,
  setMonster = function(monster)
    hideTimer = 5.0
    currentMonster = monster
  end
}
