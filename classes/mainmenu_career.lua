----------------------------------
-- Class for the Career Screen --
----------------------------------

MainMenu_Career = Core.class(Sprite)

-- Handles Keys --
local function onKeyDown(event)
	if event.keyCode == 301 then
		if optionsTable["SFX"] == "On" then sounds.sel3:play() end
		
		sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
	end
end


-- Initialization --
function MainMenu_Career:init()	
	self.font = fonts.anitaVerySmall
	self.biggerfont = fonts.anitaMed
	
	local bg = Bitmap.new(textures.mainmenubg)
	self:addChild(bg)
	local textureW = bg:getWidth()
	local textureH = bg:getHeight()
	bg:setScale(WX/textureW, WY/textureH)
	
	local careertitlestring = "Career Mode Info"
	
	local careertitle = TextWrap.new(careertitlestring, WX/2, "center", 5, self.biggerfont)
	careertitle:setTextColor(0xffffff)
	careertitle:setPosition(WX/4, WY/2 - 24)
	self:addChild(careertitle)
	
	local careerstring = "Don't Worry, Career Mode will be available in the coming months!\n \n"..
					"In this mode, you will start with a basic character, and progress through various tournaments in different locations, while "..
					"improving your stats by leveling up and acquiring special skills from defeated enemies.\n"..
					"It will be available in the paid version only, which has not yet been released. When it does, you will receive the information in the update to follow.\n"
	
	local careertext = TextWrap.new(careerstring, WX/1.1, "justify", 10, self.font)
	careertext:setTextColor(0xffffff)
	careertext:setPosition(WX/2 - careertext:getWidth()/2, WY/2 + 1.5*careertitle:getHeight() - 24)
	self:addChild(careertext)
	
	self.returnBut = MenuBut.new(150, 40, textures.returnBut, textures.returnBut1)
	self:addChild(self.returnBut)
	self.returnBut.bitmap:setPosition(self.returnBut:getWidth()/2 + 10, WY/2 + 210)
	self.returnBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.returnBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel3:play() end
		
			sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
		end
	end)
	
	-- Listen to Keys --
	self:addEventListener(Event.KEY_DOWN, onKeyDown)
end