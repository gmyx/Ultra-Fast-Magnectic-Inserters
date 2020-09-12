# Ultra-Fast-Inserters (formely Ultra-Fast-Magnectic-Inserters)
A fork of https://mods.factorio.com/mod/UltraFastMagnecticInserter to add extra inserters
Please unsubscribe from the original to avoid conflicts.

Add 6 new inserters:
* Ultra Fast Stack inserters
* Ultra Fast Long Reach Stack inserters
* Ultra Fast Filter Stack inserters
* Ultra Fast Long Reach filter Stack inserters
* Ultra Fast Configurable inserters
* Ultra Fast Configurable filter inserters

Version 0.1 adds a new exprimental inserter:
* Ultra Fast configurable inserters
** UFCI allows to chose which lane to pick-up and dropoff items. pickup is always even due to only beign able to pickup from a whole belt.
* Removing the word Magnectic - gets the name a bit shorter

Version 0.1.1
* Change default to no stack, which makes the inserters faster - it doesn't have to wait for a stack
* Added settings to allow the user to control
* Ultra Fast configurable Filter inserter
* * Same as the configurable, but with filters

Version 0.1.2
* Bug Fix: Unhandled nil - not all closed events have an element (thanks to xPucTu4)
* Changed the behaviour of overriding to 1 to apply ONLY if both pickup and drop off are belts.

Version 0.1.3
* Bug Fix: Error in migration script if comming for original mod
* Seriously neerfed the power needed for the inserters
** When form 48MW to 267KW (double stack inserters) with a drain of 1000
** Configurable take more at 365kW with a drain of 2500

There are no animations which allows the inserters to work at a significant speed boost. A great companion to fast belts.

Balance may need be adjusted. These inserter use a lot of power. Some of the graphics are a little off but the difference is minor.