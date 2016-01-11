local Widget = require "widgets/widget"
local ProgressBar = require "widgets/progressbar"
local Util = require "mutil"
local Config = require "modconfig"

return function(controls, userConfig)
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
  entity:DoPeriodicTask(0, function()
    local inst = TheInput:GetWorldEntityUnderMouse()
    if inst == nil then
      monsterHP:Hide()
      return
    end
    
    local player = nil

    if TheSim:GetGameID() == "DST" then
      player = ThePlayer

      if inst.replica == nil or inst.replica.health == nil then
        monsterHP:Hide()
        return
      end
    else
      player = GetPlayer()

      if inst.components.health == nil then
        monsterHP:Hide()
        return
      end
    end

    if inst == player then
      monsterHP:Hide()
      return
    end

    monsterHP:Show()

    if inst:HasTag("hostile") then
      monsterHP:SetColor(Config.color_hostile)
    else
      monsterHP:SetColor(Config.color_friendly)
    end
    
    local hp = 10
    local maxHP = 10
    
    if inst.components.health then
      hp = inst.components.health.currenthealth
      maxHP = inst.components.health.maxhealth
    elseif inst.replica and inst.replica.health then
      hp = inst.replica.health:GetCurrent()
      maxHP = inst.replica.health:Max()
    end
    
    local name = Util.firstToUpper(inst.prefab)
    
    if inst.name ~= nil then
      name = inst.name
    end
    
    if inst.components.named and inst.components.named.name then
      name = inst.components.named.name
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

    if not inst:HasTag("hostile") then
      subtext = subtext .. "Friendly "
    end

    if inst:HasTag("epic") then
      subtext = subtext .. "Epic "
    elseif inst:HasTag("smallcreature") then
        subtext = subtext .. "Small "
    elseif inst:HasTag("largecreature") then
      subtext = subtext .. "Large "
    end

    if inst:HasTag("canbetrapped") then
      subtext = subtext .. "Trappable "
    end

    if inst:HasTag("monster") then
      subtext = subtext .. "Monster "
    elseif inst:HasTag("insect") then
      subtext = subtext .. "Insect "
    elseif inst:HasTag("bird") then
      subtext = subtext .. "Bird "
    elseif inst:HasTag("animal") then
      subtext = subtext .. "Animal "
    end

    monsterHP:SetSubLabel(Util.trim(subtext))
  end)
end
