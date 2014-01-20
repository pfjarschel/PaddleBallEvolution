------------------------------------------
-- Class for the Main Menu - Arena Mode --
------------------------------------------

MainMenu_Arena = Core.class(Sprite)

-- Declarations --
MainMenu_Arena.font = nil

-- Handles Keys --
local function onKeyDown(event)
	if event.keyCode == 301 then
		sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
	end
end

-- Initialization --
function MainMenu_Arena:init()
	self.font = fonts.arialroundedSmall
	self.smallfont = fonts.arialroundedVerySmall
	
	-- If the same bg as the main menu one is used, weird stuff happens --
	local menubg = textures.mainmenubg2
	menubg:setScale(1, 1)
	self:addChild(menubg)
	local textureW = menubg:getWidth()
	local textureH = menubg:getHeight()
	menubg:setScale(WX/textureW, WY/textureH)
	
	-- Difficulty Selection --
	local difTextBox = TextField.new(self.font, "Difficulty:")
	difTextBox:setTextColor(0x000000)
	difTextBox:setPosition(0.5*WX - difTextBox:getWidth()/2, 0.5*WY + 90)
	self:addChild(difTextBox)
	
	local difficulty = 5
	local numTextBox = TextField.new(self.font, tostring(difficulty))
	numTextBox:setTextColor(0x000000)
	numTextBox:setPosition(0.5*WX - numTextBox:getWidth()/2, 0.5*WY + 145)
	self:addChild(numTextBox)
	
	self.decDif = MenuBut.new(textures.minusBut, 40, 40)
	self:addChild(self.decDif)
	self.decDif.bitmap:setPosition(WX/2 - 60, WY/2 + 130)
	self.decDif:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.decDif:hitTestPoint(event.touch.x, event.touch.y) then
			difficulty = difficulty - 1
			if difficulty < 1 then difficulty = 1 end
			self:removeChild(numTextBox)
			numTextBox = TextField.new(self.font, tostring(difficulty))
			numTextBox:setPosition(0.5*WX - numTextBox:getWidth()/2, 0.5*WY + 145)
			self:addChild(numTextBox)
		end
	end)
	
	self.incDif = MenuBut.new(textures.plusBut, 40, 40)
	self:addChild(self.incDif)
	self.incDif.bitmap:setPosition(WX/2 + 60, WY/2 + 130)
	self.incDif:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.incDif:hitTestPoint(event.touch.x, event.touch.y) then
			difficulty = difficulty + 1
			if difficulty > 10 then difficulty = 10 end
			self:removeChild(numTextBox)
			numTextBox = TextField.new(self.font, tostring(difficulty))
			numTextBox:setPosition(0.5*WX - numTextBox:getWidth()/2, 0.5*WY + 145)
			self:addChild(numTextBox)
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
	local classTextBox = TextField.new(self.font, "Class:")
	classTextBox:setTextColor(0x000000)
	classTextBox:setPosition(192 - classTextBox:getWidth()/2, 0.5*WY - 30)
	self:addChild(classTextBox)
	
	local classIndex = 1
	local class = "Warrior"
	local selClassTextBox = TextField.new(self.font, class)
	selClassTextBox:setTextColor(0x000000)
	selClassTextBox:setPosition(192 - selClassTextBox:getWidth()/2, 0.5*WY + 15)
	self:addChild(selClassTextBox)
	
	local selSkillTextBox = TextField.new(self.smallfont, classSkill[classIndex]..": "..classSkillDesc[classIndex])
	selSkillTextBox:setTextColor(0x000000)
	selSkillTextBox:setPosition(192 - selSkillTextBox:getWidth()/2, 0.5*WY + 40)
	self:addChild(selSkillTextBox)
	
	local stats = "Atk: "..classAtk[1].."\n"..
					"Mov: "..classMov[1].."\n"..
					"Lif: "..classLif[1].."\n"..
					"Skl: "..classSkl[1].."\n"..
					"Def: "..classDef[1].."\n"
	local statsTextBox = TextWrap.new(stats, 64, "center", 5, self.smallfont)
	statsTextBox:setTextColor(0x000000)
	statsTextBox:setPosition(192 - statsTextBox:getWidth()/2, 0.5*WY + 70)
	self:addChild(statsTextBox)
	
	self.prevBut = MenuBut.new(textures.backBut, 40, 40)
	self:addChild(self.prevBut)
	self.prevBut.bitmap:setPosition(32, WY/2)
	self.prevBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.prevBut:hitTestPoint(event.touch.x, event.touch.y) then
			classIndex = classIndex - 1
			if classIndex < 1 then classIndex = tablelength(classNames) end
			self:removeChild(selClassTextBox)
			class = classNames[classIndex]
			selClassTextBox = TextField.new(self.font, class)
			selClassTextBox:setPosition(192 - selClassTextBox:getWidth()/2, 0.5*WY + 15)
			self:addChild(selClassTextBox)
			
			self:removeChild(selSkillTextBox)
			selSkillTextBox = TextField.new(self.smallfont, classSkill[classIndex]..": "..classSkillDesc[classIndex])
			selSkillTextBox:setTextColor(0x000000)
			selSkillTextBox:setPosition(192 - selSkillTextBox:getWidth()/2, 0.5*WY + 40)
			self:addChild(selSkillTextBox)
			
			self:removeChild(statsTextBox)
			stats = "Atk: "..classAtk[classIndex].."\n"..
					"Mov: "..classMov[classIndex].."\n"..
					"Lif: "..classLif[classIndex].."\n"..
					"Skl: "..classSkl[classIndex].."\n"..
					"Def: "..classDef[classIndex].."\n"
			statsTextBox = TextWrap.new(stats, 64, "center", 5, self.smallfont)
			statsTextBox:setTextColor(0x000000)
			statsTextBox:setPosition(192 - statsTextBox:getWidth()/2, 0.5*WY + 70)
			self:addChild(statsTextBox)
		end
	end)
	
	self.nextBut = MenuBut.new(textures.forwardBut, 40, 40)
	self:addChild(self.nextBut)
	self.nextBut.bitmap:setPosition(342, WY/2)
	self.nextBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.nextBut:hitTestPoint(event.touch.x, event.touch.y) then
			classIndex = classIndex + 1
			if classIndex > tablelength(classNames) then classIndex = 1 end
			self:removeChild(selClassTextBox)
			class = classNames[classIndex]
			selClassTextBox = TextField.new(self.font, class)
			selClassTextBox:setPosition(192 - selClassTextBox:getWidth()/2, 0.5*WY + 15)
			self:addChild(selClassTextBox)
			
			self:removeChild(selSkillTextBox)
			selSkillTextBox = TextField.new(self.smallfont, classSkill[classIndex]..": "..classSkillDesc[classIndex])
			selSkillTextBox:setTextColor(0x000000)
			selSkillTextBox:setPosition(192 - selSkillTextBox:getWidth()/2, 0.5*WY + 40)
			self:addChild(selSkillTextBox)
			
			self:removeChild(statsTextBox)
			stats = "Atk: "..classAtk[classIndex].."\n"..
					"Mov: "..classMov[classIndex].."\n"..
					"Lif: "..classLif[classIndex].."\n"..
					"Skl: "..classSkl[classIndex].."\n"..
					"Def: "..classDef[classIndex].."\n"
			statsTextBox = TextWrap.new(stats, 64, "center", 5, self.smallfont)
			statsTextBox:setTextColor(0x000000)
			statsTextBox:setPosition(192 - statsTextBox:getWidth()/2, 0.5*WY + 70)
			self:addChild(statsTextBox)
		end
	end)
	
	
	local classTextBoxAI = TextField.new(self.font, "Enemy Class:")
	classTextBoxAI:setTextColor(0x000000)
	classTextBoxAI:setPosition(WX - 192 - classTextBoxAI:getWidth()/2, 0.5*WY - 30)
	self:addChild(classTextBoxAI)
	
	local classIndexAI = 1
	local classAI = "Warrior"
	local selClassTextBoxAI = TextField.new(self.font, classAI)
	selClassTextBoxAI:setTextColor(0x000000)
	selClassTextBoxAI:setPosition(WX - 192 - selClassTextBoxAI:getWidth()/2, 0.5*WY + 15)
	self:addChild(selClassTextBoxAI)
	
	local selSkillTextBoxAI = TextField.new(self.smallfont, classSkill[classIndexAI]..": "..classSkillDesc[classIndexAI])
	selSkillTextBoxAI:setTextColor(0x000000)
	selSkillTextBoxAI:setPosition(WX - 192 - selSkillTextBoxAI:getWidth()/2, 0.5*WY + 40)
	self:addChild(selSkillTextBoxAI)
	

	local statsAI = "Atk: "..classAtk[1].."\n"..
			"Mov: "..classMov[1].."\n"..
			"Lif: "..classLif[1].."\n"..
			"Skl: "..classSkl[1].."\n"..
			"Def: "..classDef[1].."\n"
	local statsTextBoxAI = TextWrap.new(statsAI, 64, "center", 5, self.smallfont)
	statsTextBoxAI:setTextColor(0x000000)
	statsTextBoxAI:setPosition(WX - 192 - statsTextBoxAI:getWidth()/2, 0.5*WY + 70)
	self:addChild(statsTextBoxAI)
	
	self.prevButAI = MenuBut.new(textures.backBut2, 40, 40)
	self:addChild(self.prevButAI)
	self.prevButAI.bitmap:setPosition(WX - 342, WY/2)
	self.prevButAI:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.prevButAI:hitTestPoint(event.touch.x, event.touch.y) then
			classIndexAI = classIndexAI - 1
			if classIndexAI < 1 then classIndexAI = tablelength(classNames) end
			self:removeChild(selClassTextBoxAI)
			classAI = classNames[classIndexAI]
			selClassTextBoxAI = TextField.new(self.font, classAI)
			selClassTextBoxAI:setPosition(WX - 192 - selClassTextBoxAI:getWidth()/2, 0.5*WY + 15)
			self:addChild(selClassTextBoxAI)
			
			self:removeChild(selSkillTextBoxAI)
			selSkillTextBoxAI = TextField.new(self.smallfont, classSkill[classIndexAI]..": "..classSkillDesc[classIndexAI])
			selSkillTextBoxAI:setTextColor(0x000000)
			selSkillTextBoxAI:setPosition(WX - 192 - selSkillTextBoxAI:getWidth()/2, 0.5*WY + 40)
			self:addChild(selSkillTextBoxAI)
			
			self:removeChild(statsTextBoxAI)
			statsAI = "Atk: "..classAtk[classIndexAI].."\n"..
						"Mov: "..classMov[classIndexAI].."\n"..
						"Lif: "..classLif[classIndexAI].."\n"..
						"Skl: "..classSkl[classIndexAI].."\n"..
						"Def: "..classDef[classIndexAI].."\n"
			statsTextBoxAI = TextWrap.new(statsAI, 64, "center", 5, self.smallfont)
			statsTextBoxAI:setTextColor(0x000000)
			statsTextBoxAI:setPosition(WX - 192 - statsTextBoxAI:getWidth()/2, 0.5*WY + 70)
			self:addChild(statsTextBoxAI)
		end
	end)
	
	self.nextButAI = MenuBut.new(textures.forwardBut2, 40, 40)
	self:addChild(self.nextButAI)
	self.nextButAI.bitmap:setPosition(WX - 32, WY/2)
	self.nextButAI:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.nextButAI:hitTestPoint(event.touch.x, event.touch.y) then
			classIndexAI = classIndexAI + 1
			if classIndexAI > tablelength(classNames) then classIndexAI = 1 end
			self:removeChild(selClassTextBoxAI)
			classAI = classNames[classIndexAI]
			selClassTextBoxAI = TextField.new(self.font, classAI)
			selClassTextBoxAI:setPosition(WX - 192 - selClassTextBoxAI:getWidth()/2, 0.5*WY + 15)
			self:addChild(selClassTextBoxAI)
			
			self:removeChild(selSkillTextBoxAI)
			selSkillTextBoxAI = TextField.new(self.smallfont, classSkill[classIndexAI]..": "..classSkillDesc[classIndexAI])
			selSkillTextBoxAI:setTextColor(0x000000)
			selSkillTextBoxAI:setPosition(WX - 192 - selSkillTextBoxAI:getWidth()/2, 0.5*WY + 40)
			self:addChild(selSkillTextBoxAI)
			
			self:removeChild(statsTextBoxAI)
			statsAI = "Atk: "..classAtk[classIndexAI].."\n"..
						"Mov: "..classMov[classIndexAI].."\n"..
						"Lif: "..classLif[classIndexAI].."\n"..
						"Skl: "..classSkl[classIndexAI].."\n"..
						"Def: "..classDef[classIndexAI].."\n"
			statsTextBoxAI = TextWrap.new(statsAI, 64, "center", 5, self.smallfont)
			statsTextBoxAI:setTextColor(0x000000)
			statsTextBoxAI:setPosition(WX - 192 - statsTextBoxAI:getWidth()/2, 0.5*WY + 70)
			self:addChild(statsTextBoxAI)
		end
	end)
	
	-- Go or return --
	self.goBut = MenuBut.new(textures.goBut, 150, 40)
	self:addChild(self.goBut)
	self.goBut.bitmap:setPosition(WX/2, WY/2 + 190)
	self.goBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.goBut:hitTestPoint(event.touch.x, event.touch.y) then
			sceneMan:changeScene("arena", transTime, SceneManager.fade, easing.linear, { userData = {difficulty, class, classAI} }) 
		end
	end)
	
	self.returnBut = MenuBut.new(textures.returnBut, 150, 40)
	self:addChild(self.returnBut)
	self.returnBut.bitmap:setPosition(self.returnBut:getWidth()/2 + 10, WY/2 + 210)
	self.returnBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.returnBut:hitTestPoint(event.touch.x, event.touch.y) then
			sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
		end
	end)
	
	-- Listen to Keys --
	self:addEventListener(Event.KEY_DOWN, onKeyDown)
end