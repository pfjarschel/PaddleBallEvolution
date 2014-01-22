---------------------------------
-- Class for the Splash Screen --
---------------------------------

Splash = Core.class(Sprite)

-- Initialization --
function Splash:init()
	gc()
	
	self.font = fonts.arialroundedSmall
	local bg = Bitmap.new(textures.splash)
	bg:setScale(1, 1)
	self:addChild(bg)
	local textureW = bg:getWidth()
	local textureH = bg:getHeight()
	bg:setScale(WX/textureW, WY/textureH)
	
	Timer.delayedCall(2000,  function()
			sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
		end)
end