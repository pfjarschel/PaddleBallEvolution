--------------------------------------
-- Class for the Arena specific AIs --
--------------------------------------

ArenaAI = Core.class()
ArenaAI.skill = ""
ArenaAI.side = nil
ArenaAI.chance = 500

function ArenaAI:init(skill)
	self.skill = skill
	self.chance = 500/arena.difFactor
	if optionsTable["ArenaSide"] == "Left" then
		self.side = 1
	else
		self.side = -1
	end
end
function ArenaAI:basicCall()
	if ((self.side == 1 and arena.mp1 > 0) or (self.side == -1 and arena.mp0 > 0)) and arena.aiPlayer.skillActive == false and arena.ball.launched then
		if self.skill == "noskill" then
			self:noskill()
		end
		if self.skill == "powershot" then
			self:powershot()
		end
		if self.skill == "curveball" then
			self:curveball()
		end
		if self.skill == "invisiball" then
			self:invisiball()
		end
		if self.skill == "viscousfield" then
			self:viscousfield()
		end
		if self.skill == "arrowball" then
			self:arrowball()
		end
		if self.skill == "multiball" then
			self:multiball()
		end
		if self.skill == "berserk" then
			self:berserk()
		end
		if self.skill == "steal" then
			self:steal()
		end
		if self.skill == "mirrorball" then
			self:mirrorball()
		end
		if self.skill == "freeze" then
			self:freeze()
		end
		if self.skill == "predict" then
			self:predict()
		end
		if self.skill == "fireball" then
			self:fireball()
		end
		if self.skill == "bite" then
			self:bite()
		end
		if self.skill == "dispel" then
			self:dispel()
		end
		if self.skill == "headshrink" then
			self:headshrink()
		end
		if self.skill == "charge" then
			self:charge()
		end
		if self.skill == "bet" then
			self:bet()
		end
		if self.skill == "reversetime" then
			self:reversetime()
		end
		if self.skill == "poison" then
			self:poison()
		end
		if self.skill == "shine" then
			self:shine()
		end
		if self.skill == "charm" then
			self:charm()
		end
		if self.skill == "confuse" then
			self:confuse()
		end
		if self.skill == "web" then
			self:web()
		end
		if self.skill == "portal" then
			self:portal()
		end
		if self.skill == "telekinesis" then
			self:telekinesis()
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


--------------
-- No Skill --
--------------
function ArenaAI:noskill()
	
end


----------------
-- Power Shot --
----------------
function ArenaAI:powershot()
	-- Activate only when ball is moving torwards him --
	local ballVx = arena.ball.body:getLinearVelocity()
	if self.side*ballVx > 0 then
		local num = math.random(1, self.chance/2)
		if num == 1 then
			self:initSkill()
		end
	end
end


----------------
-- Curve Ball --
----------------
function ArenaAI:curveball()
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


----------------
-- Invisiball --
----------------
function ArenaAI:invisiball()
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
-- Viscous Field --
-------------------
function ArenaAI:viscousfield()
	-- Activate only when ball is moving torwards him, after crossing the field. If distance is high, increase chance. Ball must be fast --
	local ballVx, ballVy = arena.ball.body:getLinearVelocity()
	local ballX, ballY = arena.ball.body:getPosition()
	local paddleX, paddleY = arena.aiPlayer.paddle.body:getPosition()
	
	local ballV0 = math.sqrt(ballVx*ballVx + ballVy*ballVy)
	
	if self.side*ballVx > 0 and self.side*(ballX - WX/2 - XShift) > 0 and ballV0 > arena.ball.baseSpeed/9 then
		local num = 0
		if math.abs(ballY - paddleY) > WY/2 then
			num = math.random(1, self.chance/3)
		else
			num = math.random(1, self.chance)
		end
		if num == 1 then
			self:initSkill()
		end
	end
end


----------------
-- Arrow Ball --
----------------
function ArenaAI:arrowball()
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


-----------------
-- Mirror Ball --
-----------------
function ArenaAI:mirrorball()
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


-------------
-- Berserk --
-------------
function ArenaAI:berserk()
	-- Activate any time --
	local num = math.random(1, self.chance)
	if num == 1 then
		self:initSkill()
	end
end

-----------
-- Steal --
-----------
function ArenaAI:steal()
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


---------------
-- Multiball --
---------------
function ArenaAI:multiball()
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


------------
-- Freeze --
------------
function ArenaAI:freeze()
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
-- Predict --
-------------
function ArenaAI:predict()
	-- Activate only when ball is moving torwards him, before crossing --
	local ballVx = arena.ball.body:getLinearVelocity()
	local ballX = arena.ball.body:getPosition()
	if self.side*ballVx > 0 and self.side*(ballX - WX/2 - XShift) < 0 then
		local num = math.random(1, self.chance/8)
		if num == 1 then
			self:initSkill()
		end
	end
end


--------------
-- Fireball --
--------------
function ArenaAI:fireball()
	-- Activate any time --
	local num = math.random(1, self.chance/2)
	if num == 1 then
		self:initSkill()
	end
end


----------
-- Bite --
----------
function ArenaAI:bite()
	-- Activate any time, if opponent mp > 0 and no skill active --
	local num = math.random(1, self.chance/4)
	if num == 1 and arena.mp0 > 0 and arena.mp1 > 0 and (not arena.aiPlayer.skillActive) and (not arena.humanPlayer.skillActive) then
		self:initSkill()
	end
end


------------
-- Dispel --
------------
function ArenaAI:dispel()
	-- Activate when opponent activates ability --
	if arena.humanPlayer.skillActive then
		local num = math.random(1, self.chance/10)
		if num == 1 then
			self:initSkill()
		end
	end
end


----------------
-- Headshrink --
----------------
function ArenaAI:headshrink()
	-- Activate any time --
	local num = math.random(1, self.chance/2)
	if num == 1 then
		self:initSkill()
	end
end


------------
-- Charge --
------------
function ArenaAI:charge()
	-- Activate when ball going away --
	local ballVx = arena.ball.body:getLinearVelocity()
	if self.side*ballVx < 0 then
		local num = math.random(1, self.chance/4)
		if num == 1 then
			self:initSkill()
		end
	end
end


---------
-- Bet --
---------
function ArenaAI:bet()
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


------------------
-- Reverse Time --
------------------
function ArenaAI:reversetime()
	-- Activate only when ball is moving torwards him, after crossing the field. If distance is high, increase chance. --
	local ballVx, ballVy = arena.ball.body:getLinearVelocity()
	local ballX, ballY = arena.ball.body:getPosition()
	local paddleX, paddleY = arena.aiPlayer.paddle.body:getPosition()
	
	if self.side*ballVx > 0 and self.side*(ballX - WX/2 - XShift) > 0 then
		local num = 0
		if math.abs(ballY - paddleY) > WY/2 then
			num = math.random(1, self.chance/5)
		else
			num = math.random(1, self.chance)
		end
		if num == 1 then
			self:initSkill()
		end
	end
end


------------
-- Poison --
------------
function ArenaAI:poison()
	-- Activate any time, if opponent mp > 0 and no skill active --
	local num = math.random(1, self.chance/4)
	if num == 1 and arena.mp0 > 0 and arena.mp1 > 0 and (not arena.aiPlayer.skillActive) and (not arena.humanPlayer.skillActive) then
		self:initSkill()
	end
end


-----------
-- Shine --
-----------
function ArenaAI:shine()
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


-----------
-- Charm --
-----------
function ArenaAI:charm()
	-- Activate only when ball is moving away from her, before crossing the field --
	local ballVx = arena.ball.body:getLinearVelocity()
	local ballX = arena.ball.body:getPosition()
	if self.side*ballVx < 0 and self.side*(ballX - WX/2 - XShift) > 0 then
		local num = math.random(1, self.chance/6)
		if num == 1 then
			self:initSkill()
		end
	end
end


-------------
-- Confuse --
-------------
function ArenaAI:confuse()
	-- Activate only when ball is moving away form him, and close to goal --
	local ballVx = arena.ball.body:getLinearVelocity()
	local ballX = arena.ball.body:getPosition()
	if self.side*ballVx < 0 and self.side*(ballX - WX/2 - XShift) < 0 then
		local num = math.random(1, self.chance/4)
		if num == 1 then
			self:initSkill()
		end
	end
end


-----------
-- Web --
-----------
function ArenaAI:web()
	-- Activate only when ball is moving torwards him --
	local ballVx = arena.ball.body:getLinearVelocity()
	local ballX = arena.ball.body:getPosition()
	if self.side*ballVx > 0 and self.side*(ballX - WX/2 - XShift) > 0 then
		local num = math.random(1, self.chance/4)
		if num == 1 then
			self:initSkill()
		end
	end
end


------------
-- Portal --
------------
function ArenaAI:portal()
	-- Activate only when ball is moving torwards him --
	local ballVx = arena.ball.body:getLinearVelocity()
	local ballX = arena.ball.body:getPosition()
	if self.side*ballVx > 0 and self.side*(ballX - WX/2 - XShift) > 0 then
		local num = math.random(1, self.chance/4)
		if num == 1 then
			self:initSkill()
		end
	end
end


-----------------
-- Telekinesis --
-----------------
function ArenaAI:telekinesis()
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