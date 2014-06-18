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

-- Declare these functions to later hold skill specific action to end it --
function Skills:endAction()
end
function Skills:forceEnd()
end

function Skills:start(side)


------------------------------------
-- No Skill: +10 attribute points --
------------------------------------
	if self.skill == "noskill" then
		
		self.endAction = function()
			
		end
		
		-- Action to force end --
		self.forceEnd = function()
			
		end
	end	


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
		
		-- Get Color --
		local colort = {}
		if side == 0 then
			colort[1], colort[2], colort[3] = arena.leftPlayer.paddle.bitmap:getColorTransform()
		else
			colort[1], colort[2], colort[3] = arena.rightPlayer.paddle.bitmap:getColorTransform()
		end
		
		-- GFX --
		if side == 0 then
			arena.leftPlayer.paddle.bitmap:setColorTransform(1, 0, 0)
		else
			arena.rightPlayer.paddle.bitmap:setColorTransform(1, 0, 0)
		end
		
		-- Action to end skill --
		self.endAction = function()
			if side == 0 then
				arena.leftPlayer.paddle.body.atkFactor = arena.leftPlayer.paddle.atkFactor
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
				arena.leftPlayer.paddle.bitmap:setColorTransform(colort[1], colort[2], colort[3])
				arena.leftPlayer.skillActive = false
			else
				arena.rightPlayer.paddle.body.atkFactor = arena.rightPlayer.paddle.atkFactor
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
				arena.rightPlayer.paddle.bitmap:setColorTransform(colort[1], colort[2], colort[3])
				arena.rightPlayer.skillActive = false
			end
		end
		
		-- Sets timer to end skill --
		--Timer.delayedCall(self.basetime,  function()
			--self:endAction() 
			--if optionsTable["SFX"] == "On" then sounds.powerup2over:play() end
		--end)
		
		-- Action to force end --
		self.forceEnd = function()
			
		end
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
		if optionsTable["SFX"] == "On" then sounds.bubbles:play() end
		arena.ball.body:setLinearVelocity(desVx, desVy)
		
		-- Sets AI intelligence high --
		arena.aiPlayer.char.intFactor = 0.4
		arena.aiPlayer:aiRandomFactor()
		
		-- GFX --
		local viscousfield = Bitmap.new(textures.gfx_viscousfield)
		viscousfield:setScale(1, 1)
		viscousfield:setAnchorPoint(0.5, 0.5)
		arena:addChild(viscousfield)
		local textureW = viscousfield:getWidth()
		local textureH = viscousfield:getHeight()
		viscousfield:setScale(WX/textureW, WY/textureH)
		viscousfield:setPosition(WX/2 + XShift, WY/2)
		viscousfield:setAlpha(0)
		fadeBitmapIn(viscousfield, 1000, 0.3)
		
		-- Action to end skill --
		self.endAction = function()
			fadeBitmapOut(viscousfield, 1000, arena)
			
			arena.aiPlayer.char:updateAttr()
			
			ballVx, ballVy = arena.ball.body:getLinearVelocity()
			ballV0 = math.sqrt(ballVx*ballVx + ballVy*ballVy)
			arena.ball.body:setLinearVelocity((ballVx/ballV0)*arena.ball.baseSpeed, (ballVy/ballV0)*arena.ball.baseSpeed)
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
		Timer.delayedCall(self.basetime/2,  function()
			self:endAction()
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == viscousfield then
					fadeBitmapOut(viscousfield, 1000, arena)
				end
			end
		end
	end


------------------------------------------------------
-- Invisiball: Ball is invisible. Simple like that! --
------------------------------------------------------
	if self.skill == "invisiball" then
		if optionsTable["SFX"] == "On" then sounds.puff:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Sets ball alpha very low --
		arena.ball:setAlpha(0.03)
		
		-- Sets AI intelligence very bad --
		arena.aiPlayer.char.intFactor = 7
		arena.aiPlayer:aiRandomFactor()
		
		-- GFX --
		local ballX, ballY = 0
		ballX, ballY = arena.ball.body:getPosition()
		local puff = Bitmap.new(textures.gfx_puff)
		puff:setScale(1, 1)
		puff:setAnchorPoint(0.5, 0.5)
		arena:addChild(puff)
		local textureW = puff:getWidth()
		local textureH = puff:getHeight()
		puff:setPosition(ballX, ballY)
		puff:setAlpha(0.4)
		puff:setRotation(math.random(1,360))
		
		scaleBitmap(puff, 100, 60/textureW, 0)		
		Timer.delayedCall(200, function()
			fadeBitmapOut(puff, 1000, arena)
		end)
		
		local puff2 = nil
		
		-- Action to end skill --
		local finished = false
		self.endAction = function()
			if optionsTable["SFX"] == "On" then sounds.puff:play() end
			finished = true
			
			arena.ball:setAlpha(1)
			arena.aiPlayer.char:updateAttr()
			arena.aiPlayer:aiRandomFactor()
			
			if side == 0 then
				ballCollideO0 = function(event)
				end
			else
				ballCollideO1 = function(event)
				end
			end
			
			ballX, ballY = 0
			ballX, ballY = arena.ball.body:getPosition()
			puff2 = Bitmap.new(textures.gfx_puff)
			puff2:setScale(1, 1)
			puff2:setAnchorPoint(0.5, 0.5)
			arena:addChild(puff2)
			local textureW2 = puff2:getWidth()
			local textureH2 = puff2:getHeight()
			puff2:setPosition(ballX, ballY)
			puff2:setAlpha(0.4)
			puff2:setRotation(math.random(1,360))
			scaleBitmap(puff2, 100, 60/textureW2, 0)
			Timer.delayedCall(200, function()
				fadeBitmapOut(puff2, 1000, arena)
			end)
			
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
		
		-- End if ball hits enemy --
		local function endaction()
		end
		endaction = self.endAction
		if side == 0 then
			ballCollideO0 = function(event)
				local body1 = event.fixtureA:getBody()
				local body2 = event.fixtureB:getBody()
				if (((body1 == arena.rightPlayer.paddle.body or body2 == arena.rightPlayer.paddle.body) and side == 0)
				or ((body1 == arena.leftPlayer.paddle.body or body2 == arena.leftPlayer.paddle.body) and side == 1)) then
					endaction()
				end
			end
		else
			ballCollideO1 = function(event)
				local body1 = event.fixtureA:getBody()
				local body2 = event.fixtureB:getBody()
				if (((body1 == arena.rightPlayer.paddle.body or body2 == arena.rightPlayer.paddle.body) and side == 0)
				or ((body1 == arena.leftPlayer.paddle.body or body2 == arena.leftPlayer.paddle.body) and side == 1)) then
					endaction()
				end
			end
		end
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime/2, function()
			if not finished then
				self:endAction()
			end
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == puff then
					fadeBitmapOut(puff, 1000, arena)
				elseif arena:getChildAt(i) == puff2 then
					fadeBitmapOut(puff2, 1000, arena)
				end
			end
		end
	end


----------------------------------------
-- CurveBall: Ball makes crazy curves --
----------------------------------------
	if self.skill == "curveball" then
		if optionsTable["SFX"] == "On" then sounds.crazyball:play() end
		
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
			
			if ballVx == 0 and ballVy == 0 then
				ballVx0 = 0
				ballVy0 = 0
				self:endAction()
			else
				if ballVy > 7.5*(ballV0^0.49) then
					direction = direction*-1
				elseif ballVy < -7.5*(ballV0^0.49) then
					direction = direction*-1
				end
				arena.ball.body:applyForce(0, direction*crazyFactor, ballX, ballY)
			end
		end
		
		-- Adds event listener only if ball is launched --
		if arena.ball.launched then
			stage:addEventListener(Event.ENTER_FRAME, curveball)
		end
		
		-- GFX --
		scaleBitmap(arena.ball.bitmap, 250, 2*arena.ball.bitmap:getScale(), arena.ball.bitmap:getScale())
		Timer.delayedCall(300, function()
			scaleBitmap(arena.ball.bitmap, 250, arena.ball.bitmap:getScale()/2, arena.ball.bitmap:getScale())
		end)
		
		-- Action to end Skill --
		local finished = false
		self.endAction = function()
			finished = true
			stage:removeEventListener(Event.ENTER_FRAME, curveball)
			Timer.delayedCall(600, function()
				arena.ball.bitmap:setScale(2*arena.ball.radius/textures.pongball:getWidth())
			end)
			
			if side == 0 then
				ballCollideO0 = function(event)
				end
			else
				ballCollideO1 = function(event)
				end
			end
			
			if optionsTable["SFX"] == "On" then sounds.crazyball_end:play() end
			
			-- Returns ball to previous state --
			--local ballVxRet = arena.ball.body:getLinearVelocity()
			--arena.ball.body:setLinearVelocity(math.abs(ballVxRet*ballVx0)/ballVxRet, ballVy0)
			arena.ball.body:setLinearVelocity(ballVx0, ballVy0)
			
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
		
		-- End if ball hits enemy --
		local function endaction()
		end
		endaction = self.endAction
		if side == 0 then
			ballCollideO0 = function(event)
				local body1 = event.fixtureA:getBody()
				local body2 = event.fixtureB:getBody()
				if (((body1 == arena.rightPlayer.paddle.body or body2 == arena.rightPlayer.paddle.body) and side == 0)
				or ((body1 == arena.leftPlayer.paddle.body or body2 == arena.leftPlayer.paddle.body) and side == 1)) then
					endaction()
				end
			end
		else
			ballCollideO1 = function(event)
				local body1 = event.fixtureA:getBody()
				local body2 = event.fixtureB:getBody()
				if (((body1 == arena.rightPlayer.paddle.body or body2 == arena.rightPlayer.paddle.body) and side == 0)
				or ((body1 == arena.leftPlayer.paddle.body or body2 == arena.leftPlayer.paddle.body) and side == 1)) then
					endaction()
				end
			end
		end
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime/2, function()
			if not finished then
				self:endAction()
			end
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			arena.ball.bitmap:setScale(2*arena.ball.radius/textures.pongball:getWidth())
		end
	end
	

----------------------------------------------------------
-- ArrowBall: Ball moves in a straight line to the goal --
----------------------------------------------------------
	if self.skill == "arrowball" then
		if optionsTable["SFX"] == "On" then sounds.woosh:play() end
		
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
		
		-- GFX --
		local arrow = Bitmap.new(textures.gfx_arrow)
		arrow:setScale(1, 1)
		arrow:setAnchorPoint(0.5, 0.5)
		arena.ball:addChild(arrow)
		local textureW = arrow:getWidth()
		local textureH = arrow:getHeight()
		arrow:setColorTransform(arena.ball.bitmap:getColorTransform())
		arrow:setAlpha(0.5)
		scaleBitmapXY(arrow, 1000, direction*325/textureW, direction*100/textureH, 0, 0)		
		fadeBitmapOut(arrow, 1000, arena.ball)
		
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
		
		-- Action to force end --
		self.forceEnd = function()
			for i = arena.ball:getNumChildren(), 1, -1 do
				if arena.ball:getChildAt(i) == arrow then
					fadeBitmapOut(arrow, 250, arena.ball)
				end
			end
		end
	end


-------------------------------------------------
-- MirrorBall: Ball changes movement direction --
-------------------------------------------------
	if self.skill == "mirrorball" then
		if optionsTable["SFX"] == "On" then sounds.glass_ping:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Gets velocity and position--
		local ballVx0, ballVy0 = arena.ball.body:getLinearVelocity()
		local ballX, ballY = arena.ball.body:getPosition()
		
		-- Only if ball is launched --
		if arena.ball.launched then
			arena.ball.body:setLinearVelocity(-ballVx0, ballVy0)
		end
		
		-- GFX --
		local mirror = Bitmap.new(textures.gfx_mirror)
		mirror:setScale(1, 1)
		mirror:setAnchorPoint(0.5, 0.5)
		arena:addChild(mirror)
		local textureW = mirror:getWidth()
		local textureH = mirror:getHeight()
		mirror:setScale(15/textureW, 480/textureH)
		mirror:setPosition(ballX, WY/2)
		fadeBitmapIn(mirror, 200, 1)
		Timer.delayedCall(200, function()
			fadeBitmapOut(mirror, 200, arena)
		end)
		
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
		
		-- Action to force end --
		self.forceEnd = function()
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == mirror then
					fadeBitmapOut(mirror, 200, arena)
				end
			end
		end
	end


-------------------------------------------------
-- Berserk: Atk, Mov and Def greatly increased --
-------------------------------------------------
	if self.skill == "berserk" then
		if optionsTable["SFX"] == "On" then sounds.powerup2:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Get Color --
		local colort = {}
		if side == 0 then
			colort[1], colort[2], colort[3] = arena.leftPlayer.paddle.bitmap:getColorTransform()
		else
			colort[1], colort[2], colort[3] = arena.rightPlayer.paddle.bitmap:getColorTransform()
		end
		
		-- GFX --
		if side == 0 then
			arena.leftPlayer.paddle.bitmap:setColorTransform(1, 0, 0)
		else
			arena.rightPlayer.paddle.bitmap:setColorTransform(1, 0, 0)
		end
		
		-- Sets stats + X, calculates factors and update --
		local incr = 10
		
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
				arena.leftPlayer.paddle.bitmap:setColorTransform(colort[1], colort[2], colort[3])
				
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
				arena.rightPlayer.paddle.paddleH = arena.rightPlayer.paddle.basepaddleH*defFactor
				arena.rightPlayer.paddle.body.paddleH = arena.rightPlayer.paddle.paddleH
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
				arena.rightPlayer.paddle.bitmap:setColorTransform(colort[1], colort[2], colort[3])
				
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
		
		-- Action to force end --
		self.forceEnd = function()
			
		end
	end
	
	
----------------------------------------------------
-- Steal: Steal ball and return with 2x its speed --
----------------------------------------------------
	if self.skill == "steal" then
		if optionsTable["SFX"] == "On" then sounds.tractorbeam:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Sets ball velocity towards paddle --
		local ballX, ballY = arena.ball.body:getPosition()
		local ballVx, ballVy = arena.ball.body:getLinearVelocity()
		local ballV0 = math.sqrt(ballVx*ballVx + ballVy*ballVy)
		local paddleX = 0
		local paddleY = 0
		local paddleH, paddleW = 0
		
		local incomingFactor = ballV0/arena.ball.baseSpeed
		
		if side == 0 then
			paddleX, paddleY = arena.leftPlayer.paddle.body:getPosition()
			arena.leftPlayer.paddle.body.atkFactor = incomingFactor*2
			paddleH = arena.leftPlayer.paddle.paddleH
			paddleW = arena.leftPlayer.paddle.paddleW
		else
			paddleX, paddleY = arena.rightPlayer.paddle.body:getPosition()
			arena.rightPlayer.paddle.body.atkFactor = incomingFactor*2
			paddleH = arena.rightPlayer.paddle.paddleH
			paddleW = arena.rightPlayer.paddle.paddleW
		end
		
		local dX = (paddleX - ballX)/math.sqrt((paddleX - ballX)*(paddleX - ballX) + (paddleY - ballY)*(paddleY - ballY))
		local dY = (paddleY - ballY)/math.sqrt((paddleX - ballX)*(paddleX - ballX) + (paddleY - ballY)*(paddleY - ballY))
		
		arena.ball.body:setLinearVelocity(dX*ballV0, dY*ballV0)
		
		-- GFX --
		local beam = Bitmap.new(textures.gfx_tractorbeam)
		beam:setScale(1, 1)
		beam:setAnchorPoint(0.5, 0.5)
		
		if side == 0 then
			arena.leftPlayer.paddle:addChild(beam)
		else
			arena.rightPlayer.paddle:addChild(beam)
		end
		
		local textureW = beam:getWidth()
		local textureH = beam:getHeight()
		beam:setScale(320*(paddleH/75)/textureW, 280*(paddleW/15)/textureH)
		beam:setPosition(paddleW/2 + 0.9*beam:getWidth()/2, 0)
		beam:setRotation(0)
		
		fadeBitmapIn(beam, 250, 0.3)
		Timer.delayedCall(1000, function()
			if side == 0 then
				fadeBitmapOut(beam, 250, arena.leftPlayer.paddle)
			else
				fadeBitmapOut(beam, 250, arena.rightPlayer.paddle)
			end
		end)
		
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
		
		-- Action to force end --
		self.forceEnd = function()
			if side == 0 then
				for i = arena.leftPlayer.paddle:getNumChildren(), 1, -1 do
					if arena.leftPlayer.paddle:getChildAt(i) == beam then
						fadeBitmapOut(beam, 250, arena.leftPlayer.paddle)
					end
				end
			else
				for i = arena.rightPlayer.paddle:getNumChildren(), 1, -1 do
					if arena.rightPlayer.paddle:getChildAt(i) == beam then
						fadeBitmapOut(beam, 250, arena.rightPlayer.paddle)
					end
				end
			end
		end
	end
	

-------------------------------------------------------
-- Multiball: Creates illusions to confuse the enemy --
-------------------------------------------------------
	if self.skill == "multiball" then
		if optionsTable["SFX"] == "On" then sounds.magic:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Creates 2 additional balls, set random directions --
		local ballX, ballY = arena.ball.body:getPosition()
		local ballVx, ballVy = arena.ball.body:getLinearVelocity()
		local ballV0 = math.sqrt(ballVx*ballVx + ballVy*ballVy)
		
		local ball2 = Ball.new(arena.difFactor)
		local ball3 = Ball.new(arena.difFactor)
		
		ball2.body:setPosition(ballX, ballY)
		ball3.body:setPosition(ballX, ballY)
		
		local randomdir = math.random(1, 6)
		if randomdir == 1 then
			arena.ball.body:setLinearVelocity(ballV0*math.cos(-math.pi/3)*(math.abs(ballVx)/ballVx), ballV0*math.sin(-math.pi/3)*(math.abs(ballVy)/ballVy))
			ball2.body:setLinearVelocity(ballVx, ballVy)
			ball3.body:setLinearVelocity(ballV0*math.cos(math.pi/3)*(math.abs(ballVx)/ballVx), ballV0*math.sin(math.pi/3)*(math.abs(ballVy)/ballVy))
		elseif randomdir == 2 then
			arena.ball.body:setLinearVelocity(ballV0*math.cos(-math.pi/3)*(math.abs(ballVx)/ballVx), ballV0*math.sin(-math.pi/3)*(math.abs(ballVy)/ballVy))
			ball2.body:setLinearVelocity(ballV0*math.cos(math.pi/3)*(math.abs(ballVx)/ballVx), ballV0*math.sin(math.pi/3)*(math.abs(ballVy)/ballVy))
			ball3.body:setLinearVelocity(ballVx, ballVy)
		elseif randomdir == 3 then
			arena.ball.body:setLinearVelocity(ballVx, ballVy)
			ball2.body:setLinearVelocity(ballV0*math.cos(-math.pi/3)*(math.abs(ballVx)/ballVx), ballV0*math.sin(-math.pi/3)*(math.abs(ballVy)/ballVy))
			ball3.body:setLinearVelocity(ballV0*math.cos(math.pi/3)*(math.abs(ballVx)/ballVx), ballV0*math.sin(math.pi/3)*(math.abs(ballVy)/ballVy))
		elseif randomdir == 4 then
			arena.ball.body:setLinearVelocity(ballVx, ballVy)
			ball2.body:setLinearVelocity(ballV0*math.cos(math.pi/3)*(math.abs(ballVx)/ballVx), ballV0*math.sin(math.pi/3)*(math.abs(ballVy)/ballVy))
			ball3.body:setLinearVelocity(ballV0*math.cos(-math.pi/3)*(math.abs(ballVx)/ballVx), ballV0*math.sin(-math.pi/3)*(math.abs(ballVy)/ballVy))
		elseif randomdir == 5 then
			arena.ball.body:setLinearVelocity(ballV0*math.cos(math.pi/3)*(math.abs(ballVx)/ballVx), ballV0*math.sin(math.pi/3)*(math.abs(ballVy)/ballVy))
			ball2.body:setLinearVelocity(ballVx, ballVy)
			ball3.body:setLinearVelocity(ballV0*math.cos(-math.pi/3)*(math.abs(ballVx)/ballVx), ballV0*math.sin(-math.pi/3)*(math.abs(ballVy)/ballVy))
		else
			arena.ball.body:setLinearVelocity(ballV0*math.cos(math.pi/3)*(math.abs(ballVx)/ballVx), ballV0*math.sin(math.pi/3)*(math.abs(ballVy)/ballVy))
			ball2.body:setLinearVelocity(ballVx, ballVy)
			ball3.body:setLinearVelocity(ballV0*math.cos(-math.pi/3)*(math.abs(ballVx)/ballVx), ballV0*math.sin(-math.pi/3)*(math.abs(ballVy)/ballVy))
		end
		
		ball2.launched = true
		ball3.launched = true
		ball2.bitmap:setColorTransform(arena.ball.bitmap:getColorTransform())
		ball3.bitmap:setColorTransform(arena.ball.bitmap:getColorTransform())
		
		-- Sets AI Target ball to one of the balls --
		local randomnum = math.random(1, 3)
		if randomnum == 2 then
			arena.aiPlayer.AITarget = ball2
		elseif randomnum == 3 then
			arena.aiPlayer.AITarget = ball3
		end
		
		-- GFX --
		local star = Bitmap.new(textures.gfx_star)
		star:setScale(1, 1)
		star:setAnchorPoint(0.5, 0.5)
		arena:addChild(star)
		local textureW = star:getWidth()
		local textureH = star:getHeight()
		star:setAlpha(0.5)
		star:setPosition(ballX, ballY)
		scaleBitmapXY(star, 1000, 2*160/textureW, 2*152/textureH, 0, 0)		
		fadeBitmapOut(star, 1000, arena)
		
		-- Action to end skill --
		self.endAction = function()	
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == ball2 then
					if ball2.body ~= nil then
						world:destroyBody(ball2.body)
						ball2.body = nil
					end
					fadeBitmapOut(ball2, 500, arena)
				end
				if arena:getChildAt(i) == ball3 then
					if ball2.body ~= nil then
						world:destroyBody(ball3.body)
						ball3.body = nil
					end
					fadeBitmapOut(ball3, 500, arena)
				end
			end
			
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
		Timer.delayedCall(self.basetime/2,  function()
			self:endAction() 
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == star then
					fadeBitmapOut(star, 500, arena)
				end
				if arena:getChildAt(i) == ball2 then
					if ball2.body ~= nil then
						world:destroyBody(ball2.body)
						ball2.body = nil
					end
					fadeBitmapOut(ball2, 200, arena)
				end
				if arena:getChildAt(i) == ball3 then
					if ball2.body ~= nil then
						world:destroyBody(ball3.body)
						ball3.body = nil
					end
					fadeBitmapOut(ball3, 200, arena)
				end
			end
		end
	end
	
	
-------------------------------------------------
-- Freeze: Freezes your opponent for some time --
-------------------------------------------------
	if self.skill == "freeze" then
		if optionsTable["SFX"] == "On" then sounds.ice:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Freezes opponent --
		if side == 0 then
			arena.rightPlayer.char.movFactor = 0
		else
			arena.leftPlayer.char.movFactor = 0
		end
		
		-- GFX --
		local paddleX, paddleY = 0
		local paddleH, paddleW = 0
		if side == 0 then
			paddleX, paddleY = arena.rightPlayer.paddle.body:getPosition()
			paddleH = arena.rightPlayer.paddle.paddleH
			paddleW = arena.rightPlayer.paddle.paddleW
		else
			paddleX, paddleY = arena.leftPlayer.paddle.body:getPosition()
			paddleH = arena.leftPlayer.paddle.paddleH
			paddleW = arena.leftPlayer.paddle.paddleW
		end
		local ice = Bitmap.new(textures.gfx_freeze)
		ice:setScale(1, 1)
		ice:setAnchorPoint(0.5, 0.5)
		arena:addChild(ice)
		local textureW = ice:getWidth()
		local textureH = ice:getHeight()
		ice:setScale((paddleW*2)/textureW, (paddleH*1.3333333333333)/textureH)
		ice:setPosition(paddleX, paddleY)
		fadeBitmapIn(ice, 500, 0.75)
		
		
		-- Action to end skill --
		self.endAction = function()
			fadeBitmapOut(ice, 1000, arena)

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
		Timer.delayedCall(self.basetime/2,  function()
			self:endAction() 
			if optionsTable["SFX"] == "On" then sounds.ice_break:play() end
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == ice then
					fadeBitmapOut(ice, 1000, arena)
				end
			end
		end
	end


---------------------------------------
-- Predict: Predicts ball trajectory --
---------------------------------------
	if self.skill == "predict" then
		if optionsTable["SFX"] == "On" then sounds.alarm:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Gets positions and velocities --
		local ballX, ballY = arena.ball.body:getPosition()
		local padX, padY = 0
		local paddleH, paddleW = 0
		local correctAIY = 0
		
		local ballVx, ballVy = arena.ball.body:getLinearVelocity()
		if ballVx < 0 then
			padX, padY = arena.leftPlayer.paddle.body:getPosition()
			paddleH = arena.leftPlayer.paddle.paddleH
			paddleW = arena.leftPlayer.paddle.paddleW
			correctAIY = arena.leftPlayer.correctAIY
		else
			padX, padY = arena.rightPlayer.paddle.body:getPosition()
			paddleH = arena.rightPlayer.paddle.paddleH
			paddleW = arena.rightPlayer.paddle.paddleW
			correctAIY = arena.rightPlayer.correctAIY
		end
		
		local ballDist = math.sqrt(math.pow(padX - ballX, 2) + math.pow(padY - ballY, 2))
		local ballVx0 = ballVx
		local ballVy0 = ballVy
		local ballV0 = math.sqrt(ballVx*ballVx + ballVy*ballVy)
		if ballVy == 0 then
			ballVy = 0.001
		end
		ballVx = ballVx*PhysicsScale
		ballVy = ballVy*PhysicsScale
		
		-- Prediction Initialization, any values --
		local predictX = XShift + WX/2
		local predictY = 0
		local dy = 0
		local maxdelta = WY - paddleH/2 - WBounds
		
		-- Predict Y coordinate of ball when it pass over the paddle line, if ball is moving towards paddle --
		if ballVx < 0  then
			
			-- Calculates ball X position when it hits a boundary, until X means it is behind a paddle --
			while predictX > (padX + paddleW/2 + arena.ball.radius) do
				if ballVy > 0 then
					dy = WY - WBounds - ballY - arena.ball.radius
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
				predictY = correctAIY + math.abs(ballVy)*(padX + paddleW/2 + arena.ball.radius - ballX)/math.abs(ballVx)
			else
				predictY = -correctAIY + WY - math.abs(ballVy)*(padX + paddleW/2 + arena.ball.radius - ballX)/math.abs(ballVx)
			end

		-- Same thing, to the other side --
		else
			while predictX < (padX - paddleW/2 - arena.ball.radius) do
				if ballVy > 0 then
					dy = WY - WBounds - ballY - arena.ball.radius
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
				predictY = correctAIY + math.abs(ballVy)*(ballX - padX + paddleW/2 + arena.ball.radius)/math.abs(ballVx)
			else
				predictY = -correctAIY + WY - math.abs(ballVy)*(ballX - padX + paddleW/2 + arena.ball.radius)/math.abs(ballVx)
			end
		end
		
		-- Set paddle movement towards target --
		if side == 0 then
			arena.leftPlayer.touchY = predictY
		else
			arena.rightPlayer.touchY = predictY
		end
		
		-- GFX --
		local target = Bitmap.new(textures.gfx_target)
		target:setScale(1, 1)
		target:setAnchorPoint(0.5, 0.5)
		arena:addChild(target)
		local textureW = target:getWidth()
		local textureH = target:getHeight()
		target:setScale(124/textureW, 124/textureH)
		target:setPosition(padX, predictY)
		fadeBitmapIn(target, 1000, 0.75)
		
		-- Sets AI Intelligent --
		arena.aiPlayer.char.intFactor = 0
		arena.aiPlayer:aiRandomFactor()
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime/4,  function()
			self:endAction() 
		end)
		
		self.endAction = function()
			fadeBitmapOut(target, 500, arena)
			arena.aiPlayer.char:updateAttr()
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
		
		-- Action to force end --
		self.forceEnd = function()
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == target then
					fadeBitmapOut(target, 100, arena)
				end
			end
		end
	end	
	

---------------------------------------------------
-- Fireball: Hurls a fireball that does 1 damage --
---------------------------------------------------
	if self.skill == "fireball" then
		if optionsTable["SFX"] == "On" then sounds.fire:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Get Values --
		local padX, padY = 0
		if side == 0 then
			padX, padY = arena.leftPlayer.paddle.body:getPosition()
		else
			padX, padY = arena.rightPlayer.paddle.body:getPosition()
		end
		
		-- GFX, Body --
		local fireball = Bitmap.new(textures.gfx_fireball)
		fireball:setScale(1, 1)
		fireball:setAnchorPoint(0.5, 0.5)
		local textureW = fireball:getWidth()
		local textureH = fireball:getHeight()
		fireball:setScale(70/textureW, 30/textureH)
		fireball:setPosition(padX, padY)
		fadeBitmapIn(fireball, 500, 0.75)
		
		fireball.body = world:createBody{
			type = b2.DYNAMIC_BODY,
			position = {x = padX + 20, y = padY},
			bullet = true
		}
		fireball.body.name = "fireball"
		fireball.body.del = false
		local shape = b2.CircleShape.new(20, 0, 15)
		fireball.fixture = fireball.body:createFixture{
			shape = shape,
			density = 1,
			restitution = 1, 
			friction = 0,
		}
		fireball.fixture:setFilterData({categoryBits = 1, maskBits = 15, groupIndex = 0})
		
		fireball.body:setLinearVelocity(arena.ball.baseSpeed0 - 2*side*arena.ball.baseSpeed0, 0)
		fireball.body:setAngle(math.pi*side)
		
		arena:addChild(fireball)
		
		-- Sets timer to check if passed goal line --
			local function onTimer(timer)
				local ballX = fireball.body:getPosition()
				if side == 0 and ballX > WX + XShift + 2*arena.ball.radius then
					if optionsTable["SFX"] == "On" then sounds.explosion:play() end
					arena.score1 = arena.score1 - 1
					arena.combatStats:update(arena.score0, arena.score1, arena.mp0, arena.mp1)
					timer:removeEventListener(Event.TIMER, onTimer)
					timer:stop()
					arena.leftPlayer.char.skill:endAction()
				elseif side == 1 and ballX <  -2*arena.ball.radius + XShift then
					if optionsTable["SFX"] == "On" then sounds.explosion:play() end
					arena.score0 = arena.score0 - 1
					arena.combatStats:update(arena.score0, arena.score1, arena.mp0, arena.mp1)
					timer:removeEventListener(Event.TIMER, onTimer)
					timer:stop()
					arena.rightPlayer.char.skill:endAction()
				end
			end
			local timer = Timer.new(33, 0)
			timer:addEventListener(Event.TIMER, onTimer, timer)
			timer:start()
		
		-- Action to end Skill --
		self.endAction = function()
			timer:removeEventListener(Event.TIMER, onTimer)
			timer:stop()
			fadeBitmapOut(fireball, 500, fireball)
			if fireball.body ~= nil then
				fireball.body.del = true
			end
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
		
		-- Collision handler, if collide, remove fireball --
		function fireball.body:collide(event)
			local body1 = event.fixtureA:getBody()
			local body2 = event.fixtureB:getBody()
			if body1.name ~= "paddle"..side and body2.name ~= "paddle"..side then
				if optionsTable["SFX"] == "On" then sounds.fireout:play() end
				Timer.delayedCall(0, function()
					fireball.body:setLinearVelocity(0,0)
					timer:removeEventListener(Event.TIMER, onTimer)
					timer:stop()
					if side == 0 then
						arena.leftPlayer.char.skill:endAction()
					else
						arena.rightPlayer.char.skill:endAction()
					end
				end)
			end
		end
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime,  function()
			--self:endAction() 
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			for i = arena:getNumChildren(), 1, -1 do
				timer:removeEventListener(Event.TIMER, onTimer)
				timer:stop()
				if arena:getChildAt(i) == fireball then
					fadeBitmapOut(fireball, 100, fireball)
					if fireball.body ~= nil then
						fireball.body.del = true
					end
				end
			end
		end
	end


-------------------------------------------
-- Bite: Next enemy skill gives you 1 HP --
-------------------------------------------
	if self.skill == "bite" then
		if optionsTable["SFX"] == "On" then sounds.bite:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- GFX --
		local bite = Bitmap.new(textures.gfx_bite)
		bite:setScale(1, 1)
		bite:setAnchorPoint(0.5, 0.5)
		local textureW = bite:getWidth()
		local textureH = bite:getHeight()
		bite:setScale(30/textureW, 120/textureH)

		local paddleX, paddleY = 0
		
		if side == 0 then
			paddleX, paddleY = arena.rightPlayer.paddle.body:getPosition()
			arena.rightPlayer.paddle:addChild(bite)
			fadeBitmapIn(bite, 500, 0.5)
			Timer.delayedCall(500, function()
				fadeBitmapOut(bite, 500, arena.rightPlayer.paddle)
			end)
		else
			paddleX, paddleY = arena.leftPlayer.paddle.body:getPosition()
			arena.leftPlayer.paddle:addChild(bite)
			fadeBitmapIn(bite, 500, 0.5)
			Timer.delayedCall(500, function()
				fadeBitmapOut(bite, 500, arena.leftPlayer.paddle)
			end)
		end
		
		-- Sets timer to check if skill is used --
			local mpInit = 0
			if side == 0 then
				mpInit = arena.mp1
			else
				mpInit = arena.mp0
			end
			local function onTimer(timer)
				if side == 0 then
					if arena.mp1 < mpInit then
						arena.score0 = arena.score0 + 1
						arena.combatStats:update(arena.score0, arena.score1, arena.mp0, arena.mp1)
						
						timer:removeEventListener(Event.TIMER, onTimer)
						timer:stop()
						arena.leftPlayer.char.skill:endAction()
					end
				else
					if arena.mp0 < mpInit then
						arena.score1 = arena.score1 + 1
						arena.combatStats:update(arena.score0, arena.score1, arena.mp0, arena.mp1)
						
						timer:removeEventListener(Event.TIMER, onTimer)
						timer:stop()
						arena.rightPlayer.char.skill:endAction()
					end
				end
			end
			local timer = Timer.new(33, 0)
			timer:addEventListener(Event.TIMER, onTimer, timer)
			timer:start()
		
		-- Action to end Skill --
		self.endAction = function()
			timer:removeEventListener(Event.TIMER, onTimer)
			timer:stop()
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
		Timer.delayedCall(self.basetime,  function()
			--self:endAction() 
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			timer:removeEventListener(Event.TIMER, onTimer)
			timer:stop()
			
			for i = arena.leftPlayer.paddle:getNumChildren(), 1, -1 do
				if arena.leftPlayer.paddle:getChildAt(i) == bite then
					fadeBitmapOut(bite, 100, arena.leftPlayer.paddle)
				end
			end
			for i = arena.rightPlayer.paddle:getNumChildren(), 1, -1 do
				if arena.rightPlayer.paddle:getChildAt(i) == bite then
					fadeBitmapOut(bite, 100, arena.rightPlayer.paddle)
				end
			end
		end
	end


-----------------------------------
-- Dispel: Cancels Enemy's skill --
-----------------------------------
	if self.skill == "dispel" then
		if optionsTable["SFX"] == "On" then sounds.dispel:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- End skill actions --
		if arena.humanPlayer.skillActive then
			arena.humanPlayer.char.skill:endAction()
		end
		if arena.aiPlayer.skillActive then
			arena.aiPlayer.char.skill:endAction()
		end
		arena.humanPlayer.char.skill:forceEnd()
		arena.aiPlayer.char.skill:forceEnd()
		
		-- End Arena Active Effects --
		arena.endArena()
		
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
		
		-- Action to force end --
		self.forceEnd = function()
			
		end
	end
	
	
-----------------------------------------------
-- Headshrink: Decreases Enemy's paddle size --
-----------------------------------------------
	if self.skill == "headshrink" then
		if optionsTable["SFX"] == "On" then sounds.powerup2over:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Decrease paddle size --
		if side == 0 then
			local defFactor = arena.rightPlayer.paddle.defFactor*0.5
			
			arena.rightPlayer.paddle.defFactor = defFactor
			
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
		else
			local defFactor = arena.leftPlayer.paddle.defFactor*0.5

			arena.leftPlayer.paddle.defFactor = defFactor
			
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
		end
		
		-- Action to end Skill --
		self.endAction = function()
			if side == 0 then
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
				arena.leftPlayer.skillActive = false
				
				local defFactor2 = 0.21 + (arena.rightPlayer.char.def)/11 -- 0.3 to 3
				arena.rightPlayer.paddle.defFactor = defFactor2
				
				local shape2 = b2.PolygonShape.new()
				arena.rightPlayer.paddle.paddleH = arena.rightPlayer.paddle.basepaddleH*defFactor2
				arena.rightPlayer.paddle.body.paddleH = arena.rightPlayer.paddle.paddleH
				shape2:setAsBox(arena.rightPlayer.paddle.paddleW/2, arena.rightPlayer.paddle.paddleH/2, 0, 0, 0)
				arena.rightPlayer.paddle.body:destroyFixture(arena.rightPlayer.paddle.fixture)
				arena.rightPlayer.paddle.shape = shape2
				arena.rightPlayer.paddle.fixture = arena.rightPlayer.paddle.body:createFixture{
					shape = shape2, 
					density = 10000,
					restitution = 0, 
					friction = 0,
					fixedRotation = true,
				}
				arena.rightPlayer.paddle.fixture:setFilterData({categoryBits = 2, maskBits = 5, groupIndex = 0})
				arena.rightPlayer.paddle.body:setAngle(arena.rightPlayer.paddle.side*math.pi)
				arena.rightPlayer.paddle.bitmap:setScale(arena.rightPlayer.paddle.paddleW/arena.rightPlayer.paddle.textureW, arena.rightPlayer.paddle.paddleH/arena.rightPlayer.paddle.textureH)
				arena.rightPlayer.paddle:setRotation(arena.rightPlayer.paddle.side*180)
			else
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
				arena.rightPlayer.skillActive = false
				
				local defFactor = 0.21 + (arena.leftPlayer.char.def)/11 -- 0.3 to 3
				arena.leftPlayer.paddle.defFactor = defFactor
	
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
			end
		end
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime,  function()
			--self:endAction() 
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			
		end
	end
	
	
-----------------------------------------------------------
-- Charge : Ball goes to random direction after charging --
-----------------------------------------------------------
	if self.skill == "charge" then
		if optionsTable["SFX"] == "On" then sounds.spark:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Stop ball --
		local ballVx0, ballVy0 = arena.ball.body:getLinearVelocity()
		local ballV = math.sqrt(math.pow(ballVx0, 2) + math.pow(ballVy0, 2))
		arena.ball.body:setLinearVelocity(0, 0)
		arena.pauseArena()
		
		-- GFX --
		local spark = Bitmap.new(textures.gfx_spark)
		spark:setScale(1, 1)
		spark:setAnchorPoint(0.5, 0.5)
		local textureW = spark:getWidth()
		local textureH = spark:getHeight()
		spark:setScale(2*arena.ball.radius/textureW, 2*arena.ball.radius/textureH)

		local ballX, ballY = arena.ball.body:getPosition()
		arena.ball:addChild(spark)
		fadeBitmapIn(spark, self.basetime/4, 1)
		Timer.delayedCall(100 + self.basetime/3, function()
			fadeBitmapOut(spark, self.basetime/4, arena.ball)
		end)
		
		-- Wait, then launch ball --
		Timer.delayedCall(self.basetime/3,  function()
			if ballV ~= 0 then
				local randomvx = math.random(0, 2000*ballV)/1000
				if ballVx0 < 0 then
					randomvx = -randomvx
				end
				local newVy = math.sqrt(math.pow((2*ballV), 2) - math.pow(randomvx, 2))
				local randsign = math.random(0, 1)
				if randsign == 0 then
					newVy = -newVy
				end
				arena.ball.body:setLinearVelocity(randomvx, newVy)
			else
				arena.ball:launch()
			end
			arena.unpauseArena()
		end)
		
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
		Timer.delayedCall(self.basetime/3,  function()
			self:endAction() 
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			for i = arena.ball:getNumChildren(), 1, -1 do
				if arena.ball:getChildAt(i) == spark then
					fadeBitmapOut(spark, 100, arena.ball)
				end
			end
		end
	end	
	
	
---------------------------------------
-- Bet: Next goal does double damage --
---------------------------------------
	if self.skill == "bet" then
		if optionsTable["SFX"] == "On" then sounds.dice:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- GFX --
		local chip = Bitmap.new(textures.gfx_chip)
		chip:setScale(1, 1)
		chip:setAnchorPoint(0.5, 0.5)
		local textureW = chip:getWidth()
		local textureH = chip:getHeight()
		chip:setScale(2*arena.ball.radius/textureW, 2*arena.ball.radius/textureH)

		local ballX, ballY = arena.ball.body:getPosition()
		arena.ball:addChild(chip)
		fadeBitmapIn(chip, 500, 0.8)
		
		-- Deals damage a bit before standard goal check --
		local function checkAlmostGoal()
			local ballX, ballY = arena.ball.body:getPosition()
			
			if ballX > XShift + WX then
				arena.score1 = arena.score1 - 1
				self:endAction()
			elseif ballX <  XShift then
				arena.score0 = arena.score0 - 1
				self:endAction()
			end
		end
			
		arena:addEventListener(Event.ENTER_FRAME, checkAlmostGoal)
		
		-- Action to end Skill --
		self.endAction = function()
			arena:removeEventListener(Event.ENTER_FRAME, checkAlmostGoal)
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
		Timer.delayedCall(self.basetime,  function()
			--self:endAction() 
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			for i = arena.ball:getNumChildren(), 1, -1 do
				if arena.ball:getChildAt(i) == chip then
					arena.ball:removeChildAt(i)
				end
			end
		end
	end
	
	
---------------------------------------------------
-- Reverse Time: Ball goes a little back in time --
---------------------------------------------------
	if self.skill == "reversetime" then
		local clocksound = nil
		if optionsTable["SFX"] == "On" then clocksound = sounds.clock:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Revert ball speed --
		local ballVx0, ballVy0 = arena.ball.body:getLinearVelocity()
		arena.ball.body:setLinearVelocity(-ballVx0, -ballVy0)
		
		-- Action to end Skill --
		self.endAction = function()
			if optionsTable["SFX"] == "On" then clocksound:stop() end
			local ballVx, ballVy = arena.ball.body:getLinearVelocity()
			arena.ball.body:setLinearVelocity(-ballVx, -ballVy)
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
		Timer.delayedCall(self.basetime/5,  function()
			self:endAction() 
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			
		end
	end
	
	
----------------------------------------------
-- Poison: Next enemy skill causes 1 damage --
----------------------------------------------
	if self.skill == "poison" then
		if optionsTable["SFX"] == "On" then sounds.bite:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- GFX --
		local bite = Bitmap.new(textures.gfx_bite2)
		bite:setScale(1, 1)
		bite:setAnchorPoint(0.5, 0.5)
		local textureW = bite:getWidth()
		local textureH = bite:getHeight()
		bite:setScale(30/textureW, 120/textureH)

		local paddleX, paddleY = 0
		
		if side == 0 then
			paddleX, paddleY = arena.rightPlayer.paddle.body:getPosition()
			arena.rightPlayer.paddle:addChild(bite)
			fadeBitmapIn(bite, 500, 0.5)
			Timer.delayedCall(500, function()
				fadeBitmapOut(bite, 500, arena.rightPlayer.paddle)
			end)
		else
			paddleX, paddleY = arena.leftPlayer.paddle.body:getPosition()
			arena.leftPlayer.paddle:addChild(bite)
			fadeBitmapIn(bite, 500, 0.5)
			Timer.delayedCall(500, function()
				fadeBitmapOut(bite, 500, arena.leftPlayer.paddle)
			end)
		end
		
		-- Sets timer to check if skill is used --
			local mpInit = 0
			if side == 0 then
				mpInit = arena.mp1
			else
				mpInit = arena.mp0
			end
			local function onTimer(timer)
				if side == 0 then
					if arena.mp1 < mpInit then
						arena.score1 = arena.score1 - 1
						arena.combatStats:update(arena.score0, arena.score1, arena.mp0, arena.mp1)
						
						timer:removeEventListener(Event.TIMER, onTimer)
						timer:stop()
						arena.leftPlayer.char.skill:endAction()
					end
				else
					if arena.mp0 < mpInit then
						arena.score0 = arena.score0 - 1
						arena.combatStats:update(arena.score0, arena.score1, arena.mp0, arena.mp1)
						
						timer:removeEventListener(Event.TIMER, onTimer)
						timer:stop()
						arena.rightPlayer.char.skill:endAction()
					end
				end
			end
			local timer = Timer.new(33, 0)
			timer:addEventListener(Event.TIMER, onTimer, timer)
			timer:start()
		
		-- Action to end Skill --
		self.endAction = function()
			timer:removeEventListener(Event.TIMER, onTimer)
			timer:stop()
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
		Timer.delayedCall(self.basetime,  function()
			--self:endAction() 
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			timer:removeEventListener(Event.TIMER, onTimer)
			timer:stop()
			
			for i = arena.leftPlayer.paddle:getNumChildren(), 1, -1 do
				if arena.leftPlayer.paddle:getChildAt(i) == bite then
					fadeBitmapOut(bite, 100, arena.leftPlayer.paddle)
				end
			end
			for i = arena.rightPlayer.paddle:getNumChildren(), 1, -1 do
				if arena.rightPlayer.paddle:getChildAt(i) == bite then
					fadeBitmapOut(bite, 100, arena.rightPlayer.paddle)
				end
			end
		end
	end
	
	
-------------------------------------------------
-- Shine: Obfuscates everyone for a short time --
-------------------------------------------------
	if self.skill == "shine" then
		if optionsTable["SFX"] == "On" then sounds.harp:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Sets AI intelligence low --
		arena.aiPlayer.char.intFactor = 7
		arena.aiPlayer:aiRandomFactor()
		
		-- GFX --
		local white = Bitmap.new(textures.white)
		white:setScale(1, 1)
		white:setAnchorPoint(0.5, 0.5)
		arena:addChild(white)
		local textureW = white:getWidth()
		local textureH = white:getHeight()
		white:setScale(WX/textureW, WY/textureH)
		white:setPosition(WX/2 + XShift, WY/2)
		white:setAlpha(0)
		fadeBitmapIn(white, 300, 1)
		
		
		-- Action to end skill --
		local finished = false
		self.endAction = function()
			finished = true
			arena.aiPlayer.char:updateAttr()
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == white then
					fadeBitmapOut(white, self.basetime/6, arena)
				end
			end
			
			if side == 0 then
				ballCollideO0 = function(event)
				end
			else
				ballCollideO1 = function(event)
				end
			end

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
		
		-- End if ball hits enemy --
		local function endaction()
		end
		endaction = self.endAction
		if side == 0 then
			ballCollideO0 = function(event)
				local body1 = event.fixtureA:getBody()
				local body2 = event.fixtureB:getBody()
				if (((body1 == arena.rightPlayer.paddle.body or body2 == arena.rightPlayer.paddle.body) and side == 0)
				or ((body1 == arena.leftPlayer.paddle.body or body2 == arena.leftPlayer.paddle.body) and side == 1)) then
					endaction()
				end
			end
		else
			ballCollideO1 = function(event)
				local body1 = event.fixtureA:getBody()
				local body2 = event.fixtureB:getBody()
				if (((body1 == arena.rightPlayer.paddle.body or body2 == arena.rightPlayer.paddle.body) and side == 0)
				or ((body1 == arena.leftPlayer.paddle.body or body2 == arena.leftPlayer.paddle.body) and side == 1)) then
					endaction()
				end
			end
		end
		
		-- Sets timer to end skill --
		Timer.delayedCall((self.basetime/3),  function()
			if not finished then
				self:endAction()
			end
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == white then
					fadeBitmapOut(white, 100, arena)
				end
			end
		end
	end	
	

------------------------------
-- Charm: Attracts opponent --
------------------------------
	if self.skill == "charm" then
		if optionsTable["SFX"] == "On" then sounds.kiss:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- GFX --
		local heart = Bitmap.new(textures.gfx_heart)
		heart:setScale(1, 1)
		heart:setAnchorPoint(0.5, 0.5)
		arena:addChild(heart)
		local textureW = heart:getWidth()
		local textureH = heart:getHeight()
		heart:setAlpha(0.8)
		heart:setPosition(XShift + WX/2, WY/2)
		scaleBitmapXY(heart, 1000, 2*160/textureW, 2*152/textureH, 0, 0)		
		fadeBitmapOut(heart, 1000, arena)
		
		-- Attract --
		local padX0 = 0
		if (side == 0) then
			padX0 = arena.rightPlayer.paddle.body:getPosition()
			arena.rightPlayer.paddle.body:setLinearVelocity(-0.5*arena.ball.baseSpeed, 0)
		else
			padX0 = arena.leftPlayer.paddle.body:getPosition()
			arena.leftPlayer.paddle.body:setLinearVelocity(0.5*arena.ball.baseSpeed, 0)
		end
		Timer.delayedCall(self.basetime/5, function()
			if (side == 0) then
					arena.rightPlayer.paddle.body:setLinearVelocity(0.5*arena.ball.baseSpeed, 0)
					Timer.delayedCall(self.basetime/5,  function()
						arena.rightPlayer.paddle.body:setLinearVelocity(0, 0)
						local padX, padY = arena.rightPlayer.paddle.body:getPosition()
						arena.rightPlayer.paddle.body:setPosition(padX0, padY)
					end)
				else
					arena.leftPlayer.paddle.body:setLinearVelocity(-0.5*arena.ball.baseSpeed, 0)
					Timer.delayedCall(self.basetime/5,  function()
						arena.leftPlayer.paddle.body:setLinearVelocity(0, 0)
						local padX, padY = arena.leftPlayer.paddle.body:getPosition()
						arena.leftPlayer.paddle.body:setPosition(padX0, padY)
					end)
			end
		end)
		
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
		Timer.delayedCall(self.basetime/2.5,  function()
			self:endAction() 
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == heart then
					fadeBitmapOut(heart, 500, arena)
				end
			end
		end
	end


-------------------------------
-- Confuse: Reverse Controls --
-------------------------------
	if self.skill == "confuse" then
		if optionsTable["SFX"] == "On" then sounds.laugh:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- GFX --
		local laugh = Bitmap.new(textures.gfx_laugh)
		laugh:setScale(1, 1)
		laugh:setAnchorPoint(0.5, 0.5)
		arena:addChild(laugh)
		local textureW = laugh:getWidth()
		local textureH = laugh:getHeight()
		laugh:setAlpha(0.8)
		laugh:setPosition(XShift + WX/2, WY/2)
		scaleBitmapXY(laugh, 1000, 2*260/textureW, 2*160/textureH, 0, 0)		
		fadeBitmapOut(laugh, 1000, arena)
		
		-- Make move factor negative --
		if side == 0 then
			arena.rightPlayer.char.movFactor = -arena.rightPlayer.char.movFactor
		else
			arena.leftPlayer.char.movFactor = -arena.leftPlayer.char.movFactor
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
		Timer.delayedCall(self.basetime,  function()
			--self:endAction() 
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == laugh then
					fadeBitmapOut(laugh, 500, arena)
				end
			end
		end
	end


------------------------------------------------------
-- Web: Ball sticks to paddle, then returns faster --
------------------------------------------------------
	if self.skill == "web" then
		if optionsTable["SFX"] == "On" then sounds.spider:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Creates Web --
		local web = Bitmap.new(textures.paddle2)
		web:setColorTransform(1.5, 1.5, 1.5)
		web:setScale(1, 1)
		web:setAnchorPoint(0.5, 0.5)
		local textureW = web:getWidth()
		local textureH = web:getHeight()
		local paddleX, paddleY, paddleW, paddleH = nil
		if side == 0 then
			paddleX, paddleY = arena.leftPlayer.paddle:getPosition()
			paddleW = arena.leftPlayer.paddle:getWidth()
			paddleH = 1.1*arena.leftPlayer.paddle:getHeight()
		else
			paddleX, paddleY = arena.rightPlayer.paddle:getPosition()
			paddleW = arena.rightPlayer.paddle:getWidth()
			paddleH = 1.1*arena.rightPlayer.paddle:getHeight()
		end
		
		web:setScale(paddleW/(2*textureW), paddleH/textureH)
		web:setPosition(paddleX + (1 - side*2)*paddleW/2, paddleY)
		fadeBitmapIn(web, 300, 0.8)
		
		web.body = world:createBody{
			type = b2.DYNAMIC_BODY,
			position = {x = paddleX + (1 - side*2)*paddleW/2, y = paddleY},
			angularDamping = 10000,
			linearDamping = 0.5
		}
		web.body.name = "web"
		web.body.del = false
		web.shape = b2.PolygonShape.new()
		web.shape:setAsBox(paddleW/4, paddleH/2, 0, 0, 0)
		web.fixture = web.body:createFixture{
			shape = web.shape, 
			density = 10000,
			restitution = 0, 
			friction = 0,
			fixedRotation = true,
		}
		web.fixture:setFilterData({categoryBits = 2, maskBits = 1, groupIndex = 0})
		web.body:setAngle(side*math.pi)
		
		arena:addChild(web)
		
		-- AI moves towards player position --
		arena.aiPlayer.Follow = true
		
		-- Disable paddle collision handler --
		local function tempcolhandler(event)
		end
		if side == 0 then
			tempcolhandler = arena.leftPlayer.paddle.body.collide
			arena.leftPlayer.paddle.body.collide = function()
			end
		else
			tempcolhandler = arena.rightPlayer.paddle.body.collide
			arena.rightPlayer.paddle.body.collide = function()
			end
		end
		
		local launching = false
		-- Web moves with paddle --
		local function moveweb()
			if launching then
				self:endAction()
				for i = arena:getNumChildren(), 1, -1 do
					if arena:getChildAt(i) == web then
						fadeBitmapOut(web, 100, arena)
						if web.body ~= nil then
							web.body.del = true
						end
					end
				end
			else
				local padX, padY = nil
				if side == 0 then
					padX, padY = arena.leftPlayer.paddle:getPosition()
				else
					padX, padY = arena.rightPlayer.paddle:getPosition()
				end
				web.body:setPosition(paddleX + (1 - side*2)*paddleW/2, padY)
			end
		end
		arena:addEventListener(Event.ENTER_FRAME, moveweb)
		
		-- Stop ball if it hits web --
		local function moveball()
		end
		local collided = false
		local basetime = self.basetime
		function web.body:collide(event)
			if not collided then
				collided = true
				arena.pauseArena()
				arena.ball.body:setLinearVelocity(0, 0)
				local ballX0, ballY0 = arena.ball.body:getPosition()
				local padX, padY = web.body:getPosition()
				local dBallY = ballY0 - padY
				
				moveball = function()
					local webX, webY = web.body:getPosition()
					local newY = webY + dBallY
					if newY > WY - WBounds - arena.ball.radius - 1 then
						newY = WY - WBounds - arena.ball.radius - 1
					end
					if newY < WBounds + arena.ball.radius + 1 then
						newY = WBounds + arena.ball.radius + 1
					end
					arena.ball.body:setPosition(ballX0, newY)
				end
				arena:addEventListener(Event.ENTER_FRAME, moveball)
				
				-- Timer to launch ball --
				Timer.delayedCall(basetime/3, function()
					arena.unpauseArena()
					arena:removeEventListener(Event.ENTER_FRAME, moveball)
					launching = true
					local setSpeed = nil
					if side == 0 then
						setSpeed = arena.ball.baseSpeed*arena.leftPlayer.char.atkFactor*2
					else
						setSpeed = -arena.ball.baseSpeed*arena.leftPlayer.char.atkFactor*2
					end	
					arena.ball.body:setLinearVelocity(setSpeed, 0)
				end)
			end
		end		
				
		-- Action to end Skill --
		self.endAction = function()
			arena:removeEventListener(Event.ENTER_FRAME, moveweb)
			arena:removeEventListener(Event.ENTER_FRAME, moveball)
			arena.aiPlayer.Follow = false
			if side == 0 then
				arena.leftPlayer.paddle.body.collide = tempcolhandler
			else
				arena.rightPlayer.paddle.body.collide = tempcolhandler
			end
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == web then
					fadeBitmapOut(web, 100, arena)
					if web.body ~= nil then
						web.body.del = true
					end
				end
			end
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
		Timer.delayedCall(self.basetime/3,  function()
			--self:endAction() 
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == web then
					fadeBitmapOut(web, 100, arena)
					if web.body ~= nil then
						web.body.del = true
					end
				end
			end
		end
	end	


------------------------------------------------
-- Portal: Ball teleports when hitting paddle --
------------------------------------------------
	if self.skill == "portal" then
		if optionsTable["SFX"] == "On" then sounds.portal:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Gets velocity and position--
		local ballVx0, ballVy0 = arena.ball.body:getLinearVelocity()
		local ballX, ballY = arena.ball.body:getPosition()
		
		-- GFX --
		local paddleX0, paddleY0 = nil
		if side == 0 then
			paddleX0, paddleY0 = arena.leftPlayer.paddle.body:getPosition()
		else
			paddleX0, paddleY0 = arena.rightPlayer.paddle.body:getPosition()
		end
		local portal = Bitmap.new(textures.paddle2)
		portal:setColorTransform(0.3, 0.45, 1)
		portal:setScale(1, 1)
		portal:setAnchorPoint(0.5, 0.5)
		arena:addChild(portal)
		local textureW = portal:getWidth()
		local textureH = portal:getHeight()
		portal:setScale(15/textureW, 75/textureH)
		portal:setPosition(XShift + WX/2, paddleY0)
		portal:setRotation(side*180)
		fadeBitmapIn(portal, 300, 1)
		
		-- Teleports --
		local function checkteleport()
			local ballVx0, ballVy0 = arena.ball.body:getLinearVelocity()
			local ballX, ballY = arena.ball.body:getPosition()
			local paddleX, paddleY = nil
			if side == 0 then
				paddleX, paddleY = arena.leftPlayer.paddle.body:getPosition()
			else
				paddleX, paddleY = arena.rightPlayer.paddle.body:getPosition()
			end

			if side == 0 and ballX <= paddleX + arena.ball.radius*3 and ballY > (paddleY - arena.leftPlayer.paddle.paddleH/2 - 1.2*arena.ball.radius) 
			and ballY < (paddleY + arena.leftPlayer.paddle.paddleH/2 + 1.2*arena.ball.radius) then
				if optionsTable["SFX"] == "On" then sounds.portal2:play() end
				arena.ball.body:setPosition(XShift + WX/2, paddleY0)
				arena.ball.body:setLinearVelocity(-ballVx0, -ballVy0)
				self:endAction()
			end
			if side == 1 and ballX >= paddleX - arena.ball.radius*3 and ballY > (paddleY - arena.rightPlayer.paddle.paddleH/2 - 1.2*arena.ball.radius) 
			and ballY < (paddleY + arena.rightPlayer.paddle.paddleH/2 + 1.2*arena.ball.radius) then
				if optionsTable["SFX"] == "On" then sounds.portal2:play() end
				arena.ball.body:setPosition(XShift + WX/2, paddleY0)
				arena.ball.body:setLinearVelocity(-ballVx0, -ballVy0)
				self:endAction()
			end
		end
		arena:addEventListener(Event.ENTER_FRAME, checkteleport)
		
		-- Action to end Skill --
		self.endAction = function()	
			arena:removeEventListener(Event.ENTER_FRAME, checkteleport)
			Timer.delayedCall(300, function()
				for i = arena:getNumChildren(), 1, -1 do
					if arena:getChildAt(i) == portal then
						fadeBitmapOut(portal, 250, arena)
					end
				end
			end)
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
		Timer.delayedCall(self.basetime,  function()
			--self:endAction()
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == portal then
					fadeBitmapOut(portal, 100, arena)
				end
			end
		end
	end


-------------------------------------------------------------
-- Telekinesis: Ball sticks to paddle, then returns faster -- DISABLED FOR NOW!
-------------------------------------------------------------
	if self.skill == "telekinesis" then
--		if optionsTable["SFX"] == "On" then sounds.tractorbeam:play() end
--		
--		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
--			arena.skillBut:setAlpha(0.1)
--		end
--		
--		-- Ball moves with paddle --
--		local ballVx = arena.ball.body:getLinearVelocity()
--		local thistime = math.abs(1000*WX/(ballVx*20))
--		local function moveball()
--			ballVx = arena.ball.body:getLinearVelocity()
--			local paddleVx, paddleVy = nil
--			if side == 0 then
--				paddleVx, paddleVy = arena.leftPlayer.paddle.body:getLinearVelocity()
--			end
--			if side == 1 then
--				paddleVx, paddleVy = arena.rightPlayer.paddle.body:getLinearVelocity()
--			end
--			arena.ball.body:setLinearVelocity(ballVx, paddleVy)
--		end
--		arena:addEventListener(Event.ENTER_FRAME, moveball)
--				
--		-- Action to end Skill --
--		self.endAction = function()
--			arena:removeEventListener(Event.ENTER_FRAME, moveball)
--			if side == 0 then
--				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
--					arena.skillBut:setAlpha(0.4)
--				end
--				arena.leftPlayer.skillActive = false
--			else
--				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
--					arena.skillBut:setAlpha(0.4)
--				end
--				arena.rightPlayer.skillActive = false
--			end
--		end
--		
--		-- Sets timer to end skill --
--		Timer.delayedCall(thistime,  function()
--			self:endAction() 
--		end)
--		
--		-- Action to force end --
--		self.forceEnd = function()
--			
--		end
	end	


---------------------------------------------------------------
-- Crystal Wall: Creates a solid wall that blocks everything --
---------------------------------------------------------------
	if self.skill == "crystalwall" then
		if optionsTable["SFX"] == "On" then sounds.ice:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Creates Wall --
		local wall = Bitmap.new(textures.gfx_crystal)
		--wall:setColorTransform(1, 1, 1)
		wall:setScale(1, 1)
		wall:setAnchorPoint(0.5, 0.5)
		local textureW = wall:getWidth()
		local textureH = wall:getHeight()
		local posX = 0
		if side == 0 then
			posX = XShift + WX/3
		else
			posX = XShift + WX - WX/3
		end
		wall:setScale(15/textureW, WY/textureH)
		wall:setPosition(posX, WY/2)
		fadeBitmapIn(wall, 500, 0.8)
		
		wall.body = world:createBody{
			type = b2.DYNAMIC_BODY,
			position = {x = posX, y = WY/2},
			angularDamping = 10000,
			linearDamping = 0.5
		}
		wall.body.name = "wall"
		wall.body.del = false
		wall.shape = b2.PolygonShape.new()
		wall.shape:setAsBox(15/2, WY/2, 0, 0, 0)
		wall.fixture = wall.body:createFixture{
			shape = wall.shape, 
			density = 10000,
			restitution = 1.5, 
			friction = 0,
			fixedRotation = true,
		}
		wall.fixture:setFilterData({categoryBits = 2, maskBits = 9, groupIndex = 0})
		wall.body:setAngle(side*math.pi)
		
		arena:addChild(wall)
		
		-- Action to end Skill --
		self.endAction = function()			
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == wall then
					fadeBitmapOut(wall, 500, arena)
					if wall.body ~= nil then
						wall.body.del = true
					end
				end
			end
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
		
		-- Collision handler --
		local wallhp = 3
		local function endaction()
		end
		endaction = self.endAction
		function wall.body:collide(event)
			wallhp = wallhp - 1
			if wallhp > 0 then
				if optionsTable["SFX"] == "On" then sounds.glass_ping:play() end
				
			else
				if optionsTable["SFX"] == "On" then sounds.ice_break:play() end
				endaction()
			end
		end	
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime,  function()
			--self:endAction() 
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == wall then
					fadeBitmapOut(wall, 100, arena)
					if wall.body ~= nil then
						wall.body.del = true
					end
				end
			end
		end
	end	


-----------------------------------
-- Earthquake: Shake everything! --
-----------------------------------
	if self.skill == "earthquake" then
		local quakesound = nil
		if optionsTable["SFX"] == "On" then quakesound = sounds.earthquake:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Shake! --
		local arenaX, arenaY = arena:getPosition()
		local function shake()
			arena:setPosition(arenaX + math.random(-50, 50), arenaY + math.random(-50, 50))
			arena.ball.body:applyLinearImpulse(math.random(-1,1), math.random(-1,1), 0, 0)
			arena.leftPlayer.paddle.body:applyLinearImpulse(0, math.random(-1,1), 0, 0)
			arena.rightPlayer.paddle.body:applyLinearImpulse(0, math.random(-1,1), 0, 0)
		end
		arena:addEventListener(Event.ENTER_FRAME, shake)		
		
		-- Sets AI intelligence bad --
		arena.aiPlayer.char.intFactor = 3
		arena.aiPlayer:aiRandomFactor()
		
		-- End Action --
		local finished = false
		self.endAction = function()
			finished = true
			quakesound:stop()
			arena:removeEventListener(Event.ENTER_FRAME, shake)
			if side == 0 then
				ballCollideO0 = function(event)
				end
			else
				ballCollideO1 = function(event)
				end
			end
			arena:setPosition(arenaX, arenaY)
			arena.aiPlayer.char:updateAttr()
			arena.aiPlayer:aiRandomFactor()
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
		
		-- End if ball hits enemy --
		local function endaction()
		end
		endaction = self.endAction
		if side == 0 then
			ballCollideO0 = function(event)
				local body1 = event.fixtureA:getBody()
				local body2 = event.fixtureB:getBody()
				if (((body1 == arena.rightPlayer.paddle.body or body2 == arena.rightPlayer.paddle.body) and side == 0)
				or ((body1 == arena.leftPlayer.paddle.body or body2 == arena.leftPlayer.paddle.body) and side == 1)) then
					endaction()
				end
			end
		else
			ballCollideO1 = function(event)
				local body1 = event.fixtureA:getBody()
				local body2 = event.fixtureB:getBody()
				if (((body1 == arena.rightPlayer.paddle.body or body2 == arena.rightPlayer.paddle.body) and side == 0)
				or ((body1 == arena.leftPlayer.paddle.body or body2 == arena.leftPlayer.paddle.body) and side == 1)) then
					endaction()
				end
			end
		end
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime/2,  function()
			if not finished then
				self:endAction()
			end 
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			
		end
	end	


----------------------------------------------------
-- Summon Imp: Summon a little paddle to help you --
----------------------------------------------------
	if self.skill == "summonimp" then
		if optionsTable["SFX"] == "On" then sounds.imp:play() end
		
		if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then
			arena.skillBut:setAlpha(0.1)
		end
		
		-- Creates Imp --
		local imp = Bitmap.new(textures.paddle2)
		imp:setColorTransform(0, 1, 0, 0.5)
		imp:setScale(1, 1)
		imp:setAnchorPoint(0.5, 0.5)
		local textureW = imp:getWidth()
		local textureH = imp:getHeight()
		local posX = 0
		if side == 0 then
			posX = XShift + WX/3
		else
			posX = XShift + WX - WX/3
		end
		imp:setScale(15/textureW, 0.3*75/textureH)
		imp:setPosition(posX, WY/2)
		fadeBitmapIn(imp, 300, 1)
		
		imp.body = world:createBody{
			type = b2.DYNAMIC_BODY,
			position = {x = posX, y = WY/2},
			angularDamping = 10000,
			linearDamping = 0.5
		}
		imp.body.name = "imp"
		imp.body.del = false
		imp.shape = b2.PolygonShape.new()
		imp.shape:setAsBox(15/2, 0.3*75/2, 0, 0, 0)
		imp.fixture = imp.body:createFixture{
			shape = imp.shape, 
			density = 10000,
			restitution = 0, 
			friction = 0,
			fixedRotation = true,
		}
		imp.fixture:setFilterData({categoryBits = 2, maskBits = 5, groupIndex = 0})
		imp.body:setAngle(side*math.pi)
		
		arena:addChild(imp)
		
		-- Moves Imp --
		local framecount = 0
		local function moveimp()
			framecount = framecount + 1
			local randomFactor = 0
			if framecount % 120 == 0 then
				randomFactor = (3.2 - 1*1)*1.1*math.random(-0.3*75/2, 0.3*75/2)/0.3
			end
			-- Gets positions and velocities --
			local ballX, ballY = arena.ball.body:getPosition()
			local padX, padY = imp.body:getPosition()
			local ballDist = math.sqrt(math.pow(padX - ballX, 2) + math.pow(padY - ballY, 2))
			local ballVx, ballVy = arena.ball.body:getLinearVelocity()
			local ballVx0 = ballVx
			local ballVy0 = ballVy
			local ballV0 = math.sqrt(ballVx*ballVx + ballVy*ballVy)
			if ballVy == 0 then
				ballVy = 0.001
			end
			ballVx = ballVx*PhysicsScale
			ballVy = ballVy*PhysicsScale
			local padVx, padVy = imp.body:getLinearVelocity()
			
			-- Prediction Initialization, any values --
			local predictX = XShift + WX/2
			local predictY = 0
			local dy = 0
			local maxdelta = WY - 0.3*75/2 - WBounds
			
			-- Predict Y coordinate of ball when it pass over the paddle line, if ball is moving towards paddle --
			if side == 0 and ballVx < 0  then
				
				-- Calculates ball X position when it hits a boundary, until X means it is behind a paddle --
				while predictX > (padX + 15/2 + arena.ball.radius) do
					if ballVy > 0 then
						dy = WY - WBounds - ballY - arena.ball.radius
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
					predictY = 12 + math.abs(ballVy)*(padX + 15/2 + arena.ball.radius - ballX)/math.abs(ballVx)
				else
					predictY = -12 + WY - math.abs(ballVy)*(padX + 15/2 + arena.ball.radius - ballX)/math.abs(ballVx)
				end
				
				-----------------------------------------------------------------------------------------------
				-- Applies velocity proportional to the difference between paddle Y position and prediction. --
				-- The random factor starts very big and gets smaller when ball approaches paddle            --
				-----------------------------------------------------------------------------------------------
				local deltaY = predictY - padY + (ballDist*math.abs(ballVy0/ballV0)/120)*randomFactor
				imp.body:setLinearVelocity(padVx, 1.5*(deltaY/maxdelta)*arena.ball.baseSpeedMov)

			-- Same thing, to the other side --
			elseif side == 1 and ballVx > 0 then
				while predictX < (padX - 15/2 - arena.ball.radius) do
					if ballVy > 0 then
						dy = WY - WBounds - ballY - arena.ball.radius
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
					predictY = 12 + math.abs(ballVy)*(ballX - padX + 15/2 + arena.ball.radius)/math.abs(ballVx)
				else
					predictY = -12 + WY - math.abs(ballVy)*(ballX - padX + 15/2 + arena.ball.radius)/math.abs(ballVx)
				end
				
				local deltaY = predictY - padY + (ballDist*math.abs(ballVy0/ballV0)/120)*randomFactor
				imp.body:setLinearVelocity(padVx, 1.5*(deltaY/maxdelta)*arena.ball.baseSpeedMov)
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
				imp.body:setLinearVelocity(padVx, 1.5*(deltaOp/maxdelta)*arena.ball.baseSpeedMov/2)
			end
		end
		
		arena:addEventListener(Event.ENTER_FRAME, moveimp)
		
		-- Action to end Skill --
		self.endAction = function()	
			arena:removeEventListener(Event.ENTER_FRAME, moveimp)
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == imp then
					fadeBitmapOut(imp, 300, arena)
					if imp.body ~= nil then
						imp.body.del = true
					end
				end
			end
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
		
		-- Collision handler --
		function imp.body:collide(event)
			
		end	
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime,  function()
			--self:endAction() 
		end)
		
		-- Action to force end --
		self.forceEnd = function()
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == imp then
					fadeBitmapOut(imp, 100, arena)
					if imp.body ~= nil then
						imp.body.del = true
					end
				end
			end
		end
	end	




end