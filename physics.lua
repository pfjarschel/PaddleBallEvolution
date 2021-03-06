---------------------------------------------
-- Box2D Physics Related Functions & Stuff --
---------------------------------------------

-- Load Box2D library --
require "box2d"

-- Declare world and debugDraw --
world = nil
debugDraw = nil

-- Function to set physics up --
function goPhysics(scale)
	b2.setScale(scale)
	world = b2.World.new(0, 0)
	
	--debugDraw = b2.DebugDraw.new()
	--world:setDebugDraw(debugDraw)
	--stage:addChild(debugDraw)
	
	world:addEventListener(Event.BEGIN_CONTACT, contactHandler)
end
function stopPhysics()
	world = nil
end

-- Function to be called at each frame, updates ojects --
function updatePhysics()
	if world ~= nil then
		world:step(1/60, 8, 3)
		
		-- Iterate through all child sprites --
		for i = 1, arena:getNumChildren() do
			local sprite = arena:getChildAt(i)
			if sprite.body then
				if not(sprite.body.del) then
					local body = sprite.body
					local bodyX, bodyY = body:getPosition()
					sprite:setPosition(bodyX, bodyY)
					sprite:setRotation(body:getAngle() * 180 / math.pi)
				else
					if sprite.body ~= nil then
						world:destroyBody(sprite.body)
						sprite.body = nil
					end
				end
			end
		end
	end
end

-- This function calls appropriate object collision handler (always called "collide") --
function contactHandler(event)
	local body1 = event.fixtureA:getBody()
	local body2 = event.fixtureB:getBody()
	body1:collide(event)
	body2:collide(event)
end