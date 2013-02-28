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
		Timer.delayedCall(self.basetime/10,  function()
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
			
			-- Only if ball is launched --
			if arena.ball.launched then
				arena.ball.body:applyForce(0, direction*crazyFactor, ballX, ballY)
			end
		end
		
		-- Adds event listener --
		stage:addEventListener(Event.ENTER_FRAME, curveball)
		
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


end