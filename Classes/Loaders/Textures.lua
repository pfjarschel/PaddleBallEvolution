------------------------------------
-- Class for Pre-Loading Textures --
------------------------------------

TextureLoader = Core.class()

-- Load a bunch of textures and sets them to variables
function TextureLoader:init()
	self.pausebg = Bitmap.new(Texture.new("imgs/pausebg.png"))
	self.menuBut = Bitmap.new(Texture.new("imgs/menuBut.png"))
	self.skillBut = Bitmap.new(Texture.new("imgs/skillBut.png"))
	self.againBut = Bitmap.new(Texture.new("imgs/againBut.png"))
	self.returnBut = Bitmap.new(Texture.new("imgs/returnBut.png"))
	self.goBut = Bitmap.new(Texture.new("imgs/goBut.png"))
	self.forwardBut = Bitmap.new(Texture.new("imgs/forwardBut.png"))
	self.backBut = Bitmap.new(Texture.new("imgs/backBut.png"))
	self.plusBut = Bitmap.new(Texture.new("imgs/plusBut.png"))
	self.minusBut = Bitmap.new(Texture.new("imgs/minusBut.png"))
	self.survivalmodeBut = Bitmap.new(Texture.new("imgs/survivalmodeBut.png"))
	self.exitBut = Bitmap.new(Texture.new("imgs/exitBut.png"))
	self.classicmodeBut = Bitmap.new(Texture.new("imgs/classicmodeBut.png"))
	self.careermodeBut = Bitmap.new(Texture.new("imgs/careermodeBut.png"))
	self.arenaBut = Bitmap.new(Texture.new("imgs/arenaBut.png"))
	self.mainmenubg = Bitmap.new(Texture.new("imgs/mainmenubg.png"))
	--self.paddle = Bitmap.new(Texture.new("imgs/paddle2.png")) -- For some reason, this one needs to be loaded at the time (something to do with the transforms applied?)
	self.pongbg = Bitmap.new(Texture.new("imgs/pongbg.png"))
	self.pongball = Bitmap.new(Texture.new("imgs/pongball.png"))
end

