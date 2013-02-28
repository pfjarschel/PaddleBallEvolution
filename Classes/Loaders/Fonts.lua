-----------------------------
-- Class for Loading Fonts --
-----------------------------

FontLoader = Core.class()

-- Load fonts and assign members --
function FontLoader:init()
	self.tahomaBig = TTFont.new("fonts/tahoma.ttf", 50)
	self.tahomaMed = TTFont.new("fonts/tahoma.ttf", 40)
	self.tahomaSmall = TTFont.new("fonts/tahoma.ttf", 30)
	self.arialroundedBig = TTFont.new("fonts/arial-rounded.ttf", 50)
	self.arialroundedMed = TTFont.new("fonts/arial-rounded.ttf", 40)
	self.arialroundedSmall = TTFont.new("fonts/arial-rounded.ttf", 30)
end

