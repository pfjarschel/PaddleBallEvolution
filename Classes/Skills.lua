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
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime, function()
			if side == 0 then
				arena.leftPlayer.paddle.body.atkFactor = arena.leftPlayer.paddle.atkFactor
				arena.leftPlayer.skillActive = false
			else
				arena.rightPlayer.paddle.body.atkFactor = arena.rightPlayer.paddle.atkFactor
				arena.rightPlayer.skillActive = false
			end
			sounds.powerup2over:play()
		end)
	end


--------------------------------------------------
-- Viscous Field: Ball speed is greatly reduced --
--------------------------------------------------
	if self.skill == "viscousfield" then
		sounds.powerup2over:play()
		
		-- Gets ball speed and reduces it --
		local ballVx, ballVy = arena.ball.body:getLinearVelocity()
		local desVx = ballVx/10
		local desVy = ballVy/10
		arena.ball.body:setLinearVelocity(desVx, desVy)
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime/2, function()
			if side == 0 then
				arena.leftPlayer.skillActive = false
			else
				arena.rightPlayer.skillActive = false
			end
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
		arena.leftPlayer.char.intFactor = 5
		arena.rightPlayer.char.intFactor = 5
		arena.leftPlayer:aiRandomFactor()
		arena.rightPlayer:aiRandomFactor()
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime/3, function()
			arena.ball:setAlpha(1)
			arena.leftPlayer.char.intFactor = leftIntFactor
			arena.rightPlayer.char.intFactor = rightIntFactor
			arena.leftPlayer:aiRandomFactor()
			arena.rightPlayer:aiRandomFactor()
			sounds.powerup2over:play()
			
			if side == 0 then
				arena.leftPlayer.skillActive = false
			else
				arena.rightPlayer.skillActive = false
			end
		end)
	end


----------------------------------------
-- CurveBall: Ball makes crazy curves --
----------------------------------------
	if self.skill == "curveball" then
		sounds.powerup2:play()
		
		-- Each frame, applies force on ball, to make it do crazy curves --
		local direction = -1
		local crazyFactor = 4*arena.ball.baseSpeed
		local function curveball()
			local ballX, ballY = arena.ball.body:getPosition()
			local ballVx, ballVy = arena.ball.body:getLinearVelocity()
			
			if ballVy > arena.ball.baseSpeed then
				direction = direction*-1
			elseif ballVy < -arena.ball.baseSpeed then
				direction = direction*-1
			end
			
			-- Only if ball is launched --
			if arena.ball.launched then
				arena.ball.body:applyForce(0, direction*crazyFactor, ballX, ballY)
			end
		end
		
		-- Adds event listener --
		stage:addEventListener(Event.ENTER_FRAME, curveball)
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime/2, function()
			stage:removeEventListener(Event.ENTER_FRAME, curveball)
			sounds.powerup2over:play()
			
			if side == 0 then
				arena.leftPlayer.skillActive = false
			else
				arena.rightPlayer.skillActive = false
			end
		end)
	end


end