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
Player.AITarget = nil
Player.Follow = false

---------------------------------------------------------------------------------------
-- Sets new random factor to be added to AI ball location prediction. Difficulty and --
-- AI intelligence affects this factor, and if paddle size is smaller than default,  -- 
-- increases range 																	 --
---------------------------------------------------------------------------------------
function Player:aiRandomFactor()
	if self.char.defFactor < 1 then
		self.randomFactor = (3.2 - self.difFactor*1)*self.char.intFactor*math.random(-self.paddle.paddleH/2, self.paddle.paddleH/2)/self.char.defFactor
	else
		self.randomFactor = (3.2 - self.difFactor*1)*self.char.intFactor*math.random(-self.paddle.paddleH/2, self.paddle.paddleH/2)
	end
end

-- Makes AI move towards predicted position --
function Player:aiMove()
	if not self.human then
	
		-- Gets positions and velocities --
		local ballX, ballY = self.AITarget.body:getPosition()
		local padX, padY = self.paddle.body:getPosition()
		local ballDist = math.sqrt(math.pow(padX - ballX, 2) + math.pow(padY - ballY, 2))
		local ballVx, ballVy = self.AITarget.body:getLinearVelocity()
		local ballVx0 = ballVx
		local ballVy0 = ballVy
		local ballV0 = math.sqrt(ballVx*ballVx + ballVy*ballVy)
		if ballVy == 0 then
			ballVy = 0.001
		end
		ballVx = ballVx*PhysicsScale
		ballVy = ballVy*PhysicsScale
		local padVx, padVy = self.paddle.body:getLinearVelocity()
		
		-- Prediction Initialization, any values --
		local predictX = XShift + WX/2
		local predictY = 0
		local dy = 0
		local maxdelta = WY - self.paddle.paddleH/2 - WBounds
		
		-- Predict Y coordinate of ball when it pass over the paddle line, if ball is moving towards paddle --
		if self.side == 0 and ballVx < 0  then
			
			-- Calculates ball X position when it hits a boundary, until X means it is behind a paddle --
			while predictX > (padX + self.paddle.paddleW/2 + self.AITarget.radius) do
				if ballVy > 0 then
					dy = WY - WBounds - ballY - self.AITarget.radius
					predictX = ballX - math.abs(ballVx)*dy/math.abs(ballVy)
					ballVy = -ballVy
					ballY = WY - WBounds - self.AITarget.radius
					ballX = predictX
				else
					dy = ballY - WBounds - self.AITarget.radius
					predictX = ballX  - math.abs(ballVx)*dy/math.abs(ballVy)
					ballVy = -ballVy
					ballY = WBounds + self.AITarget.radius
					ballX = predictX
				end
			end
			
			-- After last position is found, calculates the ball Y position when crossing the paddle line --
			if ballVy > 0 then
				predictY = self.correctAIY + math.abs(ballVy)*(padX + self.paddle.paddleW/2 + self.AITarget.radius - ballX)/math.abs(ballVx)
			else
				predictY = -self.correctAIY + WY - math.abs(ballVy)*(padX + self.paddle.paddleW/2 + self.AITarget.radius - ballX)/math.abs(ballVx)
			end
			
			-----------------------------------------------------------------------------------------------
			-- Applies velocity proportional to the difference between paddle Y position and prediction. --
			-- The random factor starts very big and gets smaller when ball approaches paddle            --
			-----------------------------------------------------------------------------------------------
			local deltaY = predictY - padY + (ballDist*math.abs(ballVy0/ballV0)/120)*self.randomFactor
			self.paddle.body:setLinearVelocity(padVx, self.char.movFactor*(deltaY/maxdelta)*self.AITarget.baseSpeedMov)

		-- Same thing, to the other side --
		elseif self.side == 1 and ballVx > 0 then
			while predictX < (padX - self.paddle.paddleW/2 - self.AITarget.radius) do
				if ballVy > 0 then
					dy = WY - WBounds - ballY - self.AITarget.radius
					predictX = ballX + math.abs(ballVx)*dy/math.abs(ballVy)
					ballVy = -ballVy
					ballY = WY - WBounds - self.AITarget.radius
					ballX = predictX
				else
					dy = ballY - WBounds - self.AITarget.radius
					predictX = ballX  + math.abs(ballVx)*dy/math.abs(ballVy)
					ballVy = -ballVy
					ballY = WBounds + self.AITarget.radius
					ballX = predictX
				end
			end
			if ballVy > 0 then
				predictY = self.correctAIY + math.abs(ballVy)*(ballX - padX + self.paddle.paddleW/2 + self.AITarget.radius)/math.abs(ballVx)
			else
				predictY = -self.correctAIY + WY - math.abs(ballVy)*(ballX - padX + self.paddle.paddleW/2 + self.AITarget.radius)/math.abs(ballVx)
			end
			
			local deltaY = predictY - padY + (ballDist*math.abs(ballVy0/ballV0)/120)*self.randomFactor
			self.paddle.body:setLinearVelocity(padVx, self.char.movFactor*(deltaY/maxdelta)*self.AITarget.baseSpeedMov)
		-- If ball is not moving towards paddle, move paddle to the position opposite to opponent --
		else
			local opponentX, opponentY = nil
			if self.side == 0 then
				opponentX, opponentY = arena.rightPlayer.paddle.body:getPosition()
			else
				opponentX, opponentY = arena.leftPlayer.paddle.body:getPosition()
			end
			local delta0 = opponentY - padY
			local opositOp = WY - opponentY
			local deltaOp = opositOp - padY
			if self.Follow then
				self.paddle.body:setLinearVelocity(padVx, self.char.movFactor*(delta0/maxdelta)*self.AITarget.baseSpeedMov/2)
			else
				self.paddle.body:setLinearVelocity(padVx, self.char.movFactor*(deltaOp/maxdelta)*self.AITarget.baseSpeedMov/2)
			end
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
		local padVx = self.paddle.body:getLinearVelocity()
		
		if math.abs(delta) < self.paddle.basepaddleH/8 then 
			self.paddle.body:setLinearVelocity(padVx, 0)
		elseif delta > 0 then
			self.paddle.body:setLinearVelocity(padVx, self.char.movFactor*self.AITarget.baseSpeedMov)
		elseif delta < 0 then
			self.paddle.body:setLinearVelocity(padVx, -self.char.movFactor*self.AITarget.baseSpeedMov)
		end
	end
end

-- Initialize objects --
function Player:init(side, human, difFactor, class, stage, world)
	if stage == nil then stage = 0 end
	if world == nil then world = 0 end
	self.side = side
	self.human = human
	self.char = Char.new(class, stage, world)
	self.difFactor = difFactor
	self.paddle = Paddle.new(side, self.char.atkFactor, self.char.defFactor)
	self.touchY = WY/2
	self.AITarget = arena.ball
end