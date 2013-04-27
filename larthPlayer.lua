-- initialize player table
LarthUnitFrames.Player = {}

-- set the health texts
LarthUnitFrames.Player.setHealth = function ()
	local health = UnitHealth("player")
	local maxHealth = UnitHealthMax("player")
	local percent = 100*health/maxHealth
	LarthUnitFrames.Player.Health:SetText(LarthUnitFrames.textBar(percent))
	LarthUnitFrames.Player.HealthAbs:SetTextColor((1-percent/100)*2, percent/50, 0)
	if health > 9999 then
		LarthUnitFrames.Player.HealthAbs:SetText(LarthUnitFrames.round(health/1000).."k")
	else
		LarthUnitFrames.Player.HealthAbs:SetText(health)
	end		
end

-- set the power texts
LarthUnitFrames.Player.setPower = function()
	local power = UnitPower("player")
	local maxpower = UnitPowerMax("player")
	local percent = 100*power/maxpower
	LarthUnitFrames.Player.PowerAbs:SetText(power)
	LarthUnitFrames.Player.Power:SetText(LarthUnitFrames.textBar(percent))

end
-- -----------------------------------------------------------------------------
-- Create Player frame
-- -----------------------------------------------------------------------------

LarthUnitFrames.Player.Frame = CreateFrame("Button", "larthPlayerFrame", UIParent)
LarthUnitFrames.Player.Frame:EnableMouse(false)
LarthUnitFrames.Player.Frame:SetWidth(250)
LarthUnitFrames.Player.Frame:SetHeight(50)
LarthUnitFrames.Player.Frame:SetPoint("CENTER", -250, 0)

LarthUnitFrames.Player.Button = CreateFrame("Button", "button_player", LarthUnitFrames.Player.Frame, "SecureActionButtonTemplate ");
LarthUnitFrames.Player.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
LarthUnitFrames.Player.Button:SetWidth(50)
LarthUnitFrames.Player.Button:SetHeight(20)
LarthUnitFrames.Player.Button:SetPoint("TOPLEFT", 0, 0)
LarthUnitFrames.Player.Button:SetAttribute('type1', 'target')
LarthUnitFrames.Player.Button:SetAttribute('unit', "player")
LarthUnitFrames.Player.Button:SetAttribute('type2', 'menu')
LarthUnitFrames.Player.Button.menu = function(self, unit, button, actionType) 
		ToggleDropDownMenu(1, 1, PlayerFrameDropDown, LarthUnitFrames.Player.Button, 0 ,0) 
	end

-- this code is so copy/paste	
LarthUnitFrames.Player.Health = LarthUnitFrames.Player.Frame:CreateFontString(nil, "OVERLAY")
LarthUnitFrames.Player.Health:SetPoint("LEFT")
LarthUnitFrames.Player.Health:SetFont(LarthUnitFrames.font, 20, "OUTLINE")
LarthUnitFrames.Player.Health:SetTextColor(1, 1, 1)

LarthUnitFrames.Player.HealthAbs = LarthUnitFrames.Player.Frame:CreateFontString(nil, "OVERLAY")
LarthUnitFrames.Player.HealthAbs:SetPoint("RIGHT")
LarthUnitFrames.Player.HealthAbs:SetFont(LarthUnitFrames.font, 20, "OUTLINE")
LarthUnitFrames.Player.HealthAbs:SetTextColor(1, 1, 1)

LarthUnitFrames.Player.PowerAbs = LarthUnitFrames.Player.Frame:CreateFontString(nil, "OVERLAY")
LarthUnitFrames.Player.PowerAbs:SetPoint("BOTTOMRIGHT")
LarthUnitFrames.Player.PowerAbs:SetFont(LarthUnitFrames.font, 14, "THINOUTLINE")
LarthUnitFrames.Player.PowerAbs:SetTextColor(1, 1, 1)

LarthUnitFrames.Player.Power = LarthUnitFrames.Player.Frame:CreateFontString(nil, "OVERLAY")
LarthUnitFrames.Player.Power:SetPoint("BOTTOMLEFT")
LarthUnitFrames.Player.Power:SetFont(LarthUnitFrames.font, 14, "THINOUTLINE")
LarthUnitFrames.Player.Power:SetTextColor(1, 1, 1)

LarthUnitFrames.Player.Name = LarthUnitFrames.Player.Frame:CreateFontString(nil, "OVERLAY")
LarthUnitFrames.Player.Name:SetPoint("TOPLEFT")
LarthUnitFrames.Player.Name:SetFont(LarthUnitFrames.font, 18, "OUTLINE")
LarthUnitFrames.Player.Name:SetTextColor(1, 1, 1)


LarthUnitFrames.Player.Aura = LarthUnitFrames.Player.Frame:CreateFontString(nil, "OVERLAY")
LarthUnitFrames.Player.Aura:SetPoint("TOPRIGHT")
LarthUnitFrames.Player.Aura:SetFont(LarthUnitFrames.font, 14, "THINOUTLINE")
LarthUnitFrames.Player.Aura:SetTextColor(1, 1, 1)




-- show durations of the important buffs/debuffs specified somewhere else
-- maybe put a timer thing here?
-- just saw this: ther is some cast timer, too.
LarthUnitFrames.Player.Frame:SetScript("OnUpdate", function(self, elapsed)
	local spell, _, _, _, _, endTime = UnitCastingInfo("player")
	if spell then 
		local finish = endTime/1000 - GetTime()
		LarthUnitFrames.Player.Name:SetText(spell.." - "..LarthUnitFrames.round(finish, 1))
	else
		LarthUnitFrames.Player.Name:SetText(UnitName("player"))
	end	
	local buffString = ""
	if ( LarthUnitFrames.Player.Watch) then
		for i=1, # LarthUnitFrames.Player.Watch do
			local _, _, _, _, _, _, expirationTime, unitCaster = UnitBuff("player", LarthUnitFrames.Player.Watch[i][1])
			if(unitCaster=="player")then 
				buffString = buffString..format("|cff%s%s|r", LarthUnitFrames.Player.Watch[i][2], (LarthUnitFrames.round(expirationTime - GetTime()).." "))
			end
		end
		LarthUnitFrames.Player.Aura:SetText(buffString)
	end
end)


-- updating health and power when it is needed (works most of the time)
LarthUnitFrames.Player.Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
LarthUnitFrames.Player.Frame:RegisterEvent("UNIT_HEALTH_FREQUENT")
LarthUnitFrames.Player.Frame:RegisterEvent("UNIT_POWER")

LarthUnitFrames.Player.Frame:SetScript("OnEvent", function(self, event, ...)
	if (event == "UNIT_POWER") then
		LarthUnitFrames.Player.setPower()
	elseif (event == "UNIT_HEALTH_FREQUENT") then
		LarthUnitFrames.Player.setHealth()
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		local localizedClass, englishClass, classIndex = UnitClass("player")
		LarthUnitFrames.Player.Watch = LarthUnitFrames.Classes[englishClass].Buff
		--no name here, name is spammed in the onUpdate atm
		--LarthUnitFrames.Player.Name:SetText(UnitName("player"))
		LarthUnitFrames.Player.setHealth()
		LarthUnitFrames.Player.setPower()
	end
end)