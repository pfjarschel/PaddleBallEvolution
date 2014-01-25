------------------------------------------
-- Class for Loading and Playing Musics --
------------------------------------------

MusicLoader = Core.class()
MusicLoader.fight = {}
MusicLoader.boss = {}
MusicLoader.champion = {}

-- Load a bunch of sounds and sets them to variables --
function MusicLoader:init()
	self.intro = Sound.new("audio/bgm/bgm_intro.mp3")
	
	self.fight[1] = Sound.new("audio/bgm/bgm_fight1.mp3")
	self.fight[2] = Sound.new("audio/bgm/bgm_fight2.mp3")
	self.fight[3] = Sound.new("audio/bgm/bgm_fight3.mp3")
	self.fight[4] = Sound.new("audio/bgm/bgm_fight4.mp3")
	self.fight[5] = Sound.new("audio/bgm/bgm_fight5.mp3")
	self.fight[6] = Sound.new("audio/bgm/bgm_fight6.mp3")
	
	self.boss[1] = Sound.new("audio/bgm/bgm_boss1.mp3")
	self.boss[2] = Sound.new("audio/bgm/bgm_boss2.mp3")
	self.boss[3] = Sound.new("audio/bgm/bgm_boss3.mp3")
	self.boss[4] = Sound.new("audio/bgm/bgm_boss4.mp3")
	
	self.champion[1] = Sound.new("audio/bgm/bgm_champion.mp3")
	self.champion[2] = Sound.new("audio/bgm/bgm_champion2.mp3")
end