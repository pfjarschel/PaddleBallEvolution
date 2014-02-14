---------------------------------------------
-- Class for the Level Up Screen (Tournament)
---------------------------------------------

TourLevelUp = Core.class(Sprite)

-- Declarations --
TourLevelUp.font = nil

-- Handles Keys --
local function onKeyDown(event)
	if event.keyCode == 301 then
		if optionsTable["SFX"] == "On" then sounds.sel3:play() end
		
		tourTable["QuickTourAtk"] = addAtk
		tourTable["QuickTourMov"] = addMov
		tourTable["QuickTourLif"] = addLif
		tourTable["QuickTourSkl"] = addSkl
		tourTable["QuickTourDef"] = addDef
		tourTable["QuickTourPoints"] = points
		local tourFile = io.open("|D|quicktour.txt", "w+")
		for k, v in pairs(tourTable) do 
			tourFile:write(k.."="..v.."\n")
		end	
		
		sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
	end
end

-- Initialization --
function TourLevelUp:init()
	self.smallfont = fonts.anitaSmall
	self.medfont = fonts.anitaMed
	
	local devW = application:getDeviceWidth()
	local devH = application:getDeviceHeight()
	local resFix = 1
	if devH < 500 and devH/devW > 1.2 and devH/devW < 1.4 then resFix = 1.05 end
	if devH < 500 and devH/devW > 1.4 and devH/devW < 1.6 then resFix = 1.025 end
	if devH > 500 and devH/devW > 1.4 and devH/devW < 1.6 then resFix = 1.0125 end
	if devH < 500 and devH/devW > 1.2 and devH/devW < 1.4 then resFix = 1.025 end
	
	local menubg = Bitmap.new(textures.bluesmoke)
	menubg:setScale(1, 1)
	local textureW = menubg:getWidth()
	local textureH = menubg:getHeight()
	menubg:setScale(WX/textureW, WY/textureH)
	--menubg:setAlpha(0.25)
	self:addChild(menubg)
	
	local ia = 1
	local arenaNames = {}
	for k, v in pairs(arenasTable) do
		arenaNames[ia] = k
		ia = ia + 1
	end
	local arenatype = arenaNames[math.random(1, tablelength(arenaNames))]
	tourTable["QuickTourArena"] = arenatype
	
	local classNames = {}
	local i = 1
	for k, v in pairs(classTable) do
		if classTable[k][12] ~=1 then
			classNames[i] = k
			i = i + 1
		end
	end
	local classok = false
	local nextclass = nil
	while not(classok) do
		classok = true
		nextclass = classNames[math.random(1, tablelength(classNames))]
		for i = 1, tourTable["QuickTourStage"] - 1, 1 do
			if nextclass == tourTable["QuickTourStage"..tostring(i)] then
				classok = false
			end
		end
	end
	tourTable["QuickTourOpponent"] = nextclass

	-- Attributes Improvement --
	local points = tourTable["QuickTourPoints"]
	local addAtk = tourTable["QuickTourAtk"]
	local addMov = tourTable["QuickTourMov"]
	local addLif = tourTable["QuickTourLif"]
	local addSkl = tourTable["QuickTourSkl"]
	local addDef = tourTable["QuickTourDef"]
	local baseAtk = classTable[tourTable["QuickTourClass"]][1]
	local baseMov = classTable[tourTable["QuickTourClass"]][2]
	local baseLif = classTable[tourTable["QuickTourClass"]][3]
	local baseSkl = classTable[tourTable["QuickTourClass"]][5]
	local baseDef = classTable[tourTable["QuickTourClass"]][6]
	
	local pointsTextBox = TextField.new(self.medfont, "Available Attribute Points: "..points)
	pointsTextBox:setTextColor(0xffffff)
	pointsTextBox:setPosition(0.5*WX0 - pointsTextBox:getWidth()/2, 48)
	self:addChild(pointsTextBox)
	
	local attrString = "Atk: (Affects ball return speed): \n"..
						"Mov: (Affects your paddle speed): \n"..
						"Life: (Your total Life points): \n"..
						"Skl: (Your total Skill points): \n"..
						"Def: (Affects your paddle size): \n"
	local attrTextBox = TextWrap.new(attrString, WX0, "left", 32, self.smallfont)
	attrTextBox:setTextColor(0xffffff)
	attrTextBox:setPosition(32, 140)
	self:addChild(attrTextBox)
	
	local attrvalString = tostring((baseAtk + addAtk)).."\n"..
						tostring((baseMov + addMov)).."\n"..
						tostring((baseLif + addLif)).."\n"..
						tostring((baseSkl + addSkl)).."\n"..
						tostring((baseDef + addDef)).."\n"
	local attrvalTextBox = TextWrap.new(attrvalString, 64, "center", 37, self.smallfont)
	attrvalTextBox:setTextColor(0xffffff)
	attrvalTextBox:setPosition(WX0 - 96 - attrvalTextBox:getWidth(), 140)
	self:addChild(attrvalTextBox)
	
	self.decAtk = MenuBut.new(30, 30, textures.minusBut, textures.minusBut1)
	--self:addChild(self.decAtk)
	self.decAtk.bitmap:setPosition(3*WX0/4, 131)
	self.decAtk:addEventListener(Event.TOUCHES_END, function(event)
		if self.decAtk:hitTestPoint(event.touch.x, event.touch.y) then
			if tonumber(tourTable["QuickTourAtk"]) < addAtk then
				addAtk = addAtk - 1
				points = points + 1
				
				self:removeChild(attrTextBox)
				local attrvalString = tostring((baseAtk + addAtk)).."\n"..
						tostring((baseMov + addMov)).."\n"..
						tostring((baseLif + addLif)).."\n"..
						tostring((baseSkl + addSkl)).."\n"..
						tostring((baseDef + addDef)).."\n"
				attrvalTextBox:setText(attrvalString)
				self:addChild(attrTextBox)
				
				self:removeChild(pointsTextBox)
				pointsTextBox:setText("Available Attribute Points: "..points)
				self:addChild(pointsTextBox)
				
				if points > 0 then
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incAtk then
							self:removeChild(self.incAtk)
						end
					end
					self:addChild(self.incAtk)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incMov then
							self:removeChild(self.incMov)
						end
					end
					self:addChild(self.incMov)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incLif then
							self:removeChild(self.incLif)
						end
					end
					self:addChild(self.incLif)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incSkl then
							self:removeChild(self.incSkl)
						end
					end
					self:addChild(self.incSkl)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incDef then
							self:removeChild(self.incDef)
						end
					end
					self:addChild(self.incDef)
				end
				if tonumber(tourTable["QuickTourAtk"]) == addAtk then
					self:removeChild(self.decAtk)
				end
			end
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	self.incAtk = MenuBut.new(30, 30, textures.plusBut, textures.plusBut1)
	self:addChild(self.incAtk)
	self.incAtk.bitmap:setPosition(WX0 - 64, 131)
	self.incAtk:addEventListener(Event.TOUCHES_END, function(event)
		if self.incAtk:hitTestPoint(event.touch.x, event.touch.y) then
			if points > 0 then
				addAtk = addAtk + 1
				points = points - 1
				
				self:removeChild(attrTextBox)
				local attrvalString = tostring((baseAtk + addAtk)).."\n"..
						tostring((baseMov + addMov)).."\n"..
						tostring((baseLif + addLif)).."\n"..
						tostring((baseSkl + addSkl)).."\n"..
						tostring((baseDef + addDef)).."\n"
				attrvalTextBox:setText(attrvalString)
				self:addChild(attrTextBox)
				
				self:removeChild(pointsTextBox)
				pointsTextBox:setText("Available Attribute Points: "..points)
				self:addChild(pointsTextBox)
				
				if addAtk > tonumber(tourTable["QuickTourAtk"]) then
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.decAtk then
							self:removeChild(self.decAtk)
						end
					end
					self:addChild(self.decAtk)
				end
				if points == 0 then
					self:removeChild(self.incAtk)
					self:removeChild(self.incMov)
					self:removeChild(self.incLif)
					self:removeChild(self.incSkl)
					self:removeChild(self.incDef)
				end
			end
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	self.decMov = MenuBut.new(30, 30, textures.minusBut, textures.minusBut1)
	--self:addChild(self.decMov)
	self.decMov.bitmap:setPosition(3*WX0/4, 131 + 1*56*resFix)
	self.decMov:addEventListener(Event.TOUCHES_END, function(event)
		if self.decMov:hitTestPoint(event.touch.x, event.touch.y) then
			if tonumber(tourTable["QuickTourMov"]) < addMov then
				addMov = addMov - 1
				points = points + 1
				
				self:removeChild(attrTextBox)
				local attrvalString = tostring((baseAtk + addAtk)).."\n"..
						tostring((baseMov + addMov)).."\n"..
						tostring((baseLif + addLif)).."\n"..
						tostring((baseSkl + addSkl)).."\n"..
						tostring((baseDef + addDef)).."\n"
				attrvalTextBox:setText(attrvalString)
				self:addChild(attrTextBox)
				
				self:removeChild(pointsTextBox)
				pointsTextBox:setText("Available Attribute Points: "..points)
				self:addChild(pointsTextBox)
				
				if points > 0 then
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incAtk then
							self:removeChild(self.incAtk)
						end
					end
					self:addChild(self.incAtk)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incMov then
							self:removeChild(self.incMov)
						end
					end
					self:addChild(self.incMov)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incLif then
							self:removeChild(self.incLif)
						end
					end
					self:addChild(self.incLif)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incSkl then
							self:removeChild(self.incSkl)
						end
					end
					self:addChild(self.incSkl)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incDef then
							self:removeChild(self.incDef)
						end
					end
					self:addChild(self.incDef)
				end
				if tonumber(tourTable["QuickTourMov"]) == addMov then
					self:removeChild(self.decMov)
				end
			end
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)	
	self.incMov = MenuBut.new(30, 30, textures.plusBut, textures.plusBut1)
	self:addChild(self.incMov)
	self.incMov.bitmap:setPosition(WX0 - 64, 131 + 1*56*resFix)
	self.incMov:addEventListener(Event.TOUCHES_END, function(event)
		if self.incMov:hitTestPoint(event.touch.x, event.touch.y) then
			if points > 0 then
				addMov = addMov + 1
				points = points - 1
				
				self:removeChild(attrTextBox)
				local attrvalString = tostring((baseAtk + addAtk)).."\n"..
						tostring((baseMov + addMov)).."\n"..
						tostring((baseLif + addLif)).."\n"..
						tostring((baseSkl + addSkl)).."\n"..
						tostring((baseDef + addDef)).."\n"
				attrvalTextBox:setText(attrvalString)
				self:addChild(attrTextBox)
				
				self:removeChild(pointsTextBox)
				pointsTextBox:setText("Available Attribute Points: "..points)
				self:addChild(pointsTextBox)
				
				if addMov > tonumber(tourTable["QuickTourMov"]) then
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.decMov then
							self:removeChild(self.decMov)
						end
					end
					self:addChild(self.decMov)
				end
				if points == 0 then
					self:removeChild(self.incAtk)
					self:removeChild(self.incMov)
					self:removeChild(self.incLif)
					self:removeChild(self.incSkl)
					self:removeChild(self.incDef)
				end
			end
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	self.decLif = MenuBut.new(30, 30, textures.minusBut, textures.minusBut1)
	--self:addChild(self.decLif)
	self.decLif.bitmap:setPosition(3*WX0/4, 131 + 2*56*resFix)
	self.decLif:addEventListener(Event.TOUCHES_END, function(event)
		if self.decLif:hitTestPoint(event.touch.x, event.touch.y) then
			if tonumber(tourTable["QuickTourLif"]) < addLif then
				addLif = addLif - 1
				points = points + 1
				
				self:removeChild(attrTextBox)
				local attrvalString = tostring((baseAtk + addAtk)).."\n"..
						tostring((baseMov + addMov)).."\n"..
						tostring((baseLif + addLif)).."\n"..
						tostring((baseSkl + addSkl)).."\n"..
						tostring((baseDef + addDef)).."\n"
				attrvalTextBox:setText(attrvalString)
				self:addChild(attrTextBox)
				
				self:removeChild(pointsTextBox)
				pointsTextBox:setText("Available Attribute Points: "..points)
				self:addChild(pointsTextBox)
				
				if points > 0 then
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incAtk then
							self:removeChild(self.incAtk)
						end
					end
					self:addChild(self.incAtk)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incMov then
							self:removeChild(self.incMov)
						end
					end
					self:addChild(self.incMov)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incLif then
							self:removeChild(self.incLif)
						end
					end
					self:addChild(self.incLif)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incSkl then
							self:removeChild(self.incSkl)
						end
					end
					self:addChild(self.incSkl)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incDef then
							self:removeChild(self.incDef)
						end
					end
					self:addChild(self.incDef)
				end
				if tonumber(tourTable["QuickTourLif"]) == addLif then
					self:removeChild(self.decLif)
				end
			end
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)	
	self.incLif = MenuBut.new(30, 30, textures.plusBut, textures.plusBut1)
	self:addChild(self.incLif)
	self.incLif.bitmap:setPosition(WX0 - 64, 131 + 2*56*resFix)
	self.incLif:addEventListener(Event.TOUCHES_END, function(event)
		if self.incLif:hitTestPoint(event.touch.x, event.touch.y) then
			if points > 0 then
				addLif = addLif + 1
				points = points - 1
				
				self:removeChild(attrTextBox)
				local attrvalString = tostring((baseAtk + addAtk)).."\n"..
						tostring((baseMov + addMov)).."\n"..
						tostring((baseLif + addLif)).."\n"..
						tostring((baseSkl + addSkl)).."\n"..
						tostring((baseDef + addDef)).."\n"
				attrvalTextBox:setText(attrvalString)
				self:addChild(attrTextBox)
				
				self:removeChild(pointsTextBox)
				pointsTextBox:setText("Available Attribute Points: "..points)
				self:addChild(pointsTextBox)
				
				if addLif > tonumber(tourTable["QuickTourLif"]) then
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.decLif then
							self:removeChild(self.decLif)
						end
					end
					self:addChild(self.decLif)
				end
				if points == 0 then
					self:removeChild(self.incAtk)
					self:removeChild(self.incMov)
					self:removeChild(self.incLif)
					self:removeChild(self.incSkl)
					self:removeChild(self.incDef)
				end
			end
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	self.decSkl = MenuBut.new(30, 30, textures.minusBut, textures.minusBut1)
	--self:addChild(self.decSkl)
	self.decSkl.bitmap:setPosition(3*WX0/4, 131 + 3*56*resFix)
	self.decSkl:addEventListener(Event.TOUCHES_END, function(event)
		if self.decSkl:hitTestPoint(event.touch.x, event.touch.y) then
			if tonumber(tourTable["QuickTourSkl"]) < addSkl then
				addSkl = addSkl - 1
				points = points + 1
				
				self:removeChild(attrTextBox)
				local attrvalString = tostring((baseAtk + addAtk)).."\n"..
						tostring((baseMov + addMov)).."\n"..
						tostring((baseLif + addLif)).."\n"..
						tostring((baseSkl + addSkl)).."\n"..
						tostring((baseDef + addDef)).."\n"
				attrvalTextBox:setText(attrvalString)
				self:addChild(attrTextBox)
				
				self:removeChild(pointsTextBox)
				pointsTextBox:setText("Available Attribute Points: "..points)
				self:addChild(pointsTextBox)
				
				if points > 0 then
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incAtk then
							self:removeChild(self.incAtk)
						end
					end
					self:addChild(self.incAtk)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incMov then
							self:removeChild(self.incMov)
						end
					end
					self:addChild(self.incMov)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incLif then
							self:removeChild(self.incLif)
						end
					end
					self:addChild(self.incLif)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incSkl then
							self:removeChild(self.incSkl)
						end
					end
					self:addChild(self.incSkl)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incDef then
							self:removeChild(self.incDef)
						end
					end
					self:addChild(self.incDef)
				end
				if tonumber(tourTable["QuickTourSkl"]) == addSkl then
					self:removeChild(self.decSkl)
				end
			end
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)	
	self.incSkl = MenuBut.new(30, 30, textures.plusBut, textures.plusBut1)
	self:addChild(self.incSkl)
	self.incSkl.bitmap:setPosition(WX0 - 64, 131 + 3*56*resFix)
	self.incSkl:addEventListener(Event.TOUCHES_END, function(event)
		if self.incSkl:hitTestPoint(event.touch.x, event.touch.y) then
			if points > 0 then
				addSkl = addSkl + 1
				points = points - 1
				
				self:removeChild(attrTextBox)
				local attrvalString = tostring((baseAtk + addAtk)).."\n"..
						tostring((baseMov + addMov)).."\n"..
						tostring((baseLif + addLif)).."\n"..
						tostring((baseSkl + addSkl)).."\n"..
						tostring((baseDef + addDef)).."\n"
				attrvalTextBox:setText(attrvalString)
				self:addChild(attrTextBox)
				
				self:removeChild(pointsTextBox)
				pointsTextBox:setText("Available Attribute Points: "..points)
				self:addChild(pointsTextBox)
				
				if addSkl > tonumber(tourTable["QuickTourSkl"]) then
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.decSkl then
							self:removeChild(self.decSkl)
						end
					end
					self:addChild(self.decSkl)
				end
				if points == 0 then
					self:removeChild(self.incAtk)
					self:removeChild(self.incMov)
					self:removeChild(self.incLif)
					self:removeChild(self.incSkl)
					self:removeChild(self.incDef)
				end
			end
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	self.decDef = MenuBut.new(30, 30, textures.minusBut, textures.minusBut1)
	--self:addChild(self.decDef)
	self.decDef.bitmap:setPosition(3*WX0/4, 131 + 4*56*resFix)
	self.decDef:addEventListener(Event.TOUCHES_END, function(event)
		if self.decDef:hitTestPoint(event.touch.x, event.touch.y) then
			if tonumber(tourTable["QuickTourDef"]) < addDef then
				addDef = addDef - 1
				points = points + 1
				
				self:removeChild(attrTextBox)
				local attrvalString = tostring((baseAtk + addAtk)).."\n"..
						tostring((baseMov + addMov)).."\n"..
						tostring((baseLif + addLif)).."\n"..
						tostring((baseSkl + addSkl)).."\n"..
						tostring((baseDef + addDef)).."\n"
				attrvalTextBox:setText(attrvalString)
				self:addChild(attrTextBox)
				
				self:removeChild(pointsTextBox)
				pointsTextBox:setText("Available Attribute Points: "..points)
				self:addChild(pointsTextBox)
				
				if points > 0 then
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incAtk then
							self:removeChild(self.incAtk)
						end
					end
					self:addChild(self.incAtk)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incMov then
							self:removeChild(self.incMov)
						end
					end
					self:addChild(self.incMov)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incLif then
							self:removeChild(self.incLif)
						end
					end
					self:addChild(self.incLif)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incSkl then
							self:removeChild(self.incSkl)
						end
					end
					self:addChild(self.incSkl)
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.incDef then
							self:removeChild(self.incDef)
						end
					end
					self:addChild(self.incDef)
				end
				if tonumber(tourTable["QuickTourDef"]) == addDef then
					self:removeChild(self.decDef)
				end
			end
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)	
	self.incDef = MenuBut.new(30, 30, textures.plusBut, textures.plusBut1)
	self:addChild(self.incDef)
	self.incDef.bitmap:setPosition(WX0 - 64, 131 + 4*56*resFix)
	self.incDef:addEventListener(Event.TOUCHES_END, function(event)
		if self.incDef:hitTestPoint(event.touch.x, event.touch.y) then
			if points > 0 then
				addDef = addDef + 1
				points = points - 1
				
				self:removeChild(attrTextBox)
				local attrvalString = tostring((baseAtk + addAtk)).."\n"..
						tostring((baseMov + addMov)).."\n"..
						tostring((baseLif + addLif)).."\n"..
						tostring((baseSkl + addSkl)).."\n"..
						tostring((baseDef + addDef)).."\n"
				attrvalTextBox:setText(attrvalString)
				self:addChild(attrTextBox)
				
				self:removeChild(pointsTextBox)
				pointsTextBox:setText("Available Attribute Points: "..points)
				self:addChild(pointsTextBox)
				
				if addDef > tonumber(tourTable["QuickTourDef"]) then
					for i = self:getNumChildren(), 1, -1 do
						if self:getChildAt(i) == self.decDef then
							self:removeChild(self.decDef)
						end
					end
					self:addChild(self.decDef)
				end
				if points == 0 then
					self:removeChild(self.incAtk)
					self:removeChild(self.incMov)
					self:removeChild(self.incLif)
					self:removeChild(self.incSkl)
					self:removeChild(self.incDef)
				end
			end
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	self.nextBut = MenuBut.new(192, 40, textures.nextBut, textures.nextBut1)
	self:addChild(self.nextBut)
	self.nextBut.bitmap:setPosition(WX0 - 16 - self.nextBut:getWidth()/2, WY0/2 + 210)
	self.nextBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.nextBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			
			tourTable["QuickTourAtk"] = addAtk
			tourTable["QuickTourMov"] = addMov
			tourTable["QuickTourLif"] = addLif
			tourTable["QuickTourSkl"] = addSkl
			tourTable["QuickTourDef"] = addDef
			tourTable["QuickTourPoints"] = points
			local tourFile = io.open("|D|quicktour.txt", "w+")
			for k, v in pairs(tourTable) do 
				tourFile:write(k.."="..v.."\n")
			end	
			tourFile:close()
							
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			
			sceneMan:changeScene("arenaTour", transTime, SceneManager.fade, easing.linear, { userData = {tourTable["QuickTourDif"], tourTable["QuickTourClass"], tourTable["QuickTourOpponent"], tourTable["QuickTourStage"], arenatype} })
		end
	end)
	
	self.returnBut = MenuBut.new(192, 40, textures.returnBut, textures.returnBut1)
	self:addChild(self.returnBut)
	self.returnBut.bitmap:setPosition(self.returnBut:getWidth()/2 + 16, WY0/2 + 210)
	self.returnBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.returnBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel3:play() end
			
			tourTable["QuickTourAtk"] = addAtk
			tourTable["QuickTourMov"] = addMov
			tourTable["QuickTourLif"] = addLif
			tourTable["QuickTourSkl"] = addSkl
			tourTable["QuickTourDef"] = addDef
			tourTable["QuickTourPoints"] = points
			local tourFile = io.open("|D|quicktour.txt", "w+")
			for k, v in pairs(tourTable) do 
				tourFile:write(k.."="..v.."\n")
			end	
			tourFile:close()
			
			sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
		end
	end)
	
	-- Listen to Keys --
	self:addEventListener(Event.KEY_DOWN, onKeyDown)
end