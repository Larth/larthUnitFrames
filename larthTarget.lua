-- initialize target table
LarthUnitFrames.target = {}

-- set the health texts
LarthUnitFrames.target.setHealth = function ()
	local health = UnitHealth("target")
	local maxHealth = UnitHealthMax("target")
	local percent = 100*health/maxHealth
	LarthUnitFrames.target.Health:SetText(LarthUnitFrames.textBar(percent))
	LarthUnitFrames.target.HealthAbs:SetTextColor((1-percent/100)*2, percent/50, 0)
	if health > 9999 then
		LarthUnitFrames.target.HealthAbs:SetText(LarthUnitFrames.round(health/1000).."k")
	else
		LarthUnitFrames.target.HealthAbs:SetText(health)
	end		
end

-- set the power texts
LarthUnitFrames.target.setPower = function()
	local power = UnitPower("target")
	local maxpower = UnitPowerMax("target")
	local percent = 100*power/maxpower
	LarthUnitFrames.target.PowerAbs:SetText(power)
	LarthUnitFrames.target.Power:SetText(LarthUnitFrames.textBar(percent))
end

-- -----------------------------------------------------------------------------
-- Create target frame
-- -----------------------------------------------------------------------------

LarthUnitFrames.target.Frame = CreateFrame("Button", "larthPlayerFrame", UIParent)
LarthUnitFrames.target.Frame:EnableMouse(false)
LarthUnitFrames.target.Frame:SetWidth(250)
LarthUnitFrames.target.Frame:SetHeight(50)
LarthUnitFrames.target.Frame:SetPoint("CENTER", 250, 0)

LarthUnitFrames.target.Button = CreateFrame("Button", "button_player", LarthUnitFrames.target.Frame, "SecureActionButtonTemplate ");
LarthUnitFrames.target.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
LarthUnitFrames.target.Button:SetWidth(50)
LarthUnitFrames.target.Button:SetHeight(20)
LarthUnitFrames.target.Button:SetPoint("TOPRIGHT", 0, 0)
LarthUnitFrames.target.Button:SetAttribute('type1', 'target')
LarthUnitFrames.target.Button:SetAttribute('unit', "target")
LarthUnitFrames.target.Button:SetAttribute('type2', 'menu')
LarthUnitFrames.target.Button.menu = function(self, unit, button, actionType) 
		ToggleDropDownMenu(1, 1, PlayerFrameDropDown, LarthUnitFrames.target.Button, 0 ,0) 
	end

-- this code is so copy/paste	
LarthUnitFrames.target.Health = LarthUnitFrames.target.Frame:CreateFontString(nil, "OVERLAY")
LarthUnitFrames.target.Health:SetPoint("RIGHT")
LarthUnitFrames.target.Health:SetFont(LarthUnitFrames.font, 20, "OUTLINE")
LarthUnitFrames.target.Health:SetTextColor(1, 1, 1)

LarthUnitFrames.target.HealthAbs = LarthUnitFrames.target.Frame:CreateFontString(nil, "OVERLAY")
LarthUnitFrames.target.HealthAbs:SetPoint("LEFT")
LarthUnitFrames.target.HealthAbs:SetFont(LarthUnitFrames.font, 20, "OUTLINE")
LarthUnitFrames.target.HealthAbs:SetTextColor(1, 1, 1)

LarthUnitFrames.target.PowerAbs = LarthUnitFrames.target.Frame:CreateFontString(nil, "OVERLAY")
LarthUnitFrames.target.PowerAbs:SetPoint("BOTTOMLEFT")
LarthUnitFrames.target.PowerAbs:SetFont(LarthUnitFrames.font, 14, "THINOUTLINE")
LarthUnitFrames.target.PowerAbs:SetTextColor(1, 1, 1)

LarthUnitFrames.target.Power = LarthUnitFrames.target.Frame:CreateFontString(nil, "OVERLAY")
LarthUnitFrames.target.Power:SetPoint("BOTTOMRIGHT")
LarthUnitFrames.target.Power:SetFont(LarthUnitFrames.font, 14, "THINOUTLINE")
LarthUnitFrames.target.Power:SetTextColor(1, 1, 1)

LarthUnitFrames.target.Name = LarthUnitFrames.target.Frame:CreateFontString(nil, "OVERLAY")
LarthUnitFrames.target.Name:SetPoint("TOPRIGHT")
LarthUnitFrames.target.Name:SetFont(LarthUnitFrames.font, 18, "OUTLINE")
LarthUnitFrames.target.Name:SetTextColor(1, 1, 1)


LarthUnitFrames.target.Aura = LarthUnitFrames.target.Frame:CreateFontString(nil, "OVERLAY")
LarthUnitFrames.target.Aura:SetPoint("TOPLEFT")
LarthUnitFrames.target.Aura:SetFont(LarthUnitFrames.font, 14, "THINOUTLINE")
LarthUnitFrames.target.Aura:SetTextColor(1, 1, 1)




-- show durations of the important buffs/debuffs specified somewhere else
-- maybe put a timer thing here?
-- just saw this: there is some cast timer, too.
LarthUnitFrames.target.Frame:SetScript("OnUpdate", function(self, elapsed)
	local spell, _, _, _, _, endTime = UnitCastingInfo("target")
	if spell then 
		local finish = endTime/1000 - GetTime()
		LarthUnitFrames.target.Name:SetText(spell.." - "..LarthUnitFrames.round(finish, 1))
	else
		LarthUnitFrames.target.Name:SetText(UnitName("target"))
	end	
	local buffString = ""
	if ( LarthUnitFrames.target.Watch) then
		for i=1, # LarthUnitFrames.target.Watch do
			local _, _, _, _, _, _, expirationTime, unitCaster = UnitDebuff("target", LarthUnitFrames.target.Watch[i][1])
			if(unitCaster=="player")then 
				buffString = buffString..format("|cff%s%s|r", LarthUnitFrames.target.Watch[i][2], (LarthUnitFrames.round(expirationTime - GetTime()).." "))
			end
		end
		LarthUnitFrames.target.Aura:SetText(buffString)
	end
end)


-- updating health and power when it is needed (works most of the time)
LarthUnitFrames.target.Frame:RegisterEvent("PLAYER_TARGET_CHANGED")
LarthUnitFrames.target.Frame:RegisterEvent("UNIT_HEALTH_FREQUENT")
LarthUnitFrames.target.Frame:RegisterEvent("UNIT_POWER")

LarthUnitFrames.target.Frame:SetScript("OnEvent", function(self, event, ...)
	if (UnitExists("target")) then
		if (event == "UNIT_POWER") then
			LarthUnitFrames.target.setPower()
		elseif (event == "UNIT_HEALTH_FREQUENT") then
			LarthUnitFrames.target.setHealth()
		elseif ( event == "PLAYER_TARGET_CHANGED" ) then
			local localizedClass, englishClass, classIndex = UnitClass("player")
			LarthUnitFrames.target.Watch = LarthUnitFrames.Classes[englishClass].Debuff
			LarthUnitFrames.target.setHealth()
			LarthUnitFrames.target.setPower()
		end
	else
		LarthUnitFrames.target.Health:SetText("")
		LarthUnitFrames.target.HealthAbs:SetText("")
		LarthUnitFrames.target.Power:SetText("")
		LarthUnitFrames.target.PowerAbs:SetText("")
	end
	
end)