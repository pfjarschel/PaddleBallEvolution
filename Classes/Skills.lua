----------------------
-- Class for Skills --
----------------------

Skills = Core.class()

-- Declarations --
Skills.skill = nil
Skills.basetime = 1000

function Skills:init(skill)
	self.skill = skill
	
	-- 5 times the time the ball takes to cross the field at full X speed --
	self.basetime = 5*1000*WX/(arena.ball.baseSpeed*20)
end

-- Declare this function to later hold skill specific action to end it --
function Skills:endAction()
end

function Skills:start(side)

--------------------------------------------------------
-- PowerShot: The next ball return will be VERY fast! --
--------------------------------------------------------
	if self.skill == "powershot" then
		sounds.powerup2:play()
		
		-- Sets attack factor x10 --
		if side == 0 then
			arena.leftPlayer.paddle.body.atkFactor = arena.leftPlayer.paddle.atkFactor*10
		else
			arena.rightPlayer.paddle.body.atkFactor = arena.rightPlayer.paddle.atkFactor*10
		end
		
		-- Action to end skill --
		self.endAction = function()
			if side == 0 then
				arena.leftPlayer.paddle.body.atkFactor = arena.leftPlayer.paddle.atkFactor
				arena.leftPlayer.skillActive = false
			else
				arena.rightPlayer.paddle.body.atkFactor = arena.rightPlayer.paddle.atkFactor
				arena.rightPlayer.skillActive = false
			end
		end
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime,  function()
			self:endAction() 
			sounds.powerup2over:play()
		end)
	end


--------------------------------------------------
-- Viscous Field: Ball speed is greatly reduced --
--------------------------------------------------
	if self.skill == "viscousfield" then
		-- Gets ball speed and reduces it --
		local ballVx, ballVy = arena.ball.body:getLinearVelocity()
		local desVx = ballVx/10
		local desVy = ballVy/10
		
		-- Prevents too many slow-downs, any direction speed must be greater than minimum base speed --
		if ballVx > arena.ball.baseSpeed*0.3/1.41 or ballVy > arena.ball.baseSpeed*0.3/1.41 or
		ballVx < -arena.ball.baseSpeed*0.3/1.41 or ballVy < -arena.ball.baseSpeed*0.3/1.41 then
			sounds.powerup2over:play()
			arena.ball.body:setLinearVelocity(desVx, desVy)
		end
		
		-- Action to end skill --
		self.endAction = function() 
			if side == 0 then
				arena.leftPlayer.skillActive = false
			else
				arena.rightPlayer.skillActive = false
			end
		end
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime/3,  function()
			self:endAction()
		end)
	end


------------------------------------------------------
-- Invisiball: Ball is invisible. Simple like that! --
------------------------------------------------------
	if self.skill == "invisiball" then
		sounds.powerup2:play()
		
		-- Sets ball alpha very low --
		arena.ball:setAlpha(0.05)
		
		-- Sets AI intelligence very bad --
		local leftIntFactor = arena.leftPlayer.char.intFactor
		local rightIntFactor = arena.leftPlayer.char.intFactor
		arena.leftPlayer.char.intFactor = 7
		arena.rightPlayer.char.intFactor = 7
		arena.leftPlayer:aiRandomFactor()
		arena.rightPlayer:aiRandomFactor()
		
		-- Action to end skill --
		self.endAction = function()
			arena.ball:setAlpha(1)
			arena.leftPlayer.char.intFactor = leftIntFactor
			arena.rightPlayer.char.intFactor = rightIntFactor
			arena.leftPlayer:aiRandomFactor()
			arena.rightPlayer:aiRandomFactor()
			
			if side == 0 then
				arena.leftPlayer.skillActive = false
			else
				arena.rightPlayer.skillActive = false
			end
		end
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime/3, function()
			self:endAction()
			sounds.powerup2over:play()
		end)
	end


----------------------------------------
-- CurveBall: Ball makes crazy curves --
----------------------------------------
	if self.skill == "curveball" then
		sounds.powerup2:play()
		
		-- Each frame, applies force on ball, to make it do crazy curves --
		local ballVx0, ballVy0 = arena.ball.body:getLinearVelocity()
		local ballV0 = math.sqrt(ballVx0*ballVx0 + ballVy0*ballVy0)
		local crazyFactor = 3*ballV0
		local direction = 0
		
		if ballVy0 > 0 then
			direction = -1
		else
			direction = 1
		end
		
		local function curveball()
			local ballX, ballY = arena.ball.body:getPosition()
			local ballVx, ballVy = arena.ball.body:getLinearVelocity()
			
			if ballVy > ballV0 then
				direction = direction*-1
			elseif ballVy < -ballV0 then
				direction = direction*-1
			end
		
			arena.ball.body:applyForce(0, direction*crazyFactor, ballX, ballY)
		end
		
		-- Adds event listener only if ball is launched --
		if arena.ball.launched then
			stage:addEventListener(Event.ENTER_FRAME, curveball)
		end
		
		-- Action to end Skill --
		self.endAction = function()
			stage:removeEventListener(Event.ENTER_FRAME, curveball)
			
			if side == 0 then
				arena.leftPlayer.skillActive = false
			else
				arena.rightPlayer.skillActive = false
			end
		end 
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime/2, function()
			self:endAction() 
			sounds.powerup2over:play()
			
			-- Returns ball to previous state --
			local ballVxRet = arena.ball.body:getLinearVelocity()
			arena.ball.body:setLinearVelocity(math.abs(ballVxRet*ballVx0)/ballVxRet, ballVy0)
		end)
	end
	

----------------------------------------------------------
-- ArrowBall: Ball moves in a straight line to the goal --
----------------------------------------------------------
	if self.skill == "arrowball" then
		sounds.powerup2:play()
		
		-- Gets velocity, direction and sets Vy = 0 --
		local ballVx0, ballVy0 = arena.ball.body:getLinearVelocity()
		local ballV0 = math.sqrt(ballVx0*ballVx0 + ballVy0*ballVy0)
		local direction = 0
		
		if ballVx0 < 0 then
			direction = -1
		else
			direction = 1
		end
		
		-- Only if ball is launched --
			if arena.ball.launched then
				arena.ball.body:setLinearVelocity(direction*ballV0, 0)
			end
		
		-- Action to end Skill --
		self.endAction = function()	
			if side == 0 then
				arena.leftPlayer.skillActive = false
			else
				arena.rightPlayer.skillActive = false
			end
		end
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime/10,  function()
			self:endAction()
		end)
	end


-------------------------------------------------
-- MirrorBall: Ball changes movement direction --
-------------------------------------------------
	if self.skill == "mirrorball" then
		sounds.powerup2:play()
		
		-- Gets velocity --
		local ballVx0, ballVy0 = arena.ball.body:getLinearVelocity()
		
		-- Only if ball is launched --
		if arena.ball.launched then
			arena.ball.body:setLinearVelocity(-ballVx0, ballVy0)
		end
		
		-- Action to end Skill --
		self.endAction = function()	
			if side == 0 then
				arena.leftPlayer.skillActive = false
			else
				arena.rightPlayer.skillActive = false
			end
		end
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime/10,  function()
			self:endAction()
		end)
	end


-------------------------------------------------
-- Berserk: Atk, Mov and Def greatly increased --
-------------------------------------------------
	if self.skill == "berserk" then
		sounds.powerup2:play()
		
		local incr = 10
		
		-- Sets stats + X, calculates factors and update --
		if side == 0 then
			local atkFactor = 0.24 + (incr + arena.leftPlayer.char.atk)/16.5 -- 0.3 to 2
			local movFactor = 0.16 + (incr + arena.leftPlayer.char.mov)/22.5 -- 0.2 to 1.5
			local defFactor = 0.21 + (incr + arena.leftPlayer.char.def)/11 -- 0.3 to 3
			
			arena.leftPlayer.paddle.body.atkFactor = atkFactor
			arena.leftPlayer.char.movFactor = movFactor
			arena.leftPlayer.paddle.body.defFactor = defFactor
			
			local shape = b2.PolygonShape.new()
			arena.leftPlayer.paddle.paddleH = arena.leftPlayer.paddle.basepaddleH*defFactor
			arena.leftPlayer.paddle.body.paddleH = arena.leftPlayer.paddle.paddleH
			shape:setAsBox(arena.leftPlayer.paddle.paddleW/2, arena.leftPlayer.paddle.paddleH/2, 0, 0, 0)
			arena.leftPlayer.paddle.body:destroyFixture(arena.leftPlayer.paddle.fixture)
			arena.leftPlayer.paddle.shape = shape
			arena.leftPlayer.paddle.fixture = arena.leftPlayer.paddle.body:createFixture{
				shape = shape, 
				density = 10000,
				restitution = 0, 
				friction = 0,
				fixedRotation = true,
			}
			arena.leftPlayer.paddle.body:setAngle(arena.leftPlayer.paddle.side*math.pi)
			arena.leftPlayer.paddle.bitmap:setScale(arena.leftPlayer.paddle.paddleW/arena.leftPlayer.paddle.textureW, arena.leftPlayer.paddle.paddleH/arena.leftPlayer.paddle.textureH)
			arena.leftPlayer.paddle:setRotation(arena.leftPlayer.paddle.side*180)
		else
			local atkFactor = 0.24 + (incr + arena.rightPlayer.char.atk)/16.5 -- 0.3 to 2
			local movFactor = 0.16 + (incr + arena.rightPlayer.char.mov)/22.5 -- 0.2 to 1.5
			local defFactor = 0.21 + (incr + arena.rightPlayer.char.def)/11 -- 0.3 to 3
			
			arena.rightPlayer.paddle.body.atkFactor = atkFactor
			arena.rightPlayer.char.movFactor = movFactor
			arena.rightPlayer.paddle.body.defFactor = defFactor
			
			local shape = b2.PolygonShape.new()
			arena.rightPlayer.paddle.paddleH = arena.leftPlayer.paddle.basepaddleH*defFactor
			arena.rightPlayer.paddle.body.paddleH = arena.leftPlayer.paddle.paddleH
			shape:setAsBox(arena.rightPlayer.paddle.paddleW/2, arena.rightPlayer.paddle.paddleH/2, 0, 0, 0)
			arena.rightPlayer.paddle.body:destroyFixture(arena.rightPlayer.paddle.fixture)
			arena.rightPlayer.paddle.shape = shape
			arena.rightPlayer.paddle.fixture = arena.rightPlayer.paddle.body:createFixture{
				shape = shape, 
				density = 10000,
				restitution = 0, 
				friction = 0,
				fixedRotation = true,
			}
			arena.rightPlayer.paddle.body:setAngle(arena.rightPlayer.paddle.side*math.pi)
			arena.rightPlayer.paddle.bitmap:setScale(arena.rightPlayer.paddle.paddleW/arena.rightPlayer.paddle.textureW, arena.rightPlayer.paddle.paddleH/arena.rightPlayer.paddle.textureH)
			arena.rightPlayer.paddle:setRotation(arena.rightPlayer.paddle.side*180)
		end
		
		-- Action to end skill --
		self.endAction = function()
			if side == 0 then
				local atkFactor = 0.24 + (arena.leftPlayer.char.atk)/16.5 -- 0.3 to 2
				local movFactor = 0.16 + (arena.leftPlayer.char.mov)/22.5 -- 0.2 to 1.5
				local defFactor = 0.21 + (arena.leftPlayer.char.def)/11 -- 0.3 to 3
				
				arena.leftPlayer.paddle.body.atkFactor = atkFactor
				arena.leftPlayer.char.movFactor = movFactor
				arena.leftPlayer.paddle.body.defFactor = defFactor
				
				local shape = b2.PolygonShape.new()
				arena.leftPlayer.paddle.paddleH = arena.leftPlayer.paddle.basepaddleH*defFactor
				arena.leftPlayer.paddle.body.paddleH = arena.leftPlayer.paddle.paddleH
				shape:setAsBox(arena.leftPlayer.paddle.paddleW/2, arena.leftPlayer.paddle.paddleH/2, 0, 0, 0)
				arena.leftPlayer.paddle.body:destroyFixture(arena.leftPlayer.paddle.fixture)
				arena.leftPlayer.paddle.shape = shape
				arena.leftPlayer.paddle.fixture = arena.leftPlayer.paddle.body:createFixture{
					shape = shape, 
					density = 10000,
					restitution = 0, 
					friction = 0,
					fixedRotation = true,
				}
				arena.leftPlayer.paddle.body:setAngle(arena.leftPlayer.paddle.side*math.pi)
				arena.leftPlayer.paddle.bitmap:setScale(arena.leftPlayer.paddle.paddleW/arena.leftPlayer.paddle.textureW, arena.leftPlayer.paddle.paddleH/arena.leftPlayer.paddle.textureH)
				arena.leftPlayer.paddle:setRotation(arena.leftPlayer.paddle.side*180)
				
				arena.leftPlayer.skillActive = false
			else
				local atkFactor = 0.24 + (arena.rightPlayer.char.atk)/16.5 -- 0.3 to 2
				local movFactor = 0.16 + (arena.rightPlayer.char.mov)/22.5 -- 0.2 to 1.5
				local defFactor = 0.21 + (arena.rightPlayer.char.def)/11 -- 0.3 to 3
				
				arena.rightPlayer.paddle.body.atkFactor = atkFactor
				arena.rightPlayer.char.movFactor = movFactor
				arena.rightPlayer.paddle.body.defFactor = defFactor
				
				local shape = b2.PolygonShape.new()
				arena.rightPlayer.paddle.paddleH = arena.leftPlayer.paddle.basepaddleH*defFactor
				arena.rightPlayer.paddle.body.paddleH = arena.leftPlayer.paddle.paddleH
				shape:setAsBox(arena.rightPlayer.paddle.paddleW/2, arena.rightPlayer.paddle.paddleH/2, 0, 0, 0)
				arena.rightPlayer.paddle.body:destroyFixture(arena.rightPlayer.paddle.fixture)
				arena.rightPlayer.paddle.shape = shape
				arena.rightPlayer.paddle.fixture = arena.rightPlayer.paddle.body:createFixture{
					shape = shape, 
					density = 10000,
					restitution = 0, 
					friction = 0,
					fixedRotation = true,
				}
				arena.rightPlayer.paddle.body:setAngle(arena.rightPlayer.paddle.side*math.pi)
				arena.rightPlayer.paddle.bitmap:setScale(arena.rightPlayer.paddle.paddleW/arena.rightPlayer.paddle.textureW, arena.rightPlayer.paddle.paddleH/arena.rightPlayer.paddle.textureH)
				arena.rightPlayer.paddle:setRotation(arena.rightPlayer.paddle.side*180)
				
				arena.rightPlayer.skillActive = false
			end
		end
		
		-- Sets timer to end skill --
		--Timer.delayedCall(self.basetime,  function()
		--	self:endAction() 
		--	sounds.powerup2over:play()
		--end)
	end
	
	
----------------------------------------------------
-- Steal: Steal ball and return with 2x its speed --
----------------------------------------------------
	if self.skill == "steal" then
		sounds.powerup2:play()
		
		-- Sets ball velocity towards paddle --
		local ballX, ballY = arena.ball.body:getPosition()
		local ballVx, ballVy = arena.ball.body:getLinearVelocity()
		local ballV0 = math.sqrt(ballVx*ballVx + ballVy*ballVy)
		local paddleX = 0
		local paddleY = 0
		
		local incomingFactor = ballV0/arena.ball.baseSpeed
		
		if side == 0 then
			paddleX, paddleY = arena.leftPlayer.paddle.body:getPosition()
			arena.leftPlayer.paddle.body.atkFactor = incomingFactor*2
		else
			paddleX, paddleY = arena.rightPlayer.paddle.body:getPosition()
			arena.rightPlayer.paddle.body.atkFactor = incomingFactor*2
		end
		
		local dX = (paddleX - ballX)/math.sqrt((paddleX - ballX)*(paddleX - ballX) + (paddleY - ballY)*(paddleY - ballY))
		local dY = (paddleY - ballY)/math.sqrt((paddleX - ballX)*(paddleX - ballX) + (paddleY - ballY)*(paddleY - ballY))
		
		arena.ball.body:setLinearVelocity(dX*ballV0, dY*ballV0)
		
		-- Action to end skill --
		self.endAction = function()
			if side == 0 then
				arena.leftPlayer.paddle.body.atkFactor = arena.leftPlayer.paddle.atkFactor
				arena.leftPlayer.skillActive = false
			else
				arena.rightPlayer.paddle.body.atkFactor = arena.rightPlayer.paddle.atkFactor
				arena.rightPlayer.skillActive = false
			end
		end
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime/6,  function()
			self:endAction() 
		end)
	end
end