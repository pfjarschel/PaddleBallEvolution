------------------------------------
-- Class for Pre-Loading Textures --
------------------------------------

TextureLoaderArenaMode = Core.class()

-- Load a bunch of textures and sets them to variables --
function TextureLoaderArenaMode:init()
	self.menuBut = Texture.new("imgs/buttons/menuBut.png", true)
	self.menuBut1 = Texture.new("imgs/buttons/menuBut1.png", true)
	
	self.skillBut = Texture.new("imgs/buttons/skillBut.png", true)
	self.skillBut1 = Texture.new("imgs/buttons/skillBut1.png", true)
	
	self.plusBut = Texture.new("imgs/buttons/plusBut.png", true)
	self.plusBut1 = Texture.new("imgs/buttons/plusBut1.png", true)
	
	self.minusBut = Texture.new("imgs/buttons/minusBut.png", true)
	self.minusBut1 = Texture.new("imgs/buttons/minusBut1.png", true)
	
	self.controlarrows = Texture.new("imgs/buttons/controlarrows.png", true)
	
	self.againBut = Texture.new("imgs/buttons/againBut.png", true)
	self.againBut1 = Texture.new("imgs/buttons/againBut1.png", true)
	
	self.restartBut = Texture.new("imgs/buttons/restartBut.png", true)
	self.restartBut1 = Texture.new("imgs/buttons/restartBut1.png", true)
	
	self.returnBut = Texture.new("imgs/buttons/returnBut.png", true)
	self.returnBut1 = Texture.new("imgs/buttons/returnBut1.png", true)
	
	self.exitBut = Texture.new("imgs/buttons/exitBut.png", true)
	self.exitBut1 = Texture.new("imgs/buttons/exitBut1.png", true)
	
	self.nextBut = Texture.new("imgs/buttons/nextBut.png", true)
	self.nextBut1 = Texture.new("imgs/buttons/nextBut1.png", true)
	
	self.pausebg = Texture.new("imgs/backs/pausebg.png", true)
	
	self.paddle2 = Texture.new("imgs/paddle2.png", true)
	
	self.pongbg = Texture.new("imgs/backs/pongbg.png", true)
	
	self.black = Texture.new("imgs/backs/black.png", true)
	
	self.bluesmoke = Texture.new("imgs/backs/bluesmoke.png", true)
	
	self.pongball = Texture.new("imgs/pongball.png", true)
	
	self.medal = Texture.new("imgs/misc/medal.png", true)
	
	self.blackmedal = Texture.new("imgs/misc/blackmedal.png", true)
	
	self.trophy= Texture.new("imgs/misc/trophy.png", true)
	
	self.gfx_freeze = Texture.new("imgs/gfx/freeze.png", true)
	self.gfx_viscousfield = Texture.new("imgs/gfx/viscousfield.png", true)
	self.gfx_puff = Texture.new("imgs/gfx/puff.png", true)
	self.gfx_arrow = Texture.new("imgs/gfx/arrow.png", true)
	self.gfx_mirror = Texture.new("imgs/gfx/mirror.png", true)
	self.gfx_star = Texture.new("imgs/gfx/star.png", true)
	self.gfx_tractorbeam = Texture.new("imgs/gfx/tractorbeam.png", true)
	self.gfx_flame = Texture.new("imgs/gfx/flame.png", true)
	self.gfx_fireball = Texture.new("imgs/gfx/fireball.png", true)
	self.gfx_target = Texture.new("imgs/gfx/target.png", true)
	self.gfx_bite = Texture.new("imgs/gfx/bite.png", true)
end

