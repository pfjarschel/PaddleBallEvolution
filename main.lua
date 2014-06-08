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
classIndexL = 1
classIndexR = 1
classIndexT = 1

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
	

-------------------------------
-- Functions to be overriden --
-------------------------------
function ballCollideO0(event)
end
function ballCollideO1(event)
end


-------------------------
-- Main Initialization --
-------------------------

-- Initialize Physics, Scale pixels are equivalent to 1 meter --
PhysicsScale = 20
goPhysics(PhysicsScale)

-- Load stuff --
sounds = nil
textures = nil
fonts = FontLoader.new()
musics = nil

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

local customclassFile = io.open("|D|customclass.txt", "r")
if not customclassFile then
	local createFile = io.open("|D|customclass.txt", "w+")
	for k, v in pairs(customClass) do 
		createFile:write(k.."="..v.."\n")
	end
else
	local lines = lines_from("|D|customclass.txt")
	for i = 1, table.getn(lines), 1 do
		for k1, v1 in string.gmatch(lines[i], "(%w+)=(%w+)") do
			customClass[k1] = v1
		end
		local skillName = skillTable[customClass["skill"]]["Name"]
		local skillDesc = skillTable[customClass["skill"]]["Desc"]
		customClass["skillName"] = skillName
		customClass["skillDesc"] = skillDesc

		classTable["Custom"] = {
			tonumber(customClass["Atk"]),
			tonumber(customClass["Mov"]),
			tonumber(customClass["Lif"]),
			tonumber(customClass["Int"]),
			tonumber(customClass["Skl"]),
			tonumber(customClass["Def"]),
			customClass["skill"],
			skillName,
			skillDesc,
			{tonumber(customClass["ColorR"])/10, tonumber(customClass["ColorG"])/10, tonumber(customClass["ColorB"])/10},
			"Custom Class",
			0
		}
	end
end

-- Create scenes for the Scene Manager --
sceneMan = SceneManager.new({
	["splash"] = Splash,
	["mainMenu"] = MainMenu,
	["mainMenu_Classic"] = MainMenu_Classic,
	["mainMenu_Arena"] = MainMenu_Arena,
	["mainMenu_Arena2"] = MainMenu_Arena2,
	["mainMenu_QuickTour"] = MainMenu_QuickTour,
	["mainMenu_QuickTour2"] = MainMenu_QuickTour2,
	["mainMenu_Career"] = MainMenu_Career,
	["arenaTour"] = ArenaTour,
	["tourLevelUp"] = TourLevelUp,
	["editCustom"] = EditCustomClass,
	["arena"] = ArenaArena,
	["classic"] = ArenaClassic,
	["survival"] = ArenaSurvival,
	["mainMenu_Options"] = MainMenu_Options,
	["mainMenu_Help"] = MainMenu_Help,
	["mainMenu_About"] = MainMenu_About,
	["blackScreen"] = BlackScreen
})

-- Load Splash Screen and then Main Menu --
stage:addChild(sceneMan)
sceneMan:changeScene("splash", transTime, SceneManager.fade, easing.linear)