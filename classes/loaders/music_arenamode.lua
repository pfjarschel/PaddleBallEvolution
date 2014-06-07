------------------------------------------
-- Class for Loading and Playing Musics --
------------------------------------------

MusicLoaderArenaMode = Core.class()
MusicLoaderArenaMode.fight = {}
MusicLoaderArenaMode.boss = {}
MusicLoaderArenaMode.champion = {}

-- Load a bunch of sounds and sets them to variables --
function MusicLoaderArenaMode:init()
	self.fight[1] = "audio/bgm/bgm_fight1.mp3"
	self.fight[2] = "audio/bgm/bgm_fight2.mp3"
	self.fight[3] = "audio/bgm/bgm_fight3.mp3"
	self.fight[4] = "audio/bgm/bgm_fight4.mp3"
	self.fight[5] = "audio/bgm/bgm_fight5.mp3"
	self.fight[6] = "audio/bgm/bgm_fight6.mp3"
	
	self.boss[1] = "audio/bgm/bgm_boss1.mp3"
	self.boss[2] = "audio/bgm/bgm_boss2.mp3"
	self.boss[3] = "audio/bgm/bgm_boss3.mp3"
	
	self.champion[1] = "audio/bgm/bgm_champion1.mp3"
	self.lost = "audio/bgm/bgm_lost.mp3"
end