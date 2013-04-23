local function round(number, decimals)
    return tonumber((("%%.%df"):format(decimals)):format(number))
end

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

local fontset = "Interface\\AddOns\\larthUnitFrames\\font.ttf"
local playerWatch = { {"Vergiften", "00ff00"}, {"Schattenklingen", "ff00ff"}, {"Zerh\195\164ckseln", "ffff00"} }

-- -----------------------------------------------------------------------------
-- Create Player frame
-- -----------------------------------------------------------------------------
local larthPlayer = {}
larthPlayer.Frame = CreateFrame("Button", "larthPlayerFrame", UIParent)
larthPlayer.Frame:EnableMouse(false)
larthPlayer.Frame:SetWidth(250)
larthPlayer.Frame:SetHeight(50)
larthPlayer.Frame:SetPoint("CENTER", -250, 0)

larthPlayer.Button = CreateFrame("Button", "button_player", larthPlayer.Frame, "SecureActionButtonTemplate ");
larthPlayer.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
larthPlayer.Button:SetWidth(50)
larthPlayer.Button:SetHeight(50)
larthPlayer.Button:SetPoint("RIGHT", 0, 0)
larthPlayer.Button:SetAttribute('type1', 'target')
larthPlayer.Button:SetAttribute('unit', "player")
larthPlayer.Button:SetAttribute('type2', 'menu')
larthPlayer.Button.menu = function(self, unit, button, actionType) 
		ToggleDropDownMenu(1, 1, PlayerFrameDropDown, larthPlayer.Button, 0 ,0) 
	end
	
larthPlayer.Health = larthPlayer.Frame:CreateFontString(nil, "OVERLAY")
larthPlayer.Health:SetPoint("LEFT")
larthPlayer.Health:SetFont(fontset, 20, "OUTLINE")
larthPlayer.Health:SetTextColor(1, 1, 1)

larthPlayer.HealthAbs = larthPlayer.Frame:CreateFontString(nil, "OVERLAY")
larthPlayer.HealthAbs:SetPoint("RIGHT")
larthPlayer.HealthAbs:SetFont(fontset, 20, "OUTLINE")
larthPlayer.HealthAbs:SetTextColor(1, 1, 1)

larthPlayer.PowerAbs = larthPlayer.Frame:CreateFontString(nil, "OVERLAY")
larthPlayer.PowerAbs:SetPoint("BOTTOMRIGHT")
larthPlayer.PowerAbs:SetFont(fontset, 14, "THINOUTLINE")
larthPlayer.PowerAbs:SetTextColor(1, 1, 1)

larthPlayer.Power = larthPlayer.Frame:CreateFontString(nil, "OVERLAY")
larthPlayer.Power:SetPoint("BOTTOMLEFT")
larthPlayer.Power:SetFont(fontset, 14, "THINOUTLINE")
larthPlayer.Power:SetTextColor(1, 1, 1)

larthPlayer.Name = larthPlayer.Frame:CreateFontString(nil, "OVERLAY")
larthPlayer.Name:SetPoint("TOPLEFT")
larthPlayer.Name:SetFont(fontset, 18, "OUTLINE")
larthPlayer.Name:SetTextColor(1, 1, 1)


larthPlayer.Aura = larthPlayer.Frame:CreateFontString(nil, "OVERLAY")
larthPlayer.Aura:SetPoint("TOPRIGHT")
larthPlayer.Aura:SetFont(fontset, 14, "THINOUTLINE")
larthPlayer.Aura:SetTextColor(1, 1, 1)





larthPlayer.Frame:SetScript("OnUpdate", function(self, elapsed)
	local spell, _, _, _, _, endTime = UnitCastingInfo("player")
	if spell then 
		local finish = endTime/1000 - GetTime()
		larthPlayer.Name:SetText(spell.." - "..round(finish))
	else
		larthPlayer.Name:SetText(UnitName("player"))
	end
	if UnitIsPVP("player") then
		larthPlayer.Name:SetTextColor(1, 0, 0)
	else
		larthPlayer.Name:SetTextColor(1, 1, 1)
	end
	local health = UnitHealth("player")
	local maxHealth = UnitHealthMax("player")
	local derString = ""..health
	local percent = 100*health/maxHealth
	larthPlayer.HealthAbs:SetTextColor((1-percent/100)*2, percent/50, 0)
	if #derString > 4 then
		larthPlayer.HealthAbs:SetText(strsub(derString, 1, -4).."k")
	else
		larthPlayer.HealthAbs:SetText(derString)
	end
	larthPlayer.Health:SetText(longHealthString(percent))
	larthPlayer.PowerAbs:SetText(round(UnitPower("player"), 0))
	larthPlayer.Power:SetText(longHealthString(100*UnitPower("player")/UnitPowerMax("player")))
	local tempString = ""
	
	local buffString = ""
	if ( playerWatch) then
		for i=1, # playerWatch do
			local _, _, _, _, _, _, expirationTime, unitCaster = UnitBuff("player", playerWatch[i][1])
			if(unitCaster=="player")then 
				buffString = buffString..format("|cff%s%s|r", playerWatch[i][2], (round(expirationTime - GetTime()).." "))
			end
		end
		larthPlayer.Aura:SetText(buffString)
	end
end)

larthPlayer.Frame:RegisterEvent("VARIABLES_LOADED")


larthPlayer.Frame:SetScript("OnEvent", function(self, event, ...)
	larthPlayer.Name:SetText(UnitName("player"))
end)