local larthUnitFrame = {}
local larthUnitButton = {}
local larthUnitName = {}
local larthUnitHealth = {}

-- -----------------------------------------------------------------------------
-- RaidFrames
-- -----------------------------------------------------------------------------
local function round(number, decimals)
    return tonumber((("%%.%df"):format(decimals)):format(number))
end

for i = 1, 40, 1 do

	--Create the Frame
	larthUnitFrame["raid"..i] = CreateFrame("Button", "button_raid"..i, UIParent, "SecureUnitButtonTemplate ");	
	larthUnitFrame["raid"..i]:SetAttribute('type1', 'target')
	larthUnitFrame["raid"..i]:SetAttribute('unit', "raid"..i)
	larthUnitFrame["raid"..i]:SetWidth(100)
	larthUnitFrame["raid"..i]:SetHeight(20)
	--Position the Frame
	if i <= 25 then 
		larthUnitFrame["raid"..i]:SetPoint("TOPLEFT", 15, -150-i*20)
	else
		larthUnitFrame["raid"..i]:SetPoint("TOPLEFT", 120, -150-(i-25)*20)
	end
	larthUnitFrame["raid"..i]:Show()
	larthUnitName["raid"..i] = larthUnitFrame["raid"..i]:CreateFontString(nil, "OVERLAY")
	larthUnitName["raid"..i]:SetPoint("LEFT")
	larthUnitName["raid"..i]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
	larthUnitName["raid"..i]:SetTextColor(1, 1, 1)
	
	larthUnitHealth["raid"..i] = larthUnitFrame["raid"..i]:CreateFontString(nil, "OVERLAY")
	larthUnitHealth["raid"..i]:SetPoint("RIGHT")
	larthUnitHealth["raid"..i]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
	larthUnitHealth["raid"..i]:SetTextColor(1, 1, 1)
	
	
	larthUnitFrame["raid"..i]:RegisterEvent("READY_CHECK_FINISHED")
	larthUnitFrame["raid"..i]:RegisterEvent("READY_CHECK_CONFIRM")
	larthUnitFrame["raid"..i]:RegisterEvent("GROUP_ROSTER_UPDATE")
	
	larthUnitFrame["raid"..i]:SetScript("OnEvent", function(self, event, ...)
		if UnitExists("raid"..i) then 
			if (event == "GROUP_ROSTER_UPDATE") then			
				local class, classFileName = UnitClass("raid"..i)
				larthUnitName["raid"..i]:SetText(UnitName("raid"..i))
				larthUnitName["raid"..i]:SetTextColor(RAID_CLASS_COLORS[classFileName].r, RAID_CLASS_COLORS[classFileName].g, RAID_CLASS_COLORS[classFileName].b)
			elseif (event == "READY_CHECK_CONFIRM") then
				if (GetReadyCheckStatus("raid"..i)) then 
					larthUnitHealth["raid"..i]:SetTextColor(0, 1, 0)
				else
					larthUnitHealth["raid"..i]:SetTextColor(1, 0, 0)
				end
			elseif (event == "READY_CHECK_FINISHED") then
			end
		end
	end)
	
	
	larthUnitFrame["raid"..i]:SetScript("OnUpdate", function(self, elapsed)
		if UnitExists("raid"..i) then 
			local health = UnitHealth("raid"..i)
			local maxHealth = UnitHealthMax("raid"..i)
			larthUnitHealth["raid"..i]:SetText(round(100*health/maxHealth, 0))
		else
			larthUnitHealth["raid"..i]:SetText("")
			larthUnitName["raid"..i]:SetText("")
		end
	end)
end