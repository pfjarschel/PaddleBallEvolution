-----------------------------
-- Class for Loading Fonts --
-----------------------------

FontLoader = Core.class()

-- Load fonts and assign members --
function FontLoader:init()
	self.tahomaBig = TTFont.new("Fonts/tahoma.ttf", 50)
	self.tahomaMed = TTFont.new("Fonts/tahoma.ttf", 40)
	self.tahomaSmall = TTFont.new("Fonts/tahoma.ttf", 30)
	self.arialroundedBig = TTFont.new("Fonts/arial-rounded.ttf", 50)
	self.arialroundedMed = TTFont.new("Fonts/arial-rounded.ttf", 40)
	self.arialroundedSmall = TTFont.new("Fonts/arial-rounded.ttf", 30)
end

