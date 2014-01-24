---------------------------------------------
-- Class for Characters (Character Sheet?) --
---------------------------------------------

Char = Core.class()

-- Declare attributes and skill string --
Char.atk = nil
Char.mov = nil
Char.lif = nil
Char.int = nil
Char.skl = nil
Char.def = nil
Char.skill = "none"

Char.atkFactor = nil
Char.dexFactor = nil
Char.lifFactor = nil
Char.intFactor = nil
Char.sklFactor = nil
Char.defFactor = nil

-- Calculates attributes modification factors --
function Char:updateAttr()
	self.atkFactor = 0.24 + self.atk/16.5 -- 0.3 to 2
	self.movFactor = 0.16 + self.mov/22.5 -- 0.2 to 1.5
	self.lifFactor = self.lif
	self.intFactor = 1.54 - self.int/26.5 -- 1.5 to 0.4
	self.sklFactor = self.skl
	self.defFactor = 0.21 + self.def/11 -- 0.3 to 3
end

-- Initialization, load from charTable if not standard char --
function Char:init(class)
	if class == "classic" then
		self.atk = 10
		self.mov = 20
		self.lif = 10
		self.int = 10
		self.skl = 10
		self.def = 10
	elseif class == "survivalLeft" then
		self.atk = 1
		self.mov = 20
		self.lif = 10
		self.int = 10
		self.skl = 10
		self.def = 30
	elseif class == "survivalRight" then
		self.atk = 1
		self.mov = 20
		self.lif = 10
		self.int = 1
		self.skl = 10
		self.def = 1
	else
		self.atk = classTable[class][1]
		self.mov = classTable[class][2]
		self.lif = classTable[class][3]
		self.int = classTable[class][4]
		self.skl = classTable[class][5]
		self.def = classTable[class][6]
		if classTable[class][7] ~= nil then
			self.skill = Skills.new(classTable[class][7])
		end
	end
	
	self:updateAttr()
end