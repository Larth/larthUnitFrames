-- -----------------------------------------------------------------------------
-- Config
-- -----------------------------------------------------------------------------

local roguePlayerAuras = { {"Zerh\195\164ckseln", "ffff00"}, {"Vergiften", "00ff00"}, {"Schattenklingen", "ff00ff"} }
local rogueTargetAuras = { {"Blutung", "ff0000"}, {"Vendetta", "ffffff"} }


local dkPlayerAuras = { }
local dkTargetAuras = { {"Frostfieber", "6666ff"}, {"Blutseuche", "00ff00"} }



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
local localizedClass, englishClass, classIndex
local targetWatch, playerWatch 
local larthUnitFrame = { }
local larthUnitName = { }
local larthUnitHealth = { }
	
local function round(number, decimals)
    return tonumber((("%%.%df"):format(decimals)):format(number))
end


-- -----------------------------------------------------------------------------
-- Generate the health strings for player and target.
-- -----------------------------------------------------------------------------
local function longHealthString(health)
	local derString = ""
	local lifef = round(health, 0)
	for i=0, 100, 10 do
		if lifef >= i and lifef < i+10 then
			derString = derString..format("|cff%s%s|r", "ff0000", lifef)
		else
			derString = derString..i
		end
	end
	return derString
end


local function trimUnitName(unitName)
	local derString = ""
	if (strlen(unitName) < 20) then
		return unitName
	else
		for x in string.gmatch(unitName, "[^%s]+") do
			if strlen(x) > 10 then 
				derString = derString..strsub(x, 1, 7)..". "
			else 
				derString = derString..x.." "
			end
		end
		return derString
	end
end
local function runeColoring(runeType)
	local derString = ""
	if (runeType == 1) then
		derString = "ff0000"
	elseif (runeType == 2) then
		derString = "00ff00"
	elseif (runeType == 3) then
		derString = "6666ff"
	elseif (runeType == 4) then
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
	if (classIndex == 6) then
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
	end
	
	local debuffString = ""
	for i=1, # targetWatch do
		local _, _, _, _, _, _, expirationTime, unitCaster = UnitDebuff("target", targetWatch[i][1])
		if(unitCaster=="player")then 
			debuffString = debuffString..format("|cff%s%s|r", targetWatch[i][2], (round(expirationTime - GetTime()).." "))
		end
	end
	targetAuraText:SetText(debuffString)
	
	local buffString = ""
	if ( playerWatch) then
		for i=1, # playerWatch do
			local _, _, _, _, _, _, expirationTime, unitCaster = UnitBuff("player", playerWatch[i][1])
			if(unitCaster=="player")then 
				buffString = buffString..format("|cff%s%s|r", playerWatch[i][2], (round(expirationTime - GetTime()).." "))
			end
		end
		playerAuraText:SetText(buffString)
	end
	
	if UnitExists("targettarget") then 
		larthUnitName["targetTarget"]:SetText(UnitName("targettarget"))
	else
		larthUnitName["targetTarget"]:SetText("")
	end
end)
-- -----------------------------------------------------------------------------
-- Register event
-- -----------------------------------------------------------------------------
larthUnitFrames:RegisterEvent("UNIT_HEALTH")
larthUnitFrames:RegisterEvent("VARIABLES_LOADED")
larthUnitFrames:RegisterEvent("GROUP_ROSTER_UPDATE")


larthUnitFrames:SetScript("OnEvent", function(self, event, ...)
	local unit = ...
	if ( unit == "player") then
		health = UnitHealth("player")
		maxHealth = UnitHealthMax("player")
		larthUnitHealth["player"]:SetText(longHealthString(100*health/maxHealth))
	elseif (unit == "target") then
		health = UnitHealth("target")
		maxHealth = UnitHealthMax("target")
		targetHealthText:SetText(longHealthString(100*health/maxHealth))
	elseif (unit and strsub(unit,1 ,4) == "raid") then		
		health = UnitHealth(unit)
		maxHealth = UnitHealthMax(unit)
		if ( larthUnitHealth[unit] ) then
			larthUnitHealth[unit]:SetText(round(100*health/maxHealth, 0))
		end
	elseif (event == "GROUP_ROSTER_UPDATE") then
		for i = 1, 40, 1 do
			if(UnitName("raid"..i)) then
				larthUnitName["raid"..i]:SetText(UnitName("raid"..i))
				larthUnitHealth["raid"..i]:SetText("100")
			else
				larthUnitName["raid"..i]:SetText("")
				larthUnitHealth["raid"..i]:SetText("")
			end
		end
	elseif (event == "VARIABLES_LOADED") then
		localizedClass, englishClass, classIndex = UnitClass("player")
		PlayerFrame:ClearAllPoints()
		PlayerFrame:SetPoint("RIGHT",UIParent,"CENTER",-150,0)
		PlayerFrame.SetPoint=function()end
		TargetFrame:ClearAllPoints()
		TargetFrame:SetPoint("LEFT",UIParent,"CENTER",150,0)
		TargetFrame.SetPoint=function()end
		health = UnitHealth("player")
		maxHealth = UnitHealthMax("player")
		PlayerFrame:SetAlpha(0)
		TargetFrame:SetAlpha(0)
		if (classIndex == 6) then
			RuneFrame:SetAlpha(0)
			targetWatch	=	dkTargetAuras
		end
		if (classIndex == 4) then 
			targetWatch = rogueTargetAuras
			playerWatch = roguePlayerAuras
			ComboPoint1:SetAlpha(0) 
			ComboPoint2:SetAlpha(0) 
			ComboPoint3:SetAlpha(0) 
			ComboPoint4:SetAlpha(0) 
			ComboPoint5:SetAlpha(0) 
		end
		larthUnitHealth["player"]:SetText(longHealthString(100))
		playerName = UnitName("player")
		playerNameText:SetText(trimUnitName(playerName))
	end
end)



-- -----------------------------------------------------------------------------
-- Create Target frame
-- -----------------------------------------------------------------------------
local larthTargetUnitFrame = CreateFrame("Frame", "larthTargetUnitFrame", UIParent)
larthTargetUnitFrame:SetFrameLevel(3)
larthTargetUnitFrame:SetWidth(200)
larthTargetUnitFrame:SetHeight(50)
larthTargetUnitFrame:SetPoint("CENTER", 250, 0)
larthTargetUnitFrame:Show()

targetHealthText = larthTargetUnitFrame:CreateFontString(nil, "OVERLAY")
targetHealthText:SetPoint("LEFT")
targetHealthText:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 20, "THINOUTLINE")
targetHealthText:SetTextColor(1, 1, 1)

targetComboPoints = larthTargetUnitFrame:CreateFontString(nil, "OVERLAY")
targetComboPoints:SetPoint("BOTTOMLEFT")
targetComboPoints:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 18, "THINOUTLINE")
targetComboPoints:SetTextColor(1, 1, 1)

targetNameText = larthTargetUnitFrame:CreateFontString(nil, "OVERLAY")
targetNameText:SetPoint("TOPRIGHT")
targetNameText:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
targetNameText:SetTextColor(1, 1, 1)

targetAuraText = larthTargetUnitFrame:CreateFontString(nil, "OVERLAY")
targetAuraText:SetPoint("TOPLEFT")
targetAuraText:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
targetAuraText:SetTextColor(1, 1, 1)

larthTargetUnitFrame:RegisterEvent("UNIT_COMBO_POINTS")
larthTargetUnitFrame:RegisterEvent("UNIT_TARGET")
larthTargetUnitFrame:SetScript("OnEvent", function(self, event, ...)	
	local comboPoints = GetComboPoints("player", "target");
	local arg1 = ...
	if ( event == "UNIT_TARGET" and arg1 == "player") then
		if UnitExists("target") then 
			health = UnitHealth("target")
			maxHealth = UnitHealthMax("target")
			targetHealthText:SetText(longHealthString(100*health/maxHealth))
			targetName = UnitName("target")
			targetNameText:SetText(trimUnitName(targetName))
		else 
			targetHealthText:SetText("")
			targetNameText:SetText("")
		end
	end
	if ( comboPoints < 1 ) then
		targetComboPoints:SetText("")
	elseif (comboPoints < 3) then 
		targetComboPoints:SetText(comboPoints)
	elseif (comboPoints < 5) then 
		targetComboPoints:SetText(format("|cff%s%s|r", "ff9900", comboPoints))
	else 
		targetComboPoints:SetText(format("|cff%s%s|r", "ff0000", comboPoints))
	end
end)


-- -----------------------------------------------------------------------------
-- Create Target of Target frame
-- -----------------------------------------------------------------------------
larthUnitFrame["targettarget"] = CreateFrame("Frame", "larthUnitFramePlayer", UIParent)
larthUnitFrame["targettarget"]:SetFrameLevel(3)
larthUnitFrame["targettarget"]:SetWidth(100)
larthUnitFrame["targettarget"]:SetHeight(40)
larthUnitFrame["targettarget"]:SetPoint("CENTER", 400, 0)
larthUnitFrame["targettarget"]:Show()

larthUnitName["targetTarget"] = larthUnitFrame["targettarget"]:CreateFontString(nil, "OVERLAY")
larthUnitName["targetTarget"]:SetPoint("CENTER")
larthUnitName["targetTarget"]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 20, "OUTLINE")
larthUnitName["targetTarget"]:SetTextColor(1, 1, 1)

-- -----------------------------------------------------------------------------
-- Create Player frame
-- -----------------------------------------------------------------------------
larthUnitFrame["player"] = CreateFrame("Frame", "larthPlayerUnitFrame", UIParent)
larthUnitFrame["player"]:SetFrameLevel(3)
larthUnitFrame["player"]:SetWidth(200)
larthUnitFrame["player"]:SetHeight(50)
larthUnitFrame["player"]:SetPoint("CENTER", -250, 0)
larthUnitFrame["player"]:Show()

larthUnitHealth["player"] = larthUnitFrame["player"]:CreateFontString(nil, "OVERLAY")
larthUnitHealth["player"]:SetPoint("RIGHT")
larthUnitHealth["player"]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 20, "OUTLINE")
larthUnitHealth["player"]:SetTextColor(1, 1, 1)

playerEnergyText = larthUnitFrame["player"]:CreateFontString(nil, "OVERLAY")
playerEnergyText:SetPoint("BOTTOMRIGHT")
playerEnergyText:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
playerEnergyText:SetTextColor(1, 1, 1)

playerNameText = larthUnitFrame["player"]:CreateFontString(nil, "OVERLAY")
playerNameText:SetPoint("TOPLEFT")
playerNameText:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
playerNameText:SetTextColor(1, 1, 1)


playerSpecialText = larthUnitFrame["player"]:CreateFontString(nil, "OVERLAY")
playerSpecialText:SetPoint("BOTTOMLEFT")
playerSpecialText:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
playerSpecialText:SetTextColor(1, 1, 1)

playerAuraText = larthUnitFrame["player"]:CreateFontString(nil, "OVERLAY")
playerAuraText:SetPoint("TOPRIGHT")
playerAuraText:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
playerAuraText:SetTextColor(1, 1, 1)



-- -----------------------------------------------------------------------------
-- RaidFrames
-- -----------------------------------------------------------------------------

for i = 1, 40, 1 do
	larthUnitFrame["raid"..i] = CreateFrame("Frame", "larthPlayerUnitFrame"..i, UIParent)
	larthUnitFrame["raid"..i]:SetFrameLevel(3)
	larthUnitFrame["raid"..i]:SetWidth(100)
	larthUnitFrame["raid"..i]:SetHeight(30)
	if i <= 25 then 
		larthUnitFrame["raid"..i]:SetPoint("TOPLEFT", 10, -150-i*20)
	else
		larthUnitFrame["raid"..i]:SetPoint("TOPLEFT", 110, -150-(i-25)*20)
	end
	larthUnitFrame["raid"..i]:Show()
	larthUnitName["raid"..i] = larthUnitFrame["raid"..i]:CreateFontString(nil, "OVERLAY")
	larthUnitName["raid"..i]:SetPoint("TOPLEFT")
	larthUnitName["raid"..i]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
	larthUnitName["raid"..i]:SetTextColor(1, 1, 1)
	
	larthUnitHealth["raid"..i] = larthUnitFrame["raid"..i]:CreateFontString(nil, "OVERLAY")
	larthUnitHealth["raid"..i]:SetPoint("BOTTOMRIGHT")
	larthUnitHealth["raid"..i]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
	larthUnitHealth["raid"..i]:SetTextColor(1, 1, 1)
end
