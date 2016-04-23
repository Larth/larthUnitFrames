LarthUF.player.Frame = CreateFrame("Button", "larthPlayerFrame", UIParent)
LarthUF.player.Frame:EnableMouse(false)
LarthUF.player.Frame:SetWidth(250)
LarthUF.player.Frame:SetHeight(50)
LarthUF.player.Frame:SetPoint("CENTER", -250, 0)
LarthUF.player.Frame:SetAttribute("unit", "player")
RegisterUnitWatch(LarthUF.player.Frame)

-- dropdown menu somewhere near the name
LarthUF.player.Button = CreateFrame("Button", "button_player", LarthUF.player.Frame, "SecureActionButtonTemplate ");
LarthUF.player.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
LarthUF.player.Button:SetWidth(50)
LarthUF.player.Button:SetHeight(20)
LarthUF.player.Button:SetPoint("TOPLEFT", 0, 0)
LarthUF.player.Button:SetAttribute('type1', 'target')
LarthUF.player.Button:SetAttribute('unit', "player")
LarthUF.player.Button:SetAttribute('type2', 'menu')
LarthUF.player.Button.menu = function(self, unit, button, actionType)
		ToggleDropDownMenu(1, 1, PlayerFrameDropDown, LarthUF.player.Button, 0 ,0)
	end

-- this code is so copy/paste
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

-- quick pet frame
LarthUF.pet = {}
LarthUF.pet.Frame = CreateFrame("Button", "larthPetFrame", UIParent, "SecureUnitButtonTemplate")
LarthUF.pet.Frame:SetAttribute("unit", "pet")
LarthUF.pet.Frame:SetWidth(100)
LarthUF.pet.Frame:SetHeight(50)
LarthUF.pet.Frame:SetPoint("CENTER", -250, -100)
RegisterUnitWatch(LarthUF.pet.Frame)

LarthUF.setText("pet", "Health", "LEFT", 20)
LarthUF.setText("pet", "Name", "TOPLEFT", 18)

LarthUF.pet.Frame:RegisterEvent("UNIT_HEALTH_FREQUENT")
LarthUF.pet.Frame:RegisterEvent("UNIT_PET")
LarthUF.pet.Frame:RegisterEvent("UNIT_AURA")

LarthUF.pet.Frame:SetScript("OnEvent", function(self, event, ...)
    if (event == "UNIT_AURA") then
			-- Green name with Mend Pet Buff active
        local countAnt = select(7, UnitAura("pet", "Mend Pet"))
        if(countAnt) then
            LarthUF["pet"].Name:SetTextColor(0,1,0)
        else
            LarthUF["pet"].Name:SetTextColor(1,1,1)
        end
    elseif (event == "UNIT_PET") then
			LarthUF.pet.Name:SetText(UnitName("pet"))
    end
		-- Update Health
    local health = UnitHealth("pet")
    local maxHealth = UnitHealthMax("pet")
    local percent = LarthUF.round(100*health/maxHealth, 0)
    LarthUF["pet"].Health:SetTextColor((1-percent/100)*2, percent/50, 0)
    LarthUF["pet"].Health:SetText(LarthUF.round(percent))
end)
