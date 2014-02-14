-------------------------------------
-- Table Containing Special Arenas --
-------------------------------------


-- Normal --
arenasTable["Normal"] = {}
arenasTable["Normal"]["Name"] = "Normal"
arenasTable["Normal"]["Desc"] = "The normal PaddleBall Arena. No Special Effects"
arenasTable["Normal"]["Image"] = "imgs/backs/arenas/normal.jpg"
arenasTable["Normal"]["Init"] = function()
end
arenasTable["Normal"]["End"] = function()
end


-- Lava --
arenasTable["Lava"] = {}
arenasTable["Lava"]["Name"] = "Lava"
arenasTable["Lava"]["Desc"] = "Paddles can randomly melt (get smaller)"
arenasTable["Lava"]["Image"] = "imgs/backs/arenas/lava.jpg"
arenasTable["Lava"]["timer"] = Timer.new(1000, 0)
arenasTable["Lava"]["onTimer"] = function()
	local chance = 10
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
arenasTable["Ice"]["Name"] = "Ice"
arenasTable["Ice"]["Desc"] = "Paddles can randomly freeze"
arenasTable["Ice"]["Image"] = "imgs/backs/arenas/ice.jpg"
arenasTable["Ice"]["timer"] = Timer.new(2000, 0)
arenasTable["Ice"]["onTimer"] = function()
	local chance = 3
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
arenasTable["MagicField"]["Name"] = "Magic Field"
arenasTable["MagicField"]["Desc"] = "Both players gain lots of Skill Points"
arenasTable["MagicField"]["Image"] = "imgs/backs/arenas/magicfield.jpg"
arenasTable["MagicField"]["Init"] = function()
	arena.mp0 = 99
	arena.mp1 = 99
	arena.combatStats:update(arena.score0, arena.score1, arena.mp0, arena.mp1)
end
arenasTable["MagicField"]["End"] = function()
	
end


-- Null Magic Field --
arenasTable["NullMagicField"] = {}
arenasTable["NullMagicField"]["Name"] = "Null-Magic Field"
arenasTable["NullMagicField"]["Desc"] = "Both players have no Skill Points"
arenasTable["NullMagicField"]["Image"] = "imgs/backs/arenas/nullmagic.jpg"
arenasTable["NullMagicField"]["Init"] = function()
	arena.mp0 = 0
	arena.mp1 = 0
	arena.combatStats:update(arena.score0, arena.score1, arena.mp0, arena.mp1)
end
arenasTable["NullMagicField"]["End"] = function()
	
end


-- Sudden Death --
arenasTable["SuddenDeath"] = {}
arenasTable["SuddenDeath"]["Name"] = "Sudden Death"
arenasTable["SuddenDeath"]["Desc"] = "Both players start with only 1 HP"
arenasTable["SuddenDeath"]["Image"] = "imgs/backs/arenas/suddendeath.jpg"
arenasTable["SuddenDeath"]["Init"] = function()
	arena.score0 = 1
	arena.score1 = 1
	arena.combatStats:update(arena.score0, arena.score1, arena.mp0, arena.mp1)
end
arenasTable["SuddenDeath"]["End"] = function()
	
end


-- Worm Hole --
arenasTable["WormHole"] = {}
arenasTable["WormHole"]["Name"] = "Worm Hole"
arenasTable["WormHole"]["Desc"] = "Ball base speed is increased"
arenasTable["WormHole"]["Image"] = "imgs/backs/arenas/wormhole.jpg"
arenasTable["WormHole"]["Init"] = function()
	arena.ball.baseSpeed = arena.ball.baseSpeed0*1.5
end
arenasTable["WormHole"]["End"] = function()
	
end


-- Swamp --
arenasTable["Swamp"] = {}
arenasTable["Swamp"]["Name"] = "Swamp"
arenasTable["Swamp"]["Desc"] = "Ball base speed is decreased"
arenasTable["Swamp"]["Image"] = "imgs/backs/arenas/viscous.jpg"
arenasTable["Swamp"]["Init"] = function()
	arena.ball.baseSpeed = arena.ball.baseSpeed0*0.75
end
arenasTable["Swamp"]["End"] = function()
	
end


-- Gas Cloud --
arenasTable["GasCloud"] = {}
arenasTable["GasCloud"]["Name"] = "Gas Cloud"
arenasTable["GasCloud"]["Desc"] = "Strong Winds change ball direction"
arenasTable["GasCloud"]["Image"] = "imgs/backs/arenas/wind.jpg"
arenasTable["GasCloud"]["timer"] = Timer.new(1000, 0)
arenasTable["GasCloud"]["onTimer"] = function()
	local chance = 7
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
arenasTable["GasCloud"]["Init"] = function()
	arenasTable["GasCloud"]["timer"]:addEventListener(Event.TIMER, arenasTable["GasCloud"]["onTimer"], arenasTable["GasCloud"]["timer"])
	arenasTable["GasCloud"]["timer"]:start()
end
arenasTable["GasCloud"]["End"] = function()
	arenasTable["GasCloud"]["timer"]:removeEventListener(Event.TIMER, arenasTable["GasCloud"]["onTimer"])
	arenasTable["GasCloud"]["timer"]:stop()
end


-- Black Hole --
arenasTable["BlackHole"] = {}
arenasTable["BlackHole"]["Name"] = "Black Hole"
arenasTable["BlackHole"]["Desc"] = "Ball is attracted to center of the arena"
arenasTable["BlackHole"]["Image"] = "imgs/backs/arenas/blackhole.jpg"
arenasTable["BlackHole"]["timer"] = Timer.new(33, 0)
arenasTable["BlackHole"]["onTimer"] = function()
	-- Applies force pointing to the center of the arena --
	if arena.ball.launched then
		local ballX, ballY = arena.ball.body:getPosition()
		local dX = (XShift + WX)/2 - ballX
		local dY = WY/2 - ballY
		local horizon = 10
		if math.abs(dX) < horizon then
			dX = horizon*dX/(math.abs(dX) + 1)
		end
		if math.abs(dY) < horizon then
			dY = horizon*dY/(math.abs(dY) + 1)
		end
		local force = arena.ball.baseSpeed*8000/(dX^2 + dY^2)
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
arenasTable["WhiteHole"]["Name"] = "White Hole"
arenasTable["WhiteHole"]["Desc"] = "Ball is repelled by the center of the arena"
arenasTable["WhiteHole"]["Image"] = "imgs/backs/arenas/whitehole.jpg"
arenasTable["WhiteHole"]["timer"] = Timer.new(33, 0)
arenasTable["WhiteHole"]["onTimer"] = function()
	-- Applies force pointing to the center of the arena --
	if arena.ball.launched then
		local ballX, ballY = arena.ball.body:getPosition()
		local dX = (XShift + WX)/2 - ballX
		local dY = WY/2 - ballY
		local horizon = 10
		if math.abs(dX) < horizon then
			dX = horizon*dX/(math.abs(dX) + 1)
		end
		if math.abs(dY) < horizon then
			dY = horizon*dY/(math.abs(dY) + 1)
		end
		local force = arena.ball.baseSpeed*25000/(dX^2 + dY^2)
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