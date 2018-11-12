----begin_license--
--
--Copyright 	2013 - 2016 	Søren Vissing Jørgensen.
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

--The following global values are set via the simulation core:
-- ------------------------------------
-- IMMUTABLES.
-- ------------------------------------
-- ID -- id of the agent.
-- STEP_RESOLUTION 	-- resolution of steps, in the simulation core.
-- EVENT_RESOLUTION	-- resolution of event distribution.
-- ENV_WIDTH -- Width of the environment in meters.
-- ENV_HEIGHT -- Height of the environment in meters.
-- ------------------------------------
-- VARIABLES.
-- ------------------------------------
-- PositionX	 	-- Agents position in the X plane.
-- PositionY	 	-- Agents position in the Y plane.
-- DestinationX 	-- Agents destination in the X plane. 
-- DestinationY 	-- Agents destination in the Y plane.
-- StepMultiple 	-- Amount of steps to skip.
-- Speed 			-- Movement speed of the agent in meters pr. second.
-- Moving 			-- Denotes wether this agent is moving (default = false).
-- GridMove 		-- Is collision detection active (default = false).
-- ------------------------------------

-- Import valid Rana lua libraries.
Event = require "ranalib_event"
Shared = require "ranalib_shared"	
Stat = require "ranalib_statistic"
Move = require "ranalib_movement"
Core = require "ranalib_core"

starting = false
listenID = 0
count = 0

-- Init of the lua frog, function called upon initilization of the LUA auton.
function InitializeAgent()

	say("Agent #: " .. ID .. " has been initialized")

	if ID == 1 then
		PositionX = 50
		PositionY = 50
		listenID = 4
		starting = true
	elseif ID == 2 then
		PositionX = 150
		PositionY = 50
		listenID = 1
	elseif ID == 3 then
		PositionX = 150
		PositionY = 150
		listenID = 2
	elseif ID == 4 then
		PositionX = 50
		PositionY = 150
		listenID = 3
	end

end

function HandleEvent(event)

	if event.ID == listenID then

			Event.emit{speed=400}

			if ID == 1 then
				count = count + 1
				say("Time: "..Core.time().." , " ..count.."," ..listenID)
			end
	end

end

function takeStep()
	
	if starting == true then
		Event.emit{speed=400}
		say("Time: "..Core.time().." Count: " ..count)
		starting = false
	end

end

function cleanUp()
	l_debug("Agent #: " .. ID .. " is done\n")
end

