----------------------------------
-- Class for Menu Buttons (Small) --
----------------------------------

SmallMenuBut = Core.class(Sprite)
SmallMenuBut.bitmap = nil
SmallMenuBut.width = 40
SmallMenuBut.height = 40

-- Initialize according to given bitmap
function SmallMenuBut:init(texture)
	self.bitmap = texture
	self.bitmap:setScale(1, 1)
	self:addChild(self.bitmap)
	local textureW = self.bitmap:getWidth()
	local textureH = self.bitmap:getHeight()
	self.bitmap:setAnchorPoint(0.5, 0.5)
	self.bitmap:setScale(self.width/textureW, self.height/textureH)
end