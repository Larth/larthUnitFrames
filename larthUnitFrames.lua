-- -----------------------------------------------------------------------------
-- Config
-- -----------------------------------------------------------------------------

local roguePlayerAuras = { {"Zerh\195\164ckseln", "ffff00"}, {"Vergiften", "00ff00"}, {"Schattenklingen", "ff00ff"} }
local rogueTargetAuras = { {"Blutung", "ff0000"}, {"Vendetta", "ffffff"} }


local dkPlayerAuras = { }
local dkTargetAuras = { {"Frostfieber", "6666ff"}, {"Blutseuche", "00ff00"} }

local priestPlayerAuras = { {"Machtwort: Schild", "ffffff"} }
local priestTargetAuras = { {"Machtwort: Schild", "ffffff"} }



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
local larthUnitPower = { }
local larthUnitButton = { }
	
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
	local debuffString = ""
	if ( targetWatch ) then
		for i=1, # targetWatch do
			local _, _, _, _, _, _, expirationTime, unitCaster = UnitDebuff("target", targetWatch[i][1])
			if(unitCaster=="player")then 
				debuffString = debuffString..format("|cff%s%s|r", targetWatch[i][2], (round(expirationTime - GetTime()).." "))
			end
		end
	end
	targetAuraText:SetText(debuffString)
end)
-- -----------------------------------------------------------------------------
-- Register event
-- -----------------------------------------------------------------------------
larthUnitFrames:RegisterEvent("VARIABLES_LOADED")


larthUnitFrames:SetScript("OnEvent", function(self, event, ...)
	local unit = ...
	if (event == "VARIABLES_LOADED") then
		localizedClass, englishClass, classIndex = UnitClass("player")
		PlayerFrame:Hide()
		health = UnitHealth("player")
		maxHealth = UnitHealthMax("player")
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

targetPowerText = larthTargetUnitFrame:CreateFontString(nil, "OVERLAY")
targetPowerText:SetPoint("BOTTOMRIGHT")
targetPowerText:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
targetPowerText:SetTextColor(1, 1, 1)

larthUnitButton["target"] = CreateFrame("Button", "button_target", UIParent, "SecureActionButtonTemplate ");
larthUnitButton["target"]:RegisterForClicks("RightButtonUp")
larthUnitButton["target"]:SetWidth(200)
larthUnitButton["target"]:SetHeight(50)
larthUnitButton["target"]:SetPoint("CENTER", 250, 0)
larthUnitButton["target"]:SetAttribute('type2', 'menu')
larthUnitButton["target"].menu = function(self, unit, button, actionType) 
		if UnitExists("target") then ToggleDropDownMenu(1, 1, TargetFrameDropDown, larthUnitButton["target"], 0 ,0) end
	end

larthTargetUnitFrame:RegisterEvent("UNIT_COMBO_POINTS")
larthTargetUnitFrame:RegisterEvent("PLAYER_TARGET_CHANGED")

larthTargetUnitFrame:SetScript("OnEvent", function(self, event, ...)
	local comboPoints = GetComboPoints("player", "target");
	local arg1 = ...
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

larthTargetUnitFrame:SetScript("OnUpdate", function(self, elapsed)
	if UnitExists("target") then 
		TargetFrame:Hide()
		health = UnitHealth("target")
		maxHealth = UnitHealthMax("target")
		targetHealthText:SetText(longHealthString(100*health/maxHealth))
		energy = UnitPower("target")
		if( energy > 0 ) then targetPowerText:SetText(round(energy, 0))
		else targetPowerText:SetText("") end
		
		targetName = UnitName("target")
		local class, classFileName = UnitClass("target")
		targetNameText:SetText(format("|cff%s%s|r", strsub(RAID_CLASS_COLORS[classFileName].colorStr, 3, 8), trimUnitName(targetName)))
	else 
		targetHealthText:SetText("")
		targetNameText:SetText("")
		targetPowerText:SetText("")
	end
end)

-- -----------------------------------------------------------------------------
-- Create Target of Target frame
-- -----------------------------------------------------------------------------
larthUnitFrame["targettarget"] = CreateFrame("Frame", "larthUnitFrameToT", UIParent)
larthUnitFrame["targettarget"]:SetFrameLevel(3)
larthUnitFrame["targettarget"]:SetWidth(100)
larthUnitFrame["targettarget"]:SetHeight(30)
larthUnitFrame["targettarget"]:SetPoint("CENTER", 400, 0)
larthUnitFrame["targettarget"]:Show()

larthUnitName["targettarget"] = larthUnitFrame["targettarget"]:CreateFontString(nil, "OVERLAY")
larthUnitName["targettarget"]:SetPoint("TOPRIGHT")
larthUnitName["targettarget"]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 18, "OUTLINE")
larthUnitName["targettarget"]:SetTextColor(1, 1, 1)

larthUnitHealth["targettarget"] = larthUnitFrame["targettarget"]:CreateFontString(nil, "OVERLAY")
larthUnitHealth["targettarget"]:SetPoint("BOTTOMRIGHT")
larthUnitHealth["targettarget"]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 18, "OUTLINE")
larthUnitHealth["targettarget"]:SetTextColor(1, 1, 1)

larthUnitFrame["targettarget"]:SetScript("OnUpdate", function(self, elapsed)
	if UnitExists("targettarget") then 
		health = UnitHealth("targettarget")
		maxHealth = UnitHealthMax("targettarget")
		larthUnitHealth["targettarget"]:SetText(round(100*health/maxHealth, 0))
		local class, classFileName = UnitClass("targettarget")
		larthUnitName["targettarget"]:SetText(format("|cff%s%s|r", strsub(RAID_CLASS_COLORS[classFileName].colorStr, 3, 8), trimUnitName(UnitName("targettarget"))))
	else
		larthUnitName["targettarget"]:SetText("")
		larthUnitHealth["targettarget"]:SetText("")
	end
end)

larthTotButton = CreateFrame("Button", "button_tot", UIParent, "SecureActionButtonTemplate ");
larthTotButton:RegisterForClicks("LeftButtonUp")
larthTotButton:SetWidth(100)
larthTotButton:SetHeight(30)
larthTotButton:SetPoint("CENTER", 400, 0)
larthTotButton:SetAttribute('type1', 'target')
larthTotButton:SetAttribute('unit', "targettarget")


-- -----------------------------------------------------------------------------
-- RaidFrames
-- -----------------------------------------------------------------------------

for i = 1, 40, 1 do
	larthUnitFrame["raid"..i] = CreateFrame("Frame", "larthUnitFrame_raid"..i, UIParent)
	larthUnitButton["raid"..i] = CreateFrame("Button", "button_raid"..i, UIParent, "SecureUnitButtonTemplate ");
	
	larthUnitButton["raid"..i]:SetAttribute('type1', 'target')
	larthUnitButton["raid"..i]:SetAttribute('unit', "raid"..i)
	
	larthUnitFrame["raid"..i]:SetFrameLevel(3)
	larthUnitFrame["raid"..i]:SetWidth(100)
	larthUnitFrame["raid"..i]:SetHeight(30)
	larthUnitButton["raid"..i]:SetWidth(100)
	larthUnitButton["raid"..i]:SetHeight(20)
	
	if i <= 25 then 
		larthUnitFrame["raid"..i]:SetPoint("TOPLEFT", 15, -150-i*20)
		larthUnitButton["raid"..i]:SetPoint("TOPLEFT", 15, -150-i*20)
	else
		larthUnitFrame["raid"..i]:SetPoint("TOPLEFT", 120, -150-(i-25)*20)
		larthUnitButton["raid"..i]:SetPoint("TOPLEFT", 120, -150-(i-25)*20)
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
	
	--GetReadyCheckStatus("unit")
	
	larthUnitFrame["raid"..i]:SetScript("OnUpdate", function(self, elapsed)
		if UnitExists("raid"..i) then 
			health = UnitHealth("raid"..i)
			maxHealth = UnitHealthMax("raid"..i)
			local class, classFileName = UnitClass("raid"..i)
			larthUnitName["raid"..i]:SetText(format("|cff%s%s|r", strsub(RAID_CLASS_COLORS[classFileName].colorStr, 3, 8), UnitName("raid"..i)))
			larthUnitHealth["raid"..i]:SetText(round(100*health/maxHealth, 0))
		else
			larthUnitHealth["raid"..i]:SetText("")
			larthUnitName["raid"..i]:SetText("")
		end
	end)
end


-- -----------------------------------------------------------------------------
-- Party Frames
-- -----------------------------------------------------------------------------

for i = 1, 4, 1 do
	larthUnitFrame["party"..i] = CreateFrame("Frame", "larthUnitFrame_party"..i, UIParent)
	larthUnitFrame["party"..i]:SetFrameLevel(3)
	larthUnitFrame["party"..i]:SetWidth(100)
	larthUnitFrame["party"..i]:SetHeight(20)

	larthUnitFrame["party"..i]:SetPoint("TOPLEFT", 15, -150-i*20)
	larthUnitFrame["party"..i]:Show()
	larthUnitName["party"..i] = larthUnitFrame["party"..i]:CreateFontString(nil, "OVERLAY")
	larthUnitName["party"..i]:SetPoint("TOPLEFT")
	larthUnitName["party"..i]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
	larthUnitName["party"..i]:SetTextColor(1, 1, 1)
	
	larthUnitHealth["party"..i] = larthUnitFrame["party"..i]:CreateFontString(nil, "OVERLAY")
	larthUnitHealth["party"..i]:SetPoint("BOTTOMRIGHT")
	larthUnitHealth["party"..i]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
	larthUnitHealth["party"..i]:SetTextColor(1, 1, 1)
	
	larthUnitFrame["party"..i]:SetScript("OnUpdate", function(self, elapsed)
		if UnitExists("party"..i) and not IsInRaid() then 
			health = UnitHealth("party"..i)
			maxHealth = UnitHealthMax("party"..i)
			larthUnitName["party"..i]:SetText(UnitName("party"..i))
			larthUnitHealth["party"..i]:SetText(round(100*health/maxHealth, 0))
		else
			larthUnitHealth["party"..i]:SetText("")
			larthUnitName["party"..i]:SetText("")
		end
	end)
end

-- -----------------------------------------------------------------------------
-- Boss Frames
-- -----------------------------------------------------------------------------

for i = 1, 5, 1 do
	larthUnitFrame["boss"..i] = CreateFrame("Frame", "larthUnitFrame_boss"..i, UIParent)
	larthUnitFrame["boss"..i]:SetFrameLevel(3)
	larthUnitFrame["boss"..i]:SetWidth(100)
	larthUnitFrame["boss"..i]:SetHeight(30)

	larthUnitFrame["boss"..i]:SetPoint("RIGHT", -30, 50-i*30)
	larthUnitFrame["boss"..i]:Show()
	larthUnitName["boss"..i] = larthUnitFrame["boss"..i]:CreateFontString(nil, "OVERLAY")
	larthUnitName["boss"..i]:SetPoint("TOP")
	larthUnitName["boss"..i]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
	larthUnitName["boss"..i]:SetTextColor(1, 1, 1)
	
	larthUnitHealth["boss"..i] = larthUnitFrame["boss"..i]:CreateFontString(nil, "OVERLAY")
	larthUnitHealth["boss"..i]:SetPoint("BOTTOMLEFT")
	larthUnitHealth["boss"..i]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
	larthUnitHealth["boss"..i]:SetTextColor(1, 1, 1)
	
	larthUnitPower["boss"..i] = larthUnitFrame["boss"..i]:CreateFontString(nil, "OVERLAY")
	larthUnitPower["boss"..i]:SetPoint("BOTTOMRIGHT")
	larthUnitPower["boss"..i]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
	larthUnitPower["boss"..i]:SetTextColor(1, 1, 1)
	
	

	larthUnitFrame["boss"..i]:SetScript("OnUpdate", function(self, elapsed)
		if UnitExists("boss"..i) and not IsInRaid() then 
			health = UnitHealth("boss"..i)
			maxHealth = UnitHealthMax("boss"..i)
			larthUnitName["boss"..i]:SetText(UnitName("boss"..i))
			larthUnitHealth["boss"..i]:SetText(round(100*health/maxHealth, 0))
			larthUnitPower["boss"..i]:SetText(round(UnitPower("boss"..i), 0))
		else
			larthUnitHealth["boss"..i]:SetText("")
			larthUnitName["boss"..i]:SetText("")
			larthUnitPower["boss"..i]:SetText("")
		end
	end)
end
-- -----------------------------------------------------------------------------
-- Create Player frame
-- -----------------------------------------------------------------------------
larthPlayerFrame = CreateFrame("Frame", "larthUnitFrame_player", UIParent)
larthPlayerFrame:SetFrameLevel(3)
larthPlayerFrame:SetWidth(200)
larthPlayerFrame:SetHeight(50)
larthPlayerFrame:SetPoint("CENTER", -250, 0)
larthPlayerFrame:Show()

larthPlayerHealth = larthPlayerFrame:CreateFontString(nil, "OVERLAY")
larthPlayerHealth:SetPoint("RIGHT")
larthPlayerHealth:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 20, "OUTLINE")
larthPlayerHealth:SetTextColor(1, 1, 1)

larthPlayerPower = larthPlayerFrame:CreateFontString(nil, "OVERLAY")
larthPlayerPower:SetPoint("BOTTOMRIGHT")
larthPlayerPower:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
larthPlayerPower:SetTextColor(1, 1, 1)

larthPlayerName = larthPlayerFrame:CreateFontString(nil, "OVERLAY")
larthPlayerName:SetPoint("TOPLEFT")
larthPlayerName:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
larthPlayerName:SetTextColor(1, 1, 1)


playerSpecialText = larthPlayerFrame:CreateFontString(nil, "OVERLAY")
playerSpecialText:SetPoint("BOTTOMLEFT")
playerSpecialText:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
playerSpecialText:SetTextColor(1, 1, 1)

playerAuraText = larthPlayerFrame:CreateFontString(nil, "OVERLAY")
playerAuraText:SetPoint("TOPRIGHT")
playerAuraText:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
playerAuraText:SetTextColor(1, 1, 1)

larthUnitButton["player"] = CreateFrame("Button", "button_player", UIParent, "SecureActionButtonTemplate ");
larthUnitButton["player"]:RegisterForClicks("LeftButtonUp", "RightButtonUp")
larthUnitButton["player"]:SetWidth(200)
larthUnitButton["player"]:SetHeight(50)
larthUnitButton["player"]:SetPoint("CENTER", -250, 0)
larthUnitButton["player"]:SetAttribute('type1', 'target')
larthUnitButton["player"]:SetAttribute('unit', "player")
larthUnitButton["player"]:SetAttribute('type2', 'menu')
larthUnitButton["player"].menu = function(self, unit, button, actionType) 
		ToggleDropDownMenu(1, 1, PlayerFrameDropDown, larthUnitButton["player"], 0 ,0) 
	end


larthPlayerFrame:SetScript("OnUpdate", function(self, elapsed)
	larthPlayerHealth:SetText(longHealthString(100*UnitHealth("player")/UnitHealthMax("player")))
	larthPlayerPower:SetText(round(UnitPower("player"), 0))
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
end)

larthPlayerFrame:RegisterEvent("VARIABLES_LOADED")


larthPlayerFrame:SetScript("OnEvent", function(self, event, ...)
	larthPlayerName:SetText(trimUnitName(UnitName("player")))
end)