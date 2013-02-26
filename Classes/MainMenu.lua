-----------------------------
-- Class for the Main Menu --
-----------------------------

MainMenu = Core.class(Sprite)

-- Declarations --
MainMenu.font = nil

-- Initialization --
function MainMenu:init()
	gc()
	
	self.font = fonts.arialroundedSmall
	local menubg = textures.mainmenubg
	menubg:setScale(1, 1)
	self:addChild(menubg)
	local textureW = menubg:getWidth()
	local textureH = menubg:getHeight()
	menubg:setScale(WX/textureW, WY/textureH)
	
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
		if self.arenaBut:hitTestPoint(event.touch.x, event.touch.y) then
			sceneMan:changeScene("mainMenu_Arena", transTime, SceneManager.fade, easing.linear)
		end
	end)
	
	self.survivalBut = MenuBut.new(textures.survivalmodeBut, 150, 40)
	self:addChild(self.survivalBut)
	self.survivalBut.bitmap:setPosition(WX/2, WY/2 + 2*self.survivalBut.height)
	self.survivalBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.survivalBut:hitTestPoint(event.touch.x, event.touch.y) then
			sceneMan:changeScene("survival", transTime, SceneManager.fade, easing.linear, { userData = "5" })
		end
	end)
	
	self.classicBut = MenuBut.new(textures.classicmodeBut, 150, 40)
	self:addChild(self.classicBut)
	self.classicBut.bitmap:setPosition(WX/2, WY/2 + 3*self.classicBut.height)
	self.classicBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.classicBut:hitTestPoint(event.touch.x, event.touch.y) then
			sceneMan:changeScene("mainMenu_Classic", transTime, SceneManager.fade, easing.linear)
		end
	end)
	
	self.exitBut = MenuBut.new(textures.exitBut, 150, 40)
	self:addChild(self.exitBut)
	self.exitBut.bitmap:setPosition(WX/2, WY/2 + 4*self.exitBut.height)
	self.exitBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if self.exitBut:hitTestPoint(event.touch.x, event.touch.y) then
			sceneMan:changeScene("blackScreen", transTime/2, SceneManager.fade, easing.linear)
		end
	end)
end