local larthUnitFrame = {}
local larthUnitButton = {}
local larthUnitName = {}
local larthUnitHealth = {}
local larthRaidUnit = {}

-- -----------------------------------------------------------------------------
-- RaidFrames
-- -----------------------------------------------------------------------------
local function round(number, decimals)
    return tonumber((("%%.%df"):format(decimals)):format(number))
end

larthRaidFrame = CreateFrame("Frame")

larthRaidFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
larthRaidFrame:RegisterEvent("PLAYER_ROLES_ASSIGNED")
larthRaidFrame:SetScript("OnEvent", function(self, event, ...)
	for i = 1, 40, 1 do
		if UnitExists("raid"..i) then 
			larthUnitFrame["raid"..i]:Show()
		else
			larthUnitFrame["raid"..i]:Hide()
		end
	end
end)
for i = 1, 40, 1 do
	
	--Create the Frame
	larthUnitFrame["raid"..i] = CreateFrame("Button", "button_raid"..i, UIParent, "SecureUnitButtonTemplate ");	
	larthUnitFrame["raid"..i]:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	larthUnitFrame["raid"..i]:SetAttribute('type1', 'target')
	larthUnitFrame["raid"..i]:SetAttribute('unit', "raid"..i)
	larthUnitFrame["raid"..i]:SetAttribute('type2', 'spell')
	larthUnitFrame["raid"..i]:SetAttribute('spell', "Schurkenhandel")
	larthUnitFrame["raid"..i]:SetWidth(100)
	larthUnitFrame["raid"..i]:SetHeight(20)
	--Position the Frame
	if i <= 25 then 
		larthUnitFrame["raid"..i]:SetPoint("TOPLEFT", 15, -150-i*20)
	else
		larthUnitFrame["raid"..i]:SetPoint("TOPLEFT", 120, -150-(i-25)*20)
	end
	larthUnitFrame["raid"..i]:Hide()
	larthUnitName["raid"..i] = larthUnitFrame["raid"..i]:CreateFontString(nil, "OVERLAY")
	larthUnitName["raid"..i]:SetPoint("LEFT")
	larthUnitName["raid"..i]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
	larthUnitName["raid"..i]:SetTextColor(1, 1, 1)
	
	larthUnitHealth["raid"..i] = larthUnitFrame["raid"..i]:CreateFontString(nil, "OVERLAY")
	larthUnitHealth["raid"..i]:SetPoint("RIGHT")
	larthUnitHealth["raid"..i]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
	larthUnitHealth["raid"..i]:SetTextColor(1, 1, 1)
	
	

	larthUnitFrame["raid"..i]:RegisterEvent("GROUP_ROSTER_UPDATE")
	larthUnitFrame["raid"..i]:RegisterEvent("PLAYER_ROLES_ASSIGNED")

	larthUnitFrame["raid"..i]:SetScript("OnEvent", function(self, event, ...)	
		if UnitExists("raid"..i) then 
			larthRaidUnit["raid"..i] = {}		
			local class, classFileName = UnitClass("raid"..i)
			local role = UnitGroupRolesAssigned("raid"..i)
			local derSring = ""
			larthRaidUnit["raid"..i].role = role
			if role == "DAMAGER" then
				derString = format("|cff%s%s|r", "ff9933", "D: ")
			elseif role == "HEALER" then
				derString = format("|cff%s%s|r", "33ff33", "H: ")
			elseif role == "TANK" then
				derString = format("|cff%s%s|r", "ccff33", "T: ")
			else
				derString = format("|cff%s%s|r", "ffffff", "_: ")
			end
			larthUnitName["raid"..i]:SetText(derString..UnitName("raid"..i))

			if (classFileName) then
				larthUnitName["raid"..i]:SetTextColor(RAID_CLASS_COLORS[classFileName].r, RAID_CLASS_COLORS[classFileName].g, RAID_CLASS_COLORS[classFileName].b)
			end		
		end
	end)
	
	
	larthUnitFrame["raid"..i]:SetScript("OnUpdate", function(self, elapsed)
		if UnitExists("raid"..i) then 
			local health = UnitHealth("raid"..i)
			local maxHealth = UnitHealthMax("raid"..i)
			local percent = round(100*health/maxHealth, 0)
			larthUnitHealth["raid"..i]:SetText(round(percent))
			larthUnitHealth["raid"..i]:SetTextColor(1-(percent/100), (percent/100), 0)
		else
			larthUnitHealth["raid"..i]:SetText("")
			larthUnitName["raid"..i]:SetText("")
		end
	end)
	
	larthUnitFrame["raid"..i]:SetScript("OnEnter", function(self, elapsed)
		larthUnitName["raid"..i]:SetTextColor(0.7, 0.7, 0.7)
	end)
	
	
	larthUnitFrame["raid"..i]:SetScript("OnLeave", function(self, elapsed)
		local class, classFileName = UnitClass("raid"..i)
		if (classFileName) then
			larthUnitName["raid"..i]:SetTextColor(RAID_CLASS_COLORS[classFileName].r, RAID_CLASS_COLORS[classFileName].g, RAID_CLASS_COLORS[classFileName].b)
		end
	end)

end