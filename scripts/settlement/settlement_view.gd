class_name SettlementView
extends Control
## The settlement screen. The sites are BuildingSite scenes placed by hand
## under World/Sites; this script only connects them to the session state, so
## it can be freshly instantiated (for example when returning from a building
## screen) and still show every building constructed during the session.
##
## Visual layers, bottom to top: background, site images, buildings, construction
## buttons (see BuildingSite). Dialogs live in a CanvasLayer above all.

## Everything inside World uses background pixel coordinates; World itself is
## scaled to fit the available area while keeping the background's aspect ratio.
@onready var _world: Node2D = %World
@onready var _background: Sprite2D = %Background
@onready var _sites_root: Node2D = %Sites
@onready var _confirm_dialog: ConstructionConfirmDialog = %ConstructionConfirmDialog
@onready var _construction_controller: ConstructionController = %ConstructionController

var _settlement: SettlementState
var _sites: Dictionary[StringName, BuildingSite] = {}


func _ready() -> void:
	_settlement = _get_settlement()
	_register_sites()
	_construction_controller.setup(_settlement, _confirm_dialog)
	_settlement.building_constructed.connect(_on_building_constructed)
	for building in _settlement.get_buildings():
		_on_building_constructed(building)
	resized.connect(_fit_world)
	_fit_world()


func _get_settlement() -> SettlementState:
	# Normally the session is created by "Create Game". This fallback only
	# matters when the scene is run on its own from the editor.
	if not SessionManager.has_active_session():
		SessionManager.start_new_session()
	return SessionManager.current_session.settlement


## Registers every valid site with the state. Sites with a configuration
## problem or a duplicate ID are reported and disabled.
func _register_sites() -> void:
	for child in _sites_root.get_children():
		var site := child as BuildingSite
		if site == null:
			continue
		var problem := site.get_configuration_problem()
		if problem == "" and _sites.has(site.site_id):
			problem = "duplicate site_id '%s'." % site.site_id
		if problem != "":
			push_error("SettlementView: site '%s' disabled: %s" % [site.name, problem])
			site.visible = false
			continue
		_settlement.ensure_site(site.site_id)
		_sites[site.site_id] = site
		site.build_requested.connect(_construction_controller.begin_construction)
		site.building_pressed.connect(_on_building_pressed)


func _on_building_constructed(building: BuildingState) -> void:
	var site: BuildingSite = _sites.get(building.site_id)
	if site == null:
		push_error("SettlementView: no site for building '%s'." % building.building_id)
		return
	site.show_building(building)


func _on_building_pressed(site: BuildingSite) -> void:
	SceneRouter.go_to_packed(site.definition.scene)


func _fit_world() -> void:
	var background_size := _background.texture.get_size()
	var fit_scale := minf(size.x / background_size.x, size.y / background_size.y)
	_world.scale = Vector2.ONE * fit_scale
	_world.position = (size - background_size * fit_scale) / 2.0
