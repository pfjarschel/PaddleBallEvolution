------------------------------------
-- Class for Pre-Loading Textures --
------------------------------------

TextureLoader = Core.class()

-- Load a bunch of textures and sets them to variables --
function TextureLoader:init()
	self.menuBut = Texture.new("imgs/menuBut.png")
	self.menuBut1 = Texture.new("imgs/menuBut1.png")
	
	self.skillBut = Texture.new("imgs/skillBut.png")
	self.skillBut1 = Texture.new("imgs/skillBut1.png")
	
	self.controlarrows = Texture.new("imgs/controlarrows.png")
	
	self.againBut = Texture.new("imgs/againBut.png")
	self.againBut1 = Texture.new("imgs/againBut1.png")
	
	self.restartBut = Texture.new("imgs/restartBut.png")
	self.restartBut1 = Texture.new("imgs/restartBut1.png")
	
	self.returnBut = Texture.new("imgs/returnBut.png")
	self.returnBut1 = Texture.new("imgs/returnBut1.png")
	
	self.goBut = Texture.new("imgs/goBut.png")
	self.goBut1 = Texture.new("imgs/goBut1.png")
	
	self.backBut = Texture.new("imgs/backBut.png")
	self.backBut1 = Texture.new("imgs/backBut1.png")
	
	self.forwardBut = Texture.new("imgs/forwardBut.png")
	self.forwardBut1 = Texture.new("imgs/forwardBut1.png")
	
	self.plusBut = Texture.new("imgs/plusBut.png")
	self.plusBut1 = Texture.new("imgs/plusBut1.png")
	
	self.minusBut = Texture.new("imgs/minusBut.png")
	self.minusBut1 = Texture.new("imgs/minusBut1.png")
	
	self.survivalmodeBut = Texture.new("imgs/survivalmodeBut.png")
	self.survivalmodeBut1 = Texture.new("imgs/survivalmodeBut1.png")
	
	self.exitBut = Texture.new("imgs/exitBut.png")
	self.exitBut1 = Texture.new("imgs/exitBut1.png")
	
	self.classicmodeBut = Texture.new("imgs/classicmodeBut.png")
	self.classicmodeBut1 = Texture.new("imgs/classicmodeBut1.png")
	
	self.careermodeBut = Texture.new("imgs/careermodeBut.png")
	self.careermodeBut1 = Texture.new("imgs/careermodeBut1.png")
	
	self.arenaBut = Texture.new("imgs/arenamodeBut.png")
	self.arenaBut1 = Texture.new("imgs/arenamodeBut1.png")
	
	self.optionsBut = Texture.new("imgs/gear.png")
	self.optionsBut1 = Texture.new("imgs/gear1.png")
	
	self.helpBut = Texture.new("imgs/help.png")
	self.helpBut1 = Texture.new("imgs/help1.png")
	
	self.pausebg = Texture.new("imgs/pausebg.png")
	
	self.mainmenubg = Texture.new("imgs/mainmenubg.png")
	
	self.splash = Texture.new("imgs/splash.png")
	
	self.black = Texture.new("imgs/black.png")
	
	self.interface = Texture.new("imgs/interface.png")
	
	self.paddle2 = Texture.new("imgs/paddle2.png")
	self.paddle0 = Texture.new("imgs/paddle0.png")
	self.paddle1 = Texture.new("imgs/paddle1.png")
	
	self.pongbg = Texture.new("imgs/pongbg.png")
	
	self.pongball = Texture.new("imgs/pongball.png")
end

