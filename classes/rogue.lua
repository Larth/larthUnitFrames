LarthUF.ROGUE = {}
LarthUF.ROGUE.Init = function()
  local LarthNotify = CreateFrame("Button", "LarthNotify", UIParent, "SecureActionButtonTemplate")
  LarthNotify:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  -- this works for whatever reason
  -- for Instant Poison both clicks work, if your spec uses
  -- Deadly Poison only RightButtonUp works
  LarthNotify:SetAttribute('spell2', 'Deadly Poison')
  LarthNotify:SetAttribute('type', 'spell')
  LarthNotify:SetAttribute('spell', 'Instant Poison')
  LarthNotify:SetFrameStrata("BACKGROUND")
  LarthNotify:SetWidth(100)
  LarthNotify:SetHeight(100)
  LarthNotify:SetAlpha(1.0)
  local LarthNotifyTexture = LarthNotify:CreateTexture(nil,"BACKGROUND")
  LarthNotifyTexture:SetTexture(GetSpellTexture(2823))
  LarthNotifyTexture:SetAllPoints(LarthNotify)
  LarthNotify.texture = LarthNotifyTexture
  LarthNotify:SetPoint("CENTER", 0, 200)

  LarthNotify:RegisterEvent("UNIT_AURA")
  LarthNotify:RegisterEvent("PLAYER_ENTERING_WORLD")
  LarthNotify:RegisterEvent("RAID_INSTANCE_WELCOME")
  LarthNotify:SetScript("OnEvent", function(self, event, ...)
    local hasPoison = false
    if select(1,UnitAura("player", "Instant Poison")) then
      hasPoison = true
    elseif select(1, UnitAura("player", "Wound Poison")) then
      hasPoison = true
    elseif select(1, UnitAura("player", "Deadly Poison")) then
      hasPoison = true
    end
    if LarthNotify:IsShown() and hasPoison then
      LarthNotify:Hide()
    end
    if not LarthNotify:IsShown() and not hasPoison then
      LarthNotify:Show()
    end
  end)
end
