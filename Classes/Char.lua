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
Char.skill = nil
Char.Stage = 5

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
function Char:init(class, stage)
	self.stage = stage
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
		self.int = classTable[class][4] + self.stage
		self.skl = classTable[class][5]
		self.def = classTable[class][6]

		local points = self.stage
		if self.stage == 10 then
			points = points*2
		end
		if points ~= 0 and points ~= -1 then
			for i = 1, points, 1 do
				local randNum = math.random(1,5)
				if randNum == 1 then
					self.atk = self.atk + 1
				elseif randNum == 2 then
					self.mov = self.mov + 1
				elseif randNum == 3 then
					self.lif = self.lif + 1
				elseif randNum == 4 then
					self.skl = self.skl + 1
				else
					self.def = self.def + 1
				end
			end
		end
		
		if points == -1 then
			self.atk = self.atk + tourTable["QuickTourAtk"]
			self.mov = self.mov + tourTable["QuickTourMov"]
			self.lif = self.lif + tourTable["QuickTourLif"]
			self.int = self.int + 1
			self.skl = self.skl + tourTable["QuickTourSkl"]
			self.def = self.def + tourTable["QuickTourDef"]
		end

		--print(self.atk)
		--print(self.mov)
		--print(self.lif)
		--print(self.int)
		--print(self.skl)
		--print(self.def)
		--print("--")
		
		if classTable[class][7] ~= nil then
			self.skill = Skills.new(classTable[class][7])
		end
	end
	
	self:updateAttr()
end