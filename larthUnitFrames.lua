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
local targetWatch, playerWatch 
local larthUnitFrame = { }
local larthUnitName = { }
local larthUnitHealth = { }
local larthUnitPower = { }
local larthUnitButton = { }

local fontset = "Interface\\AddOns\\larthUnitFrames\\font.ttf"
	
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

end)
-- -----------------------------------------------------------------------------
-- Register event
-- -----------------------------------------------------------------------------
larthUnitFrames:RegisterEvent("VARIABLES_LOADED")


larthUnitFrames:SetScript("OnEvent", function(self, event, ...)
	local unit = ...
	if (event == "VARIABLES_LOADED") then
		local localizedClass, englishClass, classIndex = UnitClass("player")
		PlayerFrame:Hide()
        PlayerFrame:UnregisterAllEvents()
        TargetFrame:Hide()
        TargetFrame:UnregisterAllEvents()
        ComboFrame:Hide()
        ComboFrame:UnregisterAllEvents()
		health = UnitHealth("player")
		maxHealth = UnitHealthMax("player")
		if (classIndex == 10) then
			larthClassSpecial:SetScript("OnUpdate", function(self, elapsed)
				local tempString = ""
				local power = UnitPower("player" , 12);
				if power > 0 then
					for i = 1, power, 1 do
						tempString = tempString.."# "
					end
				end
				larthClassSpecialText:SetText(tempString)
			end)
		end
		if (classIndex == 6) then
			RuneFrame:UnregisterAllEvents()
			RuneFrame:Hide()
			targetWatch	=	dkTargetAuras
			larthClassSpecial:SetScript("OnUpdate", function(self, elapsed)
			local tempString = "";
			for i=1, 6, 1 do
				
				local start, duration, runeReady = GetRuneCooldown(i)
				runeType = GetRuneType(i)
				local cooldown = round(duration-GetTime()+start)
				--(round(expirationTime - GetTime())
				if runeReady then
					tempString = tempString..format("|cff%s%s|r", runeColoring(runeType), "# ")
				else
					tempString = tempString..format("|cff%s%s|r", runeColoring(runeType), cooldown.." ")
				end
			end
			larthClassSpecialText:SetText(tempString)
			end)
		end

		if (classIndex == 4) then 
			targetWatch = rogueTargetAuras
			playerWatch = roguePlayerAuras
			larthClassSpecial:SetScript("OnUpdate", function(self, elapsed)
				local comboPoints = GetComboPoints("player", "target");
				if ( comboPoints < 1 ) then
					larthClassSpecialText:SetText("")
				elseif (comboPoints < 2) then 
					larthClassSpecialText:SetText("#")
				elseif (comboPoints < 3) then 
					larthClassSpecialText:SetText("# #")
				elseif (comboPoints < 4) then 
					larthClassSpecialText:SetText(format("|cff%s%s|r", "ffff00", "# # #"))
				elseif (comboPoints < 5) then 
					larthClassSpecialText:SetText(format("|cff%s%s|r", "ff9900", "# # # #"))
				else
					larthClassSpecialText:SetText(format("|cff%s%s|r", "ff0000", "# # # # #"))
				end

			end)
		end
	end
end)



-- -----------------------------------------------------------------------------
-- Create Target frame
-- -----------------------------------------------------------------------------

larthTargetUnitFrame = CreateFrame("Button", "button_target", UIParent, "SecureActionButtonTemplate");
larthTargetUnitFrame:RegisterForClicks("RightButtonUp")
larthTargetUnitFrame:SetWidth(250)
larthTargetUnitFrame:SetHeight(50)
larthTargetUnitFrame:SetPoint("CENTER", 250, 0)

larthTargetUnitFrame:SetAttribute('type2', 'menu')
larthTargetUnitFrame.menu = function(self, unit, button, actionType) 
		if UnitExists("target") then ToggleDropDownMenu(1, 1, TargetFrameDropDown, larthTargetUnitFrame, 0 ,0) end
	end
	
targetHealthText = larthTargetUnitFrame:CreateFontString(nil, "OVERLAY")
targetHealthText:SetPoint("RIGHT")
targetHealthText:SetFont(fontset, 20, "THINOUTLINE")
targetHealthText:SetTextColor(1, 1, 1)

targetNameText = larthTargetUnitFrame:CreateFontString(nil, "OVERLAY")
targetNameText:SetPoint("TOPRIGHT")
targetNameText:SetFont(fontset, 14, "THINOUTLINE")
targetNameText:SetTextColor(1, 1, 1)

targetAuraText = larthTargetUnitFrame:CreateFontString(nil, "OVERLAY")
targetAuraText:SetPoint("TOPLEFT")
targetAuraText:SetFont(fontset, 14, "THINOUTLINE")
targetAuraText:SetTextColor(1, 1, 1)

targetPowerText = larthTargetUnitFrame:CreateFontString(nil, "OVERLAY")
targetPowerText:SetPoint("BOTTOMLEFT")
targetPowerText:SetFont(fontset, 14, "THINOUTLINE")
targetPowerText:SetTextColor(1, 1, 1)

larthTargetAbs = larthTargetUnitFrame:CreateFontString(nil, "OVERLAY")
larthTargetAbs:SetPoint("LEFT")
larthTargetAbs:SetFont(fontset, 20, "OUTLINE")
larthTargetAbs:SetTextColor(1, 1, 1)

larthTargetPowerLong = larthTargetUnitFrame:CreateFontString(nil, "OVERLAY")
larthTargetPowerLong:SetPoint("BOTTOMRIGHT")
larthTargetPowerLong:SetFont(fontset, 14, "OUTLINE")
larthTargetPowerLong:SetTextColor(1, 1, 1)

larthTargetUnitFrame:SetScript("OnUpdate", function(self, elapsed)
	if UnitExists("target") then 
		local health = UnitHealth("target")
		local maxHealth = UnitHealthMax("target")
		local derString = ""..health
		local percent = 100*health/maxHealth
		targetHealthText:SetText(longHealthString(percent))
		larthTargetAbs:SetTextColor((1-percent/100)*2, percent/50, 0)
		if #derString > 7 then
			larthTargetAbs:SetText(strsub(derString, 1, -7).."M")	
		elseif #derString > 4 then
			larthTargetAbs:SetText(strsub(derString, 1, -4).."k")
		else
			larthTargetAbs:SetText(derString)
		end
		local energy = UnitPower("target")
		local powerMax = UnitPowerMax("target")
		
		if( energy > 0 ) then 
			targetPowerText:SetText(round(energy, 0))
			larthTargetPowerLong:SetText(longHealthString(100*energy/powerMax))
		else 
			targetPowerText:SetText("")
		end
		
		local targetName = UnitName("target")
		local class, classFileName = UnitClass("target")
		targetNameText:SetText(format("|cff%s%s|r", strsub(RAID_CLASS_COLORS[classFileName].colorStr, 3, 8), trimUnitName(targetName)))
	else 
		targetHealthText:SetText("")
		targetNameText:SetText("")
		targetPowerText:SetText("")
		larthTargetAbs:SetText("")
		larthTargetPowerLong:SetText("")
	end
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
-- Create Target of Target frame
-- -----------------------------------------------------------------------------

larthTotButton = CreateFrame("Button", "button_tot", UIParent, "SecureActionButtonTemplate ");
larthTotButton:RegisterForClicks("LeftButtonUp")
larthTotButton:SetWidth(100)
larthTotButton:SetHeight(30)
larthTotButton:SetPoint("CENTER", 400, 0)
larthTotButton:SetAttribute('type1', 'target')
larthTotButton:SetAttribute('unit', "targettarget")

larthUnitName["targettarget"] = larthTotButton:CreateFontString(nil, "OVERLAY")
larthUnitName["targettarget"]:SetPoint("TOPRIGHT")
larthUnitName["targettarget"]:SetFont(fontset, 18, "OUTLINE")
larthUnitName["targettarget"]:SetTextColor(1, 1, 1)

larthUnitHealth["targettarget"] = larthTotButton:CreateFontString(nil, "OVERLAY")
larthUnitHealth["targettarget"]:SetPoint("BOTTOMRIGHT")
larthUnitHealth["targettarget"]:SetFont(fontset, 18, "OUTLINE")
larthUnitHealth["targettarget"]:SetTextColor(1, 1, 1)

larthTotButton:SetScript("OnUpdate", function(self, elapsed)
	if UnitExists("targettarget") then 
		local health = UnitHealth("targettarget")
		local maxHealth = UnitHealthMax("targettarget")
		larthUnitHealth["targettarget"]:SetText(round(100*health/maxHealth, 0))
		local class, classFileName = UnitClass("targettarget")
		larthUnitName["targettarget"]:SetText(format("|cff%s%s|r", strsub(RAID_CLASS_COLORS[classFileName].colorStr, 3, 8), trimUnitName(UnitName("targettarget"))))
	else
		larthUnitName["targettarget"]:SetText("")
		larthUnitHealth["targettarget"]:SetText("")
	end
end)




-- -----------------------------------------------------------------------------
-- Create Player frame
-- -----------------------------------------------------------------------------

larthPlayerFrame = CreateFrame("Button", "button_player", UIParent, "SecureActionButtonTemplate ");
larthPlayerFrame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
larthPlayerFrame:SetWidth(250)
larthPlayerFrame:SetHeight(50)
larthPlayerFrame:SetPoint("CENTER", -250, 0)
larthPlayerFrame:SetAttribute('type1', 'target')
larthPlayerFrame:SetAttribute('unit', "player")
larthPlayerFrame:SetAttribute('type2', 'menu')
larthPlayerFrame.menu = function(self, unit, button, actionType) 
		ToggleDropDownMenu(1, 1, PlayerFrameDropDown, larthPlayerFrame, 0 ,0) 
	end
	
larthPlayerHealth = larthPlayerFrame:CreateFontString(nil, "OVERLAY")
larthPlayerHealth:SetPoint("LEFT")
larthPlayerHealth:SetFont(fontset, 20, "OUTLINE")
larthPlayerHealth:SetTextColor(1, 1, 1)

larthPlayerHealthPercent = larthPlayerFrame:CreateFontString(nil, "OVERLAY")
larthPlayerHealthPercent:SetPoint("RIGHT")
larthPlayerHealthPercent:SetFont(fontset, 20, "OUTLINE")
larthPlayerHealthPercent:SetTextColor(1, 1, 1)

larthPlayerPower = larthPlayerFrame:CreateFontString(nil, "OVERLAY")
larthPlayerPower:SetPoint("BOTTOMRIGHT")
larthPlayerPower:SetFont(fontset, 14, "THINOUTLINE")
larthPlayerPower:SetTextColor(1, 1, 1)

larthPlayerPowerLong = larthPlayerFrame:CreateFontString(nil, "OVERLAY")
larthPlayerPowerLong:SetPoint("BOTTOMLEFT")
larthPlayerPowerLong:SetFont(fontset, 14, "THINOUTLINE")
larthPlayerPowerLong:SetTextColor(1, 1, 1)

larthPlayerName = larthPlayerFrame:CreateFontString(nil, "OVERLAY")
larthPlayerName:SetPoint("TOPLEFT")
larthPlayerName:SetFont(fontset, 14, "THINOUTLINE")
larthPlayerName:SetTextColor(1, 1, 1)


playerSpecialText = larthPlayerFrame:CreateFontString(nil, "OVERLAY")
playerSpecialText:SetPoint("BOTTOMLEFT")
playerSpecialText:SetFont(fontset, 14, "THINOUTLINE")
playerSpecialText:SetTextColor(1, 1, 1)

playerAuraText = larthPlayerFrame:CreateFontString(nil, "OVERLAY")
playerAuraText:SetPoint("TOPRIGHT")
playerAuraText:SetFont(fontset, 14, "THINOUTLINE")
playerAuraText:SetTextColor(1, 1, 1)




larthPlayerFrame:SetScript("OnUpdate", function(self, elapsed)
	if UnitIsPVP("player") then
		larthPlayerName:SetTextColor(1, 0, 0)
	else
		larthPlayerName:SetTextColor(1, 1, 1)
	end
	local health = UnitHealth("player")
	local maxHealth = UnitHealthMax("player")
	local derString = ""..health
	local percent = 100*health/maxHealth
	larthPlayerHealthPercent:SetTextColor((1-percent/100)*2, percent/50, 0)
	if #derString > 4 then
		larthPlayerHealthPercent:SetText(strsub(derString, 1, -4).."k")
	else
		larthPlayerHealthPercent:SetText(derString)
	end
	larthPlayerHealth:SetText(longHealthString(percent))
	larthPlayerPower:SetText(round(UnitPower("player"), 0))
	larthPlayerPowerLong:SetText(longHealthString(100*UnitPower("player")/UnitPowerMax("player")))
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


-- -----------------------------------------------------------------------------
-- Create Special blah blah frame
-- -----------------------------------------------------------------------------
larthClassSpecial = CreateFrame("Frame", "larsClassSpecial", UIParent)
larthClassSpecial:SetFrameLevel(3)
larthClassSpecial:SetWidth(50)
larthClassSpecial:SetHeight(50)
larthClassSpecial:SetPoint("CENTER", 0, -100)
larthClassSpecial:Show()

larthClassSpecialText = larthClassSpecial:CreateFontString(nil, "OVERLAY")
larthClassSpecialText:SetPoint("CENTER")
larthClassSpecialText:SetFont(fontset, 20, "OUTLINE")
larthClassSpecialText:SetTextColor(1, 1, 1)


-- -----------------------------------------------------------------------------
-- BossFrames
-- -----------------------------------------------------------------------------



for i = 1, 6, 1 do
	
	larthUnitFrame["boss"..i] = CreateFrame("Button", "button_boss"..i, UIParent, "SecureUnitButtonTemplate ");	
	larthUnitFrame["boss"..i]:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	larthUnitFrame["boss"..i]:SetAttribute('type1', 'target')
	larthUnitFrame["boss"..i]:SetAttribute('unit', "boss"..i)
	larthUnitFrame["boss"..i]:SetWidth(100)
	larthUnitFrame["boss"..i]:SetHeight(40)
	larthUnitFrame["boss"..i]:Show()

	larthUnitFrame["boss"..i]:SetPoint("RIGHT", -20, 100-i*50)
	
	larthUnitName["boss"..i] = larthUnitFrame["boss"..i]:CreateFontString(nil, "OVERLAY")
	larthUnitName["boss"..i]:SetPoint("TOPLEFT")
	larthUnitName["boss"..i]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
	larthUnitName["boss"..i]:SetTextColor(1, 1, 1)
	
	larthUnitHealth["boss"..i] = larthUnitFrame["boss"..i]:CreateFontString(nil, "OVERLAY")
	larthUnitHealth["boss"..i]:SetPoint("BOTTOMLEFT")
	larthUnitHealth["boss"..i]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
	larthUnitHealth["boss"..i]:SetTextColor(1, 0, 0)
	
	larthUnitPower["boss"..i] = larthUnitFrame["boss"..i]:CreateFontString(nil, "OVERLAY")
	larthUnitPower["boss"..i]:SetPoint("BOTTOMRIGHT")
	larthUnitPower["boss"..i]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 14, "THINOUTLINE")
	larthUnitPower["boss"..i]:SetTextColor(0.5, 0.5, 1)
	
	
	larthUnitFrame["boss"..i]:SetScript("OnUpdate", function(self, elapsed)
		if UnitExists("boss"..i) then 
			larthUnitName["boss"..i]:SetText(UnitName("boss"..i))
			local health = UnitHealth("boss"..i)
			local maxHealth = UnitHealthMax("boss"..i)
			local percent = round(100*health/maxHealth, 0)
			larthUnitHealth["boss"..i]:SetText(round(percent))
			local power = UnitPower("boss"..i)
			local maxPower = UnitPowerMax("boss"..i)
			larthUnitPower["boss"..i]:SetText(round(100*power/maxPower))
		else
			larthUnitHealth["boss"..i]:SetText("")
			larthUnitName["boss"..i]:SetText("")
			larthUnitPower["boss"..i]:SetText("")
		end
	end)

end