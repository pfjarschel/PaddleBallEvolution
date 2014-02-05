------------------------------------------
-- Class for the Main Menu - Arena Mode --
------------------------------------------

MainMenu_Arena2 = Core.class(Sprite)

-- Declarations --
MainMenu_Arena2.font = nil

-- Handles Keys --
local function onKeyDown(event)
	if event.keyCode == 301 then
		if optionsTable["SFX"] == "On" then sounds.sel3:play() end
		
		local optionsFile = io.open("|D|options.txt", "w+")
		for k, v in pairs(optionsTable) do 
			optionsFile:write(k.."="..v.."\n")
		end	
		
		sceneMan:changeScene("mainMenu_Arena", transTime, SceneManager.fade, easing.linear) 
	end
end

-- Initialization --
function MainMenu_Arena2:init(dataTable)
	self.font = fonts.anitaSmall
	self.smallfont = fonts.anitaVerySmall
	self.bigfont = fonts.anitaBig
	
	local difficulty = dataTable[1]
	local class = dataTable[2]
	local class2 = dataTable[3]
	
	local menubg = Bitmap.new(textures.mainmenubg)
	menubg:setScale(1, 1)
	self:addChild(menubg)
	local textureW = menubg:getWidth()
	local textureH = menubg:getHeight()
	menubg:setScale(WX/textureW, WY/textureH)
	menubg:setAlpha(0.75)
	
	-- Creates arena names table --
	local arenaNames = {}
	local arenaDescs = {}
	local arenaImgs = {}
	
	local i = 1
	for k, v in pairs(arenasTable) do
		arenaNames[i] = k
		arenaDescs[i] = arenasTable[arenaNames[i]]["Desc"]
		arenaImgs[i] = arenasTable[arenaNames[i]]["Image"]
		i = i + 1
	end
	arenaNames[i] = "Random"
	arenaDescs[i] = "Random effect!"
	arenaImgs[i] = "none"
	
	-- Arena Selection --
	local arenaTextBox = TextField.new(self.font, "Arena:")

	arenaTextBox:setTextColor(0xffffff)
	arenaTextBox:setPosition(192 - arenaTextBox:getWidth()/2, 0.5*WY + 15)
	self:addChild(arenaTextBox)
	
	local arenaIndex = 1
	local arena = arenaNames[arenaIndex]
	
	local arenaname = ""
	if arena == "Random" then
		arenaname = "Random"
	else
		arenaname = arenasTable[arena]["Name"]
	end
	local selarenaTextBox = TextField.new(self.font, arenaname)
	selarenaTextBox:setTextColor(0xffffff)
	selarenaTextBox:setPosition(192 - selarenaTextBox:getWidth()/2, 0.5*WY + 55)
	self:addChild(selarenaTextBox)
	
	local selDescTextBox = TextWrap.new(arenaDescs[arenaIndex], 300, "center", 7, self.smallfont)
	selDescTextBox:setTextColor(0xffffff)
	selDescTextBox:setPosition(192 - selDescTextBox:getWidth()/2, 0.5*WY + 95)
	self:addChild(selDescTextBox)
	
	local arenaImg = Bitmap.new(Texture.new(arenaImgs[arenaIndex], true))
	local pongfg = Bitmap.new(Texture.new("imgs/backs/pongbg.png", true))
	pongfg:setScale(1,1)
	pongfg:setAnchorPoint(0.5,0.5)
	arenaImg:addChild(pongfg)
	arenaImg:setScale(1,1)
	arenaImg:setAnchorPoint(0.5,0.5)
	local arenaimgw = arenaImg:getWidth()
	local arenaimgh = arenaImg:getHeight()
	arenaImg:setScale(300/arenaimgw)
	self:addChild(arenaImg)
	arenaImg:setPosition(3*WX0/4, 0.6*WY)
	
	self.prevBut = MenuBut.new(40, 40, textures.backBut, textures.backBut1)
	self:addChild(self.prevBut)
	self.prevBut.bitmap:setPosition(32, WY/2 + 45)
	self.prevBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.prevBut:hitTestPoint(event.touch.x, event.touch.y) then
			arenaIndex = arenaIndex - 1
			if arenaIndex < 1 then arenaIndex = tablelength(arenaNames) end
			self:removeChild(selarenaTextBox)
			arena = arenaNames[arenaIndex]
			local arenaname = ""
			if arena == "Random" then
				arenaname = "Random"
			else
				arenaname = arenasTable[arena]["Name"]
			end
			selarenaTextBox = TextField.new(self.font, arenaname)
			selarenaTextBox:setTextColor(0xffffff)
			selarenaTextBox:setPosition(192 - selarenaTextBox:getWidth()/2, 0.5*WY + 55)
			self:addChild(selarenaTextBox)
			
			self:removeChild(selDescTextBox)
			selDescTextBox = TextWrap.new(arenaDescs[arenaIndex], 300, "center", 7, self.smallfont)
			selDescTextBox:setTextColor(0xffffff)
			selDescTextBox:setPosition(192 - selDescTextBox:getWidth()/2, 0.5*WY + 95)
			self:addChild(selDescTextBox)
			
			self:removeChild(arenaImg)
			if arena == "Random" then
				arenaImg = Shape.new()
				arenaImg:setFillStyle(Shape.SOLID, 0x000000, 1)
				arenaImg:beginPath()
				arenaImg:moveTo(0,0)
				arenaImg:lineTo(400, 0)
				arenaImg:lineTo(400, 240)
				arenaImg:lineTo(0, 240)
				arenaImg:lineTo(0, 0)
				arenaImg:endPath()
				local giantfont = TTFont.new("fonts/anita.ttf", 240, true)
				local question = TextField.new(giantfont, "?") 
				question:setTextColor(0xffffff)
				question:setPosition(question:getWidth() - 24, question:getHeight() + 32)
				arenaImg:addChild(question)
				arenaImg:setScale(1,1)
				arenaimgw = arenaImg:getWidth()
				arenaimgh = arenaImg:getHeight()
				arenaImg:setScale(300/arenaimgw)
				self:addChild(arenaImg)
				arenaImg:setPosition(3*WX0/4 - 3*arenaimgw/8, 0.6*WY - 3*arenaimgh/8)
			else
				arenaImg = Bitmap.new(Texture.new(arenaImgs[arenaIndex], true))
				pongfg = Bitmap.new(Texture.new("imgs/backs/pongbg.png", true))
				pongfg:setScale(1,1)
				pongfg:setAnchorPoint(0.5,0.5)
				--pongfg:setScale(0.5,0.5)
				arenaImg:addChild(pongfg)
				arenaImg:setScale(1,1)
				arenaImg:setAnchorPoint(0.5,0.5)
				arenaimgw = arenaImg:getWidth()
				arenaimgh = arenaImg:getHeight()
				arenaImg:setScale(300/arenaimgw)
				self:addChild(arenaImg)
				arenaImg:setPosition(3*WX0/4, 0.6*WY)
			end
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	self.nextBut = MenuBut.new(40, 40, textures.forwardBut, textures.forwardBut1)
	self:addChild(self.nextBut)
	self.nextBut.bitmap:setPosition(342, WY/2 + 45)
	self.nextBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.nextBut:hitTestPoint(event.touch.x, event.touch.y) then
			arenaIndex = arenaIndex + 1
			if arenaIndex > tablelength(arenaNames) then arenaIndex = 1 end
			self:removeChild(selarenaTextBox)
			arena = arenaNames[arenaIndex]
			local arenaname = ""
			if arena == "Random" then
				arenaname = "Random"
			else
				arenaname = arenasTable[arena]["Name"]
			end
			selarenaTextBox = TextField.new(self.font, arenaname)
			selarenaTextBox:setTextColor(0xffffff)
			selarenaTextBox:setPosition(192 - selarenaTextBox:getWidth()/2, 0.5*WY + 55)
			self:addChild(selarenaTextBox)
			
			self:removeChild(selDescTextBox)
			selDescTextBox = TextWrap.new(arenaDescs[arenaIndex], 300, "center", 7, self.smallfont)
			selDescTextBox:setTextColor(0xffffff)
			selDescTextBox:setPosition(192 - selDescTextBox:getWidth()/2, 0.5*WY + 95)
			self:addChild(selDescTextBox)
			
			self:removeChild(arenaImg)
			if arena == "Random" then
				arenaImg = Shape.new()
				arenaImg:setFillStyle(Shape.SOLID, 0x000000, 1)
				arenaImg:beginPath()
				arenaImg:moveTo(0,0)
				arenaImg:lineTo(400, 0)
				arenaImg:lineTo(400, 240)
				arenaImg:lineTo(0, 240)
				arenaImg:lineTo(0, 0)
				arenaImg:endPath()
				local giantfont = TTFont.new("fonts/anita.ttf", 240, true)
				local question = TextField.new(giantfont, "?") 
				question:setTextColor(0xffffff)
				question:setPosition(question:getWidth() - 24, question:getHeight() + 32)
				arenaImg:addChild(question)
				arenaImg:setScale(1,1)
				arenaimgw = arenaImg:getWidth()
				arenaimgh = arenaImg:getHeight()
				arenaImg:setScale(300/arenaimgw)
				self:addChild(arenaImg)
				arenaImg:setPosition(3*WX0/4 - 3*arenaimgw/8, 0.6*WY - 3*arenaimgh/8)
			else
				arenaImg = Bitmap.new(Texture.new(arenaImgs[arenaIndex], true))
				pongfg = Bitmap.new(Texture.new("imgs/backs/pongbg.png", true))
				pongfg:setScale(1,1)
				pongfg:setAnchorPoint(0.5,0.5)
				--pongfg:setScale(0.5,0.5)
				arenaImg:addChild(pongfg)
				arenaImg:setScale(1,1)
				arenaImg:setAnchorPoint(0.5,0.5)
				arenaimgw = arenaImg:getWidth()
				arenaimgh = arenaImg:getHeight()
				arenaImg:setScale(300/arenaimgw)
				self:addChild(arenaImg)
				arenaImg:setPosition(3*WX0/4, 0.6*WY)
			end
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	-- Go or return --
	self.goBut = MenuBut.new(150, 40, textures.goBut, textures.goBut1)
	self:addChild(self.goBut)
	self.goBut.bitmap:setPosition(WX/2, WY/2 + 190)
	self.goBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.goBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			if arena == "Random" then
				arena = arenaNames[math.random(1, tablelength(arenaNames) - 1)]
			end
			sceneMan:changeScene("arena", transTime, SceneManager.fade, easing.linear, { userData = {difficulty, class, class2, arena} }) 
		end
	end)
	
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
			sceneMan:changeScene("mainMenu_Arena", transTime, SceneManager.fade, easing.linear) 
		end
	end)
	
	-- Listen to Keys --
	self:addEventListener(Event.KEY_DOWN, onKeyDown)
end