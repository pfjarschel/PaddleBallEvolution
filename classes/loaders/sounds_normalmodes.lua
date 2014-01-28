------------------------------------------
-- Class for Loading and Playing Sounds --
------------------------------------------

SoundLoaderNormalModes = Core.class()

-- Load a bunch of sounds and sets them to variables --
function SoundLoaderNormalModes:init()
	self.sel1 = Sound.new("audio/sel1.wav")
	self.sel2 = Sound.new("audio/sel2.wav")
	self.sel3 = Sound.new("audio/sel3.wav")
	self.sel_pause = Sound.new("audio/sel_pause.wav")
	self.hit1 = Sound.new("audio/hit1.wav")
	self.hit2 = Sound.new("audio/hit2.wav")
	self.goal1 = Sound.new("audio/goal1.wav")
	self.goal2 = Sound.new("audio/goal2.wav")
	self.powerup1 = Sound.new("audio/sfx/powerup1.wav")
	self.winstring = "audio/win.mp3"
	self.losestring = "audio/lose.mp3"
end

