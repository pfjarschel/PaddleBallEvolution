-----------------------------------------------------------
-- Basic Initialization and General Function Definitions --
-----------------------------------------------------------

-- Collect Lots of Garbage --
function gc()
	collectgarbage()
	collectgarbage()
	collectgarbage()
	collectgarbage()
	collectgarbage()
end

-- Read Lines from a File into an Array --
function file_exists(file)
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end
function lines_from(file)
	if not file_exists(file) then return {} end
	local lines = {}
	for line in io.lines(file) do 
		lines[#lines + 1] = line
	end
	return lines
end

-- Get number of elements in a table --
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

-- Lua Random Seed Fix --
--math.randomseed(os.time())
math.randomseed(socket.gettime()*1000)
math.random(1)

-- Etc --
print("Init-ing...")
application:setBackgroundColor(0x000000)
classTable = {}
skillTable = {}
optionsTable = {}
tourTable = {}
customClass = {}
arenasTable = {}
careerTable = {}
Worlds = {}