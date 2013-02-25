-------------------------------------------------
-- Class for the Arena (or simply background?) --
-------------------------------------------------

ArenaSurvival = Core.class(Sprite)

-- Declare boundaries object
ArenaSurvival.bitmap = nil
ArenaSurvival.bounds = nil
ArenaSurvival.score0 = 0
ArenaSurvival.score1 = 0
ArenaSurvival.difFactor = 5/5 -- 1/5 to 10/5
ArenaSurvival.paused = false
ArenaSurvival.font = nil

local function onEnterFrame()
	updatePhysics()
	arena:moveAI()
	arena:moveHuman()
	arena:checkGoal()
end

-- Initialization function
function ArenaSurvival:init(difficulty)
	self.font = fonts.arialroundedMed
	self.bitmap = textures.pongbg
	self.bitmap:setScale(1, 1)
	self.difFactor = difficulty/5
	self:addChild(self.bitmap)
	local textureW = self.bitmap:getWidth()
	local textureH = self.bitmap:getHeight()
	self.bitmap:setScale(WX/textureW, WY/textureH)
	self:setAlpha(0)
	self:createBoundaries()
	
	local menuBut = MenuBut.new(textures.menuBut, 40, 40)
	menuBut.bitmap:setPosition(WX/2, WY - menuBut.bitmap:getHeight()/2)
	menuBut:setAlpha(0.4)
	self:addChild(menuBut)
	menuBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if menuBut:hitTestPoint(event.touch.x, event.touch.y) then
			event:stopPropagation()
			if self.paused then else
				self.paused = true
				self:removeEventListener(Event.ENTER_FRAME, onEnterFrame)
				
				local pausebg = Sprite:new()
				pausebg:addChild(textures.pausebg)
				
				local resumeBut = MenuBut.new(textures.returnBut, 150, 40)
				resumeBut.bitmap:setPosition(WX/2, WY/2 - resumeBut:getHeight())
				resumeBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
					if resumeBut:hitTestPoint(event.touch.x, event.touch.y) then
						event:stopPropagation()
						stage:removeChild(pausebg)
						self.paused = false
						self:addEventListener(Event.ENTER_FRAME, onEnterFrame)
					end
				end)
				pausebg:addChild(resumeBut)
				local quitBut = MenuBut.new(textures.exitBut, 150, 40)
				quitBut.bitmap:setPosition(WX/2, WY/2 + quitBut:getHeight())
				quitBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
					if quitBut:hitTestPoint(event.touch.x, event.touch.y) then
						event:stopPropagation()
						stage:removeChild(pausebg)
						stage:removeChild(self)
						world:destroyBody(self.ball.body)
						self.ball.body = nil
						world:destroyBody(self.leftPlayer.paddle.body)
						world:destroyBody(self.rightPlayer.paddle.body)
						world:destroyBody(self.bounds)
						self = nil
						loadMainMenu()
					end
				end)
				pausebg:addChild(quitBut)
				
				stage:addChild(pausebg)
			end
		end
	end)
	
	stage:addChild(self)
	fadeIn(self)
	Timer.delayedCall(0, function()
		self:createArenaChildren()
	end)
end

-- Create physics stuff (including collision handler)
function ArenaSurvival:createBoundaries()
	self.bounds = world:createBody({}) --Default is Static
	self.bounds.name = "bounds"
	local shapeT = b2.EdgeShape.new(-200, WBounds, WX + 200, WBounds)
	local shapeB = b2.EdgeShape.new(-200, WY-WBounds, WX + 200, WY-WBounds)
	self.bounds:createFixture{
		shape = shapeT, 
		friction = 0,
		filter = {categoryBits = 0x0001, maskBits = 0xFFFF} -- Collides with everything
	}
	self.bounds:createFixture{
		shape = shapeB, 
		friction = 0,
		filter = {categoryBits = 0x0001, maskBits = 0xFFFF}
	}
	function self.bounds:collide(event)
		--print("bounds")
	end
end

-- This function creates the arena stuff
function ArenaSurvival:createArenaChildren()
	self.ball = Ball.new(self.difFactor)
	self.leftPlayer = Player.new(0, false, self.difFactor, "survivalLeft")
	self.rightPlayer = Player.new(1, false, self.difFactor, "survivalRight")
	self.ball.baseSpeed = self.ball.baseSpeed*self.leftPlayer.char.atkFactor
	self.leftPlayer.paddle.body.atkFactor = 1
	self.rightPlayer.paddle.body.atkFactor = 1
	self.combatStats = CombatStats.new()
	self.combatStats:update(self.score0,self.score1)
	self.ball:reset()
	self:addEventListener(Event.ENTER_FRAME, onEnterFrame)
end

-- Function to handle goals
function ArenaSurvival:checkGoal()
	local ballX, ballY = self.ball.body:getPosition()
	local function updateLeft()
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
		self.leftPlayer.paddle:reset()
		self.rightPlayer.paddle:reset()
		gc()
	end
	local function gameOver()
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
				stage:removeChild(self)
				world:destroyBody(self.ball.body)
				self.ball.body = nil
				world:destroyBody(self.leftPlayer.paddle.body)
				world:destroyBody(self.rightPlayer.paddle.body)
				world:destroyBody(self.bounds)
				self = nil
				loadArena("survival", 5)
			end
		end)
		returnBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
			if returnBut:hitTestPoint(event.touch.x, event.touch.y) then
				stage:removeChild(gameOverTextBox)
				stage:removeChild(returnBut)
				stage:removeChild(againBut)
				stage:removeChild(self)
				world:destroyBody(self.ball.body)
				self.ball.body = nil
				world:destroyBody(self.leftPlayer.paddle.body)
				world:destroyBody(self.rightPlayer.paddle.body)
				world:destroyBody(self.bounds)
				self = nil
				loadMainMenu()
			end
		end)
		
		Timer.delayedCall(700, function ()
			stage:addChild(gameOverTextBox)	
			stage:addChild(returnBut)
			stage:addChild(againBut)
		end)
	end
	if ballX > WX + 2*self.ball.radius then
		self.score0 = self.score0 + 1
		updateLeft()
	elseif ballX <  -2*self.ball.radius then
		self.score1 = self.score1 + 1
		gameOver()
	end
end

function ArenaSurvival:moveAI()
	self.leftPlayer:aiMove(self.ball)
	self.rightPlayer:aiMove(self.ball)
end

function ArenaSurvival:moveHuman()
	self.leftPlayer:humanMove()
	self.rightPlayer:humanMove()
end