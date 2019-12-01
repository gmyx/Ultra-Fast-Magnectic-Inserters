
function IsUFInserters(entity)
	return entity.name == "ultra-fast-filter-inserter" or
		entity.name == "ultra-fast-inserter" or
		entity.name == "ultra-fast-long-filter-inserter" or
		entity.name == "ultra-fast-long-inserter" or
		entity.name == "ultra-fast-configurable-inserter" or
		entity.name == "ultra-fast-configurable-filter-inserter"
end

function toDropoffLane(value)
	--convert a value to a lane, using absolute values
	return math.abs(math.floor((value - 0.2) * 2)+1) --off by one for some reason
end

function toDropoffPostion(value, positive)
	--convert a lane value to a position value
	--math is simple - lane /2 + 0.2 
	--using floor on lane to get right value
	return math.floor(value) / 2 + 0.2	
end

function toPickupLane(value)
	--convert a value to a lane, using absolute values
	return math.abs(value) * 2
end

function toPickupPostion(value, positive)
	--convert a lane value to a position value
	return math.ceil(math.floor(value)/2)
end

function printToScreen(log, player_index)
	if DEBUG == true then
		game.get_player(player_index).print(log)	
	end
end

function getStackOverrideDefault(player_index)
	return game.players[player_index].force.stack_inserter_capacity_bonus
end

function getStackOverrideCurrentValue(entity, player_index)
	if entity.inserter_stack_size_override > 0 then
		return entity.inserter_stack_size_override
	else
		return getStackOverrideDefault(player_index) + 1
	end
end

function validateNumber(element, player_index)
	if element == nil then return end --fail safe
	local oValue = element.text
	printToScreen("testing value: " .. oValue ,player_index)
	value = tonumber(oValue) --convert to number for the rest of the function
	if value ~= nil then
		--is a number, good start, chekc for int
		if value == math.floor(value) then
			--yup, its an int, final check, between 1 and max
			if value > 0 and value <= getStackOverrideDefault(player_index) + 1 then
				--valid!
				if element then element.style = "number_input_textbox" end
				return true
			else
				--out of range!!!
				printToScreen("out of range: " .. value ,player_index)
				if element then element.style = "invalid_value_textfield" end
				return false
			end
		else
			--bad! not a integer
			printToScreen("not an int: " .. value ,player_index)
			if element then element.style = "invalid_value_textfield" end
			return false
		end
	else
		--bad! not a number
		printToScreen("not a number: " .. oValue ,player_index)
		if element then element.style = "invalid_value_textfield" end
		return false
	end
end