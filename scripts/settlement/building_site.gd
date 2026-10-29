@tool
class_name BuildingSite
extends Node2D
## One building site of the settlement. Place it in the settlement scene and
## move it in the editor: its position is the only world position. The three
## children (PlaceSprite, Building, BuildButton) are positioned and scaled
## locally, also in the editor. This script never changes their transforms.
##
## The site origin is the ground point shared by place image and building.
## Layout: PlaceSprite  - image of the empty site (bottom centre at the origin),
##                        visible until built.
##         Building     - origin is the ground point (bottom centre of the
##                        building image); holds the sprite, click area and
##                        notification badge. Visible once built.
##         BuildButton  - circular construction button, visible until built.
##
## @tool lets the editor show the right images and warnings while editing.

signal build_requested(site: BuildingSite)
signal building_pressed(site: BuildingSite)

## Draw layers, bottom to top. They are absolute (not relative to the parent),
## so a building on one site is never drawn under another site's place image.
const PLACE_LAYER_Z := 100
const BUILDING_LAYER_Z := 200
const BUTTON_LAYER_Z := 300

## Unique ID of this site, used by SettlementState.
@export var site_id: StringName:
	set(value):
		site_id = value
		update_configuration_warnings()

## The building type that is built on this site. Supplies the images, texts and
## the building screen.
@export var definition: BuildingDefinition:
	set(value):
		definition = value
		update_configuration_warnings()
		_refresh()

## Draw order among sites within each layer (higher is drawn on top).
@export_range(0, 99) var draw_order: int = 0:
	set(value):
		draw_order = value
		_refresh()

## Editor only: show the constructed building instead of the empty site.
## Has no effect in the running game.
@export var preview_built: bool = false:
	set(value):
		preview_built = value
		_refresh()

@onready var _place_sprite: Sprite2D = $PlaceSprite
@onready var _building: Node2D = $Building
@onready var _building_sprite: Sprite2D = $Building/Sprite
@onready var _click_area: Button = $Building/ClickArea
@onready var _notification_indicator: Control = $Building/NotificationIndicator
@onready var _build_button: Button = $BuildButton

var _building_state: BuildingState


func _ready() -> void:
	_refresh()
	if Engine.is_editor_hint():
		return
	_build_button.pressed.connect(func() -> void: build_requested.emit(self))
	_click_area.pressed.connect(func() -> void: building_pressed.emit(self))


## Shows the constructed building. Used when it is built and when the settlement
## scene is rebuilt from the session state.
func show_building(building: BuildingState) -> void:
	_building_state = building
	building.notification_changed.connect(_on_notification_changed)
	_on_notification_changed(building.has_notification)
	_refresh()


## Empty string if the site is correctly configured, otherwise a description of
## the problem.
func get_configuration_problem() -> String:
	if site_id == &"":
		return "site_id is empty."
	if definition == null:
		return "definition is not set."
	if definition.model == null or definition.scene == null:
		return "definition '%s' needs a model and a scene." % definition.id
	return ""


func _get_configuration_warnings() -> PackedStringArray:
	var problem := get_configuration_problem()
	return PackedStringArray([problem]) if problem != "" else PackedStringArray()


func _refresh() -> void:
	if not is_node_ready():
		return
	var is_built := _building_state != null or (Engine.is_editor_hint() and preview_built)
	_place_sprite.visible = not is_built
	_build_button.visible = not is_built
	_building.visible = is_built

	_place_sprite.z_index = PLACE_LAYER_Z + draw_order
	_building.z_index = BUILDING_LAYER_Z + draw_order
	_build_button.z_index = BUTTON_LAYER_Z

	_apply_place_image()
	_apply_building_image()


## Anchors the place image at its bottom centre, the same ground point the
## building uses, so the site origin is the shared ground point.
func _apply_place_image() -> void:
	var texture: Texture2D = definition.place_model if definition != null else null
	_place_sprite.texture = texture
	if texture != null:
		var size := texture.get_size()
		_place_sprite.offset = Vector2(-size.x / 2.0, -size.y)


## Fits the building image to the ground point and sizes the click area. Only
## sprite offset and click rectangle change; node transforms stay as authored.
func _apply_building_image() -> void:
	var texture: Texture2D = definition.model if definition != null else null
	_building_sprite.texture = texture
	if texture == null:
		return
	var texture_size := texture.get_size()
	_building_sprite.offset = Vector2(-texture_size.x / 2.0, -texture_size.y)
	# The sprite's local position is authored in the editor, so the click area
	# and badge follow it instead of assuming the sprite sits at the origin.
	_click_area.position = _building_sprite.position + _building_sprite.offset
	_click_area.size = texture_size
	_notification_indicator.position = _building_sprite.position + Vector2(
		-_notification_indicator.size.x / 2.0,
		-texture_size.y - _notification_indicator.size.y,
	)


func _on_notification_changed(has_notification: bool) -> void:
	_notification_indicator.visible = has_notification
