----------------------------
-- Class for Menu Buttons --
----------------------------

MenuBut = Core.class(Sprite)

-- Declare bitmap and desired dimensions --
MenuBut.bitmap = nil
MenuBut.width = 40
MenuBut.height = 40

-- Initialize according to given bitmap
function MenuBut:init(texture, width, height)
	self.bitmap = texture
	self.width = width
	self.height = height
	self.bitmap:setScale(1, 1) -- Texture loader requires this reinitialization transform (because of passing values by reference)
	self:addChild(self.bitmap)
	local textureW = self.bitmap:getWidth()
	local textureH = self.bitmap:getHeight()
	self.bitmap:setAnchorPoint(0.5, 0.5)
	self.bitmap:setScale(self.width/textureW, self.height/textureH)
end