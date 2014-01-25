------------------------------------------
-- Class for Loading and Playing Sounds --
------------------------------------------

SoundLoader = Core.class()

-- Load a bunch of sounds and sets them to variables --
function SoundLoader:init()
	self.sel1 = Sound.new("audio/sel1.mp3")
	self.sel2 = Sound.new("audio/sel2.mp3")
	self.sel3 = Sound.new("audio/sel3.mp3")
	self.sel_pause = Sound.new("audio/sel_pause.mp3")
	self.hit1 = Sound.new("audio/hit1.wav")
	self.hit2 = Sound.new("audio/hit2.wav")
	self.goal1 = Sound.new("audio/goal1.wav")
	self.goal2 = Sound.new("audio/goal2.wav")
	self.win = Sound.new("audio/win.wav")
	self.lose = Sound.new("audio/lose.wav")
	
	self.powerup1 = Sound.new("audio/sfx/powerup1.wav")
	self.powerup2 = Sound.new("audio/sfx/powerup2.wav")
	self.powerup2over = Sound.new("audio/sfx/powerup2-over.wav")
	self.bubbles = Sound.new("audio/sfx/bubbles.mp3")
	self.puff = Sound.new("audio/sfx/puff.mp3")
	self.ice = Sound.new("audio/sfx/ice.mp3")
	self.ice_break = Sound.new("audio/sfx/ice_break.mp3")
	self.crazyball = Sound.new("audio/sfx/crazyball.mp3")
	self.crazyball_end = Sound.new("audio/sfx/crazyball_end.mp3")
	self.woosh = Sound.new("audio/sfx/woosh.mp3")
	self.glass_ping = Sound.new("audio/sfx/glass_ping.mp3")
	self.magic = Sound.new("audio/sfx/magic.mp3")
	self.tractorbeam = Sound.new("audio/sfx/tractorbeam.mp3")
end

