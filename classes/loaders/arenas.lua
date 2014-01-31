-------------------------------------
-- Table Containing Special Arenas --
-------------------------------------


-- Normal --
arenasTable["Normal"] = {}
arenasTable["Normal"]["Desc"] = "The normal PaddleBall Arena. No Special Effects"
arenasTable["Normal"]["Image"] = "none"
arenasTable["Normal"]["Init"] = function()
	print("normal")
end
arenasTable["Normal"]["End"] = function()
	print("normal end!")
end


-- Lava --
arenasTable["Lava"] = {}
arenasTable["Lava"]["Desc"] = "Paddles can randomly melt (get smaller)"
arenasTable["Lava"]["Image"] = "imgs/backs/arenas/lava.png"
arenasTable["Lava"]["Init"] = function()
	print("lava")
end
arenasTable["Lava"]["End"] = function()
	print("lava end!")
end

-- Ice --
arenasTable["Ice"] = {}
arenasTable["Ice"]["Desc"] = "Paddles can randomly freeze"
arenasTable["Ice"]["Image"] = "imgs/backs/arenas/ice.png"
arenasTable["Ice"]["Init"] = function()
	print("Ice")
end
arenasTable["Ice"]["End"] = function()
	print("Ice end!")
end