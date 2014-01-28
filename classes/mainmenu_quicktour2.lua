------------------------------------------
-- Class for the Main Menu - Arena Mode --
------------------------------------------

MainMenu_QuickTour2 = Core.class(Sprite)

-- Declarations --
MainMenu_QuickTour2.font = nil
MainMenu_QuickTour2.savedData = {}


-- Handles Keys --
local function onKeyDown(event)
	if event.keyCode == 301 then
		if optionsTable["SFX"] == "On" then sounds.sel3:play() end
		
		sceneMan:changeScene("mainMenu_QuickTour", transTime, SceneManager.fade, easing.linear) 
	end
end

-- Initialization --
function MainMenu_QuickTour2:init()
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
	difTextBox:setPosition(WX/4 - difTextBox:getWidth()/2, 0.5*WY + 16)
	self:addChild(difTextBox)
	
	local difficulty = 5
	local numTextBox = TextField.new(self.font, tostring(difficulty))
	numTextBox:setTextColor(0xffffff)
	numTextBox:setPosition(WX/4 - numTextBox:getWidth()/2, 0.5*WY + 64)
	self:addChild(numTextBox)
	
	self.decDif = MenuBut.new(40, 40, textures.minusBut, textures.minusBut1)
	self:addChild(self.decDif)
	self.decDif.bitmap:setPosition(WX/4 - 60, WY/2 + 54)
	self.decDif:addEventListener(Event.TOUCHES_END, function(event)
		if self.decDif:hitTestPoint(event.touch.x, event.touch.y) then
			difficulty = difficulty - 1
			if difficulty < 1 then difficulty = 1 end
			optionsTable["Difficulty"] = difficulty
			self:removeChild(numTextBox)
			numTextBox = TextField.new(self.font, tostring(difficulty))
			numTextBox:setTextColor(0xffffff)
			numTextBox:setPosition(WX/4 - numTextBox:getWidth()/2, 0.5*WY + 64)
			self:addChild(numTextBox)
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	self.incDif = MenuBut.new(40, 40, textures.plusBut, textures.plusBut1)
	self:addChild(self.incDif)
	self.incDif.bitmap:setPosition(WX/4 + 60, WY/2 + 54)
	self.incDif:addEventListener(Event.TOUCHES_END, function(event)
		if self.incDif:hitTestPoint(event.touch.x, event.touch.y) then
			difficulty = difficulty + 1
			if difficulty > 10 then difficulty = 10 end
			optionsTable["Difficulty"] = difficulty
			self:removeChild(numTextBox)
			numTextBox = TextField.new(self.font, tostring(difficulty))
			numTextBox:setTextColor(0xffffff)
			numTextBox:setPosition(WX/4 - numTextBox:getWidth()/2, 0.5*WY + 64)
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
	classTextBox = TextField.new(self.font, "Class:")
	classTextBox:setTextColor(0xffffff)
	classTextBox:setPosition(WX - 192 - classTextBox:getWidth()/2, 0.5*WY - 30)
	self:addChild(classTextBox)
	
	local classIndex = 1
	local class = "Warrior"
	local selClassTextBox = TextField.new(self.font, class)
	selClassTextBox:setTextColor(0xffffff)
	selClassTextBox:setPosition(WX - 192 - selClassTextBox:getWidth()/2, 0.5*WY + 10)
	self:addChild(selClassTextBox)
	
	local selSkillTextBox = TextWrap.new(classSkill[classIndex]..": "..classSkillDesc[classIndex], 300, "center", 7, self.smallfont)
	selSkillTextBox:setTextColor(0xffffff)
	selSkillTextBox:setPosition(WX - 192 - selSkillTextBox:getWidth()/2, 0.5*WY + 50)
	self:addChild(selSkillTextBox)
	
	local stats = "Atk: "..classAtk[1].."\n"..
					"Mov: "..classMov[1].."\n"..
					"Lif: "..classLif[1].."\n"..
					"Skl: "..classSkl[1].."\n"..
					"Def: "..classDef[1].."\n"
	local statsTextBox = TextWrap.new(stats, 80, "center", 7, self.smallfont)
	statsTextBox:setTextColor(0xffffff)
	statsTextBox:setPosition(WX - 192 - statsTextBox:getWidth()/2, 0.5*WY + 95)
	self:addChild(statsTextBox)
	
	self.prevBut = MenuBut.new(40, 40, textures.backBut, textures.backBut1)
	self:addChild(self.prevBut)
	self.prevBut.bitmap:setPosition(WX - 342, WY/2)
	self.prevBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.prevBut:hitTestPoint(event.touch.x, event.touch.y) then
			classIndex = classIndex - 1
			if classIndex < 1 then classIndex = tablelength(classNames) end
			self:removeChild(selClassTextBox)
			class = classNames[classIndex]
			selClassTextBox = TextField.new(self.font, class)
			selClassTextBox:setTextColor(0xffffff)
			selClassTextBox:setPosition(WX - 192 - selClassTextBox:getWidth()/2, 0.5*WY + 10)
			self:addChild(selClassTextBox)
			
			self:removeChild(selSkillTextBox)
			selSkillTextBox = TextWrap.new(classSkill[classIndex]..": "..classSkillDesc[classIndex], 300, "center", 7, self.smallfont)
			selSkillTextBox:setTextColor(0xffffff)
			selSkillTextBox:setPosition(WX - 192 - selSkillTextBox:getWidth()/2, 0.5*WY + 50)
			self:addChild(selSkillTextBox)
			
			self:removeChild(statsTextBox)
			stats = "Atk: "..classAtk[classIndex].."\n"..
					"Mov: "..classMov[classIndex].."\n"..
					"Lif: "..classLif[classIndex].."\n"..
					"Skl: "..classSkl[classIndex].."\n"..
					"Def: "..classDef[classIndex].."\n"
			statsTextBox = TextWrap.new(stats, 80, "center", 7, self.smallfont)
			statsTextBox:setTextColor(0xffffff)
			statsTextBox:setPosition(WX - 192 - statsTextBox:getWidth()/2, 0.5*WY + 95)
			self:addChild(statsTextBox)
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	self.nextBut = MenuBut.new(40, 40, textures.forwardBut, textures.forwardBut1)
	self:addChild(self.nextBut)
	self.nextBut.bitmap:setPosition(WX - 42, WY/2)
	self.nextBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.nextBut:hitTestPoint(event.touch.x, event.touch.y) then
			classIndex = classIndex + 1
			if classIndex > tablelength(classNames) then classIndex = 1 end
			self:removeChild(selClassTextBox)
			class = classNames[classIndex]
			selClassTextBox = TextField.new(self.font, class)
			selClassTextBox:setTextColor(0xffffff)
			selClassTextBox:setPosition(WX - 192 - selClassTextBox:getWidth()/2, 0.5*WY + 10)
			self:addChild(selClassTextBox)
			
			self:removeChild(selSkillTextBox)
			selSkillTextBox = TextWrap.new(classSkill[classIndex]..": "..classSkillDesc[classIndex], 300, "center", 7, self.smallfont)
			selSkillTextBox:setTextColor(0xffffff)
			selSkillTextBox:setPosition(WX - 192 - selSkillTextBox:getWidth()/2, 0.5*WY + 50)
			self:addChild(selSkillTextBox)
			
			self:removeChild(statsTextBox)
			stats = "Atk: "..classAtk[classIndex].."\n"..
					"Mov: "..classMov[classIndex].."\n"..
					"Lif: "..classLif[classIndex].."\n"..
					"Skl: "..classSkl[classIndex].."\n"..
					"Def: "..classDef[classIndex].."\n"
			statsTextBox = TextWrap.new(stats, 80, "center", 7, self.smallfont)
			statsTextBox:setTextColor(0xffffff)
			statsTextBox:setPosition(WX - 192 - statsTextBox:getWidth()/2, 0.5*WY + 95)
			self:addChild(statsTextBox)
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	
	-- Go! or return --
	self.goBut = MenuBut.new(150, 40, textures.goBut, textures.goBut1)
	self:addChild(self.goBut)
	self.goBut.bitmap:setPosition(WX/2, 0.5*WY + 160)
	self.goBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.goBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			local optionsFile = io.open("|D|options.txt", "w+")
			for k, v in pairs(optionsTable) do 
				optionsFile:write(k.."="..v.."\n")
			end	
			sceneMan:changeScene("arenaTour", transTime, SceneManager.fade, easing.linear, { userData = {difficulty, class, "Random", 1} }) 
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
			sceneMan:changeScene("mainMenu_QuickTour", transTime, SceneManager.fade, easing.linear) 
		end
	end)
	
	-- Listen to Keys --
	self:addEventListener(Event.KEY_DOWN, onKeyDown)
end