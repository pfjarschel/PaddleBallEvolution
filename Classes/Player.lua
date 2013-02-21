-----------------------
-- Class for Players --
-----------------------

Player = Core.class()

Player.paddle = nil
Player.char = nil
Player.side = nil
Player.human = false
Player.randomFactor = 0
Player.isTouchDown = false
Player.touchX = 0
Player.touchY = 0
Player.isMoving = false
Player.correctAIY = 23
Player.difFactor = 1
Player.skillActive = false

function Player:aiRandomFactor()
	if self.char.defFactor < 1 then
		self.randomFactor = (3.2 - self.difFactor*1.2)*self.char.intFactor*math.random(-self.paddle.paddleH/2, self.paddle.paddleH/2)/self.char.defFactor
	else
		self.randomFactor = (3.2 - self.difFactor*1.2)*self.char.intFactor*math.random(-self.paddle.paddleH/2, self.paddle.paddleH/2)
	end
end

function Player:aiMove(ball)
	if self.human then else
		local ballX, ballY = ball.body:getPosition()
		local padX, padY = self.paddle.body:getPosition()
		local ballDist = math.sqrt(math.pow(padX - ballX, 2) + math.pow(padY - ballY, 2))
		local ballVx, ballVy = ball.body:getLinearVelocity()
		if ballVy == 0 then
			ballVy = 0.001
		end
		ballVx = ballVx*PhysicsScale
		ballVy = ballVy*PhysicsScale
		local padVx, padVy = self.paddle.body:getLinearVelocity()
		local predictX = WX/2
		local predictY = 0
		local dy = 0
		local maxdelta = WY - self.paddle.paddleH/2 - WBounds
		if self.side == 0 and ballVx < 0  then
			while predictX > (padX + self.paddle.paddleW/2 + ball.radius) do
				if ballVy > 0 then
					dy = WY -WBounds - ballY - ball.radius
					predictX = ballX - math.abs(ballVx)*dy/math.abs(ballVy)
					ballVy = -ballVy
					ballY = WY - WBounds - ball.radius
					ballX = predictX
				else
					dy = ballY - WBounds - ball.radius
					predictX = ballX  - math.abs(ballVx)*dy/math.abs(ballVy)
					ballVy = -ballVy
					ballY = WBounds + ball.radius
					ballX = predictX
				end
			end
			if ballVy > 0 then
				predictY = self.correctAIY + self.randomFactor + math.abs(ballVy)*(padX + self.paddle.paddleW/2 + ball.radius - ballX)/math.abs(ballVx)
			else
				predictY = -self.correctAIY  + self.randomFactor + WY - math.abs(ballVy)*(padX + self.paddle.paddleW/2 + ball.radius - ballX)/math.abs(ballVx)
			end
			local deltaY = predictY - padY + (ballDist/250)*self.randomFactor
			self.paddle.body:setLinearVelocity(0, self.char.movFactor*(deltaY/maxdelta)*arena.ball.baseSpeed)
		elseif self.side == 1 and ballVx > 0 then
			while predictX < (padX - self.paddle.paddleW/2 - ball.radius) do
				if ballVy > 0 then
					dy = WY -WBounds - ballY - ball.radius
					predictX = ballX + math.abs(ballVx)*dy/math.abs(ballVy)
					ballVy = -ballVy
					ballY = WY - WBounds - ball.radius
					ballX = predictX
				else
					dy = ballY - WBounds - ball.radius
					predictX = ballX  + math.abs(ballVx)*dy/math.abs(ballVy)
					ballVy = -ballVy
					ballY = WBounds + ball.radius
					ballX = predictX
				end
			end
			if ballVy > 0 then
				predictY = self.correctAIY + math.abs(ballVy)*(ballX - padX + self.paddle.paddleW/2 + ball.radius)/math.abs(ballVx)
			else
				predictY = -self.correctAIY + WY - math.abs(ballVy)*(ballX - padX + self.paddle.paddleW/2 + ball.radius)/math.abs(ballVx)
			end
			local deltaY = predictY - padY + (ballDist/250)*self.randomFactor
			self.paddle.body:setLinearVelocity(0, self.char.movFactor*(deltaY/maxdelta)*arena.ball.baseSpeed)
		else
			local opponentX, opponentY = nil
			if self.side == 0 then
				opponentX, opponentY = arena.rightPlayer.paddle.body:getPosition()
			else
				opponentX, opponentY = arena.leftPlayer.paddle.body:getPosition()
			end
			local opositOp = WY - opponentY
			local deltaOp = opositOp - padY
			self.paddle.body:setLinearVelocity(0, (deltaOp/maxdelta)*arena.ball.baseSpeed/2)
		end
	end
end

function Player:init(side, human, difFactor, class)
	self.side = side
	self.human = human
	self.char = Char.new(class)
	self.difFactor = difFactor
	self.paddle = Paddle.new(side, self.char.atkFactor, self.char.defFactor)
	if human then
		arena:addEventListener(Event.TOUCHES_BEGIN, function(event)
			self.touchY = event.touch.y
			self.isTouchDown = true
			self.isMoving = false
		end)
		arena:addEventListener(Event.TOUCHES_MOVE, function(event)
			if math.abs(self.touchY - event.touch.y) > 5 then
				self.touchY = event.touch.y
				self.isMoving = false
			end
		end)
		arena:addEventListener(Event.TOUCHES_END, function(event)
			self.isTouchDown = false
		end)
	end
end

function Player:humanMove()
	if self.human and self.isTouchDown then
		local px, py = self.paddle.body:getPosition()
		local delta = (self.touchY - py)
		local maxdelta = WY - self.paddle.paddleH/2 - WBounds
		if self.isMoving then 
			if math.abs(delta) < self.paddle.paddleH/8 then
				self.paddle.body:setLinearVelocity(0, 0)
			end
		else
			self.isMoving = true
			if delta > 0 then
				self.paddle.body:setLinearVelocity(0, self.char.movFactor*(0.3 + 0.7*delta/maxdelta)*arena.ball.baseSpeed)
			else
				self.paddle.body:setLinearVelocity(0, self.char.movFactor*(-0.3 + 0.7*delta/maxdelta)*arena.ball.baseSpeed)
			end
		end
	end
end
