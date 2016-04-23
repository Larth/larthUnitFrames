LarthUF.target.Frame = CreateFrame("Button", "larthTargetFrame", UIParent, "SecureUnitButtonTemplate")
--LarthUF.target.Frame:EnableMouse(false)
LarthUF.target.Frame:SetAttribute("unit", "target")
LarthUF.target.Frame:SetWidth(250)
LarthUF.target.Frame:SetHeight(50)
LarthUF.target.Frame:SetPoint("BOTTOM", 350, 0)
RegisterUnitWatch(LarthUF.target.Frame)

-- dropdown
LarthUF.target.Button = CreateFrame("Button", "button_target", LarthUF.target.Frame, "SecureActionButtonTemplate ");
LarthUF.target.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
LarthUF.target.Button:SetWidth(250)
LarthUF.target.Button:SetHeight(50)
LarthUF.target.Button:SetPoint("TOPRIGHT", 0, 0)
LarthUF.target.Button:SetAttribute('type1', 'target')
LarthUF.target.Button:SetAttribute('unit', "target")
LarthUF.target.Button:SetAttribute('type2', 'menu')
LarthUF.target.Button.menu = function(self, unit, button, actionType)
		ToggleDropDownMenu(1, 1, TargetFrameDropDown, LarthUF.target.Button, 0 ,0)
	end
-- this code is so copy/paste
LarthUF.setText("target", "Health", "RIGHT", 18)
LarthUF.setText("target", "HealthAbs", "LEFT", 18)
LarthUF.setText("target", "PowerAbs", "BOTTOMLEFT", 14)
LarthUF.setText("target", "Power", "BOTTOMRIGHT", 14)
LarthUF.setText("target", "Name", "TOPRIGHT", 18)
LarthUF.setText("target", "Aura", "TOPLEFT", 14)


-- show durations of the important buffs/debuffs specified somewhere else
-- maybe put a timer thing here?
-- just saw this: there is some cast timer, too.
LarthUF.target.Frame:SetScript("OnUpdate", function(self, elapsed)
	local spell, _, _, _, _, endTime = UnitCastingInfo("target")
	if (UnitExists("target")) then
		if spell then
			local finish = endTime/1000 - GetTime()
			LarthUF.target.Name:SetText(format("%10s - %s", spell, LarthUF.round(finish, 1)))
		else
			LarthUF.target.Name:SetText(strsub(UnitName("target"),1,20))
		end

		 local buffString = ""
		 if ( LarthUF.target.Watch) then
			 for i=1, # LarthUF.target.Watch do
                    local spellName = select(1, GetSpellInfo(LarthUF.target.Watch[i][1]))
                    local _, _, _, _, _, _, expirationTime, unitCaster = UnitDebuff("target", spellName)
                     if(unitCaster=="player")then
                         buffString = buffString..format("|cff%s%s|r", LarthUF.target.Watch[i][2], (LarthUF.round(expirationTime - GetTime()).." "))
                     end
                 -- end
			 end
			 LarthUF.target.Aura:SetText(buffString)
		 end
	end
end)


-- updating health and power when it is needed (works most of the time)
LarthUF.target.Frame:RegisterEvent("PLAYER_TARGET_CHANGED")
LarthUF.target.Frame:RegisterEvent("UNIT_HEALTH_FREQUENT")
LarthUF.target.Frame:RegisterEvent("UNIT_POWER")

LarthUF.target.Frame:SetScript("OnEvent", function(self, event, ...)
	if (UnitExists("target")) then
		LarthUF.setHealth("target")
		LarthUF.setPower("target")
		if ( event == "PLAYER_TARGET_CHANGED" ) then
			local _, targetClass, _ = UnitClass("target")
			if (targetClass == "") then
				LarthUF.target.Name:SetTextColor(1,1,1)
			else
				local color = RAID_CLASS_COLORS[targetClass]
				LarthUF.target.Name:SetTextColor(color.r, color.g, color.b)
			end
		end
	end
end)
