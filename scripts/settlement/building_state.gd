class_name BuildingState
extends RefCounted
## Runtime state of one constructed building.

signal notification_changed(has_notification: bool)

var building_id: StringName
var definition_id: StringName
var site_id: StringName

## True while the building has a message for the player.
var has_notification: bool = false:
	set(value):
		if has_notification == value:
			return
		has_notification = value
		notification_changed.emit(has_notification)


func _init(new_building_id: StringName, new_definition_id: StringName, new_site_id: StringName) -> void:
	building_id = new_building_id
	definition_id = new_definition_id
	site_id = new_site_id
