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
	 LarthUF["boss"..i] = {}
	 LarthUF["boss"..i].Frame = CreateFrame("Button", "button_boss"..i, UIParent, "SecureUnitButtonTemplate ");
	 LarthUF["boss"..i].Frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	 LarthUF["boss"..i].Frame:SetAttribute('type1', 'target')
	 LarthUF["boss"..i].Frame:SetAttribute('unit', "boss"..i)
	 LarthUF["boss"..i].Frame:SetWidth(50)
	 LarthUF["boss"..i].Frame:SetHeight(40)
	 LarthUF["boss"..i].Frame:Show()
	 LarthUF["boss"..i].Frame:SetPoint("RIGHT", -20, 100-i*50)
	 LarthUF.setText("boss"..i, "Name", "TOPRIGHT", 20)
	 LarthUF.setText("boss"..i, "Health", "BOTTOMLEFT", 20)
	 LarthUF.setText("boss"..i, "Power", "BOTTOMRIGHT", 20)

	 LarthUF["boss"..i].Frame:SetScript("OnUpdate", function(self, elapsed)
		 if UnitExists("boss"..i) then
			 LarthUF["boss"..i].Name:SetText(UnitName("boss"..i))
			 local health = UnitHealth("boss"..i)
			 local maxHealth = UnitHealthMax("boss"..i)
			 local percent = LarthUF.round(100*health/maxHealth, 0)
			 LarthUF["boss"..i].Health:SetText(LarthUF.round(percent))
			 local power = UnitPower("boss"..i)
			 if (power > 0) then
				 local maxPower = UnitPowerMax("boss"..i)
				 LarthUF["boss"..i].Power:SetText(LarthUF.round(100*power/maxPower))
			 end
		 else
			 LarthUF["boss"..i].Health:SetText("")
			 LarthUF["boss"..i].Name:SetText("")
			 LarthUF["boss"..i].Power:SetText("")
		 end
	 end)
 end
