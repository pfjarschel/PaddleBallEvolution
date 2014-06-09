-------------------------------------------
-- Class for the Main Menu - QuickTour 2 --
-------------------------------------------

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
		if classTable[k][12] == 0 or mainLock == "unlocked" then
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
	
	local class = classNames[classIndexT]
	local classname = ""
	if class == "Random" then
		classname = "Random"
	elseif class == "Custom" then
		classname = "Custom Class"
	else
		classname = classTable[class][11]
	end
	local selClassTextBox = TextField.new(self.font, classname)
	selClassTextBox:setTextColor(0xffffff)
	selClassTextBox:setPosition(WX - 192 - selClassTextBox:getWidth()/2, 0.5*WY + 10)
	self:addChild(selClassTextBox)
	
	local selSkillTextBox = TextWrap.new(classSkill[classIndexT]..": "..classSkillDesc[classIndexT], 300, "center", 7, self.smallfont)
	selSkillTextBox:setTextColor(0xffffff)
	selSkillTextBox:setPosition(WX - 192 - selSkillTextBox:getWidth()/2, 0.5*WY + 50)
	self:addChild(selSkillTextBox)
	
	local stats = "Atk: "..classAtk[classIndexT].."\n"..
					"Mov: "..classMov[classIndexT].."\n"..
					"Lif: "..classLif[classIndexT].."\n"..
					"Skl: "..classSkl[classIndexT].."\n"..
					"Def: "..classDef[classIndexT].."\n"
	local statsTextBox = TextWrap.new(stats, 80, "center", 7, self.smallfont)
	statsTextBox:setTextColor(0xffffff)
	statsTextBox:setPosition(WX - 192 - statsTextBox:getWidth()/2, 0.5*WY + 95)
	self:addChild(statsTextBox)
	
	self.gearBut1 = MenuBut.new(40, 40, textures.optionsBut, textures.optionsBut1)
	self.gearBut1.bitmap:setPosition(WX0 - 112, WY/2 + 126)
	self.gearBut1:addEventListener(Event.TOUCHES_END, function(event)
		if self.gearBut1:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			sceneMan:changeScene("editCustom", transTime, SceneManager.fade, easing.linear, {userData = "mainMenu_QuickTour2"}) 
		end
	end)
	if classNames[classIndexT] == "Custom" then
		self:addChild(self.gearBut1)
	end
	
	self.prevBut = MenuBut.new(40, 40, textures.backBut, textures.backBut1)
	self:addChild(self.prevBut)
	self.prevBut.bitmap:setPosition(WX - 342, WY/2)
	self.prevBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.prevBut:hitTestPoint(event.touch.x, event.touch.y) then
			classIndexT = classIndexT - 1
			if classIndexT < 1 then classIndexT = tablelength(classNames) end
			self:removeChild(selClassTextBox)
			class = classNames[classIndexT]
			local classname = ""
			if class == "Random" then
				classname = "Random"
			elseif class == "Custom" then
				classname = "Custom Class"
			else
				classname = classTable[class][11]
			end
			selClassTextBox = TextField.new(self.font, classname)
			selClassTextBox:setTextColor(0xffffff)
			selClassTextBox:setPosition(WX - 192 - selClassTextBox:getWidth()/2, 0.5*WY + 10)
			self:addChild(selClassTextBox)
			
			self:removeChild(selSkillTextBox)
			selSkillTextBox = TextWrap.new(classSkill[classIndexT]..": "..classSkillDesc[classIndexT], 300, "center", 7, self.smallfont)
			selSkillTextBox:setTextColor(0xffffff)
			selSkillTextBox:setPosition(WX - 192 - selSkillTextBox:getWidth()/2, 0.5*WY + 50)
			self:addChild(selSkillTextBox)
			
			self:removeChild(statsTextBox)
			stats = "Atk: "..classAtk[classIndexT].."\n"..
					"Mov: "..classMov[classIndexT].."\n"..
					"Lif: "..classLif[classIndexT].."\n"..
					"Skl: "..classSkl[classIndexT].."\n"..
					"Def: "..classDef[classIndexT].."\n"
			statsTextBox = TextWrap.new(stats, 80, "center", 7, self.smallfont)
			statsTextBox:setTextColor(0xffffff)
			statsTextBox:setPosition(WX - 192 - statsTextBox:getWidth()/2, 0.5*WY + 95)
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
	self.nextBut.bitmap:setPosition(WX - 42, WY/2)
	self.nextBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.nextBut:hitTestPoint(event.touch.x, event.touch.y) then
			classIndexT = classIndexT + 1
			if classIndexT > tablelength(classNames) then classIndexT = 1 end
			self:removeChild(selClassTextBox)
			class = classNames[classIndexT]
			local classname = ""
			if class == "Random" then
				classname = "Random"
			elseif class == "Custom" then
				classname = "Custom Class"
			else
				classname = classTable[class][11]
			end
			selClassTextBox = TextField.new(self.font, classname)
			selClassTextBox:setTextColor(0xffffff)
			selClassTextBox:setPosition(WX - 192 - selClassTextBox:getWidth()/2, 0.5*WY + 10)
			self:addChild(selClassTextBox)
			
			self:removeChild(selSkillTextBox)
			selSkillTextBox = TextWrap.new(classSkill[classIndexT]..": "..classSkillDesc[classIndexT], 300, "center", 7, self.smallfont)
			selSkillTextBox:setTextColor(0xffffff)
			selSkillTextBox:setPosition(WX - 192 - selSkillTextBox:getWidth()/2, 0.5*WY + 50)
			self:addChild(selSkillTextBox)
			
			self:removeChild(statsTextBox)
			stats = "Atk: "..classAtk[classIndexT].."\n"..
					"Mov: "..classMov[classIndexT].."\n"..
					"Lif: "..classLif[classIndexT].."\n"..
					"Skl: "..classSkl[classIndexT].."\n"..
					"Def: "..classDef[classIndexT].."\n"
			statsTextBox = TextWrap.new(stats, 80, "center", 7, self.smallfont)
			statsTextBox:setTextColor(0xffffff)
			statsTextBox:setPosition(WX - 192 - statsTextBox:getWidth()/2, 0.5*WY + 95)
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
	
	
	-- Go! or return --
	self.goBut = MenuBut.new(192, 40, textures.goBut, textures.goBut1)
	self:addChild(self.goBut)
	self.goBut.bitmap:setPosition(WX/2, 0.5*WY + 160)
	self.goBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.goBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			local optionsFile = io.open("|D|options.txt", "w+")
			for k, v in pairs(optionsTable) do 
				optionsFile:write(k.."="..v.."\n")
			end
			local arenaNames = {}			
			local i = 1
			for k, v in pairs(arenasTable) do
				arenaNames[i] = k
				i = i + 1
			end
			local arenatype = arenaNames[math.random(1, tablelength(arenaNames))]
			tourTable["QuickTourArena"] = arenatype
			sceneMan:changeScene("arenaTour", transTime, SceneManager.fade, easing.linear, { userData = {difficulty, class, "Random", 1, arenatype} }) 
		end
	end)
	
	self.returnBut = MenuBut.new(192, 40, textures.returnBut, textures.returnBut1)
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