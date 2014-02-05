------------------------------------------
-- Class for Loading and Playing Sounds --
------------------------------------------

SoundLoaderMenu = Core.class()

-- Load a bunch of sounds and sets them to variables --
function SoundLoaderMenu:init()
	self.sel1 = Sound.new("audio/sel1.wav")
	self.sel2 = Sound.new("audio/sel2.wav")
	self.sel3 = Sound.new("audio/sel3.wav")
end

