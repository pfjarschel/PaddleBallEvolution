-------------------------------------
-- Table Containing Special Arenas --
-------------------------------------


-- Normal --
arenasTable["Normal"] = {}
arenasTable["Normal"]["Desc"] = "The normal PaddleBall Arena. No Special Effects"
arenasTable["Normal"]["Image"] = "none"
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
	local chance = 15
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
		if randSide == 2 then
			paddleX, paddleY = arena.rightPlayer.paddle.body:getPosition()
			paddleH = arena.rightPlayer.paddle.paddleH
			paddleW = arena.rightPlayer.paddle.paddleW
		else
			paddleX, paddleY = arena.leftPlayer.paddle.body:getPosition()
			paddleH = arena.leftPlayer.paddle.paddleH
			paddleW = arena.leftPlayer.paddle.paddleW
		end
		arenasTable["Lava"].flame = Bitmap.new(textures.gfx_flame)
		arenasTable["Lava"].flame:setScale(1, 1)
		arenasTable["Lava"].flame:setAnchorPoint(0.5, 0.5)
		arena:addChild(arenasTable["Lava"].flame)
		local textureW = arenasTable["Lava"].flame:getWidth()
		local textureH = arenasTable["Lava"].flame:getHeight()
		arenasTable["Lava"].flame:setScale((paddleW*3)/textureW, (paddleH*1.5)/textureH)
		arenasTable["Lava"].flame:setPosition(paddleX, paddleY)
		fadeBitmapIn(arenasTable["Lava"].flame, 500, 0.5)
		Timer.delayedCall(500, function()
			fadeBitmapOut(arenasTable["Lava"].flame, 500, arena)
		end)
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
	
	for i = arena:getNumChildren(), 1, -1 do
		if arena:getChildAt(i) == arenasTable["Lava"].flame then
			fadeBitmapOut(arenasTable["Lava"].flame, 100, arena)
		end
	end
end

-- Ice --
arenasTable["Ice"] = {}
arenasTable["Ice"]["Desc"] = "Paddles can randomly freeze"
arenasTable["Ice"]["Image"] = "imgs/backs/arenas/ice.png"
arenasTable["Ice"]["timer"] = Timer.new(2000, 0)
arenasTable["Ice"]["onTimer"] = function()
	local chance = 8
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
	arenasTable["Lava"]["timer"]:removeEventListener(Event.TIMER, arenasTable["Lava"]["onTimer"])
	arenasTable["Lava"]["timer"]:stop()
	
	arena.rightPlayer.char:updateAttr()
	arena.leftPlayer.char:updateAttr()
	
	for i = arena:getNumChildren(), 1, -1 do
		if arena:getChildAt(i) == arenasTable["Ice"].freeze then
			fadeBitmapOut(arenasTable["Ice"].freeze, 100, arena)
		end
	end
end