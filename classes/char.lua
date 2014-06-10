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
Char.stage = 1
Char.world = 1

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
function Char:init(class, stage, world)
	self.stage = stage
	self.world = world
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
	elseif class == "career" then
		self.atk = 3
		self.mov = 3
		self.lif = 3
		self.int = 10 + 2*self.stage
		self.skl = 3
		self.def = 3
		
		if self.stage ~= 0 and self.stage ~= -1 then
			local points = 10 + (self.stage - 1) + 3*(tonumber(careerTable["World"]) - 1)
			if self.stage == 5 then
				points = points - 1 + 2*tonumber(careerTable["World"])
			end
			for i = 1, points, 1 do
				local newatk = 0
				local newmov = 0
				local newlif = 0
				local newskl = 0
				local newdef = 0
				local randNum = math.random(1,5)
				if randNum == 1 then
					newatk = 1
				elseif randNum == 2 then
					newmov = 1
				elseif randNum == 3 then
					newlif = 1
				elseif randNum == 4 then
					newskl = 1
				else
					newdef = 1
				end
				while newatk > 30 or newmov > 30 or newlif > 30 or newskl > 30 or newdef > 30 do
					local randNum = math.random(1,5)
					if randNum == 1 then
						newatk = 1
					elseif randNum == 2 then
						newmov = 1
					elseif randNum == 3 then
						newlif = 1
					elseif randNum == 4 then
						newskl = 1
					else
						newdef = 1
					end
				end
				self.atk = self.atk + newatk
				self.mov = self.mov + newmov
				self.lif = self.lif + newlif
				self.skl = self.skl + newskl
				self.def = self.def + newdef
			end
			self.skill = Skills.new(Worlds[self.world]["Skill"])
		end
		
		if self.stage == -1 then
			self.atk = self.atk + careerTable["Atk"]
			self.mov = self.mov + careerTable["Mov"]
			self.lif = self.lif + careerTable["Lif"]
			self.int = self.int + 2
			self.skl = self.skl + careerTable["Skl"]
			self.def = self.def + careerTable["Def"]
			
			if careerTable["CurSkill"] == "Unskilled" then
				self.skill = Skills.new("noskill")
			else
				self.skill = Skills.new(careerTable["CurSkill"])
			end
		end

		--print(self.atk)
		--print(self.mov)
		--print(self.lif)
		--print(self.int)
		--print(self.skl)
		--print(self.def)
		--print("--")
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