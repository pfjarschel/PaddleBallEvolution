----------
-- Main --
----------

----------------------
-- Global Variables --
----------------------
-- World dimensions --
WX = 800
WY = 480

-- Boundaries height --
WBounds = 13

-- World, and holds all arena objects --
debugDraw = nil
world = nil
arena = nil

-- Etc --
transTime = 1.5
currSong = nil
XShift = 0 -- 

----------------------
-- Global Functions --
----------------------

-- Fades scene screen out (or sprite) --
function fadeOut(sceneVar)
	local function fadeOutFunc()
		if sceneVar:getAlpha() > 0 then  
			sceneVar:setAlpha((sceneVar:getAlpha()) - 0.03)
		else
			stage:removeEventListener(Event.ENTER_FRAME, fadeOutFunc)
		end
	end
	stage:addEventListener(Event.ENTER_FRAME, fadeOutFunc)
end


-------------------------
-- Main Initialization --
-------------------------

-- Initialize Physics, Scale pixels are equivalent to 1 meter --
PhysicsScale = 20
goPhysics(PhysicsScale)

-- Load stuff --
sounds = SoundLoader.new()
textures = TextureLoader.new()
fonts = FontLoader.new()
musics = MusicLoader.new()

local optionsFile = io.open("|D|options.txt", "r")
if not optionsFile then
	local createFile = io.open("|D|options.txt", "w+")
	for k, v in pairs(optionsTable) do 
		createFile:write(k.."="..v.."\n")
	end
else
	local lines = lines_from("|D|options.txt")
	for i = 1, table.getn(lines), 1 do
		for k1, v1 in string.gmatch(lines[i], "(%w+)=(%w+)") do
			optionsTable[k1] = v1
		end
	end
end

-- Create scenes for the Scene Manager --
sceneMan = SceneManager.new({
	["splash"] = Splash,
	["mainMenu"] = MainMenu,
	["mainMenu_Classic"] = MainMenu_Classic,
	["mainMenu_Arena"] = MainMenu_Arena,
	["arena"] = ArenaArena,
	["classic"] = ArenaClassic,
	["survival"] = ArenaSurvival,
	["mainMenu_Options"] = MainMenu_Options,
	["mainMenu_Help"] = MainMenu_Help,
	["blackScreen"] = BlackScreen
})

-- Load Splash Screen and then Main Menu --
stage:addChild(sceneMan)
sceneMan:changeScene("splash", transTime, SceneManager.fade, easing.linear)