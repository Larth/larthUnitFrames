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

LarthUnitFrames.setText("target", "Health", "RIGHT", 20)
LarthUnitFrames.setText("target", "HealthAbs", "LEFT", 20)
LarthUnitFrames.setText("target", "PowerAbs", "BOTTOMLEFT", 14)
LarthUnitFrames.setText("target", "Power", "BOTTOMRIGHT", 14)
LarthUnitFrames.setText("target", "Name", "TOPRIGHT", 18)
LarthUnitFrames.setText("target", "Aura", "TOPLEFT", 14)


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
			local _, targetClass, _ = UnitClass("target")
			local _, playerClass, _ = UnitClass("player")
			local color = RAID_CLASS_COLORS[targetClass]
			LarthUnitFrames.target.Name:SetTextColor(color.r, color.g, color.b)
			LarthUnitFrames.target.Watch = LarthUnitFrames.Classes[playerClass].Debuff
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