class_name ConstructionSiteState
extends RefCounted
## Runtime state of one predefined construction site.

var site_id: StringName
## ID of the building standing on this site, or empty while the site is free.
var building_id: StringName = &""


func _init(new_site_id: StringName) -> void:
	site_id = new_site_id


func is_available() -> bool:
	return building_id == &""
