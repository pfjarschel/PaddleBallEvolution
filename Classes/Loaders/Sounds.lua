------------------------------------------
-- Class for Loading and Playing Sounds --
------------------------------------------

SoundLoader = Core.class()

--SoundLoader.hit1 = nil
--SoundLoader.hit2 = nil
--SoundLoader.goal1 = nil
--SoundLoader.goal2 = nil
--SoundLoader.win = nil
--SoundLoader.lose = nil

-- Load a bunch of sounds and sets them to variables
function SoundLoader:init()
	self.hit1 = Sound.new("audio/hit1.wav")
	self.hit2 = Sound.new("audio/hit2.wav")
	self.goal1 = Sound.new("audio/goal1.wav")
	self.goal2 = Sound.new("audio/goal2.wav")
	self.powerup1 = Sound.new("audio/powerup1.wav")
	self.powerup2 = Sound.new("audio/powerup2.wav")
	self.powerup2over = Sound.new("audio/powerup2-over.wav")
	self.win = Sound.new("audio/win.wav")
	self.lose = Sound.new("audio/lose.wav")
end

