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

-- the font 
local fontset = "Interface\\AddOns\\larthUnitFrames\\font.ttf"


-- initialize player table
local larthPlayer = {}


-- set the health texts
larthPlayer.setHealth = function ()
	local health = UnitHealth("player")
	local maxHealth = UnitHealthMax("player")
	local percent = 100*health/maxHealth
	if (percent < 100 and percent > 0) then
		larthPlayer.Health:SetText(longHealthString(percent))
		larthPlayer.HealthAbs:SetTextColor((1-percent/100)*2, percent/50, 0)
		if health > 9999 then
			larthPlayer.HealthAbs:SetText(round(health/1000).."k")
		else
			larthPlayer.HealthAbs:SetText(health)
		end		
	else
		larthPlayer.Health:SetText("")
		larthPlayer.HealthAbs:SetText("")
	end
end

-- set the power texts
larthPlayer.setPower = function()
	local power = UnitPower("player")
	local maxpower = UnitPowerMax("player")
	local percent = 100*power/maxpower
	if (percent < 100 and percent > 0) then
		larthPlayer.PowerAbs:SetText(power)
		larthPlayer.Power:SetText(longHealthString(percent))
	else
		larthPlayer.PowerAbs:SetText("")
		larthPlayer.Power:SetText("")
	end
end
-- -----------------------------------------------------------------------------
-- Create Player frame
-- -----------------------------------------------------------------------------

larthPlayer.Frame = CreateFrame("Button", "larthPlayerFrame", UIParent)
larthPlayer.Frame:EnableMouse(false)
larthPlayer.Frame:SetWidth(250)
larthPlayer.Frame:SetHeight(50)
larthPlayer.Frame:SetPoint("CENTER", -250, 0)

larthPlayer.Button = CreateFrame("Button", "button_player", larthPlayer.Frame, "SecureActionButtonTemplate ");
larthPlayer.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
larthPlayer.Button:SetWidth(50)
larthPlayer.Button:SetHeight(20)
larthPlayer.Button:SetPoint("TOPLEFT", 0, 0)
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
		larthPlayer.Name:SetText(spell.." - "..round(finish, 1))
	else
		larthPlayer.Name:SetText(UnitName("player"))
	end	
	local buffString = ""
	if ( larthPlayer.Watch) then
		for i=1, # larthPlayer.Watch do
			local _, _, _, _, _, _, expirationTime, unitCaster = UnitBuff("player", larthPlayer.Watch[i][1])
			if(unitCaster=="player")then 
				buffString = buffString..format("|cff%s%s|r", larthPlayer.Watch[i][2], (round(expirationTime - GetTime()).." "))
			end
		end
		larthPlayer.Aura:SetText(buffString)
	end
end)

larthPlayer.Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
larthPlayer.Frame:RegisterEvent("UNIT_HEALTH_FREQUENT")
larthPlayer.Frame:RegisterEvent("UNIT_POWER")



larthPlayer.Frame:SetScript("OnEvent", function(self, event, ...)
	if (event == "UNIT_POWER") then
		larthPlayer.setPower()
	elseif (event == "UNIT_HEALTH_FREQUENT") then
		larthPlayer.setHealth()
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		local localizedClass, englishClass, classIndex = UnitClass("player")
		larthPlayer.Watch = LarthUnitFrames.Classes[englishClass].Buff
		larthPlayer.Name:SetText(UnitName("player"))
		larthPlayer.setHealth()
		larthPlayer.setPower()
	end
end)