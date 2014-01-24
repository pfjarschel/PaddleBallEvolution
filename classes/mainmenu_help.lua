--------------------------------
-- Class for the Help Screens --
--------------------------------

MainMenu_Help = Core.class(Sprite)
MainMenu_Help.page = 1;
local pages = 5

-- Initialization --
function MainMenu_Help:init()	
	self.font = fonts.anitaSmall
	self.biggerfont = fonts.anitaMed
	
	local bgs = {}
	bgs[1] = Bitmap.new(textures.black)
	bgs[1]:setScale(1, 1)
	self:addChild(bgs[1])
	local textureW = bgs[1]:getWidth()
	local textureH = bgs[1]:getHeight()
	bgs[1]:setScale(WX/textureW, WY/textureH)
	bgs[2] = Bitmap.new(textures.black)
	bgs[3] = Bitmap.new(textures.interface)
	bgs[4] = Bitmap.new(textures.black)
	bgs[5] = Bitmap.new(textures.black)
	
	local helptitles = {}
	local helpstrings = {}
	
	helptitles[1] = "Game Modes"
	helptitles[2] = "Game Modes"
	helptitles[3] = ""
	helptitles[4] = "Controls"
	helptitles[5] = "Game Mechanics"
	
	local helptitle = TextWrap.new(helptitles[1], WX/2, "center", 5, self.biggerfont)
	helptitle:setTextColor(0xffffff)
	helptitle:setPosition(WX/4, 16 + helptitle:getHeight())
	self:addChild(helptitle)
	
	helpstrings[1] = "Classic: This is the classic Ping Pong arcade game! Simply defend your goal and try to send the ball to the opponent's side, can't get much simpler than this.\n \n \n \n"..
					"Career: Start low and join tournaments around the whole universe to become the ultimate PaddleBall Player! (Only in Full Version)\n"
	helpstrings[2] = "Survival: Very easy in the beggining, but how many rounds can you survive with increasing difficulty?\n \n \n \n"..
					"Arena: Select one from many different classes, each with its own attributes and special skill! (More classes in the Full Version)\n"
	helpstrings[3] = ""
	helpstrings[4] = "You can use the touch conrol area to move your paddle up and down, if you prefer touch controls. "..
					"Alternatively, you can set in the options page two other control methods:\n \n \n \n"..
					"Tilt: Tilt your device and the paddle moves accordingly.\n \n"..
					"Keys: If your device has hardware keys, you can use the Up and Down buttons for movement, and Y to activate the special skill. \n"
	helpstrings[5] = "There are 5 attributes that influence gameplay: \n \n \n \n"..
					"Attack (Atk): Strength of your ball return.\n \n"..
					"Movement (Mov): How fast your paddle moves. \n \n"..
					"Life (Lif): Goals you can take (Arena only). \n \n"..
					"Skill (Skl): Number of special ability uses. \n \n"..
					"Defense (Def): Your paddle size. \n \n \n \n"..
					"Difficulty also affects ball and movement speed.\n"
	
	local helptext = TextWrap.new(helpstrings[1], WX/1.1, "left", 10, self.font)
	helptext:setTextColor(0xffffff)
	helptext:setPosition(WX/2 - helptext:getWidth()/2, 16 + 3*helptitle:getHeight())
	self:addChild(helptext)
	
	self.prevBut = MenuBut.new(40, 40, textures.backBut, textures.backBut1)
	self:addChild(self.prevBut)
	self.prevBut.bitmap:setPosition(WX - self.prevBut:getWidth()*3, WY/2 + 210)
	self.prevBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.prevBut:hitTestPoint(event.touch.x, event.touch.y) then
			self:removeChild(bgs[self.page])
			self:removeChild(helptitle)
			self:removeChild(helptext)
			self:removeChild(self.nextBut)
			self:removeChild(self.prevBut)
			self:removeChild(self.returnBut)
			
			self.page = self.page - 1
			if self.page < 1 then
				self.page = pages
			end
			
			helptitle:setText(helptitles[self.page])
			helptext:setText(helpstrings[self.page])
			
			bgs[self.page]:setScale(1, 1)
			self:addChild(bgs[self.page])
			local textureW = bgs[self.page]:getWidth()
			local textureH = bgs[self.page]:getHeight()
			bgs[self.page]:setScale(WX/textureW, WY/textureH)
			
			self:addChild(helptitle)
			self:addChild(helptext)
			self:addChild(self.nextBut)
			self:addChild(self.prevBut)
			self:addChild(self.returnBut)
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	self.nextBut = MenuBut.new(40, 40, textures.forwardBut, textures.forwardBut1)
	self:addChild(self.nextBut)
	self.nextBut.bitmap:setPosition(WX - self.nextBut:getWidth(), WY/2 + 210)
	self.nextBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.nextBut:hitTestPoint(event.touch.x, event.touch.y) then
			self:removeChild(bgs[self.page])
			self:removeChild(helptitle)
			self:removeChild(helptext)
			self:removeChild(self.nextBut)
			self:removeChild(self.prevBut)
			self:removeChild(self.returnBut)
			
			self.page = self.page + 1
			if self.page > pages then
				self.page = 1
			end
			
			helptitle:setText(helptitles[self.page])
			helptext:setText(helpstrings[self.page])
			
			bgs[self.page]:setScale(1, 1)
			self:addChild(bgs[self.page])
			local textureW = bgs[self.page]:getWidth()
			local textureH = bgs[self.page]:getHeight()
			bgs[self.page]:setScale(WX/textureW, WY/textureH)
			
			self:addChild(helptitle)
			self:addChild(helptext)
			self:addChild(self.nextBut)
			self:addChild(self.prevBut)
			self:addChild(self.returnBut)
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	self.returnBut = MenuBut.new(150, 40, textures.returnBut, textures.returnBut1)
	self:addChild(self.returnBut)
	self.returnBut.bitmap:setPosition(self.returnBut:getWidth()/2 + 10, WY/2 + 210)
	self.returnBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.returnBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel3:play() end
		
			sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
		end
	end)
end