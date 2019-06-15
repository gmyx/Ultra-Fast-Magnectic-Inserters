commonGUI = {
	entityName = "",
	_gui = {},
	hasFilter = false,
	boxCaption = ""
}

function commonGUI:new(o)
	o = o or {}	
	setmetatable(o, self)
	self.__index = self
	return o
end

function commonGUI:RegisterEvents()		
	Event.register(defines.events.on_gui_opened, function(event) if self then self:OnGuiOpened(event) end end)
	Event.on_event(defines.events.on_gui_closed, function(event) if self then self:OnGuiClosed(event) end end)
	Event.register(defines.events.on_gui_value_changed, function(event) if self then self:OnGuiValueChanged(event) end end)
	Event.register(defines.events.on_gui_text_changed, function(event) if self then self:OnGuiValueChanged(event) end end)
	Event.register(defines.events.on_gui_checked_state_changed, function(event) if self then self:OnGuiValueChanged(event) end end)
	Event.register(defines.events.on_player_mined_entity, function(event) if self then self:OnDestroyedEntity(event) end end)
	Event.register(defines.events.on_robot_mined_entity, function(event) if self then self:OnDestroyedEntity(event) end end)
	Event.register(defines.events.on_pre_ghost_deconstructed, function(event) if self then self:OnDestroyedEntity(event) end end)
	Event.register(defines.events.on_entity_died, function(event) if self then self:OnDestroyedEntity(event) end end)

	-- version 0.1.1 stack override, if set
	Event.register(defines.events.on_built_entity, function(event) if self then self:SetOverride(event) end end)
end

function commonGUI:OnGuiOpened(event)	
	if event.entity and event.entity.name == self.entityName then
		--see if gui is already opened, if yes, ignore
		if self._gui[event.player_index] == nil then
			game.players[event.player_index].opened = self:openGUI(event.entity, event.player_index)
		else
			game.players[event.player_index].opened = self._gui[event.player_index].gui
		end
	end
end

function commonGUI:OnGuiClosed(event)	
	if event.gui_type == defines.gui_type.custom and event.element ~= nil and event.element.name == self.boxCaption  then
		self:closeGUI(event.player_index, false)	
	end
end

function commonGUI:OnGuiValueChanged (event)
	if event.element.name == "CI_pickup" then
		self:updatePickupLabel(event.player_index)
	elseif event.element.name == "CI_dropoff" then
		self:updateDropoffLabel(event.player_index)
	elseif event.element.name == "CI_override_value" then
		validateNumber(self._gui[event.player_index].gui["CI_override_flow"]["CI_override_value"], event.player_index)
	elseif event.element.name == "CI_override_state" then
		self:toggleBox(event.player_index)
	end
end

function commonGUI:OnDestroyedEntity(event)
	if event.entity and event.entity.name == self.entityName then
		--see if a gui is opened or not
		if self._gui[event.player_index] ~= nil then
			--ensure entity is the same as any opened gui
			if event.entity == self._gui[event.player_index].inserter then
				--destroy the gui
				self:closeGUI(event.player_index, true)
			end
		end
	end
end

function commonGUI:openGUI(entity, player_index)	
	local root = game.players[player_index].gui.center.add{type = "frame", name = self.boxCaption, caption = self.boxCaption, direction = "vertical"}
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

	local flow1 = root.add{type="flow", name="CI_pickup_flow", direction="horizontal"}
	flow1.add{type="label", name="CI_pickup_label", caption = "Pick-up lane"}
	flow1.add{type="slider", name="CI_pickup", minimum_value=1,maximum_value=10,value=toPickupLane(pickup_position)}
	flow1.add{type="label", name="CI_pickup_current", caption=toPickupLane(pickup_position)}

	local flow2 = root.add{type="flow", name="CI_dropoff_flow", direction="horizontal"}
	flow2.add{type="label", name="CI_dropoff_label", caption = "Dropoff lane"}
	flow2.add{type="slider", name="CI_dropoff", minimum_value=1,maximum_value=10,value=toDropoffLane(dropoff_position)}
	flow2.add{type="label", name="CI_dropoff_current", caption=toDropoffLane(dropoff_position)}
	
	--add filters here if _hasFilter == true
	if self.hasFilter == true then
		--2 extra flows required - a whitelist / blacklist radio and list of fitlers
		local flow4 = root.add{type="flow", name="CI_chooselist_flow", direction="horizontal"}
		flow4.add{type="label", name="CI_whitelist_label", caption = "Whitelist"}
		--switch element missing, using a checkbox for now
		printToScreen(entity.inserter_filter_mode, player_index)
		flow4.add{type="checkbox", name="CI_chooselist", state=(entity.inserter_filter_mode=="whitelist")}
		--flow4.add{type="label", name="CI_blacklist_label", caption = "Blacklist"}

		local flow5 = root.add{type="flow", name="CI_filters_flow", direction="horizontal"}
		for index=1, entity.filter_slot_count, 1 do
			--add an item choose slot
			flow5.add{type="choose-elem-button", name="CI_choose-elem"..index, elem_type="item", item=entity.get_filter(index)}			
		end	
	end

	local flow3 = root.add{type="flow", name="CI_override_flow", direction="horizontal"}
	flow3.add{type="checkbox", name="CI_override_state", state=(entity.inserter_stack_size_override > 0)}
	flow3.add{type="label", name="CI_override_label", caption = "Override Stack Size"}
	flow3.add{type="textfield", name="CI_override_value", text=getStackOverrideCurrentValue(entity,player_index), enabled=(entity.inserter_stack_size_override > 0)}
	flow3["CI_override_value"].style = "number_input_textbox"
	flow3["CI_override_value"].style.width=30

	printToScreen("LuaForce: " .. getStackOverrideDefault(player_index), player_index)

	self._gui[player_index] = {inserter = entity, gui = root}
	return root
end

function commonGUI:closeGUI(player_index, canceled)	
	if canceled == false and self._gui[player_index].inserter.valid then
		entity = self._gui[player_index].inserter

		--save GUI values
		local pickup_position = self._gui[player_index].gui["CI_pickup_flow"]["CI_pickup"].slider_value
		local drop_position = self._gui[player_index].gui["CI_dropoff_flow"]["CI_dropoff"].slider_value
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

		--set the filters, if a filters inserter
		printToScreen("hasFilter: " .. tostring(self.hasFilter), player_index)
		if self.hasFilter == true then
			printToScreen("whitelist state:" .. tostring(self._gui[player_index].gui["CI_chooselist_flow"]["CI_chooselist"].state), player_index)
			--if whitelist switch/checkbox
			if self._gui[player_index].gui["CI_chooselist_flow"]["CI_chooselist"].state == true then
				entity.inserter_filter_mode = "whitelist"
			else
				entity.inserter_filter_mode = "blacklist"
			end

			--set filters
			for index=1, entity.filter_slot_count, 1 do
				--add an item choose slot
				local filter = self._gui[player_index].gui["CI_filters_flow"]["CI_choose-elem"..index].elem_value				
				entity.set_filter(index, filter)
			end		
		end

		--set the Override		
		if self._gui[player_index].gui["CI_override_flow"]["CI_override_state"].state == true then
			--overriden, if valid, set to textvalue
			if validateNumber(self._gui[player_index].gui["CI_override_flow"]["CI_override_value"], player_index) == true then
				--valid number, change vlaue, else no change
				entity.inserter_stack_size_override = tonumber(self._gui[player_index].gui["CI_override_flow"]["CI_override_value"].text)
			end
		else
			--not overriden, set to 0
			entity.inserter_stack_size_override = 0
		end			
	end

	self._gui[player_index].gui.destroy()
	self._gui[player_index] = nil
end

function commonGUI:updatePickupLabel(player_index)
	local value = math.floor(self._gui[player_index].gui["CI_pickup_flow"]["CI_pickup"].slider_value)

	-- ensure even	
	self._gui[player_index].gui["CI_pickup_flow"]["CI_pickup_current"].caption = value + (value % 2)
end

function commonGUI:updateDropoffLabel(player_index)
	self._gui[player_index].gui["CI_dropoff_flow"]["CI_dropoff_current"].caption = math.floor(self._gui[player_index].gui["CI_dropoff_flow"]["CI_dropoff"].slider_value)
end

function  commonGUI:toggleBox(player_index)
	self._gui[player_index].gui["CI_override_flow"]["CI_override_value"].enabled = 
		self._gui[player_index].gui["CI_override_flow"]["CI_override_state"].state
end

function commonGUI:SetOverride(event)	
	if event.created_entity and IsUFInserters(event.created_entity) then
		--check entity at dropoff and pickup, override ONLY if both are belts
		local foundBeltAtPikcup = false
		local foundBeltAtDropoff = false
		local dropEntity = game.players[event.player_index].surface.find_entities({event.created_entity.drop_position, event.created_entity.drop_position})		
		for i,v in ipairs(dropEntity) do 
			printToScreen(i,event.player_index) 
			printToScreen("dropEntity: " .. v.name .. " of type " .. v.type ,event.player_index) 
			if v.type == "transport-belt" then
				foundBeltAtDropoff = true
			end
		end

		local pickupEntity = game.players[event.player_index].surface.find_entities({event.created_entity.pickup_position, event.created_entity.pickup_position})		
		for i,v in ipairs(pickupEntity) do 
			printToScreen(i,event.player_index) 
			printToScreen("pickupEntity: " ..v.name .. " of type " .. v.type ,event.player_index) 
			if v.type == "transport-belt" then
				foundBeltAtPikcup = true
			end
		end

		--chekc if setting is set	
		if foundBeltAtPikcup == true and foundBeltAtDropoff == true then	
			if settings.get_player_settings(game.players[event.player_index])["ufi-override-stack-size"].value == true then
				printToScreen("setting to 1" ,event.player_index)
				event.created_entity.inserter_stack_size_override = 
					tonumber(settings.get_player_settings(game.players[event.player_index])["ufi-override-stack-size-value"].value)
			end			
		end
	end
end