----begin_license--
--
--Copyright 	2013 	Søren Vissing Jørgensen.
--			2014	Søren Vissing Jørgensen, Center for Bio-Robotics, SDU, MMMI.  
--
--This file is part of RANA.
--
--RANA is free software: you can redistribute it and/or modify
--it under the terms of the GNU General Public License as published by
--the Free Software Foundation, either version 3 of the License, or
--(at your option) any later version.
--
--RANA is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.
--
--You should have received a copy of the GNU General Public License
--along with RANA.  If not, see <http://www.gnu.org/licenses/>.
--
----end_license--
posX = 0
posY = 0
ID = 0
macroF = 0
timeRes = 0


-- Init of the lua frog, function called upon initilization of the LUA auton:
function initAuton(x, y, id, macroFactor, timeResolution)

	posX = x
	posY = y
	ID = id
	macroF = macroFactor
	timeRes = timeResolution

	l_debug("Agent #: " .. id .. " has been initialized")

end

-- Event Handling:
function handleEvent(origX, origY, origID, origDesc, origTable)
	--make a response:

	return 0,0,0,"null"
end	

--Determine whether or not this Auton will initiate an event.
function initiateEvent()

	newPosX = l_getMersenneInteger(0,200)
	newPosY = l_getMersenneInteger(0,200)

	l_modifyMap(newPosX, newPosY,0,0,l_getMersenneInteger(150,255))
	r,g,b = l_checkMap(newPosX, newPosY)

	--l_debug("color "..r..","..g..","..b)
	if l_getMersenneInteger(1,100) <= 5 then
		calltable = {name = "communication", index = 2, arg1 = callStrength}
		s_calltable = serializeTbl(calltable) 
		desc = "sound"
		id = l_generateEventID()
		propagationSpeed = 50000

		targetID = 0;

		--l_gridMove(posX, posY, newPosX, newPosY)
		--posX = newPosX
		--posY = newPosY

		return propagationSpeed, s_calltable, desc, targetID
	end

	return 0,0,0,"null"
end


function getSyncData()
	return posX, posY
end

function simDone()
	l_debug("Agent #: " .. ID .. " is done\n")
end


	function serializeTbl(val, name, depth)
		--skipnewlines = skipnewlines or false
		depth = depth or 0
		local tbl = string.rep("", depth)
		if name then
			if type(name)=="number" then
				namestr = "["..name.."]"
				tbl= tbl..namestr.."="
			elseif name then 
				tbl = tbl ..name.."="
				--else tbl = tbl .. "systbl="
			end	
		end
		if type(val) == "table" then
			tbl = tbl .. "{"
			local i = 1
			for k, v in pairs(val) do
				if i ~= 1 then
					tbl = tbl .. ","
				end	
				tbl = tbl .. serializeTbl(v,k, depth +1) 
				i = i + 1;
			end
			tbl = tbl .. string.rep(" ", depth) ..  "}"
		elseif type(val) == "number" then
			tbl = tbl .. tostring(val) 
		elseif type(val) == "string" then
			tbl = tbl .. string.format("%q", val)
		else
			tbl = tbl .. "[datatype not serializable:".. type(val) .. "]"
		end

		return tbl
	end