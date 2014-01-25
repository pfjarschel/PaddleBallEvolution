----------
-- Main --
----------

----------------------
-- Global Variables --
----------------------
-- World dimensions --
WX = 800
WY = 480
WX0 = 800
WY0 = 480

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

-- Fades Bitmap from arena and removes it from parent --
function fadeBitmapOut(bitmap, totaltime, parent)
	local currentAlpha = bitmap:getAlpha()
	local step = 0
	local interval = 33
	
	step = currentAlpha/(totaltime/interval)
	
	local function onTimer(timer)
		currentAlpha = bitmap:getAlpha()
		currentAlpha = currentAlpha - step
		bitmap:setAlpha(currentAlpha)
		if currentAlpha <= 0 then
			timer:removeEventListener(Event.TIMER, onTimer)
			timer:stop()
			for i = parent:getNumChildren(), 1, -1 do
				if parent:getChildAt(i) == bitmap then
					parent:removeChild(bitmap)
				end
			end
		end
	end
	
	local timer = Timer.new(interval, 0)
	timer:addEventListener(Event.TIMER, onTimer, timer)
	timer:start()
end

-- Fades Bitmap in --
function fadeBitmapIn(bitmap, totaltime, targetalpha)
	local currentAlpha = 0
	bitmap:setAlpha(0)
	local step = 0
	local interval = 33
	
	step = (targetalpha - currentAlpha)/(totaltime/interval)
	
	local function onTimer(timer)
		currentAlpha = bitmap:getAlpha()
		currentAlpha = currentAlpha + step
		bitmap:setAlpha(currentAlpha)
		if currentAlpha >= targetalpha then
			timer:removeEventListener(Event.TIMER, onTimer)
			timer:stop()
		end
	end
	
	local timer = Timer.new(interval, 0)
	timer:addEventListener(Event.TIMER, onTimer, timer)
	timer:start()
end

-- Scales Bitmap From X to Y --
function scaleBitmap(bitmap, totaltime, targetScale, initialScale)
	bitmap:setScale(initialScale)
	local currentScale = bitmap:getScale()
	local step = 0
	local interval = 33
	step = (targetScale - initialScale)/(totaltime/interval)
	
	local function onTimer(timer)
		currentScale = bitmap:getScale()
		currentScale = currentScale + step
		bitmap:setScale(currentScale)
		if currentScale <= 1.1*targetScale and currentScale>= 0.9*targetScale then
			timer:removeEventListener(Event.TIMER, onTimer)
			timer:stop()
			bitmap:setScale(targetScale)
		end
	end
	
	local timer = Timer.new(interval, 0)
	timer:addEventListener(Event.TIMER, onTimer, timer)
	timer:start()
end

-- Scales Bitmap From X to Y, not proportional --
function scaleBitmapXY(bitmap, totaltime, targetScaleX, targetScaleY, initialScaleX, initialScaleY)
	bitmap:setScale(initialScaleX, initialScaleY)
	local currentScaleX, currentScaleY = bitmap:getScale()
	local stepX = 0
	local stepY = 0
	local interval = 33
	stepX = (targetScaleX - initialScaleX)/(totaltime/interval)
	stepY = (targetScaleY - initialScaleY)/(totaltime/interval)
	
	local function onTimer(timer)
		currentScaleX, currentScaleY = bitmap:getScale()
		currentScaleX = currentScaleX + stepX
		currentScaleY = currentScaleY + stepY
		bitmap:setScale(currentScaleX, currentScaleY)
		if (currentScaleX <= 1.1*targetScaleX and currentScaleX>= 0.9*targetScaleX  and targetScaleX > 0) or
			(currentScaleX >= 1.1*targetScaleX and currentScaleX<= 0.9*targetScaleX  and targetScaleX < 0)
		then
			timer:removeEventListener(Event.TIMER, onTimer)
			timer:stop()
			bitmap:setScale(targetScaleX, targetScaleY)
		end
	end
	
	local timer = Timer.new(interval, 0)
	timer:addEventListener(Event.TIMER, onTimer, timer)
	timer:start()
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
sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear)