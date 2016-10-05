
local 10_forage = {}

local search_radius = 0
local move_radius = 0

local grass 		= {R=0,G=255,B=0}
local background 	= {R=0,G=0,B=0}

--state descriptors
local state_search	= "searching"
local state_eat 	= "eating"
local state = state_search

local _Configure

--state functions
local _Search
local _Eat

function 10_forage.forage()

	if not Moving then
		
		if state == state_search then
			_Search()
		if state == state_eat then
			_Eat()
		end
	end
end

function configure(configuration)

	search_radius = configuration.search_radius
	move_radius = configuration.search_move_radius

end

_Search = function()

	local table = Map.radialScanMap(forage_scan_radius)

	local start_index = l_getRandomInteger(1, #table)

	for i = 0, #table-1 do
		
		local index = (start_index+i) % #table + 1
		  
		local r = table[index].R
		local g = table[index].G
		local b = table[index].B

		if _CompareColor({r,g,b}, grass) then

			DestinationX = table[index].posX
			DestinationY = table[index].posY
			Moving = true
			
			--set a new state and return
			state = state_eat
			return
		end		

	end
	--if no grass is found search a new area
	DestinationX = l_getRandomInteger(-move_radius, move_radius)
	DestinationY = l_getRandomInteger(-move_radius, move_radius)
	Moving = true

end

_Eat = function()

	if Map.quantumModify(PositionX, PositionY, grass, background ) then

		Energy = Energy + 1
	end

	state = state_search

end



_CompareColor = function(color1, color2)
	
	if color1.R == color2.R and color1.G == color2.G and color1.B == color2.B then

		return true

	end

	return false

end


return 10_forage
