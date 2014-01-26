-----------------------------
-- Class for Loading Fonts --
-----------------------------

FontLoader = Core.class()

-- Load fonts and assign members --
function FontLoader:init()
	self.anitaBig = TTFont.new("fonts/anita.ttf", 48)
	self.anitaMed = TTFont.new("fonts/anita.ttf", 35)
	self.anitaSmall = TTFont.new("fonts/anita.ttf", 25)
	self.anitaSmaller = TTFont.new("fonts/anita.ttf", 20)
	self.anitaVerySmall = TTFont.new("fonts/anita.ttf", 15)
end

