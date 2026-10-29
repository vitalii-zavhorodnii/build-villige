class_name SettlementState
extends RefCounted
## Runtime state of the settlement: its construction sites and the buildings on
## them. Owned by GameSession, so it lives exactly as long as the session and
## survives scene changes (for example visiting a building screen).

signal building_constructed(building: BuildingState)

var _sites: Dictionary[StringName, ConstructionSiteState] = {}
var _buildings: Dictionary[StringName, BuildingState] = {}
var _next_building_number: int = 1


## Declares a site that exists in the settlement scene. Safe to call again each
## time the scene is loaded; an already known site keeps its state.
func ensure_site(site_id: StringName) -> void:
	if not _sites.has(site_id):
		_sites[site_id] = ConstructionSiteState.new(site_id)


func has_site(site_id: StringName) -> bool:
	return _sites.has(site_id)


func is_site_available(site_id: StringName) -> bool:
	return _sites.has(site_id) and _sites[site_id].is_available()


func get_buildings() -> Array[BuildingState]:
	return _buildings.values()


func get_building(building_id: StringName) -> BuildingState:
	return _buildings.get(building_id)


## Places a new building on a free site. Returns null if the site is unknown or
## already occupied. The caller is responsible for validating definition_id.
func construct_building(site_id: StringName, definition_id: StringName) -> BuildingState:
	if not is_site_available(site_id):
		return null
	var building := BuildingState.new(_create_building_id(), definition_id, site_id)
	_buildings[building.building_id] = building
	_sites[site_id].building_id = building.building_id
	building_constructed.emit(building)
	return building


func _create_building_id() -> StringName:
	var building_id := StringName("building_%02d" % _next_building_number)
	_next_building_number += 1
	return building_id
