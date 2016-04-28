-- -----------------------------------------------------------------------------
-- Create Target of Target frame
-- -----------------------------------------------------------------------------

LarthUF.targettarget = {}
LarthUF.targettarget.Frame = CreateFrame("Button", "button_tot", UIParent, "SecureActionButtonTemplate ");
LarthUF.targettarget.Frame:RegisterForClicks("LeftButtonUp")
LarthUF.targettarget.Frame:SetWidth(100)
LarthUF.targettarget.Frame:SetHeight(30)
LarthUF.targettarget.Frame:SetPoint("BOTTOM", 425, 260)
LarthUF.targettarget.Frame:SetAttribute('type1', 'target')
LarthUF.targettarget.Frame:SetAttribute('unit', "targettarget")

LarthUF.setText("targettarget", "Name", "TOPRIGHT", 16)
LarthUF.setText("targettarget", "Health", "BOTTOMRIGHT", 16)


LarthUF.targettarget.Frame:SetScript("OnUpdate", function(self, elapsed)
	if UnitExists("targettarget") then
		local health = UnitHealth("targettarget")
		local maxHealth = UnitHealthMax("targettarget")
		local percent = LarthUF.round(100*health/maxHealth, 0)
		LarthUF.targettarget.Health:SetText(percent)
		LarthUF.targettarget.Health:SetTextColor((1-percent/100)*2, percent/50, 0)
		local class, classFileName = UnitClass("targettarget")
		local color = RAID_CLASS_COLORS[classFileName]
		LarthUF.targettarget.Name:SetText(format("|cff%s%s|r", strsub(color.colorStr, 3, 8), LarthUF.trimUnitName(UnitName("targettarget"))))
	else
		LarthUF.targettarget.Name:SetText("")
		LarthUF.targettarget.Health:SetText("")
	end
end)

-- Make the frame clickable and add context menu
LarthUF.targettarget.Frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
LarthUF.targettarget.Frame:SetAttribute("unit", "targettarget")
LarthUF.targettarget.Frame:SetAttribute("type1", "target")
LarthUF.targettarget.Frame:SetAttribute("type2", "menu")
LarthUF.targettarget.Frame.menu = function(self, unit, button, actionType)
	ToggleDropDownMenu(1, nil, PlayerFrameDropDown, LarthUF.targettarget.Frame, 0, 0)
end

RegisterUnitWatch(LarthUF.targettarget.Frame)
