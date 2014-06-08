------------------------------------------
-- Class for Loading and Playing Sounds --
------------------------------------------

SoundLoaderArenaMode = Core.class()

-- Load a bunch of sounds and sets them to variables --
function SoundLoaderArenaMode:init()
	self.sel1 = Sound.new("audio/sel1.wav")
	self.sel2 = Sound.new("audio/sel2.wav")
	self.sel3 = Sound.new("audio/sel3.wav")
	self.sel_pause = Sound.new("audio/sel_pause.wav")
	self.hit1 = Sound.new("audio/hit1.wav")
	self.hit2 = Sound.new("audio/hit2.wav")
	self.goal1 = Sound.new("audio/goal1.wav")
	self.goal2 = Sound.new("audio/goal2.wav")
	self.winstring = "audio/win.mp3"
	self.losestring = "audio/lose.mp3"
	
	self.powerup1 = Sound.new("audio/sfx/powerup1.wav")
	self.powerup2 = Sound.new("audio/sfx/powerup2.wav")
	self.powerup2over = Sound.new("audio/sfx/powerup2-over.wav")
	self.bubbles = Sound.new("audio/sfx/bubbles.wav")
	self.puff = Sound.new("audio/sfx/puff.wav")
	self.ice = Sound.new("audio/sfx/ice.wav")
	self.ice_break = Sound.new("audio/sfx/ice_break.wav")
	self.crazyball = Sound.new("audio/sfx/crazyball.wav")
	self.crazyball_end = Sound.new("audio/sfx/crazyball_end.wav")
	self.woosh = Sound.new("audio/sfx/woosh.wav")
	self.glass_ping = Sound.new("audio/sfx/glass_ping.wav")
	self.magic = Sound.new("audio/sfx/magic.wav")
	self.tractorbeam = Sound.new("audio/sfx/tractorbeam.wav")
	self.fire = Sound.new("audio/sfx/fire.wav")
	self.fireout = Sound.new("audio/sfx/fireout.wav")
	self.explosion = Sound.new("audio/sfx/explosion.wav")
	self.alarm = Sound.new("audio/sfx/alarm.wav")
	self.bite = Sound.new("audio/sfx/bite.wav")
	self.dispel = Sound.new("audio/sfx/dispel.wav")
	self.spark = Sound.new("audio/sfx/spark.wav")
	self.dice = Sound.new("audio/sfx/dice.wav")
	self.clock = Sound.new("audio/sfx/clock.wav")
	self.harp = Sound.new("audio/sfx/harp.wav")
	self.kiss = Sound.new("audio/sfx/kiss.wav")
	self.laugh = Sound.new("audio/sfx/laugh.wav")
	self.spider = Sound.new("audio/sfx/spider.wav")
	self.portal = Sound.new("audio/sfx/portal.wav")
	self.portal2 = Sound.new("audio/sfx/portal2.wav")
	self.earthquake = Sound.new("audio/sfx/earthquake.wav")
	self.imp = Sound.new("audio/sfx/imp.wav")
	self.explode = Sound.new("audio/sfx/explode.wav")
	self.rockhit = Sound.new("audio/sfx/rockhit.wav")
end

