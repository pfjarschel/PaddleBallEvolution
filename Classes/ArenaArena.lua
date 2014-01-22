-------------------------------------------------
-- Class for the Arena (or simply background?) --
-------------------------------------------------

ArenaArena = Core.class(Sprite)

-- Declare stuff --
ArenaArena.bitmap = nil
ArenaArena.bounds = nil
ArenaArena.score0 = 0
ArenaArena.score1 = 0
ArenaArena.difFactor = 5/5 -- 1/5 to 10/5
ArenaArena.paused = false
ArenaArena.leftClass = "classic"
ArenaArena.rightClass = "classic"
ArenaArena.font = nil
ArenaArena.pausebg = nil
ArenaArena.name = "arena"
ArenaArena.controlarrows = nil
ArenaArena.accelerometer = nil
ArenaArena.AI = nil

-- Tilt variables --
local afx = 0
local afy = 0
local afz = 0
local afx0 = 0

-- Main Match Loop --
local function onEnterFrame()
	updatePhysics()
	if controlMethod == "Tilt" then
		arena:tilt()
	end
	arena.leftPlayer:humanMove()
	--arena.rightPlayer:humanMove()
	arena:moveAI()
	arena:checkGoal()
end

-- Create physics stuff (including collision handler)
function ArenaArena:createBoundaries()
	self.bounds = world:createBody({}) --Default is Static
	self.bounds.name = "bounds"
	local shapeT = b2.EdgeShape.new(-200, WBounds, WX + 200, WBounds)
	local shapeB = b2.EdgeShape.new(-200, WY-WBounds, WX + 200, WY-WBounds)
	self.bounds:createFixture{
		shape = shapeT, 
		friction = 0,
	}
	self.bounds:createFixture{
		shape = shapeB, 
		friction = 0,
	}
	function self.bounds:collide(event)
		--print("bounds")
	end
end

-- This is the actual menu --
function ArenaArena:openMenu()
	Timer:pauseAll()
	if not self.paused then
		self.paused = true
		self:removeEventListener(Event.ENTER_FRAME, onEnterFrame)
		
		self.pausebg = Sprite:new()
		self.pausebg:addChild(Bitmap.new(textures.pausebg))
		
		-- Adds Resume Button --
		local resumeBut = MenuBut.new(150, 40, textures.returnBut, textures.returnBut1)
		resumeBut.bitmap:setPosition(WX/2, WY/2 - 2*resumeBut:getHeight())
		resumeBut:addEventListener(Event.TOUCHES_END, function(event)
			if resumeBut:hitTestPoint(event.touch.x, event.touch.y) then
				event:stopPropagation()
				Timer:resumeAll()
				stage:removeChild(self.pausebg)
				self.paused = false
				self:addEventListener(Event.ENTER_FRAME, onEnterFrame)
			end
		end)
		self.pausebg:addChild(resumeBut)
		
		-- Adds Restart Button --
		local restartBut = MenuBut.new(150, 40, textures.restartBut, textures.restartBut1)
		restartBut.bitmap:setPosition(WX/2, WY/2)
		restartBut:addEventListener(Event.TOUCHES_END, function(event)
			if restartBut:hitTestPoint(event.touch.x, event.touch.y) then
				event:stopPropagation()
				Timer.resumeAll()
				Timer.stopAll()
				self.leftPlayer.char.skill:endAction()
				self.rightPlayer.char.skill:endAction()
				stage:removeChild(self.pausebg)
				world:destroyBody(self.ball.body)
				self.ball.body = nil
				world:destroyBody(self.leftPlayer.paddle.body)
				world:destroyBody(self.rightPlayer.paddle.body)
				world:destroyBody(self.bounds)
				local difficulty = self.difFactor*5
				local class = self.leftClass
				local classAI = self.rightClass
				self = nil
				arena = nil
				sceneMan:changeScene("arena", transTime, SceneManager.fade, easing.linear, { userData = {difficulty, class, classAI} })
			end
		end)
		self.pausebg:addChild(restartBut)
		
		-- Adds Quit Button --
		local quitBut = MenuBut.new(150, 40, textures.exitBut, textures.exitBut1)
		quitBut.bitmap:setPosition(WX/2, WY/2 + 2*quitBut:getHeight())
		quitBut:addEventListener(Event.TOUCHES_END, function(event)
			if quitBut:hitTestPoint(event.touch.x, event.touch.y) then
				event:stopPropagation()
				Timer.resumeAll()
				Timer.stopAll()
				self.leftPlayer.char.skill:endAction()
				self.rightPlayer.char.skill:endAction()
				stage:removeChild(self.pausebg)
				world:destroyBody(self.ball.body)
				self.ball.body = nil
				world:destroyBody(self.leftPlayer.paddle.body)
				world:destroyBody(self.rightPlayer.paddle.body)
				world:destroyBody(self.bounds)
				self = nil
				arena = nil
				sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear)
			end
		end)
		self.pausebg:addChild(quitBut)
		
		stage:addChild(self.pausebg)
	end
end

-- This function creates the in-game menu --
function ArenaArena:addMenu()
	-- Adds Menu Button --
	local menuBut = MenuBut.new(60, 60, textures.menuBut, textures.menuBut1)
	menuBut.bitmap:setPosition(WX - menuBut.bitmap:getWidth()/1.5, WY - menuBut.bitmap:getHeight())
	menuBut:setAlpha(0.4)
	self:addChild(menuBut)
	menuBut:addEventListener(Event.TOUCHES_END, function(event)
		if menuBut:hitTestPoint(event.touch.x, event.touch.y) then
			event:stopPropagation()
			self:openMenu()
		end
	end)
end

-- Inserts Skill Button (Left Player only) --
function ArenaArena:addSkillBut()
	local skillBut = MenuBut.new(60, 60, textures.skillBut, textures.skillBut1)
	skillBut.bitmap:setPosition(WX/4, WY - skillBut.bitmap:getHeight())
	skillBut:setAlpha(0.5)
	self:addChild(skillBut)
	
	skillBut:addEventListener(Event.TOUCHES_END, function(event)
		-- Skill needs to be inactive (over) to function, and ball launched --
		if skillBut:hitTestPoint(event.touch.x, event.touch.y) then
			event:stopPropagation()
			if self.leftPlayer.skillActive == false	and self.ball.launched and self.mp0 > 0 then
				self.leftPlayer.char.skill:start(0)
				self.leftPlayer.skillActive = true
				self.mp0 = self.mp0 - 1
				self.combatStats:update(self.score0, self.score1, self.mp0, self.mp1)
			end
		end
	end)
end

-- Inserts control arrows, handles touch --
function ArenaArena:addControlArrows()
	local controlarrows = Bitmap.new(textures.controlarrows)
	controlarrows:setScale(1, 1)
	self:addChild(controlarrows)
	local textureW = controlarrows:getWidth()
	local textureH = controlarrows:getHeight()
	controlarrows:setScale(WX*0.1/textureW, WY/textureH)
	controlarrows:setPosition(3*WX/4 - controlarrows:getWidth()/2, WY/2 - controlarrows:getHeight()/2)
	controlarrows:setAlpha(0.4)
	
	controlarrows:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if not arena.paused and controlarrows:hitTestPoint(event.touch.x, event.touch.y) then
			self.leftPlayer.touchY = event.touch.y
		end
	end)
	controlarrows:addEventListener(Event.TOUCHES_MOVE, function(event)
		if not arena.paused and controlarrows:hitTestPoint(event.touch.x, event.touch.y) then
			self.leftPlayer.touchY = event.touch.y
		end
	end)
	controlarrows:addEventListener(Event.TOUCHES_END, function(event)
		
	end)
end

-- Initialize Tilt --
function ArenaArena:tiltInit()
	self.accelerometer = Accelerometer.new()
	self.accelerometer:start()
	afx0 = self.accelerometer:getAcceleration()
end

-- Handles Tilt --
function ArenaArena:tilt()
	if not arena.paused then
		local x, y, z = self.accelerometer:getAcceleration()
		local filter = 0.1;
		afx = x * filter + afx * (1 - filter)
		afy = y * filter + afy * (1 - filter)
		afz = z * filter + afz * (1 - filter)
		
		self.leftPlayer.touchY = WY/2 - (afx - afx0)*WY *1.5
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
	if controlMethod == "Keys" then
		if event.keyCode == 40 then
			arena.leftPlayer.touchY = WY
		end
		if event.keyCode == 38 then
			arena.leftPlayer.touchY = 0
		end
		if event.keyCode == 89 then
			if arena.leftPlayer.skillActive == false and arena.ball.launched and arena.mp0 > 0 then
				arena.leftPlayer.char.skill:start(0)
				arena.leftPlayer.skillActive = true
				arena.mp0 = arena.mp0 - 1
				arena.combatStats:update(arena.score0, arena.score1, arena.mp0, arena.mp1)
			end
		end
	end
end
local function onKeyUp(event)
	if controlMethod == "Keys" then
		if event.keyCode == 40 then
			local posx, posy = arena.leftPlayer.paddle.body:getPosition()
			arena.leftPlayer.touchY = posy
		end
		if event.keyCode == 38 then
			local posx, posy = arena.leftPlayer.paddle.body:getPosition()
			arena.leftPlayer.touchY = posy
		end
	end
end

-- Handles the end of the match --
function ArenaArena:gameOver()
	self:removeEventListener(Event.ENTER_FRAME, onEnterFrame)
	fadeOut(self)
	
	local gameOverString = nil
	if self.score0 > self.score1 then
		gameOverString = "Congratulations, you won!"
		sounds.win:play()
	else
		gameOverString = "You lost... :("
		sounds.lose:play()
	end
	local gameOverTextBox = TextField.new(self.font, gameOverString)
	gameOverTextBox:setTextColor(0x3c78a0)
	gameOverTextBox:setPosition(0.5*WX - gameOverTextBox:getWidth()/2, 0.25*WY + gameOverTextBox:getHeight()/2)
	
	local againBut = MenuBut.new(150, 40, textures.againBut, textures.againBut1)
	againBut.bitmap:setPosition(WX/2, WY/2 + 100)
	local exitBut = MenuBut.new(150, 40, textures.exitBut, textures.exitBut1)
	exitBut.bitmap:setPosition(exitBut:getWidth()/2 + 10, WY/2 + 210)
	
	againBut:addEventListener(Event.TOUCHES_END, function(event)
		if againBut:hitTestPoint(event.touch.x, event.touch.y) then
			stage:removeChild(gameOverTextBox)
			stage:removeChild(returnBut)
			stage:removeChild(againBut)
			world:destroyBody(self.ball.body)
			self.ball.body = nil
			world:destroyBody(self.leftPlayer.paddle.body)
			world:destroyBody(self.rightPlayer.paddle.body)
			world:destroyBody(self.bounds)
			local difficulty = self.difFactor*5
			local class = self.leftClass
			local classAI = self.rightClass
			self = nil
			arena = nil
			sceneMan:changeScene("arena", transTime, SceneManager.fade, easing.linear, { userData = {difficulty, class, classAI} })
		end
	end)
	
	exitBut:addEventListener(Event.TOUCHES_END, function(event)
		if exitBut:hitTestPoint(event.touch.x, event.touch.y) then
			event:stopPropagation()
			Timer.resumeAll()
			Timer.stopAll()
			self.leftPlayer.char.skill:endAction()
			self.rightPlayer.char.skill:endAction()
			stage:removeChild(gameOverTextBox)
			stage:removeChild(returnBut)
			stage:removeChild(againBut)
			world:destroyBody(self.ball.body)
			self.ball.body = nil
			world:destroyBody(self.leftPlayer.paddle.body)
			world:destroyBody(self.rightPlayer.paddle.body)
			world:destroyBody(self.bounds)
			self = nil
			arena = nil
			sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear)
		end
	end)
	
	Timer.delayedCall(transTime/2, function ()
		stage:addChild(gameOverTextBox)	
		stage:addChild(returnBut)
		stage:addChild(againBut)
	end)
end

-- Function to handle goals
function ArenaArena:checkGoal()
	local ballX, ballY = self.ball.body:getPosition()
	
	local function updateOrReset()
		if self.score0 <= 0 or self.score1 <= 0 then
			self.leftPlayer.skillActive = false
			self.rightPlayer.skillActive = false
			Timer.stopAll()
			self.leftPlayer.char.skill:endAction()
			self.rightPlayer.char.skill:endAction()
			self:gameOver()
		else
			self.combatStats:update(self.score0, self.score1, self.mp0, self.mp1)
			self.leftPlayer.skillActive = false
			self.rightPlayer.skillActive = false
			Timer.stopAll()
			self.leftPlayer.char.skill:endAction()
			self.rightPlayer.char.skill:endAction()
			self.ball:reset()
			self.ball:launch()
			self.leftPlayer.paddle:reset()
			self.rightPlayer.paddle:reset()
			gc()
		end
	end
	
	if ballX > WX + 2*self.ball.radius then
		self.score1 = self.score1 - 1
		sounds.goal1:play()
		updateOrReset()
	elseif ballX <  -2*self.ball.radius then
		self.score0 = self.score0 - 1
		sounds.goal2:play()
		updateOrReset()
	end
end

-- Calls AI movement routines --
function ArenaArena:moveAI()
	--self.leftPlayer:aiMove(self.ball)
	self.rightPlayer:aiMove(self.ball)
	
	-- Call specific class AI --
	self.AI:basicCall()
end

-- Initialization --
function ArenaArena:init(dataTable)
	local difficulty = dataTable[1]
	local class = dataTable[2]
	local classAI = dataTable[3]
	arena = self
	self.font = fonts.arialroundedBig
	
	-- Creates Class Names Table --
	local classNames = {}
	local i = 1
	for k, v in pairs(classTable) do
		classNames[i] = k
		i = i + 1
	end
	
	-- Sets classes --
	if(class == "Random") then
		self.leftClass = classNames[math.random(1, tablelength(classNames))]
	else
		self.leftClass = class
	end
	if(classAI == "Random") then
		self.rightClass = classNames[math.random(1, tablelength(classNames))]
	else
		self.rightClass = classAI
	end
	self.AI = ArenaAI.new(self.rightClass)
	
	local font = fonts.arialroundedSmall
	local classText = TextField.new(font, self.leftClass)
	classText:setTextColor(0xffffff)
	classText:setAlpha(0.25)
	classText:setPosition(16, 50)
	local classTextAI = TextField.new(font, self.rightClass)
	classTextAI:setTextColor(0xffffff)
	classTextAI:setAlpha(0.25)
	classTextAI:setPosition(WX - classTextAI:getWidth() - 16, 50)
	
	-- Continue as usual --
	self.bitmap = Bitmap.new(textures.pongbg)
	self.bitmap:setScale(1, 1)
	self.difFactor = difficulty/5
	self:addChild(self.bitmap)
	local textureW = self.bitmap:getWidth()
	local textureH = self.bitmap:getHeight()
	self.bitmap:setScale(WX/textureW, WY/textureH)
	self:createBoundaries()
	
	self:addMenu()

	self:addSkillBut()
	
	if controlMethod == "Touch" then
		self:addControlArrows()
	end
	
	self:addChild(classText)
	self:addChild(classTextAI)
	
	self.ball = Ball.new(self.difFactor)
	self.leftPlayer = Player.new(0, true, self.difFactor, self.leftClass)
	self.rightPlayer = Player.new(1, false, self.difFactor, self.rightClass)
	self.leftPlayer.paddle.bitmap:setColorTransform(self.leftPlayer.char.atk/30, self.leftPlayer.char.def/30, self.leftPlayer.char.mov/30, 1)
	self.rightPlayer.paddle.bitmap:setColorTransform(self.rightPlayer.char.atk/30, self.rightPlayer.char.def/30, self.rightPlayer.char.mov/30, 1)
	self.score0 = self.leftPlayer.char.lifFactor
	self.score1 = self.rightPlayer.char.lifFactor
	self.mp0 = self.leftPlayer.char.sklFactor
	self.mp1 = self.rightPlayer.char.sklFactor
	self.combatStats = CombatStats.new()
	self.combatStats:update(self.score0,self.score1, self.mp0, self.mp1)
	self.ball:reset()
	
	self:addEventListener("enterEnd", function()
		self.ball:launch()
	end)
	self:addEventListener(Event.ENTER_FRAME, onEnterFrame)
	
	-- Listen to Keys --
	self:addEventListener(Event.KEY_DOWN, onKeyDown)
	self:addEventListener(Event.KEY_UP, onKeyUp)
	
	-- Initialize tilt --
	if controlMethod == "Tilt" then
		self:tiltInit()
	end
	
end