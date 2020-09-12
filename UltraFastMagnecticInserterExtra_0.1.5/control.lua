--control the configurable inserter
DEBUG = false
Event = require('__stdlib__/stdlib/event/event')

require("control.common")
require("control.commonGUI") 

--add the 2 custom inserters 
UFCI = commonGUI:new{
	entityName=		"ultra-fast-configurable-inserter", 
	boxCaption=		"Configurable inserter"}
UFCFI = commonGUI:new{
	entityName =	"ultra-fast-configurable-filter-inserter",
	hasFilter =		true, 
	boxCaption =	"Configurable Filter inserter"}

Event.register(Event.core_events.on_init, function()
		UFCI:RegisterEvents()
		UFCFI:RegisterEvents()
end)

Event.register(Event.core_events.on_load, function()
		UFCI:RegisterEvents()
		UFCFI:RegisterEvents()
end)