-----------------------------------------------------
-- Class for the Text During Matches (HP, MP, etc) --
-----------------------------------------------------

CombatStats = Core.class()

-- Declare stuff --
CombatStats.font = nil
CombatStats.fontSize = 50
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
	self.hp1Text:setPosition(0.5*WX - #tostring(hp1)*self.fontSize*0.75, self.fontSize*1.2)
	
	self.hp2Text = TextField.new(self.font, tostring(hp2))
	self.hp2Text:setTextColor(0xffffff)
	self.hp2Text:setPosition(0.5*WX + self.fontSize*0.35, self.fontSize*1.2)
	
	arena:addChild(self.hp1Text)
	arena:addChild(self.hp2Text)
	
	if arena.name == "arena" then
		arena:removeChild(self.mp1Text)
		arena:removeChild(self.mp2Text)
		
		self.mp1Text = TextField.new(self.smallFont, tostring(mp1))
		self.mp1Text:setTextColor(0xaa00ff)
		self.mp1Text:setPosition(0.5*WX - 16 - self.mp1Text:getWidth(), self.fontSize*2)
		
		self.mp2Text = TextField.new(self.smallFont, tostring(mp2))
		self.mp2Text:setTextColor(0xaa00ff)
		self.mp2Text:setPosition(0.5*WX + 16, self.fontSize*2)
		
		arena:addChild(self.mp1Text)
		arena:addChild(self.mp2Text)
	end
end

-- Initialize score texts --
function CombatStats:init()
	self.font = fonts.arialroundedBig
	self.smallFont = fonts.arialroundedSmall

	local initStr = "--"
	
	self.hp1Text = TextField.new(self.font, initStr)
	self.hp1Text:setTextColor(0xffffff)
	self.hp1Text:setPosition(0.5*WX - #initStr*self.fontSize*0.75, self.fontSize*1.2)
	
	self.hp2Text = TextField.new(self.font, initStr)
	self.hp2Text:setTextColor(0xffffff)
	self.hp2Text:setPosition(0.5*WX + self.fontSize*0.35, self.fontSize*1.2)
		
	arena:addChild(self.hp1Text)
	arena:addChild(self.hp2Text)
	
	if arena.name == "arena" then
		self.mp1Text = TextField.new(self.smallFont, initStr)
		self.mp1Text:setTextColor(0xaa00ff)
		self.mp1Text:setPosition(0.5*WX - 16 - self.mp1Text:getWidth(), self.fontSize*2)
		
		self.mp2Text = TextField.new(self.smallFont, initStr)
		self.mp2Text:setTextColor(0xaa00ff)
		self.mp2Text:setPosition(0.5*WX + 16, self.fontSize*2)
		
		arena:addChild(self.mp1Text)
		arena:addChild(self.mp2Text)
	end
end