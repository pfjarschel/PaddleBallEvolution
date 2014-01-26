------------------------------------
-- Class for Pre-Loading Textures --
------------------------------------

TextureLoaderNormalModes = Core.class()

-- Load a bunch of textures and sets them to variables --
function TextureLoaderNormalModes:init()
	self.menuBut = Texture.new("imgs/buttons/menuBut.png")
	self.menuBut1 = Texture.new("imgs/buttons/menuBut1.png")
	
	self.controlarrows = Texture.new("imgs/buttons/controlarrows.png")
	
	self.againBut = Texture.new("imgs/buttons/againBut.png")
	self.againBut1 = Texture.new("imgs/buttons/againBut1.png")
	
	self.restartBut = Texture.new("imgs/buttons/restartBut.png")
	self.restartBut1 = Texture.new("imgs/buttons/restartBut1.png")
	
	self.returnBut = Texture.new("imgs/buttons/returnBut.png")
	self.returnBut1 = Texture.new("imgs/buttons/returnBut1.png")
	
	self.exitBut = Texture.new("imgs/buttons/exitBut.png")
	self.exitBut1 = Texture.new("imgs/buttons/exitBut1.png")
	
	self.pausebg = Texture.new("imgs/backs/pausebg.png")
	
	self.paddle2 = Texture.new("imgs/paddle2.png")
	
	self.pongbg = Texture.new("imgs/backs/pongbg.png")
	
	self.pongball = Texture.new("imgs/pongball.png")

end

