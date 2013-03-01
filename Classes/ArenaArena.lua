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

-- Main Match Loop --
local function onEnterFrame()
	updatePhysics()
	arena.leftPlayer:aiMove()
	arena.leftPlayer:humanMove()
	arena.rightPlayer:aiMove()
	arena.rightPlayer:humanMove()
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
		self.pausebg:addChild(textures.pausebg)
		
		-- Adds Resume Button --
		local resumeBut = MenuBut.new(textures.returnBut, 150, 40)
		resumeBut.bitmap:setPosition(WX/2, WY/2 - 2*resumeBut:getHeight())
		resumeBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
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
		local restartBut = MenuBut.new(textures.againBut, 150, 40)
		restartBut.bitmap:setPosition(WX/2, WY/2)
		restartBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
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
				self = nil
				arena = nil
				sceneMan:changeScene("arena", transTime, SceneManager.fade, easing.linear, { userData = {difficulty, class} })
			end
		end)
		self.pausebg:addChild(restartBut)
		
		-- Adds Quit Button --
		local quitBut = MenuBut.new(textures.exitBut, 150, 40)
		quitBut.bitmap:setPosition(WX/2, WY/2 + 2*quitBut:getHeight())
		quitBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
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
	local menuBut = MenuBut.new(textures.menuBut, 60, 60)
	menuBut.bitmap:setPosition(WX - menuBut.bitmap:getWidth()/2, WY - menuBut.bitmap:getHeight()/2)
	menuBut:setAlpha(0.4)
	self:addChild(menuBut)
	menuBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if menuBut:hitTestPoint(event.touch.x, event.touch.y) then
			event:stopPropagation()
			self:openMenu()
		end
	end)
end

-- Inserts Skill Button (Left Player only) --
function ArenaArena:addSkillBut()
	local skillBut = MenuBut.new(textures.skillBut, 60, 60)
	skillBut.bitmap:setPosition(WX/4, WY - skillBut.bitmap:getHeight()/2)
	skillBut:setAlpha(0.5)
	self:addChild(skillBut)
	
	skillBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		-- Skill needs to be inactive (over) to function, and ball launched --
		if skillBut:hitTestPoint(event.touch.x, event.touch.y) then
			event:stopPropagation()
			if self.leftPlayer.skillActive == false	and self.ball.launched then
				self.leftPlayer.char.skill:start(0)
				self.leftPlayer.skillActive = true
			end
		end
	end)
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
	
	local againBut = MenuBut.new(textures.againBut, 150, 40)
	againBut.bitmap:setPosition(WX/2, WY/2 + 100)
	local returnBut = MenuBut.new(textures.returnBut, 150, 40)
	returnBut.bitmap:setPosition(returnBut:getWidth()/2 + 10, WY/2 + 210)
	
	againBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
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
			self = nil
			arena = nil
			sceneMan:changeScene("arena", transTime, SceneManager.fade, easing.linear, { userData = {difficulty, class} })
		end
	end)
	
	returnBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if returnBut:hitTestPoint(event.touch.x, event.touch.y) then
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
			self.combatStats:update(self.score0, self.score1)
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
	self.leftPlayer:aiMove(self.ball)
	self.rightPlayer:aiMove(self.ball)
	
	-- Randomly activates AI skill --
	local num = math.random(1,1000) -- Debug mode, frequent calls
	if num == 1 and self.rightPlayer.skillActive == false then
		self.rightPlayer.char.skill:start(1)
		self.rightPlayer.skillActive = true
	end
end

-- Initialization --
function ArenaArena:init(dataTable)
	local difficulty = dataTable[1]
	local class = dataTable[2]
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
	self.leftClass = class
	self.rightClass = classNames[math.random(1, tablelength(classNames))]
	
	-- Continue as usual --
	self.bitmap = textures.pongbg
	self.bitmap:setScale(1, 1)
	self.difFactor = difficulty/5
	self:addChild(self.bitmap)
	local textureW = self.bitmap:getWidth()
	local textureH = self.bitmap:getHeight()
	self.bitmap:setScale(WX/textureW, WY/textureH)
	self:createBoundaries()
	
	self:addMenu()

	self:addSkillBut()
	
	self.ball = Ball.new(self.difFactor)
	self.leftPlayer = Player.new(0, true, self.difFactor, self.leftClass)
	self.rightPlayer = Player.new(1, false, self.difFactor, self.rightClass)
	self.leftPlayer.paddle.bitmap:setColorTransform(self.leftPlayer.char.atk/30, self.leftPlayer.char.def/30, self.leftPlayer.char.mov/30, 1)
	self.rightPlayer.paddle.bitmap:setColorTransform(self.rightPlayer.char.atk/30, self.rightPlayer.char.def/30, self.rightPlayer.char.mov/30, 1)
	self.score0 = self.leftPlayer.char.lifFactor
	self.score1 = self.rightPlayer.char.lifFactor
	self.combatStats = CombatStats.new()
	self.combatStats:update(self.score0,self.score1)
	self.ball:reset()
	
	self:addEventListener("enterEnd", function()
		self.ball:launch()
	end)
	self:addEventListener(Event.ENTER_FRAME, onEnterFrame)
	
	-- Listen to Keys --
	self:addEventListener(Event.KEY_DOWN, onKeyDown)
	
end