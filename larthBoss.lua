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
	LarthUnitFrames["boss"..i] = {}
	LarthUnitFrames["boss"..i].Frame = CreateFrame("Button", "button_boss"..i, UIParent, "SecureUnitButtonTemplate ");	
	LarthUnitFrames["boss"..i].Frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	LarthUnitFrames["boss"..i].Frame:SetAttribute('type1', 'target')
	LarthUnitFrames["boss"..i].Frame:SetAttribute('unit', "boss"..i)
	LarthUnitFrames["boss"..i].Frame:SetWidth(50)
	LarthUnitFrames["boss"..i].Frame:SetHeight(40)
	LarthUnitFrames["boss"..i].Frame:Show()
	LarthUnitFrames["boss"..i].Frame:SetPoint("RIGHT", -20, 100-i*50)	
	LarthUnitFrames.setText("boss"..i, "Name", "TOPRIGHT", 20)
	LarthUnitFrames.setText("boss"..i, "Health", "BOTTOMLEFT", 20)
	LarthUnitFrames.setText("boss"..i, "Power", "BOTTOMRIGHT", 20)

	LarthUnitFrames["boss"..i].Frame:SetScript("OnUpdate", function(self, elapsed)
		if UnitExists("boss"..i) then 
			LarthUnitFrames["boss"..i].Name:SetText(UnitName("boss"..i))
			local health = UnitHealth("boss"..i)
			local maxHealth = UnitHealthMax("boss"..i)
			local percent = LarthUnitFrames.round(100*health/maxHealth, 0)
			LarthUnitFrames["boss"..i].Health:SetText(LarthUnitFrames.round(percent))
			local power = UnitPower("boss"..i)
			if (power > 0) then 
				local maxPower = UnitPowerMax("boss"..i)
				LarthUnitFrames["boss"..i].Power:SetText(LarthUnitFrames.round(100*power/maxPower))
			end
		else
			LarthUnitFrames["boss"..i].Health:SetText("")
			LarthUnitFrames["boss"..i].Name:SetText("")
			LarthUnitFrames["boss"..i].Power:SetText("")
		end
	end)

end