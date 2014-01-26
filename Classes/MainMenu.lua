-----------------------------
-- Class for the Main Menu --
-----------------------------

MainMenu = Core.class(Sprite)

-- Declarations --
MainMenu.font = nil
MainMenu.songload = nil

-- Handles Keys --
local function onKeyDown(event)
	if event.keyCode == 301 then
		sceneMan:changeScene("blackScreen", transTime/2, SceneManager.fade, easing.linear)
	end
end

-- Initialization --
function MainMenu:init()
	textures = nil
	textures = TextureLoaderMenu.new()
	sounds = nil
	sounds = SoundLoaderMenu.new()
	musics = nil
	musics = MusicLoaderMenu.new()
	gc()
	
	WX = WX0
	XShift = 0
	if optionsTable["Music"] == "On" then
		if not(currSong == nil) then
			currSong:stop()
		end
		self.songload = nil
		self.songload = Sound.new(musics.intro)
		currSong = nil
		currSong = self.songload:play(0, true, false)
		gc()
	end
	
	self.font = fonts.anitaVerySmall
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
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			sceneMan:changeScene("mainMenu_Career", transTime, SceneManager.fade, easing.linear)
		end
	end)
	
	-- Career Mode to Come Text --
	local careerTextBox = TextField.new(self.font, "Career mode to come! (Paid)")
	careerTextBox:setTextColor(0xffffff)
	careerTextBox:setPosition(0.5*WX + careerTextBox:getWidth()/2 - 32, 0.5*WY + 6)
	--self:addChild(careerTextBox)
	
	self.arenaBut = MenuBut.new(150, 40, textures.arenaBut, textures.arenaBut1)
	self:addChild(self.arenaBut)
	self.arenaBut.bitmap:setPosition(WX/2, WY/2 + 1.2*self.arenaBut.height)
	self.arenaBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.arenaBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			
			sceneMan:changeScene("mainMenu_Arena", transTime, SceneManager.fade, easing.linear)
		end
	end)
	
	self.survivalBut = MenuBut.new(150, 40, textures.survivalmodeBut, textures.survivalmodeBut1)
	self:addChild(self.survivalBut)
	self.survivalBut.bitmap:setPosition(WX/2, WY/2 + 2.4*self.survivalBut.height)
	self.survivalBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.survivalBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			
			sceneMan:changeScene("survival", transTime, SceneManager.fade, easing.linear, { userData = "5" })
		end
	end)
	
	self.classicBut = MenuBut.new(150, 40, textures.classicmodeBut, textures.classicmodeBut1)
	self:addChild(self.classicBut)
	self.classicBut.bitmap:setPosition(WX/2, WY/2 + 3.6*self.classicBut.height)
	self.classicBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.classicBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			
			sceneMan:changeScene("mainMenu_Classic", transTime, SceneManager.fade, easing.linear)
		end
	end)
	
	self.optionsBut = MenuBut.new(40, 40, textures.optionsBut, textures.optionsBut1)
	self:addChild(self.optionsBut)
	self.optionsBut.bitmap:setPosition(52 + 80 + 32, WY/2 + 5*self.optionsBut.height)
	self.optionsBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.optionsBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			
			sceneMan:changeScene("mainMenu_Options", transTime, SceneManager.fade, easing.linear)
		end
	end)
	
	self.aboutBut = MenuBut.new(40, 40, textures.aboutBut, textures.aboutBut1)
	self:addChild(self.aboutBut)
	self.aboutBut.bitmap:setPosition(52, WY/2 + 5*self.aboutBut.height)
	self.aboutBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.aboutBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			
			sceneMan:changeScene("mainMenu_About", transTime, SceneManager.fade, easing.linear)
		end
	end)
	
	self.helpBut = MenuBut.new(40, 40, textures.helpBut, textures.helpBut1)
	self:addChild(self.helpBut)
	self.helpBut.bitmap:setPosition(52 + 40 + 16, WY/2 + 5*self.helpBut.height)
	self.helpBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.helpBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			
			sceneMan:changeScene("mainMenu_Help", transTime, SceneManager.fade, easing.linear)
		end
	end)
	
	self.exitBut = MenuBut.new(150, 40, textures.exitBut, textures.exitBut1)
	self:addChild(self.exitBut)
	self.exitBut.bitmap:setPosition(WX - 32 - self.exitBut:getWidth()/2, WY/2 + 5*self.exitBut.height)
	self.exitBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.exitBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel3:play() end
			
			sceneMan:changeScene("blackScreen", transTime/2, SceneManager.fade, easing.linear)
		end
	end)
	
	-- Listen to Keys --
	self:addEventListener(Event.KEY_DOWN, onKeyDown)
end