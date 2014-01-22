-----------------------------
-- Class for the Main Menu --
-----------------------------

MainMenu = Core.class(Sprite)

-- Declarations --
MainMenu.font = nil

-- Handles Keys --
local function onKeyDown(event)
	if event.keyCode == 301 then
		sceneMan:changeScene("blackScreen", transTime/2, SceneManager.fade, easing.linear)
	end
end

-- Initialization --
function MainMenu:init()
	gc()
	
	self.font = fonts.arialroundedSmall
	local menubg = Bitmap.new(textures.mainmenubg)
	menubg:setScale(1, 1)
	self:addChild(menubg)
	local textureW = menubg:getWidth()
	local textureH = menubg:getHeight()
	menubg:setScale(WX/textureW, WY/textureH)
	
	self.careerBut = MenuBut.new(150, 40, textures.careermodeBut, textures.careermodeBut1)
	self:addChild(self.careerBut)
	self.careerBut.bitmap:setPosition(WX/2, WY/2)
	self.careerBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.careerBut:hitTestPoint(event.touch.x, event.touch.y) then
			print("Career Mode to Come!")
		end
	end)
	
	self.arenaBut = MenuBut.new(150, 40, textures.arenaBut, textures.arenaBut1)
	self:addChild(self.arenaBut)
	self.arenaBut.bitmap:setPosition(WX/2, WY/2 + 1.2*self.arenaBut.height)
	self.arenaBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.arenaBut:hitTestPoint(event.touch.x, event.touch.y) then
			sceneMan:changeScene("mainMenu_Arena", transTime, SceneManager.fade, easing.linear)
		end
	end)
	
	self.survivalBut = MenuBut.new(150, 40, textures.survivalmodeBut, textures.survivalmodeBut1)
	self:addChild(self.survivalBut)
	self.survivalBut.bitmap:setPosition(WX/2, WY/2 + 2.4*self.survivalBut.height)
	self.survivalBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.survivalBut:hitTestPoint(event.touch.x, event.touch.y) then
			sceneMan:changeScene("survival", transTime, SceneManager.fade, easing.linear, { userData = "5" })
		end
	end)
	
	self.classicBut = MenuBut.new(150, 40, textures.classicmodeBut, textures.classicmodeBut1)
	self:addChild(self.classicBut)
	self.classicBut.bitmap:setPosition(WX/2, WY/2 + 3.6*self.classicBut.height)
	self.classicBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.classicBut:hitTestPoint(event.touch.x, event.touch.y) then
			sceneMan:changeScene("mainMenu_Classic", transTime, SceneManager.fade, easing.linear)
		end
	end)
	
	self.optionsBut = MenuBut.new(40, 40, textures.optionsBut, textures.optionsBut1)
	self:addChild(self.optionsBut)
	self.optionsBut.bitmap:setPosition(52 + 40 + 16, WY/2 + 5*self.optionsBut.height)
	self.optionsBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.optionsBut:hitTestPoint(event.touch.x, event.touch.y) then
			sceneMan:changeScene("mainMenu_Options", transTime, SceneManager.fade, easing.linear)
		end
	end)
	
	self.helpBut = MenuBut.new(40, 40, textures.helpBut, textures.helpBut1)
	self:addChild(self.helpBut)
	self.helpBut.bitmap:setPosition(52, WY/2 + 5*self.helpBut.height)
	self.helpBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.helpBut:hitTestPoint(event.touch.x, event.touch.y) then
			sceneMan:changeScene("mainMenu_Help", transTime, SceneManager.fade, easing.linear)
		end
	end)
	
	self.exitBut = MenuBut.new(150, 40, textures.exitBut, textures.exitBut1)
	self:addChild(self.exitBut)
	self.exitBut.bitmap:setPosition(WX - 32 - self.exitBut:getWidth()/2, WY/2 + 5*self.exitBut.height)
	self.exitBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.exitBut:hitTestPoint(event.touch.x, event.touch.y) then
			sceneMan:changeScene("blackScreen", transTime/2, SceneManager.fade, easing.linear)
		end
	end)
	
	-- Listen to Keys --
	self:addEventListener(Event.KEY_DOWN, onKeyDown)
end