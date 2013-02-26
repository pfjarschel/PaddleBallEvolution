------------------------
-- Class for The Ball --
------------------------

Ball = Core.class(Sprite)

-- Declare stuff --
Ball.bitmap = nil
Ball.body = nil
Ball.radius = 10
Ball.baseSpeed = 20
Ball.difFactor = 1
Ball.launched = false

-- Create Physics stuff --
function Ball:createBody()
	local x, y = self:getPosition()
	self.body = world:createBody{
		type = b2.DYNAMIC_BODY,
		position = {x = x, y = y},
		bullet = true
	}
	self.body.name = "ball"
	
	local shape = b2.CircleShape.new(0, 0, self.radius)
	self.body:createFixture{
		shape = shape,
		density = 1,
		restitution = 1, 
		friction = 0,
	}
	
	--------------------------------------------------------------------------------
	-- Collision handler. Play different souds depending on second collision body --
	-- and sets new AI random factor. If X velocity is too small, increases it.   --
	--------------------------------------------------------------------------------
	function self.body:collide(event)
		local body1 = event.fixtureA:getBody()
		local body2 = event.fixtureB:getBody()
		if body1.name == "paddle" or body2.name == "paddle" then
			sounds.hit2:play()
		else
			sounds.hit1:play()
		end
		arena.leftPlayer:aiRandomFactor()
		arena.rightPlayer:aiRandomFactor()
		
		local ballVx, ballVy = self:getLinearVelocity()
		if ballVx == 0 then ballVx = 0.01 end
		if math.abs(ballVx) < arena.ball.baseSpeed/10 then
			self:setLinearVelocity((ballVx/math.abs(ballVx))*arena.ball.baseSpeed/10, ballVy)
		end
	end
end

-- Reset to random position --
function Ball:reset()
	self.body:setLinearVelocity(0,0)
	local startY = math.random(WBounds + self.radius + 1, WY - WBounds - self.radius - 1)
	self.body:setPosition(WX/2, startY)
	self.launched = false
end

-- Launch Ball --
function Ball:launch()
	local vx0 = 0
	while math.abs(vx0) < self.baseSpeed/4 do 
		vx0 = math.random(-self.baseSpeed*0.8, self.baseSpeed*0.8)
	end
	local vy0 = math.sqrt(self.baseSpeed*self.baseSpeed - vx0*vx0)
	local direction = math.pow(-1, math.random(1,10000))
	local launchTime = math.random(300, 3000)
	Timer.delayedCall(launchTime, function ()
		if self.body ~= nil then
			self.body:setLinearVelocity(vx0, direction*vy0)
			self.launched = true
		end
	end)
end

-- Initialize --
function Ball:init(difFactor)
	self.bitmap = textures.pongball
	self.bitmap:setScale(1, 1)
	self.difFactor = difFactor
	self.baseSpeed = self.baseSpeed*(0.7 + self.difFactor*0.9)
	self:addChild(self.bitmap)
	local textureW = self.bitmap:getWidth()
	local textureH = self.bitmap:getHeight()
	self.bitmap:setAnchorPoint(0.5, 0.5)
	self.bitmap:setScale(self.radius*2/textureW, self.radius*2/textureH)
	self:setPosition(0.5*WX, 0.5*WY)
	self.bitmap:setColorTransform(math.random(300, 1000)/1000, math.random(300, 1000)/1000, math.random(300, 1000)/1000, 1)
	self:createBody()
	arena:addChild(self)
end