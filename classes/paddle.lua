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
Paddle.fixture = nil
Paddle.shape = nil

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
	self.body.name = "paddle"..tostring(self.side)
	self.body.side = self.side
	self.body.paddleH = self.paddleH
	self.body.paddleW = self.paddleW
	self.body.atkFactor = self.atkFactor
	
	self.shape = b2.PolygonShape.new()
	self.shape:setAsBox(self.paddleW/2, self.paddleH/2, 0, 0, 0)
	self.fixture = self.body:createFixture{
		shape = self.shape, 
		density = 10000,
		restitution = 0, 
		friction = 0,
		fixedRotation = true,
	}
	self.fixture:setFilterData({categoryBits = 2, maskBits = 5, groupIndex = 0})
	self.body:setAngle(self.side*math.pi)
	
	-----------------------------------------------------------------------------------
	-- Collision hadler for when paddle collides with ball. Sets direction according --
	-- to collision point, speed depends on character ATK attribute. Delay (0) is    --
	-- necessary to avoid world lock, schedules action to next frame.                --
	-----------------------------------------------------------------------------------
	function self.body:collide(event)
		local body1 = event.fixtureA:getBody()
		local body2 = event.fixtureB:getBody()
		Timer.delayedCall(0, function()
			self:setAngle(self.side*math.pi)
			if body1.name == "ball" or body2.name == "ball" then
				local colX, colY = arena.ball.body:getPosition()
				local padX, padY = self:getPosition()
				local colDistY = colY - padY
				local setSpeed = arena.ball.baseSpeed*self.atkFactor
				local setVy = 0.97*(colDistY*setSpeed)/(self.paddleH/2)
				local setVx = -2*(self.side - 0.5)*math.sqrt(math.abs(setSpeed*setSpeed - setVy*setVy))
				if self.side == 0 then
					if colY > (padY - self.paddleH/2 - 1.2*arena.ball.radius) and colY < (padY + self.paddleH/2 + 1.2*arena.ball.radius)
					and colX > padX - self.paddleW/2 then
						arena.ball.body:setLinearVelocity(setVx,setVy)
					end
				else
					if colY > (padY - self.paddleH/2 - 1.2*arena.ball.radius) and colY < (padY + self.paddleH/2 + 1.2*arena.ball.radius)
					and colX < padX + self.paddleW/2 then
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
	self.body:setPosition(XShift + 1.5*self.paddleW + self.side*(WX - self.paddleW*3), 0.5*WY)
	arena.leftPlayer.touchY = WY/2
	arena.rightPlayer.touchY = WY/2
end

-- Initialize --
function Paddle:init(side, atkFactor, defFactor)
	self.side = side
	self.atkFactor = atkFactor
	self.defFactor = defFactor
	self.paddleH = self.paddleH*defFactor
	
	self.bitmap = Bitmap.new(textures.paddle2)
	
	self.bitmap:setScale(1, 1)
	self:addChild(self.bitmap)
	self.textureW = self.bitmap:getWidth()
	self.textureH = self.bitmap:getHeight()
	self.bitmap:setAnchorPoint(0.5, 0.5)
	self:setPosition(XShift + 1.5*self.paddleW + side*(WX - self.paddleW*3), 0.5*WY)
	self.bitmap:setScale(self.paddleW/self.textureW, self.paddleH/self.textureH)
	self:setRotation(side*180)
	self.bitmap:setColorTransform(math.random(200, 1000)/1000, math.random(200, 1000)/1000, math.random(200, 1000)/1000, 1)
	self:createBody()
	arena:addChild(self)
end