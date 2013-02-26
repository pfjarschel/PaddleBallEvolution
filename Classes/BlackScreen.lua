----------------------------------------------------------------------
-- Class for a Black Screen, to be used in Scene Manager (App Exit) --
----------------------------------------------------------------------

BlackScreen = Core.class(Sprite)

function BlackScreen:onTransitionInEnd()
	application:exit()
end

-- Initialization function
function BlackScreen:init()
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
end