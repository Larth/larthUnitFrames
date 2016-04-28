-- quick pet frame
LarthUF.pet = {}
LarthUF.pet.Frame = CreateFrame("Button", "larthPetFrame", UIParent, "SecureUnitButtonTemplate")
LarthUF.pet.Frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
LarthUF.pet.Frame:SetAttribute('type1', "target")
LarthUF.pet.Frame:SetAttribute("unit", "pet")
LarthUF.pet.Frame:SetAttribute('type2', 'menu')
LarthUF.pet.Frame.menu = function(self, unit, button, actionType)
		ToggleDropDownMenu(1, nil, PetFrameDropDown, LarthUF.pet.Frame, 0 ,0)
	end
LarthUF.pet.Frame:SetWidth(100)
LarthUF.pet.Frame:SetHeight(30)
LarthUF.pet.Frame:SetPoint("BOTTOM", -425, 260)
RegisterUnitWatch(LarthUF.pet.Frame)

LarthUF.setText("pet", "Health", "BOTTOMLEFT", 16)
LarthUF.setText("pet", "Name", "TOPLEFT", 16)

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
    LarthUF["pet"].Health:SetText(percent)
end)
