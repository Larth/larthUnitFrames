-- -----------------------------------------------------------------------------
-- Variables
-- -----------------------------------------------------------------------------
local energy = UnitPower("player")
local maxEnergy = UnitPowerMax("player")
local health = UnitHealth("player")
local maxHealth = UnitHealthMax("player")
local targetName = ""
local playerName = ""
local classProfile = 0
local localizedClass, englishClass, classIndex = ""
	
local function round(number, decimals)
    return tonumber((("%%.%df"):format(decimals)):format(number))
end


-- -----------------------------------------------------------------------------
-- Generate the health strings for player and target.
-- -----------------------------------------------------------------------------
local function longHealthString(health)
	local derString = ""
	local lifef = round(health, 0)
	for i=10, 100, 10 do
		--if round(health, 0) >= round(i, 0) and round(health, 0) < round(i+10, 0) then
		if lifef >= i and lifef < i+10 then
			derString = derString..format("|cff%s%s|r", "ff0000", lifef)
		else
			derString = derString..i
		end
	end
	return derString
end

local function runeColoring(runeid)
	local derString = ""
	if (runeid == 1) then
		derString = "ff0000"
	elseif (runeid == 2) then
		derString = "00ff00"
	elseif (runeid == 3) then
		derString = "0000ff"
	elseif (runeid == 4) then
		derString = "ff00ff"
	end
	return derString
end
-- -----------------------------------------------------------------------------
-- Create addon frame
-- -----------------------------------------------------------------------------

local larthUnitFrames = CreateFrame("Frame")

larthUnitFrames:SetScript("OnUpdate", function(self, elapsed)
		energy = UnitPower("player")
		maxEnergy = UnitPowerMax("player")
		playerEnergyText:SetText(longHealthString(100*energy/maxEnergy, 0))
		

		local tempString = ""
		for i=1, 6, 1 do
			local start, duration, runeReady = GetRuneCooldown(i)
			runeType = GetRuneType(i)
			if runeReady then
				tempString = tempString..format("|cff%s%s|r", runeColoring(runeType), "#")
			else
				tempString = tempString..format("|cff%s%s|r", runeColoring(runeType), "_")
			end
		end
		playerSpecialText:SetText(tempString)
end)
-- -----------------------------------------------------------------------------
-- Register event
-- -----------------------------------------------------------------------------
larthUnitFrames:RegisterEvent("UNIT_HEALTH")
larthUnitFrames:RegisterEvent("VARIABLES_LOADED")


larthUnitFrames:SetScript("OnEvent", function(self, event, ...)
	local unit = ...
	if ( unit == "player") then
		health = UnitHealth("player")
		maxHealth = UnitHealthMax("player")
		playerHealthText:SetText(longHealthString(100*health/maxHealth))
	elseif (unit == "target") then
		health = UnitHealth("target")
		maxHealth = UnitHealthMax("target")
		targetHealthText:SetText(longHealthString(100*health/maxHealth))
	elseif (event == "VARIABLES_LOADED") then
		PlayerFrame:ClearAllPoints()
		PlayerFrame:SetPoint("RIGHT",UIParent,"CENTER",-150,0)
		PlayerFrame.SetPoint=function()end
		TargetFrame:ClearAllPoints()
		TargetFrame:SetPoint("LEFT",UIParent,"CENTER",150,0)
		TargetFrame.SetPoint=function()end
		health = UnitHealth("player")
		maxHealth = UnitHealthMax("player")
		PlayerFrame:SetAlpha(0)
		print(classIndex)
		if ( classIndex == 6 ) then
			RuneFrame:SetAlpha(0)
		end
		TargetFrame:SetAlpha(0)
		playerHealthText:SetText(longHealthString(100*health/maxHealth))
		playerName = UnitName("player")
		playerNameText:SetText(playerName)
	end
end)



-- -----------------------------------------------------------------------------
-- Create Target frame
-- -----------------------------------------------------------------------------
local targetHealth = CreateFrame("Frame", "targetHealth", UIParent)
targetHealth:SetFrameLevel(3)
targetHealth:SetWidth(200)
targetHealth:SetHeight(50)
targetHealth:SetPoint("CENTER", 250, 0)
targetHealth:Show()

targetHealthText = targetHealth:CreateFontString(nil, "OVERLAY")
targetHealthText:SetPoint("LEFT")
targetHealthText:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 20, "THINOUTLINE")
targetHealthText:SetTextColor(1, 1, 1)

targetComboPoints = targetHealth:CreateFontString(nil, "OVERLAY")
targetComboPoints:SetPoint("BOTTOMLEFT")
targetComboPoints:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
targetComboPoints:SetTextColor(1, 1, 1)

targetNameText = targetHealth:CreateFontString(nil, "OVERLAY")
targetNameText:SetPoint("TOPRIGHT")
targetNameText:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
targetNameText:SetTextColor(1, 1, 1)

targetHealth:RegisterEvent("UNIT_COMBO_POINTS")
targetHealth:RegisterEvent("UNIT_TARGET")
targetHealth:SetScript("OnEvent", function(self, event, ...)	
	local comboPoints = GetComboPoints("player", "target");
	local arg1 = ...
	if ( event == "UNIT_TARGET" and arg1 == "player") then
		if UnitExists("target") then 
			health = UnitHealth("target")
			maxHealth = UnitHealthMax("target")
			targetHealthText:SetText(longHealthString(100*health/maxHealth))
			targetName = UnitName("target")
			targetNameText:SetText(targetName)
		else 
			targetHealthText:SetText("")
			targetNameText:SetText("")
		end
	elseif ( comboPoints < 1 ) then
		targetComboPoints:SetText("")
	else 
		targetComboPoints:SetText(comboPoints)
	end
end)


-- -----------------------------------------------------------------------------
-- Create Player frame
-- -----------------------------------------------------------------------------
local playerHealth = CreateFrame("Frame", "playerHealth", UIParent)
playerHealth:SetFrameLevel(3)
playerHealth:SetWidth(200)
playerHealth:SetHeight(50)
playerHealth:SetPoint("CENTER", -250, 0)
playerHealth:Show()

playerHealthText = playerHealth:CreateFontString(nil, "OVERLAY")
playerHealthText:SetPoint("RIGHT")
playerHealthText:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 20, "THINOUTLINE")
playerHealthText:SetTextColor(1, 1, 1)

playerEnergyText = playerHealth:CreateFontString(nil, "OVERLAY")
playerEnergyText:SetPoint("BOTTOMRIGHT")
playerEnergyText:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
playerEnergyText:SetTextColor(1, 1, 1)

playerNameText = playerHealth:CreateFontString(nil, "OVERLAY")
playerNameText:SetPoint("TOPLEFT")
playerNameText:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
playerNameText:SetTextColor(1, 1, 1)


playerSpecialText = playerHealth:CreateFontString(nil, "OVERLAY")
playerSpecialText:SetPoint("BOTTOMLEFT")
playerSpecialText:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
playerSpecialText:SetTextColor(1, 1, 1)

local localizedClass, englishClass, classIndex = UnitClass("player");


