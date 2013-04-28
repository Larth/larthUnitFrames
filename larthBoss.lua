-- -----------------------------------------------------------------------------
-- BossFrames
-- -----------------------------------------------------------------------------
Boss1TargetFrame:UnregisterAllEvents()
Boss1TargetFrame:Hide()
Boss2TargetFrame:UnregisterAllEvents()
Boss2TargetFrame:Hide()
Boss3TargetFrame:UnregisterAllEvents()
Boss3TargetFrame:Hide()
Boss4TargetFrame:UnregisterAllEvents()
Boss4TargetFrame:Hide()
Boss5TargetFrame:UnregisterAllEvents()
Boss5TargetFrame:Hide()

for i = 1, 5, 1 do
	
	LarthUnitFrames["boss"..i] = CreateFrame("Button", "button_boss"..i, UIParent, "SecureUnitButtonTemplate ");	
	LarthUnitFrames["boss"..i]:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	LarthUnitFrames["boss"..i]:SetAttribute('type1', 'target')
	LarthUnitFrames["boss"..i]:SetAttribute('unit', "boss"..i)
	LarthUnitFrames["boss"..i]:SetWidth(50)
	LarthUnitFrames["boss"..i]:SetHeight(40)
	LarthUnitFrames["boss"..i]:Show()

	LarthUnitFrames["boss"..i]:SetPoint("RIGHT", -20, 100-i*50)
	
	LarthUnitFrames["boss"..i].Name = LarthUnitFrames["boss"..i]:CreateFontString(nil, "OVERLAY")
	LarthUnitFrames["boss"..i].Name:SetPoint("TOPRIGHT")
	LarthUnitFrames["boss"..i].Name:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 20, "OUTLINE")
	LarthUnitFrames["boss"..i].Name:SetTextColor(1, 1, 1)
	
	LarthUnitFrames["boss"..i].Health = LarthUnitFrames["boss"..i]:CreateFontString(nil, "OVERLAY")
	LarthUnitFrames["boss"..i].Health:SetPoint("BOTTOMLEFT")
	LarthUnitFrames["boss"..i].Health:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 20, "OUTLINE")
	LarthUnitFrames["boss"..i].Health:SetTextColor(1, 0, 0)
	
	LarthUnitFrames["boss"..i].Power = LarthUnitFrames["boss"..i]:CreateFontString(nil, "OVERLAY")
	LarthUnitFrames["boss"..i].Power:SetPoint("BOTTOMRIGHT")
	LarthUnitFrames["boss"..i].Power:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 20, "OUTLINE")
	LarthUnitFrames["boss"..i].Power:SetTextColor(0.5, 0.5, 1)
	
	
	LarthUnitFrames["boss"..i]:SetScript("OnUpdate", function(self, elapsed)
		if UnitExists("boss"..i) then 
			LarthUnitFrames["boss"..i].Name:SetText(UnitName("boss"..i))
			local health = UnitHealth("boss"..i)
			local maxHealth = UnitHealthMax("boss"..i)
			local percent = LarthUnitFrames.round(100*health/maxHealth, 0)
			LarthUnitFrames["boss"..i].Health:SetText(LarthUnitFrames.round(percent))
			local power = UnitPower("boss"..i)
			local maxPower = UnitPowerMax("boss"..i)
			LarthUnitFrames["boss"..i].Power:SetText(LarthUnitFrames.round(100*power/maxPower))
		else
			LarthUnitFrames["boss"..i].Health:SetText("")
			LarthUnitFrames["boss"..i].Name:SetText("")
			LarthUnitFrames["boss"..i].Power:SetText("")
		end
	end)

end