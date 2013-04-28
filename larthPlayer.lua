-- initialize player table
LarthUnitFrames.player = {}

-- set the health texts
LarthUnitFrames.player.setHealth = function ()
	local health = UnitHealth("player")
	local maxHealth = UnitHealthMax("player")
	local percent = 100*health/maxHealth
	LarthUnitFrames.player.Health:SetText(LarthUnitFrames.textBar(percent))
	LarthUnitFrames.player.HealthAbs:SetTextColor((1-percent/100)*2, percent/50, 0)
	if health > 9999 then
		LarthUnitFrames.player.HealthAbs:SetText(LarthUnitFrames.round(health/1000).."k")
	else
		LarthUnitFrames.player.HealthAbs:SetText(health)
	end		
end

-- set the power texts
LarthUnitFrames.player.setPower = function()
	local power = UnitPower("player")
	local maxpower = UnitPowerMax("player")
	local percent = 100*power/maxpower
	LarthUnitFrames.player.PowerAbs:SetText(power)
	LarthUnitFrames.player.Power:SetText(LarthUnitFrames.textBar(percent))

end

LarthUnitFrames.player.Frame = CreateFrame("Button", "larthPlayerFrame", UIParent)
LarthUnitFrames.player.Frame:EnableMouse(false)
LarthUnitFrames.player.Frame:SetWidth(250)
LarthUnitFrames.player.Frame:SetHeight(50)
LarthUnitFrames.player.Frame:SetPoint("CENTER", -250, 0)

LarthUnitFrames.player.Button = CreateFrame("Button", "button_player", LarthUnitFrames.player.Frame, "SecureActionButtonTemplate ");
LarthUnitFrames.player.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
LarthUnitFrames.player.Button:SetWidth(50)
LarthUnitFrames.player.Button:SetHeight(20)
LarthUnitFrames.player.Button:SetPoint("TOPLEFT", 0, 0)
LarthUnitFrames.player.Button:SetAttribute('type1', 'target')
LarthUnitFrames.player.Button:SetAttribute('unit', "player")
LarthUnitFrames.player.Button:SetAttribute('type2', 'menu')
LarthUnitFrames.player.Button.menu = function(self, unit, button, actionType) 
		ToggleDropDownMenu(1, 1, PlayerFrameDropDown, LarthUnitFrames.player.Button, 0 ,0) 
	end

-- this code is so copy/paste	
LarthUnitFrames.setText("player", "Health", "LEFT", 20)
LarthUnitFrames.setText("player", "HealthAbs", "RIGHT", 20)
LarthUnitFrames.setText("player", "PowerAbs", "BOTTOMRIGHT", 14)
LarthUnitFrames.setText("player", "Power", "BOTTOMLEFT", 14)
LarthUnitFrames.setText("player", "Name", "TOPLEFT", 18)
LarthUnitFrames.setText("player", "Aura", "TOPRIGHT", 14)



-- show durations of the important buffs/debuffs specified somewhere else
-- maybe put a timer thing here?
-- just saw this: ther is some cast timer, too.
LarthUnitFrames.player.Frame:SetScript("OnUpdate", function(self, elapsed)
	local spell, _, _, _, _, endTime = UnitCastingInfo("player")
	if spell then 
		local finish = endTime/1000 - GetTime()
		LarthUnitFrames.player.Name:SetText(spell.." - "..LarthUnitFrames.round(finish, 1))
	else
		LarthUnitFrames.player.Name:SetText(UnitName("player"))
	end	
	local buffString = ""
	if ( LarthUnitFrames.player.Watch) then
		for i=1, # LarthUnitFrames.player.Watch do
			local _, _, _, _, _, _, expirationTime, unitCaster = UnitBuff("player", LarthUnitFrames.player.Watch[i][1])
			if(unitCaster=="player")then 
				buffString = buffString..format("|cff%s%s|r", LarthUnitFrames.player.Watch[i][2], (LarthUnitFrames.round(expirationTime - GetTime()).." "))
			end
		end
		LarthUnitFrames.player.Aura:SetText(buffString)
	end
end)


-- updating health and power when it is needed (works most of the time)
LarthUnitFrames.player.Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
LarthUnitFrames.player.Frame:RegisterEvent("UNIT_HEALTH_FREQUENT")
LarthUnitFrames.player.Frame:RegisterEvent("UNIT_POWER")

LarthUnitFrames.player.Frame:SetScript("OnEvent", function(self, event, ...)
	if (event == "UNIT_POWER") then
		LarthUnitFrames.player.setPower()
	elseif (event == "UNIT_HEALTH_FREQUENT") then
		LarthUnitFrames.player.setHealth()
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		local localizedClass, englishClass, classIndex = UnitClass("player")
		LarthUnitFrames.player.Watch = LarthUnitFrames.Classes[englishClass].Buff
		--no name here, name is spammed in the onUpdate atm
		--LarthUnitFrames.player.Name:SetText(UnitName("player"))
		LarthUnitFrames.player.setHealth()
		LarthUnitFrames.player.setPower()
	end
end)