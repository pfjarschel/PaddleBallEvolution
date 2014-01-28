--------------------------------------
-- Class for the Arena specific AIs --
--------------------------------------

ArenaAI = Core.class()
ArenaAI.class = ""
ArenaAI.side = nil
ArenaAI.chance = 500

function ArenaAI:init(class)
	self.class = class
	self.chance = 500/arena.difFactor
	if optionsTable["ArenaSide"] == "Left" then
		self.side = 1
	else
		self.side = -1
	end
end
function ArenaAI:basicCall()
	if ((self.side == 1 and arena.mp1 > 0) or (self.side == -1 and arena.mp0 > 0)) and arena.aiPlayer.skillActive == false and arena.ball.launched then
		if self.class == "Warrior" then
			self:Warrior()
		end
		if self.class == "Acrobat" then
			self:Acrobat()
		end
		if self.class == "Ninja" then
			self:Ninja()
		end
		if self.class == "SwampMonster" then
			self:SwampMonster()
		end
		if self.class == "Archer" then
			self:Archer()
		end
		if self.class == "Mesmer" then
			self:Mesmer()
		end
		if self.class == "Barbarian" then
			self:Barbarian()
		end
		if self.class == "Thief" then
			self:Thief()
		end
		if self.class == "Illusionist" then
			self:Illusionist()
		end
		if self.class == "IceMan" then
			self:IceMan()
		end
	end
end
function ArenaAI:initSkill()
	if optionsTable["ArenaSide"] == "Left" then
		arena.aiPlayer.char.skill:start(1)
		arena.aiPlayer.skillActive = true
		arena.mp1 = arena.mp1 - 1
	else
		arena.aiPlayer.char.skill:start(0)
		arena.aiPlayer.skillActive = true
		arena.mp0 = arena.mp0 - 1
	end
	arena.combatStats:update(arena.score0, arena.score1, arena.mp0, arena.mp1)
end


-------------
-- Warrior --
-------------
function ArenaAI:Warrior()
	-- Activate only when ball is moving torwards him --
	local ballVx = arena.ball.body:getLinearVelocity()
	if self.side*ballVx > 0 then
		local num = math.random(1, self.chance)
		if num == 1 then
			self:initSkill()
		end
	end
end


-------------
-- Acrobat --
-------------
function ArenaAI:Acrobat()
	-- Activate only when ball is moving away form him, and close to goal --
	local ballVx = arena.ball.body:getLinearVelocity()
	local ballX = arena.ball.body:getPosition()
	if self.side*ballVx < 0 and self.side*(ballX - WX/2 - XShift) < 0 then
		local num = math.random(1, self.chance/2)
		if num == 1 then
			self:initSkill()
		end
	end
end


-----------
-- Ninja --
-----------
function ArenaAI:Ninja()
	-- Activate only when ball is moving away from him, before crossing the field --
	local ballVx = arena.ball.body:getLinearVelocity()
	local ballX = arena.ball.body:getPosition()
	if self.side*ballVx < 0 and self.side*(ballX - WX/2 - XShift) > 0 then
		local num = math.random(1, self.chance/4)
		if num == 1 then
			self:initSkill()
		end
	end
end


-------------------
-- Swamp Monster --
-------------------
function ArenaAI:SwampMonster()
	-- Activate only when ball is moving torwards him, after crossing the field. If distance is high, increase chance. Ball must be fast --
	local ballVx, ballVy = arena.ball.body:getLinearVelocity()
	local ballX, ballY = arena.ball.body:getPosition()
	local paddleX, paddleY = arena.aiPlayer.paddle.body:getPosition()
	
	local ballV0 = math.sqrt(ballVx*ballVx + ballVy*ballVy)
	
	if self.side*ballVx > 0 and self.side*(ballX - WX/2 - XShift) > 0 and ballV0 > arena.ball.baseSpeed/9 then
		local num = 0
		if math.abs(ballY - paddleY) > WY/2 then
			num = math.random(1, self.chance/5)
		else
			num = math.random(1, self.chance/2)
		end
		if num == 1 then
			self:initSkill()
		end
	end
end


------------
-- Archer --
------------
function ArenaAI:Archer()
	-- Activate only when ball is moving away form him, close to the goal, and the path is clear --
	local ballVx = arena.ball.body:getLinearVelocity()
	local ballX, ballY = arena.ball.body:getPosition()
	local epaddleX, epaddleY = arena.humanPlayer.paddle.body:getPosition()
	local epaddleSize = arena.humanPlayer.paddle.paddleH
	if self.side*ballVx < 0 and self.side*(ballX - WX/2 - XShift) < 0 and math.abs(ballY - epaddleY) > epaddleSize/2 then
		local num = math.random(1, self.chance/5)
		if num == 1 then
			self:initSkill()
		end
	end
end


-----------
-- Mesmer --
-----------
function ArenaAI:Mesmer()
	-- Activate only when ball is returned, before crossing, or if he is about to take a goal --
	local ballVx = arena.ball.body:getLinearVelocity()
	local ballX, ballY = arena.ball.body:getPosition()
	local paddleX, paddleY = arena.aiPlayer.paddle.body:getPosition()
	if (self.side*ballVx > 0 and self.side*(ballX - WX/2 - XShift) < 0) or (self.side*ballVx > 0 and self.side*(ballX - 2*WX/4 - self.side*WX/4 - XShift) > 0 and math.abs(ballY - paddleY) > WY/8) or (self.side*ballX > self.side*paddleX) then
		local num = math.random(1, self.chance/4)
		if num == 1 then
			self:initSkill()
		end
	end
end


---------------
-- Barbarian --
---------------
function ArenaAI:Barbarian()
	-- Activate any time --
	local num = math.random(1, self.chance)
	if num == 1 then
		self:initSkill()
	end
end

-----------
-- Thief --
-----------
function ArenaAI:Thief()
	-- Activate only when ball is moving torwards him --
	local ballVx = arena.ball.body:getLinearVelocity()
	local ballX = arena.ball.body:getPosition()
	if self.side*ballVx > 0 and self.side*(ballX - WX/2 - XShift) > 0 then
		local num = math.random(1, self.chance/8)
		if num == 1 then
			self:initSkill()
		end
	end
end


-----------------
-- Illusionist --
-----------------
function ArenaAI:Illusionist()
	-- Activate only when ball is moving away from him --
	local ballVx, ballVy = arena.ball.body:getLinearVelocity()
	--local ballX = arena.ball.body:getPosition()
	if self.side*ballVx < 0 then
		local num = math.random(1, self.chance/4)
		if num == 1 then
			self:initSkill()
		end
	end
end


-------------
-- Ice Man --
-------------
function ArenaAI:IceMan()
	-- Activate only when ball is moving away from him --
	local ballVx, ballVy = arena.ball.body:getLinearVelocity()
	--local ballX = arena.ball.body:getPosition()
	if self.side*ballVx < 0 then
		local num = math.random(1, self.chance/4)
		if num == 1 then
			self:initSkill()
		end
	end
end

