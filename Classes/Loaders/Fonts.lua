-----------------------------
-- Class for Loading Fonts --
-----------------------------

FontLoader = Core.class()

-- Load fonts and assign members --
function FontLoader:init()
	self.tahomaBig = TTFont.new("fonts/tahoma.ttf", 50)
	self.tahomaMed = TTFont.new("fonts/tahoma.ttf", 40)
	self.tahomaSmall = TTFont.new("fonts/tahoma.ttf", 30)
	self.tahomaVerySmall = TTFont.new("fonts/tahoma.ttf", 15)
	
	self.arialroundedBig = TTFont.new("fonts/arial-rounded.ttf", 50)
	self.arialroundedMed = TTFont.new("fonts/arial-rounded.ttf", 40)
	self.arialroundedSmall = TTFont.new("fonts/arial-rounded.ttf", 30)
	self.arialroundedVerySmall = TTFont.new("fonts/arial-rounded.ttf", 15)
	
	self.anitaBig = TTFont.new("fonts/anita.ttf", 48)
	self.anitaMed = TTFont.new("fonts/anita.ttf", 35)
	self.anitaSmall = TTFont.new("fonts/anita.ttf", 25)
	self.anitaSmaller = TTFont.new("fonts/anita.ttf", 20)
	self.anitaVerySmall = TTFont.new("fonts/anita.ttf", 15)
	
end

