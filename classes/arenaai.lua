--------------------------------------
-- Class for the Arena specific AIs --
--------------------------------------

ArenaAI = Core.class()
ArenaAI.class = ""
ArenaAI.chance = 500

function ArenaAI:init(class)
	self.class = class
end
function ArenaAI:basicCall()
	if self.class == "Warrior" then
		self:Warrior()
	end
	if self.class == "Acrobat" then
		self:Acrobat()
	end
	if self.class == "Ninja" then
		self:Ninja()
	end
	if self.class == "Swamp Monster" then
		self:SwampMonster()
	end
	if self.class == "Archer" then
		self:Archer()
	end
	if self.class == "Illusionist" then
		self:Illusionist()
	end
	if self.class == "Barbarian" then
		self:Barbarian()
	end
	if self.class == "Thief" then
		self:Thief()
	end
end
function ArenaAI:initSkill()
	arena.rightPlayer.char.skill:start(1)
	arena.rightPlayer.skillActive = true
	arena.mp1 = arena.mp1 - 1
	arena.combatStats:update(arena.score0, arena.score1, arena.mp0, arena.mp1)
end


-------------
-- Warrior --
-------------
function ArenaAI:Warrior()
	-- Activate only when ball is moving torwards him --
	local ballVx = arena.ball.body:getLinearVelocity()
	if 	arena.rightPlayer.skillActive == false and arena.mp1 > 0 and arena.ball.launched and ballVx > 0 then
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
	if 	arena.rightPlayer.skillActive == false and arena.mp1 > 0 and arena.ball.launched and ballVx < 0 and ballX < WX/2 then
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
	if 	arena.rightPlayer.skillActive == false and arena.mp1 > 0 and arena.ball.launched and ballVx < 0 and ballX > WX/2 then
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
	-- Activate only when ball is moving torwards him, after crossing the field. If distance is high, increase chance --
	local ballVx = arena.ball.body:getLinearVelocity()
	local ballX, ballY = arena.ball.body:getPosition()
	local paddleX, paddleY = arena.rightPlayer.paddle.body:getPosition()
	if 	arena.rightPlayer.skillActive == false and arena.mp1 > 0 and arena.ball.launched and ballVx > 0 and ballX > WX/2 then
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
	local epaddleX, epaddleY = arena.leftPlayer.paddle.body:getPosition()
	local epaddleSize = arena.leftPlayer.paddle.paddleH
	if 	arena.rightPlayer.skillActive == false and arena.mp1 > 0 and arena.ball.launched and ballVx < 0 and ballX < WX/2 and math.abs(ballY - epaddleY) > epaddleSize/2 then
		local num = math.random(1, self.chance/10)
		if num == 1 then
			self:initSkill()
		end
	end
end


-----------------
-- Illusionist --
-----------------
function ArenaAI:Illusionist()
	-- Activate only when ball is returned, before crossing, or if he is about to take a goal --
	local ballVx = arena.ball.body:getLinearVelocity()
	local ballX, ballY = arena.ball.body:getPosition()
	local paddleX, paddleY = arena.rightPlayer.paddle.body:getPosition()
	if 	(arena.rightPlayer.skillActive == false and arena.mp1 > 0 and arena.ball.launched) and ((ballVx > 0 and ballX < WX/2) or (ballVx > 0 and ballX > WX/4 and math.abs(ballY - paddleY) > WY/8) or (ballX > paddleX)) then
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
	if 	arena.rightPlayer.skillActive == false and arena.mp1 > 0 and arena.ball.launched then
		local num = math.random(1, self.chance)
		if num == 1 then
			self:initSkill()
		end
	end
end

-------------
-- Thief --
-------------
function ArenaAI:Thief()
	-- Activate only when ball is moving torwards him --
	local ballVx = arena.ball.body:getLinearVelocity()
	local ballX = arena.ball.body:getPosition()
	if 	arena.rightPlayer.skillActive == false and arena.mp1 > 0 and arena.ball.launched and ballVx > 0 and ballX > WX/2 then
		local num = math.random(1, self.chance/8)
		if num == 1 then
			self:initSkill()
		end
	end
end

