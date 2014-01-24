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
		if optionsTable["SFX"] == "On" then sounds.powerup2:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
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
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
				arena.leftPlayer.skillActive = false
			else
				arena.rightPlayer.paddle.body.atkFactor = arena.rightPlayer.paddle.atkFactor
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
				arena.rightPlayer.skillActive = false
			end
		end
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime,  function()
			self:endAction() 
			if optionsTable["SFX"] == "On" then sounds.powerup2over:play() end
		end)
	end


--------------------------------------------------
-- Viscous Field: Ball speed is greatly reduced --
--------------------------------------------------
	if self.skill == "viscousfield" then
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Gets ball speed and reduces it --
		local ballVx, ballVy = arena.ball.body:getLinearVelocity()
		local ballV0 = math.sqrt(ballVx*ballVx + ballVy*ballVy)
		local desVx = ballV0*(ballVx/ballV0)/10
		local desVy = ballV0*(ballVy/ballV0)/10
		local ballV = math.sqrt(desVx*desVx + desVy*desVy)
		
		-- Prevents too many slow-downs, any direction speed must be greater than minimum base speed --
		if ballV < arena.ball.baseSpeed/10 then
			ballV = arena.ball.baseSpeed/10
			desVx = (ballVx/ballV0)*arena.ball.baseSpeed/10
			desVy = (ballVy/ballV0)*arena.ball.baseSpeed/10
		end
		if optionsTable["SFX"] == "On" then sounds.powerup2over:play() end
		arena.ball.body:setLinearVelocity(desVx, desVy)
		
		-- Action to end skill --
		self.endAction = function() 
			if side == 0 then
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
				arena.leftPlayer.skillActive = false
			else
				arena.rightPlayer.skillActive = false
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
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
		if optionsTable["SFX"] == "On" then sounds.powerup2:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Sets ball alpha very low --
		arena.ball:setAlpha(0.05)
		
		-- Sets AI intelligence very bad --
		arena.aiPlayer.char.intFactor = 7
		arena.aiPlayer:aiRandomFactor()
		
		-- Action to end skill --
		self.endAction = function()
			arena.ball:setAlpha(1)
			arena.aiPlayer.char:updateAttr()
			arena.aiPlayer:aiRandomFactor()
			
			if side == 0 then
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
				arena.leftPlayer.skillActive = false
			else
				arena.rightPlayer.skillActive = false
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
			end
		end
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime/3, function()
			self:endAction()
			if optionsTable["SFX"] == "On" then sounds.powerup2over:play() end
		end)
	end


----------------------------------------
-- CurveBall: Ball makes crazy curves --
----------------------------------------
	if self.skill == "curveball" then
		if optionsTable["SFX"] == "On" then sounds.powerup2:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
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
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
			else
				arena.rightPlayer.skillActive = false
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
			end
		end 
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime/2, function()
			self:endAction() 
			if optionsTable["SFX"] == "On" then sounds.powerup2over:play() end
			
			-- Returns ball to previous state --
			local ballVxRet = arena.ball.body:getLinearVelocity()
			arena.ball.body:setLinearVelocity(math.abs(ballVxRet*ballVx0)/ballVxRet, ballVy0)
		end)
	end
	

----------------------------------------------------------
-- ArrowBall: Ball moves in a straight line to the goal --
----------------------------------------------------------
	if self.skill == "arrowball" then
		if optionsTable["SFX"] == "On" then sounds.powerup2:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
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
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
				arena.leftPlayer.skillActive = false
			else
				arena.rightPlayer.skillActive = false
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
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
		if optionsTable["SFX"] == "On" then sounds.powerup2:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Gets velocity --
		local ballVx0, ballVy0 = arena.ball.body:getLinearVelocity()
		
		-- Only if ball is launched --
		if arena.ball.launched then
			arena.ball.body:setLinearVelocity(-ballVx0, ballVy0)
		end
		
		-- Action to end Skill --
		self.endAction = function()	
			if side == 0 then
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
				arena.leftPlayer.skillActive = false
			else
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
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
		if optionsTable["SFX"] == "On" then sounds.powerup2:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
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
			arena.leftPlayer.paddle.fixture:setFilterData({categoryBits = 2, maskBits = 5, groupIndex = 0})
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
			arena.rightPlayer.paddle.fixture:setFilterData({categoryBits = 2, maskBits = 5, groupIndex = 0})
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
				arena.leftPlayer.paddle.fixture:setFilterData({categoryBits = 2, maskBits = 5, groupIndex = 0})
				arena.leftPlayer.paddle.body:setAngle(arena.leftPlayer.paddle.side*math.pi)
				arena.leftPlayer.paddle.bitmap:setScale(arena.leftPlayer.paddle.paddleW/arena.leftPlayer.paddle.textureW, arena.leftPlayer.paddle.paddleH/arena.leftPlayer.paddle.textureH)
				arena.leftPlayer.paddle:setRotation(arena.leftPlayer.paddle.side*180)
				
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
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
				arena.rightPlayer.paddle.fixture:setFilterData({categoryBits = 2, maskBits = 5, groupIndex = 0})
				arena.rightPlayer.paddle.body:setAngle(arena.rightPlayer.paddle.side*math.pi)
				arena.rightPlayer.paddle.bitmap:setScale(arena.rightPlayer.paddle.paddleW/arena.rightPlayer.paddle.textureW, arena.rightPlayer.paddle.paddleH/arena.rightPlayer.paddle.textureH)
				arena.rightPlayer.paddle:setRotation(arena.rightPlayer.paddle.side*180)
				
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
				arena.rightPlayer.skillActive = false
			end
		end
		
		-- Sets timer to end skill --
		--Timer.delayedCall(self.basetime,  function()
		--	self:endAction() 
		--	if optionsTable["SFX"] == "On" then sounds.powerup2over:play() end
		--end)
	end
	
	
----------------------------------------------------
-- Steal: Steal ball and return with 2x its speed --
----------------------------------------------------
	if self.skill == "steal" then
		if optionsTable["SFX"] == "On" then sounds.powerup2:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
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
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
				arena.leftPlayer.skillActive = false
			else
				arena.rightPlayer.paddle.body.atkFactor = arena.rightPlayer.paddle.atkFactor
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
				arena.rightPlayer.skillActive = false
			end
		end
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime/6,  function()
			self:endAction() 
		end)
	end
	

-------------------------------------------------------
-- Multiball: Creates illusions to confuse the enemy --
-------------------------------------------------------
	if self.skill == "multiball" then
		if optionsTable["SFX"] == "On" then sounds.powerup2:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Creates 2 additional balls, stores original ball --
		local ballX, ballY = arena.ball.body:getPosition()
		local ballVx, ballVy = arena.ball.body:getLinearVelocity()
		local ballV0 = math.sqrt(ballVx*ballVx + ballVy*ballVy)
		
		local ball2 = Ball.new(arena.difFactor)
		local ball3 = Ball.new(arena.difFactor)
		local ball0 = arena.ball
		
		ball2.body:setPosition(ballX, ballY)
		ball3.body:setPosition(ballX, ballY)
		ball2.body:setLinearVelocity(ballV0*math.cos(-math.pi/3)*(math.abs(ballVx)/ballVx), ballV0*math.sin(-math.pi/3)*(math.abs(ballVy)/ballVy))
		ball3.body:setLinearVelocity(ballV0*math.cos(math.pi/3)*(math.abs(ballVx)/ballVx), ballV0*math.sin(math.pi/3)*(math.abs(ballVy)/ballVy))
		
		ball2.launched = true
		ball3.launched = true
		ball2.bitmap:setColorTransform(arena.ball.bitmap:getColorTransform())
		ball3.bitmap:setColorTransform(arena.ball.bitmap:getColorTransform())
		
		-- Sets arena ball to one of the balls --
		local randomnum = math.random(1, 3)
		if randomnum == 2 then
			arena.ball = ball2
		elseif randomnum == 3 then
			arena.ball = ball3
		end
		
		-- Sets AI Target ball to one of the balls --
		local randomnum = math.random(1, 3)
		if randomnum == 2 then
			arena.aiPlayer.AITarget = ball2
		elseif randomnum == 3 then
			arena.aiPlayer.AITarget = ball3
		end
		
		-- Action to end skill --
		self.endAction = function()
			arena.ball = ball0
			
			arena:removeChild(ball2)
			world:destroyBody(ball2.body)
			ball2.body = nil
			arena:removeChild(ball3)
			world:destroyBody(ball3.body)
			ball3.body = nil
			
			arena.aiPlayer.AITarget = arena.ball
			
			if side == 0 then
				arena.leftPlayer.skillActive = false
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
			else
				arena.rightPlayer.skillActive = false
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
			end
		end
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime/3,  function()
			self:endAction() 
		end)
	end
	
	
--------------------------------------------------------
-- PowerShot: The next ball return will be VERY fast! --
--------------------------------------------------------
	if self.skill == "freeze" then
		if optionsTable["SFX"] == "On" then sounds.powerup2:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Freezes opponent --
		if side == 0 then
			arena.rightPlayer.char.movFactor = 0
		else
			arena.leftPlayer.char.movFactor = 0
		end
		
		-- Action to end skill --
		self.endAction = function()
			if side == 0 then
				arena.rightPlayer.char:updateAttr()
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
				arena.leftPlayer.skillActive = false
			else
				arena.leftPlayer.char:updateAttr()
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
				arena.rightPlayer.skillActive = false
			end
		end
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime/5,  function()
			self:endAction() 
			if optionsTable["SFX"] == "On" then sounds.powerup2over:play() end
		end)
	end	
	
	
end