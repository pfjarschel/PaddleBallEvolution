------------------------------------
-- Class for Pre-Loading Textures --
------------------------------------

TextureLoaderNormalModes = Core.class()

-- Load a bunch of textures and sets them to variables --
function TextureLoaderNormalModes:init()
	self.menuBut = Texture.new("imgs/buttons/menuBut.png", true)
	self.menuBut1 = Texture.new("imgs/buttons/menuBut1.png", true)
	
	self.controlarrows = Texture.new("imgs/buttons/controlarrows.png", true)
	
	self.againBut = Texture.new("imgs/buttons/againBut.png", true)
	self.againBut1 = Texture.new("imgs/buttons/againBut1.png", true)
	
	self.restartBut = Texture.new("imgs/buttons/restartBut.png", true)
	self.restartBut1 = Texture.new("imgs/buttons/restartBut1.png", true)
	
	self.returnBut = Texture.new("imgs/buttons/returnBut.png", true)
	self.returnBut1 = Texture.new("imgs/buttons/returnBut1.png", true)
	
	self.exitBut = Texture.new("imgs/buttons/exitBut.png", true)
	self.exitBut1 = Texture.new("imgs/buttons/exitBut1.png", true)
	
	self.pausebg = Texture.new("imgs/backs/pausebg.png", true)
	
	self.paddle2 = Texture.new("imgs/paddle2.png", true)
	
	self.pongbg = Texture.new("imgs/backs/pongbg.png", true)
	
	self.pongball = Texture.new("imgs/pongball.png", true)
	
	self.medal = Texture.new("imgs/misc/medal.png", true)
	
	self.blackmedal = Texture.new("imgs/misc/blackmedal.png", true)

end

