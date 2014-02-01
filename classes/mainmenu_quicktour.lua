------------------------------------------
-- Class for the Main Menu - Arena Mode --
------------------------------------------

MainMenu_QuickTour = Core.class(Sprite)

-- Declarations --
MainMenu_QuickTour.font = nil

-- Handles Keys --
local function onKeyDown(event)
	if event.keyCode == 301 then
		if optionsTable["SFX"] == "On" then sounds.sel3:play() end
		
		sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
	end
end

-- Initialization --
function MainMenu_QuickTour:init()
	self.font = fonts.anitaSmall
	self.smallfont = fonts.anitaVerySmall
	
	local menubg = Bitmap.new(textures.mainmenubg)
	menubg:setScale(1, 1)
	self:addChild(menubg)
	local textureW = menubg:getWidth()
	local textureH = menubg:getHeight()
	menubg:setScale(WX/textureW, WY/textureH)
	
	-- Check if there is a saved tour --
	local quicktourFile = io.open("|D|quicktour.txt", "r")
	if not quicktourFile then
		local createFile = io.open("|D|quicktour.txt", "w+")
		for k, v in pairs(tourTable) do 
			createFile:write(k.."="..v.."\n")
		end
		createFile:close()
	else
		local lines = lines_from("|D|quicktour.txt")
		for i = 1, table.getn(lines), 1 do
			for k1, v1 in string.gmatch(lines[i], "(%w+)=(%w+)") do
				tourTable[k1] = v1
			end
		end
	end

	-- New, Load, or return --
	self.newBut = MenuBut.new(150, 40, textures.newBut, textures.newBut1)
	self:addChild(self.newBut)
	self.newBut.bitmap:setPosition(WX/2, 0.5*WY + 40)
	self.newBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.newBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			local optionsFile = io.open("|D|options.txt", "w+")
			for k, v in pairs(optionsTable) do 
				optionsFile:write(k.."="..v.."\n")
			end	
			sceneMan:changeScene("mainMenu_QuickTour2", transTime, SceneManager.fade, easing.linear) 
		end
	end)
	if tonumber(tourTable["QuickTourStage"]) > 0 then
		self.loadBut = MenuBut.new(150, 40, textures.loadBut, textures.loadBut1)
		self:addChild(self.loadBut)
		self.loadBut.bitmap:setPosition(WX/2, 0.5*WY + 96)
		self.loadBut:addEventListener(Event.TOUCHES_END, function(event)
			if self.loadBut:hitTestPoint(event.touch.x, event.touch.y) then
				if optionsTable["SFX"] == "On" then sounds.sel2:play() end
				local optionsFile = io.open("|D|options.txt", "w+")
				for k, v in pairs(optionsTable) do 
					optionsFile:write(k.."="..v.."\n")
				end	
				sceneMan:changeScene("arenaTour", transTime, SceneManager.fade, easing.linear, { userData = {tonumber(tourTable["QuickTourDif"]), tourTable["QuickTourClass"], tourTable["QuickTourOpponent"], tonumber(tourTable["QuickTourStage"]), tourTable["QuickTourArena"]} }) 
			end
		end)
		
		local stagename = ", Stage "..tourTable["QuickTourStage"]
		if stagename == ", Stage 10" then
			stagename = ", Boss Stage!"
		end
		
		local stats = "Saved game Info:\n \n"..
					tourTable["QuickTourClass"]..stagename.."\n"..
					"Next opponent: "..tourTable["QuickTourOpponent"].."\n"..
					"Next Arena: "..tourTable["QuickTourArena"].."\n"..
					"Difficulty: "..tourTable["QuickTourDif"].."\n \n"..
					"Atk: "..(classTable[tourTable["QuickTourClass"]][1] + tourTable["QuickTourAtk"]).."\n"..
					"Mov: "..(classTable[tourTable["QuickTourClass"]][2] + tourTable["QuickTourMov"]).."\n"..
					"Lif: "..(classTable[tourTable["QuickTourClass"]][3] + tourTable["QuickTourLif"]).."\n"..
					"Skl: "..(classTable[tourTable["QuickTourClass"]][5] + tourTable["QuickTourSkl"]).."\n"..
					"Def: "..(classTable[tourTable["QuickTourClass"]][6] + tourTable["QuickTourDef"]).."\n"
		local statsTextBox = TextWrap.new(stats, 256, "center", 7, self.smallfont)
		statsTextBox:setTextColor(0xffffff)
		statsTextBox:setPosition(WX0/2 + statsTextBox:getWidth()/2, WY/2 - 8)
		self:addChild(statsTextBox)
	else
		self.loadBut = MenuBut.new(150, 40, textures.loadBut, textures.loadBut1, textures.loadBut0)
		self:addChild(self.loadBut)
		self.loadBut.bitmap:setPosition(WX/2, 0.5*WY + 96)
	end
	
	self.returnBut = MenuBut.new(150, 40, textures.returnBut, textures.returnBut1)
	self:addChild(self.returnBut)
	self.returnBut.bitmap:setPosition(self.returnBut:getWidth()/2 + 10, WY/2 + 210)
	self.returnBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.returnBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel3:play() end
			local optionsFile = io.open("|D|options.txt", "w+")
			for k, v in pairs(optionsTable) do 
				optionsFile:write(k.."="..v.."\n")
			end	
			sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
		end
	end)
	
	-- Listen to Keys --
	self:addEventListener(Event.KEY_DOWN, onKeyDown)
end