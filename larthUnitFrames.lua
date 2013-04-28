-- I'm playing with the German client. If you're not, well, I don't really care.

LarthUnitFrames = {
	Classes = {
		DEATHKNIGHT = {
			Buff = { {"Horn des Winters", "0099ff"} },
			Debuff = { {"Frostfieber", "6666ff"}, {"Blutseuche", "00ff00"} }
		},
		MAGE = {
			Buff = { {"Eisige Adern", "0099ff"}, {"Eisbarriere", "9999ff"} },
			Debuff = { {"Frostbombe", "9966ff"} },
		},
		MONK = {
			Buff = { {"Eisige Adern", "0099ff"}, {"Eisbarriere", "9999ff"} },
			Debuff = { {"Frostbombe", "9966ff"} },
			Special = 12
		},
		PALADIN = {
			Buff = { {"Inquisition", "ff9900"} },
			Debuff = {  },
			Special = 9
		},
		PRIEST = {
			Buff = { {"Machtwort: Schild", "ff9999"} },
			Debuff = { {"Schattenwort: Schmerz", "ff3366"}, {"Heiliges Feuer", "ff9900"} },
		},
		ROGUE = {
			Buff = { {"Vergiften", "00ff00"}, {"Schattenklingen", "ff00ff"}, {"Zerh\195\164ckseln", "ffff00"} },
			Debuff = { {"Blutung", "ff0000"}, {"Vendetta", "ffffff"}, {"Blutroter Sturm", "ff9999"} },
			RightClick = "Schurkenhandel"
		}
	}
}
LarthUnitFrames.font = "Interface\\AddOns\\larthUnitFrames\\font.ttf"

LarthUnitFrames.round = function(number, decimals)
	return tonumber((("%%.%df"):format(decimals)):format(number))
end

LarthUnitFrames.textBar = function(health)
	local derString = ""
	local lifef = LarthUnitFrames.round(health, 0)
	for i=0, 100, 10 do
		if lifef >= i and lifef < i+10 then
			derString = derString..format("|cff%s%s|r", "ff0000", lifef)
		else
			derString = derString..i
		end
	end
	return derString
end

LarthUnitFrames.setText = function (unit, text, position, size)
	LarthUnitFrames[unit][text] = LarthUnitFrames[unit].Frame:CreateFontString(nil, "OVERLAY")
	LarthUnitFrames[unit][text]:SetPoint(position)
	LarthUnitFrames[unit][text]:SetFont(LarthUnitFrames.font, size, "OUTLINE")
	LarthUnitFrames[unit][text]:SetTextColor(1, 1, 1)
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


LarthUnitFrames.Start = CreateFrame("Frame")

LarthUnitFrames.Start:RegisterEvent("VARIABLES_LOADED")

LarthUnitFrames.Start:SetScript("OnEvent", function(self, event, ...)
	local unit = ...
	if (event == "VARIABLES_LOADED") then
		-- make those proc indikaters fit between player and target frames
		SpellActivationOverlayFrame:SetScale(0.6);
		local localizedClass, englishClass, classIndex = UnitClass("player")
		
		-- hide the blizzard frames
		PlayerFrame:Hide()
        PlayerFrame:UnregisterAllEvents()
        TargetFrame:Hide()
        TargetFrame:UnregisterAllEvents()
        ComboFrame:Hide()
        ComboFrame:UnregisterAllEvents()
		RuneFrame:UnregisterAllEvents()
		RuneFrame:Hide()
		
		-- holy power, chi (hopefully)
		if (LarthUnitFrames.Classes[englishClass].Special) then
			larthSpecial.Frame:SetScript("OnUpdate", function(self, elapsed)
				local tempString = ""
				local power = UnitPower("player" , LarthUnitFrames.Classes[englishClass].Special);
				if power > 0 then
					for i = 1, power, 1 do
						tempString = tempString.."# "
					end
				end
				larthSpecial.Text:SetText(tempString)
			end)
		end
		
		-- some bad code here
		if (classIndex == 6) then
			larthSpecial.Frame:SetScript("OnUpdate", function(self, elapsed)
			local tempString = "";
			for i=1, 6, 1 do				
				local start, duration, runeReady = GetRuneCooldown(i)
				runeType = GetRuneType(i)
				local cooldown = LarthUnitFrames.round(duration-GetTime()+start)
				if cooldown > 9 or cooldown < 0 then
					cooldown = "_"
				end
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
-- Create Target of Target frame
-- -----------------------------------------------------------------------------

LarthUnitFrames.targettarget = {}
LarthUnitFrames.targettarget.Frame = CreateFrame("Button", "button_tot", UIParent, "SecureActionButtonTemplate ");
LarthUnitFrames.targettarget.Frame:RegisterForClicks("LeftButtonUp")
LarthUnitFrames.targettarget.Frame:SetWidth(100)
LarthUnitFrames.targettarget.Frame:SetHeight(30)
LarthUnitFrames.targettarget.Frame:SetPoint("CENTER", 450, 0)
LarthUnitFrames.targettarget.Frame:SetAttribute('type1', 'target')
LarthUnitFrames.targettarget.Frame:SetAttribute('unit', "targettarget")

LarthUnitFrames.setText("targettarget", "Name", "TOPLEFT", 18)
LarthUnitFrames.setText("targettarget", "Health", "BOTTOMLEFT", 18)


LarthUnitFrames.targettarget.Frame:SetScript("OnUpdate", function(self, elapsed)
	if UnitExists("targettarget") then 
		local health = UnitHealth("targettarget")
		local maxHealth = UnitHealthMax("targettarget")
		LarthUnitFrames.targettarget.Health:SetText(LarthUnitFrames.round(100*health/maxHealth, 0))
		local class, classFileName = UnitClass("targettarget")
		local color = RAID_CLASS_COLORS[classFileName]
		LarthUnitFrames.targettarget.Name:SetText(format("|cff%s%s|r", strsub(color.colorStr, 3, 8), trimUnitName(UnitName("targettarget"))))
	else
		LarthUnitFrames.targettarget.Name:SetText("")
		LarthUnitFrames.targettarget.Health:SetText("")
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
larthSpecial.Text:SetFont(LarthUnitFrames.font, 20, "OUTLINE")
larthSpecial.Text:SetTextColor(1, 1, 1)