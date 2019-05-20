local gui = {}
UFCI = {}

function UFCI.OnGuiOpened(event)
	if event.entity and event.entity.name == "ultra-fast-configurable-inserter" then
		--see if gui is already opened, if yes, ignore
		if gui[event.player_index] == nil then
			game.players[event.player_index].opened = UFCI.openGUI(event.entity, event.player_index)
		else
			game.players[event.player_index].opened = gui[event.player_index].gui
		end
	end
end

function UFCI.OnGuiClosed(event)	
	if event.gui_type == defines.gui_type.custom then
		UFCI.closeGUI(event.player_index, false)	
	end
end

function UFCI.OnGuiValueChanged (event)
	if event.element.name == "CI_pickup" then
		UFCI.updatePickupLabel(event.player_index)
	elseif event.element.name == "CI_dropoff" then
		UFCI.updateDropoffLabel(event.player_index)
	end
end

function UFCI.OnDestroyedEntity(event)
	if event.entity and event.entity.name == "ultra-fast-configurable-inserter" then
		--see if a gui is opened or not
		if gui[event.player_index] ~= nil then
			--ensure entity is the same as any opened gui
			if event.entity == gui[event.player_index].inserter then
				--destroy the gui
				UFCI.closeGUI(event.player_index, true)
			end
		end
	end
end

function UFCI.openGUI(entity, player_index)
	local root = game.players[player_index].gui.center.add{type = "frame", name = "Configurable inserter", caption = "Configurable inserter", direction = "vertical"}
	printToScreen("pickup_position = " .. entity.pickup_position.y, player_index)
	printToScreen("drop_position = " .. entity.drop_position.y, player_index)
	printToScreen("pickup_position (offsetted) = " .. entity.pickup_position.y - entity.position.y, player_index)
	printToScreen("drop_position (offsetted) = " .. entity.drop_position.y - entity.position.y, player_index)
	printToScreen("orientation = " .. entity.orientation, player_index)

	--the value of pickup and dropoff depend on orientation 0 = down, .25 left, .5 up, .75 right	
	local pickup_position
	local dropoff_position
	if entity.orientation == 0 or entity.orientation == 0.5 then
		--pick up and drop off are Y cords, because we use ABS values, we only care about X and Y
		pickup_position = entity.pickup_position.y - entity.position.y
		dropoff_position = entity.drop_position.y - entity.position.y
	else
		--pick up and drop off are X cords
		pickup_position = entity.pickup_position.x - entity.position.x
		dropoff_position = entity.drop_position.x - entity.position.x
	end

	local flow1 = root.add{type="flow", name="CI_flow1", direction="horizontal"}
	flow1.add{type="label", name="CI_pickup_label", caption = "Pick-up lane"}
	flow1.add{type="slider", name="CI_pickup", minimum_value=1,maximum_value=10,value=toPickupLane(pickup_position)}
	flow1.add{type="label", name="CI_pickup_current", caption=toPickupLane(pickup_position) }

	local flow2 = root.add{type="flow", name="CI_flow2", direction="horizontal"}
	flow2.add{type="label", name="CI_dropoff_label", caption = "Dropoff lane"}
	flow2.add{type="slider", name="CI_dropoff", minimum_value=1,maximum_value=10,value=toDropoffLane(dropoff_position)}
	flow2.add{type="label", name="CI_dropoff_current", caption=toDropoffLane(dropoff_position) }
	
	gui[player_index] = {inserter = entity, gui = root}
	return root
end

function UFCI.closeGUI(player_index, canceled)
	if canceled == false and gui[player_index].inserter.valid then
		entity = gui[player_index].inserter

		--save GUI values
		local pickup_position = gui[player_index].gui.children[1].children[2].slider_value
		local drop_position = gui[player_index].gui.children[2].children[2].slider_value
		printToScreen(toPickupPostion(pickup_position) ,player_index)
		printToScreen(toDropoffPostion(drop_position) ,player_index)

		--set the value of pickup and dropoff depend on orientation 0 = down, .25 left, .5 up, .75 right	
		if entity.orientation == 0 then
			--set the pickup_position (it must be negative)
			entity.pickup_position = {x = entity.position.x; y= entity.position.y - toPickupPostion(pickup_position)}

			--set the drop drop_position		
			entity.drop_position = {x = entity.position.x; y =  entity.position.y + toDropoffPostion(drop_position)}
		elseif entity.orientation == 0.5 then
			--set the pickup_position 
			entity.pickup_position = {x = entity.position.x; y = entity.position.y + toPickupPostion(pickup_position)}

			--set the drop drop_position (it must be negative)		
			entity.drop_position = {x = entity.position.x; y = entity.position.y - toDropoffPostion(drop_position)}
		elseif entity.orientation == 0.75 then
			--set the pickup_position (it must be negative)
			entity.pickup_position = {x = entity.position.x - toPickupPostion(pickup_position); y= entity.position.y}

			--set the drop drop_position		
			entity.drop_position = {x = entity.position.x + toDropoffPostion(drop_position); y =  entity.position.y}
		elseif entity.orientation == 0.25 then
			--set the pickup_position 
			entity.pickup_position = {x = entity.position.x + toPickupPostion(pickup_position); y = entity.position.y}

			--set the drop drop_position (it must be negative)		
			entity.drop_position = {x = entity.position.x - toDropoffPostion(drop_position); y = entity.position.y}
		end
	end

	gui[player_index].gui.destroy()
	gui[player_index] = nil
end

function UFCI.updatePickupLabel(player_index)
	local value = math.floor(gui[player_index].gui.children[1].children[2].slider_value)

	-- ensure even	
	gui[player_index].gui.children[1].children[3].caption = value + (value % 2)
end

function UFCI.updateDropoffLabel(player_index)
	gui[player_index].gui.children[2].children[3].caption = math.floor(gui[player_index].gui.children[2].children[2].slider_value)
end