LarthUF.player.Frame = CreateFrame("Button", "larthPlayerFrame", UIParent, "SecureUnitButtonTemplate")
LarthUF.player.Frame:SetWidth(250)
LarthUF.player.Frame:SetHeight(50)
LarthUF.player.Frame:SetPoint("BOTTOM", -350, 200)

-- Make the frame clickable and add context menu
LarthUF.player.Frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
LarthUF.player.Frame:SetAttribute("unit", "player")
LarthUF.player.Frame:SetAttribute("type1", "target")
LarthUF.player.Frame:SetAttribute("type2", "menu")
LarthUF.player.Frame.menu = function(self, unit, button, actionType)
	ToggleDropDownMenu(1, nil, PlayerFrameDropDown, LarthUF.player.Frame, 0, 0)
end
-- remind yourself what this is for
RegisterUnitWatch(LarthUF.player.Frame)


-- place the texts inside the frame
LarthUF.setText("player", "Health", "LEFT", 18)
LarthUF.setText("player", "HealthAbs", "RIGHT", 18)
LarthUF.setText("player", "PowerAbs", "BOTTOMRIGHT", 14)
LarthUF.setText("player", "Power", "BOTTOMLEFT", 14)
LarthUF.setText("player", "Name", "TOPLEFT", 18)
LarthUF.setText("player", "Aura", "TOPRIGHT", 14)


-- show durations of the important buffs/debuffs specified somewhere else
-- maybe put a timer thing here?
-- just saw this: there is some cast timer, too.
LarthUF.player.Frame:SetScript("OnUpdate", function(self, elapsed)
	local spell, _, _, _, _, endTime = UnitCastingInfo("player")
	if spell then
		local finish = endTime/1000 - GetTime()
		LarthUF.player.Name:SetText(spell.." - "..LarthUF.round(finish, 1))
	else
		LarthUF.player.Name:SetText(UnitName("player"))
	end


	local buffString = ""
	 if ( LarthUF.player.Watch) then
		 for i=1, # LarthUF.player.Watch do
			 local spellName = select(1, GetSpellInfo(LarthUF.player.Watch[i][1]))
			 local _, _, _, _, _, _, expirationTime, unitCaster = UnitBuff("player", spellName)
			 if(unitCaster=="player")then
				 buffString = buffString..format("|cff%s%s|r", LarthUF.player.Watch[i][2], (LarthUF.round(expirationTime - GetTime()).." "))
			 end
		 end
		 LarthUF.player.Aura:SetText(buffString)
	 end
end)


-- updating health and power when it is needed (works most of the time)
LarthUF.player.Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
LarthUF.player.Frame:RegisterEvent("UNIT_HEALTH_FREQUENT")
LarthUF.player.Frame:RegisterEvent("UNIT_POWER_FREQUENT")

LarthUF.player.Frame:SetScript("OnEvent", function(self, event, ...)
	if (event == "UNIT_POWER_FREQUENT") then
		LarthUF.setPower("player")
	elseif (event == "UNIT_HEALTH_FREQUENT") then
		LarthUF.setHealth("player")
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		local localizedClass, englishClass, classIndex = UnitClass("player")
		--no name here, name is spammed in the onUpdate atm
		--LarthUF.player.Name:SetText(UnitName("player"))
		LarthUF.setHealth("player")
		LarthUF.setPower("player")
	end
end)
