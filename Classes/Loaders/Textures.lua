------------------------------------
-- Class for Pre-Loading Textures --
------------------------------------

TextureLoader = Core.class()

-- Load a bunch of textures and sets them to variables --
function TextureLoader:init()
	self.menuBut = Bitmap.new(Texture.new("imgs/menuBut.png"))
	self.skillBut = Bitmap.new(Texture.new("imgs/skillBut.png"))
	self.controlarrows = Bitmap.new(Texture.new("imgs/controlarrows.png"))
	self.againBut = Bitmap.new(Texture.new("imgs/againBut.png"))
	self.returnBut = Bitmap.new(Texture.new("imgs/returnBut.png"))
	self.goBut = Bitmap.new(Texture.new("imgs/goBut.png"))
	self.forwardBut = Bitmap.new(Texture.new("imgs/forwardBut.png"))
	self.backBut = Bitmap.new(Texture.new("imgs/backBut.png"))
	self.forwardBut2 = Bitmap.new(Texture.new("imgs/forwardBut.png"))
	self.backBut2 = Bitmap.new(Texture.new("imgs/backBut.png"))
	self.plusBut = Bitmap.new(Texture.new("imgs/plusBut.png"))
	self.minusBut = Bitmap.new(Texture.new("imgs/minusBut.png"))
	self.survivalmodeBut = Bitmap.new(Texture.new("imgs/survivalmodeBut.png"))
	self.exitBut = Bitmap.new(Texture.new("imgs/exitBut.png"))
	self.classicmodeBut = Bitmap.new(Texture.new("imgs/classicmodeBut.png"))
	self.careermodeBut = Bitmap.new(Texture.new("imgs/careermodeBut.png"))
	self.arenaBut = Bitmap.new(Texture.new("imgs/arenaBut.png"))
	self.optionsBut = Bitmap.new(Texture.new("imgs/gear.png"))
	self.helpBut = Bitmap.new(Texture.new("imgs/help.png"))
	
	self.pausebg = Bitmap.new(Texture.new("imgs/pausebg.png"))
	self.mainmenubg = Bitmap.new(Texture.new("imgs/mainmenubg.png"))
	self.mainmenubg2 = Bitmap.new(Texture.new("imgs/mainmenubg.png"))
	self.splash = Bitmap.new(Texture.new("imgs/splash.png"))
	self.black = Bitmap.new(Texture.new("imgs/black.png"))
	self.interface = Bitmap.new(Texture.new("imgs/help_interface.png"))
	
	-- For some reason, this one needs to be loaded at the time (something to do with the transforms applied?)
	--self.paddle = Bitmap.new(Texture.new("imgs/paddle2.png"))
	
	self.pongbg = Bitmap.new(Texture.new("imgs/pongbg.png"))
	self.pongball = Bitmap.new(Texture.new("imgs/pongball.png"))
end

