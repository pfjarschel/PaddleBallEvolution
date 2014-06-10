-----------------------------------------------------
-- Class for the Text During Matches (HP, MP, etc) --
-----------------------------------------------------

CombatStats = Core.class()

-- Declare stuff --
CombatStats.font = nil
CombatStats.hp1Text = nil
CombatStats.hp2Text = nil
CombatStats.mp1Text = nil
CombatStats.mp2Text = nil

-- Function to update score --
function CombatStats:update(hp1, hp2, mp1, mp2)
	arena:removeChild(self.hp1Text)
	arena:removeChild(self.hp2Text)
	
	self.hp1Text = TextField.new(self.font, tostring(hp1))
	self.hp1Text:setTextColor(0xffffff)
	self.hp1Text:setPosition(XShift + 0.5*WX - self.hp1Text:getWidth() - 16, self.hp1Text:getHeight() + 24)
	
	self.hp2Text = TextField.new(self.font, tostring(hp2))
	self.hp2Text:setTextColor(0xffffff)
	self.hp2Text:setPosition(XShift + 0.5*WX + 16, self.hp2Text:getHeight() + 24)
	
	arena:addChild(self.hp1Text)
	arena:addChild(self.hp2Text)
	
	if arena.name == "arena" then
		arena:removeChild(self.mp1Text)
		arena:removeChild(self.mp2Text)
		
		self.mp1Text = TextField.new(self.smallFont, tostring(mp1))
		self.mp1Text:setTextColor(0xaa99ff)
		self.mp1Text:setPosition(XShift + 0.5*WX - 16 - self.mp1Text:getWidth(), 3*self.hp1Text:getHeight())
		
		self.mp2Text = TextField.new(self.smallFont, tostring(mp2))
		self.mp2Text:setTextColor(0xaa99ff)
		self.mp2Text:setPosition(XShift + 0.5*WX + 16, 3*self.hp1Text:getHeight())
		
		arena:addChild(self.mp1Text)
		arena:addChild(self.mp2Text)
		
		if optionsTable["ArenaSide"] == "Left" then
			if arena.mp0 == 0 or arena.leftPlayer.skillActive or arena.leftPlayer.char.skill.skill == "noskill" then 
				arena.skillBut:setAlpha(0.1)
			else
				arena.skillBut:setAlpha(0.4)
			end
		else
			if arena.mp1 == 0 or arena.rightPlayer.skillActive  or arena.rightPlayer.char.skill.skill == "noskill" then
				arena.skillBut:setAlpha(0.1)
			else
				arena.skillBut:setAlpha(0.4)
			end		
		end
	end
end

-- Initialize score texts --
function CombatStats:init()
	self.font = fonts.anitaBig
	self.smallFont = fonts.anitaSmall

	local initStr = "--"
	
	self.hp1Text = TextField.new(self.font, initStr)
	self.hp1Text:setTextColor(0xffffff)
	self.hp1Text:setPosition(XShift + 0.5*WX - self.hp1Text:getWidth() - 16, self.hp1Text:getHeight() + 24)
	
	self.hp2Text = TextField.new(self.font, initStr)
	self.hp2Text:setTextColor(0xffffff)
	self.hp2Text:setPosition(XShift + 0.5*WX + 16, self.hp2Text:getHeight() + 24)
		
	arena:addChild(self.hp1Text)
	arena:addChild(self.hp2Text)
	
	if arena.name == "arena" then
		self.mp1Text = TextField.new(self.smallFont, initStr)
		self.mp1Text:setTextColor(0xaa99ff)
		self.mp1Text:setPosition(XShift + 0.5*WX - 16 - self.mp1Text:getWidth(), 3*self.hp1Text:getHeight())
		
		self.mp2Text = TextField.new(self.smallFont, initStr)
		self.mp2Text:setTextColor(0xaa99ff)
		self.mp2Text:setPosition(XShift + 0.5*WX + 16, 3*self.hp1Text:getHeight())
		
		arena:addChild(self.mp1Text)
		arena:addChild(self.mp2Text)
	end
end