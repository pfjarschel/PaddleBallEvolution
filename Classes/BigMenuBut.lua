----------------------------------
-- Class for Menu Buttons (Big) --
----------------------------------

BigMenuBut = Core.class(Sprite)
BigMenuBut.bitmap = nil
BigMenuBut.width = 150
BigMenuBut.height = 45

-- Initialize according to given bitmap
function BigMenuBut:init(texture)
	self.bitmap = texture
	self.bitmap:setScale(1, 1)
	self:addChild(self.bitmap)
	local textureW = self.bitmap:getWidth()
	local textureH = self.bitmap:getHeight()
	self.bitmap:setAnchorPoint(0.5, 0.5)
	self.bitmap:setScale(self.width/textureW, self.height/textureH)
end