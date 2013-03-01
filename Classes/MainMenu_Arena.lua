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
	local i = 1
	for k, v in pairs(classTable) do
		classNames[i] = k
		i = i + 1
	end
	
	-- Class Selection --
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
		if self.goBut:hitTestPoint(event.touch.x, event.touch.y) then
			sceneMan:changeScene("arena", transTime, SceneManager.fade, easing.linear, { userData = {difficulty, class} }) 
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