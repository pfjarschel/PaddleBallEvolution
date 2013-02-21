----------------------
-- Class for Skills --
----------------------

Skills = Core.class()
Skills.skill = nil

function Skills:init(skill)
	self.skill = skill
end

function Skills:start(side)
	if self.skill == "powershot" then
		if side == 0 then
			arena.leftPlayer.paddle.body.atkFactor = arena.leftPlayer.paddle.body.atkFactor*10
			sounds.powerup2:play()
			
			local prevscore0 = arena.score0
			local prevscore1 = arena.score1
			local function stopSkill0() end
			
			local function colStopped0(event)
				local body1 = event.fixtureA:getBody()
				local body2 = event.fixtureB:getBody()
				if (body1.name == "ball" and body2.name == "paddle0") or (body2.name == "ball" and body1.name == "paddle0") then
					sounds.powerup2over:play()
					Timer.delayedCall(100, function()
						arena.leftPlayer.skillActive = false
						stopSkill0()
					end)
				end
			end
			local function goalStopped0()
				local score0 = arena.score0
				local score1 = arena.score1
				if score0 ~= prevscore0 or score1 ~= prevscore1 then
					stopSkill0()
				end
			end
			stopSkill0 = function ()
				arena.leftPlayer.paddle.body.atkFactor = arena.leftPlayer.paddle.atkFactor
				world:removeEventListener(Event.BEGIN_CONTACT, colStopped0)
				stage:removeEventListener(Event.ENTER_FRAME, goalStopped0)
			end
			world:addEventListener(Event.BEGIN_CONTACT, colStopped0)
			stage:addEventListener(Event.ENTER_FRAME, goalStopped0)
		else
			arena.rightPlayer.paddle.body.atkFactor = arena.rightPlayer.paddle.body.atkFactor*10
			sounds.powerup2:play()
			
			local prevscore0 = arena.score0
			local prevscore1 = arena.score1
			local function stopSkill1() end

			local function colStopped1(event)
				local body1 = event.fixtureA:getBody()
				local body2 = event.fixtureB:getBody()
				if (body1.name == "ball" and body2.name == "paddle1") or (body2.name == "ball" and body1.name == "paddle1") then
					sounds.powerup2over:play()
					Timer.delayedCall(100, function()
						arena.rightPlayer.skillActive = false
						stopSkill1()
					end)
				end
			end
			local function goalStopped1()
				local score0 = arena.score0
				local score1 = arena.score1
				if score0 ~= prevscore0 or score1 ~= prevscore1 then
					stopSkill1()
				end
			end
			stopSkill1 = function ()
				arena.rightPlayer.paddle.body.atkFactor = arena.rightPlayer.paddle.atkFactor
				world:removeEventListener(Event.BEGIN_CONTACT, colStopped1)
				stage:removeEventListener(Event.ENTER_FRAME, goalStopped1)
			end
			world:addEventListener(Event.BEGIN_CONTACT, colStopped1)
			stage:addEventListener(Event.ENTER_FRAME, goalStopped1)
		end
	end

	if self.skill == "viscousfield" then
		local ballVx, ballVy = arena.ball.body:getLinearVelocity()
		if ballVx ~= 0 and ballVy ~= 0 then
			local desVx = ballVx/10
			local desVy = ballVy/10
			if math.abs(desVx) < arena.ball.baseSpeed/6 then
				desVx = (ballVx/math.abs(ballVx))*arena.ball.baseSpeed/6
			end
			arena.ball.body:setLinearVelocity(desVx, desVy)
		end
		if side == 0 then
			arena.rightPlayer.paddle.body.atkFactor = arena.rightPlayer.paddle.body.atkFactor/10
			sounds.powerup2:play()
			
			local prevscore0 = arena.score0
			local prevscore1 = arena.score1
			local function stopSkill0() end

			local function colStopped0(event)
				local body1 = event.fixtureA:getBody()
				local body2 = event.fixtureB:getBody()
				if (body1.name == "ball" and (body2.name == "paddle1" or body2.name == "paddle0")) or (body2.name == "ball" and (body1.name == "paddle1" or body1.name == "paddle0")) then
					sounds.powerup2over:play()
					Timer.delayedCall(100, function()
						arena.leftPlayer.skillActive = false
						stopSkill0()
					end)
				end
			end
			local function goalStopped0()
				local score0 = arena.score0
				local score1 = arena.score1
				if score0 ~= prevscore0 or score1 ~= prevscore1 then
					stopSkill0()
				end
			end
			stopSkill0 = function ()
				arena.rightPlayer.paddle.body.atkFactor = arena.rightPlayer.paddle.atkFactor
				world:removeEventListener(Event.BEGIN_CONTACT, colStopped0)
				stage:removeEventListener(Event.ENTER_FRAME, goalStopped0)
			end
			world:addEventListener(Event.BEGIN_CONTACT, colStopped0)
			stage:addEventListener(Event.ENTER_FRAME, goalStopped0)
		else
			arena.leftPlayer.paddle.body.atkFactor = arena.leftPlayer.paddle.body.atkFactor/10
			sounds.powerup2:play()
			
			local prevscore0 = arena.score0
			local prevscore1 = arena.score1
			local function stopSkill1() end
			
			local function colStopped1(event)
				local body1 = event.fixtureA:getBody()
				local body2 = event.fixtureB:getBody()
				if (body1.name == "ball" and (body2.name == "paddle1" or body2.name == "paddle0")) or (body2.name == "ball" and (body1.name == "paddle1" or body1.name == "paddle0")) then
					sounds.powerup2over:play()
					Timer.delayedCall(100, function()
						arena.rightPlayer.skillActive = false
						stopSkill1()
					end)
				end
			end
			local function goalStopped1()
				local score0 = arena.score0
				local score1 = arena.score1
				if score0 ~= prevscore0 or score1 ~= prevscore1 then
					stopSkill1()
				end
			end
			stopSkill1 = function ()
				arena.leftPlayer.paddle.body.atkFactor = arena.leftPlayer.paddle.atkFactor
				world:removeEventListener(Event.BEGIN_CONTACT, colStopped1)
				stage:removeEventListener(Event.ENTER_FRAME, goalStopped1)
			end
			world:addEventListener(Event.BEGIN_CONTACT, colStopped1)
			stage:addEventListener(Event.ENTER_FRAME, goalStopped1)
		end
	end

	if self.skill == "invisiball" then
		if side == 0 then
			arena.ball:setAlpha(0)
			sounds.powerup2:play()
			
			local prevscore0 = arena.score0
			local prevscore1 = arena.score1
			local function stopSkill0() end

			local function colStopped0(event)
				local body1 = event.fixtureA:getBody()
				local body2 = event.fixtureB:getBody()
				if (body1.name == "ball" and body2.name == "paddle1") or (body2.name == "ball" and body1.name == "paddle1") then
					sounds.powerup2over:play()
					Timer.delayedCall(100, function()
						arena.leftPlayer.skillActive = false
						stopSkill0()
					end)
				end
			end
			local function goalStopped0()
				local score0 = arena.score0
				local score1 = arena.score1
				if score0 ~= prevscore0 or score1 ~= prevscore1 then
					stopSkill0()
				end
			end
			stopSkill0 = function ()
				arena.ball:setAlpha(1)
				world:removeEventListener(Event.BEGIN_CONTACT, colStopped0)
				stage:removeEventListener(Event.ENTER_FRAME, goalStopped0)
			end
			world:addEventListener(Event.BEGIN_CONTACT, colStopped0)
			stage:addEventListener(Event.ENTER_FRAME, goalStopped0)
		else
			arena.ball:setAlpha(0)
			sounds.powerup2:play()
			
			local prevscore0 = arena.score0
			local prevscore1 = arena.score1
			local function stopSkill1() end
			
			local function colStopped1(event)
				local body1 = event.fixtureA:getBody()
				local body2 = event.fixtureB:getBody()
				if (body1.name == "ball" and body2.name == "paddle0") or (body2.name == "ball" and body1.name == "paddle0") then
					sounds.powerup2over:play()
					arena.rightPlayer.skillActive = false
					stopSkill1()
				end
			end
			local function goalStopped1()
				local score0 = arena.score0
				local score1 = arena.score1
				if score0 ~= prevscore0 or score1 ~= prevscore1 then
					stopSkill1()
				end
			end
			stopSkill1 = function ()
				arena.ball:setAlpha(1)
				world:removeEventListener(Event.BEGIN_CONTACT, colStopped1)
				stage:removeEventListener(Event.ENTER_FRAME, goalStopped1)
			end
			world:addEventListener(Event.BEGIN_CONTACT, colStopped1)
			stage:addEventListener(Event.ENTER_FRAME, goalStopped1)
		end
	end

	if self.skill == "curveball" then
		sounds.powerup2:play()
		local direction = -1
		local function curveball()
		local ballX, ballY = arena.ball.body:getPosition()
			local ballVx, ballVy = arena.ball.body:getLinearVelocity()
			if ballVy > arena.ball.baseSpeed then
				direction = direction*-1
			elseif ballVy < -arena.ball.baseSpeed then
				direction = direction*-1
			end
			arena.ball.body:applyForce(0, direction*75, ballX, ballY)
		end
		
		local prevscore0 = arena.score0
		local prevscore1 = arena.score1
		local function stopSkill0() end

		local function colStopped0(event)
			local body1 = event.fixtureA:getBody()
			local body2 = event.fixtureB:getBody()
			if (body1.name == "ball" and (body2.name == "paddle1" or body2.name == "paddle0")) or (body2.name == "ball" and (body1.name == "paddle1" or body1.name == "paddle0")) then
				sounds.powerup2over:play()
				Timer.delayedCall(100, function()
					arena.leftPlayer.skillActive = false
					stopSkill0()
				end)
			end
		end
		local function goalStopped0()
			local score0 = arena.score0
			local score1 = arena.score1
			if score0 ~= prevscore0 or score1 ~= prevscore1 then
				stopSkill0()
			end
		end
		stopSkill0 = function ()
			world:removeEventListener(Event.BEGIN_CONTACT, colStopped0)
			stage:removeEventListener(Event.ENTER_FRAME, goalStopped0)
			stage:removeEventListener(Event.ENTER_FRAME, curveball)
		end
		world:addEventListener(Event.BEGIN_CONTACT, colStopped0)
		stage:addEventListener(Event.ENTER_FRAME, goalStopped0)
		stage:addEventListener(Event.ENTER_FRAME, curveball)
	end


end