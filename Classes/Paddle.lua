---------------------------
-- Class for the Paddles --
---------------------------

Paddle = Core.class(Sprite)

-- Declare stuff --
Paddle.bitmap = nil
Paddle.body = nil
Paddle.paddleW = 15
Paddle.basepaddleH = 75
Paddle.paddleH = 75
Paddle.textureH = 1
Paddle.textureW = 1
Paddle.side = 0
Paddle.atkFactor = 1
Paddle.defFactor = 1

-- Create physics stuff --
function Paddle:createBody()
	-- Would it be better to create a KNIETIC body? --
	local x, y = self:getPosition()
	self.body = world:createBody{
		type = b2.DYNAMIC_BODY,
		position = {x = x, y = y},
		angularDamping = 10000,
		linearDamping = 0.5
	}
	
	-- Propagate useful variables to body --
	self.body.name = "paddle" .. tostring(self.side)
	self.body.side = self.side
	self.body.paddleH = self.paddleH
	self.body.atkFactor = self.atkFactor
	
	local shape = b2.PolygonShape.new()
	shape:setAsBox(self.paddleW/2, self.paddleH/2, 0, 0, 0)
	self.body:createFixture{
		shape = shape, 
		density = 10000,
		restitution = 0, 
		friction = 0,
		fixedRotation = true,
	}
	self.body:setAngle(self.side*math.pi)
	
	-----------------------------------------------------------------------------------
	-- Collision hadler for when paddle collides with ball. Sets direction according --
	-- to collision point, speed depends on character ATK attribute. Delay (0) is    --
	-- necessary to avoid world lock, schedules action to next frame.                --
	-----------------------------------------------------------------------------------
	function self.body:collide(event)
		Timer.delayedCall(0, function()
			self:setAngle(self.side*math.pi)
			local body1 = event.fixtureA:getBody()
			local body2 = event.fixtureB:getBody()
			if body1.name == "ball" or body2.name == "ball" then
				local colX, colY = arena.ball.body:getPosition()
				local padX, padY = self:getPosition()
				local colDistY = colY - padY
				local setSpeed = arena.ball.baseSpeed*self.atkFactor
				local setVy = (colDistY*setSpeed)/(self.paddleH/2)
				local setVx = -2*(self.side - 0.5)*math.sqrt(math.abs(setSpeed*setSpeed - setVy*setVy))
				if self.side == 0 then
					if colY > (padY - self.paddleH/2 - arena.ball.radius/2) and colY < (padY + self.paddleH/2 + arena.ball.radius/2) and colX > padX then
						arena.ball.body:setLinearVelocity(setVx,setVy)
					end
				else
					if colY > (padY - self.paddleH/2 - arena.ball.radius/2) and colY < (padY + self.paddleH/2 + arena.ball.radius/2) and colX < padX then
						arena.ball.body:setLinearVelocity(setVx,setVy)
					end
				end
			end
		end)
	end
end

-- Reset position --
function Paddle:reset()
	arena:removeChild(self)
	self.body:setLinearVelocity(0,0)
	arena:addChild(self)
	self.body:setPosition(1.5*self.paddleW + self.side*(WX - self.paddleW*3), 0.5*WY)
end

-- Initialize --
function Paddle:init(side, atkFactor, defFactor)
	self.side = side
	self.atkFactor = atkFactor
	self.defFactor = defFactor
	self.paddleH = self.paddleH*defFactor
	
	-- Has to load separatedly from other textures (transforms? I don't know =/) --
	self.bitmap = Bitmap.new(Texture.new("imgs/paddle2.png"))
	
	self.bitmap:setScale(1, 1)
	self:addChild(self.bitmap)
	self.textureW = self.bitmap:getWidth()
	self.textureH = self.bitmap:getHeight()
	self.bitmap:setAnchorPoint(0.5, 0.5)
	self:setPosition(1.5*self.paddleW + side*(WX - self.paddleW*3), 0.5*WY)
	self.bitmap:setScale(self.paddleW/self.textureW, self.paddleH/self.textureH)
	self:setRotation(side*180)
	self.bitmap:setColorTransform(math.random(300, 1000)/1000, math.random(300, 1000)/1000, math.random(300, 1000)/1000, 1)
	self:createBody()
	arena:addChild(self)
end