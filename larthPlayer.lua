LarthUnitFrames.player.Frame = CreateFrame("Button", "larthPlayerFrame", UIParent)
LarthUnitFrames.player.Frame:EnableMouse(false)
LarthUnitFrames.player.Frame:SetWidth(250)
LarthUnitFrames.player.Frame:SetHeight(50)
LarthUnitFrames.player.Frame:SetPoint("CENTER", -250, 0)
LarthUnitFrames.player.Frame:SetAttribute("unit", "player")
RegisterUnitWatch(LarthUnitFrames.player.Frame)

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
-- just saw this: there is some cast timer, too.
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
			 local spellName = select(1, GetSpellInfo(LarthUnitFrames.player.Watch[i][1]))
			 local _, _, _, _, _, _, expirationTime, unitCaster = UnitBuff("player", spellName)
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
LarthUnitFrames.player.Frame:RegisterEvent("UNIT_POWER_FREQUENT")

LarthUnitFrames.player.Frame:SetScript("OnEvent", function(self, event, ...)
	if (event == "UNIT_POWER_FREQUENT") then
		LarthUnitFrames.setPower("player")
	elseif (event == "UNIT_HEALTH_FREQUENT") then
		LarthUnitFrames.setHealth("player")
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		local localizedClass, englishClass, classIndex = UnitClass("player")
		--no name here, name is spammed in the onUpdate atm
		--LarthUnitFrames.player.Name:SetText(UnitName("player"))
		LarthUnitFrames.setHealth("player")
		LarthUnitFrames.setPower("player")
	end
end)

-- quick pet frame
LarthUnitFrames.pet = {}
LarthUnitFrames.pet.Frame = CreateFrame("Button", "larthPetFrame", UIParent, "SecureUnitButtonTemplate")
LarthUnitFrames.pet.Frame:SetAttribute("unit", "pet")
LarthUnitFrames.pet.Frame:SetWidth(100)
LarthUnitFrames.pet.Frame:SetHeight(50)
LarthUnitFrames.pet.Frame:SetPoint("CENTER", -250, -100)
RegisterUnitWatch(LarthUnitFrames.pet.Frame)

LarthUnitFrames.setText("pet", "Health", "LEFT", 20)
LarthUnitFrames.setText("pet", "Name", "TOPLEFT", 18)

LarthUnitFrames.pet.Frame:RegisterEvent("UNIT_HEALTH_FREQUENT")
LarthUnitFrames.pet.Frame:RegisterEvent("UNIT_PET")
LarthUnitFrames.pet.Frame:RegisterEvent("UNIT_AURA")

LarthUnitFrames.pet.Frame:SetScript("OnEvent", function(self, event, ...)
    if (event == "UNIT_AURA") then
			-- Green name with Mend Pet Buff active
        local countAnt = select(7, UnitAura("pet", "Mend Pet"))
        if(countAnt) then
            LarthUnitFrames["pet"].Name:SetTextColor(0,1,0)
        else
            LarthUnitFrames["pet"].Name:SetTextColor(1,1,1)
        end
    elseif (event == "UNIT_PET") then
			LarthUnitFrames.pet.Name:SetText(UnitName("pet"))
    end
		-- Update Health
    local health = UnitHealth("pet")
    local maxHealth = UnitHealthMax("pet")
    local percent = LarthUnitFrames.round(100*health/maxHealth, 0)
    LarthUnitFrames["pet"].Health:SetTextColor((1-percent/100)*2, percent/50, 0)
    LarthUnitFrames["pet"].Health:SetText(LarthUnitFrames.round(percent))
end)
