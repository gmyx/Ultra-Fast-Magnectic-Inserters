--control the configurable inserter
DEBUG = false
require("control.common") 
require("control.UFCI") 

script.on_init(function()
		RegisterEvents()
end)

script.on_load(function()
		RegisterEvents()
end)

function RegisterEvents()
	script.on_event(defines.events.on_gui_opened, UFCI.OnGuiOpened)	
	script.on_event(defines.events.on_gui_closed, UFCI.OnGuiClosed)
	script.on_event(defines.events.on_gui_value_changed, UFCI.OnGuiValueChanged)	
	script.on_event(defines.events.on_player_mined_entity, UFCI.OnDestroyedEntity)
	script.on_event(defines.events.on_robot_mined_entity, UFCI.OnDestroyedEntity)
	script.on_event(defines.events.on_pre_ghost_deconstructed, UFCI.OnDestroyedEntity)
	script.on_event(defines.events.on_entity_died, UFCI.OnDestroyedEntity)	
end