---------------------------------------------
-- Class for Characters (Character Sheet?) --
---------------------------------------------

Char = Core.class()

Char.atk = nil
Char.mov = nil
Char.lif = nil
Char.int = nil
Char.skl = nil
Char.def = nil
Char.skill = nil

Char.atkFactor = nil
Char.dexFactor = nil
Char.lifFactor = nil
Char.intFactor = nil
Char.sklFactor = nil
Char.defFactor = nil

function Char:init(class)
	if class == "classic" then
		self.atk = 10
		self.mov = 13
		self.lif = 10
		self.int = 10
		self.skl = 10
		self.def = 10
	elseif class == "survivalLeft" then
		self.atk = 1
		self.mov = 13
		self.lif = 10
		self.int = 1
		self.skl = 10
		self.def = 30
	elseif class == "survivalRight" then
		self.atk = 1
		self.mov = 13
		self.lif = 10
		self.int = 1
		self.skl = 10
		self.def = 1
	else
		local attrs = lines_from("Chars/" .. class .. ".cls")
		self.atk = tonumber(attrs[1])
		self.mov = tonumber(attrs[2])
		self.lif = tonumber(attrs[3])
		self.int = tonumber(attrs[4])
		self.skl = tonumber(attrs[5])
		self.def = tonumber(attrs[6])
		if attrs[7] ~= nil then
			self.skill = Skills.new(attrs[7])
		end
	end
	
	self:updateAttr()
end

function Char:updateAttr()
	self.atkFactor = 0.24 + self.atk/16.5 -- 0.3 to 2
	self.movFactor = 0.21 + self.mov/11 -- 0.3 to 3
	self.lifFactor = self.lif
	self.intFactor = 1.54 - self.int/26.5 -- 1.5 to 0.4
	self.sklFactor = self.skl
	self.defFactor = 0.21 + self.def/11 -- 0.3 to 3
end