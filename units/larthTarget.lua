LarthUF.Frames.target = CreateFrame("Button", "larthTargetFrame", UIParent, "SecureUnitButtonTemplate")
--LarthUF.Frames.target:EnableMouse(false)
LarthUF.Frames.target:SetAttribute("unit", "target")
LarthUF.Frames.target:SetWidth(250)
LarthUF.Frames.target:SetHeight(50)
LarthUF.Frames.target:SetPoint("CENTER", 350, -200)
RegisterUnitWatch(LarthUF.Frames.target)

-- Make the frame clickable and add context menu
LarthUF.Frames.target:RegisterForClicks("LeftButtonUp", "RightButtonUp")
LarthUF.Frames.target:SetAttribute("unit", "target")
LarthUF.Frames.target:SetAttribute("type1", "target")
LarthUF.Frames.target:SetAttribute("type2", "menu")
LarthUF.Frames.target.menu = function(self, unit, button, actionType)
	ToggleDropDownMenu(1, nil, PlayerFrameDropDown, LarthUF.Frames.target, 0, 0)
end


RegisterUnitWatch(LarthUF.Frames.target)


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
LarthUF.Frames.target:SetScript("OnUpdate", function(self, elapsed)
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
			--  for i=1, # LarthUF.target.Watch do
      --               local spellName = select(1, GetSpellInfo(LarthUF.target.Watch[i][1]))
      --               local _, _, _, _, _, _, expirationTime, unitCaster = UnitDebuff("target", spellName)
      --                if(unitCaster=="player")then
      --                    buffString = buffString..format("|cff%s%s|r", LarthUF.target.Watch[i][2], (LarthUF.round(expirationTime - GetTime()).." "))
      --                end
      --            -- end
			--  end
			 LarthUF.target.Aura:SetText(buffString)
		 end
	end
end)


-- updating health and power when it is needed (works most of the time)
LarthUF.Frames.target:RegisterEvent("PLAYER_TARGET_CHANGED")
LarthUF.Frames.target:RegisterEvent("UNIT_HEALTH_FREQUENT")
LarthUF.Frames.target:RegisterEvent("UNIT_POWER")

LarthUF.Frames.target:SetScript("OnEvent", function(self, event, ...)
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
