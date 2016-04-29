-- -----------------------------------------------------------------------------
-- Create Target of Target frame
-- -----------------------------------------------------------------------------

LarthUF.targettarget = {}
LarthUF.Frames.targettarget = CreateFrame("Button", "button_tot", UIParent, "SecureActionButtonTemplate ");
LarthUF.Frames.targettarget:RegisterForClicks("LeftButtonUp")
LarthUF.Frames.targettarget:SetWidth(100)
LarthUF.Frames.targettarget:SetHeight(30)
LarthUF.Frames.targettarget:SetPoint("BOTTOM", 425, 260)
LarthUF.Frames.targettarget:SetAttribute('type1', 'target')
LarthUF.Frames.targettarget:SetAttribute('unit', "targettarget")

LarthUF.setText("targettarget", "Name", "TOPRIGHT", 16)
LarthUF.setText("targettarget", "Health", "BOTTOMRIGHT", 16)


LarthUF.Frames.targettarget:SetScript("OnUpdate", function(self, elapsed)
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
LarthUF.Frames.targettarget:RegisterForClicks("LeftButtonUp", "RightButtonUp")
LarthUF.Frames.targettarget:SetAttribute("unit", "targettarget")
LarthUF.Frames.targettarget:SetAttribute("type1", "target")
LarthUF.Frames.targettarget:SetAttribute("type2", "menu")
LarthUF.Frames.targettarget.menu = function(self, unit, button, actionType)
	ToggleDropDownMenu(1, nil, PlayerFrameDropDown, LarthUF.Frames.targettarget, 0, 0)
end

RegisterUnitWatch(LarthUF.Frames.targettarget)
