--------------------------------------
-- Class for the Classic Mode Arena --
--------------------------------------

ArenaClassic = Core.class(Sprite)

-- Declare Stuff --
ArenaClassic.bitmap = nil
ArenaClassic.bounds = nil
ArenaClassic.score0 = 0
ArenaClassic.score1 = 0
ArenaClassic.difFactor = 5/5 -- 1/5 to 10/5
ArenaClassic.paused = false
ArenaClassic.font = nil
ArenaClassic.pausebg = nil
ArenaClassic.name = "classic"
ArenaClassic.controlarrows = nil
ArenaClassic.accelerometer = nil
ArenaClassic.humanPlayer = nil
ArenaClassic.aiPlayer = nil
ArenaClassic.songload = nil

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
	arena.aiPlayer:aiMove()
	arena:checkGoal()
end

-- Create physics stuff (including collision handler) --
function ArenaClassic:createBoundaries()
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

function ArenaClassic:openMenu()
	if not self.paused then
		self.paused = true
		
		if optionsTable["SFX"] == "On" then sounds.sel_pause:play() end
		
		self:removeEventListener(Event.ENTER_FRAME, onEnterFrame)
		
		self.pausebg = Sprite:new()
		self.pausebg:addChild(Bitmap.new(textures.pausebg))
		
		-- Adds Resume Button --
		local resumeBut = MenuBut.new(192, 40, textures.returnBut, textures.returnBut1)
		resumeBut.bitmap:setPosition(WX0/2, WY0/2 - 2*resumeBut:getHeight())
		resumeBut:addEventListener(Event.TOUCHES_END, function(event)
			if resumeBut:hitTestPoint(event.touch.x, event.touch.y) then
				event:stopPropagation()
				stage:removeChild(self.pausebg)
				self.paused = false
				self:addEventListener(Event.ENTER_FRAME, onEnterFrame)
				
				if optionsTable["SFX"] == "On" then sounds.sel_pause:play() end
			end
		end)
		self.pausebg:addChild(resumeBut)
		
		-- Adds Restart Button --
		local restartBut = MenuBut.new(192, 40, textures.restartBut, textures.restartBut1)
		restartBut.bitmap:setPosition(WX0/2, WY0/2)
		restartBut:addEventListener(Event.TOUCHES_END, function(event)
			if restartBut:hitTestPoint(event.touch.x, event.touch.y) then
				event:stopPropagation()
				stage:removeChild(self.pausebg)

				local difficulty = self.difFactor*5
				
				if optionsTable["SFX"] == "On" then sounds.sel3:play() end
				
				sceneMan:changeScene("classic", transTime, SceneManager.fade, easing.linear, { userData = difficulty })
			end
		end)
		self.pausebg:addChild(restartBut)
		
		-- Adds Quit Button --
		local quitBut = MenuBut.new(192, 40, textures.exitBut, textures.exitBut1)
		quitBut.bitmap:setPosition(WX0/2, WY0/2 + 2*quitBut:getHeight())
		quitBut:addEventListener(Event.TOUCHES_END, function(event)
			if quitBut:hitTestPoint(event.touch.x, event.touch.y) then
				event:stopPropagation()
				stage:removeChild(self.pausebg)
				
				if optionsTable["SFX"] == "On" then sounds.sel3:play() end
				
				sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear)
			end
		end)
		self.pausebg:addChild(quitBut)
		
		stage:addChild(self.pausebg)
	end
end

-- This function creates the in-game menu --
function ArenaClassic:addMenu()
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

-- Inserts control arrows, handles touch--
function ArenaClassic:addControlArrows()
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
function ArenaClassic:tiltInit()
	self.accelerometer = Accelerometer.new()
	self.accelerometer:start()
	afx0 = self.accelerometer:getAcceleration()
end

-- Handles Tilt --
function ArenaClassic:tilt()
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

-- Function to Handle the End of the Match -- 
function ArenaClassic:gameOver()
	self:removeEventListener(Event.ENTER_FRAME, onEnterFrame)
	fadeOut(self)
	
	local bg = Bitmap.new(textures.black)
	bg:setScale(1, 1)
	stage:addChild(bg)
	local textureW = bg:getWidth()
	local textureH = bg:getHeight()
	bg:setScale(WX0/textureW, WY/textureH)
	
	local gameOverString = nil
	local backdrawing = nil
	if (self.score0 > self.score1 and optionsTable["ArenaSide"] == "Left") or (self.score0 < self.score1 and optionsTable["ArenaSide"] == "Right") then
		gameOverString = "Congratulations, you won!"
		
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
	else
		gameOverString = "You lost... :("
		
		backdrawing = Bitmap.new(textures.blackmedal)
		backdrawing:setScale(1, 1)

		local textureW = backdrawing:getWidth()
		local textureH = backdrawing:getHeight()
		backdrawing:setAnchorPoint(0.5, 0.5)
		backdrawing:setScale(WY*0.9/textureH)
		backdrawing:setPosition(WX0/2, WY/2)
		backdrawing:setAlpha(0.5)
		
		if optionsTable["Music"] == "On" then
			currSong:stop()
			self.songload = nil
			self.songload = Sound.new(sounds.losestring)
			currSong = nil
			currSong = self.songload:play()
		end
	end
	local gameOverTextBox = TextField.new(self.font, gameOverString)
	gameOverTextBox:setTextColor(0x419bd7)
	gameOverTextBox:setPosition(0.5*WX0 - gameOverTextBox:getWidth()/2, 0.25*WY + gameOverTextBox:getHeight()/2)
	
	local againBut = MenuBut.new(192, 40, textures.againBut, textures.againBut1)
	againBut.bitmap:setPosition(WX0/2, WY/2 + 100)
	local exitBut = MenuBut.new(192, 40, textures.exitBut, textures.exitBut1)
	exitBut.bitmap:setPosition(exitBut:getWidth()/2 + 10, WY/2 + 210)
	
	againBut:addEventListener(Event.TOUCHES_END, function(event)
		if againBut:hitTestPoint(event.touch.x, event.touch.y) then
			stage:removeChild(gameOverTextBox)
			stage:removeChild(exitBut)
			stage:removeChild(againBut)
			stage:removeChild(backdrawing)
			stage:removeChild(bg)
			
			local difficulty = self.difFactor*5
			
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			
			sceneMan:changeScene("classic", transTime, SceneManager.fade, easing.linear, { userData = difficulty })
		end
	end)
	
	exitBut:addEventListener(Event.TOUCHES_END, function(event)
		if exitBut:hitTestPoint(event.touch.x, event.touch.y) then
			event:stopPropagation()
			stage:removeChild(gameOverTextBox)
			stage:removeChild(exitBut)
			stage:removeChild(againBut)
			stage:removeChild(backdrawing)
			stage:removeChild(bg)
			
			if optionsTable["SFX"] == "On" then sounds.sel3:play() end
			
			sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear)
		end
	end)
	
	Timer.delayedCall(transTime/2, function ()
		stage:addChild(bg)
		stage:addChild(backdrawing)
		stage:addChild(gameOverTextBox)	
		stage:addChild(exitBut)
		stage:addChild(againBut)
	end)
end

-- Function to check and handle goals --
function ArenaClassic:checkGoal()
	local ballX, ballY = self.ball.body:getPosition()
	
	local function updateOrReset()
		if self.score0 >= 10 or self.score1 >= 10 then
			self:gameOver()
		else
			self.combatStats:update(self.score0, self.score1)
			self.ball:reset()
			self.ball:launch()
			self.humanPlayer.paddle:reset()
			self.aiPlayer.paddle:reset()
			gc()
		end
	end
	
	if ballX > WX + XShift + 2*self.ball.radius then
		self.score0 = self.score0 + 1
		if optionsTable["ArenaSide"] == "Left" then
			if optionsTable["SFX"] == "On" then sounds.goal1:play() end
		else
			if optionsTable["SFX"] == "On" then sounds.goal2:play() end
		end
		updateOrReset()
	elseif ballX <  -2*self.ball.radius + XShift then
		self.score1 = self.score1 + 1
		if optionsTable["ArenaSide"] == "Left" then
			if optionsTable["SFX"] == "On" then sounds.goal2:play() end
		else
			if optionsTable["SFX"] == "On" then sounds.goal1:play() end
		end
		updateOrReset()
	end
end

-- Initialization --
function ArenaClassic:init(difficulty)
	stopPhysics()
	goPhysics(PhysicsScale)	

	textures = nil
	textures = TextureLoaderNormalModes.new()
	sounds = nil
	sounds = SoundLoaderNormalModes.new()
	musics = nil
	musics = MusicLoaderNormalModes.new()
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
	arena = self
	self.font = fonts.anitaBig
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
	
	-- Stop Current song and load another (bosses not included) --
	if optionsTable["Music"] == "On" then
		local function nextSong()
			local randNum = math.random(1, 6)
			self.songload = nil
			self.songload = Sound.new(musics.fight[randNum])
			currSong = nil
			currSong = self.songload:play()
			currSong:addEventListener(Event.COMPLETE, nextSong)
			gc()
		end
		
		currSong:stop()
		nextSong()
	end
	
	self:addMenu()
	
	if optionsTable["ControlMode"] == "Touch" then
		self:addControlArrows()
	end
	
	self:createBoundaries()
	
	self.ball = Ball.new(self.difFactor)
	if optionsTable["ArenaSide"] == "Left" then
		self.leftPlayer = Player.new(0, true, self.difFactor, "classic")
		self.rightPlayer = Player.new(1, false, self.difFactor, "classic")
	else
		self.leftPlayer = Player.new(0, false, self.difFactor, "classic")
		self.rightPlayer = Player.new(1, true, self.difFactor, "classic")
	end
	self.combatStats = CombatStats.new()
	self.combatStats:update(self.score0,self.score1)
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