LarthUF.ROGUE = {}
LarthUF.ROGUE.Init = function()
  local LarthNotify = CreateFrame("Frame", "LarthNotify", UIParent)
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
     local needed = select(1, UnitAura("player", "Deadly Poison"))
     if needed then
       LarthNotify:Hide()
     else
       LarthNotify:Show()
     end
  end)
end
