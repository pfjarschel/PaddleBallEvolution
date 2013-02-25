----------
-- Main --
----------

-- Global Variables --
WX = 800
WY = 480
-- Boundaries height --
WBounds = 13
mainmenu = nil
arena = nil


-- Global Functions --
function fadeIn(sceneVar)
	local function fadeInFunc()
		if sceneVar:getAlpha() < 1 then  
			sceneVar:setAlpha((sceneVar:getAlpha()) + 0.03)
		else
			stage:removeEventListener(Event.ENTER_FRAME, fadeInFunc)
		end
	end
	stage:addEventListener(Event.ENTER_FRAME, fadeInFunc)
end
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

function loadMainMenu ()
	mainmenu = MainMenu.new()
end

function loadArena(mode, difficulty, extra)
	if mode == "classic" then
		arena = ArenaClassic.new(difficulty)
	end
	if mode == "survival" then
		arena = ArenaSurvival.new(difficulty)
	end
	if mode == "arena" then
		arena = ArenaArena.new(difficulty, extra)
	end
end

-- Initialize Physics, Scale pixels are equivalent to 1 meter --
PhysicsScale = 20
goPhysics(PhysicsScale)

-- Load stuff --
sounds = SoundLoader.new()
textures = TextureLoader.new()
fonts = FontLoader.new()

-- Load Main Menu --
loadMainMenu()