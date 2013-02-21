-----------------------------
-- Class for the Main Menu --
-----------------------------

MainMenu = Core.class(Sprite)
MainMenu.font = nil
MainMenu.timerok = true


-- Initialization function
function MainMenu:init()
	self.font = fonts.arialroundedSmall
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
	
	local difTextBox = TextField.new(self.font, "Difficulty:")
	difTextBox:setTextColor(0x000000)
	difTextBox:setPosition(0.5*WX - difTextBox:getWidth()/2, 0.5*WY + 60)
	self:addChild(difTextBox)
	local difficulty = 5
	local numTextBox = TextField.new(self.font, tostring(difficulty))
	numTextBox:setTextColor(0x000000)
	numTextBox:setPosition(0.5*WX - numTextBox:getWidth()/2, 0.5*WY + 115)
	self:addChild(numTextBox)
	
	self.decDif = MenuBut.new(textures.minusBut, 40, 40)
	self:addChild(self.decDif)
	self.decDif.bitmap:setPosition(WX/2 - 60, WY/2 + 100)
	self.decDif:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.decDif:hitTestPoint(event.touch.x, event.touch.y) then
			difficulty = difficulty - 1
			if difficulty < 1 then difficulty = 1 end
			self:removeChild(numTextBox)
			numTextBox = TextField.new(self.font, tostring(difficulty))
			numTextBox:setPosition(0.5*WX - numTextBox:getWidth()/2, 0.5*WY + 115)
			self:addChild(numTextBox)
		end
	end)
	
	self.incDif = MenuBut.new(textures.plusBut, 40, 40)
	self:addChild(self.incDif)
	self.incDif.bitmap:setPosition(WX/2 + 60, WY/2 + 100)
	self.incDif:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.incDif:hitTestPoint(event.touch.x, event.touch.y) then
			difficulty = difficulty + 1
			if difficulty > 10 then difficulty = 10 end
			self:removeChild(numTextBox)
			numTextBox = TextField.new(self.font, tostring(difficulty))
			numTextBox:setPosition(0.5*WX - numTextBox:getWidth()/2, 0.5*WY + 115)
			self:addChild(numTextBox)
		end
	end)
	
	self.goBut = MenuBut.new(textures.goBut, 150, 40)
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
	
	self.returnBut = MenuBut.new(textures.returnBut, 150, 40)
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
	
	local classNames = {}
	local i = 1
	for k, v in pairs(classTable) do
		classNames[i] = k
		i = i + 1
	end
	
	local classTextBox = TextField.new(self.font, "Class:")
	classTextBox:setTextColor(0x000000)
	classTextBox:setPosition(0.5*WX - classTextBox:getWidth()/2, 0.5*WY - 20)
	self:addChild(classTextBox)
	local class = "Warrior"
	local selClassTextBox = TextField.new(self.font, class)
	selClassTextBox:setTextColor(0x000000)
	selClassTextBox:setPosition(0.5*WX - selClassTextBox:getWidth()/2, 0.5*WY + 25)
	self:addChild(selClassTextBox)
	local classIndex = 1
	self.prevBut = MenuBut.new(textures.backBut, 40, 40)
	self:addChild(self.prevBut)
	self.prevBut.bitmap:setPosition(WX/2 - 175, WY/2 + 10)
	self.prevBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.prevBut:hitTestPoint(event.touch.x, event.touch.y) then
			classIndex = classIndex - 1
			if classIndex < 1 then classIndex = tablelength(classNames) end
			self:removeChild(selClassTextBox)
			class = classNames[classIndex]
			selClassTextBox = TextField.new(self.font, class)
			selClassTextBox:setPosition(0.5*WX - selClassTextBox:getWidth()/2, 0.5*WY + 25)
			self:addChild(selClassTextBox)
		end
	end)
	self.nextBut = MenuBut.new(textures.forwardBut, 40, 40)
	self:addChild(self.nextBut)
	self.nextBut.bitmap:setPosition(WX/2 + 175, WY/2 + 10)
	self.nextBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.nextBut:hitTestPoint(event.touch.x, event.touch.y) then
			classIndex = classIndex + 1
			if classIndex > tablelength(classNames) then classIndex = 1 end
			self:removeChild(selClassTextBox)
			class = classNames[classIndex]
			selClassTextBox = TextField.new(self.font, class)
			selClassTextBox:setPosition(0.5*WX - selClassTextBox:getWidth()/2, 0.5*WY + 25)
			self:addChild(selClassTextBox)
		end
	end)
	
	self.goBut = MenuBut.new(textures.goBut, 150, 40)
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
				loadArena("arena", difficulty, class)
			end)
		end
	end)
	
	self.returnBut = MenuBut.new(textures.returnBut, 150, 40)
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
	
	self.careerBut = MenuBut.new(textures.careermodeBut, 150, 40)
	self:addChild(self.careerBut)
	self.careerBut.bitmap:setPosition(WX/2, WY/2)
	self.careerBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.careerBut:hitTestPoint(event.touch.x, event.touch.y) then
			print("Career Mode to Come!")
		end
	end)
	
	self.arenaBut = MenuBut.new(textures.arenaBut, 150, 40)
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
	
	self.survivalBut = MenuBut.new(textures.survivalmodeBut, 150, 40)
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
	
	self.classicBut = MenuBut.new(textures.classicmodeBut, 150, 40)
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
	
	self.exitBut = MenuBut.new(textures.exitBut, 150, 40)
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