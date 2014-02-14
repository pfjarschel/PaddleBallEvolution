----------------------------------------------
-- Table Containing Class Names and Aliases --
----------------------------------------------

-- The index is the class name, followed by Atk, Mov, Lif, Int, Skl, Def, Skill internal name, Skill Full Name, Skill Description, RGB colors, Full Name, Locked

classTable["Custom"] = {
	10,
	10,
	10,
	10,
	10,
	10,
	"none",
	"None",
	"Touch 'Edit' to select",
	{0.5, 0.5, 0.5},
	"Custom Class",
	0
}
classTable["Warrior"] = {
	18,
	8,
	12,
	10,
	8,
	14,
	"powershot",
	"Power Shot",
	"The next ball return will be VERY fast",
	{0.6, 0.2, 0.2},
	"Warrior",
	0
}
classTable["Acrobat"] = {
	10,
	20,
	10,
	10,
	10,
	10,
	"curveball",
	"Curve Ball",
	"Ball makes crazy curves",
	{0.8, 0.8, 0.2},
	"Acrobat",
	0
}
classTable["Ninja"] = { 
	14,
	20,
	8,
	10,
	10,
	8,
	"invisiball",
	"Invisiball",
	"Ball turns invisible",
	{0.05, 0.2, 0.5},
	"Ninja",
	0
}
classTable["SwampMonster"] = {
	14,
	6,
	16,
	10,
	8,
	16,
	"viscousfield",
	"Viscous Field",
	"Ball slows down a lot",
	{0.6, 0.7, 0.2},
	"Swamp Monster",
	0
}
classTable["Archer"] = {
	14,
	16,
	12,
	10,
	10,
	8,
	"arrowball",
	"Arrow Ball",
	"Ball moves in a straight line to the goal",
	{0.2, 0.6, 0.2},
	"Archer",
	0
}
classTable["Illusionist"] = {
	12,
	12,
	10,
	10,
	14,
	12,
	"mirrorball",
	"Mirror Ball",
	"Ball is reflected to the other direction",
	{0.7, 0.7, 0.7},
	"Illusionist",
	0
}
classTable["Barbarian"] = {
	20,
	12,
	14,
	10,
	4,
	10,
	"berserk",
	"Berserk",
	"Atk, Mov and Def greatly increased",
	{0.8, 0.3, 0.1},
	"Barbarian",
	0
}
classTable["Thief"] = {
	8,
	18,
	8,
	10,
	16,
	10,
	"steal",
	"Steal",
	"Steal ball and return with 2x its speed",
	{0.4, 0.4, 0.4},
	"Thief",
	0
}

classTable["Mesmer"] = {
	8,
	14,
	12,
	10,
	12,
	14,
	"multiball",
	"Multiball",
	"Creates illusions to confuse the enemy",
	{0.6, 0.4, 1},
	"Mesmer",
	0
}

classTable["IceMan"] = {
	15,
	7,
	8,
	10,
	12,
	18,
	"freeze",
	"Freeze",
	"Freezes your opponent for some time",
	{0.8, 0.8, 1},
	"Ice Man",
	0
}

classTable["CaveMan"] = {
	16,
	10,
	18,
	10,
	0,
	16,
	"noskill",
	"No Skill",
	"+10 Attribute Points",
	{0.4, 0.2, 0},
	"Cave Man",
	0
}

classTable["Scientist"] = {
	8,
	12,
	8,
	10,
	20,
	12,
	"predict",
	"Predict",
	"Predicts ball trajectory",
	{0.53, 0.75, 0.86},
	"Scientist",
	0
}

classTable["Pyromancer"] = {
	16,
	16,
	10,
	10,
	6,
	12,
	"fireball",
	"Fireball",
	"Hurls a fireball that does 1 damage",
	{1, 0.2, 0},
	"Pyromancer",
	0
}

classTable["Vampire"] = {
	14,
	15,
	10,
	10,
	10,
	11,
	"bite",
	"Bite",
	"Next enemy skill gives you 1 HP",
	{0.21, 0.21, 0.43},
	"Vampire",
	0
}

classTable["Exorcist"] = {
	12,
	8,
	16,
	10,
	12,
	12,
	"dispel",
	"Dispel",
	"Cancels Enemy's skill",
	{1, 1, 1},
	"Exorcist",
	1
}

classTable["Shaman"] = {
	8,
	10,
	12,
	10,
	17,
	13,
	"headshrink",
	"Headshrink",
	"Decreases Enemy's paddle size",
	{0.4, 0.45, 0},
	"Shaman",
	1
}