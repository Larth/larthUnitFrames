LarthUF = {
	Classes = {
		DEATHKNIGHT = {
			Buff = {
                {57330, "0099ff"} --horn/remove
            },
			Debuff = {
                {55095, "6666ff"}, --frost fever
                {55078, "00ff00"}  --blood plague
            }
		},
		DRUID = {
			Buff = {
                {52610, "ffff00"}, --Savage Roar
                {102543, "0000ff"},--Incarnation CAT
                {106952, "ff0000"}, --Berserk
                {16974, "00ff00"}--Predatory Swiftness
                },
			Debuff = {
                {1079, "ff0000"}, --Rip
                {1822, "ffff00"} --Rake
            }
		},
		HUNTER = {
			Buff = {  },
			Debuff = {  }
		},
		MAGE = {
			Buff = {
                {12472, "0099ff"}, --icy veins,
                {11426, "9999ff"} --ice barrier
            },
			Debuff = {
                {44614, "9966ff"}--frostfire bolt
            }
		},
		MONK = {
			Buff = { },
			Debuff = { },
			Special = 12
		},
		PALADIN = {
			Buff = { },
			Debuff = {  },
			Special = 9
		},
		PRIEST = {
			Buff = {
                {129197, "000000"} --Insanity
            },
			Debuff = {
                {589, "ffff00"}, --Shadow Word: Pain
                {2944, "0000ff"},--Devouring Plague
                {34914, "ff0000"} --Vampiric Touch
            }
		},
		SHAMAN = {
			Buff = {  },
			Debuff = {  }
		},
		ROGUE = {
			Buff = {
                {32645, "00ff00"}, --Envenom
                {51690, "ff00ff"}, --Killing Spree
                {5171, "ffff00"}, --Slice and Dice
                {13750, "ffffff"}, --Adrenaline Rush
                {152151,"ff00ff"} --Shadow Reflection
            },
			Debuff = {
                {1943, "ff0000"}, --Rupture
                {79140, "ffffff"}, --Vendetta
                {16511, "ff9999"}, --Hemorrhage
                {84617, "cd7f32"} --Revealing Strike
            }--Revealing Strike
		},
		WARLOCK = {
			Buff = {  },
			Debuff = {  }
		},
		WARRIOR = {
			Buff = {  },
			Debuff = {  }
		}
	}
}


LarthUF.target = {}
LarthUF.player = {}
LarthUF.font = "Fonts\\ARIALN.TTF"

LarthUF.round = function(number, decimals)
	return tonumber((("%%.%df"):format(decimals)):format(number))
end

LarthUF.textBar = function(health)
	local derString = ""
	local lifef = LarthUF.round(health, 0)
	for i=0, 100, 10 do
		if lifef >= i and lifef < i+10 then
			derString = derString..format("|cff%s%s|r", "ff0000", lifef)
		else
			derString = derString..i
		end
	end
	return derString
end

LarthUF.setText = function (unit, text, position, size)
	LarthUF[unit][text] = LarthUF[unit].Frame:CreateFontString(nil, "OVERLAY")
	LarthUF[unit][text]:SetPoint(position)
	LarthUF[unit][text]:SetFont(LarthUF.font, size, "OUTLINE")
	LarthUF[unit][text]:SetTextColor(1, 1, 1)
end

-- set the health texts
LarthUF.setHealth = function (unit)
	local health = UnitHealth(unit)
	local maxHealth = UnitHealthMax(unit)
	local percent = 100*health/maxHealth
	LarthUF[unit].Health:SetText(LarthUF.textBar(percent))
	LarthUF[unit].HealthAbs:SetTextColor((1-percent/100)*2, percent/50, 0)
	if health > 9999 then
		LarthUF[unit].HealthAbs:SetText(LarthUF.round(health/1000).."k")
	else
		LarthUF[unit].HealthAbs:SetText(health)
	end
end

-- set the power texts
LarthUF.setPower = function(unit)
	local power = UnitPower(unit)
	local maxpower = UnitPowerMax(unit)
	local percent = 100*power/maxpower
	LarthUF[unit].PowerAbs:SetText(power)
	LarthUF[unit].Power:SetText(LarthUF.textBar(percent))
end
local function trimUnitName(unitName)
	local derString = ""
	if (strlen(unitName) < 20) then
		return unitName
	else
		for x in string.gmatch(unitName, "[^%s]+") do
			if strlen(x) > 10 then
				derString = derString..strsub(x, 1, 7)..". "
			else
				derString = derString..x.." "
			end
		end
		return derString
	end
end
local function runeColoring(runeType)
	local derString = ""
	if (runeType == 1) then
		derString = "ff0000"
	elseif (runeType == 2) then
		derString = "00ff00"
	elseif (runeType == 3) then
		derString = "6666ff"
	elseif (runeType == 4) then
		derString = "ff00ff"
	end
	return derString
end


LarthUF.Start = CreateFrame("Frame")

LarthUF.Start:RegisterEvent("VARIABLES_LOADED")

LarthUF.Start:SetScript("OnEvent", function(self, event, ...)
	local unit = ...
	if (event == "VARIABLES_LOADED") then
		-- make those proc indikaters fit between player and target frames
		SpellActivationOverlayFrame:SetScale(0.6);
		local localizedClass, englishClass, classIndex = UnitClass("player")
		LarthUF.target.Watch = LarthUF.Classes[englishClass].Debuff
		LarthUF.player.Watch = LarthUF.Classes[englishClass].Buff
		-- hide the blizzard frames
		PlayerFrame:Hide()
        PlayerFrame:UnregisterAllEvents()
        TargetFrame:Hide()
        TargetFrame:UnregisterAllEvents()
        ComboFrame:Hide()
        ComboFrame:UnregisterAllEvents()
		RuneFrame:UnregisterAllEvents()
		RuneFrame:Hide()

		-- holy power, chi (hopefully)
		if (LarthUF.Classes[englishClass].Special) then
			LarthUF.Special.Frame:SetScript("OnUpdate", function(self, elapsed)
				local tempString = ""
				local power = UnitPower("player" , LarthUF.Classes[englishClass].Special);
				if power > 0 then
					for i = 1, power, 1 do
						tempString = tempString.."# "
					end
				end
				LarthUF.Special.Text:SetText(tempString)
			end)
		end

-- Class Customization Start ---------------------------------------------------
		if (classIndex == 1) then
		elseif (classIndex == 2) then
		elseif (classIndex == 3) then
		elseif (classIndex == 4) then
			LarthUF.ROGUE.Init()
		elseif (classIndex == 5) then
		elseif (classIndex == 6) then
		elseif (classIndex == 7) then
		elseif (classIndex == 8) then
		elseif (classIndex == 9) then
		elseif (classIndex == 10) then
		elseif (classIndex == 11) then
		end
-- Class Customization End -----------------------------------------------------
		-- some bad code here
		if (classIndex == 6) then
			LarthUF.Special.Frame:SetScript("OnUpdate", function(self, elapsed)
			local tempString = "";
			for i=1, 6, 1 do
				local start, duration, runeReady = GetRuneCooldown(i)
				runeType = GetRuneType(i)
				local cooldown = LarthUF.round(duration-GetTime()+start)
				if cooldown > 9 or cooldown < 0 then
					cooldown = "_"
				end
				if runeReady then
					tempString = tempString..format("|cff%s%s|r", runeColoring(runeType), "# ")
				else
					tempString = tempString..format("|cff%s%s|r", runeColoring(runeType), cooldown.." ")
				end
			end
			LarthUF.Special.Text:SetText(tempString)
			end)
		end

		if ((classIndex == 4) or (classIndex == 11)) then
			LarthUF.Special.Frame:SetScript("OnUpdate", function(self, elapsed)
                local countAnt = select(4, UnitAura("player", "Anticipation"))
				local comboPoints = GetComboPoints("player")
                local strText = {}
                local strFormat = "|cff%s%s|cff%s%s|r"
                local strColor = {}

                local strAnt = ""
                local strCombo = ""

                if countAnt == nil then countAnt = 0 end

                for i=1, comboPoints, 1 do
                    if countAnt >= i then
                        strAnt = strAnt.." # "
                    else
                        strCombo = strCombo.." # "
                    end
                end
                LarthUF.Special.Text:SetText(format("|cff%s%s|cff%s%s|r", "ffffff", strCombo, "ff0000", strAnt))
			end)
		end
	end
end)

-- -----------------------------------------------------------------------------
-- Create Target of Target frame
-- -----------------------------------------------------------------------------

LarthUF.targettarget = {}
LarthUF.targettarget.Frame = CreateFrame("Button", "button_tot", UIParent, "SecureActionButtonTemplate ");
LarthUF.targettarget.Frame:RegisterForClicks("LeftButtonUp")
LarthUF.targettarget.Frame:SetWidth(100)
LarthUF.targettarget.Frame:SetHeight(30)
LarthUF.targettarget.Frame:SetPoint("CENTER", 450, 0)
LarthUF.targettarget.Frame:SetAttribute('type1', 'target')
LarthUF.targettarget.Frame:SetAttribute('unit', "targettarget")

LarthUF.setText("targettarget", "Name", "TOPLEFT", 16)
LarthUF.setText("targettarget", "Health", "BOTTOMLEFT", 16)


LarthUF.targettarget.Frame:SetScript("OnUpdate", function(self, elapsed)
	if UnitExists("targettarget") then
		local health = UnitHealth("targettarget")
		local maxHealth = UnitHealthMax("targettarget")
		LarthUF.targettarget.Health:SetText(LarthUF.round(100*health/maxHealth, 0))
		local class, classFileName = UnitClass("targettarget")
		local color = RAID_CLASS_COLORS[classFileName]
		LarthUF.targettarget.Name:SetText(format("|cff%s%s|r", strsub(color.colorStr, 3, 8), trimUnitName(UnitName("targettarget"))))
	else
		LarthUF.targettarget.Name:SetText("")
		LarthUF.targettarget.Health:SetText("")
	end
end)


-- -----------------------------------------------------------------------------
-- Create Special blah blah frame
-- -----------------------------------------------------------------------------
LarthUF.Special = {}
LarthUF.Special.Frame = CreateFrame("Frame", "larsClassSpecial", UIParent)
LarthUF.Special.Frame:SetFrameLevel(3)
LarthUF.Special.Frame:SetWidth(50)
LarthUF.Special.Frame:SetHeight(50)
LarthUF.Special.Frame:SetPoint("CENTER", 0, -100)
LarthUF.Special.Frame:Show()

LarthUF.Special.Text = LarthUF.Special.Frame:CreateFontString(nil, "OVERLAY")
LarthUF.Special.Text:SetPoint("CENTER")
LarthUF.Special.Text:SetFont(LarthUF.font, 20, "OUTLINE")
LarthUF.Special.Text:SetTextColor(1, 1, 1)
