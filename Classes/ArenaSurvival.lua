-------------------------------------------------
-- Class for the Arena (or simply background?) --
-------------------------------------------------

ArenaSurvival = Core.class(Sprite)

-- Declare Stuff --
ArenaSurvival.bitmap = nil
ArenaSurvival.bounds = nil
ArenaSurvival.score0 = 0
ArenaSurvival.score1 = 0
ArenaSurvival.difFactor = 5/5 -- 1/5 to 10/5
ArenaSurvival.paused = false
ArenaSurvival.font = nil
ArenaSurvival.pausebg = nil
ArenaSurvival.name = "survival"
ArenaSurvival.controlarrows = nil
ArenaSurvival.accelerometer = nil

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
	--arena.leftPlayer:aiMove()
	arena.leftPlayer:humanMove()
	arena.rightPlayer:aiMove()
	--arena.rightPlayer:humanMove()
	arena:checkGoal()
end

-- Create physics stuff (including collision handler) --
function ArenaSurvival:createBoundaries()
	
	-- Default is Static --
	self.bounds = world:createBody({})
	
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
	
	-- Collision Handler --
	function self.bounds:collide(event)
		--print("bounds")
	end
end

function ArenaSurvival:openMenu()
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
				stage:removeChild(self.pausebg)
				world:destroyBody(self.ball.body)
				self.ball.body = nil
				world:destroyBody(self.leftPlayer.paddle.body)
				world:destroyBody(self.rightPlayer.paddle.body)
				world:destroyBody(self.bounds)
				local difficulty = self.difFactor*5
				self = nil
				arena = nil
				sceneMan:changeScene("survival", transTime, SceneManager.fade, easing.linear, { userData = difficulty })
			end
		end)
		self.pausebg:addChild(restartBut)
		
		-- Adds Quit Button --
		local quitBut = MenuBut.new(textures.exitBut, 150, 40)
		quitBut.bitmap:setPosition(WX/2, WY/2 + 2*quitBut:getHeight())
		quitBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
			if quitBut:hitTestPoint(event.touch.x, event.touch.y) then
				event:stopPropagation()
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
function ArenaSurvival:addMenu()
	-- Adds Menu Button --
	local menuBut = MenuBut.new(textures.menuBut, 60, 60)
	menuBut.bitmap:setPosition(WX - menuBut.bitmap:getWidth()/1.5, WY - menuBut.bitmap:getHeight())
	menuBut:setAlpha(0.4)
	self:addChild(menuBut)
	menuBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if menuBut:hitTestPoint(event.touch.x, event.touch.y) then
			event:stopPropagation()
			self:openMenu()
		end
	end)
end

-- Inserts control arrows, handles touch --
function ArenaSurvival:addControlArrows()
	local controlarrows = textures.controlarrows
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
function ArenaSurvival:tiltInit()
	self.accelerometer = Accelerometer.new()
	self.accelerometer:start()
	afx0 = self.accelerometer:getAcceleration()
end

-- Handles Tilt --
function ArenaSurvival:tilt()
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

-- Function to Handle the End of the Match -- 
function ArenaSurvival:gameOver()
	self:removeEventListener(Event.ENTER_FRAME, onEnterFrame)
	fadeOut(self)
	
	local gameOverString = nil
	gameOverString = "You managed to survive " .. tostring(self.score0) .. " rounds!"
	sounds.lose:play()
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
			self = nil
			arena = nil
			sceneMan:changeScene("survival", transTime, SceneManager.fade, easing.linear, { userData = "5" })
		end
	end)
	
	returnBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if returnBut:hitTestPoint(event.touch.x, event.touch.y) then
			event:stopPropagation()
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

-- Function to handle goals --
function ArenaSurvival:checkGoal()
	local ballX, ballY = self.ball.body:getPosition()
	
	-- Updates match attributes, each 2 goals, and the other normal stuff --
	local function updateAttrs()
		self.ball.baseSpeed = self.ball.baseSpeed/self.leftPlayer.char.atkFactor
		
		self.combatStats:update(self.score0, self.score1)
		
		if self.score0%2 == 0 then
			if self.leftPlayer.char.atk < 50 then
				self.leftPlayer.char.atk = self.leftPlayer.char.atk + 1
				self.rightPlayer.char.atk = self.rightPlayer.char.atk + 1
			end
			sounds.powerup1:play()
		else
			sounds.goal1:play()
		end
		
		if self.score0%4 == 0 then
			if self.leftPlayer.char.def > 1 then
				self.leftPlayer.char.def = self.leftPlayer.char.def - 1
			end
		end
		
		if self.score0%6 == 0 then
			if self.rightPlayer.char.def < 30 then
				self.rightPlayer.char.def = self.rightPlayer.char.def + 1
			end
		end
		
		if self.score0%8 == 0 then
			if self.rightPlayer.char.int < 30 then
				self.rightPlayer.char.int = self.rightPlayer.char.int + 1
			end
		end
		
		self.leftPlayer.char:updateAttr()
		self.rightPlayer.char:updateAttr()
		self.ball.baseSpeed = self.ball.baseSpeed*self.leftPlayer.char.atkFactor
		self.ball.body.baseSpeed = self.ball.baseSpeed
		self.leftPlayer.paddle.paddleH = self.leftPlayer.paddle.basepaddleH*self.leftPlayer.char.defFactor
		self.leftPlayer.paddle.bitmap:setScale(1, 1)
		self.leftPlayer.paddle.bitmap:setScale(self.leftPlayer.paddle.paddleW/self.leftPlayer.paddle.textureW, self.leftPlayer.paddle.paddleH/self.leftPlayer.paddle.textureH)
		world:destroyBody(self.leftPlayer.paddle.body)
		self.leftPlayer.paddle:createBody()
		self.leftPlayer.paddle.body.atkFactor = 1
		self.rightPlayer.paddle.paddleH = self.rightPlayer.paddle.basepaddleH*self.rightPlayer.char.defFactor
		self.rightPlayer.paddle.bitmap:setScale(1, 1)
		self.rightPlayer.paddle.bitmap:setScale(self.rightPlayer.paddle.paddleW/self.rightPlayer.paddle.textureW, self.rightPlayer.paddle.paddleH/self.rightPlayer.paddle.textureH)
		world:destroyBody(self.rightPlayer.paddle.body)
		self.rightPlayer.paddle:createBody()
		self.rightPlayer.paddle.body.atkFactor = 1
		
		self.ball:reset()
		self.ball:launch()
		self.leftPlayer.paddle:reset()
		self.rightPlayer.paddle:reset()
		gc()
	end
	
	if ballX > WX + 2*self.ball.radius then
		self.score0 = self.score0 + 1
		updateAttrs()
	elseif ballX <  -2*self.ball.radius then
		self.score1 = self.score1 + 1
		self:gameOver()
	end
end

-- Initialization --
function ArenaSurvival:init(difficulty)
	arena = self
	self.font = fonts.arialroundedMed
	self.bitmap = textures.pongbg
	self.bitmap:setScale(1, 1)
	self.difFactor = difficulty/5
	self:addChild(self.bitmap)
	local textureW = self.bitmap:getWidth()
	local textureH = self.bitmap:getHeight()
	self.bitmap:setScale(WX/textureW, WY/textureH)
	
	self:addMenu()
	
	if controlMethod == "Touch" then
		self:addControlArrows()
	end
	
	self:createBoundaries()
	
	self.ball = Ball.new(self.difFactor)
	self.leftPlayer = Player.new(0, true, self.difFactor, "survivalLeft")
	self.rightPlayer = Player.new(1, false, self.difFactor, "survivalRight")
	self.ball.baseSpeed = self.ball.baseSpeed*self.leftPlayer.char.atkFactor
	self.leftPlayer.paddle.body.atkFactor = 1
	self.rightPlayer.paddle.body.atkFactor = 1
	self.combatStats = CombatStats.new()
	self.combatStats:update(self.score0, self.score1)
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