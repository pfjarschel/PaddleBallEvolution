-------------------------------------------------
-- Class for the Arena (or simply background?) --
-------------------------------------------------

ArenaTour = Core.class(Sprite)

-- Declare stuff --
ArenaTour.bitmap = nil
ArenaTour.bounds = nil
ArenaTour.fixtureT = nil
ArenaTour.fixtureB = nil
ArenaTour.score0 = 0
ArenaTour.score1 = 0
ArenaTour.difFactor = 5/5 -- 1/5 to 10/5
ArenaTour.paused = false
ArenaTour.leftClass = "classic"
ArenaTour.rightClass = "classic"
ArenaTour.font = nil
ArenaTour.pausebg = nil
ArenaTour.name = "arena"
ArenaTour.skillBut = nil
ArenaTour.controlarrows = nil
ArenaTour.accelerometer = nil
ArenaTour.AI = nil
ArenaTour.humanPlayer = nil
ArenaTour.aiPlayer = nil
ArenaTour.songload = nil
ArenaTour.stage = 1

-- Tilt variables --
local afx = 0
local afy = 0
local afz = 0
local afx0 = 0

-- Main Match Loop --
local function onEnterFrame()
	updatePhysics()
	if optionsTable["ControlMode"] == "Tilt" then
		arena:tilt()
	end
	arena.humanPlayer:humanMove()
	arena:moveAI()
	arena:checkGoal()
end

-- Create physics stuff (including collision handler)
function ArenaTour:createBoundaries()
	self.bounds = world:createBody({}) --Default is Static
	
	self.bounds.name = "bounds"
	
	local shapeT = b2.EdgeShape.new(-200, WBounds, WX0 + 200, WBounds)
	local shapeB = b2.EdgeShape.new(-200, WY-WBounds, WX0 + 200, WY-WBounds)
	
	self.fixtureT = self.bounds:createFixture{
		shape = shapeT, 
		friction = 0,
	}
	self.fixtureT:setFilterData({categoryBits = 4, maskBits = 3, groupIndex = 0})
	self.fixtureB = self.bounds:createFixture{
		shape = shapeB, 
		friction = 0,
	}
	self.fixtureB:setFilterData({categoryBits = 4, maskBits = 3, groupIndex = 0})
	
	function self.bounds:collide(event)
		--print("bounds")
	end
end

-- This is the actual menu --
function ArenaTour:openMenu()
	Timer:pauseAll()
	if not self.paused then
		self.paused = true
		
		if optionsTable["SFX"] == "On" then sounds.sel_pause:play() end
		
		self:removeEventListener(Event.ENTER_FRAME, onEnterFrame)
		
		self.pausebg = Sprite:new()
		self.pausebg:addChild(Bitmap.new(textures.pausebg))
		
		-- Adds Resume Button --
		local resumeBut = MenuBut.new(150, 40, textures.returnBut, textures.returnBut1)
		resumeBut.bitmap:setPosition(WX0/2, WY/2 - 2*resumeBut:getHeight())
		resumeBut:addEventListener(Event.TOUCHES_END, function(event)
			if resumeBut:hitTestPoint(event.touch.x, event.touch.y) then
				event:stopPropagation()
				Timer:resumeAll()
				stage:removeChild(self.pausebg)
				self.paused = false
				self:addEventListener(Event.ENTER_FRAME, onEnterFrame)
				
				if optionsTable["SFX"] == "On" then sounds.sel_pause:play() end
			end
		end)
		self.pausebg:addChild(resumeBut)
		
		-- Adds Restart Button --
		local restartBut = MenuBut.new(150, 40, textures.restartBut, textures.restartBut1)
		restartBut.bitmap:setPosition(WX0/2, WY/2)
		restartBut:addEventListener(Event.TOUCHES_END, function(event)
			if restartBut:hitTestPoint(event.touch.x, event.touch.y) then
				event:stopPropagation()
				if self.humanPlayer.skillActive then
					self.humanPlayer.char.skill:endAction()
				end
				if self.aiPlayer.skillActive then
					self.aiPlayer.char.skill:endAction()
				end
				Timer.resumeAll()
				Timer.stopAll()
				stage:removeChild(self.pausebg)
				world:destroyBody(self.ball.body)
				self.ball.body = nil
				world:destroyBody(self.humanPlayer.paddle.body)
				world:destroyBody(self.aiPlayer.paddle.body)
				world:destroyBody(self.bounds)
				local difficulty = self.difFactor*5
				local class = tourTable["QuickTourClass"]
				local class2 = tourTable["QuickTourOpponent"]
				local stage = self.stage
				self = nil
				arena = nil
				
				if optionsTable["SFX"] == "On" then sounds.sel3:play() end
				
				sceneMan:changeScene("arenaTour", transTime, SceneManager.fade, easing.linear, { userData = {difficulty, class, class2, stage} })
			end
		end)
		self.pausebg:addChild(restartBut)
		
		-- Adds Quit Button --
		local quitBut = MenuBut.new(150, 40, textures.exitBut, textures.exitBut1)
		quitBut.bitmap:setPosition(WX0/2, WY/2 + 2*quitBut:getHeight())
		quitBut:addEventListener(Event.TOUCHES_END, function(event)
			if quitBut:hitTestPoint(event.touch.x, event.touch.y) then
				event:stopPropagation()
				if self.humanPlayer.skillActive then
					self.humanPlayer.char.skill:endAction()
				end
				if self.aiPlayer.skillActive then
					self.aiPlayer.char.skill:endAction()
				end
				Timer.resumeAll()
				Timer.stopAll()
				stage:removeChild(self.pausebg)
				world:destroyBody(self.ball.body)
				self.ball.body = nil
				world:destroyBody(self.humanPlayer.paddle.body)
				world:destroyBody(self.aiPlayer.paddle.body)
				world:destroyBody(self.bounds)
				self = nil
				arena = nil
				
				if optionsTable["SFX"] == "On" then sounds.sel3:play() end
				
				sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear)
			end
		end)
		self.pausebg:addChild(quitBut)
		
		stage:addChild(self.pausebg)
	end
end

-- This function creates the in-game menu --
function ArenaTour:addMenu()
	-- Adds Menu Button --
	local menuBut = MenuBut.new(60, 60, textures.menuBut, textures.menuBut1)
	if optionsTable["ArenaSide"] == "Left" then
		menuBut.bitmap:setPosition(XShift + WX - menuBut.bitmap:getWidth()/1.5, WY - menuBut.bitmap:getHeight())
	else
		menuBut.bitmap:setPosition(XShift + menuBut.bitmap:getWidth()/1.5, WY - menuBut.bitmap:getHeight())
	end
	menuBut:setAlpha(0.4)
	self:addChild(menuBut)
	menuBut:addEventListener(Event.TOUCHES_END, function(event)
		if menuBut:hitTestPoint(event.touch.x, event.touch.y) then
			event:stopPropagation()
			self:openMenu()
		end
	end)
end

-- Inserts Skill Button (Human Player only) --
function ArenaTour:addSkillBut()
	self.skillBut = MenuBut.new(60, 60, textures.skillBut, textures.skillBut1)
	if optionsTable["ArenaSide"] == "Left" then
		self.skillBut.bitmap:setPosition(XShift + 3*WX/4, WY - self.skillBut.bitmap:getHeight())
	else
		self.skillBut.bitmap:setPosition(XShift + WX/4, WY - self.skillBut.bitmap:getHeight())
	end
	self.skillBut:setAlpha(0.4)
	self:addChild(self.skillBut)
	
	self.skillBut:addEventListener(Event.TOUCHES_END, function(event)
		-- Skill needs to be inactive (over) to function, and ball launched --
		if self.skillBut:hitTestPoint(event.touch.x, event.touch.y) then
			event:stopPropagation()
			if optionsTable["ArenaSide"] == "Left" then
				if self.humanPlayer.skillActive == false and self.ball.launched and self.mp0 > 0 then
					self.humanPlayer.skillActive = true
					self.humanPlayer.char.skill:start(0)
					self.mp0 = self.mp0 - 1
					self.combatStats:update(self.score0, self.score1, self.mp0, self.mp1)
				end
			else
				if self.humanPlayer.skillActive == false and self.ball.launched and self.mp1 > 0 then
					self.humanPlayer.skillActive = true
					self.humanPlayer.char.skill:start(1)
					self.mp1 = self.mp1 - 1
					self.combatStats:update(self.score0, self.score1, self.mp0, self.mp1)
				end
			end
		end
	end)
end

-- Inserts control arrows, handles touch --
function ArenaTour:addControlArrows()
	local controlarrows = Bitmap.new(textures.controlarrows)
	controlarrows:setScale(1, 1)
	self:addChild(controlarrows)
	local textureW = controlarrows:getWidth()
	local textureH = controlarrows:getHeight()
	controlarrows:setScale(80/textureW, WY/textureH)
	if optionsTable["ArenaSide"] == "Left" then
		controlarrows:setPosition(controlarrows:getWidth(), WY/2 - controlarrows:getHeight()/2)
		controlarrows:setScaleX(-1)
	else
		controlarrows:setPosition(WX0 - controlarrows:getWidth(), WY/2 - controlarrows:getHeight()/2)
	end
	--controlarrows:setAlpha(0.4)
	
	controlarrows:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if not arena.paused and controlarrows:hitTestPoint(event.touch.x, event.touch.y) then
			self.humanPlayer.touchY = event.touch.y
		end
	end)
	controlarrows:addEventListener(Event.TOUCHES_MOVE, function(event)
		if not arena.paused and controlarrows:hitTestPoint(event.touch.x, event.touch.y) then
			self.humanPlayer.touchY = event.touch.y
		end
	end)
	controlarrows:addEventListener(Event.TOUCHES_END, function(event)
		
	end)
end

-- Initialize Tilt --
function ArenaTour:tiltInit()
	self.accelerometer = Accelerometer.new()
	self.accelerometer:start()
	afx0 = self.accelerometer:getAcceleration()
end

-- Handles Tilt --
function ArenaTour:tilt()
	if not arena.paused then
		local x, y, z = self.accelerometer:getAcceleration()
		local filter = 0.1;
		afx = x * filter + afx * (1 - filter)
		afy = y * filter + afy * (1 - filter)
		afz = z * filter + afz * (1 - filter)
		
		self.humanPlayer.touchY = WY/2 - (afx - afx0)*WY *1.5
	end
end

-- Handles Keys --
local function onKeyDown(event)
	if event.keyCode == 303 then
		arena:openMenu()
	end
	if event.keyCode == 301 and arena.paused then
		Timer:resumeAll()
		stage:removeChild(arena.pausebg)
		arena.paused = false
		arena:addEventListener(Event.ENTER_FRAME, onEnterFrame)
	end
	if optionsTable["ControlMode"] == "Keys" then
		if event.keyCode == 40 then
			arena.humanPlayer.touchY = WY
		end
		if event.keyCode == 38 then
			arena.humanPlayer.touchY = 0
		end
		if event.keyCode == 89 then
			if optionsTable["ArenaSide"] == "Left" then
				if arena.humanPlayer.skillActive == false and arena.ball.launched and arena.mp0 > 0 then
					arena.humanPlayer.skillActive = true
					arena.humanPlayer.char.skill:start(0)
					arena.mp0 = arena.mp0 - 1
					arena.combatStats:update(arena.score0, arena.score1, arena.mp0, arena.mp1)
				end
			else
				if arena.humanPlayer.skillActive == false and arena.ball.launched and arena.mp1 > 0 then
					arena.humanPlayer.skillActive = true
					arena.humanPlayer.char.skill:start(1)
					arena.mp1 = arena.mp1 - 1
					arena.combatStats:update(arena.score0, arena.score1, arena.mp0, arena.mp1)
				end
			end
		end
	end
end
local function onKeyUp(event)
	if optionsTable["ControlMode"] == "Keys" then
		if event.keyCode == 40 then
			local posx, posy = arena.humanPlayer.paddle.body:getPosition()
			arena.humanPlayer.touchY = posy
		end
		if event.keyCode == 38 then
			local posx, posy = arena.humanPlayer.paddle.body:getPosition()
			arena.humanPlayer.touchY = posy
		end
	end
end

-- Handles the end of the match --
function ArenaTour:gameOver()
	self:removeEventListener(Event.ENTER_FRAME, onEnterFrame)
	fadeOut(self)
	
	local gameOverString = nil
	local gameOverTextBox = nil
	local exitBut = MenuBut.new(150, 40, textures.exitBut, textures.exitBut1)
	local againBut = MenuBut.new(150, 40, textures.restartBut, textures.restartBut1)
	local nextBut = MenuBut.new(150, 40, textures.nextBut, textures.nextBut1)
	
	if (self.score0 > self.score1 and optionsTable["ArenaSide"] == "Left") or (self.score0 < self.score1 and optionsTable["ArenaSide"] == "Right") then
		if self.stage < 10 then
			gameOverString = "You won this match!"
			if optionsTable["Music"] == "On" then
				currSong:stop()
				self.songload = nil
				self.songload = Sound.new(sounds.winstring)
				currSong = nil
				currSong = self.songload:play()
			end
			
			nextBut.bitmap:setPosition(WX0/2, WY/2 + 100)
			
			nextBut:addEventListener(Event.TOUCHES_END, function(event)
				if nextBut:hitTestPoint(event.touch.x, event.touch.y) then
					event:stopPropagation()
					Timer.resumeAll()
					Timer.stopAll()
					if self.humanPlayer.skillActive then
						self.humanPlayer.char.skill:endAction()
					end
					if self.aiPlayer.skillActive then
						self.aiPlayer.char.skill:endAction()
					end
					stage:removeChild(gameOverTextBox)
					stage:removeChild(exitBut)
					stage:removeChild(nextBut)
					world:destroyBody(self.ball.body)
					self.ball.body = nil
					world:destroyBody(self.humanPlayer.paddle.body)
					world:destroyBody(self.aiPlayer.paddle.body)
					world:destroyBody(self.bounds)
					
					self.stage = self.stage + 1
					tourTable["QuickTourStage"] = self.stage
					tourTable["QuickTourPoints"] = tourTable["QuickTourPoints"] + 1
					
					local difficulty = self.difFactor*5
					local class = tourTable["QuickTourClass"]
					local class2 = tourTable["QuickTourOpponent"]
					local stage = self.stage
					self = nil
					arena = nil
					
					if optionsTable["SFX"] == "On" then sounds.sel2:play() end
					
					sceneMan:changeScene("tourLevelUp", transTime, SceneManager.fade, easing.linear)
				end
			end)
			
			Timer.delayedCall(transTime/2, function ()
				stage:addChild(nextBut)
			end)
		else
			gameOverString = "You won the Tournament!"
			if optionsTable["Music"] == "On" then
				currSong:stop()
				self.songload = nil
				self.songload = Sound.new(musics.champion[1])
				currSong = nil
				currSong = self.songload:play()
				
				tourTable["QuickTourStage"] = 0
				tourTable["QuickTourAtk"] = 0
				tourTable["QuickTourMov"] = 0
				tourTable["QuickTourLif"] = 0
				tourTable["QuickTourSkl"] = 0
				tourTable["QuickTourDef"] = 0
			end
		end
	else
		gameOverString = "You lost this match... :("
		if optionsTable["Music"] == "On" then
			currSong:stop()
			self.songload = nil
			self.songload = Sound.new(musics.lost)
			currSong = nil
			currSong = self.songload:play()
		end
			
		againBut.bitmap:setPosition(WX0/2, WY/2 + 100)
		
		againBut:addEventListener(Event.TOUCHES_END, function(event)
			if againBut:hitTestPoint(event.touch.x, event.touch.y) then
				event:stopPropagation()
				Timer.resumeAll()
				Timer.stopAll()
				if self.humanPlayer.skillActive then
					self.humanPlayer.char.skill:endAction()
				end
				if self.aiPlayer.skillActive then
					self.aiPlayer.char.skill:endAction()
				end
				stage:removeChild(gameOverTextBox)
				stage:removeChild(exitBut)
				stage:removeChild(againBut)
				world:destroyBody(self.ball.body)
				self.ball.body = nil
				world:destroyBody(self.humanPlayer.paddle.body)
				world:destroyBody(self.aiPlayer.paddle.body)
				world:destroyBody(self.bounds)
				local difficulty = self.difFactor*5
				local class = tourTable["QuickTourClass"]
				local class2 = tourTable["QuickTourOpponent"]
				local stage = self.stage
				self = nil
				arena = nil
				
				if optionsTable["SFX"] == "On" then sounds.sel2:play() end
				
				sceneMan:changeScene("arenaTour", transTime, SceneManager.fade, easing.linear, { userData = {difficulty, class, class2, stage} })
			end
		end)
			
		Timer.delayedCall(transTime/2, function ()
			stage:addChild(againBut)
		end)
	end
	
	gameOverTextBox = TextField.new(self.font, gameOverString)
	gameOverTextBox:setTextColor(0x3c78a0)
	gameOverTextBox:setPosition(0.5*WX0 - gameOverTextBox:getWidth()/2, 0.25*WY + gameOverTextBox:getHeight()/2)
	
	exitBut.bitmap:setPosition(exitBut:getWidth()/2 + 10, WY/2 + 210)
	
	exitBut:addEventListener(Event.TOUCHES_END, function(event)
		if exitBut:hitTestPoint(event.touch.x, event.touch.y) then
			event:stopPropagation()
			Timer.resumeAll()
			Timer.stopAll()
			if self.humanPlayer.skillActive then
				self.humanPlayer.char.skill:endAction()
			end
			if self.aiPlayer.skillActive then
				self.aiPlayer.char.skill:endAction()
			end
			stage:removeChild(gameOverTextBox)
			stage:removeChild(exitBut)
			for i = stage:getNumChildren(), 1, -1 do
				if stage:getChildAt(i) == againBut then
					stage:removeChild(againBut)
				elseif stage:getChildAt(i) == nextBut then
					stage:removeChild(nextBut)
				end
			end
			world:destroyBody(self.ball.body)
			self.ball.body = nil
			world:destroyBody(self.humanPlayer.paddle.body)
			world:destroyBody(self.aiPlayer.paddle.body)
			world:destroyBody(self.bounds)
			
			local quicktourFile = io.open("|D|quicktour.txt", "w+")
			for k, v in pairs(tourTable) do 
				quicktourFile:write(k.."="..v.."\n")
			end	
			
			self = nil
			arena = nil
			
			if optionsTable["SFX"] == "On" then sounds.sel3:play() end
					
			sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear)
		end
	end)
	
	Timer.delayedCall(transTime/2, function ()
		stage:addChild(gameOverTextBox)	
		stage:addChild(exitBut)
	end)
end

-- Function to handle goals
function ArenaTour:checkGoal()
	local ballX, ballY = self.ball.body:getPosition()
	
	local function updateOrReset()
		Timer.stopAll()
		if self.score0 <= 0 or self.score1 <= 0 then
			if self.humanPlayer.skillActive then
				self.humanPlayer.char.skill:endAction()
			end
			if self.aiPlayer.skillActive then
				self.aiPlayer.char.skill:endAction()
			end
			self:gameOver()
		else
			self.combatStats:update(self.score0, self.score1, self.mp0, self.mp1)
			if self.humanPlayer.skillActive then
				self.humanPlayer.char.skill:endAction()
			end
			if self.aiPlayer.skillActive then
				self.aiPlayer.char.skill:endAction()
			end
			self.humanPlayer.char.skill:forceEnd()
			self.aiPlayer.char.skill:forceEnd()
			self.ball:reset()
			self.ball:launch()
			self.humanPlayer.paddle:reset()
			self.aiPlayer.paddle:reset()
			gc()
		end
	end
	
	if ballX > XShift + WX + 2*self.ball.radius then
		self.score1 = self.score1 - 1
		if optionsTable["ArenaSide"] == "Left" then
			if optionsTable["SFX"] == "On" then sounds.goal1:play() end
		else
			if optionsTable["SFX"] == "On" then sounds.goal2:play() end
		end
		updateOrReset()
	elseif ballX <  XShift - 2*self.ball.radius then
		self.score0 = self.score0 - 1
		if optionsTable["ArenaSide"] == "Left" then
			if optionsTable["SFX"] == "On" then sounds.goal2:play() end
		else
			if optionsTable["SFX"] == "On" then sounds.goal1:play() end
		end
		updateOrReset()
	end
end

-- Calls AI movement routines --
function ArenaTour:moveAI()
	self.aiPlayer:aiMove()
	
	-- Call specific class AI --
	self.AI:basicCall()
end

-- Initialization --
function ArenaTour:init(dataTable)
	textures = nil
	textures = TextureLoaderArenaMode.new()
	sounds = nil
	sounds = SoundLoaderArenaMode.new()
	musics = nil
	musics = MusicLoaderArenaMode.new()
	gc()

	if optionsTable["ControlMode"] == "Touch" then	
		WX = 720
		if optionsTable["ArenaSide"] == "Left" then
			XShift = 80
		else
			XShift = 0
		end
	else
		WX = 800
		XShift = 0
	end
	
	local difficulty = dataTable[1]
	local class = dataTable[2]
	local class2 = dataTable[3]
	self.stage = dataTable[4]
	arena = self
	self.font = fonts.anitaBig
	
	-- Stop Current song and load another (bosses if stage == 10) --
	if optionsTable["Music"] == "On" then
		local function nextSong()
			if self.stage < 10 then
				local randNum = math.random(1, 7)
				self.songload = nil
				self.songload = Sound.new(musics.fight[randNum])
			else
				local randNum = math.random(1, 4)
				self.songload = nil
				self.songload = Sound.new(musics.boss[randNum])
			end
			currSong = nil
			currSong = self.songload:play()
			currSong:addEventListener(Event.COMPLETE, nextSong)
			gc()
		end
		
		currSong:stop()
		nextSong()
	end
	
	-- Creates Class Names Table --
	local classNames = {}
	local i = 1
	for k, v in pairs(classTable) do
		classNames[i] = k
		i = i + 1
	end
	
	-- Sets classes --
	if optionsTable["ArenaSide"] == "Left" then
		if(class == "Random") then
			self.leftClass = classNames[math.random(1, tablelength(classNames))]
		else
			self.leftClass = class
		end
		if(class2 == "Random") then
			self.rightClass = classNames[math.random(1, tablelength(classNames))]
		else
			self.rightClass = class2
		end
		self.AI = ArenaAI.new(self.rightClass)
	else
		if(class == "Random") then
			self.rightClass = classNames[math.random(1, tablelength(classNames))]
		else
			self.rightClass = class
		end
		if(class2 == "Random") then
			self.leftClass = classNames[math.random(1, tablelength(classNames))]
		else
			self.leftClass = class2
		end
		self.AI = ArenaAI.new(self.leftClass)
	end
	
	tourTable["QuickTourDif"] = difficulty
	tourTable["QuickTourClass"] = class
	tourTable["QuickTourStage"] = self.stage
	if optionsTable["ArenaSide"] == "Left" then
		tourTable["QuickTourOpponent"] = self.rightClass
	else
		tourTable["QuickTourOpponent"] = self.leftClass
	end
	if self.stage == 1 then
		tourTable["QuickTourAtk"] = 0
		tourTable["QuickTourMov"] = 0
		tourTable["QuickTourLif"] = 0
		tourTable["QuickTourSkl"] = 0
		tourTable["QuickTourDef"] = 0
		tourTable["QuickTourPoints"] = 0
	end
	
	local quicktourFile = io.open("|D|quicktour.txt", "w+")
	for k, v in pairs(tourTable) do 
		quicktourFile:write(k.."="..v.."\n")
	end	
	
	local font = fonts.anitaSmall
	local font2 = fonts.anitaSmaller
	local classText = TextField.new(font, self.leftClass)
	classText:setTextColor(0xffffff)
	classText:setAlpha(0.35)
	classText:setPosition(XShift + 16, 50)
	local classTextAI = TextField.new(font, self.rightClass)
	classTextAI:setTextColor(0xffffff)
	classTextAI:setAlpha(0.35)
	classTextAI:setPosition(XShift + WX - classTextAI:getWidth() - 16, 50)
	
	local stageText = TextField.new(font2, "Tournament: Fight "..self.stage)
	stageText:setTextColor(0xffffff)
	stageText:setAlpha(0.35)
	if optionsTable["ArenaSide"] == "Left" then
		stageText:setPosition(XShift + 16, WY - 24)
	else
		stageText:setPosition(XShift + WX - stageText:getWidth() - 16, WY - 24)
	end
	
	-- Continue as usual --
	self.bitmap = Bitmap.new(textures.pongbg)
	self.bitmap:setScale(1, 1)
	self.difFactor = difficulty/5
	self:addChild(self.bitmap)
	local textureW = self.bitmap:getWidth()
	local textureH = self.bitmap:getHeight()
	self.bitmap:setScale(WX/textureW, WY/textureH)
	if optionsTable["ArenaSide"] == "Left" and optionsTable["ControlMode"] == "Touch" then
		self.bitmap:setPosition(XShift, 0)
	end
	self:createBoundaries()
	
	self:addMenu()

	self:addSkillBut()
	
	if optionsTable["ControlMode"] == "Touch" then
		self:addControlArrows()
	end
	
	self:addChild(classText)
	self:addChild(classTextAI)
	self:addChild(stageText)
	
	self.ball = Ball.new(self.difFactor)
	if optionsTable["ArenaSide"] == "Left" then
		self.leftPlayer = Player.new(0, true, self.difFactor, self.leftClass, -1)
		self.rightPlayer = Player.new(1, false, self.difFactor, self.rightClass, self.stage)
	else
		self.leftPlayer = Player.new(0, false, self.difFactor, self.leftClass, self.stage)
		self.rightPlayer = Player.new(1, true, self.difFactor, self.rightClass, -1)
	end
	
	self.leftPlayer.paddle.bitmap:setColorTransform(classTable[self.leftClass][10][1], classTable[self.leftClass][10][2], classTable[self.leftClass][10][3])
	self.rightPlayer.paddle.bitmap:setColorTransform(classTable[self.rightClass][10][1], classTable[self.rightClass][10][2], classTable[self.rightClass][10][3])
	self.score0 = self.leftPlayer.char.lifFactor
	self.score1 = self.rightPlayer.char.lifFactor
	self.mp0 = self.leftPlayer.char.sklFactor
	self.mp1 = self.rightPlayer.char.sklFactor
	self.combatStats = CombatStats.new()
	self.combatStats:update(self.score0,self.score1, self.mp0, self.mp1)
	self.ball:reset()
	
	if optionsTable["ArenaSide"] == "Left" then
		self.humanPlayer = self.leftPlayer
		self.aiPlayer = self.rightPlayer
	else
		self.humanPlayer = self.rightPlayer
		self.aiPlayer = self.leftPlayer
	end
	
	self:addEventListener("enterEnd", function()
		self.ball:launch()
	end)
	self:addEventListener(Event.ENTER_FRAME, onEnterFrame)
	
	-- Listen to Keys --
	self:addEventListener(Event.KEY_DOWN, onKeyDown)
	self:addEventListener(Event.KEY_UP, onKeyUp)
	
	-- Initialize tilt --
	if optionsTable["ControlMode"] == "Tilt" then
		self:tiltInit()
	end
	
end