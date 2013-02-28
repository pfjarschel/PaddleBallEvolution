--------------------------------------
-- Class for the Classic Mode Arena --
--------------------------------------

ArenaClassic = Core.class(Sprite)

-- Declare Stuff --
ArenaClassic.bitmap = nil
ArenaClassic.bounds = nil
ArenaClassic.score0 = 0
ArenaClassic.score1 = 0
ArenaClassic.difFactor = 5/5 -- 1/5 to 10/5
ArenaClassic.paused = false
ArenaClassic.font = nil

-- Main Match Loop --
local function onEnterFrame()
	updatePhysics()
	arena.leftPlayer:aiMove()
	arena.leftPlayer:humanMove()
	arena.rightPlayer:aiMove()
	arena.rightPlayer:humanMove()
	arena:checkGoal()
end

-- Create physics stuff (including collision handler) --
function ArenaClassic:createBoundaries()
	
	-- Default is Static --
	self.bounds = world:createBody({})
	
	self.bounds.name = "bounds"
	local shapeT = b2.EdgeShape.new(-200, WBounds, WX + 200, WBounds)
	local shapeB = b2.EdgeShape.new(-200, WY-WBounds, WX + 200, WY-WBounds)
	self.bounds:createFixture{
		shape = shapeT, 
		friction = 0,
	}
	self.bounds:createFixture{
		shape = shapeB, 
		friction = 0,
	}
	
	-- Collision Handler --
	function self.bounds:collide(event)
		--print("bounds")
	end
end

-- This function creates the in-game menu --
function ArenaClassic:addMenu()
	local menuBut = MenuBut.new(textures.menuBut, 60, 60)
	menuBut.bitmap:setPosition(WX - menuBut.bitmap:getWidth()/2, WY - menuBut.bitmap:getHeight()/2)
	menuBut:setAlpha(0.4)
	self:addChild(menuBut)
	menuBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if menuBut:hitTestPoint(event.touch.x, event.touch.y) then
			event:stopPropagation()
			if not self.paused then
				self.paused = true
				self:removeEventListener(Event.ENTER_FRAME, onEnterFrame)
				
				local pausebg = Sprite:new()
				pausebg:addChild(textures.pausebg)
				
				local resumeBut = MenuBut.new(textures.returnBut, 150, 40)
				resumeBut.bitmap:setPosition(WX/2, WY/2 - resumeBut:getHeight())
				resumeBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
					if resumeBut:hitTestPoint(event.touch.x, event.touch.y) then
						event:stopPropagation()
						stage:removeChild(pausebg)
						self.paused = false
						self:addEventListener(Event.ENTER_FRAME, onEnterFrame)
					end
				end)
				pausebg:addChild(resumeBut)
				
				local quitBut = MenuBut.new(textures.exitBut, 150, 40)
				quitBut.bitmap:setPosition(WX/2, WY/2 + quitBut:getHeight())
				quitBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
					if quitBut:hitTestPoint(event.touch.x, event.touch.y) then
						event:stopPropagation()
						stage:removeChild(pausebg)
						world:destroyBody(self.ball.body)
						self.ball.body = nil
						world:destroyBody(self.leftPlayer.paddle.body)
						world:destroyBody(self.rightPlayer.paddle.body)
						world:destroyBody(self.bounds)
						self = nil
						arena = nil
						sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear)
					end
				end)
				pausebg:addChild(quitBut)
				
				stage:addChild(pausebg)
			end
		end
	end)
end

-- Function to Handle the End of the Match -- 
function ArenaClassic:gameOver()
	self:removeEventListener(Event.ENTER_FRAME, onEnterFrame)
	fadeOut(self)
	
	local gameOverString = nil
	if self.score0 > self.score1 then
		gameOverString = "Congratulations, you won!"
		sounds.win:play()
	else
		gameOverString = "You lost... :("
		sounds.lose:play()
	end
	local gameOverTextBox = TextField.new(self.font, gameOverString)
	gameOverTextBox:setTextColor(0x3c78a0)
	gameOverTextBox:setPosition(0.5*WX - gameOverTextBox:getWidth()/2, 0.25*WY + gameOverTextBox:getHeight()/2)
	
	local againBut = MenuBut.new(textures.againBut, 150, 40)
	againBut.bitmap:setPosition(WX/2, WY/2 + 100)
	local returnBut = MenuBut.new(textures.returnBut, 150, 40)
	returnBut.bitmap:setPosition(returnBut:getWidth()/2 + 10, WY/2 + 210)
	
	againBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if againBut:hitTestPoint(event.touch.x, event.touch.y) then
			stage:removeChild(gameOverTextBox)
			stage:removeChild(returnBut)
			stage:removeChild(againBut)
			world:destroyBody(self.ball.body)
			self.ball.body = nil
			world:destroyBody(self.leftPlayer.paddle.body)
			world:destroyBody(self.rightPlayer.paddle.body)
			world:destroyBody(self.bounds)
			local difficulty = self.difFactor*5
			self = nil
			arena = nil
			sceneMan:changeScene("classic", transTime, SceneManager.fade, easing.linear, { userData = difficulty })
		end
	end)
	
	returnBut:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if returnBut:hitTestPoint(event.touch.x, event.touch.y) then
			event:stopPropagation()
			stage:removeChild(gameOverTextBox)
			stage:removeChild(returnBut)
			stage:removeChild(againBut)
			world:destroyBody(self.ball.body)
			self.ball.body = nil
			world:destroyBody(self.leftPlayer.paddle.body)
			world:destroyBody(self.rightPlayer.paddle.body)
			world:destroyBody(self.bounds)
			self = nil
			arena = nil
			sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
		end
	end)
	
	Timer.delayedCall(transTime/2, function ()
		stage:addChild(gameOverTextBox)	
		stage:addChild(returnBut)
		stage:addChild(againBut)
	end)
end

-- Function to check and handle goals --
function ArenaClassic:checkGoal()
	local ballX, ballY = self.ball.body:getPosition()
	
	local function updateOrReset()
		if self.score0 >= 10 or self.score1 >= 10 then
			self:gameOver()
		else
			self.combatStats:update(self.score0, self.score1)
			self.ball:reset()
			self.ball:launch()
			self.leftPlayer.paddle:reset()
			self.rightPlayer.paddle:reset()
			gc()
		end
	end
	
	if ballX > WX + 2*self.ball.radius then
		self.score0 = self.score0 + 1
		sounds.goal1:play()
		updateOrReset()
	elseif ballX <  -2*self.ball.radius then
		self.score1 = self.score1 + 1
		sounds.goal2:play()
		updateOrReset()
	end
end

-- Initialization --
function ArenaClassic:init(difficulty)
	arena = self
	self.font = fonts.arialroundedBig
	self.bitmap = textures.pongbg
	self.bitmap:setScale(1, 1)
	self.difFactor = difficulty/5
	self:addChild(self.bitmap)
	local textureW = self.bitmap:getWidth()
	local textureH = self.bitmap:getHeight()
	self.bitmap:setScale(WX/textureW, WY/textureH)
	
	self:addMenu()
	
	self:createBoundaries()
	
	self.ball = Ball.new(self.difFactor)
	self.leftPlayer = Player.new(0, true, self.difFactor, "classic")
	self.rightPlayer = Player.new(1, false, self.difFactor, "classic")
	self.combatStats = CombatStats.new()
	self.combatStats:update(self.score0,self.score1)
	self.ball:reset()
	
	self:addEventListener("enterEnd", function()
		self.ball:launch()
	end)
	self:addEventListener(Event.ENTER_FRAME, onEnterFrame)
end