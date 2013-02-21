-----------------------------
-- Class for the Main Menu --
-----------------------------

MainMenu = Core.class(Sprite)
MainMenu.fontSize = 30
MainMenu.font = TTFont.new("Fonts/arial-rounded.ttf", MainMenu.fontSize)
MainMenu.timerok = true


-- Initialization function
function MainMenu:init()
	local menubg = textures.mainmenubg
	menubg:setScale(1, 1)
	self:addChild(menubg)
	local textureW = menubg:getWidth()
	local textureH = menubg:getHeight()
	menubg:setScale(WX/textureW, WY/textureH)
	self:loadMainMenu()
	self:setAlpha(0)
	stage:addChild(self)
end

function MainMenu:clearMenuItems()
	for i = self:getNumChildren(), 2, -1 do
		self:removeChildAt(i)
	end
end

function MainMenu:loadClassicMenu()	
	self:clearMenuItems()
	
	local fontSize = 40
	local font = TTFont.new("Fonts/arial-rounded.ttf", fontSize)
	local difTextBox = TextField.new(font, "Difficulty:")
	difTextBox:setTextColor(0x000000)
	difTextBox:setPosition(0.5*WX - difTextBox:getWidth()/2, 0.5*WY + 60)
	self:addChild(difTextBox)
	local difficulty = 5
	local numTextBox = TextField.new(font, tostring(difficulty))
	numTextBox:setTextColor(0x000000)
	numTextBox:setPosition(0.5*WX - numTextBox:getWidth()/2, 0.5*WY + 115)
	self:addChild(numTextBox)
	
	self.decDif = SmallMenuBut.new(textures.minusBut)
	self:addChild(self.decDif)
	self.decDif.bitmap:setPosition(WX/2 - 60, WY/2 + 100)
	self.decDif:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.decDif:hitTestPoint(event.touch.x, event.touch.y) then
			difficulty = difficulty - 1
			if difficulty < 1 then difficulty = 1 end
			self:removeChild(numTextBox)
			numTextBox = TextField.new(font, tostring(difficulty))
			numTextBox:setPosition(0.5*WX - numTextBox:getWidth()/2, 0.5*WY + 115)
			self:addChild(numTextBox)
		end
	end)
	
	self.incDif = SmallMenuBut.new(textures.plusBut)
	self:addChild(self.incDif)
	self.incDif.bitmap:setPosition(WX/2 + 60, WY/2 + 100)
	self.incDif:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.incDif:hitTestPoint(event.touch.x, event.touch.y) then
			difficulty = difficulty + 1
			if difficulty > 10 then difficulty = 10 end
			self:removeChild(numTextBox)
			numTextBox = TextField.new(font, tostring(difficulty))
			numTextBox:setPosition(0.5*WX - numTextBox:getWidth()/2, 0.5*WY + 115)
			self:addChild(numTextBox)
		end
	end)
	
	self.goBut = BigMenuBut.new(textures.goBut)
	self:addChild(self.goBut)
	self.goBut.bitmap:setPosition(WX/2, WY/2 + 160)
	self.goBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.goBut:hitTestPoint(event.touch.x, event.touch.y) and self.timerok then
			self.timerok = false
			fadeOut(self)
			Timer.delayedCall(700, function ()
				self.timerok = true
				stage:removeChild(self)
				self = nil
				loadArena("classic", difficulty)
			end)
		end
	end)
	
	self.returnBut = BigMenuBut.new(textures.returnBut)
	self:addChild(self.returnBut)
	self.returnBut.bitmap:setPosition(self.returnBut:getWidth()/2 + 10, WY/2 + 210)
	self.returnBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.returnBut:hitTestPoint(event.touch.x, event.touch.y) and self.timerok then
			self.timerok = false
			fadeOut(self)
			Timer.delayedCall(700, function ()
				self.timerok = true
				self:loadMainMenu()
			end)
		end
	end)
	
	fadeIn(self)
end

function MainMenu:loadArenaMenu()	
	self:clearMenuItems()
	
	local fontSize = 40
	local font = TTFont.new("Fonts/arial-rounded.ttf", fontSize)
	
	local difTextBox = TextField.new(font, "Difficulty:")
	difTextBox:setTextColor(0x000000)
	difTextBox:setPosition(0.5*WX - difTextBox:getWidth()/2, 0.5*WY + 90)
	self:addChild(difTextBox)
	local difficulty = 5
	local numTextBox = TextField.new(font, tostring(difficulty))
	numTextBox:setTextColor(0x000000)
	numTextBox:setPosition(0.5*WX - numTextBox:getWidth()/2, 0.5*WY + 145)
	self:addChild(numTextBox)
	self.decDif = SmallMenuBut.new(textures.minusBut)
	self:addChild(self.decDif)
	self.decDif.bitmap:setPosition(WX/2 - 60, WY/2 + 130)
	self.decDif:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.decDif:hitTestPoint(event.touch.x, event.touch.y) then
			difficulty = difficulty - 1
			if difficulty < 1 then difficulty = 1 end
			self:removeChild(numTextBox)
			numTextBox = TextField.new(font, tostring(difficulty))
			numTextBox:setPosition(0.5*WX - numTextBox:getWidth()/2, 0.5*WY + 145)
			self:addChild(numTextBox)
		end
	end)
	self.incDif = SmallMenuBut.new(textures.plusBut)
	self:addChild(self.incDif)
	self.incDif.bitmap:setPosition(WX/2 + 60, WY/2 + 130)
	self.incDif:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.incDif:hitTestPoint(event.touch.x, event.touch.y) then
			difficulty = difficulty + 1
			if difficulty > 10 then difficulty = 10 end
			self:removeChild(numTextBox)
			numTextBox = TextField.new(font, tostring(difficulty))
			numTextBox:setPosition(0.5*WX - numTextBox:getWidth()/2, 0.5*WY + 145)
			self:addChild(numTextBox)
		end
	end)
	
	local classTextBox = TextField.new(font, "Class:")
	classTextBox:setTextColor(0x000000)
	classTextBox:setPosition(0.5*WX - classTextBox:getWidth()/2, 0.5*WY - 20)
	self:addChild(classTextBox)
	local class = "Warrior"
	local selClassTextBox = TextField.new(font, class)
	selClassTextBox:setTextColor(0x000000)
	selClassTextBox:setPosition(0.5*WX - selClassTextBox:getWidth()/2, 0.5*WY + 25)
	self:addChild(selClassTextBox)
	local classIndex = 1
	self.prevBut = SmallMenuBut.new(textures.backBut)
	self:addChild(self.prevBut)
	self.prevBut.bitmap:setPosition(WX/2 - 175, WY/2 + 10)
	self.prevBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.prevBut:hitTestPoint(event.touch.x, event.touch.y) then
			classIndex = classIndex - 1
			if classIndex < 1 then classIndex = 4 end
			self:removeChild(selClassTextBox)
			selClassTextBox = TextField.new(font, classTable[classIndex][1])
			selClassTextBox:setPosition(0.5*WX - selClassTextBox:getWidth()/2, 0.5*WY + 25)
			self:addChild(selClassTextBox)
		end
	end)
	self.nextBut = SmallMenuBut.new(textures.forwardBut)
	self:addChild(self.nextBut)
	self.nextBut.bitmap:setPosition(WX/2 + 175, WY/2 + 10)
	self.nextBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.nextBut:hitTestPoint(event.touch.x, event.touch.y) then
			classIndex = classIndex + 1
			if classIndex > 4 then classIndex = 1 end
			self:removeChild(selClassTextBox)
			selClassTextBox = TextField.new(font, classTable[classIndex][1])
			selClassTextBox:setPosition(0.5*WX - selClassTextBox:getWidth()/2, 0.5*WY + 25)
			self:addChild(selClassTextBox)
		end
	end)
	
	self.goBut = BigMenuBut.new(textures.goBut)
	self:addChild(self.goBut)
	self.goBut.bitmap:setPosition(WX/2, WY/2 + 190)
	self.goBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.goBut:hitTestPoint(event.touch.x, event.touch.y) and self.timerok then
			self.timerok = false
			fadeOut(self)
			Timer.delayedCall(700, function ()
				self.timerok = true
				stage:removeChild(self)
				self = nil
				loadArena("arena", difficulty, classIndex)
			end)
		end
	end)
	
	self.returnBut = BigMenuBut.new(textures.returnBut)
	self:addChild(self.returnBut)
	self.returnBut.bitmap:setPosition(self.returnBut:getWidth()/2 + 10, WY/2 + 210)
	self.returnBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.returnBut:hitTestPoint(event.touch.x, event.touch.y) and self.timerok then
			self.timerok = false
			fadeOut(self)
			Timer.delayedCall(700, function ()
				self.timerok = true
				self:loadMainMenu()
			end)
		end
	end)
	
	fadeIn(self)
end

function MainMenu:loadMainMenu()
	self:clearMenuItems()
	gc()
	
	self.careerBut = BigMenuBut.new(textures.careermodeBut)
	self:addChild(self.careerBut)
	self.careerBut.bitmap:setPosition(WX/2, WY/2)
	self.careerBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.careerBut:hitTestPoint(event.touch.x, event.touch.y) then
			print("Career Mode to Come!")
		end
	end)
	
	self.arenaBut = BigMenuBut.new(textures.arenaBut)
	self:addChild(self.arenaBut)
	self.arenaBut.bitmap:setPosition(WX/2, WY/2 + self.arenaBut.height)
	self.arenaBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.arenaBut:hitTestPoint(event.touch.x, event.touch.y) and self.timerok then
			self.timerok = false
			fadeOut(self)
			Timer.delayedCall(700, function ()
				self.timerok = true
				self:loadArenaMenu()
			end)
		end
	end)
	
	self.survivalBut = BigMenuBut.new(textures.survivalmodeBut)
	self:addChild(self.survivalBut)
	self.survivalBut.bitmap:setPosition(WX/2, WY/2 + 2*self.survivalBut.height)
	self.survivalBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.survivalBut:hitTestPoint(event.touch.x, event.touch.y) and self.timerok then
			self.timerok = false
			fadeOut(self)
			Timer.delayedCall(700, function ()
				self.timerok = true
				stage:removeChild(self)
				self = nil
				loadArena("survival", 5)
			end)
		end
	end)
	
	self.classicBut = BigMenuBut.new(textures.classicmodeBut)
	self:addChild(self.classicBut)
	self.classicBut.bitmap:setPosition(WX/2, WY/2 + 3*self.classicBut.height)
	self.classicBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.classicBut:hitTestPoint(event.touch.x, event.touch.y) and self.timerok then
			self.timerok = false
			fadeOut(self)
			Timer.delayedCall(700, function ()
				self.timerok = true
				self:loadClassicMenu()
			end)
		end
	end)
	
	self.exitBut = BigMenuBut.new(textures.exitBut)
	self:addChild(self.exitBut)
	self.exitBut.bitmap:setPosition(WX/2, WY/2 + 4*self.exitBut.height)
	self.exitBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.exitBut:hitTestPoint(event.touch.x, event.touch.y) and self.timerok then
			self.timerok = false
			fadeOut(self)
			Timer.delayedCall(1000, function ()
				self.timerok = true
				application:exit()
			end)
		end
	end)
	
	fadeIn(self)
end