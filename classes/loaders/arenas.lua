-------------------------------------
-- Table Containing Special Arenas --
-------------------------------------


-- Normal --
arenasTable["Normal"] = {}
arenasTable["Normal"]["Desc"] = "The normal PaddleBall Arena. No Special Effects"
arenasTable["Normal"]["Image"] = "imgs/backs/arenas/normal.png"
arenasTable["Normal"]["Init"] = function()
end
arenasTable["Normal"]["End"] = function()
end


-- Lava --
arenasTable["Lava"] = {}
arenasTable["Lava"]["Desc"] = "Paddles can randomly melt (get smaller)"
arenasTable["Lava"]["Image"] = "imgs/backs/arenas/lava.png"
arenasTable["Lava"]["timer"] = Timer.new(1000, 0)
arenasTable["Lava"]["onTimer"] = function()
	local chance = 12
	local randNum = math.random(1, chance)
	if randNum == 1 and arena.ball.launched then
		if optionsTable["SFX"] == "On" then sounds.fire:play() end
		-- Sets paddle to 75% of size --
		local randSide = math.random(1,2)
		if randSide == 1 then
			local defFactor = arena.leftPlayer.paddle.defFactor*0.75

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
		else
			local defFactor = arena.rightPlayer.paddle.defFactor*0.75
			
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
		end
		
		-- GFX --
		local paddleX, paddleY = 0
		local paddleH, paddleW = 0
		arenasTable["Lava"].flame = Bitmap.new(textures.gfx_flame)
		arenasTable["Lava"].flame:setScale(1, 1)
		arenasTable["Lava"].flame:setAnchorPoint(0.5, 0.5)
		local textureW = arenasTable["Lava"].flame:getWidth()
		local textureH = arenasTable["Lava"].flame:getHeight()
		--arenasTable["Lava"].flame:setPosition(paddleX, paddleY)
		if randSide == 2 then
			paddleX, paddleY = arena.rightPlayer.paddle.body:getPosition()
			paddleH = arena.rightPlayer.paddle.paddleH
			paddleW = arena.rightPlayer.paddle.paddleW
			arenasTable["Lava"].flame:setScale((paddleW*3)/textureW, (paddleH*1.5)/textureH)
			arena.rightPlayer.paddle:addChild(arenasTable["Lava"].flame)
			fadeBitmapIn(arenasTable["Lava"].flame, 500, 0.5)
			Timer.delayedCall(500, function()
				fadeBitmapOut(arenasTable["Lava"].flame, 500, arena.rightPlayer.paddle)
			end)
		else
			paddleX, paddleY = arena.leftPlayer.paddle.body:getPosition()
			paddleH = arena.leftPlayer.paddle.paddleH
			paddleW = arena.leftPlayer.paddle.paddleW
			arenasTable["Lava"].flame:setScale((paddleW*3)/textureW, (paddleH*1.5)/textureH)
			arena.leftPlayer.paddle:addChild(arenasTable["Lava"].flame)
			fadeBitmapIn(arenasTable["Lava"].flame, 500, 0.5)
			Timer.delayedCall(500, function()
				fadeBitmapOut(arenasTable["Lava"].flame, 500, arena.leftPlayer.paddle)
			end)
		end
	end
end
arenasTable["Lava"]["Init"] = function()
	arenasTable["Lava"]["timer"]:addEventListener(Event.TIMER, arenasTable["Lava"]["onTimer"], arenasTable["Lava"]["timer"])
	arenasTable["Lava"]["timer"]:start()
end
arenasTable["Lava"]["End"] = function()
	arenasTable["Lava"]["timer"]:removeEventListener(Event.TIMER, arenasTable["Lava"]["onTimer"])
	arenasTable["Lava"]["timer"]:stop()
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
	
	for i = arena.leftPlayer.paddle:getNumChildren(), 1, -1 do
		if arena.leftPlayer.paddle:getChildAt(i) == arenasTable["Lava"].flame then
			fadeBitmapOut(arenasTable["Lava"].flame, 100, arena.leftPlayer.paddle)
		end
	end
	for i = arena.rightPlayer.paddle:getNumChildren(), 1, -1 do
		if arena.rightPlayer.paddle:getChildAt(i) == arenasTable["Lava"].flame then
			fadeBitmapOut(arenasTable["Lava"].flame, 100, arena.rightPlayer.paddle)
		end
	end
end


-- Ice --
arenasTable["Ice"] = {}
arenasTable["Ice"]["Desc"] = "Paddles can randomly freeze"
arenasTable["Ice"]["Image"] = "imgs/backs/arenas/ice.png"
arenasTable["Ice"]["timer"] = Timer.new(2000, 0)
arenasTable["Ice"]["onTimer"] = function()
	local chance = 5
	local randNum = math.random(1, chance)
	if randNum == 1 and arena.ball.launched then
		if optionsTable["SFX"] == "On" then sounds.ice:play() end
		-- Freezes Paddle --
		local randSide = math.random(1,2)
		if randSide == 1 then
			arena.leftPlayer.char.movFactor = 0
		else
			arena.rightPlayer.char.movFactor = 0
		end
		
		-- GFX --
		local paddleX, paddleY = 0
		local paddleH, paddleW = 0
		if randSide == 2 then
			paddleX, paddleY = arena.rightPlayer.paddle.body:getPosition()
			paddleH = arena.rightPlayer.paddle.paddleH
			paddleW = arena.rightPlayer.paddle.paddleW
		else
			paddleX, paddleY = arena.leftPlayer.paddle.body:getPosition()
			paddleH = arena.leftPlayer.paddle.paddleH
			paddleW = arena.leftPlayer.paddle.paddleW
		end
		arenasTable["Ice"].freeze = Bitmap.new(textures.gfx_freeze)
		arenasTable["Ice"].freeze:setScale(1, 1)
		arenasTable["Ice"].freeze:setAnchorPoint(0.5, 0.5)
		arena:addChild(arenasTable["Ice"].freeze)
		local textureW = arenasTable["Ice"].freeze:getWidth()
		local textureH = arenasTable["Ice"].freeze:getHeight()
		arenasTable["Ice"].freeze:setScale((paddleW*2)/textureW, (paddleH*1.33333333333)/textureH)
		arenasTable["Ice"].freeze:setPosition(paddleX, paddleY)
		fadeBitmapIn(arenasTable["Ice"].freeze, 500, 0.5)
		
		Timer.delayedCall(1400, function()
			arena.rightPlayer.char:updateAttr()
			arena.leftPlayer.char:updateAttr()
			
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == arenasTable["Ice"].freeze then
					fadeBitmapOut(arenasTable["Ice"].freeze, 500, arena)
					if optionsTable["SFX"] == "On" then sounds.ice_break:play() end
				end
			end
		end)
	end
end
arenasTable["Ice"]["Init"] = function()
	arenasTable["Ice"]["timer"]:addEventListener(Event.TIMER, arenasTable["Ice"]["onTimer"], arenasTable["Ice"]["timer"])
	arenasTable["Ice"]["timer"]:start()
end
arenasTable["Ice"]["End"] = function()
	arenasTable["Ice"]["timer"]:removeEventListener(Event.TIMER, arenasTable["Ice"]["onTimer"])
	arenasTable["Ice"]["timer"]:stop()
	
	arena.rightPlayer.char:updateAttr()
	arena.leftPlayer.char:updateAttr()
	
	for i = arena:getNumChildren(), 1, -1 do
		if arena:getChildAt(i) == arenasTable["Ice"].freeze then
			fadeBitmapOut(arenasTable["Ice"].freeze, 100, arena)
		end
	end
end


-- Magic Field --
arenasTable["MagicField"] = {}
arenasTable["MagicField"]["Desc"] = "Both players gain lots of Skill Points"
arenasTable["MagicField"]["Image"] = "imgs/backs/arenas/magicfield.png"
arenasTable["MagicField"]["Init"] = function()
	arena.mp0 = 99
	arena.mp1 = 99
	arena.combatStats:update(arena.score0, arena.score1, arena.mp0, arena.mp1)
end
arenasTable["MagicField"]["End"] = function()
	
end


-- Null Magic Field --
arenasTable["NullMagicField"] = {}
arenasTable["NullMagicField"]["Desc"] = "Both players have no Skill Points"
arenasTable["NullMagicField"]["Image"] = "imgs/backs/arenas/nullmagic.png"
arenasTable["NullMagicField"]["Init"] = function()
	arena.mp0 = 0
	arena.mp1 = 0
	arena.combatStats:update(arena.score0, arena.score1, arena.mp0, arena.mp1)
end
arenasTable["NullMagicField"]["End"] = function()
	
end


-- Sudden Death --
arenasTable["SuddenDeath"] = {}
arenasTable["SuddenDeath"]["Desc"] = "Both players start with only 1 HP"
arenasTable["SuddenDeath"]["Image"] = "imgs/backs/arenas/suddendeath.png"
arenasTable["SuddenDeath"]["Init"] = function()
	arena.score0 = 1
	arena.score1 = 1
	arena.combatStats:update(arena.score0, arena.score1, arena.mp0, arena.mp1)
end
arenasTable["SuddenDeath"]["End"] = function()
	
end


-- Vacuum --
arenasTable["Vacuum"] = {}
arenasTable["Vacuum"]["Desc"] = "Ball base speed is increased"
arenasTable["Vacuum"]["Image"] = "imgs/backs/arenas/vacuum.png"
arenasTable["Vacuum"]["Init"] = function()
	arena.ball.baseSpeed = arena.ball.baseSpeed0*1.5
end
arenasTable["Vacuum"]["End"] = function()
	
end


-- Viscous --
arenasTable["Viscous"] = {}
arenasTable["Viscous"]["Desc"] = "Ball base speed is decreased"
arenasTable["Viscous"]["Image"] = "imgs/backs/arenas/viscous.png"
arenasTable["Viscous"]["Init"] = function()
	arena.ball.baseSpeed = arena.ball.baseSpeed0*0.75
end
arenasTable["Viscous"]["End"] = function()
	
end


-- Wind --
arenasTable["Wind"] = {}
arenasTable["Wind"]["Desc"] = "Strong Winds change ball direction"
arenasTable["Wind"]["Image"] = "imgs/backs/arenas/wind.png"
arenasTable["Wind"]["timer"] = Timer.new(1000, 0)
arenasTable["Wind"]["onTimer"] = function()
	local chance = 8
	local randNum = math.random(1, chance)
	if randNum == 1 and arena.ball.launched then
		if optionsTable["SFX"] == "On" then sounds.woosh:play() end
		
		-- Applies random force on ball --
		local ballX, ballY = arena.ball.body:getPosition()
		local force = arena.ball.baseSpeed*30
		local randForceX = math.random(-force, force)
		local randForceY = math.random(-force, force)
		arena.ball.body:applyForce(randForceX, randForceY, ballX, ballY)
	end
end
arenasTable["Wind"]["Init"] = function()
	arenasTable["Wind"]["timer"]:addEventListener(Event.TIMER, arenasTable["Wind"]["onTimer"], arenasTable["Wind"]["timer"])
	arenasTable["Wind"]["timer"]:start()
end
arenasTable["Wind"]["End"] = function()
	arenasTable["Wind"]["timer"]:removeEventListener(Event.TIMER, arenasTable["Wind"]["onTimer"])
	arenasTable["Wind"]["timer"]:stop()
end


-- Black Hole --
arenasTable["BlackHole"] = {}
arenasTable["BlackHole"]["Desc"] = "Ball is attracted to center of the arena"
arenasTable["BlackHole"]["Image"] = "imgs/backs/arenas/blackhole.png"
arenasTable["BlackHole"]["timer"] = Timer.new(33, 0)
arenasTable["BlackHole"]["onTimer"] = function()
	-- Applies force pointing to the center of the arena --
	if arena.ball.launched then
		local ballX, ballY = arena.ball.body:getPosition()
		local dX = (XShift + WX)/2 - ballX
		local dY = WY/2 - ballY
		local force = arena.ball.baseSpeed*6000/(dX^2 + dY^2)
		local forceX = force*dX/math.sqrt(dX^2 + dY^2)
		local forceY = force*dY/math.sqrt(dX^2 + dY^2)
		arena.ball.body:applyForce(forceX, forceY, ballX, ballY)
	end
end
arenasTable["BlackHole"]["Init"] = function()
	arenasTable["BlackHole"]["timer"]:addEventListener(Event.TIMER, arenasTable["BlackHole"]["onTimer"], arenasTable["BlackHole"]["timer"])
	arenasTable["BlackHole"]["timer"]:start()
end
arenasTable["BlackHole"]["End"] = function()
	arenasTable["BlackHole"]["timer"]:removeEventListener(Event.TIMER, arenasTable["BlackHole"]["onTimer"])
	arenasTable["BlackHole"]["timer"]:stop()
end

-- White Hole --
arenasTable["WhiteHole"] = {}
arenasTable["WhiteHole"]["Desc"] = "Ball is repelled by the center of the arena"
arenasTable["WhiteHole"]["Image"] = "imgs/backs/arenas/whitehole.png"
arenasTable["WhiteHole"]["timer"] = Timer.new(33, 0)
arenasTable["WhiteHole"]["onTimer"] = function()
	-- Applies force pointing to the center of the arena --
	if arena.ball.launched then
		local ballX, ballY = arena.ball.body:getPosition()
		local dX = (XShift + WX)/2 - ballX
		local dY = WY/2 - ballY
		local force = arena.ball.baseSpeed*20000/(dX^2 + dY^2)
		local forceX = force*dX/math.sqrt(dX^2 + dY^2)
		local forceY = force*dY/math.sqrt(dX^2 + dY^2)
		arena.ball.body:applyForce(-forceX, -forceY, ballX, ballY)
	end
end
arenasTable["WhiteHole"]["Init"] = function()
	arenasTable["WhiteHole"]["timer"]:addEventListener(Event.TIMER, arenasTable["WhiteHole"]["onTimer"], arenasTable["WhiteHole"]["timer"])
	arenasTable["WhiteHole"]["timer"]:start()
end
arenasTable["WhiteHole"]["End"] = function()
	arenasTable["WhiteHole"]["timer"]:removeEventListener(Event.TIMER, arenasTable["WhiteHole"]["onTimer"])
	arenasTable["WhiteHole"]["timer"]:stop()
end