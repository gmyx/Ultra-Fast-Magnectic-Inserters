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