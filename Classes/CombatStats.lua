-----------------------------------------------------
-- Class for the Text During Matches (HP, MP, etc) --
-----------------------------------------------------

CombatStats = Core.class()

-- Declare stuff
CombatStats.fontSize = 50
CombatStats.font = TTFont.new("Fonts/arial-rounded.ttf", CombatStats.fontSize)
CombatStats.hp1Text = nil
CombatStats.hp2Text = nil

-- Initialize score texts
function CombatStats:init()
	local initStr = "--"
	self.hp1Text = TextField.new(self.font, initStr)
	self.hp1Text:setTextColor(0xffffff)
	self.hp1Text:setPosition(0.5*WX - #initStr*self.fontSize*0.75, self.fontSize*1.2)
	
	self.hp2Text = TextField.new(self.font, initStr)
	self.hp2Text:setTextColor(0xffffff)
	self.hp2Text:setPosition(0.5*WX + self.fontSize*0.35, self.fontSize*1.2)
	
	arena:addChild(self.hp1Text)
	arena:addChild(self.hp2Text)
end

-- Function to update score
function CombatStats:update(hp1, hp2)
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
end