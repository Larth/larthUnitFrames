-- quick pet frame
LarthUF.pet = {}
LarthUF.Frames.pet = CreateFrame("Button", "larthPetFrame", UIParent, "SecureUnitButtonTemplate")
LarthUF.Frames.pet:RegisterForClicks("LeftButtonUp", "RightButtonUp")
LarthUF.Frames.pet:SetAttribute('type1', "target")
LarthUF.Frames.pet:SetAttribute("unit", "pet")
LarthUF.Frames.pet:SetAttribute('type2', 'menu')
LarthUF.Frames.pet.menu = function(self, unit, button, actionType)
		ToggleDropDownMenu(1, nil, PetFrameDropDown, LarthUF.Frames.pet, 0 ,0)
	end
LarthUF.Frames.pet:SetWidth(100)
LarthUF.Frames.pet:SetHeight(30)
LarthUF.Frames.pet:SetPoint("BOTTOM", -425, 260)
RegisterUnitWatch(LarthUF.Frames.pet)

LarthUF.setText("pet", "Health", "BOTTOMLEFT", 16)
LarthUF.setText("pet", "Name", "TOPLEFT", 16)

LarthUF.Frames.pet:RegisterEvent("UNIT_HEALTH_FREQUENT")
LarthUF.Frames.pet:RegisterEvent("UNIT_PET")
LarthUF.Frames.pet:RegisterEvent("UNIT_AURA")

LarthUF.Frames.pet:SetScript("OnEvent", function(self, event, ...)
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
    LarthUF["pet"].Health:SetText(percent)
end)
