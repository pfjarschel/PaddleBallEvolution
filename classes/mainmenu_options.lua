--------------------------------------------
-- Class for the Main Menu - Options --
--------------------------------------------

MainMenu_Options = Core.class(Sprite)

-- Declarations --
MainMenu_Options.font = nil

-- Handles Keys --
local function onKeyDown(event)
	if event.keyCode == 301 then
		if optionsTable["SFX"] == "On" then sounds.sel3:play() end
		
		local optionsFile = io.open("|D|options.txt", "w+")
		for k, v in pairs(optionsTable) do 
			optionsFile:write(k.."="..v.."\n")
		end	
		
		sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
	end
end

-- Initialization --
function MainMenu_Options:init()
	self.font = fonts.anitaSmall
	
	local menubg = Bitmap.new(textures.mainmenubg)
	menubg:setScale(1, 1)
	local textureW = menubg:getWidth()
	local textureH = menubg:getHeight()
	menubg:setScale(WX/textureW, WY/textureH)
	self:addChild(menubg)
	
	local xCenter = WX/4 - 16

	-----------------------
	-- Control Selection --
	-----------------------
	local controlTextBox = TextField.new(self.font, "Control Mode:")
	controlTextBox:setTextColor(0xffffff)
	controlTextBox:setPosition(xCenter + 32, 0.5*WY - 10)
	self:addChild(controlTextBox)
	local selcontrolTextBox = TextField.new(self.font, optionsTable["ControlMode"])
	selcontrolTextBox:setTextColor(0xffffff)
	selcontrolTextBox:setPosition(xCenter + 32 + controlTextBox:getWidth() + 16, 0.5*WY - 10)
	self:addChild(selcontrolTextBox)
	
	self.incControl = MenuBut.new(40, 40, textures.forwardBut, textures.forwardBut1)
	self:addChild(self.incControl)
	self.incControl.bitmap:setPosition(xCenter + 16 + 32 + controlTextBox:getWidth() + 16 + selcontrolTextBox:getWidth() + 64, WY/2 - 15)
	self.incControl:addEventListener(Event.TOUCHES_END, function(event)
		if self.incControl:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["ControlMode"] == "Touch" then
				optionsTable["ControlMode"] = "Tilt"
			elseif optionsTable["ControlMode"] == "Tilt" then
				optionsTable["ControlMode"] = "Keys"
			elseif optionsTable["ControlMode"] == "Keys" then
				optionsTable["ControlMode"] = "Touch"
			end
			self:removeChild(selcontrolTextBox)
			selcontrolTextBox = TextField.new(self.font, optionsTable["ControlMode"])
			selcontrolTextBox:setTextColor(0xffffff)
			selcontrolTextBox:setPosition(xCenter + 32 + controlTextBox:getWidth() + 16, 0.5*WY - 10)
			self:addChild(selcontrolTextBox)
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	-----------------------
	-- SFX Selection --
	-----------------------
	local sfxTextBox = TextField.new(self.font, "SFX:")
	sfxTextBox:setTextColor(0xffffff)
	sfxTextBox:setPosition(xCenter + 32, 0.5*WY + 45)
	self:addChild(sfxTextBox)
	local selsfxTextBox = TextField.new(self.font, optionsTable["SFX"])
	selsfxTextBox:setTextColor(0xffffff)
	selsfxTextBox:setPosition(xCenter + 32 + controlTextBox:getWidth() + 16, 0.5*WY + 45)
	self:addChild(selsfxTextBox)
	
	self.incSFX = MenuBut.new(40, 40, textures.forwardBut, textures.forwardBut1)
	self:addChild(self.incSFX)
	self.incSFX.bitmap:setPosition(xCenter + 16 + 32 + controlTextBox:getWidth() + 16 + selcontrolTextBox:getWidth() + 64, WY/2 + 35)
	self.incSFX:addEventListener(Event.TOUCHES_END, function(event)
		if self.incSFX:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then
				optionsTable["SFX"] = "Off"
			elseif optionsTable["SFX"] == "Off" then
				optionsTable["SFX"] = "On"
			end
			
			self:removeChild(selsfxTextBox)
			selsfxTextBox = TextField.new(self.font, optionsTable["SFX"])
			selsfxTextBox:setTextColor(0xffffff)
			selsfxTextBox:setPosition(xCenter + 32 + controlTextBox:getWidth() + 16, 0.5*WY + 45)
			self:addChild(selsfxTextBox)
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	-----------------------
	-- Music Selection --
	-----------------------
	local musicTextBox = TextField.new(self.font, "Music:")
	musicTextBox:setTextColor(0xffffff)
	musicTextBox:setPosition(xCenter + 32, 0.5*WY + 95)
	self:addChild(musicTextBox)
	local selmusicTextBox = TextField.new(self.font, optionsTable["Music"])
	selmusicTextBox:setTextColor(0xffffff)
	selmusicTextBox:setPosition(xCenter + 32 + controlTextBox:getWidth() + 16, 0.5*WY + 95)
	self:addChild(selmusicTextBox)
	
	self.incMusic = MenuBut.new(40, 40, textures.forwardBut, textures.forwardBut1)
	self:addChild(self.incMusic)
	self.incMusic.bitmap:setPosition(xCenter + 16 + 32 + controlTextBox:getWidth() + 16 + selcontrolTextBox:getWidth() + 64, WY/2 + 85)
	self.incMusic:addEventListener(Event.TOUCHES_END, function(event)
		if self.incMusic:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["Music"] == "On" then
				optionsTable["Music"] = "Off"
				currSong:stop()
			elseif optionsTable["Music"] == "Off" then
				optionsTable["Music"] = "On"
				currSong = musics.intro:play(0, true, false)
			end
			self:removeChild(selmusicTextBox)
			selmusicTextBox = TextField.new(self.font, optionsTable["Music"])
			selmusicTextBox:setTextColor(0xffffff)
			selmusicTextBox:setPosition(xCenter + 32 + controlTextBox:getWidth() + 16, 0.5*WY + 95)
			self:addChild(selmusicTextBox)
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	--------------------
	-- Side Selection --
	--------------------
	local sideTextBox = TextField.new(self.font, "Arena Side:")
	sideTextBox:setTextColor(0xffffff)
	sideTextBox:setPosition(xCenter + 32, 0.5*WY + 145)
	self:addChild(sideTextBox)
	local selsideTextBox = TextField.new(self.font, optionsTable["ArenaSide"])
	selsideTextBox:setTextColor(0xffffff)
	selsideTextBox:setPosition(xCenter + 32 + controlTextBox:getWidth() + 16, 0.5*WY + 145)
	self:addChild(selsideTextBox)
	
	self.incSide = MenuBut.new(40, 40, textures.forwardBut, textures.forwardBut1)
	self:addChild(self.incSide)
	self.incSide.bitmap:setPosition(xCenter + 16 + 32 + controlTextBox:getWidth() + 16 + selcontrolTextBox:getWidth() + 64, WY/2 + 135)
	self.incSide:addEventListener(Event.TOUCHES_END, function(event)
		if self.incSide:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["ArenaSide"] == "Left" then
				optionsTable["ArenaSide"] = "Right"
			elseif optionsTable["ArenaSide"] == "Right" then
				optionsTable["ArenaSide"] = "Left"
			end
			self:removeChild(selsideTextBox)
			selsideTextBox = TextField.new(self.font, optionsTable["ArenaSide"])
			selsideTextBox:setTextColor(0xffffff)
			selsideTextBox:setPosition(xCenter + 32 + controlTextBox:getWidth() + 16, 0.5*WY + 145)
			self:addChild(selsideTextBox)
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	-----------------
	-- Options End --
	-----------------
	self.returnBut = MenuBut.new(150, 40, textures.returnBut, textures.returnBut1)
	self:addChild(self.returnBut)
	self.returnBut.bitmap:setPosition(self.returnBut:getWidth()/2 + 10, WY/2 + 210)
	self.returnBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.returnBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel3:play() end
			
			local optionsFile = io.open("|D|options.txt", "w+")
			for k, v in pairs(optionsTable) do 
				optionsFile:write(k.."="..v.."\n")
			end	
			
			sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
		end
	end)
	
	-- Listen to Keys --
	self:addEventListener(Event.KEY_DOWN, onKeyDown)
end