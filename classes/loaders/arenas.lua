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
	local chance = 8
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
arenasTable["Lava"]["Pause"] = function()
	arenasTable["Lava"]["timer"]:stop()
end
arenasTable["Lava"]["Unpause"] = function()
	arenasTable["Lava"]["timer"]:start()
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
arenasTable["Ice"]["Pause"] = function()
	arenasTable["Ice"]["timer"]:stop()
end
arenasTable["Ice"]["Unpause"] = function()
	arenasTable["Ice"]["timer"]:start()
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
arenasTable["GasCloud"]["Pause"] = function()
	arenasTable["GasCloud"]["timer"]:stop()
end
arenasTable["GasCloud"]["Unpause"] = function()
	arenasTable["GasCloud"]["timer"]:start()
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
arenasTable["BlackHole"]["Pause"] = function()
	arenasTable["BlackHole"]["timer"]:stop()
end
arenasTable["BlackHole"]["Unpause"] = function()
	arenasTable["BlackHole"]["timer"]:start()
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
arenasTable["WhiteHole"]["Pause"] = function()
	arenasTable["WhiteHole"]["timer"]:stop()
end
arenasTable["WhiteHole"]["Unpause"] = function()
	arenasTable["WhiteHole"]["timer"]:start()
end


-- Lightning --
arenasTable["Lightning"] = {}
arenasTable["Lightning"]["Name"] = "Lightning"
arenasTable["Lightning"]["Desc"] = "Ball can stop and get charged"
arenasTable["Lightning"]["Image"] = "imgs/backs/arenas/thunder.jpg"
arenasTable["Lightning"]["timer"] = Timer.new(2000, 0)
arenasTable["Lightning"]["onTimer"] = function()
	local chance = 6
	local randNum = math.random(1, chance)
	if randNum == 1 and arena.ball.launched then
		if optionsTable["SFX"] == "On" then sounds.spark:play() end
		
		-- Stop ball --
		local ballVx0, ballVy0 = arena.ball.body:getLinearVelocity()
		local ballV = math.sqrt(math.pow(ballVx0, 2) + math.pow(ballVy0, 2))
		arena.ball.body:setLinearVelocity(0, 0)
		
		-- GFX --
		arenasTable["Lightning"].spark = Bitmap.new(textures.gfx_spark)
		arenasTable["Lightning"].spark:setScale(1, 1)
		arenasTable["Lightning"].spark:setAnchorPoint(0.5, 0.5)
		local textureW = arenasTable["Lightning"].spark:getWidth()
		local textureH = arenasTable["Lightning"].spark:getHeight()
		arenasTable["Lightning"].spark:setScale(2*arena.ball.radius/textureW, 2*arena.ball.radius/textureH)

		local ballX, ballY = arena.ball.body:getPosition()
		arena.ball:addChild(arenasTable["Lightning"].spark)
		fadeBitmapIn(arenasTable["Lightning"].spark, 750, 1)
		Timer.delayedCall(1000, function()
			fadeBitmapOut(arenasTable["Lightning"].spark, 300, arena.ball)
		end)
		
		-- Wait, then launch ball --
		Timer.delayedCall(1000,  function()
			if ballV ~= 0 then
				local randomvx = math.random(-2000*ballV, 2000*ballV)/1000
				local newVy = math.sqrt(math.pow((2*ballV), 2) - math.pow(randomvx, 2))
				local randsign = math.random(0, 1)
				if randsign == 0 then
					newVy = -newVy
				end
				arena.ball.body:setLinearVelocity(randomvx, newVy)
			else
				arena.ball:launch()
			end
		end)	
	end
end
arenasTable["Lightning"]["Init"] = function()
	arenasTable["Lightning"]["timer"]:addEventListener(Event.TIMER, arenasTable["Lightning"]["onTimer"], arenasTable["Lightning"]["timer"])
	arenasTable["Lightning"]["timer"]:start()
end
arenasTable["Lightning"]["End"] = function()
	arenasTable["Lightning"]["timer"]:removeEventListener(Event.TIMER, arenasTable["Lightning"]["onTimer"])
	arenasTable["Lightning"]["timer"]:stop()
	for i = arena.ball:getNumChildren(), 1, -1 do
		if arena.ball:getChildAt(i) == arenasTable["Lightning"].spark then
			fadeBitmapOut(arenasTable["Lightning"].spark, 500, arena.ball)
		end
	end
end
arenasTable["Lightning"]["Pause"] = function()
	arenasTable["Lightning"]["timer"]:stop()
end
arenasTable["Lightning"]["Unpause"] = function()
	arenasTable["Lightning"]["timer"]:start()
end


-- Forest --
arenasTable["Forest"] = {}
arenasTable["Forest"]["Name"] = "Forest"
arenasTable["Forest"]["Desc"] = "Players get randomly healed"
arenasTable["Forest"]["Image"] = "imgs/backs/arenas/leaves.jpg"
arenasTable["Forest"]["timer"] = Timer.new(2000, 0)
arenasTable["Forest"]["onTimer"] = function()
	local chance = 8
	local randNum = math.random(1, chance)
	if randNum == 1 and arena.ball.launched then
		if optionsTable["SFX"] == "On" then sounds.harp:play() end
		
		-- Heal --
		local randSide = math.random(1,2)
		if randSide == 1 then
			arena.score0 = arena.score0 + 1
			arena.combatStats:update(arena.score0, arena.score1, arena.mp0, arena.mp1)
		else
			arena.score1 = arena.score1 + 1
			arena.combatStats:update(arena.score0, arena.score1, arena.mp0, arena.mp1)
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
		arenasTable["Forest"].heal = Bitmap.new(textures.gfx_heal)
		arenasTable["Forest"].heal:setScale(1, 1)
		arenasTable["Forest"].heal:setAnchorPoint(0.5, 0.5)
		arena:addChild(arenasTable["Forest"].heal)
		local textureW = arenasTable["Forest"].heal:getWidth()
		local textureH = arenasTable["Forest"].heal:getHeight()
		arenasTable["Forest"].heal:setScale((paddleW*2)/textureW, (paddleH*1.33333333333)/textureH)
		arenasTable["Forest"].heal:setPosition(paddleX, paddleY)
		fadeBitmapIn(arenasTable["Forest"].heal, 500, 0.5)
		
		Timer.delayedCall(100 + 500, function()
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == arenasTable["Forest"].heal then
					fadeBitmapOut(arenasTable["Forest"].heal, 500, arena)
				end
			end
		end)
	end
end
arenasTable["Forest"]["Init"] = function()
	arenasTable["Forest"]["timer"]:addEventListener(Event.TIMER, arenasTable["Forest"]["onTimer"], arenasTable["Forest"]["timer"])
	arenasTable["Forest"]["timer"]:start()
end
arenasTable["Forest"]["End"] = function()
	arenasTable["Forest"]["timer"]:removeEventListener(Event.TIMER, arenasTable["Forest"]["onTimer"])
	arenasTable["Forest"]["timer"]:stop()
	for i = arena:getNumChildren(), 1, -1 do
		if arena:getChildAt(i) == arenasTable["Forest"].heal then
			fadeBitmapOut(arenasTable["Forest"].heal, 500, arena)
		end
	end
end


-- Crystal Cave --
arenasTable["CrystalCave"] = {}
arenasTable["CrystalCave"]["Name"] = "Crystal Cave"
arenasTable["CrystalCave"]["Desc"] = "Crystal Walls appear out of nowhere"
arenasTable["CrystalCave"]["Image"] = "imgs/backs/arenas/crystal.jpg"
arenasTable["CrystalCave"]["timer"] = Timer.new(3000, 0)
arenasTable["CrystalCave"]["onTimer"] = function()
	local chance = 2
	local randNum = math.random(1, chance)
	if randNum == 1 and arena.ball.launched then
		if optionsTable["SFX"] == "On" then sounds.ice:play() end
		
		-- Creates Wall --
		arenasTable["CrystalCave"].wall = Bitmap.new(textures.gfx_crystal)
		--wall:setColorTransform(1, 1, 1)
		arenasTable["CrystalCave"].wall:setScale(1, 1)
		arenasTable["CrystalCave"].wall:setAnchorPoint(0.5, 0.5)
		local textureW = arenasTable["CrystalCave"].wall:getWidth()
		local textureH = arenasTable["CrystalCave"].wall:getHeight()
		local posX = math.random(XShift + 100, XShift + WX - 100)
		arenasTable["CrystalCave"].wall:setScale(15/textureW, WY/textureH)
		arenasTable["CrystalCave"].wall:setPosition(posX, WY/2)
		fadeBitmapIn(arenasTable["CrystalCave"].wall, 500, 0.8)
		
		arenasTable["CrystalCave"].wall.body = world:createBody{
			type = b2.DYNAMIC_BODY,
			position = {x = posX, y = WY/2},
			angularDamping = 10000,
			linearDamping = 0.5
		}
		arenasTable["CrystalCave"].wall.body.name = "wall"
		arenasTable["CrystalCave"].wall.body.del = false
		arenasTable["CrystalCave"].wall.shape = b2.PolygonShape.new()
		arenasTable["CrystalCave"].wall.shape:setAsBox(15/2, WY/2, 0, 0, 0)
		arenasTable["CrystalCave"].wall.fixture = arenasTable["CrystalCave"].wall.body:createFixture{
			shape = arenasTable["CrystalCave"].wall.shape, 
			density = 10000,
			restitution = 1, 
			friction = 0,
			fixedRotation = true,
		}
		arenasTable["CrystalCave"].wall.fixture:setFilterData({categoryBits = 2, maskBits = 1, groupIndex = 0})
		local side = 0
		if posX > XShift + WX/2 then
			side = 1
		end
		arenasTable["CrystalCave"].wall.body:setAngle(side*math.pi)
		arenasTable["CrystalCave"].wall.body.collide = function(event)
			if optionsTable["SFX"] == "On" then sounds.glass_ping:play() end
		end	
		
		arena:addChild(arenasTable["CrystalCave"].wall)
		
		Timer.delayedCall(2850, function()
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == arenasTable["CrystalCave"].wall then
					if optionsTable["SFX"] == "On" then sounds.ice_break:play() end
					fadeBitmapOut(arenasTable["CrystalCave"].wall, 100, arena)
					if arenasTable["CrystalCave"].wall.body ~= nil then
						arenasTable["CrystalCave"].wall.body.del = true
					end
				end
			end
		end)
	end
end
arenasTable["CrystalCave"]["Init"] = function()
	arenasTable["CrystalCave"]["timer"]:addEventListener(Event.TIMER, arenasTable["CrystalCave"]["onTimer"], arenasTable["CrystalCave"]["timer"])
	arenasTable["CrystalCave"]["timer"]:start()
end
arenasTable["CrystalCave"]["End"] = function()
	arenasTable["CrystalCave"]["timer"]:removeEventListener(Event.TIMER, arenasTable["CrystalCave"]["onTimer"])
	arenasTable["CrystalCave"]["timer"]:stop()
	for i = arena:getNumChildren(), 1, -1 do
		if arena:getChildAt(i) == arenasTable["CrystalCave"].wall then
			if optionsTable["SFX"] == "On" then sounds.ice_break:play() end
			fadeBitmapOut(arenasTable["CrystalCave"].wall, 100, arena)
			if arenasTable["CrystalCave"].wall.body ~= nil then
				arenasTable["CrystalCave"].wall.body.del = true
			end
		end
	end
end


-- Asteroid Field --
arenasTable["AsteroidField"] = {}
arenasTable["AsteroidField"]["Name"] = "Asteroid Field"
arenasTable["AsteroidField"]["Desc"] = "Asteroids fall down on the arena"
arenasTable["AsteroidField"]["Image"] = "imgs/backs/arenas/asteroids.jpg"
arenasTable["AsteroidField"]["timer"] = Timer.new(5000, 0)
arenasTable["AsteroidField"]["onTimer"] = function()
	local chance = 1
	local randNum = math.random(1, chance)
	if randNum == 1 and arena.ball.launched then
		if optionsTable["SFX"] == "On" then sounds.explode:play() end
		
		-- Creates Asteroid --
		arenasTable["AsteroidField"].asteroid = Bitmap.new(textures.gfx_asteroid)
		--asteroid:setColorTransform(1, 1, 1)
		arenasTable["AsteroidField"].asteroid:setScale(1, 1)
		arenasTable["AsteroidField"].asteroid:setAnchorPoint(0.5, 0.5)
		local textureW = arenasTable["AsteroidField"].asteroid:getWidth()
		local textureH = arenasTable["AsteroidField"].asteroid:getHeight()
		local randradius = math.random(10, 100)
		local posX = math.random(XShift + 30 + randradius, XShift + WX - 30 - randradius)
		local posY = math.random(15 + randradius, WY - 15 - randradius)
		arenasTable["AsteroidField"].asteroid:setScale(2*randradius/textureW, 2*randradius/textureH)
		arenasTable["AsteroidField"].asteroid:setPosition(posX, posY)
		fadeBitmapIn(arenasTable["AsteroidField"].asteroid, 300, 0.8)
		
		arenasTable["AsteroidField"].asteroid.body = world:createBody{
			type = b2.DYNAMIC_BODY,
			position = {x = posX, y = posY},
			bullet = true
		}
		arenasTable["AsteroidField"].asteroid.body.name = "asteroid"
		arenasTable["AsteroidField"].asteroid.body.del = false
		arenasTable["AsteroidField"].asteroid.shape = b2.CircleShape.new(0, 0, randradius)
		arenasTable["AsteroidField"].asteroid.fixture = arenasTable["AsteroidField"].asteroid.body:createFixture{
			shape = arenasTable["AsteroidField"].asteroid.shape, 
			density = 2,
			restitution = 1, 
			friction = 10,
		}
		arenasTable["AsteroidField"].asteroid.fixture:setFilterData({categoryBits = 8, maskBits = 7, groupIndex = 0})

		arenasTable["AsteroidField"].asteroid.body:setAngle(math.random(0, 2*math.pi))
		arenasTable["AsteroidField"].asteroid.body.collide = function(event)
			if optionsTable["SFX"] == "On" then sounds.rockhit:play() end
		end	
		
		arena:addChild(arenasTable["AsteroidField"].asteroid)
		
		local astspeed = 10*arena.ball.baseSpeed/randradius
		arenasTable["AsteroidField"].asteroid.body:setLinearVelocity(math.random(-astspeed, astspeed), math.random(-astspeed, astspeed))
		arenasTable["AsteroidField"].asteroid.body:applyTorque(math.random(-100*randradius, 100*randradius))
		
		Timer.delayedCall(4850, function()
			for i = arena:getNumChildren(), 1, -1 do
				if arena:getChildAt(i) == arenasTable["AsteroidField"].asteroid then
					if optionsTable["SFX"] == "On" then sounds.rockhit:play() end
					fadeBitmapOut(arenasTable["AsteroidField"].asteroid, 100, arena)
					if arenasTable["AsteroidField"].asteroid.body ~= nil then
						arenasTable["AsteroidField"].asteroid.body.del = true
					end
				end
			end
		end)
	end
end
arenasTable["AsteroidField"]["Init"] = function()
	arenasTable["AsteroidField"]["timer"]:addEventListener(Event.TIMER, arenasTable["AsteroidField"]["onTimer"], arenasTable["AsteroidField"]["timer"])
	arenasTable["AsteroidField"]["timer"]:start()
end
arenasTable["AsteroidField"]["End"] = function()
	arenasTable["AsteroidField"]["timer"]:removeEventListener(Event.TIMER, arenasTable["AsteroidField"]["onTimer"])
	arenasTable["AsteroidField"]["timer"]:stop()
	for i = arena:getNumChildren(), 1, -1 do
		if arena:getChildAt(i) == arenasTable["AsteroidField"].asteroid then
			if optionsTable["SFX"] == "On" then sounds.rockhit:play() end
			fadeBitmapOut(arenasTable["AsteroidField"].asteroid, 100, arena)
			if arenasTable["AsteroidField"].asteroid.body ~= nil then
				arenasTable["AsteroidField"].asteroid.body.del = true
			end
		end
	end
end


-- Factory --
arenasTable["Factory"] = {}
arenasTable["Factory"]["Name"] = "Factory"
arenasTable["Factory"]["Desc"] = "Rotating fans are in the middle of the arena"
arenasTable["Factory"]["Image"] = "imgs/backs/arenas/factory.jpg"
arenasTable["Factory"]["Init"] = function()
	-- Creates Asteroid --
	arenasTable["Factory"].fan = Bitmap.new(textures.gfx_fan)
	--fan:setColorTransform(1, 1, 1)
	arenasTable["Factory"].fan:setScale(1, 1)
	arenasTable["Factory"].fan:setAnchorPoint(0.5, 0.5)
	local textureW = arenasTable["Factory"].fan:getWidth()
	local textureH = arenasTable["Factory"].fan:getHeight()

	local posX = math.random(XShift, XShift + WX)
	local posY = math.random(0, WY)
	arenasTable["Factory"].fan:setScale(19/textureW, 240/textureH)
	arenasTable["Factory"].fan:setPosition(posX, posY)
	fadeBitmapIn(arenasTable["Factory"].fan, 100, 0.8)
	
	arenasTable["Factory"].fan.body = world:createBody{
		type = b2.DYNAMIC_BODY,
		position = {x = posX, y = posY},
		bullet = true,
		angularDamping = 0,
		linearDamping = 100000
	}
	arenasTable["Factory"].fan.body.name = "fan"
	arenasTable["Factory"].fan.body.del = false
	arenasTable["Factory"].fan.shape = b2.PolygonShape.new()
	arenasTable["Factory"].fan.shape:setAsBox(9.5, 120, 0, 0, 0)
	arenasTable["Factory"].fan.fixture = arenasTable["Factory"].fan.body:createFixture{
		shape = arenasTable["Factory"].fan.shape, 
		density = 10,
		restitution = 1, 
		friction = 0
	}
	arenasTable["Factory"].fan.fixture:setFilterData({categoryBits = 8, maskBits = 0, groupIndex = 0})
	
	-- Checks if ball is launched --
	local function checkball()
		if arena.ball.launched then
			arenasTable["Factory"].fan.fixture:setFilterData({categoryBits = 8, maskBits = 1, groupIndex = 0})
			arena:removeEventListener(Event.ENTER_FRAME, checkball)
		end
	end
	arena:addEventListener(Event.ENTER_FRAME, checkball)

	arenasTable["Factory"].fan.body:setAngle(math.random(0, 2*math.pi))
	arenasTable["Factory"].fan.body.collide = function(event)
		if optionsTable["SFX"] == "On" then sounds.hit2:play() end
		Timer.delayedCall(0, function()
			arenasTable["Factory"].fan.body:setPosition(posX, posY)
		end)
	end	
	
	arena:addChild(arenasTable["Factory"].fan)
	
	local randside = math.random(0,1)
	if randside == 0 then
		arenasTable["Factory"].fan.body:applyTorque(500000)
	else
		arenasTable["Factory"].fan.body:applyTorque(-500000)
	end
end
arenasTable["Factory"]["End"] = function()
	for i = arena:getNumChildren(), 1, -1 do
		if arena:getChildAt(i) == arenasTable["Factory"].fan then
			fadeBitmapOut(arenasTable["Factory"].fan, 100, arena)
			if arenasTable["Factory"].fan.body ~= nil then
				arenasTable["Factory"].fan.body.del = true
			end
		end
	end
end


-- Portal Field --
arenasTable["PortalField"] = {}
arenasTable["PortalField"]["Name"] = "Portal Field"
arenasTable["PortalField"]["Desc"] = "Portals pop up in the arena"
arenasTable["PortalField"]["Image"] = "imgs/backs/black.jpg"
arenasTable["PortalField"]["Init"] = function()
	-- Creates Portals --
	arenasTable["PortalField"].blueportal = Bitmap.new(textures.paddle2)
	arenasTable["PortalField"].blueportal:setScale(1, 1)
	arenasTable["PortalField"].blueportal:setColorTransform(0.3, 0.45, 1)
	arenasTable["PortalField"].blueportal:setAnchorPoint(0.5, 0.5)
	local textureW = arenasTable["PortalField"].blueportal:getWidth()
	local textureH = arenasTable["PortalField"].blueportal:getHeight()
	local posX = math.random(XShift + 100, XShift + WX - 100)
	local posY = math.random(15 + 100, WY - 15 - 100)
	arenasTable["PortalField"].blueportal:setScale(15/textureW, 100/textureH)
	arenasTable["PortalField"].blueportal:setPosition(posX, posY)
	fadeBitmapIn(arenasTable["PortalField"].blueportal, 100, 0.5)
	arena:addChild(arenasTable["PortalField"].blueportal)
	
	arenasTable["PortalField"].redportal = Bitmap.new(textures.paddle2)
	arenasTable["PortalField"].redportal:setScale(1, 1)
	arenasTable["PortalField"].redportal:setColorTransform(1, 0.6, 0.1)
	arenasTable["PortalField"].redportal:setAnchorPoint(0.5, 0.5)
	local textureW2 = arenasTable["PortalField"].redportal:getWidth()
	local textureH2 = arenasTable["PortalField"].redportal:getHeight()
	local posX2 = math.random(XShift + 100, XShift + WX - 100)
	local posY2 = math.random(15 + 100, WY - 15 - 100)
	while math.abs(posX2 - posX) < 60 and math.abs(posY2 - posY) < 50 do
		posX2 = math.random(XShift + 100, XShift + WX - 100)
		posY2 = math.random(15 + 100, WY - 15 - 100)
	end
	arenasTable["PortalField"].redportal:setScale(15/textureW, 100/textureH)
	arenasTable["PortalField"].redportal:setPosition(posX2, posY2)
	fadeBitmapIn(arenasTable["PortalField"].redportal, 100, 0.5)
	arena:addChild(arenasTable["PortalField"].redportal)
	
	-- Checks if ball passes through --
	local justteleported = false
	local teleports = 0
	arenasTable["PortalField"].checkball = function()
		if arena.ball.launched then
			local ballX, ballY = arena.ball.body:getPosition()
			if math.abs(ballX - posX) < 15 and math.abs(ballY - posY) < 50 and not justteleported then
				justteleported = true
				teleports = teleports + 1
				arena.ball.body:setPosition(posX2, posY2)
				if optionsTable["SFX"] == "On" then sounds.portal2:play() end
				Timer.delayedCall(200, function()
					justteleported = false
				end)
			end
			if math.abs(ballX - posX2) < 15 and math.abs(ballY - posY2) < 50 and not justteleported then
				justteleported = true
				teleports = teleports + 1
				arena.ball.body:setPosition(posX, posY)
				if optionsTable["SFX"] == "On" then sounds.portal2:play() end
				Timer.delayedCall(200, function()
					justteleported = false
				end)
			end
			if teleports > 15 then
				local function endPortal() end
				endPortal = arenasTable["PortalField"]["End"]
				local function initPortal() end
				initPortal= arenasTable["PortalField"]["Init"]
				endPortal()
				initPortal()
			end
		end
	end
	arena:addEventListener(Event.ENTER_FRAME, arenasTable["PortalField"].checkball)

end
arenasTable["PortalField"]["End"] = function()
	arena:removeEventListener(Event.ENTER_FRAME, arenasTable["PortalField"].checkball)
	for i = arena:getNumChildren(), 1, -1 do
		if arena:getChildAt(i) == arenasTable["PortalField"].blueportal then
			fadeBitmapOut(arenasTable["PortalField"].blueportal, 100, arena)
		end
		if arena:getChildAt(i) == arenasTable["PortalField"].redportal then
			fadeBitmapOut(arenasTable["PortalField"].redportal, 100, arena)
		end
	end
end