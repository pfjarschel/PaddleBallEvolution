------------------------------------------
-- Class for the Main Menu - Arena Mode --
------------------------------------------

MainMenu_QuickTour = Core.class(Sprite)

-- Declarations --
MainMenu_QuickTour.font = nil
MainMenu_QuickTour.savedData = {}


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
		createFile:write("QuickTourStage=0\n")
		createFile:write("QuickTourDif=5\n")
		createFile:write("QuickTourClass=Warrior\n")
		
		self.savedData["QuickTourStage"] = 0
		self.savedData["QuickTourDif"] = 5
		self.savedData["QuickTourClass"] = "Warrior"
		
	else
		local lines = lines_from("|D|quicktour.txt")
		for i = 1, table.getn(lines), 1 do
			for k1, v1 in string.gmatch(lines[i], "(%w+)=(%w+)") do
				self.savedData[k1] = v1
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
	if tonumber(self.savedData["QuickTourStage"]) > 0 then
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
				sceneMan:changeScene("arenaTour", transTime, SceneManager.fade, easing.linear, { userData = {tonumber(self.savedData["QuickTourDif"]), self.savedData["QuickTourClass"], self.savedData["QuickTourOpponent"], tonumber(self.savedData["QuickTourStage"])} }) 
			end
		end)
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