LarthUnitFrames = {
	Classes = {
		ROGUE = {
			Buff = { {"Vergiften", "00ff00"}, {"Schattenklingen", "ff00ff"}, {"Zerh\195\164ckseln", "ffff00"} },
			Debuff = { {"Blutung", "ff0000"}, {"Vendetta", "ffffff"}, {"Blutroter Sturm", "ff9999"} }
		},
		DEATHKNIGHT = {
			Buff = { {"Horn des Winters", "0099ff"}, {"Schattenklingen", "ff00ff"}, {"Zerh\195\164ckseln", "ffff00"} },
			Debuff = { {"Frostfieber", "6666ff"}, {"Blutseuche", "00ff00"} }
		}
	}
}


-- -----------------------------------------------------------------------------
-- Config
-- -----------------------------------------------------------------------------

local rogueTargetAuras = { {"Blutung", "ff0000"}, {"Vendetta", "ffffff"}, {"Blutroter Sturm", "ff9999"}}
local dkTargetAuras = { {"Frostfieber", "6666ff"}, {"Blutseuche", "00ff00"} }



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
		SpellActivationOverlayFrame:SetScale(0.6);
		local localizedClass, englishClass, classIndex = UnitClass("player")
		targetWatch = LarthUnitFrames.Classes[englishClass].Debuff
		PlayerFrame:Hide()
        PlayerFrame:UnregisterAllEvents()
        TargetFrame:Hide()
        TargetFrame:UnregisterAllEvents()
        ComboFrame:Hide()
        ComboFrame:UnregisterAllEvents()
		if (classIndex == 10) then
			larthSpecial.Frame:SetScript("OnUpdate", function(self, elapsed)
				local tempString = ""
				local power = UnitPower("player" , 12);
				if power > 0 then
					for i = 1, power, 1 do
						tempString = tempString.."# "
					end
				end
				larthSpecial.Text:SetText(tempString)
			end)
		end
		if (classIndex == 6) then
			RuneFrame:UnregisterAllEvents()
			RuneFrame:Hide()
			larthSpecial.Frame:SetScript("OnUpdate", function(self, elapsed)
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
			larthSpecial.Text:SetText(tempString)
			end)
		end

		if (classIndex == 4) then 
			larthSpecial.Frame:SetScript("OnUpdate", function(self, elapsed)
				local comboPoints = GetComboPoints("player", "target");
				if ( comboPoints < 1 ) then
					larthSpecial.Text:SetText("")
				elseif (comboPoints < 2) then 
					larthSpecial.Text:SetText("#")
				elseif (comboPoints < 3) then 
					larthSpecial.Text:SetText("# #")
				elseif (comboPoints < 4) then 
					larthSpecial.Text:SetText(format("|cff%s%s|r", "ffff00", "# # #"))
				elseif (comboPoints < 5) then 
					larthSpecial.Text:SetText(format("|cff%s%s|r", "ff9900", "# # # #"))
				else
					larthSpecial.Text:SetText(format("|cff%s%s|r", "ff0000", "# # # # #"))
				end

			end)
		end
	end
end)



-- -----------------------------------------------------------------------------
-- Create Target frame
-- -----------------------------------------------------------------------------
larthTargetUnitFrame = CreateFrame("Button", "larthTargetFrame", UIParent);
larthTargetUnitFrame:SetWidth(250)
larthTargetUnitFrame:SetHeight(50)
larthTargetUnitFrame:SetPoint("CENTER", 250, 0)
larthTargetUnitFrame:EnableMouse(false)

larthTargetUnitButton = CreateFrame("Button", "button_target", larthTargetUnitFrame, "SecureActionButtonTemplate");
larthTargetUnitButton:RegisterForClicks("RightButtonUp")
larthTargetUnitButton:SetWidth(50)
larthTargetUnitButton:SetHeight(20)
larthTargetUnitButton:SetPoint("TOPRIGHT", 0, 0)

larthTargetUnitButton:SetAttribute('type2', 'menu')
larthTargetUnitButton.menu = function(self, unit, button, actionType)
		if UnitExists("target") then ToggleDropDownMenu(1, 1, TargetFrameDropDown, larthTargetUnitButton, 0 ,0) end
	end
	
targetHealthText = larthTargetUnitFrame:CreateFontString(nil, "OVERLAY")
targetHealthText:SetPoint("RIGHT")
targetHealthText:SetFont(fontset, 20, "THINOUTLINE")
targetHealthText:SetTextColor(1, 1, 1)

targetNameText = larthTargetUnitFrame:CreateFontString(nil, "OVERLAY")
targetNameText:SetPoint("TOPRIGHT")
targetNameText:SetFont(fontset, 18, "OUTLINE")
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
		local spell, _, _, _, _, endTime = UnitCastingInfo("target")
		if spell then 
			local finish = endTime/1000 - GetTime()
			targetNameText:SetText(round(finish, 1).." - "..spell)
		else
			local targetName = UnitName("target")
			local class, classFileName = UnitClass("target")
			targetNameText:SetText(format("|cff%s%s|r", strsub(RAID_CLASS_COLORS[classFileName].colorStr, 3, 8), trimUnitName(targetName)))
		end
		local health = UnitHealth("target")
		local maxHealth = UnitHealthMax("target")
		local percent = 100*health/maxHealth
		targetHealthText:SetText(longHealthString(percent))
		larthTargetAbs:SetTextColor((1-percent/100)*2, percent/50, 0)
		if health > 1000000 then
			larthTargetAbs:SetText(round(health/1000000).."M")	
		elseif health > 1000 then
			larthTargetAbs:SetText(round(health/1000).."k")
		else
			larthTargetAbs:SetText(health)
		end
		local energy = UnitPower("target")
		local powerMax = UnitPowerMax("target")
		
		if( energy > 0 ) then 
			targetPowerText:SetText(round(energy, 0))
			larthTargetPowerLong:SetText(longHealthString(100*energy/powerMax))
		else 
			targetPowerText:SetText("")
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
	else 
		targetHealthText:SetText("")
		targetNameText:SetText("")
		targetPowerText:SetText("")
		larthTargetAbs:SetText("")
		larthTargetPowerLong:SetText("")
		targetAuraText:SetText("")
	end


end)

-- -----------------------------------------------------------------------------
-- Create Target of Target frame
-- -----------------------------------------------------------------------------

larthTotButton = CreateFrame("Button", "button_tot", UIParent, "SecureActionButtonTemplate ");
larthTotButton:RegisterForClicks("LeftButtonUp")
larthTotButton:SetWidth(100)
larthTotButton:SetHeight(30)
larthTotButton:SetPoint("CENTER", 450, 0)
larthTotButton:SetAttribute('type1', 'target')
larthTotButton:SetAttribute('unit', "targettarget")

larthUnitName["targettarget"] = larthTotButton:CreateFontString(nil, "OVERLAY")
larthUnitName["targettarget"]:SetPoint("TOPLEFT")
larthUnitName["targettarget"]:SetFont(fontset, 18, "OUTLINE")
larthUnitName["targettarget"]:SetTextColor(1, 1, 1)

larthUnitHealth["targettarget"] = larthTotButton:CreateFontString(nil, "OVERLAY")
larthUnitHealth["targettarget"]:SetPoint("BOTTOMLEFT")
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
-- Create Special blah blah frame
-- -----------------------------------------------------------------------------
larthSpecial = {}
larthSpecial.Frame = CreateFrame("Frame", "larsClassSpecial", UIParent)
larthSpecial.Frame:SetFrameLevel(3)
larthSpecial.Frame:SetWidth(50)
larthSpecial.Frame:SetHeight(50)
larthSpecial.Frame:SetPoint("CENTER", 0, -100)
larthSpecial.Frame:Show()

larthSpecial.Text = larthSpecial.Frame:CreateFontString(nil, "OVERLAY")
larthSpecial.Text:SetPoint("CENTER")
larthSpecial.Text:SetFont(fontset, 20, "OUTLINE")
larthSpecial.Text:SetTextColor(1, 1, 1)


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
	
	larthUnitFrame["boss"..i] = CreateFrame("Button", "button_boss"..i, UIParent, "SecureUnitButtonTemplate ");	
	larthUnitFrame["boss"..i]:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	larthUnitFrame["boss"..i]:SetAttribute('type1', 'target')
	larthUnitFrame["boss"..i]:SetAttribute('unit', "boss"..i)
	larthUnitFrame["boss"..i]:SetWidth(50)
	larthUnitFrame["boss"..i]:SetHeight(40)
	larthUnitFrame["boss"..i]:Show()

	larthUnitFrame["boss"..i]:SetPoint("RIGHT", -20, 100-i*50)
	
	larthUnitName["boss"..i] = larthUnitFrame["boss"..i]:CreateFontString(nil, "OVERLAY")
	larthUnitName["boss"..i]:SetPoint("TOPRIGHT")
	larthUnitName["boss"..i]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 20, "OUTLINE")
	larthUnitName["boss"..i]:SetTextColor(1, 1, 1)
	
	larthUnitHealth["boss"..i] = larthUnitFrame["boss"..i]:CreateFontString(nil, "OVERLAY")
	larthUnitHealth["boss"..i]:SetPoint("BOTTOMLEFT")
	larthUnitHealth["boss"..i]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 20, "OUTLINE")
	larthUnitHealth["boss"..i]:SetTextColor(1, 0, 0)
	
	larthUnitPower["boss"..i] = larthUnitFrame["boss"..i]:CreateFontString(nil, "OVERLAY")
	larthUnitPower["boss"..i]:SetPoint("BOTTOMRIGHT")
	larthUnitPower["boss"..i]:SetFont("Interface\\AddOns\\larthUnitFrames\\font.ttf", 20, "OUTLINE")
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