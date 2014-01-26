------------------------------------------
-- Class for Loading and Playing Musics --
------------------------------------------

MusicLoaderMenu = Core.class()
MusicLoaderMenu.fight = {}
MusicLoaderMenu.boss = {}
MusicLoaderMenu.champion = {}

-- Load a bunch of sounds and sets them to variables --
function MusicLoaderMenu:init()
	self.intro = "audio/bgm/bgm_intro.mp3"
	self.credits = "audio/bgm/bgm_credits.mp3"
	
end