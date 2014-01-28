----------------------------
-- Class for Menu Buttons --
----------------------------

MenuBut = Core.class(Sprite)

-- Declare bitmap and desired dimensions --
MenuBut.bitmap = nil
MenuBut.width = 40
MenuBut.height = 40

-- Initialize according to given bitmap --
function MenuBut:init(width, height, texture_normal, texture_pressed, texture_disabled)
	
	if texture_disabled == nil then
		self.bitmap = Bitmap.new(texture_normal)
		
		-- Texture loader requires this reinitialization transform (because of passing values by reference) --
		self.bitmap:setScale(1, 1)
		
		self:addChild(self.bitmap)
		local textureW = self.bitmap:getWidth()
		local textureH = self.bitmap:getHeight()
		self.bitmap:setAnchorPoint(0.5, 0.5)
		self.bitmap:setScale(width/textureW, height/textureH)
		
		self:addEventListener(Event.TOUCHES_BEGIN, function(event)
			if self:hitTestPoint(event.touch.x, event.touch.y) then
				self.bitmap:setTexture(texture_pressed)
			end
		end)
		self:addEventListener(Event.TOUCHES_END, function(event)
			self.bitmap:setTexture(texture_normal)
		end)
	else
		self.bitmap = Bitmap.new(texture_disabled)
		
		-- Texture loader requires this reinitialization transform (because of passing values by reference) --
		self.bitmap:setScale(1, 1)
		
		self:addChild(self.bitmap)
		local textureW = self.bitmap:getWidth()
		local textureH = self.bitmap:getHeight()
		self.bitmap:setAnchorPoint(0.5, 0.5)
		self.bitmap:setScale(width/textureW, height/textureH)
	end
end