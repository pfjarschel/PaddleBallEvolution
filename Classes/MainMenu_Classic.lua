--------------------------------------------
-- Class for the Main Menu - Classic Mode --
--------------------------------------------

MainMenu_Classic = Core.class(Sprite)

-- Declarations --
MainMenu_Classic.font = nil

-- Handles Keys --
local function onKeyDown(event)
	if event.keyCode == 301 then
		sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
	end
end

-- Initialization --
function MainMenu_Classic:init()
	self.font = fonts.arialroundedSmall
	
	-- If the same bg as the main menu one is used, weird stuff happens --
	local menubg = textures.mainmenubg2
	menubg:setScale(1, 1)
	local textureW = menubg:getWidth()
	local textureH = menubg:getHeight()
	menubg:setScale(WX/textureW, WY/textureH)
	self:addChild(menubg)

	-- Difficulty Selection --
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
		if self.goBut:hitTestPoint(event.touch.x, event.touch.y) then
			sceneMan:changeScene("classic", transTime, SceneManager.fade, easing.linear, { userData = difficulty }) 
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