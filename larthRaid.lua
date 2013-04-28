-- -----------------------------------------------------------------------------
-- RaidFrames
-- -----------------------------------------------------------------------------


-- what was I thinking?
larthRaidFrame = CreateFrame("Frame")
larthRaidFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
larthRaidFrame:RegisterEvent("PLAYER_ROLES_ASSIGNED")
larthRaidFrame:SetScript("OnEvent", function(self, event, ...)
	for i = 1, 40, 1 do
		if UnitExists("raid"..i) then 
			LarthUnitFrames["raid"..i]:Show()
		else
			LarthUnitFrames["raid"..i]:Hide()
		end
	end
end)


-- even though little dps me doesn't care about others
-- there is something like NUM_MAX_RAIDMEMBERS or with a similar name, but who cares
for i = 1, 40, 1 do	
	-- Create the Frame
	LarthUnitFrames["raid"..i] = CreateFrame("Button", "button_raid"..i, UIParent, "SecureUnitButtonTemplate ");	
	LarthUnitFrames["raid"..i]:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	LarthUnitFrames["raid"..i]:SetAttribute('type1', 'target')
	LarthUnitFrames["raid"..i]:SetAttribute('unit', "raid"..i)
	LarthUnitFrames["raid"..i]:SetAttribute('type2', 'spell')
	-- yeah it's only tricks of trade (Schurkenhandel) here, go cry if you're no rogue
	LarthUnitFrames["raid"..i]:SetAttribute('spell', "Schurkenhandel")
	LarthUnitFrames["raid"..i]:SetWidth(100)
	LarthUnitFrames["raid"..i]:SetHeight(20)
	-- Position the Frame
	-- 
	if i <= 25 then 
		LarthUnitFrames["raid"..i]:SetPoint("TOPLEFT", 15, -150-i*20)
	else
		LarthUnitFrames["raid"..i]:SetPoint("TOPLEFT", 120, -150-(i-25)*20)
	end
	LarthUnitFrames["raid"..i]:Hide()
	LarthUnitFrames["raid"..i].Name = LarthUnitFrames["raid"..i]:CreateFontString(nil, "OVERLAY")
	LarthUnitFrames["raid"..i].Name:SetPoint("LEFT")
	LarthUnitFrames["raid"..i].Name:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
	LarthUnitFrames["raid"..i].Name:SetTextColor(1, 1, 1)
	
	LarthUnitFrames["raid"..i].HealthPercent = LarthUnitFrames["raid"..i]:CreateFontString(nil, "OVERLAY")
	LarthUnitFrames["raid"..i].HealthPercent:SetPoint("RIGHT")
	LarthUnitFrames["raid"..i].HealthPercent:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
	LarthUnitFrames["raid"..i].HealthPercent:SetTextColor(1, 1, 1)
	
	LarthUnitFrames["raid"..i]:RegisterEvent("GROUP_ROSTER_UPDATE")
	LarthUnitFrames["raid"..i]:RegisterEvent("PLAYER_ROLES_ASSIGNED")

	LarthUnitFrames["raid"..i]:SetScript("OnEvent", function(self, event, ...)	
		if UnitExists("raid"..i) then 		
			local class, classFileName = UnitClass("raid"..i)
			local role = UnitGroupRolesAssigned("raid"..i)
			local derSring = ""
			-- thought this was stupid, but it proved useful already
			if role == "DAMAGER" then
				derString = format("|cff%s%s|r", "ff9933", "D: ")
			elseif role == "HEALER" then
				derString = format("|cff%s%s|r", "33ff33", "H: ")
			elseif role == "TANK" then
				derString = format("|cff%s%s|r", "ccff33", "T: ")
			else
				derString = format("|cff%s%s|r", "ffffff", "_: ")
			end
			LarthUnitFrames["raid"..i].Name:SetText(derString..strsub(UnitName("raid"..i),1, 10))

			if (classFileName) then
				LarthUnitFrames["raid"..i].Name:SetTextColor(RAID_CLASS_COLORS[classFileName].r, RAID_CLASS_COLORS[classFileName].g, RAID_CLASS_COLORS[classFileName].b)
			end		
		end
	end)
	
	-- guess i could move this to OnEvent
	LarthUnitFrames["raid"..i]:SetScript("OnUpdate", function(self, elapsed)
		if UnitExists("raid"..i) then 
			local health = UnitHealth("raid"..i)
			local maxHealth = UnitHealthMax("raid"..i)
			local percent = LarthUnitFrames.round(100*health/maxHealth, 0)
			LarthUnitFrames["raid"..i].HealthPercent:SetText(LarthUnitFrames.round(percent))
			LarthUnitFrames["raid"..i].HealthPercent:SetTextColor(1-(percent/100), (percent/100), 0)
		else
			LarthUnitFrames["raid"..i].HealthPercent:SetText("")
			LarthUnitFrames["raid"..i].Name:SetText("")
		end
	end)

	-- don't want to accidently hit the heal with tricks, right?
	LarthUnitFrames["raid"..i]:SetScript("OnEnter", function(self, elapsed)
		LarthUnitFrames["raid"..i].Name:SetTextColor(0.7, 0.7, 0.7)
	end)
		
	LarthUnitFrames["raid"..i]:SetScript("OnLeave", function(self, elapsed)
		local class, classFileName = UnitClass("raid"..i)
		if (classFileName) then
			LarthUnitFrames["raid"..i].Name:SetTextColor(RAID_CLASS_COLORS[classFileName].r, RAID_CLASS_COLORS[classFileName].g, RAID_CLASS_COLORS[classFileName].b)
		end
	end)

end