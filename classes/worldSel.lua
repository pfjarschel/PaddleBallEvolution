------------------------------------------
-- Class for the Career World Selection --
------------------------------------------

WorldSel = Core.class(Sprite)

-- Declarations --
WorldSel.font = nil

-- Handles Keys --
local function onKeyDown(event)
	if event.keyCode == 301 then
		if optionsTable["SFX"] == "On" then sounds.sel3:play() end
		
		sceneMan:changeScene("careerStats", transTime, SceneManager.fade, easing.linear) 
	end
end

-- Initialization --
function WorldSel:init(dataTable)
	self.font = fonts.anitaSmall
	self.smallfont = fonts.anitaVerySmall
	self.bigfont = fonts.anitaBig
	
	local menubg = Bitmap.new(textures.black)
	menubg:setScale(1, 1)
	self:addChild(menubg)
	local textureW = menubg:getWidth()
	local textureH = menubg:getHeight()
	menubg:setScale(WX/textureW, WY/textureH)
	
	-- World Selection --
	local wi = tonumber(careerTable["World"])
	if wi > tablelength(Worlds) then wi = tablelength(Worlds) end	
	local stagelv = tonumber(careerTable["Stage"])
	
	local WorldTextBox = TextField.new(self.font, "World "..tostring(wi)..": \n"..Worlds[wi]["Name"])
	WorldTextBox:setTextColor(0xffffff)
	WorldTextBox:setPosition(WX0/2 - WorldTextBox:getWidth()/2, 50)
	self:addChild(WorldTextBox)
	
	local InfoTextBox = TextWrap.new(Worlds[wi]["Info"], 380, "center", 7, self.smallfont)
	InfoTextBox:setTextColor(0xffffff)
	InfoTextBox:setPosition(WX0/2 - InfoTextBox:getWidth()/2, WY - InfoTextBox:getHeight())
	self:addChild(InfoTextBox)
	
	local worldImg = Bitmap.new(Texture.new(Worlds[wi]["Img"], true))
	worldImg:setScale(1,1)
	worldImg:setAnchorPoint(0.5,0.5)
	local worldImgW = worldImg:getWidth()
	local worldImgH = worldImg:getHeight()
	worldImg:setScale(240/worldImgW)
	self:addChild(worldImg)
	worldImg:setPosition(WX0/2, WY/2)
	
	local medalTex1 = Texture.new("imgs/misc/medal.png", true)
	local trophyTex1 = Texture.new("imgs/misc/trophysmall.png", true)
	local medalTex0 = Texture.new("imgs/misc/blackmedal.png", true)
	local trophyTex0 = Texture.new("imgs/misc/blacktrophy.png", true)
	local medalW = medalTex1:getWidth()
	local medalH = medalTex1:getHeight()
	local trophyW = trophyTex1:getWidth()
	local trophyH = trophyTex1:getHeight()
	
	local y0 = WY/5.5
	local xgap = 48
	local x0 = WX0/2 - 2*xgap
	
	local medal1, medal2, medal3, medal4, medal5 = nil
	if stagelv > 1 then
		medal1 = Bitmap.new(medalTex1)
	else
		medal1 = Bitmap.new(medalTex0)
	end
	medal1:setScale(1,1)
	medal1:setAnchorPoint(0.5,0.5)
	medal1:setScale(40/medalW, 40/medalH)
	medal1:setPosition(x0, y0)
	self:addChild(medal1)
	
	if stagelv > 2 then
		medal2 = Bitmap.new(medalTex1)
	else
		medal2 = Bitmap.new(medalTex0)
	end
	medal2:setScale(1,1)
	medal2:setAnchorPoint(0.5,0.5)
	medal2:setScale(40/medalW, 40/medalH)
	medal2:setPosition(x0 + xgap, y0)
	self:addChild(medal2)
	
	if stagelv > 3 then
		medal3 = Bitmap.new(medalTex1)
	else
		medal3 = Bitmap.new(medalTex0)
	end
	medal3:setScale(1,1)
	medal3:setAnchorPoint(0.5,0.5)
	medal3:setScale(40/medalW, 40/medalH)
	medal3:setPosition(x0 + 2*xgap, y0)
	self:addChild(medal3)
	
	if stagelv > 4 then
		medal4 = Bitmap.new(medalTex1)
	else
		medal4 = Bitmap.new(medalTex0)
	end
	medal4:setScale(1,1)
	medal4:setAnchorPoint(0.5,0.5)
	medal4:setScale(40/medalW, 40/medalH)
	medal4:setPosition(x0 + 3*xgap, y0)
	self:addChild(medal4)
	
	if stagelv > 5 then
		medal5 = Bitmap.new(trophyTex1)
	else
		medal5 = Bitmap.new(trophyTex0)
	end
	medal5:setScale(1,1)
	medal5:setAnchorPoint(0.5,0.5)
	medal5:setScale(50/trophyW, 60/trophyH)
	medal5:setPosition(x0 + 4*xgap, y0)
	self:addChild(medal5)
	
	local function updateWorldData()
		self:removeChild(worldImg)
		worldImg = Bitmap.new(Texture.new(Worlds[wi]["Img"], true))
		worldImg:setScale(1,1)
		worldImg:setAnchorPoint(0.5,0.5)
		local worldImgW = worldImg:getWidth()
		local worldImgH = worldImg:getHeight()
		worldImg:setScale(240/worldImgW)
		self:addChild(worldImg)
		worldImg:setPosition(WX0/2, WY/2)
		
		self:removeChild(medal1)
		self:removeChild(medal2)
		self:removeChild(medal3)
		self:removeChild(medal4)
		self:removeChild(medal5)
		if wi < tonumber(careerTable["World"]) then
			medal1 = Bitmap.new(medalTex1)
			medal1:setScale(1,1)
			medal1:setAnchorPoint(0.5,0.5)
			medal1:setScale(40/medalW, 40/medalH)
			medal1:setPosition(x0, y0)
			self:addChild(medal1)
			
			medal2 = Bitmap.new(medalTex1)
			medal2:setScale(1,1)
			medal2:setAnchorPoint(0.5,0.5)
			medal2:setScale(40/medalW, 40/medalH)
			medal2:setPosition(x0 + xgap, y0)
			self:addChild(medal2)
			
			medal3 = Bitmap.new(medalTex1)
			medal3:setScale(1,1)
			medal3:setAnchorPoint(0.5,0.5)
			medal3:setScale(40/medalW, 40/medalH)
			medal3:setPosition(x0 + 2*xgap, y0)
			self:addChild(medal3)
			
			medal4 = Bitmap.new(medalTex1)
			medal4:setScale(1,1)
			medal4:setAnchorPoint(0.5,0.5)
			medal4:setScale(40/medalW, 40/medalH)
			medal4:setPosition(x0 + 3*xgap, y0)
			self:addChild(medal4)
			
			medal5 = Bitmap.new(trophyTex1)
			medal5:setScale(1,1)
			medal5:setAnchorPoint(0.5,0.5)
			medal5:setScale(50/trophyW, 60/trophyH)
			medal5:setPosition(x0 + 4*xgap, y0)
			self:addChild(medal5)
		elseif wi == tonumber(careerTable["World"]) then
			if stagelv > 1 then
				medal1 = Bitmap.new(medalTex1)
			else
				medal1 = Bitmap.new(medalTex0)
			end
			medal1:setScale(1,1)
			medal1:setAnchorPoint(0.5,0.5)
			medal1:setScale(40/medalW, 40/medalH)
			medal1:setPosition(x0, y0)
			self:addChild(medal1)
			
			if stagelv > 2 then
				medal2 = Bitmap.new(medalTex1)
			else
				medal2 = Bitmap.new(medalTex0)
			end
			medal2:setScale(1,1)
			medal2:setAnchorPoint(0.5,0.5)
			medal2:setScale(40/medalW, 40/medalH)
			medal2:setPosition(x0 + xgap, y0)
			self:addChild(medal2)
			
			if stagelv > 3 then
				medal3 = Bitmap.new(medalTex1)
			else
				medal3 = Bitmap.new(medalTex0)
			end
			medal3:setScale(1,1)
			medal3:setAnchorPoint(0.5,0.5)
			medal3:setScale(40/medalW, 40/medalH)
			medal3:setPosition(x0 + 2*xgap, y0)
			self:addChild(medal3)
			
			if stagelv > 4 then
				medal4 = Bitmap.new(medalTex1)
			else
				medal4 = Bitmap.new(medalTex0)
			end
			medal4:setScale(1,1)
			medal4:setAnchorPoint(0.5,0.5)
			medal4:setScale(40/medalW, 40/medalH)
			medal4:setPosition(x0 + 3*xgap, y0)
			self:addChild(medal4)
			
			if stagelv > 5 then
				medal5 = Bitmap.new(trophyTex1)
			else
				medal5 = Bitmap.new(trophyTex0)
			end
			medal5:setScale(1,1)
			medal5:setAnchorPoint(0.5,0.5)
			medal5:setScale(50/trophyW, 60/trophyH)
			medal5:setPosition(x0 + 4*xgap, y0)
			self:addChild(medal5)
		else
			medal1 = Bitmap.new(medalTex0)
			medal1:setScale(1,1)
			medal1:setAnchorPoint(0.5,0.5)
			medal1:setScale(40/medalW, 40/medalH)
			medal1:setPosition(x0, y0)
			self:addChild(medal1)
			
			medal2 = Bitmap.new(medalTex0)
			medal2:setScale(1,1)
			medal2:setAnchorPoint(0.5,0.5)
			medal2:setScale(40/medalW, 40/medalH)
			medal2:setPosition(x0 + xgap, y0)
			self:addChild(medal2)
			
			medal3 = Bitmap.new(medalTex0)
			medal3:setScale(1,1)
			medal3:setAnchorPoint(0.5,0.5)
			medal3:setScale(40/medalW, 40/medalH)
			medal3:setPosition(x0 + 2*xgap, y0)
			self:addChild(medal3)
			
			medal4 = Bitmap.new(medalTex0)
			medal4:setScale(1,1)
			medal4:setAnchorPoint(0.5,0.5)
			medal4:setScale(40/medalW, 40/medalH)
			medal4:setPosition(x0 + 3*xgap, y0)
			self:addChild(medal4)
			
			medal5 = Bitmap.new(trophyTex0)
			medal5:setScale(1,1)
			medal5:setAnchorPoint(0.5,0.5)
			medal5:setScale(50/trophyW, 60/trophyH)
			medal5:setPosition(x0 + 4*xgap, y0)
			self:addChild(medal5)
		end
		
		self:removeChild(WorldTextBox)
		WorldTextBox = TextField.new(self.font, "World "..tostring(wi)..": \n"..Worlds[wi]["Name"])
		WorldTextBox:setTextColor(0xffffff)
		WorldTextBox:setPosition(WX0/2 - WorldTextBox:getWidth()/2, 50)
		self:addChild(WorldTextBox)
		
		self:removeChild(InfoTextBox)
		InfoTextBox = TextWrap.new(Worlds[wi]["Info"], 380, "center", 7, self.smallfont)
		InfoTextBox:setTextColor(0xffffff)
		InfoTextBox:setPosition(WX0/2 - InfoTextBox:getWidth()/2, WY - InfoTextBox:getHeight())
		self:addChild(InfoTextBox)
	end
	
	self.prevBut = MenuBut.new(40, 40, textures.backBut, textures.backBut1)
	self:addChild(self.prevBut)
	self.prevBut.bitmap:setPosition(32, WY/2)
	self.prevBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.prevBut:hitTestPoint(event.touch.x, event.touch.y) then
			wi = wi - 1
			--if wi < 1 then wi = tablelength(Worlds) end -- Unlock all
			if wi < 1 then wi = tonumber(careerTable["World"]) end -- Normal Lock
			
			updateWorldData()
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	self.nextBut = MenuBut.new(40, 40, textures.forwardBut, textures.forwardBut1)
	self:addChild(self.nextBut)
	self.nextBut.bitmap:setPosition(WX0 - 32, WY/2)
	self.nextBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.nextBut:hitTestPoint(event.touch.x, event.touch.y) then
			wi = wi + 1
			--if wi > tablelength(Worlds) then wi = 1 end -- Unlock all
			if wi > tonumber(careerTable["World"]) then wi = 1 end -- Normal lock
			
			updateWorldData()
			
			if optionsTable["SFX"] == "On" then sounds.sel1:play() end
		end
	end)
	
	-- Go or return --
	self.goBut = MenuBut.new(192, 40, textures.goBut, textures.goBut1)
	self:addChild(self.goBut)
	self.goBut.bitmap:setPosition(WX0 - self.goBut:getWidth()/2 - 10, WY/2 + 210)
	self.goBut:addEventListener(Event.TOUCHES_END, function(event)
		if self.goBut:hitTestPoint(event.touch.x, event.touch.y) then
			if optionsTable["SFX"] == "On" then sounds.sel2:play() end
			sceneMan:changeScene("arenaCareer", transTime, SceneManager.fade, easing.linear, { userData = {tonumber(careerTable["World"]), tonumber(careerTable["Stage"]), "new"} })
		end
	end)
	
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
			sceneMan:changeScene("careerStats", transTime, SceneManager.fade, easing.linear) 
		end
	end)
	
	-- Listen to Keys --
	self:addEventListener(Event.KEY_DOWN, onKeyDown)
end