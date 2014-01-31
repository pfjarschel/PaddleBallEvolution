------------------------------------------
-- Class for the Main Menu - Arena Mode --
------------------------------------------

MainMenu_Arena = Core.class(Sprite)

-- Declarations --
MainMenu_Arena.font = nil

-- Handles Keys --
local function onKeyDown(event)
	if event.keyCode == 301 then
		if optionsTable["SFX"] == "On" then sounds.sel3:play() end
		
		local optionsFile = io.open("|D|options.txt", "w+")
		for k, v in pairs(optionsTable) do 
			optionsFile:write(k.."="..v.."\n")
		end	
		
		sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
	end
end

-- Initialization --
function MainMenu_Arena:init()
	self.font = fonts.anitaSmall
	self.smallfont = fonts.anitaVerySmall
	
	local menubg = Bitmap.new(textures.mainmenubg)
	menubg:setScale(1, 1)
	self:addChild(menubg)
	local textureW = menubg:getWidth()
	local textureH = menubg:getHeight()
	menubg:setScale(WX/textureW, WY/textureH)
	
	-- Difficulty Selection --
	local difTextBox = TextField.new(self.font, "Difficulty:")
	difTextBox:setTextColor(0xffffff)
	difTextBox:setPosition(0.5*WX - difTextBox:getWidth()/2, 0.5*WY + 90)
	self:addChild(difTextBox)
	
	local difficulty = optionsTable["Difficulty"]
	local numTextBox = TextField.new(self.font, tostring(difficulty))
	numTextBox:setTextColor(0xffffff)
	numTextBox:setPosition(0.5*WX - numTextBox:getWidth()/2, 0.5*WY + 140)
	self:addChild(numTextBox)
	
	self.decDif = MenuBut.new(40, 40, textures.minusBut, textures.minusBut1)
	self:addChild(self.decDif)
	self.decDif.bitmap:setPosition(WX/2 - 60, WY/2 + 130)
	self.decDif:addEventListener(Event.TOUCHES_END, function(event)
		if self.decDif:hitTestPoint(event.touch.x, event.touch.y) then
			difficulty = difficulty - 1
			if difficulty < 1 then difficulty = 1 end
			optionsTable["Difficulty"] = difficulty
			self:removeChild(numTextBox)
			numTextBox = TextField.new(self.font, tostring(difficulty))
			numTextBox:setTextColor(0xffffff)
			numTextBox:setPosition(0.5*WX - numTextBox:getWidth()/2, 0.5*WY + 140)
			self:addChild(numTextBox)
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	self.incDif = MenuBut.new(40, 40, textures.plusBut, textures.plusBut1)
	self:addChild(self.incDif)
	self.incDif.bitmap:setPosition(WX/2 + 60, WY/2 + 130)
	self.incDif:addEventListener(Event.TOUCHES_END, function(event)
		if self.incDif:hitTestPoint(event.touch.x, event.touch.y) then
			difficulty = difficulty + 1
			if difficulty > 10 then difficulty = 10 end
			optionsTable["Difficulty"] = difficulty
			self:removeChild(numTextBox)
			numTextBox = TextField.new(self.font, tostring(difficulty))
			numTextBox:setTextColor(0xffffff)
			numTextBox:setPosition(0.5*WX - numTextBox:getWidth()/2, 0.5*WY + 140)
			self:addChild(numTextBox)
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	-- Creates class names table --
	local classNames = {}
	local classSkill = {}
	local classSkillDesc = {}
	local classAtk = {}
	local classMov = {}
	local classLif = {}
	local classSkl = {}
	local classDef = {}
	
	local i = 1
	for k, v in pairs(classTable) do
		classNames[i] = k
		classSkill[i] = classTable[classNames[i]][8]
		classSkillDesc[i] = classTable[classNames[i]][9]
		classAtk[i] = classTable[classNames[i]][1]
		classMov[i] = classTable[classNames[i]][2]
		classLif[i] = classTable[classNames[i]][3]
		classSkl[i] = classTable[classNames[i]][5]
		classDef[i] = classTable[classNames[i]][6]
		i = i + 1
	end
	classNames[i] = "Random"
	classSkill[i] = "Random"
	classSkillDesc[i] = "Random effect!"
	classAtk[i] = "?"
	classMov[i] = "?"
	classLif[i] = "?"
	classSkl[i] = "?"
	classDef[i] = "?"
	
	-- Class Selection --
	local classTextBox = nil
	if optionsTable["ArenaSide"] == "Left" then
		classTextBox = TextField.new(self.font, "Class:")
	else
		classTextBox = TextField.new(self.font, "Enemy Class:")
	end
	classTextBox:setTextColor(0xffffff)
	classTextBox:setPosition(192 - classTextBox:getWidth()/2, 0.5*WY - 30)
	self:addChild(classTextBox)
	
	local class = classNames[classIndexL]
	
	local selClassTextBox = TextField.new(self.font, class)
	selClassTextBox:setTextColor(0xffffff)
	selClassTextBox:setPosition(192 - selClassTextBox:getWidth()/2, 0.5*WY + 10)
	self:addChild(selClassTextBox)
	
	local selSkillTextBox = TextWrap.new(classSkill[classIndexL]..": "..classSkillDesc[classIndexL], 300, "center", 7, self.smallfont)
	selSkillTextBox:setTextColor(0xffffff)
	selSkillTextBox:setPosition(192 - selSkillTextBox:getWidth()/2, 0.5*WY + 50)
	self:addChild(selSkillTextBox)
	
	local stats = "Atk: "..classAtk[classIndexL].."\n"..
					"Mov: "..classMov[classIndexL].."\n"..
					"Lif: "..classLif[classIndexL].."\n"..
					"Skl: "..classSkl[classIndexL].."\n"..
					"Def: "..classDef[classIndexL].."\n"
	local statsTextBox = TextWrap.new(stats, 80, "center", 7, self.smallfont)
	statsTextBox:setTextColor(0xffffff)
	statsTextBox:setPosition(192 - statsTextBox:getWidth()/2, 0.5*WY + 95)
	self:addChild(statsTextBox)
	
	self.gearBut1 = MenuBut.new(40, 40, textures.optionsBut, textures.optionsBut1)
	self.gearBut1.bitmap:setPosition(112, WY/2 + 126)
	self.gearBut1:addEventListener(Event.TOUCHES_END, function(event)
		if self.gearBut1:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			sceneMan:changeScene("editCustom", transTime, SceneManager.fade, easing.linear, {userData = "mainMenu_Arena"}) 
		end
	end)
	if classNames[classIndexL] == "Custom" then
		self:addChild(self.gearBut1)
	end
	self.gearBut2 = MenuBut.new(40, 40, textures.optionsBut, textures.optionsBut1)
	self.gearBut2.bitmap:setPosition(WX0 - 112, WY/2 + 126)
	self.gearBut2:addEventListener(Event.TOUCHES_END, function(event)
		if self.gearBut2:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			sceneMan:changeScene("editCustom", transTime, SceneManager.fade, easing.linear, {userData = "mainMenu_Arena"}) 
		end
	end)
	if classNames[classIndexR] == "Custom" then
		self:addChild(self.gearBut2)
	end
	
	self.prevBut = MenuBut.new(40, 40, textures.backBut, textures.backBut1)
	self:addChild(self.prevBut)
	self.prevBut.bitmap:setPosition(32, WY/2)
	self.prevBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.prevBut:hitTestPoint(event.touch.x, event.touch.y) then
			classIndexL = classIndexL - 1
			if classIndexL < 1 then classIndexL = tablelength(classNames) end
			self:removeChild(selClassTextBox)
			class = classNames[classIndexL]
			selClassTextBox = TextField.new(self.font, class)
			selClassTextBox:setTextColor(0xffffff)
			selClassTextBox:setPosition(192 - selClassTextBox:getWidth()/2, 0.5*WY + 10)
			self:addChild(selClassTextBox)
			
			self:removeChild(selSkillTextBox)
			selSkillTextBox = TextWrap.new(classSkill[classIndexL]..": "..classSkillDesc[classIndexL], 300, "center", 7, self.smallfont)
			selSkillTextBox:setTextColor(0xffffff)
			selSkillTextBox:setPosition(192 - selSkillTextBox:getWidth()/2, 0.5*WY + 50)
			self:addChild(selSkillTextBox)
			
			self:removeChild(statsTextBox)
			stats = "Atk: "..classAtk[classIndexL].."\n"..
					"Mov: "..classMov[classIndexL].."\n"..
					"Lif: "..classLif[classIndexL].."\n"..
					"Skl: "..classSkl[classIndexL].."\n"..
					"Def: "..classDef[classIndexL].."\n"
			statsTextBox = TextWrap.new(stats, 80, "center", 7, self.smallfont)
			statsTextBox:setTextColor(0xffffff)
			statsTextBox:setPosition(192 - statsTextBox:getWidth()/2, 0.5*WY + 95)
			self:addChild(statsTextBox)
			
			if class == "Custom" then
				for i = self:getNumChildren(), 1, -1 do
					if self:getChildAt(i) == self.gearBut1 then
						self:removeChild(self.gearBut1)
					end
				end
				self:addChild(self.gearBut1)
			else
				for i = self:getNumChildren(), 1, -1 do
					if self:getChildAt(i) == self.gearBut1 then
						self:removeChild(self.gearBut1)
					end
				end
			end
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	self.nextBut = MenuBut.new(40, 40, textures.forwardBut, textures.forwardBut1)
	self:addChild(self.nextBut)
	self.nextBut.bitmap:setPosition(342, WY/2)
	self.nextBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.nextBut:hitTestPoint(event.touch.x, event.touch.y) then
			classIndexL = classIndexL + 1
			if classIndexL > tablelength(classNames) then classIndexL = 1 end
			self:removeChild(selClassTextBox)
			class = classNames[classIndexL]
			selClassTextBox = TextField.new(self.font, class)
			selClassTextBox:setTextColor(0xffffff)
			selClassTextBox:setPosition(192 - selClassTextBox:getWidth()/2, 0.5*WY + 10)
			self:addChild(selClassTextBox)
			
			self:removeChild(selSkillTextBox)
			selSkillTextBox = TextWrap.new(classSkill[classIndexL]..": "..classSkillDesc[classIndexL], 300, "center", 7, self.smallfont)
			selSkillTextBox:setTextColor(0xffffff)
			selSkillTextBox:setPosition(192 - selSkillTextBox:getWidth()/2, 0.5*WY + 50)
			self:addChild(selSkillTextBox)
			
			self:removeChild(statsTextBox)
			stats = "Atk: "..classAtk[classIndexL].."\n"..
					"Mov: "..classMov[classIndexL].."\n"..
					"Lif: "..classLif[classIndexL].."\n"..
					"Skl: "..classSkl[classIndexL].."\n"..
					"Def: "..classDef[classIndexL].."\n"
			statsTextBox = TextWrap.new(stats, 80, "center", 7, self.smallfont)
			statsTextBox:setTextColor(0xffffff)
			statsTextBox:setPosition(192 - statsTextBox:getWidth()/2, 0.5*WY + 95)
			self:addChild(statsTextBox)
			
			if class == "Custom" then
				for i = self:getNumChildren(), 1, -1 do
					if self:getChildAt(i) == self.gearBut1 then
						self:removeChild(self.gearBut1)
					end
				end
				self:addChild(self.gearBut1)
			else
				for i = self:getNumChildren(), 1, -1 do
					if self:getChildAt(i) == self.gearBut1 then
						self:removeChild(self.gearBut1)
					end
				end
			end
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	
	local classTextBoxAI = nil
	if optionsTable["ArenaSide"] == "Right" then
		classTextBoxAI = TextField.new(self.font, "Class:")
	else
		classTextBoxAI = TextField.new(self.font, "Enemy Class:")
	end
	classTextBoxAI:setTextColor(0xffffff)
	classTextBoxAI:setPosition(WX - 192 - classTextBoxAI:getWidth()/2, 0.5*WY - 30)
	self:addChild(classTextBoxAI)
	
	local classAI = classNames[classIndexR]
	local selClassTextBoxAI = TextField.new(self.font, classAI)
	selClassTextBoxAI:setTextColor(0xffffff)
	selClassTextBoxAI:setPosition(WX - 192 - selClassTextBoxAI:getWidth()/2, 0.5*WY + 10)
	self:addChild(selClassTextBoxAI)
	
	local selSkillTextBoxAI = TextWrap.new(classSkill[classIndexL]..": "..classSkillDesc[classIndexL], 300, "center", 7, self.smallfont)
	selSkillTextBoxAI:setTextColor(0xffffff)
	selSkillTextBoxAI:setPosition(WX - 192 - selSkillTextBoxAI:getWidth()/2, 0.5*WY + 50)
	self:addChild(selSkillTextBoxAI)
	

	local statsAI = "Atk: "..classAtk[classIndexR].."\n"..
			"Mov: "..classMov[classIndexR].."\n"..
			"Lif: "..classLif[classIndexR].."\n"..
			"Skl: "..classSkl[classIndexR].."\n"..
			"Def: "..classDef[classIndexR].."\n"
	local statsTextBoxAI = TextWrap.new(statsAI, 80, "center", 7, self.smallfont)
	statsTextBoxAI:setTextColor(0xffffff)
	statsTextBoxAI:setPosition(WX - 192 - statsTextBoxAI:getWidth()/2, 0.5*WY + 95)
	self:addChild(statsTextBoxAI)
	
	self.prevButAI = MenuBut.new(40, 40, textures.backBut, textures.backBut1)
	self:addChild(self.prevButAI)
	self.prevButAI.bitmap:setPosition(WX - 342, WY/2)
	self.prevButAI:addEventListener(Event.TOUCHES_END, function(event)
		if self.prevButAI:hitTestPoint(event.touch.x, event.touch.y) then
			classIndexR = classIndexR - 1
			if classIndexR < 1 then classIndexR = tablelength(classNames) end
			self:removeChild(selClassTextBoxAI)
			classAI = classNames[classIndexR]
			selClassTextBoxAI = TextField.new(self.font, classAI)
			selClassTextBoxAI:setTextColor(0xffffff)
			selClassTextBoxAI:setPosition(WX - 192 - selClassTextBoxAI:getWidth()/2, 0.5*WY + 10)
			self:addChild(selClassTextBoxAI)
			
			self:removeChild(selSkillTextBoxAI)
			selSkillTextBoxAI = TextWrap.new(classSkill[classIndexL]..": "..classSkillDesc[classIndexL], 300, "center", 7, self.smallfont)
			selSkillTextBoxAI:setTextColor(0xffffff)
			selSkillTextBoxAI:setPosition(WX - 192 - selSkillTextBoxAI:getWidth()/2, 0.5*WY + 50)
			self:addChild(selSkillTextBoxAI)
			
			self:removeChild(statsTextBoxAI)
			statsAI = "Atk: "..classAtk[classIndexR].."\n"..
						"Mov: "..classMov[classIndexR].."\n"..
						"Lif: "..classLif[classIndexR].."\n"..
						"Skl: "..classSkl[classIndexR].."\n"..
						"Def: "..classDef[classIndexR].."\n"
			statsTextBoxAI = TextWrap.new(statsAI, 80, "center", 7, self.smallfont)
			statsTextBoxAI:setTextColor(0xffffff)
			statsTextBoxAI:setPosition(WX - 192 - statsTextBoxAI:getWidth()/2, 0.5*WY + 95)
			self:addChild(statsTextBoxAI)
			
			if classAI == "Custom" then
				for i = self:getNumChildren(), 1, -1 do
					if self:getChildAt(i) == self.gearBut2 then
						self:removeChild(self.gearBut2)
					end
				end
				self:addChild(self.gearBut2)
			else
				for i = self:getNumChildren(), 1, -1 do
					if self:getChildAt(i) == self.gearBut2 then
						self:removeChild(self.gearBut2)
					end
				end
			end
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	self.nextButAI = MenuBut.new(40, 40, textures.forwardBut, textures.forwardBut1)
	self:addChild(self.nextButAI)
	self.nextButAI.bitmap:setPosition(WX - 32, WY/2)
	self.nextButAI:addEventListener(Event.TOUCHES_END, function(event)
		if self.nextButAI:hitTestPoint(event.touch.x, event.touch.y) then
			classIndexR = classIndexR + 1
			if classIndexR > tablelength(classNames) then classIndexR = 1 end
			self:removeChild(selClassTextBoxAI)
			classAI = classNames[classIndexR]
			selClassTextBoxAI = TextField.new(self.font, classAI)
			selClassTextBoxAI:setTextColor(0xffffff)
			selClassTextBoxAI:setPosition(WX - 192 - selClassTextBoxAI:getWidth()/2, 0.5*WY + 10)
			self:addChild(selClassTextBoxAI)
			
			self:removeChild(selSkillTextBoxAI)
			selSkillTextBoxAI = TextWrap.new(classSkill[classIndexR]..": "..classSkillDesc[classIndexR], 300, "center", 7, self.smallfont)
			selSkillTextBoxAI:setTextColor(0xffffff)
			selSkillTextBoxAI:setPosition(WX - 192 - selSkillTextBoxAI:getWidth()/2, 0.5*WY + 50)
			self:addChild(selSkillTextBoxAI)
			
			self:removeChild(statsTextBoxAI)
			statsAI = "Atk: "..classAtk[classIndexR].."\n"..
						"Mov: "..classMov[classIndexR].."\n"..
						"Lif: "..classLif[classIndexR].."\n"..
						"Skl: "..classSkl[classIndexR].."\n"..
						"Def: "..classDef[classIndexR].."\n"
			statsTextBoxAI = TextWrap.new(statsAI, 80, "center", 7, self.smallfont)
			statsTextBoxAI:setTextColor(0xffffff)
			statsTextBoxAI:setPosition(WX - 192 - statsTextBoxAI:getWidth()/2, 0.5*WY + 95)
			self:addChild(statsTextBoxAI)
			
			if classAI == "Custom" then
				for i = self:getNumChildren(), 1, -1 do
					if self:getChildAt(i) == self.gearBut2 then
						self:removeChild(self.gearBut2)
					end
				end
				self:addChild(self.gearBut2)
			else
				for i = self:getNumChildren(), 1, -1 do
					if self:getChildAt(i) == self.gearBut2 then
						self:removeChild(self.gearBut2)
					end
				end
			end
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	-- Go or return --
	self.goBut = MenuBut.new(150, 40, textures.goBut, textures.goBut1)
	self:addChild(self.goBut)
	self.goBut.bitmap:setPosition(WX/2, WY/2 + 190)
	self.goBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.goBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			local optionsFile = io.open("|D|options.txt", "w+")
			for k, v in pairs(optionsTable) do 
				optionsFile:write(k.."="..v.."\n")
			end	
			sceneMan:changeScene("mainMenu_Arena2", transTime, SceneManager.fade, easing.linear, { userData = {difficulty, class, classAI} }) 
		end
	end)
	
	self.returnBut = MenuBut.new(150, 40, textures.returnBut, textures.returnBut1)
	self:addChild(self.returnBut)
	self.returnBut.bitmap:setPosition(self.returnBut:getWidth()/2 + 10, WY/2 + 210)
	self.returnBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.returnBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel3:play() end
			local optionsFile = io.open("|D|options.txt", "w+")
			for k, v in pairs(optionsTable) do 
				optionsFile:write(k.."="..v.."\n")
			end	
			sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
		end
	end)
	
	-- Listen to Keys --
	self:addEventListener(Event.KEY_DOWN, onKeyDown)
end