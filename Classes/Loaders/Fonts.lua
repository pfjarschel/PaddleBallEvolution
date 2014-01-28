-----------------------------
-- Class for Loading Fonts --
-----------------------------

FontLoader = Core.class()

-- Load fonts and assign members --
function FontLoader:init()
	self.anitaBig = TTFont.new("fonts/anita.ttf", 48, false)
	self.anitaMed = TTFont.new("fonts/anita.ttf", 35, false)
	self.anitaSmall = TTFont.new("fonts/anita.ttf", 25, false)
	self.anitaSmaller = TTFont.new("fonts/anita.ttf", 20, false)
	self.anitaVerySmall = TTFont.new("fonts/anita.ttf", 15, false)
end

