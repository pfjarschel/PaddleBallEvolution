-------------------------------------------------
-- Class for the Arena (or simply background?) --
-------------------------------------------------

ArenaCareer = Core.class(Sprite)

-- Declare stuff --
ArenaCareer.bitmap = nil
ArenaCareer.bounds = nil
ArenaCareer.fixtureT = nil
ArenaCareer.fixtureB = nil
ArenaCareer.score0 = 0
ArenaCareer.score1 = 0
ArenaCareer.difFactor = 5/5 -- 1/5 to 10/5
ArenaCareer.paused = false
ArenaCareer.leftClass = "career"
ArenaCareer.rightClass = "career"
ArenaCareer.font = nil
ArenaCareer.pausebg = nil
ArenaCareer.name = "arena"
ArenaCareer.skillBut = nil
ArenaCareer.controlarrows = nil
ArenaCareer.accelerometer = nil
ArenaCareer.AI = nil
ArenaCareer.humanPlayer = nil
ArenaCareer.aiPlayer = nil
ArenaCareer.songload = nil
ArenaCareer.stage = 1
ArenaCareer.world = 1
ArenaCareer.arenatype = nil
function ArenaCareer:initArena() end
function ArenaCareer:endArena() end
function ArenaArena:unpauseArena() end
function ArenaArena:pauseArena() end

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
function ArenaCareer:createBoundaries()
	self.bounds = world:createBody({}) --Default is Static
	
	self.bounds.name = "bounds"
	
	local shapeT = b2.EdgeShape.new(-200, WBounds, WX0 + 200, WBounds)
	local shapeB = b2.EdgeShape.new(-200, WY-WBounds, WX0 + 200, WY-WBounds)
	
	self.fixtureT = self.bounds:createFixture{
		shape = shapeT, 
		friction = 0,
	}
	self.fixtureT:setFilterData({categoryBits = 4, maskBits = 11, groupIndex = 0})
	self.fixtureB = self.bounds:createFixture{
		shape = shapeB, 
		friction = 0,
	}
	self.fixtureB:setFilterData({categoryBits = 4, maskBits = 11, groupIndex = 0})
	
	function self.bounds:collide(event)
		--print("bounds")
	end
end

-- This is the actual menu --
function ArenaCareer:openMenu()
	Timer:pauseAll()
	if not self.paused then
		self.paused = true
		
		if optionsTable["SFX"] == "On" then sounds.sel_pause:play() end
		
		self:removeEventListener(Event.ENTER_FRAME, onEnterFrame)
		
		self.pausebg = Sprite:new()
		self.pausebg:addChild(Bitmap.new(textures.pausebg))
		
		-- Adds Resume Button --
		local resumeBut = MenuBut.new(192, 40, textures.returnBut, textures.returnBut1)
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
		local restartBut = MenuBut.new(192, 40, textures.restartBut, textures.restartBut1)
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
				self:endArena()
				Timer.resumeAll()
				Timer.stopAll()
				stage:removeChild(self.pausebg)
				
				local stage = self.stage
				local world = self.world
				local arenatype = self.arenatype
				
				if optionsTable["SFX"] == "On" then sounds.sel3:play() end
				
				sceneMan:changeScene("arenaCareer", transTime, SceneManager.fade, easing.linear, { userData = {self.world, self.stage, arenatype} })
			end
		end)
		self.pausebg:addChild(restartBut)
		
		-- Adds Quit Button --
		local quitBut = MenuBut.new(192, 40, textures.exitBut, textures.exitBut1)
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
				self:endArena()
				Timer.resumeAll()
				Timer.stopAll()
				stage:removeChild(self.pausebg)
								
				if optionsTable["SFX"] == "On" then sounds.sel3:play() end
				
				sceneMan:changeScene("worldSel", transTime, SceneManager.fade, easing.linear)
			end
		end)
		self.pausebg:addChild(quitBut)
		
		stage:addChild(self.pausebg)
	end
end

-- This function creates the in-game menu --
function ArenaCareer:addMenu()
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
function ArenaCareer:addSkillBut()
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
function ArenaCareer:addControlArrows()
	local controlarrows = Bitmap.new(textures.controlarrows)
	controlarrows:setScale(1, 1)
	self:addChild(controlarrows)
	local textureW = controlarrows:getWidth()
	local textureH = controlarrows:getHeight()
	controlarrows:setScale(81/textureW, WY/textureH)
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
function ArenaCareer:tiltInit()
	self.accelerometer = Accelerometer.new()
	self.accelerometer:start()
	afx0 = self.accelerometer:getAcceleration()
end

-- Handles Tilt --
function ArenaCareer:tilt()
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
	if event.keyCode == 303 or event.keyCode == 306 then
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
		if event.keyCode >= 65 and event.keyCode <= 90 then
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
function ArenaCareer:gameOver()
	self:removeEventListener(Event.ENTER_FRAME, onEnterFrame)
	fadeOut(self)
	
	local bg = Bitmap.new(textures.black)
	bg:setScale(1, 1)
	stage:addChild(bg)
	local textureW = bg:getWidth()
	local textureH = bg:getHeight()
	bg:setScale(WX0/textureW, WY/textureH)
	
	local gameOverString = nil
	local gameOverTextBox = nil
	local backdrawing = nil
	local exitBut = MenuBut.new(192, 40, textures.exitBut, textures.exitBut1)
	local againBut = MenuBut.new(192, 40, textures.restartBut, textures.restartBut1)
	local nextBut = MenuBut.new(192, 40, textures.nextBut, textures.nextBut1)
	
	if (self.score0 > self.score1 and optionsTable["ArenaSide"] == "Left") or (self.score0 < self.score1 and optionsTable["ArenaSide"] == "Right") then
		if self.stage < 5 then
			if self.stage == 4 then
				gameOverString = "You won this match!\n".."Prepare for the Local Boss Fight!\n"
			else
				gameOverString = "You won this match!\n".."Now continue to the next stage!\n"
			end
			
			backdrawing = Bitmap.new(textures.medal)
			backdrawing:setScale(1, 1)
			local textureW = backdrawing:getWidth()
			local textureH = backdrawing:getHeight()
			backdrawing:setAnchorPoint(0.5, 0.5)
			backdrawing:setScale(WY*0.9/textureH)
			backdrawing:setPosition(WX0/2, WY/2)
			backdrawing:setAlpha(0.3)
			
			if optionsTable["Music"] == "On" then
				currSong:stop()
				self.songload = nil
				self.songload = Sound.new(sounds.winstring)
				currSong = nil
				currSong = self.songload:play()
			end
			
			careerTable["Stage"] = tonumber(careerTable["Stage"]) + 1
			local careerFile = io.open("|D|career.txt", "w+")
			for k, v in pairs(careerTable) do 
				careerFile:write(k.."="..v.."\n")
			end	
			careerFile:close()
			
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
					self:endArena()
					stage:removeChild(gameOverTextBox)
					stage:removeChild(exitBut)
					stage:removeChild(nextBut)
					stage:removeChild(backdrawing)
					stage:removeChild(bg)
					
					if optionsTable["SFX"] == "On" then sounds.sel2:play() end
					
					sceneMan:changeScene("worldSel", transTime, SceneManager.fade, easing.linear)
				end
			end)
			
			Timer.delayedCall(transTime/2, function ()
				stage:addChild(bg)
				stage:addChild(backdrawing)
				stage:addChild(nextBut)
			end)
		else
			if self.world < tablelength(Worlds) then
				gameOverString = "You completed this World!\n".."Skill learned: "..skillTable[Worlds[tonumber(careerTable["World"])]["Skill"]]["Name"].."\n"
			else
				gameOverString = "You saved the Universe!\n".."Congratulations, you deserve it! \\o/ \n"
			end
			if optionsTable["Music"] == "On" then
				currSong:stop()
				self.songload = nil
				self.songload = Sound.new(musics.champion[1])
				currSong = nil
				currSong = self.songload:play()
			end
			
			backdrawing = Bitmap.new(textures.trophy)
			backdrawing:setScale(1, 1)

			local textureW = backdrawing:getWidth()
			local textureH = backdrawing:getHeight()
			backdrawing:setAnchorPoint(0.5, 0.5)
			backdrawing:setScale(WY*1.2/textureH)
			backdrawing:setPosition(WX0/2, WY/2)
			backdrawing:setAlpha(0.4)
			
			careerTable["World"] = tonumber(careerTable["World"]) + 1
			careerTable["Stage"] = 1
			careerTable["Points"] = tonumber(careerTable["Points"]) + 3
			careerTable["CurSkill"] = Worlds[tonumber(careerTable["World"]) - 1]["Skill"]
			local careerFile = io.open("|D|career.txt", "w+")
			for k, v in pairs(careerTable) do 
				careerFile:write(k.."="..v.."\n")
			end	
			careerFile:close()
			
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
					self:endArena()
					stage:removeChild(gameOverTextBox)
					stage:removeChild(exitBut)
					stage:removeChild(nextBut)
					stage:removeChild(backdrawing)
					stage:removeChild(bg)
					
					if optionsTable["SFX"] == "On" then sounds.sel2:play() end
					
					sceneMan:changeScene("careerStats", transTime, SceneManager.fade, easing.linear)
				end
			end)
			
			Timer.delayedCall(transTime/2, function ()
				stage:addChild(bg)
				stage:addChild(backdrawing)
				stage:addChild(nextBut)
			end)
		end
	else
		gameOverString = "You lost this match... :(\n".."But you can always try again!\n"
		if optionsTable["Music"] == "On" then
			currSong:stop()
			self.songload = nil
			self.songload = Sound.new(musics.lost)
			currSong = nil
			currSong = self.songload:play()
		end
		
		backdrawing = Bitmap.new(textures.blackmedal)
		backdrawing:setScale(1, 1)

		local textureW = backdrawing:getWidth()
		local textureH = backdrawing:getHeight()
		backdrawing:setAnchorPoint(0.5, 0.5)
		backdrawing:setScale(WY*0.9/textureH)
		backdrawing:setPosition(WX0/2, WY/2)
		backdrawing:setAlpha(0.5)
			
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
				self:endArena()
				stage:removeChild(gameOverTextBox)
				stage:removeChild(exitBut)
				stage:removeChild(againBut)
				stage:removeChild(backdrawing)
				stage:removeChild(bg)
				
				local stage = self.stage
				local world = self.world
				local arenatype = self.arenatype
				
				sceneMan:changeScene("arenaCareer", transTime, SceneManager.fade, easing.linear, { userData = {self.world, self.stage, arenatype} })
			end
		end)
			
		Timer.delayedCall(transTime/2, function ()
			stage:addChild(bg)
			stage:addChild(backdrawing)
			stage:addChild(againBut)
		end)
	end
	
	gameOverTextBox = TextWrap.new(gameOverString, WX0, "center", 32, self.font)
	gameOverTextBox:setTextColor(0x50b0ff)
	gameOverTextBox:setPosition(0.5*WX0 - gameOverTextBox:getWidth()/2, 0*WY + gameOverTextBox:getHeight()/2)
	
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
			self:endArena()
			stage:removeChild(gameOverTextBox)
			stage:removeChild(exitBut)
			for i = stage:getNumChildren(), 1, -1 do
				if stage:getChildAt(i) == againBut then
					stage:removeChild(againBut)
				elseif stage:getChildAt(i) == nextBut then
					stage:removeChild(nextBut)
				end
			end
			stage:removeChild(bg)
			stage:removeChild(backdrawing)
						
			self = nil
			arena = nil
			
			if optionsTable["SFX"] == "On" then sounds.sel3:play() end
					
			sceneMan:changeScene("mainMenu_Career", transTime, SceneManager.fade, easing.linear)
		end
	end)
	
	Timer.delayedCall(transTime/2, function ()
		stage:addChild(gameOverTextBox)	
		stage:addChild(exitBut)
	end)
end

-- Function to handle goals
function ArenaCareer:checkGoal()
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
			self:endArena()
			self.ball:reset()
			self.ball:launch()
			self.humanPlayer.paddle:reset()
			self.aiPlayer.paddle:reset()
			self:initArena()
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
function ArenaCareer:moveAI()
	self.aiPlayer:aiMove()
	
	-- Call specific class AI --
	self.AI:basicCall()
end

-- Initialization --
function ArenaCareer:init(dataTable)
	stopPhysics()
	goPhysics(PhysicsScale)	
	textures = nil
	textures = TextureLoaderArenaMode.new()
	sounds = nil
	sounds = SoundLoaderArenaMode.new()
	musics = nil
	musics = MusicLoaderArenaMode.new()
	gc()
	
	local difficulty = careerTable["Dif"]
	self.world = dataTable[1]
	self.stage = dataTable[2]
	self.arenatype = dataTable[3]
	arena = self
	self.font = fonts.anitaBig

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
	
	-- Stop Current song and load another (bosses if stage == 10) --
	if optionsTable["Music"] == "On" then
		local function nextSong()
			if self.stage < 5 then
				local randNum = math.random(1, 6)
				self.songload = nil
				self.songload = Sound.new(musics.fight[randNum])
			else
				local randNum = math.random(1, 3)
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
		
	-- Selects Arena Type --
	if self.arenatype == "new" then
		self.arenatype = Worlds[self.world]["Arenas"][math.random(1,tablelength(Worlds[self.world]["Arenas"]))]
	end
	
	local font = fonts.anitaSmall
	local font2 = fonts.anitaSmaller
	local classText = nil
	local classTextAI = nil
	if optionsTable["ArenaSide"] == "Left" then
		classText = TextField.new(font, "You")
		if self.stage ~= 5 then
			classTextAI = TextField.new(font, Worlds[self.world]["Thug"])
		else
			classTextAI = TextField.new(font, Worlds[self.world]["Boss"])
		end
	else
		classTextAI = TextField.new(font, "You")
		if self.stage ~= 5 then
			classText = TextField.new(font, Worlds[self.world]["Thug"])
		else
			classText = TextField.new(font, Worlds[self.world]["Boss"])
		end
	end
	classText:setTextColor(0xffffff)
	classText:setAlpha(0.35)
	classText:setPosition(XShift + 16, 50)
	classTextAI:setTextColor(0xffffff)
	classTextAI:setAlpha(0.35)
	classTextAI:setPosition(XShift + WX - classTextAI:getWidth() - 16, 50)
	
	local stagename = "Fight "..self.stage
	if stagename == "Fight 5" then
		stagename = "Boss Fight!"
	end
	local stageText = TextField.new(font2, Worlds[self.world]["Name"]..": "..stagename)
	stageText:setTextColor(0xffffff)
	stageText:setAlpha(0.35)
	if optionsTable["ArenaSide"] == "Left" then
		stageText:setPosition(XShift + 16, WY - 24)
	else
		stageText:setPosition(XShift + WX - stageText:getWidth() - 16, WY - 24)
	end
	
	-- Continue as usual --
	
	-- Arena BG --
	if self.arenatype ~= "Normal" then
		self.arenabg = Bitmap.new(Texture.new(arenasTable[self.arenatype]["Image"], true))
		self.arenabg:setScale(1, 1)
		self:addChild(self.arenabg)
		local textureWbg = self.arenabg:getWidth()
		local textureHbg = self.arenabg:getHeight()
		self.arenabg:setScale(WX/textureWbg, WY/textureHbg)
		if optionsTable["ArenaSide"] == "Left" and optionsTable["ControlMode"] == "Touch" then
			self.arenabg:setPosition(XShift, 0)
		end
		
		self.initArena = arenasTable[self.arenatype]["Init"]
		self.endArena = arenasTable[self.arenatype]["End"]
		self.unpauseArena = arenasTable[self.arenatype]["Unpause"]
		self.pauseArena = arenasTable[self.arenatype]["Pause"]
	end
	
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
		self.leftPlayer = Player.new(0, true, self.difFactor, self.leftClass, -1, self.world)
		self.rightPlayer = Player.new(1, false, self.difFactor, self.rightClass, self.stage, self.world)
		self.leftPlayer.paddle.bitmap:setColorTransform(tonumber(careerTable["R"])/255, tonumber(careerTable["G"])/255, tonumber(careerTable["B"])/255, 1)
		self.rightPlayer.paddle.bitmap:setColorTransform(math.random(0, 1000)/1000, math.random(0, 1000)/1000, math.random(0, 1000)/1000, 1)
	
	else
		self.leftPlayer = Player.new(0, false, self.difFactor, self.leftClass, self.stage, self.world)
		self.rightPlayer = Player.new(1, true, self.difFactor, self.rightClass, -1, self.world)
		self.rightPlayer.paddle.bitmap:setColorTransform(careerTable["R"], careerTable["G"], careerTable["B"], 1)
		self.leftPlayer.paddle.bitmap:setColorTransform(math.random(0, 1000)/1000, math.random(0, 1000)/1000, math.random(0, 1000)/1000, 1)
	end
	
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
		self.AI = ArenaAI.new(self.rightPlayer.char.skill.skill)
	else
		self.humanPlayer = self.rightPlayer
		self.aiPlayer = self.leftPlayer
		self.AI = ArenaAI.new(self.leftPlayer.char.skill.skill)
	end
	
	self:addEventListener("enterEnd", function()
		self.ball:launch()
	end)
	self:addEventListener(Event.ENTER_FRAME, onEnterFrame)
	
	self:initArena()
	
	-- Listen to Keys --
	self:addEventListener(Event.KEY_DOWN, onKeyDown)
	self:addEventListener(Event.KEY_UP, onKeyUp)
	
	-- Initialize tilt --
	if optionsTable["ControlMode"] == "Tilt" then
		self:tiltInit()
	end
	
end