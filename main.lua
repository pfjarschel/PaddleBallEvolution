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

-- Defined Options --
controlMethod = "Touch"

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