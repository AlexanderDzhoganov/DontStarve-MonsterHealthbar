local Widget = require "widgets/widget"
local ProgressBar = require "widgets/progressbar"
local Util = require "mutil"
local Config = require "modconfig"

return function(controls)
  local container = controls:AddChild(Widget("RPGMonsterInfoContainer"))
  container:SetHAnchor(ANCHOR_MIDDLE)
  container:SetVAnchor(ANCHOR_TOP)
  container:SetPosition(0.0, -26.0, 0.0)
  container:SetClickable(false)
  container:SetScaleMode(SCALEMODE_PROPORTIONAL)

  local monsterHP = container:AddChild(ProgressBar("", Config.font_size, Config.font, Config.width, Config.height, Config.color_hostile, container))
  monsterHP:Hide()

  local entity = CreateEntity()
  entity:DoPeriodicTask(0, function()
    local inst = TheInput:GetWorldEntityUnderMouse()
    if inst == nil or inst.components.health == nil then
      monsterHP:Hide()
      return
    end

    local player = nil
    if TheSim:GetGameID() == "DST" then
      player = ThePlayer
    else
      player = GetPlayer()
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

    local hp = inst.components.health.currenthealth
    local maxHP = inst.components.health.maxhealth

    local name = Util.firstToUpper(inst.prefab)
    if inst.components.named and inst.components.named.name then
      name = inst.components.named.name
    end

    local text = name

    if Config.show_health_text then
      text = text .. " [ " .. hp .. " / " .. maxHP .. " ]"
    end

    monsterHP:SetLabel(Util.trim(text))

    local percent = (hp / maxHP) * 100.0
    monsterHP:SetPercent(percent)

    if not Config.show_traits_text then
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
