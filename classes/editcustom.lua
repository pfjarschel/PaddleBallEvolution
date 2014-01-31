---------------------------------------------
-- Class for the Level Up Screen (Tournament)
---------------------------------------------

EditCustomClass = Core.class(Sprite)

-- Declarations --
EditCustomClass.font = nil

-- Handles Keys --
local function onKeyDown(event)
	if event.keyCode == 301 then
		if optionsTable["SFX"] == "On" then sounds.sel2:play() end
		
		customClass["Atk"] = 10 + addAtk
		customClass["Mov"] = 10 + addMov
		customClass["Lif"] = 10 + addLif
		customClass["Skl"] = 10 + addSkl
		customClass["Def"] = 10 + addDef
		
		local skillName = skillTable[customClass["skill"]]["Name"]
		local skillDesc = skillTable[customClass["skill"]]["Desc"]
		customClass["skillName"] = skillName
		customClass["skillDesc"] = skillDesc
		
		classTable["Custom"] = {
			tonumber(customClass["Atk"]),
			tonumber(customClass["Mov"]),
			tonumber(customClass["Lif"]),
			tonumber(customClass["Int"]),
			tonumber(customClass["Skl"]),
			tonumber(customClass["Def"]),
			customClass["skill"],
			customClass["skillName"],
			customClass["skillDesc"],
			{tonumber(customClass["ColorR"])/10, tonumber(customClass["ColorG"])/10, tonumber(customClass["ColorB"])/10},
			customClass["Name"]
		}
		
		local createFile = io.open("|D|customclass.txt", "w+")
		for k, v in pairs(customClass) do 
			createFile:write(k.."="..v.."\n")
		end
		createFile:close()
		
		sceneMan:changeScene(self.menuplace, transTime, SceneManager.fade, easing.linear) 
	end
end

-- Initialization --
function EditCustomClass:init(menuplace)
	self.menuplace = menuplace
	self.smallfont = fonts.anitaSmall
	self.xsmallfont = fonts.anitaVerySmall
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
	
	-- Skill Selection --
	local skillNames = {}
	local skillFullNames = {}
	local skillDescs = {}
	local skill = customClass["skill"]
	local skillName = ""
	local skillDesc = ""
	local i = 1
	local j = 1
	for k, v in pairs(skillTable) do
		skillNames[i] = k
		skillFullNames[i] = v["Name"]
		skillDescs[i] = v["Desc"]
		if k == skill then
			j = i
			skillName = v["Name"]
			skillDesc = v["Desc"]
		end
		i = i + 1
	end

	local skillTextBox = TextField.new(self.smallfont, "Skill: "..skillName)
	skillTextBox:setTextColor(0xffffff)
	skillTextBox:setPosition(0.5*WX0 - skillTextBox:getWidth()/2, 30)
	self:addChild(skillTextBox)
	
	local skillDTextBox = TextField.new(self.xsmallfont, skillDesc)
	skillDTextBox:setTextColor(0xffffff)
	skillDTextBox:setPosition(0.5*WX0 - skillDTextBox:getWidth()/2, 50)
	self:addChild(skillDTextBox)
	
	self.prevBut = MenuBut.new(30, 30, textures.backBut, textures.backBut1)
	self:addChild(self.prevBut)
	self.prevBut.bitmap:setPosition(0.5*WX0 - 256, 30)
	self.prevBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.prevBut:hitTestPoint(event.touch.x, event.touch.y) then
			j = j - 1
			if j < 1 then j = tablelength(skillNames) end
			
			self:removeChild(skillTextBox)
			self:removeChild(skillDTextBox)
			
			skill = skillNames[j]
			if skill == "none" then
				j = j - 1
				if j < 1 then j = tablelength(skillNames) end
			end
			
			skill = skillNames[j]
			skillName = skillFullNames[j]
			skillDesc = skillDescs[j]
			
			skillTextBox = TextField.new(self.smallfont, "Skill: "..skillName)
			skillTextBox:setTextColor(0xffffff)
			skillTextBox:setPosition(0.5*WX0 - skillTextBox:getWidth()/2, 30)
			self:addChild(skillTextBox)
			
			skillDTextBox = TextField.new(self.xsmallfont, skillDesc)
			skillDTextBox:setTextColor(0xffffff)
			skillDTextBox:setPosition(0.5*WX0 - skillDTextBox:getWidth()/2, 50)
			self:addChild(skillDTextBox)
			
			customClass["skill"] = skill
			customClass["skillName"] = skillName
			customClass["skillDesc"] = skillDesc
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	self.nextBut = MenuBut.new(30, 30, textures.forwardBut, textures.forwardBut1)
	self:addChild(self.nextBut)
	self.nextBut.bitmap:setPosition(0.5*WX0 + 256, 30)
	self.nextBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.nextBut:hitTestPoint(event.touch.x, event.touch.y) then
			j = j + 1
			if j > tablelength(skillNames) then j = 1 end
			
			self:removeChild(skillTextBox)
			self:removeChild(skillDTextBox)
			
			skill = skillNames[j]
			if skill == "none" then
				j = j + 1
				if j > tablelength(skillNames) then j = 1 end
			end
			
			skill = skillNames[j]
			skillName = skillFullNames[j]
			skillDesc = skillDescs[j]
			
			skillTextBox = TextField.new(self.smallfont, "Skill: "..skillName)
			skillTextBox:setTextColor(0xffffff)
			skillTextBox:setPosition(0.5*WX0 - skillTextBox:getWidth()/2, 30)
			self:addChild(skillTextBox)
			
			skillDTextBox = TextField.new(self.xsmallfont, skillDesc)
			skillDTextBox:setTextColor(0xffffff)
			skillDTextBox:setPosition(0.5*WX0 - skillDTextBox:getWidth()/2, 50)
			self:addChild(skillDTextBox)
			
			customClass["skill"] = skill
			customClass["skillName"] = skillName
			customClass["skillDesc"] = skillDesc
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	

	-- Attributes Improvement --
	local addAtk = customClass["Atk"] - 10
	local addMov = customClass["Mov"] - 10
	local addLif = customClass["Lif"] - 10
	local addSkl = customClass["Skl"] - 10
	local addDef = customClass["Def"] - 10
	local baseAtk = 10
	local baseMov = 10
	local baseLif = 10
	local baseSkl = 10
	local baseDef = 10
	local points = 10 - addAtk - addMov - addLif - addSkl - addDef
	
	local pointsTextBox = TextField.new(self.smallfont, "Available Attribute Points: "..points)
	pointsTextBox:setTextColor(0xffffff)
	pointsTextBox:setPosition(0.5*WX0 - pointsTextBox:getWidth()/2, 96)
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
	self:addChild(self.decAtk)
	self.decAtk.bitmap:setPosition(3*WX0/4, 131)
	self.decAtk:addEventListener(Event.TOUCHES_END, function(event)
		if self.decAtk:hitTestPoint(event.touch.x, event.touch.y) then
			if -9 < addAtk then
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
				if -9 == addAtk then
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
				
				if addAtk >= -9 then
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
	self:addChild(self.decMov)
	self.decMov.bitmap:setPosition(3*WX0/4, 131 + 1*56*resFix)
	self.decMov:addEventListener(Event.TOUCHES_END, function(event)
		if self.decMov:hitTestPoint(event.touch.x, event.touch.y) then
			if -9 < addMov then
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
				if -9 == addMov then
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
				
				if addMov >= -9 then
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
	self:addChild(self.decLif)
	self.decLif.bitmap:setPosition(3*WX0/4, 131 + 2*56*resFix)
	self.decLif:addEventListener(Event.TOUCHES_END, function(event)
		if self.decLif:hitTestPoint(event.touch.x, event.touch.y) then
			if -9 < addLif then
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
				if -9 == addLif then
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
				
				if addLif >= -9 then
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
	self:addChild(self.decSkl)
	self.decSkl.bitmap:setPosition(3*WX0/4, 131 + 3*56*resFix)
	self.decSkl:addEventListener(Event.TOUCHES_END, function(event)
		if self.decSkl:hitTestPoint(event.touch.x, event.touch.y) then
			if -9 < addSkl then
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
				if -9 == addSkl then
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
				
				if addSkl >= -9 then
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
	self:addChild(self.decDef)
	self.decDef.bitmap:setPosition(3*WX0/4, 131 + 4*56*resFix)
	self.decDef:addEventListener(Event.TOUCHES_END, function(event)
		if self.decDef:hitTestPoint(event.touch.x, event.touch.y) then
			if -9 < addDef then
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
				if -9 == addDef then
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
				
				if addDef >= -9 then
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
	
	-- Color Pick! --
	local samplePaddle = Bitmap.new(textures.paddle2)
	samplePaddle:setScale(1, 1)
	self:addChild(samplePaddle)
	local textureWp = samplePaddle:getWidth()
	local textureHp = samplePaddle:getHeight()
	samplePaddle:setAnchorPoint(0.5, 0.5)
	samplePaddle:setScale(15/textureWp,75/textureHp)
	samplePaddle:setRotation(-90)
	samplePaddle:setPosition(WX0 - 128, WY - 56)
	
	local slideColorPicker = SlideColorPicker.new()
	local function onColorChanged(e)
		samplePaddle:setColorTransform(e.r/255, e.g/255, e.b/255)
		customClass["ColorR"] = e.r/25.5
		customClass["ColorG"] = e.g/25.5
		customClass["ColorB"] = e.b/25.5
	end
	slideColorPicker:addEventListener("COLOR_CHANGED", onColorChanged)
	self:addChild(slideColorPicker)
	slideColorPicker:setScale(0.75, 0.5)
	slideColorPicker:setPosition(WX/2 - slideColorPicker:getWidth()/2, WY - slideColorPicker:getHeight() - 32)
	Timer.delayedCall(100, function()
		samplePaddle:setColorTransform(classTable["Custom"][10][1], classTable["Custom"][10][2], classTable["Custom"][10][3])
	end)
	
	self.returnBut = MenuBut.new(150, 40, textures.returnBut, textures.returnBut1)
	self:addChild(self.returnBut)
	self.returnBut.bitmap:setPosition(self.returnBut:getWidth()/2 + 16, WY0/2 + 210)
	self.returnBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.returnBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			
			customClass["Atk"] = 10 + addAtk
			customClass["Mov"] = 10 + addMov
			customClass["Lif"] = 10 + addLif
			customClass["Skl"] = 10 + addSkl
			customClass["Def"] = 10 + addDef
			
			local skillName = skillTable[customClass["skill"]]["Name"]
			local skillDesc = skillTable[customClass["skill"]]["Desc"]
			customClass["skillName"] = skillName
			customClass["skillDesc"] = skillDesc
			
			classTable["Custom"] = {
				tonumber(customClass["Atk"]),
				tonumber(customClass["Mov"]),
				tonumber(customClass["Lif"]),
				tonumber(customClass["Int"]),
				tonumber(customClass["Skl"]),
				tonumber(customClass["Def"]),
				customClass["skill"],
				customClass["skillName"],
				customClass["skillDesc"],
				{tonumber(customClass["ColorR"])/10, tonumber(customClass["ColorG"])/10, tonumber(customClass["ColorB"])/10},
				customClass["Name"]
			}
			
			local createFile = io.open("|D|customclass.txt", "w+")
			for k, v in pairs(customClass) do 
				createFile:write(k.."="..v.."\n")
			end
			createFile:close()
			
			sceneMan:changeScene(self.menuplace, transTime, SceneManager.fade, easing.linear) 
		end
	end)
	
	-- Listen to Keys --
	self:addEventListener(Event.KEY_DOWN, onKeyDown)
end