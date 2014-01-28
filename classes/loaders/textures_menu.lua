------------------------------------
-- Class for Pre-Loading Textures --
------------------------------------

TextureLoaderMenu = Core.class()

-- Load a bunch of textures and sets them to variables --
function TextureLoaderMenu:init()
	
	self.returnBut = Texture.new("imgs/buttons/returnBut.png", true)
	self.returnBut1 = Texture.new("imgs/buttons/returnBut1.png", true)
	
	self.goBut = Texture.new("imgs/buttons/goBut.png", true)
	self.goBut1 = Texture.new("imgs/buttons/goBut1.png", true)
	
	self.backBut = Texture.new("imgs/buttons/backBut.png", true)
	self.backBut1 = Texture.new("imgs/buttons/backBut1.png", true)
	
	self.forwardBut = Texture.new("imgs/buttons/forwardBut.png", true)
	self.forwardBut1 = Texture.new("imgs/buttons/forwardBut1.png", true)
	
	self.plusBut = Texture.new("imgs/buttons/plusBut.png", true)
	self.plusBut1 = Texture.new("imgs/buttons/plusBut1.png", true)
	
	self.minusBut = Texture.new("imgs/buttons/minusBut.png", true)
	self.minusBut1 = Texture.new("imgs/buttons/minusBut1.png", true)
	
	self.survivalmodeBut = Texture.new("imgs/buttons/survivalmodeBut.png", true)
	self.survivalmodeBut1 = Texture.new("imgs/buttons/survivalmodeBut1.png", true)
	
	self.exitBut = Texture.new("imgs/buttons/exitBut.png", true)
	self.exitBut1 = Texture.new("imgs/buttons/exitBut1.png", true)
	
	self.classicmodeBut = Texture.new("imgs/buttons/classicmodeBut.png", true)
	self.classicmodeBut1 = Texture.new("imgs/buttons/classicmodeBut1.png", true)
	
	self.careermodeBut = Texture.new("imgs/buttons/careermodeBut.png", true)
	self.careermodeBut1 = Texture.new("imgs/buttons/careermodeBut1.png", true)
	
	self.arenaBut = Texture.new("imgs/buttons/arenamodeBut.png", true)
	self.arenaBut1 = Texture.new("imgs/buttons/arenamodeBut1.png", true)
	
	self.optionsBut = Texture.new("imgs/buttons/gear.png", true)
	self.optionsBut1 = Texture.new("imgs/buttons/gear1.png", true)
	
	self.helpBut = Texture.new("imgs/buttons/help.png", true)
	self.helpBut1 = Texture.new("imgs/buttons/help1.png", true)
	
	self.aboutBut = Texture.new("imgs/buttons/about.png", true)
	self.aboutBut1 = Texture.new("imgs/buttons/about1.png", true)
	
	self.mainmenubg = Texture.new("imgs/backs/mainmenubg.png", true)
	
	self.splash = Texture.new("imgs/backs/splash.png", true)
	
	self.black = Texture.new("imgs/backs/black.png", true)
	
	self.interface = Texture.new("imgs/backs/interface.png", true)
	
end

