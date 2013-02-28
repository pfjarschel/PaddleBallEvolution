-----------------------
-- Class for Players --
-----------------------

Player = Core.class()

----------------------------------------------------------------------------------------
-- Declare used objects, and some variables. The correctAIY is necessary to correct   --
-- small difference on AI prediction (can't find the issue that makes this necessary) --
----------------------------------------------------------------------------------------
Player.paddle = nil
Player.char = nil
Player.side = nil
Player.human = false
Player.randomFactor = 0
Player.touchX = 0
Player.touchY = 0
Player.correctAIY = 23
Player.difFactor = 1
Player.skillActive = false

---------------------------------------------------------------------------------------
-- Sets new random factor to be added to AI ball location prediction. Difficulty and --
-- AI intelligence affects this factor, and if paddle size is smaller than default,  -- 
-- increases range 																	 --
---------------------------------------------------------------------------------------
function Player:aiRandomFactor()
	if self.char.defFactor < 1 then
		self.randomFactor = (3.2 - self.difFactor*1.2)*self.char.intFactor*math.random(-self.paddle.paddleH/2, self.paddle.paddleH/2)/self.char.defFactor
	else
		self.randomFactor = (3.2 - self.difFactor*1.2)*self.char.intFactor*math.random(-self.paddle.paddleH/2, self.paddle.paddleH/2)
	end
end

-- Makes AI move towards predicted position --
function Player:aiMove()
	if not self.human then
	
		-- Gets positions and velocities --
		local ballX, ballY = arena.ball.body:getPosition()
		local padX, padY = self.paddle.body:getPosition()
		local ballDist = math.sqrt(math.pow(padX - ballX, 2) + math.pow(padY - ballY, 2))
		local ballVx, ballVy = arena.ball.body:getLinearVelocity()
		if ballVy == 0 then
			ballVy = 0.001
		end
		ballVx = ballVx*PhysicsScale
		ballVy = ballVy*PhysicsScale
		local padVx, padVy = self.paddle.body:getLinearVelocity()
		
		-- Prediction Initialization, any values --
		local predictX = WX/2
		local predictY = 0
		local dy = 0
		local maxdelta = WY - self.paddle.paddleH/2 - WBounds
		
		-- Predict Y coordinate of ball when it pass over the paddle line, if ball is moving towards paddle --
		if self.side == 0 and ballVx < 0  then
			
			-- Calculates ball X position when it hits a boundary, until X means it is behind a paddle --
			while predictX > (padX + self.paddle.paddleW/2 + arena.ball.radius) do
				if ballVy > 0 then
					dy = WY -WBounds - ballY - arena.ball.radius
					predictX = ballX - math.abs(ballVx)*dy/math.abs(ballVy)
					ballVy = -ballVy
					ballY = WY - WBounds - arena.ball.radius
					ballX = predictX
				else
					dy = ballY - WBounds - arena.ball.radius
					predictX = ballX  - math.abs(ballVx)*dy/math.abs(ballVy)
					ballVy = -ballVy
					ballY = WBounds + arena.ball.radius
					ballX = predictX
				end
			end
			
			-- After last position is found, calculates the ball Y position when crossing the paddle line --
			if ballVy > 0 then
				predictY = self.correctAIY + self.randomFactor + math.abs(ballVy)*(padX + self.paddle.paddleW/2 + arena.ball.radius - ballX)/math.abs(ballVx)
			else
				predictY = -self.correctAIY  + self.randomFactor + WY - math.abs(ballVy)*(padX + self.paddle.paddleW/2 + arena.ball.radius - ballX)/math.abs(ballVx)
			end
			
			-----------------------------------------------------------------------------------------------
			-- Applies velocity proportional to the difference between paddle Y position and prediction. --
			-- The random factor starts very big and gets smaller when ball approaches paddle            --
			-----------------------------------------------------------------------------------------------
			local deltaY = predictY - padY + (ballDist/250)*self.randomFactor
			self.paddle.body:setLinearVelocity(0, self.char.movFactor*(deltaY/maxdelta)*arena.ball.baseSpeed)
		
		-- Same thing, to the other side --
		elseif self.side == 1 and ballVx > 0 then
			while predictX < (padX - self.paddle.paddleW/2 - arena.ball.radius) do
				if ballVy > 0 then
					dy = WY -WBounds - ballY - arena.ball.radius
					predictX = ballX + math.abs(ballVx)*dy/math.abs(ballVy)
					ballVy = -ballVy
					ballY = WY - WBounds - arena.ball.radius
					ballX = predictX
				else
					dy = ballY - WBounds - arena.ball.radius
					predictX = ballX  + math.abs(ballVx)*dy/math.abs(ballVy)
					ballVy = -ballVy
					ballY = WBounds + arena.ball.radius
					ballX = predictX
				end
			end
			if ballVy > 0 then
				predictY = self.correctAIY + math.abs(ballVy)*(ballX - padX + self.paddle.paddleW/2 + arena.ball.radius)/math.abs(ballVx)
			else
				predictY = -self.correctAIY + WY - math.abs(ballVy)*(ballX - padX + self.paddle.paddleW/2 + arena.ball.radius)/math.abs(ballVx)
			end
			
			local deltaY = predictY - padY + (ballDist/250)*self.randomFactor
			self.paddle.body:setLinearVelocity(0, self.char.movFactor*(deltaY/maxdelta)*arena.ball.baseSpeed)
		
		-- If ball is not moving towards paddle, move paddle to the position opposite to opponent --
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

-------------------------------------------------------------------------------------
-- Moves the paddle responding to controls, function to respond to control events. --
-- Creates "drag with delay" effect, paddle will always move towards finger, with  --
-- constant speed, which depends on game mode and/or character MOV attribute.      --
-------------------------------------------------------------------------------------
function Player:humanMove()
	if self.human then
		local px, py = self.paddle.body:getPosition()
		local delta = (self.touchY - py)

		if math.abs(delta) < self.paddle.basepaddleH/8 then 
			self.paddle.body:setLinearVelocity(0, 0)
		elseif delta > 0 then
			self.paddle.body:setLinearVelocity(0, self.char.movFactor*arena.ball.baseSpeed)
		elseif delta < 0 then
			self.paddle.body:setLinearVelocity(0, -self.char.movFactor*arena.ball.baseSpeed)
		end
	end
end

-- Initialize objects, add control Listeners --
function Player:init(side, human, difFactor, class)
	self.side = side
	self.human = human
	self.char = Char.new(class)
	self.difFactor = difFactor
	self.paddle = Paddle.new(side, self.char.atkFactor, self.char.defFactor)
	self.touchY = WY/2
	if human then
		arena:addEventListener(Event.TOUCHES_BEGIN, function(event)
			if not arena.paused then
				self.touchY = event.touch.y
			end
		end)
		arena:addEventListener(Event.TOUCHES_MOVE, function(event)
			if not arena.paused then
				self.touchY = event.touch.y
			end
		end)
		arena:addEventListener(Event.TOUCHES_END, function(event)
			
		end)

	end
end