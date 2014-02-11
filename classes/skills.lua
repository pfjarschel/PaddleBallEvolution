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
				arena.leftPlayer.paddle.bitmap:setColorTransform(classTable[arena.leftClass][10][1], classTable[arena.leftClass][10][2], classTable[arena.leftClass][10][3])
				arena.leftPlayer.skillActive = false
			else
				arena.rightPlayer.paddle.body.atkFactor = arena.rightPlayer.paddle.atkFactor
				if (side == 0 and optionsTable["ArenaSide"] == "Left") or (side == 1 and optionsTable["ArenaSide"] == "Right") then 
					arena.skillBut:setAlpha(0.4)
				end
				arena.rightPlayer.paddle.bitmap:setColorTransform(classTable[arena.rightClass][10][1], classTable[arena.rightClass][10][2], classTable[arena.rightClass][10][3])
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
		arena.ball:setAlpha(0.05)
		
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
		self.endAction = function()
			arena.ball:setAlpha(1)
			arena.aiPlayer.char:updateAttr()
			arena.aiPlayer:aiRandomFactor()
			
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
		
		-- Sets timer to end skill --
		Timer.delayedCall(self.basetime/3, function()
			self:endAction()
			if optionsTable["SFX"] == "On" then sounds.puff:play() end
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
			
			if ballVy > 7.5*(ballV0^0.49) then
				direction = direction*-1
			elseif ballVy < -7.5*(ballV0^0.49) then
				direction = direction*-1
			end
		
			arena.ball.body:applyForce(0, direction*crazyFactor, ballX, ballY)
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
		self.endAction = function()
			stage:removeEventListener(Event.ENTER_FRAME, curveball)
			arena.ball.bitmap:setScale(2*arena.ball.radius/textures.pongball:getWidth())
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
			if optionsTable["SFX"] == "On" then sounds.crazyball_end:play() end
			
			-- Returns ball to previous state --
			local ballVxRet = arena.ball.body:getLinearVelocity()
			arena.ball.body:setLinearVelocity(math.abs(ballVxRet*ballVx0)/ballVxRet, ballVy0)
		end)
		
		-- Action to force end --
		self.forceEnd = function()
		
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
				arena.leftPlayer.paddle.bitmap:setColorTransform(classTable[arena.leftClass][10][1], classTable[arena.leftClass][10][2], classTable[arena.leftClass][10][3])
				
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
				arena.rightPlayer.paddle.bitmap:setColorTransform(classTable[arena.rightClass][10][1], classTable[arena.rightClass][10][2], classTable[arena.rightClass][10][3])
				
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
			world:destroyBody(ball2.body)
			ball2.body = nil
			fadeBitmapOut(ball2, 500, arena)
			world:destroyBody(ball3.body)
			ball3.body = nil
			fadeBitmapOut(ball3, 500, arena)
			
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
		Timer.delayedCall(self.basetime/2,  function()
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
		fireball.fixture:setFilterData({categoryBits = 1, maskBits = 7, groupIndex = 0})
		
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


end