------------------------------------
-- Class for Pre-Loading Textures --
------------------------------------

TextureLoaderArenaMode = Core.class()

-- Load a bunch of textures and sets them to variables --
function TextureLoaderArenaMode:init()
	self.menuBut = Texture.new("imgs/buttons/menuBut.png")
	self.menuBut1 = Texture.new("imgs/buttons/menuBut1.png")
	
	self.skillBut = Texture.new("imgs/buttons/skillBut.png")
	self.skillBut1 = Texture.new("imgs/buttons/skillBut1.png")
	
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
	
	self.gfx_freeze = Texture.new("imgs/gfx/freeze.png")
	self.gfx_viscousfield = Texture.new("imgs/gfx/viscousfield.png")
	self.gfx_puff = Texture.new("imgs/gfx/puff.png")
	self.gfx_arrow = Texture.new("imgs/gfx/arrow.png")
	self.gfx_mirror = Texture.new("imgs/gfx/mirror.png")
	self.gfx_star = Texture.new("imgs/gfx/star.png")
	self.gfx_tractorbeam = Texture.new("imgs/gfx/tractorbeam.png")
end

