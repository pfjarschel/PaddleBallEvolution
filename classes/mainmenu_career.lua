---------------------------------
-- Class for the Career Screen --
---------------------------------

MainMenu_Career = Core.class(Sprite)

-- Handles Keys --
local function onKeyDown(event)
	if event.keyCode == 301 then
		if optionsTable["SFX"] == "On" then sounds.sel3:play() end
		
		sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
	end
end


-- Initialization --
function MainMenu_Career:init()
	if mainLock == "unlocked" then
		self.font = fonts.anitaVerySmall
		self.medfont = fonts.anitaSmall
		self.biggerfont = fonts.anitaMed
		
		local menubg = Bitmap.new(textures.mainmenubg)
		menubg:setScale(1, 1)
		self:addChild(menubg)
		local textureW = menubg:getWidth()
		local textureH = menubg:getHeight()
		menubg:setScale(WX0/textureW, WY/textureH)
		
		-- Check if there is a saved tour --
		local careerFile = io.open("|D|career.txt", "r")
		if not careerFile then
			local createFile = io.open("|D|career.txt", "w+")
			for k, v in pairs(careerTable) do 
				createFile:write(k.."="..v.."\n")
			end
			createFile:close()
		else
			local lines = lines_from("|D|career.txt")
			for i = 1, table.getn(lines), 1 do
				for k1, v1 in string.gmatch(lines[i], "(%w+)=(%w+)") do
					careerTable[k1] = v1
				end
			end
		end

		-- New, Load, or return --
		self.newBut = MenuBut.new(192, 40, textures.newBut, textures.newBut1)
		self:addChild(self.newBut)
		self.newBut.bitmap:setPosition(WX0/2, 0.5*WY + 40)
		self.newBut:addEventListener(Event.TOUCHES_END, function(event)
			if self.newBut:hitTestPoint(event.touch.x, event.touch.y) then
				if optionsTable["SFX"] == "On" then sounds.sel2:play() end
				careerTable["CurSkill"] = "Unskilled"
				careerTable["World"] = 0
				careerTable["Stage"] = 0
				careerTable["Atk"] = 0
				careerTable["Mov"] = 0
				careerTable["Lif"] = 0
				careerTable["Skl"] = 0
				careerTable["Def"] = 0
				careerTable["Dif"] = 5
				careerTable["Points"] = 0
				careerTable["R"] = 1
				careerTable["G"] = 1
				careerTable["B"] = 1
				local optionsFile = io.open("|D|options.txt", "w+")
				for k, v in pairs(optionsTable) do 
					optionsFile:write(k.."="..v.."\n")
				end	
				sceneMan:changeScene("careerStats", transTime, SceneManager.fade, easing.linear) 
			end
		end)
		if tonumber(careerTable["World"]) > 0 then
			self.loadBut = MenuBut.new(192, 40, textures.loadBut, textures.loadBut1)
			self:addChild(self.loadBut)
			self.loadBut.bitmap:setPosition(WX0/2, 0.5*WY + 96)
			self.loadBut:addEventListener(Event.TOUCHES_END, function(event)
				if self.loadBut:hitTestPoint(event.touch.x, event.touch.y) then
					if optionsTable["SFX"] == "On" then sounds.sel2:play() end
					local optionsFile = io.open("|D|options.txt", "w+")
					for k, v in pairs(optionsTable) do 
						optionsFile:write(k.."="..v.."\n")
					end	
					sceneMan:changeScene("careerStats", transTime, SceneManager.fade, easing.linear)
				end
			end)
			
			local stagename = ", Stage "..careerTable["Stage"]
			if stagename == ", Stage 5" then
				stagename = ", Boss Stage!"
			end
			stagename = "World "..careerTable["World"]..stagename
			if tonumber(careerTable["World"]) > tablelength(Worlds) then
				stagename = "Universe Saved!"
			end
			
			local skillname = ""
			if careerTable["CurSkill"] == "Unskilled" then
				skillname = "Unskilled"
			else
				skillname = skillTable[careerTable["CurSkill"]]["Name"]
			end
			
			local stats = "Saved game info:\n \n"..
						stagename.."\n \n"..
						"Current Skill: "..skillname.."\n \n"..
						--"Difficulty: "..careerTable["Dif"].."\n \n"..
						"Atk: "..(3 + careerTable["Atk"]).."\n"..
						"Mov: "..(3 + careerTable["Mov"]).."\n"..
						"Lif: "..(3 + careerTable["Lif"]).."\n"..
						"Skl: "..(3 + careerTable["Skl"]).."\n"..
						"Def: "..(3 + careerTable["Def"]).."\n"
			local statsTextBox = TextWrap.new(stats, 256, "center", 7, self.font)
			statsTextBox:setTextColor(0xffffff)
			statsTextBox:setPosition(WX0/2 + statsTextBox:getWidth()/2, WY/2 - 8)
			self:addChild(statsTextBox)
			
			local samplePaddle = Bitmap.new(textures.paddle2)
			samplePaddle:setScale(1, 1)
			self:addChild(samplePaddle)
			local textureWp = samplePaddle:getWidth()
			local textureHp = samplePaddle:getHeight()
			samplePaddle:setAnchorPoint(0.5, 0.5)
			samplePaddle:setScale(15/textureWp,75/textureHp)
			samplePaddle:setRotation(-90)
			samplePaddle:setPosition(4*WX0/5 + 17, WY - 64)
			samplePaddle:setColorTransform(careerTable["R"]/255, careerTable["G"]/255, careerTable["B"]/255, 1)
		else
			self.loadBut = MenuBut.new(192, 40, textures.loadBut, textures.loadBut1, textures.loadBut0)
			self:addChild(self.loadBut)
			self.loadBut.bitmap:setPosition(WX0/2, 0.5*WY + 96)
		end
		
		self.returnBut = MenuBut.new(192, 40, textures.returnBut, textures.returnBut1)
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
	
	else
		self.font = fonts.anitaVerySmall
		self.biggerfont = fonts.anitaMed
		
		local bg = Bitmap.new(textures.mainmenubg)
		self:addChild(bg)
		local textureW = bg:getWidth()
		local textureH = bg:getHeight()
		bg:setScale(WX0/textureW, WY/textureH)
		
		local careertitlestring = "Career Mode Info"
		
		local careertitle = TextWrap.new(careertitlestring, WX0/2, "center", 5, self.biggerfont)
		careertitle:setTextColor(0xffffff)
		careertitle:setPosition(WX0/4, WY/2 - 24)
		self:addChild(careertitle)
		
		local careerstring = "Career mode is available in the full version!\n \n"..
						"In this mode, you will start with a basic character, and progress through various tournaments in different locations, while "..
						"improving your stats by leveling up and acquiring special skills from defeated enemies.\n \n"..
						"Purchase full version at Google Play Store!\n"
		
		local careertext = TextWrap.new(careerstring, WX0/1.1, "justify", 10, self.font)
		careertext:setTextColor(0xffffff)
		careertext:setPosition(WX0/2 - careertext:getWidth()/2, WY/2 + 1.5*careertitle:getHeight() - 24)
		self:addChild(careertext)
		
		self.returnBut = MenuBut.new(192, 40, textures.returnBut, textures.returnBut1)
		self:addChild(self.returnBut)
		self.returnBut.bitmap:setPosition(self.returnBut:getWidth()/2 + 10, WY/2 + 210)
		self.returnBut:addEventListener(Event.TOUCHES_END, function(event)
			if self.returnBut:hitTestPoint(event.touch.x, event.touch.y) then
				if optionsTable["SFX"] == "On" then sounds.sel3:play() end
			
				sceneMan:changeScene("mainMenu", transTime, SceneManager.fade, easing.linear) 
			end
		end)
		
		-- Listen to Keys --
		self:addEventListener(Event.KEY_DOWN, onKeyDown)
	end
end