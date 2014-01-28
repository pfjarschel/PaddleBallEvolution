--------------------------------
-- Class for the About Screen --
--------------------------------

MainMenu_About = Core.class(Sprite)
MainMenu.songload = nil

-- Handles Keys --
local function onKeyDown(event)
	if event.keyCode == 301 then
		if optionsTable["SFX"] == "On" then sounds.sel3:play() end
		
		sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
	end
end


-- Initialization --
function MainMenu_About:init()	
	self.font = fonts.anitaVerySmall
	self.biggerfont = fonts.anitaMed
	
	if optionsTable["Music"] == "On" then
		if not(currSong == nil) then
			currSong:stop()
		end
		self.songload = nil
		self.songload = Sound.new(musics.credits)
		currSong = nil
		currSong = self.songload:play(0, true, false)
		gc()
	end
	
	local bg = Bitmap.new(textures.mainmenubg)
	self:addChild(bg)
	local textureW = bg:getWidth()
	local textureH = bg:getHeight()
	bg:setScale(WX/textureW, WY/textureH)
	
	local abouttitlestring = "About"
	
	local abouttitle = TextWrap.new(abouttitlestring, WX/2, "center", 5, self.biggerfont)
	abouttitle:setTextColor(0xffffff)
	abouttitle:setPosition(WX/4, WY/2 - 24)
	self:addChild(abouttitle)
	
	local aboutstring = "Made using the great Gideros Studio: www.giderosmobile.com\n \n"..
					"Graphics, some SFX and Programming: Paulo F. Jarschel\n"..
					"Music and SFX: http://freesfx.co.uk/ (Thank you so much!)\n \n"..
					"Special thanks to awesome open-source software: Inkscape, Gimp and Audacity!\n"
	
	local abouttext = TextWrap.new(aboutstring, WX/1.1, "justify", 15, self.font)
	abouttext:setTextColor(0xffffff)
	abouttext:setPosition(WX/2 - abouttext:getWidth()/2, WY/2 + 1.5*abouttitle:getHeight() - 16)
	self:addChild(abouttext)
	
	local copystring = "Black & White Cat Studio, 2014\n"..
						"http://blackandwhitecat.net"
	
	local copytext = TextWrap.new(copystring, WX/2, "right", 10, self.font)
	copytext:setTextColor(0xffffff)
	copytext:setPosition(WX - copytext:getWidth() - 16, WY - copytext:getHeight())
	self:addChild(copytext)
	
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