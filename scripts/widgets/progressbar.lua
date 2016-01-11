local Image = require "widgets/image"
local Text = require "widgets/text"
local Widget = require "widgets/widget"

local ProgressBar = Class(Widget, function(self, label, fontSize, font, width, height, color, owner)
    Widget._ctor(self, "ProgressBar")
    self.owner = owner

    self:SetClickable(false)

    self.percent = 0
    self:SetScale(1, 1, 1)

    self.width = width
    self.height = height

    self.bgimage = self:AddChild(Image())
    self.bgimage:SetTexture("images/ui.xml", "bg_plain.tex")
    self.bgimage:ScaleToSize(self.width, self.height)
    self.bgimage:SetTint(1.0, 1.0, 1.0, 0.55)
    self.bgimage:SetBlendMode(1)

    self.barimage = self:AddChild(Image())
    self.barimage:SetTexture("images/ui.xml", "bg_plain.tex")
    self.barimage:ScaleToSize(self.width, self.height)
    self.barimage:SetTint(color.r, color.g, color.b, color.a)
    self.barimage:SetBlendMode(1)

    self.label = self:AddChild(Text(font, fontSize, label))
    self.label:SetHAlign(ANCHOR_MIDDLE)
    self.label:SetPosition(0.0, 0.0, 0.0)

    self.sublabel = self:AddChild(Text(font, fontSize - 4, ""))
    self.sublabel:SetHAlign(ANCHOR_MIDDLE)
    self.sublabel:SetPosition(0.0, -fontSize - 2.0, 0.0)
end)

function ProgressBar:SetPercent(val)
    self.percent = val
    self:InternalUpdate()
end

function ProgressBar:SetLabel(text)
    self.label:SetString(text)
end

function ProgressBar:SetSubLabel(text)
    self.sublabel:SetString(text)
end

function ProgressBar:SetColor(color)
    self.barimage:SetTint(color.r, color.g, color.b, color.a)
end

function ProgressBar:InternalUpdate()
    local width = self.width * (self.percent / 100.0)
    self.barimage:ScaleToSize(width, self.height)
    self.barimage:SetPosition((width - self.width) / 2.0, 0.0, 0.0)
end

return ProgressBar
