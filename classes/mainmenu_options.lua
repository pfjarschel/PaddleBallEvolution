--------------------------------------------
-- Class for the Main Menu - Options --
--------------------------------------------

MainMenu_Options = Core.class(Sprite)

-- Declarations --
MainMenu_Options.font = nil

-- Handles Keys --
local function onKeyDown(event)
	if event.keyCode == 301 then
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

	-- Control Selection --
	local controlTextBox = TextField.new(self.font, "Control Mode:")
	controlTextBox:setTextColor(0xffffff)
	controlTextBox:setPosition(32, 0.5*WY + 60)
	self:addChild(controlTextBox)
	local difficulty = 5
	local selcontrolTextBox = TextField.new(self.font, controlMethod)
	selcontrolTextBox:setTextColor(0xffffff)
	selcontrolTextBox:setPosition(32 + controlTextBox:getWidth() + 16, 0.5*WY + 60)
	self:addChild(selcontrolTextBox)
	
	self.incControl = MenuBut.new(40, 40, textures.forwardBut, textures.forwardBut1)
	self:addChild(self.incControl)
	self.incControl.bitmap:setPosition(32 + controlTextBox:getWidth() + 16 + selcontrolTextBox:getWidth() + 64, WY/2 + 50)
	self.incControl:addEventListener(Event.TOUCHES_END, function(event)
		if self.incControl:hitTestPoint(event.touch.x, event.touch.y) then
			if controlMethod == "Touch" then
				controlMethod = "Tilt"
			elseif controlMethod == "Tilt" then
				controlMethod = "Keys"
			elseif controlMethod == "Keys" then
				controlMethod = "Touch"
			end
			self:removeChild(selcontrolTextBox)
			selcontrolTextBox = TextField.new(self.font, controlMethod)
			selcontrolTextBox:setTextColor(0xffffff)
			selcontrolTextBox:setPosition(32 + controlTextBox:getWidth() + 16, 0.5*WY + 60)
			self:addChild(selcontrolTextBox)
		end
	end)
	
	self.returnBut = MenuBut.new(150, 40, textures.returnBut, textures.returnBut1)
	self:addChild(self.returnBut)
	self.returnBut.bitmap:setPosition(self.returnBut:getWidth()/2 + 10, WY/2 + 210)
	self.returnBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.returnBut:hitTestPoint(event.touch.x, event.touch.y) then
			sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
		end
	end)
	
	-- Listen to Keys --
	self:addEventListener(Event.KEY_DOWN, onKeyDown)
end