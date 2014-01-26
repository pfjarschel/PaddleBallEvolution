------------------------------------
-- Class for Pre-Loading Textures --
------------------------------------

TextureLoaderMenu = Core.class()

-- Load a bunch of textures and sets them to variables --
function TextureLoaderMenu:init()
	
	self.returnBut = Texture.new("imgs/buttons/returnBut.png")
	self.returnBut1 = Texture.new("imgs/buttons/returnBut1.png")
	
	self.goBut = Texture.new("imgs/buttons/goBut.png")
	self.goBut1 = Texture.new("imgs/buttons/goBut1.png")
	
	self.backBut = Texture.new("imgs/buttons/backBut.png")
	self.backBut1 = Texture.new("imgs/buttons/backBut1.png")
	
	self.forwardBut = Texture.new("imgs/buttons/forwardBut.png")
	self.forwardBut1 = Texture.new("imgs/buttons/forwardBut1.png")
	
	self.plusBut = Texture.new("imgs/buttons/plusBut.png")
	self.plusBut1 = Texture.new("imgs/buttons/plusBut1.png")
	
	self.minusBut = Texture.new("imgs/buttons/minusBut.png")
	self.minusBut1 = Texture.new("imgs/buttons/minusBut1.png")
	
	self.survivalmodeBut = Texture.new("imgs/buttons/survivalmodeBut.png")
	self.survivalmodeBut1 = Texture.new("imgs/buttons/survivalmodeBut1.png")
	
	self.exitBut = Texture.new("imgs/buttons/exitBut.png")
	self.exitBut1 = Texture.new("imgs/buttons/exitBut1.png")
	
	self.classicmodeBut = Texture.new("imgs/buttons/classicmodeBut.png")
	self.classicmodeBut1 = Texture.new("imgs/buttons/classicmodeBut1.png")
	
	self.careermodeBut = Texture.new("imgs/buttons/careermodeBut.png")
	self.careermodeBut1 = Texture.new("imgs/buttons/careermodeBut1.png")
	
	self.arenaBut = Texture.new("imgs/buttons/arenamodeBut.png")
	self.arenaBut1 = Texture.new("imgs/buttons/arenamodeBut1.png")
	
	self.optionsBut = Texture.new("imgs/buttons/gear.png")
	self.optionsBut1 = Texture.new("imgs/buttons/gear1.png")
	
	self.helpBut = Texture.new("imgs/buttons/help.png")
	self.helpBut1 = Texture.new("imgs/buttons/help1.png")
	
	self.aboutBut = Texture.new("imgs/buttons/about.png")
	self.aboutBut1 = Texture.new("imgs/buttons/about1.png")
	
	self.mainmenubg = Texture.new("imgs/backs/mainmenubg.png")
	
	self.splash = Texture.new("imgs/backs/splash.png")
	
	self.black = Texture.new("imgs/backs/black.png")
	
	self.interface = Texture.new("imgs/backs/interface.png")
	
end

