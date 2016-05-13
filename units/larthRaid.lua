 -- -----------------------------------------------------------------------------
 -- RaidFrames
 -- -----------------------------------------------------------------------------


 -- what was I thinking?
 larthRaidFrame = CreateFrame("Frame")
 larthRaidFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
 larthRaidFrame:RegisterEvent("PLAYER_ROLES_ASSIGNED")
 -- so we won't show these frames for heal, cause heal needs better anyway
 larthRaidFrame:SetScript("OnEvent", function(self, event, ...)
  for i = 1, 40, 1 do
 	 if UnitExists("raid"..i) and UnitGroupRolesAssigned("player") ~= "HEALER" and not LarthUF.Frames["raid"..i]:IsShown() then
 		 LarthUF.Frames["raid"..i]:Show()
 	 elseif not UnitExists("raid"..i) and LarthUF.Frames["raid"..i]:IsShown() then
 		 LarthUF.Frames["raid"..i]:Hide()
 	 end
  end
 end)


 -- even though little dps me doesn't care about others
 -- there is something like NUM_MAX_RAIDMEMBERS or with a similar name but 40 is nice, too
 for i = 1, 40, 1 do
  -- Create the Frame
  LarthUF["raid"..i] = {}
  LarthUF.Frames["raid"..i] = CreateFrame("Button", "button_raid"..i, UIParent, "SecureUnitButtonTemplate ")
  LarthUF.Frames["raid"..i]:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  LarthUF.Frames["raid"..i]:SetAttribute('type1', 'target')
  LarthUF.Frames["raid"..i]:SetAttribute('unit', "raid"..i)
  LarthUF.Frames["raid"..i]:SetAttribute('type2', 'spell')
  -- yeah it's only tricks of the trade (Schurkenhandel) here, go cry if you're no rogue
  LarthUF.Frames["raid"..i]:SetAttribute('spell', "Tricks of the Trade")
  LarthUF.Frames["raid"..i]:SetWidth(120)
  LarthUF.Frames["raid"..i]:SetHeight(20)
  -- Position the Frame
  --
  if i <= 20 then
 	 LarthUF.Frames["raid"..i]:SetPoint("TOPLEFT", 15, -400-i*20)
  else
 	 LarthUF.Frames["raid"..i]:SetPoint("TOPLEFT", 150, -400-(i-20)*20)
  end
  LarthUF.Frames["raid"..i]:Hide()

  LarthUF.setText("raid"..i, "Name", "LEFT", 14)
  LarthUF.setText("raid"..i, "Health", "RIGHT", 14)

  LarthUF.Frames["raid"..i]:RegisterEvent("GROUP_ROSTER_UPDATE")
  LarthUF.Frames["raid"..i]:RegisterEvent("PLAYER_ROLES_ASSIGNED")
     LarthUF.Frames["raid"..i]:RegisterEvent("UNIT_NAME_UPDATE")

  LarthUF.Frames["raid"..i]:SetScript("OnEvent", function(self, event, ...)
     if UnitExists("raid"..i) then
 		 local class, classFileName = UnitClass("raid"..i)
 		 local role = UnitGroupRolesAssigned("raid"..i)
 		 local derSring = ""
 		 -- thought this was stupid, but it proved useful already
 		 if role == "DAMAGER" then
 			 derString = format("|cff%s%s|r", "ff9933", "D: ")
 		 elseif role == "HEALER" then
 			 derString = format("|cff%s%s|r", "33ff33", "H: ")
 		 elseif role == "TANK" then
 			 derString = format("|cff%s%s|r", "ccff33", "T: ")
 		 else
 			 derString = format("|cff%s%s|r", "ffffff", "_: ")
 		 end
 		 LarthUF["raid"..i].Name:SetText(derString..strsub(UnitName("raid"..i),1, 10))

 		 if (classFileName) then
 			 LarthUF["raid"..i].Name:SetTextColor(RAID_CLASS_COLORS[classFileName].r, RAID_CLASS_COLORS[classFileName].g, RAID_CLASS_COLORS[classFileName].b)
 		 end
 	 end
  end)

  -- guess i could move this to OnEvent
  LarthUF.Frames["raid"..i]:SetScript("OnUpdate", function(self, elapsed)
 	 if UnitExists("raid"..i) then
 		 local health = UnitHealth("raid"..i)
 		 local maxHealth = UnitHealthMax("raid"..i)
 		 local percent = LarthUF.round(100*health/maxHealth, 0)
 		 LarthUF["raid"..i].Health:SetText(LarthUF.round(percent))
 		 LarthUF["raid"..i].Health:SetTextColor((1-percent/100)*2, percent/50, 0)
 	 else
 		 LarthUF["raid"..i].Health:SetText("")
 		 LarthUF["raid"..i].Name:SetText("")
 	 end
  end)

  LarthUF.Frames["raid"..i]:SetScript("OnEnter", function(self, elapsed)
 	 LarthUF["raid"..i].Name:SetTextColor(0.7, 0.7, 0.7)
  end)

  LarthUF.Frames["raid"..i]:SetScript("OnLeave", function(self, elapsed)
 	 local class, classFileName = UnitClass("raid"..i)
 	 if (classFileName) then
 		 LarthUF["raid"..i].Name:SetTextColor(RAID_CLASS_COLORS[classFileName].r, RAID_CLASS_COLORS[classFileName].g, RAID_CLASS_COLORS[classFileName].b)
 	 end
  end)

 end
