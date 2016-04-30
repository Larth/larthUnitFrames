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
	 LarthUF.Frames["boss"..i] = CreateFrame("Button", "button_boss"..i, UIParent, "SecureUnitButtonTemplate ");
	 LarthUF.Frames["boss"..i]:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	 LarthUF.Frames["boss"..i]:SetAttribute('type1', 'target')
	 LarthUF.Frames["boss"..i]:SetAttribute('unit', "boss"..i)
	 LarthUF.Frames["boss"..i]:SetWidth(50)
	 LarthUF.Frames["boss"..i]:SetHeight(40)
	 LarthUF.Frames["boss"..i]:Show()
	 LarthUF.Frames["boss"..i]:SetPoint("RIGHT", -20, 100-i*50)
	 LarthUF.setText("boss"..i, "Name", "TOPRIGHT", 20)
	 LarthUF.setText("boss"..i, "Health", "BOTTOMLEFT", 20)
	 LarthUF.setText("boss"..i, "Power", "BOTTOMRIGHT", 20)

	 LarthUF.Frames["boss"..i]:SetScript("OnUpdate", function(self, elapsed)
		 if UnitExists("boss"..i) then
			 LarthUF["boss"..i].Name:SetText(LarthUF.trimUnitName(UnitName("boss"..i)))
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
